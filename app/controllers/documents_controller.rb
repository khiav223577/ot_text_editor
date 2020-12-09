class DocumentsController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :should_have_valid_ops, only: :update
  before_action :should_have_valid_revision, only: :update

  $operations = []
  $value = 'Hello, world!'

  def show
    @revision = $operations.size
    @text = $value
    respond_to do |format|
      format.html
    end
  end

  def update
    client_revision = @revision
    client_operation = OT::TextOperation.from_a(@ops)
    server_revision = $operations.size

    if server_revision > client_revision
      mission_operation = compose_all($operations[client_revision..server_revision])
      client_operation = OT::TextOperation.transform(mission_operation, client_operation)[1] # transform 時，比較早的操作參數要在前
    end

    $operations << client_operation
    $value = client_operation.apply($value)

    ActionCable.server.broadcast(
      'document_channel',
      revision: server_revision + 1,
      ops: client_operation.ops
    )

    render json: {
      data: {
        revision: server_revision + 1,
        missing_ops: mission_operation&.ops,
      }
    }
  end

  def operation
    render json: {
      data: {
        ops: $operations[params[:revision].to_i]&.to_a,
      }
    }
  end

  private

  def should_have_valid_ops
    @ops = params[:ops]
    return render_error('invalid params') if not @ops.is_a?(Array)
    return render_error('invalid params') if @ops.empty?
  end

  def should_have_valid_revision
    @revision = params[:revision].to_i
    return render_error('invalid params') if @revision < 0
    return render_error('invalid params') if @revision > $operations.size
  end

  def render_error(*errors, status: :bad_request)
    render json: { errors: errors }, status: status
  end

  def compose_all(operations)
    operation = operations[0]
    operations[1..-1].each{|s| operation = operation.compose(s) }
    return operation
  end
end

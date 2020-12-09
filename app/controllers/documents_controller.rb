class DocumentsController < ActionController::Base
  skip_before_action :verify_authenticity_token

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
    return render_error('invalid params') if not params[:ops].is_a?(Array)
    return render_error('invalid params') if params[:ops].empty?

    client_revision = params[:revision].to_i
    client_operation = OT::TextOperation.from_a(params[:ops])
    server_revision = $operations.size

    if server_revision >= client_revision
      $operations[client_revision..server_revision].each do |other_operation|
        client_operation = OT::TextOperation.transform(client_operation, other_operation).first
      end
    end

    $operations << client_operation
    $value = client_operation.apply($value)

    render json: {
      data: {
        revision: server_revision + 1,
        ops: client_operation.to_a,
      }
    }
  end

  def operation
    render json: {
      data: {
        ops: $operations[params[:revision].to_i].to_a,
      }
    }
  end

  private

  def render_error(*errors, status: :bad_request)
    render json: { errors: errors }, status: status
  end
end

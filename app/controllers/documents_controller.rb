class DocumentsController < ActionController::Base
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
    client_revision = params[:revision]
    client_operation = OT::TextOperation.from_a(params[:operations])

    server_revision = $operations.size

    if server_revision >= client_revision
      $operations[(client_revision - 1)...server_revision].each do |other_operation|
        client_operation = OT::TextOperation.transform(client_operation, other_operation).first
      end
    end

    $operations << operation
    $value = operation.apply($value)

    render json: {
      data: {
        revision: server_revision,
        operations: operation.to_a,
      }
    }
  end
end

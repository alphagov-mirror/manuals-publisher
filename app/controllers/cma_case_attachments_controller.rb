class CmaCaseAttachmentsController < AbstractAttachmentsController
  def new
    document, attachment = services.new_cma_case_attachment(document_id).call

    render("attachments/new", locals: {
      document: view_adapter(document),
      attachment: attachment,
    })
  end

  def create
    document, attachment = services.create_cma_case_attachment(self, document_id).call

    redirect_to edit_cma_case_path(document)
  end

  def edit
    # TODO: action not tested
    document, attachment = services.show_cma_case_attachment(self, document_id).call

    render("attachments/edit", locals: {
      document: view_adapter(document),
      attachment: attachment,
    })
  end

  def update
    document, attachment = services.update_cma_case_attachment(self, document_id).call

    if attachment.persisted?
      redirect_to(edit_cma_case_path(document))
    else
      render("attachments/edit", locals: {
        document: view_adapter(document),
        attachment: attachment,
      })
    end
  end

protected
  def view_adapter(document)
    CmaCaseViewAdapter.new(document)
  end

  def document_id
    params.fetch("cma_case_id")
  end
end

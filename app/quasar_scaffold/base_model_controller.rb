class BaseModelController < ApplicationController
  def index
    responder = self.class::MODULE::IndexResponse.new(params, current_ability)

    respond_to do |format|
      format.json { render(responder.response) }
      format.xlsx do
        package = responder.ordered_records.to_xlsx
        header_style = {
          bg_color: '0000FF',
          fg_color: 'FF',
          alignment: { horizontal: :center },
          bold: true,
        }
        header_xf = package.workbook.styles.add_style header_style
        package.workbook.worksheets.first.tap do |sheet|
          sheet&.row_style(0, header_xf)
        end

        send_data(
          package.to_stream.read,
          type: 'application/xlsx',
        )
      end
      format.any { render(responder.response) }
    end
  end

  def create
    render(self.class::MODULE::CreateResponse.new(params, current_ability).response)
  end

  def edit
    render(self.class::MODULE::EditResponse.new(params, current_ability).response)
  end

  def show
    render(self.class::MODULE::ShowResponse.new(params, current_ability).response)
  end

  def update
    render(self.class::MODULE::UpdateResponse.new(params, current_ability).response)
  end

  def batch_update
    render(self.class::MODULE::BatchUpdateResponse.new(params, current_ability).response)
  end

  def destroy
    render(self.class::MODULE::DestroyResponse.new(params, current_ability).response)
  end

  def search
    render(self.class::MODULE::IndexResponse.new(params, current_ability).response)
  end

  def import
    render(self.class::MODULE::ImportResponse.new(params, current_ability).response)
  end

  def datatable_options
    render(self.class::MODULE::DatatableOptionsResponse.new(
      user: current_user,
      ability: current_ability
    ).response)
  end

  private

  def render_action
    yield

    head :ok, content_type: 'application/json'
  rescue StandardError => e
    render_error(e)
  end

  def render_action_result
    results = yield

    render(
      status: :ok,
      json: results,
      content_type: 'application/json'
    )
  rescue StandardError => e
    render_error(e)
  end

  def render_error(error)
    render(
      json: { errors: [error.message] },
      status:,
      content_type: 'application/json',
    )
  end
end

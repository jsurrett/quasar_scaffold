class BatchUpdateResponse
  extend Memoist
  include BaseResponse

  attr_reader :params, :current_ability

  def initialize(params, current_ability = {})
    @params = params
    @current_ability = current_ability
  end

  private

  def records
    model.accessible_by(current_ability).where(id: params[:ids])
  end
  memoize :records

  def execute
    records.update(permitted_attributes)
  rescue StandardError => e
    errors << e.message
  end

  def permitted_attributes
    params.require(:attributes).permit(model_columns)
  end

  def success_hash
    :ok
  end
end

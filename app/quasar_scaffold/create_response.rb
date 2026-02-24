class CreateResponse
  extend Memoist
  include BaseResponse

  attr_reader :params, :record, :current_ability

  def initialize(params, current_ability = {})
    @params = params
    @current_ability = current_ability
  end

  private

  def execute
    @record = model.create!(permitted_attributes)
  rescue StandardError => e
    errors << e.message
  end

  def success_hash
    table_module_name::IndexSerializer.new.serialize(record)
  end

  def permitted_attributes
    params.permit(model_columns - excluded_columns)
  end

  def excluded_columns
    %i[id created_at updated_at]
  end
end

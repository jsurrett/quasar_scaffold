class UpdateResponse
  extend Memoist
  include BaseResponse

  attr_reader :params, :current_ability

  def initialize(params, current_ability = {})
    @current_ability = current_ability
    @params = params
  end

  private

  def record
    model.accessible_by(current_ability).find(params[:id])
  end
  memoize :record

  def execute
    record.update!(permitted_attributes)
  rescue StandardError => e
    errors << e.message
  end

  def permitted_attributes
    params.require(model.name.underscore).permit(model_columns)
  end

  def success_hash
    serializer.new.serialize_to_json(record)
  end

  def serializer
    self.class.module_parent::IndexSerializer
  end
end

class ShowResponse
  extend Memoist
  include BaseResponse

  attr_reader :current_ability, :id

  def initialize(params, current_ability = {})
    @id = params.fetch(:id)
    @current_ability = current_ability
  end

  private

  def success_hash
    serializer.new.serialize_to_json(record)
  end

  def record
    model.accessible_by(current_ability).find(id)
  end

  def serializer
    self.class.module_parent::IndexSerializer
  end
end

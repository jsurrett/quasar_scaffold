class DestroyResponse
  extend Memoist
  include BaseResponse

  attr_reader :ids, :current_ability

  def initialize(params, current_ability = {})
    @ids = params.require(:id).to_s.split(',').map(&:to_i)
    @current_ability = current_ability
  end

  private

  def execute
    model.accessible_by(current_ability).where(id: ids).destroy_all
  rescue StandardError => e
    errors << e.message
  end
end

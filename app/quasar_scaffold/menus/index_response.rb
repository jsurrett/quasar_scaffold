module Menus
  class IndexResponse < ::IndexResponse
    def initialize(user:, ability:)
      @user = user
      @ability = ability
    end

    private

    attr_reader :user, :ability

    def success_hash
      Menus::Main.new(user:, ability:).menu
    end
  end
end

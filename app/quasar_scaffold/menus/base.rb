module Menus
  class Base
    def initialize(user:, ability:)
      @ability = ability
      @user = user
    end

    private

    attr_reader :user, :ability

    def access?
      true
    end
  end
end

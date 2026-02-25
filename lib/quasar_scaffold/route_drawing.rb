# frozen_string_literal: true

module QuasarScaffold
  module RouteDrawing
    # Draws the standard CRUD + collection routes for all configured resource modules.
    # Call this inside your routes namespace, e.g.:
    #
    #   namespace :v1 do
    #     quasar_scaffold_resources
    #   end
    def quasar_scaffold_resources
      QuasarScaffold.configuration.resource_modules.each do |module_name|
        resources module_name.tableize, only: [:index, :edit, :show, :create, :update, :destroy] do
          collection do
            put  :batch_update
            post :datatable_options
            post :search
            post :import
          end
        end
      end
    end
  end
end


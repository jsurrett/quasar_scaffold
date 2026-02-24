# frozen_string_literal: true

module QuasarScaffold
  class Engine < ::Rails::Engine
    # Non-isolated engine: gem classes live at top level (::BaseResponse, ::SchemaBuilder, etc.)
    # This is intentional — host app overrides like `class Students::EditResponse < ::EditResponse`
    # depend on gem classes being accessible at the top level.

    initializer 'quasar_scaffold.eager_load_paths' do |app|
      app.config.eager_load_paths += Dir[
        Engine.root.join('app', 'quasar_scaffold', '**')
      ]
    end

    # Dynamically create controllers and response classes after all app code is loaded
    config.to_prepare do
      QuasarScaffold.init
    end
  end
end

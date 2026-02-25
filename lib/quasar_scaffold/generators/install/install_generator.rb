# frozen_string_literal: true

require 'rails/generators'

module QuasarScaffold
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Installs QuasarScaffold into a Rails application'

      def create_initializer
        template 'initializer.rb.tt', 'config/initializers/quasar_scaffold.rb'
      end

      def show_post_install_instructions
        say "\n", :green
        say '=' * 70, :green
        say 'QuasarScaffold installed!', :green
        say '=' * 70, :green
        say "\n"
        say 'Next steps:', :yellow
        say "\n"
        say '1. Edit config/initializers/quasar_scaffold.rb to configure your resources', :cyan
        say "\n"
        say '2. Add to config/routes.rb inside your API namespace:', :cyan
        say '     namespace :v1 do'
        say '       quasar_scaffold_resources'
        say '       # ... your other routes'
        say '     end'
        say "\n"
        say '3. Add to the top of frontend/quasar.config.js:', :cyan
        say "     import { execSync } from 'child_process'"
        say "     import path from 'path'"
        say '     const gemFrontendPath = execSync('
        say '       "bundle exec ruby -e \\"require \'bundler/setup\'; print File.join(Gem.loaded_specs[\'quasar_scaffold\'].gem_dir, \'frontend\')\\"", '
        say '       { cwd: path.resolve(__dirname, \'..\') }'
        say '     ).toString().trim()'
        say "\n"
        say '4. Add to the build: {} block in quasar.config.js:', :cyan
        say '     extendViteConf(viteConf) {'
        say '       viteConf.resolve = viteConf.resolve || {}'
        say '       viteConf.resolve.alias = {'
        say '         ...(viteConf.resolve.alias || {}),'
        say "         'quasar-scaffold': gemFrontendPath,"
        say "         'quasar-scaffold-host': path.resolve(__dirname, 'src'),"
        say '       }'
        say '     },'
        say "\n"
        say 'That\'s it — no extra rake tasks or file generation needed.', :green
        say "\n"
      end
    end
  end
end

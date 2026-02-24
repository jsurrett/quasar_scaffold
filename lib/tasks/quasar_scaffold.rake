namespace :quasar_scaffold do
  desc 'Write the gem frontend path to .quasar_scaffold_frontend_path for Vite alias resolution'
  task write_frontend_path: :environment do
    path = QuasarScaffold.frontend_path
    output_file = Rails.root.join('.quasar_scaffold_frontend_path')
    File.write(output_file, path)
    puts "QuasarScaffold: wrote frontend path to #{output_file}"
    puts "  Path: #{path}"
  end
end

# frozen_string_literal: true

Bundler.require(:commandline)
require 'highline/import'
namespace :users do
  desc 'create super user'
  task create_admin: :environment do
    begin
      email = ask('Enter admin email:  ') { |q| q.echo = true }
      password = ask('Enter admin password:  ') { |q| q.echo = '*' }
      user = UserForm.new(email: email, password: password, role: 'admin')
      user.persist
      puts "Admin user #{email} has been created"
    rescue StandardError => e
      puts 'Unable to create admin user due to following errors'
      puts e.message
    end
  end
end

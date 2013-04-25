class AddRubyVersionToProject < ActiveRecord::Migration
  def change
    add_column :projects, :ruby_version, :string
  end
end

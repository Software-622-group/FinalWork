class AddOpenAttribute < ActiveRecord::Migration
  def change
    add_column :courses,:course_open,:boolean,:default =>false
    add_column :courses,:course_description,:string,:default =>""
  end
end

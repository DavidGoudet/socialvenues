class CreateVenuePlatforms < ActiveRecord::Migration[6.1]
  def change
    create_table :venue_platforms do |t|
      t.integer	:platform_name
      t.string 	:name
      t.string 	:address_1
      t.string 	:address_2
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lng, precision: 10, scale: 6
      t.integer :category_id
      t.boolean :closed
      t.string	:hours
      t.string	:website
      t.string	:phone_number

      t.timestamps
    end
  end
end

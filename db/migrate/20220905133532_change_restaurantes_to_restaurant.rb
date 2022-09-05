class ChangeRestaurantesToRestaurant < ActiveRecord::Migration[6.0]
  def change
    rename_table :restaurantes, :restaurants
  end
end

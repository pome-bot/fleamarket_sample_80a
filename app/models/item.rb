class Item < ApplicationRecord

  has_many :comments, dependent: :destroy
  has_many :item_images, dependent: :destroy
  belongs_to :category
  belongs_to :brand
  belongs_to_active_hash :item_condition
  belongs_to_active_hash :postage_burden
  belongs_to_active_hash :item_size
  belongs_to_active_hash :postage_day
  belongs_to :seller, class_name: "User"
  belongs_to :buyer, class_name: "User"

end

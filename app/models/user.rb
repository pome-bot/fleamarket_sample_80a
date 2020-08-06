class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :seller_items, foreign_key: "seller_id", class_name: "Item"
  has_many :buyer_items, foreign_key: "buyer_id", class_name: "Item"
  has_many :comments, dependent: :destroy
  has_one :credit_card
  has_one :user_profile
  has_one :user_address

end

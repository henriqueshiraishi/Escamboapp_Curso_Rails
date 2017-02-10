class Category < ActiveRecord::Base

  # Gem Friendly Id
  include FriendlyId
  friendly_id :description, use: :slugged


  # Associações
  has_many :ads

  # Validações
  validates_presence_of :description

  # Scopes
  scope :order_by_description, -> { order(description: :asc) }

end

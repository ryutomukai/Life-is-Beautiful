class Limit < ApplicationRecord

  belongs_to :admin

  validates :word, uniqueness: true

end

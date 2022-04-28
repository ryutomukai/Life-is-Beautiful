class Limit < ApplicationRecord

  #制限されたワード用モデル

  belongs_to :admin

  #制限ワードが重複しないようバリデーション
  validates :word, uniqueness: true

end

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: [:png, :jpg, :jpeg, :gif], message: "Allowed PNG, JPG, JPEG, GIF" },
                    size: { less_than: 5.megabytes }
  default_scope { order(created_at: :desc) }
end

class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: :'sender_id'
  belongs_to :recipient, class_name: 'User', foreign_key: :'recipient_id'
  validates :body_or_image, presence: true
  mount_uploader :image, ImagesUploader

  def time
    created_at.strftime("%Y年%m月%d日 %H時%M分")
  end

  private

    def body_or_image
      body.presence or image.presence
    end
end

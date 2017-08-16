class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  has_one :message_text
  has_one :message_image

  def for_js
    if message_text.present? && message_image.present?
      { name: sender.name, time: created_at.strftime("%Y年%m月%d日 %H時%M分"),
        text: message_text.body, image: message_image.body.to_s }
    elsif message_text.present?
      { name: sender.name, time: created_at.strftime("%Y年%m月%d日 %H時%M分"),
        text: message_text.body }
    else
      { name: sender.name, time: created_at.strftime("%Y年%m月%d日 %H時%M分"),
        image: message_image.body.to_s }
    end
  end

  class << self
    def create_text_or_image!(text:, image:, sender_id:, recipient_id:)
      raise if text.blank? || image.blank?
      ActiveRecord::Base.transaction do
        message = Message.create!(sender_id: sender_id, recipient_id: recipient_id)
        MessageText.create!(body: text,
         message_id: message.id) if text.present?
        MessageImage.create!(body: image,
         message_id: message.id) if image.present?
      end
      return message
    end
  end
end

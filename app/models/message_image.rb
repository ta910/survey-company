class MessageImage < ApplicationRecord
  belongs_to :message
  mount_uploader :body, ImagesUploader
end

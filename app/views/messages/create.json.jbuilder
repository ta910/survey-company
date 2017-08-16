json.name	    @message.sender.name
json.time     @message.created_at.strftime("%Y年%m月%d日 %H時%M分")
json.text     @message.message_text.body
json.image    @message.message_image.body.to_s

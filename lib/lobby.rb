class Lobby
  NO_SUCH_GAME = 'Sorry, there is no such game, /start a new one'

  def initialize(api)
    @api = api
    @games = {}
  end

  def start_game(chat_id, position=(0..15).to_a.shuffle)
    game = Game.new(position)
    text, position = game.start
    message = @api.send_message(chat_id: chat_id, text: text, reply_markup: markup(position))
    @games[message["result"]["message_id"]] = game
  end

  def move(chat_id, message_id, button)
    game = @games[message_id]
    if game
      text, position = game.move(button.to_i)
      @api.edit_message_text(chat_id: chat_id, message_id: message_id, text: text, reply_markup: markup(position))
      if game.ended?
        @games.delete message_id
      end
    else
      @api.edit_message_text(chat_id: chat_id, message_id: message_id, text: NO_SUCH_GAME)
    end
  rescue Telegram::Bot::Exceptions::ResponseError => e
    logger.debug(e.message)
  end

  private
  def markup(position)
    return unless position
    kb = position.map do |i|
     Telegram::Bot::Types::InlineKeyboardButton.new(text: markup_value(i), callback_data: markup_value(i))
    end
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb.each_slice(4).to_a)
  end

  def markup_value(field)
    field == 0 ? ' ' : field.to_s
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end
end

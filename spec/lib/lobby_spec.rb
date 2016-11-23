require 'spec_helper'

describe Lobby do
  let(:chat_id) {2}
  let(:message_id) {7}

  it do
    api = spy('api')
    lobby = Lobby.new(api)

    expect(api).to receive(:send_message) do |args|
      expect(args[:chat_id]).to eq(chat_id)
      expect(args[:text]).to eq(Game::GREETING)
      expect(args[:reply_markup].inline_keyboard.flatten.map(&:text)).to eq(
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", " ", "14", "15"])
      {"result" => {"message_id" => message_id}}
    end
    lobby.start_game(chat_id, [1,2,3,4,5,6,7,8,9,10,11,12,13,0,14,15])

    expect(api).to receive(:edit_message_text) do |args|
      expect(args[:chat_id]).to eq(chat_id)
      expect(args[:message_id]).to eq(message_id+1)
      expect(args[:text]).to eq(Lobby::NO_SUCH_GAME)
      expect(args[:reply_markup]).to eq(nil)
    end
    lobby.move(chat_id, message_id+1, "15")

    expect(api).to receive(:edit_message_text) do |args|
      expect(args[:chat_id]).to eq(chat_id)
      expect(args[:message_id]).to eq(message_id)
      expect(args[:text]).to eq(Game::MOVE_CHEER_UPS[0])
      expect(args[:reply_markup].inline_keyboard.flatten.map(&:text)).to eq(
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", " ", "15"])
    end
    lobby.move(chat_id, message_id, "14")

    expect(api).to receive(:edit_message_text) do |args|
      expect(args[:chat_id]).to eq(chat_id)
      expect(args[:message_id]).to eq(message_id)
      expect(args[:text]).to eq(Game::VICTORY)
      expect(args[:reply_markup]).to eq(nil)
    end
    lobby.move(chat_id, message_id, "15")

    expect(api).to receive(:edit_message_text) do |args|
      expect(args[:chat_id]).to eq(chat_id)
      expect(args[:message_id]).to eq(message_id)
      expect(args[:text]).to eq(Lobby::NO_SUCH_GAME)
      expect(args[:reply_markup]).to eq(nil)
    end
    lobby.move(chat_id, message_id, "15")
  end
end

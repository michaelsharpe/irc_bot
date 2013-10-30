require 'socket'
require 'cinch'

class EButlerBot
  PARTINGS = %w(bye goodbye cya seeya quit)
  PASSWORD = "AbrAhAdAbrA"

  def initialize(server, port, channel)
    @channel = channel
    @socket= TCPSocket.open(server, port)
    say "NICK eButlerBot"
    say "USER eButlerBot 0 * eButlerBot"
    say "JOIN #{@channel}"
    run!
  end

  def say(msg)
    puts msg
    @socket.puts msg
  end

  def chat(msg)
    say "PRIVMSG #{@channel} :#{msg}"
  end

  def run!
    until @socket.eof? do
      respond_to! @socket.gets
    end
  end

  def respond_to!(msg)
    puts msg
    new_user?(msg) if msg.downcase.include? "join #{@channel}"
    quit?(msg)
    ping?(msg)
    time?(msg)
  end

  def quit?(msg)
    PARTINGS.each do |p|
      say "QUIT" if msg.include? p
      @socket.close if msg.include? p
    end
  end

  def ping?(msg)
    ping = msg.include? "PING"
    return unless ping
    say(msg.gsub("PING", "PONG")) if ping
  end

  def time?(msg)
    say(Time.now) if msg.include? "time"
  end

  def new_user?(msg)
    msg =~ /[:](.+)[!]/
    user_joined = $~.to_s
    user_joined = user_joined.split('')
    user_joined.shift
    user_joined.pop
    user_joined = user_joined.join('')
    say "#{user_joined}"
  end
end

EButlerBot.new("chat.freenode.net", 6667, "#project89")
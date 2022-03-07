=begin
module Samovar
  class Certificate
    def new(host, port)
      @socket = TCPSocket.new(host, port)
      @ssl_socket = OpenSSL::SSL::SSLSocket.new(@socket)
      
    end
  end
end
=end

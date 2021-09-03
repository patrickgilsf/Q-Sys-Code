--hooks
address = Controls.ipa.String
  print(address)
port = tonumber(Controls.port.String)
  print(port)
cmd = Controls.command.String..'\x0d\x0a'
  print(cmd)


sock = TcpSocket.New()
sock.ReadTimeout = 0
sock.WriteTimeout = 0
sock.ReconnectTimeout = 5

sock.Connected = function(sock)
  print("TCP socket is connected")
end
sock.Reconnect = function(sock)
  print("TCP socket is reconnecting")
end
sock.Closed = function(sock)
  print("TCP socket was closed by the remote end")
end
sock.Error = function(sock, err)
  print("TCP socket had an error:",err)
end
sock.Timeout = function(sock, err)
  print("TCP socket timed out",err)
end
sock.Data = function()
  Controls.fbBox.String = sock:Read(sock.BufferLength)  
end
Controls.trigger.EventHandler = function()
  sock:Write(cmd)
  --Controls.fbBox.String = sock:Read(sock.BufferLength)
end
Controls.clear.EventHandler = function() 
  Controls.fbBox.String = ""
  end
Controls.command.EventHandler = function()
  if Controls.command.String ~= nil then
    cmd = Controls.command.String..'\x0d\x0a'
    print(cmd)
  end
end
Controls.ipa.EventHandler = function()
  if Controls.ipa.String ~= nil then
    ipa = Controls.ipa.String
    print(ipa)
  end
end

function IPConnect()
  if Controls.ipa.String ~= "" and Controls.port.String ~= "" then
    sock:Connect(Controls.ipa.String,tonumber(Controls.port.String))
  end
end

function IPDisconnect()
  sock:Disconnect()
  print("TCP IP Connection has been closed locally")
end

IPConnect()

function Reconnect()
  IPDisconnect()
  Timer.CallAfter(IPConnect, 0.5) 
end 

Controls.ipa.EventHandler = function()
  Reconnect()
end
Controls.port.EventHandler = function()
  Reconnect()
end
sock:Connect(address, port)

{EventEmitter} = require "events"

module.exports = class Parser extends EventEmitter
  constructor: ->
    @stringBuffer = ""
    
  receive: (buffer) ->
    @stringBuffer += buffer.toString('utf8')
    while (index = @stringBuffer.indexOf("\n")) > -1
      json = @stringBuffer.slice(0, index)
      @stringBuffer = @stringBuffer.slice(index + 1)
      if json.length > 0
        try
          json = JSON.parse(json);
          @emit("object", json)
        catch error
          @emit("error", error)
      
        
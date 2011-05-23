uuid = require('node-uuid')
{EventEmitter} = require "events"
module.exports = class HttpJsonRequest extends EventEmitter
  
  constructor: (@apiKey, @method, @resource, @body = null, @params = {}, @headers = {}) ->
    @headers["X-PachubeApiKey"] ||= @apiKey
    @token = "#{@method}:#{uuid()}"
  
  requestObject: ->
    request = 
      "resource" : @resource
      "method" : @method
      "body" : @body if @body
      "headers" : @headers
      "token" : @token
      "params" : @params
    
  # The HTTP JSON request to be sent to Pachube
  json: ->
    JSON.stringify(@requestObject())
      
  emitEvent: (json) ->
    if json.body
      @emit("data", json)
    else
      if json.status == 200 then @emit("complete", json) else @emit("error", json)
  
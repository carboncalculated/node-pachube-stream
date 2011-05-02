net = require "net"
{EventEmitter} = require "events"
HttpJsonRequest = require "./http_json_request"

module.exports = class Connection extends EventEmitter
  
  constructor: (@apiKey, @options = {}) ->
    @host = @options.host || "beta.pachube.com"
    @port = @options.port || 8081
    @conn = net.createConnection(@port, @host)
    @requests = {}
    
    @conn.on "connect", =>
      @emit "connect"
    
    @conn.on "close", (had_error) =>
      # Reconnections 
      @emit "close", had_error
    
    @conn.on "error", (error) =>
      @emit "error", error

    @conn.on 'data', (data) =>
      @processData(data)
  
  subscribe: (resource, params = {}, headers = {}) ->
    @sendRequest(new HttpJsonRequest(@apiKey, "subscribe", resource, params, headers))
    
  get: (resource, params = {}, headers = {}) ->
    @sendRequest(new HttpJsonRequest(@apiKey, "get", resource, params, headers))
    
  post: (resource, params = {}, headers = {}) ->
    @sendRequest(new HttpJsonRequest(@apiKey, "post", resource, params, headers))

  put: (resource, params = {}, headers = {}) ->
    @sendRequest(new HttpJsonRequest(@apiKey, "put", resource, params, headers))
    
  delete: (resource, params = {}, headers = {}) ->
    @sendRequest(new HttpJsonRequest(@apiKey, "delete", resource, params, headers))

  sendRequest: (request) ->
    @requests[request.token] = request
    @conn.write(request.json())
    request
  
  processData: (data) ->
    data = data.toString('utf8')
    console.log(data)
    try
      json = JSON.parse(data)
      request = @requests[json.token]
      request.emitEvent(json)
    catch error
      @emit("error", error)
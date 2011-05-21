net = require "net"
{EventEmitter} = require "events"
HttpJsonRequest = require "./http_json_request"
Parser = require "./parser"
module.exports = class Connection extends EventEmitter
  
  constructor: (@apiKey, @options = {}) ->
    @host = @options.host || "beta.pachube.com"
    @port = @options.port || 8081
    @conn = net.createConnection(@port, @host)
    @requests = {}
    @request_queue = []
    
    @parser = new Parser()
    @parser.on "object", (json) =>
      @processData(json)
      @processRequestQueue(json.token)
      
    @parser.on "error", (error) =>
      @emit("error", error)
    
    @conn.on "connect", =>
      @emit "connect"
    
    @conn.on "close", (had_error) =>
      # Reconnections 
      @emit "close", had_error
    
    @conn.on "error", (error) =>
      @emit "error", error

    @conn.on 'data', (data) =>
      @parser.receive(data)
    
  subscribe: (resource, params = {}, headers = {}) ->
    @sendRequest(new HttpJsonRequest(@apiKey, "subscribe", resource, params, headers))
  
  unsubscribe: (resource, params = {}, headers = {}) ->
    @sendRequest(new HttpJsonRequest(@apiKey, "unsubscribe", resource, params, headers))
    
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
    @request_queue.push(request.token)
    if @request_queue.length <= 1
      @conn.write(request.json())
    request
  
  processRequestQueue: (token) ->
    index = @request_queue.indexOf(token)
    @request_queue.splice(index, 1)
    if token = @request_queue.shift()
      @conn.write(@requests[token].json())
    
  processData: (json) ->      
    if request = @requests[json.token]
      request.emitEvent(json)
    else
      if json.status is 400 then @emit("error", json)  else @emit("data", json)
{HttpJsonRequest}  = require ".."
{testCase}    = require "nodeunit"
{fixturePath, fakeServer} = require "./lib/test_helper"
module.exports = testCase

  setUp: (proceed) ->
    @server = fakeServer()
    proceed()
  
  tearDown: (proceed) ->
    @server.close()
    proceed()
  
  "Adding some custom extra headers": (test) ->
    request = new HttpJsonRequest("api_key", "subscribe", "/feeds/10", {}, {}, {"beans" : "eggs"})
    test.equal(request.headers["beans"], "eggs")
    test.equal(request.headers["X-PachubeApiKey"], "api_key")
    test.done()
  
  "Adding some custom api key on the fly" : (test) ->
    request = new HttpJsonRequest("api_key", "subscribe", "/feeds/10", {}, {}, {"X-PachubeApiKey" : "eggs123"})
    test.equal(request.headers["X-PachubeApiKey"], "eggs123")
    test.done()
    
  "Adding some params" : (test) ->
    request = new HttpJsonRequest("api_key", "subscribe", "/feeds/10", {}, {"beans" : "cheese"})
    test.equal(request.params["beans"], "cheese")
    test.done()
    
  "Adding a body": (test) ->
    request = new HttpJsonRequest("api_key", "subscribe", "/feeds/10", 
      "version" : "1.0.0",
        "datastreams" : [
            {
              "id" : "0",
              "current_value" : "980"
            },
            {
              "id" : "1",
              "current_value" : "-261"
            }
          ]
      )
    test.equal(request.body["version"], "1.0.0")
    test.done()
    
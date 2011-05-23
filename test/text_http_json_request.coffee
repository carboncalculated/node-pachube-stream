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
    request = new HttpJsonRequest("api_key", "subscribe", "/feeds/10", "", {}, {"beans" : "eggs"})
    test.notStrictEqual(request.headers, {"beans": 'eggs', 'X-PachubeApiKey': 'api_key' })
    test.done()
    
  "Adding some params" : (test) ->
    request = new HttpJsonRequest("api_key", "subscribe", "/feeds/10", "", {"beans" : "eggs"})
    test.notStrictEqual(request.params, {"beans": 'eggs'})
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
    test.notStrictEqual(request.body, 
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
    test.done()
    
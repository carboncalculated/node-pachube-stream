{Connection} = require ".."
{testCase}    = require "nodeunit"
{fixturePath, fakeServer} = require "./lib/test_helper"

module.exports = testCase

  setUp: (proceed) ->
    @server = fakeServer()
    proceed()
  
  tearDown: (proceed) ->
    @server.close()
    proceed()
    
  "Making A Sucessful Connection": (test) ->
    test.expect 1
    connection = new Connection("API_KEY", {host : "localhost", port : 9001})
    connection.on "connect", ->
      test.ok(true)
      test.done()

  "#subscribe, should emit a complete event on success": (test) ->
     connection = new Connection("API_KEY", {host : "localhost", port : 9001})
     request = connection.subscribe("/feeds/256")
     test.expect 2
     request.on "complete", (data) ->
       test.equal("/feeds/256", data.resource)
       test.equal(200, data.status)
       test.done()

   "#subscribe, should emit data events when datastream has data": (test) ->
     connection = new Connection("API_KEY", {host : "localhost", port : 9001})
     request = connection.subscribe("/feeds/256")
     test.expect 3
     request.on "data", (data) ->
       test.equal("/feeds/256", data.resource)
       test.equal("live", data.body.status)
       test.ok(data.body)
       test.done()
    
    "#subscribing to multipy feeds on the same connnection, should increase the request queue" : (test) ->
      connection = new Connection("API_KEY", {host : "localhost", port : 9001})
      request1 = connection.subscribe("/feeds/256")
      request2 = connection.subscribe("/feeds/256")
      test.equal(connection.request_queue.length, 2)
      test.done()
    
    "#subscribing to multipy feeds on the same connnection, should empty request queue when request completed" : (test) ->
      connection = new Connection("API_KEY", {host : "localhost", port : 9001})
      request1 = connection.subscribe("/feeds/256")
      request2 = connection.subscribe("/feeds/256")
      request1.on "data", (data) ->
        test.equal(connection.request_queue.length, 0)
        test.done()
      
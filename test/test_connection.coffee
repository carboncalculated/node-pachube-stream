{Connection} = require ".."
{testCase}    = require "nodeunit"
{fixturePath, fakeServer} = require "./lib/test_helper"
net = require "net"

module.exports = testCase

  setUp: (proceed) ->
    @server = fakeServer()
    proceed()
  
  tearDown: (proceed) ->
    @server.close()
    proceed()
    
  "Making A Sucessful Connection": (test) ->
    test.expect 1
    connection = new Connection("API_KEY", {host : "localhost", port : 9121})
    connection.on "connect", ->
      test.ok(true)
      test.done()

  "#subscribe, should emit a complete event on success": (test) ->
    connection = new Connection("API_KEY", {host : "localhost", port : 9121})
    request = connection.subscribe("/feeds/256")
    test.expect 2
    request.on "complete", (data) ->
      test.equal("/feeds/256", data.resource)
      test.equal(200, data.status)
      test.done()
    
  "#subscribe, should emit data events when datastream has data": (test) ->
    connection = new Connection("API_KEY", {host : "localhost", port : 9121})
    request = connection.subscribe("/feeds/256")
    test.expect 3
    request.on "data", (data) ->
      test.equal("/feeds/256", data.resource)
      test.equal("live", data.body.status)
      test.ok(data.body)
      test.done()
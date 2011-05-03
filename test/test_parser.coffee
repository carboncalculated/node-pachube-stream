{Parser}  = require ".."
{testCase}    = require "nodeunit"
{fixturePath, fakeServer} = require "./lib/test_helper"

module.exports = testCase

  setUp: (proceed) ->
    @server = fakeServer()
    proceed()
  
  tearDown: (proceed) ->
    @server.close()
    proceed()
    
  "Parser, accepts chunks of JSON seperated by new line character": (test) ->
    test.expect 1
    parser = new Parser

    parser.on "object", (json) -> 
      test.equal(3, json.a)
      test.done()
    
    parser.receive("")
    parser.receive("{")
    parser.receive("\"a\" : 3")
    parser.receive("}\n")
    
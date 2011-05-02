fs     = require "fs"
{join} = require "path"
net = require "net"

exports.fixturePath = fixturePath = (fixture) ->
  join fs.realpathSync(join __dirname, ".."), "fixtures", fixture

exports.fakeServer = fakeServer = (fixture)->
  server = net.createServer (connection) ->
    connection.on "data", (data) ->
      data = data.toString('utf8')
      json = JSON.parse(data)
      if json.method == "subscribe"
        switch json.resource
          when "/feeds/256"
            fs.readFile fixturePath("feeds_256.json"), (error, data) ->
              response = JSON.parse(data)
              response["token"] = json.token
              connection.write(JSON.stringify(response))
              
            setTimeout ->
              fs.readFile fixturePath("feeds_256_data.json"), (error, data) ->
                response = JSON.parse(data)
                response["token"] = json.token
                connection.write(JSON.stringify(response))
            ,1000
            
  server.listen(9121, "localhost")  
  server
  
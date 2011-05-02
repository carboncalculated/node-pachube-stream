(function() {
  var Connection, EventEmitter, HttpJsonRequest, net;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  net = require("net");
  EventEmitter = require("events").EventEmitter;
  HttpJsonRequest = require("./http_json_request");
  module.exports = Connection = (function() {
    __extends(Connection, EventEmitter);
    function Connection(apiKey, options) {
      this.apiKey = apiKey;
      this.options = options != null ? options : {};
      this.host = this.options.host || "beta.pachube.com";
      this.port = this.options.port || 8081;
      this.conn = net.createConnection(this.port, this.host);
      this.requests = {};
      this.conn.on("connect", __bind(function() {
        return this.emit("connect");
      }, this));
      this.conn.on("close", __bind(function(had_error) {
        return this.emit("close", had_error);
      }, this));
      this.conn.on("error", __bind(function(error) {
        return this.emit("error", error);
      }, this));
      this.conn.on('data', __bind(function(data) {
        return this.processData(data);
      }, this));
    }
    Connection.prototype.subscribe = function(resource, params, headers) {
      if (params == null) {
        params = {};
      }
      if (headers == null) {
        headers = {};
      }
      return this.sendRequest(new HttpJsonRequest(this.apiKey, "subscribe", resource, params, headers));
    };
    Connection.prototype.get = function(resource, params, headers) {
      if (params == null) {
        params = {};
      }
      if (headers == null) {
        headers = {};
      }
      return this.sendRequest(new HttpJsonRequest(this.apiKey, "get", resource, params, headers));
    };
    Connection.prototype.post = function(resource, params, headers) {
      if (params == null) {
        params = {};
      }
      if (headers == null) {
        headers = {};
      }
      return this.sendRequest(new HttpJsonRequest(this.apiKey, "post", resource, params, headers));
    };
    Connection.prototype.put = function(resource, params, headers) {
      if (params == null) {
        params = {};
      }
      if (headers == null) {
        headers = {};
      }
      return this.sendRequest(new HttpJsonRequest(this.apiKey, "put", resource, params, headers));
    };
    Connection.prototype["delete"] = function(resource, params, headers) {
      if (params == null) {
        params = {};
      }
      if (headers == null) {
        headers = {};
      }
      return this.sendRequest(new HttpJsonRequest(this.apiKey, "delete", resource, params, headers));
    };
    Connection.prototype.sendRequest = function(request) {
      this.requests[request.token] = request;
      this.conn.write(request.json());
      return request;
    };
    Connection.prototype.processData = function(data) {
      var json, request;
      data = data.toString('utf8');
      console.log(data);
      try {
        json = JSON.parse(data);
        request = this.requests[json.token];
        return request.emitEvent(json);
      } catch (error) {
        return this.emit("error", error);
      }
    };
    return Connection;
  })();
}).call(this);

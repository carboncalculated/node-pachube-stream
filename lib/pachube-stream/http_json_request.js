(function() {
  var EventEmitter, HttpJsonRequest, uuid;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  uuid = require('node-uuid');
  EventEmitter = require("events").EventEmitter;
  module.exports = HttpJsonRequest = (function() {
    function HttpJsonRequest(apiKey, method, resource, body, params, headers) {
      this.apiKey = apiKey;
      this.method = method;
      this.resource = resource;
      this.body = body != null ? body : null;
      this.params = params != null ? params : {};
      this.headers = headers != null ? headers : {};
      this.headers["X-PachubeApiKey"] = this.apiKey;
      this.token = "" + this.method + ":" + (uuid());
    }
    __extends(HttpJsonRequest, EventEmitter);
    HttpJsonRequest.prototype.requestObject = function() {
      var request;
      return request = {
        "resource": this.resource,
        "method": this.method,
        "body": this.body ? this.body : void 0,
        "headers": this.headers,
        "token": this.token,
        "params": this.params
      };
    };
    HttpJsonRequest.prototype.json = function() {
      return JSON.stringify(this.requestObject());
    };
    HttpJsonRequest.prototype.emitEvent = function(json) {
      if (json.body) {
        return this.emit("data", json);
      } else {
        if (json.status === 200) {
          return this.emit("complete", json);
        } else {
          return this.emit("error", json);
        }
      }
    };
    return HttpJsonRequest;
  })();
}).call(this);

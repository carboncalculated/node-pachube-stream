(function() {
  var EventEmitter, Parser;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  EventEmitter = require("events").EventEmitter;
  module.exports = Parser = (function() {
    __extends(Parser, EventEmitter);
    function Parser() {
      this.stringBuffer = "";
    }
    Parser.prototype.receive = function(buffer) {
      var index, json, _results;
      this.stringBuffer += buffer.toString('utf8');
      _results = [];
      while ((index = this.stringBuffer.indexOf("\n")) > -1) {
        json = this.stringBuffer.slice(0, index);
        this.stringBuffer = this.stringBuffer.slice(index + 1);
        _results.push((function() {
          if (json.length > 0) {
            try {
              json = JSON.parse(json);
              return this.emit("object", json);
            } catch (error) {
              return this.emit("error", error);
            }
          }
        }).call(this));
      }
      return _results;
    };
    return Parser;
  })();
}).call(this);

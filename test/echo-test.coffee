assert = require "assert"
grunt = require "grunt"

env = require("../node_modules/pimatic/startup").env

describe "echo", ->

  plugin = require("../echo")(env)

  describe "isSupported", ->

    it "should return true if device has a known template", ->
      assert plugin.isSupported({ template: template }) for template in plugin.knownTemplates

    it "should return false if template is unknown", ->
      assert plugin.isSupported({ template: "foo"}) is false

  describe "isExcluded", ->

    it "should return false if no config value exists", ->
      assert plugin.isExcluded({config: {}}) is false

    it "should return false if device is not excluded", ->
      assert plugin.isExcluded({
        config:
          echo:
            exclude: false
      }) is false

    it "should return true if device is excluded", ->
      assert plugin.isExcluded({
        config:
          echo:
            exclude: true
      }) is true

  describe "getDeviceName", ->

    it "should return device name if no config exists", ->
      expected = "devicename"
      assert plugin.getDeviceName({
        name: expected
        config:
          echo: {}
      }) is expected

    it "should return name from config", ->
      expected = "devicename"
      assert plugin.getDeviceName({
        name: "othername"
        config:
          echo:
            name: expected
      }) is expected

  describe "getAdditionalNames", ->

    it "should return empty list no config exists", ->
      assert plugin.getAdditionalNames({
        name: "device"
        config:
          echo: {}
      }).length is 0

    it "should return names from config", ->
      additionalNames = plugin.getAdditionalNames({
        name: "othername"
        config:
          echo:
            additionalNames: ["1", "2"]
      })
      assert additionalNames[0] is "1"
      assert additionalNames[1] is "2"

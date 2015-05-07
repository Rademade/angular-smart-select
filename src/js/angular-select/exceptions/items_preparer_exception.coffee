class @OverrideException
  name : 'overrideException'
  messages : ''

  constructor : (method, className) ->
    @message = "abstract method #{method} on #{className} not overridden"
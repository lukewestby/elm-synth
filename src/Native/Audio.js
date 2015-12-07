Elm.Native.Audio = {}
Elm.Native.Audio.make = function (localRuntime) {

  localRuntime.Native.Audio = {}

  var Task = Elm.Native.Task.make(localRuntime)
  var Utils = Elm.Native.Utils.make(localRuntime)

  var audioContext = new AudioContext()
  var filter = audioContext.createBiquadFilter()
  filter.connect(audioContext.destination)
  var oscillator = null

  // start : String -> Float -> Task never ()
  function start(type, frequency) {
    return Task.asyncFunction(function (callback) {
      oscillator && oscillator.stop(0)
      oscillator = audioContext.createOscillator()
      oscillator.type = type
      oscillator.frequency.value = frequency
      oscillator.connect(filter)
      oscillator.start(0)
      callback(Task.succeed(Utils.Tuple0))
    })
  }

  // setFilter : String -> Int -> Task never ()
  function setFilter(filterType, filterPct) {
    return Task.asyncFunction(function (callback) {

      // It's important to do a power or log scale here instead of linear or
      // else things get real aggressive real quick
      var fraction = filterPct / 100
      var min = 120
      var filterFreq = Math.pow((audioContext.sampleRate / 2 - min), fraction) + min

      filter.type = filterType
      filter.frequency.value = filterFreq
      callback(Task.succeed(Utils.Tuple0))
    })
  }

  // stop : () -> Task never ()
  function stop() {
    return Task.asyncFunction(function (callback) {
      oscillator && oscillator.stop(0)
      oscillator = null
      callback(Task.succeed(Utils.Tuple0))
    })
  }

  localRuntime.Native.Audio.values = {
    start: F2(start),
    setFilter: F2(setFilter),
    stop: stop
  }

  return localRuntime.Native.Audio.values
}

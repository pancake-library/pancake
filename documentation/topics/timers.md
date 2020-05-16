# Timers

## What is a pancake timer?

Timer is a simple thing you can create and manage to control all timed based events in your game!

# Timer attributes
Every timer is a table that consists of these attributes:

- `time`(1000) <- Time (duh) in milliseconds to the end of the cycle. This number will decrease till it hits 0!
- `mode`("single") <- If this is set to **"single"**, the timer will stop after `time` hits 0. If set to **"repetetive"** it will reset itself and run again.
- `func` <- This is the name of the function that should run when timer's `time` drops to 0.
- `arguments` <- This are arguments that `func` will take when timer's `time` drops to 0.

!> **NOTE:** If timer's `mode` is **"single"**, it will be deleted after it runs it's cycle!

## How to create a timer?

You create a timer by simply using [`pancake.addTimer()`](http://mightypancake.games/#/documentation/functions/pancake.addTimer()):

```lua
pancake.addTimer(1200, "repetetive", doThing)
```

This timer will call `doThing` without any arguments every 1.2 seconds!

For more info, head to [this article](http://mightypancake.games/#/documentation/functions/pancake.addTimer())!

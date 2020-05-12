# pancake.boolConversion()

## Description

Outputs data based on given statemant.

## Inputs

- `statemant` <- This will decide which one of the next two values will be returned.
- `ifTrue`("true") <- Value that should be returned if the `statemant` is `true`.
- `ifFalse`("false") <- Value that should be returned if the `statemant` is `false`.

## Outputs

- `value` <- This is `ifTrue` if statemantis true and `ifFalse` otherwise.

## Example

Consider displaying if a certain thing is turned on and off again to the screen:

```lua
local our_text
if our_setting == true then
  our_text = "on"
else
  our_text = "off"
end
pancake.print(our_text, x, y, scale)
```

That's a lot of lines, isn't it? You can simplify it like that:

```lua
pancake.print(pancake.boolConversion(our_setting, "on", "false"))
```

See? All those lines in a simple command! Now is it just me or is this trulely beautifull?

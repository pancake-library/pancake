# Versions

Here is the list of versions and additions to pancake!

!> **NOTE:** All tutorials and downloads are targeting **latest** version of the library!

## v.2.0

- Added edit mode! Here you can inspect, change and save states in real time!
- Added full support for pseudo fonts!
- Added a pseudo font David
- Fixed few physic problems, for example clipping that caused stack overflow earlier
- Now bodies can have `colliding = "staticOnly"`. This will make it so the given object will only collide with physics set to `false` or `nil`.
- Now objects can have `image` attribute set to "rectangle", this will cause pancake to draw rectangle instaed of drawing an image.
- Now objects have their color for example: `object.color = {r=1,g=0,b=0,a=0.5}` will cause the object to be drawn half transparent and red!
- Many minor tweaks...

## v.1.1.1

- Renamed `pancake.getAxisName` to `pancake.getDirectionName`
- Added cover
- Minor changes to physics

## v.1.1.0

- Added `pancake.addFolder()`
- Added `panckae.addAssets()`

## v.1.0.1

- Added support for android touch devices
- Button's witdht and height now scales with scale parameter

## v.1.0

- Initial release

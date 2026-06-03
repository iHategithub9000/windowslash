# WindowSlash 
This is a CYF library made by `painscreen (yourhardworkgone)` on Discord.  
It allows you to replicate the window slice effect from Undertale's Genocide run ending.  
The library is Windows only. If you use the library, please credit the owner!
 
### `WindowSlash.SetParam(name, value)`
Sets a parameter. Has to run before `WindowSlash.StartSlash`. 
 
### `WindowSlash.StartSlash()`
Starts the slash animation. Can only be called once per battle. Calling it again throws an error. Running this will throw an error if the engine builtin variable `windows` is false.  

### `WindowSlash.GetSlashStarted()`
Returns whether `WindowSlash.StartSlash` has been called.
 
### `WindowSlash.Update()`
Must be called once every frame from your script's `Update()` function. 

### Params

Parameter | Description | Permitted types | Default 
|:----------|:------------|:----------------|:--------|
`WindowShakeDistance` | How far the window moves with each shake. Decreased by `WindowShakeDistanceDecrease` each time the window moves. This affects both how much the window moves, and how long it shakes. | `number` | `40`
`WindowShakeDistanceDecrease` | Amount subtracted from `WindowShakeDistance` after each shake. Higher values cause the shaking to end sooner. | `number` | `1`
`Permanence` | The name of the AlMighty global to set to `true` right before the slice finishes. Does nothing if set to `false` | `string \| boolean` | `false`
`KillCYF` | Closes the CYF window at the end if `true`, exits the battle otherwise  | `boolean` | `true`
`WindowShakeStopSleepTimer` | How much time it takes to end the battle after `WindowShakeDistance` becomes 0. Each unit corresponds to 5 frames. | `number` | `10`
`CameraShakeIntensity` | Intensity of the camera shake used to shake the giant damage number rendered at the end of the window slice. | `number` | `5`
`SliceScale` | How big the slice attack animation is. | `number` | `5`

### Example

```lua
ws = require("Libraries/windowslash")
ws.SetParam("SliceScale", 6)
ws.SetParam("KillCYF", false)

frametimer = 0

function Update()
    frametimer = frametimer + 1
    ws.Update()
    if frametimer % 10 == 0 and not ws.GetSlashStarted() then 
        -- could have used an equality check here, but i wanted to demonstrate GetSlashStarted
        ws.StartSlash()
    end
end
```

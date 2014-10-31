With `fluidPage()`, each item should be 220 pixels wide and flow with the width of the window. The appearance should be roughly the same with:

```R
runApp(system.file('examples/fluidpage', package = 'shinyBootstrap2'))
```

and

```R
shinyBootstrap2::withBootstrap2(
    runApp(system.file('examples/fluidpage', package = 'shinyBootstrap2'))
)
```

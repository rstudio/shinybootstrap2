With `fluidPage()`, each item should be 220 pixels wide and flow with the width of the window. The appearance should be roughly the same with:

```R
.GlobalEnv$useBS2 <- FALSE
runApp(system.file('examples/fluidpage', package = 'shinybootstrap2'))
```

and

```R
.GlobalEnv$useBS2 <- TRUE
runApp(system.file('examples/fluidpage', package = 'shinybootstrap2'))
```

(The app looks at the `.GlobalEnv$useBS2` variable to see whether it should use the `shinybootstrap2::withBootstrap2()` wrapper function.)

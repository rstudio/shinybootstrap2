Setting the value of the slider should update all of the other input items, and switch tabs depending on whether the value is even or odd. The behavior should be the same with:

```R
.GlobalEnv$useBS2 <- FALSE
runApp(system.file('examples/setinput', package = 'shinyBootstrap2'))
```

and

```R
.GlobalEnv$useBS2 <- TRUE
runApp(system.file('examples/setinput', package = 'shinyBootstrap2'))
```

(The app looks at the `.GlobalEnv$useBS2` variable to see whether it should use the `shinyBootstrap2::withBootstrap2()` wrapper function.)

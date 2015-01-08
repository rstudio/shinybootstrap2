With inline inputs, the items should appear on a row. The appearance should be roughly the same with:

```R
.GlobalEnv$useBS2 <- FALSE
runApp(system.file('examples/inline', package = 'shinybootstrap2'))
```

and

```R
.GlobalEnv$useBS2 <- TRUE
runApp(system.file('examples/inline', package = 'shinybootstrap2'))
```

(The app looks at the `.GlobalEnv$useBS2` variable to see whether it should use the `shinybootstrap2::withBootstrap2()` wrapper function.)

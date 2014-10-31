With inline inputs, the items should appear on a row. The appearance should be roughly the same with:

```R
runApp(system.file('examples/inline', package = 'shinyBootstrap2'))
```

and

```R
shinyBootstrap2::withBootstrap2(
    runApp(system.file('examples/inline', package = 'shinyBootstrap2'))
)
```

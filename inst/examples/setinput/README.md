Setting the value of the slider should update all of the other input items, and switch tabs depending on whether the value is even or odd. The behavior should be the same with:

```R
runApp(system.file('examples/setinput', package = 'shinyBootstrap2'))
```

and

```R
shinyBootstrap2::withBootstrap2(
    runApp(system.file('examples/setinput', package = 'shinyBootstrap2'))
)
```

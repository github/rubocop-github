# GitHub/RailsRenderInline

tldr; Do not use `render inline:`.

## Rendering plain text

``` ruby
render inline: "Just plain text" # bad
```

The `inline:` option is often misused when plain text is being returned. Instead use `render plain: "Just plain text"`.

## Rendering a dynamic ERB string

String `#{}` interpolation is often misused with `render inline:` instead of using `<%= %>` interpolation. This will lead to a memory leak where an ERB method will be compiled and cached for each invocation of `render inline:`.

``` ruby
render inline: "Hello #{@name}" # bad
```

## Rendering static ERB strings

``` ruby
render inline: "Hello <%= @name %>" # bad
```

If you are passing a static ERB string to `render inline:`, this string is best moved to a `.erb` template under `app/views`. Template files are able to be precompiled at boot time.

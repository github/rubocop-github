# GitHub/Accessibility/LinkHasHref

## Rule Details

Links should go somewhere, you probably want to use a `<button>` instead.

## Resources

- TBD

## Examples
### **Incorrect** code for this rule 👎

```erb
<%= link_to 'Go to GitHub' %>
```

```erb
<%= link_to 'Go to GitHub', '#' %>
```

### **Correct** code for this rule  👍

```erb
<!-- good -->
<%= link_to 'Go to GitHub', 'https://github.com/' %>
```

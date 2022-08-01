# GitHub/Accessibility/LinkHasHref

## Rule Details

Links should go somewhere, you probably want to use a `<button>` instead.

## Resources

- [`<a>`: The Anchor element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a)
- [Primer: Links](https://primer.style/design/accessibility/links)
- [HTML Spec: The a element](https://html.spec.whatwg.org/multipage/text-level-semantics.html#the-a-element)

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

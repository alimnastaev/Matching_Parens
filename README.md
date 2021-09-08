# Matching Parens

### The Problem<br />
We need to make a function that receives a string as input, supposedly a mathematical expression or some code snippet, and tells us whether all of it's opening parenthesis/brackets/braces have a correct closing match.<br />
Some expressions as examples:

```jason
"1 * 2 (3 + [4 / 5])" -> should return true
"9 / [(8 + 7] - 6)" -> should return false
(check tests for more examples)
```

To run tests from command line: `elixir matching_parens.exs --test`

# bike to html

For use with [Bike Outliner](https://www.hogbaysoftware.com/bike/).

This set of scripts was initially developed by [Jonathan Sterling](https://git.sr.ht/~jonsterling/bike-convertors), however I wanted to
focus more on exporting stylish HTML. Sure you could use a different markdown renderer, but I like being able to swap out the included CSS file on the fly.

[Sakura CSS](https://github.com/oxalorg/sakura/) is included by default.

In addition to adding a style sheet to exported HTML, this version also supports the proper conversion of links to `<a>` tags and inserts code blocks for Bike's row type of the same name.

# system requirements

For macOS:

- The Saxon XSLT processor: `brew install saxon`.
- The Pandoc document convertor: `brew install pandoc`

# converting a Bike outline to HTML

```shell
cat example.bike | ./bike-to-html.sh > output.html && open output.html
```

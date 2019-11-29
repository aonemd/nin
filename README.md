<div align="center">
  <h1>
    nin
  </h1>

  A simple, full-featured command line todo app

  ![nin demo GIF](/demo.gif)
</div>

## Features

- Simple, easy-to-use CLI
- Currently supports: listing, adding, editing, deleting, completing,
  archiving, and deleting archived todo items
- Smart colored output
- Uses YAML for storage by default (There's an option to use TOML but no configuration for it, yet)
- Modular code covered by unit tests

## Installation

```bash
gem install nin
```

To run the tests:

```console
rake
```

## Usage

```console
NAME:
        nin - a simple, full-featured command line todo app

USAGE:
        nin COMMAND [arguments...]

COMMANDS:
        l  [a]         List all unarchived todos. Pass optional argument `a` to list all todos
        a  desc        Add a todo. Prepend due date by an @. Prepend tag by a \#
        e  id desc     Edit a todo. Prepend due date by an @. Prepend tag by a \#
        p  id step     Prioritize a todo by either a positive or negative step within its date group
        c  id(s)       Un/complete todo(s)
        ac id(s)       Un/archive todo(s)
        d  id(s)       Delete todo(s)
        gc             Delete all archived todos. Resets item ids as a side effect
        i              Open nin in REPL mode
        o              Open todo file in $EDITOR
```

## Why

Why write another todo app? I like to use the terminal for everything and I've
been using a markdown file to manage my todo list. I looked for something
simple and I found [Todo.rb](https://gist.github.com/mattsears/1259080) which
`nin` started as a spinoff from. However, I needed to add some more features. I
then found [Todolist](http://todolist.site/) which I took some inspiration from
but kept the CLI as simple as it is in Todo.rb. I also didn't like that
todolist uses JSON to store the todo items because I wanted to view the file on
my phone and I needed something more readable.

## Contribution

Contributions are welcome. If you found a bug or want to add a new feature,
open an issue or send a pull request.

## License

See [LICENSE](https://github.com/aonemd/nin/blob/master/LICENSE).

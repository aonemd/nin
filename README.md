nin
---

A simple, full-featured command line todo app

![nin demo GIF](/demo.gif)

## Installation

```bash
gem install nin
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
        c  id(s)       Un/complete todo(s)
        ac id(s)       Un/archive todo(s)
        d  id(s)       Delete todo(s)
        gc             Delete all archived todos. Resets item ids as a side effect
        o              Open todo file in $EDITOR
```

## Why

Why write another todo app? I like to use the terminal for everything and I've
been using a markdown file to manage my todo list. I looked for something
simple and I found [Todo.rb](https://gist.github.com/mattsears/1259080) which
`nin` started as a spinoff from. However, I needed to add some more features. I
then fonud [Todolist](http://todolist.site/) which I took some inspiration from
but kept the CLI as simple as it is in Todo.rb. I also didn't like that
todolist uses JSON to store the todo items because I wanted to view the file on
my phone and I needed something more readable.

## License

See [LICENSE](https://github.com/aonemd/nin/blob/master/LICENSE).

# Poliglota

A minimalist tool to learn to programming

> Poliglota is a new way to learn new programming languages
> (or patterns/strategies/frameworks...) with already known.
> This tool gives you *flexibility* and *agility*
> to implement new learning projects.

*✨ Powered by [Arturo Programming Language][art] ✨*

## Methodology
The idea is quite simple,
implement learning projects in different languages.
Then, take notes about what you learnt in `notes.md`,
and finally, compare the difference between them
and do different approachs to resolve the same problem/challenge.

## Installation
- Clone this repository
- Have bash on your global path
- Install [Arturo][art] on your global path

> Currently, you need bash since some functions are depending on it.
> It can be changed on future

## Basic Commands

```bash
# create a new project with every template available
$ ./poli new <project>

# add a specific implementation to a project
$ ./poli add <template> <project>

# fill a project with not implemented templates
$ ./poli fill <project>

# get a complete help
$ ./poli --help
```

## Usage

```abnf
 USAGE: poli COMMAND [OPTIONS] [ARGS]...

 Options:
    -h, --help  Show this message and exit
    -v, --version   Show current version

 Commands:
    new      Create a new project
    add      Add an implementation to a project
    fill     Fill a project with missing implementations

 ---------  --------------------

 Usage: poli new [OPTIONS] <project>
        poli new [OPTIONS] {-l|--last}

 Options:
    -e, --empty     project is empty
    -l, --last      uses the last interacted project

 ---------  --------------------

 Usage: poli add [OPTIONS] <template> <project>
        poli add [OPTIONS] <template> {-l|--last}

 Options:
    --as <name>     Create with a new name
    -e, --empty     Implementation is empty
    -l, --last      uses the last interacted project

 ---------  --------------------

 Usage: poli fill <project>
```

[art]: https://arturo-lang.io/

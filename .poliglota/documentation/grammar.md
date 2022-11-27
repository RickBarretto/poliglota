---
author: @RickBarretto
---

# Grammar

This project contains proper expressions.
Then, it's worth noting their meanings and uses
to simplify your comprehension
of what is being said or referred to.

---

- [Base Template](#base-template)
- [Implementations](#implementations)
- [Implementation's Template](#implementations-templates)
- [Main Repository](#main-repository)
- [Plugins](#plugins)
- [Poliglota's Internal Folder](#poliglotas-internal-folder)
- [Project](#project)
- [Root Repository](#root-repository)
- [Template's Folder](#templates-folder)

---

## Root Repository
> Refers to the [root folder][Root]
of Github/Local repository.

Is Where the folders


[`.plugins`][Plugins] [[#1](#plugins)],
[`.poliglota`][Poliglota] [[#2](#poliglotas-internal-folder)],
[`.templates`][Templates] [[#3](#templates-folder)] and
[`repository`][Repo] [[#4](#main-repository)]
are located.

## Main Repository
> Refers to [`repository/` Folder][Root]
> at the [Root Repository](#root-repository).

Is where you'll put your *[Projects](#projects)*


## Project
> Refers to one of your project
> inside of [Main Repository](#main-repository).

Is where you'll add and write your *[Implementations](#implementations)*


## Implementations
> Refers to each implementation of a [Project](#project).

An implementation is a Project rewrite, it can be
in some specific language, framework, code-style, algorithm...
It means, different ways to generate the same result.

With these implementations
you can understand better your distinct tools.

Remember, not only frameworks are tools,
but also languages are.


## Template's Folder
> Refers to [`.templates` folder][Templates]

Is where you'll add your own
[Implementation's Templates](#implementations-template)
based on a [Base Template](#base-template)

## Implementation's Templates
> Refers to templates inside [`.templates` folder][Templates]

Are the templates that will be used to generate your
[Project](#project)'s [Implementations](#implementations).
They are builtin using a [Base Template](#base-template)


## Base Template
> Refers to [`.template/` folder][BaseTemplate]
> inside of [`.templates` folder][Templates].

Is used to generate your new
[Implementation's Templates](#implementations-templates)


## Plugins
> Refers to [`.plugins` folder][Plugins]

Is where additional features are added.

## Poliglota's Internal Folder
> Refers to [`.poliglota` folder][Poliglota]

Is where internal things of this project are placed.

This folder is composed by a
[`documentation` folder][Documentation]
(where is
placed the documentation of this project)
and a [`scripts` folder][Scripts]
(where is placed the commands that powers poli script).

---

> Note:
> This page was ordered by importance.
> But the glossary was ordered alphabetically.

[Root]: https://github.com/RickBarretto/poliglota
[Poliglota]: https://github.com/RickBarretto/poliglota/tree/main/.poliglota/
[Documentation]: https://github.com/RickBarretto/poliglota/tree/main/.poliglota/documentation/
[Scripts]: https://github.com/RickBarretto/poliglota/tree/main/.poliglota/scripts/
[Plugins]: https://github.com/RickBarretto/poliglota/tree/main/.plugins/
[Templates]: https://github.com/RickBarretto/poliglota/tree/main/.templates/
[BaseTemplate]: https://github.com/RickBarretto/poliglota/tree/main/.templates/.template/
[Repo]: https://github.com/RickBarretto/poliglota/tree/main/repository/

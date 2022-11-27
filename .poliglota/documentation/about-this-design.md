---
author: @RickBarretto
---

# About the current design

> This page is to explain design choises for *Poliglota*
> So, if you have some doubt about why I choose A rather than B,
> please, write me an [Issue](https://github.com/RickBarretto/poliglota/issues).

So, as already said in [README](../../README.md),
*Poliglota* is a *minimalist*, *flexible* and *extensible* tool.
So this is what this project must to be.

This way, Poli have just a [minimal template](../../.templates/.template/)
used to generate user's templates.

Remember, [Everything can be modified](custom-poliglota.md)

## Why poli script doesn't have a extension
So, as you can see, we have a [`poli` file](../../poli)
at the root of this repository.
And it doesn't have a `.sh` extension.
It's just a design choice to simplify the use.

So you can just rename and add a `.sh` if you want. (But it's unnecessary)
As well as you can copy `poli` to some place in your system's `$PATH`,
so you wouldn't need to write `./` to call the script.

> [!NOTE]
> But remember poli should run only in this repository.
> So be careful if you decide to do it.
> Since poli will copy templates and place into a repository folder.

## The differences between .plugins and scripts folders
You can put your own code inside .poliglota/scripts/ if you want to.
But, by default, .poliglota folder is for internal code.
That you should not change. **But you can!**

**It'll help you to don't mess the project or inject a accidental bug.**

So, for personal modifications,
you should use [`.plugins/ folder`](../../.plugins).

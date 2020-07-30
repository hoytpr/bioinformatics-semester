---
layout: page
title: Special Characters
---

In pattern matching, you can to protect special characters with backslashes. Letters, digits and non-ASCII characters never need backslashes.

Here is a list of characters that may need to be escaped when using a typical shell (ksh, bash or zsh).

`!`  history expansion.

`"`  shell syntax.

`#`  comment start when preceded by whitespace; zsh wildcards.

`$`  shell syntax.

`&`  shell syntax.

`'`  shell syntax.

`(`  even in the middle of a word.

`)` \(see `(`\)

`*`  shell wildcard.

`,`  only inside brace expansion.

`;`  shell syntax.

`<`  shell syntax.

`=`  in zsh, when it's at the beginning of a file name.

`>`  shell syntax.

`?`  shell wildcard.

`[`  shell wildcard.

`\`  shell syntax 'escape' character.

`]`  you might get away with leaving it unquoted.

`^`  history expansion; zsh wildcard.

<code>`</code>  shell syntax.

`{`  brace expansion.

`|`  shell syntax.

`}`  needs to be escaped in zsh, other shells are more lenient.

`~`  home directory expansion


A few more characters can require special handling sometimes:

**`-` isn't special for the shell, but when it's at the beginning of a command argument, it indicates an option**. It can't be protected with quotes since the special handling is in the command, not in the shell.

`.` isn't special in itself, but dot files are excluded from `*` expansions by default.

`:` isn't special for the shell, but some commands parse it specially, e.g. to indicate a remote file (hostname:filename). 

\* This page is derived from a post on [Stack Exchange](https://unix.stackexchange.com/questions/347332/what-characters-need-to-be-escaped-in-files-without-quotes).


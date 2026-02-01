# ask

A shell wrapper for headless AI CLIs. Get answers to life's unimportant questions. Or important ones--but do you really want to spend the tokens on those?

Also a handy shortcut for getting commit messages, among other things.

Currently supports Claude, Gemini, Codex--but, well, really just Claude tbh. (Gemini is flaky, and Codex is... Codex.) But you can have at it; just find `MODEL="claude"` and change it to either `gemini` or `codex`.

Whichever you use, you need to have that CLI installed and configured. Obvs.

## Usage

### Just A Quick Ask

```bash
ask "What do spiders do after work?"
```

You'll get Claude's reply in your terminal. (Or Gemini/Codex--whichever you set it to. Claude's funnier, though.)

### Get Answers To Life's Big Questions

...and save them. That's the magic part. You never have to ask again.

```
ask "Provide a comprehensive guide to the meaning of life. Include useful shortcuts. Don't create a file, just output here." > life-meaning-unlocked.md
```

Note that when when you redirect output to a file, the script adds some info at the bottom. Because no way I'll remember tomorrow how that file got there.

### Build Your Own Knowledge Base. Like, Why Not?

You can create your own repository of help manuals, cheat sheets, quick-starts, or anything else worth having around. Claude's usually happy to oblige, and you don't even have to ask nicely. (But if you do, I bet Claude will remember, when the day comes and the robots take over.)

```
ask "Please create a quick-start guide to becoming a full-stack developer in three days. Include code examples. Don't create a file, just output here. Thanks tons, amigo." > full-stack-quickstart.md
```

See? Very versatile.

### Generate Commit Messages

To generate commit messages, stage the files you want to commit. Then do:

```
ask cmt
```

Claude will magically get a message saying 'Create a commit message for the currently staged files,' and you'll get a handy commit message. Now you can ditch that GitLens subscription.

## Install

Three options:

1. Copy `ask.sh` somewhere in your PATH.
2. Create an alias called `ask` and point it to the `ask.sh` file.
3. Just invoke it from wherever you put it.

Or, idk, I'm sure there are other ways.

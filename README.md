# ask

A shell wrapper for headless AI CLIs. Get answers to life's important questions. Or unimportant ones--hey, they're your tokens.

Also a handy shortcut for getting commit messages, among other things.

Currently supports Claude, Gemini, Codex and Copilot. Works cleanest with Claude, which is the default. To change the default, find `MODEL="claude"` and change it to a different model.

Whichever you use, you need to have that CLI installed and configured. Obvs.

## Usage

### Just A Quick Ask

```bash
ask "What do spiders do after work?"
```

You'll get the model's reply in your terminal, unless you redirected to a file. If redirected to a file, the file will include a standard template, with the date created and the original question at the bottom.

### Get Answers To Life's Big Questions

...and save them. That's the magic part. You never have to ask again.

```
ask "Provide a comprehensive guide to the meaning of life. Include useful shortcuts. Don't create a file, just output here." > life-meaning-unlocked.md
```

### Build Your Own Knowledge Base

Create your own repo of help manuals, cheat sheets, quick-starts, comprehensive guides, or anything else worth having around.

```
ask gemini "Please create a quick-start guide to becoming a full-stack developer in 24 hours. Include code examples. Don't create a file, just output here. Thanks tons, amigo." > full-stack-quickstart.md
```

### Generate Commit Messages

To generate commit messages, stage the files you want to commit, and simply type use the "cmt" shortcut, which gets expanded to a commit message request.

```
ask cmt
```

The model will get a request to create a commit message for the currently staged files.

## Install

Three options:

1. Copy `ask.sh` somewhere in your PATH.
2. Create an alias called `ask` and point it to the `ask.sh` file.
3. Just invoke it from wherever you put it.

Or, idk, I'm sure there are other ways.

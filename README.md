# Zas

This is a slightly modified version of [zas](https://github.com/juanibiapina/zas) which maps to `.local` TLD instead of `.dev`.

Current implementation is not fully functional as you still need to add your `[domain].local` entry to `/etc/hosts` -- which makes it useful only for the port forwarding mapping of `app.toml`.

## Installation

After properly setting up your [Rust](https://doc.rust-lang.org/book/first-edition/getting-started.html#installing-rust-1) environment:

```bash
$ ./install.sh
```

To uninstall, run:

```bash
$ ./uninstall.sh
```

Sudo is required in order to setup the dns and port forwarding rules.

Remember to add your `~/.config/zas/apps.toml` domains to `/etc/hosts`, e.g.:

```toml
# ~/.config/zas/apps.toml
app_name = 3000
```

```bash
# /etc/hosts

# ...

127.0.0.1       app_name.local
```

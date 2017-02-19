# risk-calc

This is a graphical application for simulating battles in the game [Risk](https://en.wikipedia.org/wiki/Risk_%28game%29). Enter the number of attackers on the right, number of defenders on the left, and press the `Fight` button to simulate one round of battle. The attacker and defender counts will be updated according to their losses, allowing the next round to be simulated by pressing the button again.

## Screenshots

Maybe some day.

# Installation

## Prebuilt Binaries

Maybe I'll compile some. Windows users shouldn't hold their breath.

## Compile it Yourself

### Dependencies

* Crystal  
    For instructions on how to install [Crystal](https://crystal-lang.org/) for your operating system of choice, visit <https://crystal-lang.org/docs/installation/index.html>.
* libui  
    Installation instructions are available at <https://github.com/andlabs/libui#installation>.  
    At the time of writing (2017-2-19) installation is a pain on anything but Arch Linux. If building and installing a library manually sounds like a bad time, you can install the unrelated [libui-node](https://www.npmjs.com/package/libui-node) with [npm](https://www.npmjs.com). libui-node provides bindings to use libui with nodejs, but also installs a compiled libui.

This project also depends on libui

### Process

```sh
git clone https://github.com/idle-zealot/risk-calc.git
cd risk-calc
crystal deps
crystal build src/risk-calc.cr
```

# Usage

Run the binary generated at installation.
It should be located in the root of the project directory and named `risk-calc`.

# Contributing

I have no idea why you would want to, but if the desire strikes:

1. Fork it ( <https://github.com/idle-zealot/risk-calc/fork> )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

# Contributors

- [idle-zealot](https://github.com/[your-github-name]) Braeden Mollot - creator, maintainer

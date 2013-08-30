## Getting Started

1. Install either Xcode (with command line tools) or [Xcode Command Line Tools](http://docwiki.embarcadero.com/RADStudio/XE4/en/Installing_the_Xcode_Command_Line_Tools_on_a_Mac).

2. Ensure the OSX login account is `dev`. Note that our github user account is `sppdev`.

3. Run the following:

  ```
    sudo mkdir -p /opt/boxen
    sudo chown $USER:admin /opt/boxen
    mkdir -p ~/projects
    cd ~/projects
    git clone https://github.com/lonelyplanet/spp_boxen.git
    cd spp_boxen
  ```

  NB: Our install scripts often timeout when cloning repositories for the first time.
  It's much quicker to rsync from another pairing station:
    ```
    $ cd $HOME/projects
    $ rsync -r dev@devmac-4:projects/atlas .
    $ rsync -r dev@devmac-4:projects/deployment_tools .
    $ rsync -r dev@devmac-4:projects/lpos-chef-repo .
    $ rsync -r dev@devmac-4:projects/pairing_station .
    $ rsync -r dev@devmac-4:projects/remixer .
    $ rsync -r dev@devmac-4:projects/spp_aws .
    $ rsync -r dev@devmac-4:projects/spp_boxen .
    ```

  NB: When the boxen script prompts for username, **provide sppdev** (because this is our git user account).

4. Run:
```
  ./script/boxen
```

Open a new terminal, `./script/boxen --env` to confirm.

You may want to reboot.

To finish, follow the manual steps described within [TODO](TODO.md).

#-
## Other Stuff


### Personal Manifests

Our Boxen repo is setup to run with the GitHub user `sppdev`. If you want to run a personalized setup then create a puppet file for yourself under modules/people. Use `mriddle.pp` as an example.

Per-user manifests live in `modules/people/manifests/$login.pp`, where
`$login` is a GitHub login. A simple user manifest example:

```puppet
class people::jbarnette {
  include emacs   # requires emacs module in Puppetfile
  include sparrow # requires sparrow module in Puppetfile

  $home     = "/Users/${::luser}"
  $my       = "${home}/my"
  $dotfiles = "${my}/dotfiles"

  repository { $dotfiles:
    source  => 'jbarnette/dotfiles',
    require => File[$my]
  }
}
```

### Projects

While you _can_ include projects one by one, sometimes you might just want
all of them. You can do this easily with:

```
include projects::all
```


### Customizing

You can always check out the number of existing modules we already
provide as optional installs under the
[boxen organization](https://github.com/boxen). These modules are all
tested to be compatible with Boxen. Use the `Puppetfile` to pull them
in dependencies automatically whenever `boxen` is run.

### Including boxen modules from github (boxen/puppet-<name>)

You must add the github information for your added Puppet module into your Puppetfile at the root of your
boxen repo (ex. /path/to/your-boxen/Puppetfile):

    # Core modules for a basic development environment. You can replace
    # some/most of these if you want, but it's not recommended.

    github "dnsmasq",  "1.0.0"
    github "gcc",      "1.0.0"
    github "git",      "1.0.0"
    github "homebrew", "1.0.0"
    github "hub",      "1.0.0"
    github "inifile",  "0.9.0", :repo => "cprice-puppet/puppetlabs-inifile"
    github "nginx",    "1.0.0"
    github "nodejs",   "1.0.0"
    github "nvm",      "1.0.0"
    github "ruby",     "1.0.0"
    github "stdlib",   "3.0.0", :repo => "puppetlabs/puppetlabs-stdlib"
    github "sudo",     "1.0.0"

    # Optional/custom modules. There are tons available at
    # https://github.com/boxen.

In the above snippet of a customized Puppetfile, the bottom line
includes the sudo module from Github using the tag "1.0.0" from the github repository
"boxen/sudo".  The function "github" is defined at the top of the Puppetfile
and takes the name of the module, the version, and optional repo location:

    def github(name, version, options = nil)
      options ||= {}
      options[:repo] ||= "boxen/puppet-#{name}"
      mod name, version, :github_tarball => options[:repo]
    end

Now Puppet knows where to download the module from when you include it in your site.pp or mypersonal.pp file:

    # include the ruby module referenced in my Puppetfile with the line
    # github "ruby",     "1.0.0"
    include ruby

### Node definitions

Puppet has the concept of a
['node'](http://docs.puppetlabs.com/references/glossary.html#agent),
which is essentially the machine on which Puppet is running. Puppet looks for
[node definitions](http://docs.puppetlabs.com/learning/agent_master_basic.html#node-definitions)
in the `manifests/site.pp` file in the Boxen repo. You'll see a default node
declaration that looks like the following:

``` puppet
node default {
  # core modules, needed for most things
  include dnsmasq

  # more...
}
```

### How Boxen interacts with Puppet

Boxen runs everything declared in `manifests/site.pp` by default.
But just like any other source code, throwing all your work into one massive
file is going to be difficult to work with. Instead, we recommend you
use modules in the `Puppetfile` when you can and make new modules
in the `modules/` directory when you can't. Then add `include $modulename`
for each new module in `manifests/site.pp` to include them.
One pattern that's very common is to create a module for your organization
(e.g., `modules/github`) and put an environment class in that module
to include all of the modules your organization wants to install for
everyone by default. An example of this might look like so:

``` puppet
# modules/github/manifests/environment.pp

 class github::environment {
   include github::apps::mac

   include ruby::1-8-7

   include projects::super-top-secret-project
 }
 ```

 If you'd like to read more about how Puppet works, we recommend
 checking out [the official documentation](http://docs.puppetlabs.com/)
 for:

 * [Modules](http://docs.puppetlabs.com/learning/modules1.html#modules)
 * [Classes](http://docs.puppetlabs.com/learning/modules1.html#classes)
 * [Defined Types](http://docs.puppetlabs.com/learning/definedtypes.html)
 * [Facts](http://docs.puppetlabs.com/guides/custom_facts.html)

### Creating a project module

See [the documentation in the
`modules/projects`](modules/projects/README.md)
directory for creating organization projects (i.e., repositories that people
will be working in).

### Binary packages

We support binary packaging for everything in Homebrew, RBEnv, and NVM.
See `config/boxen.rb` for the environment variables to define.

### Halp!

Use Issues or #boxen on irc.freenode.net.

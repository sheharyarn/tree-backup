tree-backup
===========

> Background job that continously backs up 'trees'
> of specified Volume paths locally

![Tree Backup Screenshot][screenshot]


## Setup

Commands assume OSX and username of `Psy`:

```bash
# Install GNU `tree` binary:
brew install tree

# Clone repo
git clone git@github.com:sheharyarn/tree-backup.git ~/code/ruby/tree

# Make executable
sudo chmod a+x ~/code/ruby/tree/tree.rb

# Create directory for trees & logs
mkdir -p ~/.trees/

# Link Configs
ln -s ~/code/ruby/tree/config.yml ~/.trees/config.yml

# Link launchd plist
ln -s ~/code/ruby/tree/me.sheharyar.scripts.tree.plist ~/Library/LaunchAgents/

# Load service
launchctl load -w ~/Library/LaunchAgents/me.sheharyar.scripts.tree.plist
```

#### Dropbox Sync

```bash
# Initial Move
mv ~/.trees/ ~/Dropbox/Other\ Stuff/.trees/

# Create Shortcut
ln -s ~/Dropbox/Other\ Stuff/.trees ~/.trees
```



  [screenshot]: https://i.imgur.com/ZaxZi3R.png


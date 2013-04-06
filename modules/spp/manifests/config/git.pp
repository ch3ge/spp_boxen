class config::git {

  package { "edgecase-git-pair":
    provider => "gem",
  }

  git::config::global{ 'color.ui':
    value => 'auto',
  }

  git::config::global{ 'push.default':
    value => 'simple',
  }

  git::config::global{ 'core.editor':
    value => 'subl -w',
  }

  define add_git_pair ($user_details = $title) {
    exec {"Add ${user_details} git pair":
      command => "git config --global --add git-pair.authors \"${user_details}\"",
      unless => "grep -c \"${user_details}\" /Users/${::luser}/.gitconfig"
    }
  }

  add_git_pair{"Jonathan Ricketson <jonathanr@lonelyplanet.com.au>":}
  add_git_pair{"Duncan Warnock <duncan.warnock@lonelyplanet.com.au>":}
  add_git_pair{"David Hodges <david.hodges@lonelyplanet.com.au>":}
  add_git_pair{"Matt Riddle <matthew.riddle@lonelyplanet.com.au>":}
  add_git_pair{"Adel Smee <adel.smee@lonelyplanet.com.au>":}
  add_git_pair{"James Holmes <james.holmes@lonelyplanet.com.au>":}
  add_git_pair{"Ben Galvin <ben.galvin@lonelyplanet.com.au>":}
  add_git_pair{"Tim Moore <tim.moore@lonelyplanet.com.au>":}

}

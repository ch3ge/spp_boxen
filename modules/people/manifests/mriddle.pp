class people::mriddle {

  include spp::applications
  include spp::config

  include projects::atlas
  include projects::remixer

  include people::mriddle::repositories
  include people::mriddle::applications
  include people::mriddle::config

}

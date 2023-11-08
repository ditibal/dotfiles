# :wrench: .dotfiles



unschedule
resticprofile -c dotfiles/config/resticprofile/profiles.yaml -n full unschedule


schedule
resticprofile -c dotfiles/config/resticprofile/profiles.yaml -n full schedule


dry-run
resticprofile -c ~/dotfiles/config/resticprofile/profiles.yaml --dry-run --name full backup

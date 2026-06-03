#!/usr/bin/env nu

$env.NU_LOG_LEVEL = "debug"

def command-exists [name: string] {
  not (which $name | is-empty)
}

def log [tag: string, message: string] {
  print $"[($tag)] ($message)"
}

def darwin [] {
  if not (command-exists brew) {
    print --stderr "brew is not installed: install from https://brew.sh/"
    exit 1
  }

  brew install --cask font-monaspace-nf font-fira-code-nerd-font font-noto-sans
  print "Fonts installed"
}

def linux [] {
  let log_tag = "Fonts"
  if not (command-exists git) {
    print --stderr "git is not installed"
    exit 1
  }

  if not (command-exists unzip) {
    print --stderr "unzip is not installed"
    exit 1
  }

  let tmp_dir = "./tmp" | path expand
  rm -rf $tmp_dir
  mkdir $tmp_dir

  let fonts_dir = $env.HOME | path join ".local/share/fonts"
  log $log_tag $"Creating ($fonts_dir) if it doesn't already exist"
  mkdir $fonts_dir

  let tag = 1024

  let fira_code_job = job spawn {
    let job_tag = $"($log_tag) Fira Code"

    try {
      let archive = $tmp_dir | path join "FiraCode.zip"

      log $job_tag "Downloading Fira Code Font"
      ^curl -L --progress-bar -o $archive "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip"

      log $job_tag "Extracting archive"
      mkdir $"($fonts_dir)/Fira Code Nerd Font"
      unzip -o $archive -d $tmp_dir

      log $job_tag "Installing Fira Code Nerd Fonts"
      cp ($"($tmp_dir)/**/FiraCode*.ttf" | into glob) $"($fonts_dir)/Fira Code Nerd Font/"

      log $job_tag "Cleaning up archive"
      rm $archive

      log $job_tag "Done"
    } catch {|err|
      log $job_tag $"Failed: ($err.msg)"
    }

    $job_tag | job send 0 --tag $tag
  }

  let monaspace_job = job spawn {
    let job_tag = $"($log_tag) Monaspace"

    try {
      let archive = $tmp_dir | path join "Monaspace.zip"

      log $job_tag "Finding correct Monaspace archive URL"

      mut assets = []

      let token: string = $env.GITHUB_TOKEN? | default ''

      try {
        if ($token | is-empty ) {
          $assets = ^curl -L https://api.github.com/repos/githubnext/monaspace/releases
          | from json
          | get 0.assets
        } else {
          $assets = ^curl -L https://api.github.com/repos/githubnext/monaspace/releases -H "Authorization: Bearer $token"
          | from json
          | get 0.assets
        }
      } catch {|err|
        error make { msg: $"Got rate limited", inner: [$err] }
      }

      let archive_url = $assets
      | where $it.name like 'monaspace-nerdfonts-(.+)\.zip'
      | get 0.browser_download_url

      log $job_tag $"Downloading Monaspace archive from ($archive_url)"

      log $job_tag "Downloading font archive"
      ^curl -L --progress-bar -o $archive $archive_url

      log $job_tag "Extracting archive"
      unzip -o $archive -d $tmp_dir

      mkdir $"($fonts_dir)/Monaspace/"

      log $job_tag $"Installing Monaspace fonts"
      cp ($"($tmp_dir)/NerdFonts/**/*.otf" | into glob) $"($fonts_dir)/Monaspace/"

      log $job_tag "Cleaning up archive"
      rm $archive

      log $job_tag "Done"
    } catch {|err|
      log $job_tag $"Failed: ($err)"
    }

    $job_tag | job send 0 --tag $tag
  }

  # let avenir_job = job spawn {
  #   let job_tag = $"($log_tag) Avenir"

  #   try {
  #     let archive = $tmp_dir | path join "Avenir.zip"

  #     log $job_tag "Downloading font archive"
  #     ^curl -L --progress-bar -o $archive "https://github.com/platanus/fonts/archive/refs/heads/master.zip"

  #     log $job_tag "Extracting archive"
  #     unzip -o $archive -d $tmp_dir

  #     mkdir $"($fonts_dir)/Avenir"

  #     log $job_tag "Installing Avenir ttf fonts"
  #     cp ($"($tmp_dir)/fonts-*/Avenir/*.ttf" | into glob)  $"($fonts_dir)/Avenir/"

  #     log $job_tag "Cleaning up archive"
  #     rm $archive

  #     log $job_tag "Done"
  #   } catch {|err|
  #     log $job_tag $"Failed: ($err.msg)"
  #   }

  #   $job_tag | job send 0 --tag $tag
  # }

  # let download_jobs = [$fira_code_job $monaspace_job $avenir_job]
  let download_jobs = [$fira_code_job $monaspace_job]

  mut jobs = job list | where $it.id in $download_jobs
  loop {
    $jobs = job list | where $it.id in $download_jobs

    if ($jobs | is-empty) {
      break
    }

    sleep 1sec
    log $log_tag $"Waiting for ($jobs | length) jobs"
  }

  try {
    log $log_tag "Refreshing font cache"
    ^fc-cache -f
    log $log_tag "Fonts installed"
  } catch {|err|
    log $log_tag $"Refreshing font cache failed: ($err.msg)"
  } finally {
    rm -rf $tmp_dir
  }
}

match $nu.os-info.name {
  "macos" => { darwin },
  "linux" => { linux },
  _ => { print --stderr $"Unsupported OS: ($nu.os-info.name)"; exit 1 },
}

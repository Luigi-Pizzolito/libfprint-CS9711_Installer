# libfprint-CS9711 Installer
Install script for [libfprint-CS9711](https://github.com/ericlinagora/libfprint-CS9711) fork of libfprint supporting ChipSailling USB fingerprint readers.

## Upstream Merge Tracker
See https://gitlab.freedesktop.org/libfprint/libfprint/-/issues/610

## Install Script
Run `./install.sh`.

Tested on Fedora 40 with GNOME.

## Manual Install Guide
Install `rpm`, `fprintd`, `udevrule` and `printd-pam`.

Step 1: Install `libfprint` from your repo

Step 2: Install `fprint` from source

Remember to restart the system

Step 3: For some reason the fprint.service failed to start due to: `/usr/local/libexec/fprintd: error while loading shared libraries: libfprint-2.so.2: cannot open shared object file: No such file or directory`

So we are going to add it, copy the file `libfprint-2.so.2` from `/usr/local/lib64` to `/usr/local/lib` Add `/usr/local/lib` to `/etc/ld.so.conf.d/fprint.conf`

You can run `ldconfig -p | grep libfprint-2.so.2` to verify, the output should be something like this: `libfprint-2.so.2 (libc6,x86-64) => /usr/local/lib/libfprint-2.so.2`

Step 4: run `sudo ldconfig` to reload the new configuration

Step 5: `systemctl start fprintd.service`

Optional: To start fprint.service at boot, add the following to the end of the file `/usr/lib/systemd/system/fprintd.service`:

```
[Install]
WantedBy=multi-user.target
```

Then: `systemctl enable fprintd.service`

Step 6: Enable fingerprint auth
`sudo authselect enable-feature with-fingerprint`

<br />

# Original `README.md` left below
<hr />


# Proposal fork for support of Chipsailing CS9711Fingprint

This fork of [libfprint](https://gitlab.freedesktop.org/libfprint/libfprint) is a proposal for the [Chipsailing CS9711](http://www.chipsailing.com/ProductsStd_250.html) fingerprint reader, tracked in this [issue](https://gitlab.freedesktop.org/libfprint/libfprint/-/issues/610). This reader is commonly in accessible USB dongles as `2541:0236`, and also the one included in the GPD Win Max 2 2023 as `2541:9711`.

Note that enrollment count is 15 touches, so insist a bit.

Note also that this is based on an experimental image recognition from the [`sigfm`](https://gitlab.freedesktop.org/libfprint/libfprint/-/merge_requests/418) proposal.

**No garantees are made by this author as to the validity and security of this code,
while this author is very happy with the result, it should not be used for anything
serious without serious testing.**

## Nix

```nix
  services.fprintd.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      libfprint = prev.libfprint.overrideAttrs (oldAttrs: {
        version = "git";
        src = final.fetchFromGitHub {
          owner = "ericlinagora";
          repo = "libfprint-CS9711";
          rev = "c242a40fcc51aec5b57d877bdf3edfe8cb4883fd";
          sha256 = "sha256-WFq8sNitwhOOS3eO8V35EMs+FA73pbILRP0JoW/UR80=";
        };
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
          final.opencv
          final.cmake
          final.doctest
        ];
      });
    })
  ];
```

# Original Original `README.md` left below
<hr />

<div align="center">

# LibFPrint

*LibFPrint is part of the **[FPrint][Website]** project.*

<br/>

[![Button Website]][Website]
[![Button Documentation]][Documentation]

[![Button Supported]][Supported]
[![Button Unsupported]][Unsupported]

[![Button Contribute]][Contribute]
[![Button Contributors]][Contributors]

</div>

## History

**LibFPrint** was originally developed as part of an
academic project at the **[University Of Manchester]**.

It aimed to hide the differences between consumer
fingerprint scanners and provide a single uniform
API to application developers.

## Goal

The ultimate goal of the **FPrint** project is to make
fingerprint scanners widely and easily usable under
common Linux environments.

## License

`Section 6` of the license states that for compiled works that use
this library, such works must include **LibFPrint** copyright notices
alongside the copyright notices for the other parts of the work.

**LibFPrint** includes code from **NIST's** **[NBIS]** software distribution.

We include **Bozorth3** from the **[US Export Controlled]**
distribution, which we have determined to be fine
being shipped in an open source project.

<br/>

<div align="right">

[![Badge License]][License]

</div>


<!----------------------------------------------------------------------------->

[Documentation]: https://fprint.freedesktop.org/libfprint-dev/
[Contributors]: https://gitlab.freedesktop.org/libfprint/libfprint/-/graphs/master
[Unsupported]: https://gitlab.freedesktop.org/libfprint/wiki/-/wikis/Unsupported-Devices
[Supported]: https://fprint.freedesktop.org/supported-devices.html
[Website]: https://fprint.freedesktop.org/

[Contribute]: ./HACKING.md
[License]: ./COPYING

[University Of Manchester]: https://www.manchester.ac.uk/
[US Export Controlled]: https://fprint.freedesktop.org/us-export-control.html
[NBIS]: http://fingerprint.nist.gov/NBIS/index.html


<!---------------------------------[ Badges ]---------------------------------->

[Badge License]: https://img.shields.io/badge/License-LGPL2.1-015d93.svg?style=for-the-badge&labelColor=blue


<!---------------------------------[ Buttons ]--------------------------------->

[Button Documentation]: https://img.shields.io/badge/Documentation-04ACE6?style=for-the-badge&logoColor=white&logo=BookStack
[Button Contributors]: https://img.shields.io/badge/Contributors-FF4F8B?style=for-the-badge&logoColor=white&logo=ActiGraph
[Button Unsupported]: https://img.shields.io/badge/Unsupported_Devices-EF2D5E?style=for-the-badge&logoColor=white&logo=AdBlock
[Button Contribute]: https://img.shields.io/badge/Contribute-66459B?style=for-the-badge&logoColor=white&logo=Git
[Button Supported]: https://img.shields.io/badge/Supported_Devices-428813?style=for-the-badge&logoColor=white&logo=AdGuard
[Button Website]: https://img.shields.io/badge/Homepage-3B80AE?style=for-the-badge&logoColor=white&logo=freedesktopDotOrg

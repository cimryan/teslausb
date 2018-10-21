# Flashable image to get started more quick

# This is a WORK IN PROGRESS, NOT CURRENTLY WORKING. 

For now the image creation work is at:
* Modified pi-gen [rtgoodwin's fork of pi-gen](https://github.com/rtgoodwin/pi-gen) in (whatever current branch I'm working at the time). 
* `headless-patch` branch of [https://github.com/rtgoodwin/teslausb](https://github.com/rtgoodwin/teslausb)

## Notes 

* Assumes your Pi comes up on Wifi, with internet access. (But so does most of this guide.) USB networking still enabled for troubleshooting.
* I moved all script downloads and variable creation to the initial setup. At this point, I'm designing it to pull the setup scripts dynamically, since development is still ongoing. If/when we reach a good frozen state, we can generate an image that is ready to run. I think it'll also be pretty tricky to do some of the remounting and creating the backing files etc. on the image creation side. Open to suggestions/contributions there though!
* The archive server might not be reachable during the first boot during setup, ex. if building the card somewhere away from the archive server location. So I no longer fail on it not being reachable. 

## Building the Pi

WORK IN PROGRESS BUT MOSTLY RIGHT

1. Flash the image from: XXXXXXXX
1. Mount the card again, and in the `boot` directory create a `teslausb_setup_variables.conf` file to export the same environment varibles normally needed for setup (including archive, Wifi, and push notifications (if desired).) See the main README for these instructions for now. 
1. Run the `setup-piForHeadlessBuild.sh` (note: **not** `setup-piForHeadlessSetup.sh`):
`curl https://raw.githubusercontent.com/rtgoodwin/teslausb/headless-patch/headless-scripts/setup-piForHeadlessBuild.sh -o setup-piForHeadlessBuild.sh`
`chmod +x setup-piForHeadlessBuild.sh`
`./setup-piForHeadlessBuild.sh .`
1. If all goes well, put card into Pi and boot. 

* A `/boot/teslausb-headless-setup.log` file will be created and stages logged. This takes the place of the "STOP" commands 
* Marker files will be created in `boot` like `TESLA_USB_SETUP_STARTED` and `TESLA_USB_SETUP_FINISHED` to track progress. May use a progress system so the script can pick back up if needed. (This is probably useful for the general/old way of setup too.)
* The Pi LED will flash patterns as it gets to each stage (labeled in the setup-teslausb-headless script). 
  * 10 flashes means setup failed!


#### Modifications to pi-gen builder from master

Built image on a Raspi running Stretch, for maximum Pi-ception. 

1. Add SKIP and SKIP_IMAGES files to stage3, 4, and 5 (if present). 
1. Add a stage6. (There are stages0-5, but may be a stage5 in some cases. This will help keep a clean merge later.)
1. Copy the prerun.sh from `stage2`. Be SURE to mark `chmod +x` it. 
1. Remove or rename the EXPORT_NOOBS files in all stages. We don't need a NOOBS image built. 
1. In `stage6`, create a `00-tweaks` folder, with a `00-patches` folder and patch inside to patch `cmdline.txt` to remove the resize and add the needed modules. The build process uses `quilt` for patching. Note: the path for any patching you do at this stage is `stage6/rootfs/FILEPATH` where `rootfs` represents the Pi's `/`. So, `cmdline.txt` is `stage6/rootfs/boot/cmdline.txt`.
1. Add a patch for the `config.txt` file.
1. Add a file called `series` in the patches directory with the name of each `.diff` file in the order you want them applied.
1. Add a `files` folder in stage6 with modified `rc.local`. The modified `rc.local` will handle pulling down the `setup-teslausb-headless` file the first time. (Still working on build logic here.) Files are moved into final locations in a `00-run.sh` script and the `install` command. See the script for details. 
1. (Yes at this point you could suggest that just putting the end state files in place instead of patching would be good, but why not be idiomatic? :)  )
1. Add a script to flash LEDs
1. Run `sudo ./build.sh` from the `pi-gen` directory.
1. If you get a failure, it's almost certainly after stage2, so you can add SKIP files in stage2-stage5 present) and rerun `sudo CLEAN=1 ./build.sh`

### Image creation TODOs
1. TODO: Patch the hostname to teslausb
1. TODO: I still see some errors during pi-gen about locale, may need to be fixed? stage0/01-locale/debconf en_US.UTF-8
1. Aspirational TODO: Remove more packages etc to make the boot process faster? OR start from `stage1` if we don't need all of `stage2`


# AcornMiner-Tribus

## Compatible devices

Squirrels Research Labs Acorn CLE-215+
Squirrels Research Labs Acorn CLE-215
Squirrels Research Labs Acorn CLE-101

## Prerequisites

	- Driver available at http://www.squirrelsresearch.com/get-started-acorn/
	- PCIe capable M.2 slot(s) (preferably with high power design)

## First steps

If testing for the first time, just launch start.bat / start.sh to make sure you are running the miner with known good parameters. The miner will attempt to flash all compatible devices, then a power cycle (power off, wait, power on) is needed after flashing. The flashed devices will be ready for mining after that.

The example clock should work on most hardware, but the miner is very resource intensive, therefore adequate cooling is required for reaching optimal performance.
Basic cooling requirements:
	* Proper airflow usually provided by the host case. Devices placed between GPUs with no or barely any airflow may throttle even on medium clocks.
	* Extra VRM heatsink is required for higher clocks. It is also recommended to ensure satisfying lifetime of the device even on medium clocks.

The annotated start file is easy to modify to start mining on the desired pool to the user's own wallet address. It is recommended to verify correct operation by choosing a unique workername and mining to the example pool to compare the hashrate reported by the pool and the miner and compare them. At the time of the writing of this document, the example pool provided was working properly, while some other pools were reporting unreasonably low hashrates, but keep in mind that this can change over time.

## Usage

### Behavior

	1. Checks all the available devices, flashes the compatible ones which are not running the targeted bitstream.
	2. Loads the configuration file if present. Overrides configured clocks if a value is provided in command line parameters.
	3. Begins to work with all devices which were ready at the time of initial check.

Misbehaving devices may crash, which leads to them being disabled. The miner currently does not attempt crash recovery as it usually does not happen in normal conditions. Manual crash recovery may range from simply restarting the miner to power cycling.

The miner expects to be stopped by pressing `q` as simply closing the window on Windows kills the process. Proper shutdown allows it to gracefully stop the devices and save the current state which will be reloaded on the next run.

Stats are displayed periodically with differences compared to previous stats shown in parentheses. As the miner generates an internal target to continuously verify the correct operation of the devices, found share counters are only good for making sure the devices actually operate, and are not related to the difficulty set and therefore shares expected from the pool.

### Supported control keys

	- `q` gracefully stops devices and exits
	- `1`-`9` selects the appropriate worker to be targeted by commands
	- `a` selects all workers to be targeted by commands
	- `-` decreases the clock of targeted worker(s)
	- `+` increases the clock of targeted worker(s)

### Control keys with experimental features

	- `e` enables the targeted worker(s)
	- `d` disables the targeted worker(s)
	- `t` enables the tuning of targeted worker(s) for the highest stable clock. Not recommended to use without supervision
	- `i` helps identifying the targeted worker(s)

## Tuning consideration

Tuning should always target worst-case conditions within the environment. Barely passing parameters found at low temperatures will fail at higher temperatures.

Overclocking too high can lead to permanent corruption, which can be only fixed by reloading the bitstream usually done by the devices at reboot, therefore the target clock should be preferably chosen not to generate invalid shares at all. Setting a high clock target and relying on throttling for clock control may result in too high clocks when the temperature drops.

If corruption is suspected, it is useful to lower the clock to a known good, usually low frequency. If the flow of invalid shares doesn't stop shortly, it's recommended to reload the bitstream (usually reboot is enough for Acorns).

The possibility of corruption is also one of the reasons why auto tuning will not be recommended any soon. If it corrupts the bitstream even just slightly, the tuning algorithm will keep on lowering the clock due to the constant flow of invalid shares, even if rare. It may be used to find roughly the maximum clocks with very low effort either with supervision or logging, then the found values can be reduced by an appropriate safety margin to be used as manually set clocks for normal usage after bitstream reloading. Due to the mentioned issue and other disadvantages like slow operation, most users will likely want to use manual tuning instead for now.

The candle that burns twice as bright burns half as long. Actually significantly less than half for electronic devices, degradation doesn't punish in a linear fashion. Going for the highest possible performance in the short term with no consideration to the well-being of components will result in a lower performance in the long term.

## Common issues

	- Device is missing:
		- Freshly flashed device was not power cycled. Just rebooting is not enough.
		- The device has crashed, may need either just a reboot, or even a power cycle.
	
	- Device is being throttled:
		- Core temperature increased over 80 degrees Celsius. Provided airflow and / or air temperature is not adequate for the desired performance.
		- VCCINT drooped below 0.92 V. Most often caused by either too hot VRM (extra heatsink is heavily recommended) or not enough power provided usually by motherboards' weak M.2 ports.

	- Miner connects but then gets disconnected almost instantly:
		- Username provided is not a valid wallet address.
		- Password provided is not valid. This is mostly used for custom parameters for the pool, so exact issue varies.

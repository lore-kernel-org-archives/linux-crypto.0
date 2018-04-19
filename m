From: Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 00/61] tree-wide: simplify getting .drvdata
Date: Thu, 19 Apr 2018 16:05:30 +0200
Message-ID: <20180419140641.27926-1-wsa+renesas@sang-engineering.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ide@vger.kernel.org, alsa-devel@alsa-project.org,
 linux-iio@vger.kernel.org, kernel-janitors@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 platform-driver-x86@vger.kernel.org,
 Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-mtd@lists.infradead.org,
 linux-clk@vger.kernel.org, ac100@lists.launchpad.net,
 devel@driverdev.osuosl.org, linux-samsung-soc@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-serial@vger.kernel.org,
 linux-input@vger.kernel.org, linux-media@vger.kernel.org,
 linux-pwm@vger.kernel.org, linux-watchdog@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 acpi4asus-user@lists.sourceforge.net, greybus-dev@lists.linaro.org,
 linux-mediatek@lists.infradead.org, linux-tegra@vger.kernel.org,
 linux-omap@vger.kernel.org, linux-soc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linu
To: linux-kernel@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

I got tired of fixing this in Renesas drivers manually, so I took the big
hammer. Remove this cumbersome code pattern which got copy-pasted too much
already:

-	struct platform_device *pdev = to_platform_device(dev);
-	struct ep93xx_keypad *keypad = platform_get_drvdata(pdev);
+	struct ep93xx_keypad *keypad = dev_get_drvdata(dev);

I send this out as one patch per directory per subsystem. I think they should
be applied individually. If you prefer a broken out series per subsystem, I can
provide this as well. Just mail me.

A branch (tested by buildbot; only with all commits squashed into one commit
before) can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git coccinelle/get_drvdata

Open for other comments, suggestions, too, of course.

Here is the cocci-script I created (after <n> iterations by manually checking
samples):

@@
struct device* d;
identifier pdev;
expression *ptr;
@@
(
-	struct platform_device *pdev = to_platform_device(d);
|
-	struct platform_device *pdev;
	...
-	pdev = to_platform_device(d);
)
	<... when != pdev
-	&pdev->dev
+	d
	...>

	ptr =
-	platform_get_drvdata(pdev)
+	dev_get_drvdata(d)

	<... when != pdev
-	&pdev->dev
+	d
	...>

Kind regards,

   Wolfram


Wolfram Sang (61):
  ARM: plat-samsung: simplify getting .drvdata
  ata: simplify getting .drvdata
  auxdisplay: simplify getting .drvdata
  bus: simplify getting .drvdata
  clk: samsung: simplify getting .drvdata
  crypto: simplify getting .drvdata
  dma: simplify getting .drvdata
  dmaengine: dw: simplify getting .drvdata
  dmaengine: qcom: simplify getting .drvdata
  gpio: simplify getting .drvdata
  gpu: drm: msm: simplify getting .drvdata
  gpu: drm: msm: adreno: simplify getting .drvdata
  gpu: drm: msm: disp: mdp5: simplify getting .drvdata
  gpu: drm: msm: dsi: simplify getting .drvdata
  gpu: drm: omapdrm: displays: simplify getting .drvdata
  gpu: drm: vc4: simplify getting .drvdata
  hid: simplify getting .drvdata
  iio: common: cros_ec_sensors: simplify getting .drvdata
  iio: common: hid-sensors: simplify getting .drvdata
  input: keyboard: simplify getting .drvdata
  input: misc: simplify getting .drvdata
  input: mouse: simplify getting .drvdata
  input: touchscreen: simplify getting .drvdata
  iommu: simplify getting .drvdata
  media: platform: am437x: simplify getting .drvdata
  media: platform: exynos4-is: simplify getting .drvdata
  media: platform: s5p-mfc: simplify getting .drvdata
  mmc: host: simplify getting .drvdata
  mtd: devices: simplify getting .drvdata
  mtd: nand: onenand: simplify getting .drvdata
  net: dsa: simplify getting .drvdata
  net: ethernet: cadence: simplify getting .drvdata
  net: ethernet: davicom: simplify getting .drvdata
  net: ethernet: smsc: simplify getting .drvdata
  net: ethernet: ti: simplify getting .drvdata
  net: ethernet: wiznet: simplify getting .drvdata
  perf: simplify getting .drvdata
  pinctrl: simplify getting .drvdata
  pinctrl: intel: simplify getting .drvdata
  platform: x86: simplify getting .drvdata
  power: supply: simplify getting .drvdata
  ptp: simplify getting .drvdata
  pwm: simplify getting .drvdata
  rtc: simplify getting .drvdata
  slimbus: simplify getting .drvdata
  spi: simplify getting .drvdata
  staging: greybus: simplify getting .drvdata
  staging: iio: adc: simplify getting .drvdata
  staging: nvec: simplify getting .drvdata
  thermal: simplify getting .drvdata
  thermal: int340x_thermal: simplify getting .drvdata
  thermal: st: simplify getting .drvdata
  tty: serial: simplify getting .drvdata
  uio: simplify getting .drvdata
  usb: mtu3: simplify getting .drvdata
  usb: phy: simplify getting .drvdata
  video: fbdev: simplify getting .drvdata
  video: fbdev: omap2: omapfb: displays: simplify getting .drvdata
  watchdog: simplify getting .drvdata
  net: dsa: simplify getting .drvdata
  ASoC: atmel: simplify getting .drvdata

 arch/arm/plat-samsung/adc.c                        |  3 +-
 drivers/ata/pata_samsung_cf.c                      |  8 ++---
 drivers/auxdisplay/arm-charlcd.c                   |  6 ++--
 drivers/bus/brcmstb_gisb.c                         | 12 +++----
 drivers/clk/samsung/clk-s3c2410-dclk.c             |  6 ++--
 drivers/crypto/exynos-rng.c                        |  6 ++--
 drivers/crypto/picoxcell_crypto.c                  |  6 ++--
 drivers/dma/at_hdmac.c                             |  9 ++---
 drivers/dma/at_xdmac.c                             |  9 ++---
 drivers/dma/dw/platform.c                          |  6 ++--
 drivers/dma/fsldma.c                               |  6 ++--
 drivers/dma/idma64.c                               |  6 ++--
 drivers/dma/qcom/hidma.c                           |  3 +-
 drivers/dma/qcom/hidma_mgmt_sys.c                  |  6 ++--
 drivers/dma/ste_dma40.c                            | 12 +++----
 drivers/dma/txx9dmac.c                             |  8 ++---
 drivers/gpio/gpio-dwapb.c                          |  6 ++--
 drivers/gpio/gpio-lynxpoint.c                      |  3 +-
 drivers/gpio/gpio-omap.c                           | 12 +++----
 drivers/gpio/gpio-tegra.c                          |  6 ++--
 drivers/gpio/gpio-zynq.c                           |  6 ++--
 drivers/gpu/drm/msm/adreno/adreno_device.c         |  6 ++--
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |  6 ++--
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  6 ++--
 drivers/gpu/drm/msm/msm_drv.c                      |  3 +-
 drivers/gpu/drm/omapdrm/displays/panel-dsi-cm.c    | 18 ++++------
 drivers/gpu/drm/vc4/vc4_drv.c                      |  3 +-
 drivers/hid/hid-sensor-custom.c                    | 12 +++----
 .../common/cros_ec_sensors/cros_ec_sensors_core.c  |  6 ++--
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |  9 ++---
 drivers/input/keyboard/ep93xx_keypad.c             | 10 +++---
 drivers/input/keyboard/imx_keypad.c                | 10 +++---
 drivers/input/keyboard/lpc32xx-keys.c              |  6 ++--
 drivers/input/keyboard/matrix_keypad.c             | 10 +++---
 drivers/input/keyboard/omap4-keypad.c              | 10 +++---
 drivers/input/keyboard/pmic8xxx-keypad.c           |  6 ++--
 drivers/input/keyboard/pxa27x_keypad.c             | 10 +++---
 drivers/input/keyboard/samsung-keypad.c            | 12 +++----
 drivers/input/keyboard/snvs_pwrkey.c               | 10 +++---
 drivers/input/keyboard/spear-keyboard.c            | 10 +++---
 drivers/input/keyboard/st-keyscan.c                |  6 ++--
 drivers/input/keyboard/tegra-kbc.c                 | 10 +++---
 drivers/input/misc/max77693-haptic.c               |  6 ++--
 drivers/input/misc/max8997_haptic.c                |  3 +-
 drivers/input/misc/palmas-pwrbutton.c              |  6 ++--
 drivers/input/misc/regulator-haptic.c              |  6 ++--
 drivers/input/misc/twl4030-vibra.c                 |  3 +-
 drivers/input/misc/twl6040-vibra.c                 |  3 +-
 drivers/input/mouse/navpoint.c                     |  6 ++--
 drivers/input/touchscreen/imx6ul_tsc.c             |  6 ++--
 drivers/iommu/qcom_iommu.c                         |  6 ++--
 drivers/media/platform/am437x/am437x-vpfe.c        |  6 ++--
 drivers/media/platform/exynos4-is/media-dev.c      |  6 ++--
 drivers/media/platform/exynos4-is/mipi-csis.c      |  6 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  6 ++--
 drivers/mmc/host/davinci_mmc.c                     |  6 ++--
 drivers/mmc/host/sdhci-of-arasan.c                 |  6 ++--
 drivers/mmc/host/wmt-sdmmc.c                       |  6 ++--
 drivers/mtd/devices/docg3.c                        |  3 +-
 drivers/mtd/nand/onenand/samsung.c                 |  6 ++--
 drivers/net/dsa/bcm_sf2.c                          |  6 ++--
 drivers/net/dsa/qca8k.c                            |  6 ++--
 drivers/net/ethernet/cadence/macb_main.c           |  6 ++--
 drivers/net/ethernet/davicom/dm9000.c              |  6 ++--
 drivers/net/ethernet/smsc/smc91x.c                 |  3 +-
 drivers/net/ethernet/ti/cpsw.c                     |  6 ++--
 drivers/net/ethernet/ti/davinci_emac.c             |  6 ++--
 drivers/net/ethernet/wiznet/w5300.c                |  6 ++--
 drivers/perf/arm_spe_pmu.c                         |  6 ++--
 drivers/pinctrl/intel/pinctrl-baytrail.c           |  6 ++--
 drivers/pinctrl/intel/pinctrl-cherryview.c         |  6 ++--
 drivers/pinctrl/intel/pinctrl-intel.c              |  6 ++--
 drivers/pinctrl/pinctrl-amd.c                      |  6 ++--
 drivers/pinctrl/pinctrl-at91-pio4.c                |  6 ++--
 drivers/platform/x86/asus-laptop.c                 |  3 +-
 drivers/platform/x86/asus-wmi.c                    |  3 +-
 drivers/platform/x86/samsung-laptop.c              |  3 +-
 drivers/power/supply/gpio-charger.c                |  3 +-
 drivers/ptp/ptp_dte.c                              |  6 ++--
 drivers/pwm/pwm-atmel-tcb.c                        |  6 ++--
 drivers/pwm/pwm-rcar.c                             |  3 +-
 drivers/rtc/rtc-bq4802.c                           |  6 ++--
 drivers/rtc/rtc-ds1216.c                           |  6 ++--
 drivers/rtc/rtc-ds1511.c                           |  9 ++---
 drivers/rtc/rtc-ds1553.c                           | 15 +++-----
 drivers/rtc/rtc-ds1685.c                           | 21 ++++-------
 drivers/rtc/rtc-ds1742.c                           |  6 ++--
 drivers/rtc/rtc-lpc32xx.c                          | 16 ++++-----
 drivers/rtc/rtc-m48t59.c                           | 41 +++++++++-------------
 drivers/rtc/rtc-mv.c                               |  3 +-
 drivers/rtc/rtc-mxc.c                              | 21 ++++-------
 drivers/rtc/rtc-pcap.c                             | 15 +++-----
 drivers/rtc/rtc-sh.c                               | 15 +++-----
 drivers/rtc/rtc-stk17ta8.c                         | 15 +++-----
 drivers/rtc/rtc-test.c                             |  3 +-
 drivers/rtc/rtc-zynqmp.c                           | 10 +++---
 drivers/slimbus/qcom-ctrl.c                        |  6 ++--
 drivers/spi/spi-cadence.c                          |  6 ++--
 drivers/spi/spi-zynqmp-gqspi.c                     |  6 ++--
 drivers/staging/greybus/arche-platform.c           |  3 +-
 drivers/staging/iio/adc/ad7606_par.c               |  6 ++--
 drivers/staging/nvec/nvec.c                        |  6 ++--
 drivers/thermal/int340x_thermal/int3400_thermal.c  |  9 ++---
 drivers/thermal/rockchip_thermal.c                 |  8 ++---
 drivers/thermal/spear_thermal.c                    |  8 ++---
 drivers/thermal/st/st_thermal.c                    |  6 ++--
 drivers/thermal/zx2967_thermal.c                   |  6 ++--
 drivers/tty/serial/imx.c                           | 18 ++++------
 drivers/tty/serial/qcom_geni_serial.c              |  6 ++--
 drivers/tty/serial/st-asc.c                        |  6 ++--
 drivers/tty/serial/xilinx_uartps.c                 |  6 ++--
 drivers/uio/uio_fsl_elbc_gpcm.c                    |  6 ++--
 drivers/usb/mtu3/mtu3_plat.c                       |  6 ++--
 drivers/usb/phy/phy-am335x.c                       |  6 ++--
 drivers/video/fbdev/auo_k190x.c                    | 12 +++----
 .../fbdev/omap2/omapfb/displays/panel-dsi-cm.c     | 18 ++++------
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |  6 ++--
 drivers/video/fbdev/sh_mobile_meram.c              |  6 ++--
 drivers/watchdog/cadence_wdt.c                     |  6 ++--
 drivers/watchdog/of_xilinx_wdt.c                   |  6 ++--
 drivers/watchdog/wdat_wdt.c                        |  6 ++--
 net/dsa/legacy.c                                   |  6 ++--
 sound/soc/atmel/atmel_ssc_dai.c                    |  6 ++--
 123 files changed, 319 insertions(+), 607 deletions(-)

-- 
2.11.0

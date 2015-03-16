From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 00/35 linux-next] constify of_device_id array
Date: Mon, 16 Mar 2015 20:17:06 +0100
Message-ID: <1426533469-25458-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fbdev@vger.kernel.org, kernel@stlinux.com, linux-sh@vger.kernel.org,
 linux-iio@vger.kernel.org, linux-pci@vger.kernel.org,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org,
 Peter Meerwald <pmeerw@pmeerw.net>, openipmi-developer@lists.sourceforge.net,
 devel@driverdev.osuosl.org, Lars-Peter Clausen <lars@metafoo.de>,
 lm-sensors@lm-sensors.org,
 =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
 linux-serial@vger.kernel.org, linux-input@vger.kernel.org,
 linux-media@vger.kernel.org, linux-pwm@vger.kernel.org,
 linux-pm@vger.kernel.org, Fabian Frederick <fabf@skynet.be>,
 linux-gpio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-rpi-kernel@lists.infradead.org,
 linux-tegra@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
To: linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

This small patchset adds const to of_device_id arrays in
drivers branch.

Fabian Frederick (35):
  ata: constify of_device_id array
  regulator: constify of_device_id array
  thermal: constify of_device_id array
  tty/hvc_opal: constify of_device_id array
  tty: constify of_device_id array
  power: constify of_device_id array
  char: constify of_device_id array
  dma: constify of_device_id array
  iio: constify of_device_id array
  misc: constify of_device_id array
  usb: gadget: constify of_device_id array
  mtd: constify of_device_id array
  w1: constify of_device_id array
  ide: pmac: constify of_device_id array
  spi: constify of_device_id array
  video: constify of_device_id array
  coresight-replicator: constify of_device_id array
  macintosh: constify of_device_id array
  virtio_mmio: constify of_device_id array
  swim3: constify of_device_id array
  mfd: constify of_device_id array
  soc: ti: constify of_device_id array
  [media]: constify of_device_id array
  Input: constify of_device_id array
  PCI: constify of_device_id array
  hwmon: constify of_device_id array
  reset: sti: constify of_device_id array
  uio: constify of_device_id array
  gpu: constify of_device_id array
  devfreq: constify of_device_id array
  EDAC: constify of_device_id array
  clk: constify of_device_id array
  mmc: constify of_device_id array
  Staging: octeon: constify of_device_id array
  pinctrl: constify of_device_id array

 drivers/ata/pata_macio.c                     | 2 +-
 drivers/ata/pata_mpc52xx.c                   | 2 +-
 drivers/ata/pata_octeon_cf.c                 | 2 +-
 drivers/ata/pata_of_platform.c               | 2 +-
 drivers/ata/sata_fsl.c                       | 2 +-
 drivers/ata/sata_mv.c                        | 2 +-
 drivers/ata/sata_rcar.c                      | 2 +-
 drivers/block/swim3.c                        | 2 +-
 drivers/char/hw_random/pasemi-rng.c          | 2 +-
 drivers/char/hw_random/powernv-rng.c         | 2 +-
 drivers/char/hw_random/ppc4xx-rng.c          | 2 +-
 drivers/char/ipmi/ipmi_si_intf.c             | 4 ++--
 drivers/char/xillybus/xillybus_of.c          | 2 +-
 drivers/clk/clk-palmas.c                     | 2 +-
 drivers/clk/st/clkgen-fsyn.c                 | 2 +-
 drivers/clk/st/clkgen-mux.c                  | 8 ++++----
 drivers/clk/st/clkgen-pll.c                  | 4 ++--
 drivers/clk/ti/clk-dra7-atl.c                | 2 +-
 drivers/clk/ti/clockdomain.c                 | 2 +-
 drivers/clk/versatile/clk-vexpress-osc.c     | 2 +-
 drivers/coresight/coresight-replicator.c     | 2 +-
 drivers/devfreq/event/exynos-ppmu.c          | 2 +-
 drivers/devfreq/tegra-devfreq.c              | 2 +-
 drivers/dma/bestcomm/bestcomm.c              | 4 ++--
 drivers/dma/k3dma.c                          | 2 +-
 drivers/dma/mmp_pdma.c                       | 2 +-
 drivers/dma/mmp_tdma.c                       | 2 +-
 drivers/dma/mpc512x_dma.c                    | 2 +-
 drivers/dma/mv_xor.c                         | 2 +-
 drivers/dma/sirf-dma.c                       | 2 +-
 drivers/dma/sun6i-dma.c                      | 2 +-
 drivers/edac/highbank_mc_edac.c              | 2 +-
 drivers/edac/mpc85xx_edac.c                  | 4 ++--
 drivers/edac/ppc4xx_edac.c                   | 2 +-
 drivers/edac/synopsys_edac.c                 | 2 +-
 drivers/gpio/gpio-mpc8xxx.c                  | 2 +-
 drivers/gpio/gpio-octeon.c                   | 2 +-
 drivers/gpio/gpio-tz1090-pdc.c               | 2 +-
 drivers/gpio/gpio-tz1090.c                   | 2 +-
 drivers/gpio/gpio-zynq.c                     | 2 +-
 drivers/gpu/drm/armada/armada_crtc.c         | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_dsi.c      | 2 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c         | 2 +-
 drivers/gpu/drm/exynos/exynos_mixer.c        | 2 +-
 drivers/gpu/drm/panel/panel-ld9040.c         | 2 +-
 drivers/gpu/drm/panel/panel-s6e8aa0.c        | 2 +-
 drivers/gpu/drm/sti/sti_dvo.c                | 2 +-
 drivers/gpu/drm/sti/sti_hqvdp.c              | 2 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c          | 4 ++--
 drivers/gpu/drm/tilcdc/tilcdc_panel.c        | 2 +-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c        | 4 ++--
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c       | 4 ++--
 drivers/gpu/host1x/dev.c                     | 2 +-
 drivers/gpu/host1x/mipi.c                    | 2 +-
 drivers/hwmon/pwm-fan.c                      | 2 +-
 drivers/hwmon/vexpress.c                     | 2 +-
 drivers/ide/pmac.c                           | 2 +-
 drivers/iio/common/ssp_sensors/ssp_dev.c     | 2 +-
 drivers/input/misc/palmas-pwrbutton.c        | 2 +-
 drivers/input/misc/regulator-haptic.c        | 2 +-
 drivers/input/misc/tps65218-pwrbutton.c      | 2 +-
 drivers/input/touchscreen/ar1021_i2c.c       | 2 +-
 drivers/macintosh/mediabay.c                 | 2 +-
 drivers/macintosh/rack-meter.c               | 2 +-
 drivers/media/i2c/adv7604.c                  | 2 +-
 drivers/media/platform/fsl-viu.c             | 2 +-
 drivers/media/platform/soc_camera/rcar_vin.c | 2 +-
 drivers/media/rc/gpio-ir-recv.c              | 2 +-
 drivers/media/rc/ir-hix5hd2.c                | 2 +-
 drivers/media/rc/st_rc.c                     | 2 +-
 drivers/mfd/hi6421-pmic-core.c               | 2 +-
 drivers/mfd/rk808.c                          | 2 +-
 drivers/mfd/twl4030-power.c                  | 2 +-
 drivers/misc/carma/carma-fpga-program.c      | 2 +-
 drivers/misc/carma/carma-fpga.c              | 2 +-
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c       | 2 +-
 drivers/misc/lis3lv02d/lis3lv02d_spi.c       | 2 +-
 drivers/misc/sram.c                          | 2 +-
 drivers/mmc/host/mmc_spi.c                   | 2 +-
 drivers/mmc/host/wmt-sdmmc.c                 | 2 +-
 drivers/mtd/devices/docg3.c                  | 2 +-
 drivers/mtd/maps/physmap_of.c                | 4 ++--
 drivers/mtd/nand/mpc5121_nfc.c               | 2 +-
 drivers/mtd/spi-nor/fsl-quadspi.c            | 2 +-
 drivers/pci/host/pci-rcar-gen2.c             | 2 +-
 drivers/pci/host/pcie-xilinx.c               | 2 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c        | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt8135.c    | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mt8173.c    | 2 +-
 drivers/pinctrl/mvebu/pinctrl-armada-370.c   | 2 +-
 drivers/pinctrl/mvebu/pinctrl-armada-375.c   | 2 +-
 drivers/pinctrl/mvebu/pinctrl-armada-38x.c   | 2 +-
 drivers/pinctrl/mvebu/pinctrl-armada-39x.c   | 2 +-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c    | 2 +-
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c     | 2 +-
 drivers/pinctrl/mvebu/pinctrl-orion.c        | 2 +-
 drivers/pinctrl/pinctrl-as3722.c             | 2 +-
 drivers/pinctrl/pinctrl-at91.c               | 4 ++--
 drivers/pinctrl/pinctrl-palmas.c             | 2 +-
 drivers/pinctrl/pinctrl-single.c             | 4 ++--
 drivers/pinctrl/pinctrl-st.c                 | 2 +-
 drivers/pinctrl/pinctrl-tz1090-pdc.c         | 2 +-
 drivers/pinctrl/pinctrl-tz1090.c             | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sun4i-a10.c    | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sun5i-a10s.c   | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sun5i-a13.c    | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sun6i-a31-r.c  | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sun6i-a31.c    | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sun6i-a31s.c   | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sun7i-a20.c    | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c  | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c    | 2 +-
 drivers/pinctrl/sunxi/pinctrl-sun9i-a80.c    | 2 +-
 drivers/pinctrl/vt8500/pinctrl-vt8500.c      | 2 +-
 drivers/pinctrl/vt8500/pinctrl-wm8505.c      | 2 +-
 drivers/pinctrl/vt8500/pinctrl-wm8650.c      | 2 +-
 drivers/pinctrl/vt8500/pinctrl-wm8750.c      | 2 +-
 drivers/pinctrl/vt8500/pinctrl-wm8850.c      | 2 +-
 drivers/power/charger-manager.c              | 2 +-
 drivers/power/reset/at91-poweroff.c          | 2 +-
 drivers/power/reset/at91-reset.c             | 4 ++--
 drivers/power/reset/hisi-reboot.c            | 2 +-
 drivers/power/reset/keystone-reset.c         | 2 +-
 drivers/power/reset/st-poweroff.c            | 2 +-
 drivers/power/reset/syscon-reboot.c          | 2 +-
 drivers/power/reset/vexpress-poweroff.c      | 2 +-
 drivers/power/reset/xgene-reboot.c           | 2 +-
 drivers/power/tps65090-charger.c             | 2 +-
 drivers/regulator/palmas-regulator.c         | 2 +-
 drivers/reset/sti/reset-stih407.c            | 2 +-
 drivers/reset/sti/reset-stih415.c            | 2 +-
 drivers/reset/sti/reset-stih416.c            | 2 +-
 drivers/soc/ti/knav_dma.c                    | 2 +-
 drivers/soc/ti/knav_qmss_queue.c             | 2 +-
 drivers/spi/spi-mpc512x-psc.c                | 2 +-
 drivers/spi/spi-octeon.c                     | 2 +-
 drivers/spi/spi-st-ssc4.c                    | 2 +-
 drivers/staging/octeon-usb/octeon-hcd.c      | 2 +-
 drivers/staging/octeon/ethernet.c            | 2 +-
 drivers/thermal/st/st_thermal_memmap.c       | 2 +-
 drivers/thermal/st/st_thermal_syscfg.c       | 2 +-
 drivers/tty/hvc/hvc_opal.c                   | 2 +-
 drivers/tty/serial/apbuart.c                 | 2 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c  | 2 +-
 drivers/tty/serial/fsl_lpuart.c              | 2 +-
 drivers/tty/serial/mpc52xx_uart.c            | 2 +-
 drivers/tty/serial/mxs-auart.c               | 2 +-
 drivers/tty/serial/of_serial.c               | 4 ++--
 drivers/tty/serial/pmac_zilog.c              | 2 +-
 drivers/tty/serial/pxa.c                     | 2 +-
 drivers/tty/serial/serial-tegra.c            | 2 +-
 drivers/tty/serial/sirfsoc_uart.c            | 2 +-
 drivers/tty/serial/st-asc.c                  | 2 +-
 drivers/tty/serial/uartlite.c                | 2 +-
 drivers/tty/serial/ucc_uart.c                | 2 +-
 drivers/tty/serial/xilinx_uartps.c           | 2 +-
 drivers/uio/uio_pdrv_genirq.c                | 2 +-
 drivers/usb/gadget/udc/pxa27x_udc.c          | 2 +-
 drivers/video/backlight/gpio_backlight.c     | 2 +-
 drivers/video/backlight/pwm_bl.c             | 2 +-
 drivers/video/fbdev/fsl-diu-fb.c             | 2 +-
 drivers/video/fbdev/grvga.c                  | 2 +-
 drivers/video/fbdev/mb862xx/mb862xxfbdrv.c   | 2 +-
 drivers/video/fbdev/ocfb.c                   | 2 +-
 drivers/video/fbdev/platinumfb.c             | 2 +-
 drivers/video/fbdev/xilinxfb.c               | 2 +-
 drivers/virtio/virtio_mmio.c                 | 2 +-
 drivers/w1/masters/mxc_w1.c                  | 2 +-
 drivers/w1/masters/omap_hdq.c                | 2 +-
 drivers/w1/masters/w1-gpio.c                 | 2 +-
 170 files changed, 185 insertions(+), 185 deletions(-)

-- 
2.1.0

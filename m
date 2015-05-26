From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 00/13] dmaengine + omap drivers: support fro
	deferred probing
Date: Tue, 26 May 2015 16:25:55 +0300
Message-ID: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
 linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-spi@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-serial@vger.kernel.org, dmaengine@vger.kernel.org,
 dan.j.williams@intel.com, linux-omap@vger.kernel.org,
 linux-media@vger.kernel.org
To: <vinod.koul@intel.com>, <tony@atomide.com>
Return-path: <alsa-devel-bounces@alsa-project.org>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Vinod: as I promised: https://lkml.org/lkml/2015/5/8/80

With this series it is possible to put omap-dma or edma to even late_initcall
and the drivers will figure out the load order fine(ish).
We need to add dma_request_slave_channel_compat_reason() which is the equivalent
of dma_request_slave_channel_compat() but returning with error codes in case of
failure instead of NULL pointer.
The rest of the series just converts the OMAP/daVinci drivers to use this new
function to get the channel(s) and to handle the deferred probing.

I did not moved the omap-dma, edma or ti-dma-crossbar from arch_initcall. If I
do so UART will only comes up after the DMA driver is loaded since we are using,
or going to use 8250 with DAM support. This delays the kernel messages. Other
issue is the MMC/SD cards. On  board with eMMC and SD card slot the mmcblk0/1
might get swapped due to different probe order for the MMC/SD drivers. For
example in omap5-uevm:
1. omap-dma in arch_initcall the SD card is mmcblk1 (4809c000.mmc) and eMMC is
mmcblk0 (480b4000.mmc)
2. omap-dma in late_initcall the SD card is mmcblk0 (4809c000.mmc) and eMMC is
mmcblk1 (480b4000.mmc)

Because in case 1 the 4809c000.mmc got deferred by missing regulator so
480b4000.mmc got registered first. In case 2 both deferring because of DMA and
at the end 4809c000.mmc get registered first. So far I have not found a way to
bind mmcblk0/1 to a specific node...

Regards,
Peter
---
Peter Ujfalusi (13):
  dmaengine: of_dma: Correct return code for
    of_dma_request_slave_channel in case !CONFIG_OF
  dmaengine: Introduce dma_request_slave_channel_compat_reason()
  serial: 8250_dma: Support for deferred probing when requesting DMA
    channels
  mmc: omap_hsmmc: No need to check DMA channel validity at module
    remove
  mmc: omap_hsmmc: Support for deferred probing when requesting DMA
    channels
  mmc: omap: Support for deferred probing when requesting DMA channels
  mmc: davinci_mmc: Support for deferred probing when requesting DMA
    channels
  crypto: omap-aes - Support for deferred probing when requesting DMA
    channels
  crypto: omap-des - Support for deferred probing when requesting DMA
    channels
  crypto: omap-sham - Support for deferred probing when requesting DMA
    channel
  spi: omap2-mcspi: Support for deferred probing when requesting DMA
    channels
  [media] omap3isp: Support for deferred probing when requesting DMA
    channel
  ASoC: omap-pcm: Switch to use
    dma_request_slave_channel_compat_reason()

 drivers/crypto/omap-aes.c                 | 38 ++++++++++++++++---------------
 drivers/crypto/omap-des.c                 | 38 ++++++++++++++++---------------
 drivers/crypto/omap-sham.c                | 15 ++++++++----
 drivers/media/platform/omap3isp/isphist.c | 12 +++++++---
 drivers/mmc/host/davinci_mmc.c            | 26 ++++++++++++---------
 drivers/mmc/host/omap.c                   | 20 ++++++++++++----
 drivers/mmc/host/omap_hsmmc.c             | 28 ++++++++++-------------
 drivers/spi/spi-omap2-mcspi.c             | 36 +++++++++++++++++------------
 drivers/tty/serial/8250/8250_dma.c        | 18 +++++++--------
 include/linux/dmaengine.h                 | 22 ++++++++++++++++++
 include/linux/of_dma.h                    |  2 +-
 sound/soc/omap/omap-pcm.c                 | 16 ++++++++-----
 12 files changed, 164 insertions(+), 107 deletions(-)

-- 
2.3.5

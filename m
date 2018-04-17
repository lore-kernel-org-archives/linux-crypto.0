From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v3 01/20] ASoC: Remove depends on HAS_DMA in case of platform
 dependency
Date: Tue, 17 Apr 2018 19:49:01 +0200
Message-ID: <1523987360-18760-2-git-send-email-geert@linux-m68k.org>
References: <1523987360-18760-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
 linux-media@vger.kernel.org, linux-iio@vger.kernel.org, netdev@vger.kernel.org,
 linux-fpga@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-fbdev@vger.kernel.org,
 linux-spi@vger.kernel.org, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, iommu@lists.linux-foundation.org,
 linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-serial@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-remoteproc@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
 linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Felipe Balbi <balbi@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>,
 Liam Girdwood <lgirdwood@gmail.com>, Tejun Heo <tj@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 Stefan Richter <stefanr@s5r6.in-berlin.de>, Alan Tull <atull@kernel.org>,
 Moritz Fischer <mdf@kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
 Jonathan Cameron <jic23@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Matias Bjorling <mb@lightnvm.io>, Jassi Brar <jassisinghbrar@gmail.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>,
 Ulf Hansson <ulf.hansson@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>,
 Br
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1523987360-18760-1-git-send-email-geert@linux-m68k.org>
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

Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
In most cases this other symbol is an architecture or platform specific
symbol, or PCI.

Generic symbols and drivers without platform dependencies keep their
dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
cannot work anyway.

This simplifies the dependencies, and allows to improve compile-testing.

Note:
  - The various SND_SOC_LPASS_* symbols had to loose their dependencies
    on HAS_DMA, as they are selected by SND_SOC_STORM and/or
    SND_SOC_APQ8016_SBC.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Mark Brown <broonie@kernel.org>
---
v3:
  - Add Acked-by,
  - Rebase to v4.17-rc1,

v2:
  - Add Reviewed-by, Acked-by,
  - Drop RFC state,
  - Drop dependency of SND_SOC_LPASS_IPQ806X on HAS_DMA,
  - Split per subsystem.
---
 sound/soc/bcm/Kconfig      | 3 +--
 sound/soc/kirkwood/Kconfig | 1 -
 sound/soc/pxa/Kconfig      | 1 -
 sound/soc/qcom/Kconfig     | 7 ++-----
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/sound/soc/bcm/Kconfig b/sound/soc/bcm/Kconfig
index edf367100ebd2f17..02f50b7a966ff262 100644
--- a/sound/soc/bcm/Kconfig
+++ b/sound/soc/bcm/Kconfig
@@ -11,9 +11,8 @@ config SND_BCM2835_SOC_I2S
 config SND_SOC_CYGNUS
 	tristate "SoC platform audio for Broadcom Cygnus chips"
 	depends on ARCH_BCM_CYGNUS || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  Say Y if you want to add support for ASoC audio on Broadcom
 	  Cygnus chips (bcm958300, bcm958305, bcm911360)
 
-	  If you don't know what to do here, say N.
\ No newline at end of file
+	  If you don't know what to do here, say N.
diff --git a/sound/soc/kirkwood/Kconfig b/sound/soc/kirkwood/Kconfig
index bc3c7b5ac752e471..132bb83f8e99aff3 100644
--- a/sound/soc/kirkwood/Kconfig
+++ b/sound/soc/kirkwood/Kconfig
@@ -1,7 +1,6 @@
 config SND_KIRKWOOD_SOC
 	tristate "SoC Audio for the Marvell Kirkwood and Dove chips"
 	depends on ARCH_DOVE || ARCH_MVEBU || COMPILE_TEST
-	depends on HAS_DMA
 	help
 	  Say Y or M if you want to add support for codecs attached to
 	  the Kirkwood I2S interface. You will also need to select the
diff --git a/sound/soc/pxa/Kconfig b/sound/soc/pxa/Kconfig
index 484ab3c2ad672fc8..960744e46edc0549 100644
--- a/sound/soc/pxa/Kconfig
+++ b/sound/soc/pxa/Kconfig
@@ -1,7 +1,6 @@
 config SND_PXA2XX_SOC
 	tristate "SoC Audio for the Intel PXA2xx chip"
 	depends on ARCH_PXA || COMPILE_TEST
-	depends on HAS_DMA
 	select SND_PXA2XX_LIB
 	help
 	  Say Y or M if you want to add support for codecs attached to
diff --git a/sound/soc/qcom/Kconfig b/sound/soc/qcom/Kconfig
index 8ec9a074b38bd702..3cc252e55468eaab 100644
--- a/sound/soc/qcom/Kconfig
+++ b/sound/soc/qcom/Kconfig
@@ -11,24 +11,21 @@ config SND_SOC_LPASS_CPU
 
 config SND_SOC_LPASS_PLATFORM
 	tristate
-	depends on HAS_DMA
 	select REGMAP_MMIO
 
 config SND_SOC_LPASS_IPQ806X
 	tristate
-	depends on HAS_DMA
 	select SND_SOC_LPASS_CPU
 	select SND_SOC_LPASS_PLATFORM
 
 config SND_SOC_LPASS_APQ8016
 	tristate
-	depends on HAS_DMA
 	select SND_SOC_LPASS_CPU
 	select SND_SOC_LPASS_PLATFORM
 
 config SND_SOC_STORM
 	tristate "ASoC I2S support for Storm boards"
-	depends on SND_SOC_QCOM && HAS_DMA
+	depends on SND_SOC_QCOM
 	select SND_SOC_LPASS_IPQ806X
 	select SND_SOC_MAX98357A
 	help
@@ -37,7 +34,7 @@ config SND_SOC_STORM
 
 config SND_SOC_APQ8016_SBC
 	tristate "SoC Audio support for APQ8016 SBC platforms"
-	depends on SND_SOC_QCOM && HAS_DMA
+	depends on SND_SOC_QCOM
 	select SND_SOC_LPASS_APQ8016
 	help
           Support for Qualcomm Technologies LPASS audio block in
-- 
2.7.4

From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v3 09/20] iommu: Remove depends on HAS_DMA in case of platform
 dependency
Date: Tue, 17 Apr 2018 19:49:09 +0200
Message-ID: <1523987360-18760-10-git-send-email-geert@linux-m68k.org>
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

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Joerg Roedel <jroedel@suse.de>
---
v3:
  - Add Acked-by,
  - Rebase to v4.17-rc1,

v2:
  - Add Reviewed-by, Acked-by,
  - Drop RFC state,
  - Split per subsystem.
---
 drivers/iommu/Kconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index df171cb8582296b9..c76157e57f6ba4ba 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -23,7 +23,7 @@ config IOMMU_IO_PGTABLE
 config IOMMU_IO_PGTABLE_LPAE
 	bool "ARMv7/v8 Long Descriptor Format"
 	select IOMMU_IO_PGTABLE
-	depends on HAS_DMA && (ARM || ARM64 || (COMPILE_TEST && !GENERIC_ATOMIC64))
+	depends on ARM || ARM64 || (COMPILE_TEST && !GENERIC_ATOMIC64)
 	help
 	  Enable support for the ARM long descriptor pagetable format.
 	  This allocator supports 4K/2M/1G, 16K/32M and 64K/512M page
@@ -42,7 +42,7 @@ config IOMMU_IO_PGTABLE_LPAE_SELFTEST
 config IOMMU_IO_PGTABLE_ARMV7S
 	bool "ARMv7/v8 Short Descriptor Format"
 	select IOMMU_IO_PGTABLE
-	depends on HAS_DMA && (ARM || ARM64 || COMPILE_TEST)
+	depends on ARM || ARM64 || COMPILE_TEST
 	help
 	  Enable support for the ARM Short-descriptor pagetable format.
 	  This supports 32-bit virtual and physical addresses mapped using
@@ -376,7 +376,6 @@ config QCOM_IOMMU
 	# Note: iommu drivers cannot (yet?) be built as modules
 	bool "Qualcomm IOMMU Support"
 	depends on ARCH_QCOM || (COMPILE_TEST && !GENERIC_ATOMIC64)
-	depends on HAS_DMA
 	select IOMMU_API
 	select IOMMU_IO_PGTABLE_LPAE
 	select ARM_DMA_USE_IOMMU
-- 
2.7.4

From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH v2 2/7] ARM: OMAP2xxx: hwmod: Add DMA support for SHAM module
Date: Tue, 23 Oct 2012 19:36:02 -0700
Message-ID: <1351046167-4882-3-git-send-email-mgreer@animalcreek.com>
References: <1351046167-4882-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <1351046167-4882-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

The current OMAP2 SHAM support doesn't enable DMA
so add that support so it can use DMA just like OMAP3.

CC: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c | 2 +-
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c      | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c b/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c
index bb314c5..4b4fd5f 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c
@@ -405,5 +405,5 @@ struct omap_hwmod_ocp_if omap2xxx_l4_core__sham = {
 	.slave		= &omap2xxx_sham_hwmod,
 	.clk		= "sha_ick",
 	.addr		= omap2xxx_sham_addrs,
-	.user		= OCP_USER_MPU,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
diff --git a/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c b/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
index a041670..703b269 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
@@ -873,9 +873,15 @@ struct omap_hwmod_irq_info omap2_sham_mpu_irqs[] = {
 	{ .irq = -1 }
 };
 
+struct omap_hwmod_dma_info omap2_sham_sdma_chs[] = {
+	{ .name = "rx", .dma_req = OMAP24XX_DMA_SHA1MD5_RX },
+	{ .dma_req = -1 }
+};
+
 struct omap_hwmod omap2xxx_sham_hwmod = {
 	.name		= "sham",
 	.mpu_irqs	= omap2_sham_mpu_irqs,
+	.sdma_reqs	= omap2_sham_sdma_chs,
 	.main_clk	= "l4_ck",
 	.prcm		= {
 		.omap2 = {
-- 
1.7.12


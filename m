From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>
Subject: [PATCH] crypto: caam - add support for LS1021A
Date: Mon, 17 Aug 2015 15:24:10 +0300
Message-ID: <1439814250-4221-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	Victoria Milhoan <vicki.milhoan@freescale.com>,
	Alex Porosanu <alexandru.porosanu@freescale.com>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0118.outbound.protection.outlook.com ([157.56.111.118]:35698
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751427AbbHQMY2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Aug 2015 08:24:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

LS1021A is a QorIQ SoC having little endian CAAM.

There are a few differences b/w QorIQ and i.MX from CAAM perspective:

1. i.MX platforms are somewhat special wrt. 64-bit registers:
-big endian format at 64-bit level: MSW at address+0 and LSW at address=
+4
-little endian format at 32-bit level (within MSW and LSW)
and thus need special handling.

2. No CCM (clock controller module) for QorIQ.
No CAAM clocks to enable / disable.

A new Kconfig option - CRYPTO_DEV_FSL_CAAM_LE - is added to indicate
CAAM is little endian (*). It is hidden from the user (to avoid
misconfiguration); when adding support for a new platform with LE CAAM,
either the Kconfig needs to be updated or the corresponding defconfig
needs to indicate that CAAM is LE.
(*) Using a DT property to provide CAAM endianness would not allow
for the ifdeffery.

In order to keep changes to a minimum, the following changes
are postponed:
-endianness fix of the last word in the S/G (rsvd2, bpid, offset),
fields are always 0 anyway;
-S/G format fix for i.MX7 (yes, i.MX7 support was not added yet,
but still...)

Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
---

Tested with ls1021_defconfig added by:
ARM: configs: Add Freescale LS1021A defconfig
https://patchwork.kernel.org/patch/6967421

and with crypto node appended to the DT:
ARM: dts: ls1021a: add crypto node
https://patchwork.kernel.org/patch/6997561

Also tested that patch does not break i.MX6.

 drivers/crypto/caam/Kconfig |  8 ++++++++
 drivers/crypto/caam/ctrl.c  |  4 ++--
 drivers/crypto/caam/desc.h  |  8 ++++----
 drivers/crypto/caam/regs.h  | 19 +++++++++++++++----
 4 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index 66ef0c09af73..5652a53415dc 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -112,6 +112,14 @@ config CRYPTO_DEV_FSL_CAAM_RNG_API
 	  To compile this as a module, choose M here: the module
 	  will be called caamrng.
=20
+config CRYPTO_DEV_FSL_CAAM_IMX
+	def_bool SOC_IMX6 || SOC_IMX7D
+	depends on CRYPTO_DEV_FSL_CAAM
+
+config CRYPTO_DEV_FSL_CAAM_LE
+	def_bool CRYPTO_DEV_FSL_CAAM_IMX || SOC_LS1021A
+	depends on CRYPTO_DEV_FSL_CAAM
+
 config CRYPTO_DEV_FSL_CAAM_DEBUG
 	bool "Enable debug output in CAAM driver"
 	depends on CRYPTO_DEV_FSL_CAAM
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 4f174ee8a347..81b552d1ad91 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -16,10 +16,10 @@
 #include "error.h"
=20
 /*
- * ARM targets tend to have clock control subsystems that can
+ * i.MX targets tend to have clock control subsystems that can
  * enable/disable clocking to our device.
  */
-#ifdef CONFIG_ARM
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
 static inline struct clk *caam_drv_identify_clk(struct device *dev,
 						char *clk_name)
 {
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 405acbf13dac..983d663ef671 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -23,12 +23,12 @@
 #define SEC4_SG_OFFS_MASK	0x00001fff
=20
 struct sec4_sg_entry {
-#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-	dma_addr_t ptr;
-#else
+#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
 	u32 rsvd1;
 	dma_addr_t ptr;
-#endif
+#else
+	u64 ptr;
+#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_IMX */
 	u32 len;
 	u8 rsvd2;
 	u8 buf_pool_id;
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index d7c3579af791..a8a79975682f 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -108,20 +108,31 @@
=20
 /*
  * The only users of these wr/rd_reg64 functions is the Job Ring (JR).
- * The DMA address registers in the JR are a pair of 32-bit registers.
- * The layout is:
+ * The DMA address registers in the JR are handled differently dependi=
ng on
+ * platform:
+ *
+ * 1. All BE CAAM platforms and i.MX platforms (LE CAAM):
  *
  *    base + 0x0000 : most-significant 32 bits
  *    base + 0x0004 : least-significant 32 bits
  *
  * The 32-bit version of this core therefore has to write to base + 0x=
0004
- * to set the 32-bit wide DMA address. This seems to be independent of=
 the
- * endianness of the written/read data.
+ * to set the 32-bit wide DMA address.
+ *
+ * 2. All other LE CAAM platforms (LS1021A etc.)
+ *    base + 0x0000 : least-significant 32 bits
+ *    base + 0x0004 : most-significant 32 bits
  */
=20
 #ifndef CONFIG_64BIT
+#if !defined(CONFIG_CRYPTO_DEV_FSL_CAAM_LE) || \
+	defined(CONFIG_CRYPTO_DEV_FSL_CAAM_IMX)
 #define REG64_MS32(reg) ((u32 __iomem *)(reg))
 #define REG64_LS32(reg) ((u32 __iomem *)(reg) + 1)
+#else
+#define REG64_MS32(reg) ((u32 __iomem *)(reg) + 1)
+#define REG64_LS32(reg) ((u32 __iomem *)(reg))
+#endif
=20
 static inline void wr_reg64(u64 __iomem *reg, u64 data)
 {
--=20
2.4.4

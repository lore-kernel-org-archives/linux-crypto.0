From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH] crypto: caam - fix non-64-bit write/read access
Date: Tue, 16 Jun 2015 12:59:07 +0200
Message-ID: <1434452347-27177-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: Ruchika Gupta <ruchika.gupta@freescale.com>,
	Victoria Milhoan <Vicki.Milhoan@freescale.com>,
	Russell King <linux@arm.linux.org.uk>,
	Jon Nettleton <jon.nettleton@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel@pengutronix.de, Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44705 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbbFPK7x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 06:59:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The patch

	crypto: caam - Add definition of rd/wr_reg64 for little endian platform

added support for little endian platforms to the CAAM driver. Namely a
write and read function for 64 bit registers.
The only user of this functions is the Job Ring driver (drivers/crypto/caam/jr.c).
It uses the functions to set the DMA addresses for the input/output rings.
However, at least in the default configuration, the least significant 32 bits are
always in the base+0x0004 address; independent of the endianness of the bytes itself.
That means the addresses do not change with the system endianness.

DMA addresses are only 32 bits wide on non-64-bit systems, writing the upper 32 bits
of this value to the register for the least significant bits results in the DMA address
being set to 0.

Fix this by always writing the registers in the same way.

Suggested-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---

This patch is only compile-tested for PowerPC and tested on ARM.
According to the datasheets for i.MX6 and P1010 this should be correct, though.

 drivers/crypto/caam/regs.h | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 378ddc17f60e..672c97489505 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -83,35 +83,35 @@
 #endif
 #endif
 
+/*
+ * The only users of these wr/rd_reg64 functions is the Job Ring (JR).
+ * The DMA address registers in the JR are a pair of 32-bit registers.
+ * The layout is:
+ *
+ *    base + 0x0000 : most-significant 32 bits
+ *    base + 0x0004 : least-significant 32 bits
+ *
+ * The 32-bit version of this core therefore has to write to base + 0x0004
+ * to set the 32-bit wide DMA address. This seems to be independent of the
+ * endianness of the written/read data.
+ */
+
 #ifndef CONFIG_64BIT
-#ifdef __BIG_ENDIAN
-static inline void wr_reg64(u64 __iomem *reg, u64 data)
-{
-	wr_reg32((u32 __iomem *)reg, (data & 0xffffffff00000000ull) >> 32);
-	wr_reg32((u32 __iomem *)reg + 1, data & 0x00000000ffffffffull);
-}
+#define REG64_MS32(reg) ((u32 __iomem *)(reg))
+#define REG64_LS32(reg) ((u32 __iomem *)(reg) + 1)
 
-static inline u64 rd_reg64(u64 __iomem *reg)
-{
-	return (((u64)rd_reg32((u32 __iomem *)reg)) << 32) |
-		((u64)rd_reg32((u32 __iomem *)reg + 1));
-}
-#else
-#ifdef __LITTLE_ENDIAN
 static inline void wr_reg64(u64 __iomem *reg, u64 data)
 {
-	wr_reg32((u32 __iomem *)reg + 1, (data & 0xffffffff00000000ull) >> 32);
-	wr_reg32((u32 __iomem *)reg, data & 0x00000000ffffffffull);
+	wr_reg32(REG64_MS32(reg), data >> 32);
+	wr_reg32(REG64_LS32(reg), data);
 }
 
 static inline u64 rd_reg64(u64 __iomem *reg)
 {
-	return (((u64)rd_reg32((u32 __iomem *)reg + 1)) << 32) |
-		((u64)rd_reg32((u32 __iomem *)reg));
+	return ((u64)rd_reg32(REG64_MS32(reg)) << 32 |
+		(u64)rd_reg32(REG64_LS32(reg)));
 }
 #endif
-#endif
-#endif
 
 /*
  * jr_outentry
-- 
2.1.4

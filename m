From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH RFC 02/11] crypto: caam - Add register I/O primitives for ARM compatibility
Date: Mon, 15 Jun 2015 16:52:50 -0700
Message-ID: <1434412379-11623-3-git-send-email-vicki.milhoan@freescale.com>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0146.outbound.protection.outlook.com ([157.56.111.146]:10209
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750858AbbFPA0O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 20:26:14 -0400
In-Reply-To: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Steve Cornelius <steve.cornelius@freescale.com>

Add appropriate read/write register handling to support ARM/Little Endian
devices.

Add set/clear 32-bit primitives for compatibility with ARM devices since
the primitives were previously only defined for the Power architecture.

Signed-off-by: Steve Cornelius <steve.cornelius@freescale.com>
[<vicki.milhoan@freescale.com>: Edit to accomodate __BIG_ENDIAN and __LITTLE_ENDIAN changes]
Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/regs.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 378ddc1..9cca14e 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -74,17 +74,23 @@
 #endif
 #else
 #ifdef __LITTLE_ENDIAN
-#define wr_reg32(reg, data) __raw_writel(data, reg)
-#define rd_reg32(reg) __raw_readl(reg)
+#define wr_reg32(reg, data) writel(data, reg)
+#define rd_reg32(reg) readl(reg)
 #ifdef CONFIG_64BIT
-#define wr_reg64(reg, data) __raw_writeq(data, reg)
-#define rd_reg64(reg) __raw_readq(reg)
+#define wr_reg64(reg, data) writeq(data, reg)
+#define rd_reg64(reg) readq(reg)
 #endif
 #endif
 #endif
 
+#ifdef CONFIG_ARM
+/* These are common macros for Power, put here for ARM */
+#define setbits32(_addr, _v) writel((readl(_addr) | (_v)), (_addr))
+#define clrbits32(_addr, _v) writel((readl(_addr) & ~(_v)), (_addr))
+#endif
+
 #ifndef CONFIG_64BIT
-#ifdef __BIG_ENDIAN
+#if defined(__BIG_ENDIAN) || defined(CONFIG_ARCH_MXC)
 static inline void wr_reg64(u64 __iomem *reg, u64 data)
 {
 	wr_reg32((u32 __iomem *)reg, (data & 0xffffffff00000000ull) >> 32);
-- 
2.1.4

From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH] crypto:caam - Define setbits32() and clrbits32() for ARM in the Freescale CAAM driver
Date: Tue, 29 Apr 2014 15:41:39 +0530
Message-ID: <1398766299-30412-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ruchika Gupta <ruchika.gupta@freescale.com>,
	Victoria Milhoan <vicki.milhoan@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:16714
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756462AbaD2KOA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Apr 2014 06:14:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The kernel defines setbits32() and clrbits32() macros only for
Power-based architectures.  This patch modifies the Freescale CAAM
driver to add macros for use on ARM architectures.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
 drivers/crypto/caam/regs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 7bb898d..16a3d2e 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -83,6 +83,12 @@
 #endif
 #endif
 
+#ifdef CONFIG_ARM
+/* These are common macros for Power, put here for ARMs */
+#define setbits32(_addr, _v) writel((readl(_addr) | (_v)), (_addr))
+#define clrbits32(_addr, _v) writel((readl(_addr) & ~(_v)), (_addr))
+#endif
+
 #ifndef CONFIG_64BIT
 static inline void wr_reg64(u64 __iomem *reg, u64 data)
 {
-- 
1.8.1.4

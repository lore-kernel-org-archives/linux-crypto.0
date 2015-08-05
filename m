From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH v2 02/14] crypto: caam - Add setbits32/clrbits32/clrsetbits primitives for ARM compatibility
Date: Wed, 5 Aug 2015 11:28:36 -0700
Message-ID: <1438799328-10757-3-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0114.outbound.protection.outlook.com ([207.46.100.114]:28832
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753199AbbHES2y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 14:28:54 -0400
In-Reply-To: <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add set/clear 32-bit primitives for compatibility with ARM devices since
the primitives were previously only defined for the Power architecture.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/ctrl.c |  6 +++---
 drivers/crypto/caam/regs.h | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 1891809..660cc3e 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -445,9 +445,9 @@ static int caam_probe(struct platform_device *pdev)
 	 * Enable DECO watchdogs and, if this is a PHYS_ADDR_T_64BIT kernel,
 	 * long pointers in master configuration register
 	 */
-	clrsetbits_be32(&ctrl->mcr, MCFGR_AWCACHE_MASK, MCFGR_AWCACHE_CACH |
-			MCFGR_WDENABLE | (sizeof(dma_addr_t) == sizeof(u64) ?
-					 MCFGR_LONG_PTR : 0));
+	clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK, MCFGR_AWCACHE_CACH |
+		      MCFGR_WDENABLE | (sizeof(dma_addr_t) == sizeof(u64) ?
+					MCFGR_LONG_PTR : 0));
 
 	/*
 	 *  Read the Compile Time paramters and SCFGR to determine
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 5e64352..3a2a788 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -65,9 +65,31 @@
  *
  */
 
+#ifdef CONFIG_ARM
+/* These are common macros for Power, put here for ARM */
+#define setbits32(_addr, _v) writel((readl(_addr) | (_v)), (_addr))
+#define clrbits32(_addr, _v) writel((readl(_addr) & ~(_v)), (_addr))
+
+#define out_arch(type, endian, a, v)	__raw_write##type(cpu_to_##endian(v), a)
+#define in_arch(type, endian, a)	endian##_to_cpu(__raw_read##type(a))
+
+#define out_le32(a, v)	out_arch(l, le32, a, v)
+#define in_le32(a)	in_arch(l, le32, a)
+
+#define out_be32(a, v)	out_arch(l, be32, a, v)
+#define in_be32(a)	in_arch(l, be32, a)
+
+#define clrsetbits(type, addr, clear, set) \
+	out_##type((addr), (in_##type(addr) & ~(clear)) | (set))
+
+#define clrsetbits_be32(addr, clear, set) clrsetbits(be32, addr, clear, set)
+#define clrsetbits_le32(addr, clear, set) clrsetbits(le32, addr, clear, set)
+#endif
+
 #ifdef __BIG_ENDIAN
 #define wr_reg32(reg, data) out_be32(reg, data)
 #define rd_reg32(reg) in_be32(reg)
+#define clrsetbits_32(addr, clear, set) clrsetbits_be32(addr, clear, set)
 #ifdef CONFIG_64BIT
 #define wr_reg64(reg, data) out_be64(reg, data)
 #define rd_reg64(reg) in_be64(reg)
@@ -76,6 +98,7 @@
 #ifdef __LITTLE_ENDIAN
 #define wr_reg32(reg, data) __raw_writel(data, reg)
 #define rd_reg32(reg) __raw_readl(reg)
+#define clrsetbits_32(addr, clear, set) clrsetbits_le32(addr, clear, set)
 #ifdef CONFIG_64BIT
 #define wr_reg64(reg, data) __raw_writeq(data, reg)
 #define rd_reg64(reg) __raw_readq(reg)
-- 
2.1.4

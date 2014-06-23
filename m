From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH] crypto: caam - Add definition of rd/wr_reg64 for little endian platform
Date: Mon, 23 Jun 2014 18:49:30 +0530
Message-ID: <1403529570-23393-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>, <alexandru.porosanu@freescale.com>,
	<kim.phillips@freescale.com>, <dan.carpenter@oracle.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:9788
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751282AbaFWICh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Jun 2014 04:02:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CAAM IP has certain 64 bit registers . 32 bit architectures cannot force
atomic-64 operations.  This patch adds definition of these atomic-64
operations for little endian platforms. The definitions which existed
previously were for big endian platforms.

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
Tested on LS1021 platform

 drivers/crypto/caam/regs.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index cbde8b9..2825067 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -84,6 +84,7 @@
 #endif
 
 #ifndef CONFIG_64BIT
+#ifdef __BIG_ENDIAN
 static inline void wr_reg64(u64 __iomem *reg, u64 data)
 {
 	wr_reg32((u32 __iomem *)reg, (data & 0xffffffff00000000ull) >> 32);
@@ -95,6 +96,21 @@ static inline u64 rd_reg64(u64 __iomem *reg)
 	return (((u64)rd_reg32((u32 __iomem *)reg)) << 32) |
 		((u64)rd_reg32((u32 __iomem *)reg + 1));
 }
+#else
+#ifdef __LITTLE_ENDIAN
+static inline void wr_reg64(u64 __iomem *reg, u64 data)
+{
+	wr_reg32((u32 __iomem *)reg + 1, (data & 0xffffffff00000000ull) >> 32);
+	wr_reg32((u32 __iomem *)reg, data & 0x00000000ffffffffull);
+}
+
+static inline u64 rd_reg64(u64 __iomem *reg)
+{
+	return (((u64)rd_reg32((u32 __iomem *)reg + 1)) << 32) |
+		((u64)rd_reg32((u32 __iomem *)reg));
+}
+#endif
+#endif
 #endif
 
 /*
-- 
1.8.1.4

From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v9 7/8] crypto: caam: cleanup CONFIG_64BIT ifdefs when using io{read|write}64
Date: Tue,  5 Dec 2017 16:30:57 -0700
Message-ID: <20171205233058.5365-8-logang@deltatee.com>
References: <20171205233058.5365-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:54068 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753011AbdLEXbV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 18:31:21 -0500
In-Reply-To: <20171205233058.5365-1-logang@deltatee.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Clean up the extra ifdefs which defined the wr_reg64 and rd_reg64
functions in non-64bit cases in favour of the new common
io-64-nonatomic-lo-hi header.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Dan Douglass <dan.douglass@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/crypto/caam/regs.h | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index fee363865d88..ec6528e5ce9d 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -10,7 +10,7 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
-#include <linux/io.h>
+#include <linux/io-64-nonatomic-hi-lo.h>
 
 /*
  * Architecture-specific register access methods
@@ -136,7 +136,6 @@ static inline void clrsetbits_32(void __iomem *reg, u32 clear, u32 set)
  *    base + 0x0000 : least-significant 32 bits
  *    base + 0x0004 : most-significant 32 bits
  */
-#ifdef CONFIG_64BIT
 static inline void wr_reg64(void __iomem *reg, u64 data)
 {
 	if (caam_little_end)
@@ -153,29 +152,6 @@ static inline u64 rd_reg64(void __iomem *reg)
 		return ioread64be(reg);
 }
 
-#else /* CONFIG_64BIT */
-static inline void wr_reg64(void __iomem *reg, u64 data)
-{
-	if (!caam_imx && caam_little_end) {
-		wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);
-		wr_reg32((u32 __iomem *)(reg), data);
-	} else {
-		wr_reg32((u32 __iomem *)(reg), data >> 32);
-		wr_reg32((u32 __iomem *)(reg) + 1, data);
-	}
-}
-
-static inline u64 rd_reg64(void __iomem *reg)
-{
-	if (!caam_imx && caam_little_end)
-		return ((u64)rd_reg32((u32 __iomem *)(reg) + 1) << 32 |
-			(u64)rd_reg32((u32 __iomem *)(reg)));
-
-	return ((u64)rd_reg32((u32 __iomem *)(reg)) << 32 |
-		(u64)rd_reg32((u32 __iomem *)(reg) + 1));
-}
-#endif /* CONFIG_64BIT  */
-
 static inline u64 cpu_to_caam_dma64(dma_addr_t value)
 {
 	if (caam_imx)
-- 
2.11.0

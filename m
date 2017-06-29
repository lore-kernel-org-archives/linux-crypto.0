From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v3 4/4] crypto: caam: cleanup CONFIG_64BIT ifdefs when using io{read|write}64
Date: Thu, 29 Jun 2017 10:10:00 -0600
Message-ID: <20170629161000.15563-5-logang@deltatee.com>
References: <20170629161000.15563-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170629161000.15563-1-logang@deltatee.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

We can now make use of the io-64-nonatomic-hi-lo header to always
provide 64 bit IO operations. So this patch cleans up the extra
CONFIG_64BIT ifdefs.

To be consistent with CAAM engine HW spec: in case of 64-bit registers,
irrespective of device endianness, the lower address should be read from
/ written to first, followed by the upper address. Indeed the I/O
accessors in CAAM driver currently don't follow the spec, however this
is a good opportunity to fix the code.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Dan Douglass <dan.douglass@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/crypto/caam/regs.h | 35 +++++------------------------------
 1 file changed, 5 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 84d2f838a063..0c45505458e7 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -9,7 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
-#include <linux/io.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 
 /*
  * Architecture-specific register access methods
@@ -134,50 +134,25 @@ static inline void clrsetbits_32(void __iomem *reg, u32 clear, u32 set)
  *    base + 0x0000 : least-significant 32 bits
  *    base + 0x0004 : most-significant 32 bits
  */
-#ifdef CONFIG_64BIT
 static inline void wr_reg64(void __iomem *reg, u64 data)
 {
+#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
 	if (caam_little_end)
 		iowrite64(data, reg);
 	else
-		iowrite64be(data, reg);
-}
-
-static inline u64 rd_reg64(void __iomem *reg)
-{
-	if (caam_little_end)
-		return ioread64(reg);
-	else
-		return ioread64be(reg);
-}
-
-#else /* CONFIG_64BIT */
-static inline void wr_reg64(void __iomem *reg, u64 data)
-{
-#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
-	if (caam_little_end) {
-		wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);
-		wr_reg32((u32 __iomem *)(reg), data);
-	} else
 #endif
-	{
-		wr_reg32((u32 __iomem *)(reg), data >> 32);
-		wr_reg32((u32 __iomem *)(reg) + 1, data);
-	}
+		iowrite64be(data, reg);
 }
 
 static inline u64 rd_reg64(void __iomem *reg)
 {
 #ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
 	if (caam_little_end)
-		return ((u64)rd_reg32((u32 __iomem *)(reg) + 1) << 32 |
-			(u64)rd_reg32((u32 __iomem *)(reg)));
+		return ioread64(reg);
 	else
 #endif
-		return ((u64)rd_reg32((u32 __iomem *)(reg)) << 32 |
-			(u64)rd_reg32((u32 __iomem *)(reg) + 1));
+		return ioread64be(reg);
 }
-#endif /* CONFIG_64BIT  */
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 #ifdef CONFIG_SOC_IMX7D
-- 
2.11.0

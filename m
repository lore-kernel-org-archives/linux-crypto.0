From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 7/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when using io{read|write}64
Date: Sat, 24 Jun 2017 14:57:07 +0300
Message-ID: <20170624115707.30095-1-horia.geanta@nxp.com>
References: <411c4bb0-2709-1902-778a-bf4d7734e3e1@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Radu Solea <radu.solea@nxp.com>,
        Steve Cornelius <steve.cornelius@nxp.com>
To: Logan Gunthorpe <logang@deltatee.com>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-ntb@googlegroups.com>, <linux-alpha@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <411c4bb0-2709-1902-778a-bf4d7734e3e1@deltatee.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now that ioread64 and iowrite64 are always available we don't
need the ugly ifdefs to change their implementation when they
are not.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Dan Douglass <dan.douglass@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>

Updated patch such that behaviour does not change
from i.MX workaround point of view.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/regs.h | 33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 84d2f838a063..b893ebb24e65 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
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
2.12.0.264.gd6db3f216544

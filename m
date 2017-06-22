From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH 7/7] crypto: caam: cleanup CONFIG_64BIT ifdefs when using io{read|write}64
Date: Thu, 22 Jun 2017 10:48:17 -0600
Message-ID: <20170622164817.25515-8-logang@deltatee.com>
References: <20170622164817.25515-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-alpha@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Return-path: <linux-alpha-owner@vger.kernel.org>
In-Reply-To: <20170622164817.25515-1-logang@deltatee.com>
Sender: linux-alpha-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now that ioread64 and iowrite64 are always available we don't
need the ugly ifdefs to change their implementation when they
are not.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: Dan Douglass <dan.douglass@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/crypto/caam/regs.h | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 84d2f838a063..26fc19dd0c39 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -134,7 +134,6 @@ static inline void clrsetbits_32(void __iomem *reg, u32 clear, u32 set)
  *    base + 0x0000 : least-significant 32 bits
  *    base + 0x0004 : most-significant 32 bits
  */
-#ifdef CONFIG_64BIT
 static inline void wr_reg64(void __iomem *reg, u64 data)
 {
 	if (caam_little_end)
@@ -151,34 +150,6 @@ static inline u64 rd_reg64(void __iomem *reg)
 		return ioread64be(reg);
 }
 
-#else /* CONFIG_64BIT */
-static inline void wr_reg64(void __iomem *reg, u64 data)
-{
-#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
-	if (caam_little_end) {
-		wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);
-		wr_reg32((u32 __iomem *)(reg), data);
-	} else
-#endif
-	{
-		wr_reg32((u32 __iomem *)(reg), data >> 32);
-		wr_reg32((u32 __iomem *)(reg) + 1, data);
-	}
-}
-
-static inline u64 rd_reg64(void __iomem *reg)
-{
-#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
-	if (caam_little_end)
-		return ((u64)rd_reg32((u32 __iomem *)(reg) + 1) << 32 |
-			(u64)rd_reg32((u32 __iomem *)(reg)));
-	else
-#endif
-		return ((u64)rd_reg32((u32 __iomem *)(reg)) << 32 |
-			(u64)rd_reg32((u32 __iomem *)(reg) + 1));
-}
-#endif /* CONFIG_64BIT  */
-
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 #ifdef CONFIG_SOC_IMX7D
 #define cpu_to_caam_dma(value) \
-- 
2.11.0


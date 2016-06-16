From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: caam: fix misspelled upper_32_bits
Date: Thu, 16 Jun 2016 11:05:46 +0200
Message-ID: <20160616090609.1041337-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

An endianess fix mistakenly used higher_32_bits() instead of
upper_32_bits(), and that doesn't exist:

drivers/crypto/caam/desc_constr.h: In function 'append_ptr':
drivers/crypto/caam/desc_constr.h:84:75: error: implicit declaration of function 'higher_32_bits' [-Werror=implicit-function-declaration]
  *offset = cpu_to_caam_dma(ptr);

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 261ea058f016 ("crypto: caam - handle core endianness != caam endianness")
---
 drivers/crypto/caam/regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 8c766cf9202c..b3c5016f6458 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -183,10 +183,10 @@ static inline u64 rd_reg64(void __iomem *reg)
 #ifdef CONFIG_SOC_IMX7D
 #define cpu_to_caam_dma(value) \
 		(((u64)cpu_to_caam32(lower_32_bits(value)) << 32) | \
-		 (u64)cpu_to_caam32(higher_32_bits(value)))
+		  (u64)cpu_to_caam32(upper_32_bits(value)))
 #define caam_dma_to_cpu(value) \
 		(((u64)caam32_to_cpu(lower_32_bits(value)) << 32) | \
-		 (u64)caam32_to_cpu(higher_32_bits(value)))
+		  (u64)caam32_to_cpu(upper_32_bits(value)))
 #else
 #define cpu_to_caam_dma(value) cpu_to_caam64(value)
 #define caam_dma_to_cpu(value) caam64_to_cpu(value)
-- 
2.9.0

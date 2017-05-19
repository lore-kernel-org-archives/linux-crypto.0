From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 5/9] crypto: mv_cesa - Use IPAD/OPAD constant
Date: Fri, 19 May 2017 08:53:27 +0200
Message-ID: <20170519065331.27670-6-clabbe.montjoie@gmail.com>
References: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, qat-linux@intel.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        thomas.lendacky@amd.com, gary.hook@amd.com,
        boris.brezillon@free-electrons.com, arno@natisbad.org,
        matthias.bgg@gmail.com, giovanni.cabiddu@intel.com,
        salvatore.benedetto@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170519065331.27670-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch simply replace all occurrence of HMAC IPAD/OPAD value by their
define.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/mv_cesa.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 451fa18c1c7b..bf25f415eea6 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <crypto/hmac.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
 #include <linux/of.h>
@@ -822,8 +823,8 @@ static int mv_hash_setkey(struct crypto_ahash *tfm, const u8 * key,
 		memcpy(opad, ipad, bs);
 
 		for (i = 0; i < bs; i++) {
-			ipad[i] ^= 0x36;
-			opad[i] ^= 0x5c;
+			ipad[i] ^= HMAC_IPAD_VALUE;
+			opad[i] ^= HMAC_OPAD_VALUE;
 		}
 
 		rc = crypto_shash_init(shash) ? :
-- 
2.13.0

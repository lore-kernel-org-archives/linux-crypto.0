From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/9] crypto: brcm - Use IPAD/OPAD constant
Date: Mon, 24 Apr 2017 16:16:22 +0200
Message-ID: <20170424141629.27155-2-clabbe.montjoie@gmail.com>
References: <20170424141629.27155-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: qat-linux@intel.com, linux-kernel@vger.kernel.org,
 Corentin Labbe <clabbe.montjoie@gmail.com>, linux-crypto@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, thomas.lendacky@amd.com,
 gary.hook@amd.com, boris.brezillon@free-electrons.com, arno@natisbad.org,
 matthias.bgg@gmail.com, giovanni.cabiddu@intel.com,
 salvatore.benedetto@intel.com
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170424141629.27155-1-clabbe.montjoie@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

This patch simply replace all occurrence of HMAC IPAD/OPAD value by their
define.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/bcm/cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index cc0d5b9..304c7ed 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2510,8 +2510,8 @@ static int ahash_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 		memcpy(ctx->opad, ctx->ipad, blocksize);
 
 		for (index = 0; index < blocksize; index++) {
-			ctx->ipad[index] ^= 0x36;
-			ctx->opad[index] ^= 0x5c;
+			ctx->ipad[index] ^= HMAC_IPAD_VALUE;
+			ctx->opad[index] ^= HMAC_OPAD_VALUE;
 		}
 
 		flow_dump("  ipad: ", ctx->ipad, blocksize);
-- 
2.10.2

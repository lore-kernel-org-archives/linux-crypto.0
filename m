From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 20/20] crypto: mark Multi buffer SHA1 helper cipher
Date: Sat, 28 Mar 2015 00:02:30 +0100
Message-ID: <1904568.I4NK9lf4NM@tachyon.chronox.de>
References: <1746748.uPZFXamDiM@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1746748.uPZFXamDiM@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Flag all Multi buffer SHA1 helper ciphers as internal ciphers
to prevent them from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/sha-mb/sha1_mb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
index 9414fd9..e510b1c 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha-mb/sha1_mb.c
@@ -694,7 +694,8 @@ static struct shash_alg sha1_mb_shash_alg = {
 		 * use ASYNC flag as some buffers in multi-buffer
 		 * algo may not have completed before hashing thread sleep
 		 */
-		.cra_flags	 = CRYPTO_ALG_TYPE_SHASH | CRYPTO_ALG_ASYNC,
+		.cra_flags	 = CRYPTO_ALG_TYPE_SHASH | CRYPTO_ALG_ASYNC |
+				   CRYPTO_ALG_INTERNAL,
 		.cra_blocksize	 = SHA1_BLOCK_SIZE,
 		.cra_module	 = THIS_MODULE,
 		.cra_list	 = LIST_HEAD_INIT(sha1_mb_shash_alg.base.cra_list),
@@ -770,7 +771,9 @@ static int sha1_mb_async_init_tfm(struct crypto_tfm *tfm)
 	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct mcryptd_hash_ctx *mctx;
 
-	mcryptd_tfm = mcryptd_alloc_ahash("__intel_sha1-mb", 0, 0);
+	mcryptd_tfm = mcryptd_alloc_ahash("__intel_sha1-mb",
+					  CRYPTO_ALG_INTERNAL,
+					  CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(mcryptd_tfm))
 		return PTR_ERR(mcryptd_tfm);
 	mctx = crypto_ahash_ctx(&mcryptd_tfm->base);
-- 
2.1.0

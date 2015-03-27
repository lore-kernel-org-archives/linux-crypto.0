From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 07/20] crypto: mark GHASH ARMv8 vmull.p64 helper ciphers
Date: Fri, 27 Mar 2015 23:54 +0100
Message-ID: <6866738.b3jUbsQeMA@tachyon.chronox.de>
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

Flag all GHASH ARMv8 vmull.p64 helper ciphers as internal ciphers
to prevent them from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/arm/crypto/ghash-ce-glue.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 8c959d1..03a39fe 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -141,7 +141,7 @@ static struct shash_alg ghash_alg = {
 		.cra_name	= "ghash",
 		.cra_driver_name = "__driver-ghash-ce",
 		.cra_priority	= 0,
-		.cra_flags	= CRYPTO_ALG_TYPE_SHASH,
+		.cra_flags	= CRYPTO_ALG_TYPE_SHASH | CRYPTO_ALG_INTERNAL,
 		.cra_blocksize	= GHASH_BLOCK_SIZE,
 		.cra_ctxsize	= sizeof(struct ghash_key),
 		.cra_module	= THIS_MODULE,
@@ -248,7 +248,9 @@ static int ghash_async_init_tfm(struct crypto_tfm *tfm)
 	struct cryptd_ahash *cryptd_tfm;
 	struct ghash_async_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	cryptd_tfm = cryptd_alloc_ahash("__driver-ghash-ce", 0, 0);
+	cryptd_tfm = cryptd_alloc_ahash("__driver-ghash-ce",
+					CRYPTO_ALG_INTERNAL,
+					CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(cryptd_tfm))
 		return PTR_ERR(cryptd_tfm);
 	ctx->cryptd_tfm = cryptd_tfm;
-- 
2.1.0

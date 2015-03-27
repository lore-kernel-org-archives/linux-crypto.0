From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 06/20] crypto: mark ghash clmulni helper ciphers
Date: Fri, 27 Mar 2015 23:53:26 +0100
Message-ID: <4506917.K3R83TsDgA@tachyon.chronox.de>
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

Flag all ash clmulni helper ciphers as internal ciphers to prevent them
from being called by normal users.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 8253d85..2079baf 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -154,7 +154,8 @@ static struct shash_alg ghash_alg = {
 		.cra_name		= "__ghash",
 		.cra_driver_name	= "__ghash-pclmulqdqni",
 		.cra_priority		= 0,
-		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH |
+					  CRYPTO_ALG_INTERNAL,
 		.cra_blocksize		= GHASH_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct ghash_ctx),
 		.cra_module		= THIS_MODULE,
@@ -261,7 +262,9 @@ static int ghash_async_init_tfm(struct crypto_tfm *tfm)
 	struct cryptd_ahash *cryptd_tfm;
 	struct ghash_async_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	cryptd_tfm = cryptd_alloc_ahash("__ghash-pclmulqdqni", 0, 0);
+	cryptd_tfm = cryptd_alloc_ahash("__ghash-pclmulqdqni",
+					CRYPTO_ALG_INTERNAL,
+					CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(cryptd_tfm))
 		return PTR_ERR(cryptd_tfm);
 	ctx->cryptd_tfm = cryptd_tfm;
-- 
2.1.0

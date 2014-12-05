From: =?UTF-8?B?U3Zlbm5pbmcgU8O4cmVuc2Vu?= <sss@secomea.com>
Subject: Resend: [PATCH] CRYPTO: atmel_sha: remove unused shash fallback instance
Date: Fri, 5 Dec 2014 01:18:57 +0100
Message-ID: <5480F9F1.6000509@secomea.com>
References: <5480E764.7030508@secomea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 4dim-gw.4dim.as ([81.7.137.98]:21335 "EHLO
	SECOEXCHANGE.secomea.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932398AbaLEAUT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2014 19:20:19 -0500
In-Reply-To: <5480E764.7030508@secomea.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[Sorry about the messed up tabs and line wraps in first post;
I hope I managed to tame TB this time around]

CRYPTO: atmel_sha: remove unused shash fallback instance.

The fallback is never used, so there is no point in having it.

The cra_exit routine can also be removed, since all it did was releasing
the fallback, along with the stub around cra_init, which just added an
unused NULL argument.

Signed-off-by: Svenning Soerensen <sss@secomea.com>

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 9a4f69e..6ed3530 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -102,10 +102,6 @@ struct atmel_sha_ctx {
 	struct atmel_sha_dev	*dd;
 
 	unsigned long		flags;
-
-	/* fallback stuff */
-	struct crypto_shash	*fallback;
-
 };
 
 #define ATMEL_SHA_QUEUE_LENGTH	50
@@ -974,19 +970,8 @@ static int atmel_sha_digest(struct ahash_request *req)
 	return atmel_sha_init(req) ?: atmel_sha_finup(req);
 }
 
-static int atmel_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
+static int atmel_sha_cra_init(struct crypto_tfm *tfm)
 {
-	struct atmel_sha_ctx *tctx = crypto_tfm_ctx(tfm);
-	const char *alg_name = crypto_tfm_alg_name(tfm);
-
-	/* Allocate a fallback and abort if it failed. */
-	tctx->fallback = crypto_alloc_shash(alg_name, 0,
-					    CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(tctx->fallback)) {
-		pr_err("atmel-sha: fallback driver '%s' could not be loaded.\n",
-				alg_name);
-		return PTR_ERR(tctx->fallback);
-	}
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct atmel_sha_reqctx) +
 				 SHA_BUFFER_LEN + SHA512_BLOCK_SIZE);
@@ -994,19 +979,6 @@ static int atmel_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 	return 0;
 }
 
-static int atmel_sha_cra_init(struct crypto_tfm *tfm)
-{
-	return atmel_sha_cra_init_alg(tfm, NULL);
-}
-
-static void atmel_sha_cra_exit(struct crypto_tfm *tfm)
-{
-	struct atmel_sha_ctx *tctx = crypto_tfm_ctx(tfm);
-
-	crypto_free_shash(tctx->fallback);
-	tctx->fallback = NULL;
-}
-
 static struct ahash_alg sha_1_256_algs[] = {
 {
 	.init		= atmel_sha_init,
@@ -1020,14 +992,12 @@ static struct ahash_alg sha_1_256_algs[] = {
 			.cra_name		= "sha1",
 			.cra_driver_name	= "atmel-sha1",
 			.cra_priority		= 100,
-			.cra_flags		= CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_NEED_FALLBACK,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
 			.cra_blocksize		= SHA1_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct atmel_sha_ctx),
 			.cra_alignmask		= 0,
 			.cra_module		= THIS_MODULE,
 			.cra_init		= atmel_sha_cra_init,
-			.cra_exit		= atmel_sha_cra_exit,
 		}
 	}
 },
@@ -1043,14 +1013,12 @@ static struct ahash_alg sha_1_256_algs[] = {
 			.cra_name		= "sha256",
 			.cra_driver_name	= "atmel-sha256",
 			.cra_priority		= 100,
-			.cra_flags		= CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_NEED_FALLBACK,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
 			.cra_blocksize		= SHA256_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct atmel_sha_ctx),
 			.cra_alignmask		= 0,
 			.cra_module		= THIS_MODULE,
 			.cra_init		= atmel_sha_cra_init,
-			.cra_exit		= atmel_sha_cra_exit,
 		}
 	}
 },
@@ -1068,14 +1036,12 @@ static struct ahash_alg sha_224_alg = {
 			.cra_name		= "sha224",
 			.cra_driver_name	= "atmel-sha224",
 			.cra_priority		= 100,
-			.cra_flags		= CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_NEED_FALLBACK,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
 			.cra_blocksize		= SHA224_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct atmel_sha_ctx),
 			.cra_alignmask		= 0,
 			.cra_module		= THIS_MODULE,
 			.cra_init		= atmel_sha_cra_init,
-			.cra_exit		= atmel_sha_cra_exit,
 		}
 	}
 };
@@ -1093,14 +1059,12 @@ static struct ahash_alg sha_384_512_algs[] = {
 			.cra_name		= "sha384",
 			.cra_driver_name	= "atmel-sha384",
 			.cra_priority		= 100,
-			.cra_flags		= CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_NEED_FALLBACK,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
 			.cra_blocksize		= SHA384_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct atmel_sha_ctx),
 			.cra_alignmask		= 0x3,
 			.cra_module		= THIS_MODULE,
 			.cra_init		= atmel_sha_cra_init,
-			.cra_exit		= atmel_sha_cra_exit,
 		}
 	}
 },
@@ -1116,14 +1080,12 @@ static struct ahash_alg sha_384_512_algs[] = {
 			.cra_name		= "sha512",
 			.cra_driver_name	= "atmel-sha512",
 			.cra_priority		= 100,
-			.cra_flags		= CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_NEED_FALLBACK,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
 			.cra_blocksize		= SHA512_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct atmel_sha_ctx),
 			.cra_alignmask		= 0x3,
 			.cra_module		= THIS_MODULE,
 			.cra_init		= atmel_sha_cra_init,
-			.cra_exit		= atmel_sha_cra_exit,
 		}
 	}
 },

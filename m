From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/2] crypto: talitos - consolidate common cra_* assignments
Date: Wed, 8 Aug 2012 20:33:34 -0500
Message-ID: <20120808203334.714fac505024e11ed7afa06a@freescale.com>
References: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
	<1343917001-20001-5-git-send-email-horia.geanta@freescale.com>
	<20120806204751.1f6277ba8f7b1de92fd128ac@freescale.com>
	<FD18E5D573A8AB48A365D4D78185DE9929291E@039-SN1MPN1-001.039d.mgd.msft.net>
	<FD18E5D573A8AB48A365D4D78185DE99293799@039-SN1MPN1-001.039d.mgd.msft.net>
	<20120807212748.d805c751b83e14e20b397cc1@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:43656
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822Ab2HIBfn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Aug 2012 21:35:43 -0400
In-Reply-To: <20120807212748.d805c751b83e14e20b397cc1@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

the entry points and geniv definitions for all aead,
ablkcipher, and hash algorithms are all common; move them to a
single assignment in talitos_alg_alloc().

This assumes it's ok to assign a setkey() on non-hmac algs.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---

 drivers/crypto/talitos.c | 163 +++++------------------------------------------
 1 file changed, 17 insertions(+), 146 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index df4a266..f414983 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2380,12 +2380,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = AES_BLOCK_SIZE,
 				.maxauthsize = SHA1_DIGEST_SIZE,
 			}
@@ -2405,12 +2399,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = DES3_EDE_BLOCK_SIZE,
 				.maxauthsize = SHA1_DIGEST_SIZE,
 			}
@@ -2431,12 +2419,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = AES_BLOCK_SIZE,
 				.maxauthsize = SHA224_DIGEST_SIZE,
 			}
@@ -2456,12 +2438,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = DES3_EDE_BLOCK_SIZE,
 				.maxauthsize = SHA224_DIGEST_SIZE,
 			}
@@ -2482,12 +2458,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = AES_BLOCK_SIZE,
 				.maxauthsize = SHA256_DIGEST_SIZE,
 			}
@@ -2507,12 +2477,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = DES3_EDE_BLOCK_SIZE,
 				.maxauthsize = SHA256_DIGEST_SIZE,
 			}
@@ -2533,12 +2497,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = AES_BLOCK_SIZE,
 				.maxauthsize = SHA384_DIGEST_SIZE,
 			}
@@ -2558,12 +2516,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = DES3_EDE_BLOCK_SIZE,
 				.maxauthsize = SHA384_DIGEST_SIZE,
 			}
@@ -2584,12 +2536,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = AES_BLOCK_SIZE,
 				.maxauthsize = SHA512_DIGEST_SIZE,
 			}
@@ -2609,12 +2555,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = DES3_EDE_BLOCK_SIZE,
 				.maxauthsize = SHA512_DIGEST_SIZE,
 			}
@@ -2635,12 +2575,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = AES_BLOCK_SIZE,
 				.maxauthsize = MD5_DIGEST_SIZE,
 			}
@@ -2660,12 +2594,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
 			.cra_aead = {
-				.setkey = aead_setkey,
-				.setauthsize = aead_setauthsize,
-				.encrypt = aead_encrypt,
-				.decrypt = aead_decrypt,
-				.givencrypt = aead_givencrypt,
-				.geniv = "<built-in>",
 				.ivsize = DES3_EDE_BLOCK_SIZE,
 				.maxauthsize = MD5_DIGEST_SIZE,
 			}
@@ -2688,10 +2616,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
                                      CRYPTO_ALG_ASYNC,
 			.cra_ablkcipher = {
-				.setkey = ablkcipher_setkey,
-				.encrypt = ablkcipher_encrypt,
-				.decrypt = ablkcipher_decrypt,
-				.geniv = "eseqiv",
 				.min_keysize = AES_MIN_KEY_SIZE,
 				.max_keysize = AES_MAX_KEY_SIZE,
 				.ivsize = AES_BLOCK_SIZE,
@@ -2709,10 +2633,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
                                      CRYPTO_ALG_ASYNC,
 			.cra_ablkcipher = {
-				.setkey = ablkcipher_setkey,
-				.encrypt = ablkcipher_encrypt,
-				.decrypt = ablkcipher_decrypt,
-				.geniv = "eseqiv",
 				.min_keysize = DES3_EDE_KEY_SIZE,
 				.max_keysize = DES3_EDE_KEY_SIZE,
 				.ivsize = DES3_EDE_BLOCK_SIZE,
@@ -2726,11 +2646,6 @@ static struct talitos_alg_template driver_algs[] = {
 	/* AHASH algorithms. */
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
 			.halg.digestsize = MD5_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "md5",
@@ -2746,11 +2661,6 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
 			.halg.digestsize = SHA1_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "sha1",
@@ -2766,11 +2676,6 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
 			.halg.digestsize = SHA224_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "sha224",
@@ -2786,11 +2691,6 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
 			.halg.digestsize = SHA256_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "sha256",
@@ -2806,11 +2706,6 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
 			.halg.digestsize = SHA384_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "sha384",
@@ -2826,11 +2721,6 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
 			.halg.digestsize = SHA512_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "sha512",
@@ -2846,12 +2736,6 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
-			.setkey = ahash_setkey,
 			.halg.digestsize = MD5_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "hmac(md5)",
@@ -2867,12 +2751,6 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
-			.setkey = ahash_setkey,
 			.halg.digestsize = SHA1_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "hmac(sha1)",
@@ -2888,12 +2766,6 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
-			.setkey = ahash_setkey,
 			.halg.digestsize = SHA224_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "hmac(sha224)",
@@ -2909,12 +2781,6 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
-			.setkey = ahash_setkey,
 			.halg.digestsize = SHA256_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "hmac(sha256)",
@@ -2930,12 +2796,6 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
-			.setkey = ahash_setkey,
 			.halg.digestsize = SHA384_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "hmac(sha384)",
@@ -2951,12 +2811,6 @@ static struct talitos_alg_template driver_algs[] = {
 	},
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.hash = {
-			.init = ahash_init,
-			.update = ahash_update,
-			.final = ahash_final,
-			.finup = ahash_finup,
-			.digest = ahash_digest,
-			.setkey = ahash_setkey,
 			.halg.digestsize = SHA512_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "hmac(sha512)",
@@ -3122,16 +2976,33 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		alg = &t_alg->algt.alg.crypto;
 		alg->cra_init = talitos_cra_init;
 		alg->cra_type = &crypto_ablkcipher_type;
+		alg->cra_ablkcipher.setkey = ablkcipher_setkey;
+		alg->cra_ablkcipher.encrypt = ablkcipher_encrypt;
+		alg->cra_ablkcipher.decrypt = ablkcipher_decrypt;
+		alg->cra_ablkcipher.geniv = "eseqiv";
 		break;
 	case CRYPTO_ALG_TYPE_AEAD:
 		alg = &t_alg->algt.alg.crypto;
 		alg->cra_init = talitos_cra_init_aead;
 		alg->cra_type = &crypto_aead_type;
+		alg->cra_aead.setkey = aead_setkey;
+		alg->cra_aead.setauthsize = aead_setauthsize;
+		alg->cra_aead.encrypt = aead_encrypt;
+		alg->cra_aead.decrypt = aead_decrypt;
+		alg->cra_aead.givencrypt = aead_givencrypt;
+		alg->cra_aead.geniv = "<built-in>";
 		break;
 	case CRYPTO_ALG_TYPE_AHASH:
 		alg = &t_alg->algt.alg.hash.halg.base;
 		alg->cra_init = talitos_cra_init_ahash;
 		alg->cra_type = &crypto_ahash_type;
+		t_alg->algt.alg.hash.init = ahash_init;
+		t_alg->algt.alg.hash.update = ahash_update;
+		t_alg->algt.alg.hash.final = ahash_final;
+		t_alg->algt.alg.hash.finup = ahash_finup;
+		t_alg->algt.alg.hash.digest = ahash_digest;
+		t_alg->algt.alg.hash.setkey = ahash_setkey;
+
 		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
 		    !strncmp(alg->cra_name, "hmac", 4)) {
 			kfree(t_alg);
-- 
1.7.11.3

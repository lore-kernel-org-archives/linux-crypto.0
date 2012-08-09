From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/2] crypto: talitos - consolidate cra_type assignments
Date: Wed, 8 Aug 2012 20:32:00 -0500
Message-ID: <20120808203200.54353e16f8bd5e8a6b839f2f@freescale.com>
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
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:39016
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822Ab2HIBeI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Aug 2012 21:34:08 -0400
In-Reply-To: <20120807212748.d805c751b83e14e20b397cc1@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

lighten driver_algs[] by moving them to talitos_alg_alloc().

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
these two patches apply on top of all remaining talitos patches -
including XOR support - currently on linux-crypto (i.e., that
haven't been applied to the cryptodev tree).

 drivers/crypto/talitos.c | 29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index e0b097f..df4a266 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2379,7 +2379,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2405,7 +2404,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-sha1-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2432,7 +2430,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-sha224-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2458,7 +2455,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-sha224-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2485,7 +2481,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2511,7 +2506,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-sha256-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2538,7 +2532,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-sha384-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2564,7 +2557,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-sha384-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2591,7 +2583,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-sha512-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2617,7 +2608,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-sha512-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2644,7 +2634,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-md5-cbc-aes-talitos",
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2670,7 +2659,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_driver_name = "authenc-hmac-md5-cbc-3des-talitos",
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_aead_type,
 			.cra_aead = {
 				.setkey = aead_setkey,
 				.setauthsize = aead_setauthsize,
@@ -2699,7 +2687,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
                                      CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_ablkcipher_type,
 			.cra_ablkcipher = {
 				.setkey = ablkcipher_setkey,
 				.encrypt = ablkcipher_encrypt,
@@ -2721,7 +2708,6 @@ static struct talitos_alg_template driver_algs[] = {
 			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
                                      CRYPTO_ALG_ASYNC,
-			.cra_type = &crypto_ablkcipher_type,
 			.cra_ablkcipher = {
 				.setkey = ablkcipher_setkey,
 				.encrypt = ablkcipher_encrypt,
@@ -2752,7 +2738,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = MD5_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2773,7 +2758,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2794,7 +2778,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2815,7 +2798,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2836,7 +2818,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2857,7 +2838,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2879,7 +2859,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = MD5_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2901,7 +2880,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2923,7 +2901,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2945,7 +2922,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2967,7 +2943,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -2989,7 +2964,6 @@ static struct talitos_alg_template driver_algs[] = {
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
 					     CRYPTO_ALG_ASYNC,
-				.cra_type = &crypto_ahash_type
 			}
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
@@ -3147,14 +3121,17 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
 		alg = &t_alg->algt.alg.crypto;
 		alg->cra_init = talitos_cra_init;
+		alg->cra_type = &crypto_ablkcipher_type;
 		break;
 	case CRYPTO_ALG_TYPE_AEAD:
 		alg = &t_alg->algt.alg.crypto;
 		alg->cra_init = talitos_cra_init_aead;
+		alg->cra_type = &crypto_aead_type;
 		break;
 	case CRYPTO_ALG_TYPE_AHASH:
 		alg = &t_alg->algt.alg.hash.halg.base;
 		alg->cra_init = talitos_cra_init_ahash;
+		alg->cra_type = &crypto_ahash_type;
 		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
 		    !strncmp(alg->cra_name, "hmac", 4)) {
 			kfree(t_alg);
-- 
1.7.11.3

Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76D8C04A6A
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Aug 2023 06:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjHMGzj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Aug 2023 02:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjHMGzH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Aug 2023 02:55:07 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852CD170E
        for <linux-crypto@vger.kernel.org>; Sat, 12 Aug 2023 23:55:06 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qV509-002bvG-LS; Sun, 13 Aug 2023 14:55:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 13 Aug 2023 14:55:01 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sun, 13 Aug 2023 14:55:01 +0800
Subject: [v2 PATCH 27/36] crypto: caam - Use new crypto_engine_op interface
References: <ZNh94a7YYnvx0l8C@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qV509-002bvG-LS@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_op interface where the callback is stored
in the algorithm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/caamalg.c  |  382 +++++++++++++++++++++++++++++++----------
 drivers/crypto/caam/caamhash.c |   28 +--
 drivers/crypto/caam/caampkc.c  |   20 +-
 drivers/crypto/caam/caampkc.h  |    3 
 4 files changed, 320 insertions(+), 113 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index da8182ee86fe..eba2d750c3b0 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -57,11 +57,14 @@
 #include "key_gen.h"
 #include "caamalg_desc.h"
 #include <asm/unaligned.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/engine.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -95,13 +98,13 @@ struct caam_alg_entry {
 };
 
 struct caam_aead_alg {
-	struct aead_alg aead;
+	struct aead_engine_alg aead;
 	struct caam_alg_entry caam;
 	bool registered;
 };
 
 struct caam_skcipher_alg {
-	struct skcipher_alg skcipher;
+	struct skcipher_engine_alg skcipher;
 	struct caam_alg_entry caam;
 	bool registered;
 };
@@ -110,7 +113,6 @@ struct caam_skcipher_alg {
  * per-session context
  */
 struct caam_ctx {
-	struct crypto_engine_ctx enginectx;
 	u32 sh_desc_enc[DESC_MAX_USED_LEN];
 	u32 sh_desc_dec[DESC_MAX_USED_LEN];
 	u8 key[CAAM_MAX_KEY_SIZE];
@@ -188,7 +190,8 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 static int aead_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_aead_alg *alg = container_of(crypto_aead_alg(aead),
-						 struct caam_aead_alg, aead);
+						 struct caam_aead_alg,
+						 aead.base);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx_dma(aead);
 	struct device *jrdev = ctx->jrdev;
@@ -738,7 +741,7 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	struct caam_ctx *ctx = crypto_skcipher_ctx_dma(skcipher);
 	struct caam_skcipher_alg *alg =
 		container_of(crypto_skcipher_alg(skcipher), typeof(*alg),
-			     skcipher);
+			     skcipher.base);
 	struct device *jrdev = ctx->jrdev;
 	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
 	u32 *desc;
@@ -1195,7 +1198,8 @@ static void init_authenc_job(struct aead_request *req,
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_aead_alg *alg = container_of(crypto_aead_alg(aead),
-						 struct caam_aead_alg, aead);
+						 struct caam_aead_alg,
+						 aead.base);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx_dma(aead);
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jrdev->parent);
@@ -1881,7 +1885,7 @@ static int skcipher_decrypt(struct skcipher_request *req)
 
 static struct caam_skcipher_alg driver_algs[] = {
 	{
-		.skcipher = {
+		.skcipher.base = {
 			.base = {
 				.cra_name = "cbc(aes)",
 				.cra_driver_name = "cbc-aes-caam",
@@ -1894,10 +1898,13 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
 		},
+		.skcipher.op = {
+			.do_one_request = skcipher_do_one_req,
+		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 	},
 	{
-		.skcipher = {
+		.skcipher.base = {
 			.base = {
 				.cra_name = "cbc(des3_ede)",
 				.cra_driver_name = "cbc-3des-caam",
@@ -1910,10 +1917,13 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 		},
+		.skcipher.op = {
+			.do_one_request = skcipher_do_one_req,
+		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 	},
 	{
-		.skcipher = {
+		.skcipher.base = {
 			.base = {
 				.cra_name = "cbc(des)",
 				.cra_driver_name = "cbc-des-caam",
@@ -1926,10 +1936,13 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.max_keysize = DES_KEY_SIZE,
 			.ivsize = DES_BLOCK_SIZE,
 		},
+		.skcipher.op = {
+			.do_one_request = skcipher_do_one_req,
+		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 	},
 	{
-		.skcipher = {
+		.skcipher.base = {
 			.base = {
 				.cra_name = "ctr(aes)",
 				.cra_driver_name = "ctr-aes-caam",
@@ -1943,11 +1956,14 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.chunksize = AES_BLOCK_SIZE,
 		},
+		.skcipher.op = {
+			.do_one_request = skcipher_do_one_req,
+		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES |
 					OP_ALG_AAI_CTR_MOD128,
 	},
 	{
-		.skcipher = {
+		.skcipher.base = {
 			.base = {
 				.cra_name = "rfc3686(ctr(aes))",
 				.cra_driver_name = "rfc3686-ctr-aes-caam",
@@ -1963,6 +1979,9 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.chunksize = AES_BLOCK_SIZE,
 		},
+		.skcipher.op = {
+			.do_one_request = skcipher_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -1970,7 +1989,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 		},
 	},
 	{
-		.skcipher = {
+		.skcipher.base = {
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-caam",
@@ -1984,10 +2003,13 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.max_keysize = 2 * AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
 		},
+		.skcipher.op = {
+			.do_one_request = skcipher_do_one_req,
+		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_XTS,
 	},
 	{
-		.skcipher = {
+		.skcipher.base = {
 			.base = {
 				.cra_name = "ecb(des)",
 				.cra_driver_name = "ecb-des-caam",
@@ -1999,10 +2021,13 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
 		},
+		.skcipher.op = {
+			.do_one_request = skcipher_do_one_req,
+		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_ECB,
 	},
 	{
-		.skcipher = {
+		.skcipher.base = {
 			.base = {
 				.cra_name = "ecb(aes)",
 				.cra_driver_name = "ecb-aes-caam",
@@ -2014,10 +2039,13 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 		},
+		.skcipher.op = {
+			.do_one_request = skcipher_do_one_req,
+		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_ECB,
 	},
 	{
-		.skcipher = {
+		.skcipher.base = {
 			.base = {
 				.cra_name = "ecb(des3_ede)",
 				.cra_driver_name = "ecb-des3-caam",
@@ -2029,13 +2057,16 @@ static struct caam_skcipher_alg driver_algs[] = {
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
 		},
+		.skcipher.op = {
+			.do_one_request = skcipher_do_one_req,
+		},
 		.caam.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_ECB,
 	},
 };
 
 static struct caam_aead_alg driver_aeads[] = {
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "rfc4106(gcm(aes))",
 				.cra_driver_name = "rfc4106-gcm-aes-caam",
@@ -2048,13 +2079,16 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = GCM_RFC4106_IV_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
 			.nodkp = true,
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "rfc4543(gcm(aes))",
 				.cra_driver_name = "rfc4543-gcm-aes-caam",
@@ -2067,6 +2101,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = GCM_RFC4543_IV_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
 			.nodkp = true,
@@ -2074,7 +2111,7 @@ static struct caam_aead_alg driver_aeads[] = {
 	},
 	/* Galois Counter Mode */
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "gcm(aes)",
 				.cra_driver_name = "gcm-aes-caam",
@@ -2087,6 +2124,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = GCM_AES_IV_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
 			.nodkp = true,
@@ -2094,7 +2134,7 @@ static struct caam_aead_alg driver_aeads[] = {
 	},
 	/* single-pass ipsec_esp descriptor */
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(md5),"
 					    "ecb(cipher_null))",
@@ -2109,13 +2149,16 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = NULL_IV_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
 					   OP_ALG_AAI_HMAC_PRECOMP,
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha1),"
 					    "ecb(cipher_null))",
@@ -2130,13 +2173,16 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = NULL_IV_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
 					   OP_ALG_AAI_HMAC_PRECOMP,
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha224),"
 					    "ecb(cipher_null))",
@@ -2151,13 +2197,16 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = NULL_IV_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
 					   OP_ALG_AAI_HMAC_PRECOMP,
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha256),"
 					    "ecb(cipher_null))",
@@ -2172,13 +2221,16 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = NULL_IV_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
 					   OP_ALG_AAI_HMAC_PRECOMP,
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha384),"
 					    "ecb(cipher_null))",
@@ -2193,13 +2245,16 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = NULL_IV_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
 					   OP_ALG_AAI_HMAC_PRECOMP,
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha512),"
 					    "ecb(cipher_null))",
@@ -2214,13 +2269,16 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = NULL_IV_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
 					   OP_ALG_AAI_HMAC_PRECOMP,
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-md5-"
@@ -2234,6 +2292,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
@@ -2241,7 +2302,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(md5),"
 					    "cbc(aes)))",
@@ -2256,6 +2317,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
@@ -2264,7 +2328,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha1),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha1-"
@@ -2278,6 +2342,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
@@ -2285,7 +2352,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha1),"
 					    "cbc(aes)))",
@@ -2300,6 +2367,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
@@ -2308,7 +2378,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha224),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha224-"
@@ -2322,6 +2392,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
@@ -2329,7 +2402,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha224),"
 					    "cbc(aes)))",
@@ -2344,6 +2417,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
@@ -2352,7 +2428,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha256),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha256-"
@@ -2366,6 +2442,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
@@ -2373,7 +2452,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha256),"
 					    "cbc(aes)))",
@@ -2388,6 +2467,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
@@ -2396,7 +2478,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha384),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha384-"
@@ -2410,6 +2492,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
@@ -2417,7 +2502,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha384),"
 					    "cbc(aes)))",
@@ -2432,6 +2517,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
@@ -2440,7 +2528,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha512),cbc(aes))",
 				.cra_driver_name = "authenc-hmac-sha512-"
@@ -2454,6 +2542,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
@@ -2461,7 +2552,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha512),"
 					    "cbc(aes)))",
@@ -2476,6 +2567,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
@@ -2484,7 +2578,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
 				.cra_driver_name = "authenc-hmac-md5-"
@@ -2498,6 +2592,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
@@ -2505,7 +2602,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		}
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(md5),"
 					    "cbc(des3_ede)))",
@@ -2520,6 +2617,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
@@ -2528,7 +2628,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		}
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha1),"
 					    "cbc(des3_ede))",
@@ -2543,6 +2643,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
@@ -2550,7 +2653,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha1),"
 					    "cbc(des3_ede)))",
@@ -2566,6 +2669,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
@@ -2574,7 +2680,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha224),"
 					    "cbc(des3_ede))",
@@ -2589,6 +2695,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
@@ -2596,7 +2705,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha224),"
 					    "cbc(des3_ede)))",
@@ -2612,6 +2721,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
@@ -2620,7 +2732,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha256),"
 					    "cbc(des3_ede))",
@@ -2635,6 +2747,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
@@ -2642,7 +2757,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha256),"
 					    "cbc(des3_ede)))",
@@ -2658,6 +2773,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
@@ -2666,7 +2784,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha384),"
 					    "cbc(des3_ede))",
@@ -2681,6 +2799,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
@@ -2688,7 +2809,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha384),"
 					    "cbc(des3_ede)))",
@@ -2704,6 +2825,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
@@ -2712,7 +2836,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha512),"
 					    "cbc(des3_ede))",
@@ -2727,6 +2851,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
@@ -2734,7 +2861,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha512),"
 					    "cbc(des3_ede)))",
@@ -2750,6 +2877,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
@@ -2758,7 +2888,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(md5),cbc(des))",
 				.cra_driver_name = "authenc-hmac-md5-"
@@ -2772,6 +2902,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
@@ -2779,7 +2912,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(md5),"
 					    "cbc(des)))",
@@ -2794,6 +2927,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
@@ -2802,7 +2938,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha1),cbc(des))",
 				.cra_driver_name = "authenc-hmac-sha1-"
@@ -2816,6 +2952,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
@@ -2823,7 +2962,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha1),"
 					    "cbc(des)))",
@@ -2838,6 +2977,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
@@ -2846,7 +2988,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha224),cbc(des))",
 				.cra_driver_name = "authenc-hmac-sha224-"
@@ -2860,6 +3002,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
@@ -2867,7 +3012,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha224),"
 					    "cbc(des)))",
@@ -2882,6 +3027,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
@@ -2890,7 +3038,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha256),cbc(des))",
 				.cra_driver_name = "authenc-hmac-sha256-"
@@ -2904,6 +3052,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
@@ -2911,7 +3062,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha256),"
 					    "cbc(des)))",
@@ -2926,6 +3077,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
@@ -2934,7 +3088,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha384),cbc(des))",
 				.cra_driver_name = "authenc-hmac-sha384-"
@@ -2948,6 +3102,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
@@ -2955,7 +3112,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha384),"
 					    "cbc(des)))",
@@ -2970,6 +3127,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
@@ -2978,7 +3138,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha512),cbc(des))",
 				.cra_driver_name = "authenc-hmac-sha512-"
@@ -2992,6 +3152,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
@@ -2999,7 +3162,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "echainiv(authenc(hmac(sha512),"
 					    "cbc(des)))",
@@ -3014,6 +3177,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
 			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
@@ -3022,7 +3188,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(md5),"
 					    "rfc3686(ctr(aes)))",
@@ -3037,6 +3203,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3046,7 +3215,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "seqiv(authenc("
 					    "hmac(md5),rfc3686(ctr(aes))))",
@@ -3061,6 +3230,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3071,7 +3243,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha1),"
 					    "rfc3686(ctr(aes)))",
@@ -3086,6 +3258,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3095,7 +3270,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "seqiv(authenc("
 					    "hmac(sha1),rfc3686(ctr(aes))))",
@@ -3110,6 +3285,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3120,7 +3298,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha224),"
 					    "rfc3686(ctr(aes)))",
@@ -3135,6 +3313,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3144,7 +3325,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "seqiv(authenc("
 					    "hmac(sha224),rfc3686(ctr(aes))))",
@@ -3159,6 +3340,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3169,7 +3353,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha256),"
 					    "rfc3686(ctr(aes)))",
@@ -3184,6 +3368,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3193,7 +3380,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "seqiv(authenc(hmac(sha256),"
 					    "rfc3686(ctr(aes))))",
@@ -3208,6 +3395,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3218,7 +3408,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha384),"
 					    "rfc3686(ctr(aes)))",
@@ -3233,6 +3423,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3242,7 +3435,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "seqiv(authenc(hmac(sha384),"
 					    "rfc3686(ctr(aes))))",
@@ -3257,6 +3450,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3267,7 +3463,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "authenc(hmac(sha512),"
 					    "rfc3686(ctr(aes)))",
@@ -3282,6 +3478,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3291,7 +3490,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "seqiv(authenc(hmac(sha512),"
 					    "rfc3686(ctr(aes))))",
@@ -3306,6 +3505,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_AES |
 					   OP_ALG_AAI_CTR_MOD128,
@@ -3316,7 +3518,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "rfc7539(chacha20,poly1305)",
 				.cra_driver_name = "rfc7539-chacha20-poly1305-"
@@ -3330,6 +3532,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = CHACHAPOLY_IV_SIZE,
 			.maxauthsize = POLY1305_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_CHACHA20 |
 					   OP_ALG_AAI_AEAD,
@@ -3339,7 +3544,7 @@ static struct caam_aead_alg driver_aeads[] = {
 		},
 	},
 	{
-		.aead = {
+		.aead.base = {
 			.base = {
 				.cra_name = "rfc7539esp(chacha20,poly1305)",
 				.cra_driver_name = "rfc7539esp-chacha20-"
@@ -3353,6 +3558,9 @@ static struct caam_aead_alg driver_aeads[] = {
 			.ivsize = 8,
 			.maxauthsize = POLY1305_DIGEST_SIZE,
 		},
+		.aead.op = {
+			.do_one_request = aead_do_one_req,
+		},
 		.caam = {
 			.class1_alg_type = OP_ALG_ALGSEL_CHACHA20 |
 					   OP_ALG_AAI_AEAD,
@@ -3412,13 +3620,11 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 {
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct caam_skcipher_alg *caam_alg =
-		container_of(alg, typeof(*caam_alg), skcipher);
+		container_of(alg, typeof(*caam_alg), skcipher.base);
 	struct caam_ctx *ctx = crypto_skcipher_ctx_dma(tfm);
 	u32 alg_aai = caam_alg->caam.class1_alg_type & OP_ALG_AAI_MASK;
 	int ret = 0;
 
-	ctx->enginectx.op.do_one_request = skcipher_do_one_req;
-
 	if (alg_aai == OP_ALG_AAI_XTS) {
 		const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
 		struct crypto_skcipher *fallback;
@@ -3449,13 +3655,11 @@ static int caam_aead_init(struct crypto_aead *tfm)
 {
 	struct aead_alg *alg = crypto_aead_alg(tfm);
 	struct caam_aead_alg *caam_alg =
-		 container_of(alg, struct caam_aead_alg, aead);
+		 container_of(alg, struct caam_aead_alg, aead.base);
 	struct caam_ctx *ctx = crypto_aead_ctx_dma(tfm);
 
 	crypto_aead_set_reqsize(tfm, sizeof(struct caam_aead_req_ctx));
 
-	ctx->enginectx.op.do_one_request = aead_do_one_req;
-
 	return caam_init_common(ctx, &caam_alg->caam, !caam_alg->caam.nodkp);
 }
 
@@ -3490,20 +3694,20 @@ void caam_algapi_exit(void)
 		struct caam_aead_alg *t_alg = driver_aeads + i;
 
 		if (t_alg->registered)
-			crypto_unregister_aead(&t_alg->aead);
+			crypto_engine_unregister_aead(&t_alg->aead);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
 		struct caam_skcipher_alg *t_alg = driver_algs + i;
 
 		if (t_alg->registered)
-			crypto_unregister_skcipher(&t_alg->skcipher);
+			crypto_engine_unregister_skcipher(&t_alg->skcipher);
 	}
 }
 
 static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 {
-	struct skcipher_alg *alg = &t_alg->skcipher;
+	struct skcipher_alg *alg = &t_alg->skcipher.base;
 
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
@@ -3517,7 +3721,7 @@ static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 
 static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
 {
-	struct aead_alg *alg = &t_alg->aead;
+	struct aead_alg *alg = &t_alg->aead.base;
 
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = CAAM_CRA_PRIORITY;
@@ -3607,10 +3811,10 @@ int caam_algapi_init(struct device *ctrldev)
 
 		caam_skcipher_alg_init(t_alg);
 
-		err = crypto_register_skcipher(&t_alg->skcipher);
+		err = crypto_engine_register_skcipher(&t_alg->skcipher);
 		if (err) {
 			pr_warn("%s alg registration failed\n",
-				t_alg->skcipher.base.cra_driver_name);
+				t_alg->skcipher.base.base.cra_driver_name);
 			continue;
 		}
 
@@ -3654,15 +3858,15 @@ int caam_algapi_init(struct device *ctrldev)
 		 * if MD or MD size is not supported by device.
 		 */
 		if (is_mdha(c2_alg_sel) &&
-		    (!md_inst || t_alg->aead.maxauthsize > md_limit))
+		    (!md_inst || t_alg->aead.base.maxauthsize > md_limit))
 			continue;
 
 		caam_aead_alg_init(t_alg);
 
-		err = crypto_register_aead(&t_alg->aead);
+		err = crypto_engine_register_aead(&t_alg->aead);
 		if (err) {
 			pr_warn("%s alg registration failed\n",
-				t_alg->aead.base.cra_driver_name);
+				t_alg->aead.base.base.cra_driver_name);
 			continue;
 		}
 
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 9ef25387f6b6..290c8500c247 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -66,8 +66,12 @@
 #include "key_gen.h"
 #include "caamhash_desc.h"
 #include <crypto/internal/engine.h>
+#include <crypto/internal/hash.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
 #define CAAM_CRA_PRIORITY		3000
 
@@ -89,7 +93,6 @@ static struct list_head hash_list;
 
 /* ahash per-session context */
 struct caam_hash_ctx {
-	struct crypto_engine_ctx enginectx;
 	u32 sh_desc_update[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
 	u32 sh_desc_update_first[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
 	u32 sh_desc_fin[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
@@ -1750,7 +1753,7 @@ static struct caam_hash_template driver_hash[] = {
 struct caam_hash_alg {
 	struct list_head entry;
 	int alg_type;
-	struct ahash_alg ahash_alg;
+	struct ahash_engine_alg ahash_alg;
 };
 
 static int caam_hash_cra_init(struct crypto_tfm *tfm)
@@ -1762,7 +1765,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	struct ahash_alg *alg =
 		 container_of(halg, struct ahash_alg, halg);
 	struct caam_hash_alg *caam_hash =
-		 container_of(alg, struct caam_hash_alg, ahash_alg);
+		 container_of(alg, struct caam_hash_alg, ahash_alg.base);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx_dma(ahash);
 	/* Sizes for MDHA running digests: MD5, SHA1, 224, 256, 384, 512 */
 	static const u8 runninglen[] = { HASH_MSG_LEN + MD5_DIGEST_SIZE,
@@ -1853,8 +1856,6 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 						      sh_desc_digest) -
 					sh_desc_update_offset;
 
-	ctx->enginectx.op.do_one_request = ahash_do_one_req;
-
 	crypto_ahash_set_reqsize_dma(ahash, sizeof(struct caam_hash_state));
 
 	/*
@@ -1887,7 +1888,7 @@ void caam_algapi_hash_exit(void)
 		return;
 
 	list_for_each_entry_safe(t_alg, n, &hash_list, entry) {
-		crypto_unregister_ahash(&t_alg->ahash_alg);
+		crypto_engine_unregister_ahash(&t_alg->ahash_alg);
 		list_del(&t_alg->entry);
 		kfree(t_alg);
 	}
@@ -1905,8 +1906,8 @@ caam_hash_alloc(struct caam_hash_template *template,
 	if (!t_alg)
 		return ERR_PTR(-ENOMEM);
 
-	t_alg->ahash_alg = template->template_ahash;
-	halg = &t_alg->ahash_alg;
+	t_alg->ahash_alg.base = template->template_ahash;
+	halg = &t_alg->ahash_alg.base;
 	alg = &halg->halg.base;
 
 	if (keyed) {
@@ -1919,7 +1920,7 @@ caam_hash_alloc(struct caam_hash_template *template,
 			 template->name);
 		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 			 template->driver_name);
-		t_alg->ahash_alg.setkey = NULL;
+		halg->setkey = NULL;
 	}
 	alg->cra_module = THIS_MODULE;
 	alg->cra_init = caam_hash_cra_init;
@@ -1931,6 +1932,7 @@ caam_hash_alloc(struct caam_hash_template *template,
 	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY;
 
 	t_alg->alg_type = template->alg_type;
+	t_alg->ahash_alg.op.do_one_request = ahash_do_one_req;
 
 	return t_alg;
 }
@@ -1992,10 +1994,10 @@ int caam_algapi_hash_init(struct device *ctrldev)
 			continue;
 		}
 
-		err = crypto_register_ahash(&t_alg->ahash_alg);
+		err = crypto_engine_register_ahash(&t_alg->ahash_alg);
 		if (err) {
 			pr_warn("%s alg registration failed: %d\n",
-				t_alg->ahash_alg.halg.base.cra_driver_name,
+				t_alg->ahash_alg.base.halg.base.cra_driver_name,
 				err);
 			kfree(t_alg);
 		} else
@@ -2012,10 +2014,10 @@ int caam_algapi_hash_init(struct device *ctrldev)
 			continue;
 		}
 
-		err = crypto_register_ahash(&t_alg->ahash_alg);
+		err = crypto_engine_register_ahash(&t_alg->ahash_alg);
 		if (err) {
 			pr_warn("%s alg registration failed: %d\n",
-				t_alg->ahash_alg.halg.base.cra_driver_name,
+				t_alg->ahash_alg.base.halg.base.cra_driver_name,
 				err);
 			kfree(t_alg);
 		} else
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 72670cd10b87..1779d6c18336 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -18,7 +18,10 @@
 #include "caampkc.h"
 #include <crypto/internal/engine.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
 #define DESC_RSA_PUB_LEN	(2 * CAAM_CMD_SZ + SIZEOF_RSA_PUB_PDB)
 #define DESC_RSA_PRIV_F1_LEN	(2 * CAAM_CMD_SZ + \
@@ -39,7 +42,7 @@ static u8 *zero_buffer;
 static bool init_done;
 
 struct caam_akcipher_alg {
-	struct akcipher_alg akcipher;
+	struct akcipher_engine_alg akcipher;
 	bool registered;
 };
 
@@ -1122,8 +1125,6 @@ static int caam_rsa_init_tfm(struct crypto_akcipher *tfm)
 		return -ENOMEM;
 	}
 
-	ctx->enginectx.op.do_one_request = akcipher_do_one_req;
-
 	return 0;
 }
 
@@ -1140,7 +1141,7 @@ static void caam_rsa_exit_tfm(struct crypto_akcipher *tfm)
 }
 
 static struct caam_akcipher_alg caam_rsa = {
-	.akcipher = {
+	.akcipher.base = {
 		.encrypt = caam_rsa_enc,
 		.decrypt = caam_rsa_dec,
 		.set_pub_key = caam_rsa_set_pub_key,
@@ -1156,7 +1157,10 @@ static struct caam_akcipher_alg caam_rsa = {
 			.cra_ctxsize = sizeof(struct caam_rsa_ctx) +
 				       CRYPTO_DMA_PADDING,
 		},
-	}
+	},
+	.akcipher.op = {
+		.do_one_request = akcipher_do_one_req,
+	},
 };
 
 /* Public Key Cryptography module initialization handler */
@@ -1194,12 +1198,12 @@ int caam_pkc_init(struct device *ctrldev)
 	if (!zero_buffer)
 		return -ENOMEM;
 
-	err = crypto_register_akcipher(&caam_rsa.akcipher);
+	err = crypto_engine_register_akcipher(&caam_rsa.akcipher);
 
 	if (err) {
 		kfree(zero_buffer);
 		dev_warn(ctrldev, "%s alg registration failed\n",
-			 caam_rsa.akcipher.base.cra_driver_name);
+			 caam_rsa.akcipher.base.base.cra_driver_name);
 	} else {
 		init_done = true;
 		caam_rsa.registered = true;
@@ -1215,7 +1219,7 @@ void caam_pkc_exit(void)
 		return;
 
 	if (caam_rsa.registered)
-		crypto_unregister_akcipher(&caam_rsa.akcipher);
+		crypto_engine_unregister_akcipher(&caam_rsa.akcipher);
 
 	kfree(zero_buffer);
 }
diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
index cc889a525e2f..96d03704c9be 100644
--- a/drivers/crypto/caam/caampkc.h
+++ b/drivers/crypto/caam/caampkc.h
@@ -12,7 +12,6 @@
 #define _PKC_DESC_H_
 #include "compat.h"
 #include "pdb.h"
-#include <crypto/engine.h>
 
 /**
  * caam_priv_key_form - CAAM RSA private key representation
@@ -88,13 +87,11 @@ struct caam_rsa_key {
 
 /**
  * caam_rsa_ctx - per session context.
- * @enginectx   : crypto engine context
  * @key         : RSA key in DMA zone
  * @dev         : device structure
  * @padding_dma : dma address of padding, for adding it to the input
  */
 struct caam_rsa_ctx {
-	struct crypto_engine_ctx enginectx;
 	struct caam_rsa_key key;
 	struct device *dev;
 	dma_addr_t padding_dma;

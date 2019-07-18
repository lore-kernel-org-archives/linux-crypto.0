Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371E4C76197
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 23:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04836208C0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 23:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfGRX6T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 19:58:19 -0400
Received: from inva021.nxp.com ([92.121.34.21]:53144 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfGRX6R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 19:58:17 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D143F200028;
        Fri, 19 Jul 2019 01:58:13 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C299D200003;
        Fri, 19 Jul 2019 01:58:13 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 765F6205D1;
        Fri, 19 Jul 2019 01:58:13 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v2 04/14] crypto: caam - check key length
Date:   Fri, 19 Jul 2019 02:57:46 +0300
Message-Id: <1563494276-3993-5-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
References: <1563494276-3993-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Check key length to solve the extra tests that expect -EINVAL to be
returned when the key size is not valid.

Validated AES keylen for skcipher and ahash.

The check_aes_keylen function is added in a common file, to be used
also for caam/qi and caam/qi2.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/Makefile      |   2 +-
 drivers/crypto/caam/caamalg.c     | 124 +++++++++++++++++++++++++-------
 drivers/crypto/caam/caamalg_qi.c  | 128 ++++++++++++++++++++++++++-------
 drivers/crypto/caam/caamalg_qi2.c | 147 +++++++++++++++++++++++++++++---------
 drivers/crypto/caam/caamhash.c    |  11 +++
 drivers/crypto/caam/common_if.c   |  31 ++++++++
 drivers/crypto/caam/common_if.h   |  13 ++++
 7 files changed, 367 insertions(+), 89 deletions(-)
 create mode 100644 drivers/crypto/caam/common_if.c
 create mode 100644 drivers/crypto/caam/common_if.h

diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 9ab4e81..7edd697 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -8,7 +8,7 @@ endif
 
 ccflags-y += -DVERSION=\"\"
 
-obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_COMMON) += error.o
+obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_COMMON) += error.o common_if.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_JR) += caam_jr.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC) += caamalg_desc.o
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 28d55a0..6ac59b1 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -53,6 +53,7 @@
 #include "desc_constr.h"
 #include "jr.h"
 #include "error.h"
+#include "common_if.h"
 #include "sg_sw_sec4.h"
 #include "key_gen.h"
 #include "caamalg_desc.h"
@@ -667,6 +668,13 @@ static int gcm_setkey(struct crypto_aead *aead,
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
+	int err;
+
+	err = check_aes_keylen(keylen);
+	if (err) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
 
 	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -683,10 +691,17 @@ static int rfc4106_setkey(struct crypto_aead *aead,
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
+	int err;
 
 	if (keylen < 4)
 		return -EINVAL;
 
+	err = check_aes_keylen(keylen - 4);
+	if (err) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
+
 	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
@@ -707,10 +722,17 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
+	int err;
 
 	if (keylen < 4)
 		return -EINVAL;
 
+	err = check_aes_keylen(keylen - 4);
+	if (err) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
+
 	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
@@ -727,7 +749,7 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 }
 
 static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
-			   unsigned int keylen)
+			   unsigned int keylen, const u32 ctx1_iv_off)
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct caam_skcipher_alg *alg =
@@ -736,30 +758,10 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	struct device *jrdev = ctx->jrdev;
 	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
 	u32 *desc;
-	u32 ctx1_iv_off = 0;
-	const bool ctr_mode = ((ctx->cdata.algtype & OP_ALG_AAI_MASK) ==
-			       OP_ALG_AAI_CTR_MOD128);
 	const bool is_rfc3686 = alg->caam.rfc3686;
 
 	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
-	/*
-	 * AES-CTR needs to load IV in CONTEXT1 reg
-	 * at an offset of 128bits (16bytes)
-	 * CONTEXT1[255:128] = IV
-	 */
-	if (ctr_mode)
-		ctx1_iv_off = 16;
-
-	/*
-	 * RFC3686 specific:
-	 *	| CONTEXT1[255:128] = {NONCE, IV, COUNTER}
-	 *	| *key = {KEY, NONCE}
-	 */
-	if (is_rfc3686) {
-		ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
-		keylen -= CTR_RFC3686_NONCE_SIZE;
-	}
 
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
@@ -782,6 +784,74 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	return 0;
 }
 
+static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
+			       const u8 *key, unsigned int keylen)
+{
+	int err;
+
+	err = check_aes_keylen(keylen);
+	if (err) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, 0);
+}
+
+static int rfc3686_skcipher_setkey(struct crypto_skcipher *skcipher,
+				   const u8 *key, unsigned int keylen)
+{
+	u32 ctx1_iv_off;
+	int err;
+
+	/*
+	 * RFC3686 specific:
+	 *	| CONTEXT1[255:128] = {NONCE, IV, COUNTER}
+	 *	| *key = {KEY, NONCE}
+	 */
+	ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
+	keylen -= CTR_RFC3686_NONCE_SIZE;
+
+	err = check_aes_keylen(keylen);
+	if (err) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
+}
+
+static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
+			       const u8 *key, unsigned int keylen)
+{
+	u32 ctx1_iv_off;
+	int err;
+
+	/*
+	 * AES-CTR needs to load IV in CONTEXT1 reg
+	 * at an offset of 128bits (16bytes)
+	 * CONTEXT1[255:128] = IV
+	 */
+	ctx1_iv_off = 16;
+
+	err = check_aes_keylen(keylen);
+	if (err) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
+}
+
+static int arc4_skcipher_setkey(struct crypto_skcipher *skcipher,
+				const u8 *key, unsigned int keylen)
+{
+	return skcipher_setkey(skcipher, key, keylen, 0);
+}
+
 static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
@@ -800,7 +870,7 @@ static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
 		return -EINVAL;
 	}
 
-	return skcipher_setkey(skcipher, key, keylen);
+	return skcipher_setkey(skcipher, key, keylen, 0);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
@@ -1880,7 +1950,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-aes-caam",
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = aes_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
@@ -1928,7 +1998,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "ctr-aes-caam",
 				.cra_blocksize = 1,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = ctr_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
@@ -1946,7 +2016,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "rfc3686-ctr-aes-caam",
 				.cra_blocksize = 1,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = rfc3686_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE +
@@ -2000,7 +2070,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "ecb-aes-caam",
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = aes_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
@@ -2030,7 +2100,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "ecb-arc4-caam",
 				.cra_blocksize = ARC4_BLOCK_SIZE,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = arc4_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = ARC4_MIN_KEY_SIZE,
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 66531d6..46097e3 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -385,6 +385,12 @@ static int gcm_setkey(struct crypto_aead *aead,
 	struct device *jrdev = ctx->jrdev;
 	int ret;
 
+	ret = check_aes_keylen(keylen);
+	if (ret) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return ret;
+	}
+
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
@@ -483,6 +489,12 @@ static int rfc4106_setkey(struct crypto_aead *aead,
 	if (keylen < 4)
 		return -EINVAL;
 
+	ret = check_aes_keylen(keylen - 4);
+	if (ret) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return ret;
+	}
+
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
@@ -585,6 +597,12 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 	if (keylen < 4)
 		return -EINVAL;
 
+	ret = check_aes_keylen(keylen - 4);
+	if (ret) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return ret;
+	}
+
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
@@ -624,7 +642,7 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 }
 
 static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
-			   unsigned int keylen)
+			   unsigned int keylen, const u32 ctx1_iv_off)
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct caam_skcipher_alg *alg =
@@ -632,33 +650,12 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 			     skcipher);
 	struct device *jrdev = ctx->jrdev;
 	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
-	u32 ctx1_iv_off = 0;
-	const bool ctr_mode = ((ctx->cdata.algtype & OP_ALG_AAI_MASK) ==
-			       OP_ALG_AAI_CTR_MOD128);
 	const bool is_rfc3686 = alg->caam.rfc3686;
 	int ret = 0;
 
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
-	/*
-	 * AES-CTR needs to load IV in CONTEXT1 reg
-	 * at an offset of 128bits (16bytes)
-	 * CONTEXT1[255:128] = IV
-	 */
-	if (ctr_mode)
-		ctx1_iv_off = 16;
-
-	/*
-	 * RFC3686 specific:
-	 *	| CONTEXT1[255:128] = {NONCE, IV, COUNTER}
-	 *	| *key = {KEY, NONCE}
-	 */
-	if (is_rfc3686) {
-		ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
-		keylen -= CTR_RFC3686_NONCE_SIZE;
-	}
-
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
@@ -694,11 +691,88 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	return -EINVAL;
 }
 
+static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
+			       const u8 *key, unsigned int keylen)
+{
+	int err;
+
+	err = check_aes_keylen(keylen);
+	if (err) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, 0);
+}
+
+static int rfc3686_skcipher_setkey(struct crypto_skcipher *skcipher,
+				   const u8 *key, unsigned int keylen)
+{
+	u32 ctx1_iv_off;
+	int err;
+
+	/*
+	 * RFC3686 specific:
+	 *	| CONTEXT1[255:128] = {NONCE, IV, COUNTER}
+	 *	| *key = {KEY, NONCE}
+	 */
+	ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
+	keylen -= CTR_RFC3686_NONCE_SIZE;
+
+	err = check_aes_keylen(keylen);
+	if (err) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
+}
+
+static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
+			       const u8 *key, unsigned int keylen)
+{
+	u32 ctx1_iv_off;
+	int err;
+
+	/*
+	 * AES-CTR needs to load IV in CONTEXT1 reg
+	 * at an offset of 128bits (16bytes)
+	 * CONTEXT1[255:128] = IV
+	 */
+	ctx1_iv_off = 16;
+
+	err = check_aes_keylen(keylen);
+	if (err) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
+}
+
 static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
 				const u8 *key, unsigned int keylen)
 {
 	return unlikely(des3_verify_key(skcipher, key)) ?:
-	       skcipher_setkey(skcipher, key, keylen);
+	       skcipher_setkey(skcipher, key, keylen, 0);
+}
+
+static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
+			       const u8 *key, unsigned int keylen)
+{
+	u32 tmp[DES_EXPKEY_WORDS];
+
+	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &
+	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_WEAK_KEY);
+		return -EINVAL;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, 0);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
@@ -1405,7 +1479,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-aes-caam-qi",
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = aes_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
@@ -1437,7 +1511,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-des-caam-qi",
 				.cra_blocksize = DES_BLOCK_SIZE,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = des_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES_KEY_SIZE,
@@ -1453,7 +1527,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "ctr-aes-caam-qi",
 				.cra_blocksize = 1,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = ctr_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
@@ -1471,7 +1545,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "rfc3686-ctr-aes-caam-qi",
 				.cra_blocksize = 1,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = rfc3686_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE +
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index bc370af..da4abf1 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -731,7 +731,13 @@ static int gcm_setkey(struct crypto_aead *aead,
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *dev = ctx->dev;
+	int ret;
 
+	ret = check_aes_keylen(keylen);
+	if (ret) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return ret;
+	}
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
@@ -817,10 +823,17 @@ static int rfc4106_setkey(struct crypto_aead *aead,
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *dev = ctx->dev;
+	int ret;
 
 	if (keylen < 4)
 		return -EINVAL;
 
+	ret = check_aes_keylen(keylen - 4);
+	if (ret) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return ret;
+	}
+
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
@@ -911,10 +924,17 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *dev = ctx->dev;
+	int ret;
 
 	if (keylen < 4)
 		return -EINVAL;
 
+	ret = check_aes_keylen(keylen - 4);
+	if (ret) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return ret;
+	}
+
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
@@ -931,7 +951,7 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 }
 
 static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
-			   unsigned int keylen)
+			   unsigned int keylen, const u32 ctx1_iv_off)
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct caam_skcipher_alg *alg =
@@ -941,34 +961,11 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	struct caam_flc *flc;
 	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
 	u32 *desc;
-	u32 ctx1_iv_off = 0;
-	const bool ctr_mode = ((ctx->cdata.algtype & OP_ALG_AAI_MASK) ==
-			       OP_ALG_AAI_CTR_MOD128) &&
-			       ((ctx->cdata.algtype & OP_ALG_ALGSEL_MASK) !=
-			       OP_ALG_ALGSEL_CHACHA20);
 	const bool is_rfc3686 = alg->caam.rfc3686;
 
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
-	/*
-	 * AES-CTR needs to load IV in CONTEXT1 reg
-	 * at an offset of 128bits (16bytes)
-	 * CONTEXT1[255:128] = IV
-	 */
-	if (ctr_mode)
-		ctx1_iv_off = 16;
-
-	/*
-	 * RFC3686 specific:
-	 *	| CONTEXT1[255:128] = {NONCE, IV, COUNTER}
-	 *	| *key = {KEY, NONCE}
-	 */
-	if (is_rfc3686) {
-		ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
-		keylen -= CTR_RFC3686_NONCE_SIZE;
-	}
-
 	ctx->cdata.keylen = keylen;
 	ctx->cdata.key_virt = key;
 	ctx->cdata.key_inline = true;
@@ -996,11 +993,93 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	return 0;
 }
 
-static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
-				const u8 *key, unsigned int keylen)
+static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
+			       const u8 *key, unsigned int keylen)
+{
+	int err;
+
+	err = check_aes_keylen(keylen);
+	if (err) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, 0);
+}
+
+static int rfc3686_skcipher_setkey(struct crypto_skcipher *skcipher,
+				   const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(skcipher, key)) ?:
-	       skcipher_setkey(skcipher, key, keylen);
+	u32 ctx1_iv_off;
+	int err;
+
+	/*
+	 * RFC3686 specific:
+	 *	| CONTEXT1[255:128] = {NONCE, IV, COUNTER}
+	 *	| *key = {KEY, NONCE}
+	 */
+	ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
+	keylen -= CTR_RFC3686_NONCE_SIZE;
+
+	err = check_aes_keylen(keylen);
+	if (err) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
+}
+
+static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
+			       const u8 *key, unsigned int keylen)
+{
+	u32 ctx1_iv_off;
+	int err;
+
+	/*
+	 * AES-CTR needs to load IV in CONTEXT1 reg
+	 * at an offset of 128bits (16bytes)
+	 * CONTEXT1[255:128] = IV
+	 */
+	ctx1_iv_off = 16;
+
+	err = check_aes_keylen(keylen);
+	if (err) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
+}
+
+static int chacha20_skcipher_setkey(struct crypto_skcipher *skcipher,
+				    const u8 *key, unsigned int keylen)
+{
+	return skcipher_setkey(skcipher, key, keylen, 0);
+}
+
+static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
+			       const u8 *key, unsigned int keylen)
+{
+	u32 tmp[DES3_EDE_EXPKEY_WORDS];
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(skcipher);
+
+	if (keylen == DES3_EDE_KEY_SIZE &&
+	    __des3_ede_setkey(tmp, &tfm->crt_flags, key, DES3_EDE_KEY_SIZE)) {
+		return -EINVAL;
+	}
+
+	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &
+	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
+		crypto_skcipher_set_flags(skcipher,
+					  CRYPTO_TFM_RES_WEAK_KEY);
+		return -EINVAL;
+	}
+
+	return skcipher_setkey(skcipher, key, keylen, 0);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
@@ -1534,7 +1613,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-aes-caam-qi2",
 				.cra_blocksize = AES_BLOCK_SIZE,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = aes_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
@@ -1550,7 +1629,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-3des-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des3_skcipher_setkey,
+			.setkey = des_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
@@ -1566,7 +1645,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-des-caam-qi2",
 				.cra_blocksize = DES_BLOCK_SIZE,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = des_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES_KEY_SIZE,
@@ -1582,7 +1661,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "ctr-aes-caam-qi2",
 				.cra_blocksize = 1,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = ctr_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
@@ -1600,7 +1679,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "rfc3686-ctr-aes-caam-qi2",
 				.cra_blocksize = 1,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = rfc3686_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE +
@@ -1639,7 +1718,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "chacha20-caam-qi2",
 				.cra_blocksize = 1,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = chacha20_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = CHACHA_KEY_SIZE,
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 73abefa..2ec4bad 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -62,6 +62,7 @@
 #include "desc_constr.h"
 #include "jr.h"
 #include "error.h"
+#include "common_if.h"
 #include "sg_sw_sec4.h"
 #include "key_gen.h"
 #include "caamhash_desc.h"
@@ -501,6 +502,9 @@ static int axcbc_setkey(struct crypto_ahash *ahash, const u8 *key,
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct device *jrdev = ctx->jrdev;
 
+	if (keylen != AES_KEYSIZE_128)
+		return -EINVAL;
+
 	memcpy(ctx->key, key, keylen);
 	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
 	ctx->adata.keylen = keylen;
@@ -515,6 +519,13 @@ static int acmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 			unsigned int keylen)
 {
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	int err;
+
+	err = check_aes_keylen(keylen);
+	if (err) {
+		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return err;
+	}
 
 	/* key is immediate data for all cmac shared descriptors */
 	ctx->adata.key_virt = key;
diff --git a/drivers/crypto/caam/common_if.c b/drivers/crypto/caam/common_if.c
new file mode 100644
index 0000000..859d4b4
--- /dev/null
+++ b/drivers/crypto/caam/common_if.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * CAAM Common Location for caam/jr, caam/qi, caam/qi2
+ *
+ * Copyright 2019 NXP
+ */
+
+#include "compat.h"
+#include "common_if.h"
+
+/*
+ * validate key length for AES algorithms
+ */
+int check_aes_keylen(unsigned int keylen)
+{
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_192:
+	case AES_KEYSIZE_256:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(check_aes_keylen);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("FSL CAAM drivers common location");
+MODULE_AUTHOR("NXP Semiconductors");
diff --git a/drivers/crypto/caam/common_if.h b/drivers/crypto/caam/common_if.h
new file mode 100644
index 0000000..6964ba3
--- /dev/null
+++ b/drivers/crypto/caam/common_if.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * CAAM Common Location for caam/jr, caam/qi, caam/qi2
+ *
+ * Copyright 2019 NXP
+ */
+
+#ifndef CAAM_COMMON_LOCATION_H
+#define CAAM_COMMON_LOCATION_H
+
+int check_aes_keylen(unsigned int keylen);
+
+#endif /* CAAM_COMMON_LOCATION_H */
-- 
2.1.0


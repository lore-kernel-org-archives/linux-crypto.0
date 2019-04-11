Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B01C282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E24DF2184B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 08:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfDKIvE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:51:04 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:41212 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfDKIvE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 04:51:04 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEVQE-0003Kq-Es
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 16:51:02 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEVQE-0006mC-7q; Thu, 11 Apr 2019 16:51:02 +0800
Subject: [PATCH 6/24] crypto: caam - Forbid 2-key 3DES in FIPS mode
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1hEVQE-0006mC-7q@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 11 Apr 2019 16:51:02 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/caamalg.c     |   57 +++++++++++++++++++++++++-------
 drivers/crypto/caam/caamalg_qi.c  |   66 ++++++++++++++++++++++++++++++--------
 drivers/crypto/caam/caamalg_qi2.c |   66 ++++++++++++++++++++++++++++++--------
 3 files changed, 151 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 579578498deb..0030cee3e75d 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -638,6 +638,39 @@ static int aead_setkey(struct crypto_aead *aead,
 	return -EINVAL;
 }
 
+static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
+			    unsigned int keylen)
+{
+	struct crypto_authenc_keys keys;
+	u32 flags;
+	int err;
+
+	err = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (unlikely(err))
+		goto badkey;
+
+	err = -EINVAL;
+	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
+		goto badkey;
+
+	flags = crypto_aead_get_flags(aead);
+	err = __des3_verify_key(&flags, keys.enckey);
+	if (unlikely(err)) {
+		crypto_aead_set_flags(aead, flags);
+		goto out;
+	}
+
+	err = aead_setkey(aead, key, keylen);
+
+out:
+	memzero_explicit(&keys, sizeof(keys));
+	return err;
+
+badkey:
+	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	goto out;
+}
+
 static int gcm_setkey(struct crypto_aead *aead,
 		      const u8 *key, unsigned int keylen)
 {
@@ -2457,7 +2490,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2479,7 +2512,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2502,7 +2535,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2525,7 +2558,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2548,7 +2581,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2571,7 +2604,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2594,7 +2627,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2617,7 +2650,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2640,7 +2673,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2663,7 +2696,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2686,7 +2719,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2709,7 +2742,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index c61921d32489..70af211d2d01 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -292,6 +292,39 @@ static int aead_setkey(struct crypto_aead *aead, const u8 *key,
 	return -EINVAL;
 }
 
+static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
+			    unsigned int keylen)
+{
+	struct crypto_authenc_keys keys;
+	u32 flags;
+	int err;
+
+	err = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (unlikely(err))
+		goto badkey;
+
+	err = -EINVAL;
+	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
+		goto badkey;
+
+	flags = crypto_aead_get_flags(aead);
+	err = __des3_verify_key(&flags, keys.enckey);
+	if (unlikely(err)) {
+		crypto_aead_set_flags(aead, flags);
+		goto out;
+	}
+
+	err = aead_setkey(aead, key, keylen);
+
+out:
+	memzero_explicit(&keys, sizeof(keys));
+	return err;
+
+badkey:
+	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	goto out;
+}
+
 static int gcm_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
@@ -667,6 +700,13 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	return -EINVAL;
 }
 
+static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
+				const u8 *key, unsigned int keylen)
+{
+	return unlikely(des3_verify_key(skcipher, key)) ?:
+	       skcipher_setkey(skcipher, key, keylen);
+}
+
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 			       unsigned int keylen)
 {
@@ -1382,7 +1422,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-3des-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
@@ -1798,7 +1838,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -1820,7 +1860,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -1843,7 +1883,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -1866,7 +1906,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -1889,7 +1929,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -1912,7 +1952,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -1935,7 +1975,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -1958,7 +1998,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -1981,7 +2021,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2004,7 +2044,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2027,7 +2067,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2050,7 +2090,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index c2c1abc68f81..d19c97acf1aa 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -323,6 +323,39 @@ static int aead_setkey(struct crypto_aead *aead, const u8 *key,
 	return -EINVAL;
 }
 
+static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
+			    unsigned int keylen)
+{
+	struct crypto_authenc_keys keys;
+	u32 flags;
+	int err;
+
+	err = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (unlikely(err))
+		goto badkey;
+
+	err = -EINVAL;
+	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
+		goto badkey;
+
+	flags = crypto_aead_get_flags(aead);
+	err = __des3_verify_key(&flags, keys.enckey);
+	if (unlikely(err)) {
+		crypto_aead_set_flags(aead, flags);
+		goto out;
+	}
+
+	err = aead_setkey(aead, key, keylen);
+
+out:
+	memzero_explicit(&keys, sizeof(keys));
+	return err;
+
+badkey:
+	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	goto out;
+}
+
 static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 					   bool encrypt)
 {
@@ -938,6 +971,13 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	return 0;
 }
 
+static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
+				const u8 *key, unsigned int keylen)
+{
+	return unlikely(des3_verify_key(skcipher, key)) ?:
+	       skcipher_setkey(skcipher, key, keylen);
+}
+
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 			       unsigned int keylen)
 {
@@ -1484,7 +1524,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-3des-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
@@ -1916,7 +1956,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -1938,7 +1978,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -1961,7 +2001,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -1984,7 +2024,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2007,7 +2047,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2030,7 +2070,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2053,7 +2093,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2076,7 +2116,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2099,7 +2139,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2122,7 +2162,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2145,7 +2185,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,
@@ -2168,7 +2208,7 @@ static struct caam_aead_alg driver_aeads[] = {
 						   "cbc-des3_ede-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = aead_setkey,
+			.setkey = des3_aead_setkey,
 			.setauthsize = aead_setauthsize,
 			.encrypt = aead_encrypt,
 			.decrypt = aead_decrypt,

Return-Path: <SRS0=52Dc=ZX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197AEC33CB9
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 21:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E09E0218AC
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 21:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575237263;
	bh=L0P6g7JaAqO0KTwbrfe5ujMTYOxvSb8TJwxM1Il6kcE=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=w0lbNSQCHlPSzEWNzxMaWFmFcmLfjIEcpt3z4cnSjHj+2JP8/lgcXFFCZqIvDSy7z
	 eNUZ5Jzosd+K2shYW4ZH/o1ovHRJSooC/mLjN5mkvNObo41jjP/dd8v7MKROSiZOyO
	 rHP/8Dn3Z5EO575OnUiekAUh7reOhvUcf+DACrQg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfLAVyW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Dec 2019 16:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbfLAVyV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Dec 2019 16:54:21 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3168215F1
        for <linux-crypto@vger.kernel.org>; Sun,  1 Dec 2019 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575237260;
        bh=L0P6g7JaAqO0KTwbrfe5ujMTYOxvSb8TJwxM1Il6kcE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ptO7XvBgEM0vfQVpFQtsS1axozVEQBXqI/HrkW+gPWvoDFd9xBt+zmVP7rDrzZzqM
         1KEjrEUwXY7rUQYYQz++PunsNLQhmYkVjnjM4HmSSZEaCVniZ09TINKea+ycabwPx3
         UaCKe5YSoMOTuFS/U+fg8m4hy4tYCg+vJRLC7aOg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 5/7] crypto: testmgr - test setting misaligned keys
Date:   Sun,  1 Dec 2019 13:53:28 -0800
Message-Id: <20191201215330.171990-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191201215330.171990-1-ebiggers@kernel.org>
References: <20191201215330.171990-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The alignment bug in ghash_setkey() fixed by commit 5c6bc4dfa515
("crypto: ghash - fix unaligned memory access in ghash_setkey()")
wasn't reliably detected by the crypto self-tests on ARM because the
tests only set the keys directly from the test vectors.

To improve test coverage, update the tests to sometimes pass misaligned
keys to setkey().  This applies to shash, ahash, skcipher, and aead.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 73 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 69 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 3d7c1c1529cf..d1ffa8f73948 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -259,6 +259,9 @@ struct test_sg_division {
  *	       where 0 is aligned to a 2*(MAX_ALGAPI_ALIGNMASK+1) byte boundary
  * @iv_offset_relative_to_alignmask: if true, add the algorithm's alignmask to
  *				     the @iv_offset
+ * @key_offset: misalignment of the key, where 0 is default alignment
+ * @key_offset_relative_to_alignmask: if true, add the algorithm's alignmask to
+ *				      the @key_offset
  * @finalization_type: what finalization function to use for hashes
  * @nosimd: execute with SIMD disabled?  Requires !CRYPTO_TFM_REQ_MAY_SLEEP.
  */
@@ -269,7 +272,9 @@ struct testvec_config {
 	struct test_sg_division src_divs[XBUFSIZE];
 	struct test_sg_division dst_divs[XBUFSIZE];
 	unsigned int iv_offset;
+	unsigned int key_offset;
 	bool iv_offset_relative_to_alignmask;
+	bool key_offset_relative_to_alignmask;
 	enum finalization_type finalization_type;
 	bool nosimd;
 };
@@ -297,6 +302,7 @@ static const struct testvec_config default_cipher_testvec_configs[] = {
 		.name = "unaligned buffer, offset=1",
 		.src_divs = { { .proportion_of_total = 10000, .offset = 1 } },
 		.iv_offset = 1,
+		.key_offset = 1,
 	}, {
 		.name = "buffer aligned only to alignmask",
 		.src_divs = {
@@ -308,6 +314,8 @@ static const struct testvec_config default_cipher_testvec_configs[] = {
 		},
 		.iv_offset = 1,
 		.iv_offset_relative_to_alignmask = true,
+		.key_offset = 1,
+		.key_offset_relative_to_alignmask = true,
 	}, {
 		.name = "two even aligned splits",
 		.src_divs = {
@@ -323,6 +331,7 @@ static const struct testvec_config default_cipher_testvec_configs[] = {
 			{ .proportion_of_total = 4800, .offset = 18 },
 		},
 		.iv_offset = 3,
+		.key_offset = 3,
 	}, {
 		.name = "misaligned splits crossing pages, inplace",
 		.inplace = true,
@@ -355,6 +364,7 @@ static const struct testvec_config default_hash_testvec_configs[] = {
 		.name = "init+update+final misaligned buffer",
 		.src_divs = { { .proportion_of_total = 10000, .offset = 1 } },
 		.finalization_type = FINALIZATION_TYPE_FINAL,
+		.key_offset = 1,
 	}, {
 		.name = "digest buffer aligned only to alignmask",
 		.src_divs = {
@@ -365,6 +375,8 @@ static const struct testvec_config default_hash_testvec_configs[] = {
 			},
 		},
 		.finalization_type = FINALIZATION_TYPE_DIGEST,
+		.key_offset = 1,
+		.key_offset_relative_to_alignmask = true,
 	}, {
 		.name = "init+update+update+final two even splits",
 		.src_divs = {
@@ -740,6 +752,49 @@ static int build_cipher_test_sglists(struct cipher_test_sglists *tsgls,
 				 alignmask, dst_total_len, NULL, NULL);
 }
 
+/*
+ * Support for testing passing a misaligned key to setkey():
+ *
+ * If cfg->key_offset is set, copy the key into a new buffer at that offset,
+ * optionally adding alignmask.  Else, just use the key directly.
+ */
+static int prepare_keybuf(const u8 *key, unsigned int ksize,
+			  const struct testvec_config *cfg,
+			  unsigned int alignmask,
+			  const u8 **keybuf_ret, const u8 **keyptr_ret)
+{
+	unsigned int key_offset = cfg->key_offset;
+	u8 *keybuf = NULL, *keyptr = (u8 *)key;
+
+	if (key_offset != 0) {
+		if (cfg->key_offset_relative_to_alignmask)
+			key_offset += alignmask;
+		keybuf = kmalloc(key_offset + ksize, GFP_KERNEL);
+		if (!keybuf)
+			return -ENOMEM;
+		keyptr = keybuf + key_offset;
+		memcpy(keyptr, key, ksize);
+	}
+	*keybuf_ret = keybuf;
+	*keyptr_ret = keyptr;
+	return 0;
+}
+
+/* Like setkey_f(tfm, key, ksize), but sometimes misalign the key */
+#define do_setkey(setkey_f, tfm, key, ksize, cfg, alignmask)		\
+({									\
+	const u8 *keybuf, *keyptr;					\
+	int err;							\
+									\
+	err = prepare_keybuf((key), (ksize), (cfg), (alignmask),	\
+			     &keybuf, &keyptr);				\
+	if (err == 0) {							\
+		err = setkey_f((tfm), keyptr, (ksize));			\
+		kfree(keybuf);						\
+	}								\
+	err;								\
+})
+
 #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
 
 /* Generate a random length in range [0, max_len], but prefer smaller values */
@@ -966,6 +1021,11 @@ static void generate_random_testvec_config(struct testvec_config *cfg,
 		p += scnprintf(p, end - p, " iv_offset=%u", cfg->iv_offset);
 	}
 
+	if (prandom_u32() % 2 == 0) {
+		cfg->key_offset = 1 + (prandom_u32() % MAX_ALGAPI_ALIGNMASK);
+		p += scnprintf(p, end - p, " key_offset=%u", cfg->key_offset);
+	}
+
 	WARN_ON_ONCE(!valid_testvec_config(cfg));
 }
 
@@ -1103,7 +1163,8 @@ static int test_shash_vec_cfg(const char *driver,
 
 	/* Set the key, if specified */
 	if (vec->ksize) {
-		err = crypto_shash_setkey(tfm, vec->key, vec->ksize);
+		err = do_setkey(crypto_shash_setkey, tfm, vec->key, vec->ksize,
+				cfg, alignmask);
 		if (err) {
 			if (err == vec->setkey_error)
 				return 0;
@@ -1290,7 +1351,8 @@ static int test_ahash_vec_cfg(const char *driver,
 
 	/* Set the key, if specified */
 	if (vec->ksize) {
-		err = crypto_ahash_setkey(tfm, vec->key, vec->ksize);
+		err = do_setkey(crypto_ahash_setkey, tfm, vec->key, vec->ksize,
+				cfg, alignmask);
 		if (err) {
 			if (err == vec->setkey_error)
 				return 0;
@@ -1861,7 +1923,9 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 		crypto_aead_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	else
 		crypto_aead_clear_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
-	err = crypto_aead_setkey(tfm, vec->key, vec->klen);
+
+	err = do_setkey(crypto_aead_setkey, tfm, vec->key, vec->klen,
+			cfg, alignmask);
 	if (err && err != vec->setkey_error) {
 		pr_err("alg: aead: %s setkey failed on test vector %s; expected_error=%d, actual_error=%d, flags=%#x\n",
 		       driver, vec_name, vec->setkey_error, err,
@@ -2460,7 +2524,8 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	else
 		crypto_skcipher_clear_flags(tfm,
 					    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
-	err = crypto_skcipher_setkey(tfm, vec->key, vec->klen);
+	err = do_setkey(crypto_skcipher_setkey, tfm, vec->key, vec->klen,
+			cfg, alignmask);
 	if (err) {
 		if (err == vec->setkey_error)
 			return 0;
-- 
2.24.0


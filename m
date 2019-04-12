Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98DDC10F14
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A29EB218D2
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555045252;
	bh=a/0SWQBAhZot3wg/RXKQGtL85ztccD7sdC9sf6S6Xy0=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IwFih5O2XtSxUyhi6/gSy7CRkMas6ygsS3WlGIOt4zA8+p2H0yruhTQZrWbX9yd0k
	 76vbc+M1l5cSNTCS4ZwprIk5rkwYYWXMnfSz6L/dSty1E6RK/Mv4Ss43eDS4QAAayC
	 7BgV1PEHqT+ePzJGQvamakjfniK1Od4QP8lu14Nk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfDLFAw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 01:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbfDLFAv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 01:00:51 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7656218AE;
        Fri, 12 Apr 2019 05:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555045250;
        bh=a/0SWQBAhZot3wg/RXKQGtL85ztccD7sdC9sf6S6Xy0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=m+AE2MTM7Ax6f03QuDawJ8Ur3gndOMiHz5qst5aqZkF88soehW/Hv2X/+W5wLEKj0
         o785ZR08Z/rhavdLi1jSbUZlCt4o/q60bVBGQiCOGNs5p9hx5yrs4ngVWlkw/olN5R
         xjMhgWdkBW4+RSz5a2iYJmYQ6W4Ttrp9x6bmQ3o0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 5/7] crypto: testmgr - fuzz skciphers against their generic implementation
Date:   Thu, 11 Apr 2019 21:57:40 -0700
Message-Id: <20190412045742.1725-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190412045742.1725-1-ebiggers@kernel.org>
References: <20190412045742.1725-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When the extra crypto self-tests are enabled, test each skcipher
algorithm against its generic implementation when one is available.
This involves: checking the algorithm properties for consistency, then
randomly generating test vectors using the generic implementation and
running them against the implementation under test.  Both good and bad
inputs are tested.

This has already detected a bug in the skcipher_walk API, a bug in the
LRW template, and an inconsistency in the cts implementations.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 197 +++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.h |   2 +-
 2 files changed, 198 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c66101ea32b8d..7b9a7a90e9e25 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2124,6 +2124,186 @@ static int test_skcipher_vec(const char *driver, int enc,
 	return 0;
 }
 
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+/*
+ * Generate a symmetric cipher test vector from the given implementation.
+ * Assumes the buffers in 'vec' were already allocated.
+ */
+static void generate_random_cipher_testvec(struct skcipher_request *req,
+					   struct cipher_testvec *vec,
+					   unsigned int maxdatasize,
+					   char *name, size_t max_namelen)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const unsigned int maxkeysize = tfm->keysize;
+	const unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	struct scatterlist src, dst;
+	u8 iv[MAX_IVLEN];
+	DECLARE_CRYPTO_WAIT(wait);
+
+	/* Key: length in [0, maxkeysize], but usually choose maxkeysize */
+	vec->klen = maxkeysize;
+	if (prandom_u32() % 4 == 0)
+		vec->klen = prandom_u32() % (maxkeysize + 1);
+	generate_random_bytes((u8 *)vec->key, vec->klen);
+	vec->setkey_error = crypto_skcipher_setkey(tfm, vec->key, vec->klen);
+
+	/* IV */
+	generate_random_bytes((u8 *)vec->iv, ivsize);
+
+	/* Plaintext */
+	vec->len = generate_random_length(maxdatasize);
+	generate_random_bytes((u8 *)vec->ptext, vec->len);
+
+	/* If the key couldn't be set, no need to continue to encrypt. */
+	if (vec->setkey_error)
+		goto done;
+
+	/* Ciphertext */
+	sg_init_one(&src, vec->ptext, vec->len);
+	sg_init_one(&dst, vec->ctext, vec->len);
+	memcpy(iv, vec->iv, ivsize);
+	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, &src, &dst, vec->len, iv);
+	vec->crypt_error = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+done:
+	snprintf(name, max_namelen, "\"random: len=%u klen=%u\"",
+		 vec->len, vec->klen);
+}
+
+/*
+ * Test the skcipher algorithm represented by @req against the corresponding
+ * generic implementation, if one is available.
+ */
+static int test_skcipher_vs_generic_impl(const char *driver,
+					 const char *generic_driver,
+					 struct skcipher_request *req,
+					 struct cipher_test_sglists *tsgls)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	const unsigned int blocksize = crypto_skcipher_blocksize(tfm);
+	const unsigned int maxdatasize = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN;
+	const char *algname = crypto_skcipher_alg(tfm)->base.cra_name;
+	char _generic_driver[CRYPTO_MAX_ALG_NAME];
+	struct crypto_skcipher *generic_tfm = NULL;
+	struct skcipher_request *generic_req = NULL;
+	unsigned int i;
+	struct cipher_testvec vec = { 0 };
+	char vec_name[64];
+	struct testvec_config cfg;
+	char cfgname[TESTVEC_CONFIG_NAMELEN];
+	int err;
+
+	if (noextratests)
+		return 0;
+
+	/* Keywrap isn't supported here yet as it handles its IV differently. */
+	if (strncmp(algname, "kw(", 3) == 0)
+		return 0;
+
+	if (!generic_driver) { /* Use default naming convention? */
+		err = build_generic_driver_name(algname, _generic_driver);
+		if (err)
+			return err;
+		generic_driver = _generic_driver;
+	}
+
+	if (strcmp(generic_driver, driver) == 0) /* Already the generic impl? */
+		return 0;
+
+	generic_tfm = crypto_alloc_skcipher(generic_driver, 0, 0);
+	if (IS_ERR(generic_tfm)) {
+		err = PTR_ERR(generic_tfm);
+		if (err == -ENOENT) {
+			pr_warn("alg: skcipher: skipping comparison tests for %s because %s is unavailable\n",
+				driver, generic_driver);
+			return 0;
+		}
+		pr_err("alg: skcipher: error allocating %s (generic impl of %s): %d\n",
+		       generic_driver, algname, err);
+		return err;
+	}
+
+	generic_req = skcipher_request_alloc(generic_tfm, GFP_KERNEL);
+	if (!generic_req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* Check the algorithm properties for consistency. */
+
+	if (tfm->keysize != generic_tfm->keysize) {
+		pr_err("alg: skcipher: max keysize for %s (%u) doesn't match generic impl (%u)\n",
+		       driver, tfm->keysize, generic_tfm->keysize);
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (ivsize != crypto_skcipher_ivsize(generic_tfm)) {
+		pr_err("alg: skcipher: ivsize for %s (%u) doesn't match generic impl (%u)\n",
+		       driver, ivsize, crypto_skcipher_ivsize(generic_tfm));
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (blocksize != crypto_skcipher_blocksize(generic_tfm)) {
+		pr_err("alg: skcipher: blocksize for %s (%u) doesn't match generic impl (%u)\n",
+		       driver, blocksize,
+		       crypto_skcipher_blocksize(generic_tfm));
+		err = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Now generate test vectors using the generic implementation, and test
+	 * the other implementation against them.
+	 */
+
+	vec.key = kmalloc(tfm->keysize, GFP_KERNEL);
+	vec.iv = kmalloc(ivsize, GFP_KERNEL);
+	vec.ptext = kmalloc(maxdatasize, GFP_KERNEL);
+	vec.ctext = kmalloc(maxdatasize, GFP_KERNEL);
+	if (!vec.key || !vec.iv || !vec.ptext || !vec.ctext) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < fuzz_iterations * 8; i++) {
+		generate_random_cipher_testvec(generic_req, &vec, maxdatasize,
+					       vec_name, sizeof(vec_name));
+		generate_random_testvec_config(&cfg, cfgname, sizeof(cfgname));
+
+		err = test_skcipher_vec_cfg(driver, ENCRYPT, &vec, vec_name,
+					    &cfg, req, tsgls);
+		if (err)
+			goto out;
+		err = test_skcipher_vec_cfg(driver, DECRYPT, &vec, vec_name,
+					    &cfg, req, tsgls);
+		if (err)
+			goto out;
+		cond_resched();
+	}
+	err = 0;
+out:
+	kfree(vec.key);
+	kfree(vec.iv);
+	kfree(vec.ptext);
+	kfree(vec.ctext);
+	crypto_free_skcipher(generic_tfm);
+	skcipher_request_free(generic_req);
+	return err;
+}
+#else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
+static int test_skcipher_vs_generic_impl(const char *driver,
+					 const char *generic_driver,
+					 struct skcipher_request *req,
+					 struct cipher_test_sglists *tsgls)
+{
+	return 0;
+}
+#endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
+
 static int test_skcipher(const char *driver, int enc,
 			 const struct cipher_test_suite *suite,
 			 struct skcipher_request *req,
@@ -2183,6 +2363,11 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 		goto out;
 
 	err = test_skcipher(driver, DECRYPT, suite, req, tsgls);
+	if (err)
+		goto out;
+
+	err = test_skcipher_vs_generic_impl(driver, desc->generic_driver, req,
+					    tsgls);
 out:
 	free_cipher_test_sglists(tsgls);
 	skcipher_request_free(req);
@@ -3138,12 +3323,14 @@ static int alg_test_null(const struct alg_test_desc *desc,
 static const struct alg_test_desc alg_test_descs[] = {
 	{
 		.alg = "adiantum(xchacha12,aes)",
+		.generic_driver = "adiantum(xchacha12-generic,aes-generic,nhpoly1305-generic)",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(adiantum_xchacha12_aes_tv_template)
 		},
 	}, {
 		.alg = "adiantum(xchacha20,aes)",
+		.generic_driver = "adiantum(xchacha20-generic,aes-generic,nhpoly1305-generic)",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(adiantum_xchacha20_aes_tv_template)
@@ -3916,30 +4103,35 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "lrw(aes)",
+		.generic_driver = "lrw(ecb(aes-generic))",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(aes_lrw_tv_template)
 		}
 	}, {
 		.alg = "lrw(camellia)",
+		.generic_driver = "lrw(ecb(camellia-generic))",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(camellia_lrw_tv_template)
 		}
 	}, {
 		.alg = "lrw(cast6)",
+		.generic_driver = "lrw(ecb(cast6-generic))",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(cast6_lrw_tv_template)
 		}
 	}, {
 		.alg = "lrw(serpent)",
+		.generic_driver = "lrw(ecb(serpent-generic))",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(serpent_lrw_tv_template)
 		}
 	}, {
 		.alg = "lrw(twofish)",
+		.generic_driver = "lrw(ecb(twofish-generic))",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(tf_lrw_tv_template)
@@ -4274,6 +4466,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		},
 	}, {
 		.alg = "xts(aes)",
+		.generic_driver = "xts(ecb(aes-generic))",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
 		.suite = {
@@ -4281,12 +4474,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "xts(camellia)",
+		.generic_driver = "xts(ecb(camellia-generic))",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(camellia_xts_tv_template)
 		}
 	}, {
 		.alg = "xts(cast6)",
+		.generic_driver = "xts(ecb(cast6-generic))",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(cast6_xts_tv_template)
@@ -4300,12 +4495,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 	}, {
 		.alg = "xts(serpent)",
+		.generic_driver = "xts(ecb(serpent-generic))",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(serpent_xts_tv_template)
 		}
 	}, {
 		.alg = "xts(twofish)",
+		.generic_driver = "xts(ecb(twofish-generic))",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(tf_xts_tv_template)
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index beb9bd79fe1fa..e03f4f72723b1 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -71,7 +71,7 @@ struct cipher_testvec {
 	const char *ptext;
 	const char *ctext;
 	unsigned char wk; /* weak key flag */
-	unsigned char klen;
+	unsigned short klen;
 	unsigned short len;
 	bool fips_skip;
 	bool generates_iv;
-- 
2.21.0


Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF5CC10F11
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C3DA20866
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062766;
	bh=FwyJZ5Wqr6znCHEpoos5DguWellKh9TCb+s+2wMl3WA=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ahf0sAP/H9jwUC7F+HLEYY9OMsxt4iDMCCADegc8nuKbe28n6j7P3EK28h+BTnGk/
	 TKJd6q6xrgd0krM46+yV8C0RuWvGCKJ3L2tPxcJgk2buDJVd5O6N90Gx+AeMfSk3Nr
	 BCCS5ICDtLkR/p7TS7YviJvWWEGNUDJMdGppufok=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbfCaUGC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731498AbfCaUGA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:06:00 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 009DB218FC
        for <linux-crypto@vger.kernel.org>; Sun, 31 Mar 2019 20:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062760;
        bh=FwyJZ5Wqr6znCHEpoos5DguWellKh9TCb+s+2wMl3WA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EV9ooGR4Jim4r02vUUYB7z3wrLdVRtLCqAEZ/ipI2f4LTqSQYh6J3swP5r1rH5fik
         ZWfQHMnQtq+V1iHMBSfCdGW0tWTTxteGcxo5VDECCMu7s+7ynNgXqRNRPSr/PJjrx8
         3PYr0wBueaptxZKeqMVeUOWiluBWe1T9RiBwvnNQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [RFC/RFT PATCH 17/18] crypto: testmgr - fuzz AEADs against their generic implementation
Date:   Sun, 31 Mar 2019 13:04:27 -0700
Message-Id: <20190331200428.26597-18-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190331200428.26597-1-ebiggers@kernel.org>
References: <20190331200428.26597-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When the extra crypto self-tests are enabled, test each AEAD algorithm
against its generic implementation when one is available.  This
involves: checking the algorithm properties for consistency, then
randomly generating test vectors using the generic implementation and
running them against the implementation under test.  Both bad and good
inputs are tested.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 226 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 226 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 3fe178e32b0fe..5cb93ce4e7ed0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1759,6 +1759,223 @@ static int test_aead_vec(const char *driver, int enc,
 	return 0;
 }
 
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+/*
+ * Generate an AEAD test vector from the given implementation.
+ * Assumes the buffers in 'vec' were already allocated.
+ */
+static void generate_random_aead_testvec(struct aead_request *req,
+					 struct aead_testvec *vec,
+					 unsigned int maxkeysize,
+					 unsigned int maxdatasize,
+					 char *name, size_t max_namelen)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const unsigned int ivsize = crypto_aead_ivsize(tfm);
+	unsigned int maxauthsize = crypto_aead_alg(tfm)->maxauthsize;
+	unsigned int authsize;
+	unsigned int total_len;
+	int i;
+	struct scatterlist src[2], dst;
+	u8 iv[MAX_IVLEN];
+	DECLARE_CRYPTO_WAIT(wait);
+
+	/* Key: length in [0, maxkeysize], but usually choose maxkeysize */
+	vec->klen = maxkeysize;
+	if (prandom_u32() % 4 == 0)
+		vec->klen = prandom_u32() % (maxkeysize + 1);
+	generate_random_bytes((u8 *)vec->key, vec->klen);
+	vec->setkey_error = crypto_aead_setkey(tfm, vec->key, vec->klen);
+
+	/* IV */
+	generate_random_bytes((u8 *)vec->iv, ivsize);
+
+	/* Tag length: in [0, maxauthsize], but usually choose maxauthsize */
+	authsize = maxauthsize;
+	if (prandom_u32() % 4 == 0)
+		authsize = prandom_u32() % (maxauthsize + 1);
+	if (WARN_ON(authsize > maxdatasize))
+		authsize = maxdatasize;
+	maxdatasize -= authsize;
+	vec->setauthsize_error = crypto_aead_setauthsize(tfm, authsize);
+
+	/* Plaintext and associated data */
+	total_len = generate_random_length(maxdatasize);
+	vec->alen = generate_random_length(total_len);
+	vec->plen = total_len - vec->alen;
+	generate_random_bytes((u8 *)vec->assoc, vec->alen);
+	generate_random_bytes((u8 *)vec->ptext, vec->plen);
+
+	vec->clen = vec->plen + authsize;
+
+	/*
+	 * If the key or authentication tag size couldn't be set, no need to
+	 * continue to encrypt.
+	 */
+	if (vec->setkey_error || vec->setauthsize_error)
+		goto done;
+
+	/* Ciphertext */
+	sg_init_table(src, 2);
+	i = 0;
+	if (vec->alen)
+		sg_set_buf(&src[i++], vec->assoc, vec->alen);
+	if (vec->plen)
+		sg_set_buf(&src[i++], vec->ptext, vec->plen);
+	sg_init_one(&dst, vec->ctext, vec->alen + vec->clen);
+	memcpy(iv, vec->iv, ivsize);
+	aead_request_set_callback(req, 0, crypto_req_done, &wait);
+	aead_request_set_crypt(req, src, &dst, vec->plen, iv);
+	aead_request_set_ad(req, vec->alen);
+	vec->crypt_error = crypto_wait_req(crypto_aead_encrypt(req), &wait);
+	if (vec->crypt_error == 0)
+		memmove((u8 *)vec->ctext, vec->ctext + vec->alen, vec->clen);
+done:
+	snprintf(name, max_namelen,
+		 "\"random: alen=%u plen=%u authsize=%u klen=%u\"",
+		 vec->alen, vec->plen, authsize, vec->klen);
+}
+
+/*
+ * Test the AEAD algorithm represented by @req against the corresponding generic
+ * implementation, if one is available.
+ */
+static int test_aead_vs_generic_impl(const char *driver,
+				     const struct alg_test_desc *test_desc,
+				     struct aead_request *req,
+				     struct cipher_test_sglists *tsgls)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const unsigned int ivsize = crypto_aead_ivsize(tfm);
+	const unsigned int maxauthsize = crypto_aead_alg(tfm)->maxauthsize;
+	const unsigned int blocksize = crypto_aead_blocksize(tfm);
+	const unsigned int maxdatasize = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN;
+	const char *algname = tfm->base.__crt_alg->cra_name;
+	const char *generic_driver = test_desc->generic_driver;
+	char _generic_driver[CRYPTO_MAX_ALG_NAME];
+	struct crypto_aead *generic_tfm = NULL;
+	struct aead_request *generic_req = NULL;
+	unsigned int maxkeysize;
+	unsigned int i;
+	struct aead_testvec vec = { 0 };
+	char vec_name[64];
+	struct testvec_config cfg;
+	char cfgname[TESTVEC_CONFIG_NAMELEN];
+	int err;
+
+	if (noextratests)
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
+	generic_tfm = crypto_alloc_aead(generic_driver, 0, 0);
+	if (IS_ERR(generic_tfm)) {
+		err = PTR_ERR(generic_tfm);
+		if (err == -ENOENT) {
+			pr_warn("alg: aead: skipping comparison tests for %s because %s is unavailable\n",
+				driver, generic_driver);
+			return 0;
+		}
+		pr_err("alg: aead: error allocating %s (generic impl of %s): %d\n",
+		       generic_driver, algname, err);
+		return err;
+	}
+
+	generic_req = aead_request_alloc(generic_tfm, GFP_KERNEL);
+	if (!generic_req) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* Check the algorithm properties for consistency. */
+
+	if (maxauthsize != crypto_aead_alg(generic_tfm)->maxauthsize) {
+		pr_err("alg: aead: maxauthsize for %s (%u) doesn't match generic impl (%u)\n",
+		       driver, maxauthsize,
+		       crypto_aead_alg(generic_tfm)->maxauthsize);
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (ivsize != crypto_aead_ivsize(generic_tfm)) {
+		pr_err("alg: aead: ivsize for %s (%u) doesn't match generic impl (%u)\n",
+		       driver, ivsize, crypto_aead_ivsize(generic_tfm));
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (blocksize != crypto_aead_blocksize(generic_tfm)) {
+		pr_err("alg: aead: blocksize for %s (%u) doesn't match generic impl (%u)\n",
+		       driver, blocksize, crypto_aead_blocksize(generic_tfm));
+		err = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Now generate test vectors using the generic implementation, and test
+	 * the other implementation against them.
+	 */
+
+	maxkeysize = 0;
+	for (i = 0; i < test_desc->suite.aead.count; i++)
+		maxkeysize = max_t(unsigned int, maxkeysize,
+				   test_desc->suite.aead.vecs[i].klen);
+
+	vec.key = kmalloc(maxkeysize, GFP_KERNEL);
+	vec.iv = kmalloc(ivsize, GFP_KERNEL);
+	vec.assoc = kmalloc(maxdatasize, GFP_KERNEL);
+	vec.ptext = kmalloc(maxdatasize, GFP_KERNEL);
+	vec.ctext = kmalloc(maxdatasize, GFP_KERNEL);
+	if (!vec.key || !vec.iv || !vec.assoc || !vec.ptext || !vec.ctext) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < fuzz_iterations * 8; i++) {
+		generate_random_aead_testvec(generic_req, &vec,
+					     maxkeysize, maxdatasize,
+					     vec_name, sizeof(vec_name));
+		generate_random_testvec_config(&cfg, cfgname, sizeof(cfgname));
+
+		err = test_aead_vec_cfg(driver, ENCRYPT, &vec, vec_name, &cfg,
+					req, tsgls);
+		if (err)
+			goto out;
+		err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name, &cfg,
+					req, tsgls);
+		if (err)
+			goto out;
+		cond_resched();
+	}
+	err = 0;
+out:
+	kfree(vec.key);
+	kfree(vec.iv);
+	kfree(vec.assoc);
+	kfree(vec.ptext);
+	kfree(vec.ctext);
+	crypto_free_aead(generic_tfm);
+	aead_request_free(generic_req);
+	return err;
+}
+#else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
+static int test_aead_vs_generic_impl(const char *driver,
+				     const struct alg_test_desc *test_desc,
+				     struct aead_request *req,
+				     struct cipher_test_sglists *tsgls)
+{
+	return 0;
+}
+#endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
+
 static int test_aead(const char *driver, int enc,
 		     const struct aead_test_suite *suite,
 		     struct aead_request *req,
@@ -1818,6 +2035,10 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 		goto out;
 
 	err = test_aead(driver, DECRYPT, suite, req, tsgls);
+	if (err)
+		goto out;
+
+	err = test_aead_vs_generic_impl(driver, desc, req, tsgls);
 out:
 	free_cipher_test_sglists(tsgls);
 	aead_request_free(req);
@@ -3562,6 +3783,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ccm(aes)",
+		.generic_driver = "ccm_base(ctr(aes-generic),cbcmac(aes-generic))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -3974,6 +4196,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "gcm(aes)",
+		.generic_driver = "gcm_base(ctr(aes-generic),ghash-generic)",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -4245,6 +4468,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "rfc4106(gcm(aes))",
+		.generic_driver = "rfc4106(gcm_base(ctr(aes-generic),ghash-generic))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -4252,6 +4476,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "rfc4309(ccm(aes))",
+		.generic_driver = "rfc4309(ccm_base(ctr(aes-generic),cbcmac(aes-generic)))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -4259,6 +4484,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "rfc4543(gcm(aes))",
+		.generic_driver = "rfc4543(gcm_base(ctr(aes-generic),ghash-generic))",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = __VECS(aes_gcm_rfc4543_tv_template)
-- 
2.21.0


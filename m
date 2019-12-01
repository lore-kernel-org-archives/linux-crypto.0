Return-Path: <SRS0=52Dc=ZX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB739C432C0
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 21:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACC3620865
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 21:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575237264;
	bh=pGk34DrcHh6rvXLSDHPpNSWaAxZKZ03bYz00Y8DrsCA=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lPzIVyO48Evm1CMDaj3HxQVRlMWVGsll0mIjS4NFi4Lo1LJB4jmukD8EsYTYxe8Pd
	 fQS0AYuc/XKrXRlBDnhqO+4A6gkfau7WVTYMf7p0V3KAAv7ZAMuWdy8aZQ2eVWtl+6
	 iRseDJjJ3TM9w/K2OytShOxk493JjqiVag0aMxKA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfLAVyX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Dec 2019 16:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbfLAVyX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Dec 2019 16:54:23 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FA9D21774
        for <linux-crypto@vger.kernel.org>; Sun,  1 Dec 2019 21:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575237261;
        bh=pGk34DrcHh6rvXLSDHPpNSWaAxZKZ03bYz00Y8DrsCA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hpNN5y5GoRXUduNV/tEshAxEyeQGGPjPe9W9T8fJfziNuivzIKFDKslpRs8iy+ebN
         LV+wZ5izSHlYIUjdxXFzEu/bBJBHkMgdQlDP8dUbn0+RPfv95GzcJmAqG/t6GuzfrH
         UWrYqg+t5EL5Q8k28p60eEHyRCSGvIlioudXM3XE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 7/7] crypto: testmgr - generate inauthentic AEAD test vectors
Date:   Sun,  1 Dec 2019 13:53:30 -0800
Message-Id: <20191201215330.171990-8-ebiggers@kernel.org>
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

The whole point of using an AEAD over length-preserving encryption is
that the data is authenticated.  However currently the fuzz tests don't
test any inauthentic inputs to verify that the data is actually being
authenticated.  And only two algorithms ("rfc4543(gcm(aes))" and
"ccm(aes)") even have any inauthentic test vectors at all.

Therefore, update the AEAD fuzz tests to sometimes generate inauthentic
test vectors, either by generating a (ciphertext, AAD) pair without
using the key, or by mutating an authentic pair that was generated.

To avoid flakiness, only assume this works reliably if the auth tag is
at least 8 bytes.  Also account for the rfc4106, rfc4309, and rfc7539esp
algorithms intentionally ignoring the last 8 AAD bytes, and for some
algorithms doing extra checks that result in EINVAL rather than EBADMSG.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 320 +++++++++++++++++++++++++++++++++++++----------
 crypto/testmgr.h |  14 ++-
 2 files changed, 261 insertions(+), 73 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4fe210845e78..88f33c0efb23 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -82,6 +82,19 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 struct aead_test_suite {
 	const struct aead_testvec *vecs;
 	unsigned int count;
+
+	/*
+	 * Set if trying to decrypt an inauthentic ciphertext with this
+	 * algorithm might result in EINVAL rather than EBADMSG, due to other
+	 * validation the algorithm does on the inputs such as length checks.
+	 */
+	unsigned int einval_allowed : 1;
+
+	/*
+	 * Set if the algorithm intentionally ignores the last 8 bytes of the
+	 * AAD buffer during decryption.
+	 */
+	unsigned int esp_aad : 1;
 };
 
 struct cipher_test_suite {
@@ -814,27 +827,39 @@ static unsigned int generate_random_length(unsigned int max_len)
 	}
 }
 
-/* Sometimes make some random changes to the given data buffer */
-static void mutate_buffer(u8 *buf, size_t count)
+/* Flip a random bit in the given nonempty data buffer */
+static void flip_random_bit(u8 *buf, size_t size)
+{
+	size_t bitpos;
+
+	bitpos = prandom_u32() % (size * 8);
+	buf[bitpos / 8] ^= 1 << (bitpos % 8);
+}
+
+/* Flip a random byte in the given nonempty data buffer */
+static void flip_random_byte(u8 *buf, size_t size)
+{
+	buf[prandom_u32() % size] ^= 0xff;
+}
+
+/* Sometimes make some random changes to the given nonempty data buffer */
+static void mutate_buffer(u8 *buf, size_t size)
 {
 	size_t num_flips;
 	size_t i;
-	size_t pos;
 
 	/* Sometimes flip some bits */
 	if (prandom_u32() % 4 == 0) {
-		num_flips = min_t(size_t, 1 << (prandom_u32() % 8), count * 8);
-		for (i = 0; i < num_flips; i++) {
-			pos = prandom_u32() % (count * 8);
-			buf[pos / 8] ^= 1 << (pos % 8);
-		}
+		num_flips = min_t(size_t, 1 << (prandom_u32() % 8), size * 8);
+		for (i = 0; i < num_flips; i++)
+			flip_random_bit(buf, size);
 	}
 
 	/* Sometimes flip some bytes */
 	if (prandom_u32() % 4 == 0) {
-		num_flips = min_t(size_t, 1 << (prandom_u32() % 8), count);
+		num_flips = min_t(size_t, 1 << (prandom_u32() % 8), size);
 		for (i = 0; i < num_flips; i++)
-			buf[prandom_u32() % count] ^= 0xff;
+			flip_random_byte(buf, size);
 	}
 }
 
@@ -1915,7 +1940,6 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 		 cfg->iv_offset +
 		 (cfg->iv_offset_relative_to_alignmask ? alignmask : 0);
 	struct kvec input[2];
-	int expected_error;
 	int err;
 
 	/* Set the key */
@@ -2036,20 +2060,31 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 		return -EINVAL;
 	}
 
-	/* Check for success or failure */
-	expected_error = vec->novrfy ? -EBADMSG : vec->crypt_error;
-	if (err) {
-		if (err == expected_error)
-			return 0;
-		pr_err("alg: aead: %s %s failed on test vector %s; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
-		       driver, op, vec_name, expected_error, err, cfg->name);
-		return err;
-	}
-	if (expected_error) {
-		pr_err("alg: aead: %s %s unexpectedly succeeded on test vector %s; expected_error=%d, cfg=\"%s\"\n",
+	/* Check for unexpected success or failure, or wrong error code */
+	if ((err == 0 && vec->novrfy) ||
+	    (err != vec->crypt_error && !(err == -EBADMSG && vec->novrfy))) {
+		char expected_error[32];
+
+		if (vec->novrfy &&
+		    vec->crypt_error != 0 && vec->crypt_error != -EBADMSG)
+			sprintf(expected_error, "-EBADMSG or %d",
+				vec->crypt_error);
+		else if (vec->novrfy)
+			sprintf(expected_error, "-EBADMSG");
+		else
+			sprintf(expected_error, "%d", vec->crypt_error);
+		if (err) {
+			pr_err("alg: aead: %s %s failed on test vector %s; expected_error=%s, actual_error=%d, cfg=\"%s\"\n",
+			       driver, op, vec_name, expected_error, err,
+			       cfg->name);
+			return err;
+		}
+		pr_err("alg: aead: %s %s unexpectedly succeeded on test vector %s; expected_error=%s, cfg=\"%s\"\n",
 		       driver, op, vec_name, expected_error, cfg->name);
 		return -EINVAL;
 	}
+	if (err) /* Expectedly failed. */
+		return 0;
 
 	/* Check for the correct output (ciphertext or plaintext) */
 	err = verify_correct_output(&tsgls->dst, enc ? vec->ctext : vec->ptext,
@@ -2128,24 +2163,112 @@ struct aead_extra_tests_ctx {
 };
 
 /*
- * Generate an AEAD test vector from the given implementation.
- * Assumes the buffers in 'vec' were already allocated.
+ * Make at least one random change to a (ciphertext, AAD) pair.  "Ciphertext"
+ * here means the full ciphertext including the authentication tag.  The
+ * authentication tag (and hence also the ciphertext) is assumed to be nonempty.
+ */
+static void mutate_aead_message(struct aead_testvec *vec, bool esp_aad)
+{
+	const unsigned int aad_tail_size = esp_aad ? 8 : 0;
+	const unsigned int authsize = vec->clen - vec->plen;
+
+	if (prandom_u32() % 2 == 0 && vec->alen > aad_tail_size) {
+		 /* Mutate the AAD */
+		flip_random_bit((u8 *)vec->assoc, vec->alen - aad_tail_size);
+		if (prandom_u32() % 2 == 0)
+			return;
+	}
+	if (prandom_u32() % 2 == 0) {
+		/* Mutate auth tag (assuming it's at the end of ciphertext) */
+		flip_random_bit((u8 *)vec->ctext + vec->plen, authsize);
+	} else {
+		/* Mutate any part of the ciphertext */
+		flip_random_bit((u8 *)vec->ctext, vec->clen);
+	}
+}
+
+/*
+ * Minimum authentication tag size in bytes at which we assume that we can
+ * reliably generate inauthentic messages, i.e. not generate an authentic
+ * message by chance.
+ */
+#define MIN_COLLISION_FREE_AUTHSIZE 8
+
+static void generate_aead_message(struct aead_request *req,
+				  const struct aead_test_suite *suite,
+				  struct aead_testvec *vec,
+				  bool prefer_inauthentic)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const unsigned int ivsize = crypto_aead_ivsize(tfm);
+	const unsigned int authsize = vec->clen - vec->plen;
+	const bool inauthentic = (authsize >= MIN_COLLISION_FREE_AUTHSIZE) &&
+				 (prefer_inauthentic || prandom_u32() % 4 == 0);
+
+	/* Generate the AAD. */
+	generate_random_bytes((u8 *)vec->assoc, vec->alen);
+
+	if (inauthentic && prandom_u32() % 2 == 0) {
+		/* Generate a random ciphertext. */
+		generate_random_bytes((u8 *)vec->ctext, vec->clen);
+	} else {
+		int i = 0;
+		struct scatterlist src[2], dst;
+		u8 iv[MAX_IVLEN];
+		DECLARE_CRYPTO_WAIT(wait);
+
+		/* Generate a random plaintext and encrypt it. */
+		sg_init_table(src, 2);
+		if (vec->alen)
+			sg_set_buf(&src[i++], vec->assoc, vec->alen);
+		if (vec->plen) {
+			generate_random_bytes((u8 *)vec->ptext, vec->plen);
+			sg_set_buf(&src[i++], vec->ptext, vec->plen);
+		}
+		sg_init_one(&dst, vec->ctext, vec->alen + vec->clen);
+		memcpy(iv, vec->iv, ivsize);
+		aead_request_set_callback(req, 0, crypto_req_done, &wait);
+		aead_request_set_crypt(req, src, &dst, vec->plen, iv);
+		aead_request_set_ad(req, vec->alen);
+		vec->crypt_error = crypto_wait_req(crypto_aead_encrypt(req),
+						   &wait);
+		/* If encryption failed, we're done. */
+		if (vec->crypt_error != 0)
+			return;
+		memmove((u8 *)vec->ctext, vec->ctext + vec->alen, vec->clen);
+		if (!inauthentic)
+			return;
+		/*
+		 * Mutate the authentic (ciphertext, AAD) pair to get an
+		 * inauthentic one.
+		 */
+		mutate_aead_message(vec, suite->esp_aad);
+	}
+	vec->novrfy = 1;
+	if (suite->einval_allowed)
+		vec->crypt_error = -EINVAL;
+}
+
+/*
+ * Generate an AEAD test vector 'vec' using the implementation specified by
+ * 'req'.  The buffers in 'vec' must already be allocated.
+ *
+ * If 'prefer_inauthentic' is true, then this function will generate inauthentic
+ * test vectors (i.e. vectors with 'vec->novrfy=1') more often.
  */
 static void generate_random_aead_testvec(struct aead_request *req,
 					 struct aead_testvec *vec,
+					 const struct aead_test_suite *suite,
 					 unsigned int maxkeysize,
 					 unsigned int maxdatasize,
-					 char *name, size_t max_namelen)
+					 char *name, size_t max_namelen,
+					 bool prefer_inauthentic)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	const unsigned int ivsize = crypto_aead_ivsize(tfm);
 	const unsigned int maxauthsize = crypto_aead_maxauthsize(tfm);
 	unsigned int authsize;
 	unsigned int total_len;
-	int i;
-	struct scatterlist src[2], dst;
-	u8 iv[MAX_IVLEN];
-	DECLARE_CRYPTO_WAIT(wait);
 
 	/* Key: length in [0, maxkeysize], but usually choose maxkeysize */
 	vec->klen = maxkeysize;
@@ -2161,50 +2284,83 @@ static void generate_random_aead_testvec(struct aead_request *req,
 	authsize = maxauthsize;
 	if (prandom_u32() % 4 == 0)
 		authsize = prandom_u32() % (maxauthsize + 1);
+	if (prefer_inauthentic && authsize < MIN_COLLISION_FREE_AUTHSIZE)
+		authsize = MIN_COLLISION_FREE_AUTHSIZE;
 	if (WARN_ON(authsize > maxdatasize))
 		authsize = maxdatasize;
 	maxdatasize -= authsize;
 	vec->setauthsize_error = crypto_aead_setauthsize(tfm, authsize);
 
-	/* Plaintext and associated data */
+	/* AAD, plaintext, and ciphertext lengths */
 	total_len = generate_random_length(maxdatasize);
 	if (prandom_u32() % 4 == 0)
 		vec->alen = 0;
 	else
 		vec->alen = generate_random_length(total_len);
 	vec->plen = total_len - vec->alen;
-	generate_random_bytes((u8 *)vec->assoc, vec->alen);
-	generate_random_bytes((u8 *)vec->ptext, vec->plen);
-
 	vec->clen = vec->plen + authsize;
 
 	/*
-	 * If the key or authentication tag size couldn't be set, no need to
-	 * continue to encrypt.
+	 * Generate the AAD, plaintext, and ciphertext.  Not applicable if the
+	 * key or the authentication tag size couldn't be set.
 	 */
+	vec->novrfy = 0;
 	vec->crypt_error = 0;
-	if (vec->setkey_error || vec->setauthsize_error)
-		goto done;
-
-	/* Ciphertext */
-	sg_init_table(src, 2);
-	i = 0;
-	if (vec->alen)
-		sg_set_buf(&src[i++], vec->assoc, vec->alen);
-	if (vec->plen)
-		sg_set_buf(&src[i++], vec->ptext, vec->plen);
-	sg_init_one(&dst, vec->ctext, vec->alen + vec->clen);
-	memcpy(iv, vec->iv, ivsize);
-	aead_request_set_callback(req, 0, crypto_req_done, &wait);
-	aead_request_set_crypt(req, src, &dst, vec->plen, iv);
-	aead_request_set_ad(req, vec->alen);
-	vec->crypt_error = crypto_wait_req(crypto_aead_encrypt(req), &wait);
-	if (vec->crypt_error == 0)
-		memmove((u8 *)vec->ctext, vec->ctext + vec->alen, vec->clen);
-done:
+	if (vec->setkey_error == 0 && vec->setauthsize_error == 0)
+		generate_aead_message(req, suite, vec, prefer_inauthentic);
 	snprintf(name, max_namelen,
-		 "\"random: alen=%u plen=%u authsize=%u klen=%u\"",
-		 vec->alen, vec->plen, authsize, vec->klen);
+		 "\"random: alen=%u plen=%u authsize=%u klen=%u novrfy=%d\"",
+		 vec->alen, vec->plen, authsize, vec->klen, vec->novrfy);
+}
+
+static void try_to_generate_inauthentic_testvec(
+					struct aead_extra_tests_ctx *ctx)
+{
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		generate_random_aead_testvec(ctx->req, &ctx->vec,
+					     &ctx->test_desc->suite.aead,
+					     ctx->maxkeysize, ctx->maxdatasize,
+					     ctx->vec_name,
+					     sizeof(ctx->vec_name), true);
+		if (ctx->vec.novrfy)
+			return;
+	}
+}
+
+/*
+ * Generate inauthentic test vectors (i.e. ciphertext, AAD pairs that aren't the
+ * result of an encryption with the key) and verify that decryption fails.
+ */
+static int test_aead_inauthentic_inputs(struct aead_extra_tests_ctx *ctx)
+{
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < fuzz_iterations * 8; i++) {
+		/*
+		 * Since this part of the tests isn't comparing the
+		 * implementation to another, there's no point in testing any
+		 * test vectors other than inauthentic ones (vec.novrfy=1) here.
+		 *
+		 * If we're having trouble generating such a test vector, e.g.
+		 * if the algorithm keeps rejecting the generated keys, don't
+		 * retry forever; just continue on.
+		 */
+		try_to_generate_inauthentic_testvec(ctx);
+		if (ctx->vec.novrfy) {
+			generate_random_testvec_config(&ctx->cfg, ctx->cfgname,
+						       sizeof(ctx->cfgname));
+			err = test_aead_vec_cfg(ctx->driver, DECRYPT, &ctx->vec,
+						ctx->vec_name, &ctx->cfg,
+						ctx->req, ctx->tsgls);
+			if (err)
+				return err;
+		}
+		cond_resched();
+	}
+	return 0;
 }
 
 /*
@@ -2285,17 +2441,20 @@ static int test_aead_vs_generic_impl(struct aead_extra_tests_ctx *ctx)
 	 */
 	for (i = 0; i < fuzz_iterations * 8; i++) {
 		generate_random_aead_testvec(generic_req, &ctx->vec,
+					     &ctx->test_desc->suite.aead,
 					     ctx->maxkeysize, ctx->maxdatasize,
 					     ctx->vec_name,
-					     sizeof(ctx->vec_name));
+					     sizeof(ctx->vec_name), false);
 		generate_random_testvec_config(&ctx->cfg, ctx->cfgname,
 					       sizeof(ctx->cfgname));
-		err = test_aead_vec_cfg(driver, ENCRYPT, &ctx->vec,
-					ctx->vec_name, &ctx->cfg,
-					ctx->req, ctx->tsgls);
-		if (err)
-			goto out;
-		if (ctx->vec.crypt_error == 0) {
+		if (!ctx->vec.novrfy) {
+			err = test_aead_vec_cfg(driver, ENCRYPT, &ctx->vec,
+						ctx->vec_name, &ctx->cfg,
+						ctx->req, ctx->tsgls);
+			if (err)
+				goto out;
+		}
+		if (ctx->vec.crypt_error == 0 || ctx->vec.novrfy) {
 			err = test_aead_vec_cfg(driver, DECRYPT, &ctx->vec,
 						ctx->vec_name, &ctx->cfg,
 						ctx->req, ctx->tsgls);
@@ -2348,6 +2507,10 @@ static int test_aead_extra(const char *driver,
 		goto out;
 	}
 
+	err = test_aead_inauthentic_inputs(ctx);
+	if (err)
+		goto out;
+
 	err = test_aead_vs_generic_impl(ctx);
 out:
 	kfree(ctx->vec.key);
@@ -3978,7 +4141,8 @@ static int alg_test_null(const struct alg_test_desc *desc,
 	return 0;
 }
 
-#define __VECS(tv)	{ .vecs = tv, .count = ARRAY_SIZE(tv) }
+#define ____VECS(tv)	.vecs = tv, .count = ARRAY_SIZE(tv)
+#define __VECS(tv)	{ ____VECS(tv) }
 
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
@@ -4284,7 +4448,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = __VECS(aes_ccm_tv_template)
+			.aead = {
+				____VECS(aes_ccm_tv_template),
+				.einval_allowed = 1,
+			}
 		}
 	}, {
 		.alg = "cfb(aes)",
@@ -5032,7 +5199,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = __VECS(aes_gcm_rfc4106_tv_template)
+			.aead = {
+				____VECS(aes_gcm_rfc4106_tv_template),
+				.einval_allowed = 1,
+				.esp_aad = 1,
+			}
 		}
 	}, {
 		.alg = "rfc4309(ccm(aes))",
@@ -5040,14 +5211,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
-			.aead = __VECS(aes_ccm_rfc4309_tv_template)
+			.aead = {
+				____VECS(aes_ccm_rfc4309_tv_template),
+				.einval_allowed = 1,
+				.esp_aad = 1,
+			}
 		}
 	}, {
 		.alg = "rfc4543(gcm(aes))",
 		.generic_driver = "rfc4543(gcm_base(ctr(aes-generic),ghash-generic))",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = __VECS(aes_gcm_rfc4543_tv_template)
+			.aead = {
+				____VECS(aes_gcm_rfc4543_tv_template),
+				.einval_allowed = 1,
+			}
 		}
 	}, {
 		.alg = "rfc7539(chacha20,poly1305)",
@@ -5059,7 +5237,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "rfc7539esp(chacha20,poly1305)",
 		.test = alg_test_aead,
 		.suite = {
-			.aead = __VECS(rfc7539esp_tv_template)
+			.aead = {
+				____VECS(rfc7539esp_tv_template),
+				.einval_allowed = 1,
+				.esp_aad = 1,
+			}
 		}
 	}, {
 		.alg = "rmd128",
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 48da646651cb..d29983908c38 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -85,16 +85,22 @@ struct cipher_testvec {
  * @ctext:	Pointer to the full authenticated ciphertext.  For AEADs that
  *		produce a separate "ciphertext" and "authentication tag", these
  *		two parts are concatenated: ciphertext || tag.
- * @novrfy:	Decryption verification failure expected?
+ * @novrfy:	If set, this is an inauthentic input test: only decryption is
+ *		tested, and it is expected to fail with either -EBADMSG or
+ *		@crypt_error if it is nonzero.
  * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
  *		(e.g. setkey() needs to fail due to a weak key)
  * @klen:	Length of @key in bytes
  * @plen:	Length of @ptext in bytes
  * @alen:	Length of @assoc in bytes
  * @clen:	Length of @ctext in bytes
- * @setkey_error: Expected error from setkey()
- * @setauthsize_error: Expected error from setauthsize()
- * @crypt_error: Expected error from encrypt() and decrypt()
+ * @setkey_error: Expected error from setkey().  If set, neither encryption nor
+ *		  decryption is tested.
+ * @setauthsize_error: Expected error from setauthsize().  If set, neither
+ *		       encryption nor decryption is tested.
+ * @crypt_error: When @novrfy=0, the expected error from encrypt().  When
+ *		 @novrfy=1, an optional alternate error code that is acceptable
+ *		 for decrypt() to return besides -EBADMSG.
  */
 struct aead_testvec {
 	const char *key;
-- 
2.24.0


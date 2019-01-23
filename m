Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A30C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 782302184C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548283983;
	bh=aJ5SVBlQtdhDQruxcH2GJN4Iom93pd+lEX7QvpA7EzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bPiCwTQ1Fdgo5nn2vEhU30yUjZ8F2hK8y2OojKhvXC5ogA2xHxU+I3YsEWTUSTIGV
	 bCvQ4cm1pjEj7m0DC1bqYUnCELuvZ3mN20Y+NRhhSfBav66mi2khm/5WJ0o+SZ3F8A
	 5Gw6r+r/EabHd5z5YNuCuUbv4rlt0fro1MXpuqO8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfAWWwh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:52:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbfAWWwg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:36 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C1D0218A2;
        Wed, 23 Jan 2019 22:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283954;
        bh=aJ5SVBlQtdhDQruxcH2GJN4Iom93pd+lEX7QvpA7EzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sd8bLBaf1GUaUmVpAUzEWRXPxfsnvSIEZwXp+mxPt+X2QsY7ePUHusUXvIwOVxuxx
         ZxOH6Y4I9yF6PLSGtH7lFAx+0Fpwi1G2iVucy8JafQHBKb6BO1BCYY1BYu+cV+La+b
         XiJRXl+GZNbs+QHeyuD5/ni1xSzM2+D1q+ASqeFQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [RFC/RFT PATCH 11/15] crypto: testmgr - convert skcipher testing to use testvec_configs
Date:   Wed, 23 Jan 2019 14:49:22 -0800
Message-Id: <20190123224926.250525-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <20190123224926.250525-1-ebiggers@kernel.org>
References: <20190123224926.250525-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert alg_test_skcipher() to use the new test framework, adding a list
of testvec_configs to test by default.  When the extra self-tests are
enabled, randomly generated testvec_configs are tested as well.

This improves skcipher test coverage mainly because now all algorithms
have a variety of data layouts tested, whereas before each algorithm was
responsible for declaring its own chunked test cases which were often
missing or provided poor test coverage.  The new code also tests both
the MAY_SLEEP and !MAY_SLEEP cases, different IV alignments, and buffers
that cross pages.

This has already found a bug in the arm64 ctr-aes-neonbs algorithm.
It would have easily found many past bugs.

I removed the skcipher chunked test vectors that were the same as
non-chunked ones, but left the ones that were unique.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 515 ++++++++++++++++++++++-------------------------
 crypto/testmgr.h | 253 -----------------------
 2 files changed, 245 insertions(+), 523 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ccc0e18b13ea..fd3fed8eee4e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -284,6 +284,68 @@ struct testvec_config {
 
 #define TESTVEC_CONFIG_NAMELEN	192
 
+/*
+ * The following are the lists of testvec_configs to test for each algorithm
+ * type when the basic crypto self-tests are enabled, i.e. when
+ * CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is unset.  They aim to provide good test
+ * coverage, while keeping the test time much shorter than the full fuzz tests
+ * so that the basic tests can be enabled in a wider range of circumstances.
+ */
+
+/* Configs for skciphers and aeads */
+static const struct testvec_config default_cipher_testvec_configs[] = {
+	{
+		.name = "in-place",
+		.inplace = true,
+		.src_divs = { { .proportion_of_total = 10000 } },
+	}, {
+		.name = "out-of-place",
+		.src_divs = { { .proportion_of_total = 10000 } },
+	}, {
+		.name = "unaligned buffer, offset=1",
+		.src_divs = { { .proportion_of_total = 10000, .offset = 1 } },
+		.iv_offset = 1,
+	}, {
+		.name = "buffer aligned only to alignmask",
+		.src_divs = {
+			{
+				.proportion_of_total = 10000,
+				.offset = 1,
+				.offset_relative_to_alignmask = true,
+			},
+		},
+		.iv_offset = 1,
+		.iv_offset_relative_to_alignmask = true,
+	}, {
+		.name = "two even aligned splits",
+		.src_divs = {
+			{ .proportion_of_total = 5000 },
+			{ .proportion_of_total = 5000 },
+		},
+	}, {
+		.name = "uneven misaligned splits, may sleep",
+		.req_flags = CRYPTO_TFM_REQ_MAY_SLEEP,
+		.src_divs = {
+			{ .proportion_of_total = 1900, .offset = 33 },
+			{ .proportion_of_total = 3300, .offset = 7  },
+			{ .proportion_of_total = 4800, .offset = 18 },
+		},
+		.iv_offset = 3,
+	}, {
+		.name = "misaligned splits crossing pages, inplace",
+		.inplace = true,
+		.src_divs = {
+			{
+				.proportion_of_total = 7500,
+				.offset = PAGE_SIZE - 32
+			}, {
+				.proportion_of_total = 2500,
+				.offset = PAGE_SIZE - 7
+			},
+		},
+	}
+};
+
 static unsigned int count_test_sg_divisions(const struct test_sg_division *divs)
 {
 	unsigned int remaining = TEST_SG_TOTAL;
@@ -1608,8 +1670,6 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 
 	j = 0;
 	for (i = 0; i < tcount; i++) {
-		if (template[i].np)
-			continue;
 
 		if (fips_enabled && template[i].fips_skip)
 			continue;
@@ -1667,282 +1727,214 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 	return ret;
 }
 
-static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
-			   const struct cipher_testvec *template,
-			   unsigned int tcount,
-			   const bool diff_dst, const int align_offset)
+static int test_skcipher_vec_cfg(const char *driver, int enc,
+				 const struct cipher_testvec *vec,
+				 unsigned int vec_num,
+				 const struct testvec_config *cfg,
+				 struct skcipher_request *req,
+				 struct cipher_test_sglists *tsgls)
 {
-	const char *algo =
-		crypto_tfm_alg_driver_name(crypto_skcipher_tfm(tfm));
-	unsigned int i, j, k, n, temp;
-	char *q;
-	struct skcipher_request *req;
-	struct scatterlist sg[8];
-	struct scatterlist sgout[8];
-	const char *e, *d;
-	struct crypto_wait wait;
-	const char *input, *result;
-	void *data;
-	char iv[MAX_IVLEN];
-	char *xbuf[XBUFSIZE];
-	char *xoutbuf[XBUFSIZE];
-	int ret = -ENOMEM;
-	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
-
-	if (testmgr_alloc_buf(xbuf))
-		goto out_nobuf;
-
-	if (diff_dst && testmgr_alloc_buf(xoutbuf))
-		goto out_nooutbuf;
-
-	if (diff_dst)
-		d = "-ddst";
-	else
-		d = "";
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const unsigned int alignmask = crypto_skcipher_alignmask(tfm);
+	const unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
+	const char *op = enc ? "encryption" : "decryption";
+	DECLARE_CRYPTO_WAIT(wait);
+	u8 _iv[3 * (MAX_ALGAPI_ALIGNMASK + 1) + MAX_IVLEN];
+	u8 *iv = PTR_ALIGN(&_iv[0], 2 * (MAX_ALGAPI_ALIGNMASK + 1)) +
+		 cfg->iv_offset +
+		 (cfg->iv_offset_relative_to_alignmask ? alignmask : 0);
+	struct kvec input;
+	int err;
 
-	if (enc == ENCRYPT)
-	        e = "encryption";
+	/* Set the key */
+	if (vec->wk)
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	else
-		e = "decryption";
-
-	crypto_init_wait(&wait);
-
-	req = skcipher_request_alloc(tfm, GFP_KERNEL);
-	if (!req) {
-		pr_err("alg: skcipher%s: Failed to allocate request for %s\n",
-		       d, algo);
-		goto out;
+		crypto_skcipher_clear_flags(tfm,
+					    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
+	err = crypto_skcipher_setkey(tfm, vec->key, vec->klen);
+	if (err) {
+		if (vec->fail) /* expectedly failed to set key? */
+			return 0;
+		pr_err("alg: skcipher: %s setkey failed with err %d on test vector %u; flags=%#x\n",
+		       driver, err, vec_num, crypto_skcipher_get_flags(tfm));
+		return err;
+	}
+	if (vec->fail) {
+		pr_err("alg: skcipher: %s setkey unexpectedly succeeded on test vector %u\n",
+		       driver, vec_num);
+		return -EINVAL;
 	}
 
-	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      crypto_req_done, &wait);
-
-	j = 0;
-	for (i = 0; i < tcount; i++) {
-		if (template[i].np && !template[i].also_non_np)
-			continue;
-
-		if (fips_enabled && template[i].fips_skip)
-			continue;
-
-		if (template[i].iv && !(template[i].generates_iv && enc))
-			memcpy(iv, template[i].iv, ivsize);
+	/* The IV must be copied to a buffer, as the algorithm may modify it */
+	if (ivsize) {
+		if (WARN_ON(ivsize > MAX_IVLEN))
+			return -EINVAL;
+		if (vec->iv && !(vec->generates_iv && enc))
+			memcpy(iv, vec->iv, ivsize);
 		else
-			memset(iv, 0, MAX_IVLEN);
-
-		input  = enc ? template[i].ptext : template[i].ctext;
-		result = enc ? template[i].ctext : template[i].ptext;
-		j++;
-		ret = -EINVAL;
-		if (WARN_ON(align_offset + template[i].len > PAGE_SIZE))
-			goto out;
-
-		data = xbuf[0];
-		data += align_offset;
-		memcpy(data, input, template[i].len);
-
-		crypto_skcipher_clear_flags(tfm, ~0);
-		if (template[i].wk)
-			crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
-
-		ret = crypto_skcipher_setkey(tfm, template[i].key,
-					     template[i].klen);
-		if (template[i].fail == !ret) {
-			pr_err("alg: skcipher%s: setkey failed on test %d for %s: flags=%x\n",
-			       d, j, algo, crypto_skcipher_get_flags(tfm));
-			goto out;
-		} else if (ret)
-			continue;
-
-		sg_init_one(&sg[0], data, template[i].len);
-		if (diff_dst) {
-			data = xoutbuf[0];
-			data += align_offset;
-			sg_init_one(&sgout[0], data, template[i].len);
-		}
-
-		skcipher_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
-					   template[i].len, iv);
-		ret = crypto_wait_req(enc ? crypto_skcipher_encrypt(req) :
-				      crypto_skcipher_decrypt(req), &wait);
-
-		if (ret) {
-			pr_err("alg: skcipher%s: %s failed on test %d for %s: ret=%d\n",
-			       d, e, j, algo, -ret);
-			goto out;
-		}
-
-		q = data;
-		if (memcmp(q, result, template[i].len)) {
-			pr_err("alg: skcipher%s: Test %d failed (invalid result) on %s for %s\n",
-			       d, j, e, algo);
-			hexdump(q, template[i].len);
-			ret = -EINVAL;
-			goto out;
-		}
-
-		if (template[i].generates_iv && enc &&
-		    memcmp(iv, template[i].iv, crypto_skcipher_ivsize(tfm))) {
-			pr_err("alg: skcipher%s: Test %d failed (invalid output IV) on %s for %s\n",
-			       d, j, e, algo);
-			hexdump(iv, crypto_skcipher_ivsize(tfm));
-			ret = -EINVAL;
-			goto out;
+			memset(iv, 0, ivsize);
+	} else {
+		if (vec->generates_iv) {
+			pr_err("alg: skcipher: %s has ivsize=0 but test vector %u generates IV!\n",
+			       driver, vec_num);
+			return -EINVAL;
 		}
+		iv = NULL;
 	}
 
-	j = 0;
-	for (i = 0; i < tcount; i++) {
-		/* alignment tests are only done with continuous buffers */
-		if (align_offset != 0)
-			break;
-
-		if (!template[i].np)
-			continue;
-
-		if (fips_enabled && template[i].fips_skip)
-			continue;
-
-		if (template[i].iv && !(template[i].generates_iv && enc))
-			memcpy(iv, template[i].iv, ivsize);
-		else
-			memset(iv, 0, MAX_IVLEN);
-
-		input  = enc ? template[i].ptext : template[i].ctext;
-		result = enc ? template[i].ctext : template[i].ptext;
-		j++;
-		crypto_skcipher_clear_flags(tfm, ~0);
-		if (template[i].wk)
-			crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
-
-		ret = crypto_skcipher_setkey(tfm, template[i].key,
-					     template[i].klen);
-		if (template[i].fail == !ret) {
-			pr_err("alg: skcipher%s: setkey failed on chunk test %d for %s: flags=%x\n",
-			       d, j, algo, crypto_skcipher_get_flags(tfm));
-			goto out;
-		} else if (ret)
-			continue;
-
-		temp = 0;
-		ret = -EINVAL;
-		sg_init_table(sg, template[i].np);
-		if (diff_dst)
-			sg_init_table(sgout, template[i].np);
-		for (k = 0; k < template[i].np; k++) {
-			if (WARN_ON(offset_in_page(IDX[k]) +
-				    template[i].tap[k] > PAGE_SIZE))
-				goto out;
-
-			q = xbuf[IDX[k] >> PAGE_SHIFT] + offset_in_page(IDX[k]);
-
-			memcpy(q, input + temp, template[i].tap[k]);
-
-			if (offset_in_page(q) + template[i].tap[k] < PAGE_SIZE)
-				q[template[i].tap[k]] = 0;
-
-			sg_set_buf(&sg[k], q, template[i].tap[k]);
-			if (diff_dst) {
-				q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
-				    offset_in_page(IDX[k]);
-
-				sg_set_buf(&sgout[k], q, template[i].tap[k]);
+	/* Build the src/dst scatterlists */
+	input.iov_base = enc ? (void *)vec->ptext : (void *)vec->ctext;
+	input.iov_len = vec->len;
+	err = build_cipher_test_sglists(tsgls, cfg, alignmask,
+					vec->len, vec->len, &input, 1);
+	if (err) {
+		pr_err("alg: skcipher: %s %s: error preparing scatterlists for test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return err;
+	}
 
-				memset(q, 0, template[i].tap[k]);
-				if (offset_in_page(q) +
-				    template[i].tap[k] < PAGE_SIZE)
-					q[template[i].tap[k]] = 0;
-			}
+	/* Do the actual encryption or decryption */
+	testmgr_poison(req->__ctx, crypto_skcipher_reqsize(tfm));
+	skcipher_request_set_callback(req, req_flags, crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, tsgls->src.sgl_ptr, tsgls->dst.sgl_ptr,
+				   vec->len, iv);
+	err = crypto_wait_req(enc ? crypto_skcipher_encrypt(req) :
+			      crypto_skcipher_decrypt(req), &wait);
+	if (err) {
+		pr_err("alg: skcipher: %s %s failed with err %d on test vector %u, cfg=\"%s\"\n",
+		       driver, op, err, vec_num, cfg->name);
+		return err;
+	}
 
-			temp += template[i].tap[k];
-		}
+	/* Check for the correct output (ciphertext or plaintext) */
+	err = verify_correct_output(&tsgls->dst, enc ? vec->ctext : vec->ptext,
+				    vec->len, 0, true);
+	if (err == -EOVERFLOW) {
+		pr_err("alg: skcipher: %s %s overran dst buffer on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return err;
+	}
+	if (err) {
+		pr_err("alg: skcipher: %s %s test failed (wrong result) on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return err;
+	}
 
-		skcipher_request_set_crypt(req, sg, (diff_dst) ? sgout : sg,
-					   template[i].len, iv);
+	/* If applicable, check that the algorithm generated the correct IV */
+	if (vec->generates_iv && enc && memcmp(iv, vec->iv, ivsize) != 0) {
+		pr_err("alg: skcipher: %s %s test failed (wrong output IV) on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		hexdump(iv, ivsize);
+		return -EINVAL;
+	}
 
-		ret = crypto_wait_req(enc ? crypto_skcipher_encrypt(req) :
-				      crypto_skcipher_decrypt(req), &wait);
+	return 0;
+}
 
-		if (ret) {
-			pr_err("alg: skcipher%s: %s failed on chunk test %d for %s: ret=%d\n",
-			       d, e, j, algo, -ret);
-			goto out;
-		}
+static int test_skcipher_vec(const char *driver, int enc,
+			     const struct cipher_testvec *vec,
+			     unsigned int vec_num,
+			     struct skcipher_request *req,
+			     struct cipher_test_sglists *tsgls)
+{
+	unsigned int i;
+	int err;
 
-		temp = 0;
-		ret = -EINVAL;
-		for (k = 0; k < template[i].np; k++) {
-			if (diff_dst)
-				q = xoutbuf[IDX[k] >> PAGE_SHIFT] +
-				    offset_in_page(IDX[k]);
-			else
-				q = xbuf[IDX[k] >> PAGE_SHIFT] +
-				    offset_in_page(IDX[k]);
+	if (fips_enabled && vec->fips_skip)
+		return 0;
 
-			if (memcmp(q, result + temp, template[i].tap[k])) {
-				pr_err("alg: skcipher%s: Chunk test %d failed on %s at page %u for %s\n",
-				       d, j, e, k, algo);
-				hexdump(q, template[i].tap[k]);
-				goto out;
-			}
+	for (i = 0; i < ARRAY_SIZE(default_cipher_testvec_configs); i++) {
+		err = test_skcipher_vec_cfg(driver, enc, vec, vec_num,
+					    &default_cipher_testvec_configs[i],
+					    req, tsgls);
+		if (err)
+			return err;
+	}
 
-			q += template[i].tap[k];
-			for (n = 0; offset_in_page(q + n) && q[n]; n++)
-				;
-			if (n) {
-				pr_err("alg: skcipher%s: Result buffer corruption in chunk test %d on %s at page %u for %s: %u bytes:\n",
-				       d, j, e, k, algo, n);
-				hexdump(q, n);
-				goto out;
-			}
-			temp += template[i].tap[k];
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+	if (!noextratests) {
+		struct testvec_config cfg;
+		char cfgname[TESTVEC_CONFIG_NAMELEN];
+
+		for (i = 0; i < fuzz_iterations; i++) {
+			generate_random_testvec_config(&cfg, cfgname,
+						       sizeof(cfgname));
+			err = test_skcipher_vec_cfg(driver, enc, vec, vec_num,
+						    &cfg, req, tsgls);
+			if (err)
+				return err;
 		}
 	}
+#endif
+	return 0;
+}
 
-	ret = 0;
+static int test_skcipher(const char *driver, int enc,
+			 const struct cipher_test_suite *suite,
+			 struct skcipher_request *req,
+			 struct cipher_test_sglists *tsgls)
+{
+	unsigned int i;
+	int err;
 
-out:
-	skcipher_request_free(req);
-	if (diff_dst)
-		testmgr_free_buf(xoutbuf);
-out_nooutbuf:
-	testmgr_free_buf(xbuf);
-out_nobuf:
-	return ret;
+	for (i = 0; i < suite->count; i++) {
+		err = test_skcipher_vec(driver, enc, &suite->vecs[i], i, req,
+					tsgls);
+		if (err)
+			return err;
+	}
+	return 0;
 }
 
-static int test_skcipher(struct crypto_skcipher *tfm, int enc,
-			 const struct cipher_testvec *template,
-			 unsigned int tcount)
+static int alg_test_skcipher(const struct alg_test_desc *desc,
+			     const char *driver, u32 type, u32 mask)
 {
-	unsigned int alignmask;
-	int ret;
+	const struct cipher_test_suite *suite = &desc->suite.cipher;
+	struct crypto_skcipher *tfm;
+	struct skcipher_request *req = NULL;
+	struct cipher_test_sglists *tsgls = NULL;
+	int err;
 
-	/* test 'dst == src' case */
-	ret = __test_skcipher(tfm, enc, template, tcount, false, 0);
-	if (ret)
-		return ret;
+	if (suite->count <= 0) {
+		pr_err("alg: skcipher: empty test suite for %s\n", driver);
+		return -EINVAL;
+	}
 
-	/* test 'dst != src' case */
-	ret = __test_skcipher(tfm, enc, template, tcount, true, 0);
-	if (ret)
-		return ret;
+	tfm = crypto_alloc_skcipher(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		pr_err("alg: skcipher: failed to allocate transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
 
-	/* test unaligned buffers, check with one byte offset */
-	ret = __test_skcipher(tfm, enc, template, tcount, true, 1);
-	if (ret)
-		return ret;
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		pr_err("alg: skcipher: failed to allocate request for %s\n",
+		       driver);
+		err = -ENOMEM;
+		goto out;
+	}
 
-	alignmask = crypto_tfm_alg_alignmask(&tfm->base);
-	if (alignmask) {
-		/* Check if alignment mask for tfm is correctly set. */
-		ret = __test_skcipher(tfm, enc, template, tcount, true,
-				      alignmask + 1);
-		if (ret)
-			return ret;
+	tsgls = alloc_cipher_test_sglists();
+	if (!tsgls) {
+		pr_err("alg: skcipher: failed to allocate test buffers for %s\n",
+		       driver);
+		err = -ENOMEM;
+		goto out;
 	}
 
-	return 0;
+	err = test_skcipher(driver, ENCRYPT, suite, req, tsgls);
+	if (err)
+		goto out;
+
+	err = test_skcipher(driver, DECRYPT, suite, req, tsgls);
+out:
+	free_cipher_test_sglists(tsgls);
+	skcipher_request_free(req);
+	crypto_free_skcipher(tfm);
+	return err;
 }
 
 static int test_comp(struct crypto_comp *tfm,
@@ -2326,28 +2318,6 @@ static int alg_test_cipher(const struct alg_test_desc *desc,
 	return err;
 }
 
-static int alg_test_skcipher(const struct alg_test_desc *desc,
-			     const char *driver, u32 type, u32 mask)
-{
-	const struct cipher_test_suite *suite = &desc->suite.cipher;
-	struct crypto_skcipher *tfm;
-	int err;
-
-	tfm = crypto_alloc_skcipher(driver, type, mask);
-	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: skcipher: Failed to load transform for "
-		       "%s: %ld\n", driver, PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
-
-	err = test_skcipher(tfm, ENCRYPT, suite->vecs, suite->count);
-	if (!err)
-		err = test_skcipher(tfm, DECRYPT, suite->vecs, suite->count);
-
-	crypto_free_skcipher(tfm);
-	return err;
-}
-
 static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
@@ -4220,6 +4190,11 @@ static void alg_check_test_descs_order(void)
 
 static void alg_check_testvec_configs(void)
 {
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(default_cipher_testvec_configs); i++)
+		WARN_ON(!valid_testvec_config(
+				&default_cipher_testvec_configs[i]));
 }
 
 static void testmgr_onetime_init(void)
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index d8f6035c7ff2..1a73af8a79f7 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -52,10 +52,6 @@ struct hash_testvec {
  * @fail:	If set to one, the test need to fail
  * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
  * 		( e.g. test needs to fail due to a weak key )
- * @np: 	numbers of SG to distribute data in (from 1 to MAX_TAP)
- * @tap:	How to distribute data in @np SGs
- * @also_non_np: 	if set to 1, the test will be also done without
- * 			splitting data in @np SGs
  * @fips_skip:	Skip the test vector in FIPS mode
  * @generates_iv: Encryption should ignore the given IV, and output @iv.
  *		  Decryption takes @iv.  Needed for AES Keywrap ("kw(aes)").
@@ -65,9 +61,6 @@ struct cipher_testvec {
 	const char *iv;
 	const char *ptext;
 	const char *ctext;
-	unsigned short tap[MAX_TAP];
-	int np;
-	unsigned char also_non_np;
 	bool fail;
 	unsigned char wk; /* weak key flag */
 	unsigned char klen;
@@ -7011,18 +7004,6 @@ static const struct cipher_testvec des_tv_template[] = {
 		.ctext	= "\xc9\x57\x44\x25\x6a\x5e\xd3\x1d"
 			  "\xf7\x9c\x89\x2a\x33\x8f\x4a\x8b",
 		.len	= 16,
-		.np	= 2,
-		.tap	= { 8, 8 }
-	}, {
-		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
-		.klen	= 8,
-		.ptext	= "\x01\x23\x45\x67\x89\xab\xcd\xe7"
-			  "\xa3\x99\x7b\xca\xaf\x69\xa0\xf5",
-		.ctext	= "\xc9\x57\x44\x25\x6a\x5e\xd3\x1d"
-			  "\x69\x0f\x5b\x0d\x9a\x26\x93\x9b",
-		.len	= 16,
-		.np	= 2,
-		.tap	= { 8, 8 }
 	}, {
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -7031,8 +7012,6 @@ static const struct cipher_testvec des_tv_template[] = {
 		.ctext	= "\xc9\x57\x44\x25\x6a\x5e\xd3\x1d"
 			  "\x69\x0f\x5b\x0d\x9a\x26\x93\x9b",
 		.len	= 16,
-		.np	= 3,
-		.tap	= { 3, 12, 1 }
 	}, { /* Four blocks -- for testing encryption with chunking */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -7045,38 +7024,6 @@ static const struct cipher_testvec des_tv_template[] = {
 			  "\xb4\x99\x26\xf7\x1f\xe1\xd4\x90"
 			  "\xf7\x9c\x89\x2a\x33\x8f\x4a\x8b",
 		.len	= 32,
-		.np	= 3,
-		.tap	= { 14, 10, 8 }
-	}, {
-		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
-		.klen	= 8,
-		.ptext	= "\x01\x23\x45\x67\x89\xab\xcd\xe7"
-			  "\x22\x33\x44\x55\x66\x77\x88\x99"
-			  "\xca\xfe\xba\xbe\xfe\xed\xbe\xef",
-		.ctext	= "\xc9\x57\x44\x25\x6a\x5e\xd3\x1d"
-			  "\xf7\x9c\x89\x2a\x33\x8f\x4a\x8b"
-			  "\xb4\x99\x26\xf7\x1f\xe1\xd4\x90",
-		.len	= 24,
-		.np	= 4,
-		.tap	= { 2, 1, 3, 18 }
-	}, {
-		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
-		.klen	= 8,
-		.ptext	= "\x01\x23\x45\x67\x89\xab\xcd\xe7"
-			  "\x22\x33\x44\x55\x66\x77\x88\x99",
-		.ctext	= "\xc9\x57\x44\x25\x6a\x5e\xd3\x1d"
-			  "\xf7\x9c\x89\x2a\x33\x8f\x4a\x8b",
-		.len	= 16,
-		.np	= 5,
-		.tap	= { 2, 2, 2, 2, 8 }
-	}, {
-		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
-		.klen	= 8,
-		.ptext	= "\x01\x23\x45\x67\x89\xab\xcd\xe7",
-		.ctext	= "\xc9\x57\x44\x25\x6a\x5e\xd3\x1d",
-		.len	= 8,
-		.np	= 8,
-		.tap	= { 1, 1, 1, 1, 1, 1, 1, 1 }
 	}, { /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
@@ -7143,9 +7090,6 @@ static const struct cipher_testvec des_tv_template[] = {
 			  "\xE1\x58\x39\x09\xB4\x8B\x40\xAC"
 			  "\x5F\x62\xC7\x72\xD9\xFC\xCB\x9A",
 		.len	= 248,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 248 - 10, 2, 8 },
 	},
 };
 
@@ -7182,23 +7126,6 @@ static const struct cipher_testvec des_cbc_tv_template[] = {
 		.ptext	= "\x66\x6f\x72\x20\x61\x6c\x6c\x20",
 		.ctext	= "\x68\x37\x88\x49\x9a\x7c\x05\xf6",
 		.len	= 8,
-		.np	= 2,
-		.tap	= { 4, 4 },
-		.also_non_np = 1,
-	}, { /* Copy of openssl vector for chunk testing */
-	     /* From OpenSSL */
-		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
-		.klen	= 8,
-		.iv	= "\xfe\xdc\xba\x98\x76\x54\x32\x10",
-		.ptext	= "\x37\x36\x35\x34\x33\x32\x31\x20"
-			  "\x4e\x6f\x77\x20\x69\x73\x20\x74"
-			  "\x68\x65\x20\x74\x69\x6d\x65\x20",
-		.ctext	= "\xcc\xd1\x73\xff\xab\x20\x39\xf4"
-			  "\xac\xd8\xae\xfd\xdf\xd8\xa1\xeb"
-			  "\x46\x8e\x91\x15\x78\x88\xba\x68",
-		.len	= 24,
-		.np	= 2,
-		.tap	= { 13, 11 }
 	}, { /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
@@ -7266,9 +7193,6 @@ static const struct cipher_testvec des_cbc_tv_template[] = {
 			  "\x82\xA9\xBD\x6A\x31\x91\x39\x11"
 			  "\xC6\x4A\xF3\x55\xC7\x29\x2E\x63",
 		.len	= 248,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 248 - 10, 2, 8 },
 	},
 };
 
@@ -7340,9 +7264,6 @@ static const struct cipher_testvec des_ctr_tv_template[] = {
 			  "\x19\x7F\x99\x19\x53\xCE\x1D\x14"
 			  "\x69\x74\xA1\x06\x46\x0F\x4E\x75",
 		.len	= 248,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 248 - 10, 2, 8 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
@@ -7410,9 +7331,6 @@ static const struct cipher_testvec des_ctr_tv_template[] = {
 			  "\xA5\xA6\xE7\xB0\x51\x36\x52\x37"
 			  "\x91\x45\x05\x3E\x58\xBF\x32",
 		.len	= 247,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 247 - 8, 8 },
 	},
 };
 
@@ -7571,9 +7489,6 @@ static const struct cipher_testvec des3_ede_tv_template[] = {
 			  "\x93\x03\xD7\x51\x09\xFA\xBE\x68"
 			  "\xD8\x45\xFF\x33\xBA\xBB\x2B\x63",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -7749,9 +7664,6 @@ static const struct cipher_testvec des3_ede_cbc_tv_template[] = {
 			  "\x83\x70\xFF\x86\xE6\xAA\x0F\x1F"
 			  "\x95\x63\x73\xA2\x44\xAC\xF8\xA5",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -7888,9 +7800,6 @@ static const struct cipher_testvec des3_ede_ctr_tv_template[] = {
 			  "\xFD\x51\xB0\xC6\x2C\x63\x13\x78"
 			  "\x5C\xEE\xFC\xCF\xC4\x70\x00\x34",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\x9C\xD6\xF3\x9C\xB9\x5A\x67\x00"
 			  "\x5A\x67\x00\x2D\xCE\xEB\x2D\xCE"
@@ -8025,9 +7934,6 @@ static const struct cipher_testvec des3_ede_ctr_tv_template[] = {
 			  "\x32\x0F\x05\x2F\xF2\x4C\x95\x3B"
 			  "\xF2\x79\xD9",
 		.len	= 499,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 499 - 16, 16 },
 	},
 };
 
@@ -8213,9 +8119,6 @@ static const struct cipher_testvec bf_tv_template[] = {
 			  "\x56\xEB\x36\x77\x3D\xAA\xB8\xF5"
 			  "\xC9\x1A\xFB\x5D\xDE\xBB\x43\xF4",
 		.len	= 504,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 504 - 10, 2, 8 },
 	},
 };
 
@@ -8368,9 +8271,6 @@ static const struct cipher_testvec bf_cbc_tv_template[] = {
 			  "\x93\x9B\xEE\xB5\x97\x41\xD2\xA0"
 			  "\xB4\x98\xD8\x6B\x74\xE7\x65\xF4",
 		.len	= 504,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 504 - 10, 2, 8 },
 	},
 };
 
@@ -8643,9 +8543,6 @@ static const struct cipher_testvec bf_ctr_tv_template[] = {
 			  "\x32\x44\x96\x1C\xD8\xEB\x95\xD2"
 			  "\xF3\x71\xEF\xEB\x4E\xBB\x4D",
 		.len	= 503,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 503 - 8, 8 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -8944,9 +8841,6 @@ static const struct cipher_testvec tf_tv_template[] = {
 			  "\x58\x33\x9B\x78\xC7\x58\x48\x6B"
 			  "\x2C\x75\x64\xC4\xCA\xC1\x7E\xD5",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -9122,9 +9016,6 @@ static const struct cipher_testvec tf_cbc_tv_template[] = {
 			  "\x30\x70\x56\xA4\x37\xDD\x7C\xC0"
 			  "\x0A\xA3\x30\x10\x26\x25\x41\x2C",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -9530,9 +9421,6 @@ static const struct cipher_testvec tf_ctr_tv_template[] = {
 			  "\xC5\xC9\x7F\x9E\xCF\x33\x7A\xDF"
 			  "\x6C\x82\x9D",
 		.len	= 499,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 499 - 16, 16 },
 	},
 };
 
@@ -9774,9 +9662,6 @@ static const struct cipher_testvec tf_lrw_tv_template[] = {
 			  "\x80\x18\xc4\x6c\x03\xd3\xb7\xba"
 			  "\x11\xd7\xb8\x6e\xea\xe1\x80\x30",
 		.len	= 512,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -10111,9 +9996,6 @@ static const struct cipher_testvec tf_xts_tv_template[] = {
 			  "\xa4\x05\x0b\xb2\xb3\xa8\x30\x97"
 			  "\x37\x30\xe1\x91\x8d\xb3\x2a\xff",
 		.len	= 512,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -10286,9 +10168,6 @@ static const struct cipher_testvec serpent_tv_template[] = {
 			  "\x75\x55\x9B\xFF\x36\x73\xAB\x7C"
 			  "\xF4\x46\x2E\xEB\xAC\xF3\xD2\xB7",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -10505,9 +10384,6 @@ static const struct cipher_testvec serpent_cbc_tv_template[] = {
 			  "\xFC\x66\xAA\x37\xF2\x37\x39\x6B"
 			  "\xBC\x08\x3A\xA2\x29\xB3\xDF\xD1",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -10780,9 +10656,6 @@ static const struct cipher_testvec serpent_ctr_tv_template[] = {
 			  "\x40\x53\x77\x8C\x15\xF8\x8D\x13"
 			  "\x38\xE2\xE5",
 		.len	= 499,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 499 - 16, 16 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -11157,9 +11030,6 @@ static const struct cipher_testvec serpent_lrw_tv_template[] = {
 			  "\x5c\xc6\x84\xfe\x7c\xcb\x26\xfd"
 			  "\xd9\x51\x0f\xd7\x94\x2f\xc5\xa7",
 		.len	= 512,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -11494,9 +11364,6 @@ static const struct cipher_testvec serpent_xts_tv_template[] = {
 			  "\xaf\x43\x0b\xc5\x20\x41\x92\x20"
 			  "\xd4\xa0\x91\x98\x11\x5f\x4d\xb1",
 		.len	= 512,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -11836,9 +11703,6 @@ static const struct cipher_testvec cast6_tv_template[] = {
 			  "\x84\x52\x6D\x68\xDE\xC6\x64\xB2"
 			  "\x11\x74\x93\x57\xB4\x7E\xC6\x00",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -11976,9 +11840,6 @@ static const struct cipher_testvec cast6_cbc_tv_template[] = {
 			  "\x4D\x59\x7D\xC5\x28\x69\xFA\x92"
 			  "\x22\x46\x89\x2D\x0F\x2B\x08\x24",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -12131,9 +11992,6 @@ static const struct cipher_testvec cast6_ctr_tv_template[] = {
 			  "\x0E\x74\x33\x30\x62\xB9\x89\xDF"
 			  "\xF9\xC5\xDD\x27\xB3\x39\xCB\xCB",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -12277,9 +12135,6 @@ static const struct cipher_testvec cast6_lrw_tv_template[] = {
 			  "\x8D\xD9\xCD\x3B\x22\x67\x18\xC7"
 			  "\xC4\xF5\x99\x61\xBC\xBB\x5B\x46",
 		.len	= 512,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -12425,9 +12280,6 @@ static const struct cipher_testvec cast6_xts_tv_template[] = {
 			  "\xA1\xAC\xE8\xCF\xC6\x74\xCF\xDC"
 			  "\x22\x60\x4E\xE8\xA4\x5D\x85\xB9",
 		.len	= 512,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -12596,9 +12448,6 @@ static const struct cipher_testvec aes_tv_template[] = {
 			  "\x09\x79\xA0\x43\x5C\x0D\x08\x58"
 			  "\x17\xBB\xC0\x6B\x62\x3F\x56\xE9",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -12613,9 +12462,6 @@ static const struct cipher_testvec aes_cbc_tv_template[] = {
 		.ctext	= "\xe3\x53\x77\x9c\x10\x79\xae\xb8"
 			  "\x27\x08\x94\x2d\xbe\x77\x18\x1a",
 		.len	= 16,
-		.also_non_np = 1,
-		.np	= 8,
-		.tap	= { 3, 2, 3, 2, 3, 1, 1, 1 },
 	}, {
 		.key    = "\xc2\x86\x69\x6d\x88\x7c\x9a\xa0"
 			  "\x61\x1b\xbb\x3e\x20\x25\xa4\x5a",
@@ -12813,9 +12659,6 @@ static const struct cipher_testvec aes_cbc_tv_template[] = {
 			  "\xE0\x1F\x91\xF8\x82\x96\x2D\x65"
 			  "\xA3\xAA\x13\xCC\x50\xFF\x7B\x02",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -12892,9 +12735,6 @@ static const struct cipher_testvec aes_cfb_tv_template[] = {
 			  "\x75\xa3\x85\x74\x1a\xb9\xce\xf8"
 			  "\x20\x31\x62\x3d\x55\xb1\xe4\x71",
 		.len	= 64,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 31, 33 },
 	}, { /* > 16 bytes, not a multiple of 16 bytes */
 		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
 			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
@@ -14795,9 +14635,6 @@ static const struct cipher_testvec aes_lrw_tv_template[] = {
 			  "\xcd\x7e\x2b\x5d\x43\xea\x42\xe7"
 			  "\x74\x3f\x7d\x58\x88\x75\xde\x3e",
 		.len	= 512,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 512 - 20, 4, 16 },
 	}
 };
 
@@ -15133,9 +14970,6 @@ static const struct cipher_testvec aes_xts_tv_template[] = {
 			  "\xc4\xf3\x6f\xfd\xa9\xfc\xea\x70"
 			  "\xb9\xc6\xe6\x93\xe1\x48\xc1\x51",
 		.len	= 512,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 512 - 20, 4, 16 },
 	}
 };
 
@@ -15345,9 +15179,6 @@ static const struct cipher_testvec aes_ctr_tv_template[] = {
 			  "\xFA\x3A\x05\x4C\xFA\xD1\xFF\xFE"
 			  "\xF1\x4C\xE5\xB2\x91\x64\x0C\x51",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55"
 			  "\x0F\x32\x55\x78\x9B\xBE\x78\x9B"
@@ -15483,9 +15314,6 @@ static const struct cipher_testvec aes_ctr_tv_template[] = {
 			  "\xD8\xFE\xC9\x5B\x5C\x25\xE5\x76"
 			  "\xFB\xF2\x3F",
 		.len	= 499,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 499 - 16, 16 },
 	},
 };
 
@@ -16609,8 +16437,6 @@ static const struct cipher_testvec aes_ctr_rfc3686_tv_template[] = {
 			"\x4b\xef\x31\x18\xea\xac\xb1\x84"
 			"\x21\xed\xda\x86",
 		.len	= 4100,
-		.np	= 2,
-		.tap	= { 4064, 36 },
 	},
 };
 
@@ -16638,9 +16464,6 @@ static const struct cipher_testvec aes_ofb_tv_template[] = {
 			  "\x30\x4c\x65\x28\xf6\x59\xc7\x78"
 			  "\x66\xa5\x10\xd9\xc1\xd6\xae\x5e",
 		.len	= 64,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 31, 33 },
 	}, { /* > 16 bytes, not a multiple of 16 bytes */
 		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
 			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
@@ -23174,9 +22997,6 @@ static const struct cipher_testvec cast5_tv_template[] = {
 			  "\x4F\xFE\x24\x9C\x9A\x02\xE5\x57"
 			  "\xF5\xBC\x25\xD6\x02\x56\x57\x1C",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -23311,9 +23131,6 @@ static const struct cipher_testvec cast5_cbc_tv_template[] = {
 			  "\x15\x5F\xDB\xE9\xB1\x83\xD2\xE6"
 			  "\x1D\x18\x66\x44\x5B\x8F\x14\xEB",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -23460,9 +23277,6 @@ static const struct cipher_testvec cast5_ctr_tv_template[] = {
 			  "\x8C\x98\xDB\xDE\xFC\x72\x94\xAA"
 			  "\xC0\x0D\x96\xAA\x23\xF8\xFE\x13",
 		.len	= 496,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -23835,20 +23649,6 @@ static const struct cipher_testvec fcrypt_pcbc_tv_template[] = {
 			  "\x19\x89\x09\x1c\x2a\x8e\x8c\x94"
 			  "\xfc\xc7\x68\xe4\x88\xaa\xde\x0f",
 		.len	= 48,
-	}, { /* split-page version */
-		.key	= "\xfe\xdc\xba\x98\x76\x54\x32\x10",
-		.klen	= 8,
-		.iv	= "\xf0\xe1\xd2\xc3\xb4\xa5\x96\x87",
-		.ptext	= "The quick brown fox jumps over the lazy dogs.\0\0",
-		.ctext	= "\xca\x90\xf5\x9d\xcb\xd4\xd2\x3c"
-			  "\x01\x88\x7f\x3e\x31\x6e\x62\x9d"
-			  "\xd8\xe0\x57\xa3\x06\x3a\x42\x58"
-			  "\x2a\x28\xfe\x72\x52\x2f\xdd\xe0"
-			  "\x19\x89\x09\x1c\x2a\x8e\x8c\x94"
-			  "\xfc\xc7\x68\xe4\x88\xaa\xde\x0f",
-		.len	= 48,
-		.np	= 2,
-		.tap	= { 20, 28 },
 	}
 };
 
@@ -24145,9 +23945,6 @@ static const struct cipher_testvec camellia_tv_template[] = {
 			  "\xF8\xB2\xAA\x7A\xD6\xFF\xFA\x55"
 			  "\x33\x1A\xBB\xD3\xA2\x7E\x97\x66",
 		.len	= 1008,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 1008 - 20, 4, 16 },
 	},
 };
 
@@ -24438,9 +24235,6 @@ static const struct cipher_testvec camellia_cbc_tv_template[] = {
 			  "\x55\x01\xD4\x58\xB2\xF2\x85\x49"
 			  "\x70\xC5\xB9\x0B\x3B\x7A\x6E\x6C",
 		.len	= 1008,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 1008 - 20, 4, 16 },
 	},
 };
 
@@ -24841,9 +24635,6 @@ static const struct cipher_testvec camellia_ctr_tv_template[] = {
 			  "\xE7\x2C\x49\x08\x8B\x72\xFA\x5C"
 			  "\xF1\x6B\xD9",
 		.len	= 1011,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 1011 - 16, 16 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -25346,9 +25137,6 @@ static const struct cipher_testvec camellia_lrw_tv_template[] = {
 			  "\xb2\x1a\xd8\x4c\xbd\x1d\x10\xe9"
 			  "\x5a\xa8\x92\x7f\xba\xe6\x0c\x95",
 		.len	= 512,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -25683,9 +25471,6 @@ static const struct cipher_testvec camellia_xts_tv_template[] = {
 			  "\xb7\x16\xd8\x12\x5c\xcd\x7d\x4e"
 			  "\xd5\xc6\x99\xcc\x4e\x6c\x94\x95",
 		.len	= 512,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -26889,8 +26674,6 @@ static const struct cipher_testvec salsa20_stream_tv_template[] = {
 			"\x87\x13\xc6\x5b\x59\x8d\xf2\xc8"
 			"\xaf\xdf\x11\x95",
 		.len	= 4100,
-		.np	= 2,
-		.tap	= { 4064, 36 },
 	},
 };
 
@@ -27023,9 +26806,6 @@ static const struct cipher_testvec chacha20_tv_template[] = {
 			  "\x5b\x86\x2f\x37\x30\xe3\x7c\xfd"
 			  "\xc4\xfd\x80\x6c\x22\xf2\x21",
 		.len	= 375,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 375 - 20, 4, 16 },
 
 	}, { /* RFC7539 A.2. Test Vector #3 */
 		.key	= "\x1c\x92\x40\xa5\xeb\x55\xd3\x8a"
@@ -27399,9 +27179,6 @@ static const struct cipher_testvec chacha20_tv_template[] = {
 			  "\xa1\xed\xad\xd5\x76\xfa\x24\x8f"
 			  "\x98",
 		.len	= 1281,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 1200, 1, 80 },
 	},
 };
 
@@ -27594,9 +27371,6 @@ static const struct cipher_testvec xchacha20_tv_template[] = {
 			  "\xab\xff\x1f\x12\xc3\xee\xe5\x65"
 			  "\x12\x8d\x7b\x61\xe5\x1f\x98",
 		.len	= 375,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 375 - 20, 4, 16 },
 
 	}, { /* Derived from a ChaCha20 test vector, via the process above */
 		.key	= "\x1c\x92\x40\xa5\xeb\x55\xd3\x8a"
@@ -27974,9 +27748,6 @@ static const struct cipher_testvec xchacha20_tv_template[] = {
 			  "\xba\xd0\x34\xc9\x2d\x91\xc5\x17"
 			  "\x11",
 		.len	= 1281,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 1200, 1, 80 },
 	}, { /* test vector from https://tools.ietf.org/html/draft-arciszewski-xchacha-02#appendix-A.3.2 */
 		.key	= "\x80\x81\x82\x83\x84\x85\x86\x87"
 			  "\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f"
@@ -28259,9 +28030,6 @@ static const struct cipher_testvec xchacha12_tv_template[] = {
 			  "\xda\x4e\xc9\xab\x9b\x8a\x7b",
 
 		.len	= 375,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 375 - 20, 4, 16 },
 
 	}, {
 		.key	= "\x1c\x92\x40\xa5\xeb\x55\xd3\x8a"
@@ -28639,9 +28407,6 @@ static const struct cipher_testvec xchacha12_tv_template[] = {
 			  "\xf0\xfc\x5e\x1c\xf1\xf5\xf9\xf3"
 			  "\x5b",
 		.len	= 1281,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 1200, 1, 80 },
 	}, {
 		.key	= "\x80\x81\x82\x83\x84\x85\x86\x87"
 			  "\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f"
@@ -28749,9 +28514,6 @@ static const struct cipher_testvec adiantum_xchacha12_aes_tv_template[] = {
 		.ctext	= "\x6d\x32\x86\x18\x67\x86\x0f\x3f"
 			  "\x96\x7c\x9d\x28\x0d\x53\xec\x9f",
 		.len	= 16,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 14, 2 },
 	}, {
 		.key	= "\x36\x2b\x57\x97\xf8\x5d\xcd\x99"
 			  "\x5f\x1a\x5a\x44\x1d\x92\x0f\x27"
@@ -28814,9 +28576,6 @@ static const struct cipher_testvec adiantum_xchacha12_aes_tv_template[] = {
 			  "\x74\xa6\xaa\xa3\xac\xdc\xc2\xf5"
 			  "\x8d\xde\x34\x86\x78\x60\x75\x8d",
 		.len	= 128,
-		.also_non_np = 1,
-		.np	= 4,
-		.tap	= { 104, 16, 4, 4 },
 	}, {
 		.key	= "\xd3\x81\x72\x18\x23\xff\x6f\x4a"
 			  "\x25\x74\x29\x0d\x51\x8a\x0e\x13"
@@ -28956,9 +28715,6 @@ static const struct cipher_testvec adiantum_xchacha12_aes_tv_template[] = {
 			  "\x21\xb0\x21\x52\xba\xa7\x37\xaa"
 			  "\xcc\xbf\x95\xa8\xf4\xd0\x91\xf6",
 		.len	= 512,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 144, 368 },
 	}
 };
 
@@ -28980,9 +28736,6 @@ static const struct cipher_testvec adiantum_xchacha20_aes_tv_template[] = {
 		.ctext	= "\xf6\x78\x97\xd6\xaa\x94\x01\x27"
 			  "\x2e\x4d\x83\xe0\x6e\x64\x9a\xdf",
 		.len	= 16,
-		.also_non_np = 1,
-		.np	= 3,
-		.tap	= { 5, 2, 9 },
 	}, {
 		.key	= "\x36\x2b\x57\x97\xf8\x5d\xcd\x99"
 			  "\x5f\x1a\x5a\x44\x1d\x92\x0f\x27"
@@ -29002,9 +28755,6 @@ static const struct cipher_testvec adiantum_xchacha20_aes_tv_template[] = {
 			  "\x57\x72\xb5\xfd\xb5\x5d\xb8\x28"
 			  "\x0c\x04\x91\x14\x91\xe9\x37",
 		.len	= 31,
-		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 16, 15 },
 	}, {
 		.key	= "\xa5\x28\x24\x34\x1a\x3c\xd8\xf7"
 			  "\x05\x91\x8f\xee\x85\x1f\x35\x7f"
@@ -29048,9 +28798,6 @@ static const struct cipher_testvec adiantum_xchacha20_aes_tv_template[] = {
 			  "\x29\x62\x0d\xb2\xf6\x3c\x58\x57"
 			  "\xc1\xd5\x5a\xbb\xd6\xa6\x2a\xe5",
 		.len	= 128,
-		.also_non_np = 1,
-		.np	= 4,
-		.tap	= { 112, 7, 8, 1 },
 	}, {
 		.key	= "\xd3\x81\x72\x18\x23\xff\x6f\x4a"
 			  "\x25\x74\x29\x0d\x51\x8a\x0e\x13"
-- 
2.20.1.321.g9e740568ce-goog


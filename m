Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2499C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45E4620869
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549007554;
	bh=pA7AYwVguA+NVqusRPfisWT7BmFEXh41nQ39nQLgVlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0NsGVxkgSZp9+Xfapu1fF9Upw50R+5NE9zgf2E9+redUv3z3e74ay4Ybwg/behN1E
	 TBLW8lOglP5P6BNthoUtDiBMbgRK5Q/gq1ZhGUebjod35EFVSm7jIHclzuD5otdvZ8
	 lXdPrVbt3Z648RCU+JzBgKBZK5Syqd1B0gtX4lkk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfBAHwU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:52:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbfBAHwH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:52:07 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 243412184A;
        Fri,  1 Feb 2019 07:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549007524;
        bh=pA7AYwVguA+NVqusRPfisWT7BmFEXh41nQ39nQLgVlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8cCP+ysL6wOJUn1Ai9Y/EJ2Zc7lKSj2sT2oKv+3W5gf4/RBizkRP/MdRDzug2Ng0
         d/R7BUis/Ac0cOHzB5w/BR5ZPPWkg9h1pix6hVnE3axUACekMq27TcIAmICxk6IN9x
         EnIJnA/oUU5q8/suUzfND+ncf9yb4mypVwXzkICA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/15] crypto: testmgr - convert hash testing to use testvec_configs
Date:   Thu, 31 Jan 2019 23:51:48 -0800
Message-Id: <20190201075150.18644-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190201075150.18644-1-ebiggers@kernel.org>
References: <20190201075150.18644-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert alg_test_hash() to use the new test framework, adding a list of
testvec_configs to test by default.  When the extra self-tests are
enabled, randomly generated testvec_configs are tested as well.

This improves hash test coverage mainly because now all algorithms have
a variety of data layouts tested, whereas before each algorithm was
responsible for declaring its own chunked test cases which were often
missing or provided poor test coverage.  The new code also tests both
the MAY_SLEEP and !MAY_SLEEP cases and buffers that cross pages.

This already found bugs in the hash walk code and in the arm32 and arm64
implementations of crct10dif.

I removed the hash chunked test vectors that were the same as
non-chunked ones, but left the ones that were unique.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 795 ++++++++++++++++++++---------------------------
 crypto/testmgr.h | 107 +------
 2 files changed, 352 insertions(+), 550 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 7638090ff1b0a..96aa268ff4184 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -71,18 +71,6 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
  */
 #define XBUFSIZE	8
 
-/*
- * Indexes into the xbuf to simulate cross-page access.
- */
-#define IDX1		32
-#define IDX2		32400
-#define IDX3		1511
-#define IDX4		8193
-#define IDX5		22222
-#define IDX6		17101
-#define IDX7		27333
-#define IDX8		3000
-
 /*
 * Used by test_cipher()
 */
@@ -149,9 +137,6 @@ struct alg_test_desc {
 	} suite;
 };
 
-static const unsigned int IDX[8] = {
-	IDX1, IDX2, IDX3, IDX4, IDX5, IDX6, IDX7, IDX8 };
-
 static void hexdump(unsigned char *buf, unsigned int len)
 {
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
@@ -346,6 +331,79 @@ static const struct testvec_config default_cipher_testvec_configs[] = {
 	}
 };
 
+static const struct testvec_config default_hash_testvec_configs[] = {
+	{
+		.name = "init+update+final aligned buffer",
+		.src_divs = { { .proportion_of_total = 10000 } },
+		.finalization_type = FINALIZATION_TYPE_FINAL,
+	}, {
+		.name = "init+finup aligned buffer",
+		.src_divs = { { .proportion_of_total = 10000 } },
+		.finalization_type = FINALIZATION_TYPE_FINUP,
+	}, {
+		.name = "digest aligned buffer",
+		.src_divs = { { .proportion_of_total = 10000 } },
+		.finalization_type = FINALIZATION_TYPE_DIGEST,
+	}, {
+		.name = "init+update+final misaligned buffer",
+		.src_divs = { { .proportion_of_total = 10000, .offset = 1 } },
+		.finalization_type = FINALIZATION_TYPE_FINAL,
+	}, {
+		.name = "digest buffer aligned only to alignmask",
+		.src_divs = {
+			{
+				.proportion_of_total = 10000,
+				.offset = 1,
+				.offset_relative_to_alignmask = true,
+			},
+		},
+		.finalization_type = FINALIZATION_TYPE_DIGEST,
+	}, {
+		.name = "init+update+update+final two even splits",
+		.src_divs = {
+			{ .proportion_of_total = 5000 },
+			{
+				.proportion_of_total = 5000,
+				.flush_type = FLUSH_TYPE_FLUSH,
+			},
+		},
+		.finalization_type = FINALIZATION_TYPE_FINAL,
+	}, {
+		.name = "digest uneven misaligned splits, may sleep",
+		.req_flags = CRYPTO_TFM_REQ_MAY_SLEEP,
+		.src_divs = {
+			{ .proportion_of_total = 1900, .offset = 33 },
+			{ .proportion_of_total = 3300, .offset = 7  },
+			{ .proportion_of_total = 4800, .offset = 18 },
+		},
+		.finalization_type = FINALIZATION_TYPE_DIGEST,
+	}, {
+		.name = "digest misaligned splits crossing pages",
+		.src_divs = {
+			{
+				.proportion_of_total = 7500,
+				.offset = PAGE_SIZE - 32,
+			}, {
+				.proportion_of_total = 2500,
+				.offset = PAGE_SIZE - 7,
+			},
+		},
+		.finalization_type = FINALIZATION_TYPE_DIGEST,
+	}, {
+		.name = "import/export",
+		.src_divs = {
+			{
+				.proportion_of_total = 6500,
+				.flush_type = FLUSH_TYPE_REIMPORT,
+			}, {
+				.proportion_of_total = 3500,
+				.flush_type = FLUSH_TYPE_REIMPORT,
+			},
+		},
+		.finalization_type = FINALIZATION_TYPE_FINAL,
+	}
+};
+
 static unsigned int count_test_sg_divisions(const struct test_sg_division *divs)
 {
 	unsigned int remaining = TEST_SG_TOTAL;
@@ -782,430 +840,320 @@ static void generate_random_testvec_config(struct testvec_config *cfg,
 }
 #endif /* CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 
-static int ahash_guard_result(char *result, char c, int size)
+static int check_nonfinal_hash_op(const char *op, int err,
+				  u8 *result, unsigned int digestsize,
+				  const char *driver, unsigned int vec_num,
+				  const struct testvec_config *cfg)
 {
-	int i;
-
-	for (i = 0; i < size; i++) {
-		if (result[i] != c)
-			return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int ahash_partial_update(struct ahash_request **preq,
-	struct crypto_ahash *tfm, const struct hash_testvec *template,
-	void *hash_buff, int k, int temp, struct scatterlist *sg,
-	const char *algo, char *result, struct crypto_wait *wait)
-{
-	char *state;
-	struct ahash_request *req;
-	int statesize, ret = -EINVAL;
-	static const unsigned char guard[] = { 0x00, 0xba, 0xad, 0x00 };
-	int digestsize = crypto_ahash_digestsize(tfm);
-
-	req = *preq;
-	statesize = crypto_ahash_statesize(
-			crypto_ahash_reqtfm(req));
-	state = kmalloc(statesize + sizeof(guard), GFP_KERNEL);
-	if (!state) {
-		pr_err("alg: hash: Failed to alloc state for %s\n", algo);
-		goto out_nostate;
-	}
-	memcpy(state + statesize, guard, sizeof(guard));
-	memset(result, 1, digestsize);
-	ret = crypto_ahash_export(req, state);
-	WARN_ON(memcmp(state + statesize, guard, sizeof(guard)));
-	if (ret) {
-		pr_err("alg: hash: Failed to export() for %s\n", algo);
-		goto out;
-	}
-	ret = ahash_guard_result(result, 1, digestsize);
-	if (ret) {
-		pr_err("alg: hash: Failed, export used req->result for %s\n",
-		       algo);
-		goto out;
-	}
-	ahash_request_free(req);
-	req = ahash_request_alloc(tfm, GFP_KERNEL);
-	if (!req) {
-		pr_err("alg: hash: Failed to alloc request for %s\n", algo);
-		goto out_noreq;
-	}
-	ahash_request_set_callback(req,
-		CRYPTO_TFM_REQ_MAY_BACKLOG,
-		crypto_req_done, wait);
-
-	memcpy(hash_buff, template->plaintext + temp,
-		template->tap[k]);
-	sg_init_one(&sg[0], hash_buff, template->tap[k]);
-	ahash_request_set_crypt(req, sg, result, template->tap[k]);
-	ret = crypto_ahash_import(req, state);
-	if (ret) {
-		pr_err("alg: hash: Failed to import() for %s\n", algo);
-		goto out;
+	if (err) {
+		pr_err("alg: hash: %s %s() failed with err %d on test vector %u, cfg=\"%s\"\n",
+		       driver, op, err, vec_num, cfg->name);
+		return err;
 	}
-	ret = ahash_guard_result(result, 1, digestsize);
-	if (ret) {
-		pr_err("alg: hash: Failed, import used req->result for %s\n",
-		       algo);
-		goto out;
+	if (!testmgr_is_poison(result, digestsize)) {
+		pr_err("alg: hash: %s %s() used result buffer on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return -EINVAL;
 	}
-	ret = crypto_wait_req(crypto_ahash_update(req), wait);
-	if (ret)
-		goto out;
-	*preq = req;
-	ret = 0;
-	goto out_noreq;
-out:
-	ahash_request_free(req);
-out_noreq:
-	kfree(state);
-out_nostate:
-	return ret;
+	return 0;
 }
 
-enum hash_test {
-	HASH_TEST_DIGEST,
-	HASH_TEST_FINAL,
-	HASH_TEST_FINUP
-};
-
-static int __test_hash(struct crypto_ahash *tfm,
-		       const struct hash_testvec *template, unsigned int tcount,
-		       enum hash_test test_type, const int align_offset)
+static int test_hash_vec_cfg(const char *driver,
+			     const struct hash_testvec *vec,
+			     unsigned int vec_num,
+			     const struct testvec_config *cfg,
+			     struct ahash_request *req,
+			     struct test_sglist *tsgl,
+			     u8 *hashstate)
 {
-	const char *algo = crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
-	size_t digest_size = crypto_ahash_digestsize(tfm);
-	unsigned int i, j, k, temp;
-	struct scatterlist sg[8];
-	char *result;
-	char *key;
-	struct ahash_request *req;
-	struct crypto_wait wait;
-	void *hash_buff;
-	char *xbuf[XBUFSIZE];
-	int ret = -ENOMEM;
-
-	result = kmalloc(digest_size, GFP_KERNEL);
-	if (!result)
-		return ret;
-	key = kmalloc(MAX_KEYLEN, GFP_KERNEL);
-	if (!key)
-		goto out_nobuf;
-	if (testmgr_alloc_buf(xbuf))
-		goto out_nobuf;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	const unsigned int alignmask = crypto_ahash_alignmask(tfm);
+	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
+	const unsigned int statesize = crypto_ahash_statesize(tfm);
+	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
+	const struct test_sg_division *divs[XBUFSIZE];
+	DECLARE_CRYPTO_WAIT(wait);
+	struct kvec _input;
+	struct iov_iter input;
+	unsigned int i;
+	struct scatterlist *pending_sgl;
+	unsigned int pending_len;
+	u8 result[HASH_MAX_DIGESTSIZE + TESTMGR_POISON_LEN];
+	int err;
 
-	crypto_init_wait(&wait);
+	/* Set the key, if specified */
+	if (vec->ksize) {
+		err = crypto_ahash_setkey(tfm, vec->key, vec->ksize);
+		if (err) {
+			pr_err("alg: hash: %s setkey failed with err %d on test vector %u; flags=%#x\n",
+			       driver, err, vec_num,
+			       crypto_ahash_get_flags(tfm));
+			return err;
+		}
+	}
 
-	req = ahash_request_alloc(tfm, GFP_KERNEL);
-	if (!req) {
-		printk(KERN_ERR "alg: hash: Failed to allocate request for "
-		       "%s\n", algo);
-		goto out_noreq;
+	/* Build the scatterlist for the source data */
+	_input.iov_base = (void *)vec->plaintext;
+	_input.iov_len = vec->psize;
+	iov_iter_kvec(&input, WRITE, &_input, 1, vec->psize);
+	err = build_test_sglist(tsgl, cfg->src_divs, alignmask, vec->psize,
+				&input, divs);
+	if (err) {
+		pr_err("alg: hash: %s: error preparing scatterlist for test vector %u, cfg=\"%s\"\n",
+		       driver, vec_num, cfg->name);
+		return err;
 	}
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &wait);
 
-	j = 0;
-	for (i = 0; i < tcount; i++) {
-		if (template[i].np)
-			continue;
+	/* Do the actual hashing */
 
-		ret = -EINVAL;
-		if (WARN_ON(align_offset + template[i].psize > PAGE_SIZE))
-			goto out;
+	testmgr_poison(req->__ctx, crypto_ahash_reqsize(tfm));
+	testmgr_poison(result, digestsize + TESTMGR_POISON_LEN);
 
-		j++;
-		memset(result, 0, digest_size);
+	if (cfg->finalization_type == FINALIZATION_TYPE_DIGEST) {
+		/* Just using digest() */
+		ahash_request_set_callback(req, req_flags, crypto_req_done,
+					   &wait);
+		ahash_request_set_crypt(req, tsgl->sgl, result, vec->psize);
+		err = crypto_wait_req(crypto_ahash_digest(req), &wait);
+		if (err) {
+			pr_err("alg: hash: %s digest() failed with err %d on test vector %u, cfg=\"%s\"\n",
+			       driver, err, vec_num, cfg->name);
+			return err;
+		}
+		goto result_ready;
+	}
 
-		hash_buff = xbuf[0];
-		hash_buff += align_offset;
+	/* Using init(), zero or more update(), then final() or finup() */
 
-		memcpy(hash_buff, template[i].plaintext, template[i].psize);
-		sg_init_one(&sg[0], hash_buff, template[i].psize);
+	ahash_request_set_callback(req, req_flags, crypto_req_done, &wait);
+	ahash_request_set_crypt(req, NULL, result, 0);
+	err = crypto_wait_req(crypto_ahash_init(req), &wait);
+	err = check_nonfinal_hash_op("init", err, result, digestsize,
+				     driver, vec_num, cfg);
+	if (err)
+		return err;
 
-		if (template[i].ksize) {
-			crypto_ahash_clear_flags(tfm, ~0);
-			if (template[i].ksize > MAX_KEYLEN) {
-				pr_err("alg: hash: setkey failed on test %d for %s: key size %d > %d\n",
-				       j, algo, template[i].ksize, MAX_KEYLEN);
-				ret = -EINVAL;
-				goto out;
-			}
-			memcpy(key, template[i].key, template[i].ksize);
-			ret = crypto_ahash_setkey(tfm, key, template[i].ksize);
-			if (ret) {
-				printk(KERN_ERR "alg: hash: setkey failed on "
-				       "test %d for %s: ret=%d\n", j, algo,
-				       -ret);
-				goto out;
-			}
+	pending_sgl = NULL;
+	pending_len = 0;
+	for (i = 0; i < tsgl->nents; i++) {
+		if (divs[i]->flush_type != FLUSH_TYPE_NONE &&
+		    pending_sgl != NULL) {
+			/* update() with the pending data */
+			ahash_request_set_callback(req, req_flags,
+						   crypto_req_done, &wait);
+			ahash_request_set_crypt(req, pending_sgl, result,
+						pending_len);
+			err = crypto_wait_req(crypto_ahash_update(req), &wait);
+			err = check_nonfinal_hash_op("update", err,
+						     result, digestsize,
+						     driver, vec_num, cfg);
+			if (err)
+				return err;
+			pending_sgl = NULL;
+			pending_len = 0;
 		}
-
-		ahash_request_set_crypt(req, sg, result, template[i].psize);
-		switch (test_type) {
-		case HASH_TEST_DIGEST:
-			ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
-			if (ret) {
-				pr_err("alg: hash: digest failed on test %d "
-				       "for %s: ret=%d\n", j, algo, -ret);
-				goto out;
-			}
-			break;
-
-		case HASH_TEST_FINAL:
-			memset(result, 1, digest_size);
-			ret = crypto_wait_req(crypto_ahash_init(req), &wait);
-			if (ret) {
-				pr_err("alg: hash: init failed on test %d "
-				       "for %s: ret=%d\n", j, algo, -ret);
-				goto out;
-			}
-			ret = ahash_guard_result(result, 1, digest_size);
-			if (ret) {
-				pr_err("alg: hash: init failed on test %d "
-				       "for %s: used req->result\n", j, algo);
-				goto out;
-			}
-			ret = crypto_wait_req(crypto_ahash_update(req), &wait);
-			if (ret) {
-				pr_err("alg: hash: update failed on test %d "
-				       "for %s: ret=%d\n", j, algo, -ret);
-				goto out;
-			}
-			ret = ahash_guard_result(result, 1, digest_size);
-			if (ret) {
-				pr_err("alg: hash: update failed on test %d "
-				       "for %s: used req->result\n", j, algo);
-				goto out;
-			}
-			ret = crypto_wait_req(crypto_ahash_final(req), &wait);
-			if (ret) {
-				pr_err("alg: hash: final failed on test %d "
-				       "for %s: ret=%d\n", j, algo, -ret);
-				goto out;
+		if (divs[i]->flush_type == FLUSH_TYPE_REIMPORT) {
+			/* Test ->export() and ->import() */
+			testmgr_poison(hashstate + statesize,
+				       TESTMGR_POISON_LEN);
+			err = crypto_ahash_export(req, hashstate);
+			err = check_nonfinal_hash_op("export", err,
+						     result, digestsize,
+						     driver, vec_num, cfg);
+			if (err)
+				return err;
+			if (!testmgr_is_poison(hashstate + statesize,
+					       TESTMGR_POISON_LEN)) {
+				pr_err("alg: hash: %s export() overran state buffer on test vector %u, cfg=\"%s\"\n",
+				       driver, vec_num, cfg->name);
+				return -EOVERFLOW;
 			}
-			break;
 
-		case HASH_TEST_FINUP:
-			memset(result, 1, digest_size);
-			ret = crypto_wait_req(crypto_ahash_init(req), &wait);
-			if (ret) {
-				pr_err("alg: hash: init failed on test %d "
-				       "for %s: ret=%d\n", j, algo, -ret);
-				goto out;
-			}
-			ret = ahash_guard_result(result, 1, digest_size);
-			if (ret) {
-				pr_err("alg: hash: init failed on test %d "
-				       "for %s: used req->result\n", j, algo);
-				goto out;
-			}
-			ret = crypto_wait_req(crypto_ahash_finup(req), &wait);
-			if (ret) {
-				pr_err("alg: hash: final failed on test %d "
-				       "for %s: ret=%d\n", j, algo, -ret);
-				goto out;
-			}
-			break;
+			testmgr_poison(req->__ctx, crypto_ahash_reqsize(tfm));
+			err = crypto_ahash_import(req, hashstate);
+			err = check_nonfinal_hash_op("import", err,
+						     result, digestsize,
+						     driver, vec_num, cfg);
+			if (err)
+				return err;
 		}
+		if (pending_sgl == NULL)
+			pending_sgl = &tsgl->sgl[i];
+		pending_len += tsgl->sgl[i].length;
+	}
 
-		if (memcmp(result, template[i].digest,
-			   crypto_ahash_digestsize(tfm))) {
-			printk(KERN_ERR "alg: hash: Test %d failed for %s\n",
-			       j, algo);
-			hexdump(result, crypto_ahash_digestsize(tfm));
-			ret = -EINVAL;
-			goto out;
+	ahash_request_set_callback(req, req_flags, crypto_req_done, &wait);
+	ahash_request_set_crypt(req, pending_sgl, result, pending_len);
+	if (cfg->finalization_type == FINALIZATION_TYPE_FINAL) {
+		/* finish with update() and final() */
+		err = crypto_wait_req(crypto_ahash_update(req), &wait);
+		err = check_nonfinal_hash_op("update", err, result, digestsize,
+					     driver, vec_num, cfg);
+		if (err)
+			return err;
+		err = crypto_wait_req(crypto_ahash_final(req), &wait);
+		if (err) {
+			pr_err("alg: hash: %s final() failed with err %d on test vector %u, cfg=\"%s\"\n",
+			       driver, err, vec_num, cfg->name);
+			return err;
+		}
+	} else {
+		/* finish with finup() */
+		err = crypto_wait_req(crypto_ahash_finup(req), &wait);
+		if (err) {
+			pr_err("alg: hash: %s finup() failed with err %d on test vector %u, cfg=\"%s\"\n",
+			       driver, err, vec_num, cfg->name);
+			return err;
 		}
 	}
 
-	if (test_type)
-		goto out;
-
-	j = 0;
-	for (i = 0; i < tcount; i++) {
-		/* alignment tests are only done with continuous buffers */
-		if (align_offset != 0)
-			break;
+result_ready:
+	/* Check that the algorithm produced the correct digest */
+	if (memcmp(result, vec->digest, digestsize) != 0) {
+		pr_err("alg: hash: %s test failed (wrong result) on test vector %u, cfg=\"%s\"\n",
+		       driver, vec_num, cfg->name);
+		return -EINVAL;
+	}
+	if (!testmgr_is_poison(&result[digestsize], TESTMGR_POISON_LEN)) {
+		pr_err("alg: hash: %s overran result buffer on test vector %u, cfg=\"%s\"\n",
+		       driver, vec_num, cfg->name);
+		return -EOVERFLOW;
+	}
 
-		if (!template[i].np)
-			continue;
+	return 0;
+}
 
-		j++;
-		memset(result, 0, digest_size);
+static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
+			 unsigned int vec_num, struct ahash_request *req,
+			 struct test_sglist *tsgl, u8 *hashstate)
+{
+	unsigned int i;
+	int err;
 
-		temp = 0;
-		sg_init_table(sg, template[i].np);
-		ret = -EINVAL;
-		for (k = 0; k < template[i].np; k++) {
-			if (WARN_ON(offset_in_page(IDX[k]) +
-				    template[i].tap[k] > PAGE_SIZE))
-				goto out;
-			sg_set_buf(&sg[k],
-				   memcpy(xbuf[IDX[k] >> PAGE_SHIFT] +
-					  offset_in_page(IDX[k]),
-					  template[i].plaintext + temp,
-					  template[i].tap[k]),
-				   template[i].tap[k]);
-			temp += template[i].tap[k];
-		}
-
-		if (template[i].ksize) {
-			if (template[i].ksize > MAX_KEYLEN) {
-				pr_err("alg: hash: setkey failed on test %d for %s: key size %d > %d\n",
-				       j, algo, template[i].ksize, MAX_KEYLEN);
-				ret = -EINVAL;
-				goto out;
-			}
-			crypto_ahash_clear_flags(tfm, ~0);
-			memcpy(key, template[i].key, template[i].ksize);
-			ret = crypto_ahash_setkey(tfm, key, template[i].ksize);
-
-			if (ret) {
-				printk(KERN_ERR "alg: hash: setkey "
-				       "failed on chunking test %d "
-				       "for %s: ret=%d\n", j, algo, -ret);
-				goto out;
-			}
-		}
+	for (i = 0; i < ARRAY_SIZE(default_hash_testvec_configs); i++) {
+		err = test_hash_vec_cfg(driver, vec, vec_num,
+					&default_hash_testvec_configs[i],
+					req, tsgl, hashstate);
+		if (err)
+			return err;
+	}
 
-		ahash_request_set_crypt(req, sg, result, template[i].psize);
-		ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
-		if (ret) {
-			pr_err("alg: hash: digest failed on chunking test %d for %s: ret=%d\n",
-			       j, algo, -ret);
-			goto out;
-		}
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+	if (!noextratests) {
+		struct testvec_config cfg;
+		char cfgname[TESTVEC_CONFIG_NAMELEN];
 
-		if (memcmp(result, template[i].digest,
-			   crypto_ahash_digestsize(tfm))) {
-			printk(KERN_ERR "alg: hash: Chunking test %d "
-			       "failed for %s\n", j, algo);
-			hexdump(result, crypto_ahash_digestsize(tfm));
-			ret = -EINVAL;
-			goto out;
+		for (i = 0; i < fuzz_iterations; i++) {
+			generate_random_testvec_config(&cfg, cfgname,
+						       sizeof(cfgname));
+			err = test_hash_vec_cfg(driver, vec, vec_num, &cfg,
+						req, tsgl, hashstate);
+			if (err)
+				return err;
 		}
 	}
+#endif
+	return 0;
+}
 
-	/* partial update exercise */
-	j = 0;
-	for (i = 0; i < tcount; i++) {
-		/* alignment tests are only done with continuous buffers */
-		if (align_offset != 0)
-			break;
+static int __alg_test_hash(const struct hash_testvec *vecs,
+			   unsigned int num_vecs, const char *driver,
+			   u32 type, u32 mask)
+{
+	struct crypto_ahash *tfm;
+	struct ahash_request *req = NULL;
+	struct test_sglist *tsgl = NULL;
+	u8 *hashstate = NULL;
+	unsigned int i;
+	int err;
 
-		if (template[i].np < 2)
-			continue;
+	tfm = crypto_alloc_ahash(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		pr_err("alg: hash: failed to allocate transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
 
-		j++;
-		memset(result, 0, digest_size);
+	req = ahash_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		pr_err("alg: hash: failed to allocate request for %s\n",
+		       driver);
+		err = -ENOMEM;
+		goto out;
+	}
 
-		ret = -EINVAL;
-		hash_buff = xbuf[0];
-		memcpy(hash_buff, template[i].plaintext,
-			template[i].tap[0]);
-		sg_init_one(&sg[0], hash_buff, template[i].tap[0]);
-
-		if (template[i].ksize) {
-			crypto_ahash_clear_flags(tfm, ~0);
-			if (template[i].ksize > MAX_KEYLEN) {
-				pr_err("alg: hash: setkey failed on test %d for %s: key size %d > %d\n",
-					j, algo, template[i].ksize, MAX_KEYLEN);
-				ret = -EINVAL;
-				goto out;
-			}
-			memcpy(key, template[i].key, template[i].ksize);
-			ret = crypto_ahash_setkey(tfm, key, template[i].ksize);
-			if (ret) {
-				pr_err("alg: hash: setkey failed on test %d for %s: ret=%d\n",
-					j, algo, -ret);
-				goto out;
-			}
-		}
+	tsgl = kmalloc(sizeof(*tsgl), GFP_KERNEL);
+	if (!tsgl || init_test_sglist(tsgl) != 0) {
+		pr_err("alg: hash: failed to allocate test buffers for %s\n",
+		       driver);
+		kfree(tsgl);
+		tsgl = NULL;
+		err = -ENOMEM;
+		goto out;
+	}
 
-		ahash_request_set_crypt(req, sg, result, template[i].tap[0]);
-		ret = crypto_wait_req(crypto_ahash_init(req), &wait);
-		if (ret) {
-			pr_err("alg: hash: init failed on test %d for %s: ret=%d\n",
-				j, algo, -ret);
-			goto out;
-		}
-		ret = crypto_wait_req(crypto_ahash_update(req), &wait);
-		if (ret) {
-			pr_err("alg: hash: update failed on test %d for %s: ret=%d\n",
-				j, algo, -ret);
-			goto out;
-		}
+	hashstate = kmalloc(crypto_ahash_statesize(tfm) + TESTMGR_POISON_LEN,
+			    GFP_KERNEL);
+	if (!hashstate) {
+		pr_err("alg: hash: failed to allocate hash state buffer for %s\n",
+		       driver);
+		err = -ENOMEM;
+		goto out;
+	}
 
-		temp = template[i].tap[0];
-		for (k = 1; k < template[i].np; k++) {
-			ret = ahash_partial_update(&req, tfm, &template[i],
-				hash_buff, k, temp, &sg[0], algo, result,
-				&wait);
-			if (ret) {
-				pr_err("alg: hash: partial update failed on test %d for %s: ret=%d\n",
-					j, algo, -ret);
-				goto out_noreq;
-			}
-			temp += template[i].tap[k];
-		}
-		ret = crypto_wait_req(crypto_ahash_final(req), &wait);
-		if (ret) {
-			pr_err("alg: hash: final failed on test %d for %s: ret=%d\n",
-				j, algo, -ret);
-			goto out;
-		}
-		if (memcmp(result, template[i].digest,
-			   crypto_ahash_digestsize(tfm))) {
-			pr_err("alg: hash: Partial Test %d failed for %s\n",
-			       j, algo);
-			hexdump(result, crypto_ahash_digestsize(tfm));
-			ret = -EINVAL;
+	for (i = 0; i < num_vecs; i++) {
+		err = test_hash_vec(driver, &vecs[i], i, req, tsgl, hashstate);
+		if (err)
 			goto out;
-		}
 	}
-
-	ret = 0;
-
+	err = 0;
 out:
+	kfree(hashstate);
+	if (tsgl) {
+		destroy_test_sglist(tsgl);
+		kfree(tsgl);
+	}
 	ahash_request_free(req);
-out_noreq:
-	testmgr_free_buf(xbuf);
-out_nobuf:
-	kfree(key);
-	kfree(result);
-	return ret;
+	crypto_free_ahash(tfm);
+	return err;
 }
 
-static int test_hash(struct crypto_ahash *tfm,
-		     const struct hash_testvec *template,
-		     unsigned int tcount, enum hash_test test_type)
+static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
+			 u32 type, u32 mask)
 {
-	unsigned int alignmask;
-	int ret;
+	const struct hash_testvec *template = desc->suite.hash.vecs;
+	unsigned int tcount = desc->suite.hash.count;
+	unsigned int nr_unkeyed, nr_keyed;
+	int err;
 
-	ret = __test_hash(tfm, template, tcount, test_type, 0);
-	if (ret)
-		return ret;
+	/*
+	 * For OPTIONAL_KEY algorithms, we have to do all the unkeyed tests
+	 * first, before setting a key on the tfm.  To make this easier, we
+	 * require that the unkeyed test vectors (if any) are listed first.
+	 */
 
-	/* test unaligned buffers, check with one byte offset */
-	ret = __test_hash(tfm, template, tcount, test_type, 1);
-	if (ret)
-		return ret;
+	for (nr_unkeyed = 0; nr_unkeyed < tcount; nr_unkeyed++) {
+		if (template[nr_unkeyed].ksize)
+			break;
+	}
+	for (nr_keyed = 0; nr_unkeyed + nr_keyed < tcount; nr_keyed++) {
+		if (!template[nr_unkeyed + nr_keyed].ksize) {
+			pr_err("alg: hash: test vectors for %s out of order, "
+			       "unkeyed ones must come first\n", desc->alg);
+			return -EINVAL;
+		}
+	}
 
-	alignmask = crypto_tfm_alg_alignmask(&tfm->base);
-	if (alignmask) {
-		/* Check if alignment mask for tfm is correctly set. */
-		ret = __test_hash(tfm, template, tcount, test_type,
-				  alignmask + 1);
-		if (ret)
-			return ret;
+	err = 0;
+	if (nr_unkeyed) {
+		err = __alg_test_hash(template, nr_unkeyed, driver, type, mask);
+		template += nr_unkeyed;
 	}
 
-	return 0;
+	if (!err && nr_keyed)
+		err = __alg_test_hash(template, nr_keyed, driver, type, mask);
+
+	return err;
 }
 
 static int test_aead_vec_cfg(const char *driver, int enc,
@@ -2113,67 +2061,6 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
-static int __alg_test_hash(const struct hash_testvec *template,
-			   unsigned int tcount, const char *driver,
-			   u32 type, u32 mask)
-{
-	struct crypto_ahash *tfm;
-	int err;
-
-	tfm = crypto_alloc_ahash(driver, type, mask);
-	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: hash: Failed to load transform for %s: "
-		       "%ld\n", driver, PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
-
-	err = test_hash(tfm, template, tcount, HASH_TEST_DIGEST);
-	if (!err)
-		err = test_hash(tfm, template, tcount, HASH_TEST_FINAL);
-	if (!err)
-		err = test_hash(tfm, template, tcount, HASH_TEST_FINUP);
-	crypto_free_ahash(tfm);
-	return err;
-}
-
-static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
-			 u32 type, u32 mask)
-{
-	const struct hash_testvec *template = desc->suite.hash.vecs;
-	unsigned int tcount = desc->suite.hash.count;
-	unsigned int nr_unkeyed, nr_keyed;
-	int err;
-
-	/*
-	 * For OPTIONAL_KEY algorithms, we have to do all the unkeyed tests
-	 * first, before setting a key on the tfm.  To make this easier, we
-	 * require that the unkeyed test vectors (if any) are listed first.
-	 */
-
-	for (nr_unkeyed = 0; nr_unkeyed < tcount; nr_unkeyed++) {
-		if (template[nr_unkeyed].ksize)
-			break;
-	}
-	for (nr_keyed = 0; nr_unkeyed + nr_keyed < tcount; nr_keyed++) {
-		if (!template[nr_unkeyed + nr_keyed].ksize) {
-			pr_err("alg: hash: test vectors for %s out of order, "
-			       "unkeyed ones must come first\n", desc->alg);
-			return -EINVAL;
-		}
-	}
-
-	err = 0;
-	if (nr_unkeyed) {
-		err = __alg_test_hash(template, nr_unkeyed, driver, type, mask);
-		template += nr_unkeyed;
-	}
-
-	if (!err && nr_keyed)
-		err = __alg_test_hash(template, nr_keyed, driver, type, mask);
-
-	return err;
-}
-
 static int alg_test_crc32c(const struct alg_test_desc *desc,
 			   const char *driver, u32 type, u32 mask)
 {
@@ -3959,6 +3846,10 @@ static void alg_check_testvec_configs(void)
 	for (i = 0; i < ARRAY_SIZE(default_cipher_testvec_configs); i++)
 		WARN_ON(!valid_testvec_config(
 				&default_cipher_testvec_configs[i]));
+
+	for (i = 0; i < ARRAY_SIZE(default_hash_testvec_configs); i++)
+		WARN_ON(!valid_testvec_config(
+				&default_hash_testvec_configs[i]));
 }
 
 static void testmgr_onetime_init(void)
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index dfd8059d1306d..8f1d30b54a76e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -5,6 +5,7 @@
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) 2007 Nokia Siemens Networks
  * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
+ * Copyright (c) 2019 Google LLC
  *
  * Updated RFC4106 AES-GCM testing. Some test vectors were taken from
  * http://csrc.nist.gov/groups/ST/toolkit/BCM/documents/proposedmodes/
@@ -24,19 +25,20 @@
 #ifndef _CRYPTO_TESTMGR_H
 #define _CRYPTO_TESTMGR_H
 
-#define MAX_DIGEST_SIZE		64
-#define MAX_TAP			8
-
-#define MAX_KEYLEN		1088
 #define MAX_IVLEN		32
 
+/*
+ * hash_testvec:	structure to describe a hash (message digest) test
+ * @key:	Pointer to key (NULL if none)
+ * @plaintext:	Pointer to source data
+ * @digest:	Pointer to expected digest
+ * @psize:	Length of source data in bytes
+ * @ksize:	Length of @key in bytes (0 if no key)
+ */
 struct hash_testvec {
-	/* only used with keyed hash algorithms */
 	const char *key;
 	const char *plaintext;
 	const char *digest;
-	unsigned short tap[MAX_TAP];
-	unsigned short np;
 	unsigned short psize;
 	unsigned short ksize;
 };
@@ -1022,8 +1024,6 @@ static const struct hash_testvec md4_tv_template[] = {
 		.psize	= 26,
 		.digest	= "\xd7\x9e\x1c\x30\x8a\xa5\xbb\xcd"
 			  "\xee\xa8\xed\x63\xdf\x41\x2d\xa9",
-		.np	= 2,
-		.tap	= { 13, 13 },
 	}, {
 		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
 		.psize	= 62,
@@ -1060,8 +1060,6 @@ static const struct hash_testvec sha3_224_tv_template[] = {
 				"\xc9\xfd\x55\x74\x49\x44\x79\xba"
 				"\x5c\x7e\x7a\xb7\x6e\xf2\x64\xea"
 				"\xd0\xfc\xce\x33",
-		.np	= 2,
-		.tap	= { 28, 28 },
 	}, {
 		.plaintext = "\x08\x9f\x13\xaa\x41\xd8\x4c\xe3"
 			     "\x7a\x11\x85\x1c\xb3\x27\xbe\x55"
@@ -1221,8 +1219,6 @@ static const struct hash_testvec sha3_256_tv_template[] = {
 				"\x49\x10\x03\x76\xa8\x23\x5e\x2c"
 				"\x82\xe1\xb9\x99\x8a\x99\x9e\x21"
 				"\xdb\x32\xdd\x97\x49\x6d\x33\x76",
-		.np	= 2,
-		.tap	= { 28, 28 },
 	}, {
 		.plaintext = "\x08\x9f\x13\xaa\x41\xd8\x4c\xe3"
 			     "\x7a\x11\x85\x1c\xb3\x27\xbe\x55"
@@ -1389,8 +1385,6 @@ static const struct hash_testvec sha3_384_tv_template[] = {
 				"\x9b\xfd\xbc\x32\xb9\xd4\xad\x5a"
 				"\xa0\x4a\x1f\x07\x6e\x62\xfe\xa1"
 				"\x9e\xef\x51\xac\xd0\x65\x7c\x22",
-		.np	= 2,
-		.tap	= { 28, 28 },
 	}, {
 		.plaintext = "\x08\x9f\x13\xaa\x41\xd8\x4c\xe3"
 			     "\x7a\x11\x85\x1c\xb3\x27\xbe\x55"
@@ -1565,8 +1559,6 @@ static const struct hash_testvec sha3_512_tv_template[] = {
 				"\xba\x1b\x0d\x8d\xc7\x8c\x08\x63"
 				"\x46\xb5\x33\xb4\x9c\x03\x0d\x99"
 				"\xa2\x7d\xaf\x11\x39\xd6\xe7\x5e",
-		.np	= 2,
-		.tap	= { 28, 28 },
 	}, {
 		.plaintext = "\x08\x9f\x13\xaa\x41\xd8\x4c\xe3"
 			     "\x7a\x11\x85\x1c\xb3\x27\xbe\x55"
@@ -1736,8 +1728,6 @@ static const struct hash_testvec md5_tv_template[] = {
 		.psize	= 26,
 		.digest	= "\xc3\xfc\xd3\xd7\x61\x92\xe4\x00"
 			  "\x7d\xfb\x49\x6c\xca\x67\xe1\x3b",
-		.np	= 2,
-		.tap	= {13, 13}
 	}, {
 		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
 		.psize	= 62,
@@ -1798,8 +1788,6 @@ static const struct hash_testvec rmd128_tv_template[] = {
 		.psize	= 56,
 		.digest	= "\xa1\xaa\x06\x89\xd0\xfa\xfa\x2d"
 			  "\xdc\x22\xe8\x8b\x49\x13\x3a\x06",
-		.np	= 2,
-		.tap	= { 28, 28 },
 	}, {
 		.plaintext = "abcdefghbcdefghicdefghijdefghijkefghijklfghi"
 			     "jklmghijklmnhijklmnoijklmnopjklmnopqklmnopqr"
@@ -1860,8 +1848,6 @@ static const struct hash_testvec rmd160_tv_template[] = {
 		.psize	= 56,
 		.digest	= "\x12\xa0\x53\x38\x4a\x9c\x0c\x88\xe4\x05"
 			  "\xa0\x6c\x27\xdc\xf4\x9a\xda\x62\xeb\x2b",
-		.np	= 2,
-		.tap	= { 28, 28 },
 	}, {
 		.plaintext = "abcdefghbcdefghicdefghijdefghijkefghijklfghi"
 			     "jklmghijklmnhijklmnoijklmnopjklmnopqklmnopqr"
@@ -1938,8 +1924,6 @@ static const struct hash_testvec rmd256_tv_template[] = {
 			  "\xc8\xd9\x12\x85\x73\xe7\xa9\x80"
 			  "\x9a\xfb\x2a\x0f\x34\xcc\xc3\x6e"
 			  "\xa9\xe7\x2f\x16\xf6\x36\x8e\x3f",
-		.np	= 2,
-		.tap	= { 28, 28 },
 	}
 };
 
@@ -2004,8 +1988,6 @@ static const struct hash_testvec rmd320_tv_template[] = {
 			  "\xb8\x4d\xf7\x69\xa5\xde\x20\x60\xe2\x59"
 			  "\xdf\x4c\x9b\xb4\xa4\x26\x8c\x0e\x93\x5b"
 			  "\xbc\x74\x70\xa9\x69\xc9\xd0\x72\xa1\xac",
-		.np	= 2,
-		.tap	= { 28, 28 },
 	}
 };
 
@@ -2019,26 +2001,11 @@ static const struct hash_testvec crct10dif_tv_template[] = {
 				  "123456789012345678901234567890123456789",
 		.psize		= 79,
 		.digest 	= (u8 *)(u16 []){ 0x4b70 },
-		.np		= 2,
-		.tap		= { 63, 16 },
 	}, {
 		.plaintext	= "abcdddddddddddddddddddddddddddddddddddddddd"
 				  "ddddddddddddd",
 		.psize		= 56,
 		.digest		= (u8 *)(u16 []){ 0x9ce3 },
-		.np		= 8,
-		.tap		= { 1, 2, 28, 7, 6, 5, 4, 3 },
-	}, {
-		.plaintext 	= "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "1234567890123456789012345678901234567890"
-				  "123456789012345678901234567890123456789",
-		.psize		= 319,
-		.digest		= (u8 *)(u16 []){ 0x44c6 },
 	}, {
 		.plaintext 	= "1234567890123456789012345678901234567890"
 				  "1234567890123456789012345678901234567890"
@@ -2050,8 +2017,6 @@ static const struct hash_testvec crct10dif_tv_template[] = {
 				  "123456789012345678901234567890123456789",
 		.psize		= 319,
 		.digest		= (u8 *)(u16 []){ 0x44c6 },
-		.np		= 4,
-		.tap		= { 1, 255, 57, 6 },
 	}, {
 		.plaintext =	"\x6e\x05\x79\x10\xa7\x1b\xb2\x49"
 				"\xe0\x54\xeb\x82\x19\x8d\x24\xbb"
@@ -2517,8 +2482,6 @@ static const struct hash_testvec sha1_tv_template[] = {
 		.psize	= 56,
 		.digest	= "\x84\x98\x3e\x44\x1c\x3b\xd2\x6e\xba\xae"
 			  "\x4a\xa1\xf9\x51\x29\xe5\xe5\x46\x70\xf1",
-		.np	= 2,
-		.tap	= { 28, 28 }
 	}, {
 		.plaintext = "\xec\x29\x56\x12\x44\xed\xe7\x06"
 			     "\xb6\xeb\x30\xa1\xc3\x71\xd7\x44"
@@ -2544,8 +2507,6 @@ static const struct hash_testvec sha1_tv_template[] = {
 		.psize	= 163,
 		.digest	= "\x97\x01\x11\xc4\xe7\x7b\xcc\x88\xcc\x20"
 			  "\x45\x9c\x02\xb6\x9b\x4a\xa8\xf5\x82\x17",
-		.np	= 4,
-		.tap	= { 63, 64, 31, 5 }
 	}, {
 		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-",
 		.psize	= 64,
@@ -2714,8 +2675,6 @@ static const struct hash_testvec sha224_tv_template[] = {
 			  "\x5D\xBA\x5D\xA1\xFD\x89\x01\x50"
 			  "\xB0\xC6\x45\x5C\xB4\xF5\x8B\x19"
 			  "\x52\x52\x25\x25",
-		.np     = 2,
-		.tap    = { 28, 28 }
 	}, {
 		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-",
 		.psize	= 64,
@@ -2885,8 +2844,6 @@ static const struct hash_testvec sha256_tv_template[] = {
 			  "\xe5\xc0\x26\x93\x0c\x3e\x60\x39"
 			  "\xa3\x3c\xe4\x59\x64\xff\x21\x67"
 			  "\xf6\xec\xed\xd4\x19\xdb\x06\xc1",
-		.np	= 2,
-		.tap	= { 28, 28 }
 	}, {
 		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-",
 		.psize	= 64,
@@ -3082,8 +3039,6 @@ static const struct hash_testvec sha384_tv_template[] = {
 			  "\x4d\x8f\xd0\x14\xe5\x82\x82\x3a"
 			  "\x89\xe1\x6f\x9b\x2a\x7b\xbc\x1a"
 			  "\xc9\x38\xe2\xd1\x99\xe8\xbe\xa4",
-		.np	= 4,
-		.tap	= { 26, 26, 26, 26 }
 	}, {
 		.plaintext = "\x08\x9f\x13\xaa\x41\xd8\x4c\xe3"
 			     "\x7a\x11\x85\x1c\xb3\x27\xbe\x55"
@@ -3284,8 +3239,6 @@ static const struct hash_testvec sha512_tv_template[] = {
 			  "\xb2\x78\xe6\x6d\xff\x8b\x84\xfe"
 			  "\x2b\x28\x70\xf7\x42\xa5\x80\xd8"
 			  "\xed\xb4\x19\x87\x23\x28\x50\xc9",
-		.np	= 4,
-		.tap	= { 26, 26, 26, 26 }
 	}, {
 		.plaintext = "\x08\x9f\x13\xaa\x41\xd8\x4c\xe3"
 			     "\x7a\x11\x85\x1c\xb3\x27\xbe\x55"
@@ -3818,8 +3771,6 @@ static const struct hash_testvec ghash_tv_template[] =
 		.psize	= 28,
 		.digest	= "\x3e\x1f\x5c\x4d\x65\xf0\xef\xce"
 			  "\x0d\x61\x06\x27\x66\x51\xd5\xe2",
-		.np	= 2,
-		.tap	= {14, 14}
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
@@ -3930,8 +3881,6 @@ static const struct hash_testvec hmac_md5_tv_template[] =
 		.psize	= 28,
 		.digest	= "\x75\x0c\x78\x3e\x6a\xb0\xb5\x03"
 			  "\xea\xa8\x6e\x31\x0a\x5d\xb7\x38",
-		.np	= 2,
-		.tap	= {14, 14}
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
 		.ksize	= 16,
@@ -4009,8 +3958,6 @@ static const struct hash_testvec hmac_rmd128_tv_template[] = {
 		.psize	= 28,
 		.digest	= "\x87\x5f\x82\x88\x62\xb6\xb3\x34"
 			  "\xb4\x27\xc5\x5f\x9f\x7f\xf0\x9b",
-		.np	= 2,
-		.tap	= { 14, 14 },
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
 		.ksize	= 16,
@@ -4088,8 +4035,6 @@ static const struct hash_testvec hmac_rmd160_tv_template[] = {
 		.psize	= 28,
 		.digest	= "\xdd\xa6\xc0\x21\x3a\x48\x5a\x9e\x24\xf4"
 			  "\x74\x20\x64\xa7\xf0\x33\xb4\x3c\x40\x69",
-		.np	= 2,
-		.tap	= { 14, 14 },
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
 		.ksize	= 20,
@@ -4168,8 +4113,6 @@ static const struct hash_testvec hmac_sha1_tv_template[] = {
 		.psize	= 28,
 		.digest	= "\xef\xfc\xdf\x6a\xe5\xeb\x2f\xa2\xd2\x74"
 			  "\x16\xd5\xf1\x84\xdf\x9c\x25\x9a\x7c\x79",
-		.np	= 2,
-		.tap	= { 14, 14 }
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
 		.ksize	= 20,
@@ -4259,8 +4202,6 @@ static const struct hash_testvec hmac_sha224_tv_template[] = {
 			"\x45\x69\x0f\x3a\x7e\x9e\x6d\x0f"
 			"\x8b\xbe\xa2\xa3\x9e\x61\x48\x00"
 			"\x8f\xd0\x5e\x44",
-		.np = 4,
-		.tap    = { 7, 7, 7, 7 }
 	}, {
 		.key    = "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -4404,8 +4345,6 @@ static const struct hash_testvec hmac_sha256_tv_template[] = {
 			  "\x6a\x04\x24\x26\x08\x95\x75\xc7"
 			  "\x5a\x00\x3f\x08\x9d\x27\x39\x83"
 			  "\x9d\xec\x58\xb9\x64\xec\x38\x43",
-		.np	= 2,
-		.tap	= { 14, 14 }
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -4578,8 +4517,6 @@ static const struct hash_testvec aes_cbcmac_tv_template[] = {
 				  "\xf8\xf2\x76\x03\xac\x39\xb0\x9d",
 		.psize		= 33,
 		.ksize		= 16,
-		.np		= 2,
-		.tap		= { 7, 26 },
 	}, {
 		.key		= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
 				  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
@@ -4696,9 +4633,7 @@ static const struct hash_testvec aes_xcbc128_tv_template[] = {
 			     "\x10\x11\x12\x13",
 		.digest = "\x47\xf5\x1b\x45\x64\x96\x62\x15"
 			  "\xb8\x98\x5c\x63\x05\x5e\xd3\x08",
-		.tap	= { 10, 10 },
 		.psize	= 20,
-		.np	= 2,
 		.ksize	= 16,
 	}, {
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
@@ -4721,9 +4656,7 @@ static const struct hash_testvec aes_xcbc128_tv_template[] = {
 			     "\x20\x21",
 		.digest = "\xbe\xcb\xb3\xbc\xcd\xb5\x18\xa3"
 			  "\x06\x77\xd5\x48\x1f\xb6\xb4\xd8",
-		.tap	= { 17, 17 },
 		.psize	= 34,
-		.np	= 2,
 		.ksize	= 16,
 	}
 };
@@ -4806,8 +4739,6 @@ static const struct hash_testvec vmac64_aes_tv_template[] = {
 			  "abcabcabcabcabcabcabcabcabcabcabcabcabcabcabc",
 		.psize	= 316,
 		.digest	= "\x44\x92\xdf\x6c\x5c\xac\x1b\xbe",
-		.tap	= { 1, 100, 200, 15 },
-		.np	= 4,
 	}, {
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -4912,8 +4843,6 @@ static const struct hash_testvec hmac_sha384_tv_template[] = {
 			  "\xe4\x2e\xc3\x73\x63\x22\x44\x5e"
 			  "\x8e\x22\x40\xca\x5e\x69\xe2\xc7"
 			  "\x8b\x32\x39\xec\xfa\xb2\x16\x49",
-		.np	= 4,
-		.tap	= { 7, 7, 7, 7 }
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -5014,8 +4943,6 @@ static const struct hash_testvec hmac_sha512_tv_template[] = {
 			  "\x6d\x03\x4f\x65\xf8\xf0\xe6\xfd"
 			  "\xca\xea\xb1\xa3\x4d\x4a\x6b\x4b"
 			  "\x63\x6e\x07\x0a\x38\xbc\xe7\x37",
-		.np	= 4,
-		.tap	= { 7, 7, 7, 7 }
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -5111,8 +5038,6 @@ static const struct hash_testvec hmac_sha3_224_tv_template[] = {
 			  "\x1b\x79\x86\x34\xad\x38\x68\x11"
 			  "\xc2\xcf\xc8\x5b\xfa\xf5\xd5\x2b"
 			  "\xba\xce\x5e\x66",
-		.np	= 4,
-		.tap	= { 7, 7, 7, 7 }
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -5200,8 +5125,6 @@ static const struct hash_testvec hmac_sha3_256_tv_template[] = {
 			  "\x35\x96\xbb\xb0\xda\x73\xb8\x87"
 			  "\xc9\x17\x1f\x93\x09\x5b\x29\x4a"
 			  "\xe8\x57\xfb\xe2\x64\x5e\x1b\xa5",
-		.np	= 4,
-		.tap	= { 7, 7, 7, 7 }
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -5293,8 +5216,6 @@ static const struct hash_testvec hmac_sha3_384_tv_template[] = {
 			  "\x3c\xa1\x35\x08\xa9\x32\x43\xce"
 			  "\x48\xc0\x45\xdc\x00\x7f\x26\xa2"
 			  "\x1b\x3f\x5e\x0e\x9d\xf4\xc2\x0a",
-		.np	= 4,
-		.tap	= { 7, 7, 7, 7 }
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -5394,8 +5315,6 @@ static const struct hash_testvec hmac_sha3_512_tv_template[] = {
 			  "\xee\x7a\x0c\x31\xd0\x22\xa9\x5e"
 			  "\x1f\xc9\x2b\xa9\xd7\x7d\xf8\x83"
 			  "\x96\x02\x75\xbe\xb4\xe6\x20\x24",
-		.np	= 4,
-		.tap	= { 7, 7, 7, 7 }
 	}, {
 		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
 			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
@@ -6003,8 +5922,6 @@ static const struct hash_testvec nhpoly1305_tv_template[] = {
 		.psize	= 16,
 		.digest	= "\x04\xbf\x7f\x6a\xce\x72\xea\x6a"
 			  "\x79\xdb\xb0\xc9\x60\xf6\x12\xcc",
-		.np	= 6,
-		.tap	= { 4, 4, 1, 1, 1, 5 },
 	}, {
 		.key	= "\x65\x4d\xe3\xf8\xd2\x4c\xac\x28"
 			  "\x68\xf5\xb3\x81\x71\x4b\xa1\xfa"
@@ -6274,8 +6191,6 @@ static const struct hash_testvec nhpoly1305_tv_template[] = {
 		.psize	= 1024,
 		.digest	= "\x64\x3a\xbc\xc3\x3f\x74\x40\x51"
 			  "\x6e\x56\x01\x1a\x51\xec\x36\xde",
-		.np	= 8,
-		.tap	= { 64, 203, 267, 28, 263, 62, 54, 83 },
 	}, {
 		.key	= "\x1b\x82\x2e\x1b\x17\x23\xb9\x6d"
 			  "\xdc\x9c\xda\x99\x07\xe3\x5f\xd8"
@@ -29461,8 +29376,6 @@ static const struct hash_testvec crc32_tv_template[] = {
 			     "\xe9\xea\xeb\xec\xed\xee\xef\xf0",
 		.psize = 240,
 		.digest = "\x6c\xc6\x56\xde",
-		.np = 2,
-		.tap = { 31, 209 }
 	}, {
 		.key = "\xff\xff\xff\xff",
 		.ksize = 4,
@@ -29902,8 +29815,6 @@ static const struct hash_testvec crc32c_tv_template[] = {
 			     "\xe9\xea\xeb\xec\xed\xee\xef\xf0",
 		.psize = 240,
 		.digest = "\x75\xd3\xc5\x24",
-		.np = 2,
-		.tap = { 31, 209 }
 	}, {
 		.key = "\xff\xff\xff\xff",
 		.ksize = 4,
-- 
2.20.1


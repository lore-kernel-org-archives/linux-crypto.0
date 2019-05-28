Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA7CC04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 16:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 057F4216FD
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 16:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559061768;
	bh=d3sSOQssV1+byTB0SutKnUGY/PfXtukGT7k65yn474g=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=baiREg+SalLRGg44malylqlktPbV0hqkJsnffWRMnllnDGSyAzaI747mIL4JqRXuw
	 gC6gE48IriC5UGbbzUb2KjE8sGQ6ZqJZ12PNQzIOVquSkDkEl7pfzdmyXcvO1DklGq
	 v5VnUpfQKtJk7Hh4ZjxROhvVL+ytkHns71rJMiRI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfE1Qmr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 12:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfE1Qmr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 12:42:47 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3631A2166E;
        Tue, 28 May 2019 16:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559061765;
        bh=d3sSOQssV1+byTB0SutKnUGY/PfXtukGT7k65yn474g=;
        h=From:To:Cc:Subject:Date:From;
        b=EyaO1fhAbci7D0BvLSNfvAKnzdbJNc1MuDUjF6EQMQaDJUSbRy4nM2eINqfHHwIVb
         adveSMja0VUnSiZ0dtLVwB6BFN9vy/gP3uXZDyuij1f2jnhSOgbDnJVli9DNWo5Ug0
         bRSM2y3gUT8UjBXtliHZP57X42cINNH6lpPcHsEk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Elena Petrova <lenaptr@google.com>
Subject: [PATCH] crypto: testmgr - test the shash API
Date:   Tue, 28 May 2019 09:40:55 -0700
Message-Id: <20190528164055.21404-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

For hash algorithms implemented using the "shash" algorithm type, test
both the ahash and shash APIs, not just the ahash API.

Testing the ahash API already tests the shash API indirectly, which is
normally good enough.  However, there have been corner cases where there
have been shash bugs that don't get exposed through the ahash API.  So,
update testmgr to test the shash API too.

This would have detected the arm64 SHA-1 and SHA-2 bugs for which fixes
were just sent out (https://patchwork.kernel.org/patch/10964843/ and
https://patchwork.kernel.org/patch/10965089/):

    alg: shash: sha1-ce test failed (wrong result) on test vector 0, cfg="init+finup aligned buffer"
    alg: shash: sha224-ce test failed (wrong result) on test vector 0, cfg="init+finup aligned buffer"
    alg: shash: sha256-ce test failed (wrong result) on test vector 0, cfg="init+finup aligned buffer"

This also would have detected the bugs fixed by commit 307508d10729
("crypto: crct10dif-generic - fix use via crypto_shash_digest()") and
commit dec3d0b1071a
("crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()").

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 402 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 335 insertions(+), 67 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c9e67c2bd7257..a347be1423239 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1037,6 +1037,205 @@ static void crypto_reenable_simd_for_test(void)
 }
 #endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 
+static int build_hash_sglist(struct test_sglist *tsgl,
+			     const struct hash_testvec *vec,
+			     const struct testvec_config *cfg,
+			     unsigned int alignmask,
+			     const struct test_sg_division *divs[XBUFSIZE])
+{
+	struct kvec kv;
+	struct iov_iter input;
+
+	kv.iov_base = (void *)vec->plaintext;
+	kv.iov_len = vec->psize;
+	iov_iter_kvec(&input, WRITE, &kv, 1, vec->psize);
+	return build_test_sglist(tsgl, cfg->src_divs, alignmask, vec->psize,
+				 &input, divs);
+}
+
+static int check_hash_result(const char *type,
+			     const u8 *result, unsigned int digestsize,
+			     const struct hash_testvec *vec,
+			     const char *vec_name,
+			     const char *driver,
+			     const struct testvec_config *cfg)
+{
+	if (memcmp(result, vec->digest, digestsize) != 0) {
+		pr_err("alg: %s: %s test failed (wrong result) on test vector %s, cfg=\"%s\"\n",
+		       type, driver, vec_name, cfg->name);
+		return -EINVAL;
+	}
+	if (!testmgr_is_poison(&result[digestsize], TESTMGR_POISON_LEN)) {
+		pr_err("alg: %s: %s overran result buffer on test vector %s, cfg=\"%s\"\n",
+		       type, driver, vec_name, cfg->name);
+		return -EOVERFLOW;
+	}
+	return 0;
+}
+
+static inline int check_shash_op(const char *op, int err,
+				 const char *driver, const char *vec_name,
+				 const struct testvec_config *cfg)
+{
+	if (err)
+		pr_err("alg: shash: %s %s() failed with err %d on test vector %s, cfg=\"%s\"\n",
+		       driver, op, err, vec_name, cfg->name);
+	return err;
+}
+
+static inline const void *sg_data(struct scatterlist *sg)
+{
+	return page_address(sg_page(sg)) + sg->offset;
+}
+
+/* Test one hash test vector in one configuration, using the shash API */
+static int test_shash_vec_cfg(const char *driver,
+			      const struct hash_testvec *vec,
+			      const char *vec_name,
+			      const struct testvec_config *cfg,
+			      struct shash_desc *desc,
+			      struct test_sglist *tsgl,
+			      u8 *hashstate)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	const unsigned int alignmask = crypto_shash_alignmask(tfm);
+	const unsigned int digestsize = crypto_shash_digestsize(tfm);
+	const unsigned int statesize = crypto_shash_statesize(tfm);
+	const struct test_sg_division *divs[XBUFSIZE];
+	unsigned int i;
+	u8 result[HASH_MAX_DIGESTSIZE + TESTMGR_POISON_LEN];
+	int err;
+
+	/* Set the key, if specified */
+	if (vec->ksize) {
+		err = crypto_shash_setkey(tfm, vec->key, vec->ksize);
+		if (err) {
+			if (err == vec->setkey_error)
+				return 0;
+			pr_err("alg: shash: %s setkey failed on test vector %s; expected_error=%d, actual_error=%d, flags=%#x\n",
+			       driver, vec_name, vec->setkey_error, err,
+			       crypto_shash_get_flags(tfm));
+			return err;
+		}
+		if (vec->setkey_error) {
+			pr_err("alg: shash: %s setkey unexpectedly succeeded on test vector %s; expected_error=%d\n",
+			       driver, vec_name, vec->setkey_error);
+			return -EINVAL;
+		}
+	}
+
+	/* Build the scatterlist for the source data */
+	err = build_hash_sglist(tsgl, vec, cfg, alignmask, divs);
+	if (err) {
+		pr_err("alg: shash: %s: error preparing scatterlist for test vector %s, cfg=\"%s\"\n",
+		       driver, vec_name, cfg->name);
+		return err;
+	}
+
+	/* Do the actual hashing */
+
+	testmgr_poison(desc->__ctx, crypto_shash_descsize(tfm));
+	testmgr_poison(result, digestsize + TESTMGR_POISON_LEN);
+
+	if (cfg->finalization_type == FINALIZATION_TYPE_DIGEST ||
+	    vec->digest_error) {
+		/* Just using digest() */
+		if (tsgl->nents != 1)
+			return 0;
+		if (cfg->nosimd)
+			crypto_disable_simd_for_test();
+		err = crypto_shash_digest(desc, sg_data(&tsgl->sgl[0]),
+					  tsgl->sgl[0].length, result);
+		if (cfg->nosimd)
+			crypto_reenable_simd_for_test();
+		if (err) {
+			if (err == vec->digest_error)
+				return 0;
+			pr_err("alg: shash: %s digest() failed on test vector %s; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
+			       driver, vec_name, vec->digest_error, err,
+			       cfg->name);
+			return err;
+		}
+		if (vec->digest_error) {
+			pr_err("alg: shash: %s digest() unexpectedly succeeded on test vector %s; expected_error=%d, cfg=\"%s\"\n",
+			       driver, vec_name, vec->digest_error, cfg->name);
+			return -EINVAL;
+		}
+		goto result_ready;
+	}
+
+	/* Using init(), zero or more update(), then final() or finup() */
+
+	if (cfg->nosimd)
+		crypto_disable_simd_for_test();
+	err = crypto_shash_init(desc);
+	if (cfg->nosimd)
+		crypto_reenable_simd_for_test();
+	err = check_shash_op("init", err, driver, vec_name, cfg);
+	if (err)
+		return err;
+
+	for (i = 0; i < tsgl->nents; i++) {
+		if (i + 1 == tsgl->nents &&
+		    cfg->finalization_type == FINALIZATION_TYPE_FINUP) {
+			if (divs[i]->nosimd)
+				crypto_disable_simd_for_test();
+			err = crypto_shash_finup(desc, sg_data(&tsgl->sgl[i]),
+						 tsgl->sgl[i].length, result);
+			if (divs[i]->nosimd)
+				crypto_reenable_simd_for_test();
+			err = check_shash_op("finup", err, driver, vec_name,
+					     cfg);
+			if (err)
+				return err;
+			goto result_ready;
+		}
+		if (divs[i]->nosimd)
+			crypto_disable_simd_for_test();
+		err = crypto_shash_update(desc, sg_data(&tsgl->sgl[i]),
+					  tsgl->sgl[i].length);
+		if (divs[i]->nosimd)
+			crypto_reenable_simd_for_test();
+		err = check_shash_op("update", err, driver, vec_name, cfg);
+		if (err)
+			return err;
+		if (divs[i]->flush_type == FLUSH_TYPE_REIMPORT) {
+			/* Test ->export() and ->import() */
+			testmgr_poison(hashstate + statesize,
+				       TESTMGR_POISON_LEN);
+			err = crypto_shash_export(desc, hashstate);
+			err = check_shash_op("export", err, driver, vec_name,
+					     cfg);
+			if (err)
+				return err;
+			if (!testmgr_is_poison(hashstate + statesize,
+					       TESTMGR_POISON_LEN)) {
+				pr_err("alg: shash: %s export() overran state buffer on test vector %s, cfg=\"%s\"\n",
+				       driver, vec_name, cfg->name);
+				return -EOVERFLOW;
+			}
+			testmgr_poison(desc->__ctx, crypto_shash_descsize(tfm));
+			err = crypto_shash_import(desc, hashstate);
+			err = check_shash_op("import", err, driver, vec_name,
+					     cfg);
+			if (err)
+				return err;
+		}
+	}
+
+	if (cfg->nosimd)
+		crypto_disable_simd_for_test();
+	err = crypto_shash_final(desc, result);
+	if (cfg->nosimd)
+		crypto_reenable_simd_for_test();
+	err = check_shash_op("final", err, driver, vec_name, cfg);
+	if (err)
+		return err;
+result_ready:
+	return check_hash_result("shash", result, digestsize, vec, vec_name,
+				 driver, cfg);
+}
+
 static int do_ahash_op(int (*op)(struct ahash_request *req),
 		       struct ahash_request *req,
 		       struct crypto_wait *wait, bool nosimd)
@@ -1054,31 +1253,32 @@ static int do_ahash_op(int (*op)(struct ahash_request *req),
 	return crypto_wait_req(err, wait);
 }
 
-static int check_nonfinal_hash_op(const char *op, int err,
-				  u8 *result, unsigned int digestsize,
-				  const char *driver, const char *vec_name,
-				  const struct testvec_config *cfg)
+static int check_nonfinal_ahash_op(const char *op, int err,
+				   u8 *result, unsigned int digestsize,
+				   const char *driver, const char *vec_name,
+				   const struct testvec_config *cfg)
 {
 	if (err) {
-		pr_err("alg: hash: %s %s() failed with err %d on test vector %s, cfg=\"%s\"\n",
+		pr_err("alg: ahash: %s %s() failed with err %d on test vector %s, cfg=\"%s\"\n",
 		       driver, op, err, vec_name, cfg->name);
 		return err;
 	}
 	if (!testmgr_is_poison(result, digestsize)) {
-		pr_err("alg: hash: %s %s() used result buffer on test vector %s, cfg=\"%s\"\n",
+		pr_err("alg: ahash: %s %s() used result buffer on test vector %s, cfg=\"%s\"\n",
 		       driver, op, vec_name, cfg->name);
 		return -EINVAL;
 	}
 	return 0;
 }
 
-static int test_hash_vec_cfg(const char *driver,
-			     const struct hash_testvec *vec,
-			     const char *vec_name,
-			     const struct testvec_config *cfg,
-			     struct ahash_request *req,
-			     struct test_sglist *tsgl,
-			     u8 *hashstate)
+/* Test one hash test vector in one configuration, using the ahash API */
+static int test_ahash_vec_cfg(const char *driver,
+			      const struct hash_testvec *vec,
+			      const char *vec_name,
+			      const struct testvec_config *cfg,
+			      struct ahash_request *req,
+			      struct test_sglist *tsgl,
+			      u8 *hashstate)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	const unsigned int alignmask = crypto_ahash_alignmask(tfm);
@@ -1087,8 +1287,6 @@ static int test_hash_vec_cfg(const char *driver,
 	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
 	const struct test_sg_division *divs[XBUFSIZE];
 	DECLARE_CRYPTO_WAIT(wait);
-	struct kvec _input;
-	struct iov_iter input;
 	unsigned int i;
 	struct scatterlist *pending_sgl;
 	unsigned int pending_len;
@@ -1101,26 +1299,22 @@ static int test_hash_vec_cfg(const char *driver,
 		if (err) {
 			if (err == vec->setkey_error)
 				return 0;
-			pr_err("alg: hash: %s setkey failed on test vector %s; expected_error=%d, actual_error=%d, flags=%#x\n",
+			pr_err("alg: ahash: %s setkey failed on test vector %s; expected_error=%d, actual_error=%d, flags=%#x\n",
 			       driver, vec_name, vec->setkey_error, err,
 			       crypto_ahash_get_flags(tfm));
 			return err;
 		}
 		if (vec->setkey_error) {
-			pr_err("alg: hash: %s setkey unexpectedly succeeded on test vector %s; expected_error=%d\n",
+			pr_err("alg: ahash: %s setkey unexpectedly succeeded on test vector %s; expected_error=%d\n",
 			       driver, vec_name, vec->setkey_error);
 			return -EINVAL;
 		}
 	}
 
 	/* Build the scatterlist for the source data */
-	_input.iov_base = (void *)vec->plaintext;
-	_input.iov_len = vec->psize;
-	iov_iter_kvec(&input, WRITE, &_input, 1, vec->psize);
-	err = build_test_sglist(tsgl, cfg->src_divs, alignmask, vec->psize,
-				&input, divs);
+	err = build_hash_sglist(tsgl, vec, cfg, alignmask, divs);
 	if (err) {
-		pr_err("alg: hash: %s: error preparing scatterlist for test vector %s, cfg=\"%s\"\n",
+		pr_err("alg: ahash: %s: error preparing scatterlist for test vector %s, cfg=\"%s\"\n",
 		       driver, vec_name, cfg->name);
 		return err;
 	}
@@ -1140,13 +1334,13 @@ static int test_hash_vec_cfg(const char *driver,
 		if (err) {
 			if (err == vec->digest_error)
 				return 0;
-			pr_err("alg: hash: %s digest() failed on test vector %s; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
+			pr_err("alg: ahash: %s digest() failed on test vector %s; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
 			       driver, vec_name, vec->digest_error, err,
 			       cfg->name);
 			return err;
 		}
 		if (vec->digest_error) {
-			pr_err("alg: hash: %s digest() unexpectedly succeeded on test vector %s; expected_error=%d, cfg=\"%s\"\n",
+			pr_err("alg: ahash: %s digest() unexpectedly succeeded on test vector %s; expected_error=%d, cfg=\"%s\"\n",
 			       driver, vec_name, vec->digest_error, cfg->name);
 			return -EINVAL;
 		}
@@ -1158,8 +1352,8 @@ static int test_hash_vec_cfg(const char *driver,
 	ahash_request_set_callback(req, req_flags, crypto_req_done, &wait);
 	ahash_request_set_crypt(req, NULL, result, 0);
 	err = do_ahash_op(crypto_ahash_init, req, &wait, cfg->nosimd);
-	err = check_nonfinal_hash_op("init", err, result, digestsize,
-				     driver, vec_name, cfg);
+	err = check_nonfinal_ahash_op("init", err, result, digestsize,
+				      driver, vec_name, cfg);
 	if (err)
 		return err;
 
@@ -1175,9 +1369,9 @@ static int test_hash_vec_cfg(const char *driver,
 						pending_len);
 			err = do_ahash_op(crypto_ahash_update, req, &wait,
 					  divs[i]->nosimd);
-			err = check_nonfinal_hash_op("update", err,
-						     result, digestsize,
-						     driver, vec_name, cfg);
+			err = check_nonfinal_ahash_op("update", err,
+						      result, digestsize,
+						      driver, vec_name, cfg);
 			if (err)
 				return err;
 			pending_sgl = NULL;
@@ -1188,23 +1382,23 @@ static int test_hash_vec_cfg(const char *driver,
 			testmgr_poison(hashstate + statesize,
 				       TESTMGR_POISON_LEN);
 			err = crypto_ahash_export(req, hashstate);
-			err = check_nonfinal_hash_op("export", err,
-						     result, digestsize,
-						     driver, vec_name, cfg);
+			err = check_nonfinal_ahash_op("export", err,
+						      result, digestsize,
+						      driver, vec_name, cfg);
 			if (err)
 				return err;
 			if (!testmgr_is_poison(hashstate + statesize,
 					       TESTMGR_POISON_LEN)) {
-				pr_err("alg: hash: %s export() overran state buffer on test vector %s, cfg=\"%s\"\n",
+				pr_err("alg: ahash: %s export() overran state buffer on test vector %s, cfg=\"%s\"\n",
 				       driver, vec_name, cfg->name);
 				return -EOVERFLOW;
 			}
 
 			testmgr_poison(req->__ctx, crypto_ahash_reqsize(tfm));
 			err = crypto_ahash_import(req, hashstate);
-			err = check_nonfinal_hash_op("import", err,
-						     result, digestsize,
-						     driver, vec_name, cfg);
+			err = check_nonfinal_ahash_op("import", err,
+						      result, digestsize,
+						      driver, vec_name, cfg);
 			if (err)
 				return err;
 		}
@@ -1218,13 +1412,13 @@ static int test_hash_vec_cfg(const char *driver,
 	if (cfg->finalization_type == FINALIZATION_TYPE_FINAL) {
 		/* finish with update() and final() */
 		err = do_ahash_op(crypto_ahash_update, req, &wait, cfg->nosimd);
-		err = check_nonfinal_hash_op("update", err, result, digestsize,
-					     driver, vec_name, cfg);
+		err = check_nonfinal_ahash_op("update", err, result, digestsize,
+					      driver, vec_name, cfg);
 		if (err)
 			return err;
 		err = do_ahash_op(crypto_ahash_final, req, &wait, cfg->nosimd);
 		if (err) {
-			pr_err("alg: hash: %s final() failed with err %d on test vector %s, cfg=\"%s\"\n",
+			pr_err("alg: ahash: %s final() failed with err %d on test vector %s, cfg=\"%s\"\n",
 			       driver, err, vec_name, cfg->name);
 			return err;
 		}
@@ -1232,31 +1426,49 @@ static int test_hash_vec_cfg(const char *driver,
 		/* finish with finup() */
 		err = do_ahash_op(crypto_ahash_finup, req, &wait, cfg->nosimd);
 		if (err) {
-			pr_err("alg: hash: %s finup() failed with err %d on test vector %s, cfg=\"%s\"\n",
+			pr_err("alg: ahash: %s finup() failed with err %d on test vector %s, cfg=\"%s\"\n",
 			       driver, err, vec_name, cfg->name);
 			return err;
 		}
 	}
 
 result_ready:
-	/* Check that the algorithm produced the correct digest */
-	if (memcmp(result, vec->digest, digestsize) != 0) {
-		pr_err("alg: hash: %s test failed (wrong result) on test vector %s, cfg=\"%s\"\n",
-		       driver, vec_name, cfg->name);
-		return -EINVAL;
-	}
-	if (!testmgr_is_poison(&result[digestsize], TESTMGR_POISON_LEN)) {
-		pr_err("alg: hash: %s overran result buffer on test vector %s, cfg=\"%s\"\n",
-		       driver, vec_name, cfg->name);
-		return -EOVERFLOW;
+	return check_hash_result("ahash", result, digestsize, vec, vec_name,
+				 driver, cfg);
+}
+
+static int test_hash_vec_cfg(const char *driver,
+			     const struct hash_testvec *vec,
+			     const char *vec_name,
+			     const struct testvec_config *cfg,
+			     struct ahash_request *req,
+			     struct shash_desc *desc,
+			     struct test_sglist *tsgl,
+			     u8 *hashstate)
+{
+	int err;
+
+	/*
+	 * For algorithms implemented as "shash", most bugs will be detected by
+	 * both the shash and ahash tests.  Test the shash API first so that the
+	 * failures involve less indirection, so are easier to debug.
+	 */
+
+	if (desc) {
+		err = test_shash_vec_cfg(driver, vec, vec_name, cfg, desc, tsgl,
+					 hashstate);
+		if (err)
+			return err;
 	}
 
-	return 0;
+	return test_ahash_vec_cfg(driver, vec, vec_name, cfg, req, tsgl,
+				  hashstate);
 }
 
 static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 			 unsigned int vec_num, struct ahash_request *req,
-			 struct test_sglist *tsgl, u8 *hashstate)
+			 struct shash_desc *desc, struct test_sglist *tsgl,
+			 u8 *hashstate)
 {
 	char vec_name[16];
 	unsigned int i;
@@ -1267,7 +1479,7 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 	for (i = 0; i < ARRAY_SIZE(default_hash_testvec_configs); i++) {
 		err = test_hash_vec_cfg(driver, vec, vec_name,
 					&default_hash_testvec_configs[i],
-					req, tsgl, hashstate);
+					req, desc, tsgl, hashstate);
 		if (err)
 			return err;
 	}
@@ -1281,7 +1493,7 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 			generate_random_testvec_config(&cfg, cfgname,
 						       sizeof(cfgname));
 			err = test_hash_vec_cfg(driver, vec, vec_name, &cfg,
-						req, tsgl, hashstate);
+						req, desc, tsgl, hashstate);
 			if (err)
 				return err;
 		}
@@ -1343,6 +1555,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 				     const char *generic_driver,
 				     unsigned int maxkeysize,
 				     struct ahash_request *req,
+				     struct shash_desc *desc,
 				     struct test_sglist *tsgl,
 				     u8 *hashstate)
 {
@@ -1423,7 +1636,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 		generate_random_testvec_config(&cfg, cfgname, sizeof(cfgname));
 
 		err = test_hash_vec_cfg(driver, &vec, vec_name, &cfg,
-					req, tsgl, hashstate);
+					req, desc, tsgl, hashstate);
 		if (err)
 			goto out;
 		cond_resched();
@@ -1441,6 +1654,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 				     const char *generic_driver,
 				     unsigned int maxkeysize,
 				     struct ahash_request *req,
+				     struct shash_desc *desc,
 				     struct test_sglist *tsgl,
 				     u8 *hashstate)
 {
@@ -1448,26 +1662,67 @@ static int test_hash_vs_generic_impl(const char *driver,
 }
 #endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 
+static int alloc_shash(const char *driver, u32 type, u32 mask,
+		       struct crypto_shash **tfm_ret,
+		       struct shash_desc **desc_ret)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+
+	tfm = crypto_alloc_shash(driver, type, mask);
+	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT) {
+			/*
+			 * This algorithm is only available through the ahash
+			 * API, not the shash API, so skip the shash tests.
+			 */
+			return 0;
+		}
+		pr_err("alg: hash: failed to allocate shash transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
+	if (!desc) {
+		crypto_free_shash(tfm);
+		return -ENOMEM;
+	}
+	desc->tfm = tfm;
+
+	*tfm_ret = tfm;
+	*desc_ret = desc;
+	return 0;
+}
+
 static int __alg_test_hash(const struct hash_testvec *vecs,
 			   unsigned int num_vecs, const char *driver,
 			   u32 type, u32 mask,
 			   const char *generic_driver, unsigned int maxkeysize)
 {
-	struct crypto_ahash *tfm;
+	struct crypto_ahash *atfm = NULL;
 	struct ahash_request *req = NULL;
+	struct crypto_shash *stfm = NULL;
+	struct shash_desc *desc = NULL;
 	struct test_sglist *tsgl = NULL;
 	u8 *hashstate = NULL;
+	unsigned int statesize;
 	unsigned int i;
 	int err;
 
-	tfm = crypto_alloc_ahash(driver, type, mask);
-	if (IS_ERR(tfm)) {
+	/*
+	 * Always test the ahash API.  This works regardless of whether the
+	 * algorithm is implemented as ahash or shash.
+	 */
+
+	atfm = crypto_alloc_ahash(driver, type, mask);
+	if (IS_ERR(atfm)) {
 		pr_err("alg: hash: failed to allocate transform for %s: %ld\n",
-		       driver, PTR_ERR(tfm));
-		return PTR_ERR(tfm);
+		       driver, PTR_ERR(atfm));
+		return PTR_ERR(atfm);
 	}
 
-	req = ahash_request_alloc(tfm, GFP_KERNEL);
+	req = ahash_request_alloc(atfm, GFP_KERNEL);
 	if (!req) {
 		pr_err("alg: hash: failed to allocate request for %s\n",
 		       driver);
@@ -1475,6 +1730,14 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 		goto out;
 	}
 
+	/*
+	 * If available also test the shash API, to cover corner cases that may
+	 * be missed by testing the ahash API only.
+	 */
+	err = alloc_shash(driver, type, mask, &stfm, &desc);
+	if (err)
+		goto out;
+
 	tsgl = kmalloc(sizeof(*tsgl), GFP_KERNEL);
 	if (!tsgl || init_test_sglist(tsgl) != 0) {
 		pr_err("alg: hash: failed to allocate test buffers for %s\n",
@@ -1485,8 +1748,10 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 		goto out;
 	}
 
-	hashstate = kmalloc(crypto_ahash_statesize(tfm) + TESTMGR_POISON_LEN,
-			    GFP_KERNEL);
+	statesize = crypto_ahash_statesize(atfm);
+	if (stfm)
+		statesize = max(statesize, crypto_shash_statesize(stfm));
+	hashstate = kmalloc(statesize + TESTMGR_POISON_LEN, GFP_KERNEL);
 	if (!hashstate) {
 		pr_err("alg: hash: failed to allocate hash state buffer for %s\n",
 		       driver);
@@ -1495,20 +1760,23 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	}
 
 	for (i = 0; i < num_vecs; i++) {
-		err = test_hash_vec(driver, &vecs[i], i, req, tsgl, hashstate);
+		err = test_hash_vec(driver, &vecs[i], i, req, desc, tsgl,
+				    hashstate);
 		if (err)
 			goto out;
 	}
 	err = test_hash_vs_generic_impl(driver, generic_driver, maxkeysize, req,
-					tsgl, hashstate);
+					desc, tsgl, hashstate);
 out:
 	kfree(hashstate);
 	if (tsgl) {
 		destroy_test_sglist(tsgl);
 		kfree(tsgl);
 	}
+	kfree(desc);
+	crypto_free_shash(stfm);
 	ahash_request_free(req);
-	crypto_free_ahash(tfm);
+	crypto_free_ahash(atfm);
 	return err;
 }
 
-- 
2.21.0


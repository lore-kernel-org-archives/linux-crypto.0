Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE121C282DA
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89F31218D2
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555045254;
	bh=JV1hwKJ559AtSpN0gbtnKA4bq4Ds4GVBeexVAcMyToA=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BbXvr9F0x8CLPEEVOph9ODOmbgK0ogP3H8ZqZSmG8p+NkkmFgJoeHM+dyF2bqxg0Q
	 RYwdJJQABcnbafk8WCCzN2OMuxdZKwlz21KPANmupnIhdqCiyedRH7CTuQFKHQV3H6
	 EXT0haZQEA7YhieJVSCtdowUfYAJCsvO+IQJlCwc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfDLFAw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 01:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfDLFAv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 01:00:51 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E40BF21871;
        Fri, 12 Apr 2019 05:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555045250;
        bh=JV1hwKJ559AtSpN0gbtnKA4bq4Ds4GVBeexVAcMyToA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dtK0a1h25e0gCv2dNS+2g6STiRL2yoaNqFdE7ngcXfVvLoW4sS8HMIqcgkB9olQzJ
         a3SkioTFwduHnEt0yj+XyclAnHBiAAe9VM4vXeeqm7jsiZC84aLxVcUQFOQtCK8Fov
         eCWph2q4pSnH9ANP5iq4rA8sp0Cqx+Gp/fFh0tnY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 2/7] crypto: testmgr - identify test vectors by name rather than number
Date:   Thu, 11 Apr 2019 21:57:37 -0700
Message-Id: <20190412045742.1725-3-ebiggers@kernel.org>
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

In preparation for fuzz testing algorithms against their generic
implementation, make error messages in testmgr identify test vectors by
name rather than index.  Built-in test vectors are simply "named" by
their index in testmgr.h, as before.  But (in later patches) generated
test vectors will be given more descriptive names to help developers
debug problems detected with them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 183 +++++++++++++++++++++++++----------------------
 1 file changed, 96 insertions(+), 87 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 755f0725b5279..0e7548fb183e4 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -928,17 +928,17 @@ static int do_ahash_op(int (*op)(struct ahash_request *req),
 
 static int check_nonfinal_hash_op(const char *op, int err,
 				  u8 *result, unsigned int digestsize,
-				  const char *driver, unsigned int vec_num,
+				  const char *driver, const char *vec_name,
 				  const struct testvec_config *cfg)
 {
 	if (err) {
-		pr_err("alg: hash: %s %s() failed with err %d on test vector %u, cfg=\"%s\"\n",
-		       driver, op, err, vec_num, cfg->name);
+		pr_err("alg: hash: %s %s() failed with err %d on test vector %s, cfg=\"%s\"\n",
+		       driver, op, err, vec_name, cfg->name);
 		return err;
 	}
 	if (!testmgr_is_poison(result, digestsize)) {
-		pr_err("alg: hash: %s %s() used result buffer on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: hash: %s %s() used result buffer on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return -EINVAL;
 	}
 	return 0;
@@ -946,7 +946,7 @@ static int check_nonfinal_hash_op(const char *op, int err,
 
 static int test_hash_vec_cfg(const char *driver,
 			     const struct hash_testvec *vec,
-			     unsigned int vec_num,
+			     const char *vec_name,
 			     const struct testvec_config *cfg,
 			     struct ahash_request *req,
 			     struct test_sglist *tsgl,
@@ -973,14 +973,14 @@ static int test_hash_vec_cfg(const char *driver,
 		if (err) {
 			if (err == vec->setkey_error)
 				return 0;
-			pr_err("alg: hash: %s setkey failed on test vector %u; expected_error=%d, actual_error=%d, flags=%#x\n",
-			       driver, vec_num, vec->setkey_error, err,
+			pr_err("alg: hash: %s setkey failed on test vector %s; expected_error=%d, actual_error=%d, flags=%#x\n",
+			       driver, vec_name, vec->setkey_error, err,
 			       crypto_ahash_get_flags(tfm));
 			return err;
 		}
 		if (vec->setkey_error) {
-			pr_err("alg: hash: %s setkey unexpectedly succeeded on test vector %u; expected_error=%d\n",
-			       driver, vec_num, vec->setkey_error);
+			pr_err("alg: hash: %s setkey unexpectedly succeeded on test vector %s; expected_error=%d\n",
+			       driver, vec_name, vec->setkey_error);
 			return -EINVAL;
 		}
 	}
@@ -992,8 +992,8 @@ static int test_hash_vec_cfg(const char *driver,
 	err = build_test_sglist(tsgl, cfg->src_divs, alignmask, vec->psize,
 				&input, divs);
 	if (err) {
-		pr_err("alg: hash: %s: error preparing scatterlist for test vector %u, cfg=\"%s\"\n",
-		       driver, vec_num, cfg->name);
+		pr_err("alg: hash: %s: error preparing scatterlist for test vector %s, cfg=\"%s\"\n",
+		       driver, vec_name, cfg->name);
 		return err;
 	}
 
@@ -1012,14 +1012,14 @@ static int test_hash_vec_cfg(const char *driver,
 		if (err) {
 			if (err == vec->digest_error)
 				return 0;
-			pr_err("alg: hash: %s digest() failed on test vector %u; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
-			       driver, vec_num, vec->digest_error, err,
+			pr_err("alg: hash: %s digest() failed on test vector %s; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
+			       driver, vec_name, vec->digest_error, err,
 			       cfg->name);
 			return err;
 		}
 		if (vec->digest_error) {
-			pr_err("alg: hash: %s digest() unexpectedly succeeded on test vector %u; expected_error=%d, cfg=\"%s\"\n",
-			       driver, vec_num, vec->digest_error, cfg->name);
+			pr_err("alg: hash: %s digest() unexpectedly succeeded on test vector %s; expected_error=%d, cfg=\"%s\"\n",
+			       driver, vec_name, vec->digest_error, cfg->name);
 			return -EINVAL;
 		}
 		goto result_ready;
@@ -1031,7 +1031,7 @@ static int test_hash_vec_cfg(const char *driver,
 	ahash_request_set_crypt(req, NULL, result, 0);
 	err = do_ahash_op(crypto_ahash_init, req, &wait, cfg->nosimd);
 	err = check_nonfinal_hash_op("init", err, result, digestsize,
-				     driver, vec_num, cfg);
+				     driver, vec_name, cfg);
 	if (err)
 		return err;
 
@@ -1049,7 +1049,7 @@ static int test_hash_vec_cfg(const char *driver,
 					  divs[i]->nosimd);
 			err = check_nonfinal_hash_op("update", err,
 						     result, digestsize,
-						     driver, vec_num, cfg);
+						     driver, vec_name, cfg);
 			if (err)
 				return err;
 			pending_sgl = NULL;
@@ -1062,13 +1062,13 @@ static int test_hash_vec_cfg(const char *driver,
 			err = crypto_ahash_export(req, hashstate);
 			err = check_nonfinal_hash_op("export", err,
 						     result, digestsize,
-						     driver, vec_num, cfg);
+						     driver, vec_name, cfg);
 			if (err)
 				return err;
 			if (!testmgr_is_poison(hashstate + statesize,
 					       TESTMGR_POISON_LEN)) {
-				pr_err("alg: hash: %s export() overran state buffer on test vector %u, cfg=\"%s\"\n",
-				       driver, vec_num, cfg->name);
+				pr_err("alg: hash: %s export() overran state buffer on test vector %s, cfg=\"%s\"\n",
+				       driver, vec_name, cfg->name);
 				return -EOVERFLOW;
 			}
 
@@ -1076,7 +1076,7 @@ static int test_hash_vec_cfg(const char *driver,
 			err = crypto_ahash_import(req, hashstate);
 			err = check_nonfinal_hash_op("import", err,
 						     result, digestsize,
-						     driver, vec_num, cfg);
+						     driver, vec_name, cfg);
 			if (err)
 				return err;
 		}
@@ -1091,21 +1091,21 @@ static int test_hash_vec_cfg(const char *driver,
 		/* finish with update() and final() */
 		err = do_ahash_op(crypto_ahash_update, req, &wait, cfg->nosimd);
 		err = check_nonfinal_hash_op("update", err, result, digestsize,
-					     driver, vec_num, cfg);
+					     driver, vec_name, cfg);
 		if (err)
 			return err;
 		err = do_ahash_op(crypto_ahash_final, req, &wait, cfg->nosimd);
 		if (err) {
-			pr_err("alg: hash: %s final() failed with err %d on test vector %u, cfg=\"%s\"\n",
-			       driver, err, vec_num, cfg->name);
+			pr_err("alg: hash: %s final() failed with err %d on test vector %s, cfg=\"%s\"\n",
+			       driver, err, vec_name, cfg->name);
 			return err;
 		}
 	} else {
 		/* finish with finup() */
 		err = do_ahash_op(crypto_ahash_finup, req, &wait, cfg->nosimd);
 		if (err) {
-			pr_err("alg: hash: %s finup() failed with err %d on test vector %u, cfg=\"%s\"\n",
-			       driver, err, vec_num, cfg->name);
+			pr_err("alg: hash: %s finup() failed with err %d on test vector %s, cfg=\"%s\"\n",
+			       driver, err, vec_name, cfg->name);
 			return err;
 		}
 	}
@@ -1113,13 +1113,13 @@ static int test_hash_vec_cfg(const char *driver,
 result_ready:
 	/* Check that the algorithm produced the correct digest */
 	if (memcmp(result, vec->digest, digestsize) != 0) {
-		pr_err("alg: hash: %s test failed (wrong result) on test vector %u, cfg=\"%s\"\n",
-		       driver, vec_num, cfg->name);
+		pr_err("alg: hash: %s test failed (wrong result) on test vector %s, cfg=\"%s\"\n",
+		       driver, vec_name, cfg->name);
 		return -EINVAL;
 	}
 	if (!testmgr_is_poison(&result[digestsize], TESTMGR_POISON_LEN)) {
-		pr_err("alg: hash: %s overran result buffer on test vector %u, cfg=\"%s\"\n",
-		       driver, vec_num, cfg->name);
+		pr_err("alg: hash: %s overran result buffer on test vector %s, cfg=\"%s\"\n",
+		       driver, vec_name, cfg->name);
 		return -EOVERFLOW;
 	}
 
@@ -1130,11 +1130,14 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 			 unsigned int vec_num, struct ahash_request *req,
 			 struct test_sglist *tsgl, u8 *hashstate)
 {
+	char vec_name[16];
 	unsigned int i;
 	int err;
 
+	sprintf(vec_name, "%u", vec_num);
+
 	for (i = 0; i < ARRAY_SIZE(default_hash_testvec_configs); i++) {
-		err = test_hash_vec_cfg(driver, vec, vec_num,
+		err = test_hash_vec_cfg(driver, vec, vec_name,
 					&default_hash_testvec_configs[i],
 					req, tsgl, hashstate);
 		if (err)
@@ -1149,7 +1152,7 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 		for (i = 0; i < fuzz_iterations; i++) {
 			generate_random_testvec_config(&cfg, cfgname,
 						       sizeof(cfgname));
-			err = test_hash_vec_cfg(driver, vec, vec_num, &cfg,
+			err = test_hash_vec_cfg(driver, vec, vec_name, &cfg,
 						req, tsgl, hashstate);
 			if (err)
 				return err;
@@ -1261,7 +1264,7 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 
 static int test_aead_vec_cfg(const char *driver, int enc,
 			     const struct aead_testvec *vec,
-			     unsigned int vec_num,
+			     const char *vec_name,
 			     const struct testvec_config *cfg,
 			     struct aead_request *req,
 			     struct cipher_test_sglists *tsgls)
@@ -1288,27 +1291,27 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 		crypto_aead_clear_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	err = crypto_aead_setkey(tfm, vec->key, vec->klen);
 	if (err && err != vec->setkey_error) {
-		pr_err("alg: aead: %s setkey failed on test vector %u; expected_error=%d, actual_error=%d, flags=%#x\n",
-		       driver, vec_num, vec->setkey_error, err,
+		pr_err("alg: aead: %s setkey failed on test vector %s; expected_error=%d, actual_error=%d, flags=%#x\n",
+		       driver, vec_name, vec->setkey_error, err,
 		       crypto_aead_get_flags(tfm));
 		return err;
 	}
 	if (!err && vec->setkey_error) {
-		pr_err("alg: aead: %s setkey unexpectedly succeeded on test vector %u; expected_error=%d\n",
-		       driver, vec_num, vec->setkey_error);
+		pr_err("alg: aead: %s setkey unexpectedly succeeded on test vector %s; expected_error=%d\n",
+		       driver, vec_name, vec->setkey_error);
 		return -EINVAL;
 	}
 
 	/* Set the authentication tag size */
 	err = crypto_aead_setauthsize(tfm, authsize);
 	if (err && err != vec->setauthsize_error) {
-		pr_err("alg: aead: %s setauthsize failed on test vector %u; expected_error=%d, actual_error=%d\n",
-		       driver, vec_num, vec->setauthsize_error, err);
+		pr_err("alg: aead: %s setauthsize failed on test vector %s; expected_error=%d, actual_error=%d\n",
+		       driver, vec_name, vec->setauthsize_error, err);
 		return err;
 	}
 	if (!err && vec->setauthsize_error) {
-		pr_err("alg: aead: %s setauthsize unexpectedly succeeded on test vector %u; expected_error=%d\n",
-		       driver, vec_num, vec->setauthsize_error);
+		pr_err("alg: aead: %s setauthsize unexpectedly succeeded on test vector %s; expected_error=%d\n",
+		       driver, vec_name, vec->setauthsize_error);
 		return -EINVAL;
 	}
 
@@ -1335,8 +1338,8 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 						     vec->plen),
 					input, 2);
 	if (err) {
-		pr_err("alg: aead: %s %s: error preparing scatterlists for test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: aead: %s %s: error preparing scatterlists for test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return err;
 	}
 
@@ -1363,8 +1366,8 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 	    req->base.complete != crypto_req_done ||
 	    req->base.flags != req_flags ||
 	    req->base.data != &wait) {
-		pr_err("alg: aead: %s %s corrupted request struct on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: aead: %s %s corrupted request struct on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		if (req->cryptlen != (enc ? vec->plen : vec->clen))
 			pr_err("alg: aead: changed 'req->cryptlen'\n");
 		if (req->assoclen != vec->alen)
@@ -1386,14 +1389,14 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 		return -EINVAL;
 	}
 	if (is_test_sglist_corrupted(&tsgls->src)) {
-		pr_err("alg: aead: %s %s corrupted src sgl on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: aead: %s %s corrupted src sgl on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return -EINVAL;
 	}
 	if (tsgls->dst.sgl_ptr != tsgls->src.sgl &&
 	    is_test_sglist_corrupted(&tsgls->dst)) {
-		pr_err("alg: aead: %s %s corrupted dst sgl on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: aead: %s %s corrupted dst sgl on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return -EINVAL;
 	}
 
@@ -1402,13 +1405,13 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 	if (err) {
 		if (err == expected_error)
 			return 0;
-		pr_err("alg: aead: %s %s failed on test vector %u; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
-		       driver, op, vec_num, expected_error, err, cfg->name);
+		pr_err("alg: aead: %s %s failed on test vector %s; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
+		       driver, op, vec_name, expected_error, err, cfg->name);
 		return err;
 	}
 	if (expected_error) {
-		pr_err("alg: aead: %s %s unexpectedly succeeded on test vector %u; expected_error=%d, cfg=\"%s\"\n",
-		       driver, op, vec_num, expected_error, cfg->name);
+		pr_err("alg: aead: %s %s unexpectedly succeeded on test vector %s; expected_error=%d, cfg=\"%s\"\n",
+		       driver, op, vec_name, expected_error, cfg->name);
 		return -EINVAL;
 	}
 
@@ -1417,13 +1420,13 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 				    enc ? vec->clen : vec->plen,
 				    vec->alen, enc || !cfg->inplace);
 	if (err == -EOVERFLOW) {
-		pr_err("alg: aead: %s %s overran dst buffer on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: aead: %s %s overran dst buffer on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return err;
 	}
 	if (err) {
-		pr_err("alg: aead: %s %s test failed (wrong result) on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: aead: %s %s test failed (wrong result) on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return err;
 	}
 
@@ -1435,14 +1438,17 @@ static int test_aead_vec(const char *driver, int enc,
 			 struct aead_request *req,
 			 struct cipher_test_sglists *tsgls)
 {
+	char vec_name[16];
 	unsigned int i;
 	int err;
 
 	if (enc && vec->novrfy)
 		return 0;
 
+	sprintf(vec_name, "%u", vec_num);
+
 	for (i = 0; i < ARRAY_SIZE(default_cipher_testvec_configs); i++) {
-		err = test_aead_vec_cfg(driver, enc, vec, vec_num,
+		err = test_aead_vec_cfg(driver, enc, vec, vec_name,
 					&default_cipher_testvec_configs[i],
 					req, tsgls);
 		if (err)
@@ -1457,7 +1463,7 @@ static int test_aead_vec(const char *driver, int enc,
 		for (i = 0; i < fuzz_iterations; i++) {
 			generate_random_testvec_config(&cfg, cfgname,
 						       sizeof(cfgname));
-			err = test_aead_vec_cfg(driver, enc, vec, vec_num,
+			err = test_aead_vec_cfg(driver, enc, vec, vec_name,
 						&cfg, req, tsgls);
 			if (err)
 				return err;
@@ -1622,7 +1628,7 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 
 static int test_skcipher_vec_cfg(const char *driver, int enc,
 				 const struct cipher_testvec *vec,
-				 unsigned int vec_num,
+				 const char *vec_name,
 				 const struct testvec_config *cfg,
 				 struct skcipher_request *req,
 				 struct cipher_test_sglists *tsgls)
@@ -1650,14 +1656,14 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	if (err) {
 		if (err == vec->setkey_error)
 			return 0;
-		pr_err("alg: skcipher: %s setkey failed on test vector %u; expected_error=%d, actual_error=%d, flags=%#x\n",
-		       driver, vec_num, vec->setkey_error, err,
+		pr_err("alg: skcipher: %s setkey failed on test vector %s; expected_error=%d, actual_error=%d, flags=%#x\n",
+		       driver, vec_name, vec->setkey_error, err,
 		       crypto_skcipher_get_flags(tfm));
 		return err;
 	}
 	if (vec->setkey_error) {
-		pr_err("alg: skcipher: %s setkey unexpectedly succeeded on test vector %u; expected_error=%d\n",
-		       driver, vec_num, vec->setkey_error);
+		pr_err("alg: skcipher: %s setkey unexpectedly succeeded on test vector %s; expected_error=%d\n",
+		       driver, vec_name, vec->setkey_error);
 		return -EINVAL;
 	}
 
@@ -1673,8 +1679,8 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 			memset(iv, 0, ivsize);
 	} else {
 		if (vec->generates_iv) {
-			pr_err("alg: skcipher: %s has ivsize=0 but test vector %u generates IV!\n",
-			       driver, vec_num);
+			pr_err("alg: skcipher: %s has ivsize=0 but test vector %s generates IV!\n",
+			       driver, vec_name);
 			return -EINVAL;
 		}
 		iv = NULL;
@@ -1686,8 +1692,8 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	err = build_cipher_test_sglists(tsgls, cfg, alignmask,
 					vec->len, vec->len, &input, 1);
 	if (err) {
-		pr_err("alg: skcipher: %s %s: error preparing scatterlists for test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: skcipher: %s %s: error preparing scatterlists for test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return err;
 	}
 
@@ -1712,8 +1718,8 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	    req->base.complete != crypto_req_done ||
 	    req->base.flags != req_flags ||
 	    req->base.data != &wait) {
-		pr_err("alg: skcipher: %s %s corrupted request struct on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: skcipher: %s %s corrupted request struct on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		if (req->cryptlen != vec->len)
 			pr_err("alg: skcipher: changed 'req->cryptlen'\n");
 		if (req->iv != iv)
@@ -1733,14 +1739,14 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 		return -EINVAL;
 	}
 	if (is_test_sglist_corrupted(&tsgls->src)) {
-		pr_err("alg: skcipher: %s %s corrupted src sgl on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: skcipher: %s %s corrupted src sgl on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return -EINVAL;
 	}
 	if (tsgls->dst.sgl_ptr != tsgls->src.sgl &&
 	    is_test_sglist_corrupted(&tsgls->dst)) {
-		pr_err("alg: skcipher: %s %s corrupted dst sgl on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: skcipher: %s %s corrupted dst sgl on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return -EINVAL;
 	}
 
@@ -1748,13 +1754,13 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	if (err) {
 		if (err == vec->crypt_error)
 			return 0;
-		pr_err("alg: skcipher: %s %s failed on test vector %u; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
-		       driver, op, vec_num, vec->crypt_error, err, cfg->name);
+		pr_err("alg: skcipher: %s %s failed on test vector %s; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
+		       driver, op, vec_name, vec->crypt_error, err, cfg->name);
 		return err;
 	}
 	if (vec->crypt_error) {
-		pr_err("alg: skcipher: %s %s unexpectedly succeeded on test vector %u; expected_error=%d, cfg=\"%s\"\n",
-		       driver, op, vec_num, vec->crypt_error, cfg->name);
+		pr_err("alg: skcipher: %s %s unexpectedly succeeded on test vector %s; expected_error=%d, cfg=\"%s\"\n",
+		       driver, op, vec_name, vec->crypt_error, cfg->name);
 		return -EINVAL;
 	}
 
@@ -1762,20 +1768,20 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	err = verify_correct_output(&tsgls->dst, enc ? vec->ctext : vec->ptext,
 				    vec->len, 0, true);
 	if (err == -EOVERFLOW) {
-		pr_err("alg: skcipher: %s %s overran dst buffer on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: skcipher: %s %s overran dst buffer on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return err;
 	}
 	if (err) {
-		pr_err("alg: skcipher: %s %s test failed (wrong result) on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: skcipher: %s %s test failed (wrong result) on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return err;
 	}
 
 	/* If applicable, check that the algorithm generated the correct IV */
 	if (vec->iv_out && memcmp(iv, vec->iv_out, ivsize) != 0) {
-		pr_err("alg: skcipher: %s %s test failed (wrong output IV) on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: skcipher: %s %s test failed (wrong output IV) on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		hexdump(iv, ivsize);
 		return -EINVAL;
 	}
@@ -1789,14 +1795,17 @@ static int test_skcipher_vec(const char *driver, int enc,
 			     struct skcipher_request *req,
 			     struct cipher_test_sglists *tsgls)
 {
+	char vec_name[16];
 	unsigned int i;
 	int err;
 
 	if (fips_enabled && vec->fips_skip)
 		return 0;
 
+	sprintf(vec_name, "%u", vec_num);
+
 	for (i = 0; i < ARRAY_SIZE(default_cipher_testvec_configs); i++) {
-		err = test_skcipher_vec_cfg(driver, enc, vec, vec_num,
+		err = test_skcipher_vec_cfg(driver, enc, vec, vec_name,
 					    &default_cipher_testvec_configs[i],
 					    req, tsgls);
 		if (err)
@@ -1811,7 +1820,7 @@ static int test_skcipher_vec(const char *driver, int enc,
 		for (i = 0; i < fuzz_iterations; i++) {
 			generate_random_testvec_config(&cfg, cfgname,
 						       sizeof(cfgname));
-			err = test_skcipher_vec_cfg(driver, enc, vec, vec_num,
+			err = test_skcipher_vec_cfg(driver, enc, vec, vec_name,
 						    &cfg, req, tsgls);
 			if (err)
 				return err;
-- 
2.21.0


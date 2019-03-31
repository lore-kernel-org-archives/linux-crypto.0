Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B81CC3E8A3
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 137DA20866
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062763;
	bh=Nq/aNEFXKvsFevkUNFim11+PI0YLeJQTR9hjTrrb55s=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0vqC+lsgse0eTP2SE4rl476ZN3S4qDTgQjs5DAR5PJL1Nu5MEJNdhQNh/KztTZs05
	 RLL20gYtaskCHYe7+1C0x2/Mj01Hzk4c6tIQQ03q76o4LBbdFWlgC+O8owJxoznbta
	 kdTFJ1PnXK7Y0beN3rrk/NU0Bt25nJAePk7WbyFE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbfCaUGB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:06:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731481AbfCaUGB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:06:01 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A20420866
        for <linux-crypto@vger.kernel.org>; Sun, 31 Mar 2019 20:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062759;
        bh=Nq/aNEFXKvsFevkUNFim11+PI0YLeJQTR9hjTrrb55s=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TKrPUcxS8JliGwl6K3Sbo2U8yhUQgKIYEjUiIHeApWk2Yyic1ZsPdEjerYhwMlGCU
         SdqmIqGyPSAoD/9E0lYyFr8mqy3fR6rv+N75RG7O8lsTzssXE+znjfdWIkokidCiiX
         KJ5Qw3Nk6kFaj4ZCcskwEIlY9r8iAWhyG8kRhZi8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [RFC/RFT PATCH 13/18] crypto: testmgr - identify test vectors by name rather than number
Date:   Sun, 31 Mar 2019 13:04:23 -0700
Message-Id: <20190331200428.26597-14-ebiggers@kernel.org>
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
index f81043c76cf55..fcdb891b9b357 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -925,17 +925,17 @@ static int do_ahash_op(int (*op)(struct ahash_request *req),
 
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
@@ -943,7 +943,7 @@ static int check_nonfinal_hash_op(const char *op, int err,
 
 static int test_hash_vec_cfg(const char *driver,
 			     const struct hash_testvec *vec,
-			     unsigned int vec_num,
+			     const char *vec_name,
 			     const struct testvec_config *cfg,
 			     struct ahash_request *req,
 			     struct test_sglist *tsgl,
@@ -970,14 +970,14 @@ static int test_hash_vec_cfg(const char *driver,
 		if (err) {
 			if (err == vec->setkey_error)
 				return 0;
-			pr_err("alg: hash: %s setkey failed with err %d on test vector %u; flags=%#x\n",
-			       driver, err, vec_num,
+			pr_err("alg: hash: %s setkey failed with err %d on test vector %s; flags=%#x\n",
+			       driver, err, vec_name,
 			       crypto_ahash_get_flags(tfm));
 			return err;
 		}
 		if (vec->setkey_error) {
-			pr_err("alg: hash: %s setkey unexpectedly succeeded on test vector %u\n",
-			       driver, vec_num);
+			pr_err("alg: hash: %s setkey unexpectedly succeeded on test vector %s\n",
+			       driver, vec_name);
 			return -EINVAL;
 		}
 	}
@@ -989,8 +989,8 @@ static int test_hash_vec_cfg(const char *driver,
 	err = build_test_sglist(tsgl, cfg->src_divs, alignmask, vec->psize,
 				&input, divs);
 	if (err) {
-		pr_err("alg: hash: %s: error preparing scatterlist for test vector %u, cfg=\"%s\"\n",
-		       driver, vec_num, cfg->name);
+		pr_err("alg: hash: %s: error preparing scatterlist for test vector %s, cfg=\"%s\"\n",
+		       driver, vec_name, cfg->name);
 		return err;
 	}
 
@@ -1009,13 +1009,13 @@ static int test_hash_vec_cfg(const char *driver,
 		if (err) {
 			if (err == vec->digest_error)
 				return 0;
-			pr_err("alg: hash: %s digest() failed with err %d on test vector %u, cfg=\"%s\"\n",
-			       driver, err, vec_num, cfg->name);
+			pr_err("alg: hash: %s digest() failed with err %d on test vector %s, cfg=\"%s\"\n",
+			       driver, err, vec_name, cfg->name);
 			return err;
 		}
 		if (vec->digest_error) {
-			pr_err("alg: hash: %s digest() unexpectedly succeeded on test vector %u, cfg=\"%s\"\n",
-			       driver, vec_num, cfg->name);
+			pr_err("alg: hash: %s digest() unexpectedly succeeded on test vector %s, cfg=\"%s\"\n",
+			       driver, vec_name, cfg->name);
 			return -EINVAL;
 		}
 		goto result_ready;
@@ -1027,7 +1027,7 @@ static int test_hash_vec_cfg(const char *driver,
 	ahash_request_set_crypt(req, NULL, result, 0);
 	err = do_ahash_op(crypto_ahash_init, req, &wait, cfg->nosimd);
 	err = check_nonfinal_hash_op("init", err, result, digestsize,
-				     driver, vec_num, cfg);
+				     driver, vec_name, cfg);
 	if (err)
 		return err;
 
@@ -1045,7 +1045,7 @@ static int test_hash_vec_cfg(const char *driver,
 					  divs[i]->nosimd);
 			err = check_nonfinal_hash_op("update", err,
 						     result, digestsize,
-						     driver, vec_num, cfg);
+						     driver, vec_name, cfg);
 			if (err)
 				return err;
 			pending_sgl = NULL;
@@ -1058,13 +1058,13 @@ static int test_hash_vec_cfg(const char *driver,
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
 
@@ -1072,7 +1072,7 @@ static int test_hash_vec_cfg(const char *driver,
 			err = crypto_ahash_import(req, hashstate);
 			err = check_nonfinal_hash_op("import", err,
 						     result, digestsize,
-						     driver, vec_num, cfg);
+						     driver, vec_name, cfg);
 			if (err)
 				return err;
 		}
@@ -1087,21 +1087,21 @@ static int test_hash_vec_cfg(const char *driver,
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
@@ -1109,13 +1109,13 @@ static int test_hash_vec_cfg(const char *driver,
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
 
@@ -1126,11 +1126,14 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
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
@@ -1145,7 +1148,7 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 		for (i = 0; i < fuzz_iterations; i++) {
 			generate_random_testvec_config(&cfg, cfgname,
 						       sizeof(cfgname));
-			err = test_hash_vec_cfg(driver, vec, vec_num, &cfg,
+			err = test_hash_vec_cfg(driver, vec, vec_name, &cfg,
 						req, tsgl, hashstate);
 			if (err)
 				return err;
@@ -1257,7 +1260,7 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 
 static int test_aead_vec_cfg(const char *driver, int enc,
 			     const struct aead_testvec *vec,
-			     unsigned int vec_num,
+			     const char *vec_name,
 			     const struct testvec_config *cfg,
 			     struct aead_request *req,
 			     struct cipher_test_sglists *tsgls)
@@ -1283,26 +1286,26 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 		crypto_aead_clear_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	err = crypto_aead_setkey(tfm, vec->key, vec->klen);
 	if (err && err != vec->setkey_error) {
-		pr_err("alg: aead: %s setkey failed with err %d on test vector %u; flags=%#x\n",
-		       driver, err, vec_num, crypto_aead_get_flags(tfm));
+		pr_err("alg: aead: %s setkey failed with err %d on test vector %s; flags=%#x\n",
+		       driver, err, vec_name, crypto_aead_get_flags(tfm));
 		return err;
 	}
 	if (!err && vec->setkey_error) {
-		pr_err("alg: aead: %s setkey unexpectedly succeeded on test vector %u\n",
-		       driver, vec_num);
+		pr_err("alg: aead: %s setkey unexpectedly succeeded on test vector %s\n",
+		       driver, vec_name);
 		return -EINVAL;
 	}
 
 	/* Set the authentication tag size */
 	err = crypto_aead_setauthsize(tfm, authsize);
 	if (err && err != vec->setauthsize_error) {
-		pr_err("alg: aead: %s setauthsize failed with err %d on test vector %u\n",
-		       driver, err, vec_num);
+		pr_err("alg: aead: %s setauthsize failed with err %d on test vector %s\n",
+		       driver, err, vec_name);
 		return err;
 	}
 	if (!err && vec->setauthsize_error) {
-		pr_err("alg: aead: %s setauthsize unexpectedly succeeded on test vector %u\n",
-		       driver, vec_num);
+		pr_err("alg: aead: %s setauthsize unexpectedly succeeded on test vector %s\n",
+		       driver, vec_name);
 		return -EINVAL;
 	}
 
@@ -1329,8 +1332,8 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 						     vec->plen),
 					input, 2);
 	if (err) {
-		pr_err("alg: aead: %s %s: error preparing scatterlists for test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: aead: %s %s: error preparing scatterlists for test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return err;
 	}
 
@@ -1357,8 +1360,8 @@ static int test_aead_vec_cfg(const char *driver, int enc,
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
@@ -1380,27 +1383,27 @@ static int test_aead_vec_cfg(const char *driver, int enc,
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
 
 	if (err) {
 		if (err == vec->crypt_error || (err == -EBADMSG && vec->novrfy))
 			return 0;
-		pr_err("alg: aead: %s %s failed with err %d on test vector %u, cfg=\"%s\"\n",
-		       driver, op, err, vec_num, cfg->name);
+		pr_err("alg: aead: %s %s failed with err %d on test vector %s, cfg=\"%s\"\n",
+		       driver, op, err, vec_name, cfg->name);
 		return err;
 	}
 	if (vec->crypt_error || vec->novrfy) {
-		pr_err("alg: aead: %s %s unexpectedly succeeded on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: aead: %s %s unexpectedly succeeded on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return -EINVAL;
 	}
 
@@ -1409,13 +1412,13 @@ static int test_aead_vec_cfg(const char *driver, int enc,
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
 
@@ -1427,14 +1430,17 @@ static int test_aead_vec(const char *driver, int enc,
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
@@ -1449,7 +1455,7 @@ static int test_aead_vec(const char *driver, int enc,
 		for (i = 0; i < fuzz_iterations; i++) {
 			generate_random_testvec_config(&cfg, cfgname,
 						       sizeof(cfgname));
-			err = test_aead_vec_cfg(driver, enc, vec, vec_num,
+			err = test_aead_vec_cfg(driver, enc, vec, vec_name,
 						&cfg, req, tsgls);
 			if (err)
 				return err;
@@ -1613,7 +1619,7 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 
 static int test_skcipher_vec_cfg(const char *driver, int enc,
 				 const struct cipher_testvec *vec,
-				 unsigned int vec_num,
+				 const char *vec_name,
 				 const struct testvec_config *cfg,
 				 struct skcipher_request *req,
 				 struct cipher_test_sglists *tsgls)
@@ -1641,13 +1647,13 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	if (err) {
 		if (err == vec->setkey_error)
 			return 0;
-		pr_err("alg: skcipher: %s setkey failed with err %d on test vector %u; flags=%#x\n",
-		       driver, err, vec_num, crypto_skcipher_get_flags(tfm));
+		pr_err("alg: skcipher: %s setkey failed with err %d on test vector %s; flags=%#x\n",
+		       driver, err, vec_name, crypto_skcipher_get_flags(tfm));
 		return err;
 	}
 	if (vec->setkey_error) {
-		pr_err("alg: skcipher: %s setkey unexpectedly succeeded on test vector %u\n",
-		       driver, vec_num);
+		pr_err("alg: skcipher: %s setkey unexpectedly succeeded on test vector %s\n",
+		       driver, vec_name);
 		return -EINVAL;
 	}
 
@@ -1663,8 +1669,8 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
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
@@ -1676,8 +1682,8 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	err = build_cipher_test_sglists(tsgls, cfg, alignmask,
 					vec->len, vec->len, &input, 1);
 	if (err) {
-		pr_err("alg: skcipher: %s %s: error preparing scatterlists for test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: skcipher: %s %s: error preparing scatterlists for test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return err;
 	}
 
@@ -1702,8 +1708,8 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
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
@@ -1723,27 +1729,27 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
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
 
 	if (err) {
 		if (err == vec->crypt_error)
 			return 0;
-		pr_err("alg: skcipher: %s %s failed with err %d on test vector %u, cfg=\"%s\"\n",
-		       driver, op, err, vec_num, cfg->name);
+		pr_err("alg: skcipher: %s %s failed with err %d on test vector %s, cfg=\"%s\"\n",
+		       driver, op, err, vec_name, cfg->name);
 		return err;
 	}
 	if (vec->crypt_error) {
-		pr_err("alg: skcipher: %s %s unexpectedly succeeded on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
+		pr_err("alg: skcipher: %s %s unexpectedly succeeded on test vector %s, cfg=\"%s\"\n",
+		       driver, op, vec_name, cfg->name);
 		return -EINVAL;
 	}
 
@@ -1751,20 +1757,20 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
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
@@ -1778,14 +1784,17 @@ static int test_skcipher_vec(const char *driver, int enc,
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
@@ -1800,7 +1809,7 @@ static int test_skcipher_vec(const char *driver, int enc,
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


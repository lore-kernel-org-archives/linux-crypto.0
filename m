Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38927175AB
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739675252; cv=none; b=fft8W3msb1Kaur4btknzEdSBi2O/aUCRYCvTwztYKqf8FNeYi4fCdcWzqLD24NUlkq9OBIupS30vSgpAdX7VvGvL7zD+oI31xG3HKndkXcA7spn1Gb0/mZ6OcCVE6lumi+NIRFW8G9Njj8PSDu+SpG553xw/pYyq+BkW28SNki8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739675252; c=relaxed/simple;
	bh=cvsu9qMEHJf/jmokSe2ErOC9R047bAaOIe+RGcmmviw=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=hlfNaW+BJXhSJi3TKAtZ+m7j0LtHVF5ZNd7y752zXuEThdEjEiJYTZHnp+HStRovJQEY5ewobjwbv2hjpMyv57FhdI/y0p36iaKr88EUD1OErIcoiiOG+ovTRSgFXlxwp2u2R1hEql6YLHd502zKVHQ0gyoHKfQoz6LE3sBiHfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IJBEJii5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IJBEJii5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kLY3Mf/uW0xOojfZN6Q+S4VUkA2I3+nbK457YK7eDbQ=; b=IJBEJii5teKVV3MAdayjtjEZCI
	XtcRNv/9xOa6SpXZMfzdOSDY/usJZ3MVaTPoYMdjLyWSzxJ49tQbfi6tw5quZwgB+cgdVKjnez8CP
	6mK6l1ekVNzXWN/LongRjnb3nrGdFAIMF1LQib5zx/levoZDZ3xwV+BVnlu4GZ7e8/MkdkyC2nGfW
	59uK/DyFBbZoWqtzInHsbSL0pExcTSEJUtdOCuMEKM/FxRW66GBSg7z0ZYOl91SF0aR6CuPulLC9J
	d7KxltfxGI8a5ZLiJgEh7ZjVSGpZtnGSxPyOUCDSWougSTB/4IUdWgUqaIDC3RylAYNLrQnOoF+jp
	/zVSu6Dg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUnG-000gZH-02;
	Sun, 16 Feb 2025 11:07:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:07:26 +0800
Date: Sun, 16 Feb 2025 11:07:26 +0800
Message-Id: <bb74b3f54e24308bef2def8d25ed917d13590921.1739674648.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1739674648.git.herbert@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 07/11] crypto: testmgr - Add multibuffer hash testing
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This is based on a patch by Eric Biggers <ebiggers@google.com>.

Add limited self-test for multibuffer hash code path.  This tests
only a single request in chain of a random length.  The other
requests are all of the same length as the one being tested.

Potential extension include testing all requests rather than just
the single one, and varying the length of each request.

Link: https://lore.kernel.org/all/20241001153718.111665-3-ebiggers@kernel.org/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c | 132 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 103 insertions(+), 29 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b69877db3f33..9717b5c0f3c6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -58,6 +58,9 @@ module_param(fuzz_iterations, uint, 0644);
 MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
 #endif
 
+/* Multibuffer hashing is unlimited.  Set arbitrary limit for testing. */
+#define HASH_TEST_MAX_MB_MSGS	16
+
 #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
 
 /* a perfect nop */
@@ -299,6 +302,11 @@ struct test_sg_division {
  * @key_offset_relative_to_alignmask: if true, add the algorithm's alignmask to
  *				      the @key_offset
  * @finalization_type: what finalization function to use for hashes
+ * @multibuffer: test with multibuffer
+ * @multibuffer_index: random number used to generate the message index to use
+ *		       for multibuffer.
+ * @multibuffer_count: random number used to generate the num_msgs parameter
+ *		       for multibuffer
  * @nosimd: execute with SIMD disabled?  Requires !CRYPTO_TFM_REQ_MAY_SLEEP.
  *	    This applies to the parts of the operation that aren't controlled
  *	    individually by @nosimd_setkey or @src_divs[].nosimd.
@@ -318,6 +326,9 @@ struct testvec_config {
 	enum finalization_type finalization_type;
 	bool nosimd;
 	bool nosimd_setkey;
+	bool multibuffer;
+	unsigned int multibuffer_index;
+	unsigned int multibuffer_count;
 };
 
 #define TESTVEC_CONFIG_NAMELEN	192
@@ -1146,6 +1157,13 @@ static void generate_random_testvec_config(struct rnd_state *rng,
 		break;
 	}
 
+	if (prandom_bool(rng)) {
+		cfg->multibuffer = true;
+		cfg->multibuffer_index = prandom_u32_state(rng);
+		cfg->multibuffer_count = prandom_u32_state(rng);
+		p += scnprintf(p, end - p, " multibuffer");
+	}
+
 	if (!(cfg->req_flags & CRYPTO_TFM_REQ_MAY_SLEEP)) {
 		if (prandom_bool(rng)) {
 			cfg->nosimd = true;
@@ -1446,16 +1464,61 @@ static int test_shash_vec_cfg(const struct hash_testvec *vec,
 				 driver, cfg);
 }
 
-static int do_ahash_op(int (*op)(struct ahash_request *req),
-		       struct ahash_request *req,
-		       struct crypto_wait *wait, bool nosimd)
+static int do_ahash_op_multibuffer(
+	int (*op)(struct ahash_request *req),
+	struct ahash_request *reqs[HASH_TEST_MAX_MB_MSGS],
+	struct crypto_wait *wait,
+	const struct testvec_config *cfg)
 {
+	struct ahash_request *req = reqs[0];
+	u8 trash[HASH_MAX_DIGESTSIZE];
+	unsigned int num_msgs;
+	unsigned int msg_idx;
+	int err;
+	int i;
+
+	num_msgs = 1 + (cfg->multibuffer_count % HASH_TEST_MAX_MB_MSGS);
+	if (num_msgs == 1)
+		return op(req);
+
+	msg_idx = cfg->multibuffer_index % num_msgs;
+	for (i = 1; i < num_msgs; i++) {
+		struct ahash_request *r2 = reqs[i];
+
+		ahash_request_set_callback(r2, req->base.flags, NULL, NULL);
+		ahash_request_set_crypt(r2, req->src, trash, req->nbytes);
+		ahash_request_chain(r2, req);
+	}
+
+	if (msg_idx) {
+		reqs[msg_idx]->result = req->result;
+		req->result = trash;
+	}
+
+	err = op(req);
+
+	if (msg_idx)
+		req->result = reqs[msg_idx]->result;
+
+	return err;
+}
+
+static int do_ahash_op(int (*op)(struct ahash_request *req),
+		       struct ahash_request *reqs[HASH_TEST_MAX_MB_MSGS],
+		       struct crypto_wait *wait,
+		       const struct testvec_config *cfg,
+		       bool nosimd)
+{
+	struct ahash_request *req = reqs[0];
 	int err;
 
 	if (nosimd)
 		crypto_disable_simd_for_test();
 
-	err = op(req);
+	if (cfg->multibuffer)
+		err = do_ahash_op_multibuffer(op, reqs, wait, cfg);
+	else
+		err = op(req);
 
 	if (nosimd)
 		crypto_reenable_simd_for_test();
@@ -1485,10 +1548,11 @@ static int check_nonfinal_ahash_op(const char *op, int err,
 static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 			      const char *vec_name,
 			      const struct testvec_config *cfg,
-			      struct ahash_request *req,
+			      struct ahash_request *reqs[HASH_TEST_MAX_MB_MSGS],
 			      struct test_sglist *tsgl,
 			      u8 *hashstate)
 {
+	struct ahash_request *req = reqs[0];
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
 	const unsigned int statesize = crypto_ahash_statesize(tfm);
@@ -1540,7 +1604,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 		ahash_request_set_callback(req, req_flags, crypto_req_done,
 					   &wait);
 		ahash_request_set_crypt(req, tsgl->sgl, result, vec->psize);
-		err = do_ahash_op(crypto_ahash_digest, req, &wait, cfg->nosimd);
+		err = do_ahash_op(crypto_ahash_digest, reqs, &wait, cfg, cfg->nosimd);
 		if (err) {
 			if (err == vec->digest_error)
 				return 0;
@@ -1561,7 +1625,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 
 	ahash_request_set_callback(req, req_flags, crypto_req_done, &wait);
 	ahash_request_set_crypt(req, NULL, result, 0);
-	err = do_ahash_op(crypto_ahash_init, req, &wait, cfg->nosimd);
+	err = do_ahash_op(crypto_ahash_init, reqs, &wait, cfg, cfg->nosimd);
 	err = check_nonfinal_ahash_op("init", err, result, digestsize,
 				      driver, vec_name, cfg);
 	if (err)
@@ -1577,8 +1641,8 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 						   crypto_req_done, &wait);
 			ahash_request_set_crypt(req, pending_sgl, result,
 						pending_len);
-			err = do_ahash_op(crypto_ahash_update, req, &wait,
-					  divs[i]->nosimd);
+			err = do_ahash_op(crypto_ahash_update, reqs, &wait,
+					  cfg, divs[i]->nosimd);
 			err = check_nonfinal_ahash_op("update", err,
 						      result, digestsize,
 						      driver, vec_name, cfg);
@@ -1621,12 +1685,13 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 	ahash_request_set_crypt(req, pending_sgl, result, pending_len);
 	if (cfg->finalization_type == FINALIZATION_TYPE_FINAL) {
 		/* finish with update() and final() */
-		err = do_ahash_op(crypto_ahash_update, req, &wait, cfg->nosimd);
+		err = do_ahash_op(crypto_ahash_update, reqs, &wait, cfg, cfg->nosimd);
 		err = check_nonfinal_ahash_op("update", err, result, digestsize,
 					      driver, vec_name, cfg);
 		if (err)
 			return err;
-		err = do_ahash_op(crypto_ahash_final, req, &wait, cfg->nosimd);
+		ahash_request_set_callback(req, req_flags, crypto_req_done, &wait);
+		err = do_ahash_op(crypto_ahash_final, reqs, &wait, cfg, cfg->nosimd);
 		if (err) {
 			pr_err("alg: ahash: %s final() failed with err %d on test vector %s, cfg=\"%s\"\n",
 			       driver, err, vec_name, cfg->name);
@@ -1634,7 +1699,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 		}
 	} else {
 		/* finish with finup() */
-		err = do_ahash_op(crypto_ahash_finup, req, &wait, cfg->nosimd);
+		err = do_ahash_op(crypto_ahash_finup, reqs, &wait, cfg, cfg->nosimd);
 		if (err) {
 			pr_err("alg: ahash: %s finup() failed with err %d on test vector %s, cfg=\"%s\"\n",
 			       driver, err, vec_name, cfg->name);
@@ -1650,7 +1715,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 static int test_hash_vec_cfg(const struct hash_testvec *vec,
 			     const char *vec_name,
 			     const struct testvec_config *cfg,
-			     struct ahash_request *req,
+			     struct ahash_request *reqs[HASH_TEST_MAX_MB_MSGS],
 			     struct shash_desc *desc,
 			     struct test_sglist *tsgl,
 			     u8 *hashstate)
@@ -1670,11 +1735,12 @@ static int test_hash_vec_cfg(const struct hash_testvec *vec,
 			return err;
 	}
 
-	return test_ahash_vec_cfg(vec, vec_name, cfg, req, tsgl, hashstate);
+	return test_ahash_vec_cfg(vec, vec_name, cfg, reqs, tsgl, hashstate);
 }
 
 static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
-			 struct ahash_request *req, struct shash_desc *desc,
+			 struct ahash_request *reqs[HASH_TEST_MAX_MB_MSGS],
+			 struct shash_desc *desc,
 			 struct test_sglist *tsgl, u8 *hashstate)
 {
 	char vec_name[16];
@@ -1686,7 +1752,7 @@ static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
 	for (i = 0; i < ARRAY_SIZE(default_hash_testvec_configs); i++) {
 		err = test_hash_vec_cfg(vec, vec_name,
 					&default_hash_testvec_configs[i],
-					req, desc, tsgl, hashstate);
+					reqs, desc, tsgl, hashstate);
 		if (err)
 			return err;
 	}
@@ -1703,7 +1769,7 @@ static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
 			generate_random_testvec_config(&rng, &cfg, cfgname,
 						       sizeof(cfgname));
 			err = test_hash_vec_cfg(vec, vec_name, &cfg,
-						req, desc, tsgl, hashstate);
+						reqs, desc, tsgl, hashstate);
 			if (err)
 				return err;
 			cond_resched();
@@ -1762,11 +1828,12 @@ static void generate_random_hash_testvec(struct rnd_state *rng,
  */
 static int test_hash_vs_generic_impl(const char *generic_driver,
 				     unsigned int maxkeysize,
-				     struct ahash_request *req,
+				     struct ahash_request *reqs[HASH_TEST_MAX_MB_MSGS],
 				     struct shash_desc *desc,
 				     struct test_sglist *tsgl,
 				     u8 *hashstate)
 {
+	struct ahash_request *req = reqs[0];
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
 	const unsigned int blocksize = crypto_ahash_blocksize(tfm);
@@ -1864,7 +1931,7 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 					       sizeof(cfgname));
 
 		err = test_hash_vec_cfg(&vec, vec_name, cfg,
-					req, desc, tsgl, hashstate);
+					reqs, desc, tsgl, hashstate);
 		if (err)
 			goto out;
 		cond_resched();
@@ -1929,8 +1996,8 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 			   u32 type, u32 mask,
 			   const char *generic_driver, unsigned int maxkeysize)
 {
+	struct ahash_request *reqs[HASH_TEST_MAX_MB_MSGS] = {};
 	struct crypto_ahash *atfm = NULL;
-	struct ahash_request *req = NULL;
 	struct crypto_shash *stfm = NULL;
 	struct shash_desc *desc = NULL;
 	struct test_sglist *tsgl = NULL;
@@ -1954,12 +2021,14 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	}
 	driver = crypto_ahash_driver_name(atfm);
 
-	req = ahash_request_alloc(atfm, GFP_KERNEL);
-	if (!req) {
-		pr_err("alg: hash: failed to allocate request for %s\n",
-		       driver);
-		err = -ENOMEM;
-		goto out;
+	for (i = 0; i < HASH_TEST_MAX_MB_MSGS; i++) {
+		reqs[i] = ahash_request_alloc(atfm, GFP_KERNEL);
+		if (!reqs[i]) {
+			pr_err("alg: hash: failed to allocate request for %s\n",
+			       driver);
+			err = -ENOMEM;
+			goto out;
+		}
 	}
 
 	/*
@@ -1995,12 +2064,12 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 		if (fips_enabled && vecs[i].fips_skip)
 			continue;
 
-		err = test_hash_vec(&vecs[i], i, req, desc, tsgl, hashstate);
+		err = test_hash_vec(&vecs[i], i, reqs, desc, tsgl, hashstate);
 		if (err)
 			goto out;
 		cond_resched();
 	}
-	err = test_hash_vs_generic_impl(generic_driver, maxkeysize, req,
+	err = test_hash_vs_generic_impl(generic_driver, maxkeysize, reqs,
 					desc, tsgl, hashstate);
 out:
 	kfree(hashstate);
@@ -2010,7 +2079,12 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	}
 	kfree(desc);
 	crypto_free_shash(stfm);
-	ahash_request_free(req);
+	if (reqs[0]) {
+		ahash_request_set_callback(reqs[0], 0, NULL, NULL);
+		for (i = 1; i < HASH_TEST_MAX_MB_MSGS && reqs[i]; i++)
+			ahash_request_chain(reqs[i], reqs[0]);
+		ahash_request_free(reqs[0]);
+	}
 	crypto_free_ahash(atfm);
 	return err;
 }
-- 
2.39.5


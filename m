Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF7C1EFF9A
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 08:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742546624; cv=none; b=qOeT3Jxs6Cdx6Vcs34LcVEjAQYMEfsOfJhQkg7rM4FvRoHpP867urY68fO02vzR5eubfeslk9OkjxS3tYB9I+S783NPNqVN16pcfdsL/HGbwjhNfA6DbR38WaqUsV69T0nqztNBm3NJmmHXDrXBTyJ8qnqQBwmgfgIAbGA7jLJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742546624; c=relaxed/simple;
	bh=n4ZDe061MaqhyPv3A/FUiUW4lX09Ax/dyz9UkmstaBA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=X3LPQ2e0AKa1FXR7LZ6+bDvb3STs+CV48Cyhuw30ksXjRpVmHR5H9s8unC3jMHKX64RgIt21OfFu9C1DwKFUJ1xmFtMaAXRQMloDgWS7Xc7PR/GgHdtwJlH4LtFyGgbIFsKjTz7tWDe/wEsQd4bnFG+meU6OLQCT+LwHhBg3pt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sTV2juYh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sTV2juYh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=uzu9fItJIi9CAHIyfUdCVKF9e+PbPmgLkaEoEvtkERk=; b=sTV2juYhKnvzvhmaecubMtrpGP
	FzXF/MSFYnX2Hp6jJxBJKDpl3tet/lR5Yges8+YJo+w1Wig8OPogqfy5e4lqCtrDMv2KAooyr3C0r
	nxkw/HvwCr9YKmvLfRVkzVwwYE9RrJU0B1JO6Xun61lpBxdwlzNZnkEeJrmo2PbktGILFsmWBIOok
	rwztdqAiwQ0fB5xvnPZEclCDqf9Ut0wjjgkFfQJl3jc9GxEfBHT11VnykB/RkFb1te2GjJ+MeIJn/
	KutqppPcM/buljO1pJxQ3VyKo9n6u9WjgLfq7TrM5eVfT6hkPo9ZcO6dIQbdeMCsknimh14AhOcE/
	xSew+ZaA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvXyU-008xvh-1v;
	Fri, 21 Mar 2025 16:43:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 16:43:30 +0800
Date: Fri, 21 Mar 2025 16:43:30 +0800
Message-Id: <4b47cfef99fbf9aaf500ff7cc9e449ac7cb35e45.1742546178.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742546178.git.herbert@gondor.apana.org.au>
References: <cover.1742546178.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/4] crypto: testmgr - Add multibuffer hash testing
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This is based on a patch by Eric Biggers <ebiggers@google.com>.

Add limited self-test for multibuffer hash code path.  This tests
only a single request in chain of a random length.  The other
requests are either all of the same length as the one being tested,
or random lengths between 0 and PAGE_SIZE * 2 * XBUFSIZE.

Potential extension include testing all requests rather than just
the single one.

Link: https://lore.kernel.org/all/20241001153718.111665-3-ebiggers@kernel.org/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c | 160 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 136 insertions(+), 24 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 140872765dcd..5694901e5242 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -58,6 +58,9 @@ module_param(fuzz_iterations, uint, 0644);
 MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
 #endif
 
+/* Multibuffer is unlimited.  Set arbitrary limit for testing. */
+#define MAX_MB_MSGS	16
+
 #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
 
 /* a perfect nop */
@@ -299,6 +302,13 @@ struct test_sg_division {
  * @key_offset_relative_to_alignmask: if true, add the algorithm's alignmask to
  *				      the @key_offset
  * @finalization_type: what finalization function to use for hashes
+ * @multibuffer: test with multibuffer
+ * @multibuffer_index: random number used to generate the message index to use
+ *		       for multibuffer.
+ * @multibuffer_uneven: test with multibuffer using uneven lengths
+ * @multibuffer_lens: random lengths to make chained request uneven
+ * @multibuffer_count: random number used to generate the num_msgs parameter
+ *		       for multibuffer
  * @nosimd: execute with SIMD disabled?  Requires !CRYPTO_TFM_REQ_MAY_SLEEP.
  *	    This applies to the parts of the operation that aren't controlled
  *	    individually by @nosimd_setkey or @src_divs[].nosimd.
@@ -318,6 +328,11 @@ struct testvec_config {
 	enum finalization_type finalization_type;
 	bool nosimd;
 	bool nosimd_setkey;
+	bool multibuffer;
+	unsigned int multibuffer_index;
+	unsigned int multibuffer_count;
+	bool multibuffer_uneven;
+	unsigned int multibuffer_lens[MAX_MB_MSGS];
 };
 
 #define TESTVEC_CONFIG_NAMELEN	192
@@ -557,6 +572,7 @@ struct test_sglist {
 	char *bufs[XBUFSIZE];
 	struct scatterlist sgl[XBUFSIZE];
 	struct scatterlist sgl_saved[XBUFSIZE];
+	struct scatterlist full_sgl[XBUFSIZE];
 	struct scatterlist *sgl_ptr;
 	unsigned int nents;
 };
@@ -670,6 +686,11 @@ static int build_test_sglist(struct test_sglist *tsgl,
 	sg_mark_end(&tsgl->sgl[tsgl->nents - 1]);
 	tsgl->sgl_ptr = tsgl->sgl;
 	memcpy(tsgl->sgl_saved, tsgl->sgl, tsgl->nents * sizeof(tsgl->sgl[0]));
+
+	sg_init_table(tsgl->full_sgl, XBUFSIZE);
+	for (i = 0; i < XBUFSIZE; i++)
+		sg_set_buf(tsgl->full_sgl, tsgl->bufs[i], PAGE_SIZE * 2);
+
 	return 0;
 }
 
@@ -1146,6 +1167,27 @@ static void generate_random_testvec_config(struct rnd_state *rng,
 		break;
 	}
 
+	if (prandom_bool(rng)) {
+		int i;
+
+		cfg->multibuffer = true;
+		cfg->multibuffer_count = prandom_u32_state(rng);
+		cfg->multibuffer_count %= MAX_MB_MSGS;
+		if (cfg->multibuffer_count++) {
+			cfg->multibuffer_index = prandom_u32_state(rng);
+			cfg->multibuffer_index %= cfg->multibuffer_count;
+		}
+
+		cfg->multibuffer_uneven = prandom_bool(rng);
+		for (i = 0; i < MAX_MB_MSGS; i++)
+			cfg->multibuffer_lens[i] =
+				generate_random_length(rng, PAGE_SIZE * 2 * XBUFSIZE);
+
+		p += scnprintf(p, end - p, " multibuffer(%d/%d%s)",
+			       cfg->multibuffer_index, cfg->multibuffer_count,
+			       cfg->multibuffer_uneven ? "/uneven" : "");
+	}
+
 	if (!(cfg->req_flags & CRYPTO_TFM_REQ_MAY_SLEEP)) {
 		if (prandom_bool(rng)) {
 			cfg->nosimd = true;
@@ -1450,6 +1492,7 @@ static int do_ahash_op(int (*op)(struct ahash_request *req),
 		       struct ahash_request *req,
 		       struct crypto_wait *wait, bool nosimd)
 {
+	struct ahash_request *r2;
 	int err;
 
 	if (nosimd)
@@ -1460,7 +1503,15 @@ static int do_ahash_op(int (*op)(struct ahash_request *req),
 	if (nosimd)
 		crypto_reenable_simd_for_test();
 
-	return crypto_wait_req(err, wait);
+	err = crypto_wait_req(err, wait);
+	if (err)
+		return err;
+
+	list_for_each_entry(r2, &req->base.list, base.list)
+		if (r2->base.err)
+			return r2->base.err;
+
+	return 0;
 }
 
 static int check_nonfinal_ahash_op(const char *op, int err,
@@ -1481,20 +1532,65 @@ static int check_nonfinal_ahash_op(const char *op, int err,
 	return 0;
 }
 
+static void setup_ahash_multibuffer(
+	struct ahash_request *reqs[MAX_MB_MSGS],
+	const struct testvec_config *cfg,
+	struct test_sglist *tsgl)
+{
+	struct scatterlist *sg = tsgl->full_sgl;
+	static u8 trash[HASH_MAX_DIGESTSIZE];
+	struct ahash_request *req = reqs[0];
+	unsigned int num_msgs;
+	unsigned int msg_idx;
+	int i;
+
+	if (!cfg->multibuffer)
+		return;
+
+	num_msgs = cfg->multibuffer_count;
+	if (num_msgs == 1)
+		return;
+
+	msg_idx = cfg->multibuffer_index;
+	for (i = 1; i < num_msgs; i++) {
+		struct ahash_request *r2 = reqs[i];
+		unsigned int nbytes = req->nbytes;
+
+		if (cfg->multibuffer_uneven)
+			nbytes = cfg->multibuffer_lens[i];
+
+		ahash_request_set_callback(r2, req->base.flags, NULL, NULL);
+		ahash_request_set_crypt(r2, sg, trash, nbytes);
+		ahash_request_chain(r2, req);
+	}
+
+	if (msg_idx) {
+		reqs[msg_idx]->src = req->src;
+		reqs[msg_idx]->nbytes = req->nbytes;
+		reqs[msg_idx]->result = req->result;
+		req->src = sg;
+		if (cfg->multibuffer_uneven)
+			req->nbytes = cfg->multibuffer_lens[0];
+		req->result = trash;
+	}
+}
+
 /* Test one hash test vector in one configuration, using the ahash API */
 static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 			      const char *vec_name,
 			      const struct testvec_config *cfg,
-			      struct ahash_request *req,
+			      struct ahash_request *reqs[MAX_MB_MSGS],
 			      struct test_sglist *tsgl,
 			      u8 *hashstate)
 {
+	struct ahash_request *req = reqs[0];
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
 	const unsigned int statesize = crypto_ahash_statesize(tfm);
 	const char *driver = crypto_ahash_driver_name(tfm);
 	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
 	const struct test_sg_division *divs[XBUFSIZE];
+	struct ahash_request *reqi = req;
 	DECLARE_CRYPTO_WAIT(wait);
 	unsigned int i;
 	struct scatterlist *pending_sgl;
@@ -1502,6 +1598,9 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 	u8 result[HASH_MAX_DIGESTSIZE + TESTMGR_POISON_LEN];
 	int err;
 
+	if (cfg->multibuffer)
+		reqi = reqs[cfg->multibuffer_index];
+
 	/* Set the key, if specified */
 	if (vec->ksize) {
 		err = do_setkey(crypto_ahash_setkey, tfm, vec->key, vec->ksize,
@@ -1531,7 +1630,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 
 	/* Do the actual hashing */
 
-	testmgr_poison(req->__ctx, crypto_ahash_reqsize(tfm));
+	testmgr_poison(reqi->__ctx, crypto_ahash_reqsize(tfm));
 	testmgr_poison(result, digestsize + TESTMGR_POISON_LEN);
 
 	if (cfg->finalization_type == FINALIZATION_TYPE_DIGEST ||
@@ -1540,6 +1639,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 		ahash_request_set_callback(req, req_flags, crypto_req_done,
 					   &wait);
 		ahash_request_set_crypt(req, tsgl->sgl, result, vec->psize);
+		setup_ahash_multibuffer(reqs, cfg, tsgl);
 		err = do_ahash_op(crypto_ahash_digest, req, &wait, cfg->nosimd);
 		if (err) {
 			if (err == vec->digest_error)
@@ -1561,6 +1661,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 
 	ahash_request_set_callback(req, req_flags, crypto_req_done, &wait);
 	ahash_request_set_crypt(req, NULL, result, 0);
+	setup_ahash_multibuffer(reqs, cfg, tsgl);
 	err = do_ahash_op(crypto_ahash_init, req, &wait, cfg->nosimd);
 	err = check_nonfinal_ahash_op("init", err, result, digestsize,
 				      driver, vec_name, cfg);
@@ -1577,6 +1678,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 						   crypto_req_done, &wait);
 			ahash_request_set_crypt(req, pending_sgl, result,
 						pending_len);
+			setup_ahash_multibuffer(reqs, cfg, tsgl);
 			err = do_ahash_op(crypto_ahash_update, req, &wait,
 					  divs[i]->nosimd);
 			err = check_nonfinal_ahash_op("update", err,
@@ -1591,7 +1693,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 			/* Test ->export() and ->import() */
 			testmgr_poison(hashstate + statesize,
 				       TESTMGR_POISON_LEN);
-			err = crypto_ahash_export(req, hashstate);
+			err = crypto_ahash_export(reqi, hashstate);
 			err = check_nonfinal_ahash_op("export", err,
 						      result, digestsize,
 						      driver, vec_name, cfg);
@@ -1604,8 +1706,8 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 				return -EOVERFLOW;
 			}
 
-			testmgr_poison(req->__ctx, crypto_ahash_reqsize(tfm));
-			err = crypto_ahash_import(req, hashstate);
+			testmgr_poison(reqi->__ctx, crypto_ahash_reqsize(tfm));
+			err = crypto_ahash_import(reqi, hashstate);
 			err = check_nonfinal_ahash_op("import", err,
 						      result, digestsize,
 						      driver, vec_name, cfg);
@@ -1619,6 +1721,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 
 	ahash_request_set_callback(req, req_flags, crypto_req_done, &wait);
 	ahash_request_set_crypt(req, pending_sgl, result, pending_len);
+	setup_ahash_multibuffer(reqs, cfg, tsgl);
 	if (cfg->finalization_type == FINALIZATION_TYPE_FINAL) {
 		/* finish with update() and final() */
 		err = do_ahash_op(crypto_ahash_update, req, &wait, cfg->nosimd);
@@ -1650,7 +1753,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 static int test_hash_vec_cfg(const struct hash_testvec *vec,
 			     const char *vec_name,
 			     const struct testvec_config *cfg,
-			     struct ahash_request *req,
+			     struct ahash_request *reqs[MAX_MB_MSGS],
 			     struct shash_desc *desc,
 			     struct test_sglist *tsgl,
 			     u8 *hashstate)
@@ -1670,11 +1773,12 @@ static int test_hash_vec_cfg(const struct hash_testvec *vec,
 			return err;
 	}
 
-	return test_ahash_vec_cfg(vec, vec_name, cfg, req, tsgl, hashstate);
+	return test_ahash_vec_cfg(vec, vec_name, cfg, reqs, tsgl, hashstate);
 }
 
 static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
-			 struct ahash_request *req, struct shash_desc *desc,
+			 struct ahash_request *reqs[MAX_MB_MSGS],
+			 struct shash_desc *desc,
 			 struct test_sglist *tsgl, u8 *hashstate)
 {
 	char vec_name[16];
@@ -1686,7 +1790,7 @@ static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
 	for (i = 0; i < ARRAY_SIZE(default_hash_testvec_configs); i++) {
 		err = test_hash_vec_cfg(vec, vec_name,
 					&default_hash_testvec_configs[i],
-					req, desc, tsgl, hashstate);
+					reqs, desc, tsgl, hashstate);
 		if (err)
 			return err;
 	}
@@ -1703,7 +1807,7 @@ static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
 			generate_random_testvec_config(&rng, &cfg, cfgname,
 						       sizeof(cfgname));
 			err = test_hash_vec_cfg(vec, vec_name, &cfg,
-						req, desc, tsgl, hashstate);
+						reqs, desc, tsgl, hashstate);
 			if (err)
 				return err;
 			cond_resched();
@@ -1762,11 +1866,12 @@ static void generate_random_hash_testvec(struct rnd_state *rng,
  */
 static int test_hash_vs_generic_impl(const char *generic_driver,
 				     unsigned int maxkeysize,
-				     struct ahash_request *req,
+				     struct ahash_request *reqs[MAX_MB_MSGS],
 				     struct shash_desc *desc,
 				     struct test_sglist *tsgl,
 				     u8 *hashstate)
 {
+	struct ahash_request *req = reqs[0];
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
 	const unsigned int blocksize = crypto_ahash_blocksize(tfm);
@@ -1864,7 +1969,7 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 					       sizeof(cfgname));
 
 		err = test_hash_vec_cfg(&vec, vec_name, cfg,
-					req, desc, tsgl, hashstate);
+					reqs, desc, tsgl, hashstate);
 		if (err)
 			goto out;
 		cond_resched();
@@ -1882,7 +1987,7 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 #else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 static int test_hash_vs_generic_impl(const char *generic_driver,
 				     unsigned int maxkeysize,
-				     struct ahash_request *req,
+				     struct ahash_request *reqs[MAX_MB_MSGS],
 				     struct shash_desc *desc,
 				     struct test_sglist *tsgl,
 				     u8 *hashstate)
@@ -1929,8 +2034,8 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 			   u32 type, u32 mask,
 			   const char *generic_driver, unsigned int maxkeysize)
 {
+	struct ahash_request *reqs[MAX_MB_MSGS] = {};
 	struct crypto_ahash *atfm = NULL;
-	struct ahash_request *req = NULL;
 	struct crypto_shash *stfm = NULL;
 	struct shash_desc *desc = NULL;
 	struct test_sglist *tsgl = NULL;
@@ -1954,12 +2059,14 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	}
 	driver = crypto_ahash_driver_name(atfm);
 
-	req = ahash_request_alloc(atfm, GFP_KERNEL);
-	if (!req) {
-		pr_err("alg: hash: failed to allocate request for %s\n",
-		       driver);
-		err = -ENOMEM;
-		goto out;
+	for (i = 0; i < MAX_MB_MSGS; i++) {
+		reqs[i] = ahash_request_alloc(atfm, GFP_KERNEL);
+		if (!reqs[i]) {
+			pr_err("alg: hash: failed to allocate request for %s\n",
+			       driver);
+			err = -ENOMEM;
+			goto out;
+		}
 	}
 
 	/*
@@ -1995,12 +2102,12 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
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
@@ -2010,7 +2117,12 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	}
 	kfree(desc);
 	crypto_free_shash(stfm);
-	ahash_request_free(req);
+	if (reqs[0]) {
+		ahash_request_set_callback(reqs[0], 0, NULL, NULL);
+		for (i = 1; i < MAX_MB_MSGS && reqs[i]; i++)
+			ahash_request_chain(reqs[i], reqs[0]);
+		ahash_request_free(reqs[0]);
+	}
 	crypto_free_ahash(atfm);
 	return err;
 }
-- 
2.39.5


Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3802F24;
	Sun, 30 Mar 2025 01:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743299045; cv=none; b=ozYAgrNJEeZrShqFKDvPI7S0n1XMh6TdfFxf0cFNdnjAaXpTRiSW0AyDlsLi6BTC9pblCjw8EQiou43ZL3EN/NU40DGIDsIAVIMNtlKLbWNWPElKSgIR9LQlb2yxwyf/VpJrrQ/OajMXxWL/jitqi1cYilKGh/mO6pHM0PGuAdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743299045; c=relaxed/simple;
	bh=q0JgxsA70ur2LSUYqAHYtht6Q4LvLkygIc1TnIcLsA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GTdUPYMgOtmtW2hzm6KsrO9PN5rLGsU7CAeQBoXPucFqey4d7Ye5A5jh7j1+aNtR0JliDDZkZgSNZ+SVZwjyRBI5fClrPjWCUvMJ5vbvFWE3DM+etZ9n+idi5MXi6+6MZFDNayqZrxxhyA6iEErBNoKNYy6ZjjQWb7fZi2NpKvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ERPN0296; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ERPN0296"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/DXWsN0Dr889Hf9khoNk9VARb6cbpuCUe0xmbyA6i4I=; b=ERPN0296qysxR2J45SQc09+q+5
	hj0ryedijafW5y67CwS/JiL7+JGN3TCWkkINK7LPCCwlINkdy9D+/EdUQCTag6BDZNPN0CGlvRqQH
	S3R8acfVh8dLgNmK3skJUu9y/oTArRf8g9xiYo/lB1ShywUgLkF+NDUZaq2v/550+plTTe+uVI5YZ
	tOgH4B76Api88S/uVBfDFAWjBpCXKxgYSML6d5YMGHJX9M/o0nmbe08MmfBDpj8nlTfTty/ZG/Bmx
	4SGaclf1X6eMpiWoQFNvfXajqYxZuPg/p3wFi1VtkfjlphTp7jMQHWUXnQbd98oQE5WebEpN+F5/8
	smfjgyWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tyhiO-00BHZm-1d;
	Sun, 30 Mar 2025 09:43:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 30 Mar 2025 09:43:56 +0800
Date: Sun, 30 Mar 2025 09:43:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-crypto@vger.kernel.org,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: [PATCH] Revert "crypto: testmgr - Add multibuffer hash testing"
Message-ID: <Z-ih3Hqf8eNlAc-U@gondor.apana.org.au>
References: <202503281658.7a078821-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202503281658.7a078821-lkp@intel.com>

On Fri, Mar 28, 2025 at 04:51:38PM +0800, kernel test robot wrote:
> 
> kernel test robot noticed "WARNING:at_crypto/testmgr.c:#alg_test" on:
> 
> commit: 8b54e6a8f4156ed43627f40300b0711dc977fbc1 ("crypto: testmgr - Add multibuffer hash testing")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master db8da9da41bced445077925f8a886c776a47440c]

---8<---
This reverts commit 8b54e6a8f4156ed43627f40300b0711dc977fbc1.

The multibuffer tests has a number of bugs.  For example, the SG
lists for the filler requests weren't initialised properly, and
it fails to take data-keyed algorithms such as poly1305 into account.

More importantly, the chaining interface itself is under review.
Revert this until the interface is fully settled.

Reported-by: Manorit Chawdhry <m-chawdhry@ti.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202503281658.7a078821-lkp@intel.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c | 157 ++++++++---------------------------------------
 1 file changed, 24 insertions(+), 133 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index cd0f6a778b62..2c7fc4c94c04 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -302,13 +302,6 @@ struct test_sg_division {
  * @key_offset_relative_to_alignmask: if true, add the algorithm's alignmask to
  *				      the @key_offset
  * @finalization_type: what finalization function to use for hashes
- * @multibuffer: test with multibuffer
- * @multibuffer_index: random number used to generate the message index to use
- *		       for multibuffer.
- * @multibuffer_uneven: test with multibuffer using uneven lengths
- * @multibuffer_lens: random lengths to make chained request uneven
- * @multibuffer_count: random number used to generate the num_msgs parameter
- *		       for multibuffer
  * @nosimd: execute with SIMD disabled?  Requires !CRYPTO_TFM_REQ_MAY_SLEEP.
  *	    This applies to the parts of the operation that aren't controlled
  *	    individually by @nosimd_setkey or @src_divs[].nosimd.
@@ -328,11 +321,6 @@ struct testvec_config {
 	enum finalization_type finalization_type;
 	bool nosimd;
 	bool nosimd_setkey;
-	bool multibuffer;
-	unsigned int multibuffer_index;
-	unsigned int multibuffer_count;
-	bool multibuffer_uneven;
-	unsigned int multibuffer_lens[MAX_MB_MSGS];
 };
 
 #define TESTVEC_CONFIG_NAMELEN	192
@@ -572,7 +560,6 @@ struct test_sglist {
 	char *bufs[XBUFSIZE];
 	struct scatterlist sgl[XBUFSIZE];
 	struct scatterlist sgl_saved[XBUFSIZE];
-	struct scatterlist full_sgl[XBUFSIZE];
 	struct scatterlist *sgl_ptr;
 	unsigned int nents;
 };
@@ -686,11 +673,6 @@ static int build_test_sglist(struct test_sglist *tsgl,
 	sg_mark_end(&tsgl->sgl[tsgl->nents - 1]);
 	tsgl->sgl_ptr = tsgl->sgl;
 	memcpy(tsgl->sgl_saved, tsgl->sgl, tsgl->nents * sizeof(tsgl->sgl[0]));
-
-	sg_init_table(tsgl->full_sgl, XBUFSIZE);
-	for (i = 0; i < XBUFSIZE; i++)
-		sg_set_buf(tsgl->full_sgl, tsgl->bufs[i], PAGE_SIZE * 2);
-
 	return 0;
 }
 
@@ -1167,27 +1149,6 @@ static void generate_random_testvec_config(struct rnd_state *rng,
 		break;
 	}
 
-	if (prandom_bool(rng)) {
-		int i;
-
-		cfg->multibuffer = true;
-		cfg->multibuffer_count = prandom_u32_state(rng);
-		cfg->multibuffer_count %= MAX_MB_MSGS;
-		if (cfg->multibuffer_count++) {
-			cfg->multibuffer_index = prandom_u32_state(rng);
-			cfg->multibuffer_index %= cfg->multibuffer_count;
-		}
-
-		cfg->multibuffer_uneven = prandom_bool(rng);
-		for (i = 0; i < MAX_MB_MSGS; i++)
-			cfg->multibuffer_lens[i] =
-				generate_random_length(rng, PAGE_SIZE * 2 * XBUFSIZE);
-
-		p += scnprintf(p, end - p, " multibuffer(%d/%d%s)",
-			       cfg->multibuffer_index, cfg->multibuffer_count,
-			       cfg->multibuffer_uneven ? "/uneven" : "");
-	}
-
 	if (!(cfg->req_flags & CRYPTO_TFM_REQ_MAY_SLEEP)) {
 		if (prandom_bool(rng)) {
 			cfg->nosimd = true;
@@ -1492,7 +1453,6 @@ static int do_ahash_op(int (*op)(struct ahash_request *req),
 		       struct ahash_request *req,
 		       struct crypto_wait *wait, bool nosimd)
 {
-	struct ahash_request *r2;
 	int err;
 
 	if (nosimd)
@@ -1503,15 +1463,7 @@ static int do_ahash_op(int (*op)(struct ahash_request *req),
 	if (nosimd)
 		crypto_reenable_simd_for_test();
 
-	err = crypto_wait_req(err, wait);
-	if (err)
-		return err;
-
-	list_for_each_entry(r2, &req->base.list, base.list)
-		if (r2->base.err)
-			return r2->base.err;
-
-	return 0;
+	return crypto_wait_req(err, wait);
 }
 
 static int check_nonfinal_ahash_op(const char *op, int err,
@@ -1532,65 +1484,20 @@ static int check_nonfinal_ahash_op(const char *op, int err,
 	return 0;
 }
 
-static void setup_ahash_multibuffer(
-	struct ahash_request *reqs[MAX_MB_MSGS],
-	const struct testvec_config *cfg,
-	struct test_sglist *tsgl)
-{
-	struct scatterlist *sg = tsgl->full_sgl;
-	static u8 trash[HASH_MAX_DIGESTSIZE];
-	struct ahash_request *req = reqs[0];
-	unsigned int num_msgs;
-	unsigned int msg_idx;
-	int i;
-
-	if (!cfg->multibuffer)
-		return;
-
-	num_msgs = cfg->multibuffer_count;
-	if (num_msgs == 1)
-		return;
-
-	msg_idx = cfg->multibuffer_index;
-	for (i = 1; i < num_msgs; i++) {
-		struct ahash_request *r2 = reqs[i];
-		unsigned int nbytes = req->nbytes;
-
-		if (cfg->multibuffer_uneven)
-			nbytes = cfg->multibuffer_lens[i];
-
-		ahash_request_set_callback(r2, req->base.flags, NULL, NULL);
-		ahash_request_set_crypt(r2, sg, trash, nbytes);
-		ahash_request_chain(r2, req);
-	}
-
-	if (msg_idx) {
-		reqs[msg_idx]->src = req->src;
-		reqs[msg_idx]->nbytes = req->nbytes;
-		reqs[msg_idx]->result = req->result;
-		req->src = sg;
-		if (cfg->multibuffer_uneven)
-			req->nbytes = cfg->multibuffer_lens[0];
-		req->result = trash;
-	}
-}
-
 /* Test one hash test vector in one configuration, using the ahash API */
 static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 			      const char *vec_name,
 			      const struct testvec_config *cfg,
-			      struct ahash_request *reqs[MAX_MB_MSGS],
+			      struct ahash_request *req,
 			      struct test_sglist *tsgl,
 			      u8 *hashstate)
 {
-	struct ahash_request *req = reqs[0];
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
 	const unsigned int statesize = crypto_ahash_statesize(tfm);
 	const char *driver = crypto_ahash_driver_name(tfm);
 	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
 	const struct test_sg_division *divs[XBUFSIZE];
-	struct ahash_request *reqi = req;
 	DECLARE_CRYPTO_WAIT(wait);
 	unsigned int i;
 	struct scatterlist *pending_sgl;
@@ -1598,9 +1505,6 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 	u8 result[HASH_MAX_DIGESTSIZE + TESTMGR_POISON_LEN];
 	int err;
 
-	if (cfg->multibuffer)
-		reqi = reqs[cfg->multibuffer_index];
-
 	/* Set the key, if specified */
 	if (vec->ksize) {
 		err = do_setkey(crypto_ahash_setkey, tfm, vec->key, vec->ksize,
@@ -1630,7 +1534,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 
 	/* Do the actual hashing */
 
-	testmgr_poison(reqi->__ctx, crypto_ahash_reqsize(tfm));
+	testmgr_poison(req->__ctx, crypto_ahash_reqsize(tfm));
 	testmgr_poison(result, digestsize + TESTMGR_POISON_LEN);
 
 	if (cfg->finalization_type == FINALIZATION_TYPE_DIGEST ||
@@ -1639,7 +1543,6 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 		ahash_request_set_callback(req, req_flags, crypto_req_done,
 					   &wait);
 		ahash_request_set_crypt(req, tsgl->sgl, result, vec->psize);
-		setup_ahash_multibuffer(reqs, cfg, tsgl);
 		err = do_ahash_op(crypto_ahash_digest, req, &wait, cfg->nosimd);
 		if (err) {
 			if (err == vec->digest_error)
@@ -1661,7 +1564,6 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 
 	ahash_request_set_callback(req, req_flags, crypto_req_done, &wait);
 	ahash_request_set_crypt(req, NULL, result, 0);
-	setup_ahash_multibuffer(reqs, cfg, tsgl);
 	err = do_ahash_op(crypto_ahash_init, req, &wait, cfg->nosimd);
 	err = check_nonfinal_ahash_op("init", err, result, digestsize,
 				      driver, vec_name, cfg);
@@ -1678,7 +1580,6 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 						   crypto_req_done, &wait);
 			ahash_request_set_crypt(req, pending_sgl, result,
 						pending_len);
-			setup_ahash_multibuffer(reqs, cfg, tsgl);
 			err = do_ahash_op(crypto_ahash_update, req, &wait,
 					  divs[i]->nosimd);
 			err = check_nonfinal_ahash_op("update", err,
@@ -1693,7 +1594,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 			/* Test ->export() and ->import() */
 			testmgr_poison(hashstate + statesize,
 				       TESTMGR_POISON_LEN);
-			err = crypto_ahash_export(reqi, hashstate);
+			err = crypto_ahash_export(req, hashstate);
 			err = check_nonfinal_ahash_op("export", err,
 						      result, digestsize,
 						      driver, vec_name, cfg);
@@ -1706,8 +1607,8 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 				return -EOVERFLOW;
 			}
 
-			testmgr_poison(reqi->__ctx, crypto_ahash_reqsize(tfm));
-			err = crypto_ahash_import(reqi, hashstate);
+			testmgr_poison(req->__ctx, crypto_ahash_reqsize(tfm));
+			err = crypto_ahash_import(req, hashstate);
 			err = check_nonfinal_ahash_op("import", err,
 						      result, digestsize,
 						      driver, vec_name, cfg);
@@ -1721,7 +1622,6 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 
 	ahash_request_set_callback(req, req_flags, crypto_req_done, &wait);
 	ahash_request_set_crypt(req, pending_sgl, result, pending_len);
-	setup_ahash_multibuffer(reqs, cfg, tsgl);
 	if (cfg->finalization_type == FINALIZATION_TYPE_FINAL) {
 		/* finish with update() and final() */
 		err = do_ahash_op(crypto_ahash_update, req, &wait, cfg->nosimd);
@@ -1753,7 +1653,7 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 static int test_hash_vec_cfg(const struct hash_testvec *vec,
 			     const char *vec_name,
 			     const struct testvec_config *cfg,
-			     struct ahash_request *reqs[MAX_MB_MSGS],
+			     struct ahash_request *req,
 			     struct shash_desc *desc,
 			     struct test_sglist *tsgl,
 			     u8 *hashstate)
@@ -1773,12 +1673,11 @@ static int test_hash_vec_cfg(const struct hash_testvec *vec,
 			return err;
 	}
 
-	return test_ahash_vec_cfg(vec, vec_name, cfg, reqs, tsgl, hashstate);
+	return test_ahash_vec_cfg(vec, vec_name, cfg, req, tsgl, hashstate);
 }
 
 static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
-			 struct ahash_request *reqs[MAX_MB_MSGS],
-			 struct shash_desc *desc,
+			 struct ahash_request *req, struct shash_desc *desc,
 			 struct test_sglist *tsgl, u8 *hashstate)
 {
 	char vec_name[16];
@@ -1790,7 +1689,7 @@ static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
 	for (i = 0; i < ARRAY_SIZE(default_hash_testvec_configs); i++) {
 		err = test_hash_vec_cfg(vec, vec_name,
 					&default_hash_testvec_configs[i],
-					reqs, desc, tsgl, hashstate);
+					req, desc, tsgl, hashstate);
 		if (err)
 			return err;
 	}
@@ -1807,7 +1706,7 @@ static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
 			generate_random_testvec_config(&rng, &cfg, cfgname,
 						       sizeof(cfgname));
 			err = test_hash_vec_cfg(vec, vec_name, &cfg,
-						reqs, desc, tsgl, hashstate);
+						req, desc, tsgl, hashstate);
 			if (err)
 				return err;
 			cond_resched();
@@ -1866,12 +1765,11 @@ static void generate_random_hash_testvec(struct rnd_state *rng,
  */
 static int test_hash_vs_generic_impl(const char *generic_driver,
 				     unsigned int maxkeysize,
-				     struct ahash_request *reqs[MAX_MB_MSGS],
+				     struct ahash_request *req,
 				     struct shash_desc *desc,
 				     struct test_sglist *tsgl,
 				     u8 *hashstate)
 {
-	struct ahash_request *req = reqs[0];
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
 	const unsigned int blocksize = crypto_ahash_blocksize(tfm);
@@ -1969,7 +1867,7 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 					       sizeof(cfgname));
 
 		err = test_hash_vec_cfg(&vec, vec_name, cfg,
-					reqs, desc, tsgl, hashstate);
+					req, desc, tsgl, hashstate);
 		if (err)
 			goto out;
 		cond_resched();
@@ -1987,7 +1885,7 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 #else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 static int test_hash_vs_generic_impl(const char *generic_driver,
 				     unsigned int maxkeysize,
-				     struct ahash_request *reqs[MAX_MB_MSGS],
+				     struct ahash_request *req,
 				     struct shash_desc *desc,
 				     struct test_sglist *tsgl,
 				     u8 *hashstate)
@@ -2034,8 +1932,8 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 			   u32 type, u32 mask,
 			   const char *generic_driver, unsigned int maxkeysize)
 {
-	struct ahash_request *reqs[MAX_MB_MSGS] = {};
 	struct crypto_ahash *atfm = NULL;
+	struct ahash_request *req = NULL;
 	struct crypto_shash *stfm = NULL;
 	struct shash_desc *desc = NULL;
 	struct test_sglist *tsgl = NULL;
@@ -2059,14 +1957,12 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	}
 	driver = crypto_ahash_driver_name(atfm);
 
-	for (i = 0; i < MAX_MB_MSGS; i++) {
-		reqs[i] = ahash_request_alloc(atfm, GFP_KERNEL);
-		if (!reqs[i]) {
-			pr_err("alg: hash: failed to allocate request for %s\n",
-			       driver);
-			err = -ENOMEM;
-			goto out;
-		}
+	req = ahash_request_alloc(atfm, GFP_KERNEL);
+	if (!req) {
+		pr_err("alg: hash: failed to allocate request for %s\n",
+		       driver);
+		err = -ENOMEM;
+		goto out;
 	}
 
 	/*
@@ -2102,12 +1998,12 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 		if (fips_enabled && vecs[i].fips_skip)
 			continue;
 
-		err = test_hash_vec(&vecs[i], i, reqs, desc, tsgl, hashstate);
+		err = test_hash_vec(&vecs[i], i, req, desc, tsgl, hashstate);
 		if (err)
 			goto out;
 		cond_resched();
 	}
-	err = test_hash_vs_generic_impl(generic_driver, maxkeysize, reqs,
+	err = test_hash_vs_generic_impl(generic_driver, maxkeysize, req,
 					desc, tsgl, hashstate);
 out:
 	kfree(hashstate);
@@ -2117,12 +2013,7 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	}
 	kfree(desc);
 	crypto_free_shash(stfm);
-	if (reqs[0]) {
-		ahash_request_set_callback(reqs[0], 0, NULL, NULL);
-		for (i = 1; i < MAX_MB_MSGS && reqs[i]; i++)
-			ahash_request_chain(reqs[i], reqs[0]);
-		ahash_request_free(reqs[0]);
-	}
+	ahash_request_free(req);
 	crypto_free_ahash(atfm);
 	return err;
 }
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6D2229B3D
	for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 09:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747214575; cv=none; b=TIdW6AhayrhvCoFFszdudiBl1aXLgHOFqynqzWUzYR/9IHWRD7VIfrtGbcYsn/DV2luJ7XZ9TmIwlNe9mFX53lcZTysWKBCeFSGGSzrozCbG8UsoE3IfRTR2L3MOdTP0G6gDf97FKjmDlcl3fb8gobS3kVd3ZyF/URNyt2mHBdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747214575; c=relaxed/simple;
	bh=ayIlfUnE2QVjqjOQj3rM75wLwfSIyhQz0iNpm7z7cZo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=TDE7Plqf8MpREgx8gEUBv71dg2bjMxhZxWUfVxHUrwEm2bcP12Guo/rqpDArGdUdftAetXY90ttSYgOcYPkmNHXN267/HSyH5lehV/dx2SxO5CrxbYMND6LW0H+4XQ1VuKyGcXpQHTuoq9Eu+o4VD7xh7kLNLM9GOqdAtzDz2I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=g2u7t5Iz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="g2u7t5Iz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aQbTrCOrXS9mMcgSw761bt1XDmWS783itWz8mHdG+74=; b=g2u7t5Ize8px6qKm+jSMi9SWjL
	u2HOMHB6D2XNmgTWKCkfd8uzVvBKySyCyDLc9WkIiVAhaxLtM2+aKCAWTPC+1Uf90nz+FhOvQ2xwk
	Jm9F+B38ZdAIl2mJAcFGxMeYlUfPpROP8xh1qfnipARaLt2JMR4CD+JB7dVKTGH+RehzV/pUt8slC
	ExAieaQ7+RZ23kJ+EaW2lFlWYXhtyy/tiDVzfG2ofNwql/h3qUOdTg3cSAMMJwfVx0ks97KU7Gu33
	wh+5/OtFZLT3czlag/pN7LsNDK9uh8/8HV5SsFuEW6lzF+Kl/CcleQf+lkauthImtUra1537MQu08
	mEknz58w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF8KA-0060Ln-0y;
	Wed, 14 May 2025 17:22:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 17:22:50 +0800
Date: Wed, 14 May 2025 17:22:50 +0800
Message-Id: <730e4556aa0ec6e33670ffd77c0305727f13bd59.1747214319.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747214319.git.herbert@gondor.apana.org.au>
References: <cover.1747214319.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 10/11] crypto: testmgr - Use ahash for generic tfm
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As shash is being phased out, use ahash for the generic tfm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index fc28000c27f5..557ec5b1656a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1699,7 +1699,7 @@ static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
  * Assumes the buffers in 'vec' were already allocated.
  */
 static void generate_random_hash_testvec(struct rnd_state *rng,
-					 struct shash_desc *desc,
+					 struct ahash_request *req,
 					 struct hash_testvec *vec,
 					 unsigned int maxkeysize,
 					 unsigned int maxdatasize,
@@ -1721,16 +1721,17 @@ static void generate_random_hash_testvec(struct rnd_state *rng,
 			vec->ksize = prandom_u32_inclusive(rng, 1, maxkeysize);
 		generate_random_bytes(rng, (u8 *)vec->key, vec->ksize);
 
-		vec->setkey_error = crypto_shash_setkey(desc->tfm, vec->key,
-							vec->ksize);
+		vec->setkey_error = crypto_ahash_setkey(
+			crypto_ahash_reqtfm(req), vec->key, vec->ksize);
 		/* If the key couldn't be set, no need to continue to digest. */
 		if (vec->setkey_error)
 			goto done;
 	}
 
 	/* Digest */
-	vec->digest_error = crypto_shash_digest(desc, vec->plaintext,
-						vec->psize, (u8 *)vec->digest);
+	vec->digest_error = crypto_hash_digest(
+		crypto_ahash_reqtfm(req), vec->plaintext,
+		vec->psize, (u8 *)vec->digest);
 done:
 	snprintf(name, max_namelen, "\"random: psize=%u ksize=%u\"",
 		 vec->psize, vec->ksize);
@@ -1755,8 +1756,8 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 	const char *driver = crypto_ahash_driver_name(tfm);
 	struct rnd_state rng;
 	char _generic_driver[CRYPTO_MAX_ALG_NAME];
-	struct crypto_shash *generic_tfm = NULL;
-	struct shash_desc *generic_desc = NULL;
+	struct ahash_request *generic_req = NULL;
+	struct crypto_ahash *generic_tfm = NULL;
 	unsigned int i;
 	struct hash_testvec vec = { 0 };
 	char vec_name[64];
@@ -1779,7 +1780,7 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 	if (strcmp(generic_driver, driver) == 0) /* Already the generic impl? */
 		return 0;
 
-	generic_tfm = crypto_alloc_shash(generic_driver, 0, 0);
+	generic_tfm = crypto_alloc_ahash(generic_driver, 0, 0);
 	if (IS_ERR(generic_tfm)) {
 		err = PTR_ERR(generic_tfm);
 		if (err == -ENOENT) {
@@ -1798,27 +1799,25 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 		goto out;
 	}
 
-	generic_desc = kzalloc(sizeof(*desc) +
-			       crypto_shash_descsize(generic_tfm), GFP_KERNEL);
-	if (!generic_desc) {
+	generic_req = ahash_request_alloc(generic_tfm, GFP_KERNEL);
+	if (!generic_req) {
 		err = -ENOMEM;
 		goto out;
 	}
-	generic_desc->tfm = generic_tfm;
 
 	/* Check the algorithm properties for consistency. */
 
-	if (digestsize != crypto_shash_digestsize(generic_tfm)) {
+	if (digestsize != crypto_ahash_digestsize(generic_tfm)) {
 		pr_err("alg: hash: digestsize for %s (%u) doesn't match generic impl (%u)\n",
 		       driver, digestsize,
-		       crypto_shash_digestsize(generic_tfm));
+		       crypto_ahash_digestsize(generic_tfm));
 		err = -EINVAL;
 		goto out;
 	}
 
-	if (blocksize != crypto_shash_blocksize(generic_tfm)) {
+	if (blocksize != crypto_ahash_blocksize(generic_tfm)) {
 		pr_err("alg: hash: blocksize for %s (%u) doesn't match generic impl (%u)\n",
-		       driver, blocksize, crypto_shash_blocksize(generic_tfm));
+		       driver, blocksize, crypto_ahash_blocksize(generic_tfm));
 		err = -EINVAL;
 		goto out;
 	}
@@ -1837,7 +1836,7 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 	}
 
 	for (i = 0; i < fuzz_iterations * 8; i++) {
-		generate_random_hash_testvec(&rng, generic_desc, &vec,
+		generate_random_hash_testvec(&rng, generic_req, &vec,
 					     maxkeysize, maxdatasize,
 					     vec_name, sizeof(vec_name));
 		generate_random_testvec_config(&rng, cfg, cfgname,
@@ -1855,8 +1854,8 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 	kfree(vec.key);
 	kfree(vec.plaintext);
 	kfree(vec.digest);
-	crypto_free_shash(generic_tfm);
-	kfree_sensitive(generic_desc);
+	ahash_request_free(generic_req);
+	crypto_free_ahash(generic_tfm);
 	return err;
 }
 
-- 
2.39.5


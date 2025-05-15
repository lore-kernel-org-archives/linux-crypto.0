Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A92295520
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 05:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747288499; cv=none; b=KEX9Mukiqz6K0mrNfbhyyvBUwooXS9jB1LiMT6SCXTXmvqcIsV6eEwp/mrc97y9lFy/wyAbDAVsrTgCdkLh2eWYTTns/EhYJ9HGVxVjj2FMdbl+sfQ5Ht21WLn0MroeV2o80ti3o8sHM4TY0+18nlAeM8ib4iYdMdW8As5adfd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747288499; c=relaxed/simple;
	bh=l97SICDS4n2BfyLkDeOiJyjKWtBfUIfymEFvsHb1olA=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=IUZSwiRMRKUhyOupbxKYcuLb6iyrlkxSdUVzS98gwLl12O1Sr68C01Fz6R64yIvHn9vr1qoOd3pH+OKQTuQcJqqWmFpujhERxt63A+zHPDsqJb16v3W3ngpHwPCPrBqY16Rc6LeOwrX8bPxnGU5c8HK6huMB8VjJKWr0Q9hcCoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aSXXu8mv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aSXXu8mv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mVzgjyJaVC/87ThlVSSH2h5NE65EruqJ8lNvj3NdwOg=; b=aSXXu8mvugelBHYkMdZSF0XVPW
	MFG0fzPMIfWvf/kvTRbx2JnzzdoFo3BOb4mI+rIWgFRpfeNIo+5Sow7mrqqxKyzoi0b7eDqCTdtpw
	8lKZ5Srz+DvPoeeBpWi7Eytp68lH/OEi+q8m8vhPij/j4VMqVbsPaJmIihLYENRJ6QVsiWQGn8Iwo
	B290tZK0ka7RHTqlKM0P6GSY7NKlj7nYXH/fX+tGoWvYj3SpHsFriOkuqxfkU1zRQvFTK041+48wH
	7zfnGemU5EqxmHXIs1spPcjSmk/OIJAAF8KbLcKG37tCddppEnqpzQQ2fE8EeW/qcrdkLC/NZKYbn
	MeKMcIAQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFRYU-006EdE-0P;
	Thu, 15 May 2025 13:54:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 13:54:54 +0800
Date: Thu, 15 May 2025 13:54:54 +0800
Message-Id: <8d8aca050771f8237895e38240a8bc2fe91207b1.1747288315.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747288315.git.herbert@gondor.apana.org.au>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 10/11] crypto: testmgr - Use ahash for generic tfm
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
index ee682ad50e34..72005074a5c2 100644
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


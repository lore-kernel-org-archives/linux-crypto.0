Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3BF296723
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 05:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747288502; cv=none; b=fUE8KgBkqtpOZRVcNoH+nc+5MZZ2jR92mtDRyhBF29olela8ri/dpizpjlr4USMHusyH4xDwe1E4wXhk/cfxXqw5vhxd1CTCK5yyTLoOhMbDOJ2yltNDyNOcKsN2GxlRDSOtnt9pAA/Y6TEC+eTu+9jK1p25QDQp9rWy4GgDbbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747288502; c=relaxed/simple;
	bh=yGojNx+jIzm4WCoo2V3X+9dEe0YPK+/V2ejrOhkNL98=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=h35KdhPHgheFYsNO7PQuLZk7VJ00TTUh8bF6Kl0zAY7Z6s3+CLta52srTwZj25vlSDTeVpgJod8ULicPMTajBMu292ep41QYPDeB9v6ImX2aTIHhuLYwavTPggmhHdI4roNrplsYKr2vVJWyOEJoBunpOTmK/owYioyaBfbDsgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mFNFLTAY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mFNFLTAY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OID+Vxpihm66ngBrcJBT7zrUr/7VrVJpUwfIeJhvlws=; b=mFNFLTAYn/DUbiOYV9pf0TwSgp
	2n72sqO2f7e6qJYhsBkhWqBDOccU2N6p1OISdR2OXCfcp5FFmKZv9O4Ki/Y9fQLc2vZy7dkQ+NXan
	ccwN6QCGmMkek+U+I9Muz8XSE1w/cCve14p22B1wsty32vLUKZBCSMe46i/JkCXjZH54wYRMZOkuz
	kFPuEeZcbqT/83w4gM1eEyKIeZ7QbY9u/43F1pfxJDYZC0EyLEZuYqNY4sfRU0MKHjAFJIZahnnTk
	JYGqgply4Wsj9vkDBYovH+wEbHgWciH7hd2vG38/LR4QI/tRxQ6aYwzyReql4c95b/M6Fs8Dftzi3
	XKuDL9Dg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFRYW-006Edm-1P;
	Thu, 15 May 2025 13:54:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 13:54:56 +0800
Date: Thu, 15 May 2025 13:54:56 +0800
Message-Id: <30e4640222d3763c5dcc70271931f90045f02146.1747288315.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747288315.git.herbert@gondor.apana.org.au>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 11/11] crypto: testmgr - Add hash export format testing
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Ensure that the hash state can be exported to and imported from
the generic algorithm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c               | 95 ++++++++++++++++++++++++++++++----
 crypto/testmgr.h               |  2 +
 include/crypto/internal/hash.h |  6 +++
 3 files changed, 94 insertions(+), 9 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 72005074a5c2..737064b31480 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -17,10 +17,19 @@
  */
 
 #include <crypto/aead.h>
-#include <crypto/hash.h>
+#include <crypto/acompress.h>
+#include <crypto/akcipher.h>
+#include <crypto/drbg.h>
+#include <crypto/internal/cipher.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/simd.h>
+#include <crypto/kpp.h>
+#include <crypto/rng.h>
+#include <crypto/sig.h>
 #include <crypto/skcipher.h>
 #include <linux/err.h>
 #include <linux/fips.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/once.h>
 #include <linux/prandom.h>
@@ -28,14 +37,6 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uio.h>
-#include <crypto/rng.h>
-#include <crypto/drbg.h>
-#include <crypto/akcipher.h>
-#include <crypto/kpp.h>
-#include <crypto/acompress.h>
-#include <crypto/sig.h>
-#include <crypto/internal/cipher.h>
-#include <crypto/internal/simd.h>
 
 #include "internal.h"
 
@@ -1464,6 +1465,49 @@ static int check_nonfinal_ahash_op(const char *op, int err,
 	return 0;
 }
 
+static int check_ahash_export(struct ahash_request *req,
+			      const struct hash_testvec *vec,
+			      const char *vec_name,
+			      const struct testvec_config *cfg,
+			      const char *driver, u8 *hashstate)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
+	HASH_FBREQ_ON_STACK(fbreq, req);
+	int err;
+
+	if (!vec->state)
+		return 0;
+
+	err = crypto_ahash_export(req, hashstate);
+	if (err) {
+		pr_err("alg: ahash: %s mixed export() failed with err %d on test vector %s, cfg=\"%s\"\n",
+		       driver, err, vec_name, cfg->name);
+		return err;
+	}
+	err = crypto_ahash_import(req, vec->state);
+	if (err) {
+		pr_err("alg: ahash: %s mixed import() failed with err %d on test vector %s, cfg=\"%s\"\n",
+		       driver, err, vec_name, cfg->name);
+		return err;
+	}
+	err = crypto_ahash_import(fbreq, hashstate);
+	if (err) {
+		pr_err("alg: ahash: %s fallback import() failed with err %d on test vector %s, cfg=\"%s\"\n",
+		       crypto_ahash_driver_name(crypto_ahash_reqtfm(fbreq)), err, vec_name, cfg->name);
+		return err;
+	}
+	ahash_request_set_crypt(fbreq, NULL, hashstate, 0);
+	testmgr_poison(hashstate, digestsize + TESTMGR_POISON_LEN);
+	err = crypto_ahash_final(fbreq);
+	if (err) {
+		pr_err("alg: ahash: %s fallback final() failed with err %d on test vector %s, cfg=\"%s\"\n",
+		       crypto_ahash_driver_name(crypto_ahash_reqtfm(fbreq)), err, vec_name, cfg->name);
+		return err;
+	}
+	return check_hash_result("ahash export", hashstate, digestsize, vec, vec_name, driver, cfg);
+}
+
 /* Test one hash test vector in one configuration, using the ahash API */
 static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 			      const char *vec_name,
@@ -1609,6 +1653,10 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 					      driver, vec_name, cfg);
 		if (err)
 			return err;
+		err = check_ahash_export(req, vec, vec_name, cfg,
+					 driver, hashstate);
+		if (err)
+			return err;
 		err = do_ahash_op(crypto_ahash_final, req, &wait, cfg->nosimd);
 		if (err) {
 			pr_err("alg: ahash: %s final() failed with err %d on test vector %s, cfg=\"%s\"\n",
@@ -1732,6 +1780,17 @@ static void generate_random_hash_testvec(struct rnd_state *rng,
 	vec->digest_error = crypto_hash_digest(
 		crypto_ahash_reqtfm(req), vec->plaintext,
 		vec->psize, (u8 *)vec->digest);
+
+	if (vec->digest_error || !vec->state)
+		goto done;
+
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	ahash_request_set_virt(req, vec->plaintext, (u8 *)vec->digest,
+			       vec->psize);
+	crypto_ahash_init(req);
+	crypto_ahash_update(req);
+	crypto_ahash_export(req, (u8 *)vec->state);
+
 done:
 	snprintf(name, max_namelen, "\"random: psize=%u ksize=%u\"",
 		 vec->psize, vec->ksize);
@@ -1750,6 +1809,7 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
+	const unsigned int statesize = crypto_ahash_statesize(tfm);
 	const unsigned int blocksize = crypto_ahash_blocksize(tfm);
 	const unsigned int maxdatasize = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN;
 	const char *algname = crypto_hash_alg_common(tfm)->base.cra_name;
@@ -1822,6 +1882,22 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 		goto out;
 	}
 
+	if (crypto_hash_no_export_core(tfm) ||
+	    crypto_hash_no_export_core(generic_tfm))
+		;
+	else if (statesize != crypto_ahash_statesize(generic_tfm)) {
+		pr_err("alg: hash: statesize for %s (%u) doesn't match generic impl (%u)\n",
+		       driver, statesize,
+		       crypto_ahash_statesize(generic_tfm));
+		err = -EINVAL;
+		goto out;
+	} else {
+		vec.state = kmalloc(statesize, GFP_KERNEL);
+		err = -ENOMEM;
+		if (!vec.state)
+			goto out;
+	}
+
 	/*
 	 * Now generate test vectors using the generic implementation, and test
 	 * the other implementation against them.
@@ -1854,6 +1930,7 @@ static int test_hash_vs_generic_impl(const char *generic_driver,
 	kfree(vec.key);
 	kfree(vec.plaintext);
 	kfree(vec.digest);
+	kfree(vec.state);
 	ahash_request_free(generic_req);
 	crypto_free_ahash(generic_tfm);
 	return err;
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 32d099ac9e73..5cf455a708b8 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -29,6 +29,7 @@
  * hash_testvec:	structure to describe a hash (message digest) test
  * @key:	Pointer to key (NULL if none)
  * @plaintext:	Pointer to source data
+ * @state:	Pointer to expected state
  * @digest:	Pointer to expected digest
  * @psize:	Length of source data in bytes
  * @ksize:	Length of @key in bytes (0 if no key)
@@ -39,6 +40,7 @@
 struct hash_testvec {
 	const char *key;
 	const char *plaintext;
+	const char *state;
 	const char *digest;
 	unsigned int psize;
 	unsigned short ksize;
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 0f85c543f80b..f052afa6e7b0 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -91,6 +91,12 @@ static inline bool crypto_hash_alg_needs_key(struct hash_alg_common *alg)
 		!(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY);
 }
 
+static inline bool crypto_hash_no_export_core(struct crypto_ahash *tfm)
+{
+	return crypto_hash_alg_common(tfm)->base.cra_flags &
+	       CRYPTO_AHASH_ALG_NO_EXPORT_CORE;
+}
+
 int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
 		      struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask);
-- 
2.39.5


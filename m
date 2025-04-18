Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3613D267F47
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945129; cv=none; b=kGaxLSmPm2/PzmBWDyoYnPDKZsUJ2Ze+Q5j6DY0JCEl8hE+hYRGMqkirTi0hej5lHt99ksd7viKv2N+SK1RaM5+ofJoANYPbw/nXzGyTuMb67sb5S3rc8wQ1g6CPMQdCjVDEQAy6uN/N0RSzx8MU61rz4ejtkbVf1Z5r52ZlPuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945129; c=relaxed/simple;
	bh=EBItUck9/IchLfW0zfjcUUut1QL92a7guq1KgOpquJ4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=bnVP9Qusqf/QFLI4UgMySK++uzvigcB1rNekQ1WjkiT1Mzn8w1P10oXx20mkoTLX+ul7HWet8e9X+oJ03aoktBIunWf2Zm7dX5RLsCDFlRvwaB4fCQgvzvp5b744hIqX6rSO5qVtUQJwBFGPRDPb1cnfz6Uj1EdkHZNMNIcBVz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UsWQyUGL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UsWQyUGL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DD4wtYMYqIOBD5B6FXHStmKW0u0mSNbBexZtaX/QoTo=; b=UsWQyUGLspwiv2/aFiIoYkWK6L
	MW37Zw9vsxO3rGIFc+d71ukwCK2pFx/gXridtxM7lUOE1IP5eT6OqIs94iBClAbj37g9kPsKTJs6X
	KsI2zbVhvNMzelIk4v4PsL0cGbP04n1sVCNmiypHzhKaQVk//vEZduySgmiVqFryVNoqwMX8NMPLf
	P25Kpdn4TL4hFqJVanC9F4YQJEPYYCpLvqNVZ5JtutMi3DJADk4sGa8U03mTe+Ynmt9aedQ6qe5YR
	bwV9uLp7l2LCaoWy7alrR7++KA80yl95aRC4YUcJfMO4+cBRrgyatY44stRoXVmE2vFruyxG5Zmc/
	3+dQaeSQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bw9-00Gdzg-08;
	Fri, 18 Apr 2025 10:58:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:58:41 +0800
Date: Fri, 18 Apr 2025 10:58:41 +0800
Message-Id: <e4dd5f35c250b622c802d3f27e9290ecb3d6fe7b.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 01/67] crypto: shash - Handle partial blocks in API
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Provide an option to handle the partial blocks in the shash API.
Almost every hash algorithm has a block size and are only able
to hash partial blocks on finalisation.

Rather than duplicating the partial block handling many times,
add this functionality to the shash API.

It is optional (e.g., hmac would never need this by relying on
the partial block handling of the underlying hash), and to enable
it set the bit CRYPTO_AHASH_ALG_BLOCK_ONLY.

The export format is always that of the underlying hash export,
plus the partial block buffer, followed by a single-byte for the
partial block length.

Set the bit CRYPTO_AHASH_ALG_FINAL_NONZERO to withhold an extra
byte in the partial block.  This will come in handy when this
is extended to ahash where hardware often can't deal with a
zero-length final.

It will also be used for algorithms requiring an extra block for
finalisation (e.g., cmac).

As an optimisation, set the bit CRYPTO_AHASH_ALG_FINUP_MAX if
the algorithm wishes to get as much data as possible instead of
just the last partial block.

The descriptor will be zeroed after finalisation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/shash.c                 | 229 +++++++++++++++++++++++++++------
 include/crypto/hash.h          | 104 +++++++++------
 include/crypto/internal/hash.h |  15 +++
 include/linux/crypto.h         |   2 +
 4 files changed, 271 insertions(+), 79 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index f23bd9cb1873..b6c79a4a044a 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -16,6 +16,24 @@
 
 #include "hash.h"
 
+static inline bool crypto_shash_block_only(struct crypto_shash *tfm)
+{
+	return crypto_shash_alg(tfm)->base.cra_flags &
+	       CRYPTO_AHASH_ALG_BLOCK_ONLY;
+}
+
+static inline bool crypto_shash_final_nonzero(struct crypto_shash *tfm)
+{
+	return crypto_shash_alg(tfm)->base.cra_flags &
+	       CRYPTO_AHASH_ALG_FINAL_NONZERO;
+}
+
+static inline bool crypto_shash_finup_max(struct crypto_shash *tfm)
+{
+	return crypto_shash_alg(tfm)->base.cra_flags &
+	       CRYPTO_AHASH_ALG_FINUP_MAX;
+}
+
 int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
 		    unsigned int keylen)
 {
@@ -46,18 +64,27 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_shash_setkey);
 
-int crypto_shash_update(struct shash_desc *desc, const u8 *data,
-			unsigned int len)
+static int __crypto_shash_init(struct shash_desc *desc)
 {
-	return crypto_shash_alg(desc->tfm)->update(desc, data, len);
-}
-EXPORT_SYMBOL_GPL(crypto_shash_update);
+	struct crypto_shash *tfm = desc->tfm;
 
-int crypto_shash_final(struct shash_desc *desc, u8 *out)
-{
-	return crypto_shash_alg(desc->tfm)->final(desc, out);
+	if (crypto_shash_block_only(tfm)) {
+		u8 *buf = shash_desc_ctx(desc);
+
+		buf += crypto_shash_descsize(tfm) - 1;
+		*buf = 0;
+	}
+
+	return crypto_shash_alg(tfm)->init(desc);
 }
-EXPORT_SYMBOL_GPL(crypto_shash_final);
+
+int crypto_shash_init(struct shash_desc *desc)
+{
+	if (crypto_shash_get_flags(desc->tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+	return __crypto_shash_init(desc);
+}
+EXPORT_SYMBOL_GPL(crypto_shash_init);
 
 static int shash_default_finup(struct shash_desc *desc, const u8 *data,
 			       unsigned int len, u8 *out)
@@ -68,20 +95,89 @@ static int shash_default_finup(struct shash_desc *desc, const u8 *data,
 	       shash->final(desc, out);
 }
 
-int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
-		       unsigned int len, u8 *out)
+static int crypto_shash_op_and_zero(
+	int (*op)(struct shash_desc *desc, const u8 *data,
+		  unsigned int len, u8 *out),
+	struct shash_desc *desc, const u8 *data, unsigned int len, u8 *out)
 {
-	return crypto_shash_alg(desc->tfm)->finup(desc, data, len, out);
+	int err;
+
+	err = op(desc, data, len, out);
+	memset(shash_desc_ctx(desc), 0, crypto_shash_descsize(desc->tfm));
+	return err;
+}
+
+int crypto_shash_finup(struct shash_desc *restrict desc, const u8 *data,
+		       unsigned int len, u8 *restrict out)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	u8 *blenp = shash_desc_ctx(desc);
+	bool finup_max, nonzero;
+	unsigned int bs;
+	int err;
+	u8 *buf;
+
+	if (!crypto_shash_block_only(tfm)) {
+		if (out)
+			goto finup;
+		return crypto_shash_alg(tfm)->update(desc, data, len);
+	}
+
+	finup_max = out && crypto_shash_finup_max(tfm);
+
+	/* Retain extra block for final nonzero algorithms. */
+	nonzero = crypto_shash_final_nonzero(tfm);
+
+	/*
+	 * The partial block buffer follows the algorithm desc context.
+	 * The byte following that contains the length.
+	 */
+	blenp += crypto_shash_descsize(tfm) - 1;
+	bs = crypto_shash_blocksize(tfm);
+	buf = blenp - bs;
+
+	if (likely(!*blenp && finup_max))
+		goto finup;
+
+	while ((*blenp + len) >= bs + nonzero) {
+		unsigned int nbytes = len - nonzero;
+		const u8 *src = data;
+
+		if (*blenp) {
+			memcpy(buf + *blenp, data, bs - *blenp);
+			nbytes = bs;
+			src = buf;
+		}
+
+		err = crypto_shash_alg(tfm)->update(desc, src, nbytes);
+		if (err < 0)
+			return err;
+
+		data += nbytes - err - *blenp;
+		len -= nbytes - err - *blenp;
+		*blenp = 0;
+	}
+
+	if (*blenp || !out) {
+		memcpy(buf + *blenp, data, len);
+		*blenp += len;
+		if (!out)
+			return 0;
+		data = buf;
+		len = *blenp;
+	}
+
+finup:
+	return crypto_shash_op_and_zero(crypto_shash_alg(tfm)->finup, desc,
+					data, len, out);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_finup);
 
 static int shash_default_digest(struct shash_desc *desc, const u8 *data,
 				unsigned int len, u8 *out)
 {
-	struct shash_alg *shash = crypto_shash_alg(desc->tfm);
-
-	return shash->init(desc) ?:
-	       shash->finup(desc, data, len, out);
+	return __crypto_shash_init(desc) ?:
+	       crypto_shash_finup(desc, data, len, out);
 }
 
 int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
@@ -92,7 +188,8 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 	if (crypto_shash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
 
-	return crypto_shash_alg(tfm)->digest(desc, data, len, out);
+	return crypto_shash_op_and_zero(crypto_shash_alg(tfm)->digest, desc,
+					data, len, out);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_digest);
 
@@ -100,44 +197,92 @@ int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
 			    unsigned int len, u8 *out)
 {
 	SHASH_DESC_ON_STACK(desc, tfm);
-	int err;
 
 	desc->tfm = tfm;
-
-	err = crypto_shash_digest(desc, data, len, out);
-
-	shash_desc_zero(desc);
-
-	return err;
+	return crypto_shash_digest(desc, data, len, out);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_tfm_digest);
 
+int crypto_shash_export_core(struct shash_desc *desc, void *out)
+{
+	int (*export)(struct shash_desc *desc, void *out);
+	struct crypto_shash *tfm = desc->tfm;
+	u8 *buf = shash_desc_ctx(desc);
+	unsigned int plen, ss;
+
+	plen = crypto_shash_blocksize(tfm) + 1;
+	ss = crypto_shash_statesize(tfm);
+	if (crypto_shash_block_only(tfm))
+		ss -= plen;
+	export = crypto_shash_alg(tfm)->export;
+	if (!export) {
+		memcpy(out, buf, ss);
+		return 0;
+	}
+
+	return export(desc, out);
+}
+EXPORT_SYMBOL_GPL(crypto_shash_export_core);
+
 int crypto_shash_export(struct shash_desc *desc, void *out)
 {
 	struct crypto_shash *tfm = desc->tfm;
-	struct shash_alg *shash = crypto_shash_alg(tfm);
 
-	if (shash->export)
-		return shash->export(desc, out);
+	if (crypto_shash_block_only(tfm)) {
+		unsigned int plen = crypto_shash_blocksize(tfm) + 1;
+		unsigned int descsize = crypto_shash_descsize(tfm);
+		unsigned int ss = crypto_shash_statesize(tfm);
+		u8 *buf = shash_desc_ctx(desc);
 
-	memcpy(out, shash_desc_ctx(desc), crypto_shash_descsize(tfm));
-	return 0;
+		memcpy(out + ss - plen, buf + descsize - plen, plen);
+	}
+	return crypto_shash_export_core(desc, out);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_export);
 
-int crypto_shash_import(struct shash_desc *desc, const void *in)
+int crypto_shash_import_core(struct shash_desc *desc, const void *in)
 {
+	int (*import)(struct shash_desc *desc, const void *in);
 	struct crypto_shash *tfm = desc->tfm;
-	struct shash_alg *shash = crypto_shash_alg(tfm);
+	unsigned int descsize, plen, ss;
+	u8 *buf = shash_desc_ctx(desc);
 
 	if (crypto_shash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
 
-	if (shash->import)
-		return shash->import(desc, in);
+	plen = crypto_shash_blocksize(tfm) + 1;
+	descsize = crypto_shash_descsize(tfm);
+	ss = crypto_shash_statesize(tfm);
+	buf[descsize - 1] = 0;
+	if (crypto_shash_block_only(tfm))
+		ss -= plen;
+	import = crypto_shash_alg(tfm)->import;
+	if (!import) {
+		memcpy(buf, in, ss);
+		return 0;
+	}
 
-	memcpy(shash_desc_ctx(desc), in, crypto_shash_descsize(tfm));
-	return 0;
+	return import(desc, in);
+}
+EXPORT_SYMBOL_GPL(crypto_shash_import_core);
+
+int crypto_shash_import(struct shash_desc *desc, const void *in)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	int err;
+
+	err = crypto_shash_import_core(desc, in);
+	if (crypto_shash_block_only(tfm)) {
+		unsigned int plen = crypto_shash_blocksize(tfm) + 1;
+		unsigned int descsize = crypto_shash_descsize(tfm);
+		unsigned int ss = crypto_shash_statesize(tfm);
+		u8 *buf = shash_desc_ctx(desc);
+
+		memcpy(buf + descsize - plen, in + ss - plen, plen);
+		if (buf[descsize - 1] >= plen)
+			err = -EOVERFLOW;
+	}
+	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_shash_import);
 
@@ -293,9 +438,6 @@ static int shash_prepare_alg(struct shash_alg *alg)
 	struct crypto_alg *base = &alg->halg.base;
 	int err;
 
-	if (alg->descsize > HASH_MAX_DESCSIZE)
-		return -EINVAL;
-
 	if ((alg->export && !alg->import) || (alg->import && !alg->export))
 		return -EINVAL;
 
@@ -321,11 +463,20 @@ static int shash_prepare_alg(struct shash_alg *alg)
 		alg->finup = shash_default_finup;
 	if (!alg->digest)
 		alg->digest = shash_default_digest;
-	if (!alg->export)
+	if (!alg->export && !alg->halg.statesize)
 		alg->halg.statesize = alg->descsize;
 	if (!alg->setkey)
 		alg->setkey = shash_no_setkey;
 
+	if (base->cra_flags & CRYPTO_AHASH_ALG_BLOCK_ONLY) {
+		BUILD_BUG_ON(MAX_ALGAPI_BLOCKSIZE >= 256);
+		alg->descsize += base->cra_blocksize + 1;
+		alg->statesize += base->cra_blocksize + 1;
+	}
+
+	if (alg->descsize > HASH_MAX_DESCSIZE)
+		return -EINVAL;
+
 	return 0;
 }
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 58ac1423dc38..5f87d1040a7c 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -85,6 +85,8 @@ struct ahash_request {
  *	   transformation object. Data processing can happen synchronously
  *	   [SHASH] or asynchronously [AHASH] at this point. Driver must not use
  *	   req->result.
+ *	   For block-only algorithms, @update must return the number
+ *	   of bytes to store in the API partial block buffer.
  * @final: **[mandatory]** Retrieve result from the driver. This function finalizes the
  *	   transformation and retrieves the resulting hash from the driver and
  *	   pushes it back to upper layers. No data processing happens at this
@@ -905,6 +907,18 @@ int crypto_hash_digest(struct crypto_ahash *tfm, const u8 *data,
  */
 int crypto_shash_export(struct shash_desc *desc, void *out);
 
+/**
+ * crypto_shash_export_core() - extract core state for message digest
+ * @desc: reference to the operational state handle whose state is exported
+ * @out: output buffer of sufficient size that can hold the hash state
+ *
+ * Export the hash state without the partial block buffer.
+ *
+ * Context: Softirq or process context.
+ * Return: 0 if the export creation was successful; < 0 if an error occurred
+ */
+int crypto_shash_export_core(struct shash_desc *desc, void *out);
+
 /**
  * crypto_shash_import() - import operational state
  * @desc: reference to the operational state handle the state imported into
@@ -919,6 +933,18 @@ int crypto_shash_export(struct shash_desc *desc, void *out);
  */
 int crypto_shash_import(struct shash_desc *desc, const void *in);
 
+/**
+ * crypto_shash_import_core() - import core state
+ * @desc: reference to the operational state handle the state imported into
+ * @in: buffer holding the state
+ *
+ * Import the hash state without the partial block buffer.
+ *
+ * Context: Softirq or process context.
+ * Return: 0 if the import was successful; < 0 if an error occurred
+ */
+int crypto_shash_import_core(struct shash_desc *desc, const void *in);
+
 /**
  * crypto_shash_init() - (re)initialize message digest
  * @desc: operational state handle that is already filled
@@ -931,46 +957,7 @@ int crypto_shash_import(struct shash_desc *desc, const void *in);
  * Return: 0 if the message digest initialization was successful; < 0 if an
  *	   error occurred
  */
-static inline int crypto_shash_init(struct shash_desc *desc)
-{
-	struct crypto_shash *tfm = desc->tfm;
-
-	if (crypto_shash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
-
-	return crypto_shash_alg(tfm)->init(desc);
-}
-
-/**
- * crypto_shash_update() - add data to message digest for processing
- * @desc: operational state handle that is already initialized
- * @data: input data to be added to the message digest
- * @len: length of the input data
- *
- * Updates the message digest state of the operational state handle.
- *
- * Context: Softirq or process context.
- * Return: 0 if the message digest update was successful; < 0 if an error
- *	   occurred
- */
-int crypto_shash_update(struct shash_desc *desc, const u8 *data,
-			unsigned int len);
-
-/**
- * crypto_shash_final() - calculate message digest
- * @desc: operational state handle that is already filled with data
- * @out: output buffer filled with the message digest
- *
- * Finalize the message digest operation and create the message digest
- * based on all data added to the cipher handle. The message digest is placed
- * into the output buffer. The caller must ensure that the output buffer is
- * large enough by using crypto_shash_digestsize.
- *
- * Context: Softirq or process context.
- * Return: 0 if the message digest creation was successful; < 0 if an error
- *	   occurred
- */
-int crypto_shash_final(struct shash_desc *desc, u8 *out);
+int crypto_shash_init(struct shash_desc *desc);
 
 /**
  * crypto_shash_finup() - calculate message digest of buffer
@@ -990,6 +977,43 @@ int crypto_shash_final(struct shash_desc *desc, u8 *out);
 int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 		       unsigned int len, u8 *out);
 
+/**
+ * crypto_shash_update() - add data to message digest for processing
+ * @desc: operational state handle that is already initialized
+ * @data: input data to be added to the message digest
+ * @len: length of the input data
+ *
+ * Updates the message digest state of the operational state handle.
+ *
+ * Context: Softirq or process context.
+ * Return: 0 if the message digest update was successful; < 0 if an error
+ *	   occurred
+ */
+static inline int crypto_shash_update(struct shash_desc *desc, const u8 *data,
+				      unsigned int len)
+{
+	return crypto_shash_finup(desc, data, len, NULL);
+}
+
+/**
+ * crypto_shash_final() - calculate message digest
+ * @desc: operational state handle that is already filled with data
+ * @out: output buffer filled with the message digest
+ *
+ * Finalize the message digest operation and create the message digest
+ * based on all data added to the cipher handle. The message digest is placed
+ * into the output buffer. The caller must ensure that the output buffer is
+ * large enough by using crypto_shash_digestsize.
+ *
+ * Context: Softirq or process context.
+ * Return: 0 if the message digest creation was successful; < 0 if an error
+ *	   occurred
+ */
+static inline int crypto_shash_final(struct shash_desc *desc, u8 *out)
+{
+	return crypto_shash_finup(desc, NULL, 0, out);
+}
+
 static inline void shash_desc_zero(struct shash_desc *desc)
 {
 	memzero_explicit(desc,
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 45c728ac2621..1e80dd084a23 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -11,6 +11,15 @@
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
 
+/* Set this bit to handle partial blocks in the API. */
+#define CRYPTO_AHASH_ALG_BLOCK_ONLY	0x01000000
+
+/* Set this bit if final requires at least one byte. */
+#define CRYPTO_AHASH_ALG_FINAL_NONZERO	0x02000000
+
+/* Set this bit if finup can deal with multiple blocks. */
+#define CRYPTO_AHASH_ALG_FINUP_MAX	0x04000000
+
 #define HASH_FBREQ_ON_STACK(name, req) \
         char __##name##_req[sizeof(struct ahash_request) + \
                             MAX_SYNC_HASH_REQSIZE] CRYPTO_MINALIGN_ATTR; \
@@ -281,5 +290,11 @@ static inline struct ahash_request *ahash_fbreq_on_stack_init(
 	return req;
 }
 
+/* Return the state size without partial block for block-only algorithms. */
+static inline unsigned int crypto_shash_coresize(struct crypto_shash *tfm)
+{
+	return crypto_shash_statesize(tfm) - crypto_shash_blocksize(tfm) - 1;
+}
+
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b89b1b348095..f691ce01745e 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -136,6 +136,8 @@
 /* Set if the algorithm supports request chains and virtual addresses. */
 #define CRYPTO_ALG_REQ_CHAIN		0x00040000
 
+/* The high bits 0xff000000 are reserved for type-specific flags. */
+
 /*
  * Transform masks and values (for crt_flags).
  */
-- 
2.39.5


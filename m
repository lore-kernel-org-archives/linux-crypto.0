Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7BB10A1F
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739675256; cv=none; b=ER5mXAo8XGCpQxUSIkkHK21Skp0gSD1VYaVt/wDSvo9I3FnQuGSvUDUNy05cVZ4mzYOmTMAJIeTUmsZr6mJaKH7I2xqaBiOWK5AF4oTvFaiSqjsLt8513frO9KPsiny+yMJcbLbNDoAykhJMstDmC0gZzwEb5AjGQBzVRNDPiRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739675256; c=relaxed/simple;
	bh=35yDBQpzpN6NuQDIyD47ciJFy71wiMY/6pgQ0NL/268=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=YU1r8YXNsvUD9pU3pIityiv83wHOOYmXQNoU2LmfI6uv99MTG3JZZGKrXF+vdYs/7KZQ3pBtrHBF+A25ZsqUjA8ff/eW3sVGYflyIcrh/bOPl+rHIU1LZc4dsCtkrw1r9v2sOot2XeEArdcNt/Bb+32Gdi5GfW7ETw5NAxjcVug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZIF93BTV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZIF93BTV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/Gy8ojeyn/pSetWrgiMW7tNsrPDhJ+xUsPdhwiBTYgM=; b=ZIF93BTVB/yehw23wiBlQJ0SKE
	sX28cEjd4VVnom8X7mgS1YsYUOFY2ikCh3Lb1MdxP95UbUZSmsMxDswoKZ96gZw/Y+blGM2RKGyAJ
	ZGi8v7m4LuhC4NGp/RB4TCnLwyecUzJaWZduKUDU5Z/bFUBt4QH7ifjKkpWyx5Gdsgq80EqQRIT4G
	J6x+lYf6pu01I51xp33+HgWsEfX3eEPcHM+mYpmoQqn479jFDo4hpE78wmtfwbltTiQYkTZngsbpw
	fbqvMEr0s1lUs0+kKrTOo9CpU+AKwqKWPeSgDtwyOvti00usNugRHwigKTjBmllYZKs84UBU5GlEj
	GlZULOrw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUnK-000gZw-1z;
	Sun, 16 Feb 2025 11:07:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:07:31 +0800
Date: Sun, 16 Feb 2025 11:07:31 +0800
Message-Id: <d6e10dbf172f0b7c791f5406d55e8f1c74492d57.1739674648.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1739674648.git.herbert@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 09/11] crypto: hash - Add sync hash interface
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Introduce a new sync hash interface based on ahash, similar to
sync skcipher.

It will replace shash for existing users.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c        |  37 ++++++++++++++++
 include/crypto/hash.h | 100 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 6b19fa6fc628..fafce2e47a78 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -949,6 +949,27 @@ struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_ahash);
 
+struct crypto_sync_hash *crypto_alloc_sync_hash(const char *alg_name,
+						u32 type, u32 mask)
+{
+	struct crypto_ahash *tfm;
+
+	/* Only sync algorithms allowed. */
+	mask |= CRYPTO_ALG_ASYNC;
+	type &= ~CRYPTO_ALG_ASYNC;
+
+	tfm = crypto_alloc_ahash(alg_name, type, mask);
+
+	if (!IS_ERR(tfm) && WARN_ON(crypto_ahash_reqsize(tfm) >
+				    MAX_SYNC_HASH_REQSIZE)) {
+		crypto_free_ahash(tfm);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return container_of(tfm, struct crypto_sync_hash, base);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_sync_hash);
+
 int crypto_has_ahash(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_ahash_type, type, mask);
@@ -1123,5 +1144,21 @@ void ahash_request_free(struct ahash_request *req)
 }
 EXPORT_SYMBOL_GPL(ahash_request_free);
 
+int crypto_sync_hash_digest(struct crypto_sync_hash *tfm, const u8 *data,
+			    unsigned int len, u8 *out)
+{
+	SYNC_HASH_REQUEST_ON_STACK(req, tfm);
+	int err;
+
+	ahash_request_set_callback(req, 0, NULL, NULL);
+	ahash_request_set_virt(req, data, out, len);
+	err = crypto_ahash_digest(req);
+
+	ahash_request_zero(req);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_shash_tfm_digest);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 2aa83ee0ec98..f6e0c44331a3 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_HASH_H
 #define _CRYPTO_HASH_H
 
+#include <linux/align.h>
 #include <linux/atomic.h>
 #include <linux/crypto.h>
 #include <linux/string.h>
@@ -162,6 +163,8 @@ struct shash_desc {
 	void *__ctx[] __aligned(ARCH_SLAB_MINALIGN);
 };
 
+struct sync_hash_requests;
+
 #define HASH_MAX_DIGESTSIZE	 64
 
 /*
@@ -169,12 +172,30 @@ struct shash_desc {
  * containing a 'struct sha3_state'.
  */
 #define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
+#define MAX_SYNC_HASH_REQSIZE	HASH_MAX_DESCSIZE
 
 #define SHASH_DESC_ON_STACK(shash, ctx)					     \
 	char __##shash##_desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE] \
 		__aligned(__alignof__(struct shash_desc));		     \
 	struct shash_desc *shash = (struct shash_desc *)__##shash##_desc
 
+#define SYNC_HASH_REQUEST_ON_STACK(name, _tfm) \
+	char __##name##_req[sizeof(struct ahash_request) + \
+			     MAX_SYNC_HASH_REQSIZE \
+			    ] CRYPTO_MINALIGN_ATTR; \
+	struct ahash_request *name = \
+		(((struct ahash_request *)__##name##_req)->base.tfm = \
+			crypto_sync_hash_tfm((_tfm)), \
+		 (void *)__##name##_req)
+
+#define SYNC_HASH_REQUESTS_ON_STACK(name, _n, _tfm) \
+	char __##name##_req[(_n) * ALIGN(sizeof(struct ahash_request) + \
+					  MAX_SYNC_HASH_REQSIZE, \
+					  CRYPTO_MINALIGN) \
+			    ] CRYPTO_MINALIGN_ATTR; \
+	struct sync_hash_requests *name = sync_hash_requests_on_stack_init( \
+		__##name##_req, sizeof(__##name##_req), (_tfm))
+
 /**
  * struct shash_alg - synchronous message digest definition
  * @init: see struct ahash_alg
@@ -241,6 +262,10 @@ struct crypto_shash {
 	struct crypto_tfm base;
 };
 
+struct crypto_sync_hash {
+	struct crypto_ahash base;
+};
+
 /**
  * DOC: Asynchronous Message Digest API
  *
@@ -273,6 +298,9 @@ static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_tfm *tfm)
 struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
 					u32 mask);
 
+struct crypto_sync_hash *crypto_alloc_sync_hash(const char *alg_name,
+						u32 type, u32 mask);
+
 struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *tfm);
 
 static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
@@ -280,6 +308,12 @@ static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
 	return &tfm->base;
 }
 
+static inline struct crypto_tfm *crypto_sync_hash_tfm(
+	struct crypto_sync_hash *tfm)
+{
+	return crypto_ahash_tfm(&tfm->base);
+}
+
 /**
  * crypto_free_ahash() - zeroize and free the ahash handle
  * @tfm: cipher handle to be freed
@@ -291,6 +325,11 @@ static inline void crypto_free_ahash(struct crypto_ahash *tfm)
 	crypto_destroy_tfm(tfm, crypto_ahash_tfm(tfm));
 }
 
+static inline void crypto_free_sync_hash(struct crypto_sync_hash *tfm)
+{
+	crypto_free_ahash(&tfm->base);
+}
+
 /**
  * crypto_has_ahash() - Search for the availability of an ahash.
  * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
@@ -313,6 +352,12 @@ static inline const char *crypto_ahash_driver_name(struct crypto_ahash *tfm)
 	return crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
 }
 
+static inline const char *crypto_sync_hash_driver_name(
+	struct crypto_sync_hash *tfm)
+{
+	return crypto_ahash_driver_name(&tfm->base);
+}
+
 /**
  * crypto_ahash_blocksize() - obtain block size for cipher
  * @tfm: cipher handle
@@ -327,6 +372,12 @@ static inline unsigned int crypto_ahash_blocksize(struct crypto_ahash *tfm)
 	return crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 }
 
+static inline unsigned int crypto_sync_hash_blocksize(
+	struct crypto_sync_hash *tfm)
+{
+	return crypto_ahash_blocksize(&tfm->base);
+}
+
 static inline struct hash_alg_common *__crypto_hash_alg_common(
 	struct crypto_alg *alg)
 {
@@ -354,6 +405,12 @@ static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash *tfm)
 	return crypto_hash_alg_common(tfm)->digestsize;
 }
 
+static inline unsigned int crypto_sync_hash_digestsize(
+	struct crypto_sync_hash *tfm)
+{
+	return crypto_ahash_digestsize(&tfm->base);
+}
+
 /**
  * crypto_ahash_statesize() - obtain size of the ahash state
  * @tfm: cipher handle
@@ -369,6 +426,12 @@ static inline unsigned int crypto_ahash_statesize(struct crypto_ahash *tfm)
 	return tfm->statesize;
 }
 
+static inline unsigned int crypto_sync_hash_statesize(
+	struct crypto_sync_hash *tfm)
+{
+	return crypto_ahash_statesize(&tfm->base);
+}
+
 static inline u32 crypto_ahash_get_flags(struct crypto_ahash *tfm)
 {
 	return crypto_tfm_get_flags(crypto_ahash_tfm(tfm));
@@ -877,6 +940,9 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
 			    unsigned int len, u8 *out);
 
+int crypto_sync_hash_digest(struct crypto_sync_hash *tfm, const u8 *data,
+			    unsigned int len, u8 *out);
+
 /**
  * crypto_shash_export() - extract operational state for message digest
  * @desc: reference to the operational state handle whose state is exported
@@ -982,6 +1048,13 @@ static inline void shash_desc_zero(struct shash_desc *desc)
 			 sizeof(*desc) + crypto_shash_descsize(desc->tfm));
 }
 
+static inline void ahash_request_zero(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	memzero_explicit(req, sizeof(*req) + crypto_ahash_reqsize(tfm));
+}
+
 static inline int ahash_request_err(struct ahash_request *req)
 {
 	return req->base.err;
@@ -992,4 +1065,31 @@ static inline bool ahash_is_async(struct crypto_ahash *tfm)
 	return crypto_tfm_is_async(&tfm->base);
 }
 
+static inline struct ahash_request *sync_hash_requests(
+	struct sync_hash_requests *reqs, int i)
+{
+	unsigned unit = sizeof(struct ahash_request) + MAX_SYNC_HASH_REQSIZE;
+	unsigned alunit = ALIGN(unit, CRYPTO_MINALIGN);
+
+	return (void *)((char *)reqs + i * alunit);
+}
+
+static inline struct sync_hash_requests *sync_hash_requests_on_stack_init(
+	char *buf, unsigned len, struct crypto_sync_hash *tfm)
+{
+	unsigned unit = sizeof(struct ahash_request) + MAX_SYNC_HASH_REQSIZE;
+	unsigned alunit = ALIGN(unit, CRYPTO_MINALIGN);
+	struct sync_hash_requests *reqs = (void *)buf;
+	int n = len / alunit;
+	int i;
+
+	for (i = 0; i < n; i++) {
+		struct ahash_request *req = sync_hash_requests(reqs, i);
+
+		req->base.tfm = crypto_sync_hash_tfm(tfm);
+	}
+
+	return reqs;
+}
+
 #endif	/* _CRYPTO_HASH_H */
-- 
2.39.5


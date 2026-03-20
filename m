Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB8A30F95F;
	Fri, 20 Mar 2026 22:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774045060; cv=none; b=mzcE0l/xmsqGESSYVsbdr+1C5n63u48FIfNFYY3YZTLllptdtPd0U53VcfYHIGTnIVkdVCRt1LVqwFHdih5kIbZaW84gndVdeKOLffLNZoZ0KNWP7UsOBpfP5IcyK0K9rYvaVrrfxWuICNj6K6o1LjVq+OTl+fjmg3ggJ9NNsEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774045060; c=relaxed/simple;
	bh=amJ+gSFeiX0v88OOrwl24zoLlKeaW9XuNTiVlHSNIRI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LasbOwtujQymVkuRjdvpnhU9eAqtH0aIkAOCdy8th/ZbGUFega8/zH3OoBKcvEA3tbRx9aFZI+Z+itHFeGnrCZp9v5gNlMeNnpJIZcRNpqNj/XkYs9hySwf7XjmohQFGY+BoI5YuXXrzUPVhka8ovOCKc7Mh3foOiP4wKfsQAHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Urnz9upp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Urnz9upp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BFDC4CEF7;
	Fri, 20 Mar 2026 22:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774045059;
	bh=amJ+gSFeiX0v88OOrwl24zoLlKeaW9XuNTiVlHSNIRI=;
	h=From:To:Cc:Subject:Date:From;
	b=Urnz9uppEPyl5pfgyYi1ASjQwC40gm9ZIq/n8/XkO8Tiq3Y394+af77QxYSl2+naz
	 DHufMf0kQKF4bR5XsDwkK2PkOxMUsqP9T/tiLhLSGLnKOaUu/KUL3J4wozuhD5y3YH
	 mgqKuQ7hRvy1eGoaao7XRPZU9a5gQVv4+2qs1WdcalwatSRACeL1ElvfDwzJUTbskJ
	 2CY39k/qbIIsMc7p/FyQnGpf18l8lDQy1OvX9sVLosocWZ5iMmvVZyOIQxwrAptB1m
	 JSsUzvQJ51VbYDSvrlRUUqkWPlJ5qTnmzMdPyubkvwJ/B3Uk/DUbDMnJ05XNr2a0c1
	 q4dnyHbRqdlSQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: cryptd - Remove unused functions
Date: Fri, 20 Mar 2026 15:17:27 -0700
Message-ID: <20260320221727.38346-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Many functions in cryptd.c no longer have any caller.  Remove them.

Also remove several associated structs and includes.  Finally, inline
cryptd_shash_desc() into its only caller, allowing it to be removed too.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting cryptodev/master.  It has a dependency on
"crypto: simd - Remove unused skcipher support"
(https://lore.kernel.org/r/20260314213720.91525-1-ebiggers@kernel.org/)

 crypto/cryptd.c         | 112 +---------------------------------------
 include/crypto/cryptd.h |  33 ------------
 2 files changed, 2 insertions(+), 143 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index cd38f4676176..aba9fe0f23b4 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -644,11 +644,12 @@ static int cryptd_hash_export(struct ahash_request *req, void *out)
 
 static int cryptd_hash_import(struct ahash_request *req, const void *in)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct shash_desc *desc = cryptd_shash_desc(req);
+	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct shash_desc *desc = &rctx->desc;
 
 	desc->tfm = ctx->child;
 
 	return crypto_shash_import(desc, in);
 }
@@ -950,119 +951,10 @@ static struct crypto_template cryptd_tmpl = {
 	.name = "cryptd",
 	.create = cryptd_create,
 	.module = THIS_MODULE,
 };
 
-struct cryptd_skcipher *cryptd_alloc_skcipher(const char *alg_name,
-					      u32 type, u32 mask)
-{
-	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
-	struct cryptd_skcipher_ctx *ctx;
-	struct crypto_skcipher *tfm;
-
-	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
-		     "cryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-EINVAL);
-
-	tfm = crypto_alloc_skcipher(cryptd_alg_name, type, mask);
-	if (IS_ERR(tfm))
-		return ERR_CAST(tfm);
-
-	if (tfm->base.__crt_alg->cra_module != THIS_MODULE) {
-		crypto_free_skcipher(tfm);
-		return ERR_PTR(-EINVAL);
-	}
-
-	ctx = crypto_skcipher_ctx(tfm);
-	refcount_set(&ctx->refcnt, 1);
-
-	return container_of(tfm, struct cryptd_skcipher, base);
-}
-EXPORT_SYMBOL_GPL(cryptd_alloc_skcipher);
-
-struct crypto_skcipher *cryptd_skcipher_child(struct cryptd_skcipher *tfm)
-{
-	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
-
-	return ctx->child;
-}
-EXPORT_SYMBOL_GPL(cryptd_skcipher_child);
-
-bool cryptd_skcipher_queued(struct cryptd_skcipher *tfm)
-{
-	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
-
-	return refcount_read(&ctx->refcnt) - 1;
-}
-EXPORT_SYMBOL_GPL(cryptd_skcipher_queued);
-
-void cryptd_free_skcipher(struct cryptd_skcipher *tfm)
-{
-	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
-
-	if (refcount_dec_and_test(&ctx->refcnt))
-		crypto_free_skcipher(&tfm->base);
-}
-EXPORT_SYMBOL_GPL(cryptd_free_skcipher);
-
-struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
-					u32 type, u32 mask)
-{
-	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
-	struct cryptd_hash_ctx *ctx;
-	struct crypto_ahash *tfm;
-
-	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
-		     "cryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-EINVAL);
-	tfm = crypto_alloc_ahash(cryptd_alg_name, type, mask);
-	if (IS_ERR(tfm))
-		return ERR_CAST(tfm);
-	if (tfm->base.__crt_alg->cra_module != THIS_MODULE) {
-		crypto_free_ahash(tfm);
-		return ERR_PTR(-EINVAL);
-	}
-
-	ctx = crypto_ahash_ctx(tfm);
-	refcount_set(&ctx->refcnt, 1);
-
-	return __cryptd_ahash_cast(tfm);
-}
-EXPORT_SYMBOL_GPL(cryptd_alloc_ahash);
-
-struct crypto_shash *cryptd_ahash_child(struct cryptd_ahash *tfm)
-{
-	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
-
-	return ctx->child;
-}
-EXPORT_SYMBOL_GPL(cryptd_ahash_child);
-
-struct shash_desc *cryptd_shash_desc(struct ahash_request *req)
-{
-	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-	return &rctx->desc;
-}
-EXPORT_SYMBOL_GPL(cryptd_shash_desc);
-
-bool cryptd_ahash_queued(struct cryptd_ahash *tfm)
-{
-	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
-
-	return refcount_read(&ctx->refcnt) - 1;
-}
-EXPORT_SYMBOL_GPL(cryptd_ahash_queued);
-
-void cryptd_free_ahash(struct cryptd_ahash *tfm)
-{
-	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
-
-	if (refcount_dec_and_test(&ctx->refcnt))
-		crypto_free_ahash(&tfm->base);
-}
-EXPORT_SYMBOL_GPL(cryptd_free_ahash);
-
 struct cryptd_aead *cryptd_alloc_aead(const char *alg_name,
 						  u32 type, u32 mask)
 {
 	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
 	struct cryptd_aead_ctx *ctx;
diff --git a/include/crypto/cryptd.h b/include/crypto/cryptd.h
index 796d986e58e1..29c5878a3609 100644
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -14,43 +14,10 @@
 #define _CRYPTO_CRYPT_H
 
 #include <linux/types.h>
 
 #include <crypto/aead.h>
-#include <crypto/hash.h>
-#include <crypto/skcipher.h>
-
-struct cryptd_skcipher {
-	struct crypto_skcipher base;
-};
-
-/* alg_name should be algorithm to be cryptd-ed */
-struct cryptd_skcipher *cryptd_alloc_skcipher(const char *alg_name,
-					      u32 type, u32 mask);
-struct crypto_skcipher *cryptd_skcipher_child(struct cryptd_skcipher *tfm);
-/* Must be called without moving CPUs. */
-bool cryptd_skcipher_queued(struct cryptd_skcipher *tfm);
-void cryptd_free_skcipher(struct cryptd_skcipher *tfm);
-
-struct cryptd_ahash {
-	struct crypto_ahash base;
-};
-
-static inline struct cryptd_ahash *__cryptd_ahash_cast(
-	struct crypto_ahash *tfm)
-{
-	return (struct cryptd_ahash *)tfm;
-}
-
-/* alg_name should be algorithm to be cryptd-ed */
-struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
-					u32 type, u32 mask);
-struct crypto_shash *cryptd_ahash_child(struct cryptd_ahash *tfm);
-struct shash_desc *cryptd_shash_desc(struct ahash_request *req);
-/* Must be called without moving CPUs. */
-bool cryptd_ahash_queued(struct cryptd_ahash *tfm);
-void cryptd_free_ahash(struct cryptd_ahash *tfm);
 
 struct cryptd_aead {
 	struct crypto_aead base;
 };
 

base-commit: c708d3fad4217f23421b8496e231b0c5cee617a0
prerequisite-patch-id: 81ed16d662b3981bb70c91248b93177679d9ea83
-- 
2.53.0


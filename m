Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96EF346770;
	Sat,  7 Mar 2026 22:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772923577; cv=none; b=kHnRjJnl8qvHtYxNEi4Tb+quhjNqgcAN3zZMuoOsKIEQs/nbiNLNDxjOZJU0tZpGbzM+jPSpmdkxGvmVjrBzRwhFKQhSKR1cZQeAT3b9ibrcXX/Vo7wR7Z/0cB27iMfH8Rps/Ihe248m7GNRMNtkjuklsdXfQIGmoAglhwxTJ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772923577; c=relaxed/simple;
	bh=NaDEjwP1efsfHD7GRkA/+b8LQpDP7b8fj8TiHJoftd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMSXsQv7B98Se5d9Comm7QYiLqtNjDtk7QiTSx6wkAEmHQIB8wgTqfj5gXd7PTVFHPRrAx3GLzka++WrcqVe4e7Plisy2j7lzC3snTZ07a3RqBDbw8WuP95lp9wZf1LfxeGazbH/O9r5S3gXBYwkaM23WJ/G32zetjmwOAVsvOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUDay2dm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUDay2dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ABAC19423;
	Sat,  7 Mar 2026 22:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772923577;
	bh=NaDEjwP1efsfHD7GRkA/+b8LQpDP7b8fj8TiHJoftd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUDay2dmzhc40wywat/XlLuCHs5kjflNQggo4QFHRXd8CK6EDj5fJst6SkEv6kJy/
	 RGj4O24n1d/S44F5/0FFQcIvyc/eRHiVikyt1q/uCfQnzRsRwj+pvMm2bEY6civ3ri
	 6xyCsKOY8s0TI9yFjXorlW9byaceFuBMsRlvNyF1p0N3/MnO+BjB2P7oJS36k8/foy
	 OCmQ/ErPucxvJIWHYFvaLbEBA9Uh8gPNdmSPY+EjVPusQbmPe17G8EDkYS9MDhXeWk
	 NQAiDCvQwG7arXajjAeooWvTVQkMosBJLF3CtI4qHSdvkvwQsM17UTujCL9TKNenCm
	 7Pk23nR/ey0EA==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [RFC PATCH 6/8] crypto: hash - Remove support for cloning hash tfms
Date: Sat,  7 Mar 2026 14:43:39 -0800
Message-ID: <20260307224341.5644-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260307224341.5644-1-ebiggers@kernel.org>
References: <20260307224341.5644-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hash transformation cloning no longer has a user, and there's a good
chance no new one will appear because the library API solves the problem
in a much simpler and more efficient way.  Remove support for it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/ahash.c        | 70 -------------------------------------------
 crypto/cmac.c         | 16 ----------
 crypto/cryptd.c       | 16 ----------
 crypto/hmac.c         | 31 -------------------
 crypto/shash.c        | 37 -----------------------
 include/crypto/hash.h |  8 -----
 6 files changed, 178 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 7a730324c50e2..85dcd120de3ee 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -860,80 +860,10 @@ bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
 
 	return __crypto_ahash_alg(alg)->setkey != ahash_nosetkey;
 }
 EXPORT_SYMBOL_GPL(crypto_hash_alg_has_setkey);
 
-struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
-{
-	struct hash_alg_common *halg = crypto_hash_alg_common(hash);
-	struct crypto_tfm *tfm = crypto_ahash_tfm(hash);
-	struct crypto_ahash *fb = NULL;
-	struct crypto_ahash *nhash;
-	struct ahash_alg *alg;
-	int err;
-
-	if (!crypto_hash_alg_has_setkey(halg)) {
-		tfm = crypto_tfm_get(tfm);
-		if (IS_ERR(tfm))
-			return ERR_CAST(tfm);
-
-		return hash;
-	}
-
-	nhash = crypto_clone_tfm(&crypto_ahash_type, tfm);
-
-	if (IS_ERR(nhash))
-		return nhash;
-
-	nhash->reqsize = hash->reqsize;
-	nhash->statesize = hash->statesize;
-
-	if (likely(hash->using_shash)) {
-		struct crypto_shash **nctx = crypto_ahash_ctx(nhash);
-		struct crypto_shash *shash;
-
-		shash = crypto_clone_shash(ahash_to_shash(hash));
-		if (IS_ERR(shash)) {
-			err = PTR_ERR(shash);
-			goto out_free_nhash;
-		}
-		crypto_ahash_tfm(nhash)->exit = crypto_exit_ahash_using_shash;
-		nhash->using_shash = true;
-		*nctx = shash;
-		return nhash;
-	}
-
-	if (crypto_ahash_need_fallback(hash)) {
-		fb = crypto_clone_ahash(crypto_ahash_fb(hash));
-		err = PTR_ERR(fb);
-		if (IS_ERR(fb))
-			goto out_free_nhash;
-
-		crypto_ahash_tfm(nhash)->fb = crypto_ahash_tfm(fb);
-	}
-
-	err = -ENOSYS;
-	alg = crypto_ahash_alg(hash);
-	if (!alg->clone_tfm)
-		goto out_free_fb;
-
-	err = alg->clone_tfm(nhash, hash);
-	if (err)
-		goto out_free_fb;
-
-	crypto_ahash_tfm(nhash)->exit = crypto_ahash_exit_tfm;
-
-	return nhash;
-
-out_free_fb:
-	crypto_free_ahash(fb);
-out_free_nhash:
-	crypto_free_ahash(nhash);
-	return ERR_PTR(err);
-}
-EXPORT_SYMBOL_GPL(crypto_clone_ahash);
-
 static int ahash_default_export_core(struct ahash_request *req, void *out)
 {
 	return -ENOSYS;
 }
 
diff --git a/crypto/cmac.c b/crypto/cmac.c
index 1b03964abe007..83e58937f0136 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -149,25 +149,10 @@ static int cmac_init_tfm(struct crypto_shash *tfm)
 	ctx->child = cipher;
 
 	return 0;
 }
 
-static int cmac_clone_tfm(struct crypto_shash *tfm, struct crypto_shash *otfm)
-{
-	struct cmac_tfm_ctx *octx = crypto_shash_ctx(otfm);
-	struct cmac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
-	struct crypto_cipher *cipher;
-
-	cipher = crypto_clone_cipher(octx->child);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	ctx->child = cipher;
-
-	return 0;
-}
-
 static void cmac_exit_tfm(struct crypto_shash *tfm)
 {
 	struct cmac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
 	crypto_free_cipher(ctx->child);
 }
@@ -220,11 +205,10 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.init = crypto_cmac_digest_init;
 	inst->alg.update = crypto_cmac_digest_update;
 	inst->alg.finup = crypto_cmac_digest_finup;
 	inst->alg.setkey = crypto_cmac_digest_setkey;
 	inst->alg.init_tfm = cmac_init_tfm;
-	inst->alg.clone_tfm = cmac_clone_tfm;
 	inst->alg.exit_tfm = cmac_exit_tfm;
 
 	inst->free = shash_free_singlespawn_instance;
 
 	err = shash_register_instance(tmpl, inst);
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index cd38f46761767..e2958020f1ae4 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -450,25 +450,10 @@ static int cryptd_hash_init_tfm(struct crypto_ahash *tfm)
 				 sizeof(struct cryptd_hash_request_ctx) +
 				 crypto_shash_descsize(hash));
 	return 0;
 }
 
-static int cryptd_hash_clone_tfm(struct crypto_ahash *ntfm,
-				 struct crypto_ahash *tfm)
-{
-	struct cryptd_hash_ctx *nctx = crypto_ahash_ctx(ntfm);
-	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct crypto_shash *hash;
-
-	hash = crypto_clone_shash(ctx->child);
-	if (IS_ERR(hash))
-		return PTR_ERR(hash);
-
-	nctx->child = hash;
-	return 0;
-}
-
 static void cryptd_hash_exit_tfm(struct crypto_ahash *tfm)
 {
 	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	crypto_free_shash(ctx->child);
@@ -697,11 +682,10 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->alg.halg.digestsize = alg->digestsize;
 	inst->alg.halg.statesize = alg->statesize;
 	inst->alg.halg.base.cra_ctxsize = sizeof(struct cryptd_hash_ctx);
 
 	inst->alg.init_tfm = cryptd_hash_init_tfm;
-	inst->alg.clone_tfm = cryptd_hash_clone_tfm;
 	inst->alg.exit_tfm = cryptd_hash_exit_tfm;
 
 	inst->alg.init   = cryptd_hash_init_enqueue;
 	inst->alg.update = cryptd_hash_update_enqueue;
 	inst->alg.final  = cryptd_hash_final_enqueue;
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 148af460ae974..807e08b252c55 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -156,24 +156,10 @@ static int hmac_init_tfm(struct crypto_shash *parent)
 
 	tctx->hash = hash;
 	return 0;
 }
 
-static int hmac_clone_tfm(struct crypto_shash *dst, struct crypto_shash *src)
-{
-	struct hmac_ctx *sctx = crypto_shash_ctx(src);
-	struct hmac_ctx *dctx = crypto_shash_ctx(dst);
-	struct crypto_shash *hash;
-
-	hash = crypto_clone_shash(sctx->hash);
-	if (IS_ERR(hash))
-		return PTR_ERR(hash);
-
-	dctx->hash = hash;
-	return 0;
-}
-
 static void hmac_exit_tfm(struct crypto_shash *parent)
 {
 	struct hmac_ctx *tctx = crypto_shash_ctx(parent);
 
 	crypto_free_shash(tctx->hash);
@@ -233,11 +219,10 @@ static int __hmac_create_shash(struct crypto_template *tmpl,
 	inst->alg.import = hmac_import;
 	inst->alg.export_core = hmac_export_core;
 	inst->alg.import_core = hmac_import_core;
 	inst->alg.setkey = hmac_setkey;
 	inst->alg.init_tfm = hmac_init_tfm;
-	inst->alg.clone_tfm = hmac_clone_tfm;
 	inst->alg.exit_tfm = hmac_exit_tfm;
 
 	inst->free = shash_free_singlespawn_instance;
 
 	err = shash_register_instance(tmpl, inst);
@@ -421,25 +406,10 @@ static int hmac_init_ahash_tfm(struct crypto_ahash *parent)
 
 	tctx->hash = hash;
 	return 0;
 }
 
-static int hmac_clone_ahash_tfm(struct crypto_ahash *dst,
-				struct crypto_ahash *src)
-{
-	struct ahash_hmac_ctx *sctx = crypto_ahash_ctx(src);
-	struct ahash_hmac_ctx *dctx = crypto_ahash_ctx(dst);
-	struct crypto_ahash *hash;
-
-	hash = crypto_clone_ahash(sctx->hash);
-	if (IS_ERR(hash))
-		return PTR_ERR(hash);
-
-	dctx->hash = hash;
-	return 0;
-}
-
 static void hmac_exit_ahash_tfm(struct crypto_ahash *parent)
 {
 	struct ahash_hmac_ctx *tctx = crypto_ahash_ctx(parent);
 
 	crypto_free_ahash(tctx->hash);
@@ -501,11 +471,10 @@ static int hmac_create_ahash(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->alg.import = hmac_import_ahash;
 	inst->alg.export_core = hmac_export_core_ahash;
 	inst->alg.import_core = hmac_import_core_ahash;
 	inst->alg.setkey = hmac_setkey_ahash;
 	inst->alg.init_tfm = hmac_init_ahash_tfm;
-	inst->alg.clone_tfm = hmac_clone_ahash_tfm;
 	inst->alg.exit_tfm = hmac_exit_ahash_tfm;
 
 	inst->free = ahash_free_singlespawn_instance;
 
 	err = ahash_register_instance(tmpl, inst);
diff --git a/crypto/shash.c b/crypto/shash.c
index 2f07d0bd1f61b..351cba3c11070 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -393,47 +393,10 @@ int crypto_has_shash(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_shash_type, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_has_shash);
 
-struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
-{
-	struct crypto_tfm *tfm = crypto_shash_tfm(hash);
-	struct shash_alg *alg = crypto_shash_alg(hash);
-	struct crypto_shash *nhash;
-	int err;
-
-	if (!crypto_shash_alg_has_setkey(alg)) {
-		tfm = crypto_tfm_get(tfm);
-		if (IS_ERR(tfm))
-			return ERR_CAST(tfm);
-
-		return hash;
-	}
-
-	if (!alg->clone_tfm && (alg->init_tfm || alg->base.cra_init))
-		return ERR_PTR(-ENOSYS);
-
-	nhash = crypto_clone_tfm(&crypto_shash_type, tfm);
-	if (IS_ERR(nhash))
-		return nhash;
-
-	if (alg->clone_tfm) {
-		err = alg->clone_tfm(nhash, hash);
-		if (err) {
-			crypto_free_shash(nhash);
-			return ERR_PTR(err);
-		}
-	}
-
-	if (alg->exit_tfm)
-		crypto_shash_tfm(nhash)->exit = crypto_shash_exit_tfm;
-
-	return nhash;
-}
-EXPORT_SYMBOL_GPL(crypto_clone_shash);
-
 int hash_prepare_alg(struct hash_alg_common *alg)
 {
 	struct crypto_alg *base = &alg->base;
 
 	if (alg->digestsize > HASH_MAX_DIGESTSIZE)
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 586700332c731..e474f8461ea19 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -146,11 +146,10 @@ struct ahash_request {
  *	      requirement of the transformation and put any software
  *	      fallbacks in place.
  * @exit_tfm: Deinitialize the cryptographic transformation object.
  *	      This is a counterpart to @init_tfm, used to remove
  *	      various changes set in @init_tfm.
- * @clone_tfm: Copy transform into new object, may allocate memory.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
 	int (*init)(struct ahash_request *req);
 	int (*update)(struct ahash_request *req);
@@ -163,11 +162,10 @@ struct ahash_alg {
 	int (*import_core)(struct ahash_request *req, const void *in);
 	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
 		      unsigned int keylen);
 	int (*init_tfm)(struct crypto_ahash *tfm);
 	void (*exit_tfm)(struct crypto_ahash *tfm);
-	int (*clone_tfm)(struct crypto_ahash *dst, struct crypto_ahash *src);
 
 	struct hash_alg_common halg;
 };
 
 struct shash_desc {
@@ -237,11 +235,10 @@ struct shash_desc {
  *	      requirement of the transformation and put any software
  *	      fallbacks in place.
  * @exit_tfm: Deinitialize the cryptographic transformation object.
  *	      This is a counterpart to @init_tfm, used to remove
  *	      various changes set in @init_tfm.
- * @clone_tfm: Copy transform into new object, may allocate memory.
  * @descsize: Size of the operational state for the message digest. This state
  * 	      size is the memory size that needs to be allocated for
  *	      shash_desc.__ctx
  * @halg: see struct hash_alg_common
  * @HASH_ALG_COMMON: see struct hash_alg_common
@@ -261,11 +258,10 @@ struct shash_alg {
 	int (*import_core)(struct shash_desc *desc, const void *in);
 	int (*setkey)(struct crypto_shash *tfm, const u8 *key,
 		      unsigned int keylen);
 	int (*init_tfm)(struct crypto_shash *tfm);
 	void (*exit_tfm)(struct crypto_shash *tfm);
-	int (*clone_tfm)(struct crypto_shash *dst, struct crypto_shash *src);
 
 	unsigned int descsize;
 
 	union {
 		struct HASH_ALG_COMMON;
@@ -320,12 +316,10 @@ static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_tfm *tfm)
  *	   of an error, PTR_ERR() returns the error code.
  */
 struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
 					u32 mask);
 
-struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *tfm);
-
 static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
 {
 	return &tfm->base;
 }
 
@@ -757,12 +751,10 @@ static inline void ahash_request_set_virt(struct ahash_request *req,
  *	   of an error, PTR_ERR() returns the error code.
  */
 struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
 					u32 mask);
 
-struct crypto_shash *crypto_clone_shash(struct crypto_shash *tfm);
-
 int crypto_has_shash(const char *alg_name, u32 type, u32 mask);
 
 static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
 {
 	return &tfm->base;
-- 
2.53.0


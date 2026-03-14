Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDFB330328;
	Sat, 14 Mar 2026 21:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773524324; cv=none; b=nLx/NhvlbKwhT0YJ1OxfsPDDxFWHBmPM2W3bh/DqEK53cPDYUtaIgKrIPfj0LLph2ul6I6Ae5aBqAIQLRPciphJbfnGR8i8zA3ieSGh5H85cDWqTK/RVsbyZ9ChoXL2e+xvuTsCKyOWIpRCsqWPGDc0R1Bbua8Pca7AnhQ8xEAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773524324; c=relaxed/simple;
	bh=f/UzhbLMWmIT+jvQzwOqvUeSfnVCrAz9+d4N0vjRNHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MfmxgrRjXux4VmwyFGjrZhYiAnpSNHmxyFIkJEzuaU5HC60kQXZFoz6514arqocgJmjPl+q680Bbq2yyJ26mig1DSmzLaKcMx3bzAgsYIsijhOUpOeBRhc8m9L3Tuk/KngigKfZ639HAhYG0oySNKAw9tGLwaoB/wc06JMtp+Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+ydxqrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+ydxqrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C10CC116C6;
	Sat, 14 Mar 2026 21:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773524324;
	bh=f/UzhbLMWmIT+jvQzwOqvUeSfnVCrAz9+d4N0vjRNHE=;
	h=From:To:Cc:Subject:Date:From;
	b=j+ydxqrb50vIfMk289r8NAPgRxpwrA5TkaO3G7rmRjcKxfkkzlWTlTLvlSiBXNoeM
	 SH99MNj1awacKEfqfxHX/igZAIrVJBz4NPSwefUsgUSMo+bcy2AV8FFFpUZ3tlowfC
	 EfLTb+sfS5Yx/kGHrnPerM75Yy5AhhpbQFBVzP6oAlyAfWTAMeZ9o28sZCMsm5EsEo
	 5u0PRWGR9M4nxJCK/2g0oRfkrQxMyegtM+F4+vRPCLEk163AnzV7/TC7LaQsMnMAoa
	 nFKng6N91wOVzGBQRBlqv5q8Jc56Z2/0wotZ10JAQ9dHu3e7yAa3Kf/pXzUtgtn54Z
	 ZvlmvLjVNTFRg==
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: simd - Remove unused skcipher support
Date: Sat, 14 Mar 2026 14:37:20 -0700
Message-ID: <20260314213720.91525-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the skcipher algorithm support from crypto/simd.c.  It is no
longer used, and it is unlikely to gain any new user in the future,
given the performance issues with this code.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting cryptodev/master

 crypto/simd.c                  | 231 +--------------------------------
 include/crypto/internal/simd.h |  19 ---
 2 files changed, 5 insertions(+), 245 deletions(-)

diff --git a/crypto/simd.c b/crypto/simd.c
index f71c4a334c7d0..7cb3333e1763d 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -11,15 +11,15 @@
  *    Author: Huang Ying <ying.huang@intel.com>
  */
 
 /*
  * Shared crypto SIMD helpers.  These functions dynamically create and register
- * an skcipher or AEAD algorithm that wraps another, internal algorithm.  The
- * wrapper ensures that the internal algorithm is only executed in a context
- * where SIMD instructions are usable, i.e. where may_use_simd() returns true.
- * If SIMD is already usable, the wrapper directly calls the internal algorithm.
- * Otherwise it defers execution to a workqueue via cryptd.
+ * an AEAD algorithm that wraps another, internal algorithm.  The wrapper
+ * ensures that the internal algorithm is only executed in a context where SIMD
+ * instructions are usable, i.e. where may_use_simd() returns true.  If SIMD is
+ * already usable, the wrapper directly calls the internal algorithm.  Otherwise
+ * it defers execution to a workqueue via cryptd.
  *
  * This is an alternative to the internal algorithm implementing a fallback for
  * the !may_use_simd() case itself.
  *
  * Note that the wrapper algorithm is asynchronous, i.e. it has the
@@ -28,236 +28,15 @@
  */
 
 #include <crypto/cryptd.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/simd.h>
-#include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/preempt.h>
 #include <asm/simd.h>
 
-/* skcipher support */
-
-struct simd_skcipher_alg {
-	const char *ialg_name;
-	struct skcipher_alg alg;
-};
-
-struct simd_skcipher_ctx {
-	struct cryptd_skcipher *cryptd_tfm;
-};
-
-static int simd_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
-				unsigned int key_len)
-{
-	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_skcipher *child = &ctx->cryptd_tfm->base;
-
-	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(tfm) &
-					 CRYPTO_TFM_REQ_MASK);
-	return crypto_skcipher_setkey(child, key, key_len);
-}
-
-static int simd_skcipher_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_request *subreq;
-	struct crypto_skcipher *child;
-
-	subreq = skcipher_request_ctx(req);
-	*subreq = *req;
-
-	if (!crypto_simd_usable() ||
-	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
-		child = &ctx->cryptd_tfm->base;
-	else
-		child = cryptd_skcipher_child(ctx->cryptd_tfm);
-
-	skcipher_request_set_tfm(subreq, child);
-
-	return crypto_skcipher_encrypt(subreq);
-}
-
-static int simd_skcipher_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_request *subreq;
-	struct crypto_skcipher *child;
-
-	subreq = skcipher_request_ctx(req);
-	*subreq = *req;
-
-	if (!crypto_simd_usable() ||
-	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
-		child = &ctx->cryptd_tfm->base;
-	else
-		child = cryptd_skcipher_child(ctx->cryptd_tfm);
-
-	skcipher_request_set_tfm(subreq, child);
-
-	return crypto_skcipher_decrypt(subreq);
-}
-
-static void simd_skcipher_exit(struct crypto_skcipher *tfm)
-{
-	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	cryptd_free_skcipher(ctx->cryptd_tfm);
-}
-
-static int simd_skcipher_init(struct crypto_skcipher *tfm)
-{
-	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct cryptd_skcipher *cryptd_tfm;
-	struct simd_skcipher_alg *salg;
-	struct skcipher_alg *alg;
-	unsigned reqsize;
-
-	alg = crypto_skcipher_alg(tfm);
-	salg = container_of(alg, struct simd_skcipher_alg, alg);
-
-	cryptd_tfm = cryptd_alloc_skcipher(salg->ialg_name,
-					   CRYPTO_ALG_INTERNAL,
-					   CRYPTO_ALG_INTERNAL);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-
-	ctx->cryptd_tfm = cryptd_tfm;
-
-	reqsize = crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm));
-	reqsize = max(reqsize, crypto_skcipher_reqsize(&cryptd_tfm->base));
-	reqsize += sizeof(struct skcipher_request);
-
-	crypto_skcipher_set_reqsize(tfm, reqsize);
-
-	return 0;
-}
-
-struct simd_skcipher_alg *simd_skcipher_create_compat(struct skcipher_alg *ialg,
-						      const char *algname,
-						      const char *drvname,
-						      const char *basename)
-{
-	struct simd_skcipher_alg *salg;
-	struct skcipher_alg *alg;
-	int err;
-
-	salg = kzalloc_obj(*salg);
-	if (!salg) {
-		salg = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-
-	salg->ialg_name = basename;
-	alg = &salg->alg;
-
-	err = -ENAMETOOLONG;
-	if (snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", algname) >=
-	    CRYPTO_MAX_ALG_NAME)
-		goto out_free_salg;
-
-	if (snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		     drvname) >= CRYPTO_MAX_ALG_NAME)
-		goto out_free_salg;
-
-	alg->base.cra_flags = CRYPTO_ALG_ASYNC |
-		(ialg->base.cra_flags & CRYPTO_ALG_INHERITED_FLAGS);
-	alg->base.cra_priority = ialg->base.cra_priority;
-	alg->base.cra_blocksize = ialg->base.cra_blocksize;
-	alg->base.cra_alignmask = ialg->base.cra_alignmask;
-	alg->base.cra_module = ialg->base.cra_module;
-	alg->base.cra_ctxsize = sizeof(struct simd_skcipher_ctx);
-
-	alg->ivsize = ialg->ivsize;
-	alg->chunksize = ialg->chunksize;
-	alg->min_keysize = ialg->min_keysize;
-	alg->max_keysize = ialg->max_keysize;
-
-	alg->init = simd_skcipher_init;
-	alg->exit = simd_skcipher_exit;
-
-	alg->setkey = simd_skcipher_setkey;
-	alg->encrypt = simd_skcipher_encrypt;
-	alg->decrypt = simd_skcipher_decrypt;
-
-	err = crypto_register_skcipher(alg);
-	if (err)
-		goto out_free_salg;
-
-out:
-	return salg;
-
-out_free_salg:
-	kfree(salg);
-	salg = ERR_PTR(err);
-	goto out;
-}
-EXPORT_SYMBOL_GPL(simd_skcipher_create_compat);
-
-void simd_skcipher_free(struct simd_skcipher_alg *salg)
-{
-	crypto_unregister_skcipher(&salg->alg);
-	kfree(salg);
-}
-EXPORT_SYMBOL_GPL(simd_skcipher_free);
-
-int simd_register_skciphers_compat(struct skcipher_alg *algs, int count,
-				   struct simd_skcipher_alg **simd_algs)
-{
-	int err;
-	int i;
-	const char *algname;
-	const char *drvname;
-	const char *basename;
-	struct simd_skcipher_alg *simd;
-
-	err = crypto_register_skciphers(algs, count);
-	if (err)
-		return err;
-
-	for (i = 0; i < count; i++) {
-		WARN_ON(strncmp(algs[i].base.cra_name, "__", 2));
-		WARN_ON(strncmp(algs[i].base.cra_driver_name, "__", 2));
-		algname = algs[i].base.cra_name + 2;
-		drvname = algs[i].base.cra_driver_name + 2;
-		basename = algs[i].base.cra_driver_name;
-		simd = simd_skcipher_create_compat(algs + i, algname, drvname, basename);
-		err = PTR_ERR(simd);
-		if (IS_ERR(simd))
-			goto err_unregister;
-		simd_algs[i] = simd;
-	}
-	return 0;
-
-err_unregister:
-	simd_unregister_skciphers(algs, count, simd_algs);
-	return err;
-}
-EXPORT_SYMBOL_GPL(simd_register_skciphers_compat);
-
-void simd_unregister_skciphers(struct skcipher_alg *algs, int count,
-			       struct simd_skcipher_alg **simd_algs)
-{
-	int i;
-
-	crypto_unregister_skciphers(algs, count);
-
-	for (i = 0; i < count; i++) {
-		if (simd_algs[i]) {
-			simd_skcipher_free(simd_algs[i]);
-			simd_algs[i] = NULL;
-		}
-	}
-}
-EXPORT_SYMBOL_GPL(simd_unregister_skciphers);
-
-/* AEAD support */
-
 struct simd_aead_alg {
 	const char *ialg_name;
 	struct aead_alg alg;
 };
 
diff --git a/include/crypto/internal/simd.h b/include/crypto/internal/simd.h
index 9e338e7aafbd9..f5e5d7b639519 100644
--- a/include/crypto/internal/simd.h
+++ b/include/crypto/internal/simd.h
@@ -8,29 +8,10 @@
 
 #include <asm/simd.h>
 #include <linux/percpu.h>
 #include <linux/types.h>
 
-/* skcipher support */
-
-struct simd_skcipher_alg;
-struct skcipher_alg;
-
-struct simd_skcipher_alg *simd_skcipher_create_compat(struct skcipher_alg *ialg,
-						      const char *algname,
-						      const char *drvname,
-						      const char *basename);
-void simd_skcipher_free(struct simd_skcipher_alg *alg);
-
-int simd_register_skciphers_compat(struct skcipher_alg *algs, int count,
-				   struct simd_skcipher_alg **simd_algs);
-
-void simd_unregister_skciphers(struct skcipher_alg *algs, int count,
-			       struct simd_skcipher_alg **simd_algs);
-
-/* AEAD support */
-
 struct simd_aead_alg;
 struct aead_alg;
 
 int simd_register_aeads_compat(struct aead_alg *algs, int count,
 			       struct simd_aead_alg **simd_algs);

base-commit: 2c8669bbb7c783dce2541ecb4f24489b2d2175f5
-- 
2.53.0


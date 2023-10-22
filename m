Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21A6C001DF
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjJVITw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbjJVITH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:19:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5015FD67
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6D0C43395
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962730;
        bh=T2ZJiDo+f27sELZt3itiGVHeqhQFxtNwENsoLqKMCLw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=H6cupww/mKmzkA3tsO8XaMybWo1609fEa9rXAu/vvVxErpSvHzOa73HpdkeCL18wf
         5lS64+XgxfhJ949PqQ075UXClNZR4VJQhQq5st+Vnthylhq6bUBiOpi0q6Upt2nLKh
         MsewWQ+t95MZGo20BTutpVjs1JmDrEeBzXAZYdrBEt0Htu6CrwtNNicp4fOPqJkaiu
         GSQ+JvwMAAXxvujYncf0yC1SQBxyPVpxVFwSOZgbQkcSnFG8taPz4nGyRtPy+PtoZi
         ikzHStjtr1g16KIVk29+I4OIlX+N22Nx1xseZj4vC7SpqBQtsjVr92VgeoP2S3QnDQ
         5CVIZNfuIvOGA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 30/30] crypto: ahash - optimize performance when wrapping shash
Date:   Sun, 22 Oct 2023 01:11:00 -0700
Message-ID: <20231022081100.123613-31-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The "ahash" API provides access to both CPU-based and hardware offload-
based implementations of hash algorithms.  Typically the former are
implemented as "shash" algorithms under the hood, while the latter are
implemented as "ahash" algorithms.  The "ahash" API provides access to
both.  Various kernel subsystems use the ahash API because they want to
support hashing hardware offload without using a separate API for it.

Yet, the common case is that a crypto accelerator is not actually being
used, and ahash is just wrapping a CPU-based shash algorithm.

This patch optimizes the ahash API for that common case by eliminating
the extra indirect call for each ahash operation on top of shash.

It also fixes the double-counting of crypto stats in this scenario
(though CONFIG_CRYPTO_STATS should *not* be enabled by anyone interested
in performance anyway...), and it eliminates redundant checking of
CRYPTO_TFM_NEED_KEY.  As a bonus, it also shrinks struct crypto_ahash.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c        | 285 +++++++++++++++++++++---------------------
 crypto/hash.h         |  10 ++
 crypto/shash.c        |   8 +-
 include/crypto/hash.h |  68 +---------
 4 files changed, 167 insertions(+), 204 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 96fec0ca202af..deee55f939dc8 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -20,61 +20,67 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <net/netlink.h>
 
 #include "hash.h"
 
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 
-static int shash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
-			      unsigned int keylen)
+static inline struct crypto_istat_hash *ahash_get_stat(struct ahash_alg *alg)
 {
-	struct crypto_shash **ctx = crypto_ahash_ctx(tfm);
+	return hash_get_stat(&alg->halg);
+}
+
+static inline int crypto_ahash_errstat(struct ahash_alg *alg, int err)
+{
+	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
+		return err;
 
-	return crypto_shash_setkey(*ctx, key, keylen);
+	if (err && err != -EINPROGRESS && err != -EBUSY)
+		atomic64_inc(&ahash_get_stat(alg)->err_cnt);
+
+	return err;
 }
 
-static int shash_async_init(struct ahash_request *req)
+/*
+ * For an ahash tfm that is using an shash algorithm (instead of an ahash
+ * algorithm), this returns the underlying shash tfm.
+ */
+static inline struct crypto_shash *ahash_to_shash(struct crypto_ahash *tfm)
 {
-	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
-	struct shash_desc *desc = ahash_request_ctx(req);
+	return *(struct crypto_shash **)crypto_ahash_ctx(tfm);
+}
 
-	desc->tfm = *ctx;
+static inline struct shash_desc *prepare_shash_desc(struct ahash_request *req,
+						    struct crypto_ahash *tfm)
+{
+	struct shash_desc *desc = ahash_request_ctx(req);
 
-	return crypto_shash_init(desc);
+	desc->tfm = ahash_to_shash(tfm);
+	return desc;
 }
 
 int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc)
 {
 	struct crypto_hash_walk walk;
 	int nbytes;
 
 	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes > 0;
 	     nbytes = crypto_hash_walk_done(&walk, nbytes))
 		nbytes = crypto_shash_update(desc, walk.data, nbytes);
 
 	return nbytes;
 }
 EXPORT_SYMBOL_GPL(shash_ahash_update);
 
-static int shash_async_update(struct ahash_request *req)
-{
-	return shash_ahash_update(req, ahash_request_ctx(req));
-}
-
-static int shash_async_final(struct ahash_request *req)
-{
-	return crypto_shash_final(ahash_request_ctx(req), req->result);
-}
-
 int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc)
 {
 	struct crypto_hash_walk walk;
 	int nbytes;
 
 	nbytes = crypto_hash_walk_first(req, &walk);
 	if (!nbytes)
 		return crypto_shash_final(desc, req->result);
 
 	do {
@@ -82,30 +88,20 @@ int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc)
 			 crypto_shash_finup(desc, walk.data, nbytes,
 					    req->result) :
 			 crypto_shash_update(desc, walk.data, nbytes);
 		nbytes = crypto_hash_walk_done(&walk, nbytes);
 	} while (nbytes > 0);
 
 	return nbytes;
 }
 EXPORT_SYMBOL_GPL(shash_ahash_finup);
 
-static int shash_async_finup(struct ahash_request *req)
-{
-	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
-	struct shash_desc *desc = ahash_request_ctx(req);
-
-	desc->tfm = *ctx;
-
-	return shash_ahash_finup(req, desc);
-}
-
 int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 {
 	unsigned int nbytes = req->nbytes;
 	struct scatterlist *sg;
 	unsigned int offset;
 	int err;
 
 	if (nbytes &&
 	    (sg = req->src, offset = sg->offset,
 	     nbytes <= min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
@@ -116,110 +112,54 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 					  req->result);
 		kunmap_local(data);
 	} else
 		err = crypto_shash_init(desc) ?:
 		      shash_ahash_finup(req, desc);
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(shash_ahash_digest);
 
-static int shash_async_digest(struct ahash_request *req)
-{
-	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
-	struct shash_desc *desc = ahash_request_ctx(req);
-
-	desc->tfm = *ctx;
-
-	return shash_ahash_digest(req, desc);
-}
-
-static int shash_async_export(struct ahash_request *req, void *out)
-{
-	return crypto_shash_export(ahash_request_ctx(req), out);
-}
-
-static int shash_async_import(struct ahash_request *req, const void *in)
-{
-	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
-	struct shash_desc *desc = ahash_request_ctx(req);
-
-	desc->tfm = *ctx;
-
-	return crypto_shash_import(desc, in);
-}
-
-static void crypto_exit_shash_ops_async(struct crypto_tfm *tfm)
+static void crypto_exit_ahash_using_shash(struct crypto_tfm *tfm)
 {
 	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
 
 	crypto_free_shash(*ctx);
 }
 
-static int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
+static int crypto_init_ahash_using_shash(struct crypto_tfm *tfm)
 {
 	struct crypto_alg *calg = tfm->__crt_alg;
-	struct shash_alg *alg = __crypto_shash_alg(calg);
 	struct crypto_ahash *crt = __crypto_ahash_cast(tfm);
 	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
 	struct crypto_shash *shash;
 
 	if (!crypto_mod_get(calg))
 		return -EAGAIN;
 
 	shash = crypto_create_tfm(calg, &crypto_shash_type);
 	if (IS_ERR(shash)) {
 		crypto_mod_put(calg);
 		return PTR_ERR(shash);
 	}
 
+	crt->using_shash = true;
 	*ctx = shash;
-	tfm->exit = crypto_exit_shash_ops_async;
-
-	crt->init = shash_async_init;
-	crt->update = shash_async_update;
-	crt->final = shash_async_final;
-	crt->finup = shash_async_finup;
-	crt->digest = shash_async_digest;
-	if (crypto_shash_alg_has_setkey(alg))
-		crt->setkey = shash_async_setkey;
+	tfm->exit = crypto_exit_ahash_using_shash;
 
 	crypto_ahash_set_flags(crt, crypto_shash_get_flags(shash) &
 				    CRYPTO_TFM_NEED_KEY);
-
-	crt->export = shash_async_export;
-	crt->import = shash_async_import;
-
 	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
 
 	return 0;
 }
 
-static struct crypto_ahash *
-crypto_clone_shash_ops_async(struct crypto_ahash *nhash,
-			     struct crypto_ahash *hash)
-{
-	struct crypto_shash **nctx = crypto_ahash_ctx(nhash);
-	struct crypto_shash **ctx = crypto_ahash_ctx(hash);
-	struct crypto_shash *shash;
-
-	shash = crypto_clone_shash(*ctx);
-	if (IS_ERR(shash)) {
-		crypto_free_ahash(nhash);
-		return ERR_CAST(shash);
-	}
-
-	*nctx = shash;
-
-	return nhash;
-}
-
 static int hash_walk_next(struct crypto_hash_walk *walk)
 {
 	unsigned int offset = walk->offset;
 	unsigned int nbytes = min(walk->entrylen,
 				  ((unsigned int)(PAGE_SIZE)) - offset);
 
 	walk->data = kmap_local_page(walk->pg);
 	walk->data += offset;
 	walk->entrylen -= nbytes;
 	return nbytes;
@@ -283,44 +223,68 @@ int crypto_hash_walk_first(struct ahash_request *req,
 	return hash_walk_new_entry(walk);
 }
 EXPORT_SYMBOL_GPL(crypto_hash_walk_first);
 
 static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
 			  unsigned int keylen)
 {
 	return -ENOSYS;
 }
 
-static void ahash_set_needkey(struct crypto_ahash *tfm)
+static void ahash_set_needkey(struct crypto_ahash *tfm, struct ahash_alg *alg)
 {
-	const struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
-
-	if (tfm->setkey != ahash_nosetkey &&
-	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
+	if (alg->setkey != ahash_nosetkey &&
+	    !(alg->halg.base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
 		crypto_ahash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
 }
 
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen)
 {
-	int err = tfm->setkey(tfm, key, keylen);
+	if (likely(tfm->using_shash)) {
+		struct crypto_shash *shash = ahash_to_shash(tfm);
+		int err;
 
-	if (unlikely(err)) {
-		ahash_set_needkey(tfm);
-		return err;
+		err = crypto_shash_setkey(shash, key, keylen);
+		if (unlikely(err)) {
+			crypto_ahash_set_flags(tfm,
+					       crypto_shash_get_flags(shash) &
+					       CRYPTO_TFM_NEED_KEY);
+			return err;
+		}
+	} else {
+		struct ahash_alg *alg = crypto_ahash_alg(tfm);
+		int err;
+
+		err = alg->setkey(tfm, key, keylen);
+		if (unlikely(err)) {
+			ahash_set_needkey(tfm, alg);
+			return err;
+		}
 	}
-
 	crypto_ahash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
+int crypto_ahash_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	if (likely(tfm->using_shash))
+		return crypto_shash_init(prepare_shash_desc(req, tfm));
+	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+	return crypto_ahash_alg(tfm)->init(req);
+}
+EXPORT_SYMBOL_GPL(crypto_ahash_init);
+
 static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt,
 			  bool has_state)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	unsigned int ds = crypto_ahash_digestsize(tfm);
 	struct ahash_request *subreq;
 	unsigned int subreq_size;
 	unsigned int reqsize;
 	u8 *result;
 	gfp_t gfp;
@@ -370,67 +334,92 @@ static void ahash_restore_req(struct ahash_request *req, int err)
 
 	if (!err)
 		memcpy(req->result, subreq->result,
 		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
 
 	req->priv = NULL;
 
 	kfree_sensitive(subreq);
 }
 
-int crypto_ahash_final(struct ahash_request *req)
+int crypto_ahash_update(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
+	struct ahash_alg *alg;
 
+	if (likely(tfm->using_shash))
+		return shash_ahash_update(req, ahash_request_ctx(req));
+
+	alg = crypto_ahash_alg(tfm);
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
-		atomic64_inc(&hash_get_stat(alg)->hash_cnt);
+		atomic64_add(req->nbytes, &ahash_get_stat(alg)->hash_tlen);
+	return crypto_ahash_errstat(alg, alg->update(req));
+}
+EXPORT_SYMBOL_GPL(crypto_ahash_update);
+
+int crypto_ahash_final(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ahash_alg *alg;
+
+	if (likely(tfm->using_shash))
+		return crypto_shash_final(ahash_request_ctx(req), req->result);
 
-	return crypto_hash_errstat(alg, tfm->final(req));
+	alg = crypto_ahash_alg(tfm);
+	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
+		atomic64_inc(&ahash_get_stat(alg)->hash_cnt);
+	return crypto_ahash_errstat(alg, alg->final(req));
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_final);
 
 int crypto_ahash_finup(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
+	struct ahash_alg *alg;
+
+	if (likely(tfm->using_shash))
+		return shash_ahash_finup(req, ahash_request_ctx(req));
 
+	alg = crypto_ahash_alg(tfm);
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
-		struct crypto_istat_hash *istat = hash_get_stat(alg);
+		struct crypto_istat_hash *istat = ahash_get_stat(alg);
 
 		atomic64_inc(&istat->hash_cnt);
 		atomic64_add(req->nbytes, &istat->hash_tlen);
 	}
-
-	return crypto_hash_errstat(alg, tfm->finup(req));
+	return crypto_ahash_errstat(alg, alg->finup(req));
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
 
 int crypto_ahash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
+	struct ahash_alg *alg;
 	int err;
 
+	if (likely(tfm->using_shash))
+		return shash_ahash_digest(req, prepare_shash_desc(req, tfm));
+
+	alg = crypto_ahash_alg(tfm);
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
-		struct crypto_istat_hash *istat = hash_get_stat(alg);
+		struct crypto_istat_hash *istat = ahash_get_stat(alg);
 
 		atomic64_inc(&istat->hash_cnt);
 		atomic64_add(req->nbytes, &istat->hash_tlen);
 	}
 
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		err = -ENOKEY;
 	else
-		err = tfm->digest(req);
+		err = alg->digest(req);
 
-	return crypto_hash_errstat(alg, err);
+	return crypto_ahash_errstat(alg, err);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_digest);
 
 static void ahash_def_finup_done2(void *data, int err)
 {
 	struct ahash_request *areq = data;
 
 	if (err == -EINPROGRESS)
 		return;
 
@@ -441,21 +430,21 @@ static void ahash_def_finup_done2(void *data, int err)
 
 static int ahash_def_finup_finish1(struct ahash_request *req, int err)
 {
 	struct ahash_request *subreq = req->priv;
 
 	if (err)
 		goto out;
 
 	subreq->base.complete = ahash_def_finup_done2;
 
-	err = crypto_ahash_reqtfm(req)->final(subreq);
+	err = crypto_ahash_alg(crypto_ahash_reqtfm(req))->final(subreq);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
 out:
 	ahash_restore_req(req, err);
 	return err;
 }
 
 static void ahash_def_finup_done1(void *data, int err)
 {
@@ -478,59 +467,68 @@ static void ahash_def_finup_done1(void *data, int err)
 
 static int ahash_def_finup(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	int err;
 
 	err = ahash_save_req(req, ahash_def_finup_done1, true);
 	if (err)
 		return err;
 
-	err = tfm->update(req->priv);
+	err = crypto_ahash_alg(tfm)->update(req->priv);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
 	return ahash_def_finup_finish1(req, err);
 }
 
+int crypto_ahash_export(struct ahash_request *req, void *out)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	if (likely(tfm->using_shash))
+		return crypto_shash_export(ahash_request_ctx(req), out);
+	return crypto_ahash_alg(tfm)->export(req, out);
+}
+EXPORT_SYMBOL_GPL(crypto_ahash_export);
+
+int crypto_ahash_import(struct ahash_request *req, const void *in)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	if (likely(tfm->using_shash))
+		return crypto_shash_import(prepare_shash_desc(req, tfm), in);
+	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+	return crypto_ahash_alg(tfm)->import(req, in);
+}
+EXPORT_SYMBOL_GPL(crypto_ahash_import);
+
 static void crypto_ahash_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
 	alg->exit_tfm(hash);
 }
 
 static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
-	hash->setkey = ahash_nosetkey;
-
 	crypto_ahash_set_statesize(hash, alg->halg.statesize);
 
 	if (tfm->__crt_alg->cra_type == &crypto_shash_type)
-		return crypto_init_shash_ops_async(tfm);
-
-	hash->init = alg->init;
-	hash->update = alg->update;
-	hash->final = alg->final;
-	hash->finup = alg->finup ?: ahash_def_finup;
-	hash->digest = alg->digest;
-	hash->export = alg->export;
-	hash->import = alg->import;
-
-	if (alg->setkey) {
-		hash->setkey = alg->setkey;
-		ahash_set_needkey(hash);
-	}
+		return crypto_init_ahash_using_shash(tfm);
+
+	ahash_set_needkey(hash, alg);
 
 	if (alg->exit_tfm)
 		tfm->exit = crypto_ahash_exit_tfm;
 
 	return alg->init_tfm ? alg->init_tfm(hash) : 0;
 }
 
 static unsigned int crypto_ahash_extsize(struct crypto_alg *alg)
 {
 	if (alg->cra_type == &crypto_shash_type)
@@ -634,33 +632,35 @@ struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
 			return ERR_CAST(tfm);
 
 		return hash;
 	}
 
 	nhash = crypto_clone_tfm(&crypto_ahash_type, tfm);
 
 	if (IS_ERR(nhash))
 		return nhash;
 
-	nhash->init = hash->init;
-	nhash->update = hash->update;
-	nhash->final = hash->final;
-	nhash->finup = hash->finup;
-	nhash->digest = hash->digest;
-	nhash->export = hash->export;
-	nhash->import = hash->import;
-	nhash->setkey = hash->setkey;
 	nhash->reqsize = hash->reqsize;
 	nhash->statesize = hash->statesize;
 
-	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
-		return crypto_clone_shash_ops_async(nhash, hash);
+	if (likely(hash->using_shash)) {
+		struct crypto_shash **nctx = crypto_ahash_ctx(nhash);
+		struct crypto_shash *shash;
+
+		shash = crypto_clone_shash(ahash_to_shash(hash));
+		if (IS_ERR(shash)) {
+			err = PTR_ERR(shash);
+			goto out_free_nhash;
+		}
+		*nctx = shash;
+		return nhash;
+	}
 
 	err = -ENOSYS;
 	alg = crypto_ahash_alg(hash);
 	if (!alg->clone_tfm)
 		goto out_free_nhash;
 
 	err = alg->clone_tfm(nhash, hash);
 	if (err)
 		goto out_free_nhash;
 
@@ -680,20 +680,25 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	if (alg->halg.statesize == 0)
 		return -EINVAL;
 
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
 
 	base->cra_type = &crypto_ahash_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_AHASH;
 
+	if (!alg->finup)
+		alg->finup = ahash_def_finup;
+	if (!alg->setkey)
+		alg->setkey = ahash_nosetkey;
+
 	return 0;
 }
 
 int crypto_register_ahash(struct ahash_alg *alg)
 {
 	struct crypto_alg *base = &alg->halg.base;
 	int err;
 
 	err = ahash_prepare_alg(alg);
 	if (err)
@@ -754,16 +759,16 @@ int ahash_register_instance(struct crypto_template *tmpl,
 }
 EXPORT_SYMBOL_GPL(ahash_register_instance);
 
 bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
 {
 	struct crypto_alg *alg = &halg->base;
 
 	if (alg->cra_type == &crypto_shash_type)
 		return crypto_shash_alg_has_setkey(__crypto_shash_alg(alg));
 
-	return __crypto_ahash_alg(alg)->setkey != NULL;
+	return __crypto_ahash_alg(alg)->setkey != ahash_nosetkey;
 }
 EXPORT_SYMBOL_GPL(crypto_hash_alg_has_setkey);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/crypto/hash.h b/crypto/hash.h
index de2ee2f4ae304..93f6ba0df263e 100644
--- a/crypto/hash.h
+++ b/crypto/hash.h
@@ -5,20 +5,30 @@
  * Copyright (c) 2023 Herbert Xu <herbert@gondor.apana.org.au>
  */
 #ifndef _LOCAL_CRYPTO_HASH_H
 #define _LOCAL_CRYPTO_HASH_H
 
 #include <crypto/internal/hash.h>
 #include <linux/cryptouser.h>
 
 #include "internal.h"
 
+static inline struct crypto_istat_hash *hash_get_stat(
+	struct hash_alg_common *alg)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	return &alg->stat;
+#else
+	return NULL;
+#endif
+}
+
 static inline int crypto_hash_report_stat(struct sk_buff *skb,
 					  struct crypto_alg *alg,
 					  const char *type)
 {
 	struct hash_alg_common *halg = __crypto_hash_alg_common(alg);
 	struct crypto_istat_hash *istat = hash_get_stat(halg);
 	struct crypto_stat_hash rhash;
 
 	memset(&rhash, 0, sizeof(rhash));
 
diff --git a/crypto/shash.c b/crypto/shash.c
index 28092ed8415a7..d5194221c88cb 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -16,21 +16,27 @@
 
 #include "hash.h"
 
 static inline struct crypto_istat_hash *shash_get_stat(struct shash_alg *alg)
 {
 	return hash_get_stat(&alg->halg);
 }
 
 static inline int crypto_shash_errstat(struct shash_alg *alg, int err)
 {
-	return crypto_hash_errstat(&alg->halg, err);
+	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
+		return err;
+
+	if (err && err != -EINPROGRESS && err != -EBUSY)
+		atomic64_inc(&shash_get_stat(alg)->err_cnt);
+
+	return err;
 }
 
 int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
 		    unsigned int keylen)
 {
 	return -ENOSYS;
 }
 EXPORT_SYMBOL_GPL(shash_no_setkey);
 
 static void shash_set_needkey(struct crypto_shash *tfm, struct shash_alg *alg)
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index b00a4a36a8ec3..c7bdbece27ccb 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -243,30 +243,21 @@ struct shash_alg {
 
 	union {
 		struct HASH_ALG_COMMON;
 		struct hash_alg_common halg;
 	};
 };
 #undef HASH_ALG_COMMON
 #undef HASH_ALG_COMMON_STAT
 
 struct crypto_ahash {
-	int (*init)(struct ahash_request *req);
-	int (*update)(struct ahash_request *req);
-	int (*final)(struct ahash_request *req);
-	int (*finup)(struct ahash_request *req);
-	int (*digest)(struct ahash_request *req);
-	int (*export)(struct ahash_request *req, void *out);
-	int (*import)(struct ahash_request *req, const void *in);
-	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
-		      unsigned int keylen);
-
+	bool using_shash; /* Underlying algorithm is shash, not ahash */
 	unsigned int statesize;
 	unsigned int reqsize;
 	struct crypto_tfm base;
 };
 
 struct crypto_shash {
 	unsigned int descsize;
 	struct crypto_tfm base;
 };
 
@@ -506,109 +497,60 @@ int crypto_ahash_digest(struct ahash_request *req);
  * crypto_ahash_export() - extract current message digest state
  * @req: reference to the ahash_request handle whose state is exported
  * @out: output buffer of sufficient size that can hold the hash state
  *
  * This function exports the hash state of the ahash_request handle into the
  * caller-allocated output buffer out which must have sufficient size (e.g. by
  * calling crypto_ahash_statesize()).
  *
  * Return: 0 if the export was successful; < 0 if an error occurred
  */
-static inline int crypto_ahash_export(struct ahash_request *req, void *out)
-{
-	return crypto_ahash_reqtfm(req)->export(req, out);
-}
+int crypto_ahash_export(struct ahash_request *req, void *out);
 
 /**
  * crypto_ahash_import() - import message digest state
  * @req: reference to ahash_request handle the state is imported into
  * @in: buffer holding the state
  *
  * This function imports the hash state into the ahash_request handle from the
  * input buffer. That buffer should have been generated with the
  * crypto_ahash_export function.
  *
  * Return: 0 if the import was successful; < 0 if an error occurred
  */
-static inline int crypto_ahash_import(struct ahash_request *req, const void *in)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-
-	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
-
-	return tfm->import(req, in);
-}
+int crypto_ahash_import(struct ahash_request *req, const void *in);
 
 /**
  * crypto_ahash_init() - (re)initialize message digest handle
  * @req: ahash_request handle that already is initialized with all necessary
  *	 data using the ahash_request_* API functions
  *
  * The call (re-)initializes the message digest referenced by the ahash_request
  * handle. Any potentially existing state created by previous operations is
  * discarded.
  *
  * Return: see crypto_ahash_final()
  */
-static inline int crypto_ahash_init(struct ahash_request *req)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-
-	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
-
-	return tfm->init(req);
-}
-
-static inline struct crypto_istat_hash *hash_get_stat(
-	struct hash_alg_common *alg)
-{
-#ifdef CONFIG_CRYPTO_STATS
-	return &alg->stat;
-#else
-	return NULL;
-#endif
-}
-
-static inline int crypto_hash_errstat(struct hash_alg_common *alg, int err)
-{
-	if (!IS_ENABLED(CONFIG_CRYPTO_STATS))
-		return err;
-
-	if (err && err != -EINPROGRESS && err != -EBUSY)
-		atomic64_inc(&hash_get_stat(alg)->err_cnt);
-
-	return err;
-}
+int crypto_ahash_init(struct ahash_request *req);
 
 /**
  * crypto_ahash_update() - add data to message digest for processing
  * @req: ahash_request handle that was previously initialized with the
  *	 crypto_ahash_init call.
  *
  * Updates the message digest state of the &ahash_request handle. The input data
  * is pointed to by the scatter/gather list registered in the &ahash_request
  * handle
  *
  * Return: see crypto_ahash_final()
  */
-static inline int crypto_ahash_update(struct ahash_request *req)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
-
-	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
-		atomic64_add(req->nbytes, &hash_get_stat(alg)->hash_tlen);
-
-	return crypto_hash_errstat(alg, tfm->update(req));
-}
+int crypto_ahash_update(struct ahash_request *req);
 
 /**
  * DOC: Asynchronous Hash Request Handle
  *
  * The &ahash_request data structure contains all pointers to data
  * required for the asynchronous cipher operation. This includes the cipher
  * handle (which can be used by multiple &ahash_request instances), pointer
  * to plaintext and the message digest output buffer, asynchronous callback
  * function, etc. It acts as a handle to the ahash_request_* API calls in a
  * similar way as ahash handle to the crypto_ahash_* API calls.
-- 
2.42.0


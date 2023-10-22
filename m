Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC01FCDB474
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjJVITw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjJVITH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:19:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E47D65
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AC5C43391
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962729;
        bh=6WU8MpAPtJfS0/kGhCtDYNcu4Y6wA+p47ogRFLLLlzA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=eK8ig9CG2mKkYuIrhIVwId/kOzG/2SoW0YMbuj5KBLIR/UI0SYpniiFA+j+4/8rzc
         yDWKRTvx0E3ssAOljlPqlpgeSy+IJ9jkB2kimilFVigW0NgaWWBh14kbi/FBEgaIfS
         +c9+fM7PYhzGACcZb910oysW87kgNY56F8JePULxld3N/vrKWqLojUX7FpHBp9/jNZ
         PLGYWKm6YNFZCOOJaPl24YKfJeHHxQsPEFfCPWjLNCTGT/Y77ri7askKD7hd0FqIGG
         us8FNOu4xiFRi+SHodwYfwtoIl19S4ON+3cJFyVEkVU6zPUvukqJKFiNBXYnlDWEDU
         taBK/3QwRGpEw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 28/30] crypto: hash - move "ahash wrapping shash" functions to ahash.c
Date:   Sun, 22 Oct 2023 01:10:58 -0700
Message-ID: <20231022081100.123613-29-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The functions that are involved in implementing the ahash API on top of
an shash algorithm belong better in ahash.c, not in shash.c where they
currently are.  Move them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c | 186 ++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/hash.h  |   4 +-
 crypto/shash.c | 189 +------------------------------------------------
 3 files changed, 188 insertions(+), 191 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 1ad402f4dac6c..74be1eb26c1aa 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -22,20 +22,206 @@
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <net/netlink.h>
 
 #include "hash.h"
 
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 
 static const struct crypto_type crypto_ahash_type;
 
+static int shash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct crypto_shash **ctx = crypto_ahash_ctx(tfm);
+
+	return crypto_shash_setkey(*ctx, key, keylen);
+}
+
+static int shash_async_init(struct ahash_request *req)
+{
+	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct shash_desc *desc = ahash_request_ctx(req);
+
+	desc->tfm = *ctx;
+
+	return crypto_shash_init(desc);
+}
+
+int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc)
+{
+	struct crypto_hash_walk walk;
+	int nbytes;
+
+	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes > 0;
+	     nbytes = crypto_hash_walk_done(&walk, nbytes))
+		nbytes = crypto_shash_update(desc, walk.data, nbytes);
+
+	return nbytes;
+}
+EXPORT_SYMBOL_GPL(shash_ahash_update);
+
+static int shash_async_update(struct ahash_request *req)
+{
+	return shash_ahash_update(req, ahash_request_ctx(req));
+}
+
+static int shash_async_final(struct ahash_request *req)
+{
+	return crypto_shash_final(ahash_request_ctx(req), req->result);
+}
+
+int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc)
+{
+	struct crypto_hash_walk walk;
+	int nbytes;
+
+	nbytes = crypto_hash_walk_first(req, &walk);
+	if (!nbytes)
+		return crypto_shash_final(desc, req->result);
+
+	do {
+		nbytes = crypto_hash_walk_last(&walk) ?
+			 crypto_shash_finup(desc, walk.data, nbytes,
+					    req->result) :
+			 crypto_shash_update(desc, walk.data, nbytes);
+		nbytes = crypto_hash_walk_done(&walk, nbytes);
+	} while (nbytes > 0);
+
+	return nbytes;
+}
+EXPORT_SYMBOL_GPL(shash_ahash_finup);
+
+static int shash_async_finup(struct ahash_request *req)
+{
+	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct shash_desc *desc = ahash_request_ctx(req);
+
+	desc->tfm = *ctx;
+
+	return shash_ahash_finup(req, desc);
+}
+
+int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
+{
+	unsigned int nbytes = req->nbytes;
+	struct scatterlist *sg;
+	unsigned int offset;
+	int err;
+
+	if (nbytes &&
+	    (sg = req->src, offset = sg->offset,
+	     nbytes <= min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
+		void *data;
+
+		data = kmap_local_page(sg_page(sg));
+		err = crypto_shash_digest(desc, data + offset, nbytes,
+					  req->result);
+		kunmap_local(data);
+	} else
+		err = crypto_shash_init(desc) ?:
+		      shash_ahash_finup(req, desc);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(shash_ahash_digest);
+
+static int shash_async_digest(struct ahash_request *req)
+{
+	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct shash_desc *desc = ahash_request_ctx(req);
+
+	desc->tfm = *ctx;
+
+	return shash_ahash_digest(req, desc);
+}
+
+static int shash_async_export(struct ahash_request *req, void *out)
+{
+	return crypto_shash_export(ahash_request_ctx(req), out);
+}
+
+static int shash_async_import(struct ahash_request *req, const void *in)
+{
+	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct shash_desc *desc = ahash_request_ctx(req);
+
+	desc->tfm = *ctx;
+
+	return crypto_shash_import(desc, in);
+}
+
+static void crypto_exit_shash_ops_async(struct crypto_tfm *tfm)
+{
+	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_shash(*ctx);
+}
+
+static int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *calg = tfm->__crt_alg;
+	struct shash_alg *alg = __crypto_shash_alg(calg);
+	struct crypto_ahash *crt = __crypto_ahash_cast(tfm);
+	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
+	struct crypto_shash *shash;
+
+	if (!crypto_mod_get(calg))
+		return -EAGAIN;
+
+	shash = crypto_create_tfm(calg, &crypto_shash_type);
+	if (IS_ERR(shash)) {
+		crypto_mod_put(calg);
+		return PTR_ERR(shash);
+	}
+
+	*ctx = shash;
+	tfm->exit = crypto_exit_shash_ops_async;
+
+	crt->init = shash_async_init;
+	crt->update = shash_async_update;
+	crt->final = shash_async_final;
+	crt->finup = shash_async_finup;
+	crt->digest = shash_async_digest;
+	if (crypto_shash_alg_has_setkey(alg))
+		crt->setkey = shash_async_setkey;
+
+	crypto_ahash_set_flags(crt, crypto_shash_get_flags(shash) &
+				    CRYPTO_TFM_NEED_KEY);
+
+	crt->export = shash_async_export;
+	crt->import = shash_async_import;
+
+	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
+
+	return 0;
+}
+
+static struct crypto_ahash *
+crypto_clone_shash_ops_async(struct crypto_ahash *nhash,
+			     struct crypto_ahash *hash)
+{
+	struct crypto_shash **nctx = crypto_ahash_ctx(nhash);
+	struct crypto_shash **ctx = crypto_ahash_ctx(hash);
+	struct crypto_shash *shash;
+
+	shash = crypto_clone_shash(*ctx);
+	if (IS_ERR(shash)) {
+		crypto_free_ahash(nhash);
+		return ERR_CAST(shash);
+	}
+
+	*nctx = shash;
+
+	return nhash;
+}
+
 static int hash_walk_next(struct crypto_hash_walk *walk)
 {
 	unsigned int offset = walk->offset;
 	unsigned int nbytes = min(walk->entrylen,
 				  ((unsigned int)(PAGE_SIZE)) - offset);
 
 	walk->data = kmap_local_page(walk->pg);
 	walk->data += offset;
 	walk->entrylen -= nbytes;
 	return nbytes;
diff --git a/crypto/hash.h b/crypto/hash.h
index 7e6c1a948692f..de2ee2f4ae304 100644
--- a/crypto/hash.h
+++ b/crypto/hash.h
@@ -24,17 +24,15 @@ static inline int crypto_hash_report_stat(struct sk_buff *skb,
 
 	strscpy(rhash.type, type, sizeof(rhash.type));
 
 	rhash.stat_hash_cnt = atomic64_read(&istat->hash_cnt);
 	rhash.stat_hash_tlen = atomic64_read(&istat->hash_tlen);
 	rhash.stat_err_cnt = atomic64_read(&istat->err_cnt);
 
 	return nla_put(skb, CRYPTOCFGA_STAT_HASH, sizeof(rhash), &rhash);
 }
 
-int crypto_init_shash_ops_async(struct crypto_tfm *tfm);
-struct crypto_ahash *crypto_clone_shash_ops_async(struct crypto_ahash *nhash,
-						  struct crypto_ahash *hash);
+extern const struct crypto_type crypto_shash_type;
 
 int hash_prepare_alg(struct hash_alg_common *alg);
 
 #endif	/* _LOCAL_CRYPTO_HASH_H */
diff --git a/crypto/shash.c b/crypto/shash.c
index 359702c2cd02b..28092ed8415a7 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -9,22 +9,20 @@
 #include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <net/netlink.h>
 
 #include "hash.h"
 
-static const struct crypto_type crypto_shash_type;
-
 static inline struct crypto_istat_hash *shash_get_stat(struct shash_alg *alg)
 {
 	return hash_get_stat(&alg->halg);
 }
 
 static inline int crypto_shash_errstat(struct shash_alg *alg, int err)
 {
 	return crypto_hash_errstat(&alg->halg, err);
 }
 
@@ -186,205 +184,20 @@ int crypto_shash_import(struct shash_desc *desc, const void *in)
 		return -ENOKEY;
 
 	if (shash->import)
 		return shash->import(desc, in);
 
 	memcpy(shash_desc_ctx(desc), in, crypto_shash_descsize(tfm));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_shash_import);
 
-static int shash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
-			      unsigned int keylen)
-{
-	struct crypto_shash **ctx = crypto_ahash_ctx(tfm);
-
-	return crypto_shash_setkey(*ctx, key, keylen);
-}
-
-static int shash_async_init(struct ahash_request *req)
-{
-	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
-	struct shash_desc *desc = ahash_request_ctx(req);
-
-	desc->tfm = *ctx;
-
-	return crypto_shash_init(desc);
-}
-
-int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc)
-{
-	struct crypto_hash_walk walk;
-	int nbytes;
-
-	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes > 0;
-	     nbytes = crypto_hash_walk_done(&walk, nbytes))
-		nbytes = crypto_shash_update(desc, walk.data, nbytes);
-
-	return nbytes;
-}
-EXPORT_SYMBOL_GPL(shash_ahash_update);
-
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
-int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc)
-{
-	struct crypto_hash_walk walk;
-	int nbytes;
-
-	nbytes = crypto_hash_walk_first(req, &walk);
-	if (!nbytes)
-		return crypto_shash_final(desc, req->result);
-
-	do {
-		nbytes = crypto_hash_walk_last(&walk) ?
-			 crypto_shash_finup(desc, walk.data, nbytes,
-					    req->result) :
-			 crypto_shash_update(desc, walk.data, nbytes);
-		nbytes = crypto_hash_walk_done(&walk, nbytes);
-	} while (nbytes > 0);
-
-	return nbytes;
-}
-EXPORT_SYMBOL_GPL(shash_ahash_finup);
-
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
-int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
-{
-	unsigned int nbytes = req->nbytes;
-	struct scatterlist *sg;
-	unsigned int offset;
-	int err;
-
-	if (nbytes &&
-	    (sg = req->src, offset = sg->offset,
-	     nbytes <= min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
-		void *data;
-
-		data = kmap_local_page(sg_page(sg));
-		err = crypto_shash_digest(desc, data + offset, nbytes,
-					  req->result);
-		kunmap_local(data);
-	} else
-		err = crypto_shash_init(desc) ?:
-		      shash_ahash_finup(req, desc);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(shash_ahash_digest);
-
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
-{
-	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
-
-	crypto_free_shash(*ctx);
-}
-
-int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
-{
-	struct crypto_alg *calg = tfm->__crt_alg;
-	struct shash_alg *alg = __crypto_shash_alg(calg);
-	struct crypto_ahash *crt = __crypto_ahash_cast(tfm);
-	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
-	struct crypto_shash *shash;
-
-	if (!crypto_mod_get(calg))
-		return -EAGAIN;
-
-	shash = crypto_create_tfm(calg, &crypto_shash_type);
-	if (IS_ERR(shash)) {
-		crypto_mod_put(calg);
-		return PTR_ERR(shash);
-	}
-
-	*ctx = shash;
-	tfm->exit = crypto_exit_shash_ops_async;
-
-	crt->init = shash_async_init;
-	crt->update = shash_async_update;
-	crt->final = shash_async_final;
-	crt->finup = shash_async_finup;
-	crt->digest = shash_async_digest;
-	if (crypto_shash_alg_has_setkey(alg))
-		crt->setkey = shash_async_setkey;
-
-	crypto_ahash_set_flags(crt, crypto_shash_get_flags(shash) &
-				    CRYPTO_TFM_NEED_KEY);
-
-	crt->export = shash_async_export;
-	crt->import = shash_async_import;
-
-	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
-
-	return 0;
-}
-
-struct crypto_ahash *crypto_clone_shash_ops_async(struct crypto_ahash *nhash,
-						  struct crypto_ahash *hash)
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
 static void crypto_shash_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_shash *hash = __crypto_shash_cast(tfm);
 	struct shash_alg *alg = crypto_shash_alg(hash);
 
 	alg->exit_tfm(hash);
 }
 
 static int crypto_shash_init_tfm(struct crypto_tfm *tfm)
 {
@@ -449,21 +262,21 @@ static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "digestsize   : %u\n", salg->digestsize);
 }
 
 static int __maybe_unused crypto_shash_report_stat(
 	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	return crypto_hash_report_stat(skb, alg, "shash");
 }
 
-static const struct crypto_type crypto_shash_type = {
+const struct crypto_type crypto_shash_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_shash_init_tfm,
 	.free = crypto_shash_free_instance,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_shash_show,
 #endif
 #if IS_ENABLED(CONFIG_CRYPTO_USER)
 	.report = crypto_shash_report,
 #endif
 #ifdef CONFIG_CRYPTO_STATS
-- 
2.42.0


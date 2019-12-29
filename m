Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E01DC2D0DB
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BE5521744
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588297;
	bh=Bp1nngZyJNiSDK1c0ywUkk9ketNZhgaPJMtIp7bq338=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sJcgEM9qwippPByofvRnM/vUmPHkU7XXT0qvk563kAKY0YiSCKw2gagZ4JTyhc6yi
	 RylXFVKDxjA0G/OcXlSW4NjpqzTtQi6vOGoMP/GepEBAjc6SFsMOaPOtYOvhD8ZG/W
	 16TTdydQbTL5HaVvARI/Q0WsUPAZMYmQR7Cz0inQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfL2C6P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbfL2C6O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:14 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55AA221927
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588293;
        bh=Bp1nngZyJNiSDK1c0ywUkk9ketNZhgaPJMtIp7bq338=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Gy1jvR5qhdW4ELDSw+vh7AM2MJbXzkHfJhdjl+NXIAX0veNFe2W/sBIrZhSbgQgyW
         7wiDCWvVWKqf+oo6LjaCWL9mNJCXaNZQ1pc9SLmTkD/0sDt0coqKIwiLDXotXD67MO
         RG4dGI129+fmkCCN4oh7ElAriPGRhBfNZJD+uqy8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 26/28] crypto: algapi - remove obsoleted instance creation helpers
Date:   Sat, 28 Dec 2019 20:57:12 -0600
Message-Id: <20191229025714.544159-27-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229025714.544159-1-ebiggers@kernel.org>
References: <20191229025714.544159-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Remove lots of helper functions that were previously used for
instantiating crypto templates, but are now unused:

- crypto_get_attr_alg() and similar functions looked up an inner
  algorithm directly from a template parameter.  These were replaced
  with getting the algorithm's name, then calling crypto_grab_*().

- crypto_init_spawn() and similar functions initialized a spawn, given
  an algorithm.  Similarly, these were replaced with crypto_grab_*().

- crypto_alloc_instance() and similar functions allocated an instance
  with a single spawn, given the inner algorithm.  These aren't useful
  anymore since crypto_grab_*() need the instance allocated first.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c                 | 25 ---------------
 crypto/algapi.c                | 57 ----------------------------------
 crypto/shash.c                 | 19 ------------
 include/crypto/algapi.h        | 22 -------------
 include/crypto/internal/hash.h | 31 ------------------
 5 files changed, 154 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index e98a1398ed7f..2b8449fdb93c 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -655,31 +655,6 @@ int ahash_register_instance(struct crypto_template *tmpl,
 }
 EXPORT_SYMBOL_GPL(ahash_register_instance);
 
-void ahash_free_instance(struct crypto_instance *inst)
-{
-	crypto_drop_spawn(crypto_instance_ctx(inst));
-	kfree(ahash_instance(inst));
-}
-EXPORT_SYMBOL_GPL(ahash_free_instance);
-
-int crypto_init_ahash_spawn(struct crypto_ahash_spawn *spawn,
-			    struct hash_alg_common *alg,
-			    struct crypto_instance *inst)
-{
-	return crypto_init_spawn2(&spawn->base, &alg->base, inst,
-				  &crypto_ahash_type);
-}
-EXPORT_SYMBOL_GPL(crypto_init_ahash_spawn);
-
-struct hash_alg_common *ahash_attr_alg(struct rtattr *rta, u32 type, u32 mask)
-{
-	struct crypto_alg *alg;
-
-	alg = crypto_attr_alg2(rta, &crypto_ahash_type, type, mask);
-	return IS_ERR(alg) ? ERR_CAST(alg) : __crypto_hash_alg_common(alg);
-}
-EXPORT_SYMBOL_GPL(ahash_attr_alg);
-
 bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
 {
 	struct crypto_alg *alg = &halg->base;
diff --git a/crypto/algapi.c b/crypto/algapi.c
index a25ce02918f8..f66a4ff57e6e 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -697,23 +697,6 @@ int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 }
 EXPORT_SYMBOL_GPL(crypto_init_spawn);
 
-int crypto_init_spawn2(struct crypto_spawn *spawn, struct crypto_alg *alg,
-		       struct crypto_instance *inst,
-		       const struct crypto_type *frontend)
-{
-	int err = -EINVAL;
-
-	if ((alg->cra_flags ^ frontend->type) & frontend->maskset)
-		goto out;
-
-	spawn->frontend = frontend;
-	err = crypto_init_spawn(spawn, alg, inst, frontend->maskset);
-
-out:
-	return err;
-}
-EXPORT_SYMBOL_GPL(crypto_init_spawn2);
-
 int crypto_grab_spawn(struct crypto_spawn *spawn, struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask)
 {
@@ -876,20 +859,6 @@ const char *crypto_attr_alg_name(struct rtattr *rta)
 }
 EXPORT_SYMBOL_GPL(crypto_attr_alg_name);
 
-struct crypto_alg *crypto_attr_alg2(struct rtattr *rta,
-				    const struct crypto_type *frontend,
-				    u32 type, u32 mask)
-{
-	const char *name;
-
-	name = crypto_attr_alg_name(rta);
-	if (IS_ERR(name))
-		return ERR_CAST(name);
-
-	return crypto_find_alg(name, frontend, type, mask);
-}
-EXPORT_SYMBOL_GPL(crypto_attr_alg2);
-
 int crypto_attr_u32(struct rtattr *rta, u32 *num)
 {
 	struct crypto_attr_u32 *nu32;
@@ -923,32 +892,6 @@ int crypto_inst_setname(struct crypto_instance *inst, const char *name,
 }
 EXPORT_SYMBOL_GPL(crypto_inst_setname);
 
-void *crypto_alloc_instance(const char *name, struct crypto_alg *alg,
-			    unsigned int head)
-{
-	struct crypto_instance *inst;
-	char *p;
-	int err;
-
-	p = kzalloc(head + sizeof(*inst) + sizeof(struct crypto_spawn),
-		    GFP_KERNEL);
-	if (!p)
-		return ERR_PTR(-ENOMEM);
-
-	inst = (void *)(p + head);
-
-	err = crypto_inst_setname(inst, name, alg);
-	if (err)
-		goto err_free_inst;
-
-	return p;
-
-err_free_inst:
-	kfree(p);
-	return ERR_PTR(err);
-}
-EXPORT_SYMBOL_GPL(crypto_alloc_instance);
-
 void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen)
 {
 	INIT_LIST_HEAD(&queue->list);
diff --git a/crypto/shash.c b/crypto/shash.c
index e0872ac2729a..4d6ccb59e126 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -584,24 +584,5 @@ void shash_free_instance(struct crypto_instance *inst)
 }
 EXPORT_SYMBOL_GPL(shash_free_instance);
 
-int crypto_init_shash_spawn(struct crypto_shash_spawn *spawn,
-			    struct shash_alg *alg,
-			    struct crypto_instance *inst)
-{
-	return crypto_init_spawn2(&spawn->base, &alg->base, inst,
-				  &crypto_shash_type);
-}
-EXPORT_SYMBOL_GPL(crypto_init_shash_spawn);
-
-struct shash_alg *shash_attr_alg(struct rtattr *rta, u32 type, u32 mask)
-{
-	struct crypto_alg *alg;
-
-	alg = crypto_attr_alg2(rta, &crypto_shash_type, type, mask);
-	return IS_ERR(alg) ? ERR_CAST(alg) :
-	       container_of(alg, struct shash_alg, base);
-}
-EXPORT_SYMBOL_GPL(shash_attr_alg);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Synchronous cryptographic hash type");
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index c7c028472e91..8a43c55a1979 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -113,12 +113,8 @@ void crypto_unregister_instance(struct crypto_instance *inst);
 
 int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 		      struct crypto_instance *inst, u32 mask);
-int crypto_init_spawn2(struct crypto_spawn *spawn, struct crypto_alg *alg,
-		       struct crypto_instance *inst,
-		       const struct crypto_type *frontend);
 int crypto_grab_spawn(struct crypto_spawn *spawn, struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask);
-
 void crypto_drop_spawn(struct crypto_spawn *spawn);
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 				    u32 mask);
@@ -127,21 +123,9 @@ void *crypto_spawn_tfm2(struct crypto_spawn *spawn);
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
 int crypto_check_attr_type(struct rtattr **tb, u32 type);
 const char *crypto_attr_alg_name(struct rtattr *rta);
-struct crypto_alg *crypto_attr_alg2(struct rtattr *rta,
-				    const struct crypto_type *frontend,
-				    u32 type, u32 mask);
-
-static inline struct crypto_alg *crypto_attr_alg(struct rtattr *rta,
-						 u32 type, u32 mask)
-{
-	return crypto_attr_alg2(rta, NULL, type, mask);
-}
-
 int crypto_attr_u32(struct rtattr *rta, u32 *num);
 int crypto_inst_setname(struct crypto_instance *inst, const char *name,
 			struct crypto_alg *alg);
-void *crypto_alloc_instance(const char *name, struct crypto_alg *alg,
-			    unsigned int head);
 
 void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen);
 int crypto_enqueue_request(struct crypto_queue *queue,
@@ -248,12 +232,6 @@ static inline struct crypto_async_request *crypto_get_backlog(
 	       container_of(queue->backlog, struct crypto_async_request, list);
 }
 
-static inline struct crypto_alg *crypto_get_attr_alg(struct rtattr **tb,
-						     u32 type, u32 mask)
-{
-	return crypto_attr_alg(tb[1], type, mask);
-}
-
 static inline int crypto_requires_off(u32 type, u32 mask, u32 off)
 {
 	return (type ^ off) & mask & off;
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index e1024fa0032f..79e561abef61 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -87,7 +87,6 @@ int crypto_register_ahashes(struct ahash_alg *algs, int count);
 void crypto_unregister_ahashes(struct ahash_alg *algs, int count);
 int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst);
-void ahash_free_instance(struct crypto_instance *inst);
 
 int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
 		    unsigned int keylen);
@@ -105,10 +104,6 @@ static inline bool crypto_shash_alg_needs_key(struct shash_alg *alg)
 
 bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg);
 
-int crypto_init_ahash_spawn(struct crypto_ahash_spawn *spawn,
-			    struct hash_alg_common *alg,
-			    struct crypto_instance *inst);
-
 int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
 		      struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask);
@@ -124,8 +119,6 @@ static inline struct hash_alg_common *crypto_spawn_ahash_alg(
 	return __crypto_hash_alg_common(spawn->base.alg);
 }
 
-struct hash_alg_common *ahash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
-
 int crypto_register_shash(struct shash_alg *alg);
 void crypto_unregister_shash(struct shash_alg *alg);
 int crypto_register_shashes(struct shash_alg *algs, int count);
@@ -134,10 +127,6 @@ int shash_register_instance(struct crypto_template *tmpl,
 			    struct shash_instance *inst);
 void shash_free_instance(struct crypto_instance *inst);
 
-int crypto_init_shash_spawn(struct crypto_shash_spawn *spawn,
-			    struct shash_alg *alg,
-			    struct crypto_instance *inst);
-
 int crypto_grab_shash(struct crypto_shash_spawn *spawn,
 		      struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask);
@@ -153,8 +142,6 @@ static inline struct shash_alg *crypto_spawn_shash_alg(
 	return __crypto_shash_alg(spawn->base.alg);
 }
 
-struct shash_alg *shash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
-
 int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
 int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc);
 int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc);
@@ -195,17 +182,6 @@ static inline void *ahash_instance_ctx(struct ahash_instance *inst)
 	return crypto_instance_ctx(ahash_crypto_instance(inst));
 }
 
-static inline unsigned int ahash_instance_headroom(void)
-{
-	return sizeof(struct ahash_alg) - sizeof(struct crypto_alg);
-}
-
-static inline struct ahash_instance *ahash_alloc_instance(
-	const char *name, struct crypto_alg *alg)
-{
-	return crypto_alloc_instance(name, alg, ahash_instance_headroom());
-}
-
 static inline void ahash_request_complete(struct ahash_request *req, int err)
 {
 	req->base.complete(&req->base, err);
@@ -262,13 +238,6 @@ static inline void *shash_instance_ctx(struct shash_instance *inst)
 	return crypto_instance_ctx(shash_crypto_instance(inst));
 }
 
-static inline struct shash_instance *shash_alloc_instance(
-	const char *name, struct crypto_alg *alg)
-{
-	return crypto_alloc_instance(name, alg,
-				     sizeof(struct shash_alg) - sizeof(*alg));
-}
-
 static inline struct crypto_shash *crypto_spawn_shash(
 	struct crypto_shash_spawn *spawn)
 {
-- 
2.24.1


Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE2C21ABC8
	for <linux-crypto@vger.kernel.org>; Mon, 17 Mar 2025 08:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200443; cv=none; b=LYmFkpeduxPL28xRK6Ms5hbkqdQJ0X/B4KCmtePWyBKMuypt0Q8kwM9wP0lxr9bPHVtPygDIdf2YmAXOHESPLwwaMJ/h9X5iWoDz+plHcac8xmu4IzT7J4WnKp7igmS0GihXygvcm0O+pIfMLkd82mRNhIxliuwqzVbPA4cEKuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200443; c=relaxed/simple;
	bh=ffbX1KnIF/OOwWI4YbjBxSDjexreBHyRaQWojGKsQsU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=P70KVctDTe911J2bTwVorX3IEvOe4ipM3dtWH8P32LsSQKTMLiVGLWdBpFI1NSlFg1SNJQfjEfQDP9Br50uWCrGwD4dg1bkTO19qjf4xo563X9yZoyrHfrPSsbg3Gk1gM6W6zg9P/FzpM/b7Akj/3v189/e4ibiqiRjMPKFWhR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gzlagFtv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gzlagFtv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jIWtXz5ZyOCGLSquEkXQDSND3wfG3MzCbvAznjyXJug=; b=gzlagFtvKe9yTqh+VjUHfIAnk4
	XVosye8tvTG53cnDSB8njjEJYTNE5XHEUEQhtxiL4USAJb114clExfnCGTVmJIlqyKibUryIQpRI1
	/YPhlqvDGDaYImcf/t5JPWguizSuXLszs+Fd8dFzI/arJNAcp8DUaA3mmy5vUQEzfFQZejvZcGgEE
	/iOEOLoqAQkHA7j4GxAxKQUYKuLHSxGtiVYy2y3OCG8fGKvhWf+WG1Ab6goxMpoe+xnXJbBYJq3/L
	FTCRoaDBxqs6K+/w+EGMB4uYh3qv7tlh43adFN/FcBm88pF4dSim5g1BYQtsb007x6JcDelntyney
	ozzI8t4g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tu5v3-007UWS-0U;
	Mon, 17 Mar 2025 16:33:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 17 Mar 2025 16:33:57 +0800
Date: Mon, 17 Mar 2025 16:33:57 +0800
Message-Id: <87134afb04c78b317f54b56bbcc01ea495461ce0.1742200161.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742200161.git.herbert@gondor.apana.org.au>
References: <cover.1742200161.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/3] crypto: api - Ensure cra_type->destroy is done in process
 context
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Move the cra_type->destroy call out of crypto_alg_put and into
crypto_unregister_alg and crypto_free_instance.  This ensures
that it's always done in process context so calls such as flush_work
can be done.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c   | 13 ++++++++++---
 crypto/api.c      | 10 ----------
 crypto/internal.h |  3 +--
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 22bf80aad82b..5b8a4c787387 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -66,7 +66,13 @@ static int crypto_check_alg(struct crypto_alg *alg)
 
 static void crypto_free_instance(struct crypto_instance *inst)
 {
-	inst->alg.cra_type->free(inst);
+	struct crypto_alg *alg = &inst->alg;
+	const struct crypto_type *type;
+
+	type = alg->cra_type;
+	if (type->destroy)
+		type->destroy(alg);
+	type->free(inst);
 }
 
 static void crypto_destroy_instance_workfn(struct work_struct *w)
@@ -150,7 +156,6 @@ static void crypto_remove_instance(struct crypto_instance *inst,
 	list_del_init(&inst->alg.cra_list);
 	hlist_del(&inst->list);
 	hlist_add_head(&inst->list, &tmpl->dead);
-	inst->alg.cra_destroy = crypto_destroy_instance;
 
 	BUG_ON(!list_empty(&inst->alg.cra_users));
 
@@ -479,7 +484,8 @@ void crypto_unregister_alg(struct crypto_alg *alg)
 	if (WARN_ON(refcount_read(&alg->cra_refcnt) != 1))
 		return;
 
-	crypto_alg_put(alg);
+	if (alg->cra_type && alg->cra_type->destroy)
+		alg->cra_type->destroy(alg);
 
 	crypto_remove_final(&list);
 }
@@ -637,6 +643,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 
 	inst->alg.cra_module = tmpl->module;
 	inst->alg.cra_flags |= CRYPTO_ALG_INSTANCE;
+	inst->alg.cra_destroy = crypto_destroy_instance;
 
 	down_write(&crypto_alg_sem);
 
diff --git a/crypto/api.c b/crypto/api.c
index 3416e98128a0..2880aa04bb99 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -703,15 +703,5 @@ void crypto_req_done(void *data, int err)
 }
 EXPORT_SYMBOL_GPL(crypto_req_done);
 
-void crypto_destroy_alg(struct crypto_alg *alg)
-{
-	if (alg->cra_type && alg->cra_type->destroy)
-		alg->cra_type->destroy(alg);
-
-	if (alg->cra_destroy)
-		alg->cra_destroy(alg);
-}
-EXPORT_SYMBOL_GPL(crypto_destroy_alg);
-
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
diff --git a/crypto/internal.h b/crypto/internal.h
index 11567ea24fc3..2edefb546ad4 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -128,7 +128,6 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 			const struct crypto_type *frontend, int node);
 void *crypto_clone_tfm(const struct crypto_type *frontend,
 		       struct crypto_tfm *otfm);
-void crypto_destroy_alg(struct crypto_alg *alg);
 
 static inline void *crypto_create_tfm(struct crypto_alg *alg,
 			const struct crypto_type *frontend)
@@ -166,7 +165,7 @@ static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 static inline void crypto_alg_put(struct crypto_alg *alg)
 {
 	if (refcount_dec_and_test(&alg->cra_refcnt))
-		crypto_destroy_alg(alg);
+		alg->cra_destroy(alg);
 }
 
 static inline int crypto_tmpl_get(struct crypto_template *tmpl)
-- 
2.39.5


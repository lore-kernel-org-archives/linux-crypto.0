From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/10] crypto: api - Move type exit function into crypto_tfm
Date: Fri, 07 Nov 2008 16:36:55 +0800
Message-ID: <E1KyMpr-0002kT-Hn@gondolin.me.apana.org.au>
References: <20081107083536.GA10169@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39122 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751450AbYKGIg6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 03:36:58 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KyMps-0006AC-5Q
	for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2008 19:36:56 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: api - Move type exit function into crypto_tfm

The type exit function needs to undo any allocations done by the type
init function.  However, the type init function may differ depending
on the upper-level type of the transform (e.g., a crypto_blkcipher
instantiated as a crypto_ablkcipher).

So we need to move the exit function out of the lower-level
structure and into crypto_tfm itself.

As it stands this is a no-op since nobody uses exit functions at
all.  However, all cases where a lower-level type is instantiated
as a different upper-level type (such as blkcipher as ablkcipher)
will be converted such that they allocate the underlying transform
and use that instead of casting (e.g., crypto_ablkcipher casted
into crypto_blkcipher).  That will need to use a different exit
function depending on the upper-level type.

This patch also allows the type init/exit functions to call (or not)
cra_init/cra_exit instead of always calling them from the top level.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/api.c            |   13 ++++++-------
 include/crypto/algapi.h |    1 -
 include/linux/crypto.h  |    2 ++
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 0444d24..cbaaf34 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -300,8 +300,8 @@ static void crypto_exit_ops(struct crypto_tfm *tfm)
 	const struct crypto_type *type = tfm->__crt_alg->cra_type;
 
 	if (type) {
-		if (type->exit)
-			type->exit(tfm);
+		if (tfm->exit)
+			tfm->exit(tfm);
 		return;
 	}
 
@@ -379,17 +379,16 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 	if (err)
 		goto out_free_tfm;
 
-	if (alg->cra_init && (err = alg->cra_init(tfm))) {
-		if (err == -EAGAIN)
-			crypto_shoot_alg(alg);
+	if (!tfm->exit && alg->cra_init && (err = alg->cra_init(tfm)))
 		goto cra_init_failed;
-	}
 
 	goto out;
 
 cra_init_failed:
 	crypto_exit_ops(tfm);
 out_free_tfm:
+	if (err == -EAGAIN)
+		crypto_shoot_alg(alg);
 	kfree(tfm);
 out_err:
 	tfm = ERR_PTR(err);
@@ -469,7 +468,7 @@ void crypto_free_tfm(struct crypto_tfm *tfm)
 	alg = tfm->__crt_alg;
 	size = sizeof(*tfm) + alg->cra_ctxsize;
 
-	if (alg->cra_exit)
+	if (!tfm->exit && alg->cra_exit)
 		alg->cra_exit(tfm);
 	crypto_exit_ops(tfm);
 	crypto_mod_put(alg);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 60d06e7..5fb6d86 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -23,7 +23,6 @@ struct seq_file;
 struct crypto_type {
 	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
 	int (*init)(struct crypto_tfm *tfm, u32 type, u32 mask);
-	void (*exit)(struct crypto_tfm *tfm);
 	void (*show)(struct seq_file *m, struct crypto_alg *alg);
 };
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 3d2317e..ea52cd9 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -480,6 +480,8 @@ struct crypto_tfm {
 		struct compress_tfm compress;
 		struct rng_tfm rng;
 	} crt_u;
+
+	void (*exit)(struct crypto_tfm *tfm);
 	
 	struct crypto_alg *__crt_alg;
 

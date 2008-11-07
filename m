From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/10] crypto: api - Rebirth of crypto_alloc_tfm
Date: Fri, 07 Nov 2008 16:36:56 +0800
Message-ID: <E1KyMps-0002kc-Ns@gondolin.me.apana.org.au>
References: <20081107083536.GA10169@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39123 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751475AbYKGIg7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 03:36:59 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KyMps-0006AE-Vv
	for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2008 19:36:57 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: api - Rebirth of crypto_alloc_tfm

This patch reintroduces a completely revamped crypto_alloc_tfm.
The biggest change is that we now take two crypto_type objects
when allocating a tfm, a frontend and a backend.  In fact this
simply formalises what we've been doing behind the API's back.

For example, as it stands crypto_alloc_ahash may use an
actual ahash algorithm or a crypto_hash algorithm.  Putting
this in the API allows us to do this much more cleanly.

The existing types will be converted across gradually.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/api.c            |  108 ++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/internal.h       |    2 
 include/crypto/algapi.h |   10 ++++
 include/linux/crypto.h  |    4 +
 4 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index cbaaf34..9975a7b 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -403,6 +403,9 @@ EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
  *	@type: Type of algorithm
  *	@mask: Mask for type comparison
  *
+ *	This function should not be used by new algorithm types.
+ *	Plesae use crypto_alloc_tfm instead.
+ *
  *	crypto_alloc_base() will first attempt to locate an already loaded
  *	algorithm.  If that fails and the kernel supports dynamically loadable
  *	modules, it will then attempt to load a module of the same name or
@@ -449,6 +452,111 @@ err:
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_base);
+
+struct crypto_tfm *crypto_create_tfm(struct crypto_alg *alg,
+				     const struct crypto_type *frontend)
+{
+	char *mem;
+	struct crypto_tfm *tfm = NULL;
+	unsigned int tfmsize;
+	unsigned int total;
+	int err = -ENOMEM;
+
+	tfmsize = frontend->tfmsize;
+	total = tfmsize + sizeof(*tfm) + frontend->extsize(alg, frontend);
+
+	mem = kzalloc(total, GFP_KERNEL);
+	if (mem == NULL)
+		goto out_err;
+
+	tfm = (struct crypto_tfm *)(mem + tfmsize);
+	tfm->__crt_alg = alg;
+
+	err = frontend->init_tfm(tfm, frontend);
+	if (err)
+		goto out_free_tfm;
+
+	if (!tfm->exit && alg->cra_init && (err = alg->cra_init(tfm)))
+		goto cra_init_failed;
+
+	goto out;
+
+cra_init_failed:
+	crypto_exit_ops(tfm);
+out_free_tfm:
+	if (err == -EAGAIN)
+		crypto_shoot_alg(alg);
+	kfree(mem);
+out_err:
+	tfm = ERR_PTR(err);
+out:
+	return tfm;
+}
+EXPORT_SYMBOL_GPL(crypto_create_tfm);
+
+/*
+ *	crypto_alloc_tfm - Locate algorithm and allocate transform
+ *	@alg_name: Name of algorithm
+ *	@frontend: Frontend algorithm type
+ *	@type: Type of algorithm
+ *	@mask: Mask for type comparison
+ *
+ *	crypto_alloc_tfm() will first attempt to locate an already loaded
+ *	algorithm.  If that fails and the kernel supports dynamically loadable
+ *	modules, it will then attempt to load a module of the same name or
+ *	alias.  If that fails it will send a query to any loaded crypto manager
+ *	to construct an algorithm on the fly.  A refcount is grabbed on the
+ *	algorithm which is then associated with the new transform.
+ *
+ *	The returned transform is of a non-determinate type.  Most people
+ *	should use one of the more specific allocation functions such as
+ *	crypto_alloc_blkcipher.
+ *
+ *	In case of error the return value is an error pointer.
+ */
+struct crypto_tfm *crypto_alloc_tfm(const char *alg_name,
+				    const struct crypto_type *frontend,
+				    u32 type, u32 mask)
+{
+	struct crypto_alg *(*lookup)(const char *name, u32 type, u32 mask);
+	struct crypto_tfm *tfm;
+	int err;
+
+	type &= frontend->maskclear;
+	mask &= frontend->maskclear;
+	type |= frontend->type;
+	mask |= frontend->maskset;
+
+	lookup = frontend->lookup ?: crypto_alg_mod_lookup;
+
+	for (;;) {
+		struct crypto_alg *alg;
+
+		alg = lookup(alg_name, type, mask);
+		if (IS_ERR(alg)) {
+			err = PTR_ERR(alg);
+			goto err;
+		}
+
+		tfm = crypto_create_tfm(alg, frontend);
+		if (!IS_ERR(tfm))
+			return tfm;
+
+		crypto_mod_put(alg);
+		err = PTR_ERR(tfm);
+
+err:
+		if (err != -EAGAIN)
+			break;
+		if (signal_pending(current)) {
+			err = -EINTR;
+			break;
+		}
+	}
+
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_tfm);
  
 /*
  *	crypto_free_tfm - Free crypto transform
diff --git a/crypto/internal.h b/crypto/internal.h
index 8ef72d7..3c19a27 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -109,6 +109,8 @@ void crypto_alg_tested(const char *name, int err);
 void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
+struct crypto_tfm *crypto_create_tfm(struct crypto_alg *alg,
+				     const struct crypto_type *frontend);
 
 int crypto_register_instance(struct crypto_template *tmpl,
 			     struct crypto_instance *inst);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 5fb6d86..986db68 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -22,8 +22,18 @@ struct seq_file;
 
 struct crypto_type {
 	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
+	unsigned int (*extsize)(struct crypto_alg *alg,
+				const struct crypto_type *frontend);
 	int (*init)(struct crypto_tfm *tfm, u32 type, u32 mask);
+	int (*init_tfm)(struct crypto_tfm *tfm,
+		        const struct crypto_type *frontend);
 	void (*show)(struct seq_file *m, struct crypto_alg *alg);
+	struct crypto_alg *(*lookup)(const char *name, u32 type, u32 mask);
+
+	unsigned int type;
+	unsigned int maskclear;
+	unsigned int maskset;
+	unsigned int tfmsize;
 };
 
 struct crypto_instance {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ea52cd9..ffaaa41 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -546,7 +546,9 @@ struct crypto_attr_u32 {
  * Transform user interface.
  */
  
-struct crypto_tfm *crypto_alloc_tfm(const char *alg_name, u32 tfm_flags);
+struct crypto_tfm *crypto_alloc_tfm(const char *alg_name,
+				    const struct crypto_type *frontend,
+				    u32 type, u32 mask);
 struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask);
 void crypto_free_tfm(struct crypto_tfm *tfm);
 

From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/6] MODSIGN: In-kernel crypto extensions
Date: Wed, 14 Feb 2007 19:09:49 +0000
Message-ID: <20070214190949.6438.28537.stgit@warthog.cambridge.redhat.com>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, davej@redhat.com,
	arjan@infradead.org, linux-crypto@vger.kernel.org,
	dhowells@redhat.com
To: torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932456AbXBNTKM@vger.kernel.org>
In-Reply-To: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Two extensions are added:

 (1) Support for SHA1 digestion of in-kernel buffers directly without the use
     of scatter-gather lists.

 (2) Allocation of crypto algorithm instances without resort to fallback module
     loading.

SHA1 is used by module signature checking, and so must not itself require
loading as a module when the module signature checking is enabled.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 crypto/api.c           |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 crypto/digest.c        |    9 +++++++++
 include/linux/crypto.h |   11 +++++++++++
 3 files changed, 65 insertions(+), 1 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 55af8bb..3138d7c 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -341,6 +341,45 @@ out:
 EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
 
 /*
+ *	crypto_alloc_tfm2 - Find or load crypto module
+ *	@name: Name of algorithm
+ *	@flags: Flags to control algorithm instance
+ *	@nomodload: True to suppress resort to module loading
+ *
+ *	Attempt to find or load a crypto algorithm module and create an
+ *	instance of it.
+ */
+struct crypto_tfm *crypto_alloc_tfm2(const char *name, u32 flags,
+				     int nomodload)
+{
+	struct crypto_tfm *tfm = NULL;
+	int err;
+
+	do {
+		struct crypto_alg *alg;
+
+		if (!nomodload)
+			alg = crypto_alg_mod_lookup(name, 0, CRYPTO_ALG_ASYNC);
+		else
+			alg = crypto_alg_lookup(name, 0, CRYPTO_ALG_ASYNC);
+
+		err = PTR_ERR(alg);
+		if (IS_ERR(alg))
+			continue;
+
+		tfm = __crypto_alloc_tfm(alg, flags, 0);
+		err = 0;
+		if (IS_ERR(tfm)) {
+			crypto_mod_put(alg);
+			err = PTR_ERR(tfm);
+			tfm = NULL;
+		}
+	} while (err == -EAGAIN && !signal_pending(current));
+
+	return tfm;
+}
+
+/*
  *	crypto_alloc_base - Locate algorithm and allocate transform
  *	@alg_name: Name of algorithm
  *	@type: Type of algorithm
@@ -392,7 +431,12 @@ err:
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_base);
- 
+
+struct crypto_tfm *crypto_alloc_tfm(const char *name, u32 flags)
+{
+	return crypto_alloc_tfm2(name, flags, 0);
+}
+
 /*
  *	crypto_free_tfm - Free crypto transform
  *	@tfm: Transform to free
diff --git a/crypto/digest.c b/crypto/digest.c
index 1bf7414..d03a4e1 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -91,6 +91,14 @@ static int update(struct hash_desc *desc,
 	return update2(desc, sg, nbytes);
 }
 
+static void update_kernel(struct hash_desc *desc,
+			  const void *data, size_t count)
+{
+	struct crypto_tfm *tfm = crypto_hash_tfm(desc->tfm);
+	tfm->__crt_alg->cra_digest.dia_update(tfm, data, count);
+	crypto_yield(desc->flags);
+}
+
 static int final(struct hash_desc *desc, u8 *out)
 {
 	struct crypto_tfm *tfm = crypto_hash_tfm(desc->tfm);
@@ -146,6 +154,7 @@ int crypto_init_digest_ops(struct crypto_tfm *tfm)
 	
 	ops->init	= init;
 	ops->update	= update;
+	ops->update_kernel = update_kernel;
 	ops->final	= final;
 	ops->digest	= digest;
 	ops->setkey	= dalg->dia_setkey ? setkey : nosetkey;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 779aa78..d960ec1 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -273,6 +273,8 @@ struct hash_tfm {
 	int (*init)(struct hash_desc *desc);
 	int (*update)(struct hash_desc *desc,
 		      struct scatterlist *sg, unsigned int nsg);
+	void (*update_kernel)(struct hash_desc *desc,
+			      const void *data, size_t count);
 	int (*final)(struct hash_desc *desc, u8 *out);
 	int (*digest)(struct hash_desc *desc, struct scatterlist *sg,
 		      unsigned int nsg, u8 *out);
@@ -341,6 +343,8 @@ struct crypto_attr_alg {
  */
  
 struct crypto_tfm *crypto_alloc_tfm(const char *alg_name, u32 tfm_flags);
+struct crypto_tfm *crypto_alloc_tfm2(const char *alg_name, u32 tfm_flags,
+		int nomodload);
 struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask);
 void crypto_free_tfm(struct crypto_tfm *tfm);
 
@@ -739,6 +743,13 @@ static inline int crypto_hash_update(struct hash_desc *desc,
 	return crypto_hash_crt(desc->tfm)->update(desc, sg, nbytes);
 }
 
+static inline void crypto_hash_update_kernel(struct hash_desc *desc,
+					     const void *data,
+					     size_t count)
+{
+	return crypto_hash_crt(desc->tfm)->update_kernel(desc, data, count);
+}
+
 static inline int crypto_hash_final(struct hash_desc *desc, u8 *out)
 {
 	return crypto_hash_crt(desc->tfm)->final(desc, out);

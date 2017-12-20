From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH RFC 2/3] crypto: Implement a generic crypto statistics
Date: Wed, 20 Dec 2017 20:09:26 +0000
Message-ID: <1513800567-12764-3-git-send-email-clabbe@baylibre.com>
References: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch implement a generic way to get statistics about all crypto
usages.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/Kconfig             |  11 +++
 crypto/ahash.c             |  18 +++++
 crypto/algapi.c            | 186 +++++++++++++++++++++++++++++++++++++++++++++
 crypto/rng.c               |   3 +
 include/crypto/acompress.h |  10 +++
 include/crypto/akcipher.h  |  12 +++
 include/crypto/kpp.h       |   9 +++
 include/crypto/rng.h       |   5 ++
 include/crypto/skcipher.h  |   8 ++
 include/linux/crypto.h     |  22 ++++++
 10 files changed, 284 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index d6e9b60fc063..69f1822a026b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1781,6 +1781,17 @@ config CRYPTO_USER_API_AEAD
 	  This option enables the user-spaces interface for AEAD
 	  cipher algorithms.
 
+config CRYPTO_STATS
+	bool "Crypto usage statistics for User-space"
+	help
+	  This option enables the gathering of crypto stats.
+	  This will collect:
+	  - encrypt/decrypt size and numbers of symmeric operations
+	  - compress/decompress size and numbers of compress operations
+	  - size and numbers of hash operations
+	  - encrypt/decrypt/sign/verify numbers for asymmetric operations
+	  - generate/seed numbers for rng operations
+
 config CRYPTO_HASH_INFO
 	bool
 
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3a35d67de7d9..93b56892f1b8 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -356,18 +356,36 @@ static int crypto_ahash_op(struct ahash_request *req,
 
 int crypto_ahash_final(struct ahash_request *req)
 {
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	tfm->base.__crt_alg->enc_cnt++;
+	tfm->base.__crt_alg->enc_tlen += req->nbytes;
+#endif
 	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_final);
 
 int crypto_ahash_finup(struct ahash_request *req)
 {
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	tfm->base.__crt_alg->enc_cnt++;
+	tfm->base.__crt_alg->enc_tlen += req->nbytes;
+#endif
 	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
 
 int crypto_ahash_digest(struct ahash_request *req)
 {
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	tfm->base.__crt_alg->enc_cnt++;
+	tfm->base.__crt_alg->enc_tlen += req->nbytes;
+#endif
 	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->digest);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_digest);
diff --git a/crypto/algapi.c b/crypto/algapi.c
index b8f6122f37e9..4fca4576af78 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -20,11 +20,158 @@
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/kobject.h>
 
 #include "internal.h"
 
 static LIST_HEAD(crypto_template_list);
 
+#ifdef CONFIG_CRYPTO_STATS
+static struct kobject *crypto_root_kobj;
+
+static struct kobj_type dynamic_kobj_ktype = {
+	.sysfs_ops      = &kobj_sysfs_ops,
+};
+
+static ssize_t fcrypto_priority(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	struct crypto_alg *alg;
+
+	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
+	return snprintf(buf, 9, "%d\n", alg->cra_priority);
+}
+
+static ssize_t fcrypto_stat_enc_cnt(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	struct crypto_alg *alg;
+
+	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
+	return snprintf(buf, 9, "%lu\n", alg->enc_cnt);
+}
+
+static ssize_t fcrypto_stat_enc_tlen(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	struct crypto_alg *alg;
+
+	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
+	return snprintf(buf, 9, "%lu\n", alg->enc_tlen);
+}
+
+static ssize_t fcrypto_stat_dec_cnt(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	struct crypto_alg *alg;
+
+	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
+	return snprintf(buf, 9, "%lu\n", alg->dec_cnt);
+}
+
+static ssize_t fcrypto_stat_dec_tlen(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	struct crypto_alg *alg;
+
+	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
+	return snprintf(buf, 9, "%lu\n", alg->dec_tlen);
+}
+
+static ssize_t fcrypto_stat_verify_cnt(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
+{
+	struct crypto_alg *alg;
+
+	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
+	return snprintf(buf, 9, "%lu\n", alg->verify_cnt);
+}
+
+static ssize_t fcrypto_stat_sign_cnt(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	struct crypto_alg *alg;
+
+	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
+	return snprintf(buf, 9, "%lu\n", alg->sign_cnt);
+}
+
+static ssize_t fcrypto_stat_type(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *buf)
+{
+	struct crypto_alg *alg;
+	u32 type;
+
+	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
+	type = (alg->cra_flags & CRYPTO_ALG_TYPE_MASK);
+	if (type == CRYPTO_ALG_TYPE_ABLKCIPHER ||
+	    type == CRYPTO_ALG_TYPE_SKCIPHER ||
+	    type == CRYPTO_ALG_TYPE_CIPHER ||
+	    type == CRYPTO_ALG_TYPE_BLKCIPHER
+		)
+		return snprintf(buf, 9, "cipher\n");
+	if (type == CRYPTO_ALG_TYPE_AHASH ||
+	    type == CRYPTO_ALG_TYPE_HASH
+		)
+		return snprintf(buf, 9, "hash\n");
+	if (type == CRYPTO_ALG_TYPE_COMPRESS ||
+	    type == CRYPTO_ALG_TYPE_SCOMPRESS)
+		return snprintf(buf, 11, "compress\n");
+	if (type == CRYPTO_ALG_TYPE_RNG)
+		return snprintf(buf, 9, "rng\n");
+	if (type == CRYPTO_ALG_TYPE_AKCIPHER)
+		return snprintf(buf, 11, "asymetric\n");
+	if (type == CRYPTO_ALG_TYPE_KPP)
+		return snprintf(buf, 4, "kpp\n");
+	return snprintf(buf, 16, "unknown %x\n", type);
+}
+
+static ssize_t fcrypto_stat_algname(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	struct crypto_alg *alg;
+
+	alg = container_of(kobj, struct crypto_alg, cra_stat_obj);
+	return snprintf(buf, 32, "%s\n", alg->cra_name);
+}
+
+static struct kobj_attribute crypto_stat_attribute_priority =
+	__ATTR(priority, 0444, fcrypto_priority, NULL);
+static struct kobj_attribute crypto_stat_attribute_enc_cnt =
+	__ATTR(enc_cnt, 0444, fcrypto_stat_enc_cnt, NULL);
+static struct kobj_attribute crypto_stat_attribute_enc_tlen =
+	__ATTR(enc_tlen, 0444, fcrypto_stat_enc_tlen, NULL);
+static struct kobj_attribute crypto_stat_attribute_dec_cnt =
+	__ATTR(dec_cnt, 0444, fcrypto_stat_dec_cnt, NULL);
+static struct kobj_attribute crypto_stat_attribute_dec_tlen =
+	__ATTR(dec_tlen, 0444, fcrypto_stat_dec_tlen, NULL);
+static struct kobj_attribute crypto_stat_attribute_verify_cnt =
+	__ATTR(verify_cnt, 0444, fcrypto_stat_verify_cnt, NULL);
+static struct kobj_attribute crypto_stat_attribute_sign_cnt =
+	__ATTR(sign_cnt, 0444, fcrypto_stat_sign_cnt, NULL);
+static struct kobj_attribute crypto_stat_attribute_algtype =
+	__ATTR(algtype, 0444, fcrypto_stat_type, NULL);
+static struct kobj_attribute crypto_stat_attribute_algname =
+	__ATTR(algname, 0444, fcrypto_stat_algname, NULL);
+
+static struct attribute *attrs[] = {
+	&crypto_stat_attribute_priority.attr,
+	&crypto_stat_attribute_enc_cnt.attr,
+	&crypto_stat_attribute_enc_tlen.attr,
+	&crypto_stat_attribute_dec_cnt.attr,
+	&crypto_stat_attribute_dec_tlen.attr,
+	&crypto_stat_attribute_verify_cnt.attr,
+	&crypto_stat_attribute_sign_cnt.attr,
+	&crypto_stat_attribute_algtype.attr,
+	&crypto_stat_attribute_algname.attr,
+	NULL,
+};
+
+static struct attribute_group attr_group = {
+	.attrs = attrs,
+};
+#endif
+
 static inline int crypto_set_driver_name(struct crypto_alg *alg)
 {
 	static const char suffix[] = "-generic";
@@ -73,6 +220,9 @@ static void crypto_free_instance(struct crypto_instance *inst)
 		inst->tmpl->free(inst);
 		return;
 	}
+#ifdef CONFIG_CRYPTO_STATS
+	kobject_put(&inst->alg.cra_stat_obj);
+#endif
 
 	inst->alg.cra_type->free(inst);
 }
@@ -237,6 +387,38 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	list_add(&alg->cra_list, &crypto_alg_list);
 	list_add(&larval->alg.cra_list, &crypto_alg_list);
 
+#ifdef CONFIG_CRYPTO_STATS
+	if (!crypto_root_kobj) {
+		pr_info("crypto: register crypto sysfs\n");
+		crypto_root_kobj = kobject_create_and_add("crypto",
+							  kernel_kobj);
+		if (!crypto_root_kobj) {
+			pr_err("crypto: register crypto class failed\n");
+			ret = -ENOMEM;
+			goto err;
+		}
+		/* TODO class_destroy */
+	}
+
+	pr_debug("Register %s %s %p\n", alg->cra_name, alg->cra_driver_name,
+		 alg->cra_type);
+
+	ret = kobject_init_and_add(&alg->cra_stat_obj, &dynamic_kobj_ktype,
+				   crypto_root_kobj, "%s", alg->cra_driver_name);
+	if (ret == 0) {
+		alg->enc_cnt = 0;
+		alg->dec_cnt = 0;
+		alg->enc_tlen = 0;
+		alg->dec_tlen = 0;
+		ret = sysfs_create_group(&alg->cra_stat_obj, &attr_group);
+		if (ret) {
+			pr_err("crypto: Failed to add stats for %s\n",
+			       alg->cra_driver_name);
+			kobject_put(&alg->cra_stat_obj);
+		}
+	}
+#endif
+
 out:
 	return larval;
 
@@ -401,6 +583,10 @@ int crypto_unregister_alg(struct crypto_alg *alg)
 	ret = crypto_remove_alg(alg, &list);
 	up_write(&crypto_alg_sem);
 
+#ifdef CONFIG_CRYPTO_STATS
+	kobject_put(&alg->cra_stat_obj);
+#endif
+
 	if (ret)
 		return ret;
 
diff --git a/crypto/rng.c b/crypto/rng.c
index b4a618668161..1e9d45c8e9b2 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -49,6 +49,9 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 		seed = buf;
 	}
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->dec_cnt++;
+#endif
 	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
 out:
 	kzfree(buf);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index e328b52425a8..3a091fb914cf 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -247,6 +247,11 @@ static inline int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->enc_cnt++;
+	tfm->base.__crt_alg->enc_tlen += req->slen;
+#endif
+
 	return tfm->compress(req);
 }
 
@@ -263,6 +268,11 @@ static inline int crypto_acomp_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->dec_cnt++;
+	tfm->base.__crt_alg->dec_tlen += req->slen;
+#endif
+
 	return tfm->decompress(req);
 }
 
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index b5e11de4d497..6a625f319fd0 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -286,6 +286,9 @@ static inline int crypto_akcipher_encrypt(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->enc_cnt++;
+#endif
 	return alg->encrypt(req);
 }
 
@@ -304,6 +307,9 @@ static inline int crypto_akcipher_decrypt(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->dec_cnt++;
+#endif
 	return alg->decrypt(req);
 }
 
@@ -322,6 +328,9 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->sign_cnt++;
+#endif
 	return alg->sign(req);
 }
 
@@ -340,6 +349,9 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->verify_cnt++;
+#endif
 	return alg->verify(req);
 }
 
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 1bde0a6514fa..d17a84e43b3c 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -288,6 +288,9 @@ static inline int crypto_kpp_set_secret(struct crypto_kpp *tfm,
 {
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->dec_cnt++;
+#endif
 	return alg->set_secret(tfm, buffer, len);
 }
 
@@ -309,6 +312,9 @@ static inline int crypto_kpp_generate_public_key(struct kpp_request *req)
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->enc_cnt++;
+#endif
 	return alg->generate_public_key(req);
 }
 
@@ -327,6 +333,9 @@ static inline int crypto_kpp_compute_shared_secret(struct kpp_request *req)
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->verify_cnt++;
+#endif
 	return alg->compute_shared_secret(req);
 }
 
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index b95ede354a66..7893217b2fb5 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -140,6 +140,11 @@ static inline int crypto_rng_generate(struct crypto_rng *tfm,
 				      const u8 *src, unsigned int slen,
 				      u8 *dst, unsigned int dlen)
 {
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->enc_cnt++;
+	tfm->base.__crt_alg->enc_tlen += dlen;
+#endif
+
 	return crypto_rng_alg(tfm)->generate(tfm, src, slen, dst, dlen);
 }
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 562001cb412b..3b730384e27f 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -442,6 +442,10 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->enc_cnt++;
+	tfm->base.__crt_alg->enc_tlen += req->cryptlen;
+#endif
 	return tfm->encrypt(req);
 }
 
@@ -460,6 +464,10 @@ static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 
+#ifdef CONFIG_CRYPTO_STATS
+	tfm->base.__crt_alg->dec_cnt++;
+	tfm->base.__crt_alg->dec_tlen += req->cryptlen;
+#endif
 	return tfm->decrypt(req);
 }
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 78508ca4b108..18831a386c36 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -19,6 +19,7 @@
 
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/kobject.h>
 #include <linux/list.h>
 #include <linux/bug.h>
 #include <linux/slab.h>
@@ -466,6 +467,17 @@ struct crypto_alg {
 	void (*cra_destroy)(struct crypto_alg *alg);
 	
 	struct module *cra_module;
+
+#ifdef CONFIG_CRYPTO_STATS
+	struct kobject cra_stat_obj;
+	/* enc is for encrypt / compress/ hash / generate,
+	 * dec is decrypt / decompress / seed
+	 */
+	unsigned long enc_cnt, dec_cnt;
+	unsigned long enc_tlen, dec_tlen;
+	unsigned long verify_cnt;
+	unsigned long sign_cnt;
+#endif
 } CRYPTO_MINALIGN_ATTR;
 
 /*
@@ -901,6 +913,11 @@ static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
 		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+
+#ifdef CONFIG_CRYPTO_STATS
+	crt->base->base.__crt_alg->enc_cnt++;
+	crt->base->base.__crt_alg->enc_tlen += req->nbytes;
+#endif
 	return crt->encrypt(req);
 }
 
@@ -919,6 +936,11 @@ static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
 		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+
+#ifdef CONFIG_CRYPTO_STATS
+	crt->base->base.__crt_alg->dec_cnt++;
+	crt->base->base.__crt_alg->dec_tlen += req->nbytes;
+#endif
 	return crt->decrypt(req);
 }
 
-- 
2.13.6

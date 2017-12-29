From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: algapi - convert cra_refcnt to refcount_t
Date: Fri, 29 Dec 2017 10:00:46 -0600
Message-ID: <20171229160046.23661-1-ebiggers3@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        Elena Reshetova <elena.reshetova@intel.com>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Reference counters should use refcount_t rather than atomic_t, since the
refcount_t implementation can prevent overflows, reducing the
exploitability of reference leak bugs.  crypto_alg.cra_refcount is a
reference counter with the usual semantics, so switch it over to
refcount_t.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c        | 8 ++++----
 crypto/api.c           | 2 +-
 crypto/crypto_user.c   | 4 ++--
 crypto/internal.h      | 4 ++--
 crypto/proc.c          | 2 +-
 include/linux/crypto.h | 2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 60d7366ed343..8084a76e01d8 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -62,7 +62,7 @@ static int crypto_check_alg(struct crypto_alg *alg)
 	if (alg->cra_priority < 0)
 		return -EINVAL;
 
-	atomic_set(&alg->cra_refcnt, 1);
+	refcount_set(&alg->cra_refcnt, 1);
 
 	return crypto_set_driver_name(alg);
 }
@@ -224,7 +224,7 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	if (!larval->adult)
 		goto free_larval;
 
-	atomic_set(&larval->alg.cra_refcnt, 1);
+	refcount_set(&larval->alg.cra_refcnt, 1);
 	memcpy(larval->alg.cra_driver_name, alg->cra_driver_name,
 	       CRYPTO_MAX_ALG_NAME);
 	larval->alg.cra_priority = alg->cra_priority;
@@ -399,7 +399,7 @@ int crypto_unregister_alg(struct crypto_alg *alg)
 	if (ret)
 		return ret;
 
-	BUG_ON(atomic_read(&alg->cra_refcnt) != 1);
+	BUG_ON(refcount_read(&alg->cra_refcnt) != 1);
 	if (alg->cra_destroy)
 		alg->cra_destroy(alg);
 
@@ -490,7 +490,7 @@ void crypto_unregister_template(struct crypto_template *tmpl)
 	up_write(&crypto_alg_sem);
 
 	hlist_for_each_entry_safe(inst, n, list, list) {
-		BUG_ON(atomic_read(&inst->alg.cra_refcnt) != 1);
+		BUG_ON(refcount_read(&inst->alg.cra_refcnt) != 1);
 		crypto_free_instance(inst);
 	}
 	crypto_remove_final(&users);
diff --git a/crypto/api.c b/crypto/api.c
index 6da802d7be67..70a894e52ff3 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -137,7 +137,7 @@ static struct crypto_alg *crypto_larval_add(const char *name, u32 type,
 	if (IS_ERR(larval))
 		return ERR_CAST(larval);
 
-	atomic_set(&larval->alg.cra_refcnt, 2);
+	refcount_set(&larval->alg.cra_refcnt, 2);
 
 	down_write(&crypto_alg_sem);
 	alg = __crypto_alg_lookup(name, type, mask);
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 0dbe2be7f783..5c291eedaa70 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -169,7 +169,7 @@ static int crypto_report_one(struct crypto_alg *alg,
 	ualg->cru_type = 0;
 	ualg->cru_mask = 0;
 	ualg->cru_flags = alg->cra_flags;
-	ualg->cru_refcnt = atomic_read(&alg->cra_refcnt);
+	ualg->cru_refcnt = refcount_read(&alg->cra_refcnt);
 
 	if (nla_put_u32(skb, CRYPTOCFGA_PRIORITY_VAL, alg->cra_priority))
 		goto nla_put_failure;
@@ -387,7 +387,7 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto drop_alg;
 
 	err = -EBUSY;
-	if (atomic_read(&alg->cra_refcnt) > 2)
+	if (refcount_read(&alg->cra_refcnt) > 2)
 		goto drop_alg;
 
 	err = crypto_unregister_instance((struct crypto_instance *)alg);
diff --git a/crypto/internal.h b/crypto/internal.h
index ae65e5fcaa59..1388af6da85a 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -105,13 +105,13 @@ int crypto_type_has_alg(const char *name, const struct crypto_type *frontend,
 
 static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 {
-	atomic_inc(&alg->cra_refcnt);
+	refcount_inc(&alg->cra_refcnt);
 	return alg;
 }
 
 static inline void crypto_alg_put(struct crypto_alg *alg)
 {
-	if (atomic_dec_and_test(&alg->cra_refcnt) && alg->cra_destroy)
+	if (refcount_dec_and_test(&alg->cra_refcnt) && alg->cra_destroy)
 		alg->cra_destroy(alg);
 }
 
diff --git a/crypto/proc.c b/crypto/proc.c
index 2cc10c96d753..822fcef6d91c 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -46,7 +46,7 @@ static int c_show(struct seq_file *m, void *p)
 	seq_printf(m, "driver       : %s\n", alg->cra_driver_name);
 	seq_printf(m, "module       : %s\n", module_name(alg->cra_module));
 	seq_printf(m, "priority     : %d\n", alg->cra_priority);
-	seq_printf(m, "refcnt       : %d\n", atomic_read(&alg->cra_refcnt));
+	seq_printf(m, "refcnt       : %u\n", refcount_read(&alg->cra_refcnt));
 	seq_printf(m, "selftest     : %s\n",
 		   (alg->cra_flags & CRYPTO_ALG_TESTED) ?
 		   "passed" : "unknown");
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 78508ca4b108..231e59f90d32 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -447,7 +447,7 @@ struct crypto_alg {
 	unsigned int cra_alignmask;
 
 	int cra_priority;
-	atomic_t cra_refcnt;
+	refcount_t cra_refcnt;
 
 	char cra_name[CRYPTO_MAX_ALG_NAME];
 	char cra_driver_name[CRYPTO_MAX_ALG_NAME];
-- 
2.15.1

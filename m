From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 1/2] crypto: Implement a generic crypto statistics
Date: Mon,  3 Sep 2018 19:22:47 +0000
Message-ID: <1536002568-18949-2-git-send-email-clabbe@baylibre.com>
References: <1536002568-18949-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536002568-18949-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch implement a generic way to get statistics about all crypto
usages.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/Kconfig                               |  11 +
 crypto/Makefile                              |   1 +
 crypto/ahash.c                               |  21 +-
 crypto/algapi.c                              |   8 +
 crypto/{crypto_user.c => crypto_user_base.c} |   9 +-
 crypto/crypto_user_stat.c                    | 463 +++++++++++++++++++++++++++
 crypto/rng.c                                 |   1 +
 include/crypto/acompress.h                   |  38 ++-
 include/crypto/aead.h                        |  51 ++-
 include/crypto/akcipher.h                    |  76 ++++-
 include/crypto/hash.h                        |  32 +-
 include/crypto/internal/cryptouser.h         |   8 +
 include/crypto/kpp.h                         |  51 ++-
 include/crypto/rng.h                         |  29 +-
 include/crypto/skcipher.h                    |  44 ++-
 include/linux/crypto.h                       |  83 ++++-
 include/uapi/linux/cryptouser.h              |  52 +++
 17 files changed, 943 insertions(+), 35 deletions(-)
 rename crypto/{crypto_user.c => crypto_user_base.c} (97%)
 create mode 100644 crypto/crypto_user_stat.c
 create mode 100644 include/crypto/internal/cryptouser.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f3e40ac56d93..517bd6f4ae20 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1875,6 +1875,17 @@ config CRYPTO_USER_API_AEAD
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
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 6d1d40eeb964..f4282aeabcb6 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -54,6 +54,7 @@ cryptomgr-y := algboss.o testmgr.o
 
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
+crypto_user-y := crypto_user_base.o crypto_user_stat.o
 obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_VMAC) += vmac.o
diff --git a/crypto/ahash.c b/crypto/ahash.c
index a64c143165b1..cecff282c303 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -364,24 +364,35 @@ static int crypto_ahash_op(struct ahash_request *req,
 
 int crypto_ahash_final(struct ahash_request *req)
 {
-	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final);
+	int ret;
+
+	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final);
+	crypto_stat_ahash_final(req, ret);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_final);
 
 int crypto_ahash_finup(struct ahash_request *req)
 {
-	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup);
+	int ret;
+
+	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup);
+	crypto_stat_ahash_final(req, ret);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
 
 int crypto_ahash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	int ret;
 
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
-
-	return crypto_ahash_op(req, tfm->digest);
+		ret = -ENOKEY;
+	else
+		ret = crypto_ahash_op(req, tfm->digest);
+	crypto_stat_ahash_final(req, ret);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_digest);
 
diff --git a/crypto/algapi.c b/crypto/algapi.c
index c0755cf4f53f..f707ff8ae9ef 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -253,6 +253,14 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	list_add(&alg->cra_list, &crypto_alg_list);
 	list_add(&larval->alg.cra_list, &crypto_alg_list);
 
+	atomic_set(&alg->encrypt_cnt, 0);
+	atomic_set(&alg->decrypt_cnt, 0);
+	atomic64_set(&alg->encrypt_tlen, 0);
+	atomic64_set(&alg->decrypt_tlen, 0);
+	atomic_set(&alg->verify_cnt, 0);
+	atomic_set(&alg->cipher_err_cnt, 0);
+	atomic_set(&alg->sign_cnt, 0);
+
 out:
 	return larval;
 
diff --git a/crypto/crypto_user.c b/crypto/crypto_user_base.c
similarity index 97%
rename from crypto/crypto_user.c
rename to crypto/crypto_user_base.c
index 0e89b5457cab..e41f6cc33fff 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user_base.c
@@ -29,6 +29,7 @@
 #include <crypto/internal/rng.h>
 #include <crypto/akcipher.h>
 #include <crypto/kpp.h>
+#include <crypto/internal/cryptouser.h>
 
 #include "internal.h"
 
@@ -37,7 +38,7 @@
 static DEFINE_MUTEX(crypto_cfg_mutex);
 
 /* The crypto netlink socket */
-static struct sock *crypto_nlsk;
+struct sock *crypto_nlsk;
 
 struct crypto_dump_info {
 	struct sk_buff *in_skb;
@@ -46,7 +47,7 @@ struct crypto_dump_info {
 	u16 nlmsg_flags;
 };
 
-static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
+struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
 {
 	struct crypto_alg *q, *alg = NULL;
 
@@ -461,6 +462,7 @@ static const int crypto_msg_min[CRYPTO_NR_MSGTYPES] = {
 	[CRYPTO_MSG_UPDATEALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
 	[CRYPTO_MSG_GETALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
 	[CRYPTO_MSG_DELRNG	- CRYPTO_MSG_BASE] = 0,
+	[CRYPTO_MSG_GETSTAT	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
 };
 
 static const struct nla_policy crypto_policy[CRYPTOCFGA_MAX+1] = {
@@ -481,6 +483,9 @@ static const struct crypto_link {
 						       .dump = crypto_dump_report,
 						       .done = crypto_dump_report_done},
 	[CRYPTO_MSG_DELRNG	- CRYPTO_MSG_BASE] = { .doit = crypto_del_rng },
+	[CRYPTO_MSG_GETSTAT	- CRYPTO_MSG_BASE] = { .doit = crypto_reportstat,
+						       .dump = crypto_dump_reportstat,
+						       .done = crypto_dump_reportstat_done},
 };
 
 static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
new file mode 100644
index 000000000000..46ad3bae17bc
--- /dev/null
+++ b/crypto/crypto_user_stat.c
@@ -0,0 +1,463 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Crypto user configuration API.
+ *
+ * Copyright (C) 2017-2018 Corentin Labbe <clabbe@baylibre.com>
+ *
+ */
+
+#include <linux/crypto.h>
+#include <linux/cryptouser.h>
+#include <linux/sched.h>
+#include <net/netlink.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/internal/rng.h>
+#include <crypto/akcipher.h>
+#include <crypto/kpp.h>
+#include <crypto/internal/cryptouser.h>
+
+#include "internal.h"
+
+#define null_terminated(x)	(strnlen(x, sizeof(x)) < sizeof(x))
+
+static DEFINE_MUTEX(crypto_cfg_mutex);
+
+extern struct sock *crypto_nlsk;
+
+struct crypto_dump_info {
+	struct sk_buff *in_skb;
+	struct sk_buff *out_skb;
+	u32 nlmsg_seq;
+	u16 nlmsg_flags;
+};
+
+static int crypto_report_aead(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_stat raead;
+	u64 v64;
+	u32 v32;
+
+	strncpy(raead.type, "aead", sizeof(raead.type));
+
+	v32 = atomic_read(&alg->encrypt_cnt);
+	raead.stat_encrypt_cnt = v32;
+	v64 = atomic64_read(&alg->encrypt_tlen);
+	raead.stat_encrypt_tlen = v64;
+	v32 = atomic_read(&alg->decrypt_cnt);
+	raead.stat_decrypt_cnt = v32;
+	v64 = atomic64_read(&alg->decrypt_tlen);
+	raead.stat_decrypt_tlen = v64;
+	v32 = atomic_read(&alg->aead_err_cnt);
+	raead.stat_aead_err_cnt = v32;
+
+	if (nla_put(skb, CRYPTOCFGA_STAT_AEAD,
+		    sizeof(struct crypto_stat), &raead))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_stat rcipher;
+	u64 v64;
+	u32 v32;
+
+	strlcpy(rcipher.type, "cipher", sizeof(rcipher.type));
+
+	v32 = atomic_read(&alg->encrypt_cnt);
+	rcipher.stat_encrypt_cnt = v32;
+	v64 = atomic64_read(&alg->encrypt_tlen);
+	rcipher.stat_encrypt_tlen = v64;
+	v32 = atomic_read(&alg->decrypt_cnt);
+	rcipher.stat_decrypt_cnt = v32;
+	v64 = atomic64_read(&alg->decrypt_tlen);
+	rcipher.stat_decrypt_tlen = v64;
+	v32 = atomic_read(&alg->cipher_err_cnt);
+	rcipher.stat_cipher_err_cnt = v32;
+
+	if (nla_put(skb, CRYPTOCFGA_STAT_CIPHER,
+		    sizeof(struct crypto_stat), &rcipher))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_stat rcomp;
+	u64 v64;
+	u32 v32;
+
+	strlcpy(rcomp.type, "compression", sizeof(rcomp.type));
+	v32 = atomic_read(&alg->compress_cnt);
+	rcomp.stat_compress_cnt = v32;
+	v64 = atomic64_read(&alg->compress_tlen);
+	rcomp.stat_compress_tlen = v64;
+	v32 = atomic_read(&alg->decompress_cnt);
+	rcomp.stat_decompress_cnt = v32;
+	v64 = atomic64_read(&alg->decompress_tlen);
+	rcomp.stat_decompress_tlen = v64;
+	v32 = atomic_read(&alg->cipher_err_cnt);
+	rcomp.stat_compress_err_cnt = v32;
+
+	if (nla_put(skb, CRYPTOCFGA_STAT_COMPRESS,
+		    sizeof(struct crypto_stat), &rcomp))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int crypto_report_acomp(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_stat racomp;
+	u64 v64;
+	u32 v32;
+
+	strlcpy(racomp.type, "acomp", sizeof(racomp.type));
+	v32 = atomic_read(&alg->compress_cnt);
+	racomp.stat_compress_cnt = v32;
+	v64 = atomic64_read(&alg->compress_tlen);
+	racomp.stat_compress_tlen = v64;
+	v32 = atomic_read(&alg->decompress_cnt);
+	racomp.stat_decompress_cnt = v32;
+	v64 = atomic64_read(&alg->decompress_tlen);
+	racomp.stat_decompress_tlen = v64;
+	v32 = atomic_read(&alg->cipher_err_cnt);
+	racomp.stat_compress_err_cnt = v32;
+
+	if (nla_put(skb, CRYPTOCFGA_STAT_ACOMP,
+		    sizeof(struct crypto_stat), &racomp))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int crypto_report_akcipher(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_stat rakcipher;
+	u64 v64;
+	u32 v32;
+
+	strncpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
+	v32 = atomic_read(&alg->encrypt_cnt);
+	rakcipher.stat_encrypt_cnt = v32;
+	v64 = atomic64_read(&alg->encrypt_tlen);
+	rakcipher.stat_encrypt_tlen = v64;
+	v32 = atomic_read(&alg->decrypt_cnt);
+	rakcipher.stat_decrypt_cnt = v32;
+	v64 = atomic64_read(&alg->decrypt_tlen);
+	rakcipher.stat_decrypt_tlen = v64;
+	v32 = atomic_read(&alg->sign_cnt);
+	rakcipher.stat_sign_cnt = v32;
+	v32 = atomic_read(&alg->verify_cnt);
+	rakcipher.stat_verify_cnt = v32;
+	v32 = atomic_read(&alg->akcipher_err_cnt);
+	rakcipher.stat_akcipher_err_cnt = v32;
+
+	if (nla_put(skb, CRYPTOCFGA_STAT_AKCIPHER,
+		    sizeof(struct crypto_stat), &rakcipher))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int crypto_report_kpp(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_stat rkpp;
+	u32 v;
+
+	strlcpy(rkpp.type, "kpp", sizeof(rkpp.type));
+
+	v = atomic_read(&alg->setsecret_cnt);
+	rkpp.stat_setsecret_cnt = v;
+	v = atomic_read(&alg->generate_public_key_cnt);
+	rkpp.stat_generate_public_key_cnt = v;
+	v = atomic_read(&alg->compute_shared_secret_cnt);
+	rkpp.stat_compute_shared_secret_cnt = v;
+	v = atomic_read(&alg->kpp_err_cnt);
+	rkpp.stat_kpp_err_cnt = v;
+
+	if (nla_put(skb, CRYPTOCFGA_STAT_KPP,
+		    sizeof(struct crypto_stat), &rkpp))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int crypto_report_ahash(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_stat rhash;
+	u64 v64;
+	u32 v32;
+
+	strncpy(rhash.type, "ahash", sizeof(rhash.type));
+
+	v32 = atomic_read(&alg->hash_cnt);
+	rhash.stat_hash_cnt = v32;
+	v64 = atomic64_read(&alg->hash_tlen);
+	rhash.stat_hash_tlen = v64;
+	v32 = atomic_read(&alg->hash_err_cnt);
+	rhash.stat_hash_err_cnt = v32;
+
+	if (nla_put(skb, CRYPTOCFGA_STAT_HASH,
+		    sizeof(struct crypto_stat), &rhash))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int crypto_report_shash(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_stat rhash;
+	u64 v64;
+	u32 v32;
+
+	strncpy(rhash.type, "shash", sizeof(rhash.type));
+
+	v32 = atomic_read(&alg->hash_cnt);
+	rhash.stat_hash_cnt = v32;
+	v64 = atomic64_read(&alg->hash_tlen);
+	rhash.stat_hash_tlen = v64;
+	v32 = atomic_read(&alg->hash_err_cnt);
+	rhash.stat_hash_err_cnt = v32;
+
+	if (nla_put(skb, CRYPTOCFGA_STAT_HASH,
+		    sizeof(struct crypto_stat), &rhash))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int crypto_report_rng(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_stat rrng;
+	u64 v64;
+	u32 v32;
+
+	strncpy(rrng.type, "rng", sizeof(rrng.type));
+
+	v32 = atomic_read(&alg->generate_cnt);
+	rrng.stat_generate_cnt = v32;
+	v64 = atomic64_read(&alg->generate_tlen);
+	rrng.stat_generate_tlen = v64;
+	v32 = atomic_read(&alg->seed_cnt);
+	rrng.stat_seed_cnt = v32;
+	v32 = atomic_read(&alg->hash_err_cnt);
+	rrng.stat_rng_err_cnt = v32;
+
+	if (nla_put(skb, CRYPTOCFGA_STAT_RNG,
+		    sizeof(struct crypto_stat), &rrng))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int crypto_reportstat_one(struct crypto_alg *alg,
+				 struct crypto_user_alg *ualg,
+				 struct sk_buff *skb)
+{
+	strlcpy(ualg->cru_name, alg->cra_name, sizeof(ualg->cru_name));
+	strlcpy(ualg->cru_driver_name, alg->cra_driver_name,
+		sizeof(ualg->cru_driver_name));
+	strlcpy(ualg->cru_module_name, module_name(alg->cra_module),
+		sizeof(ualg->cru_module_name));
+
+	ualg->cru_type = 0;
+	ualg->cru_mask = 0;
+	ualg->cru_flags = alg->cra_flags;
+	ualg->cru_refcnt = refcount_read(&alg->cra_refcnt);
+
+	if (nla_put_u32(skb, CRYPTOCFGA_PRIORITY_VAL, alg->cra_priority))
+		goto nla_put_failure;
+	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
+		struct crypto_stat rl;
+
+		strlcpy(rl.type, "larval", sizeof(rl.type));
+		if (nla_put(skb, CRYPTOCFGA_STAT_LARVAL,
+			    sizeof(struct crypto_stat), &rl))
+			goto nla_put_failure;
+		goto out;
+	}
+
+	switch (alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL)) {
+	case CRYPTO_ALG_TYPE_AEAD:
+		if (crypto_report_aead(skb, alg))
+			goto nla_put_failure;
+		break;
+	case CRYPTO_ALG_TYPE_SKCIPHER:
+		if (crypto_report_cipher(skb, alg))
+			goto nla_put_failure;
+		break;
+	case CRYPTO_ALG_TYPE_BLKCIPHER:
+		if (crypto_report_cipher(skb, alg))
+			goto nla_put_failure;
+		break;
+	case CRYPTO_ALG_TYPE_CIPHER:
+		if (crypto_report_cipher(skb, alg))
+			goto nla_put_failure;
+		break;
+	case CRYPTO_ALG_TYPE_COMPRESS:
+		if (crypto_report_comp(skb, alg))
+			goto nla_put_failure;
+		break;
+	case CRYPTO_ALG_TYPE_ACOMPRESS:
+		if (crypto_report_acomp(skb, alg))
+			goto nla_put_failure;
+		break;
+	case CRYPTO_ALG_TYPE_SCOMPRESS:
+		if (crypto_report_acomp(skb, alg))
+			goto nla_put_failure;
+		break;
+	case CRYPTO_ALG_TYPE_AKCIPHER:
+		if (crypto_report_akcipher(skb, alg))
+			goto nla_put_failure;
+		break;
+	case CRYPTO_ALG_TYPE_KPP:
+		if (crypto_report_kpp(skb, alg))
+			goto nla_put_failure;
+		break;
+	case CRYPTO_ALG_TYPE_AHASH:
+		if (crypto_report_ahash(skb, alg))
+			goto nla_put_failure;
+		break;
+	case CRYPTO_ALG_TYPE_HASH:
+		if (crypto_report_shash(skb, alg))
+			goto nla_put_failure;
+		break;
+	case CRYPTO_ALG_TYPE_RNG:
+		if (crypto_report_rng(skb, alg))
+			goto nla_put_failure;
+		break;
+	default:
+		pr_err("ERROR: Unhandled alg %d in %s\n",
+		       alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL),
+		       __func__);
+	}
+
+out:
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static int crypto_reportstat_alg(struct crypto_alg *alg,
+				 struct crypto_dump_info *info)
+{
+	struct sk_buff *in_skb = info->in_skb;
+	struct sk_buff *skb = info->out_skb;
+	struct nlmsghdr *nlh;
+	struct crypto_user_alg *ualg;
+	int err = 0;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(in_skb).portid, info->nlmsg_seq,
+			CRYPTO_MSG_GETSTAT, sizeof(*ualg), info->nlmsg_flags);
+	if (!nlh) {
+		err = -EMSGSIZE;
+		goto out;
+	}
+
+	ualg = nlmsg_data(nlh);
+
+	err = crypto_reportstat_one(alg, ualg, skb);
+	if (err) {
+		nlmsg_cancel(skb, nlh);
+		goto out;
+	}
+
+	nlmsg_end(skb, nlh);
+
+out:
+	return err;
+}
+
+int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
+		      struct nlattr **attrs)
+{
+	struct crypto_user_alg *p = nlmsg_data(in_nlh);
+	struct crypto_alg *alg;
+	struct sk_buff *skb;
+	struct crypto_dump_info info;
+	int err;
+
+	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name))
+		return -EINVAL;
+
+	alg = crypto_alg_match(p, 0);
+	if (!alg)
+		return -ENOENT;
+
+	err = -ENOMEM;
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb)
+		goto drop_alg;
+
+	info.in_skb = in_skb;
+	info.out_skb = skb;
+	info.nlmsg_seq = in_nlh->nlmsg_seq;
+	info.nlmsg_flags = 0;
+
+	err = crypto_reportstat_alg(alg, &info);
+
+drop_alg:
+	crypto_mod_put(alg);
+
+	if (err)
+		return err;
+
+	return nlmsg_unicast(crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
+}
+
+int crypto_dump_reportstat(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct crypto_alg *alg;
+	struct crypto_dump_info info;
+	int err;
+
+	if (cb->args[0])
+		goto out;
+
+	cb->args[0] = 1;
+
+	info.in_skb = cb->skb;
+	info.out_skb = skb;
+	info.nlmsg_seq = cb->nlh->nlmsg_seq;
+	info.nlmsg_flags = NLM_F_MULTI;
+
+	list_for_each_entry(alg, &crypto_alg_list, cra_list) {
+		err = crypto_reportstat_alg(alg, &info);
+		if (err)
+			goto out_err;
+	}
+
+out:
+	return skb->len;
+out_err:
+	return err;
+}
+
+int crypto_dump_reportstat_done(struct netlink_callback *cb)
+{
+	return 0;
+}
+
+MODULE_LICENSE("GPL");
diff --git a/crypto/rng.c b/crypto/rng.c
index b4a618668161..547f16ecbfb0 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -50,6 +50,7 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 	}
 
 	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
+	crypto_stat_rng_seed(tfm, err);
 out:
 	kzfree(buf);
 	return err;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index e328b52425a8..22e6f412c595 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -234,6 +234,34 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 		req->flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
 }
 
+static inline void crypto_stat_compress(struct acomp_req *req, int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&tfm->base.__crt_alg->compress_err_cnt);
+	} else {
+		atomic_inc(&tfm->base.__crt_alg->compress_cnt);
+		atomic64_add(req->slen, &tfm->base.__crt_alg->compress_tlen);
+	}
+#endif
+}
+
+static inline void crypto_stat_decompress(struct acomp_req *req, int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&tfm->base.__crt_alg->compress_err_cnt);
+	} else {
+		atomic_inc(&tfm->base.__crt_alg->decompress_cnt);
+		atomic64_add(req->slen, &tfm->base.__crt_alg->decompress_tlen);
+	}
+#endif
+}
+
 /**
  * crypto_acomp_compress() -- Invoke asynchronous compress operation
  *
@@ -246,8 +274,11 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 static inline int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	int ret;
 
-	return tfm->compress(req);
+	ret = tfm->compress(req);
+	crypto_stat_compress(req, ret);
+	return ret;
 }
 
 /**
@@ -262,8 +293,11 @@ static inline int crypto_acomp_compress(struct acomp_req *req)
 static inline int crypto_acomp_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	int ret;
 
-	return tfm->decompress(req);
+	ret = tfm->decompress(req);
+	crypto_stat_decompress(req, ret);
+	return ret;
 }
 
 #endif
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 1e26f790b03f..0d765d7bfb82 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -306,6 +306,34 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
 	return __crypto_aead_cast(req->base.tfm);
 }
 
+static inline void crypto_stat_aead_encrypt(struct aead_request *req, int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&tfm->base.__crt_alg->aead_err_cnt);
+	} else {
+		atomic_inc(&tfm->base.__crt_alg->encrypt_cnt);
+		atomic64_add(req->cryptlen, &tfm->base.__crt_alg->encrypt_tlen);
+	}
+#endif
+}
+
+static inline void crypto_stat_aead_decrypt(struct aead_request *req, int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&tfm->base.__crt_alg->aead_err_cnt);
+	} else {
+		atomic_inc(&tfm->base.__crt_alg->decrypt_cnt);
+		atomic64_add(req->cryptlen, &tfm->base.__crt_alg->decrypt_tlen);
+	}
+#endif
+}
+
 /**
  * crypto_aead_encrypt() - encrypt plaintext
  * @req: reference to the aead_request handle that holds all information
@@ -328,11 +356,14 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
 static inline int crypto_aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	int ret;
 
 	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
-
-	return crypto_aead_alg(aead)->encrypt(req);
+		ret = -ENOKEY;
+	else
+		ret = crypto_aead_alg(aead)->encrypt(req);
+	crypto_stat_aead_encrypt(req, ret);
+	return ret;
 }
 
 /**
@@ -360,14 +391,16 @@ static inline int crypto_aead_encrypt(struct aead_request *req)
 static inline int crypto_aead_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	int ret;
 
 	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
-
-	if (req->cryptlen < crypto_aead_authsize(aead))
-		return -EINVAL;
-
-	return crypto_aead_alg(aead)->decrypt(req);
+		ret = -ENOKEY;
+	else if (req->cryptlen < crypto_aead_authsize(aead))
+		ret = -EINVAL;
+	else
+		ret = crypto_aead_alg(aead)->decrypt(req);
+	crypto_stat_aead_decrypt(req, ret);
+	return ret;
 }
 
 /**
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 8e0f752286e4..ee072a82d39d 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -271,6 +271,62 @@ static inline unsigned int crypto_akcipher_maxsize(struct crypto_akcipher *tfm)
 	return alg->max_size(tfm);
 }
 
+static inline void crypto_stat_akcipher_encrypt(struct akcipher_request *req,
+						int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&tfm->base.__crt_alg->akcipher_err_cnt);
+	} else {
+		atomic_inc(&tfm->base.__crt_alg->encrypt_cnt);
+		atomic64_add(req->src_len, &tfm->base.__crt_alg->encrypt_tlen);
+	}
+#endif
+}
+
+static inline void crypto_stat_akcipher_decrypt(struct akcipher_request *req,
+						int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&tfm->base.__crt_alg->akcipher_err_cnt);
+	} else {
+		atomic_inc(&tfm->base.__crt_alg->decrypt_cnt);
+		atomic64_add(req->src_len, &tfm->base.__crt_alg->decrypt_tlen);
+	}
+#endif
+}
+
+static inline void crypto_stat_akcipher_sign(struct akcipher_request *req,
+					     int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
+		atomic_inc(&tfm->base.__crt_alg->akcipher_err_cnt);
+	else
+		atomic_inc(&tfm->base.__crt_alg->sign_cnt);
+#endif
+}
+
+static inline void crypto_stat_akcipher_verify(struct akcipher_request *req,
+					       int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
+		atomic_inc(&tfm->base.__crt_alg->akcipher_err_cnt);
+	else
+		atomic_inc(&tfm->base.__crt_alg->verify_cnt);
+#endif
+}
+
 /**
  * crypto_akcipher_encrypt() - Invoke public key encrypt operation
  *
@@ -285,8 +341,11 @@ static inline int crypto_akcipher_encrypt(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+	int ret;
 
-	return alg->encrypt(req);
+	ret = alg->encrypt(req);
+	crypto_stat_akcipher_encrypt(req, ret);
+	return ret;
 }
 
 /**
@@ -303,8 +362,11 @@ static inline int crypto_akcipher_decrypt(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+	int ret;
 
-	return alg->decrypt(req);
+	ret = alg->decrypt(req);
+	crypto_stat_akcipher_decrypt(req, ret);
+	return ret;
 }
 
 /**
@@ -321,8 +383,11 @@ static inline int crypto_akcipher_sign(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+	int ret;
 
-	return alg->sign(req);
+	ret = alg->sign(req);
+	crypto_stat_akcipher_sign(req, ret);
+	return ret;
 }
 
 /**
@@ -339,8 +404,11 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+	int ret;
 
-	return alg->verify(req);
+	ret = alg->verify(req);
+	crypto_stat_akcipher_verify(req, ret);
+	return ret;
 }
 
 /**
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 76e432cab75d..88c4e600958f 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -408,6 +408,32 @@ static inline void *ahash_request_ctx(struct ahash_request *req)
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen);
 
+static inline void crypto_stat_ahash_update(struct ahash_request *req, int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
+		atomic_inc(&tfm->base.__crt_alg->hash_err_cnt);
+	else
+		atomic64_add(req->nbytes, &tfm->base.__crt_alg->hash_tlen);
+#endif
+}
+
+static inline void crypto_stat_ahash_final(struct ahash_request *req, int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&tfm->base.__crt_alg->hash_err_cnt);
+	} else {
+		atomic_inc(&tfm->base.__crt_alg->hash_cnt);
+		atomic64_add(req->nbytes, &tfm->base.__crt_alg->hash_tlen);
+	}
+#endif
+}
+
 /**
  * crypto_ahash_finup() - update and finalize message digest
  * @req: reference to the ahash_request handle that holds all information
@@ -522,7 +548,11 @@ static inline int crypto_ahash_init(struct ahash_request *req)
  */
 static inline int crypto_ahash_update(struct ahash_request *req)
 {
-	return crypto_ahash_reqtfm(req)->update(req);
+	int ret;
+
+	ret = crypto_ahash_reqtfm(req)->update(req);
+	crypto_stat_ahash_update(req, ret);
+	return ret;
 }
 
 /**
diff --git a/include/crypto/internal/cryptouser.h b/include/crypto/internal/cryptouser.h
new file mode 100644
index 000000000000..8db299c25566
--- /dev/null
+++ b/include/crypto/internal/cryptouser.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <net/netlink.h>
+
+struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact);
+
+int crypto_dump_reportstat(struct sk_buff *skb, struct netlink_callback *cb);
+int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh, struct nlattr **attrs);
+int crypto_dump_reportstat_done(struct netlink_callback *cb);
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 1bde0a6514fa..f517ba6d3a27 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -268,6 +268,42 @@ struct kpp_secret {
 	unsigned short len;
 };
 
+static inline void crypto_stat_kpp_set_secret(struct crypto_kpp *tfm, int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	if (ret)
+		atomic_inc(&tfm->base.__crt_alg->kpp_err_cnt);
+	else
+		atomic_inc(&tfm->base.__crt_alg->setsecret_cnt);
+#endif
+}
+
+static inline void crypto_stat_kpp_generate_public_key(struct kpp_request *req,
+						       int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+
+	if (ret)
+		atomic_inc(&tfm->base.__crt_alg->kpp_err_cnt);
+	else
+		atomic_inc(&tfm->base.__crt_alg->generate_public_key_cnt);
+#endif
+}
+
+static inline void crypto_stat_kpp_compute_shared_secret(struct kpp_request *req,
+							 int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+
+	if (ret)
+		atomic_inc(&tfm->base.__crt_alg->kpp_err_cnt);
+	else
+		atomic_inc(&tfm->base.__crt_alg->compute_shared_secret_cnt);
+#endif
+}
+
 /**
  * crypto_kpp_set_secret() - Invoke kpp operation
  *
@@ -287,8 +323,11 @@ static inline int crypto_kpp_set_secret(struct crypto_kpp *tfm,
 					const void *buffer, unsigned int len)
 {
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
+	int ret;
 
-	return alg->set_secret(tfm, buffer, len);
+	ret = alg->set_secret(tfm, buffer, len);
+	crypto_stat_kpp_set_secret(tfm, ret);
+	return ret;
 }
 
 /**
@@ -308,8 +347,11 @@ static inline int crypto_kpp_generate_public_key(struct kpp_request *req)
 {
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
+	int ret;
 
-	return alg->generate_public_key(req);
+	ret = alg->generate_public_key(req);
+	crypto_stat_kpp_generate_public_key(req, ret);
+	return ret;
 }
 
 /**
@@ -326,8 +368,11 @@ static inline int crypto_kpp_compute_shared_secret(struct kpp_request *req)
 {
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct kpp_alg *alg = crypto_kpp_alg(tfm);
+	int ret;
 
-	return alg->compute_shared_secret(req);
+	ret = alg->compute_shared_secret(req);
+	crypto_stat_kpp_compute_shared_secret(req, ret);
+	return ret;
 }
 
 /**
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 42811936a361..0d781fa77161 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -122,6 +122,29 @@ static inline void crypto_free_rng(struct crypto_rng *tfm)
 	crypto_destroy_tfm(tfm, crypto_rng_tfm(tfm));
 }
 
+static inline void crypto_stat_rng_seed(struct crypto_rng *tfm, int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
+		atomic_inc(&tfm->base.__crt_alg->rng_err_cnt);
+	else
+		atomic_inc(&tfm->base.__crt_alg->seed_cnt);
+#endif
+}
+
+static inline void crypto_stat_rng_generate(struct crypto_rng *tfm,
+					    unsigned int dlen, int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&tfm->base.__crt_alg->rng_err_cnt);
+	} else {
+		atomic_inc(&tfm->base.__crt_alg->generate_cnt);
+		atomic64_add(dlen, &tfm->base.__crt_alg->generate_tlen);
+	}
+#endif
+}
+
 /**
  * crypto_rng_generate() - get random number
  * @tfm: cipher handle
@@ -140,7 +163,11 @@ static inline int crypto_rng_generate(struct crypto_rng *tfm,
 				      const u8 *src, unsigned int slen,
 				      u8 *dst, unsigned int dlen)
 {
-	return crypto_rng_alg(tfm)->generate(tfm, src, slen, dst, dlen);
+	int ret;
+
+	ret = crypto_rng_alg(tfm)->generate(tfm, src, slen, dst, dlen);
+	crypto_stat_rng_generate(tfm, dlen, ret);
+	return ret;
 }
 
 /**
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 2f327f090c3e..ffa3df325ca3 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -422,6 +422,32 @@ static inline struct crypto_skcipher *crypto_skcipher_reqtfm(
 	return __crypto_skcipher_cast(req->base.tfm);
 }
 
+static inline void crypto_stat_skcipher_encrypt(struct skcipher_request *req,
+						int ret, struct crypto_alg *alg)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&alg->cipher_err_cnt);
+	} else {
+		atomic_inc(&alg->encrypt_cnt);
+		atomic64_add(req->cryptlen, &alg->encrypt_tlen);
+	}
+#endif
+}
+
+static inline void crypto_stat_skcipher_decrypt(struct skcipher_request *req,
+						int ret, struct crypto_alg *alg)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&alg->cipher_err_cnt);
+	} else {
+		atomic_inc(&alg->decrypt_cnt);
+		atomic64_add(req->cryptlen, &alg->decrypt_tlen);
+	}
+#endif
+}
+
 /**
  * crypto_skcipher_encrypt() - encrypt plaintext
  * @req: reference to the skcipher_request handle that holds all information
@@ -436,11 +462,14 @@ static inline struct crypto_skcipher *crypto_skcipher_reqtfm(
 static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	int ret;
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
-
-	return tfm->encrypt(req);
+		ret = -ENOKEY;
+	else
+		ret = tfm->encrypt(req);
+	crypto_stat_skcipher_encrypt(req, ret, tfm->base.__crt_alg);
+	return ret;
 }
 
 /**
@@ -457,11 +486,14 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
 static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	int ret;
 
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
-
-	return tfm->decrypt(req);
+		ret = -ENOKEY;
+	else
+		ret = tfm->decrypt(req);
+	crypto_stat_skcipher_decrypt(req, ret, tfm->base.__crt_alg);
+	return ret;
 }
 
 /**
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e8839d3a7559..1c32a6fe676a 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -487,6 +487,45 @@ struct crypto_alg {
 	void (*cra_destroy)(struct crypto_alg *alg);
 	
 	struct module *cra_module;
+
+	union {
+		atomic_t encrypt_cnt;
+		atomic_t compress_cnt;
+		atomic_t generate_cnt;
+		atomic_t hash_cnt;
+		atomic_t setsecret_cnt;
+	};
+	union {
+		atomic64_t encrypt_tlen;
+		atomic64_t compress_tlen;
+		atomic64_t generate_tlen;
+		atomic64_t hash_tlen;
+	};
+	union {
+		atomic_t akcipher_err_cnt;
+		atomic_t cipher_err_cnt;
+		atomic_t compress_err_cnt;
+		atomic_t aead_err_cnt;
+		atomic_t hash_err_cnt;
+		atomic_t rng_err_cnt;
+		atomic_t kpp_err_cnt;
+	};
+	union {
+		atomic_t decrypt_cnt;
+		atomic_t decompress_cnt;
+		atomic_t seed_cnt;
+		atomic_t generate_public_key_cnt;
+	};
+	union {
+		atomic64_t decrypt_tlen;
+		atomic64_t decompress_tlen;
+	};
+	union {
+		atomic_t verify_cnt;
+		atomic_t compute_shared_secret_cnt;
+	};
+	atomic_t sign_cnt;
+
 } CRYPTO_MINALIGN_ATTR;
 
 /*
@@ -907,6 +946,38 @@ static inline struct crypto_ablkcipher *crypto_ablkcipher_reqtfm(
 	return __crypto_ablkcipher_cast(req->base.tfm);
 }
 
+static inline void crypto_stat_ablkcipher_encrypt(struct ablkcipher_request *req,
+						  int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct ablkcipher_tfm *crt =
+		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&crt->base->base.__crt_alg->cipher_err_cnt);
+	} else {
+		atomic_inc(&crt->base->base.__crt_alg->encrypt_cnt);
+		atomic64_add(req->nbytes, &crt->base->base.__crt_alg->encrypt_tlen);
+	}
+#endif
+}
+
+static inline void crypto_stat_ablkcipher_decrypt(struct ablkcipher_request *req,
+						  int ret)
+{
+#ifdef CONFIG_CRYPTO_STATS
+	struct ablkcipher_tfm *crt =
+		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
+
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
+		atomic_inc(&crt->base->base.__crt_alg->cipher_err_cnt);
+	} else {
+		atomic_inc(&crt->base->base.__crt_alg->decrypt_cnt);
+		atomic64_add(req->nbytes, &crt->base->base.__crt_alg->decrypt_tlen);
+	}
+#endif
+}
+
 /**
  * crypto_ablkcipher_encrypt() - encrypt plaintext
  * @req: reference to the ablkcipher_request handle that holds all information
@@ -922,7 +993,11 @@ static inline int crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
 		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
-	return crt->encrypt(req);
+	int ret;
+
+	ret = crt->encrypt(req);
+	crypto_stat_ablkcipher_encrypt(req, ret);
+	return ret;
 }
 
 /**
@@ -940,7 +1015,11 @@ static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 {
 	struct ablkcipher_tfm *crt =
 		crypto_ablkcipher_crt(crypto_ablkcipher_reqtfm(req));
-	return crt->decrypt(req);
+	int ret;
+
+	ret = crt->decrypt(req);
+	crypto_stat_ablkcipher_decrypt(req, ret);
+	return ret;
 }
 
 /**
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index 19bf0ca6d635..6dafbc3e4414 100644
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -29,6 +29,7 @@ enum {
 	CRYPTO_MSG_UPDATEALG,
 	CRYPTO_MSG_GETALG,
 	CRYPTO_MSG_DELRNG,
+	CRYPTO_MSG_GETSTAT,
 	__CRYPTO_MSG_MAX
 };
 #define CRYPTO_MSG_MAX (__CRYPTO_MSG_MAX - 1)
@@ -50,6 +51,16 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_AKCIPHER,	/* struct crypto_report_akcipher */
 	CRYPTOCFGA_REPORT_KPP,		/* struct crypto_report_kpp */
 	CRYPTOCFGA_REPORT_ACOMP,	/* struct crypto_report_acomp */
+	CRYPTOCFGA_STAT_LARVAL,		/* struct crypto_stat */
+	CRYPTOCFGA_STAT_HASH,		/* struct crypto_stat */
+	CRYPTOCFGA_STAT_BLKCIPHER,	/* struct crypto_stat */
+	CRYPTOCFGA_STAT_AEAD,		/* struct crypto_stat */
+	CRYPTOCFGA_STAT_COMPRESS,	/* struct crypto_stat */
+	CRYPTOCFGA_STAT_RNG,		/* struct crypto_stat */
+	CRYPTOCFGA_STAT_CIPHER,		/* struct crypto_stat */
+	CRYPTOCFGA_STAT_AKCIPHER,	/* struct crypto_stat */
+	CRYPTOCFGA_STAT_KPP,		/* struct crypto_stat */
+	CRYPTOCFGA_STAT_ACOMP,		/* struct crypto_stat */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -65,6 +76,47 @@ struct crypto_user_alg {
 	__u32 cru_flags;
 };
 
+struct crypto_stat {
+	char type[CRYPTO_MAX_NAME];
+	union {
+		__u32 stat_encrypt_cnt;
+		__u32 stat_compress_cnt;
+		__u32 stat_generate_cnt;
+		__u32 stat_hash_cnt;
+		__u32 stat_setsecret_cnt;
+	};
+	union {
+		__u64 stat_encrypt_tlen;
+		__u64 stat_compress_tlen;
+		__u64 stat_generate_tlen;
+		__u64 stat_hash_tlen;
+	};
+	union {
+		__u32 stat_akcipher_err_cnt;
+		__u32 stat_cipher_err_cnt;
+		__u32 stat_compress_err_cnt;
+		__u32 stat_aead_err_cnt;
+		__u32 stat_hash_err_cnt;
+		__u32 stat_rng_err_cnt;
+		__u32 stat_kpp_err_cnt;
+	};
+	union {
+		__u32 stat_decrypt_cnt;
+		__u32 stat_decompress_cnt;
+		__u32 stat_seed_cnt;
+		__u32 stat_generate_public_key_cnt;
+	};
+	union {
+		__u64 stat_decrypt_tlen;
+		__u64 stat_decompress_tlen;
+	};
+	union {
+		__u32 stat_verify_cnt;
+		__u32 stat_compute_shared_secret_cnt;
+	};
+	__u32 stat_sign_cnt;
+};
+
 struct crypto_report_larval {
 	char type[CRYPTO_MAX_NAME];
 };
-- 
2.16.4

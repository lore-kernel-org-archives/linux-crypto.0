Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40379 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbeKTGSu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 01:18:50 -0500
Received: by mail-wm1-f65.google.com with SMTP id q26so6461288wmf.5
        for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2018 11:53:39 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 02/11] crypto: crypto_user_stat: made crypto_user_stat optional
Date: Mon, 19 Nov 2018 19:53:21 +0000
Message-Id: <1542657210-37739-3-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1542657210-37739-1-git-send-email-clabbe@baylibre.com>
References: <1542657210-37739-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Even if CRYPTO_STATS is set to n, some part of CRYPTO_STATS are
compiled.
This patch made all part of crypto_user_stat uncompiled in that case.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/Makefile                      |  3 ++-
 crypto/algapi.c                      |  2 ++
 include/crypto/internal/cryptouser.h | 17 +++++++++++++++++
 include/linux/crypto.h               |  2 ++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index abbd86fdbad2..22f9f84f961d 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -54,7 +54,8 @@ cryptomgr-y := algboss.o testmgr.o
 
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
-crypto_user-y := crypto_user_base.o crypto_user_stat.o
+crypto_user-y := crypto_user_base.o
+crypto_user-$(CONFIG_CRYPTO_STATS) += crypto_user_stat.o
 obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_VMAC) += vmac.o
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 2545c5f89c4c..f5396c88e8cd 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -258,6 +258,7 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	list_add(&alg->cra_list, &crypto_alg_list);
 	list_add(&larval->alg.cra_list, &crypto_alg_list);
 
+#ifdef CONFIG_CRYPTO_STATS
 	atomic_set(&alg->encrypt_cnt, 0);
 	atomic_set(&alg->decrypt_cnt, 0);
 	atomic64_set(&alg->encrypt_tlen, 0);
@@ -265,6 +266,7 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	atomic_set(&alg->verify_cnt, 0);
 	atomic_set(&alg->cipher_err_cnt, 0);
 	atomic_set(&alg->sign_cnt, 0);
+#endif
 
 out:
 	return larval;
diff --git a/include/crypto/internal/cryptouser.h b/include/crypto/internal/cryptouser.h
index 8db299c25566..3492ab42eefb 100644
--- a/include/crypto/internal/cryptouser.h
+++ b/include/crypto/internal/cryptouser.h
@@ -3,6 +3,23 @@
 
 struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact);
 
+#ifdef CONFIG_CRYPTO_STATS
 int crypto_dump_reportstat(struct sk_buff *skb, struct netlink_callback *cb);
 int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh, struct nlattr **attrs);
 int crypto_dump_reportstat_done(struct netlink_callback *cb);
+#else
+static int crypto_dump_reportstat(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	return -ENOTSUPP;
+}
+
+static int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh, struct nlattr **attrs)
+{
+	return -ENOTSUPP;
+}
+
+static int crypto_dump_reportstat_done(struct netlink_callback *cb)
+{
+	return -ENOTSUPP;
+}
+#endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ac8f4168a831..9dc8d50dc578 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -515,6 +515,7 @@ struct crypto_alg {
 	
 	struct module *cra_module;
 
+#ifdef CONFIG_CRYPTO_STATS
 	union {
 		atomic_t encrypt_cnt;
 		atomic_t compress_cnt;
@@ -552,6 +553,7 @@ struct crypto_alg {
 		atomic_t compute_shared_secret_cnt;
 	};
 	atomic_t sign_cnt;
+#endif /* CONFIG_CRYPTO_STATS */
 
 } CRYPTO_MINALIGN_ATTR;
 
-- 
2.18.1

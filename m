Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706E0C64EC7
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Feb 2023 09:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbjBOJ0Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Feb 2023 04:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbjBOJZ7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2023 04:25:59 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AA03754E
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 01:25:31 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSE2Y-00BVmY-4s; Wed, 15 Feb 2023 17:25:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Feb 2023 17:25:26 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Wed, 15 Feb 2023 17:25:26 +0800
Subject: [PATCH 10/10] crypto: api - Check CRYPTO_USER instead of NET for report
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1pSE2Y-00BVmY-4s@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The report function is currently conditionalised on CONFIG_NET.
As it's only used by CONFIG_CRYPTO_USER, conditionalising on that
instead of CONFIG_NET makes more sense.

This gets rid of a rarely used code-path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/acompress.c |   11 ++++-------
 crypto/aead.c      |   11 ++++-------
 crypto/ahash.c     |   11 ++++-------
 crypto/akcipher.c  |   11 ++++-------
 crypto/kpp.c       |   11 ++++-------
 crypto/rng.c       |   11 ++++-------
 crypto/scompress.c |   11 ++++-------
 crypto/shash.c     |   11 ++++-------
 crypto/skcipher.c  |   11 ++++-------
 9 files changed, 36 insertions(+), 63 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 022839ab457a..d17c1ef779de 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -33,7 +33,8 @@ static inline struct acomp_alg *crypto_acomp_alg(struct crypto_acomp *tfm)
 	return __crypto_acomp_alg(crypto_acomp_tfm(tfm)->__crt_alg);
 }
 
-#ifdef CONFIG_NET
+static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__maybe_unused;
 static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_acomp racomp;
@@ -44,12 +45,6 @@ static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 
 	return nla_put(skb, CRYPTOCFGA_REPORT_ACOMP, sizeof(racomp), &racomp);
 }
-#else
-static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
 
 static void crypto_acomp_show(struct seq_file *m, struct crypto_alg *alg)
 	__maybe_unused;
@@ -131,7 +126,9 @@ static const struct crypto_type crypto_acomp_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_acomp_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
 	.report = crypto_acomp_report,
+#endif
 #ifdef CONFIG_CRYPTO_STATS
 	.report_stat = crypto_acomp_report_stat,
 #endif
diff --git a/crypto/aead.c b/crypto/aead.c
index a36c3417ff6c..83d103addb62 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -177,7 +177,8 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
-#ifdef CONFIG_NET
+static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__maybe_unused;
 static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_aead raead;
@@ -194,12 +195,6 @@ static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 
 	return nla_put(skb, CRYPTOCFGA_REPORT_AEAD, sizeof(raead), &raead);
 }
-#else
-static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
 
 static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
 	__maybe_unused;
@@ -251,7 +246,9 @@ static const struct crypto_type crypto_aead_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_aead_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
 	.report = crypto_aead_report,
+#endif
 #ifdef CONFIG_CRYPTO_STATS
 	.report_stat = crypto_aead_report_stat,
 #endif
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3030caf8b1af..b1a9d7919157 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -469,7 +469,8 @@ static void crypto_ahash_free_instance(struct crypto_instance *inst)
 	ahash->free(ahash);
 }
 
-#ifdef CONFIG_NET
+static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__maybe_unused;
 static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_hash rhash;
@@ -483,12 +484,6 @@ static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
 
 	return nla_put(skb, CRYPTOCFGA_REPORT_HASH, sizeof(rhash), &rhash);
 }
-#else
-static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
 
 static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 	__maybe_unused;
@@ -517,7 +512,9 @@ static const struct crypto_type crypto_ahash_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_ahash_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
 	.report = crypto_ahash_report,
+#endif
 #ifdef CONFIG_CRYPTO_STATS
 	.report_stat = crypto_ahash_report_stat,
 #endif
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index d298baf9f312..a5aac25aa6f0 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -17,7 +17,8 @@
 
 #include "internal.h"
 
-#ifdef CONFIG_NET
+static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__maybe_unused;
 static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_akcipher rakcipher;
@@ -29,12 +30,6 @@ static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	return nla_put(skb, CRYPTOCFGA_REPORT_AKCIPHER,
 		       sizeof(rakcipher), &rakcipher);
 }
-#else
-static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
 
 static void crypto_akcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	__maybe_unused;
@@ -107,7 +102,9 @@ static const struct crypto_type crypto_akcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_akcipher_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
 	.report = crypto_akcipher_report,
+#endif
 #ifdef CONFIG_CRYPTO_STATS
 	.report_stat = crypto_akcipher_report_stat,
 #endif
diff --git a/crypto/kpp.c b/crypto/kpp.c
index 8dd2289469a6..12ebaf668c10 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -17,7 +17,8 @@
 
 #include "internal.h"
 
-#ifdef CONFIG_NET
+static int crypto_kpp_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__maybe_unused;
 static int crypto_kpp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_kpp rkpp;
@@ -28,12 +29,6 @@ static int crypto_kpp_report(struct sk_buff *skb, struct crypto_alg *alg)
 
 	return nla_put(skb, CRYPTOCFGA_REPORT_KPP, sizeof(rkpp), &rkpp);
 }
-#else
-static int crypto_kpp_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
 
 static void crypto_kpp_show(struct seq_file *m, struct crypto_alg *alg)
 	__maybe_unused;
@@ -103,7 +98,9 @@ static const struct crypto_type crypto_kpp_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_kpp_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
 	.report = crypto_kpp_report,
+#endif
 #ifdef CONFIG_CRYPTO_STATS
 	.report_stat = crypto_kpp_report_stat,
 #endif
diff --git a/crypto/rng.c b/crypto/rng.c
index de2b24dd88d4..5c4507769676 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -69,7 +69,8 @@ static unsigned int seedsize(struct crypto_alg *alg)
 	return ralg->seedsize;
 }
 
-#ifdef CONFIG_NET
+static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__maybe_unused;
 static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_rng rrng;
@@ -82,12 +83,6 @@ static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
 
 	return nla_put(skb, CRYPTOCFGA_REPORT_RNG, sizeof(rrng), &rrng);
 }
-#else
-static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
 
 static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
 	__maybe_unused;
@@ -125,7 +120,9 @@ static const struct crypto_type crypto_rng_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_rng_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
 	.report = crypto_rng_report,
+#endif
 #ifdef CONFIG_CRYPTO_STATS
 	.report_stat = crypto_rng_report_stat,
 #endif
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 214283f7730a..7e26a37b8eff 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -37,7 +37,8 @@ static const struct crypto_type crypto_scomp_type;
 static int scomp_scratch_users;
 static DEFINE_MUTEX(scomp_lock);
 
-#ifdef CONFIG_NET
+static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__maybe_unused;
 static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_comp rscomp;
@@ -49,12 +50,6 @@ static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 	return nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
 		       sizeof(rscomp), &rscomp);
 }
-#else
-static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
 
 static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
 	__maybe_unused;
@@ -246,7 +241,9 @@ static const struct crypto_type crypto_scomp_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_scomp_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
 	.report = crypto_scomp_report,
+#endif
 #ifdef CONFIG_CRYPTO_STATS
 	.report_stat = crypto_acomp_report_stat,
 #endif
diff --git a/crypto/shash.c b/crypto/shash.c
index 3ccacdbee73f..9b9e7b4ac804 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -490,7 +490,8 @@ static void crypto_shash_free_instance(struct crypto_instance *inst)
 	shash->free(shash);
 }
 
-#ifdef CONFIG_NET
+static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__maybe_unused;
 static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_hash rhash;
@@ -505,12 +506,6 @@ static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
 
 	return nla_put(skb, CRYPTOCFGA_REPORT_HASH, sizeof(rhash), &rhash);
 }
-#else
-static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
 
 static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 	__maybe_unused;
@@ -538,7 +533,9 @@ static const struct crypto_type crypto_shash_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_shash_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
 	.report = crypto_shash_report,
+#endif
 #ifdef CONFIG_CRYPTO_STATS
 	.report_stat = crypto_shash_report_stat,
 #endif
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index e8314722223d..d2f0b067715c 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -727,7 +727,8 @@ static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "walksize     : %u\n", skcipher->walksize);
 }
 
-#ifdef CONFIG_NET
+static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__maybe_unused;
 static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct skcipher_alg *skcipher = __crypto_skcipher_alg(alg);
@@ -746,12 +747,6 @@ static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	return nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
 		       sizeof(rblkcipher), &rblkcipher);
 }
-#else
-static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
 
 static int crypto_skcipher_report_stat(struct sk_buff *skb,
 				       struct crypto_alg *alg) __maybe_unused;
@@ -784,7 +779,9 @@ static const struct crypto_type crypto_skcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_skcipher_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
 	.report = crypto_skcipher_report,
+#endif
 #ifdef CONFIG_CRYPTO_STATS
 	.report_stat = crypto_skcipher_report_stat,
 #endif

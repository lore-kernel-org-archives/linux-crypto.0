Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF09C636CC
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 10:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjBPKga (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 05:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjBPKgX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 05:36:23 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F331053563
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 02:35:57 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pSbbs-00BwK8-1N; Thu, 16 Feb 2023 18:35:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Feb 2023 18:35:28 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 16 Feb 2023 18:35:28 +0800
Subject: [v2 PATCH 10/10] crypto: api - Check CRYPTO_USER instead of NET for report
References: <Y+4GpkkLQjyv7KUt@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1pSbbs-00BwK8-1N@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The report function is currently conditionalised on CONFIG_NET.
As it's only used by CONFIG_CRYPTO_USER, conditionalising on that
instead of CONFIG_NET makes more sense.

This gets rid of a rarely used code-path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/acompress.c |   12 ++++--------
 crypto/aead.c      |   12 ++++--------
 crypto/ahash.c     |   12 ++++--------
 crypto/akcipher.c  |   12 ++++--------
 crypto/kpp.c       |   12 ++++--------
 crypto/rng.c       |   12 ++++--------
 crypto/scompress.c |   12 ++++--------
 crypto/shash.c     |   12 ++++--------
 crypto/skcipher.c  |   12 ++++--------
 9 files changed, 36 insertions(+), 72 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 022839ab457a..82a290df2822 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -33,8 +33,8 @@ static inline struct acomp_alg *crypto_acomp_alg(struct crypto_acomp *tfm)
 	return __crypto_acomp_alg(crypto_acomp_tfm(tfm)->__crt_alg);
 }
 
-#ifdef CONFIG_NET
-static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+static int __maybe_unused crypto_acomp_report(
+	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_acomp racomp;
 
@@ -44,12 +44,6 @@ static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 
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
@@ -131,7 +125,9 @@ static const struct crypto_type crypto_acomp_type = {
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
index 5ea65c433608..ffc48a7dfb34 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -175,8 +175,8 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
-#ifdef CONFIG_NET
-static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
+static int __maybe_unused crypto_aead_report(
+	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_aead raead;
 	struct aead_alg *aead = container_of(alg, struct aead_alg, base);
@@ -192,12 +192,6 @@ static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 
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
@@ -248,7 +242,9 @@ static const struct crypto_type crypto_aead_type = {
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
index c886cec64c23..2d858d7fd1bb 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -469,8 +469,8 @@ static void crypto_ahash_free_instance(struct crypto_instance *inst)
 	ahash->free(ahash);
 }
 
-#ifdef CONFIG_NET
-static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
+static int __maybe_unused crypto_ahash_report(
+	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_hash rhash;
 
@@ -483,12 +483,6 @@ static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
 
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
@@ -515,7 +509,9 @@ static const struct crypto_type crypto_ahash_type = {
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
index 61d7c8b2d76e..186e762b509a 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -17,8 +17,8 @@
 
 #include "internal.h"
 
-#ifdef CONFIG_NET
-static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+static int __maybe_unused crypto_akcipher_report(
+	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_akcipher rakcipher;
 
@@ -29,12 +29,6 @@ static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
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
@@ -104,7 +98,9 @@ static const struct crypto_type crypto_akcipher_type = {
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
index 3e19c2f2cf94..74f2e8e918fa 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -17,8 +17,8 @@
 
 #include "internal.h"
 
-#ifdef CONFIG_NET
-static int crypto_kpp_report(struct sk_buff *skb, struct crypto_alg *alg)
+static int __maybe_unused crypto_kpp_report(
+	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_kpp rkpp;
 
@@ -28,12 +28,6 @@ static int crypto_kpp_report(struct sk_buff *skb, struct crypto_alg *alg)
 
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
@@ -102,7 +96,9 @@ static const struct crypto_type crypto_kpp_type = {
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
index ef56c71bda50..ffde0f64fb25 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -69,8 +69,8 @@ static unsigned int seedsize(struct crypto_alg *alg)
 	return ralg->seedsize;
 }
 
-#ifdef CONFIG_NET
-static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
+static int __maybe_unused crypto_rng_report(
+	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_rng rrng;
 
@@ -82,12 +82,6 @@ static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
 
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
@@ -124,7 +118,9 @@ static const struct crypto_type crypto_rng_type = {
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
index 214283f7730a..24138b42a648 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -37,8 +37,8 @@ static const struct crypto_type crypto_scomp_type;
 static int scomp_scratch_users;
 static DEFINE_MUTEX(scomp_lock);
 
-#ifdef CONFIG_NET
-static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+static int __maybe_unused crypto_scomp_report(
+	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_comp rscomp;
 
@@ -49,12 +49,6 @@ static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
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
@@ -246,7 +240,9 @@ static const struct crypto_type crypto_scomp_type = {
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
index 1f3454736f6e..dcc6a7170ce4 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -490,8 +490,8 @@ static void crypto_shash_free_instance(struct crypto_instance *inst)
 	shash->free(shash);
 }
 
-#ifdef CONFIG_NET
-static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
+static int __maybe_unused crypto_shash_report(
+	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_hash rhash;
 	struct shash_alg *salg = __crypto_shash_alg(alg);
@@ -505,12 +505,6 @@ static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
 
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
@@ -536,7 +530,9 @@ static const struct crypto_type crypto_shash_type = {
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
index 0139f3416339..6caca02d7e55 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -727,8 +727,8 @@ static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "walksize     : %u\n", skcipher->walksize);
 }
 
-#ifdef CONFIG_NET
-static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+static int __maybe_unused crypto_skcipher_report(
+	struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct skcipher_alg *skcipher = __crypto_skcipher_alg(alg);
 	struct crypto_report_blkcipher rblkcipher;
@@ -746,12 +746,6 @@ static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	return nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
 		       sizeof(rblkcipher), &rblkcipher);
 }
-#else
-static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
 
 static int __maybe_unused crypto_skcipher_report_stat(
 	struct sk_buff *skb, struct crypto_alg *alg)
@@ -782,7 +776,9 @@ static const struct crypto_type crypto_skcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_skcipher_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
 	.report = crypto_skcipher_report,
+#endif
 #ifdef CONFIG_CRYPTO_STATS
 	.report_stat = crypto_skcipher_report_stat,
 #endif

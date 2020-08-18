Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF14FC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6611206B5
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgHRIZe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 04:25:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42296 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgHRIZc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 04:25:32 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k7wvx-0000dR-Gn; Tue, 18 Aug 2020 18:25:30 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Aug 2020 18:25:29 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 18 Aug 2020 18:25:29 +1000
Subject: [PATCH 1/6] crypto: skcipher - Add helpers for sync skcipher spawn
References: <20200818082410.GA24497@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        ebiggers@kernel.org, Ben Greear <greearb@candelatech.com>
Message-Id: <E1k7wvx-0000dR-Gn@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds helpers for using sync skciphers as spawns from
crypto instances.

In doing so it also changes the error returned when an algorithm
exceeds the maximum sync skcipher request size from EINVAL to E2BIG
as the former is used for way too many things.

Also the CRYPTO_ALG_ASYNC bit is now masked off just in case someone
tries to be clever.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/skcipher.c                  |   38 ++++++++++++++++++++++++++-----------
 include/crypto/internal/skcipher.h |   28 +++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 467af525848a1..bc9fc0c07a659 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -14,7 +14,7 @@
 #include <crypto/scatterwalk.h>
 #include <linux/bug.h>
 #include <linux/cryptouser.h>
-#include <linux/compiler.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
@@ -762,16 +762,9 @@ struct crypto_skcipher *crypto_alloc_skcipher(const char *alg_name,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_skcipher);
 
-struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
-				const char *alg_name, u32 type, u32 mask)
+static struct crypto_sync_skcipher *crypto_verify_sync_skcipher(
+	struct crypto_skcipher *tfm)
 {
-	struct crypto_skcipher *tfm;
-
-	/* Only sync algorithms allowed. */
-	mask |= CRYPTO_ALG_ASYNC;
-
-	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
-
 	/*
 	 * Make sure we do not allocate something that might get used with
 	 * an on-stack request: check the request size.
@@ -779,13 +772,36 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 	if (!IS_ERR(tfm) && WARN_ON(crypto_skcipher_reqsize(tfm) >
 				    MAX_SYNC_SKCIPHER_REQSIZE)) {
 		crypto_free_skcipher(tfm);
-		return ERR_PTR(-EINVAL);
+		tfm = ERR_PTR(-E2BIG);
 	}
 
 	return (struct crypto_sync_skcipher *)tfm;
 }
+
+struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
+				const char *alg_name, u32 type, u32 mask)
+{
+	struct crypto_skcipher *tfm;
+
+	/* Only sync algorithms allowed. */
+	type &= ~CRYPTO_ALG_ASYNC;
+	mask |= CRYPTO_ALG_ASYNC;
+
+	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
+	return crypto_verify_sync_skcipher(tfm);
+}
 EXPORT_SYMBOL_GPL(crypto_alloc_sync_skcipher);
 
+struct crypto_sync_skcipher *crypto_spawn_sync_skcipher(
+	struct crypto_sync_skcipher_spawn *spawn)
+{
+	struct crypto_skcipher *tfm;
+
+	tfm = crypto_spawn_skcipher(&spawn->base);
+	return crypto_verify_sync_skcipher(tfm);
+}
+EXPORT_SYMBOL_GPL(crypto_spawn_sync_skcipher);
+
 int crypto_has_skcipher(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_skcipher_type, type, mask);
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 10226c12c5df0..19f99643c0fe2 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -31,6 +31,10 @@ struct crypto_skcipher_spawn {
 	struct crypto_spawn base;
 };
 
+struct crypto_sync_skcipher_spawn {
+	struct crypto_skcipher_spawn base;
+};
+
 struct skcipher_walk {
 	union {
 		struct {
@@ -92,11 +96,26 @@ int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
 			 struct crypto_instance *inst,
 			 const char *name, u32 type, u32 mask);
 
+static inline int crypto_grab_sync_skcipher(
+	struct crypto_sync_skcipher_spawn *spawn,
+	struct crypto_instance *inst, const char *name, u32 type, u32 mask)
+{
+	return crypto_grab_skcipher(&spawn->base, inst, name,
+				    type & ~CRYPTO_ALG_ASYNC,
+				    mask | CRYPTO_ALG_ASYNC);
+}
+
 static inline void crypto_drop_skcipher(struct crypto_skcipher_spawn *spawn)
 {
 	crypto_drop_spawn(&spawn->base);
 }
 
+static inline void crypto_drop_sync_skcipher(
+	struct crypto_sync_skcipher_spawn *spawn)
+{
+	crypto_drop_skcipher(&spawn->base);
+}
+
 static inline struct skcipher_alg *crypto_skcipher_spawn_alg(
 	struct crypto_skcipher_spawn *spawn)
 {
@@ -109,12 +128,21 @@ static inline struct skcipher_alg *crypto_spawn_skcipher_alg(
 	return crypto_skcipher_spawn_alg(spawn);
 }
 
+static inline struct skcipher_alg *crypto_sync_spawn_skcipher_alg(
+	struct crypto_sync_skcipher_spawn *spawn)
+{
+	return crypto_spawn_skcipher_alg(&spawn->base);
+}
+
 static inline struct crypto_skcipher *crypto_spawn_skcipher(
 	struct crypto_skcipher_spawn *spawn)
 {
 	return crypto_spawn_tfm2(&spawn->base);
 }
 
+struct crypto_sync_skcipher *crypto_spawn_sync_skcipher(
+	struct crypto_sync_skcipher_spawn *spawn);
+
 static inline void crypto_skcipher_set_reqsize(
 	struct crypto_skcipher *skcipher, unsigned int reqsize)
 {

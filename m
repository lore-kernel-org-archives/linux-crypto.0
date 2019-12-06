Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78B6C43603
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 02:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A36242075C
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 02:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfLFCgX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 21:36:23 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37578 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbfLFCgW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 21:36:22 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1id3Th-00034x-FW
        for <linux-crypto@vger.kernel.org>; Fri, 06 Dec 2019 10:36:21 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1id3Th-00078C-7M; Fri, 06 Dec 2019 10:36:21 +0800
Subject: [PATCH 3/3] crypto: hmac - Use init_tfm/exit_tfm interface
References: <20191206023527.k4kxngcsb7rpq2rz@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1id3Th-00078C-7M@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri, 06 Dec 2019 10:36:21 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch switches hmac over to the new init_tfm/exit_tfm interface
as opposed to cra_init/cra_exit.  This way the shash API can make
sure that descsize does not exceed the maximum.

This patch also adds the API helper shash_alg_instance.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/hmac.c                  |   20 +++++++-------------
 include/crypto/internal/hash.h |    6 ++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 8b2a212eb0ad..00a7abd7275d 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -138,12 +138,11 @@ static int hmac_finup(struct shash_desc *pdesc, const u8 *data,
 	       crypto_shash_finup(desc, out, ds, out);
 }
 
-static int hmac_init_tfm(struct crypto_tfm *tfm)
+static int hmac_init_tfm(struct crypto_shash *parent)
 {
-	struct crypto_shash *parent = __crypto_shash_cast(tfm);
 	struct crypto_shash *hash;
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_shash_spawn *spawn = crypto_instance_ctx(inst);
+	struct shash_instance *inst = shash_alg_instance(parent);
+	struct crypto_shash_spawn *spawn = shash_instance_ctx(inst);
 	struct hmac_ctx *ctx = hmac_ctx(parent);
 
 	hash = crypto_spawn_shash(spawn);
@@ -152,18 +151,14 @@ static int hmac_init_tfm(struct crypto_tfm *tfm)
 
 	parent->descsize = sizeof(struct shash_desc) +
 			   crypto_shash_descsize(hash);
-	if (WARN_ON(parent->descsize > HASH_MAX_DESCSIZE)) {
-		crypto_free_shash(hash);
-		return -EINVAL;
-	}
 
 	ctx->hash = hash;
 	return 0;
 }
 
-static void hmac_exit_tfm(struct crypto_tfm *tfm)
+static void hmac_exit_tfm(struct crypto_shash *parent)
 {
-	struct hmac_ctx *ctx = hmac_ctx(__crypto_shash_cast(tfm));
+	struct hmac_ctx *ctx = hmac_ctx(parent);
 	crypto_free_shash(ctx->hash);
 }
 
@@ -217,9 +212,6 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_ctxsize = sizeof(struct hmac_ctx) +
 				     ALIGN(ss * 2, crypto_tfm_ctx_alignment());
 
-	inst->alg.base.cra_init = hmac_init_tfm;
-	inst->alg.base.cra_exit = hmac_exit_tfm;
-
 	inst->alg.init = hmac_init;
 	inst->alg.update = hmac_update;
 	inst->alg.final = hmac_final;
@@ -227,6 +219,8 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.export = hmac_export;
 	inst->alg.import = hmac_import;
 	inst->alg.setkey = hmac_setkey;
+	inst->alg.init_tfm = hmac_init_tfm;
+	inst->alg.exit_tfm = hmac_exit_tfm;
 
 	err = shash_register_instance(tmpl, inst);
 	if (err) {
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index bfc9db7b100d..7bf4181c7abb 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -214,6 +214,12 @@ static inline struct shash_instance *shash_instance(
 			    struct shash_instance, alg);
 }
 
+static inline struct shash_instance *shash_alg_instance(	
+	struct crypto_shash *shash)
+{
+	return shash_instance(crypto_tfm_alg_instance(&shash->base));
+}
+
 static inline void *shash_instance_ctx(struct shash_instance *inst)
 {
 	return crypto_instance_ctx(shash_crypto_instance(inst));

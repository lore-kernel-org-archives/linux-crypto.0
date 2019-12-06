Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF101C2D0B1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 06:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 960F124679
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 06:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfLFGil (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 01:38:41 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52992 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfLFGik (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 01:38:40 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1id7GB-0005PO-KS
        for <linux-crypto@vger.kernel.org>; Fri, 06 Dec 2019 14:38:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1id7GB-00051a-DO; Fri, 06 Dec 2019 14:38:39 +0800
Subject: [PATCH 4/4] crypto: skcipher - Retain alg refcount in crypto_grab_skcipher
References: <20191206063812.ueudgjfwzri5ekpr@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1id7GB-00051a-DO@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri, 06 Dec 2019 14:38:39 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch changes crypto_grab_skcipher to retain the reference count
on the algorithm.  This is because the caller needs to access the
algorithm parameters and without the reference count the algorithm
can be freed at any time.

All callers have been modified to drop the reference count instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/adiantum.c                  |    2 ++
 crypto/authenc.c                   |    3 +++
 crypto/authencesn.c                |    3 +++
 crypto/ccm.c                       |    3 +++
 crypto/chacha20poly1305.c          |    3 +++
 crypto/cryptd.c                    |    3 ++-
 crypto/ctr.c                       |    3 +++
 crypto/cts.c                       |    3 +++
 crypto/essiv.c                     |    7 ++++---
 crypto/gcm.c                       |    3 +++
 crypto/lrw.c                       |    3 +++
 crypto/skcipher.c                  |    7 +------
 crypto/xts.c                       |    3 +++
 include/crypto/internal/skcipher.h |    5 +++++
 14 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 655fd8921c13..40f87474049e 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -628,6 +628,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	crypto_mod_put(_hash_alg);
 	crypto_mod_put(blockcipher_alg);
+	skcipher_alg_put(streamcipher_alg);
 	return 0;
 
 out_drop_hash:
@@ -639,6 +640,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	crypto_mod_put(blockcipher_alg);
 out_drop_streamcipher:
 	crypto_drop_skcipher(&ictx->streamcipher_spawn);
+	skcipher_alg_put(streamcipher_alg);
 out_free_inst:
 	kfree(inst);
 	return err;
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 3f0ed9402582..599155378983 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -473,12 +473,15 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 	if (err)
 		goto err_drop_enc;
 
+	skcipher_alg_put(enc);
+
 out:
 	crypto_mod_put(auth_base);
 	return err;
 
 err_drop_enc:
 	crypto_drop_skcipher(&ctx->enc);
+	skcipher_alg_put(enc);
 err_drop_auth:
 	crypto_drop_ahash(&ctx->auth);
 err_free_inst:
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index adb7554fca29..4bc96b8d8cf1 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -488,12 +488,15 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 	if (err)
 		goto err_drop_enc;
 
+	skcipher_alg_put(enc);
+
 out:
 	crypto_mod_put(auth_base);
 	return err;
 
 err_drop_enc:
 	crypto_drop_skcipher(&ctx->enc);
+	skcipher_alg_put(enc);
 err_drop_auth:
 	crypto_drop_ahash(&ctx->auth);
 err_free_inst:
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 6f555342a4a7..8898b08e10d9 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -548,12 +548,15 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 	if (err)
 		goto err_drop_ctr;
 
+	skcipher_alg_put(ctr);
+
 out_put_mac:
 	crypto_mod_put(mac_alg);
 	return err;
 
 err_drop_ctr:
 	crypto_drop_skcipher(&ictx->ctr);
+	skcipher_alg_put(ctr);
 err_drop_mac:
 	crypto_drop_ahash(&ictx->mac);
 err_free_inst:
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 74e824e537e6..95f4b28c1d39 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -665,12 +665,15 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	if (err)
 		goto out_drop_chacha;
 
+	skcipher_alg_put(chacha);
+
 out_put_poly:
 	crypto_mod_put(poly);
 	return err;
 
 out_drop_chacha:
 	crypto_drop_skcipher(&ctx->chacha);
+	skcipher_alg_put(chacha);
 err_drop_poly:
 	crypto_drop_ahash(&ctx->poly);
 err_free_inst:
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index c10ac1f61988..5e4de88848ea 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -451,8 +451,9 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 	inst->free = cryptd_skcipher_free;
 
 	err = skcipher_register_instance(tmpl, inst);
-	if (err) {
 out_drop_skcipher:
+	skcipher_alg_put(alg);
+	if (err) {
 		crypto_drop_skcipher(&ctx->spawn);
 out_free_inst:
 		kfree(inst);
diff --git a/crypto/ctr.c b/crypto/ctr.c
index e11e58950c0e..59f33840fd78 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -347,11 +347,14 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	if (err)
 		goto err_drop_spawn;
 
+	skcipher_alg_put(alg);
+
 out:
 	return err;
 
 err_drop_spawn:
 	crypto_drop_skcipher(spawn);
+	skcipher_alg_put(alg);
 err_free_inst:
 	kfree(inst);
 	goto out;
diff --git a/crypto/cts.c b/crypto/cts.c
index 6b6087dbb62a..2df557231630 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -397,11 +397,14 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto err_drop_spawn;
 
+	skcipher_alg_put(alg);
+
 out:
 	return err;
 
 err_drop_spawn:
 	crypto_drop_skcipher(spawn);
+	skcipher_alg_put(alg);
 err_free_inst:
 	kfree(inst);
 	goto out;
diff --git a/crypto/essiv.c b/crypto/essiv.c
index 08e0209d1b09..2c0bbef770f9 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -624,7 +624,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	crypto_mod_put(_hash_alg);
 
 	if (type == CRYPTO_ALG_TYPE_SKCIPHER)
-		;
+		skcipher_alg_put(skcipher_alg);
 	else
 		aead_alg_put(aead_alg);
 
@@ -633,9 +633,10 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 out_free_hash:
 	crypto_mod_put(_hash_alg);
 out_drop_skcipher:
-	if (type == CRYPTO_ALG_TYPE_SKCIPHER)
+	if (type == CRYPTO_ALG_TYPE_SKCIPHER) {
 		crypto_drop_skcipher(&ictx->u.skcipher_spawn);
-	else {
+		skcipher_alg_put(skcipher_alg);
+	} else {
 		crypto_drop_aead(&ictx->u.aead_spawn);
 		aead_alg_put(aead_alg);
 	}
diff --git a/crypto/gcm.c b/crypto/gcm.c
index f10af8f50836..d0a0aa93bb5f 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -676,12 +676,15 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	if (err)
 		goto out_put_ctr;
 
+	skcipher_alg_put(ctr);
+
 out_put_ghash:
 	crypto_mod_put(ghash_alg);
 	return err;
 
 out_put_ctr:
 	crypto_drop_skcipher(&ctx->ctr);
+	skcipher_alg_put(ctr);
 err_drop_ghash:
 	crypto_drop_ahash(&ctx->ghash);
 err_free_inst:
diff --git a/crypto/lrw.c b/crypto/lrw.c
index be829f6afc8e..4c23f273671e 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -407,11 +407,14 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto err_drop_spawn;
 
+	skcipher_alg_put(alg);
+
 out:
 	return err;
 
 err_drop_spawn:
 	crypto_drop_skcipher(spawn);
+	skcipher_alg_put(alg);
 err_free_inst:
 	kfree(inst);
 	goto out;
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index d7cc271ed76b..41142c8cb912 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -770,13 +770,8 @@ static const struct crypto_type crypto_skcipher_type = {
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
 			  const char *name, u32 type, u32 mask)
 {
-	int err;
-
 	spawn->base.frontend = &crypto_skcipher_type;
-	err = crypto_grab_spawn(&spawn->base, name, type, mask);
-	if (!err)
-		crypto_mod_put(spawn->base.alg);
-	return err;
+	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_grab_skcipher);
 
diff --git a/crypto/xts.c b/crypto/xts.c
index ab117633d64e..40cf16c103e2 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -445,11 +445,14 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto err_drop_spawn;
 
+	skcipher_alg_put(alg);
+
 out:
 	return err;
 
 err_drop_spawn:
 	crypto_drop_skcipher(&ctx->spawn);
+	skcipher_alg_put(alg);
 err_free_inst:
 	kfree(inst);
 	goto out;
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index ad4a6330ff53..7b41fffb9bfc 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -226,5 +226,10 @@ static inline struct crypto_alg *skcipher_ialg_simple(
 	return spawn->alg;
 }
 
+static inline void skcipher_alg_put(struct skcipher_alg *alg)
+{
+	crypto_mod_put(&alg->base);
+}
+
 #endif	/* _CRYPTO_INTERNAL_SKCIPHER_H */
 

Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459C1C2D0C0
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 06:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26A5424679
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 06:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfLFGii (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 01:38:38 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52984 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfLFGii (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 01:38:38 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1id7G9-0005Ox-DR
        for <linux-crypto@vger.kernel.org>; Fri, 06 Dec 2019 14:38:37 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1id7G9-00051G-5w; Fri, 06 Dec 2019 14:38:37 +0800
Subject: [PATCH 2/4] crypto: aead - Retain alg refcount in crypto_grab_aead
References: <20191206063812.ueudgjfwzri5ekpr@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1id7G9-00051G-5w@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri, 06 Dec 2019 14:38:37 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch changes crypto_grab_aead to retain the reference count
on the algorithm.  This is because the caller needs to access the
algorithm parameters and without the reference count the algorithm
can be freed at any time.

All callers have been modified to drop the reference count instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                   |    7 +------
 crypto/ccm.c                    |    3 +++
 crypto/cryptd.c                 |    3 ++-
 crypto/echainiv.c               |    1 +
 crypto/essiv.c                  |   10 +++++++++-
 crypto/gcm.c                    |    6 ++++++
 crypto/geniv.c                  |    1 +
 crypto/pcrypt.c                 |    3 +++
 crypto/seqiv.c                  |    1 +
 include/crypto/internal/aead.h  |    5 +++++
 include/crypto/internal/geniv.h |    7 +++++++
 11 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index f548a5c3f74d..47f16d139e8e 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -210,13 +210,8 @@ static const struct crypto_type crypto_aead_type = {
 int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
 		     u32 type, u32 mask)
 {
-	int err;
-
 	spawn->base.frontend = &crypto_aead_type;
-	err = crypto_grab_spawn(&spawn->base, name, type, mask);
-	if (!err)
-		crypto_mod_put(spawn->base.alg);
-	return err;
+	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_grab_aead);
 
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 380eb619f657..6f555342a4a7 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -819,11 +819,14 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 	if (err)
 		goto out_drop_alg;
 
+	aead_alg_put(alg);
+
 out:
 	return err;
 
 out_drop_alg:
 	crypto_drop_aead(spawn);
+	aead_alg_put(alg);
 out_free_inst:
 	kfree(inst);
 	goto out;
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 2c6649b10923..c10ac1f61988 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -899,8 +899,9 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	inst->alg.decrypt = cryptd_aead_decrypt_enqueue;
 
 	err = aead_register_instance(tmpl, inst);
-	if (err) {
 out_drop_aead:
+	aead_alg_put(alg);
+	if (err) {
 		crypto_drop_aead(&ctx->aead_spawn);
 out_free_inst:
 		kfree(inst);
diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index a49cbf7b0929..0b4dc95abfcb 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -136,6 +136,7 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	inst->free = aead_geniv_free;
 
 	err = aead_register_instance(tmpl, inst);
+	aead_geniv_alg_put(inst);
 	if (err)
 		goto free_inst;
 
diff --git a/crypto/essiv.c b/crypto/essiv.c
index 808f2b362106..08e0209d1b09 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -622,6 +622,12 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 		goto out_free_hash;
 
 	crypto_mod_put(_hash_alg);
+
+	if (type == CRYPTO_ALG_TYPE_SKCIPHER)
+		;
+	else
+		aead_alg_put(aead_alg);
+
 	return 0;
 
 out_free_hash:
@@ -629,8 +635,10 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 out_drop_skcipher:
 	if (type == CRYPTO_ALG_TYPE_SKCIPHER)
 		crypto_drop_skcipher(&ictx->u.skcipher_spawn);
-	else
+	else {
 		crypto_drop_aead(&ictx->u.aead_spawn);
+		aead_alg_put(aead_alg);
+	}
 out_free_inst:
 	kfree(skcipher_inst);
 	kfree(aead_inst);
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 73884208f075..f10af8f50836 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -941,11 +941,14 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	if (err)
 		goto out_drop_alg;
 
+	aead_alg_put(alg);
+
 out:
 	return err;
 
 out_drop_alg:
 	crypto_drop_aead(spawn);
+	aead_alg_put(alg);
 out_free_inst:
 	kfree(inst);
 	goto out;
@@ -1179,11 +1182,14 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 	if (err)
 		goto out_drop_alg;
 
+	aead_alg_put(alg);
+
 out:
 	return err;
 
 out_drop_alg:
 	crypto_drop_aead(spawn);
+	aead_alg_put(alg);
 out_free_inst:
 	kfree(inst);
 	goto out;
diff --git a/crypto/geniv.c b/crypto/geniv.c
index b9e45a2a98b5..be6b8c2c30b8 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -105,6 +105,7 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 
 err_drop_alg:
 	crypto_drop_aead(spawn);
+	aead_alg_put(alg);
 err_free_inst:
 	kfree(inst);
 	inst = ERR_PTR(err);
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 543792e0ebf0..d7d4ad148a57 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -266,11 +266,14 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	if (err)
 		goto out_drop_aead;
 
+	aead_alg_put(alg);
+
 out:
 	return err;
 
 out_drop_aead:
 	crypto_drop_aead(&ctx->spawn);
+	aead_alg_put(alg);
 out_free_inst:
 	kfree(inst);
 	goto out;
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 96d222c32acc..239826e4054c 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -159,6 +159,7 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_ctxsize += inst->alg.ivsize;
 
 	err = aead_register_instance(tmpl, inst);
+	aead_geniv_alg_put(inst);
 	if (err)
 		goto free_inst;
 
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index c509ec30fc65..43c3b33902ae 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -175,6 +175,11 @@ static inline unsigned int crypto_aead_chunksize(struct crypto_aead *tfm)
 	return crypto_aead_alg_chunksize(crypto_aead_alg(tfm));
 }
 
+static inline void aead_alg_put(struct aead_alg *alg)
+{
+	crypto_mod_put(&alg->base);
+}
+
 int crypto_register_aead(struct aead_alg *alg);
 void crypto_unregister_aead(struct aead_alg *alg);
 int crypto_register_aeads(struct aead_alg *algs, int count);
diff --git a/include/crypto/internal/geniv.h b/include/crypto/internal/geniv.h
index 0108c0c7b2ed..462e363bcb68 100644
--- a/include/crypto/internal/geniv.h
+++ b/include/crypto/internal/geniv.h
@@ -25,4 +25,11 @@ void aead_geniv_free(struct aead_instance *inst);
 int aead_init_geniv(struct crypto_aead *tfm);
 void aead_exit_geniv(struct crypto_aead *tfm);
 
+static inline void aead_geniv_alg_put(struct aead_instance *inst)
+{
+	struct crypto_aead_spawn *spawn = aead_instance_ctx(inst);
+	struct aead_alg *alg = crypto_spawn_aead_alg(spawn);
+	aead_alg_put(alg);
+}
+
 #endif	/* _CRYPTO_INTERNAL_GENIV_H */

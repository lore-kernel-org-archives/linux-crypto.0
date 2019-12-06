Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77ACC43603
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 14:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C1A624673
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 14:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfLFOjy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 09:39:54 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:46970 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfLFOjy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 09:39:54 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1idEls-0007yP-S9
        for <linux-crypto@vger.kernel.org>; Fri, 06 Dec 2019 22:39:52 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1idEls-0001VO-Jk; Fri, 06 Dec 2019 22:39:52 +0800
Subject: [PATCH 1/2] crypto: api - Fix race condition in crypto_spawn_alg
References: <20191206143914.hfggirmmnjk27kx4@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1idEls-0001VO-Jk@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri, 06 Dec 2019 22:39:52 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function crypto_spawn_alg is racy because it drops the lock
before shooting the dying algorithm.  The algorithm could disappear
altogether before we shoot it.

This patch fixes it by moving the shooting into the locked section.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c   |   16 +++++-----------
 crypto/api.c      |    3 +--
 crypto/internal.h |    1 -
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 6869feb31c99..cc55301beef4 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -678,22 +678,16 @@ EXPORT_SYMBOL_GPL(crypto_drop_spawn);
 static struct crypto_alg *crypto_spawn_alg(struct crypto_spawn *spawn)
 {
 	struct crypto_alg *alg;
-	struct crypto_alg *alg2;
 
 	down_read(&crypto_alg_sem);
 	alg = spawn->alg;
-	alg2 = alg;
-	if (alg2)
-		alg2 = crypto_mod_get(alg2);
-	up_read(&crypto_alg_sem);
-
-	if (!alg2) {
-		if (alg)
-			crypto_shoot_alg(alg);
-		return ERR_PTR(-EAGAIN);
+	if (alg && !crypto_mod_get(alg)) {
+		alg->cra_flags |= CRYPTO_ALG_DYING;
+		alg = NULL;
 	}
+	up_read(&crypto_alg_sem);
 
-	return alg;
+	return alg ?: ERR_PTR(-EAGAIN);
 }
 
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
diff --git a/crypto/api.c b/crypto/api.c
index 55bca28df92d..0ef9f2a37d3d 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -344,13 +344,12 @@ static unsigned int crypto_ctxsize(struct crypto_alg *alg, u32 type, u32 mask)
 	return len;
 }
 
-void crypto_shoot_alg(struct crypto_alg *alg)
+static void crypto_shoot_alg(struct crypto_alg *alg)
 {
 	down_write(&crypto_alg_sem);
 	alg->cra_flags |= CRYPTO_ALG_DYING;
 	up_write(&crypto_alg_sem);
 }
-EXPORT_SYMBOL_GPL(crypto_shoot_alg);
 
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask)
diff --git a/crypto/internal.h b/crypto/internal.h
index 93df7bec844a..e506a57e2243 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -68,7 +68,6 @@ void crypto_alg_tested(const char *name, int err);
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg);
 void crypto_remove_final(struct list_head *list);
-void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm(struct crypto_alg *alg,

Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDE0C43603
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 06:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A78C24679
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 06:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLFGih (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 01:38:37 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52980 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfLFGih (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 01:38:37 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1id7G8-0005Op-A8
        for <linux-crypto@vger.kernel.org>; Fri, 06 Dec 2019 14:38:36 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1id7G8-000516-19; Fri, 06 Dec 2019 14:38:36 +0800
Subject: [PATCH 1/4] crypto: api - Retain alg refcount in crypto_grab_spawn
References: <20191206063812.ueudgjfwzri5ekpr@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1id7G8-000516-19@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri, 06 Dec 2019 14:38:36 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch changes crypto_grab_spawn to retain the reference count
on the algorithm.  This is because the caller needs to access the
algorithm parameters and without the reference count the algorithm
can be freed at any time.

For now this only changes adiantum as all other callers of this
function are internal API users.  The internal API callers will
still drop the ref count immediately.  They will be changed in
subsequent patches.
 
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/adiantum.c |    2 ++
 crypto/aead.c     |    7 ++++++-
 crypto/akcipher.c |    7 ++++++-
 crypto/algapi.c   |    1 -
 crypto/skcipher.c |    7 ++++++-
 5 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index aded26092268..655fd8921c13 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -627,6 +627,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 		goto out_drop_hash;
 
 	crypto_mod_put(_hash_alg);
+	crypto_mod_put(blockcipher_alg);
 	return 0;
 
 out_drop_hash:
@@ -635,6 +636,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	crypto_mod_put(_hash_alg);
 out_drop_blockcipher:
 	crypto_drop_spawn(&ictx->blockcipher_spawn);
+	crypto_mod_put(blockcipher_alg);
 out_drop_streamcipher:
 	crypto_drop_skcipher(&ictx->streamcipher_spawn);
 out_free_inst:
diff --git a/crypto/aead.c b/crypto/aead.c
index 47f16d139e8e..f548a5c3f74d 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -210,8 +210,13 @@ static const struct crypto_type crypto_aead_type = {
 int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
 		     u32 type, u32 mask)
 {
+	int err;
+
 	spawn->base.frontend = &crypto_aead_type;
-	return crypto_grab_spawn(&spawn->base, name, type, mask);
+	err = crypto_grab_spawn(&spawn->base, name, type, mask);
+	if (!err)
+		crypto_mod_put(spawn->base.alg);
+	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_grab_aead);
 
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 7d5cf4939423..ce3471102120 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -93,8 +93,13 @@ static const struct crypto_type crypto_akcipher_type = {
 int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn, const char *name,
 			 u32 type, u32 mask)
 {
+	int err;
+
 	spawn->base.frontend = &crypto_akcipher_type;
-	return crypto_grab_spawn(&spawn->base, name, type, mask);
+	err = crypto_grab_spawn(&spawn->base, name, type, mask);
+	if (!err)
+		crypto_mod_put(spawn->base.alg);
+	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_grab_akcipher);
 
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 9ecb4a57b342..6869feb31c99 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -662,7 +662,6 @@ int crypto_grab_spawn(struct crypto_spawn *spawn, const char *name,
 		return PTR_ERR(alg);
 
 	err = crypto_init_spawn(spawn, alg, spawn->inst, mask);
-	crypto_mod_put(alg);
 	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_grab_spawn);
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 41142c8cb912..d7cc271ed76b 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -770,8 +770,13 @@ static const struct crypto_type crypto_skcipher_type = {
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
 			  const char *name, u32 type, u32 mask)
 {
+	int err;
+
 	spawn->base.frontend = &crypto_skcipher_type;
-	return crypto_grab_spawn(&spawn->base, name, type, mask);
+	err = crypto_grab_spawn(&spawn->base, name, type, mask);
+	if (!err)
+		crypto_mod_put(spawn->base.alg);
+	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_grab_skcipher);
 

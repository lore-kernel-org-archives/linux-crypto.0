Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9881C43603
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 06:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9033824679
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 06:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfLFGik (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 01:38:40 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52988 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfLFGij (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 01:38:39 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1id7GA-0005P6-Gt
        for <linux-crypto@vger.kernel.org>; Fri, 06 Dec 2019 14:38:38 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1id7GA-00051Q-9U; Fri, 06 Dec 2019 14:38:38 +0800
Subject: [PATCH 3/4] crypto: akcipher - Retain alg refcount in crypto_grab_akcipher
References: <20191206063812.ueudgjfwzri5ekpr@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1id7GA-00051Q-9U@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri, 06 Dec 2019 14:38:38 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch changes crypto_grab_akcipher to retain the reference count
on the algorithm.  This is because the caller needs to access the
algorithm parameters and without the reference count the algorithm
can be freed at any time.

All callers have been modified to drop the reference count instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/akcipher.c                  |    7 +------
 crypto/rsa-pkcs1pad.c              |    3 +++
 include/crypto/internal/akcipher.h |    5 +++++
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index ce3471102120..7d5cf4939423 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -93,13 +93,8 @@ static const struct crypto_type crypto_akcipher_type = {
 int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn, const char *name,
 			 u32 type, u32 mask)
 {
-	int err;
-
 	spawn->base.frontend = &crypto_akcipher_type;
-	err = crypto_grab_spawn(&spawn->base, name, type, mask);
-	if (!err)
-		crypto_mod_put(spawn->base.alg);
-	return err;
+	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_grab_akcipher);
 
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 0aa489711ec4..c445e93216e1 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -692,10 +692,13 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto out_drop_alg;
 
+	akcipher_alg_put(rsa_alg);
+
 	return 0;
 
 out_drop_alg:
 	crypto_drop_akcipher(spawn);
+	akcipher_alg_put(rsa_alg);
 out_free_inst:
 	kfree(inst);
 	return err;
diff --git a/include/crypto/internal/akcipher.h b/include/crypto/internal/akcipher.h
index d6c8a42789ad..10c36ed22b78 100644
--- a/include/crypto/internal/akcipher.h
+++ b/include/crypto/internal/akcipher.h
@@ -105,6 +105,11 @@ static inline struct akcipher_alg *crypto_spawn_akcipher_alg(
 	return container_of(spawn->base.alg, struct akcipher_alg, base);
 }
 
+static inline void akcipher_alg_put(struct akcipher_alg *alg)
+{
+	crypto_mod_put(&alg->base);
+}
+
 /**
  * crypto_register_akcipher() -- Register public key algorithm
  *

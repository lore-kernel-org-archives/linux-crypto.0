From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/24] crypto: api - Add crypto_grab_spawn primitive
Date: Mon, 11 May 2015 17:47:39 +0800
Message-ID: <E1YrkJH-00017q-Vo@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55849 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbEKJrm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:42 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJI-0000DH-4u
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:40 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a new primitive crypto_grab_spawn which is meant
to replace crypto_init_spawn and crypto_init_spawn2.  Under the
new scheme the user no longer has to worry about reference counting
the alg object before it is subsumed by the spawn.

It is pretty much an exact copy of crypto_grab_aead.

Prior to calling this function spawn->frontend and spawn->inst
must have been set.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c         |   16 ++++++++++++++++
 include/crypto/algapi.h |    2 ++
 2 files changed, 18 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 3103e6a..abf100c 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -612,6 +612,22 @@ out:
 }
 EXPORT_SYMBOL_GPL(crypto_init_spawn2);
 
+int crypto_grab_spawn(struct crypto_spawn *spawn, const char *name,
+		      u32 type, u32 mask)
+{
+	struct crypto_alg *alg;
+	int err;
+
+	alg = crypto_find_alg(name, spawn->frontend, type, mask);
+	if (IS_ERR(alg))
+		return PTR_ERR(alg);
+
+	err = crypto_init_spawn(spawn, alg, spawn->inst, mask);
+	crypto_mod_put(alg);
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_grab_spawn);
+
 void crypto_drop_spawn(struct crypto_spawn *spawn)
 {
 	if (!spawn->alg)
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 0ecb768..a949bf7 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -144,6 +144,8 @@ int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
 int crypto_init_spawn2(struct crypto_spawn *spawn, struct crypto_alg *alg,
 		       struct crypto_instance *inst,
 		       const struct crypto_type *frontend);
+int crypto_grab_spawn(struct crypto_spawn *spawn, const char *name,
+		      u32 type, u32 mask);
 
 void crypto_drop_spawn(struct crypto_spawn *spawn);
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,

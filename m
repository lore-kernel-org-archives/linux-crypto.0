From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/14] crypto: pcrypt - Propagate new AEAD implementation flag
Date: Thu, 09 Jul 2015 07:17:18 +0800
Message-ID: <E1ZCyac-0007Xl-G5@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57050 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbbGHXRV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:21 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZCyac-0005Dn-Mn
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2015 09:17:18 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch allows the CRYPTO_ALG_AEAD_NEW flag to be propagated.

It also restores the ASYNC bit that went missing during the AEAD
conversion.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/pcrypt.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 45e7d51..001a3a3 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -274,11 +274,16 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 			      u32 type, u32 mask)
 {
 	struct pcrypt_instance_ctx *ctx;
+	struct crypto_attr_type *algt;
 	struct aead_instance *inst;
 	struct aead_alg *alg;
 	const char *name;
 	int err;
 
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
 	name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
@@ -290,7 +295,9 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	ctx = aead_instance_ctx(inst);
 	crypto_set_aead_spawn(&ctx->spawn, aead_crypto_instance(inst));
 
-	err = crypto_grab_aead(&ctx->spawn, name, 0, 0);
+	err = crypto_grab_aead(&ctx->spawn, name,
+			       algt->type & CRYPTO_ALG_AEAD_NEW,
+			       algt->mask & CRYPTO_ALG_AEAD_NEW);
 	if (err)
 		goto out_free_inst;
 
@@ -299,6 +306,9 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	if (err)
 		goto out_drop_aead;
 
+	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags |= alg->base.cra_flags & CRYPTO_ALG_AEAD_NEW;
+
 	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
 	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 

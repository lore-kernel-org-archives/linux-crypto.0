From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/8] crypto: echainiv - Only hold RNG during initialisation
Date: Sun, 21 Jun 2015 19:11:50 +0800
Message-ID: <E1Z6dAE-0007rM-VL@gondolin.me.apana.org.au>
References: <20150621110702.GA29747@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53448 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbbFULLy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 07:11:54 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Z6dAF-0000Fl-H0
	for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2015 21:11:51 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes the RNG allocation so that we only hold a
reference to the RNG during initialisation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/echainiv.c |   28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 08d3336..b6e43dc 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -197,8 +197,13 @@ static int echainiv_init(struct crypto_tfm *tfm)
 
 	crypto_aead_set_reqsize(geniv, sizeof(struct aead_request));
 
+	err = crypto_get_default_rng();
+	if (err)
+		goto out;
+
 	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
 				   crypto_aead_ivsize(geniv));
+	crypto_put_default_rng();
 	if (err)
 		goto out;
 
@@ -277,35 +282,14 @@ free_inst:
 	goto out;
 }
 
-static int echainiv_create(struct crypto_template *tmpl, struct rtattr **tb)
-{
-	int err;
-
-	err = crypto_get_default_rng();
-	if (err)
-		goto out;
-
-	err = echainiv_aead_create(tmpl, tb);
-	if (err)
-		goto put_rng;
-
-out:
-	return err;
-
-put_rng:
-	crypto_put_default_rng();
-	goto out;
-}
-
 static void echainiv_free(struct crypto_instance *inst)
 {
 	aead_geniv_free(aead_instance(inst));
-	crypto_put_default_rng();
 }
 
 static struct crypto_template echainiv_tmpl = {
 	.name = "echainiv",
-	.create = echainiv_create,
+	.create = echainiv_aead_create,
 	.free = echainiv_free,
 	.module = THIS_MODULE,
 };

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 12/30] crypto: echainiv - Use skcipher
Date: Tue, 12 Jul 2016 13:17:43 +0800
Message-ID: <E1bMq4l-0007R4-VI@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54322 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbcGLFRq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:46 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4m-0004bO-44
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:44 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces use of the obsolete blkcipher with skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/echainiv.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index b96a8456..1b01fe9 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -20,6 +20,7 @@
 
 #include <crypto/internal/geniv.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -112,13 +113,16 @@ static int echainiv_encrypt(struct aead_request *req)
 	info = req->iv;
 
 	if (req->src != req->dst) {
-		struct blkcipher_desc desc = {
-			.tfm = ctx->null,
-		};
+		SKCIPHER_REQUEST_ON_STACK(nreq, ctx->sknull);
 
-		err = crypto_blkcipher_encrypt(
-			&desc, req->dst, req->src,
-			req->assoclen + req->cryptlen);
+		skcipher_request_set_tfm(nreq, ctx->sknull);
+		skcipher_request_set_callback(nreq, req->base.flags,
+					      NULL, NULL);
+		skcipher_request_set_crypt(nreq, req->src, req->dst,
+					   req->assoclen + req->cryptlen,
+					   NULL);
+
+		err = crypto_skcipher_encrypt(nreq);
 		if (err)
 			return err;
 	}

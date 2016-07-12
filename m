From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/30] crypto: seqiv - Use skcipher
Date: Tue, 12 Jul 2016 13:17:45 +0800
Message-ID: <E1bMq4n-0007RL-2T@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37104 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbcGLFRs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:48 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4n-0004bt-6r
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:45 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces use of the obsolete blkcipher with skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 15a749a..a859b3a 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -165,12 +165,16 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	info = req->iv;
 
 	if (req->src != req->dst) {
-		struct blkcipher_desc desc = {
-			.tfm = ctx->null,
-		};
+		SKCIPHER_REQUEST_ON_STACK(nreq, ctx->sknull);
 
-		err = crypto_blkcipher_encrypt(&desc, req->dst, req->src,
-					       req->assoclen + req->cryptlen);
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

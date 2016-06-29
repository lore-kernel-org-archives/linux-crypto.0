From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 23/28] crypto: seqiv - Use skcipher
Date: Wed, 29 Jun 2016 18:04:10 +0800
Message-ID: <E1bICLq-0006x1-An@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58045 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbcF2KEN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:13 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLq-0005NH-Fe
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:10 +1000
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

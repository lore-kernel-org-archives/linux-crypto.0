From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/11] crypto: echainiv - Copy AD along with plain text
Date: Wed, 27 May 2015 14:37:31 +0800
Message-ID: <E1YxUy3-0006m2-Lv@gondolin.me.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48442 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbbE0Ghf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 02:37:35 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YxUy4-0005bl-LX
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2015 16:37:32 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As the AD does not necessarily exist in the destination buffer
it must be copied along with the plain text.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/echainiv.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index bd85dcc..02d0543 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -228,19 +228,13 @@ static int echainiv_encrypt(struct aead_request *req)
 	info = req->iv;
 
 	if (req->src != req->dst) {
-		struct scatterlist src[2];
-		struct scatterlist dst[2];
 		struct blkcipher_desc desc = {
 			.tfm = ctx->null,
 		};
 
 		err = crypto_blkcipher_encrypt(
-			&desc,
-			scatterwalk_ffwd(dst, req->dst,
-					 req->assoclen + ivsize),
-			scatterwalk_ffwd(src, req->src,
-					 req->assoclen + ivsize),
-			req->cryptlen - ivsize);
+			&desc, req->dst, req->src,
+			req->assoclen + req->cryptlen);
 		if (err)
 			return err;
 	}

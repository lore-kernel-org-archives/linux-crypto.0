From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/11] crypto: aead - Preserve in-place processing in old_crypt
Date: Wed, 27 May 2015 14:37:29 +0800
Message-ID: <E1YxUy1-0006lU-1I@gondolin.me.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33185 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbbE0Ghc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 02:37:32 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YxUy1-0005bR-9H
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2015 16:37:29 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch tries to preserve in-place processing in old_crypt as
various algorithms are optimised for in-place processing where
src == dst.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 7c3d725..35c55e0 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -107,7 +107,8 @@ static int old_crypt(struct aead_request *req,
 		return crypt(req);
 
 	src = scatterwalk_ffwd(nreq->srcbuf, req->src, req->assoclen);
-	dst = scatterwalk_ffwd(nreq->dstbuf, req->dst, req->assoclen);
+	dst = req->src == req->dst ?
+	      src : scatterwalk_ffwd(nreq->dstbuf, req->dst, req->assoclen);
 
 	aead_request_set_tfm(&nreq->subreq, aead);
 	aead_request_set_callback(&nreq->subreq, aead_request_flags(req),

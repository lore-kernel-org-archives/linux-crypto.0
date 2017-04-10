From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: lrw - Fix use-after-free on EINPROGRESS
Date: Mon, 10 Apr 2017 17:15:48 +0800
Message-ID: <20170410091547.GA7634@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51778 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbdDJJQH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 05:16:07 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When we get an EINPROGRESS completion in lrw, we will end up marking
the request as done and freeing it.  This then blows up when the
request is really completed as we've already freed the memory.

Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 3ea095a..a8bfae4 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -345,6 +345,13 @@ static void encrypt_done(struct crypto_async_request *areq, int err)
 	struct rctx *rctx;
 
 	rctx = skcipher_request_ctx(req);
+
+	if (err == -EINPROGRESS) {
+		if (rctx->left != req->cryptlen)
+			return;
+		goto out;
+	}
+
 	subreq = &rctx->subreq;
 	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 
@@ -352,6 +359,7 @@ static void encrypt_done(struct crypto_async_request *areq, int err)
 	if (rctx->left)
 		return;
 
+out:
 	skcipher_request_complete(req, err);
 }
 
@@ -389,6 +397,13 @@ static void decrypt_done(struct crypto_async_request *areq, int err)
 	struct rctx *rctx;
 
 	rctx = skcipher_request_ctx(req);
+
+	if (err == -EINPROGRESS) {
+		if (rctx->left != req->cryptlen)
+			return;
+		goto out;
+	}
+
 	subreq = &rctx->subreq;
 	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 
@@ -396,6 +411,7 @@ static void decrypt_done(struct crypto_async_request *areq, int err)
 	if (rctx->left)
 		return;
 
+out:
 	skcipher_request_complete(req, err);
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

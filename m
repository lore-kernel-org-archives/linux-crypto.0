From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: algif_aead - Fix bogus request dereference in completion
 function
Date: Mon, 10 Apr 2017 17:59:07 +0800
Message-ID: <20170410095907.GA8226@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:51816 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752963AbdDJJ7d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2017 05:59:33 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The algif_aead completion function tries to deduce the aead_request
from the crypto_async_request argument.  This is broken because
the API does not guarantee that the same request will be pased to
the completion function.  Only the value of req->data can be used
in the completion function.

This patch fixes it by storing a pointer to sk in areq and using
that instead of passing in sk through req->data.

Fixes: 83094e5e9e49 ("crypto: af_alg - add async support to...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 5a80537..ef59d99 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -40,6 +40,7 @@ struct aead_async_req {
 	struct aead_async_rsgl first_rsgl;
 	struct list_head list;
 	struct kiocb *iocb;
+	struct sock *sk;
 	unsigned int tsgls;
 	char iv[];
 };
@@ -379,12 +380,10 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 
 static void aead_async_cb(struct crypto_async_request *_req, int err)
 {
-	struct sock *sk = _req->data;
-	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
-	struct aead_request *req = aead_request_cast(_req);
+	struct aead_request *req = _req->data;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aead_async_req *areq = GET_ASYM_REQ(req, tfm);
+	struct sock *sk = areq->sk;
 	struct scatterlist *sg = areq->tsgl;
 	struct aead_async_rsgl *rsgl;
 	struct kiocb *iocb = areq->iocb;
@@ -447,11 +446,12 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	memset(&areq->first_rsgl, '\0', sizeof(areq->first_rsgl));
 	INIT_LIST_HEAD(&areq->list);
 	areq->iocb = msg->msg_iocb;
+	areq->sk = sk;
 	memcpy(areq->iv, ctx->iv, crypto_aead_ivsize(tfm));
 	aead_request_set_tfm(req, tfm);
 	aead_request_set_ad(req, ctx->aead_assoclen);
 	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  aead_async_cb, sk);
+				  aead_async_cb, req);
 	used -= ctx->aead_assoclen;
 
 	/* take over all tx sgls from ctx */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

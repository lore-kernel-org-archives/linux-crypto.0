From: Marek Vasut <marex@denx.de>
Subject: [PATCH 1/3 V4] crypto: Fix the pointer voodoo in unaligned ahash
Date: Fri, 14 Mar 2014 02:37:04 +0100
Message-ID: <1394761026-7292-1-git-send-email-marex@denx.de>
Cc: linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:48917 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbaCNBhk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Mar 2014 21:37:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add documentation for the pointer voodoo that is happening in crypto/ahash.c
in ahash_op_unaligned(). This code is quite confusing, so add a beefy chunk
of documentation.

Moreover, make sure the mangled request is completely restored after finishing
this unaligned operation. This means restoring all of .result, .base.data
and .base.complete .

Also, remove the crypto_completion_t complete = ... line present in the
ahash_op_unaligned_done() function. This type actually declares a function
pointer, which is very confusing.

Finally, yet very important nonetheless, make sure the req->priv is free()'d
only after the original request is restored in ahash_op_unaligned_done().
The req->priv data must not be free()'d before that in ahash_op_unaligned_finish(),
since we would be accessing previously free()'d data in ahash_op_unaligned_done()
and cause corruption.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
---
 crypto/ahash.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 7 deletions(-)

V2: Move the restoration of the ORIGINAL crypto request fields from
    ahash_op_unaligned_done() to ahash_op_unaligned_finish(). This way,
    we handle both Sync-HASH and Async-HASH cases properly:
     SYNC:  ahash_op_unaligned_finish() is called with err=0 . Data are
            copied from ADJUSTED request to ORIGINAL request, ORIGINAL
	    request is correctly restored and free'd.
     ASYNC: ahash_op_unaligned_finish() is called with err=-EINPROGRESS,
            returns. Later, ahash_op_unaligned_finish() is called again
	    from ahash_op_unaligned_done() callback. Data are copied
	    from ADJUSTED request to ORIGINAL request, ORIGINAL request
	    is correctly restored and free'd.
V3: Swap the names of req<->areq variables to be consistent with the rest
    of the crypto API again.
V4: Do not save (struct ahash_request).priv when adjusting the request,
    the .priv field is internal to Crypto API and the user must NOT EVER
    use it. Add a comment about this.

diff --git a/crypto/ahash.c b/crypto/ahash.c
index a92dc38..4fdb4d3 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -201,22 +201,34 @@ static void ahash_op_unaligned_finish(struct ahash_request *req, int err)
 		memcpy(priv->result, req->result,
 		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
 
+	/* Restore the original crypto request. */
+	req->result = priv->result;
+	req->base.complete = priv->complete;
+	req->base.data = priv->data;
+	req->priv = NULL;
+
+	/* Free the req->priv.priv from the ADJUSTED request. */
 	kzfree(priv);
 }
 
 static void ahash_op_unaligned_done(struct crypto_async_request *req, int err)
 {
 	struct ahash_request *areq = req->data;
-	struct ahash_request_priv *priv = areq->priv;
-	crypto_completion_t complete = priv->complete;
-	void *data = priv->data;
 
-	ahash_op_unaligned_finish(areq, err);
+	/*
+	 * Restore the original request, see ahash_op_unaligned() for what
+	 * goes where.
+	 *
+	 * The "struct ahash_request *req" here is in fact the "req.base"
+	 * from the ADJUSTED request from ahash_op_unaligned(), thus as it
+	 * is a pointer to self, it is also the ADJUSTED "req" .
+	 */
 
-	areq->base.complete = complete;
-	areq->base.data = data;
+	/* First copy areq->result into areq->priv.result */
+	ahash_op_unaligned_finish(areq, err);
 
-	complete(&areq->base, err);
+	/* Complete the ORIGINAL request. */
+	areq->base.complete(&areq->base, err);
 }
 
 static int ahash_op_unaligned(struct ahash_request *req,
@@ -234,9 +246,39 @@ static int ahash_op_unaligned(struct ahash_request *req,
 	if (!priv)
 		return -ENOMEM;
 
+	/*
+	 * WARNING: Voodoo programming below!
+	 *
+	 * The code below is obscure and hard to understand, thus explanation
+	 * is necessary. See include/crypto/hash.h and include/linux/crypto.h
+	 * to understand the layout of structures used here!
+	 *
+	 * The code here will replace portions of the ORIGINAL request with
+	 * pointers to new code and buffers so the hashing operation can store
+	 * the result in aligned buffer. We will call the modified request
+	 * an ADJUSTED request.
+	 *
+	 * The newly mangled request will look as such:
+	 *
+	 * req {
+	 *   .result        = ADJUSTED[new aligned buffer]
+	 *   .base.complete = ADJUSTED[pointer to completion function]
+	 *   .base.data     = ADJUSTED[*req (pointer to self)]
+	 *   .priv          = ADJUSTED[new priv] {
+	 *           .result   = ORIGINAL(result)
+	 *           .complete = ORIGINAL(base.complete)
+	 *           .data     = ORIGINAL(base.data)
+	 *   }
+	 */
+
 	priv->result = req->result;
 	priv->complete = req->base.complete;
 	priv->data = req->base.data;
+	/*
+	 * WARNING: We do not backup req->priv here! The req->priv
+	 *          is for internal use of the Crypto API and the
+	 *          user must _NOT_ _EVER_ depend on it's content!
+	 */
 
 	req->result = PTR_ALIGN((u8 *)priv->ubuf, alignmask + 1);
 	req->base.complete = ahash_op_unaligned_done;
-- 
1.8.5.2

From: Marek Vasut <marex@denx.de>
Subject: [PATCH 3/3 V3] crypto: Simplify the ahash_finup implementation
Date: Thu, 13 Mar 2014 02:41:25 +0100
Message-ID: <1394674885-7776-3-git-send-email-marex@denx.de>
References: <1394674885-7776-1-git-send-email-marex@denx.de>
Cc: linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:55922 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaCMBli (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Mar 2014 21:41:38 -0400
In-Reply-To: <1394674885-7776-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ahash_def_finup() can make use of the request save/restore functions,
thus make it so. This simplifies the code a little and unifies the code
paths.

Note that the same remark about free()ing the req->priv applies here, the
req->priv can only be free()'d after the original request was restored.

Finally, squash a bug in the invocation of completion in the ASYNC path.
In both ahash_def_finup_done{1,2}, the function areq->base.complete(X, err);
was called with X=areq->base.data . This is incorrect , as X=&areq->base
is the correct value. By analysis of the data structures, we see the areq is
of type 'struct ahash_request' , areq->base is of type 'struct crypto_async_request'
and areq->base.completion is of type crypto_completion_t, which is defined in
include/linux/crypto.h as:

  typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);

This is one lead that the X should be &areq->base . Next up, we can inspect
other code which calls the completion callback to give us kind-of statistical
idea of how this callback is used. We can try:

  $ git grep base\.complete\( drivers/crypto/

Finally, by inspecting ahash_request_set_callback() implementation defined
in include/crypto/hash.h , we observe that the .data entry of 'struct
crypto_async_request' is intended for arbitrary data, not for completion
argument.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
---
 crypto/ahash.c | 36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

V2: Same as with 1/3 V2, move the restoration and freeing of the private
    data right past memcpy() of the buffer.
V3: - Swap the names of req<->areq variables to be consistent with the rest
      of the crypto API again.
    - Squash another bug in areq->base.complete(X, err); invocation, see the
      commit message, which was augmented with the last paragraph.

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 7f521b4..b4fdcf7 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -347,19 +347,16 @@ static void ahash_def_finup_finish2(struct ahash_request *req, int err)
 		memcpy(priv->result, req->result,
 		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
 
-	kzfree(priv);
+	ahash_restore_req(req);
 }
 
 static void ahash_def_finup_done2(struct crypto_async_request *req, int err)
 {
 	struct ahash_request *areq = req->data;
-	struct ahash_request_priv *priv = areq->priv;
-	crypto_completion_t complete = priv->complete;
-	void *data = priv->data;
 
 	ahash_def_finup_finish2(areq, err);
 
-	complete(data, err);
+	areq->base.complete(&areq->base, err);
 }
 
 static int ahash_def_finup_finish1(struct ahash_request *req, int err)
@@ -379,38 +376,23 @@ out:
 static void ahash_def_finup_done1(struct crypto_async_request *req, int err)
 {
 	struct ahash_request *areq = req->data;
-	struct ahash_request_priv *priv = areq->priv;
-	crypto_completion_t complete = priv->complete;
-	void *data = priv->data;
 
 	err = ahash_def_finup_finish1(areq, err);
 
-	complete(data, err);
+	areq->base.complete(&areq->base, err);
 }
 
 static int ahash_def_finup(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	unsigned long alignmask = crypto_ahash_alignmask(tfm);
-	unsigned int ds = crypto_ahash_digestsize(tfm);
-	struct ahash_request_priv *priv;
-
-	priv = kmalloc(sizeof(*priv) + ahash_align_buffer_size(ds, alignmask),
-		       (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC);
-	if (!priv)
-		return -ENOMEM;
-
-	priv->result = req->result;
-	priv->complete = req->base.complete;
-	priv->data = req->base.data;
+	int err;
 
-	req->result = PTR_ALIGN((u8 *)priv->ubuf, alignmask + 1);
-	req->base.complete = ahash_def_finup_done1;
-	req->base.data = req;
-	req->priv = priv;
+	err = ahash_save_req(req, ahash_def_finup_done1);
+	if (err)
+		return err;
 
-	return ahash_def_finup_finish1(req, tfm->update(req));
+	err = tfm->update(req);
+	return ahash_def_finup_finish1(req, err);
 }
 
 static int ahash_no_export(struct ahash_request *req, void *out)
-- 
1.8.5.2

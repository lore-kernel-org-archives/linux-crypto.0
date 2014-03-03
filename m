From: Marek Vasut <marex@denx.de>
Subject: [PATCH 2/3 V2] crypto: Pull out the functions to save/restore request
Date: Mon,  3 Mar 2014 01:21:47 +0100
Message-ID: <1393806108-6374-2-git-send-email-marex@denx.de>
References: <1389720829-5963-1-git-send-email-marex@denx.de>
 <1393806108-6374-1-git-send-email-marex@denx.de>
Cc: linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:36829 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaCCAWF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Mar 2014 19:22:05 -0500
In-Reply-To: <1393806108-6374-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The functions to save original request within a newly adjusted request
and it's counterpart to restore the original request can be re-used by
more code in the crypto/ahash.c file. Pull these functions out from the
code so they're available.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
---
 crypto/ahash.c | 107 +++++++++++++++++++++++++++++++++------------------------
 1 file changed, 62 insertions(+), 45 deletions(-)

V2: Rebase on top of 1/3 V2 , no functional changes.

diff --git a/crypto/ahash.c b/crypto/ahash.c
index affebb5..4faa50e 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -191,55 +191,12 @@ static inline unsigned int ahash_align_buffer_size(unsigned len,
 	return len + (mask & ~(crypto_tfm_ctx_alignment() - 1));
 }
 
-static void ahash_op_unaligned_finish(struct ahash_request *req, int err)
-{
-	struct ahash_request_priv *priv = req->priv;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	if (!err)
-		memcpy(priv->result, req->result,
-		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
-
-	/* Restore the original crypto request. */
-	req->result = priv->result;
-	req->base.complete = priv->complete;
-	req->base.data = priv->data;
-	req->priv = priv->priv;
-
-	/* Free the req->priv.priv from the ADJUSTED request. */
-	kzfree(priv);
-}
-
-static void ahash_op_unaligned_done(struct crypto_async_request *areq, int err)
-{
-	struct ahash_request *req = areq->data;
-
-	/*
-	 * Restore the original request, see ahash_op_unaligned() for what
-	 * goes where.
-	 *
-	 * The "struct ahash_request *req" here is in fact the "req.base"
-	 * from the ADJUSTED request from ahash_op_unaligned(), thus as it
-	 * is a pointer to self, it is also the ADJUSTED "req" .
-	 */
-
-	/* First copy req->result into req->priv.result */
-	ahash_op_unaligned_finish(req, err);
-
-	/* Complete the ORIGINAL request. */
-	req->base.complete(&req->base, err);
-}
-
-static int ahash_op_unaligned(struct ahash_request *req,
-			      int (*op)(struct ahash_request *))
+static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	unsigned long alignmask = crypto_ahash_alignmask(tfm);
 	unsigned int ds = crypto_ahash_digestsize(tfm);
 	struct ahash_request_priv *priv;
-	int err;
 
 	priv = kmalloc(sizeof(*priv) + ahash_align_buffer_size(ds, alignmask),
 		       (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
@@ -279,10 +236,70 @@ static int ahash_op_unaligned(struct ahash_request *req,
 	priv->priv = req->priv;
 
 	req->result = PTR_ALIGN((u8 *)priv->ubuf, alignmask + 1);
-	req->base.complete = ahash_op_unaligned_done;
+	req->base.complete = cplt;
 	req->base.data = req;
 	req->priv = priv;
 
+	return 0;
+}
+
+static void ahash_restore_req(struct ahash_request *req)
+{
+	struct ahash_request_priv *priv = req->priv;
+
+	/* Restore the original crypto request. */
+	req->result = priv->result;
+	req->base.complete = priv->complete;
+	req->base.data = priv->data;
+	req->priv = priv->priv;
+
+	/* Free the req->priv.priv from the ADJUSTED request. */
+	kzfree(priv);
+}
+
+static void ahash_op_unaligned_finish(struct ahash_request *req, int err)
+{
+	struct ahash_request_priv *priv = req->priv;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	if (!err)
+		memcpy(priv->result, req->result,
+		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
+
+	ahash_restore_req(req);
+}
+
+static void ahash_op_unaligned_done(struct crypto_async_request *areq, int err)
+{
+	struct ahash_request *req = areq->data;
+
+	/*
+	 * Restore the original request, see ahash_op_unaligned() for what
+	 * goes where.
+	 *
+	 * The "struct ahash_request *req" here is in fact the "req.base"
+	 * from the ADJUSTED request from ahash_op_unaligned(), thus as it
+	 * is a pointer to self, it is also the ADJUSTED "req" .
+	 */
+
+	/* First copy req->result into req->priv.result */
+	ahash_op_unaligned_finish(req, err);
+
+	/* Complete the ORIGINAL request. */
+	req->base.complete(&req->base, err);
+}
+
+static int ahash_op_unaligned(struct ahash_request *req,
+			      int (*op)(struct ahash_request *))
+{
+	int err;
+
+	err = ahash_save_req(req, ahash_op_unaligned_done);
+	if (err)
+		return err;
+
 	err = op(req);
 	ahash_op_unaligned_finish(req, err);
 
-- 
1.8.5.2

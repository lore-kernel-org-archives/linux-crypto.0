From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 2/2] crypto: atmel-sha - fix race in atmel_sha_final()
Date: Mon, 8 Feb 2016 16:26:49 +0100
Message-ID: <bb132102ffbea635f08e583ca43e064924e11714.1454944687.git.cyrille.pitchen@atmel.com>
References: <cover.1454944687.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454944687.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When (!ctx->bufcnt && !(ctx->flags & SHA_FLAGS_PAD)), the former source
code used to set the SHA_FLAGS_BUSY without checking whether this flag was
already set. If so, the hardware is already processing another hash
request so the processing of the req argument of atmel_sha_final() should
be delayed by queueing this request, the same way as done for the
(ctx->bufcnt != 0) case.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 7d27f96cdf02..596e489a4ca9 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -979,37 +979,17 @@ static int atmel_sha_update(struct ahash_request *req)
 static int atmel_sha_final(struct ahash_request *req)
 {
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
-	struct atmel_sha_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
-	struct atmel_sha_dev *dd = tctx->dd;
-
-	int err = 0;
 
 	ctx->flags |= SHA_FLAGS_FINUP;
 
 	if (ctx->flags & SHA_FLAGS_ERROR)
 		return 0; /* uncompleted hash is not needed */
 
-	if (ctx->bufcnt) {
-		return atmel_sha_enqueue(req, SHA_OP_FINAL);
-	} else if (!(ctx->flags & SHA_FLAGS_PAD)) { /* add padding */
-		err = atmel_sha_hw_init(dd);
-		if (err)
-			goto err1;
-
-		dd->req = req;
-		dd->flags |= SHA_FLAGS_BUSY;
-		err = atmel_sha_final_req(dd);
-	} else {
+	if (ctx->flags & SHA_FLAGS_PAD)
 		/* copy ready hash (+ finalize hmac) */
 		return atmel_sha_finish(req);
-	}
-
-err1:
-	if (err != -EINPROGRESS)
-		/* done_task will not finish it, so do it here */
-		atmel_sha_finish_req(req, err);
 
-	return err;
+	return atmel_sha_enqueue(req, SHA_OP_FINAL);
 }
 
 static int atmel_sha_finup(struct ahash_request *req)
-- 
1.8.2.2

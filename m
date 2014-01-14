From: Marek Vasut <marex@denx.de>
Subject: [PATCH] dcp: aes: Move the AES operation type from actx to rctx
Date: Tue, 14 Jan 2014 18:31:01 +0100
Message-ID: <1389720661-5820-1-git-send-email-marex@denx.de>
Cc: linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:56396 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaANRbH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jan 2014 12:31:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move the AES operation type and mode from async crypto context to
crypto request context. This allows for recycling of the async crypto
context for different kinds of operations.

I found this problem when I used dm-crypt, which uses the same async
crypto context (actx) for both encryption and decryption requests.
Since the requests are enqueued into the processing queue, immediatelly
storing the type of operation into async crypto context (actx) caused
corruption of this information when encryption and decryption operations
followed imediatelly one after the other. When the first operation was
dequeued, the second operation was already enqueued and overwritten the
type of operation in actx, thus causing incorrect result of the first
operation.

Fix this problem by storing the type of operation into the crypto request
context.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/mxs-dcp.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index d41917c..48f12dd 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -83,13 +83,16 @@ struct dcp_async_ctx {
 	unsigned int			hot:1;
 
 	/* Crypto-specific context */
-	unsigned int			enc:1;
-	unsigned int			ecb:1;
 	struct crypto_ablkcipher	*fallback;
 	unsigned int			key_len;
 	uint8_t				key[AES_KEYSIZE_128];
 };
 
+struct dcp_aes_req_ctx {
+	unsigned int	enc:1;
+	unsigned int	ecb:1;
+};
+
 struct dcp_sha_req_ctx {
 	unsigned int	init:1;
 	unsigned int	fini:1;
@@ -190,10 +193,12 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 /*
  * Encryption (AES128)
  */
-static int mxs_dcp_run_aes(struct dcp_async_ctx *actx, int init)
+static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
+			   struct ablkcipher_request *req, int init)
 {
 	struct dcp *sdcp = global_sdcp;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
+	struct dcp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
 	int ret;
 
 	dma_addr_t key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
@@ -212,14 +217,14 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx, int init)
 	/* Payload contains the key. */
 	desc->control0 |= MXS_DCP_CONTROL0_PAYLOAD_KEY;
 
-	if (actx->enc)
+	if (rctx->enc)
 		desc->control0 |= MXS_DCP_CONTROL0_CIPHER_ENCRYPT;
 	if (init)
 		desc->control0 |= MXS_DCP_CONTROL0_CIPHER_INIT;
 
 	desc->control1 = MXS_DCP_CONTROL1_CIPHER_SELECT_AES128;
 
-	if (actx->ecb)
+	if (rctx->ecb)
 		desc->control1 |= MXS_DCP_CONTROL1_CIPHER_MODE_ECB;
 	else
 		desc->control1 |= MXS_DCP_CONTROL1_CIPHER_MODE_CBC;
@@ -247,6 +252,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 
 	struct ablkcipher_request *req = ablkcipher_request_cast(arq);
 	struct dcp_async_ctx *actx = crypto_tfm_ctx(arq->tfm);
+	struct dcp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
 
 	struct scatterlist *dst = req->dst;
 	struct scatterlist *src = req->src;
@@ -271,7 +277,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 	/* Copy the key from the temporary location. */
 	memcpy(key, actx->key, actx->key_len);
 
-	if (!actx->ecb) {
+	if (!rctx->ecb) {
 		/* Copy the CBC IV just past the key. */
 		memcpy(key + AES_KEYSIZE_128, req->info, AES_KEYSIZE_128);
 		/* CBC needs the INIT set. */
@@ -300,7 +306,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 			 * submit the buffer.
 			 */
 			if (actx->fill == out_off || sg_is_last(src)) {
-				ret = mxs_dcp_run_aes(actx, init);
+				ret = mxs_dcp_run_aes(actx, req, init);
 				if (ret)
 					return ret;
 				init = 0;
@@ -391,13 +397,14 @@ static int mxs_dcp_aes_enqueue(struct ablkcipher_request *req, int enc, int ecb)
 	struct dcp *sdcp = global_sdcp;
 	struct crypto_async_request *arq = &req->base;
 	struct dcp_async_ctx *actx = crypto_tfm_ctx(arq->tfm);
+	struct dcp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
 	int ret;
 
 	if (unlikely(actx->key_len != AES_KEYSIZE_128))
 		return mxs_dcp_block_fallback(req, enc);
 
-	actx->enc = enc;
-	actx->ecb = ecb;
+	rctx->enc = enc;
+	rctx->ecb = ecb;
 	actx->chan = DCP_CHAN_CRYPTO;
 
 	mutex_lock(&sdcp->mutex[actx->chan]);
@@ -484,7 +491,7 @@ static int mxs_dcp_aes_fallback_init(struct crypto_tfm *tfm)
 		return PTR_ERR(blk);
 
 	actx->fallback = blk;
-	tfm->crt_ablkcipher.reqsize = sizeof(struct dcp_async_ctx);
+	tfm->crt_ablkcipher.reqsize = sizeof(struct dcp_aes_req_ctx);
 	return 0;
 }
 
-- 
1.8.5.2

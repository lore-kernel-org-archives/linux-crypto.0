From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 10/12] crypto: caam - fix error path for ctx_dma mapping failure
Date: Fri, 10 Feb 2017 14:07:23 +0200
Message-ID: <1486728445-13047-11-git-send-email-horia.geanta@nxp.com>
References: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        "Cristian Stoica" <cristian.stoica@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0078.outbound.protection.outlook.com ([104.47.42.78]:25302
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753357AbdBJMIC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2017 07:08:02 -0500
In-Reply-To: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In case ctx_dma dma mapping fails, ahash_unmap_ctx() tries to
dma unmap an invalid address:
map_seq_out_ptr_ctx() / ctx_map_to_sec4_sg() -> goto unmap_ctx ->
-> ahash_unmap_ctx() -> dma unmap ctx_dma

There is also possible to reach ahash_unmap_ctx() with ctx_dma
uninitialzed or to try to unmap the same address twice.

Fix these by setting ctx_dma = 0 where needed:
-initialize ctx_dma in ahash_init()
-clear ctx_dma in case of mapping error (instead of holding
the error code returned by the dma map function)
-clear ctx_dma after each unmapping

Fixes: 32686d34f8fb6 ("crypto: caam - ensure that we clean up after an error")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 2ad83a8dc0fe..6c6c005f417b 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -148,6 +148,7 @@ static inline int map_seq_out_ptr_ctx(u32 *desc, struct device *jrdev,
 					ctx_len, DMA_FROM_DEVICE);
 	if (dma_mapping_error(jrdev, state->ctx_dma)) {
 		dev_err(jrdev, "unable to map ctx\n");
+		state->ctx_dma = 0;
 		return -ENOMEM;
 	}
 
@@ -208,6 +209,7 @@ static inline int ctx_map_to_sec4_sg(u32 *desc, struct device *jrdev,
 	state->ctx_dma = dma_map_single(jrdev, state->caam_ctx, ctx_len, flag);
 	if (dma_mapping_error(jrdev, state->ctx_dma)) {
 		dev_err(jrdev, "unable to map ctx\n");
+		state->ctx_dma = 0;
 		return -ENOMEM;
 	}
 
@@ -482,8 +484,10 @@ static inline void ahash_unmap_ctx(struct device *dev,
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 
-	if (state->ctx_dma)
+	if (state->ctx_dma) {
 		dma_unmap_single(dev, state->ctx_dma, ctx->ctx_len, flag);
+		state->ctx_dma = 0;
+	}
 	ahash_unmap(dev, edesc, req, dst_len);
 }
 
@@ -1463,6 +1467,7 @@ static int ahash_init(struct ahash_request *req)
 	state->finup = ahash_finup_first;
 	state->final = ahash_final_no_ctx;
 
+	state->ctx_dma = 0;
 	state->current_buf = 0;
 	state->buf_dma = 0;
 	state->buflen_0 = 0;
-- 
2.4.4

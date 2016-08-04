From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv3 05/11] crypto: omap-sham: fix SW fallback HMAC handling for omap2/omap3
Date: Thu, 4 Aug 2016 13:28:40 +0300
Message-ID: <1470306526-27219-6-git-send-email-t-kristo@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52951 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbcHDKaV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 06:30:21 -0400
In-Reply-To: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If software fallback is used on older hardware accelerator setup (OMAP2/
OMAP3), the first block of data must be purged from the buffer. The
first block contains the pre-generated ipad value required by the HW,
but the software fallback algorithm generates its own, causing wrong
results.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index b4f5131..f9c5fe5 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1145,9 +1145,20 @@ static int omap_sham_final_shash(struct ahash_request *req)
 {
 	struct omap_sham_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
+	int offset = 0;
+
+	/*
+	 * If we are running HMAC on limited hardware support, skip
+	 * the ipad in the beginning of the buffer if we are going for
+	 * software fallback algorithm.
+	 */
+	if (test_bit(FLAGS_HMAC, &ctx->flags) &&
+	    !test_bit(FLAGS_AUTO_XOR, &ctx->dd->flags))
+		offset = get_block_size(ctx);
 
 	return omap_sham_shash_digest(tctx->fallback, req->base.flags,
-				      ctx->buffer, ctx->bufcnt, req->result);
+				      ctx->buffer + offset,
+				      ctx->bufcnt - offset, req->result);
 }
 
 static int omap_sham_final(struct ahash_request *req)
-- 
1.9.1

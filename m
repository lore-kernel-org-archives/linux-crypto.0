From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH crypto] crypto: caam - add missing key_dma unmap
Date: Fri, 14 Mar 2014 17:48:30 +0200
Message-ID: <1394812110-14139-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:36907
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755324AbaCNPso (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Mar 2014 11:48:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

(struct caam_ctx) ctx->key_dma needs to be unmapped
when context is cleaned up.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b71f2fd749df..f44cfe065eb3 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2099,6 +2099,11 @@ static void caam_cra_exit(struct crypto_tfm *tfm)
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_givenc_dma,
 				 desc_bytes(ctx->sh_desc_givenc),
 				 DMA_TO_DEVICE);
+	if (ctx->key_dma &&
+	    !dma_mapping_error(ctx->jrdev, ctx->key_dma))
+		dma_unmap_single(ctx->jrdev, ctx->key_dma,
+				 ctx->enckeylen + ctx->split_key_pad_len,
+				 DMA_TO_DEVICE);
 
 	caam_jr_free(ctx->jrdev);
 }
-- 
1.8.3.1

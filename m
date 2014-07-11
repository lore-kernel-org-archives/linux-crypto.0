From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 03/10] crypto: caam - fix typo in dma_mapping_error
Date: Fri, 11 Jul 2014 15:34:48 +0300
Message-ID: <1405082095-30146-4-git-send-email-horia.geanta@freescale.com>
References: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:45363
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753507AbaGKMgS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2014 08:36:18 -0400
In-Reply-To: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

dma_mapping_error checks for an incorrect DMA address:
s/ctx->sh_desc_enc_dma/ctx->sh_desc_dec_dma

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 64c606d9e821..31f2e10b5102 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -786,7 +786,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc,
 					      desc_bytes(desc),
 					      DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, ctx->sh_desc_enc_dma)) {
+	if (dma_mapping_error(jrdev, ctx->sh_desc_dec_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
 		return -ENOMEM;
 	}
-- 
1.8.3.1

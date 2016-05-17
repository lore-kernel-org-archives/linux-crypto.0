From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix typos sizeof for ctx
Date: Tue, 17 May 2016 10:53:51 -0700
Message-ID: <1463507631-5789-1-git-send-email-tadeusz.struk@intel.com>
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:17606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbcEQRzZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 May 2016 13:55:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The sizeof(*ctx->dec_cd) and sizeof(*ctx->enc_cd) are equal,
but we should use the correct one for freeing memory anyway.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 1e8852a8..769148d 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -947,13 +947,13 @@ static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 	return 0;
 
 out_free_all:
-	memset(ctx->dec_cd, 0, sizeof(*ctx->enc_cd));
-	dma_free_coherent(dev, sizeof(*ctx->enc_cd),
+	memset(ctx->dec_cd, 0, sizeof(*ctx->dec_cd));
+	dma_free_coherent(dev, sizeof(*ctx->dec_cd),
 			  ctx->dec_cd, ctx->dec_cd_paddr);
 	ctx->dec_cd = NULL;
 out_free_enc:
-	memset(ctx->enc_cd, 0, sizeof(*ctx->dec_cd));
-	dma_free_coherent(dev, sizeof(*ctx->dec_cd),
+	memset(ctx->enc_cd, 0, sizeof(*ctx->enc_cd));
+	dma_free_coherent(dev, sizeof(*ctx->enc_cd),
 			  ctx->enc_cd, ctx->enc_cd_paddr);
 	ctx->enc_cd = NULL;
 	return -ENOMEM;
-- 
2.1.4

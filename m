From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 1/2] crypto: caam - fix echainiv(authenc) encrypt shared descriptor
Date: Thu, 4 Aug 2016 20:02:46 +0300
Message-ID: <1470330167-31534-2-git-send-email-horia.geanta@nxp.com>
References: <1470330167-31534-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0062.outbound.protection.outlook.com ([104.47.34.62]:17832
	"EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933859AbcHDRfT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 13:35:19 -0400
In-Reply-To: <1470330167-31534-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There are a few things missed by the conversion to the
new AEAD interface:

1 - echainiv(authenc) encrypt shared descriptor

The shared descriptor is incorrect: due to the order of operations,
at some point in time MATH3 register is being overwritten.

2 - buffer used for echainiv(authenc) encrypt shared descriptor

Encrypt and givencrypt shared descriptors (for AEAD ops) are mutually
exclusive and thus use the same buffer in context state: sh_desc_enc.

However, there's one place missed by s/sh_desc_givenc/sh_desc_enc,
leading to errors when echainiv(authenc(...)) algorithms are used:
DECO: desc idx 14: Header Error. Invalid length or parity, or
certain other problems.

While here, also fix a typo: dma_mapping_error() is checking
for validity of sh_desc_givenc_dma instead of sh_desc_enc_dma.

Cc: <stable@vger.kernel.org> # 4.3+
Fixes: 479bcc7c5b9e ("crypto: caam - Convert authenc to new AEAD interface")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ea8189f4b021..e356005a7212 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -614,7 +614,7 @@ skip_enc:
 		keys_fit_inline = true;
 
 	/* aead_givencrypt shared descriptor */
-	desc = ctx->sh_desc_givenc;
+	desc = ctx->sh_desc_enc;
 
 	/* Note: Context registers are saved. */
 	init_sh_desc_key_aead(desc, ctx, keys_fit_inline, is_rfc3686);
@@ -645,13 +645,13 @@ copy_iv:
 	append_operation(desc, ctx->class2_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
 
-	/* ivsize + cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
-
 	/* Read and write assoclen bytes */
 	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
 	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 
+	/* ivsize + cryptlen = seqoutlen - authsize */
+	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
+
 	/* Skip assoc data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
 
@@ -697,7 +697,7 @@ copy_iv:
 	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc,
 					      desc_bytes(desc),
 					      DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, ctx->sh_desc_givenc_dma)) {
+	if (dma_mapping_error(jrdev, ctx->sh_desc_enc_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
 		return -ENOMEM;
 	}
-- 
2.4.4

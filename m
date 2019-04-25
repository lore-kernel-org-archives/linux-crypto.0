Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339CEC4321A
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 14:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 516F92067C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 14:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfDYOwj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:52:39 -0400
Received: from inva021.nxp.com ([92.121.34.21]:48744 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbfDYOwj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 10:52:39 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D2CBA2003F2;
        Thu, 25 Apr 2019 16:52:36 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BC1C42003F1;
        Thu, 25 Apr 2019 16:52:36 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 83B7D2061F;
        Thu, 25 Apr 2019 16:52:36 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 3/3] crypto: caam/qi2 - generate hash keys in-place
Date:   Thu, 25 Apr 2019 17:52:23 +0300
Message-Id: <20190425145223.28603-4-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190425145223.28603-1-horia.geanta@nxp.com>
References: <20190425145223.28603-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 307244452d3d ("crypto: caam - generate hash keys in-place")
fixed ahash implementation in caam/jr driver such that user-provided key
buffer is not DMA mapped, since it's not guaranteed to be DMAable.

Apply a similar fix for caam/qi2 driver.

Cc: <stable@vger.kernel.org> # v4.20+
Fixes: 3f16f6c9d632 ("crypto: caam/qi2 - add support for ahash algorithms")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 41 +++++++++++--------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 844dd9a20486..33a4df6b81de 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3060,13 +3060,13 @@ static void split_key_sh_done(void *cbk_ctx, u32 err)
 }
 
 /* Digest hash size if it is too large */
-static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
-			   u32 *keylen, u8 *key_out, u32 digestsize)
+static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
+			   u32 digestsize)
 {
 	struct caam_request *req_ctx;
 	u32 *desc;
 	struct split_key_sh_result result;
-	dma_addr_t src_dma, dst_dma;
+	dma_addr_t key_dma;
 	struct caam_flc *flc;
 	dma_addr_t flc_dma;
 	int ret = -ENOMEM;
@@ -3083,17 +3083,10 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 	if (!flc)
 		goto err_flc;
 
-	src_dma = dma_map_single(ctx->dev, (void *)key_in, *keylen,
-				 DMA_TO_DEVICE);
-	if (dma_mapping_error(ctx->dev, src_dma)) {
-		dev_err(ctx->dev, "unable to map key input memory\n");
-		goto err_src_dma;
-	}
-	dst_dma = dma_map_single(ctx->dev, (void *)key_out, digestsize,
-				 DMA_FROM_DEVICE);
-	if (dma_mapping_error(ctx->dev, dst_dma)) {
-		dev_err(ctx->dev, "unable to map key output memory\n");
-		goto err_dst_dma;
+	key_dma = dma_map_single(ctx->dev, key, *keylen, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(ctx->dev, key_dma)) {
+		dev_err(ctx->dev, "unable to map key memory\n");
+		goto err_key_dma;
 	}
 
 	desc = flc->sh_desc;
@@ -3118,14 +3111,14 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 
 	dpaa2_fl_set_final(in_fle, true);
 	dpaa2_fl_set_format(in_fle, dpaa2_fl_single);
-	dpaa2_fl_set_addr(in_fle, src_dma);
+	dpaa2_fl_set_addr(in_fle, key_dma);
 	dpaa2_fl_set_len(in_fle, *keylen);
 	dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
-	dpaa2_fl_set_addr(out_fle, dst_dma);
+	dpaa2_fl_set_addr(out_fle, key_dma);
 	dpaa2_fl_set_len(out_fle, digestsize);
 
 	print_hex_dump_debug("key_in@" __stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, key_in, *keylen, 1);
+			     DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
 	print_hex_dump_debug("shdesc@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
@@ -3145,17 +3138,15 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 		wait_for_completion(&result.completion);
 		ret = result.err;
 		print_hex_dump_debug("digested key@" __stringify(__LINE__)": ",
-				     DUMP_PREFIX_ADDRESS, 16, 4, key_in,
+				     DUMP_PREFIX_ADDRESS, 16, 4, key,
 				     digestsize, 1);
 	}
 
 	dma_unmap_single(ctx->dev, flc_dma, sizeof(flc->flc) + desc_bytes(desc),
 			 DMA_TO_DEVICE);
 err_flc_dma:
-	dma_unmap_single(ctx->dev, dst_dma, digestsize, DMA_FROM_DEVICE);
-err_dst_dma:
-	dma_unmap_single(ctx->dev, src_dma, *keylen, DMA_TO_DEVICE);
-err_src_dma:
+	dma_unmap_single(ctx->dev, key_dma, *keylen, DMA_BIDIRECTIONAL);
+err_key_dma:
 	kfree(flc);
 err_flc:
 	kfree(req_ctx);
@@ -3177,12 +3168,10 @@ static int ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
 	dev_dbg(ctx->dev, "keylen %d blocksize %d\n", keylen, blocksize);
 
 	if (keylen > blocksize) {
-		hashed_key = kmalloc_array(digestsize, sizeof(*hashed_key),
-					   GFP_KERNEL | GFP_DMA);
+		hashed_key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
 		if (!hashed_key)
 			return -ENOMEM;
-		ret = hash_digest_key(ctx, key, &keylen, hashed_key,
-				      digestsize);
+		ret = hash_digest_key(ctx, &keylen, hashed_key, digestsize);
 		if (ret)
 			goto bad_free_key;
 		key = hashed_key;
-- 
2.17.1


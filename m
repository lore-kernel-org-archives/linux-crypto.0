Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8570AC38145
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Sep 2022 05:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiIFFFm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Sep 2022 01:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiIFFFl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2022 01:05:41 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B036825287
        for <linux-crypto@vger.kernel.org>; Mon,  5 Sep 2022 22:05:39 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oVQmF-001Pob-Mu; Tue, 06 Sep 2022 15:05:36 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Sep 2022 13:05:35 +0800
Date:   Tue, 6 Sep 2022 13:05:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Neal Liu <neal_liu@aspeedtech.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: aspeed - Fix sparse warnings
Message-ID: <YxbVH33BOJk2T+rT@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes a bunch of bit endianness warnings and two missing
static modifiers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/aspeed/aspeed-hace-crypto.c b/drivers/crypto/aspeed/aspeed-hace-crypto.c
index ba6158f5cf18..ef73b0028b4d 100644
--- a/drivers/crypto/aspeed/aspeed-hace-crypto.c
+++ b/drivers/crypto/aspeed/aspeed-hace-crypto.c
@@ -258,21 +258,20 @@ static int aspeed_sk_start_sg(struct aspeed_hace_dev *hace_dev)
 	total = req->cryptlen;
 
 	for_each_sg(req->src, s, src_sg_len, i) {
-		src_list[i].phy_addr = sg_dma_address(s);
+		u32 phy_addr = sg_dma_address(s);
+		u32 len = sg_dma_len(s);
 
-		if (total > sg_dma_len(s)) {
-			src_list[i].len = sg_dma_len(s);
-			total -= src_list[i].len;
-
-		} else {
+		if (total > len)
+			total -= len;
+		else {
 			/* last sg list */
-			src_list[i].len = total;
-			src_list[i].len |= BIT(31);
+			len = total;
+			len |= BIT(31);
 			total = 0;
 		}
 
-		src_list[i].phy_addr = cpu_to_le32(src_list[i].phy_addr);
-		src_list[i].len = cpu_to_le32(src_list[i].len);
+		src_list[i].phy_addr = cpu_to_le32(phy_addr);
+		src_list[i].len = cpu_to_le32(len);
 	}
 
 	if (total != 0) {
@@ -290,21 +289,20 @@ static int aspeed_sk_start_sg(struct aspeed_hace_dev *hace_dev)
 		total = req->cryptlen;
 
 		for_each_sg(req->dst, s, dst_sg_len, i) {
-			dst_list[i].phy_addr = sg_dma_address(s);
-
-			if (total > sg_dma_len(s)) {
-				dst_list[i].len = sg_dma_len(s);
-				total -= dst_list[i].len;
+			u32 phy_addr = sg_dma_address(s);
+			u32 len = sg_dma_len(s);
 
-			} else {
+			if (total > len)
+				total -= len;
+			else {
 				/* last sg list */
-				dst_list[i].len = total;
-				dst_list[i].len |= BIT(31);
+				len = total;
+				len |= BIT(31);
 				total = 0;
 			}
 
-			dst_list[i].phy_addr = cpu_to_le32(dst_list[i].phy_addr);
-			dst_list[i].len = cpu_to_le32(dst_list[i].len);
+			dst_list[i].phy_addr = cpu_to_le32(phy_addr);
+			dst_list[i].len = cpu_to_le32(len);
 
 		}
 
@@ -731,7 +729,7 @@ static void aspeed_crypto_cra_exit(struct crypto_skcipher *tfm)
 	crypto_free_skcipher(ctx->fallback_tfm);
 }
 
-struct aspeed_hace_alg aspeed_crypto_algs[] = {
+static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 	{
 		.alg.skcipher = {
 			.min_keysize	= AES_MIN_KEY_SIZE,
@@ -1019,7 +1017,7 @@ struct aspeed_hace_alg aspeed_crypto_algs[] = {
 	},
 };
 
-struct aspeed_hace_alg aspeed_crypto_algs_g6[] = {
+static struct aspeed_hace_alg aspeed_crypto_algs_g6[] = {
 	{
 		.alg.skcipher = {
 			.ivsize		= AES_BLOCK_SIZE,
diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index 0a44ffc0e13b..7f7f289fceb7 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -208,6 +208,9 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 	}
 
 	if (rctx->bufcnt != 0) {
+		u32 phy_addr;
+		u32 len;
+
 		rctx->buffer_dma_addr = dma_map_single(hace_dev->dev,
 						       rctx->buffer,
 						       rctx->block_size * 2,
@@ -218,36 +221,35 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 			goto free_rctx_digest;
 		}
 
-		src_list[0].phy_addr = rctx->buffer_dma_addr;
-		src_list[0].len = rctx->bufcnt;
-		length -= src_list[0].len;
+		phy_addr = rctx->buffer_dma_addr;
+		len = rctx->bufcnt;
+		length -= len;
 
 		/* Last sg list */
 		if (length == 0)
-			src_list[0].len |= HASH_SG_LAST_LIST;
+			len |= HASH_SG_LAST_LIST;
 
-		src_list[0].phy_addr = cpu_to_le32(src_list[0].phy_addr);
-		src_list[0].len = cpu_to_le32(src_list[0].len);
+		src_list[0].phy_addr = cpu_to_le32(phy_addr);
+		src_list[0].len = cpu_to_le32(len);
 		src_list++;
 	}
 
 	if (length != 0) {
 		for_each_sg(rctx->src_sg, s, sg_len, i) {
-			src_list[i].phy_addr = sg_dma_address(s);
-
-			if (length > sg_dma_len(s)) {
-				src_list[i].len = sg_dma_len(s);
-				length -= sg_dma_len(s);
+			u32 phy_addr = sg_dma_address(s);
+			u32 len = sg_dma_len(s);
 
-			} else {
+			if (length > len)
+				length -= len;
+			else {
 				/* Last sg list */
-				src_list[i].len = length;
-				src_list[i].len |= HASH_SG_LAST_LIST;
+				len = length;
+				len |= HASH_SG_LAST_LIST;
 				length = 0;
 			}
 
-			src_list[i].phy_addr = cpu_to_le32(src_list[i].phy_addr);
-			src_list[i].len = cpu_to_le32(src_list[i].len);
+			src_list[i].phy_addr = cpu_to_le32(phy_addr);
+			src_list[i].len = cpu_to_le32(len);
 		}
 	}
 
@@ -913,7 +915,7 @@ static int aspeed_sham_import(struct ahash_request *req, const void *in)
 	return 0;
 }
 
-struct aspeed_hace_alg aspeed_ahash_algs[] = {
+static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 	{
 		.alg.ahash = {
 			.init	= aspeed_sham_init,
@@ -1099,7 +1101,7 @@ struct aspeed_hace_alg aspeed_ahash_algs[] = {
 	},
 };
 
-struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
+static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 	{
 		.alg.ahash = {
 			.init	= aspeed_sham_init,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

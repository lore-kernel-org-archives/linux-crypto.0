Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814A6C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 13:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61C5E22B43
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 13:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgGaN4Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jul 2020 09:56:25 -0400
Received: from [216.24.177.18] ([216.24.177.18]:40674 "EHLO fornost.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1730733AbgGaN4Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jul 2020 09:56:25 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k1VVc-0001sw-Gl; Fri, 31 Jul 2020 23:55:41 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Jul 2020 23:55:40 +1000
Date:   Fri, 31 Jul 2020 23:55:40 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: marvell/cesa - Fix sparse warnings
Message-ID: <20200731135540.GA15634@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes most sparse warnings in the cesa driver.  The only
ones remaining are to do with copying data between iomem pointers and
SG lists.

Most changes are trivial.  The following are the noteworthy ones:

- Removal of swab in mv_cesa_aes_setkey.  This appears to be bogus
as everything gets swabbed again later on so for BE this ends up
being different from LE.  The change takes the LE behaviour as the
correct one.

- next_dma in mv_cesa_tdma_chain was not swabbed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
index 0c9cbb681e49..09cc17e330fb 100644
--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -239,7 +239,7 @@ struct mv_cesa_sec_accel_desc {
  * Context associated to a cipher operation.
  */
 struct mv_cesa_skcipher_op_ctx {
-	u32 key[8];
+	__le32 key[8];
 	u32 iv[4];
 };
 
@@ -252,7 +252,7 @@ struct mv_cesa_skcipher_op_ctx {
  */
 struct mv_cesa_hash_op_ctx {
 	u32 iv[16];
-	u32 hash[8];
+	__le32 hash[8];
 };
 
 /**
@@ -300,8 +300,14 @@ struct mv_cesa_op_ctx {
  */
 struct mv_cesa_tdma_desc {
 	__le32 byte_cnt;
-	__le32 src;
-	__le32 dst;
+	union {
+		__le32 src;
+		dma_addr_t src_dma;
+	};
+	union {
+		__le32 dst;
+		dma_addr_t dst_dma;
+	};
 	__le32 next_dma;
 
 	/* Software state */
@@ -506,7 +512,7 @@ struct mv_cesa_hash_ctx {
  */
 struct mv_cesa_hmac_ctx {
 	struct mv_cesa_ctx base;
-	u32 iv[16];
+	__be32 iv[16];
 };
 
 /**
diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 45b4d7a29833..6ddf73c1c68c 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -262,8 +262,7 @@ static int mv_cesa_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	remaining = (ctx->aes.key_length - 16) / 4;
 	offset = ctx->aes.key_length + 24 - remaining;
 	for (i = 0; i < remaining; i++)
-		ctx->aes.key_dec[4 + i] =
-			cpu_to_le32(ctx->aes.key_enc[offset + i]);
+		ctx->aes.key_dec[4 + i] = ctx->aes.key_enc[offset + i];
 
 	return 0;
 }
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index bd0bd9ffd6e9..da05f445746b 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -222,9 +222,11 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 					      CESA_SA_DATA_SRAM_OFFSET + len,
 					      new_cache_ptr);
 			} else {
-				len += mv_cesa_ahash_pad_req(creq,
-						engine->sram + len +
-						CESA_SA_DATA_SRAM_OFFSET);
+				i = mv_cesa_ahash_pad_req(creq, creq->cache);
+				len += i;
+				memcpy_toio(engine->sram + len +
+					    CESA_SA_DATA_SRAM_OFFSET,
+					    creq->cache, i);
 			}
 
 			if (frag_mode == CESA_SA_DESC_CFG_LAST_FRAG)
@@ -342,7 +344,7 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 		 */
 		data = creq->base.chain.last->op->ctx.hash.hash;
 		for (i = 0; i < digsize / 4; i++)
-			creq->state[i] = cpu_to_le32(data[i]);
+			creq->state[i] = le32_to_cpu(data[i]);
 
 		memcpy(ahashreq->result, data, digsize);
 	} else {
@@ -1265,10 +1267,10 @@ static int mv_cesa_ahmac_md5_setkey(struct crypto_ahash *tfm, const u8 *key,
 		return ret;
 
 	for (i = 0; i < ARRAY_SIZE(istate.hash); i++)
-		ctx->iv[i] = be32_to_cpu(istate.hash[i]);
+		ctx->iv[i] = cpu_to_be32(istate.hash[i]);
 
 	for (i = 0; i < ARRAY_SIZE(ostate.hash); i++)
-		ctx->iv[i + 8] = be32_to_cpu(ostate.hash[i]);
+		ctx->iv[i + 8] = cpu_to_be32(ostate.hash[i]);
 
 	return 0;
 }
@@ -1336,10 +1338,10 @@ static int mv_cesa_ahmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
 		return ret;
 
 	for (i = 0; i < ARRAY_SIZE(istate.state); i++)
-		ctx->iv[i] = be32_to_cpu(istate.state[i]);
+		ctx->iv[i] = cpu_to_be32(istate.state[i]);
 
 	for (i = 0; i < ARRAY_SIZE(ostate.state); i++)
-		ctx->iv[i + 8] = be32_to_cpu(ostate.state[i]);
+		ctx->iv[i + 8] = cpu_to_be32(ostate.state[i]);
 
 	return 0;
 }
@@ -1394,10 +1396,10 @@ static int mv_cesa_ahmac_sha256_setkey(struct crypto_ahash *tfm, const u8 *key,
 		return ret;
 
 	for (i = 0; i < ARRAY_SIZE(istate.state); i++)
-		ctx->iv[i] = be32_to_cpu(istate.state[i]);
+		ctx->iv[i] = cpu_to_be32(istate.state[i]);
 
 	for (i = 0; i < ARRAY_SIZE(ostate.state); i++)
-		ctx->iv[i + 8] = be32_to_cpu(ostate.state[i]);
+		ctx->iv[i + 8] = cpu_to_be32(ostate.state[i]);
 
 	return 0;
 }
diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
index b81ee276fe0e..5d9c48fb72b2 100644
--- a/drivers/crypto/marvell/cesa/tdma.c
+++ b/drivers/crypto/marvell/cesa/tdma.c
@@ -83,10 +83,10 @@ void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
 
 	for (tdma = dreq->chain.first; tdma; tdma = tdma->next) {
 		if (tdma->flags & CESA_TDMA_DST_IN_SRAM)
-			tdma->dst = cpu_to_le32(tdma->dst + engine->sram_dma);
+			tdma->dst = cpu_to_le32(tdma->dst_dma + engine->sram_dma);
 
 		if (tdma->flags & CESA_TDMA_SRC_IN_SRAM)
-			tdma->src = cpu_to_le32(tdma->src + engine->sram_dma);
+			tdma->src = cpu_to_le32(tdma->src_dma + engine->sram_dma);
 
 		if ((tdma->flags & CESA_TDMA_TYPE_MSK) == CESA_TDMA_OP)
 			mv_cesa_adjust_op(engine, tdma->op);
@@ -114,7 +114,7 @@ void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
 		 */
 		if (!(last->flags & CESA_TDMA_BREAK_CHAIN) &&
 		    !(dreq->chain.first->flags & CESA_TDMA_SET_STATE))
-			last->next_dma = dreq->chain.first->cur_dma;
+			last->next_dma = cpu_to_le32(dreq->chain.first->cur_dma);
 	}
 }
 
@@ -237,8 +237,8 @@ int mv_cesa_dma_add_result_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
 		return -EIO;
 
 	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
-	tdma->src = src;
-	tdma->dst = op_desc->src;
+	tdma->src_dma = src;
+	tdma->dst_dma = op_desc->src_dma;
 	tdma->op = op_desc->op;
 
 	flags &= (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
@@ -272,7 +272,7 @@ struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
 	tdma->op = op;
 	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
 	tdma->src = cpu_to_le32(dma_handle);
-	tdma->dst = CESA_SA_CFG_SRAM_OFFSET;
+	tdma->dst_dma = CESA_SA_CFG_SRAM_OFFSET;
 	tdma->flags = CESA_TDMA_DST_IN_SRAM | CESA_TDMA_OP;
 
 	return op;
@@ -289,8 +289,8 @@ int mv_cesa_dma_add_data_transfer(struct mv_cesa_tdma_chain *chain,
 		return PTR_ERR(tdma);
 
 	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
-	tdma->src = src;
-	tdma->dst = dst;
+	tdma->src_dma = src;
+	tdma->dst_dma = dst;
 
 	flags &= (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
 	tdma->flags = flags | CESA_TDMA_DATA;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

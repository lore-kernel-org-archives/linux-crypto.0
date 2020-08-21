Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194D5C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 07:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F114D20738
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 07:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHUHwJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 03:52:09 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49888 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgHUHwI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 03:52:08 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k91qG-0003rR-EA; Fri, 21 Aug 2020 17:52:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Aug 2020 17:52:04 +1000
Date:   Fri, 21 Aug 2020 17:52:04 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ryder Lee <ryder.lee@mediatek.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: mediatek - Fix endianness bugs and sparse warnings
Message-ID: <20200821075204.GA20426@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch squashes all the sparse warnings in mediatek, some of
which appear to be genuine bugs.  In particular, previously on
BE the keys and IVs all get 32-bit swabbed which can't be right
because they don't get swabbed on LE.  I presume LE is the one
that actually works.

Another funky thing is that the GHASH key gets swabbed on LE.
This makes no sense but I'm presuming someone actually tested
this on LE so I'm preserving the swabbing.  Someone needs to
test this though as it is entirely possible that GCM is the
only thing that worked on BE but not LE.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 4ad3571ab6af..7323066724c3 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -126,7 +126,7 @@ struct mtk_aes_ctx {
 struct mtk_aes_ctr_ctx {
 	struct mtk_aes_base_ctx base;
 
-	u32	iv[AES_BLOCK_SIZE / sizeof(u32)];
+	__be32	iv[AES_BLOCK_SIZE / sizeof(u32)];
 	size_t offset;
 	struct scatterlist src[2];
 	struct scatterlist dst[2];
@@ -242,22 +242,6 @@ static inline void mtk_aes_restore_sg(const struct mtk_aes_dma *dma)
 	sg->length += dma->remainder;
 }
 
-static inline void mtk_aes_write_state_le(__le32 *dst, const u32 *src, u32 size)
-{
-	int i;
-
-	for (i = 0; i < SIZE_IN_WORDS(size); i++)
-		dst[i] = cpu_to_le32(src[i]);
-}
-
-static inline void mtk_aes_write_state_be(__be32 *dst, const u32 *src, u32 size)
-{
-	int i;
-
-	for (i = 0; i < SIZE_IN_WORDS(size); i++)
-		dst[i] = cpu_to_be32(src[i]);
-}
-
 static inline int mtk_aes_complete(struct mtk_cryp *cryp,
 				   struct mtk_aes_rec *aes,
 				   int err)
@@ -321,7 +305,7 @@ static int mtk_aes_xmit(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 
 	/* Prepare enough space for authenticated tag */
 	if (aes->flags & AES_FLAGS_GCM)
-		res->hdr += AES_BLOCK_SIZE;
+		le32_add_cpu(&res->hdr, AES_BLOCK_SIZE);
 
 	/*
 	 * Make sure that all changes to the DMA ring are done before we
@@ -449,10 +433,10 @@ static void mtk_aes_info_init(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
 		return;
 	}
 
-	mtk_aes_write_state_le(info->state + ctx->keylen, (void *)req->iv,
-			       AES_BLOCK_SIZE);
+	memcpy(info->state + ctx->keylen, req->iv, AES_BLOCK_SIZE);
 ctr:
-	info->tfm[0] += AES_TFM_SIZE(SIZE_IN_WORDS(AES_BLOCK_SIZE));
+	le32_add_cpu(&info->tfm[0],
+		     le32_to_cpu(AES_TFM_SIZE(SIZE_IN_WORDS(AES_BLOCK_SIZE))));
 	info->tfm[1] |= AES_TFM_FULL_IV;
 	info->cmd[cnt++] = AES_CMD2;
 ecb:
@@ -601,8 +585,7 @@ static int mtk_aes_ctr_transfer(struct mtk_cryp *cryp, struct mtk_aes_rec *aes)
 	       scatterwalk_ffwd(cctx->dst, req->dst, cctx->offset));
 
 	/* Write IVs into transform state buffer. */
-	mtk_aes_write_state_le(ctx->info.state + ctx->keylen, cctx->iv,
-			       AES_BLOCK_SIZE);
+	memcpy(ctx->info.state + ctx->keylen, cctx->iv, AES_BLOCK_SIZE);
 
 	if (unlikely(fragmented)) {
 	/*
@@ -654,7 +637,7 @@ static int mtk_aes_setkey(struct crypto_skcipher *tfm,
 	}
 
 	ctx->keylen = SIZE_IN_WORDS(keylen);
-	mtk_aes_write_state_le(ctx->key, (const u32 *)key, keylen);
+	memcpy(ctx->key, key, keylen);
 
 	return 0;
 }
@@ -848,7 +831,7 @@ mtk_aes_gcm_ctx_cast(struct mtk_aes_base_ctx *ctx)
 static int mtk_aes_gcm_tag_verify(struct mtk_cryp *cryp,
 				  struct mtk_aes_rec *aes)
 {
-	u32 status = cryp->ring[aes->id]->res_prev->ct;
+	__le32 status = cryp->ring[aes->id]->res_prev->ct;
 
 	return mtk_aes_complete(cryp, aes, (status & AES_AUTH_TAG_ERR) ?
 				-EBADMSG : 0);
@@ -866,7 +849,7 @@ static void mtk_aes_gcm_info_init(struct mtk_cryp *cryp,
 	u32 ivsize = crypto_aead_ivsize(crypto_aead_reqtfm(req));
 	u32 cnt = 0;
 
-	ctx->ct_hdr = AES_CT_CTRL_HDR | len;
+	ctx->ct_hdr = AES_CT_CTRL_HDR | cpu_to_le32(len);
 
 	info->cmd[cnt++] = AES_GCM_CMD0 | cpu_to_le32(req->assoclen);
 	info->cmd[cnt++] = AES_GCM_CMD1 | cpu_to_le32(req->assoclen);
@@ -889,8 +872,8 @@ static void mtk_aes_gcm_info_init(struct mtk_cryp *cryp,
 	info->tfm[1] = AES_TFM_CTR_INIT | AES_TFM_IV_CTR_MODE | AES_TFM_3IV |
 		       AES_TFM_ENC_HASH;
 
-	mtk_aes_write_state_le(info->state + ctx->keylen + SIZE_IN_WORDS(
-			       AES_BLOCK_SIZE), (const u32 *)req->iv, ivsize);
+	memcpy(info->state + ctx->keylen + SIZE_IN_WORDS(AES_BLOCK_SIZE),
+	       req->iv, ivsize);
 }
 
 static int mtk_aes_gcm_dma(struct mtk_cryp *cryp, struct mtk_aes_rec *aes,
@@ -994,9 +977,13 @@ static int mtk_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 			      u32 keylen)
 {
 	struct mtk_aes_base_ctx *ctx = crypto_aead_ctx(aead);
-	u8 hash[AES_BLOCK_SIZE] __aligned(4) = {};
+	union {
+		u32 x32[SIZE_IN_WORDS(AES_BLOCK_SIZE)];
+		u8 x8[AES_BLOCK_SIZE];
+	} hash = {};
 	struct crypto_aes_ctx aes_ctx;
 	int err;
+	int i;
 
 	switch (keylen) {
 	case AES_KEYSIZE_128:
@@ -1019,12 +1006,16 @@ static int mtk_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	if (err)
 		return err;
 
-	aes_encrypt(&aes_ctx, hash, hash);
+	aes_encrypt(&aes_ctx, hash.x8, hash.x8);
 	memzero_explicit(&aes_ctx, sizeof(aes_ctx));
 
-	mtk_aes_write_state_le(ctx->key, (const u32 *)key, keylen);
-	mtk_aes_write_state_be(ctx->key + ctx->keylen, (const u32 *)hash,
-			       AES_BLOCK_SIZE);
+	memcpy(ctx->key, key, keylen);
+
+	/* Why do we need to do this? */
+	for (i = 0; i < SIZE_IN_WORDS(AES_BLOCK_SIZE); i++)
+		hash.x32[i] = swab32(hash.x32[i]);
+
+	memcpy(ctx->key + ctx->keylen, &hash, AES_BLOCK_SIZE);
 
 	return 0;
 }
diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index da3f0b8814aa..3d5d7d68b03b 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -239,7 +239,7 @@ static int mtk_sha_append_sg(struct mtk_sha_reqctx *ctx)
 static void mtk_sha_fill_padding(struct mtk_sha_reqctx *ctx, u32 len)
 {
 	u32 index, padlen;
-	u64 bits[2];
+	__be64 bits[2];
 	u64 size = ctx->digcnt;
 
 	size += ctx->bufcnt;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A9DC433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1C6B20FC3
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgHUN7S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 09:59:18 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50482 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgHUN7R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 09:59:17 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k97ZY-0002R3-3v; Fri, 21 Aug 2020 23:59:13 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Aug 2020 23:59:12 +1000
Date:   Fri, 21 Aug 2020 23:59:12 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        Lionel Debieve <lionel.debieve@st.com>,
        Etienne Carriere <etienne.carriere@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: stm32 - Fix sparse warnings
Message-ID: <20200821135911.GA20179@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes most of the sparse endianness warnings in stm32.
The patch itself doesn't change anything apart from markings,
but there is some questionable code in stm32_cryp_check_ctr_counter.

That function operates on the counters as if they're in CPU order,
however, they're then written out as big-endian.  This looks like
a genuine bug.  Therefore I've left that warning alone until
someone can confirm that this really does work as intended on
little-endian.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 3ba41148c2a4..8acbe1d45fe6 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -216,9 +216,8 @@ static int stm32_crc_update(struct shash_desc *desc, const u8 *d8,
 		return burst_update(desc, d8, length);
 
 	/* Digest first bytes not 32bit aligned at first pass in the loop */
-	size = min(length,
-		   burst_sz + (unsigned int)d8 - ALIGN_DOWN((unsigned int)d8,
-							    sizeof(u32)));
+	size = min_t(size_t, length, burst_sz + (size_t)d8 -
+				     ALIGN_DOWN((size_t)d8, sizeof(u32)));
 	for (rem_sz = length, cur = d8; rem_sz;
 	     rem_sz -= size, cur += size, size = min(rem_sz, burst_sz)) {
 		ret = burst_update(desc, cur, size);
diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index d347a1d6e351..2670c30332fa 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -118,7 +118,7 @@ struct stm32_cryp_ctx {
 	struct crypto_engine_ctx enginectx;
 	struct stm32_cryp       *cryp;
 	int                     keylen;
-	u32                     key[AES_KEYSIZE_256 / sizeof(u32)];
+	__be32                  key[AES_KEYSIZE_256 / sizeof(u32)];
 	unsigned long           flags;
 };
 
@@ -380,24 +380,24 @@ static int stm32_cryp_copy_sgs(struct stm32_cryp *cryp)
 	return 0;
 }
 
-static void stm32_cryp_hw_write_iv(struct stm32_cryp *cryp, u32 *iv)
+static void stm32_cryp_hw_write_iv(struct stm32_cryp *cryp, __be32 *iv)
 {
 	if (!iv)
 		return;
 
-	stm32_cryp_write(cryp, CRYP_IV0LR, cpu_to_be32(*iv++));
-	stm32_cryp_write(cryp, CRYP_IV0RR, cpu_to_be32(*iv++));
+	stm32_cryp_write(cryp, CRYP_IV0LR, be32_to_cpu(*iv++));
+	stm32_cryp_write(cryp, CRYP_IV0RR, be32_to_cpu(*iv++));
 
 	if (is_aes(cryp)) {
-		stm32_cryp_write(cryp, CRYP_IV1LR, cpu_to_be32(*iv++));
-		stm32_cryp_write(cryp, CRYP_IV1RR, cpu_to_be32(*iv++));
+		stm32_cryp_write(cryp, CRYP_IV1LR, be32_to_cpu(*iv++));
+		stm32_cryp_write(cryp, CRYP_IV1RR, be32_to_cpu(*iv++));
 	}
 }
 
 static void stm32_cryp_get_iv(struct stm32_cryp *cryp)
 {
 	struct skcipher_request *req = cryp->req;
-	u32 *tmp = (void *)req->iv;
+	__be32 *tmp = (void *)req->iv;
 
 	if (!tmp)
 		return;
@@ -417,13 +417,13 @@ static void stm32_cryp_hw_write_key(struct stm32_cryp *c)
 	int r_id;
 
 	if (is_des(c)) {
-		stm32_cryp_write(c, CRYP_K1LR, cpu_to_be32(c->ctx->key[0]));
-		stm32_cryp_write(c, CRYP_K1RR, cpu_to_be32(c->ctx->key[1]));
+		stm32_cryp_write(c, CRYP_K1LR, be32_to_cpu(c->ctx->key[0]));
+		stm32_cryp_write(c, CRYP_K1RR, be32_to_cpu(c->ctx->key[1]));
 	} else {
 		r_id = CRYP_K3RR;
 		for (i = c->ctx->keylen / sizeof(u32); i > 0; i--, r_id -= 4)
 			stm32_cryp_write(c, r_id,
-					 cpu_to_be32(c->ctx->key[i - 1]));
+					 be32_to_cpu(c->ctx->key[i - 1]));
 	}
 }
 
@@ -469,7 +469,7 @@ static unsigned int stm32_cryp_get_input_text_len(struct stm32_cryp *cryp)
 static int stm32_cryp_gcm_init(struct stm32_cryp *cryp, u32 cfg)
 {
 	int ret;
-	u32 iv[4];
+	__be32 iv[4];
 
 	/* Phase 1 : init */
 	memcpy(iv, cryp->areq->iv, 12);
@@ -491,6 +491,7 @@ static int stm32_cryp_ccm_init(struct stm32_cryp *cryp, u32 cfg)
 {
 	int ret;
 	u8 iv[AES_BLOCK_SIZE], b0[AES_BLOCK_SIZE];
+	__be32 *bd;
 	u32 *d;
 	unsigned int i, textlen;
 
@@ -498,7 +499,7 @@ static int stm32_cryp_ccm_init(struct stm32_cryp *cryp, u32 cfg)
 	memcpy(iv, cryp->areq->iv, AES_BLOCK_SIZE);
 	memset(iv + AES_BLOCK_SIZE - 1 - iv[0], 0, iv[0] + 1);
 	iv[AES_BLOCK_SIZE - 1] = 1;
-	stm32_cryp_hw_write_iv(cryp, (u32 *)iv);
+	stm32_cryp_hw_write_iv(cryp, (__be32 *)iv);
 
 	/* Build B0 */
 	memcpy(b0, iv, AES_BLOCK_SIZE);
@@ -518,11 +519,14 @@ static int stm32_cryp_ccm_init(struct stm32_cryp *cryp, u32 cfg)
 
 	/* Write B0 */
 	d = (u32 *)b0;
+	bd = (__be32 *)b0;
 
 	for (i = 0; i < AES_BLOCK_32; i++) {
+		u32 xd = d[i];
+
 		if (!cryp->caps->padding_wa)
-			*d = cpu_to_be32(*d);
-		stm32_cryp_write(cryp, CRYP_DIN, *d++);
+			xd = be32_to_cpu(bd[i]);
+		stm32_cryp_write(cryp, CRYP_DIN, xd);
 	}
 
 	/* Wait for end of processing */
@@ -617,7 +621,7 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
 	case CR_TDES_CBC:
 	case CR_AES_CBC:
 	case CR_AES_CTR:
-		stm32_cryp_hw_write_iv(cryp, (u32 *)cryp->req->iv);
+		stm32_cryp_hw_write_iv(cryp, (__be32 *)cryp->req->iv);
 		break;
 
 	default:
@@ -1120,7 +1124,7 @@ static int stm32_cryp_read_auth_tag(struct stm32_cryp *cryp)
 		/* GCM: write aad and payload size (in bits) */
 		size_bit = cryp->areq->assoclen * 8;
 		if (cryp->caps->swap_final)
-			size_bit = cpu_to_be32(size_bit);
+			size_bit = (__force u32)cpu_to_be32(size_bit);
 
 		stm32_cryp_write(cryp, CRYP_DIN, 0);
 		stm32_cryp_write(cryp, CRYP_DIN, size_bit);
@@ -1129,7 +1133,7 @@ static int stm32_cryp_read_auth_tag(struct stm32_cryp *cryp)
 				cryp->areq->cryptlen - AES_BLOCK_SIZE;
 		size_bit *= 8;
 		if (cryp->caps->swap_final)
-			size_bit = cpu_to_be32(size_bit);
+			size_bit = (__force u32)cpu_to_be32(size_bit);
 
 		stm32_cryp_write(cryp, CRYP_DIN, 0);
 		stm32_cryp_write(cryp, CRYP_DIN, size_bit);
@@ -1137,14 +1141,19 @@ static int stm32_cryp_read_auth_tag(struct stm32_cryp *cryp)
 		/* CCM: write CTR0 */
 		u8 iv[AES_BLOCK_SIZE];
 		u32 *iv32 = (u32 *)iv;
+		__be32 *biv;
+
+		biv = (void *)iv;
 
 		memcpy(iv, cryp->areq->iv, AES_BLOCK_SIZE);
 		memset(iv + AES_BLOCK_SIZE - 1 - iv[0], 0, iv[0] + 1);
 
 		for (i = 0; i < AES_BLOCK_32; i++) {
+			u32 xiv = iv32[i];
+
 			if (!cryp->caps->padding_wa)
-				*iv32 = cpu_to_be32(*iv32);
-			stm32_cryp_write(cryp, CRYP_DIN, *iv32++);
+				xiv = be32_to_cpu(biv[i]);
+			stm32_cryp_write(cryp, CRYP_DIN, xiv);
 		}
 	}
 
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 03c5e6683805..9fe4ba234006 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -748,7 +748,7 @@ static int stm32_hash_final_req(struct stm32_hash_dev *hdev)
 static void stm32_hash_copy_hash(struct ahash_request *req)
 {
 	struct stm32_hash_request_ctx *rctx = ahash_request_ctx(req);
-	u32 *hash = (u32 *)rctx->digest;
+	__be32 *hash = (void *)rctx->digest;
 	unsigned int i, hashsize;
 
 	switch (rctx->flags & HASH_FLAGS_ALGO_MASK) {
@@ -769,7 +769,7 @@ static void stm32_hash_copy_hash(struct ahash_request *req)
 	}
 
 	for (i = 0; i < hashsize / sizeof(u32); i++)
-		hash[i] = be32_to_cpu(stm32_hash_read(rctx->hdev,
+		hash[i] = cpu_to_be32(stm32_hash_read(rctx->hdev,
 						      HASH_HREG(i)));
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

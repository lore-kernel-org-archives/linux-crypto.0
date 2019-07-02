Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B898CC06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EF5E2082F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eYcbXWuq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfGBPmj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:42:39 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46256 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfGBPmi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 11:42:38 -0400
Received: by mail-ed1-f66.google.com with SMTP id d4so448777edr.13
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 08:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dhq8K4eUgPlvl/TVT6QaFUvN3I1NAdeY754g1eOfiTU=;
        b=eYcbXWuqtkxi+TCjWHK4iymP8LlRqXBIaUEVPDxkN8Ck5GFOFnGfC+Cpd3NxKQuesT
         3dmX4pMJHyliovHLgLpgAOGFKrOKWgdEr4/qp5a5kO2GDTRgL3kAYOhzj+SF92mlzmJu
         63CeuH3IukCMxmvDrlGGknBiM9eG1Cd7aLiTqyIPPvxwAYX20dlBcGAkuzSH5IZDO+Jh
         1+Nn3Lml+7rL0Qy5F9HdPyTX+Z7LF9q5Tw84ekcF43dULgp2Xt3YHide12rGja+AhKcz
         L0KJLH65T0DdNBVrlEyM+Jdo/Pv8YCvHWoU7+oMQGIVBM8eCmOGtGqWJRqCikiad0+Uj
         cn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Dhq8K4eUgPlvl/TVT6QaFUvN3I1NAdeY754g1eOfiTU=;
        b=RhBePtJhcXxA9+MtRkfWXyCyXo10tZD4XdLPAN/t234liXplRfy0xNQbiJQqxCxZ9X
         32V7HSIM+OUY+z8a52Nv+TMqI27SLfs9Bj3JmPrVc3Uqm9MTDpi6p9VJe4PM7sbMbTYZ
         Dk8Zuzys0Deo1AMmMQleC+aFmyHNEpuar4O5eR/dlnDEnln5XiT2TmQOzU8G2fe/qMRj
         8GmOluf7q96a4NagAGgmi06/SBvM7UKqcWsDRAx3ontEERGfogRP6mjlUVw2Re8gYp4m
         tiVmq7WsoPlJ/WviZgnxJQc3aVWyGEpFQRDSvd+HdGKY1gLUHGFnCt9mQFy0Onbe/bva
         SztQ==
X-Gm-Message-State: APjAAAV5bAwlLq9EnAdzqpBbuFNuAb6d+XcJls7IlcD42ltilA6YbtqA
        1o4ifN5eYId2xlcrINqBZatjFuUB
X-Google-Smtp-Source: APXvYqx7zUcPEbKg1c2geK81D+3fDacdamnuOw2toCS1vD+5TH0+4nIg3ARcD1svBzlw+qlGTrvBfQ==
X-Received: by 2002:a17:906:ad86:: with SMTP id la6mr29217769ejb.43.1562082156348;
        Tue, 02 Jul 2019 08:42:36 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id j11sm2341704ejr.69.2019.07.02.08.42.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:42:35 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 4/9] crypto: inside-secure - fix scatter/gather list to descriptor conversion
Date:   Tue,  2 Jul 2019 16:39:55 +0200
Message-Id: <1562078400-969-7-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

Fixed issues with the skcipher and AEAD scatter/gather list to engine
descriptor conversion code which caused either too much or too little
buffer space to be provided to the hardware. This caused errors with the
testmgr extra tests, either kernel panics (on x86-EIP197-FPGA) or engine
descriptor errors 0x1, 0x8 or 0x9 (on Macchiatobin e.g. Marvell A8K).
With this patch in place, all skcipher and AEAD (extra) tests pass.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 182 ++++++++++++++++++-------
 1 file changed, 136 insertions(+), 46 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 9aebc0a..c839514 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -54,6 +54,7 @@ struct safexcel_cipher_req {
 	/* Number of result descriptors associated to the request */
 	unsigned int rdescs;
 	bool needs_inv;
+	int  nr_src, nr_dst;
 };
 
 static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
@@ -358,10 +359,10 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 	safexcel_complete(priv, ring);
 
 	if (src == dst) {
-		dma_unmap_sg(priv->dev, src, sg_nents(src), DMA_BIDIRECTIONAL);
+		dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(priv->dev, src, sg_nents(src), DMA_TO_DEVICE);
-		dma_unmap_sg(priv->dev, dst, sg_nents(dst), DMA_FROM_DEVICE);
+		dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
+		dma_unmap_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
 	}
 
 	/*
@@ -370,7 +371,7 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 	if ((!ctx->aead) && (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) &&
 	    (sreq->direction == SAFEXCEL_ENCRYPT)) {
 		/* For encrypt take the last output word */
-		sg_pcopy_to_buffer(dst, sg_nents(dst), areq->iv,
+		sg_pcopy_to_buffer(dst, sreq->nr_dst, areq->iv,
 				   crypto_skcipher_ivsize(skcipher),
 				   (cryptlen -
 				    crypto_skcipher_ivsize(skcipher)));
@@ -393,63 +394,99 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct safexcel_command_desc *cdesc;
+	struct safexcel_command_desc *first_cdesc = NULL;
 	struct safexcel_result_desc *rdesc, *first_rdesc = NULL;
 	struct scatterlist *sg;
-	unsigned int totlen = cryptlen + assoclen;
-	int nr_src, nr_dst, n_cdesc = 0, n_rdesc = 0, queued = totlen;
-	int i, ret = 0;
+	unsigned int totlen;
+	unsigned int totlen_src = cryptlen + assoclen;
+	unsigned int totlen_dst = totlen_src;
+	int n_cdesc = 0, n_rdesc = 0;
+	int queued, i, ret = 0;
+	bool first = true;
 
-	if ((!ctx->aead) && (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) &&
-	    (sreq->direction == SAFEXCEL_DECRYPT)) {
+	sreq->nr_src = sg_nents_for_len(src, totlen_src);
+
+	if (ctx->aead) {
+		/*
+		 * AEAD has auth tag appended to output for encrypt and
+		 * removed from the output for decrypt!
+		 */
+		if (sreq->direction == SAFEXCEL_DECRYPT)
+			totlen_dst -= digestsize;
+		else
+			totlen_dst += digestsize;
+
+		memcpy(ctx->base.ctxr->data + ctx->key_len / sizeof(u32),
+		       ctx->ipad, ctx->state_sz);
+		memcpy(ctx->base.ctxr->data + (ctx->key_len + ctx->state_sz) /
+		       sizeof(u32),
+		       ctx->opad, ctx->state_sz);
+	} else if ((ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) &&
+		   (sreq->direction == SAFEXCEL_DECRYPT)) {
 		/*
 		 * Save IV from last crypto input word for CBC modes in decrypt
 		 * direction. Need to do this first in case of inplace operation
 		 * as it will be overwritten.
 		 */
-		sg_pcopy_to_buffer(src, sg_nents(src), areq->iv,
+		sg_pcopy_to_buffer(src, sreq->nr_src, areq->iv,
 				   crypto_skcipher_ivsize(skcipher),
-				   (totlen -
+				   (totlen_src -
 				    crypto_skcipher_ivsize(skcipher)));
 	}
 
+	sreq->nr_dst = sg_nents_for_len(dst, totlen_dst);
+
+	/*
+	 * Remember actual input length, source buffer length may be
+	 * updated in case of inline operation below.
+	 */
+	totlen = totlen_src;
+	queued = totlen_src;
+
 	if (src == dst) {
-		nr_src = dma_map_sg(priv->dev, src, sg_nents(src),
-				    DMA_BIDIRECTIONAL);
-		nr_dst = nr_src;
-		if (!nr_src)
+		sreq->nr_src = max(sreq->nr_src, sreq->nr_dst);
+		sreq->nr_dst = sreq->nr_src;
+		if (unlikely((totlen_src || totlen_dst) &&
+		    (sreq->nr_src <= 0))) {
+			dev_err(priv->dev, "In-place buffer not large enough (need %d bytes)!",
+				max(totlen_src, totlen_dst));
 			return -EINVAL;
+		}
+		dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
 	} else {
-		nr_src = dma_map_sg(priv->dev, src, sg_nents(src),
-				    DMA_TO_DEVICE);
-		if (!nr_src)
+		if (unlikely(totlen_src && (sreq->nr_src <= 0))) {
+			dev_err(priv->dev, "Source buffer not large enough (need %d bytes)!",
+				totlen_src);
 			return -EINVAL;
+		}
+		dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
 
-		nr_dst = dma_map_sg(priv->dev, dst, sg_nents(dst),
-				    DMA_FROM_DEVICE);
-		if (!nr_dst) {
-			dma_unmap_sg(priv->dev, src, nr_src, DMA_TO_DEVICE);
+		if (unlikely(totlen_dst && (sreq->nr_dst <= 0))) {
+			dev_err(priv->dev, "Dest buffer not large enough (need %d bytes)!",
+				totlen_dst);
+			dma_unmap_sg(priv->dev, src, sreq->nr_src,
+				     DMA_TO_DEVICE);
 			return -EINVAL;
 		}
+		dma_map_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
 	}
 
 	memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);
 
-	if (ctx->aead) {
-		memcpy(ctx->base.ctxr->data + ctx->key_len / sizeof(u32),
-		       ctx->ipad, ctx->state_sz);
-		memcpy(ctx->base.ctxr->data + (ctx->key_len + ctx->state_sz) / sizeof(u32),
-		       ctx->opad, ctx->state_sz);
-	}
+	/* The EIP cannot deal with zero length input packets! */
+	if (totlen == 0)
+		totlen = 1;
 
 	/* command descriptors */
-	for_each_sg(src, sg, nr_src, i) {
+	for_each_sg(src, sg, sreq->nr_src, i) {
 		int len = sg_dma_len(sg);
 
 		/* Do not overflow the request */
 		if (queued - len < 0)
 			len = queued;
 
-		cdesc = safexcel_add_cdesc(priv, ring, !n_cdesc, !(queued - len),
+		cdesc = safexcel_add_cdesc(priv, ring, !n_cdesc,
+					   !(queued - len),
 					   sg_dma_address(sg), len, totlen,
 					   ctx->base.ctxr_dma);
 		if (IS_ERR(cdesc)) {
@@ -460,14 +497,7 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 		n_cdesc++;
 
 		if (n_cdesc == 1) {
-			safexcel_context_control(ctx, base, sreq, cdesc);
-			if (ctx->aead)
-				safexcel_aead_token(ctx, iv, cdesc,
-						    sreq->direction, cryptlen,
-						    assoclen, digestsize);
-			else
-				safexcel_skcipher_token(ctx, iv, cdesc,
-							cryptlen);
+			first_cdesc = cdesc;
 		}
 
 		queued -= len;
@@ -475,23 +505,83 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 			break;
 	}
 
+	if (unlikely(!n_cdesc)) {
+		/*
+		 * Special case: zero length input buffer.
+		 * The engine always needs the 1st command descriptor, however!
+		 */
+		first_cdesc = safexcel_add_cdesc(priv, ring, 1, 1, 0, 0, totlen,
+						 ctx->base.ctxr_dma);
+		n_cdesc = 1;
+	}
+
+	/* Add context control words and token to first command descriptor */
+	safexcel_context_control(ctx, base, sreq, first_cdesc);
+	if (ctx->aead)
+		safexcel_aead_token(ctx, iv, first_cdesc,
+				    sreq->direction, cryptlen,
+				    assoclen, digestsize);
+	else
+		safexcel_skcipher_token(ctx, iv, first_cdesc,
+					cryptlen);
+
 	/* result descriptors */
-	for_each_sg(dst, sg, nr_dst, i) {
-		bool first = !i, last = sg_is_last(sg);
+	for_each_sg(dst, sg, sreq->nr_dst, i) {
+		bool last = (i == sreq->nr_dst - 1);
 		u32 len = sg_dma_len(sg);
 
-		rdesc = safexcel_add_rdesc(priv, ring, first, last,
-					   sg_dma_address(sg), len);
+		/* only allow the part of the buffer we know we need */
+		if (len > totlen_dst)
+			len = totlen_dst;
+		if (unlikely(!len))
+			break;
+		totlen_dst -= len;
+
+		/* skip over AAD space in buffer - not written */
+		if (assoclen) {
+			if (assoclen >= len) {
+				assoclen -= len;
+				continue;
+			}
+			rdesc = safexcel_add_rdesc(priv, ring, first, last,
+						   sg_dma_address(sg) +
+						   assoclen,
+						   len - assoclen);
+			assoclen = 0;
+		} else {
+			rdesc = safexcel_add_rdesc(priv, ring, first, last,
+						   sg_dma_address(sg),
+						   len);
+		}
 		if (IS_ERR(rdesc)) {
 			/* No space left in the result descriptor ring */
 			ret = PTR_ERR(rdesc);
 			goto rdesc_rollback;
 		}
-		if (first)
+		if (first) {
 			first_rdesc = rdesc;
+			first = false;
+		}
 		n_rdesc++;
 	}
 
+	if (unlikely(first)) {
+		/*
+		 * Special case: AEAD decrypt with only AAD data.
+		 * In this case there is NO output data from the engine,
+		 * but the engine still needs a result descriptor!
+		 * Create a dummy one just for catching the result token.
+		 */
+		rdesc = safexcel_add_rdesc(priv, ring, true, true, 0, 0);
+		if (IS_ERR(rdesc)) {
+			/* No space left in the result descriptor ring */
+			ret = PTR_ERR(rdesc);
+			goto rdesc_rollback;
+		}
+		first_rdesc = rdesc;
+		n_rdesc = 1;
+	}
+
 	safexcel_rdr_req_set(priv, ring, first_rdesc, base);
 
 	*commands = n_cdesc;
@@ -506,10 +596,10 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 		safexcel_ring_rollback_wptr(priv, &priv->ring[ring].cdr);
 
 	if (src == dst) {
-		dma_unmap_sg(priv->dev, src, nr_src, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(priv->dev, src, nr_src, DMA_TO_DEVICE);
-		dma_unmap_sg(priv->dev, dst, nr_dst, DMA_FROM_DEVICE);
+		dma_unmap_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
+		dma_unmap_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
 	}
 
 	return ret;
-- 
1.8.3.1


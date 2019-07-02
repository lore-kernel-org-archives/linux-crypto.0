Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E506C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B012082F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aE3Ve3AF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfGBPmh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:42:37 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34561 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfGBPmh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 11:42:37 -0400
Received: by mail-ed1-f66.google.com with SMTP id s49so27792947edb.1
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 08:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d2VMJcA6qcVcIWS9TtHbEJ8xNyPF8HEc/OWfnlj04PQ=;
        b=aE3Ve3AF9PVdP19asdIu7r5RLE+Uoq/cY4QDNETi5ajYQ3LJdbkxt/KuUv6GfDj5g2
         W04VLSkyhQHG6uWbDbObck9n+yrx3AskLU2uJ2vG1lCqbpXK2dLaIMQNq4t2u3QpfHLL
         aDy6tn4AwQDrsrsXyG6eZxqqTCwcrc1+3AaZkUpkBKjo8Qt/6ReFqFmyJPoajP72sBVN
         zb4hS0skbbiL7nqKqwmwmdg2BhPm2j9077aUXITimCi4bhJR/8M6Ovxw8Kah2/qsRaB6
         4uB24+trUmzbxGFOoCV6bkDYhJCfzTbbx8suTfF58aDLWZdg4Fdr/9Ji5TJQSDa9bYoN
         QtGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d2VMJcA6qcVcIWS9TtHbEJ8xNyPF8HEc/OWfnlj04PQ=;
        b=WZeBnYHxReSfXSamAFXjptjIjHGIyZCV1xM6y2IMB8BwMe31L+wVxUgka4UUaqh8Jt
         VNsjSu7C3Lu7llpxbs7J6ETOgGdGJbpFhEzOSmqjOLzEmSV3cD4WxV0vhnp5IhRBIGYv
         Ep9qggFQGod4YetHhDOjDgPGHnbp4iPsHc2MLt76S4ThtAAyX1uQ7w33dKmIcfITSHe+
         iycMn6nlN2vnlk39drmLR79s0nWwIRdbx0W+oKZgJ3bH7qwzbvPrYz9gprypATmAgNmI
         XKiybgUIyXD1oz6wePRnX2lSGrY+6Q7HaHafDnFIChh4DNpoB43ImkUxg1x6ok9fmaE3
         Ep7Q==
X-Gm-Message-State: APjAAAWnHgGUQi7DdcVb1H9JQa0NJMpKB3XZkQ5WVbbLixW04qj5hCsy
        tBANPMeJbwYiwUTC6khrGNUDuu7g
X-Google-Smtp-Source: APXvYqwjlslwnbtZxWJy3qo3AnYCBJfNpygTQIy6dug3088a4p0Rdq7SnwJ+NLE0+WgyhHK1rQnBPA==
X-Received: by 2002:a50:9167:: with SMTP id f36mr36647261eda.297.1562082155535;
        Tue, 02 Jul 2019 08:42:35 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id j11sm2341704ejr.69.2019.07.02.08.42.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:42:34 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 3/9] crypto: inside-secure - fix incorrect skcipher output IV
Date:   Tue,  2 Jul 2019 16:39:54 +0200
Message-Id: <1562078400-969-6-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

This patch fixes corruption issues with the skcipher output IV
witnessed on x86+EIP197-FPGA (devboard). The original fix, commit
57660b11d5ad ("crypto: inside-secure - implement IV retrieval"),
attempted to write out the result IV through the context record.
However, this is not a reliable mechanism as there is no way of
knowing the hardware context update actually arrived in memory, so
it is possible to read the old contents instead of the updated IV.
(and indeed, this failed for the x86/FPGA case)

The alternative approach used here recognises the fact that the
result IV for CBC is actually the last cipher block, which is the last
input block in case of decryption and the last output block in case
of encryption. So the result IV is taken from the input data buffer
respectively the output data buffer instead, which *is* reliable.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 84 +++++++++++++-------------
 1 file changed, 43 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 7977e4c..9aebc0a 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -92,25 +92,6 @@ static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	token[0].instructions = EIP197_TOKEN_INS_LAST |
 				EIP197_TOKEN_INS_TYPE_CRYTO |
 				EIP197_TOKEN_INS_TYPE_OUTPUT;
-
-	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
-		u32 last = (EIP197_MAX_TOKENS - 1) - offset;
-
-		token[last].opcode = EIP197_TOKEN_OPCODE_CTX_ACCESS;
-		token[last].packet_length = EIP197_TOKEN_DIRECTION_EXTERNAL |
-					    EIP197_TOKEN_EXEC_IF_SUCCESSFUL|
-					    EIP197_TOKEN_CTX_OFFSET(0x2);
-		token[last].stat = EIP197_TOKEN_STAT_LAST_HASH |
-			EIP197_TOKEN_STAT_LAST_PACKET;
-		token[last].instructions =
-			EIP197_TOKEN_INS_ORIGIN_LEN(block_sz / sizeof(u32)) |
-			EIP197_TOKEN_INS_ORIGIN_IV0;
-
-		/* Store the updated IV values back in the internal context
-		 * registers.
-		 */
-		cdesc->control_data.control1 |= CONTEXT_CONTROL_CRYPTO_STORE;
-	}
 }
 
 static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
@@ -348,6 +329,9 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 				      struct safexcel_cipher_req *sreq,
 				      bool *should_complete, int *ret)
 {
+	struct skcipher_request *areq = skcipher_request_cast(async);
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(areq);
+	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct safexcel_result_desc *rdesc;
 	int ndesc = 0;
 
@@ -380,6 +364,18 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
 		dma_unmap_sg(priv->dev, dst, sg_nents(dst), DMA_FROM_DEVICE);
 	}
 
+	/*
+	 * Update IV in req from last crypto output word for CBC modes
+	 */
+	if ((!ctx->aead) && (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) &&
+	    (sreq->direction == SAFEXCEL_ENCRYPT)) {
+		/* For encrypt take the last output word */
+		sg_pcopy_to_buffer(dst, sg_nents(dst), areq->iv,
+				   crypto_skcipher_ivsize(skcipher),
+				   (cryptlen -
+				    crypto_skcipher_ivsize(skcipher)));
+	}
+
 	*should_complete = true;
 
 	return ndesc;
@@ -392,6 +388,8 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 			     unsigned int digestsize, u8 *iv, int *commands,
 			     int *results)
 {
+	struct skcipher_request *areq = skcipher_request_cast(base);
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(areq);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct safexcel_command_desc *cdesc;
@@ -401,6 +399,19 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 	int nr_src, nr_dst, n_cdesc = 0, n_rdesc = 0, queued = totlen;
 	int i, ret = 0;
 
+	if ((!ctx->aead) && (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) &&
+	    (sreq->direction == SAFEXCEL_DECRYPT)) {
+		/*
+		 * Save IV from last crypto input word for CBC modes in decrypt
+		 * direction. Need to do this first in case of inplace operation
+		 * as it will be overwritten.
+		 */
+		sg_pcopy_to_buffer(src, sg_nents(src), areq->iv,
+				   crypto_skcipher_ivsize(skcipher),
+				   (totlen -
+				    crypto_skcipher_ivsize(skcipher)));
+	}
+
 	if (src == dst) {
 		nr_src = dma_map_sg(priv->dev, src, sg_nents(src),
 				    DMA_BIDIRECTIONAL);
@@ -570,7 +581,6 @@ static int safexcel_skcipher_handle_result(struct safexcel_crypto_priv *priv,
 {
 	struct skcipher_request *req = skcipher_request_cast(async);
 	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
-	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(async->tfm);
 	int err;
 
 	if (sreq->needs_inv) {
@@ -581,24 +591,6 @@ static int safexcel_skcipher_handle_result(struct safexcel_crypto_priv *priv,
 		err = safexcel_handle_req_result(priv, ring, async, req->src,
 						 req->dst, req->cryptlen, sreq,
 						 should_complete, ret);
-
-		if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
-			u32 block_sz = 0;
-
-			switch (ctx->alg) {
-			case SAFEXCEL_DES:
-				block_sz = DES_BLOCK_SIZE;
-				break;
-			case SAFEXCEL_3DES:
-				block_sz = DES3_EDE_BLOCK_SIZE;
-				break;
-			case SAFEXCEL_AES:
-				block_sz = AES_BLOCK_SIZE;
-				break;
-			}
-
-			memcpy(req->iv, ctx->base.ctxr->data, block_sz);
-		}
 	}
 
 	return err;
@@ -656,12 +648,22 @@ static int safexcel_skcipher_send(struct crypto_async_request *async, int ring,
 
 	BUG_ON(!(priv->flags & EIP197_TRC_CACHE) && sreq->needs_inv);
 
-	if (sreq->needs_inv)
+	if (sreq->needs_inv) {
 		ret = safexcel_cipher_send_inv(async, ring, commands, results);
-	else
+	} else {
+		struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+		u8 input_iv[AES_BLOCK_SIZE];
+
+		/*
+		 * Save input IV in case of CBC decrypt mode
+		 * Will be overwritten with output IV prior to use!
+		 */
+		memcpy(input_iv, req->iv, crypto_skcipher_ivsize(skcipher));
+
 		ret = safexcel_send_req(async, ring, sreq, req->src,
-					req->dst, req->cryptlen, 0, 0, req->iv,
+					req->dst, req->cryptlen, 0, 0, input_iv,
 					commands, results);
+	}
 
 	sreq->rdescs = *results;
 	return ret;
-- 
1.8.3.1


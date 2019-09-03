Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63170C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3994921881
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XNUIp7gh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbfICQn6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:43:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42700 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQn6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:43:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id w22so2679695pfi.9
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4rOqC3sDxYEvPZjvQzEBSOK6QwtrxcRA7eQQZQ1weWg=;
        b=XNUIp7ghp+lOhuBLKnuLx1NkTFRe1oGt4Q58jSOkokHLV5Q2YA7rJwpvGFzgdfaugh
         Kbk0bVKcfqmC22mpp+Ie7M3ZE2x8sBShhMbFQXUTu/nMbHZGdI7fLJz8C38R4NFloT3W
         h68neaRl1rjFTgnpK7jSzic1Wz0KF6VS3DjvNZY1GyijSs0GisLf6kSvC4yzIKBd4Jev
         b063wN7T3n+B7wWvUGttJpAmjcpInqFMLqfqKv3IOh7WVigJK+gSSgm+dpLU1seRqSaI
         eBkV6uLa4rPnXSjliWM1e+sCruyrDoWJrctMd7FS152QFarxXhwrRD7g512pjNKaDzcZ
         Wp/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4rOqC3sDxYEvPZjvQzEBSOK6QwtrxcRA7eQQZQ1weWg=;
        b=Fgb8Bn7aufpBXd2hMZudMyevLyxy1COu3XKRUR4a3PJdtalDWqdFthoadrC5zx5gTk
         R7IN+xeFUoMAIdwoTcv9wzrtFyEXYM9/1CaJfJ9CTqPC1W5yIgLG1KjFj12kpGM95dO+
         HGsFuFgUyFvHHReyanU05uy/X6/8naLoazzSp1iKJsxwVxj1sTeYuKqWdCDhpN0q88Ug
         HUfnkMQ5h4m5H1MogshO9pYcCcOOv1Ihmu9wCyDt2dCladZ5kTEnRB5/WZigRblQ3Vqr
         6fd3vYvOwqQ83MRZIAJfCA8Fb+EEQOlm2Ksy8lllIRmdFrARAY06SP3GfcRRi31GFwcy
         FmFQ==
X-Gm-Message-State: APjAAAX4TeuH1KYggb5wMaJpXDS47dbvgOw4f2GTZ+RaW/OCbLR9T6RS
        09M6m2a4+1KaNMnCc7KGfjcMm4pCPSsixmrz
X-Google-Smtp-Source: APXvYqxU/KRk0+60VC4NN8cqMA9dh7QO+0hwWQqErttNWTW5WK311lEqoAxd+fTjAKt/EaLgbnTutQ==
X-Received: by 2002:a65:47c1:: with SMTP id f1mr30749430pgs.169.1567529037456;
        Tue, 03 Sep 2019 09:43:57 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:43:56 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 10/17] crypto: arm64/aes-cts-cbc - move request context data to the stack
Date:   Tue,  3 Sep 2019 09:43:32 -0700
Message-Id: <20190903164339.27984-11-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
References: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since the CTS-CBC code completes synchronously, there is no point in
keeping part of the scratch data it uses in the request context, so
move it to the stack instead.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c | 61 +++++++++-----------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 4154bb93a85b..5ee980c5a5c2 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -107,12 +107,6 @@ asmlinkage void aes_mac_update(u8 const in[], u32 const rk[], int rounds,
 			       int blocks, u8 dg[], int enc_before,
 			       int enc_after);
 
-struct cts_cbc_req_ctx {
-	struct scatterlist sg_src[2];
-	struct scatterlist sg_dst[2];
-	struct skcipher_request subreq;
-};
-
 struct crypto_aes_xts_ctx {
 	struct crypto_aes_ctx key1;
 	struct crypto_aes_ctx __aligned(8) key2;
@@ -292,23 +286,20 @@ static int __maybe_unused cbc_decrypt(struct skcipher_request *req)
 	return cbc_decrypt_walk(req, &walk);
 }
 
-static int cts_cbc_init_tfm(struct crypto_skcipher *tfm)
-{
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct cts_cbc_req_ctx));
-	return 0;
-}
-
 static int cts_cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct cts_cbc_req_ctx *rctx = skcipher_request_ctx(req);
 	int err, rounds = 6 + ctx->key_length / 4;
 	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
 	struct scatterlist *src = req->src, *dst = req->dst;
+	struct scatterlist sg_src[2], sg_dst[2];
+	struct skcipher_request subreq;
 	struct skcipher_walk walk;
 
-	skcipher_request_set_tfm(&rctx->subreq, tfm);
+	skcipher_request_set_tfm(&subreq, tfm);
+	skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
+				      NULL, NULL);
 
 	if (req->cryptlen <= AES_BLOCK_SIZE) {
 		if (req->cryptlen < AES_BLOCK_SIZE)
@@ -317,31 +308,30 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
 	}
 
 	if (cbc_blocks > 0) {
-		skcipher_request_set_crypt(&rctx->subreq, req->src, req->dst,
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
 					   cbc_blocks * AES_BLOCK_SIZE,
 					   req->iv);
 
-		err = skcipher_walk_virt(&walk, &rctx->subreq, false) ?:
-		      cbc_encrypt_walk(&rctx->subreq, &walk);
+		err = skcipher_walk_virt(&walk, &subreq, false) ?:
+		      cbc_encrypt_walk(&subreq, &walk);
 		if (err)
 			return err;
 
 		if (req->cryptlen == AES_BLOCK_SIZE)
 			return 0;
 
-		dst = src = scatterwalk_ffwd(rctx->sg_src, req->src,
-					     rctx->subreq.cryptlen);
+		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
 		if (req->dst != req->src)
-			dst = scatterwalk_ffwd(rctx->sg_dst, req->dst,
-					       rctx->subreq.cryptlen);
+			dst = scatterwalk_ffwd(sg_dst, req->dst,
+					       subreq.cryptlen);
 	}
 
 	/* handle ciphertext stealing */
-	skcipher_request_set_crypt(&rctx->subreq, src, dst,
+	skcipher_request_set_crypt(&subreq, src, dst,
 				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
 				   req->iv);
 
-	err = skcipher_walk_virt(&walk, &rctx->subreq, false);
+	err = skcipher_walk_virt(&walk, &subreq, false);
 	if (err)
 		return err;
 
@@ -357,13 +347,16 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct cts_cbc_req_ctx *rctx = skcipher_request_ctx(req);
 	int err, rounds = 6 + ctx->key_length / 4;
 	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
 	struct scatterlist *src = req->src, *dst = req->dst;
+	struct scatterlist sg_src[2], sg_dst[2];
+	struct skcipher_request subreq;
 	struct skcipher_walk walk;
 
-	skcipher_request_set_tfm(&rctx->subreq, tfm);
+	skcipher_request_set_tfm(&subreq, tfm);
+	skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
+				      NULL, NULL);
 
 	if (req->cryptlen <= AES_BLOCK_SIZE) {
 		if (req->cryptlen < AES_BLOCK_SIZE)
@@ -372,31 +365,30 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	}
 
 	if (cbc_blocks > 0) {
-		skcipher_request_set_crypt(&rctx->subreq, req->src, req->dst,
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
 					   cbc_blocks * AES_BLOCK_SIZE,
 					   req->iv);
 
-		err = skcipher_walk_virt(&walk, &rctx->subreq, false) ?:
-		      cbc_decrypt_walk(&rctx->subreq, &walk);
+		err = skcipher_walk_virt(&walk, &subreq, false) ?:
+		      cbc_decrypt_walk(&subreq, &walk);
 		if (err)
 			return err;
 
 		if (req->cryptlen == AES_BLOCK_SIZE)
 			return 0;
 
-		dst = src = scatterwalk_ffwd(rctx->sg_src, req->src,
-					     rctx->subreq.cryptlen);
+		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
 		if (req->dst != req->src)
-			dst = scatterwalk_ffwd(rctx->sg_dst, req->dst,
-					       rctx->subreq.cryptlen);
+			dst = scatterwalk_ffwd(sg_dst, req->dst,
+					       subreq.cryptlen);
 	}
 
 	/* handle ciphertext stealing */
-	skcipher_request_set_crypt(&rctx->subreq, src, dst,
+	skcipher_request_set_crypt(&subreq, src, dst,
 				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
 				   req->iv);
 
-	err = skcipher_walk_virt(&walk, &rctx->subreq, false);
+	err = skcipher_walk_virt(&walk, &subreq, false);
 	if (err)
 		return err;
 
@@ -675,7 +667,6 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey		= skcipher_aes_setkey,
 	.encrypt	= cts_cbc_encrypt,
 	.decrypt	= cts_cbc_decrypt,
-	.init		= cts_cbc_init_tfm,
 }, {
 	.base = {
 		.cra_name		= "__essiv(cbc(aes),sha256)",
-- 
2.17.1


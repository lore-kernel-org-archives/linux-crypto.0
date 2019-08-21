Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9926C3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB927216F4
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EwWBwtST"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfHUOdT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55975 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728763AbfHUOdT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id f72so2364837wmf.5
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4rOqC3sDxYEvPZjvQzEBSOK6QwtrxcRA7eQQZQ1weWg=;
        b=EwWBwtST+N+pDX259VYc6hMCiCiRFsj5huNKdJ61973ObppP+x7c4HczzHMCQk40Hl
         2I15aox8qgvkaf5hIp8L603o7BXcA7qCTxRlkp5+b48IXNJj/shtNJ3AbCLYrILoKQkZ
         tb5wqj5RwMR2WLttSe13OMyZWGabjDhhGvrTfjgJGutKHlsTdJE+J1h16F2ozOMRT/1U
         xB1I9mQEVFC527Qc/VnmSGKotjqPcrnJoa1tzu9m3UnQcw9rD2t4e+RS9gR/ldyGGD67
         /Kj7vE/OaljhXwag4MS6PwIUw4WvXGPDh1EyaWwbHN6ByHPiT4wSpBa9hkYfjWKtE8BM
         6CcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4rOqC3sDxYEvPZjvQzEBSOK6QwtrxcRA7eQQZQ1weWg=;
        b=PNnZ31jLEb6HQIxAsIT6mgBGMPU5xC7d7SH2rQa+RSv/yIBGVgzQQdxCK/K5wYMINh
         JRcbitCzg+xUkZPG7KGVcpi5eYQsmQtqEa2feTdnDJTG5fDpQX9Y9RVSn3ocpHyt8QkE
         VCtucdC66GuRGeqryh7J8VFz1Q+UDOp67lXDLJfbjyaKY9yMRDvO9AW8RieE0C9F7W9n
         oktqrbB54vKeFLSB37uig+5e6wzivlwlXHq/2gdQ9+UW+m0Q3V3d+3TH1rzqlj2iW9eh
         GkkFmrajjCrqO3PfcZbIPKS5hiMpfBZC26jLJ94ahP3M44cB7hxHaaxceiEZXd0fdni8
         TrYQ==
X-Gm-Message-State: APjAAAWwP2IAESVonoFlzt1xNTzs0UYCvfoVLErkzczEOlC+68ELHIkx
        0jHnAPwl2Oeo43RZ8SHH2F4zwltYVvou9Q==
X-Google-Smtp-Source: APXvYqzxzRJHvNIiVif4YtqbmhqMlx12YNzoOIM9uHhRa4Xx3HcZ66KrPmI6tm6B86y3fdOpfw6RXA==
X-Received: by 2002:a7b:c4c6:: with SMTP id g6mr423241wmk.52.1566397996004;
        Wed, 21 Aug 2019 07:33:16 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:15 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 10/17] crypto: arm64/aes-cts-cbc - move request context data to the stack
Date:   Wed, 21 Aug 2019 17:32:46 +0300
Message-Id: <20190821143253.30209-11-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
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


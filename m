Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C28C4167B
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Jan 2023 09:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjAAJNN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Jan 2023 04:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjAAJNK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Jan 2023 04:13:10 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CCC5F7B
        for <linux-crypto@vger.kernel.org>; Sun,  1 Jan 2023 01:13:09 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o2so21490073pjh.4
        for <linux-crypto@vger.kernel.org>; Sun, 01 Jan 2023 01:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fcdz/TWV42h49YlZugYjZVlzH264f/FrcB95KFPCDnQ=;
        b=RNASz+XiPKgB93ESQ3LHZuf6c/3Kt8w4haazOiSOU+j2R+s/sYMqIZFU+ahMeR3ZGh
         hslz+Cvzx0N9Fw25ioxhSSNXfw1T2A/1kdF2vmT0XOrQbT7d4ZKS5kPXwY1p+J1bcJZN
         1HHzDwCqLGdIZXGXwhB0AsuQL9w3clh4Ob1386sKfIGe1D8O7NySyFf3d30rxvHViZJI
         TtQ8zXoojFD87flBf68nMiipTfNGPb7eoa127twuUZqKPyOliAV7zmRhKbbMOnSg6qvd
         V6yRlfsqO58d0i9xWTKAdTwjsfjdqy9gaAjG114A7EWHwIl7ByukZ8f9H/zg6PTRkYtI
         eaSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fcdz/TWV42h49YlZugYjZVlzH264f/FrcB95KFPCDnQ=;
        b=TR8z14/RuwLqb/nUqroYhAWoaIBcMMfNUFQ8Otsu5vOMOB25GqcNExbtCoJZog7KbT
         AOstlBSqIGtkilMyKqeKAvF5hxkkvaSUyNzPYHGy95ENxnmv1pCSdGsOEOEf+ygMCcHM
         fo1AroK+RLfXcRGIMjt8ElUfudufx96WvDUME4ynxWWhXnckeJsSS7Fsy93QX+ASD9/I
         6eNSdz4B6hNYrmHsIzGRqWZCMs4csl3E3QPbHeKsl7Xme7xh4kyyDnEprx+mpa3/yZJk
         AkL8n/V8xsNrAi7HFM9vrmye+SADlvK9tomrLRRDpF3hTATWYwg9R5y4NAwMbTYaO0AF
         dCNg==
X-Gm-Message-State: AFqh2kqruN130VMBtVyTjQNrfXYON9p2P2uUG77uHf7+K6rfqAh8rgOe
        mHOIlUxa4hHHzlPZdcqJObDJ/BUe3OGtDA==
X-Google-Smtp-Source: AMrXdXse1CbBhSlyN2UzACx/nzTJtzsl8j8u6C9g5NJOYNjK0mCBPYZ7hvgibFNqenJsAOWii08Puw==
X-Received: by 2002:a05:6a20:e609:b0:a4:cb41:298f with SMTP id my9-20020a056a20e60900b000a4cb41298fmr46657628pzb.6.1672564388162;
        Sun, 01 Jan 2023 01:13:08 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k26-20020aa79d1a000000b0058130f1eca1sm10951327pfp.182.2023.01.01.01.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 01:13:07 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Cc:     elliott@hpe.com, jussi.kivilinna@iki.fi, ebiggers@kernel.org,
        ap420073@gmail.com
Subject: [PATCH v8 1/4] crypto: aria: add keystream array into request ctx
Date:   Sun,  1 Jan 2023 09:12:49 +0000
Message-Id: <20230101091252.700117-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230101091252.700117-1-ap420073@gmail.com>
References: <20230101091252.700117-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

avx accelerated aria module used local keystream array.
But, keystream array size is too big.
So, it puts the keystream array into request ctx.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v8:
 - No changes.

v7:
 - No changes.

v6:
 - No changes.

v5:
 - No changes.

v4:
 - Add aria_avx_request ctx for keystream array

v3:
 - No changes.

v2:
 - Patch introduced.

 arch/x86/crypto/aria_aesni_avx_glue.c | 39 ++++++++++++++++++---------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/crypto/aria_aesni_avx_glue.c b/arch/x86/crypto/aria_aesni_avx_glue.c
index c561ea4fefa5..5f97e442349f 100644
--- a/arch/x86/crypto/aria_aesni_avx_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx_glue.c
@@ -33,6 +33,10 @@ asmlinkage void aria_aesni_avx_gfni_ctr_crypt_16way(const void *ctx, u8 *dst,
 
 static struct aria_avx_ops aria_ops;
 
+struct aria_avx_request_ctx {
+	u8 keystream[ARIA_AESNI_PARALLEL_BLOCK_SIZE];
+};
+
 static int ecb_do_encrypt(struct skcipher_request *req, const u32 *rkey)
 {
 	ECB_WALK_START(req, ARIA_BLOCK_SIZE, ARIA_AESNI_PARALLEL_BLOCKS);
@@ -73,6 +77,7 @@ static int aria_avx_set_key(struct crypto_skcipher *tfm, const u8 *key,
 
 static int aria_avx_ctr_encrypt(struct skcipher_request *req)
 {
+	struct aria_avx_request_ctx *req_ctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aria_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
@@ -86,10 +91,9 @@ static int aria_avx_ctr_encrypt(struct skcipher_request *req)
 		u8 *dst = walk.dst.virt.addr;
 
 		while (nbytes >= ARIA_AESNI_PARALLEL_BLOCK_SIZE) {
-			u8 keystream[ARIA_AESNI_PARALLEL_BLOCK_SIZE];
-
 			kernel_fpu_begin();
-			aria_ops.aria_ctr_crypt_16way(ctx, dst, src, keystream,
+			aria_ops.aria_ctr_crypt_16way(ctx, dst, src,
+						      &req_ctx->keystream[0],
 						      walk.iv);
 			kernel_fpu_end();
 			dst += ARIA_AESNI_PARALLEL_BLOCK_SIZE;
@@ -98,28 +102,29 @@ static int aria_avx_ctr_encrypt(struct skcipher_request *req)
 		}
 
 		while (nbytes >= ARIA_BLOCK_SIZE) {
-			u8 keystream[ARIA_BLOCK_SIZE];
-
-			memcpy(keystream, walk.iv, ARIA_BLOCK_SIZE);
+			memcpy(&req_ctx->keystream[0], walk.iv, ARIA_BLOCK_SIZE);
 			crypto_inc(walk.iv, ARIA_BLOCK_SIZE);
 
-			aria_encrypt(ctx, keystream, keystream);
+			aria_encrypt(ctx, &req_ctx->keystream[0],
+				     &req_ctx->keystream[0]);
 
-			crypto_xor_cpy(dst, src, keystream, ARIA_BLOCK_SIZE);
+			crypto_xor_cpy(dst, src, &req_ctx->keystream[0],
+				       ARIA_BLOCK_SIZE);
 			dst += ARIA_BLOCK_SIZE;
 			src += ARIA_BLOCK_SIZE;
 			nbytes -= ARIA_BLOCK_SIZE;
 		}
 
 		if (walk.nbytes == walk.total && nbytes > 0) {
-			u8 keystream[ARIA_BLOCK_SIZE];
-
-			memcpy(keystream, walk.iv, ARIA_BLOCK_SIZE);
+			memcpy(&req_ctx->keystream[0], walk.iv,
+			       ARIA_BLOCK_SIZE);
 			crypto_inc(walk.iv, ARIA_BLOCK_SIZE);
 
-			aria_encrypt(ctx, keystream, keystream);
+			aria_encrypt(ctx, &req_ctx->keystream[0],
+				     &req_ctx->keystream[0]);
 
-			crypto_xor_cpy(dst, src, keystream, nbytes);
+			crypto_xor_cpy(dst, src, &req_ctx->keystream[0],
+				       nbytes);
 			dst += nbytes;
 			src += nbytes;
 			nbytes = 0;
@@ -130,6 +135,13 @@ static int aria_avx_ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
+static int aria_avx_init_tfm(struct crypto_skcipher *tfm)
+{
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct aria_avx_request_ctx));
+
+	return 0;
+}
+
 static struct skcipher_alg aria_algs[] = {
 	{
 		.base.cra_name		= "__ecb(aria)",
@@ -160,6 +172,7 @@ static struct skcipher_alg aria_algs[] = {
 		.setkey			= aria_avx_set_key,
 		.encrypt		= aria_avx_ctr_encrypt,
 		.decrypt		= aria_avx_ctr_encrypt,
+		.init			= aria_avx_init_tfm,
 	}
 };
 
-- 
2.34.1


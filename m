Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF25C352A1
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Dec 2022 13:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiLGN71 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Dec 2022 08:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiLGN7P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2022 08:59:15 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0605C0E6
        for <linux-crypto@vger.kernel.org>; Wed,  7 Dec 2022 05:59:14 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso1713071pjh.1
        for <linux-crypto@vger.kernel.org>; Wed, 07 Dec 2022 05:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qc9BjCuL8Y9jsd9KB/2MCymvXzgk7q3hryqmU37kquc=;
        b=bqpqWtnub1u5fPao//HWxPuIw8CUr2slN8/CKMQznG9qgyi3cYv9vWGZdXp8SLSjwu
         aCFGRHriRR0l/gwl5IU9JbJG6EFNo1vdtLG/bY08ezoYXyPcWQ5npl+Ssm0N9NkGYCh8
         dDTp+kYlvt/ah29845NW1yV/yJ7ITtgdlpEyj6lIgnEqFdEvGfrjciwFG2zOWWcIc5Qx
         0GcdIXC6fvqvxULBrGy0k/BcqG+XWkK3SQ8umy8Q3lbzn2hM7Y1NGBS788xzSpPx11zr
         bJ4aMZsRO1JKoEjMI+dB4uADeb0adq34LsFwVc2qzcJXK6ou8m05n1XcAK/Pl7Tc4MZp
         OuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qc9BjCuL8Y9jsd9KB/2MCymvXzgk7q3hryqmU37kquc=;
        b=64lobHN76FIvcV9cRPDNO//cngCr6zSGfVQyPRBNXmhkTmH4v03IUdzdSX4CMJtIV5
         g1VLDc314VGqZQNZO4+UxQR0F7piR0fiI1k+PKFztRGNgY8QrCHCWwNRFCAUm3rCClPk
         mTQguFXUMMCdcM1Tke8Rzg813fvSPRMVjH2mxG0OzKs/feky5Mu9T/88LReRHJ5OgwXP
         PXk5AwlyWYjOYymwzXnnGOQKbvfexKMr4vTOXQSQLK9IWmu/QSgFU8EFgiFLd8uaoTAZ
         EzsIsqtx2kG0D+vX2N9ig/XttWAz73wp/21zaLBr24EgdoqADmO0d8+Hr0fdDNTizG3c
         k0hw==
X-Gm-Message-State: ANoB5pnCQO4BF4wRgd50ugBVSd5BEUNJFnC+VLvDMrYwl7Yv7mlquohJ
        PX/qQWjB70UzT1mwjqN6FwlU5KlKvWq+CA==
X-Google-Smtp-Source: AA0mqf6fT3TUlCo+cqBzdrHepAal7jdBcKCBVHSXmY+VgJ/6hxRRfYBO/XtoeKCXFeqAx+3jXEvuAw==
X-Received: by 2002:a05:6a20:8410:b0:a8:61bd:d9af with SMTP id c16-20020a056a20841000b000a861bdd9afmr1654417pzd.40.1670421553160;
        Wed, 07 Dec 2022 05:59:13 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b001885041d7b8sm14554619pln.293.2022.12.07.05.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:59:12 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Cc:     elliott@hpe.com, jussi.kivilinna@iki.fi, ebiggers@kernel.org,
        ap420073@gmail.com
Subject: [PATCH v7 1/4] crypto: aria: add keystream array into request ctx
Date:   Wed,  7 Dec 2022 13:58:52 +0000
Message-Id: <20221207135855.459181-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221207135855.459181-1-ap420073@gmail.com>
References: <20221207135855.459181-1-ap420073@gmail.com>
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


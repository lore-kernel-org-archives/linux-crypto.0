Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCCDC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 07:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiKRHXq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 02:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKRHXh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 02:23:37 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE0864546
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2022 23:23:36 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d192so4149632pfd.0
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2022 23:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2yyWY0X9+A0ZrKdoQEl093Jqor4oArGQvvfNH1BB7jY=;
        b=ogIULfajIq81buFOj+zkZouvrf2qbg505Qz4ivLRpHcK25F0YuDfPONyV+1vAOXRuC
         L+TWucvOLXY0KFLzPr77ZYroaBn1q97ignjekl3kGwBwVviDBKhWJKXsb/hy6/3oCD5k
         WPvQh/8BRRQ6bWgElwljdP1wk+6hBIETcM1rO59FR7R+3wIy6jzpWxP3xZs9y94rxeoI
         PmAGHMIDdA/zkfa/LWfDrturlx3wAyCEEYkPNM29a5sEyUZoOgkI5xCWwQ0TpCOFXElW
         j18y+tn6+xkO/ydjzOyTkcjeBX91Giia1usVSQc0hCI5kVXa+NgGBlwMGquxEoAxq2VQ
         BWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2yyWY0X9+A0ZrKdoQEl093Jqor4oArGQvvfNH1BB7jY=;
        b=EnkXSiLzHu/Y/iuFeqIyNY/Mr8N4LwBvrhXtD6i7081/dAHL7DJjRMej2M9tFohvKQ
         yl4Mh6KuMPex0K7CQK0j450q/MeCSYQ6MV80NEQLKhCZJF+crzXBbwXTd9z9tjib/PZ2
         FjrhP5wV/jq9etrbwzlwHZh2PNSTt9pFGo293cjXMcqu0yjgOpYtE12vwsn2ivChc/0p
         3B95l4Pml9G4iEedM0wXNFqYjnfSXIGjdwzKpyO/qBojKV10qfabVfUAuOqVlZNO38MA
         IyR/njNYypvg1dVOraPasgtalgVpLpQRci9caPGzpp6RoWLQs1lx1OxRUPzIPsuaWzaa
         jtzg==
X-Gm-Message-State: ANoB5plU2CZ5NCKpZ1bvb8IDYLWPaF2B7g9JGLzlxx4CXtJXwGwv/K60
        OZcHq5CjuTQCo+9iD2AB42rSQm3bpms=
X-Google-Smtp-Source: AA0mqf65/EWmUZsnqCEUD3LIdqMDyq06RVtHOqLzBL+atbYRGuK8K9vJfiiTEjDW2SoZh318s8InHw==
X-Received: by 2002:a63:fc49:0:b0:476:941a:8582 with SMTP id r9-20020a63fc49000000b00476941a8582mr5561306pgk.321.1668756216151;
        Thu, 17 Nov 2022 23:23:36 -0800 (PST)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id ix9-20020a170902f80900b001782a0d3eeasm2734228plb.115.2022.11.17.23.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 23:23:35 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
Cc:     ap420073@gmail.com
Subject: [PATCH v5 1/4] crypto: aria: add keystream array into request ctx
Date:   Fri, 18 Nov 2022 07:22:49 +0000
Message-Id: <20221118072252.10770-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118072252.10770-1-ap420073@gmail.com>
References: <20221118072252.10770-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

avx accelerated aria module used local keystream array.
But, keystream array size is too big.
So, it puts the keystream array into request ctx.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

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
2.17.1


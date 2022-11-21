Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BFDC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Nov 2022 00:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiKUAkT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Nov 2022 19:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiKUAkR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Nov 2022 19:40:17 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180A613EB9
        for <linux-crypto@vger.kernel.org>; Sun, 20 Nov 2022 16:40:17 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id mv18so1409165pjb.0
        for <linux-crypto@vger.kernel.org>; Sun, 20 Nov 2022 16:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eMW8fXXCkGqDGobKI8Qj8Rj7+omRVdtV0VT3HzQdiXA=;
        b=dT0747NaI+UNAL5yRh20JV48kjkeVjhRhTZ4JTEI6UTqAWn9Ihy9XiGvwX/mHTN1hu
         XXVFzf8l51HTyMBAZyhBDfRiV1Lo1ERt59lKzJYCVt5Z4bW+gfCTRM6fU3j5Djh90ubO
         EB0lYSNflHvCKPjPbWCTWmyygiyLxEV8MXWtFlbYcgwDxlgM8oaMUh9ddvG9843Yjua1
         SDkN6+HiaRGdcSEoVd7IPMuhPlaJO5r+dJUoPLoBHaNoZtSoMXUU/yf0TIFF+GJnhIOo
         s26MlJoTJwNtHN+yKMARoufZC1uTdktM7Xp9KJY25CJASEeBC3T2IkP+D9r4ifQKWrr/
         7Rpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eMW8fXXCkGqDGobKI8Qj8Rj7+omRVdtV0VT3HzQdiXA=;
        b=1P8XHbwhNIu8I8KXNunwoYKQgNLrLxVASlk/Sy0bZX/HGrd/dcrNm8oqidc6rhp0YA
         KqwlKzlgbVUeMimY7/YiA+SReMbjGD0uJE4DudzIULZUkHg/8MM+kpa9nKYDtho9gPUZ
         WwEtR9hiGLXXZIGiZ8/+v3RJWe8qvBbTiAVnTaiPaRbmul2R0r/fXOFry4+XNoRneohu
         6DP2SF+1k911KXaYbb/Y4QuGMpTpH6vcLTpWVoBny+Z+NtPaiUBRU7A414czh6uanp+k
         ccHjaUOnSSoaIBVA48HDhlSzLOAWsby7xaXExxo1SiANOHdhhnKTIPpDnXnaXBwbguqX
         eBvw==
X-Gm-Message-State: ANoB5pnX9BMBq3GfQik68HYB7GBhd2LZsSKabdKJfk9niX0t3SJXAoCK
        7tzavgcikYFhStqF+1KCzV0FBcnQbes=
X-Google-Smtp-Source: AA0mqf4zMBCsqzOA/zeFRelMSTDoGneEi+eUb826CDA5YW/3wW7KWlkVWSde+OgzHmOwoVmK2IK7Og==
X-Received: by 2002:a17:903:1ce:b0:186:a2ef:7a69 with SMTP id e14-20020a17090301ce00b00186a2ef7a69mr3069038plh.77.1668991216438;
        Sun, 20 Nov 2022 16:40:16 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902680d00b001837b19ebb8sm8075682plk.244.2022.11.20.16.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 16:40:16 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi,
        ebiggers@kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH v6 1/4] crypto: aria: add keystream array into request ctx
Date:   Mon, 21 Nov 2022 00:39:52 +0000
Message-Id: <20221121003955.2214462-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121003955.2214462-1-ap420073@gmail.com>
References: <20221121003955.2214462-1-ap420073@gmail.com>
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


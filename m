Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE8CC4360D
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 240E6222BF
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SYIsA/jL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732673AbfIYQOA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:14:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33840 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387919AbfIYQOA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id a11so7676954wrx.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 09:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xupbsCtUMBq0dKLLZcgZZz8OoL1zNg5tE6xYiAmXGow=;
        b=SYIsA/jLyOT0qlEO7cDTv2aW9SXsCwRwELfU1LJSTg6ZtBdPf/Th6yPkKEhj/J2adr
         Y2tUqkSPh4P0nJFGCaab9LSoY9FwcwWbEFVGm9sOpeRekjpfxZurAIa5tW9A6QbzDJC0
         h/JSGGDGnDXTJ95eEqNSHUarUCnxy4vRJyibdJuwzgoGERTNXJC6oAxTYpUHSLFzLBn4
         cU2WQx4k6LgfVmdjuC5I5IplDoZHPC78rRIiQVHHTaFxfVPjLpzk2dNe/vfd04/019i4
         YOWgSgvsxyZfu2v1O/drgMNdQfe+7oLX+jhjG24oKtDk0u73q0WP/4tcdBBTc9yMMNs1
         LZZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xupbsCtUMBq0dKLLZcgZZz8OoL1zNg5tE6xYiAmXGow=;
        b=olWyevibJQZX2qglgUbRhGXvThyUK3TxCISyTjrylJr2tDvgvwcHNzeSedNu5daJsX
         CPXHiSySbjThUVdKuvN6U90rZl4kVqcGpiBUk6dvqDH33HjjTiG0mHwVZ3xlZx0f+7Be
         c9swp5mrsXYglujptH/gdV4RKrxDlPvkD9/XaLWK+HG8ZOc0b9pZwfWQmVE7Y26RMKUq
         RXzHR/Btk8wr7s5wBNc2ARcD6x0Qplmnhx2173Dg9T07AXnBd+pU5V3VW0NMyVdEBPZI
         eH2P180YJ1zGK/BAF0+v6OsrkrB5kEy1zAU9lqzNmwDzgFgWbckPOqUyEqVew5pg3104
         wDmw==
X-Gm-Message-State: APjAAAUoXGqxAxvN5wctOVS0zaOC2eyoUcQ5hDHAs3/C0Pla1dUPG5ph
        OTtOWCaCJi++FpHjn21t/71W109IrQHi2s5I
X-Google-Smtp-Source: APXvYqwC8EG0AIcwFUrSnHZLRvuiWV5oBEZ24YsBf/vED1PlaF+hl22X2hkyEdzgxov49IyWVFvLvg==
X-Received: by 2002:adf:f547:: with SMTP id j7mr10623741wrp.119.1569428037024;
        Wed, 25 Sep 2019 09:13:57 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id o70sm4991085wme.29.2019.09.25.09.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:13:56 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC PATCH 07/18] crypto: rfc7539 - use zero reqsize for sync instantiations without alignmask
Date:   Wed, 25 Sep 2019 18:12:44 +0200
Message-Id: <20190925161255.1871-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that we have moved all the scratch buffers that must be allocated
on the heap out of the request context, we can move the request context
itself to the stack if we are instantiating a synchronous version of
the chacha20poly1305 transformation. This allows users of the AEAD to
allocate the request structure on the stack, removing the need for
per-packet heap allocations on the en/decryption hot path.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/chacha20poly1305.c | 51 ++++++++++++--------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 71496a8107f5..d171a0c9e837 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -49,13 +49,14 @@ struct chachapoly_req_ctx {
 };
 
 static inline void async_done_continue(struct aead_request *req, int err,
-				       int (*cont)(struct aead_request *))
+				       int (*cont)(struct aead_request *,
+						   struct chachapoly_req_ctx *))
 {
 	if (!err) {
 		struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 
 		rctx->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-		err = cont(req);
+		err = cont(req, rctx);
 	}
 
 	if (err != -EINPROGRESS && err != -EBUSY)
@@ -74,11 +75,11 @@ static void chacha_iv(u8 *iv, struct aead_request *req, u32 icb)
 }
 
 static int poly_generate_tag(struct aead_request *req, u8 *poly_tag,
-			     struct scatterlist *crypt)
+			     struct scatterlist *crypt,
+			     struct chachapoly_req_ctx *rctx)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	u32 chacha_state[CHACHA_BLOCK_SIZE / sizeof(u32)];
 	SHASH_DESC_ON_STACK(desc, ctx->poly);
 	u8 poly_key[POLY1305_KEY_SIZE];
@@ -148,13 +149,13 @@ static int poly_generate_tag(struct aead_request *req, u8 *poly_tag,
 	return 0;
 }
 
-static int poly_append_tag(struct aead_request *req)
+static int poly_append_tag(struct aead_request *req,
+			   struct chachapoly_req_ctx *rctx)
 {
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	u8 poly_tag[POLY1305_DIGEST_SIZE];
 	int err;
 
-	err = poly_generate_tag(req, poly_tag, req->dst);
+	err = poly_generate_tag(req, poly_tag, req->dst, rctx);
 	if (err)
 		return err;
 
@@ -171,12 +172,17 @@ static void chacha_encrypt_done(struct crypto_async_request *areq, int err)
 
 static int chachapoly_encrypt(struct aead_request *req)
 {
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
+	struct chachapoly_req_ctx stack_rctx CRYPTO_MINALIGN_ATTR;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
+	struct chachapoly_req_ctx *rctx = &stack_rctx;
 	struct chacha_req *creq = &rctx->chacha;
 	struct scatterlist *src, *dst;
 	int err;
 
+	if (unlikely(crypto_aead_reqsize(tfm) > 0))
+		rctx = aead_request_ctx(req);
+
 	rctx->cryptlen = req->cryptlen;
 	rctx->flags = aead_request_flags(req);
 
@@ -200,7 +206,7 @@ static int chachapoly_encrypt(struct aead_request *req)
 		return err;
 
 skip:
-	return poly_append_tag(req);
+	return poly_append_tag(req, rctx);
 }
 
 static void chacha_decrypt_done(struct crypto_async_request *areq, int err)
@@ -210,18 +216,23 @@ static void chacha_decrypt_done(struct crypto_async_request *areq, int err)
 
 static int chachapoly_decrypt(struct aead_request *req)
 {
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
+	struct chachapoly_req_ctx stack_rctx CRYPTO_MINALIGN_ATTR;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
+	struct chachapoly_req_ctx *rctx = &stack_rctx;
 	struct chacha_req *creq = &rctx->chacha;
 	u8 calculated_tag[POLY1305_DIGEST_SIZE];
 	u8 provided_tag[POLY1305_DIGEST_SIZE];
 	struct scatterlist *src, *dst;
 	int err;
 
+	if (unlikely(crypto_aead_reqsize(tfm) > 0))
+		rctx = aead_request_ctx(req);
+
 	rctx->cryptlen = req->cryptlen - POLY1305_DIGEST_SIZE;
 	rctx->flags = aead_request_flags(req);
 
-	err = poly_generate_tag(req, calculated_tag, req->src);
+	err = poly_generate_tag(req, calculated_tag, req->src, rctx);
 	if (err)
 		return err;
 	scatterwalk_map_and_copy(provided_tag, req->src,
@@ -314,12 +325,14 @@ static int chachapoly_init(struct crypto_aead *tfm)
 
 	align = crypto_aead_alignmask(tfm);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	crypto_aead_set_reqsize(
-		tfm,
-		align +
-		offsetof(struct chachapoly_req_ctx, chacha.req) +
-		sizeof(struct skcipher_request) +
-		crypto_skcipher_reqsize(chacha));
+	if (crypto_aead_alignmask(tfm) > 0 ||
+	    (crypto_aead_get_flags(tfm) & CRYPTO_ALG_ASYNC))
+		crypto_aead_set_reqsize(
+			tfm,
+			align +
+			offsetof(struct chachapoly_req_ctx, chacha.req) +
+			sizeof(struct skcipher_request) +
+			crypto_skcipher_reqsize(chacha));
 
 	return 0;
 }
-- 
2.20.1


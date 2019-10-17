Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EA1ECE58D
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECBA521A49
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:10:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V7I4hpnN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503388AbfJQTKO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:10:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41460 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503322AbfJQTKO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:10:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id p4so3583374wrm.8
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IZIptCKd4WM8fX70RUOUVGCwkhKzlQyYGe3DbvsRt/c=;
        b=V7I4hpnN7QpQsdfNovsBb3ah83qPRsQkztYR7SDq7rpuR+g1jtpD3VS6I4vjaclKv6
         GFsLVPmfjmw6aLsSNkoIIB/eX4li8BK2AZvgAlCh6wjsU4EQDUNSPgX5ZoMDIqO3Lx1w
         xXgNjxkw2wl9yAmr2dMjAdhC8GjqoFMp54DGh9UGjsAGnyBf3vAEj1cgUJXS/ECap6Gd
         pq8i+enCuSCx3Ee8RZBsyuWZDP4+V0KsIKHw0F+z+Fo9W0fwZTTILGkgp8T8q5sdnU6X
         hybxyaK2Bo81pHPc+VUOiq2MNUBR4d+DRLUczh3UMUXYpxMFP/58UJr81aa92UMOc9H2
         PerQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IZIptCKd4WM8fX70RUOUVGCwkhKzlQyYGe3DbvsRt/c=;
        b=fEstpK50euxtymGbEvMcSkjL/Fnu7FQEptJz05YxHRoDV/XTglZ4VM2GsZgHfchuio
         TDJZxRBOa8pyT0s9prehJQbad8MHTewfFWkIhw2ioGxQx4v8u/0h+VP4rSHcQPKmW3ST
         6n5o2ioFJVB6raZBjDYevUX3ZCRbBZrVGFNzII5YTG6y0nBVFj1qC3SgKKHF6sWw82oC
         jfpJAI0ynYntRU+XOGIiEXrCWwsCeHvheWTKiYi8wdaW5jlaY8FvPr3HWlF7RHF9wvW7
         VNHUowIprEVKUqVaBmNVaP9H7iFrHUyRHStQ/OPter/vbX+OwWx2eC2PRs/ll42CiE2F
         C7Ig==
X-Gm-Message-State: APjAAAWNGlux89fQKPcvrBcqQWfx4wjan7oJ0dvCpahFHjYed37Pyt6h
        v0cPMLw4t7ZaFXxOlmjfJ0nVkvBPfsS06AyN
X-Google-Smtp-Source: APXvYqz1l1GRv1g97DvET9c8S+/SftXIqmgimqH6OGV36zRv7x+KYaWJ61yAEo49QqCnog1KSIF/Jg==
X-Received: by 2002:adf:e747:: with SMTP id c7mr4363804wrn.384.1571339410196;
        Thu, 17 Oct 2019 12:10:10 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.10.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:10:09 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 12/35] crypto: chacha - unexport chacha_generic routines
Date:   Thu, 17 Oct 2019 21:09:09 +0200
Message-Id: <20191017190932.1947-13-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that all users of generic ChaCha code have moved to the core library,
there is no longer a need for the generic ChaCha skcpiher driver to
export parts of it implementation for reuse by other drivers. So drop
the exports, and make the symbols static.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/chacha_generic.c          | 26 ++++++--------------
 include/crypto/internal/chacha.h | 10 --------
 2 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index ebae6d9d9b32..c1b147318393 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -21,7 +21,7 @@ static int chacha_stream_xor(struct skcipher_request *req,
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	crypto_chacha_init(state, ctx, iv);
+	chacha_init_generic(state, ctx->key, iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
@@ -37,36 +37,27 @@ static int chacha_stream_xor(struct skcipher_request *req,
 	return err;
 }
 
-void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv)
-{
-	chacha_init_generic(state, ctx->key, iv);
-}
-EXPORT_SYMBOL_GPL(crypto_chacha_init);
-
-int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize)
+static int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+				  unsigned int keysize)
 {
 	return chacha_setkey(tfm, key, keysize, 20);
 }
-EXPORT_SYMBOL_GPL(crypto_chacha20_setkey);
 
-int crypto_chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize)
+static int crypto_chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
+				 unsigned int keysize)
 {
 	return chacha_setkey(tfm, key, keysize, 12);
 }
-EXPORT_SYMBOL_GPL(crypto_chacha12_setkey);
 
-int crypto_chacha_crypt(struct skcipher_request *req)
+static int crypto_chacha_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return chacha_stream_xor(req, ctx, req->iv);
 }
-EXPORT_SYMBOL_GPL(crypto_chacha_crypt);
 
-int crypto_xchacha_crypt(struct skcipher_request *req)
+static int crypto_xchacha_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -75,7 +66,7 @@ int crypto_xchacha_crypt(struct skcipher_request *req)
 	u8 real_iv[16];
 
 	/* Compute the subkey given the original key and first 128 nonce bits */
-	crypto_chacha_init(state, ctx, req->iv);
+	chacha_init_generic(state, ctx->key, req->iv);
 	hchacha_block_generic(state, subctx.key, ctx->nrounds);
 	subctx.nrounds = ctx->nrounds;
 
@@ -86,7 +77,6 @@ int crypto_xchacha_crypt(struct skcipher_request *req)
 	/* Generate the stream and XOR it with the data */
 	return chacha_stream_xor(req, &subctx, real_iv);
 }
-EXPORT_SYMBOL_GPL(crypto_xchacha_crypt);
 
 static struct skcipher_alg algs[] = {
 	{
diff --git a/include/crypto/internal/chacha.h b/include/crypto/internal/chacha.h
index 8724545bc959..194980d58174 100644
--- a/include/crypto/internal/chacha.h
+++ b/include/crypto/internal/chacha.h
@@ -12,8 +12,6 @@ struct chacha_ctx {
 	int nrounds;
 };
 
-void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv);
-
 static inline int chacha_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				unsigned int keysize, int nrounds)
 {
@@ -30,12 +28,4 @@ static inline int chacha_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return 0;
 }
 
-int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize);
-int crypto_chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			   unsigned int keysize);
-
-int crypto_chacha_crypt(struct skcipher_request *req);
-int crypto_xchacha_crypt(struct skcipher_request *req);
-
 #endif /* _CRYPTO_CHACHA_H */
-- 
2.20.1


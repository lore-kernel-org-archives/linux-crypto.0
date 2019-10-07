Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5D5ECE58E
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52D592070B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qsKpL//M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfJGQqg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36877 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbfJGQqg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:36 -0400
Received: by mail-wm1-f67.google.com with SMTP id f22so204433wmc.2
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2THynFjLIZu6DUZ0NDsK2MmHBOgVMYE3XCp8GCIntiA=;
        b=qsKpL//M2CeQOOSvxNK3f92C1JB8Q0B2ISuVeOT/mZAHeSwaKDxIEUO7qpoRD4ks1D
         oTF2VPl16TmNaAIfpuIHB7MXFv9LfG1f9BW78q9ct7U5etDnepQxuSd1RUmoVsYo7Mqq
         28ea0PgdaoaCx0yXkCucKD90YmXlwTNepeeT8dz/AZhJz+NzcqrFM/5zY761zPYAfBtX
         5yVF9LatNWtljPUOZw7DmHxjQD95GrrAzoRu87NC5o4JfCXTyWLBquRVp/EQpGc1spPg
         gdqAtZkQV46fA0SzpbTSaiIDpa5ZywfA/ggCsL0ihyxAKfVNJg96ZLaO8Cg7OygqAzZA
         cFlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2THynFjLIZu6DUZ0NDsK2MmHBOgVMYE3XCp8GCIntiA=;
        b=mq34sdJ6L94xjzG7mEXG6kmNqFmOrJw6DtQeNgT5toMCDL2Clwz37BpDFbLeeHFo0d
         132Cq9dDgr0wWUdpXb7Hm/UTy6XUZW0kepuaVHXqborFmsJxJb6LyGwCpqbTVPu0QYUD
         clTU4oAfJpTu8MQV/GN+pfhtuWbY4emvhk3W5AEL/iDCpnbu5/uAfIZdDFPeZ3gw/qCI
         PJEVC/cC4aiNcgHP9W7pk8zMk3/e99nz7ktS7nVawwA/DEnyrDKh1bAz/Q/ZeL5F0+Bq
         2otS7QR6HtHpLhELFuCpceUEhK8v0Sz+mVtFruvra9snQIrU4USeYXLuP52wEuyZrITl
         L8xA==
X-Gm-Message-State: APjAAAXgH1F3VeugVL8hJH+EdjLCNVVsb9DpbrgWWkF3QMNxCw8IASYv
        6ZcI6tu5hRS51VF4J0rILlSjrDgHQVStqg==
X-Google-Smtp-Source: APXvYqwPCwETIvRI6kxSiiQK5piP45cuOXuOpsR6s7KLRTSvmbZm5gAlPYdz4UrfqQ7gACtPl4IYuQ==
X-Received: by 2002:a05:600c:143:: with SMTP id w3mr162679wmm.17.1570466794328;
        Mon, 07 Oct 2019 09:46:34 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:33 -0700 (PDT)
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
        Rene van Dorst <opensource@vdorst.com>
Subject: [PATCH v3 11/29] crypto: chacha - unexport chacha_generic routines
Date:   Mon,  7 Oct 2019 18:45:52 +0200
Message-Id: <20191007164610.6881-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
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
 crypto/chacha_generic.c          | 28 +++++++++-----------
 include/crypto/internal/chacha.h | 10 -------
 2 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index ebae6d9d9b32..a794df0e5b70 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -12,6 +12,12 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/module.h>
 
+static void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx,
+			       const u8 *iv)
+{
+	chacha_init_generic(state, ctx->key, iv);
+}
+
 static int chacha_stream_xor(struct skcipher_request *req,
 			     const struct chacha_ctx *ctx, const u8 *iv)
 {
@@ -37,36 +43,27 @@ static int chacha_stream_xor(struct skcipher_request *req,
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
@@ -86,7 +83,6 @@ int crypto_xchacha_crypt(struct skcipher_request *req)
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


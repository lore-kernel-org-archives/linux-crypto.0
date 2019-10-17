Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0860ECE58E
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BADF921925
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QxveP7R0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503382AbfJQTJ7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:09:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42876 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503381AbfJQTJ7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:09:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id n14so3578914wrw.9
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=db2V0+timUMEhJuS4YSILq+YAa+36qRb2CN9ONVL3TM=;
        b=QxveP7R0JGkQ2SewJ0Hz6LqwrQbQgFZxj5sbvGawGplq8ArUM11jlX6mmPwwYJNzJx
         lNVBHHCl4IkDhaR/FHgjvzJiJA7sqk80/aIUZ1VUBMcnfyflN9ooiInwrnWGFVBu5tLy
         FUnX26alhTzCkA1Wpa4FmgKXYRT0geq5LpqSEu2VueUNy6j04JF7iwkaAjMngeuLYl0l
         G/8eEQfd7Yd+XYTMMr/7tz7Z3l7e8i9+Xofhn+/EqdBrpLDeyMMLPR1NLnlV2B6qcMcn
         T1cygGBgCZxDMTIPRKwYtHdU9bW5q5sYHvwgShXEA1cNvTmI4lFqZHCS7NcDmv8GPAgF
         32PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=db2V0+timUMEhJuS4YSILq+YAa+36qRb2CN9ONVL3TM=;
        b=dhIw1OYogvJimOUj/iWwiWd5Ut7tbNSqjrp8YMoX7mr5WdWjB6vd2mF00wTizIWwqO
         D2OjL/cSpZe4Pui9klRNj96xt9RD2PBy+FGGTSuLtjQvjDpvqrlqyL/UI8NGHrA2sbUe
         VexOpkdA0L/M9IrV0mHBwHuiRwBD7O6Qun3yBIHqLgAY0LoR1IOAW0YrjYTKlugrwYPB
         M3JKqM/2dbDALFdn2KYegr3vuJjBLXnAIyxwe/szkmENfg0GDdkRCFqCtvwaWE+9u2fm
         +4vaN/Z2oH0fFQXE9r8GR+1MGLNTxPxd7TB9FTSUM2UToxzAG/Q7FgDcajrYOKVbSCAZ
         5Vxg==
X-Gm-Message-State: APjAAAX3hkaw7W0REhgTMQArTsrPM5HPGqLkVNEDE4NAxWMHUZ9ag/4p
        n1wewMo1azYNr8HN5leV4A9CTw0o7PfKn10r
X-Google-Smtp-Source: APXvYqwuGexQXOQrY6TLwPxVMf033u4zd+D51I/rgISJSKabkZhjBeqZ9lTDhAY851uXsa272Hyy/A==
X-Received: by 2002:a5d:66cd:: with SMTP id k13mr4678814wrw.194.1571339395285;
        Thu, 17 Oct 2019 12:09:55 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.09.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:09:54 -0700 (PDT)
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
Subject: [PATCH v4 03/35] crypto: x86/chacha - depend on generic chacha library instead of crypto driver
Date:   Thu, 17 Oct 2019 21:09:00 +0200
Message-Id: <20191017190932.1947-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In preparation of extending the x86 ChaCha driver to also expose the ChaCha
library interface, drop the dependency on the chacha_generic crypto driver
as a non-SIMD fallback, and depend on the generic ChaCha library directly.
This way, we only pull in the code we actually need, without registering
a set of ChaCha skciphers that we will never use.

Since turning the FPU on and off is cheap these days, simplify the SIMD
routine by dropping the per-page yield, which makes for a cleaner switch
to the library API as well. This also allows use to invoke the skcipher
walk routines in non-atomic mode.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/chacha_glue.c | 98 +++++++++-----------
 crypto/Kconfig                |  2 +-
 2 files changed, 46 insertions(+), 54 deletions(-)

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index bc62daa8dafd..a264dcc64679 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -123,37 +123,38 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
-static int chacha_simd_stream_xor(struct skcipher_walk *walk,
+static int chacha_simd_stream_xor(struct skcipher_request *req,
 				  const struct chacha_ctx *ctx, const u8 *iv)
 {
 	u32 *state, state_buf[16 + 2] __aligned(8);
-	int next_yield = 4096; /* bytes until next FPU yield */
-	int err = 0;
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
 
 	BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
 	state = PTR_ALIGN(state_buf + 0, CHACHA_STATE_ALIGN);
 
-	crypto_chacha_init(state, ctx, iv);
+	chacha_init_generic(state, ctx->key, iv);
 
-	while (walk->nbytes > 0) {
-		unsigned int nbytes = walk->nbytes;
+	while (walk.nbytes > 0) {
+		unsigned int nbytes = walk.nbytes;
 
-		if (nbytes < walk->total) {
-			nbytes = round_down(nbytes, walk->stride);
-			next_yield -= nbytes;
-		}
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
 
-		chacha_dosimd(state, walk->dst.virt.addr, walk->src.virt.addr,
-			      nbytes, ctx->nrounds);
-
-		if (next_yield <= 0) {
-			/* temporarily allow preemption */
-			kernel_fpu_end();
+		if (!crypto_simd_usable()) {
+			chacha_crypt_generic(state, walk.dst.virt.addr,
+					     walk.src.virt.addr, nbytes,
+					     ctx->nrounds);
+		} else {
 			kernel_fpu_begin();
-			next_yield = 4096;
+			chacha_dosimd(state, walk.dst.virt.addr,
+				      walk.src.virt.addr, nbytes,
+				      ctx->nrounds);
+			kernel_fpu_end();
 		}
-
-		err = skcipher_walk_done(walk, walk->nbytes - nbytes);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
 	return err;
@@ -163,55 +164,46 @@ static int chacha_simd(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	int err;
-
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
-		return crypto_chacha_crypt(req);
 
-	err = skcipher_walk_virt(&walk, req, true);
-	if (err)
-		return err;
-
-	kernel_fpu_begin();
-	err = chacha_simd_stream_xor(&walk, ctx, req->iv);
-	kernel_fpu_end();
-	return err;
+	return chacha_simd_stream_xor(req, ctx, req->iv);
 }
 
 static int xchacha_simd(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	struct chacha_ctx subctx;
 	u32 *state, state_buf[16 + 2] __aligned(8);
+	struct chacha_ctx subctx;
 	u8 real_iv[16];
-	int err;
-
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
-		return crypto_xchacha_crypt(req);
-
-	err = skcipher_walk_virt(&walk, req, true);
-	if (err)
-		return err;
 
 	BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
 	state = PTR_ALIGN(state_buf + 0, CHACHA_STATE_ALIGN);
-	crypto_chacha_init(state, ctx, req->iv);
-
-	kernel_fpu_begin();
-
-	hchacha_block_ssse3(state, subctx.key, ctx->nrounds);
+	chacha_init_generic(state, ctx->key, req->iv);
+
+	if (req->cryptlen > CHACHA_BLOCK_SIZE && crypto_simd_usable()) {
+		kernel_fpu_begin();
+		hchacha_block_ssse3(state, subctx.key, ctx->nrounds);
+		kernel_fpu_end();
+	} else {
+		hchacha_block_generic(state, subctx.key, ctx->nrounds);
+	}
 	subctx.nrounds = ctx->nrounds;
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
 	memcpy(&real_iv[8], req->iv + 16, 8);
-	err = chacha_simd_stream_xor(&walk, &subctx, real_iv);
+	return chacha_simd_stream_xor(req, &subctx, real_iv);
+}
 
-	kernel_fpu_end();
+static int chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+		    unsigned int keysize)
+{
+	return chacha_setkey(tfm, key, keysize, 20);
+}
 
-	return err;
+static int chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
+		    unsigned int keysize)
+{
+	return chacha_setkey(tfm, key, keysize, 12);
 }
 
 static struct skcipher_alg algs[] = {
@@ -227,7 +219,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= chacha_simd,
 		.decrypt		= chacha_simd,
 	}, {
@@ -242,7 +234,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= xchacha_simd,
 		.decrypt		= xchacha_simd,
 	}, {
@@ -257,7 +249,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha12_setkey,
+		.setkey			= chacha12_setkey,
 		.encrypt		= xchacha_simd,
 		.decrypt		= xchacha_simd,
 	},
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 153cdefcbd78..9da4b67ac8e2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1417,7 +1417,7 @@ config CRYPTO_CHACHA20_X86_64
 	tristate "ChaCha stream cipher algorithms (x86_64/SSSE3/AVX2/AVX-512VL)"
 	depends on X86 && 64BIT
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_CHACHA20
+	select CRYPTO_LIB_CHACHA_GENERIC
 	help
 	  SSSE3, AVX2, and AVX-512VL optimized implementations of the ChaCha20,
 	  XChaCha20, and XChaCha12 stream ciphers.
-- 
2.20.1


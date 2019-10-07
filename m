Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D96ECE596
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D8FE2133F
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 16:46:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IEODKYqO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfJGQqY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 12:46:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43372 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbfJGQqX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 12:46:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id j18so15344283wrq.10
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2019 09:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wacjnu5s+UlDpKfDkG2erDF4AHgi0dg4fYncQyjWISM=;
        b=IEODKYqO1OXyor34Q+y4F1Rab1ZJ3bHIW9f/2T/VAOycnVkCsTtJo2xVEOl3w1M0NG
         yBfa6DO1sV4LZ6A4WBGwibsHBJDCHjrnmjTJbepB//17HViMrT082zaKkcxbmUn1/Qew
         f1zcEaJPj9FeZWt0wfvVoRyFjhur1zWLqzN8Bbgc4PmUz2hE/B/2fqmSjWueLfV089Jv
         9SxAua90+YJ3IPC79bPGJse/qpn9AtaejjHhDhxyYeHHRNpZ6QP7ha8RSHGAu5fo3MuE
         +WxxJGVPxycH7ez4vbNmpq0XB7G+ssun0odIeQ4/WBEBpuSAo5KTZppN5mkvV7zA/whK
         qiaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wacjnu5s+UlDpKfDkG2erDF4AHgi0dg4fYncQyjWISM=;
        b=pmqW1X1xozuP6j8TxC6/0DiAfYoJZ9pDXF0MG/RYxjHKSVVA+Wzb3nvEXZm2JV8Ye8
         0O0hHrTWs6Wa2MLdrcf/x4XOKAexLF3Kt//p3Qple2AJqNbfjseh0G4BBpauacUkOCk7
         hLEW4cEKR02gr0EP8jYkyM2edEXgAPLMxxWEXvN5CWKsjDzeQyJ84YtMT4AYgck7/D19
         llM5BhFI1uRa5aikK53IFd3gU8P96wP7AfJ3mgwx3DjN9BZ000luorQFBqaI97d0p9xz
         wyI5Wz2pH3lmqS4oWhThhiht83sIMamLc4AAYsZ3kl8Pfyb6Qkinh/ZULtdkEal0xrsO
         gacA==
X-Gm-Message-State: APjAAAXNhGJVUuoSMrVo3QemU+L3AOxkBAn2ULld/tDzqsKmTNwRBri2
        GJCFTd72nzFXMLmBtci3zd8lqfYac/6vbQ==
X-Google-Smtp-Source: APXvYqy7MHvAHIXegekW3EFvqSyoj+C7+UWqVuxeu3Q1IBE2wF0I6PZ+ZTKTU5OO6mOdp/1DdNU+tA==
X-Received: by 2002:adf:8163:: with SMTP id 90mr19685075wrm.129.1570466781821;
        Mon, 07 Oct 2019 09:46:21 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id b22sm68507wmj.36.2019.10.07.09.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 09:46:21 -0700 (PDT)
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
Subject: [PATCH v3 02/29] crypto: x86/chacha - depend on generic chacha library instead of crypto driver
Date:   Mon,  7 Oct 2019 18:45:43 +0200
Message-Id: <20191007164610.6881-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
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
to the library API as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/chacha_glue.c | 77 ++++++++++----------
 crypto/Kconfig                |  2 +-
 2 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index bc62daa8dafd..3a1a11a4326d 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -127,32 +127,32 @@ static int chacha_simd_stream_xor(struct skcipher_walk *walk,
 				  const struct chacha_ctx *ctx, const u8 *iv)
 {
 	u32 *state, state_buf[16 + 2] __aligned(8);
-	int next_yield = 4096; /* bytes until next FPU yield */
+	bool do_simd;
 	int err = 0;
 
 	BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
 	state = PTR_ALIGN(state_buf + 0, CHACHA_STATE_ALIGN);
 
-	crypto_chacha_init(state, ctx, iv);
+	chacha_init_generic(state, ctx->key, iv);
 
+	do_simd = (walk->total > CHACHA_BLOCK_SIZE) && crypto_simd_usable();
 	while (walk->nbytes > 0) {
 		unsigned int nbytes = walk->nbytes;
 
-		if (nbytes < walk->total) {
+		if (nbytes < walk->total)
 			nbytes = round_down(nbytes, walk->stride);
-			next_yield -= nbytes;
-		}
-
-		chacha_dosimd(state, walk->dst.virt.addr, walk->src.virt.addr,
-			      nbytes, ctx->nrounds);
 
-		if (next_yield <= 0) {
-			/* temporarily allow preemption */
-			kernel_fpu_end();
+		if (!do_simd) {
+			chacha_crypt_generic(state, walk->dst.virt.addr,
+					     walk->src.virt.addr, nbytes,
+					     ctx->nrounds);
+		} else {
 			kernel_fpu_begin();
-			next_yield = 4096;
+			chacha_dosimd(state, walk->dst.virt.addr,
+				      walk->src.virt.addr, nbytes,
+				      ctx->nrounds);
+			kernel_fpu_end();
 		}
-
 		err = skcipher_walk_done(walk, walk->nbytes - nbytes);
 	}
 
@@ -164,19 +164,9 @@ static int chacha_simd(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
-	int err;
 
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
-		return crypto_chacha_crypt(req);
-
-	err = skcipher_walk_virt(&walk, req, true);
-	if (err)
-		return err;
-
-	kernel_fpu_begin();
-	err = chacha_simd_stream_xor(&walk, ctx, req->iv);
-	kernel_fpu_end();
-	return err;
+	return skcipher_walk_virt(&walk, req, true) ?:
+	       chacha_simd_stream_xor(&walk, ctx, req->iv);
 }
 
 static int xchacha_simd(struct skcipher_request *req)
@@ -189,31 +179,42 @@ static int xchacha_simd(struct skcipher_request *req)
 	u8 real_iv[16];
 	int err;
 
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
-		return crypto_xchacha_crypt(req);
-
 	err = skcipher_walk_virt(&walk, req, true);
 	if (err)
 		return err;
 
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
 	err = chacha_simd_stream_xor(&walk, &subctx, real_iv);
 
-	kernel_fpu_end();
-
 	return err;
 }
 
+static int chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
+		    unsigned int keysize)
+{
+	return chacha_setkey(tfm, key, keysize, 20);
+}
+
+static int chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
+		    unsigned int keysize)
+{
+	return chacha_setkey(tfm, key, keysize, 12);
+}
+
 static struct skcipher_alg algs[] = {
 	{
 		.base.cra_name		= "chacha20",
@@ -227,7 +228,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= chacha_simd,
 		.decrypt		= chacha_simd,
 	}, {
@@ -242,7 +243,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= xchacha_simd,
 		.decrypt		= xchacha_simd,
 	}, {
@@ -257,7 +258,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha12_setkey,
+		.setkey			= chacha12_setkey,
 		.encrypt		= xchacha_simd,
 		.decrypt		= xchacha_simd,
 	},
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b39ca79ef65f..86732709b171 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1439,7 +1439,7 @@ config CRYPTO_CHACHA20_X86_64
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


Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEDBFC6196
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69E952245A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215791;
	bh=k3fbYCO1DU67T1JhgJSlKCZM9zw8Y0KzD9MS1ntJ3eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hiS3Y9oqZOV+S9soKLQ+PabZKfqyLhyF5RbZNr5rMR6XY4T5t/qtWbPVt8NC1R7fk
	 057U9UqwqYkGEW53i2nz7VJ3h2wZ/u7NjLH970ARxZHy64obvmsVmsKSTV0Tc++DTO
	 RGkZ1bQ9VHisaGMBnfQUFGWJpmP1aJ4cYokjM/hc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbfKHMXK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:23:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfKHMXK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:10 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF1E21D7B;
        Fri,  8 Nov 2019 12:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215789;
        bh=k3fbYCO1DU67T1JhgJSlKCZM9zw8Y0KzD9MS1ntJ3eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGv4OJ7oMZVPPis2jj+WobLE8wfRG3m/EIUAh6Z3/K4tx++yNV6WMSox+pRvs8xcJ
         v5JWPZ/JLlTH0T19c5Bl1QCLgxpMZPfN3Euk+8zU06Q3oqr6J0FMNEzoxvVlyg48nm
         Rsi4L9n9HmhxwD9CqErplhgVC+leYlqW72Cgui6k=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 03/34] crypto: x86/chacha - depend on generic chacha library instead of crypto driver
Date:   Fri,  8 Nov 2019 13:22:09 +0100
Message-Id: <20191108122240.28479-4-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
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

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/chacha_glue.c | 90 ++++++++------------
 crypto/Kconfig                |  2 +-
 2 files changed, 36 insertions(+), 56 deletions(-)

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index bc62daa8dafd..0aabb382edce 100644
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
@@ -163,55 +164,34 @@ static int chacha_simd(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
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
-
-	kernel_fpu_end();
-
-	return err;
+	return chacha_simd_stream_xor(req, &subctx, real_iv);
 }
 
 static struct skcipher_alg algs[] = {
@@ -227,7 +207,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= chacha_simd,
 		.decrypt		= chacha_simd,
 	}, {
@@ -242,7 +222,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha20_setkey,
+		.setkey			= chacha20_setkey,
 		.encrypt		= xchacha_simd,
 		.decrypt		= xchacha_simd,
 	}, {
@@ -257,7 +237,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= crypto_chacha12_setkey,
+		.setkey			= chacha12_setkey,
 		.encrypt		= xchacha_simd,
 		.decrypt		= xchacha_simd,
 	},
diff --git a/crypto/Kconfig b/crypto/Kconfig
index ae4495ae003f..1abca30ed6ae 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1436,7 +1436,7 @@ config CRYPTO_CHACHA20_X86_64
 	tristate "ChaCha stream cipher algorithms (x86_64/SSSE3/AVX2/AVX-512VL)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
-	select CRYPTO_CHACHA20
+	select CRYPTO_LIB_CHACHA_GENERIC
 	help
 	  SSSE3, AVX2, and AVX-512VL optimized implementations of the ChaCha20,
 	  XChaCha20, and XChaCha12 stream ciphers.
-- 
2.20.1


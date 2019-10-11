Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C744ECE58C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 06:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0300E21D56
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 06:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570775501;
	bh=dXE9W93OuXrFNXnjyGrExhX3jrJnaZbtiWVRA5dF2nM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sNP4oij40etVruZb3Mti6xyO+OgZlY9/f8jJjulCQOjlThaaRTJrozOdYVDyQDJO1
	 w+8ouMTniWmccQPrxghPjSgOlnwwaVpKTkd43TYko4ucfpMGBe5YmP+6taQTx8kFx5
	 4fzp0oYfNRhh/lxJ04h7mOJE2dRlytDSO/WaKbfQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfJKGbk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 02:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfJKGbj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 02:31:39 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1308B214E0;
        Fri, 11 Oct 2019 06:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570775498;
        bh=dXE9W93OuXrFNXnjyGrExhX3jrJnaZbtiWVRA5dF2nM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YYBZ0Q/UCoZkfMjoNVI85I9NzgtrgCEGw0BdIGtOjalJ+k4ZzWRQOtNzWzrEzYJdq
         7t9iqaQCTcEwiBEwb86FWqOa5Spgsqj6qNPoLlbCojB5RbzuPRucoHsqq8n8spi/Tm
         WCacfm1SQMJblCXANmsRWew63HHkEHc3K/qiwEk4=
Date:   Thu, 10 Oct 2019 23:31:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH v3 07/29] crypto: arm/chacha - remove dependency on
 generic ChaCha driver
Message-ID: <20191011063136.GF23882@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-8-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007164610.6881-8-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 07, 2019 at 06:45:48PM +0200, Ard Biesheuvel wrote:
> +static int chacha_stream_xor(struct skcipher_request *req,
> +			     const struct chacha_ctx *ctx, const u8 *iv)
> +{
> +	struct skcipher_walk walk;
> +	u32 state[16];
> +	int err;
> +
> +	err = skcipher_walk_virt(&walk, req, false);
> +
> +	chacha_init_generic(state, ctx->key, iv);
> +
> +	while (walk.nbytes > 0) {
> +		unsigned int nbytes = walk.nbytes;
> +
> +		if (nbytes < walk.total)
> +			nbytes = round_down(nbytes, walk.stride);
> +
> +		chacha_doarm(walk.dst.virt.addr, walk.src.virt.addr,
> +			     nbytes, state, ctx->nrounds);
> +		state[12] += DIV_ROUND_UP(nbytes, CHACHA_BLOCK_SIZE);
> +		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
> +	}
> +
> +	return err;
> +}
> +
> +static int chacha_arm(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> +
> +	return chacha_stream_xor(req, ctx, req->iv);
> +}
> +
> +static int chacha_neon_stream_xor(struct skcipher_request *req,
> +				  const struct chacha_ctx *ctx, const u8 *iv)
> +{
> +	struct skcipher_walk walk;
> +	u32 state[16];
> +	bool do_neon;
> +	int err;
> +
> +	err = skcipher_walk_virt(&walk, req, false);
> +
> +	chacha_init_generic(state, ctx->key, iv);
> +
> +	do_neon = (req->cryptlen > CHACHA_BLOCK_SIZE) && crypto_simd_usable();
> +	while (walk.nbytes > 0) {
> +		unsigned int nbytes = walk.nbytes;
> +
> +		if (nbytes < walk.total)
> +			nbytes = round_down(nbytes, walk.stride);
> +
> +		if (!do_neon) {
> +			chacha_doarm(walk.dst.virt.addr, walk.src.virt.addr,
> +				     nbytes, state, ctx->nrounds);
> +			state[12] += DIV_ROUND_UP(nbytes, CHACHA_BLOCK_SIZE);
> +		} else {
> +			kernel_neon_begin();
> +			chacha_doneon(state, walk.dst.virt.addr,
> +				      walk.src.virt.addr, nbytes, ctx->nrounds);
> +			kernel_neon_end();
> +		}
> +		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
> +	}
> +
> +	return err;
> +}
> +
> +static int chacha_neon(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> +
> +	return chacha_neon_stream_xor(req, ctx, req->iv);
> +}
> +
> +static int xchacha_arm(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct chacha_ctx subctx;
> +	u32 state[16];
> +	u8 real_iv[16];
> +
> +	chacha_init_generic(state, ctx->key, req->iv);
> +
> +	hchacha_block_arm(state, subctx.key, ctx->nrounds);
> +	subctx.nrounds = ctx->nrounds;
> +
> +	memcpy(&real_iv[0], req->iv + 24, 8);
> +	memcpy(&real_iv[8], req->iv + 16, 8);
> +	return chacha_stream_xor(req, &subctx, real_iv);
> +}
> +
> +static int xchacha_neon(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct chacha_ctx subctx;
> +	u32 state[16];
> +	u8 real_iv[16];
> +
> +	chacha_init_generic(state, ctx->key, req->iv);
> +
> +	if (!crypto_simd_usable()) {
> +		hchacha_block_arm(state, subctx.key, ctx->nrounds);
> +	} else {
> +		kernel_neon_begin();
> +		hchacha_block_neon(state, subctx.key, ctx->nrounds);
> +		kernel_neon_end();
> +	}
> +	subctx.nrounds = ctx->nrounds;
> +
> +	memcpy(&real_iv[0], req->iv + 24, 8);
> +	memcpy(&real_iv[8], req->iv + 16, 8);
> +	return chacha_neon_stream_xor(req, &subctx, real_iv);
> +}

There is some code duplication here: two implementations of stream_xor, and two
implementations of xchacha (hchacha + stream_xor).  How about doing something
like the following?

diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index dae69a63b640..1952cbda2168 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -32,6 +32,11 @@ asmlinkage void chacha_doarm(u8 *dst, const u8 *src, unsigned int bytes,
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(use_neon);
 
+static inline bool neon_usable(void)
+{
+	return static_branch_likely(&use_neon) && crypto_simd_usable();
+}
+
 static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
 			  unsigned int bytes, int nrounds)
 {
@@ -95,7 +100,8 @@ void chacha_crypt(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 EXPORT_SYMBOL(chacha_crypt);
 
 static int chacha_stream_xor(struct skcipher_request *req,
-			     const struct chacha_ctx *ctx, const u8 *iv)
+			     const struct chacha_ctx *ctx, const u8 *iv,
+			     bool neon)
 {
 	struct skcipher_walk walk;
 	u32 state[16];
@@ -105,49 +111,14 @@ static int chacha_stream_xor(struct skcipher_request *req,
 
 	chacha_init_generic(state, ctx->key, iv);
 
+	neon &= (req->cryptlen > CHACHA_BLOCK_SIZE);
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
 
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
 
-		chacha_doarm(walk.dst.virt.addr, walk.src.virt.addr,
-			     nbytes, state, ctx->nrounds);
-		state[12] += DIV_ROUND_UP(nbytes, CHACHA_BLOCK_SIZE);
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
-
-	return err;
-}
-
-static int chacha_arm(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return chacha_stream_xor(req, ctx, req->iv);
-}
-
-static int chacha_neon_stream_xor(struct skcipher_request *req,
-				  const struct chacha_ctx *ctx, const u8 *iv)
-{
-	struct skcipher_walk walk;
-	u32 state[16];
-	bool do_neon;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	chacha_init_generic(state, ctx->key, iv);
-
-	do_neon = (req->cryptlen > CHACHA_BLOCK_SIZE) && crypto_simd_usable();
-	while (walk.nbytes > 0) {
-		unsigned int nbytes = walk.nbytes;
-
-		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, walk.stride);
-
-		if (!static_branch_likely(&use_neon) || !do_neon) {
+		if (!neon) {
 			chacha_doarm(walk.dst.virt.addr, walk.src.virt.addr,
 				     nbytes, state, ctx->nrounds);
 			state[12] += DIV_ROUND_UP(nbytes, CHACHA_BLOCK_SIZE);
@@ -163,33 +134,25 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
 	return err;
 }
 
-static int chacha_neon(struct skcipher_request *req)
+static int do_chacha(struct skcipher_request *req, bool neon)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return chacha_neon_stream_xor(req, ctx, req->iv);
+	return chacha_stream_xor(req, ctx, req->iv, neon);
 }
 
-static int xchacha_arm(struct skcipher_request *req)
+static int chacha_arm(struct skcipher_request *req)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct chacha_ctx subctx;
-	u32 state[16];
-	u8 real_iv[16];
-
-	chacha_init_generic(state, ctx->key, req->iv);
-
-	hchacha_block_arm(state, subctx.key, ctx->nrounds);
-	subctx.nrounds = ctx->nrounds;
+	return do_chacha(req, false);
+}
 
-	memcpy(&real_iv[0], req->iv + 24, 8);
-	memcpy(&real_iv[8], req->iv + 16, 8);
-	return chacha_stream_xor(req, &subctx, real_iv);
+static int chacha_neon(struct skcipher_request *req)
+{
+	return do_chacha(req, neon_usable());
 }
 
-static int xchacha_neon(struct skcipher_request *req)
+static int do_xchacha(struct skcipher_request *req, bool neon)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -199,7 +162,7 @@ static int xchacha_neon(struct skcipher_request *req)
 
 	chacha_init_generic(state, ctx->key, req->iv);
 
-	if (!static_branch_likely(&use_neon) || !crypto_simd_usable()) {
+	if (!neon) {
 		hchacha_block_arm(state, subctx.key, ctx->nrounds);
 	} else {
 		kernel_neon_begin();
@@ -210,7 +173,17 @@ static int xchacha_neon(struct skcipher_request *req)
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
 	memcpy(&real_iv[8], req->iv + 16, 8);
-	return chacha_neon_stream_xor(req, &subctx, real_iv);
+	return chacha_stream_xor(req, &subctx, real_iv, neon);
+}
+
+static int xchacha_arm(struct skcipher_request *req)
+{
+	return do_xchacha(req, false);
+}
+
+static int xchacha_neon(struct skcipher_request *req)
+{
+	return do_xchacha(req, neon_usable());
 }
 
 static int chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,

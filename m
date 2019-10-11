Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8E9ECE58C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 06:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B543121D56
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 06:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570773632;
	bh=avNLJbT2XY9f9KNjuyotgP7R/3HSQTx/Nt/IZKW7Dmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=d0Vcp0CBkv+fckmp4j0MCVUr5/O1sqjGmYc/eixYBKfMxRSfH4kQt75mBdbUp1LB5
	 GUb3VrwN+1dguKf/L5DDQHdR1YHTJl/zphiCMyTr4n5g5Y53cowDFwldJtrI3LIR2p
	 QKpUiIKFDbI3o+apZ2ggoTg/y1Tze2C9rmVWs8zg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfJKGAb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 02:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbfJKGAb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 02:00:31 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0836C214E0;
        Fri, 11 Oct 2019 06:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570773630;
        bh=avNLJbT2XY9f9KNjuyotgP7R/3HSQTx/Nt/IZKW7Dmc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FzLgxn9DYJE/xCWQMAeCehnCuSKHj9PoKQ1956eUUKTJ4+cWJEmyiBQuWXH6JtlnQ
         68aKzJyOoIWGRHZoNXBmTSpcYXtkXG8GLNpt+ldrsnXufP+it9sy+acJbFLX4HuxnR
         UaYB1h1Ea2k50n7cdi/g8+NVpA52aMO8/x24N4WE=
Date:   Thu, 10 Oct 2019 23:00:28 -0700
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
Subject: Re: [PATCH v3 02/29] crypto: x86/chacha - depend on generic chacha
 library instead of crypto driver
Message-ID: <20191011060028.GA23882@sol.localdomain>
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
 <20191007164610.6881-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007164610.6881-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 07, 2019 at 06:45:43PM +0200, Ard Biesheuvel wrote:
> In preparation of extending the x86 ChaCha driver to also expose the ChaCha
> library interface, drop the dependency on the chacha_generic crypto driver
> as a non-SIMD fallback, and depend on the generic ChaCha library directly.
> This way, we only pull in the code we actually need, without registering
> a set of ChaCha skciphers that we will never use.
> 
> Since turning the FPU on and off is cheap these days, simplify the SIMD
> routine by dropping the per-page yield, which makes for a cleaner switch
> to the library API as well.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/x86/crypto/chacha_glue.c | 77 ++++++++++----------
>  crypto/Kconfig                |  2 +-
>  2 files changed, 40 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
> index bc62daa8dafd..3a1a11a4326d 100644
> --- a/arch/x86/crypto/chacha_glue.c
> +++ b/arch/x86/crypto/chacha_glue.c
> @@ -127,32 +127,32 @@ static int chacha_simd_stream_xor(struct skcipher_walk *walk,
>  				  const struct chacha_ctx *ctx, const u8 *iv)
>  {
>  	u32 *state, state_buf[16 + 2] __aligned(8);
> -	int next_yield = 4096; /* bytes until next FPU yield */
> +	bool do_simd;
>  	int err = 0;
>  
>  	BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
>  	state = PTR_ALIGN(state_buf + 0, CHACHA_STATE_ALIGN);
>  
> -	crypto_chacha_init(state, ctx, iv);
> +	chacha_init_generic(state, ctx->key, iv);
>  
> +	do_simd = (walk->total > CHACHA_BLOCK_SIZE) && crypto_simd_usable();
>  	while (walk->nbytes > 0) {
>  		unsigned int nbytes = walk->nbytes;
>  
> -		if (nbytes < walk->total) {
> +		if (nbytes < walk->total)
>  			nbytes = round_down(nbytes, walk->stride);
> -			next_yield -= nbytes;
> -		}
> -
> -		chacha_dosimd(state, walk->dst.virt.addr, walk->src.virt.addr,
> -			      nbytes, ctx->nrounds);
>  
> -		if (next_yield <= 0) {
> -			/* temporarily allow preemption */
> -			kernel_fpu_end();
> +		if (!do_simd) {
> +			chacha_crypt_generic(state, walk->dst.virt.addr,
> +					     walk->src.virt.addr, nbytes,
> +					     ctx->nrounds);
> +		} else {
>  			kernel_fpu_begin();
> -			next_yield = 4096;
> +			chacha_dosimd(state, walk->dst.virt.addr,
> +				      walk->src.virt.addr, nbytes,
> +				      ctx->nrounds);
> +			kernel_fpu_end();

Since the kernel_fpu_begin() and kernel_fpu_end() were moved here, it's now
possible to simplify the code by moving the call to skcipher_walk_virt() into
chacha_simd_stream_xor() rather than making the caller do it.

I.e., see what the code was like prior to the following commit:

	commit f9c9bdb5131eee60dc3b92e5126d4c0e291703e2
	Author: Eric Biggers <ebiggers@google.com>
	Date:   Sat Dec 15 12:40:17 2018 -0800

	    crypto: x86/chacha - avoid sleeping under kernel_fpu_begin()

>  		}
> -
>  		err = skcipher_walk_done(walk, walk->nbytes - nbytes);
>  	}
>  
> @@ -164,19 +164,9 @@ static int chacha_simd(struct skcipher_request *req)
>  	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>  	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
>  	struct skcipher_walk walk;
> -	int err;
>  
> -	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
> -		return crypto_chacha_crypt(req);
> -
> -	err = skcipher_walk_virt(&walk, req, true);
> -	if (err)
> -		return err;
> -
> -	kernel_fpu_begin();
> -	err = chacha_simd_stream_xor(&walk, ctx, req->iv);
> -	kernel_fpu_end();
> -	return err;
> +	return skcipher_walk_virt(&walk, req, true) ?:
> +	       chacha_simd_stream_xor(&walk, ctx, req->iv);
>  }
>  
>  static int xchacha_simd(struct skcipher_request *req)
> @@ -189,31 +179,42 @@ static int xchacha_simd(struct skcipher_request *req)
>  	u8 real_iv[16];
>  	int err;
>  
> -	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
> -		return crypto_xchacha_crypt(req);
> -
>  	err = skcipher_walk_virt(&walk, req, true);
>  	if (err)
>  		return err;
>  
>  	BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
>  	state = PTR_ALIGN(state_buf + 0, CHACHA_STATE_ALIGN);
> -	crypto_chacha_init(state, ctx, req->iv);
> -
> -	kernel_fpu_begin();
> -
> -	hchacha_block_ssse3(state, subctx.key, ctx->nrounds);
> +	chacha_init_generic(state, ctx->key, req->iv);
> +
> +	if (req->cryptlen > CHACHA_BLOCK_SIZE && crypto_simd_usable()) {
> +		kernel_fpu_begin();
> +		hchacha_block_ssse3(state, subctx.key, ctx->nrounds);
> +		kernel_fpu_end();
> +	} else {
> +		hchacha_block_generic(state, subctx.key, ctx->nrounds);
> +	}
>  	subctx.nrounds = ctx->nrounds;
>  
>  	memcpy(&real_iv[0], req->iv + 24, 8);
>  	memcpy(&real_iv[8], req->iv + 16, 8);
>  	err = chacha_simd_stream_xor(&walk, &subctx, real_iv);
>  
> -	kernel_fpu_end();
> -
>  	return err;

Can use 'return chacha_simd_stream_xor(...') here.

- Eric

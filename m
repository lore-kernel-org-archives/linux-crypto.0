Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB991864C
	for <linux-crypto@vger.kernel.org>; Wed, 14 Feb 2024 23:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707954114; cv=none; b=nDTvwKR0LoKix9h3Z6ivjHaiPtkOqCTDaOBKVo2HhXPMXi+2lmrsc+hju4xwC3kF2d3MXOnuXi2DT71DoKHDJ5l6S8x4Ph4/BL57tKrl2xj/yLq8UFUU1aSG+nkhjx3T1p81/1yD74z7+nsQLgcOgka3uLmTCqBndZOshAmX/jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707954114; c=relaxed/simple;
	bh=CEb7IBHx+fjusQQcE8apVrNp83EBkkAjWwir31Bc96Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CsFpJ4QxPih9nNJOGaaAfRNhpA6+0fRoo0GFqOP3mJWmPYX9ygT+iIb97bQ+UFheKfHnWaRBX1mSc3XuzwomV5OY9BUNo3AxkNQFVzTtsGcUBKD67o5y9M7qnPaHLoB0TA3Z7ZdvHiIyWi5Dwg7W6WGbwSVdpWdHPhZROOD8WRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WtbdFJe8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WtbdFJe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B11C433C7;
	Wed, 14 Feb 2024 23:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707954113;
	bh=CEb7IBHx+fjusQQcE8apVrNp83EBkkAjWwir31Bc96Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WtbdFJe8M9eTIYkkR8eeyYnwPV44QBQjaIvcpB0Oy99auSOYUfCqYA/REFb02mdYO
	 /JHAyoB8P/ejLDK2Clea2vUd3QdzkiGQAyKhpk6cq0pd8XwehKeoagr18f+qq60uxp
	 GklWnAPeVxQju9EdkvBFFR30N6CriRYyTI+NhtbIl0LhQdN04+xksd1rKu5+T8rLj1
	 4ID3bNmfrPGdkyifwe+1tCZh4rC8pd7QiH7WvkdBF126BTMAs2co1jl4AUU78qZNIo
	 gpoatCfFlYUuWAcxRaV3XS3lMG+u4csbyBAM5i+7bJsaYOPfIspRlAvIL2ro3DzJiJ
	 xu/o5b3UFciTg==
Date: Wed, 14 Feb 2024 15:41:51 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 09/15] crypto: chacha-generic - Convert from skcipher to
 lskcipher
Message-ID: <20240214234151.GE1638@sol.localdomain>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <1585df67b3f356eba2c23ac9f36c7181432d191e.1707815065.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585df67b3f356eba2c23ac9f36c7181432d191e.1707815065.git.herbert@gondor.apana.org.au>

On Wed, Dec 06, 2023 at 01:49:32PM +0800, Herbert Xu wrote:
> +static int chacha_stream_xor(const struct chacha_ctx *ctx, const u8 *src,
> +			     u8 *dst, unsigned nbytes, u8 *siv, u32 flags)

In cryptography, siv normally stands for Synthetic Initialization Vector.  I
*think* that here you're having it stand for "state and IV", or something like
that.  Is there a better name for it?  Maybe it should just be state?

> -static int crypto_xchacha_crypt(struct skcipher_request *req)
> +static int crypto_xchacha_crypt(struct crypto_lskcipher *tfm, const u8 *src,
> +				u8 *dst, unsigned nbytes, u8 *siv, u32 flags)
>  {
> -	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> -	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct chacha_ctx *ctx = crypto_lskcipher_ctx(tfm);
>  	struct chacha_ctx subctx;
> -	u32 state[16];
> -	u8 real_iv[16];
> +	u8 *real_iv;
> +	u32 *state;
>  
> -	/* Compute the subkey given the original key and first 128 nonce bits */
> -	chacha_init_generic(state, ctx->key, req->iv);
> -	hchacha_block_generic(state, subctx.key, ctx->nrounds);
> +	real_iv = siv + XCHACHA_IV_SIZE;
> +	state = (u32 *)(real_iv + CHACHA_IV_SIZE);

So the "siv" contains xchacha_iv || real_iv || state?  That's 112 bytes, which
is more than the 80 that's allocated for it.

Isn't the state the only thing that actually needs to be carried forward?

- Eric

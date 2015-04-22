From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add key wrapping block chaining mode
Date: Wed, 22 Apr 2015 13:48:46 +0800
Message-ID: <20150422054846.GA7804@gondor.apana.org.au>
References: <6218629.uO4632Hmli@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44859 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbbDVFsv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 01:48:51 -0400
Content-Disposition: inline
In-Reply-To: <6218629.uO4632Hmli@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 22, 2015 at 06:36:59AM +0200, Stephan Mueller wrote:
>
> +static int crypto_kw_decrypt(struct aead_request *req)
> +{
> +	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> +	struct crypto_kw_ctx *ctx = crypto_aead_ctx(aead);
> +	struct crypto_cipher *tfm = ctx->child;
> +	unsigned long alignmask = crypto_cipher_alignmask(tfm);
> +	unsigned int src_nbytes, dst_nbytes, i;
> +	struct scatter_walk src_walk, dst_walk;
> +	struct crypto_kw_block block;

Why isn't this aligned like tbe_buffer?

> +	u8 tmpblock[SEMIBSIZE];
> +	u64 t = 6 * ((req->cryptlen - SEMIBSIZE) >> 3);
> +	int ret = -EAGAIN;
> +	struct scatterlist src, dst;
> +	/* IV of KW defined by section 6.2 */
> +	u8 *default_iv = "\xA6\xA6\xA6\xA6\xA6\xA6\xA6\xA6";
> +	unsigned int outcryptlen = req->cryptlen - SEMIBSIZE;
> +
> +	/*
> +	 * Require at least 3 semiblocks as defined in SP800-38F and ensure
> +	 * that the given data is aligned to semiblock.
> +	 */
> +	if (req->cryptlen < (3 * SEMIBSIZE) || req->cryptlen % 8)
> +		return -EINVAL;
> +
> +	/*
> +	 * src scatterlist is read only. dst scatterlist is r/w. During the
> +	 * first loop, src points to req->src and dst to req->dst. For any
> +	 * subsequent round, the code operates on req->dst only.
> +	 */
> +	crypto_kw_copy_scatterlist(req->src, &src);
> +	crypto_kw_copy_scatterlist(req->dst, &dst);
> +
> +	for (i = 0; i < 6; i++) {
> +		u8 tbe_buffer[SEMIBSIZE + alignmask];
> +		/* alignment for the crypto_xor operation */

You're setting alignmask to that of the child transform, which
may have no requirements on alignment at all.  So you need to
ensure that it's at least 4-byte aligned for crypto_xor.

> +	inst->alg.cra_alignmask = alg->cra_alignmask | (__alignof__(u64) - 1);

Where does this 8-byte alignment requirement come from?

You also never actually pass any input data directly to the child,
except for the key so you don't need to specify the child's alignment
here at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 3/3] crypto: talitos - add hash algorithms
Date: Thu, 29 Apr 2010 22:07:51 -0500
Message-ID: <20100429220751.224037c0.kim.phillips@freescale.com>
References: <4bd82b34.0e0bca0a.475e.ffffa572@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:35334 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0EAHAG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 May 2010 03:00:06 -0400
Received: from az33smr01.freescale.net (az33smr01.freescale.net [10.64.34.199])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id o3U2tE3m024082
	for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2010 19:55:14 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net [10.64.32.10])
	by az33smr01.freescale.net (8.13.1/8.13.0) with ESMTP id o3U33d55004870
	for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2010 22:03:39 -0500 (CDT)
In-Reply-To: <4bd82b34.0e0bca0a.475e.ffffa572@mx.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 28 Apr 2010 05:33:56 -0700
<lee.nipper@gmail.com> wrote:

> Add the following alorithms to talitos:
>     md5,
>     sha1,
>     sha256,
>     sha384,
>     sha512.
> These are all type ahash.

sha224 is left as an exercise for the reader, I see ;)

> It has been tested successfully on MPC8349E.

curious, is that an 8349E/sec2.1 or 8349EA/sec2.4?

> It needs a load on a board with SEC 3.x (hint hint).

loaded on an fsl,sec3.0 (8572) - all selftests passed.

> +const struct talitos_ptr zero_entry = {

  CHECK   drivers/crypto/talitos.c
drivers/crypto/talitos.c:71:26: warning: symbol 'zero_entry' was not declared. Should it be static?

> -	edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
> +	if (dma_len)
> +		edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
>  					     edesc->dma_len, DMA_BIDIRECTIONAL);

broken indentation. 

> +	/* HMAC key */
> +	if (ctx->keylen)
> +		map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
> +				       (char *)&ctx->key, 0, DMA_TO_DEVICE);
> +	else {
> +		desc->ptr[2] = zero_entry;
> +	}

unnecessary braces.

> +	if (!req_ctx->last && (index + nbytes) < blocksize) {
> +		/* Buffer the partial block */
> +		sg_copy_to_buffer(areq->src,
> +				  sg_count(areq->src, nbytes, &chained),
> +				  req_ctx->buf + index, nbytes);
> +	} else {
> +		if (index) {
> +			/* partial block from previous update; chain it in. */
> +			sg_init_table(req_ctx->bufsl, (nbytes) ? 2 : 1);
> +			sg_set_buf(req_ctx->bufsl, req_ctx->buf, index);
> +			if (nbytes)
> +				scatterwalk_sg_chain(req_ctx->bufsl, 2,
> +						     areq->src);
> +			req_ctx->psrc = req_ctx->bufsl;
> +		} else {
> +			req_ctx->psrc = areq->src;
> +		}
> +		nbytes_to_hash =  index + nbytes;
> +		if (!req_ctx->last) {
> +			to_hash_later = (nbytes_to_hash & (blocksize - 1));
> +			if (to_hash_later) {
> +				int nents;
> +				/* Must copy to_hash_later bytes from the end
> +				 * to bufnext (a partial block) for later.
> +				 */
> +				nents = sg_count(areq->src, nbytes, &chained);
> +				sg_copy_end_to_buffer(areq->src, nents,
> +						      req_ctx->bufnext,
> +						      to_hash_later,
> +						      nbytes - to_hash_later);
> +
> +				/* Adjust count for what will be hashed now */
> +				nbytes_to_hash -= to_hash_later;
> +			}
> +			req_ctx->to_hash_later = to_hash_later;
> +		}
> +
> +		/* allocate extended descriptor */
> +		edesc = ahash_edesc_alloc(areq, nbytes_to_hash);
> +		if (IS_ERR(edesc))
> +			return PTR_ERR(edesc);
> +
> +		edesc->desc.hdr = ctx->desc_hdr_template;
> +
> +		/* On last one, request SEC to pad; otherwise continue */
> +		if (req_ctx->last)
> +			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
> +		else
> +			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
> +
> +		/* On first one, request SEC to INIT hash. */
> +		if (req_ctx->first)
> +			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
> +

> +		/* When the tfm context has a keylen, it's an HMAC. */
> +		if (ctx->keylen) {
> +			/* All but middle descriptors request HMAC. */
> +			if (req_ctx->first || req_ctx->last)
> +				edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
> +		}

if (ctx->keylen && (req_ctx->first || req_ctx->last))
	hdr |= ...

> +
> +		return common_nonsnoop_hash(edesc, areq, nbytes_to_hash,
> +					    ahash_done);
> +	}
> +	return 0;

instead of 

if (cond) {
	do a;
} else {
	do b;
	return x;
}
return 0;

can we do:

if (cond) {
	do a;
	return 0;
}
do b;
return x;

> -	struct talitos_crypto_alg *talitos_alg;
> +	struct talitos_crypto_alg *talitos_alg =
> +					crypto_alg_to_talitos_crypto_alg(alg);
>  	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
>  
> -	talitos_alg =  container_of(alg, struct talitos_crypto_alg,
> -				    algt.alg.crypto);
> -

this undoes what "[PATCH 2/3] crypto: talitos - second prepare step for
adding ahash algorithms" did better IMO.

Thanks!

Kim

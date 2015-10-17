From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] crypto: caam - Add support for hashing export and import
 functions
Date: Sat, 17 Oct 2015 08:39:23 +0100
Message-ID: <20151017073923.GJ32532@n2100.arm.linux.org.uk>
References: <1445037573-29667-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	horia.geanta@freescale.com, fabio.estevam@freescale.com,
	boris.brezillon@free-electrons.com, arno@natisbad.org,
	thomas.petazzoni@free-electrons.com, jason@lakedaemon.net,
	davem@davemloft.net
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:42415 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbbJQHjf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 03:39:35 -0400
Content-Disposition: inline
In-Reply-To: <1445037573-29667-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 16, 2015 at 04:19:33PM -0700, Victoria Milhoan wrote:
> @@ -319,7 +319,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
>  		have_key = OP_ALG_AAI_HMAC_PRECOMP;
>  
>  	/* ahash_update shared descriptor */
> -	desc = ctx->sh_desc_update;
> +	desc = kmalloc(DESC_HASH_MAX_USED_BYTES, GFP_KERNEL | GFP_DMA);

What if kmalloc() fails?  Should this really oops the kernel?  Ditto
for every other kmalloc you've added below.
 
> @@ -1557,6 +1575,20 @@ static int ahash_export(struct ahash_request *req, void *out)
>  	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
>  	struct caam_hash_state *state = ahash_request_ctx(req);
>  
> +	/*
> +	 * Do not export the data buffers. New buffers are
> +	 * allocated during import.
> +	 */
> +	kfree(state->buf_0);
> +	kfree(state->buf_1);
> +	state->buf_0 = NULL;
> +	state->buf_1 = NULL;
> +
> +	state->current_buf = 0;
> +	state->buf_dma = 0;
> +	state->buflen_0 = 0;
> +	state->buflen_1 = 0;
> +

So what if I export, and then continue using _this_ context later?

> @@ -1605,6 +1641,8 @@ static struct caam_hash_template driver_hash[] = {
>  			.setkey = ahash_setkey,
>  			.halg = {
>  				.digestsize = SHA1_DIGEST_SIZE,
> +				.statesize = sizeof(struct caam_hash_ctx) +
> +					     sizeof(struct caam_hash_state),

Much prefer to have a 'struct caam_hash_export_state' thing rather than
litter the code with the knowledge that these two go together.

>  				},
>  			},
>  		.alg_type = OP_ALG_ALGSEL_SHA1,
> @@ -1626,6 +1664,8 @@ static struct caam_hash_template driver_hash[] = {
>  			.setkey = ahash_setkey,
>  			.halg = {
>  				.digestsize = SHA224_DIGEST_SIZE,
> +				.statesize = sizeof(struct caam_hash_ctx) +
> +					     sizeof(struct caam_hash_state),
>  				},
>  			},
>  		.alg_type = OP_ALG_ALGSEL_SHA224,
> @@ -1647,6 +1687,8 @@ static struct caam_hash_template driver_hash[] = {
>  			.setkey = ahash_setkey,
>  			.halg = {
>  				.digestsize = SHA256_DIGEST_SIZE,
> +				.statesize = sizeof(struct caam_hash_ctx) +
> +					     sizeof(struct caam_hash_state),
>  				},
>  			},
>  		.alg_type = OP_ALG_ALGSEL_SHA256,
> @@ -1668,6 +1710,8 @@ static struct caam_hash_template driver_hash[] = {
>  			.setkey = ahash_setkey,
>  			.halg = {
>  				.digestsize = SHA384_DIGEST_SIZE,
> +				.statesize = sizeof(struct caam_hash_ctx) +
> +					     sizeof(struct caam_hash_state),
>  				},
>  			},
>  		.alg_type = OP_ALG_ALGSEL_SHA384,
> @@ -1689,6 +1733,8 @@ static struct caam_hash_template driver_hash[] = {
>  			.setkey = ahash_setkey,
>  			.halg = {
>  				.digestsize = SHA512_DIGEST_SIZE,
> +				.statesize = sizeof(struct caam_hash_ctx) +
> +					     sizeof(struct caam_hash_state),
>  				},
>  			},
>  		.alg_type = OP_ALG_ALGSEL_SHA512,
> @@ -1710,6 +1756,8 @@ static struct caam_hash_template driver_hash[] = {
>  			.setkey = ahash_setkey,
>  			.halg = {
>  				.digestsize = MD5_DIGEST_SIZE,
> +				.statesize = sizeof(struct caam_hash_ctx) +
> +					     sizeof(struct caam_hash_state),
>  				},
>  			},
>  		.alg_type = OP_ALG_ALGSEL_MD5,
> @@ -1796,6 +1844,12 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
>  		dma_unmap_single(ctx->jrdev, ctx->sh_desc_finup_dma,
>  				 desc_bytes(ctx->sh_desc_finup), DMA_TO_DEVICE);
>  
> +	kfree(ctx->sh_desc_update);
> +	kfree(ctx->sh_desc_update_first);
> +	kfree(ctx->sh_desc_fin);
> +	kfree(ctx->sh_desc_digest);
> +	kfree(ctx->sh_desc_finup);
> +

What happens to these when ahash_import() overwrites all the context
state?  Doesn't this mean we end up with double-kfree()s ?

Also, did you test this DMA debug enabled?

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

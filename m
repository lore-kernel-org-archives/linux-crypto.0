From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] crypto: caam - Add support for hashing export and import
 functions
Date: Sat, 17 Oct 2015 11:52:54 +0100
Message-ID: <20151017105254.GM32532@n2100.arm.linux.org.uk>
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
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:42671 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbbJQKxD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 06:53:03 -0400
Content-Disposition: inline
In-Reply-To: <1445037573-29667-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 16, 2015 at 04:19:33PM -0700, Victoria Milhoan wrote:
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
>  	memcpy(out, ctx, sizeof(struct caam_hash_ctx));
>  	memcpy(out + sizeof(struct caam_hash_ctx), state,
>  	       sizeof(struct caam_hash_state));
> @@ -1569,6 +1601,10 @@ static int ahash_import(struct ahash_request *req, const void *in)
>  	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
>  	struct caam_hash_state *state = ahash_request_ctx(req);
>  
> +	/* Allocate new data buffers to use for this request */
> +	state->buf_0 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
> +	state->buf_1 = kmalloc(CAAM_MAX_HASH_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
> +
>  	memcpy(ctx, in, sizeof(struct caam_hash_ctx));
>  	memcpy(state, in + sizeof(struct caam_hash_ctx),
>  	       sizeof(struct caam_hash_state));

Why are we even saving and restoring the caam_hash_ctx here?

That comes from: crypto_tfm_ctx(crypto_ahash_tfm(tfm)), which, tracing
that through the inline functions comes out as:

	tfm->base.__crt_ctx

tfm comes from: __crypto_ahash_cast(req->base.tfm), where req->base.tfm
is a pointer to struct crypto_ahash's base member.

When a hash is accept()ed, req->base.tfm is copied from the original
socket handle to the new socket handle (see ahash_request_set_tfm(),
called from hash_accept_parent(), which is in turn called from
af_alg_accept() in hash_accept()).  So both the exporting and importing
hashes end up with the same struct caam_hash_ctx.

We can see this if we add debug print:

[156147.994219] ahash_export(ctx=ed087080,state=e2a6e600)
[156147.994257] ahash_import(ctx=ed087080,state=e2a6d600)
[156147.998256] ahash_export(ctx=ed083080,state=e2a6c600)
[156147.998294] ahash_import(ctx=ed083080,state=edb9ee00)
[156147.998659] ahash_export(ctx=ed087080,state=e2a6e600)
[156147.998700] ahash_import(ctx=ed087080,state=e2a6fa00)
[156147.999002] ahash_export(ctx=ed080880,state=e2a6d200)
[156147.999040] ahash_import(ctx=ed080880,state=e2a6d600)

Notice that the state changes between each export and import, but the
context doesn't.

So, I think we can (and should) completely drop the saving and restoring
of context in these functions.

Now, with that change, and with your change to buf_0/buf_1, I see
(before the import/export functions are used) several of these errors:

caam_jr 2101000.jr0: 40000501: DECO: desc idx 5: SGT Length Error. The descriptor is trying to read more data than is contained in the SGT table.

when checking using openssh.  They don't occur when testing with openssl
performing normal hashes (as per my previously posted script) but only
with openssh.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2 1/2] crypto: Add Imagination Technologies hw hash
 accelerator
Date: Thu, 20 Nov 2014 22:22:10 +0800
Message-ID: <20141120142210.GA31745@gondor.apana.org.au>
References: <1416343727-2178-1-git-send-email-james.hartley@imgtec.com>
 <1416343727-2178-2-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, grant.likely@linaro.org, robh+dt@kernel.org,
	gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, pawel.moll@arm.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, Ezequiel.Garcia@imgtec.com,
	abrestic@chromium.org
To: James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:49638 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbaKTOWg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Nov 2014 09:22:36 -0500
Content-Disposition: inline
In-Reply-To: <1416343727-2178-2-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 18, 2014 at 08:48:46PM +0000, James Hartley wrote:
>
> +struct img_hash_request_ctx {
> +	struct img_hash_dev	*hdev;
> +	u8 digest[SHA256_DIGEST_SIZE] __aligned(sizeof(u32));
> +	unsigned long		flags;
> +	size_t			digsize;
> +
> +	dma_addr_t		dma_addr;
> +	size_t			dma_ct;
> +
> +	/* sg root */
> +	struct scatterlist	*sgfirst;
> +	/* walk state */
> +	struct scatterlist	*sg;
> +	size_t			nents;
> +	size_t			offset;
> +	unsigned int		total;
> +	size_t			sent;
> +
> +	unsigned long		op;
> +
> +	size_t			bufcnt;
> +	u8 buffer[0] __aligned(sizeof(u32));
> +};

Unfortunately this is not consistent with our API since you're
not storing the non-final hash state in the request context.

It appears that you're finalising every request.  That means
you can only implement finup and digest.  With finup you'll
also need to be able to import a non-final hash state.  If the
hardware cannot do that then you can only implement digest.

Everything else would have to be done by a fallback driver.

So the question is can you obtain the non-final hash state from
the hardware and then reinsert it for the next operation?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

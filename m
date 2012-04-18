From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3 v5] crypto: ux500: Add driver for HASH hardware
Date: Wed, 18 Apr 2012 15:49:46 +0800
Message-ID: <20120418074945.GA20681@gondor.apana.org.au>
References: <1334059426-6806-1-git-send-email-andreas.westin@stericsson.com>
 <1334059426-6806-3-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kim.phillips@freescale.com
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:39739 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751251Ab2DRHtz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Apr 2012 03:49:55 -0400
Content-Disposition: inline
In-Reply-To: <1334059426-6806-3-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 10, 2012 at 02:03:45PM +0200, Andreas Westin wrote:
>
> +/**
> + * hash_hw_update - Updates current HASH computation hashing another part of
> + *                  the message.
> + * @req:	Byte array containing the message to be hashed (caller
> + *		allocated).
> + */
> +int hash_hw_update(struct ahash_request *req)
> +{
> +	int ret = 0;
> +	u8 index = 0;
> +	u8 *buffer;
> +	struct hash_device_data *device_data;
> +	u8 *data_buffer;
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
> +	struct crypto_hash_walk walk;
> +	int msg_length = crypto_hash_walk_first(req, &walk);
> +
> +	/* Empty message ("") is correct indata */
> +	if (msg_length == 0)
> +		return ret;
> +
> +	index = ctx->state.index;
> +	buffer = (u8 *)ctx->state.buffer;

Hmm, if this buffer is written to by the update function, then
this doesn't work because the buffer resides in the tfm which
can be used by multiple entities simultaneously.

All writable data must reside in the request, not the tfm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

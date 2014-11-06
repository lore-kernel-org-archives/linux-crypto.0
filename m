From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 3/3] crypto: sahara - add support for SHA1/256
Date: Thu, 6 Nov 2014 22:59:03 +0800
Message-ID: <20141106145902.GB3300@gondor.apana.org.au>
References: <1414160458-6548-1-git-send-email-s.trumtrar@pengutronix.de>
 <1414160458-6548-4-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54892 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaKFO7I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 09:59:08 -0500
Content-Disposition: inline
In-Reply-To: <1414160458-6548-4-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 24, 2014 at 04:20:58PM +0200, Steffen Trumtrar wrote:
> +struct sahara_sha_reqctx {
> +	unsigned int		mode;
> +	unsigned int		digest_size;
> +	unsigned int		context_size;
> +	u8			buf[SAHARA_MAX_SHA_BLOCK_SIZE];
> +	u8			rembuf[SAHARA_MAX_SHA_BLOCK_SIZE];
> +	unsigned int		buf_cnt;
> +	unsigned int		sg_in_idx;
> +	struct scatterlist	*in_sg;
> +	struct scatterlist	in_sg_chain[2];
> +	bool			in_sg_chained;
> +	size_t			total;
> +};

Sorry but this is still broken as you don't seem to be storing
the hash state in this structure.  Unless I'm misreading your
code buf and rembuf are simply leftover plain-text that is to
be hashed, rather than the hash state.

This implies that the hash state is still being stored in some
other structure that will be overwritten if you receive another
hash request before the previous one has been finalised (i.e.,
someone calls final/finup) or exported.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

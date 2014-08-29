From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: sahara - add support for SHA1/256
Date: Fri, 29 Aug 2014 21:44:42 +0800
Message-ID: <20140829134442.GA9971@gondor.apana.org.au>
References: <1408367619-3436-1-git-send-email-s.trumtrar@pengutronix.de>
 <1408367619-3436-2-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36693 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaH2Nox (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Aug 2014 09:44:53 -0400
Content-Disposition: inline
In-Reply-To: <1408367619-3436-2-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 18, 2014 at 03:13:39PM +0200, Steffen Trumtrar wrote:
>
> +struct sahara_sha_reqctx {
> +	unsigned int mode;
> +	unsigned int digest_size;
> +	unsigned int context_size;
> +	u8 buf[SAHARA_MAX_SHA_BLOCK_SIZE];
> +	unsigned int buf_cnt;
> +	unsigned int hash_rem;
> +	struct sg_table data_sg;
> +	struct scatterlist buf_sg;
> +	unsigned int sg_in_idx;
> +	unsigned int result_idx;
> +};

So where is the hash state stored?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

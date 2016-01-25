From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/5] crypto: atmel-sha: fix algorihtm registration
Date: Mon, 25 Jan 2016 15:23:34 +0800
Message-ID: <20160125072334.GC5609@gondor.apana.org.au>
References: <cover.1452867917.git.cyrille.pitchen@atmel.com>
 <49c8ccb4a2bd61eaab85d0cceba592f41ce7f21c.1452867917.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, nicolas.ferre@atmel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47585 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbcAYHXp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 02:23:45 -0500
Content-Disposition: inline
In-Reply-To: <49c8ccb4a2bd61eaab85d0cceba592f41ce7f21c.1452867917.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 15, 2016 at 03:49:35PM +0100, Cyrille Pitchen wrote:
>
> +static int atmel_sha_export(struct ahash_request *req, void *out)
> +{
> +	const struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
> +	struct atmel_sha_state *state = out;
> +
> +	memcpy(state->digest, ctx->digest, SHA512_DIGEST_SIZE);
> +	memcpy(state->buffer, ctx->buffer, ctx->bufcnt);
> +	state->bufcnt = ctx->bufcnt;
> +	state->digcnt[0] = ctx->digcnt[0];
> +	state->digcnt[1] = ctx->digcnt[1];
> +	return 0;
> +}

Hmm, you're assuming that out is aligned but that is not necessarily
the case.  Ditto for import.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

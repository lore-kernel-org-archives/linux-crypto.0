From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2 6/9] crypto: ccp - Add support for RSA on the CCP
Date: Sun, 13 Nov 2016 17:39:30 +0800
Message-ID: <20161113093930.GA7299@gondor.apana.org.au>
References: <20161104160140.18155.75618.stgit@taos>
 <20161104160432.18155.29136.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46726 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932845AbcKMJjt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 04:39:49 -0500
Content-Disposition: inline
In-Reply-To: <20161104160432.18155.29136.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 04, 2016 at 11:04:32AM -0500, Gary R Hook wrote:
>
> +	ctx->u.rsa.pkey.e = mpi_read_raw_data(raw_key.e, raw_key.e_sz);
> +	if (!ctx->u.rsa.pkey.e)
> +		goto e_ret;
> +	ctx->u.rsa.e_buf = mpi_get_buffer(ctx->u.rsa.pkey.e,
> +					  &ctx->u.rsa.e_len, NULL);

You're converting a raw integer into an MPI and then back again.
Why?

In general drivers shouldn't touch the MPI stuff at all since the
hardware generally deals with raw integers.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

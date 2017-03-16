From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/2] crypto: skcipher AF_ALG - overhaul memory
 management
Date: Thu, 16 Mar 2017 16:39:23 +0800
Message-ID: <20170316083922.GA11653@gondor.apana.org.au>
References: <2523592.mde6d2a8Lg@positron.chronox.de>
 <16908830.B9gcyeAhPX@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52969 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751477AbdCPIjq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 04:39:46 -0400
Content-Disposition: inline
In-Reply-To: <16908830.B9gcyeAhPX@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 17, 2017 at 11:31:41PM +0100, Stephan Müller wrote:
>
> +	} else {
> +		/* Synchronous operation */
> +		skcipher_request_set_callback(&areq->req,
> +					      CRYPTO_TFM_REQ_MAY_SLEEP |
> +					      CRYPTO_TFM_REQ_MAY_BACKLOG,
> +					      af_alg_complete,
> +					      &ctx->completion);
> +		err = af_alg_wait_for_completion(ctx->enc ?
> +					crypto_skcipher_encrypt(&areq->req) :
> +					crypto_skcipher_decrypt(&areq->req),
> +						 &ctx->completion);
> +	}

This is now outside of the loop for the sync case.  The purpose
of the loop in the sync case was to segment the data when we get
a very large SG list that does not fit inside a single call.

Or did I miss something?

Overall I like this patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

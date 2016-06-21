From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto : async implementation for sha1-mb
Date: Tue, 21 Jun 2016 21:07:19 +0800
Message-ID: <20160621130719.GA22526@gondor.apana.org.au>
References: <1466454346-12107-1-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466454346-12107-1-git-send-email-megha.dey@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 20, 2016 at 01:25:46PM -0700, Megha Dey wrote:
>
> -	desc->tfm = child;
> -	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;  /* check this again */
> +	ahash_request_set_tfm(desc, child);
> +	ahash_request_set_callback(desc, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);

The callback function needs to be set, or this will crash when
it returns -EINPROGRESS.

>  	if (err) {
>  		req->base.complete = rctx->complete;

This is not calling the completion function conditinoally, rather
it is trying to restore the original completion function when we
are done.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V6 5/7] crypto: AES CBC multi-buffer glue code
Date: Wed, 19 Jul 2017 15:02:17 +0800
Message-ID: <20170719070217.GA9374@gondor.apana.org.au>
References: <1498609575-6217-1-git-send-email-megha.dey@linux.intel.com>
 <1498609575-6217-6-git-send-email-megha.dey@linux.intel.com>
 <20170718054142.GA4764@gondor.apana.org.au>
 <da15ba80-a3b1-0d79-47ea-5528c0d12b20@linux.intel.com>
 <1500427139.32379.0.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48474 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753103AbdGSHC6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2017 03:02:58 -0400
Content-Disposition: inline
In-Reply-To: <1500427139.32379.0.camel@megha-Z97X-UD7-TH>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 18, 2017 at 06:18:59PM -0700, Megha Dey wrote:
>
> > >> +/*
> > >> + * CRYPTO_ALG_ASYNC flag is passed to indicate we have an ablk
> > >> + * scatter-gather walk.
> > >> + */
> > >> +static struct skcipher_alg aes_cbc_mb_alg = {
> > >> +	.base = {
> > >> +		.cra_name		= "cbc(aes)",
> > >> +		.cra_driver_name	= "cbc-aes-aesni-mb",
> > >> +		.cra_priority		= 500,
> > >> +		.cra_flags		= CRYPTO_ALG_INTERNAL,
> > >> +		.cra_blocksize		= AES_BLOCK_SIZE,
> > >> +		.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
> > >> +		.cra_module		= THIS_MODULE,
> > >> +	},
> > >> +	.min_keysize	= AES_MIN_KEY_SIZE,
> > >> +	.max_keysize	= AES_MAX_KEY_SIZE,
> > >> +	.ivsize		= AES_BLOCK_SIZE,
> > >> +	.setkey		= aes_set_key,
> > >> +	.encrypt	= mb_aes_cbc_encrypt,
> > >> +	.decrypt	= mb_aes_cbc_decrypt
> > >> +};
> > > 
> > > So this claims to be a sync algorithm.  Is this really the case?
> 
> yes, the inner algorithm is sync whereas the outer algorithm is async.

Are you saying that once mb_aes_cbc_encrypt returns it will never
touch the input/output again? This doesn't seem to agree with the
actual code:

+       if (!ret_rctx) {
+               /* we submitted a job, but none completed */
+               /* just notify the caller */
+               notify_callback(rctx, cstate, -EINPROGRESS);
+               return 0;
+       }

Just because an algorithm is internal doesn't mean that it can
arbitrarily violate the crypto API requirements.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

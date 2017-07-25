From: Megha Dey <megha.dey@linux.intel.com>
Subject: Re: FW: [PATCH V6 5/7] crypto: AES CBC multi-buffer glue code
Date: Mon, 24 Jul 2017 18:09:56 -0700
Message-ID: <1500944996.3305.2.camel@megha-Z97X-UD7-TH>
References: <1498609575-6217-1-git-send-email-megha.dey@linux.intel.com>
         <1498609575-6217-6-git-send-email-megha.dey@linux.intel.com>
         <20170718054142.GA4764@gondor.apana.org.au>
         <da15ba80-a3b1-0d79-47ea-5528c0d12b20@linux.intel.com>
         <1500427139.32379.0.camel@megha-Z97X-UD7-TH>
         <20170719070217.GA9374@gondor.apana.org.au>
         <C440BA31B54DCD4AAC682D2365C8FEE703DEC4CE@ORSMSX111.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31708 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751869AbdGYA6D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 20:58:03 -0400
In-Reply-To: <C440BA31B54DCD4AAC682D2365C8FEE703DEC4CE@ORSMSX111.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2017-07-25 at 00:53 +0000, Dey, Megha wrote:
> 
> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
> Sent: Wednesday, July 19, 2017 12:02 AM
> To: Dey, Megha <megha.dey@intel.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>; davem@davemloft.net; linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V6 5/7] crypto: AES CBC multi-buffer glue code
> 
> On Tue, Jul 18, 2017 at 06:18:59PM -0700, Megha Dey wrote:
> >
> > > >> +/*
> > > >> + * CRYPTO_ALG_ASYNC flag is passed to indicate we have an ablk
> > > >> + * scatter-gather walk.
> > > >> + */
> > > >> +static struct skcipher_alg aes_cbc_mb_alg = {
> > > >> +	.base = {
> > > >> +		.cra_name		= "cbc(aes)",
> > > >> +		.cra_driver_name	= "cbc-aes-aesni-mb",
> > > >> +		.cra_priority		= 500,
> > > >> +		.cra_flags		= CRYPTO_ALG_INTERNAL,
> > > >> +		.cra_blocksize		= AES_BLOCK_SIZE,
> > > >> +		.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
> > > >> +		.cra_module		= THIS_MODULE,
> > > >> +	},
> > > >> +	.min_keysize	= AES_MIN_KEY_SIZE,
> > > >> +	.max_keysize	= AES_MAX_KEY_SIZE,
> > > >> +	.ivsize		= AES_BLOCK_SIZE,
> > > >> +	.setkey		= aes_set_key,
> > > >> +	.encrypt	= mb_aes_cbc_encrypt,
> > > >> +	.decrypt	= mb_aes_cbc_decrypt
> > > >> +};
> > > > 
> > > > So this claims to be a sync algorithm.  Is this really the case?
> > 
> > yes, the inner algorithm is sync whereas the outer algorithm is async.
> 
> Are you saying that once mb_aes_cbc_encrypt returns it will never touch the input/output again? This doesn't seem to agree with the actual code:
> 
> +       if (!ret_rctx) {
> +               /* we submitted a job, but none completed */
> +               /* just notify the caller */
> +               notify_callback(rctx, cstate, -EINPROGRESS);
> +               return 0;
> +       }
> 
> Just because an algorithm is internal doesn't mean that it can arbitrarily violate the crypto API requirements.
> 
> Cheers,

Hi Herbert,

Under the skcipher interface, if both the outer and inner alg are async,
there should not be any problem right? Currently I do not see any
existing algorithms have both algorithms async.
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

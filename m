From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v2 1/4] crypto: ecc - add privkey generation support
Date: Mon, 29 May 2017 11:23:00 +0200
Message-ID: <6869489.T5IFoD8UlO@tauon.chronox.de>
References: <1495034813-27143-1-git-send-email-tudor.ambarus@microchip.com> <8501918.Kgl28GDAYF@positron.chronox.de> <c9c47d0f-d4cb-0326-4c43-979fec11001c@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, marcel@holtmann.org,
        Nicolas.Ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59814 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751078AbdE2JXC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 05:23:02 -0400
In-Reply-To: <c9c47d0f-d4cb-0326-4c43-979fec11001c@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 29. Mai 2017, 11:08:38 CEST schrieb Tudor Ambarus:

Hi Tudor,
> 
> >> +	unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
> >> +
> >> +	get_random_bytes(priv, nbytes);
> > 
> > Can you please use crypto_get_default_rng / crypto_rng_get_bytes /
> > crypto_put_default_rng?
> 
> Actually I tried this and I encountered some problems, I'm currently
> debugging it.
> 
> When using the default rng and the run-time self tests are enabled,
> the kernel is in a blocking state. What's worse is that the kernel
> blocks before the console has the chance to be enabled and I can't see
> anything :).
> 
> I suspect that the kernel blocks because the rng does not have enough
> entropy. Could you please give me some hints?

Hm, there should be no blocking for the DRBG to initialize.

What happens if you compile that as a module and insmod it at runtime?
> 
> >> +
> >> +	if (vli_is_zero(priv, ndigits))
> >> +		return -EINVAL;
> >> +
> >> +	/* Make sure the private key is in the range [1, n-1]. */
> >> +	if (vli_cmp(curve->n, priv, ndigits) != 1)
> >> +		return -EINVAL;
> >> +
> >> +	ecc_swap_digits(priv, privkey, ndigits);
> > 
> > Is a byteswap faster than a copy operation by looping through priv/privkey
> > and simply assinging the value?
> 
> Maybe not, but I am consistent with the rest of the code. Can we change
> this in a latter patch, if necessary?

Ok, fine with me.


Ciao
Stephan

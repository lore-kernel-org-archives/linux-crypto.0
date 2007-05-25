From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] HIFN: preliminary HIFN 795x driver for new async cryptoapi.
Date: Fri, 25 May 2007 13:00:05 +0400
Message-ID: <20070525090004.GB3808@2ka.mipt.ru>
References: <20070523080354.GA19665@2ka.mipt.ru> <E1HrV37-00076a-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org, linux-crypto@ml.breakpoint.cc
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:37141 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbXEYJBE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2007 05:01:04 -0400
Content-Disposition: inline
In-Reply-To: <E1HrV37-00076a-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 25, 2007 at 06:21:25PM +1000, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > 
> > It does not - your code only supposed to work with ecb, since it is what
> > was requested during initialization time. This new scheme with templates
> > helps alot for ciphers/crypto modes which do not support several
> > templates, so I used old scheme with 'cipher' only template, not
> > 'ecb(cipher)', 'cbc(cipher)' and so on.
> 
> I just had a look and your driver should use the cra_name of "ecb(aes)"
> since ECB is what it implements.  The cra_driver_name can be ecb-aes-hifn
> (if there can only be one hifn device, otherwise make it something like
> ecb-aes-hifn-<devname> or ecb-aes-<devname>).

I implemented one mode only to show that it would be good to have one
structure allocated and use different crypto modes with only the same
callbacks. But since there is no way to determine for which mode
encryption is performed until 'mode(cipher)' string is used, I have to
allocate and initialize all supported modes and register them
saparately.

> Your priority should also be above 200 which is where assembly-optimised
> software algorithms are registered at by default.  I suggest 300.

Ok.

> > HIFN supports at least 12 different ciphers/mode (3des, des and aes,
> > each one with 4 modes), so it is not a good idea to put them all into
> > separated structures, so I rised a question about it.
> 
> Well it is a trade-off of a bit of work here vs. the ability to better
> support new cipher modes that arise.  Could we perhaps use macro helpers
> so that you don't have to type out each one by hand?

I think that would be good to have set of functions like
struct crypto_alg alloc_crypto_alg(char *name, setkey_callback,
encrypt/decrypt callbacks);
I will put them into driver initially for testing purposes, later
we could move them into generic code to be reused.

> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
	Evgeniy Polyakov

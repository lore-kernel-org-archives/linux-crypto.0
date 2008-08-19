From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: add fips_enable flag
Date: Tue, 19 Aug 2008 06:58:49 -0400
Message-ID: <20080819105849.GA2834@hmsreliant.think-freely.org>
References: <20080730203407.GA14674@hmsreliant.think-freely.org> <20080805061422.GA19801@gondor.apana.org.au> <20080819075535.GA5411@gondor.apana.org.au> <20080819080830.GA24166@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4580 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYHSK7B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Aug 2008 06:59:01 -0400
Content-Disposition: inline
In-Reply-To: <20080819080830.GA24166@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 19, 2008 at 06:08:30PM +1000, Herbert Xu wrote:
> On Tue, Aug 19, 2008 at 05:55:35PM +1000, Herbert Xu wrote:
> >
> > diff --git a/crypto/Makefile b/crypto/Makefile
> > index ed2be05..e3ce913 100644
> > --- a/crypto/Makefile
> > +++ b/crypto/Makefile
> > @@ -5,6 +5,8 @@
> >  obj-$(CONFIG_CRYPTO) += crypto.o
> >  crypto-objs := api.o cipher.o digest.o compress.o
> >  
> > +obj-$(CONFIG_FIPS) += fips.o
> > +
> >  crypto_algapi-$(CONFIG_PROC_FS) += proc.o
> >  crypto_algapi-objs := algapi.o scatterwalk.o $(crypto_algapi-y)
> >  obj-$(CONFIG_CRYPTO_ALGAPI) += crypto_algapi.o
> 
> Doh, made a typo here.  This patch fixes it up.
> 
Copy that, thanks herbert!
Neil

> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> diff --git a/crypto/Makefile b/crypto/Makefile
> index e3ce913..5862b80 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -5,7 +5,7 @@
>  obj-$(CONFIG_CRYPTO) += crypto.o
>  crypto-objs := api.o cipher.o digest.o compress.o
>  
> -obj-$(CONFIG_FIPS) += fips.o
> +obj-$(CONFIG_CRYPTO_FIPS) += fips.o
>  
>  crypto_algapi-$(CONFIG_PROC_FS) += proc.o
>  crypto_algapi-objs := algapi.o scatterwalk.o $(crypto_algapi-y)

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/

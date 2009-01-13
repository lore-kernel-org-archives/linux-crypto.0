From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1 v8] Add CryptoAPI User Interface Support v8
Date: Tue, 13 Jan 2009 16:08:43 +1100
Message-ID: <20090113050843.GA25361@gondor.apana.org.au>
References: <DB599F406D04E34389140B7D99C71B1B0670C3FD@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org, Loc Ho <lho@amcc.com>
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46748 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751918AbZAMFIt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2009 00:08:49 -0500
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B0670C3FD@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 17, 2008 at 03:31:42PM -0800, Shasi Pulijala wrote:
> 
> This patch v8 includes the code that prevents synchronous calls from freeing data when request completion is interrupted, while the data may still be accessed by the crypto code in parallel.
> From: Shasi Pulijala <spulijala@amcc.com>
> 
> 
> Signed-off-by: Shasi Pulijala <spulijala@amcc.com>
> Acked-by: Loc Ho <lho@amcc.com>

I'm only going to comment on the user-space interface as without
an agreement on that there is no point in talking about the
implementation.

Now at the very outset I gave a list of requirements that the
user-space interface should satisfy.  One of them was the ability
to extend the API to cover arbitrary operations.  This is very
important IMO as otherwise we may have to come up with an entirely
new interface should we extend the kernel crypto API with a new
algorithm type or operation.

> +/**
> + * @struct session_op
> + * @brief ioctl parameter to create a session
> + *
> + *
> + */
> +struct session_op {
> +
> +	__u16		algo_size;
> +	__u16		key_size;	/* cipher key length*/
> +	__u16		hmackey_size;	/* mac key length*/
> +	__u16		icv_size;	/*authsize (ccm, gcm)*/
> +	__u8		data[0];
> +};
> +
> +/**
> + * @struct key_op
> + * @brief ioctl parameter to change the session key
> + *
> + */
> +struct key_op {
> +	__u16		ksize;
> +	__u8		data[0];
> +};

As such I think this interface is inadequate by the fact that
it is based completely on the traditional crypto operations.

What I'd like to see is a much more abstract interface where
details such as the meaning of arguments or their format is
left up to each algorithm type to decide.

Now I'm happy with the underlying transport that you have come
up with, i.e., the use of IOVs to delineate arguments for an
individual operation and the use of ioctls to set session/tfm
attributes.

So what I think we need to do here is to change the protocol
on top of this transport to be more generic.

For instance, for session setup, rather than having multiple
ioctl's for each type, I'd like to see a single entry point
that carries the configuration info in a type-specific format
(perhaps netlink like) which we then pass to each algorithm type
to decode.

Similarly, for each operations the generic layer should simply
pass the IOVs to each individual type which can do whatever they
want with it.

At the end of the day I'd like to have an interface where if
I were to add a new algorithm type (like rng that we just added),
I could simply write the hooks for it and it'll work without
me having to modify the guts of the interface.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

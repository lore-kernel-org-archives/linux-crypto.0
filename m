From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH v2 3/4] xfrm: Add a netlink attribute for
	software crypto accelerators
Date: Mon, 27 Apr 2009 16:53:46 +0800
Message-ID: <20090427085346.GA21761@gondor.apana.org.au>
References: <20090424102451.GB12680@secunet.com> <20090424102828.GE12680@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56228 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753587AbZD0Ixy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2009 04:53:54 -0400
Content-Disposition: inline
In-Reply-To: <20090424102828.GE12680@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 24, 2009 at 12:28:28PM +0200, Steffen Klassert wrote:
>
> +struct xfrm_accl {
> +	char	name[64];
> +	__u8	type;
> +#define XFRM_ACCL_ENC	1
> +#define XFRM_ACCL_AUTH	2	
> +#define XFRM_ACCL_COMP	4
> +#define XFRM_ACCL_AEAD	8
> +};

While this should work for pcrypt, I'd like this to be solved
more generally.  The crux of the issue is that we can't specify
an arbitrary implementation of a given algorithm.  So the obvious
solution is to specify the driver name along with the algorithm
name.

This is in fact pretty much what you've done, but I'd just like
it to be generalised.  In particular, instead of having just a
single name per SA, we should allow one to be set for each algorithm
type.

On another note, I don't expect this to be the primary mechanism
for activating parallel processing.  Doing it manually on each
SA is just painful.  This should be used for testing or when you
want to specify it for a subset of SAs only.

When the admin wants to turn the entire system over to pcrypt,
it should be done at the crypto layer, by simply registering
the pcrypt version of the algorithm in question, and having it
as the default implementation of that algorithm.

In fact, this mechanism should then be able to allow specific
SAs to not use parallel processing, which means that it should
definitely not be called accl :)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

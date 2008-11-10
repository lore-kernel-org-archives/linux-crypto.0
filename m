From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Unloading hardware based crypto to fallback to software based crypto
Date: Mon, 10 Nov 2008 14:55:42 +0800
Message-ID: <E1KzQgY-0008MT-Co@gondolin.me.apana.org.au>
References: <200811071034.41253.djenkins@mvista.com>
Cc: linux-crypto@vger.kernel.org
To: djenkins@mvista.com (Dean Jenkins)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41084 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750912AbYKJGzp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2008 01:55:45 -0500
In-Reply-To: <200811071034.41253.djenkins@mvista.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dean Jenkins <djenkins@mvista.com> wrote:
> 
> Is there a mechanism to allow a hardware crypto driver to be unloaded and the 
> IPsec session to fallback to using software based crypto drivers ?

Fail-over should be implemented within the driver.  Please look
at drivers/crypto/padlock-sha.c for an example for how to use a
software fallback implementation.

> Conversely, is there a mechanism to dynamically upgrade from using software 
> based crypto to hardware based crypto without killing the IPsec tunnel ?

Note that IPsec tunnel != IPsec SA.  During the life-time of a
tunnel many SAs could be used.  It's trivial to change drivers
without killing the tunnel by changing SAs.  Of course, changing
implementations without replacing the SA is impossible, unless
you start out with the hardware implementation registered but
only use the software fallback.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

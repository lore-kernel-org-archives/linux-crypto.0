From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Sat, 20 Mar 2010 11:45:31 +0800
Message-ID: <20100320034531.GA31798@gondor.apana.org.au>
References: <20100319234044.GA5127@jenkins> <20100320010115.GA30561@gondor.apana.org.au> <20100320010849.GA30654@gondor.apana.org.au> <20100319.194612.226782074.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: brandon@ifup.org, linux-crypto@vger.kernel.org,
	rusty@rustcorp.com.au
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60376 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386Ab0CTDpj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Mar 2010 23:45:39 -0400
Content-Disposition: inline
In-Reply-To: <20100319.194612.226782074.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 19, 2010 at 07:46:12PM -0700, David Miller wrote:
>
> Even if userland "does" this, nothing stops another thread
> from rmmod'ing the dependency in between the modloads.
> 
> We have to handle this case properly in the kernel, no matter
> what.

Right, if that had happened I think the reasonable response would
be to fail the subsequent load for lack of dependency rather than
looping around forever.

However, I don't think that's what Brandon is seeing here, unless
there is something performing the rmmod?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

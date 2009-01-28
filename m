From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IPSec AH hardware offload
Date: Wed, 28 Jan 2009 21:41:36 +1100
Message-ID: <20090128104136.GA16727@gondor.apana.org.au>
References: <20090128033736.GA5888@gondor.apana.org.au> <49801903.2000303@picochip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jamie Iles <jamie.iles@picochip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34552 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751512AbZA1Klm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Jan 2009 05:41:42 -0500
Content-Disposition: inline
In-Reply-To: <49801903.2000303@picochip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 28, 2009 at 08:36:19AM +0000, Jamie Iles wrote:
>
> Does that include the hash for authentication header in  
> net/ipv[46]/ah[46].c?

Yes.

> The driver implements authenc algorithms, so we'll already get  
> asynchronous operation for ESP, but the crypto_alloc_hash() in ah[46].c  
> explicitly requests a synchronous hash. Is this worth converting to use  
> ahash?

Whether it's worth it depends on how much you're being paid :)
But it certainly wouldn't hurt, provided that someone is willing
to do the work.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_remove_spawns: BUG: unable to handle kernel NULL
	pointer dereference at 0000000000000018
Date: Thu, 18 Feb 2010 08:26:18 +0800
Message-ID: <20100218002618.GA29504@gondor.apana.org.au>
References: <20100214174507.GA8688@x200> <20100215052729.GA17156@gondor.apana.org.au> <b6fcc0a1002142347n1aff4326p3275e70b0ecea0e3@mail.gmail.com> <20100215081155.GA18566@gondor.apana.org.au> <b6fcc0a1002150014j43415772mea21790c0667a32b@mail.gmail.com> <20100216120203.GA32264@gondor.apana.org.au> <20100216193139.GA5512@x200> <20100217003735.GB11975@gondor.apana.org.au> <20100217193109.GB5256@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50814 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752712Ab0BRA0Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Feb 2010 19:26:24 -0500
Content-Disposition: inline
In-Reply-To: <20100217193109.GB5256@x200>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 17, 2010 at 09:31:09PM +0200, Alexey Dobriyan wrote:
>
> Race started to become even less reproducible, so I can't confirm your patch quickly. :-(

See if it's setkey or racoon that's loading the algorithms.  Once
you know which it is, just repeatedly restart that while running
rmmod on aes.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

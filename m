From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_remove_spawns: BUG: unable to handle kernel NULL
	pointer dereference at 0000000000000018
Date: Wed, 17 Feb 2010 08:37:35 +0800
Message-ID: <20100217003735.GB11975@gondor.apana.org.au>
References: <20100214174507.GA8688@x200> <20100215052729.GA17156@gondor.apana.org.au> <b6fcc0a1002142347n1aff4326p3275e70b0ecea0e3@mail.gmail.com> <20100215081155.GA18566@gondor.apana.org.au> <b6fcc0a1002150014j43415772mea21790c0667a32b@mail.gmail.com> <20100216120203.GA32264@gondor.apana.org.au> <20100216193139.GA5512@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44311 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933726Ab0BQAhq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2010 19:37:46 -0500
Content-Disposition: inline
In-Reply-To: <20100216193139.GA5512@x200>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 16, 2010 at 09:31:39PM +0200, Alexey Dobriyan wrote:
>
> Which codepath exactly?

When a spawn is created the instance associated with it will have
a zero-initialised cra_users entry.

> BTW, CBC or AES aren't used, just loaded.

Can you boot without aes/cbc loaded and see if it gets automatically
loaded? PF_KEY users tend to load all possible algorithms when
they start up.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

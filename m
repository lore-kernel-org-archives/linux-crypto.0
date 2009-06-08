From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Mon, 8 Jun 2009 15:28:08 +1000
Message-ID: <20090608052808.GB19826@gondor.apana.org.au>
References: <20090602035041.GB22831@gondor.apana.org.au> <20090602092151.GJ20366@secunet.com> <20090602092815.GA26832@gondor.apana.org.au> <20090603093216.GK20366@secunet.com> <20090603094049.GA11356@gondor.apana.org.au> <20090603112353.GL20366@secunet.com> <20090603115931.GA13361@gondor.apana.org.au> <20090605092030.GO20366@secunet.com> <20090605092021.GB8724@gondor.apana.org.au> <20090605093430.GP20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42589 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751219AbZFHF2L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2009 01:28:11 -0400
Content-Disposition: inline
In-Reply-To: <20090605093430.GP20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 05, 2009 at 11:34:30AM +0200, Steffen Klassert wrote:
>
> In pcrypt_alloc_instance() I do
> inst->alg.cra_priority = alg->cra_priority + 100;
> 
> So, in my case authenc has priority 2000 and pcrypt has priority 2100.
> In this case pcrypt is not instantiated if I use %s for pcrypt as
> cra_name. If I do 
> inst->alg.cra_priority = alg->cra_priority - 100
> it will be instantiated with priority 1900 but it will not be used
> because the priority of authenc is higher.
> 
> So I did the priority check in crypto_alg_tested() the other way around.
> Then I can instantiate pcrypt with priority 2100 and I can use it.

Can you send me a pcrypt patch that I can use to reproduce this?

The check modified is meant to replace instances of the same
implementation (i.e., you're replaceing aes-x86-64 with a newer
version of aes-x86-64).  It should never do anything when you add
a different implementation of the same algorithm.

So I'm surprised that you're seeing a difference when changing
that check.  Because unless you're creating two pcrypt objects
with the same driver name, or your pcrypt object has the wrong
driver name, then this change should make no difference whatsoever.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

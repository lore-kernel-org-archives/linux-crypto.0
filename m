From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Mon, 8 Jun 2009 08:45:18 +0200
Message-ID: <20090608064518.GQ20366@secunet.com>
References: <20090602092151.GJ20366@secunet.com> <20090602092815.GA26832@gondor.apana.org.au> <20090603093216.GK20366@secunet.com> <20090603094049.GA11356@gondor.apana.org.au> <20090603112353.GL20366@secunet.com> <20090603115931.GA13361@gondor.apana.org.au> <20090605092030.GO20366@secunet.com> <20090605092021.GB8724@gondor.apana.org.au> <20090605093430.GP20366@secunet.com> <20090608052808.GB19826@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:58020 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbZFHGmv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2009 02:42:51 -0400
Content-Disposition: inline
In-Reply-To: <20090608052808.GB19826@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 08, 2009 at 03:28:08PM +1000, Herbert Xu wrote:
> On Fri, Jun 05, 2009 at 11:34:30AM +0200, Steffen Klassert wrote:
> >
> > In pcrypt_alloc_instance() I do
> > inst->alg.cra_priority = alg->cra_priority + 100;
> > 
> > So, in my case authenc has priority 2000 and pcrypt has priority 2100.
> > In this case pcrypt is not instantiated if I use %s for pcrypt as
> > cra_name. If I do 
> > inst->alg.cra_priority = alg->cra_priority - 100
> > it will be instantiated with priority 1900 but it will not be used
> > because the priority of authenc is higher.
> > 
> > So I did the priority check in crypto_alg_tested() the other way around.
> > Then I can instantiate pcrypt with priority 2100 and I can use it.
> 
> Can you send me a pcrypt patch that I can use to reproduce this?

Yes, I will send the full patchset including the tcrypt changes to
instantiate pcrypt.

As the patchset is, I'm not able to instantiate pcrypt here. I need to
either change the priority check in crypto_alg_tested() or to make
pcrypt using a lower priority than authenc.

> 
> The check modified is meant to replace instances of the same
> implementation (i.e., you're replaceing aes-x86-64 with a newer
> version of aes-x86-64).  It should never do anything when you add
> a different implementation of the same algorithm.
> 
> So I'm surprised that you're seeing a difference when changing
> that check.  Because unless you're creating two pcrypt objects
> with the same driver name, or your pcrypt object has the wrong
> driver name, then this change should make no difference whatsoever.
> 

I was just surprised that I was able to instantiate pcrypt if it has a
lower priority than the underlying authenc algorithm. So I searched for
priority checks like the one in crypto_alg_tested() and in fact changing
this check got it to work as I described above.

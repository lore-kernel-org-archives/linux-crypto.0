From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Fri, 5 Jun 2009 11:34:30 +0200
Message-ID: <20090605093430.GP20366@secunet.com>
References: <20090513130818.GF20366@secunet.com> <20090602035041.GB22831@gondor.apana.org.au> <20090602092151.GJ20366@secunet.com> <20090602092815.GA26832@gondor.apana.org.au> <20090603093216.GK20366@secunet.com> <20090603094049.GA11356@gondor.apana.org.au> <20090603112353.GL20366@secunet.com> <20090603115931.GA13361@gondor.apana.org.au> <20090605092030.GO20366@secunet.com> <20090605092021.GB8724@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:43763 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZFEJcF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Jun 2009 05:32:05 -0400
Content-Disposition: inline
In-Reply-To: <20090605092021.GB8724@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 05, 2009 at 07:20:21PM +1000, Herbert Xu wrote:
> On Fri, Jun 05, 2009 at 11:20:30AM +0200, Steffen Klassert wrote:
> > 
> > As it is, I can instantiate pcrypt if the priority of pcrypt is lower
> > than the priority of the underlying algorithm. If I do the priority
> > check in crypto_alg_tested() the other way arround, I get it to work if
> > pcrypt has a higher priority than the underlying algorithm. So I guess
> > we need the patch below, right? If so, I would send a signed-off patch.
> 
> Can you give me an example with actual numbers and what you expect
> to happen?
> 

In pcrypt_alloc_instance() I do
inst->alg.cra_priority = alg->cra_priority + 100;

So, in my case authenc has priority 2000 and pcrypt has priority 2100.
In this case pcrypt is not instantiated if I use %s for pcrypt as
cra_name. If I do 
inst->alg.cra_priority = alg->cra_priority - 100
it will be instantiated with priority 1900 but it will not be used
because the priority of authenc is higher.

So I did the priority check in crypto_alg_tested() the other way around.
Then I can instantiate pcrypt with priority 2100 and I can use it.

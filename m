From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Fri, 5 Jun 2009 19:20:21 +1000
Message-ID: <20090605092021.GB8724@gondor.apana.org.au>
References: <20090513130618.GD20366@secunet.com> <20090513130818.GF20366@secunet.com> <20090602035041.GB22831@gondor.apana.org.au> <20090602092151.GJ20366@secunet.com> <20090602092815.GA26832@gondor.apana.org.au> <20090603093216.GK20366@secunet.com> <20090603094049.GA11356@gondor.apana.org.au> <20090603112353.GL20366@secunet.com> <20090603115931.GA13361@gondor.apana.org.au> <20090605092030.GO20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41309 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751937AbZFEJUY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Jun 2009 05:20:24 -0400
Content-Disposition: inline
In-Reply-To: <20090605092030.GO20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 05, 2009 at 11:20:30AM +0200, Steffen Klassert wrote:
> 
> As it is, I can instantiate pcrypt if the priority of pcrypt is lower
> than the priority of the underlying algorithm. If I do the priority
> check in crypto_alg_tested() the other way arround, I get it to work if
> pcrypt has a higher priority than the underlying algorithm. So I guess
> we need the patch below, right? If so, I would send a signed-off patch.

Can you give me an example with actual numbers and what you expect
to happen?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

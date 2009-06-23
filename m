From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] pcrypt: Add pcrypt crypto parallelization
	wrapper
Date: Tue, 23 Jun 2009 10:29:21 +0200
Message-ID: <20090623082921.GB20366@secunet.com>
References: <20090608070749.GR20366@secunet.com> <20090608071000.GT20366@secunet.com> <20090619122933.GB18631@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:39078 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbZFWI0s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2009 04:26:48 -0400
Content-Disposition: inline
In-Reply-To: <20090619122933.GB18631@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 19, 2009 at 08:29:33PM +0800, Herbert Xu wrote:
> On Mon, Jun 08, 2009 at 09:10:00AM +0200, Steffen Klassert wrote:
> >
> > +config CRYPTO_PCRYPT
> > +	tristate "Parallel crypto engine (EXPERIMENTAL)"
> > +	depends on USE_GENERIC_SMP_HELPERS && EXPERIMENTAL
> > +	select CRYPTO_MANAGER
> > +	select CRYPTO_PCRYPT_CORE
> > +	help
> > +	  This converts an arbitrary crypto algorithm into a parallel
> > +	  algorithm that is executed in a softirq.
> 
> BTW, do we really need softirqs for these things? Cryptographic
> operations are typically slow (especially when you have to move
> them to other CPUs to handle a single NIC:) so if we're going to
> the trouble of making it async then we should put them in work
> queues instead.

I did already tests with a work queue based parallelization, but the
throughput and the latency on networking tests were much better with the
remote softirq based version. The serialization engine must always wait
for the cpu that processes the 'next' packet to keep the packets in the
right order. And softirqs are a good way to ensure that the packets are
processed as soon as possible.

Anyway, we can always use pcrypt(cryptd(..)) combinations if we need to
make the request async.

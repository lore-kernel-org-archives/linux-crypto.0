From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] pcrypt: Add pcrypt crypto parallelization
	wrapper
Date: Tue, 23 Jun 2009 11:14:29 +0200
Message-ID: <20090623091429.GC20366@secunet.com>
References: <20090608070749.GR20366@secunet.com> <20090608071000.GT20366@secunet.com> <20090619122933.GB18631@gondor.apana.org.au> <20090623082921.GB20366@secunet.com> <20090623083438.GA8315@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:39808 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbZFWJL4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2009 05:11:56 -0400
Content-Disposition: inline
In-Reply-To: <20090623083438.GA8315@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 23, 2009 at 04:34:38PM +0800, Herbert Xu wrote:
> On Tue, Jun 23, 2009 at 10:29:21AM +0200, Steffen Klassert wrote:
> >
> > I did already tests with a work queue based parallelization, but the
> > throughput and the latency on networking tests were much better with the
> > remote softirq based version. The serialization engine must always wait
> > for the cpu that processes the 'next' packet to keep the packets in the
> > right order. And softirqs are a good way to ensure that the packets are
> > processed as soon as possible.
> 
> OK, do you have some numbers that we can add to the patches?

I posted some numbers for the actual softirq based version with the
first patchset, see:
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03035.html

But as I pointed out there, these numbers are not that meaningful
as long as we have the lock in crypto_authenc_hash()
Actually I'm about to rewrite authenc/hmac to use ahash. As soon as I
finished this I will redo the tests without the lock.

> 
> Also note that the real time folks are turning softirq into threads
> so this complexity might be moot in the end.
> 

Yes, I know. The one of the main problems of the thread based version
was that it had to wait for the cpu that serves the interrupt for the
NICs. As soon as other softirqs (like the NET_RX_SOFTIRQ) are thread
based too this should not be a problem any more.

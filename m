From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] pcrypt: Add pcrypt crypto parallelization
	wrapper
Date: Tue, 23 Jun 2009 12:19:58 +0200
Message-ID: <20090623101958.GD20366@secunet.com>
References: <20090608070749.GR20366@secunet.com> <20090608071000.GT20366@secunet.com> <20090619122933.GB18631@gondor.apana.org.au> <20090623082921.GB20366@secunet.com> <20090623083438.GA8315@gondor.apana.org.au> <20090623091429.GC20366@secunet.com> <20090623091852.GA8701@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:40611 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZFWKRY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2009 06:17:24 -0400
Content-Disposition: inline
In-Reply-To: <20090623091852.GA8701@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 23, 2009 at 05:18:52PM +0800, Herbert Xu wrote:
> On Tue, Jun 23, 2009 at 11:14:29AM +0200, Steffen Klassert wrote:
> >
> > I posted some numbers for the actual softirq based version with the
> > first patchset, see:
> > http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03035.html
> 
> Thanks, but I was thinking of softirq numbers vs. workqueue numbers.
> 

I have just some numbers from a network based parallelization
that uses threads. So it's probaply not really comparable to
the pcrypt version. To compare the pcrypt version, we would need a
thread based padata version. If you think that it is needed I could
care about this as soon as I finished the ahash work.

Anyway, here are numbers for the network based versions:

I did forwarding tests with the thread version and two quad core machines
(Intel Core 2 Quad Q6600):

linux-2.6.25.2 + thread based (network) parallelization
Packetsize: 1420 byte
Encryption: aes192-sha1
Unidirectional throughput: 660 Mbit/s (tcp)

After rewriting this to use remote softirqs I've got with the same
environment:

linux-2.6-git (Dec 01, 2008) + softirq based (network) parallelization
Packetsize: 1420 byte
Encryption: aes192-sha1
Unidirectional throughput: 910 Mbit/s (tcp)

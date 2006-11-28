From: rsnel@cube.dyndns.org
Subject: Re: [PATCHv2 4/6] crypto: table driven multiplications in GF(2^128), needed by LRW (and in the future ABL)
Date: Tue, 28 Nov 2006 22:17:39 +0100
Message-ID: <20061128211739.GA22569@cube.dyndns.org>
References: <20061128200232.GA401@cube.dyndns.org> <E1GpAGq-00041C-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:38149 "EHLO
	smtp-vbr7.xs4all.nl") by vger.kernel.org with ESMTP
	id S1755776AbWK1VRw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Nov 2006 16:17:52 -0500
To: Herbert Xu <herbert@gondor.apana.org.au>
Content-Disposition: inline
In-Reply-To: <E1GpAGq-00041C-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Herbert,

On Wed, Nov 29, 2006 at 08:13:40AM +1100, Herbert Xu wrote:
> > It's OK. The source will be more maintainable, but constantly converting
> > between big and little-endian (on little endian machines) may have a
> > significant performance impact (I will just test when your gf128 hits
> > cryptodev-2.6, and complain if it is the case).
> 
> BTW, the tcrypt speed test for lrw doesn't work for me.

Did you try my patch: [PATCH] adding speed_test_template for lrw(aes)
which I sent on Sep 23?

> > This seems to be the problem, the table is constructed wrongly. 
> > All the calculations take place as if we are on a big endian machine, so
> > the table entries should never be swapped, so the above line should read
> > 
> > +#define xx(p, q)       0x##p##q
> 
> Yes you're quite right.  That was the problem.  I'll push this into mm
> as soon as I get the speed tests fixed.

Ok, that's good news.

Greetings,

Rik.

-- 
Nothing is ever a total loss; it can always serve as a bad example.

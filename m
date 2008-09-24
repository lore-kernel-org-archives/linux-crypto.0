From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: hifn_795x in Linux-2.6.27-rc7
Date: Wed, 24 Sep 2008 06:53:08 +0400
Message-ID: <20080924025308.GA27398@2ka.mipt.ru>
References: <20080923165521.GA26513@2ka.mipt.ru> <48D93028.20903@psycast.de> <20080923181840.GA24982@2ka.mipt.ru> <20080923.145515.34843004.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: max@psycast.de, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:35223 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYIXCyI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Sep 2008 22:54:08 -0400
Content-Disposition: inline
In-Reply-To: <20080923.145515.34843004.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 23, 2008 at 02:55:15PM -0700, David Miller (davem@davemloft.net) wrote:
> > Yes, I was wrong with the patch: HIFN does not support 64-bit addresses
> > afaics.
> > 
> > Attached patch should not allow HIFN to be registered on 64-bit arch, so
> > crypto layer will fallback to the software algorithms.
> > 
> > Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> 
> Well, it will disallow HIFN on 32-bit systems using highmem too. :-)

Yes, but only 64g, where dma_addr_t is 8 bytes.

> In the end, you will need to use bouncebuffers or similar, it seems.

Maybe, we need to check, since allocation of multiple smaller pages from
4 gb area, copy data between them, hardware crypto, backward copy and
page freeing can be slower than software crypto. Although we can
preallocate buffers for several common sizes, although this will not
help dm-crypto which can submit up to 31 pages in single request on top
of ext3 in the common case.

--
	Evgeniy Polyakov

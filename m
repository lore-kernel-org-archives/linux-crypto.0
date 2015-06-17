From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v5 05/14] crypto: marvell/CESA: add TDMA support
Date: Wed, 17 Jun 2015 09:15:03 +0200
Message-ID: <20150617091503.5f74b6e5@bbrezillon>
References: <1434448748-10828-1-git-send-email-boris.brezillon@free-electrons.com>
	<1434448748-10828-6-git-send-email-boris.brezillon@free-electrons.com>
	<20150617050527.GA8807@gondor.apana.org.au>
	<20150617055633.GA9123@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	Imre Kaloz <kaloz@openwrt.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:49542 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757462AbbFQHPI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 03:15:08 -0400
In-Reply-To: <20150617055633.GA9123@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 17 Jun 2015 13:56:33 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Jun 17, 2015 at 01:05:27PM +0800, Herbert Xu wrote:
> > On Tue, Jun 16, 2015 at 11:58:59AM +0200, Boris Brezillon wrote:
> > >
> > > +	ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
> > > +			 DMA_TO_DEVICE);
> > > +	if (ret != creq->src_nents)
> > > +		return -ENOMEM;
> > 
> > Hmm it doesn't quite work like that.  It returns zero on error,
> > otherwise it returns the number (n) of mapped entries which may be
> > less than what you gave it due to merging.  You're then supposed
> > to use only the first n entries which should contain everything.
> 
> Please take a look at Documentation/DMA-API-HOWTO.txt, it has
> everything you need to know about the dma_map_sg interface.

Yep, I read it, but apparently not carefully enough ;-).
I'll fix that.

Note that I did not ignore your previous comment on purpose (checking
for !ret to verify if the sg entries were successfully mapped), but I
have a specific case in the hash code where the requested len is 0
(final request) and thus the src_nents is 0 too. Which means I'm
expecting the dma_sg_map to return 0.

Anyway, now I'm doing the following test:

if (creq->src_nents && !ret)
	return -ENOMEM;

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

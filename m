From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v6 05/14] crypto: marvell/CESA: add TDMA support
Date: Wed, 17 Jun 2015 13:33:24 +0200
Message-ID: <20150617133324.1ee6ad55@bbrezillon>
References: <1434527142-3609-1-git-send-email-boris.brezillon@free-electrons.com>
	<1434527142-3609-6-git-send-email-boris.brezillon@free-electrons.com>
	<20150617095001.GA11538@gondor.apana.org.au>
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
Received: from down.free-electrons.com ([37.187.137.238]:56721 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752948AbbFQLd3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 07:33:29 -0400
In-Reply-To: <20150617095001.GA11538@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 17 Jun 2015 17:50:01 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Wed, Jun 17, 2015 at 09:45:33AM +0200, Boris Brezillon wrote:
> >
> > +	ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
> > +			 DMA_TO_DEVICE);
> > +	if (!ret)
> > +		return -ENOMEM;
> > +
> > +	creq->src_nents = ret;
> 
> DMA-API-HOWTO says that you must retain the original nents and
> use it when you call dma_unmap_sg.  So I'm afraid one more repost
> is needed :)

My bad (again :-/).
Actually, I think I don't need to save the dma_map_sg return val, since
I'm using the sg_next function to iterate over the scatterlist. Am I
right ?
IOW, is the ->map_sg() function (in dma_map_ops) supposed to merge the
contiguous entries and then flag the unused entries with the is_chain
flag ?
If that's not the case, and the ->map_sg() just marks the merged entries
as empty (length = 0), then I'll have to rework my iterator algorithm.

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

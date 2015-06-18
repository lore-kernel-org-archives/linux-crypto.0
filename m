From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v6 05/14] crypto: marvell/CESA: add TDMA support
Date: Thu, 18 Jun 2015 10:04:00 +0100
Message-ID: <20150618090400.GG7557@n2100.arm.linux.org.uk>
References: <1434527142-3609-1-git-send-email-boris.brezillon@free-electrons.com>
 <1434527142-3609-6-git-send-email-boris.brezillon@free-electrons.com>
 <20150617095001.GA11538@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
	Nadav Haklai <nadavh@marvell.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Arnaud Ebalard <arno@natisbad.org>,
	Rob Herring <robh+dt@kernel.org>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	linux-arm-kernel@lists.infradead.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Kumar Gala <galak@codeaurora.org>,
	Imre Kaloz <kaloz@openwrt.org>,
	"David S. Miller" <
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:39531 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbbFRJE1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 05:04:27 -0400
Content-Disposition: inline
In-Reply-To: <20150617095001.GA11538@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 17, 2015 at 05:50:01PM +0800, Herbert Xu wrote:
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

It's worse than that...  You're right on that point, but there's an
additional point.

If dma_map_sg() coalesces scatterlist entries, then ret will be smaller
than src_nents, and ret indicates how many scatterlist entries to be
walked during DMA - you should not use src_nents for that.  I couldn't
see where the driver used that information.  In fact, the driver seems
to be capable of walking more than src_nents/ret numbers of scatterlist
entries: it just keeps going with sg_next() until it hits the end of
the allocated scatterlist.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.

From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [RESEND PATCH v4 05/14] crypto: marvell/CESA: add TDMA support
Date: Mon, 15 Jun 2015 13:25:03 +0200
Message-ID: <20150615132503.69ec2cbb@bbrezillon>
References: <1434093366-14681-1-git-send-email-boris.brezillon@free-electrons.com>
	<1434093366-14681-6-git-send-email-boris.brezillon@free-electrons.com>
	<20150615100920.GB32199@gondor.apana.org.au>
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
Received: from down.free-electrons.com ([37.187.137.238]:60634 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753329AbbFOLZI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 07:25:08 -0400
In-Reply-To: <20150615100920.GB32199@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Mon, 15 Jun 2015 18:09:20 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, Jun 12, 2015 at 09:15:57AM +0200, Boris Brezillon wrote:
> >
> > +	ret = dma_map_sg(cesa_dev->dev, req->src, creq->src_nents,
> > +			 DMA_TO_DEVICE);
> > +	if (ret < 0)
> 
> This function returns zero on error, not negative.  See
> Documentation/DMA-API-HOWTO.txt for details.

Yep, I'll fix that.

Thanks for pointing this out.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

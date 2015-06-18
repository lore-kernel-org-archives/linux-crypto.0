From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 05/14] crypto: marvell/CESA: add TDMA support
Date: Thu, 18 Jun 2015 17:37:30 +0800
Message-ID: <20150618093730.GA29911@gondor.apana.org.au>
References: <1434527142-3609-1-git-send-email-boris.brezillon@free-electrons.com>
 <1434527142-3609-6-git-send-email-boris.brezillon@free-electrons.com>
 <20150617095001.GA11538@gondor.apana.org.au>
 <20150618090400.GG7557@n2100.arm.linux.org.uk>
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
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44915 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbbFRJiX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 05:38:23 -0400
Content-Disposition: inline
In-Reply-To: <20150618090400.GG7557@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 18, 2015 at 10:04:00AM +0100, Russell King - ARM Linux wrote:
>
> If dma_map_sg() coalesces scatterlist entries, then ret will be smaller
> than src_nents, and ret indicates how many scatterlist entries to be
> walked during DMA - you should not use src_nents for that.  I couldn't
> see where the driver used that information.  In fact, the driver seems
> to be capable of walking more than src_nents/ret numbers of scatterlist
> entries: it just keeps going with sg_next() until it hits the end of
> the allocated scatterlist.

I think he should be OK even though he throws away the return value
because he's stopping his walk once the sum of sg_dma_length reaches
his end goal.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

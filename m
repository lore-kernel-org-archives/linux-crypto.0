From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/8] dmaengine: mv_xor: add support for a38x command in descriptor mode
Date: Wed, 13 May 2015 10:46:45 +0200
Message-ID: <2913865.DiE4h2cH6J@wuerfel>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com> <4862159.g8Sk9nOiS2@wuerfel> <20150513081535.GS10961@lukather>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-arm-kernel@lists.infradead.org,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Lior Amsalem <alior@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:49402 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbbEMIrD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2015 04:47:03 -0400
In-Reply-To: <20150513081535.GS10961@lukather>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 13 May 2015 10:15:35 Maxime Ripard wrote:
> > Alternatively, you could leave the XOR_DESCRIPTOR_SWAP flag disabled
> > and just swap the descriptors manually like a lot of other drivers
> > do. You have to swap the mmio accesses anywya.
> 
> That won't be easily doable however.
> 
> Not only the endianness of the individual fields in the descriptor
> changes, but changing the endianness also swaps the fields themselves
> by pair of u32.
> 
> You can see that here:
> http://lxr.free-electrons.com/source/drivers/dma/mv_xor.h#L159
> 
> So I'm guessing that leaving it like it is was the more readable
> solution.

I see, yes that would get a bit ugly.

	Arnd

From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/8] dmaengine: mv_xor: add support for a38x command in descriptor mode
Date: Tue, 12 May 2015 18:03:34 +0200
Message-ID: <3020836.4xH6fTICuR@wuerfel>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com> <4862159.g8Sk9nOiS2@wuerfel> <20150512175431.378c346e@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
	Jason Cooper <jason@lakedaemon.net>,
	Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	linux-crypto@vger.kernel.org,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:61325 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149AbbELQEa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2015 12:04:30 -0400
In-Reply-To: <20150512175431.378c346e@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday 12 May 2015 17:54:31 Thomas Petazzoni wrote:
> Dear Arnd Bergmann,
> 
> On Tue, 12 May 2015 17:49:08 +0200, Arnd Bergmann wrote:
> 
> > Using 
> > 
> >       if (IS_ENABLED(__BIG_ENDIAN))
> > 
> > here would make it more readable by avoiding the #if. Alternatively,
> > you could leave the XOR_DESCRIPTOR_SWAP flag disabled and just swap
> > the descriptors manually like a lot of other drivers do. You have
> > to swap the mmio accesses anywya.
> 
> Agreed on IS_ENABLED(). However, I don't understand the comment about
> the need to swap mmio accesses? We're using readl_relaxed() /
> writel_relaxed(), and they do the swapping already. Am I missing
> something?
> 

Sorry for being unclear. This was exactly my point: readl_relaxed()
has to do swaps internally, and you can also do swaps when accessing
the descriptor in memory.

	Arnd

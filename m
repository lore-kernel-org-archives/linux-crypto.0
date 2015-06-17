From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v7 05/14] crypto: marvell/CESA: add TDMA support
Date: Wed, 17 Jun 2015 17:58:28 +0200
Message-ID: <20150617175828.2a83cda6@bbrezillon>
References: <20150617122533.GA13185@gondor.apana.org.au>
	<1434547922-10363-1-git-send-email-boris.brezillon@free-electrons.com>
	<20150617150808.GA14915@gondor.apana.org.au>
	<20150617173402.7946bbb0@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
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
	Imre Kaloz <kaloz@openw
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:38280 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754990AbbFQP6c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 11:58:32 -0400
In-Reply-To: <20150617173402.7946bbb0@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 17 Jun 2015 17:34:02 +0200
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> On Wed, 17 Jun 2015 23:08:08 +0800
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > On Wed, Jun 17, 2015 at 03:32:02PM +0200, Boris Brezillon wrote:
> > >
> > > Hi Herbert,
> > > 
> > > I send you this patch alone so that you can verify I'm now properly
> > > manipulating the SG list. Once I have your confirmation I'll send
> > > the whole series again and annoy all the people in Cc one more time
> > > ;-).
> > 
> > Thanks.  The only problem that I can see is the fact you're not
> > checking for req->src == req->dst.  If they're equal then you must
> > not map it twice.  Instead it should be mapped as DMA_BIDIRECTIONAL.
> 
> I can check for that too, but note that it doesn't prevent one from
> providing different scatterlist structures pointing to the same memory
> region.

Actually, I don't know if it's a problem or not, so if it's not, please
ignore my comment.

> This being said, checking for req->src == req->dst should fix the case
> where dst and src are pointing to the same scatterlist, which is a good
> start.

Here is an incremental patch [1], please let me know if something else
is missing.

Thanks,

Boris

[1]http://code.bulix.org/x8mz8x-88568


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

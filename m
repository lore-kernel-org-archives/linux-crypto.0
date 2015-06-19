From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v7 04/14] crypto: add a new driver for Marvell's CESA
Date: Fri, 19 Jun 2015 10:24:07 +0200
Message-ID: <20150619102407.01187ff0@free-electrons.com>
References: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
	<1434635190-27733-5-git-send-email-boris.brezillon@free-electrons.com>
	<20150619064256.GA10246@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
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
	Imre Kaloz <kaloz@openwrt.org>,
	Russell King - ARM Linux <linux@arm
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:58753 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753740AbbFSIYP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2015 04:24:15 -0400
In-Reply-To: <20150619064256.GA10246@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

On Fri, 19 Jun 2015 14:42:56 +0800, Herbert Xu wrote:
> On Thu, Jun 18, 2015 at 03:46:20PM +0200, Boris Brezillon wrote:
> >
> > +	dram = mv_mbus_dram_info_nooverlap();
> 
> This doesn't compile because it hasn't made it into mainline yet.
> I'm afraid this patch-set will have to wait until that happens.

We have two options here:

 1/ We can ask the mach-mvebu maintainers to provide a branch with just
    the commit implementing mv_mbus_dram_info_nooverlap(), and you
    merge that branch into your tree as a dependency.

 2/ We temporarily revert back to using mv_mbus_dram_info(). For the
    vast majority of platforms, this is OK. It's only if you have 4 GB
    of RAM or more that it causes problem. And then we switch to
    mv_mbus_dram_info_nooverlap() as part of the -rc cycle.

(2) is probably easier. Herbert, what do you think?

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

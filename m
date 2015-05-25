From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 02/16] crypto: add a new driver for Marvell's CESA
Date: Mon, 25 May 2015 13:17:13 +0200
Message-ID: <20150525131713.38acbad6@bbrezillon>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
	<1432301642-11470-3-git-send-email-boris.brezillon@free-electrons.com>
	<20150525075812.GA28689@gondor.apana.org.au>
	<20150525101016.252a1dc0@bbrezillon>
	<op.xy6tguug2s3iss@ecaz>
	<20150525130812.375cfebc@bbrezillon>
	<op.xy6us5v52s3iss@ecaz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, "Arnaud Ebalard" <arno@natisbad.org>,
	"Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>,
	"Gregory CLEMENT" <gregory.clement@free-electrons.com>,
	"Jason Cooper" <jason@lakedaemon.net>,
	"Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>,
	"Andrew Lunn" <andrew@lunn.ch>,
	"Tawfik Bayouk" <tawfik@marvell.com>,
	"Lior Amsalem" <alior@marvell.com>,
	"Nadav Haklai" <nadavh@marvell.com>,
	"Eran Ben-Avi" <benavi@marvell.com>,
	"Rob Herring" <robh+dt@kernel.org>,
	"Pawel Moll" <pawel.moll@arm.com>,
	"Mark Rutland" <mark.rutland@arm.com>,
	"Ian Campbell" <ijc+devicetree@hellion.org.uk>,
	"Kumar Gala" <galak@codeaurora.org>, devicetree@vger.kernel.org
To: "Imre Kaloz" <kaloz@openwrt.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57775 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751199AbbEYLRQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 May 2015 07:17:16 -0400
In-Reply-To: <op.xy6us5v52s3iss@ecaz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 25 May 2015 13:13:43 +0200
"Imre Kaloz" <kaloz@openwrt.org> wrote:

> Hi Boris,
> 
> On Mon, 25 May 2015 13:08:12 +0200, Boris Brezillon  
> <boris.brezillon@free-electrons.com> wrote:
> 
> >> > Yep, I noticed that after submitting this version. I guess I only
> >> > needed the import function for my test cases and thus forgot to
> >> > implement the import function.
> >> > Anyway, I just added the the import functions (they'll be available in
> >> > my v4).
> >>
> >> Given the driver is supposed to work on platforms up to 38x, could v4
> >> include the missing bindings for those platforms, too?
> >
> > Sure, what's missing ?
> > I already added the cesazX clocks and the "marvell,armada-38x-crypto"
> > compatible string ?
> >
> 
> Sorry, I didn't word it right - the series is missing the crypto nodes for  
> the orion, 375 and 38x platforms.

I only add nodes for platforms I have tested on.
If you're able to test on those platforms I'd be happy to include those
changes in the upcoming version.


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

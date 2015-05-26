From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v3 16/16] ARM: marvell/dt: add crypto node to kirkwood
 dtsi
Date: Tue, 26 May 2015 09:06:29 +0000
Message-ID: <20150526090629.GB13641@io.lakedaemon.net>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
 <1432301642-11470-17-git-send-email-boris.brezillon@free-electrons.com>
 <55634221.6050504@free-electrons.com>
 <20150525164651.GA13641@io.lakedaemon.net>
 <20150525204302.7c79afbf@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [54.186.218.12] ([54.186.218.12]:57058 "HELO
	pmta2.delivery5.ore.mailhop.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751464AbbEZJ0c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 05:26:32 -0400
Content-Disposition: inline
In-Reply-To: <20150525204302.7c79afbf@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 25, 2015 at 08:43:02PM +0200, Boris Brezillon wrote:
> Jason, Gregory,
> 
> On Mon, 25 May 2015 16:46:51 +0000
> Jason Cooper <jason@lakedaemon.net> wrote:
> 
> > On Mon, May 25, 2015 at 05:39:13PM +0200, Gregory CLEMENT wrote:
> > > Hi Boris, Arnaud,
> > > 
> > > On 22/05/2015 15:34, Boris Brezillon wrote:
> > > > From: Arnaud Ebalard <arno@natisbad.org>
> > > > 
> > > > Add crypto related nodes to kirkwood.dtsi.
> > > 
> > > Here you use a new compatible string but with an old binding
> > > to let the user chose between the old and the new driver. Am I right?
> 
> That was not the intention, but you're right, that's exactly what's
> happening here.
> 
> > 
> > I thought we had settled on the user choosing by module load/ which driver is
> > compiled in?  The DT should be describing the hardware, not which driver the
> > user chooses to use.
> 
> Right, but I didn't want to add new compatible strings to the old
> driver in the first place, neither I wanted to support the new way of
> defining/referencing the crypto SRAMs.


> ITOH, if we want to benefit from the TDMA optimization on Kirkwood SoCs,
> we have to add a new compatible (unlike Orion SoCs, Kirkwood ones embed
> a TDMA engine).

Ah, there's the HW difference I must have missed in my previous thousand-foot
overview scans :-/

So "marvell,orion-crypto" matches IP blocks without the TDMA engine,
"marvell,kirkwood-crypto" matches IP blocks *with* the TDMA engine.

> This leaves the following solutions:
>  - avoid changing the compatible in existing orion and kirkwood dtsi
>    files

no, in light of the above HW difference, it makes sense to change these.

>  - adding kirkwood compatible string support to the existing CESA
>    driver (and I think supporting the new approach to retrieve SRAM
>    memory region would make sense too)

Or, old driver matches "marvell,orion-crypto", and the new driver matches
either compatible string.  If dt has "marvell,kirkwood-crypto" then new driver
enables TDMA with the provided properties.

We then update the dtsi for all but orion to "marvell,kirkwood-crypto".

This may be what you are already doing.  If so, please ignore my rambling. ;-)

thx,

Jason.

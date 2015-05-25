From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 16/16] ARM: marvell/dt: add crypto node to kirkwood
 dtsi
Date: Mon, 25 May 2015 20:43:02 +0200
Message-ID: <20150525204302.7c79afbf@bbrezillon>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
	<1432301642-11470-17-git-send-email-boris.brezillon@free-electrons.com>
	<55634221.6050504@free-electrons.com>
	<20150525164651.GA13641@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:39791 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751781AbbEYSnI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 May 2015 14:43:08 -0400
In-Reply-To: <20150525164651.GA13641@io.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jason, Gregory,

On Mon, 25 May 2015 16:46:51 +0000
Jason Cooper <jason@lakedaemon.net> wrote:

> On Mon, May 25, 2015 at 05:39:13PM +0200, Gregory CLEMENT wrote:
> > Hi Boris, Arnaud,
> > 
> > On 22/05/2015 15:34, Boris Brezillon wrote:
> > > From: Arnaud Ebalard <arno@natisbad.org>
> > > 
> > > Add crypto related nodes to kirkwood.dtsi.
> > 
> > Here you use a new compatible string but with an old binding
> > to let the user chose between the old and the new driver. Am I right?

That was not the intention, but you're right, that's exactly what's
happening here.

> 
> I thought we had settled on the user choosing by module load/ which driver is
> compiled in?  The DT should be describing the hardware, not which driver the
> user chooses to use.

Right, but I didn't want to add new compatible strings to the old
driver in the first place, neither I wanted to support the new way of
defining/referencing the crypto SRAMs.
ITOH, if we want to benefit from the TDMA optimization on Kirkwood SoCs,
we have to add a new compatible (unlike Orion SoCs, Kirkwood ones embed
a TDMA engine).

This leaves the following solutions:
 - avoid changing the compatible in existing orion and kirkwood dtsi
   files
 - adding kirkwood compatible string support to the existing CESA
   driver (and I think supporting the new approach to retrieve SRAM
   memory region would make sense too)

Best Regards,

Boris
-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v3 16/16] ARM: marvell/dt: add crypto node to kirkwood
 dtsi
Date: Mon, 25 May 2015 16:46:51 +0000
Message-ID: <20150525164651.GA13641@io.lakedaemon.net>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
 <1432301642-11470-17-git-send-email-boris.brezillon@free-electrons.com>
 <55634221.6050504@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
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
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from erouter8.ore.mailhop.org ([54.187.218.212]:32367 "HELO
	outbound3.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750853AbbEYRC5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 May 2015 13:02:57 -0400
Content-Disposition: inline
In-Reply-To: <55634221.6050504@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 25, 2015 at 05:39:13PM +0200, Gregory CLEMENT wrote:
> Hi Boris, Arnaud,
> 
> On 22/05/2015 15:34, Boris Brezillon wrote:
> > From: Arnaud Ebalard <arno@natisbad.org>
> > 
> > Add crypto related nodes to kirkwood.dtsi.
> 
> Here you use a new compatible string but with an old binding
> to let the user chose between the old and the new driver. Am I right?

I thought we had settled on the user choosing by module load/ which driver is
compiled in?  The DT should be describing the hardware, not which driver the
user chooses to use.

thx,

Jason.

> > Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  arch/arm/boot/dts/kirkwood.dtsi | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
> > index 464f09a..1700b2b 100644
> > --- a/arch/arm/boot/dts/kirkwood.dtsi
> > +++ b/arch/arm/boot/dts/kirkwood.dtsi
> > @@ -41,7 +41,7 @@
> >  		pcie-io-aperture  = <0xf2000000 0x100000>;   /*   1 MiB    I/O space */
> >  
> >  		cesa: crypto@0301 {
> > -			compatible = "marvell,orion-crypto";
> > +			compatible = "marvell,kirkwood-crypto";
> >  			reg = <MBUS_ID(0xf0, 0x01) 0x30000 0x10000>,
> >  			      <MBUS_ID(0x03, 0x01) 0 0x800>;
> >  			reg-names = "regs", "sram";
> > 
> 
> 
> -- 
> Gregory Clement, Free Electrons
> Kernel, drivers, real-time and embedded Linux
> development, consulting, training and support.
> http://free-electrons.com

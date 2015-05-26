From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 15/16] ARM: marvell/dt: add crypto node to armada 370
 dtsi
Date: Tue, 26 May 2015 11:03:45 +0200
Message-ID: <20150526110345.663efb51@bbrezillon>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
	<1432301642-11470-16-git-send-email-boris.brezillon@free-electrons.com>
	<556340C4.5090208@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
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
Received: from [37.187.137.238] ([37.187.137.238]:48998 "EHLO
	mail.free-electrons.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752010AbbEZJEI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 05:04:08 -0400
In-Reply-To: <556340C4.5090208@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Gregory,

On Mon, 25 May 2015 17:33:24 +0200
Gregory CLEMENT <gregory.clement@free-electrons.com> wrote:

> Hi Boris, Arnaud,
> 
> 
> 
> On 22/05/2015 15:34, Boris Brezillon wrote:
> > From: Arnaud Ebalard <arno@natisbad.org>
> > 
> > Add crypto related nodes in armada-370.dtsi.
> > 
> > Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  arch/arm/boot/dts/armada-370.dtsi | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/armada-370.dtsi b/arch/arm/boot/dts/armada-370.dtsi
> > index 00b50db5..1255318 100644
> > --- a/arch/arm/boot/dts/armada-370.dtsi
> > +++ b/arch/arm/boot/dts/armada-370.dtsi
> > @@ -307,6 +307,26 @@
> >  					dmacap,memset;
> >  				};
> >  			};
> > +
> > +			crypto@90000 {
> > +				compatible = "marvell,armada-370-crypto";
> > +				reg = <0x90000 0x10000>;
> > +				reg-names = "regs";
> > +				interrupts = <48>;
> 
> There is no clocks property. After a quick look on the datasheet, indeed I didn't
> find any clock which match the CESA. In this case you should update the binding
> documentation by adding that the clock is optional for armada-370-crypto.

Hm, actually the clock is defined in Marvell's LSP, but not described
in the datasheet. Which one should I trust :-) ?

Anyway, if this clock appears to be present on armada-370, we'll have
to modify the clock driver to account for this before referencing the
clock in the crypto node.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

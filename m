From: Lior Amsalem <alior@marvell.com>
Subject: RE: [PATCH 8/8] ARM: mvebu: a38x: Enable A38x XOR engine features
Date: Wed, 13 May 2015 07:16:34 +0000
Message-ID: <14c9a6d3ba4c46f89880e4c1b4494dbb@IL-EXCH02.marvell.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
 <1431445063-20226-9-git-send-email-maxime.ripard@free-electrons.com>
 <20150512161314.GL19927@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	"dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Andrew Lunn <andrew@lunn.ch>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19430 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954AbbEMHRz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2015 03:17:55 -0400
In-Reply-To: <20150512161314.GL19927@lunn.ch>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> From: Andrew Lunn [mailto:andrew@lunn.ch]
> Sent: Tuesday, May 12, 2015 7:13 PM
> 
> On Tue, May 12, 2015 at 05:37:43PM +0200, Maxime Ripard wrote:
> > From: Lior Amsalem <alior@marvell.com>
> >
> > The new XOR engine has a new compatible of its own, together with new
> > channel capabilities.
> >
> > Use that new compatible now that we have a driver that can handle it.
> >
> > Signed-off-by: Lior Amsalem <alior@marvell.com>
> > Reviewed-by: Ofer Heifetz <oferh@marvell.com>
> > Reviewed-by: Nadav Haklai <nadavh@marvell.com>
> > Tested-by: Nadav Haklai <nadavh@marvell.com>
> > ---
> >  arch/arm/boot/dts/armada-38x.dtsi | 20 ++++++--------------
> >  1 file changed, 6 insertions(+), 14 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/armada-38x.dtsi
> > b/arch/arm/boot/dts/armada-38x.dtsi
> > index ed2dd8ba4080..6d07b7389415 100644
> > --- a/arch/arm/boot/dts/armada-38x.dtsi
> > +++ b/arch/arm/boot/dts/armada-38x.dtsi
> > @@ -448,7 +448,7 @@
> >  			};
> >
> >  			xor@60800 {
> > -				compatible = "marvell,orion-xor";
> > +				compatible = "marvell,a38x-xor";
> >  				reg = <0x60800 0x100
> >  				       0x60a00 0x100>;
> >  				clocks = <&gateclk 22>;
> > @@ -458,17 +458,13 @@
> >  					interrupts = <GIC_SPI 22
> IRQ_TYPE_LEVEL_HIGH>;
> >  					dmacap,memcpy;
> >  					dmacap,xor;
> > -				};
> > -				xor01 {
> > -					interrupts = <GIC_SPI 23
> IRQ_TYPE_LEVEL_HIGH>;
> > -					dmacap,memcpy;
> > -					dmacap,xor;
> > -					dmacap,memset;
> > +					dmacap,pq;
> > +					dmacap,interrupt;
> 
> Does this mean the hardware only has one channel?
> And memset is no longer supported?
> 

The hardware has two channels per engine and two engines.
However, both on HW side (both channels are on the same "bus port")
and SW (the dma subsystem will assign one channel per CPU).
we found it's better (performance wise) to use only one channel on each engine
and let the framework assign one per CPU.
This way, descriptors chaining was better (cause of the depended descriptors
problem) and overall interrupt number reduced.

Yes, since memset is a problematic one. It can only be done via registers
(and not on descriptors level) plus no one really needs it...

>     Andrew
> 
> 
> >  				};
> >  			};
> >
> >  			xor@60900 {
> > -				compatible = "marvell,orion-xor";
> > +				compatible = "marvell,a38x-xor";
> >  				reg = <0x60900 0x100
> >  				       0x60b00 0x100>;
> >  				clocks = <&gateclk 28>;
> > @@ -478,12 +474,8 @@
> >  					interrupts = <GIC_SPI 65
> IRQ_TYPE_LEVEL_HIGH>;
> >  					dmacap,memcpy;
> >  					dmacap,xor;
> > -				};
> > -				xor11 {
> > -					interrupts = <GIC_SPI 66
> IRQ_TYPE_LEVEL_HIGH>;
> > -					dmacap,memcpy;
> > -					dmacap,xor;
> > -					dmacap,memset;
> > +					dmacap,pq;
> > +					dmacap,interrupt;
> >  				};
> >  			};
> >
> > --
> > 2.4.0
> >


Regards,
Lior Amsalem

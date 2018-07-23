From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH 13/14] arm64: dts: marvell: armada-cp110: update the
 crypto engine compatible
Date: Mon, 23 Jul 2018 09:21:52 +0200
Message-ID: <20180723072152.GA3456@kwain>
References: <20180628151544.22134-1-antoine.tenart@bootlin.com>
 <20180628151544.22134-14-antoine.tenart@bootlin.com>
 <CAOesGMjx_Qprh+4Y6GM4BqGOeJtKWwAhkFNvBz0PGqQkyuRtrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        maxime.chevallier@bootlin.com, miquel.raynal@bootlin.com,
        Nadav Haklai <nadavh@marvell.com>, oferh@marvell.com,
        igall@marvell.com
To: Olof Johansson <olof@lixom.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOesGMjx_Qprh+4Y6GM4BqGOeJtKWwAhkFNvBz0PGqQkyuRtrw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Olof,

On Sat, Jul 21, 2018 at 02:35:01PM -0700, Olof Johansson wrote:
> On Thu, Jun 28, 2018 at 8:15 AM, Antoine Tenart
> <antoine.tenart@bootlin.com> wrote:
> > New compatibles are now supported by the Inside Secure SafeXcel driver.
> > As they are more specific than the old ones, they should be used
> > whenever possible. This patch updates the Marvell cp110 device tree
> > accordingly.
> >
> > Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> > ---
> >  arch/arm64/boot/dts/marvell/armada-cp110.dtsi | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/boot/dts/marvell/armada-cp110.dtsi b/arch/arm64/boot/dts/marvell/armada-cp110.dtsi
> > index 2bf083272a87..bb2914f90048 100644
> > --- a/arch/arm64/boot/dts/marvell/armada-cp110.dtsi
> > +++ b/arch/arm64/boot/dts/marvell/armada-cp110.dtsi
> > @@ -427,7 +427,7 @@
> >                 };
> >
> >                 CP110_LABEL(crypto): crypto@800000 {
> > -                       compatible = "inside-secure,safexcel-eip197";
> > +                       compatible = "inside-secure,safexcel-eip197b";
> 
> So the device is still compatible with the less-specific binding,
> right? If so, it should probably have both compatible properties in
> there, not just the more specific one.

Using "safexcel-eip197" as a compatible was a mistake as there's no such
thing as an eip197, they all have minor versions (such as 'b').

I've thought about using the compatible for a less specific binding, but
this isn't true for the other patch, using the compatible ending in
"-eip97". The engine it supports is the most specific one (i.e. with the
largest number of algorithms supported). So it would simply not work,
and as we only have a few device trees supporting the engine as of now,
I thought fixing this by removing the wrong compatible was a better
solution (of course the driver is backward compatible, and using the old
compatibles will still work).

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

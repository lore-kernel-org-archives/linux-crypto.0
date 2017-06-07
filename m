From: Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/4] dt-bindings: rng: add generic bindings for MediaTek
 SoCs
Date: Wed, 7 Jun 2017 21:20:19 +0800
Message-ID: <1496841619.30833.5.camel@mtkswgap22>
References: <cover.1496255334.git.sean.wang@mediatek.com>
         <1d9c981e1b45bf2f04732a02d90e6857cc203ce5.1496255334.git.sean.wang@mediatek.com>
         <9eb87222-ca89-0abb-4532-3887008f6e7a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        <romain.perier-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, <shannon.nelson-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <keyhaede-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
To: Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9eb87222-ca89-0abb-4532-3887008f6e7a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2017-06-06 at 13:07 +0200, Matthias Brugger wrote:
> 
> On 31/05/17 20:44, sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org wrote:
> > From: Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > 
> > Add the generic binding for allowing the support of RNG on MediaTek SoCs
> > such as MT7622.
> > 
> > Signed-off-by: Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > ---
> >   Documentation/devicetree/bindings/rng/mtk-rng.txt | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.txt b/Documentation/devicetree/bindings/rng/mtk-rng.txt
> > index a6d62a2..0772913 100644
> > --- a/Documentation/devicetree/bindings/rng/mtk-rng.txt
> > +++ b/Documentation/devicetree/bindings/rng/mtk-rng.txt
> > @@ -2,7 +2,8 @@ Device-Tree bindings for Mediatek random number generator
> >   found in Mediatek SoC family
> >   
> >   Required properties:
> > -- compatible	    : Should be "mediatek,mt7623-rng"
> > +- compatible	    : Should be "mediatek,generic-rng" or
> > +				"mediatek,mt7623-rng".
> 
> What does generic-rng mean. Is it for all mt7xxx, or also for mt6xxx and 
> mt8xxx based SoCs? I think we should stick with SoC specific bindings, 
> as we don't know if Mediatek won't publish a new IP block next year 
> which is differnet.
> 

Yes, what I mean is generic-rng can be applied to all
platform MediaTek provides. 


> Just in case we should add a binding for the actual SoC + a fallback. 
> For example.
> - compatible " Should be
> 	"mediatek,mt7622-rng", 	"mediatek,mt7623-rng" for SoC mt7622
> 	"mediatek,mt7623-rng" for SoC mt7623
> 
> This will also eliminate the need of adding mt6722-rng to the driver, as 
> it will use mt7623-rng as fallback. If in the future we realize that 
> mt7622-rng has a extra feature/bug, we can still work around it, without 
> breaking the bindings.
> 

I knew the fallback rules you said here because I saw them being used in
many drivers such as sysirq and uart driver, such kind of basic drivers.

These drivers are basic enough, various following chipsets almost fall
back into the oldest one. So the clues let me think the hardware
interface shouldn't have too much differences among them.

If there is string used like generic-uart or generic-sysirq, it can
stop we blindly add new string into the binding document when a new
platform is introduced. 

And they easily allows users unfamiliar MediaTek platform (they didn't
know what the oldest MediaTek chipset is) pick up the right compatible
string to start bring up the new platform. 

The specific one can be added after new feature required is added or
critical hardware bug is found. Otherwise the generic one can fit 
all generic needs for those.

Those are only opinions, if you don't like it, I still can accept the
original way as you suggest :)


> Makes sense?
> 
> Regards,
> Matthias
> 
> >   - clocks	    : list of clock specifiers, corresponding to
> >   		      entries in clock-names property;
> >   - clock-names	    : Should contain "rng" entries;
> > 


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

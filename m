From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 0/4] staging: add ccree crypto driver
Date: Tue, 18 Apr 2017 16:43:50 +0100
Message-ID: <20170418154349.GJ17866@leverpostej>
References: <1492524470-13847-1-git-send-email-gilad@benyossef.com>
 <20170418151355.GI17866@leverpostej>
 <CAOtvUMeB8ub-e6PXxgJWyK=TW4HseZgSN6NO=kSmVax514ufdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Gilad Ben-Yossef <gilad.benyossef-5wv7dgnIgG8@public.gmane.org>,
        Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>
To: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOtvUMeB8ub-e6PXxgJWyK=TW4HseZgSN6NO=kSmVax514ufdg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 18, 2017 at 06:29:22PM +0300, Gilad Ben-Yossef wrote:
> On Tue, Apr 18, 2017 at 6:13 PM, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > On Tue, Apr 18, 2017 at 05:07:50PM +0300, Gilad Ben-Yossef wrote:
> >> Arm TrustZone CryptoCell 700 is a family of cryptographic hardware
> >> accelerators. It is supported by a long lived series of out of tree
> >> drivers, which I am now in the process of unifying and upstreaming.
> >> This is the first drop, supporting the new CryptoCell 712 REE.
> >>
> >> The code still needs some cleanup before maturing to a proper
> >> upstream driver, which I am in the process of doing. However,
> >> as discussion of some of the capabilities of the hardware and
> >> its application to some dm-crypt and dm-verity features recently
> >> took place I though it is better to do this in the open via the
> >> staging tree.
> >>
> >> A Git repository based off of Linux 4.11-rc7 is available at
> >> https://github.com/gby/linux.git branch ccree.
> >>
> >> Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
> >> CC: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >> CC: Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>
> >>
> >> Gilad Ben-Yossef (4):
> >>   staging: add ccree crypto driver
> >>   staging: ccree: add TODO list
> >>   staging: ccree: add devicetree bindings
> >>   MAINTAINERS: add Gilad BY as maintainer for ccree
> >>
> >>  .../devicetree/bindings/crypto/arm-cryptocell.txt  |   23 +
> >
> > I'm interested in looking at the DT binding, but for some reason I've
> > only recevied the cover letter so far.
> >
> > Are my mail servers being particularly slow today, or has something gone
> > wrong with the Cc list for the remaining patches?
> >
> 
> Thanks a bunch for the willingness to review this.
> 
> My apologies for not communicating this clearly enough -  Since it is
> an pre-existing driver it is rather big.
> I did not want to inflict a 600K patch on the mailing list so opted to
> provide a git repo instead, as stated in the
> email.

Should this have been a [GIT PULL], then?

I was confused by the [PATCH 0/4].

> The patch in question is here:
> https://github.com/gby/linux/commit/12d92e0bc19aa9bbd891cdab765eaaeabe0b6967
> 
> Do let me know if you prefer that I will send at least the smaller
> patch file via email in the normal fashion.

Sending patches is the usual way to have things reviewed. Linking to an
external site doesn't fit with the workflows of everyone.

If you wish to have patches reviewed, please send them as patches in the
usual fashion.

I will note that on the patch you linked, the compatible string is far
too vague, per common conventions. Per your description above, that
should be something like "arm,cryptocell-712-ree" (and each variant
should have its own string).

I don't have documentation to hand to attempt to review the rest.

I would appreciate if you could ensure that the DT binding was reviewed
as part of the staging TODOs. That needs to follow the usual DT review
process of sending patches to the list. Until that has occurred, it
shouldn't be in Documentation/devicetree/.

Thanks,
Mark.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

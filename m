From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] dt-bindings: rng: clocks property on omap_rng not
 always mandatory
Date: Fri, 24 Mar 2017 09:19:05 -0500
Message-ID: <20170324141905.scn7vrzrcrmzplk5@rob-hp-laptop>
References: <1489755519-32664-1-git-send-email-thomas.petazzoni@free-electrons.com>
 <20170324135200.j7m3zzgphbetqn7p@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
        Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, romain.perier-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org,
        Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
        Hanna Hawa <hannah-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
        Yehuda Yitschak <yehuday-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
        Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
        Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Gregory Clement <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
        stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170324135200.j7m3zzgphbetqn7p@rob-hp-laptop>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 24, 2017 at 08:52:00AM -0500, Rob Herring wrote:
> On Fri, Mar 17, 2017 at 01:58:39PM +0100, Thomas Petazzoni wrote:
> > Commit 52060836f79 ("dt-bindings: omap-rng: Document SafeXcel IP-76
> > device variant") update the omap_rng Device Tree binding to add support
> > for the IP-76 variation of the IP. As part of this change, a "clocks"
> > property was added, but is indicated as "Required", without indicated
> > it's actually only required for some compatible strings.
> > 
> > This commit fixes that, by explicitly stating that the clocks property
> > is only required with the inside-secure,safexcel-eip76 compatible
> > string.
> > 
> > Fixes: 52060836f79 ("dt-bindings: omap-rng: Document SafeXcel IP-76 device variant")
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > Signed-off-by: Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> > ---
> > Changes since v1:
> >  - Instead of indicating the property as optional, indicate it as
> >    mandatory for the inside-secure,safexcel-eip76 compatible string, as
> >    suggested by Rob Herring.
> > ---
> >  Documentation/devicetree/bindings/rng/omap_rng.txt | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

And applied.

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

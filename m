From: Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] dt-bindings: rng: clocks property on omap_rng is
 optional
Date: Fri, 17 Mar 2017 13:57:06 +0100
Message-ID: <20170317135706.4ad30514@free-electrons.com>
References: <1488896308-17731-1-git-send-email-thomas.petazzoni@free-electrons.com>
        <20170315175737.vfy5omissjkyyie7@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
        Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
        Deepak Saxena <dsaxena-k7pgMgclrJvR7s880joybQ@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, romain.perier-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org,
        Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
        Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Gregory Clement <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
        Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
        Hanna Hawa <hannah-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
        Yehuda Yitschak <yehuday-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170315175737.vfy5omissjkyyie7@rob-hp-laptop>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hello,

On Wed, 15 Mar 2017 12:57:37 -0500, Rob Herring wrote:

> > diff --git a/Documentation/devicetree/bindings/rng/omap_rng.txt b/Documentation/devicetree/bindings/rng/omap_rng.txt
> > index 4714772..20d435da 100644
> > --- a/Documentation/devicetree/bindings/rng/omap_rng.txt
> > +++ b/Documentation/devicetree/bindings/rng/omap_rng.txt
> > @@ -12,6 +12,9 @@ Required properties:
> >  - reg : Offset and length of the register set for the module
> >  - interrupts : the interrupt number for the RNG module.
> >  		Used for "ti,omap4-rng" and "inside-secure,safexcel-eip76"
> > +
> > +Optional properties:
> > +  
> 
> Wouldn't just "for ? compatible only" be more correct?

I don't know if at the HW point of view the EIP76 will *always* need a
clock. Maybe it depends on the integration in the SoC.

But anyway, let's mark the clocks property as mandatory for
"inside-secure,safexcel-eip76" for the moment, we can always relax this
requirement later on if we realize that some EIP76 have been integrated
in a way that doesn't require a clock.

It is worth mentioning that the actual driver implementation simply
makes the clock optional in all cases, without looking at the
compatible to figure out if the clock must be there or not. But that's
just the current driver implementation. The Device Tree binding
specification can be more specific than what the current driver does.

Therefore: v2 coming.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

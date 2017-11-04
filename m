From: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>
Subject: Re: [PATCH 07/12] hwrng: bcm2835-rng: Manage an optional clock
Date: Sat, 4 Nov 2017 20:37:31 +0100
Message-ID: <20171104193731.GA751@lunn.ch>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
 <20171102010408.27736-8-f.fainelli@gmail.com>
 <944505791.223880.1509803454887@email.1und1.de>
 <e12063f9-86e4-e9ce-2a7f-f85fe2ce352f@gmail.com>
 <547786283.132202.1509819754396@email.1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
        Martin Kaiser <martin-XxZfDwE/svGeZLLa646FqQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>,
        Harald Freudenberger <freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "maintainer:BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE..."
        <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <l
To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <547786283.132202.1509819754396-7tX72C7vayboQLBSYMtkGA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Florian

> > >> +	/* Clock is optional on most platforms */
> > >> +	priv->clk = devm_clk_get(dev, NULL);
> > >> +	if (IS_ERR(priv->clk))
> > >> +		priv->clk = NULL;
> > > 
> > > at least in case of EPROBE_DEFERED this isn't the expected behavior. Maybe we should better trigger on non-existing clock?
> > 
> > Good point, so more like:
> > 
> > if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -ENODEV)?
> 

> Unfortunately we need to return the error in all other cases. Please
> take a look at devm_usb_get_phy in dwc2 [1]. AFAIK we don't need to
> take care of ENXIO in our case.

A few subsystems have a get_optional() call, e.g.
devm_phy_optional_get(). It does not return an error when the phy is
not supposed to exist, but in all other cases, it does.

Maybe consider adding devm_clk_get_optional()?

      Andrew
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

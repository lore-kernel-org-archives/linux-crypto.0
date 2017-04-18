From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 0/4] staging: add ccree crypto driver
Date: Tue, 18 Apr 2017 17:39:51 +0200
Message-ID: <20170418153951.GA31214@kroah.com>
References: <1492524470-13847-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        gilad.benyossef-5wv7dgnIgG8@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>
To: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492524470-13847-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 18, 2017 at 05:07:50PM +0300, Gilad Ben-Yossef wrote:
> Arm TrustZone CryptoCell 700 is a family of cryptographic hardware
> accelerators. It is supported by a long lived series of out of tree
> drivers, which I am now in the process of unifying and upstreaming.
> This is the first drop, supporting the new CryptoCell 712 REE. 
> 
> The code still needs some cleanup before maturing to a proper
> upstream driver, which I am in the process of doing. However,
> as discussion of some of the capabilities of the hardware and
> its application to some dm-crypt and dm-verity features recently
> took place I though it is better to do this in the open via the
> staging tree.
> 
> A Git repository based off of Linux 4.11-rc7 is available at
> https://github.com/gby/linux.git branch ccree.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
> CC: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> CC: Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>
> 
> Gilad Ben-Yossef (4):
>   staging: add ccree crypto driver
>   staging: ccree: add TODO list
>   staging: ccree: add devicetree bindings
>   MAINTAINERS: add Gilad BY as maintainer for ccree

We can't do much without a real patch, sorry.  Digging in random git
trees doesn't work :(

I can't take this as-is, I need patches.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

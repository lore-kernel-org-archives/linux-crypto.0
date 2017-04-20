From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 0/9] staging: ccree: add Arm TrustZone CryptoCell REE
 driver
Date: Thu, 20 Apr 2017 15:30:52 +0200
Message-ID: <20170420133052.GA8998@kroah.com>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gilad.benyossef-5wv7dgnIgG8@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Stuart Yoder <stuart.yoder-5wv7dgnIgG8@public.gmane.org>,
        Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>
To: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492693983-8175-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 20, 2017 at 04:12:54PM +0300, Gilad Ben-Yossef wrote:
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
> A Git repository based off of Linux 4.11-rc7 is also available at
> https://github.com/gby/linux.git branch ccree_v2 for those inclined.

If you want this in staging, I'll be glad to take it, but note then you
can't work off of an external repo, as syncing the two is almost
impossible and more work than you want to go through.

So, as long as this builds properly, want me to queue these up in my
tree?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

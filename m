From: Marek Vasut <marex-ynQEQJNshbs@public.gmane.org>
Subject: Re: [PATCH v3 1/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Sun, 22 Jun 2014 14:23:15 +0200
Message-ID: <201406221423.15193.marex@denx.de>
References: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com> <201406142101.02747.marex@denx.de> <53A6C4D0.1030102@gmail.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: Text/Plain; charset=ISO-8859-1
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
 pawel.moll-5wv7dgnIgG8@public.gmane.org,
 mark.rutland-5wv7dgnIgG8@public.gmane.org,
 ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org,
 galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
 rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
 maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
 linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
 herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
 davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
 grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org,
 devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-sunxi+bncBDIOBYPK6QDRBOEVTOOQKGQEH3M7PIA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <53A6C4D0.1030102-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

On Sunday, June 22, 2014 at 01:58:08 PM, Corentin LABBE wrote:
[...]
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published by
> >> + * the Free Software Foundation version 2 of the License
> > 
> > The license text seems incomplete.
> > [...]
> 
> I will replace it with a simplier line "Licensed under the GPL-2."

I'd suggest you to use the SPDX license identifiers then, but that's not 
something the kernel crowd agreed upon yet IIRC.Therefore , just make the text 
complete please.

[...]

> >> +	src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
> >> +	if (src_addr == NULL) {
> >> +		dev_err(ss->dev, "KMAP error for src SG\n");
> >> +		return -1;
> >> +	}
> > 
> > Why can't you just use dma_map_sg() or somesuch ?
> 
> I do not see why I will use a DMA function in a driver without DMA support.
> Perhaps I do not know some tricks.
> Can I use writel/readl on address gived by DMA API ?

Oh, ok, good question -- dear list, shall one use sg_page()+kmap or sg_virt()?

btw. I just noticed you're just feeding the hardware FIFO in a loop with data in 
the scatterlists, do I understand it correctly ? The driver will consume quite a 
lot of CPU time to do that, can you not implement DMA here ?

[...]

Best regards,
Marek Vasut

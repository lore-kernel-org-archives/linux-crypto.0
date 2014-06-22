From: Marek Vasut <marex-ynQEQJNshbs@public.gmane.org>
Subject: Re: [PATCH v3 1/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Sun, 22 Jun 2014 15:44:29 +0200
Message-ID: <201406221544.29592.marex@denx.de>
References: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com> <201406221423.15193.marex@denx.de> <20140622123335.GE32514@n2100.arm.linux.org.uk>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: Text/Plain; charset=ISO-8859-1
Cc: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
 pawel.moll-5wv7dgnIgG8@public.gmane.org,
 mark.rutland-5wv7dgnIgG8@public.gmane.org,
 ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org,
 galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
 rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
 maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
 herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
 davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
 grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org,
 devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: "Russell King - ARM Linux" <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Return-path: <linux-sunxi+bncBDIOBYPK6QDRBQN3TOOQKGQEGOO66QI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20140622123335.GE32514-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

On Sunday, June 22, 2014 at 02:33:35 PM, Russell King - ARM Linux wrote:
> On Sun, Jun 22, 2014 at 02:23:15PM +0200, Marek Vasut wrote:
> > On Sunday, June 22, 2014 at 01:58:08 PM, Corentin LABBE wrote:
> > [...]
> > 
> > > >> + * This program is free software; you can redistribute it and/or
> > > >> modify + * it under the terms of the GNU General Public License as
> > > >> published by + * the Free Software Foundation version 2 of the
> > > >> License
> > > > 
> > > > The license text seems incomplete.
> > > > [...]
> > > 
> > > I will replace it with a simplier line "Licensed under the GPL-2."
> > 
> > I'd suggest you to use the SPDX license identifiers then, but that's not
> > something the kernel crowd agreed upon yet IIRC.Therefore , just make the
> > text complete please.
> 
> Marek,
> 
> The full text of the first paragraph (in COPYING) is:
> 
>     This program is free software; you can redistribute it and/or modify
>     it under the terms of the GNU General Public License as published by
>     the Free Software Foundation; either version 2 of the License, or
>     (at your option) any later version.
> 
> which is deemed to be entirely sufficient; quoting the full text is
> discouraged, especially when it includes the FSF address.  It is also
> acceptable to restrict it to version 2 only, in which case something
> like this can be used:
> 
>    This program is free software; you can redistribute it and/or modify
>    it under the terms of the GNU General Public License version 2 as
>    published by the Free Software Foundation.
> 
> Of course, it's up to the author to make up their own mind at the end
> of the day.

Ah, I fully agree. Thank you for clarifying this.

> > Oh, ok, good question -- dear list, shall one use sg_page()+kmap or
> > sg_virt()?
> 
> sg_page() + kmap() is preferred, because sg_virt() fails with highmem.
> Using sg_virt() means you restrict the driver to non-highmem memory,
> and if the kernel wants to place the data into a highmem page, it will
> have to use bounce buffers (so it's inefficient).

Ah, thanks for explaining this!

> What's even better is to use the scatterlist iterator, which will handle
> this for you.  See the sg_miter_*() functions.

The scatterwalk ( include/crypto/scatterwalk.h ) should work pretty much the 
same then, right ? But with the added benefit that it's crypto-friendly such 
that it handles both the input and output scatterlists of the crypto 
transformation etc.

Please correct me if I'm mistaken.

Best regards,
Marek Vasut

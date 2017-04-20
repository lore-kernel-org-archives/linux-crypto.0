From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/9] staging: ccree: introduce CryptoCell HW driver
Date: Thu, 20 Apr 2017 16:01:03 +0200
Message-ID: <20170420140103.GA20172@kroah.com>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
 <1492693983-8175-2-git-send-email-gilad@benyossef.com>
 <20170420133308.GB8998@kroah.com>
 <CAOtvUMdH-=VrSS0wYUv99n=67WH53EyPfaby7kDhmgJk05C8gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Rutland <mark.rutland@arm.com>, devel@driverdev.osuosl.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stuart Yoder <stuart.yoder@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37148 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032005AbdDTOBU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 10:01:20 -0400
Content-Disposition: inline
In-Reply-To: <CAOtvUMdH-=VrSS0wYUv99n=67WH53EyPfaby7kDhmgJk05C8gQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 20, 2017 at 04:40:56PM +0300, Gilad Ben-Yossef wrote:
> On Thu, Apr 20, 2017 at 4:33 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Apr 20, 2017 at 04:12:55PM +0300, Gilad Ben-Yossef wrote:
> >> +++ b/drivers/staging/ccree/bsp.h
> >> @@ -0,0 +1,21 @@
> >> +/*
> >> + * Copyright (C) 2012-2016 ARM Limited or its affiliates.
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify it
> >> + * under the terms of the GNU General Public License as published by the Free
> >> + * Software Foundation; either version 2 of the License, or (at your option)
> >> + * any later version.
> >
> > Oh, I have to ask, do you really mean "any later version" here and
> > elsewhere?
> >
> > If so, then your MODULE_LICENSE() marking is wrong, please fix that up,
> > or fix up the license text, I can't take incompatible ones without
> > getting angry emails from legal people sent to me...
> >
> 
> Thanks for noticing this.
> 
> The copyright + license notice is a boilerplate I got from the powers
> that be here.
> 
> I'll consult internally what is the proper action. I don't want to
> make legal mad either... :-)

Ok, I'll drop this patch series then, and wait for an updated one with
this fixed up.

thanks,

greg k-h

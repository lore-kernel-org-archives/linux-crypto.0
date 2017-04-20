From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2 1/9] staging: ccree: introduce CryptoCell HW driver
Date: Thu, 20 Apr 2017 16:40:56 +0300
Message-ID: <CAOtvUMdH-=VrSS0wYUv99n=67WH53EyPfaby7kDhmgJk05C8gQ@mail.gmail.com>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com>
 <1492693983-8175-2-git-send-email-gilad@benyossef.com> <20170420133308.GB8998@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devel@driverdev.osuosl.org, Binoy Jayan <binoy.jayan@linaro.org>,
        devicetree@vger.kernel.org,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Stuart Yoder <stuart.yoder@arm.com>,
        Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:34992 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945941AbdDTNk5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 09:40:57 -0400
Received: by mail-yb0-f177.google.com with SMTP id 6so25030479ybq.2
        for <linux-crypto@vger.kernel.org>; Thu, 20 Apr 2017 06:40:57 -0700 (PDT)
In-Reply-To: <20170420133308.GB8998@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 20, 2017 at 4:33 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Apr 20, 2017 at 04:12:55PM +0300, Gilad Ben-Yossef wrote:
>> +++ b/drivers/staging/ccree/bsp.h
>> @@ -0,0 +1,21 @@
>> +/*
>> + * Copyright (C) 2012-2016 ARM Limited or its affiliates.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License as published by the Free
>> + * Software Foundation; either version 2 of the License, or (at your option)
>> + * any later version.
>
> Oh, I have to ask, do you really mean "any later version" here and
> elsewhere?
>
> If so, then your MODULE_LICENSE() marking is wrong, please fix that up,
> or fix up the license text, I can't take incompatible ones without
> getting angry emails from legal people sent to me...
>

Thanks for noticing this.

The copyright + license notice is a boilerplate I got from the powers
that be here.

I'll consult internally what is the proper action. I don't want to
make legal mad either... :-)


Thanks again,

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

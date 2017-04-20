From: abed mohammad kamaluddin <abedamu@gmail.com>
Subject: Re: [RFC PATCH v1 0/1] *** crypto: AF_ALG: add compression support ***
Date: Thu, 20 Apr 2017 12:39:58 +0530
Message-ID: <CACVarEQ9kW=zF+Zse17LA2KjM-dg7mb6d5XWCvSbg5nCT3=Y6A@mail.gmail.com>
References: <1492108494-10694-1-git-send-email-akamaluddin@cavium.com> <20170414083240.GA26625@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
        "akamaluddin@cavium.com" <akamaluddin@cavium.com>,
        pathreya@cavium.com, mchalla@cavium.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34010 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941875AbdDTHKV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 03:10:21 -0400
Received: by mail-io0-f171.google.com with SMTP id a103so58811650ioj.1
        for <linux-crypto@vger.kernel.org>; Thu, 20 Apr 2017 00:10:21 -0700 (PDT)
In-Reply-To: <20170414083240.GA26625@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> I think we should convert ipcomp over to the new interface first
> in order to make sure that we don't need to change the interface
> which would be hard to do once we export it to user-space.

Would it be acceptable if we export an algif interface using alg_type_compress,
which is being used by ipcomp currently? We would like to use our zip
device from
userspace through this interface.

Thanks
Abed (Cavium)


On Fri, Apr 14, 2017 at 2:02 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Apr 14, 2017 at 12:04:53AM +0530, Abed Kamaluddin wrote:
>> Hi Herbert,
>>
>> This patch adds compression support to the AF_ALG interface exported by the
>> kernel crypto API. By extending AF_ALG, all compression algorithms of types
>> scomp and acomp, which the kernel crypto API allows access to, are now also
>> accessible from userspace.
>>
>> The new compression interface has been tested with both kernel software
>> deflate(scomp) and HW accelerated ThunderX deflate(scomp) using the zpipe
>> example application provided by zlib.
>
> I think we should convert ipcomp over to the new interface first
> in order to make sure that we don't need to change the interface
> which would be hard to do once we export it to user-space.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

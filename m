From: abed mohammad kamaluddin <abedamu@gmail.com>
Subject: Re: [RFC PATCH v1 0/1] *** crypto: AF_ALG: add compression support ***
Date: Thu, 20 Apr 2017 20:09:52 +0530
Message-ID: <CACVarESLvtwerfFnoo1brhUxZVkQf6v6+2ZET72cv83Qxw=V0A@mail.gmail.com>
References: <1492108494-10694-1-git-send-email-akamaluddin@cavium.com>
 <20170414083240.GA26625@gondor.apana.org.au> <CACVarEQ9kW=zF+Zse17LA2KjM-dg7mb6d5XWCvSbg5nCT3=Y6A@mail.gmail.com>
 <20170420080038.GB6780@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
        "akamaluddin@cavium.com" <akamaluddin@cavium.com>,
        pathreya@cavium.com, mchalla@cavium.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f173.google.com ([209.85.213.173]:34971 "EHLO
        mail-yb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032745AbdDTOkO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 10:40:14 -0400
Received: by mail-yb0-f173.google.com with SMTP id 6so27022618ybq.2
        for <linux-crypto@vger.kernel.org>; Thu, 20 Apr 2017 07:40:13 -0700 (PDT)
In-Reply-To: <20170420080038.GB6780@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

>> > I think we should convert ipcomp over to the new interface first
>> > in order to make sure that we don't need to change the interface
>> > which would be hard to do once we export it to user-space.
>>
>> Would it be acceptable if we export an algif interface using alg_type_compress,
>
> No we're not going to export an obsolete interface.
>

Are there any deficiencies expected in the acomp interface for use
with ipcomp? One issue mentioned earlier on the lists was that the
interface might
require tweaks for piecemeal decompression. Has this been taken up?

We identified few issues when using acomp with user-space zlib for file
compression. If the the interface is tweaked keeping those use-cases
in mind apart from the existing kernel apps (zswap/ipcomp/zram), the hardware
algorithms can be utilized using the algif framework.

Thanks
Abed



On Thu, Apr 20, 2017 at 1:30 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Apr 20, 2017 at 12:39:58PM +0530, abed mohammad kamaluddin wrote:
>> Hi Herbert,
>>
>> > I think we should convert ipcomp over to the new interface first
>> > in order to make sure that we don't need to change the interface
>> > which would be hard to do once we export it to user-space.
>>
>> Would it be acceptable if we export an algif interface using alg_type_compress,
>> which is being used by ipcomp currently? We would like to use our zip
>> device from
>> userspace through this interface.
>
> No we're not going to export an obsolete interface.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

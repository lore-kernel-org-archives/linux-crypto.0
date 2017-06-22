From: Raj Ammanur <rammanur@arista.com>
Subject: Re: XFRM Stats
Date: Wed, 21 Jun 2017 22:20:05 -0700
Message-ID: <CAMFBXf=9y=c7EP1rBKDL51e2QB0KqFTHaDAFaLPUMv+eCeyYww@mail.gmail.com>
References: <CAMFBXfmPTjuSkC+Wv9woBG36cqYTexmqoYE4C-iW-jRjYvRdiA@mail.gmail.com>
 <20170622024211.GA24666@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:34397 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752486AbdFVFUH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 01:20:07 -0400
Received: by mail-ua0-f171.google.com with SMTP id z22so5726326uah.1
        for <linux-crypto@vger.kernel.org>; Wed, 21 Jun 2017 22:20:06 -0700 (PDT)
In-Reply-To: <20170622024211.GA24666@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

oops yes, completely forgot the lifetime stats. Thanks Herbert.

I will check this out, but after a rekey, are the stats still preserved?

thanks
--Raj

On Wed, Jun 21, 2017 at 7:42 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Raj Ammanur <rammanur@arista.com> wrote:
>> Hi Crypto/Xfrm Team,
>>
>> I was wondering if there has been any discussion in the past
>> about adding stats in Xfrm to count the packets going in/out of
>> this sub-system? Right now we only have error stats.
>
> Have you looked at ip -s x s?
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

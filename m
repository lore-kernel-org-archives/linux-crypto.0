From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 6/6] crypto: tcrypt: add multibuf aead speed test
Date: Wed, 13 Dec 2017 15:23:32 +0200
Message-ID: <CAOtvUMfL6wfZ-5PZvUzXsm12=LCm+Jrrm=fW93Jf2SeFZSt9=A@mail.gmail.com>
References: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
 <1512036574-26665-7-git-send-email-gilad@benyossef.com> <20171211113533.GA11625@gondor.apana.org.au>
 <CAOtvUMf4jMWw46D9=jGhh3apoiWwS-3Nev5A=A=Lh3qByPwXBg@mail.gmail.com> <20171213123113.GA1738@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:32857 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752886AbdLMNXd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Dec 2017 08:23:33 -0500
Received: by mail-oi0-f41.google.com with SMTP id w131so1535318oiw.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Dec 2017 05:23:33 -0800 (PST)
In-Reply-To: <20171213123113.GA1738@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 13, 2017 at 2:31 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Dec 13, 2017 at 11:12:10AM +0200, Gilad Ben-Yossef wrote:
>>
>> I'm sorry if I'm confused but as the cover letter stated, the patch
>> set is supposed to
>> go on top of the patch entitled  "crypto: tcrypt - fix S/G table for
>> test_aead_speed()"
>> which you stated will be applied
>> (https://patchwork.kernel.org/patch/9995727/) but
>> is not in the tree yet.
>
> It is in cryptodev as
>
> commit 5c6ac1d4f8fbdbed65dbeb8cf149d736409d16a1
> Author: Robert Baronescu <robert.baronescu@nxp.com>
> Date:   Tue Oct 10 13:21:59 2017 +0300
>
>     crypto: tcrypt - fix S/G table for test_aead_speed()
>
> Yet your patch still fails to apply.

Opps sorry. I've accidentally checked against crypto and not cryptodev
My bad.

Will respin. Sorry for the noise.

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

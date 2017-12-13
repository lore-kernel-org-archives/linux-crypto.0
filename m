From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 6/6] crypto: tcrypt: add multibuf aead speed test
Date: Wed, 13 Dec 2017 11:12:10 +0200
Message-ID: <CAOtvUMf4jMWw46D9=jGhh3apoiWwS-3Nev5A=A=Lh3qByPwXBg@mail.gmail.com>
References: <1512036574-26665-1-git-send-email-gilad@benyossef.com>
 <1512036574-26665-7-git-send-email-gilad@benyossef.com> <20171211113533.GA11625@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:46702 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbdLMJML (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Dec 2017 04:12:11 -0500
Received: by mail-oi0-f53.google.com with SMTP id t81so1090744oih.13
        for <linux-crypto@vger.kernel.org>; Wed, 13 Dec 2017 01:12:11 -0800 (PST)
In-Reply-To: <20171211113533.GA11625@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Mon, Dec 11, 2017 at 1:35 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Nov 30, 2017 at 10:09:32AM +0000, Gilad Ben-Yossef wrote:
>> The performance of some aead tfm providers is affected by
>> the amount of parallelism possible with the processing.
>>
>> Introduce an async aead concurrent multiple buffer
>> processing speed test to be able to test performance of such
>> tfm providers.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>
> Sorry, this no longer applies to the current cryptodev tree.
>
> Please respin.
>

I'm sorry if I'm confused but as the cover letter stated, the patch
set is supposed to
go on top of the patch entitled  "crypto: tcrypt - fix S/G table for
test_aead_speed()"
which you stated will be applied
(https://patchwork.kernel.org/patch/9995727/) but
is not in the tree yet.

Apart from touching the same code that fix is needed because without it all the
AEAD speed tests crash so it's impossible to test my own additions.

If you apply Robert's patch to cryptodev my own patch set applies on
top of it OK.

Did I miss something?

Thanks,
Gilad




-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

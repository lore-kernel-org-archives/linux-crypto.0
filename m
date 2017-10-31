From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: testmgr: don't allocate IV on stack
Date: Tue, 31 Oct 2017 10:05:28 +0200
Message-ID: <CAOtvUMdRjyRCDaF5wN+VEdYvwLS92mH-L5C=s24mqHYqPteCVg@mail.gmail.com>
References: <1509436586-17500-1-git-send-email-gilad@benyossef.com> <20171031075925.GA26147@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:57071 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbdJaIF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2017 04:05:29 -0400
Received: by mail-qt0-f194.google.com with SMTP id z28so19589791qtz.13
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2017 01:05:29 -0700 (PDT)
In-Reply-To: <20171031075925.GA26147@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 31, 2017 at 9:59 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Oct 31, 2017 at 07:56:26AM +0000, Gilad Ben-Yossef wrote:
>> The IV was allocated on the stack in testmgr skcipher tests.
>> Since HW based tfm providers need to DMA the IV to the HW,
>> this leads to problems and is detected by the DMA-API debug
>> code.
>>
>> Fix it by allocating the IV using kmalloc instead.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>
> The driver that is mapping the IV directly should be fixed instead.
> Only input that is given in the form of SG lists can be mapped.
> Everything else should be copied if they need to go over DMA.

Got it. Will do.

Thanks,
Gilad

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

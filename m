From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] crypto: exynoes-rng: Set cra_ctxsize to 0
Date: Mon, 22 May 2017 09:14:42 +0530
Message-ID: <CANc+2y6WmVJaRyCegxe-MqbEMHGetVvdR=wEs_=Ci4LbQDQ9BQ@mail.gmail.com>
References: <20170521060952.19055-1-prasannatsmkumar@gmail.com>
 <CAJKOXPfh21DLOqTUPSZ=mDUyuCE+L8Wn9m=ioM=N1nomT4Vs+g@mail.gmail.com>
 <CANc+2y4KsFfLqnK4rA8iMEQcvUQD6nvQq43oDoheEwt+T23kxQ@mail.gmail.com> <CAJKOXPcyzcM93OXcRRbR-zSs0Fj81ROuBn293PNcqEzp1to0iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:34975 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757241AbdEVDon (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 May 2017 23:44:43 -0400
Received: by mail-ua0-f171.google.com with SMTP id y4so45504605uay.2
        for <linux-crypto@vger.kernel.org>; Sun, 21 May 2017 20:44:43 -0700 (PDT)
In-Reply-To: <CAJKOXPcyzcM93OXcRRbR-zSs0Fj81ROuBn293PNcqEzp1to0iQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21 May 2017 at 12:44, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Sun, May 21, 2017 at 9:11 AM, PrasannaKumar Muralidharan
> <prasannatsmkumar@gmail.com> wrote:
>> Hi Krzysztof
>>
>> On 21 May 2017 at 11:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>>> On Sun, May 21, 2017 at 8:09 AM, PrasannaKumar Muralidharan
>>> <prasannatsmkumar@gmail.com> wrote:
>>>> As cra_ctxsize is set but the allocated space is not used, set it 0.
>>>
>>> Why do you think it is not used? Did you test our change on hardware?
>>
>> Had a look at the crypto rng code. I think the additional size is used
>> to store driver private data. But this driver does not store any
>> private data in the crypto_tfm structure so I think the 'cra_ctxsize'
>> can be safely set to 0.
>
> Then from where does crypto_tfm_ctx() get its memory?

Ah, yes. Thanks for pointing out. I overlooked this. My patch is
completely wrong.

>> I do not have access to the hardware, did not test the change. Sorry I
>> forgot to mention that.
>
> That is quite important... By default everything must be tested so if
> you are skipping this step then please mark the patch respectively so
> others will provide testing.

Sure. Will keep that in mind. Instead of marking it as a [PATCH]
should I use something else for this? Will it make things easier?

Thanks,
PrasannaKumar

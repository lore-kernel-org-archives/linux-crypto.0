From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] crypto: exynoes-rng: Set cra_ctxsize to 0
Date: Sun, 21 May 2017 12:41:40 +0530
Message-ID: <CANc+2y4KsFfLqnK4rA8iMEQcvUQD6nvQq43oDoheEwt+T23kxQ@mail.gmail.com>
References: <20170521060952.19055-1-prasannatsmkumar@gmail.com> <CAJKOXPfh21DLOqTUPSZ=mDUyuCE+L8Wn9m=ioM=N1nomT4Vs+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:35680 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdEUHLl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 May 2017 03:11:41 -0400
Received: by mail-ua0-f195.google.com with SMTP id e28so5769130uah.2
        for <linux-crypto@vger.kernel.org>; Sun, 21 May 2017 00:11:41 -0700 (PDT)
In-Reply-To: <CAJKOXPfh21DLOqTUPSZ=mDUyuCE+L8Wn9m=ioM=N1nomT4Vs+g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Krzysztof

On 21 May 2017 at 11:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Sun, May 21, 2017 at 8:09 AM, PrasannaKumar Muralidharan
> <prasannatsmkumar@gmail.com> wrote:
>> As cra_ctxsize is set but the allocated space is not used, set it 0.
>
> Why do you think it is not used? Did you test our change on hardware?

Had a look at the crypto rng code. I think the additional size is used
to store driver private data. But this driver does not store any
private data in the crypto_tfm structure so I think the 'cra_ctxsize'
can be safely set to 0.

I do not have access to the hardware, did not test the change. Sorry I
forgot to mention that.

> Best regards,
> Krzysztof
>
>>
>> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>> ---
>>  drivers/crypto/exynos-rng.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
>> index 451620b..d009df6 100644
>> --- a/drivers/crypto/exynos-rng.c
>> +++ b/drivers/crypto/exynos-rng.c
>> @@ -260,7 +260,7 @@ static int exynos_rng_kcapi_init(struct crypto_tfm *tfm)
>>                 .cra_name               = "stdrng",
>>                 .cra_driver_name        = "exynos_rng",
>>                 .cra_priority           = 100,
>> -               .cra_ctxsize            = sizeof(struct exynos_rng_ctx),
>> +               .cra_ctxsize            = 0,
>>                 .cra_module             = THIS_MODULE,
>>                 .cra_init               = exynos_rng_kcapi_init,
>>         }
>> --
>> 1.8.5.6
>>

Regards,
PrasannaKumar

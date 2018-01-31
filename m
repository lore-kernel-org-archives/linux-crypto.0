From: Anand Moon <linux.amoon@gmail.com>
Subject: Re: Odroid HC1 cryptsetup:encrypt sata driver
Date: Wed, 31 Jan 2018 11:21:58 +0530
Message-ID: <CANAwSgT5buQ2ROmt-Bk0sh8=cSU5hp3GiHRuKwSagn0s57Nevw@mail.gmail.com>
References: <CGME20180124130437epcas2p251156941d5fd0dab2c24807a26a156be@epcas2p2.samsung.com>
 <CANAwSgQ3WE9XmjmzHxJstDz52fj_SFvmBKnMjY3MVjhxJuoFmg@mail.gmail.com> <f1966769-106e-a95e-8068-642e93c390b4@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:43603 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbeAaFwT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 00:52:19 -0500
In-Reply-To: <f1966769-106e-a95e-8068-642e93c390b4@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kamil,

On 30 January 2018 at 21:02, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
> Hi Anand,
>
> On 24.01.2018 14:04, Anand Moon wrote:
>> Hi Kamil Konieczny,
>>
>> I am looking in setup of encrypted sata hard-disk on Odroid XU4/HC1 device.
>> using following encryption method.
>>
>> aes-cbc-essiv:sha256 128
>> aes-cbc-essiv:sha256 256
>>
>> Here is my defconfig I am using. https://pastebin.com/gF5T2stp
>>
>> Following crypt benchmark we use to test : https://pastebin.com/WiexsJA2
>>
>> When I am trying to format the the hard drive I am getting kernel panic.
>> I have tired different option like below.
>>
>> *Please guide me in how to fix this bug*
>> [...]
>
> Sorry for late response, I was on holidays. Try latest kernel 4.15
> and turn off option:
>
> CONFIG_CRYPTO_DEV_EXYNOS_HASH=n
>
> in
>
> Cryptographic API:
> Hardware crypto devices:
> Support for Samsung Exynos HASH accelerator --> turn off
>
> You should also turn on option for software SHA256 (and maybe SHA1)
>
> This is last change in this driver,
> so maybe there is some problem with concurrent access to hardware
> by AES and HASH driver parts.
>

Thanks for your input, but I tried your suggestion on latest kernel.
but the result is the same.

How can I help trace this bug. please guide me.

Best Regards
-Anand
> --
> Best regards,
> Kamil Konieczny
> Samsung R&D Institute Poland
>

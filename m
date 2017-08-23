From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2 4/4] crypto: jz4780-rng: Enable PRNG support in CI20 defconfig
Date: Wed, 23 Aug 2017 20:45:00 +0530
Message-ID: <CANc+2y5qkx0mk4P1y-sEgYGAxBAAz_d7WtOcHa0Wh2h9AGe33Q@mail.gmail.com>
References: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
 <20170823025707.27888-5-prasannatsmkumar@gmail.com> <9da7ab8b-aa81-e012-596c-54355758da83@imgtec.com>
 <CANc+2y6LPFf6a-oJJ8=Sf59mCOH0q2s6Na5zCAMhnBAiOMjDcQ@mail.gmail.com> <02fb41c2-c740-ec2c-d82f-aabecfa798ea@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Cercueil <paul@crapouillou.net>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@linux-mips.org, Mathieu Malaterre <malat@debian.org>,
        noloader@gmail.com
To: Harvey Hunt <Harvey.Hunt@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36083 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932112AbdHWPPB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Aug 2017 11:15:01 -0400
In-Reply-To: <02fb41c2-c740-ec2c-d82f-aabecfa798ea@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Harvey,

On 23 August 2017 at 20:21, Harvey Hunt <Harvey.Hunt@imgtec.com> wrote:
> Hi PrasannaKumar,
>
>
> On 23/08/17 15:50, PrasannaKumar Muralidharan wrote:
>>
>> Hi Harvey,
>>
>> On 23 August 2017 at 14:39, Harvey Hunt <Harvey.Hunt@imgtec.com> wrote:
>>>
>>> Hi PrasannaKumar,
>>>
>>> On 23/08/17 03:57, PrasannaKumar Muralidharan wrote:
>>>>
>>>>
>>>> Enable PRNG driver support in MIPS Creator CI20 default config.
>>>>
>>>> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>>>> ---
>>>> No changes in v2
>>>>
>>>>    arch/mips/configs/ci20_defconfig | 5 +++++
>>>>    1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/arch/mips/configs/ci20_defconfig
>>>> b/arch/mips/configs/ci20_defconfig
>>>> index b42cfa7..9f48f2c 100644
>>>> --- a/arch/mips/configs/ci20_defconfig
>>>> +++ b/arch/mips/configs/ci20_defconfig
>>>> @@ -88,6 +88,11 @@ CONFIG_SERIAL_8250_RUNTIME_UARTS=5
>>>>    CONFIG_SERIAL_8250_INGENIC=y
>>>>    CONFIG_SERIAL_OF_PLATFORM=y
>>>>    # CONFIG_HW_RANDOM is not set
>>>> +CONFIG_CRYPTO_USER=y
>>>> +CONFIG_CRYPTO_USER_API=y
>>>> +CONFIG_CRYPTO_USER_API_RNG=y
>>>> +CONFIG_CRYPTO_HW=y
>>>> +CONFIG_CRYPTO_DEV_JZ4780_RNG=y
>>>>    CONFIG_I2C=y
>>>>    CONFIG_I2C_JZ4780=y
>>>>    CONFIG_GPIO_SYSFS=y
>>>>
>>>
>>> You need to regenerate your defconfig as it is missing CONFIG_MFD_SYSCON.
>>>
>>> Thanks,
>>>
>>> Harvey
>>
>>
>> CONFIG_MFD_SYSCON gets selected when CONFIG_CRYPTO_DEV_JZ4780_RNG is
>> selected. Please see the Kconfig changes. Given that should I add it
>> in ci20_defconfig? If it is required I will add and send a new
>> version.
>
>
> Oops, I hadn't noticed that - just skimmed the patches before my morning
> coffee. :-)
>
> It's fine as is, excuse the noise.

No issues.

>
>>
>> Thanks,
>> PrasannaKumar
>>
>
> Thanks,
>
> Harvey
>

Regards,
PrasannaKumar

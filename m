From: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 4/4] crypto: jz4780-rng: Enable PRNG support in CI20 defconfig
Date: Wed, 23 Aug 2017 20:20:07 +0530
Message-ID: <CANc+2y6LPFf6a-oJJ8=Sf59mCOH0q2s6Na5zCAMhnBAiOMjDcQ@mail.gmail.com>
References: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
 <20170823025707.27888-5-prasannatsmkumar@gmail.com> <9da7ab8b-aa81-e012-596c-54355758da83@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>,
        Paul Cercueil <paul-icTtO2rgO2OTuSrc4Mpeew@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Mathieu Malaterre <malat-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>,
        noloader-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Harvey Hunt <Harvey.Hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9da7ab8b-aa81-e012-596c-54355758da83-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Harvey,

On 23 August 2017 at 14:39, Harvey Hunt <Harvey.Hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org> wrote:
> Hi PrasannaKumar,
>
> On 23/08/17 03:57, PrasannaKumar Muralidharan wrote:
>>
>> Enable PRNG driver support in MIPS Creator CI20 default config.
>>
>> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> No changes in v2
>>
>>   arch/mips/configs/ci20_defconfig | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/mips/configs/ci20_defconfig
>> b/arch/mips/configs/ci20_defconfig
>> index b42cfa7..9f48f2c 100644
>> --- a/arch/mips/configs/ci20_defconfig
>> +++ b/arch/mips/configs/ci20_defconfig
>> @@ -88,6 +88,11 @@ CONFIG_SERIAL_8250_RUNTIME_UARTS=5
>>   CONFIG_SERIAL_8250_INGENIC=y
>>   CONFIG_SERIAL_OF_PLATFORM=y
>>   # CONFIG_HW_RANDOM is not set
>> +CONFIG_CRYPTO_USER=y
>> +CONFIG_CRYPTO_USER_API=y
>> +CONFIG_CRYPTO_USER_API_RNG=y
>> +CONFIG_CRYPTO_HW=y
>> +CONFIG_CRYPTO_DEV_JZ4780_RNG=y
>>   CONFIG_I2C=y
>>   CONFIG_I2C_JZ4780=y
>>   CONFIG_GPIO_SYSFS=y
>>
>
> You need to regenerate your defconfig as it is missing CONFIG_MFD_SYSCON.
>
> Thanks,
>
> Harvey

CONFIG_MFD_SYSCON gets selected when CONFIG_CRYPTO_DEV_JZ4780_RNG is
selected. Please see the Kconfig changes. Given that should I add it
in ci20_defconfig? If it is required I will add and send a new
version.

Thanks,
PrasannaKumar
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

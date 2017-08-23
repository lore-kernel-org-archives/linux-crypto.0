From: Harvey Hunt <Harvey.Hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/4] crypto: jz4780-rng: Enable PRNG support in CI20
 defconfig
Date: Wed, 23 Aug 2017 10:09:41 +0100
Message-ID: <9da7ab8b-aa81-e012-596c-54355758da83@imgtec.com>
References: <20170823025707.27888-1-prasannatsmkumar@gmail.com>
 <20170823025707.27888-5-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, <paul-icTtO2rgO2OTuSrc4Mpeew@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, <malat-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>,
        <noloader-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170823025707.27888-5-prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi PrasannaKumar,

On 23/08/17 03:57, PrasannaKumar Muralidharan wrote:
> Enable PRNG driver support in MIPS Creator CI20 default config.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> No changes in v2
> 
>   arch/mips/configs/ci20_defconfig | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/arch/mips/configs/ci20_defconfig b/arch/mips/configs/ci20_defconfig
> index b42cfa7..9f48f2c 100644
> --- a/arch/mips/configs/ci20_defconfig
> +++ b/arch/mips/configs/ci20_defconfig
> @@ -88,6 +88,11 @@ CONFIG_SERIAL_8250_RUNTIME_UARTS=5
>   CONFIG_SERIAL_8250_INGENIC=y
>   CONFIG_SERIAL_OF_PLATFORM=y
>   # CONFIG_HW_RANDOM is not set
> +CONFIG_CRYPTO_USER=y
> +CONFIG_CRYPTO_USER_API=y
> +CONFIG_CRYPTO_USER_API_RNG=y
> +CONFIG_CRYPTO_HW=y
> +CONFIG_CRYPTO_DEV_JZ4780_RNG=y
>   CONFIG_I2C=y
>   CONFIG_I2C_JZ4780=y
>   CONFIG_GPIO_SYSFS=y
> 

You need to regenerate your defconfig as it is missing CONFIG_MFD_SYSCON.

Thanks,

Harvey
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

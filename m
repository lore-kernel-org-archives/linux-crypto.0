From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [v18,3/7] iomap: introduce io{read|write}64_{lo_hi|hi_lo}
Date: Fri, 13 Jul 2018 18:12:43 -0700
Message-ID: <cc6cfb2a-d1d4-3328-3f49-07f7cec09faf@roeck-us.net>
References: <20180622194752.11221-4-logang@deltatee.com>
 <20180713233831.GA2946@roeck-us.net>
 <0a32dbb8-a1fa-f691-1d4a-9851b1496b9a@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0a32dbb8-a1fa-f691-1d4a-9851b1496b9a@deltatee.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 07/13/2018 05:20 PM, Logan Gunthorpe wrote:
> 
> 
> On 13/07/18 05:38 PM, Guenter Roeck wrote:
>> This patch causes a build failure in -next when building
>> ppc:corenet64_smp_defconfig.
> 
> Thanks for the report. This 64bit IO stuff is a bit of a mess. It looks
> like your corner case arch and config was never covered by the kbuild
> robot which has run extensively on this patchset.
> 
> Anyway, I think the fix is to put back the ioread64/write64 prototypes
> (even though they are only used in this one corner).
> 
> Can you try it with the following patch to ensure it fixes things for you?
> 

It does.

Guenter

> Logan
> 
> --
> 
> diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
> index 5a4af0199b32..9f11a79e0d7a 100644
> --- a/include/asm-generic/iomap.h
> +++ b/include/asm-generic/iomap.h
> @@ -32,6 +32,11 @@ extern unsigned int ioread16be(void __iomem *);
>   extern unsigned int ioread32(void __iomem *);
>   extern unsigned int ioread32be(void __iomem *);
> 
> +#ifdef CONFIG_64BIT
> +extern u64 ioread64(void __iomem *);
> +extern u64 ioread64be(void __iomem *);
> +#endif
> +
>   #ifdef readq
>   #define ioread64_lo_hi ioread64_lo_hi
>   #define ioread64_hi_lo ioread64_hi_lo
> @@ -49,6 +54,11 @@ extern void iowrite16be(u16, void __iomem *);
>   extern void iowrite32(u32, void __iomem *);
>   extern void iowrite32be(u32, void __iomem *);
> 
> +#ifdef CONFIG_64BIT
> +extern void iowrite64(u64, void __iomem *);
> +extern void iowrite64be(u64, void __iomem *);
> +#endif
> +
>   #ifdef writeq
>   #define iowrite64_lo_hi iowrite64_lo_hi
>   #define iowrite64_hi_lo iowrite64_hi_lo
> 

From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v2 3/3] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Wed, 28 Jun 2017 10:51:15 -0600
Message-ID: <c3f2e061-5ed1-5c74-b955-3d2bfb0da074@deltatee.com>
References: <20170627230204.16410-1-logang@deltatee.com>
 <20170627230204.16410-4-logang@deltatee.com>
 <CAK8P3a1mXeH+qdW=MFKO7i4oXw3yfLj-QU=09Y=MvD5y-T4zmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jyri Sarha <jsarha@ti.com>,
        Stephen Bates <sbates@raithlin.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1mXeH+qdW=MFKO7i4oXw3yfLj-QU=09Y=MvD5y-T4zmw@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 28/06/17 04:20 AM, Arnd Bergmann wrote:
> On Wed, Jun 28, 2017 at 1:02 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
>>  #include <linux/types.h>
>>  #include <linux/bitops.h>
>> -#include <linux/io.h>
>> +#include <linux/io-64-nonatomic-hi-lo.h>
> 
> Here you include the hi-lo variant unconditionally.
> 
>> -#else /* CONFIG_64BIT */
>> -static inline void wr_reg64(void __iomem *reg, u64 data)
>> -{
>> -#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX
>> -       if (caam_little_end) {
>> -               wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);
>> -               wr_reg32((u32 __iomem *)(reg), data);
>> -       } else
>>  #endif
>> -       {
>> -               wr_reg32((u32 __iomem *)(reg), data >> 32);
>> -               wr_reg32((u32 __iomem *)(reg) + 1, data);
>> -       }
>> +               iowrite64be(data, reg);
>>  }
> 
> However, the #else path here uses lo-hi instead. I guess we have
> to decide how to define iowrite64be_lo_hi() first: it could
> either byteswap the 64-bit value first, then write the two halves,
> or it could write the two halves, doing a 32-bit byte swap on
> each.

Ok, I studied this a bit more:

The lo_hi/hi_lo functions seem to always refer to the data being written
or read not to the address operated on. So, in the v3 version of this
set, which I'm working on, I've defined:

static inline void iowrite64_hi_lo(u64 val, void __iomem *addr)
{
        iowrite32(val >> 32, addr + sizeof(u32));
        iowrite32(val, addr);
}

static inline void iowrite64be_hi_lo(u64 val, void __iomem *addr)
{
        iowrite32be(val >> 32, addr);
        iowrite32be(val, addr + sizeof(u32));
}

So the two hi_lo functions match both paths of the #if and thus, I
believe, the patch will be correct in v3 without changes.

Thanks,

Logan

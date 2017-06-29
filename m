From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v2 3/3] crypto: caam: cleanup CONFIG_64BIT ifdefs when
 using io{read|write}64
Date: Thu, 29 Jun 2017 07:52:04 +0000
Message-ID: <VI1PR0401MB259145C2DFDB5E4084EA5DFC98D20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170627230204.16410-1-logang@deltatee.com>
 <20170627230204.16410-4-logang@deltatee.com>
 <CAK8P3a1mXeH+qdW=MFKO7i4oXw3yfLj-QU=09Y=MvD5y-T4zmw@mail.gmail.com>
 <c3f2e061-5ed1-5c74-b955-3d2bfb0da074@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jyri Sarha <jsarha@ti.com>,
        Stephen Bates <sbates@raithlin.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Logan Gunthorpe <logang@deltatee.com>,
        Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0069.outbound.protection.outlook.com ([104.47.1.69]:55766
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751684AbdF2HwK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2017 03:52:10 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 6/28/2017 7:51 PM, Logan Gunthorpe wrote:=0A=
> =0A=
> =0A=
> On 28/06/17 04:20 AM, Arnd Bergmann wrote:=0A=
>> On Wed, Jun 28, 2017 at 1:02 AM, Logan Gunthorpe <logang@deltatee.com> w=
rote:=0A=
>>>  #include <linux/types.h>=0A=
>>>  #include <linux/bitops.h>=0A=
>>> -#include <linux/io.h>=0A=
>>> +#include <linux/io-64-nonatomic-hi-lo.h>=0A=
>>=0A=
>> Here you include the hi-lo variant unconditionally.=0A=
>>=0A=
Arnd, thanks for spotting this.=0A=
=0A=
This was not in the patch I signed off.=0A=
The lo-hi variant should be used instead for CAAM, see further below.=0A=
=0A=
>>> -#else /* CONFIG_64BIT */=0A=
>>> -static inline void wr_reg64(void __iomem *reg, u64 data)=0A=
>>> -{=0A=
>>> -#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM_IMX=0A=
>>> -       if (caam_little_end) {=0A=
>>> -               wr_reg32((u32 __iomem *)(reg) + 1, data >> 32);=0A=
>>> -               wr_reg32((u32 __iomem *)(reg), data);=0A=
>>> -       } else=0A=
>>>  #endif=0A=
>>> -       {=0A=
>>> -               wr_reg32((u32 __iomem *)(reg), data >> 32);=0A=
>>> -               wr_reg32((u32 __iomem *)(reg) + 1, data);=0A=
>>> -       }=0A=
>>> +               iowrite64be(data, reg);=0A=
>>>  }=0A=
>>=0A=
>> However, the #else path here uses lo-hi instead. I guess we have=0A=
>> to decide how to define iowrite64be_lo_hi() first: it could=0A=
>> either byteswap the 64-bit value first, then write the two halves,=0A=
>> or it could write the two halves, doing a 32-bit byte swap on=0A=
>> each.=0A=
> =0A=
> Ok, I studied this a bit more:=0A=
> =0A=
> The lo_hi/hi_lo functions seem to always refer to the data being written=
=0A=
> or read not to the address operated on. So, in the v3 version of this=0A=
> set, which I'm working on, I've defined:=0A=
> =0A=
> static inline void iowrite64_hi_lo(u64 val, void __iomem *addr)=0A=
> {=0A=
>         iowrite32(val >> 32, addr + sizeof(u32));=0A=
>         iowrite32(val, addr);=0A=
> }=0A=
> =0A=
> static inline void iowrite64be_hi_lo(u64 val, void __iomem *addr)=0A=
> {=0A=
>         iowrite32be(val >> 32, addr);=0A=
>         iowrite32be(val, addr + sizeof(u32));=0A=
> }=0A=
> =0A=
> So the two hi_lo functions match both paths of the #if and thus, I=0A=
> believe, the patch will be correct in v3 without changes.=0A=
> =0A=
To be consistent with CAAM engine HW spec: in case of 64-bit registers,=0A=
irrespective of device endianness, the lower address should be read from=0A=
/ written to first, followed by the upper address.=0A=
=0A=
Indeed the I/O accessors in CAAM driver currently don't follow the spec,=0A=
however this is a good opportunity to fix the code.=0A=
I don't consider this requires a separate patch, as we haven't noticed=0A=
any problem. I'd say a simple note in the commit message mentioning the=0A=
change (lo-hi r/w order replacing hi-lo for little endian case) is enough.=
=0A=
=0A=
Thanks,=0A=
Horia=0A=

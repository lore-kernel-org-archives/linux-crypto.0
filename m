From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v5 3/6] iomap: introduce io{read|write}64_{lo_hi|hi_lo}
Date: Mon, 31 Jul 2017 19:10:59 +0300
Message-ID: <CAHp75Ve619EE9ePy2zj+MjS7-MW3u_k2BQ5kc9iFBMYYQ9nMWQ@mail.gmail.com>
References: <20170726231917.6073-1-logang@deltatee.com> <20170726231917.6073-4-logang@deltatee.com>
 <CAHp75Vcv7UCpnGY+mL7CMU5u9hCUxwaYWNsg58BoWBJGAFX4tQ@mail.gmail.com> <5c52d908-3b77-c5c6-99a7-1164d878ac95@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-ntb@googlegroups.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
To: Logan Gunthorpe <logang@deltatee.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36928 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751978AbdGaQLA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 12:11:00 -0400
In-Reply-To: <5c52d908-3b77-c5c6-99a7-1164d878ac95@deltatee.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 31, 2017 at 6:55 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
> On 30/07/17 10:03 AM, Andy Shevchenko wrote:
>> On Thu, Jul 27, 2017 at 2:19 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
>>> In order to provide non-atomic functions for io{read|write}64 that will
>>> use readq and writeq when appropriate. We define a number of variants
>>> of these functions in the generic iomap that will do non-atomic
>>> operations on pio but atomic operations on mmio.
>>>
>>> These functions are only defined if readq and writeq are defined. If
>>> they are not, then the wrappers that always use non-atomic operations
>>> from include/linux/io-64-nonatomic*.h will be used.
>>
>> Don't you see here a slight problem?
>>
>> In some cases we want to substitute atomic in favour of non-atomic
>> when both are defined.
>> So, please don't do this "smartly".
>
> I'm not sure what you mean here. The driver should use ioread64 and
> include an io-64-nonatomic header. Then there are three cases:
>
> 1) The arch has no atomic 64 bit io operations defined. In this case it
> uses the non-atomic inline function in the io-64-nonatomic header.

Okay

> 2) The arch uses CONFIG_GENERIC_IOMAP and has readq defined, but not
> ioread64 defined (likely because pio can't do atomic 64 bit operations
> but mmio can). In this case we need to use the ioread64_xx functions
> defined in iomap.c which do atomic mmio and non-atomic pio.

Not okay.

Some drivers (hardware) would like to have non-atomic MMIO accesses
when readq() defined

> 3) The arch has ioread64 defined so the atomic operation is used.

Not okay. Same reason as above.

In case of readq() / writeq() it's defined by the order of inclusion:

1)
include <...non-atomic...>
include <linux/io.h>

Always non-atomic will be used.

2)
include <linux/io.h>
include <...non-atomic...>

Auto switch like you described.

I don't like above solution, since it's fragile, but few drivers depend on that.

If you wish to do it always like 2) perhaps we need to split accessors
to ones for fixed bus width and ones for atomic/non-atomic cases.
OTOH, it would be done by introducing
memcpyXX_fromio()
memcpyXX_toio()
memsetXX_io()

Where XX = 64, 32, 16, 8.

Note, that ioreadXX_rep() is not the same as above.

P.S. I have done a table of comparison between IO accessors in Linux
kernel and it looks hell out of being consistent.

-- 
With Best Regards,
Andy Shevchenko

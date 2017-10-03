From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: Re: [PATCH 2/2] MIPS: crypto: Add crc32 and crc32c hw accelerated
 module
Date: Tue, 3 Oct 2017 08:38:38 +0200
Message-ID: <7d9d2e3a-a78f-bbb6-f957-1419473fb90e@imgtec.com>
References: <1506514716-29470-1-git-send-email-marcin.nowakowski@imgtec.com>
 <1506514716-29470-3-git-send-email-marcin.nowakowski@imgtec.com>
 <20170929213451.GB24591@jhogan-linux.le.imgtec.org>
 <CAOiHx=kMH+ujTw2myQ0uR3DxHnsBsmaGtmeVniGNf7VHytTa6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Jonas Gorski <jonas.gorski@gmail.com>,
        James Hogan <james.hogan@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:17376 "EHLO
        mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdJCGin (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 02:38:43 -0400
In-Reply-To: <CAOiHx=kMH+ujTw2myQ0uR3DxHnsBsmaGtmeVniGNf7VHytTa6g@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jonas, James,

On 02.10.2017 16:20, Jonas Gorski wrote:
> On 29 September 2017 at 23:34, James Hogan <james.hogan@imgtec.com> wrote:
>> Hi Marcin,
>>
>> On Wed, Sep 27, 2017 at 02:18:36PM +0200, Marcin Nowakowski wrote:
>>> This module registers crc32 and crc32c algorithms that use the
>>> optional CRC32[bhwd] and CRC32C[bhwd] instructions in MIPSr6 cores.
>>>
>>> Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
>>> Cc: linux-crypto@vger.kernel.org
>>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>>
>>> ---
>>>   arch/mips/Kconfig             |   4 +
>>>   arch/mips/Makefile            |   3 +
>>>   arch/mips/crypto/Makefile     |   5 +
>>>   arch/mips/crypto/crc32-mips.c | 361 ++++++++++++++++++++++++++++++++++++++++++
>>>   crypto/Kconfig                |   9 ++
>>>   5 files changed, 382 insertions(+)
>>>   create mode 100644 arch/mips/crypto/Makefile
>>>   create mode 100644 arch/mips/crypto/crc32-mips.c
>>>
>>> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
>>> index cb7fcc4..0f96812 100644
>>> --- a/arch/mips/Kconfig
>>> +++ b/arch/mips/Kconfig
>>> @@ -2036,6 +2036,7 @@ config CPU_MIPSR6
>>>        select CPU_HAS_RIXI
>>>        select HAVE_ARCH_BITREVERSE
>>>        select MIPS_ASID_BITS_VARIABLE
>>> +     select MIPS_CRC_SUPPORT
>>>        select MIPS_SPRAM
>>>
>>>   config EVA
>>> @@ -2503,6 +2504,9 @@ config MIPS_ASID_BITS
>>>   config MIPS_ASID_BITS_VARIABLE
>>>        bool
>>>
>>> +config MIPS_CRC_SUPPORT
>>> +     bool
>>> +
>>>   #
>>>   # - Highmem only makes sense for the 32-bit kernel.
>>>   # - The current highmem code will only work properly on physically indexed
>>> diff --git a/arch/mips/Makefile b/arch/mips/Makefile
>>> index a96d97a..aa77536 100644
>>> --- a/arch/mips/Makefile
>>> +++ b/arch/mips/Makefile
>>> @@ -216,6 +216,8 @@ cflags-$(toolchain-msa)                   += -DTOOLCHAIN_SUPPORTS_MSA
>>>   endif
>>>   toolchain-virt                               := $(call cc-option-yn,$(mips-cflags) -mvirt)
>>>   cflags-$(toolchain-virt)             += -DTOOLCHAIN_SUPPORTS_VIRT
>>> +toolchain-crc                                := $(call cc-option-yn,$(mips-cflags) -Wa$(comma)-mcrc)
>>> +cflags-$(toolchain-crc)                      += -DTOOLCHAIN_SUPPORTS_CRC
>>>
>>>   #
>>>   # Firmware support
>>> @@ -324,6 +326,7 @@ libs-y                    += arch/mips/math-emu/
>>>   # See arch/mips/Kbuild for content of core part of the kernel
>>>   core-y += arch/mips/
>>>
>>> +drivers-$(CONFIG_MIPS_CRC_SUPPORT) += arch/mips/crypto/
>>>   drivers-$(CONFIG_OPROFILE)   += arch/mips/oprofile/
>>>
>>>   # suspend and hibernation support
>>> diff --git a/arch/mips/crypto/Makefile b/arch/mips/crypto/Makefile
>>> new file mode 100644
>>> index 0000000..665c725
>>> --- /dev/null
>>> +++ b/arch/mips/crypto/Makefile
>>> @@ -0,0 +1,5 @@
>>> +#
>>> +# Makefile for MIPS crypto files..
>>> +#
>>> +
>>> +obj-$(CONFIG_CRYPTO_CRC32_MIPS) += crc32-mips.o
>>> diff --git a/arch/mips/crypto/crc32-mips.c b/arch/mips/crypto/crc32-mips.c
>>> new file mode 100644
>>> index 0000000..dfa8bb1
>>> --- /dev/null
>>> +++ b/arch/mips/crypto/crc32-mips.c
>>> @@ -0,0 +1,361 @@
>>> +/*
>>> + * crc32-mips.c - CRC32 and CRC32C using optional MIPSr6 instructions
>>> + *
>>> + * Module based on arm64/crypto/crc32-arm.c
>>> + *
>>> + * Copyright (C) 2014 Linaro Ltd <yazen.ghannam@linaro.org>
>>> + * Copyright (C) 2017 Imagination Technologies, Ltd.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#include <linux/unaligned/access_ok.h>
>>> +#include <linux/cpufeature.h>
>>> +#include <linux/init.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/string.h>
>>> +
>>> +#include <crypto/internal/hash.h>
>>> +
>>> +enum crc_op_size {
>>> +     b, h, w, d,
>>> +};
>>> +
>>> +enum crc_type {
>>> +     crc32,
>>> +     crc32c,
>>> +};
>>> +
>>> +#ifdef TOOLCHAIN_SUPPORTS_CRC
>>> +
>>> +#define _CRC32(crc, value, size, type)               \
>>> +do {                                         \
>>> +     __asm__ __volatile__(                   \
>>> +     ".set   push\n\t"                       \
>>> +     ".set   crc\n\t"                        \
>>> +     #type #size "   %0, %1, %0\n\t"         \
>>> +     ".set   pop\n\t"                        \
>>
>> Technically the \n\t on the last line is redundant.
>>
>>> +     : "+r" (crc)                            \
>>> +     : "r" (value)                           \
>>> +);                                           \
>>> +} while(0)
>>> +
>>> +#define CRC_REGISTER
>>> +
>>> +#else        /* TOOLCHAIN_SUPPORTS_CRC */
>>> +/*
>>> + * Crc argument is currently ignored and the assembly below assumes
>>> + * the crc is stored in $2. As the register number is encoded in the
>>> + * instruction we can't let the compiler chose the register it wants.
>>> + * An alternative is to change the code to do
>>> + * move $2, %0
>>> + * crc32
>>> + * move %0, $2
>>> + * but that adds unnecessary operations that the crc32 operation is
>>> + * designed to avoid. This issue can go away once the assembler
>>> + * is extended to support this operation and the compiler can make
>>> + * the right register choice automatically
>>> + */
>>> +
>>> +#define _CRC32(crc, value, size, type)                                               \
>>> +do {                                                                         \
>>> +     __asm__ __volatile__(                                                   \
>>> +     ".set   push\n\t"                                                       \
>>> +     ".set   noat\n\t"                                                       \
>>> +     "move   $at, %1\n\t"                                                    \
>>> +     "# " #type #size "      %0, $at, %0\n\t"                                \
>>> +     _ASM_INSN_IF_MIPS(0x7c00000f | (2 << 16) | (1 << 21) | (%2 << 6) | (%3 << 8))   \
>>> +     _ASM_INSN32_IF_MM(0x00000030 | (1 << 16) | (2 << 21) | (%2 << 14) | (%3 << 3))  \
>>
>> You should explicitly include <asm/mipsregs.h> for these macros.
>>
>>> +     ".set   pop\n\t"                                                        \
>>> +     : "+r" (crc)                                                            \
>>> +     : "r" (value), "i" (size), "i" (type)                                   \
>>> +);                                                                           \
>>> +} while(0)
>>> +
>>> +#define CRC_REGISTER __asm__("$2")
>>> +#endif       /* !TOOLCHAIN_SUPPORTS_CRC */
>>> +
>>> +#define CRC32(crc, value, size) \
>>> +     _CRC32(crc, value, size, crc32)
>>> +
>>> +#define CRC32C(crc, value, size) \
>>> +     _CRC32(crc, value, size, crc32c)
>>> +
>>> +static u32 crc32_mips_le_hw(u32 crc_, const u8 *p, unsigned int len)
>>> +{
>>> +     s64 length = len;
>>
>> The need for 64-bit signed length is unfortunate. Do you get decent
>> assembly and comparable/better performance on 32-bit if you just use len
>> and only decrement it in the loops? i.e.
>>
>> -       while ((length -= sizeof(uXX)) >= 0) {
>> +       while (len >= sizeof(uXX)) {
>>                  register uXX value = get_unaligned_leXX(p);
>>
>>                  CRC32(crc, value, XX);
>>                  p += sizeof(uXX);
>> +               len -= sizeof(uXX);
>>          }
>>
>> That would be more readable too IMHO.
> 
> or maybe just do some pointer arithmetic like
> 
>    const u8 *end = p + len;
> 
>    while ((end - p) >= sizeof(uXX)) {
>             register uXX value = get_unaligned_leXX(p);
> 
>             CRC32(crc, value, XX);
>             p += sizeof(uXX);
>    }

Thank you both for these suggestions. All solutions are very similar in 
terms of the assembly produced, although the original code is the 
smallest of all:

original vs James':
crc32_mips_le_hw                             104     132     +28
vermagic                                      72      78      +6
chksumc_finup                                 40      44      +4
chksumc_digest                                44      48      +4
chksum_finup                                  92      96      +4
chksum_digest                                100     104      +4

original vs Jonas':
add/remove: 0/0 grow/shrink: 7/0 up/down: 90/0 (90)
function                                     old     new   delta
crc32_mips_le_hw                             104     148     +44
vermagic                                      72      78      +6
chksumc_finup                                 40      44      +4
chksumc_digest                                44      48      +4
chksum_finup                                  92      96      +4
chksum_digest                                100     104      +4


However - the key thing which is the processing loop is 6 instructions 
long in all variants. It's only the pre/post loop processing that adds 
the extra instructions so all these solutions should be roughly equal in 
terms of performance.
I find James' code a bit more readable so I'll go with it and post an 
updated patch.


Thanks
Marcin

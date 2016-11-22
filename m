From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3] arm64/crypto: Accelerated CRC T10 DIF computation
Date: Tue, 22 Nov 2016 13:38:00 +0000
Message-ID: <CAKv+Gu8CXh_k7ndC3jc75NJ8=Tmo5MSwzdQxw7oBavODyO4GRQ@mail.gmail.com>
References: <20161122101455.5312-1-yuehaibing@huawei.com> <CAKv+Gu9x+Z6Wx_jXQvFBuD4nQFF7rhz7M0KZmPWqUgfsfVz-OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        dingtinahong <dingtianhong@huawei.com>, yangshengkai@huawei.com,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: YueHaibing <yuehaibing@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9x+Z6Wx_jXQvFBuD4nQFF7rhz7M0KZmPWqUgfsfVz-OA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 22 November 2016 at 12:53, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 22 November 2016 at 10:14, YueHaibing <yuehaibing@huawei.com> wrote:
>> This is the ARM64 CRC T10 DIF transform accelerated with the ARMv8
>> NEON instruction.The config CRYPTO_CRCT10DIF_NEON should be turned
>> on to enable the feature.The crc_t10dif crypto library function will
>> use this faster algorithm when crct10dif_neon module is loaded.
>>
>
> What is this algorithm commonly used for? In other words, why is it a
> good idea to add support for this algorithm to the kernel?
>
>> Tcrypt benchmark results:
>>
>> HIP06  (mode=320 sec=2)
>>
>> The ratio of bytes/sec crct10dif-neon Vs. crct10dif-generic:
>>
>>                         TEST                              neon          generic         ratio
>>   16 byte blocks,   16 bytes per update,   1 updates    214506112       171095400       1.25
>>   64 byte blocks,   16 bytes per update,   4 updates    139385312       119036352       1.17
>>   64 byte blocks,   64 bytes per update,   1 updates    671523712       198945344       3.38
>>  256 byte blocks,   16 bytes per update,  16 updates    157674880       125146752       1.26
>>  256 byte blocks,   64 bytes per update,   4 updates    491888128       175764096       2.80
>>  256 byte blocks,  256 bytes per update,   1 updates    2123298176      206995200       10.26
>> 1024 byte blocks,   16 bytes per update,  64 updates    161243136       126460416       1.28
>> 1024 byte blocks,  256 bytes per update,   4 updates    1643020800      200027136       8.21
>> 1024 byte blocks, 1024 bytes per update,   1 updates    4238239232      209106432       20.27
>> 2048 byte blocks,   16 bytes per update, 128 updates    162079744       126953472       1.28
>> 2048 byte blocks,  256 bytes per update,   8 updates    1693587456      200867840       8.43
>> 2048 byte blocks, 1024 bytes per update,   2 updates    3424323584      206330880       16.60
>> 2048 byte blocks, 2048 bytes per update,   1 updates    5228207104      208620544       25.06
>> 4096 byte blocks,   16 bytes per update, 256 updates    162304000       126894080       1.28
>> 4096 byte blocks,  256 bytes per update,  16 updates    1731862528      201197568       8.61
>> 4096 byte blocks, 1024 bytes per update,   4 updates    3668625408      207003648       17.72
>> 4096 byte blocks, 4096 bytes per update,   1 updates    5551239168      209127424       26.54
>> 8192 byte blocks,   16 bytes per update, 512 updates    162779136       126984192       1.28
>> 8192 byte blocks,  256 bytes per update,  32 updates    1753702400      201420800       8.71
>> 8192 byte blocks, 1024 bytes per update,   8 updates    3760918528      207351808       18.14
>> 8192 byte blocks, 4096 bytes per update,   2 updates    5483655168      208928768       26.25
>> 8192 byte blocks, 8192 bytes per update,   1 updates    5623377920      209108992       26.89
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> Signed-off-by: YangShengkai <yangshengkai@huawei.com>
>> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>
>> ---
>>  arch/arm64/crypto/Kconfig                 |   5 +
>>  arch/arm64/crypto/Makefile                |   4 +
>>  arch/arm64/crypto/crct10dif-neon-asm_64.S | 751 ++++++++++++++++++++++++++++++
>>  arch/arm64/crypto/crct10dif-neon_glue.c   | 115 +++++
>>  4 files changed, 875 insertions(+)
>>  create mode 100644 arch/arm64/crypto/crct10dif-neon-asm_64.S
>>  create mode 100644 arch/arm64/crypto/crct10dif-neon_glue.c
>>
>> diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
>> index 2cf32e9..2e450bf 100644
>> --- a/arch/arm64/crypto/Kconfig
>> +++ b/arch/arm64/crypto/Kconfig
>> @@ -23,6 +23,11 @@ config CRYPTO_GHASH_ARM64_CE
>>         depends on ARM64 && KERNEL_MODE_NEON
>>         select CRYPTO_HASH
>>
>> +config CRYPTO_CRCT10DIF_NEON
>> +       tristate "CRCT10DIF hardware acceleration using NEON instructions"
>> +       depends on ARM64 && KERNEL_MODE_NEON
>> +       select CRYPTO_HASH
>> +
>
> Could you please follow the existing pattern:
>
> config CRYPTO_CRCT10DIF_ARM64_NEON
>
>
>>  config CRYPTO_AES_ARM64_CE
>>         tristate "AES core cipher using ARMv8 Crypto Extensions"
>>         depends on ARM64 && KERNEL_MODE_NEON
>> diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
>> index abb79b3..6c9ff2c 100644
>> --- a/arch/arm64/crypto/Makefile
>> +++ b/arch/arm64/crypto/Makefile
>> @@ -29,6 +29,10 @@ aes-ce-blk-y := aes-glue-ce.o aes-ce.o
>>  obj-$(CONFIG_CRYPTO_AES_ARM64_NEON_BLK) += aes-neon-blk.o
>>  aes-neon-blk-y := aes-glue-neon.o aes-neon.o
>>
>> +obj-$(CONFIG_CRYPTO_CRCT10DIF_NEON) += crct10dif-neon.o
>> +crct10dif-neon-y := crct10dif-neon-asm_64.o crct10dif-neon_glue.o
>> +AFLAGS_crct10dif-neon-asm_64.o := -march=armv8-a+crypto
>> +
>
> Please drop this line, and add
>
> .cpu generic+crypto
>
> to the .S file
>
>>  AFLAGS_aes-ce.o                := -DINTERLEAVE=4
>>  AFLAGS_aes-neon.o      := -DINTERLEAVE=4
>>
>> diff --git a/arch/arm64/crypto/crct10dif-neon-asm_64.S b/arch/arm64/crypto/crct10dif-neon-asm_64.S
>> new file mode 100644
>> index 0000000..2ae3033
>> --- /dev/null
>> +++ b/arch/arm64/crypto/crct10dif-neon-asm_64.S
>> @@ -0,0 +1,751 @@
>> +/*
>> + * Copyright (c) 2016-2017 Hisilicon Limited.
>> + *
>
> Please drop the 2017 here.
>
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#include <linux/linkage.h>
>> +#include <asm/assembler.h>
>> +
>> +.global crc_t10dif_neon
>
> Please drop this .global, and use ENTRY() below
>
>> +.text
>> +
>> +/* X0 is initial CRC value
>> + * X1 is data buffer
>> + * X2 is the length of buffer
>> + * X3 is the backup buffer(for extend)
>> + * X4 for other extend parameter(for extend)
>> + * Q0, Q1, Q2, Q3 maybe as parameter for other functions,
>> + * the value of Q0, Q1, Q2, Q3 maybe modified.
>> + *
>> + * suggestion:
>> + * 1. dont use general purpose register for calculation
>> + * 2. set data endianness outside of the kernel
>> + * 3. use ext as shifting around
>> + * 4. dont use LD3/LD4, ST3/ST4
>> + */
>> +
>
>
> Whose suggestions are these, and why? I do appreciate comments like
> this, but only if I can learn something from it
>
>> +crc_t10dif_neon:
>
> ENTRY()
>
>> +       /* push the register to stack that CRC16 will use */
>> +       STP             X5, X6, [sp, #-0x10]!
>
> Please use an ordinary stack frame, i.e.,
>
> stp   x29, x30, [sp, #-xxx]!
> mov x29, sp
>
> where xxx is the entire allocation you need for stacking callee save registers
>
>> +       STP             X7, X8, [sp, #-0x10]!
>> +       STP             X9, X10, [sp, #-0x10]!
>> +       STP             X11, X12, [sp, #-0x10]!
>> +       STP             X13, X14, [sp, #-0x10]!
>
> These are not callee save, so no need to stack them
>
>> +       STP             Q10, Q11, [sp, #-0x20]!
>> +       STP             Q12, Q13, [sp, #-0x20]!
>> +       STP             Q4, Q5, [sp, #-0x20]!
>> +       STP             Q6, Q7, [sp, #-0x20]!
>> +       STP             Q8, Q9, [sp, #-0x20]!
>> +       STP             Q14, Q15, [sp, #-0x20]!
>> +       STP             Q16, Q17, [sp, #-0x20]!
>> +       STP             Q18, Q19, [sp, #-0x20]!
>> +
>
> What is the point of stacking the NEON registers? Also, as a general
> note, could you switch to lower case throughout the file?
>
>
>> +       SUB             sp,sp,#0x20
>> +
>
> Please account for locals in the allocation above. Only outgoing
> arguments should be allocated below the frame pointer
>
>
>> +       MOV             X11, #0         // PUSH STACK FLAG
>> +
>
> What does this comment mean?
>
>> +       CMP             X2, #0x80
>> +       B.LT            2f              // _less_than_128, <128
>> +
>
> Redundant comment
>
>> +       /* V10/V11/V12/V13      is 128bit.
>> +        * we get data 512bit( by cacheline ) each time
>> +        */
>> +       LDP             Q10, Q11, [X1], #0x20
>> +       LDP             Q12, Q13, [X1], #0x20
>> +
>> +       /* move the initial value to V6 register */
>> +       LSL             X0, X0, #48
>> +       EOR             V6.16B, V6.16B, V6.16B
>> +       MOV             V6.D[1], X0
>> +
>> +       /* big-little end change. because the data in memory is little-end,
>> +        * we deal the data for bigend
>> +        */
>> +
>
> What if I am using a big endian kernel? Hint: you probably need to
> wrap these in CPU_LE()
>
>> +       REV64           V10.16B, V10.16B
>> +       REV64           V11.16B, V11.16B
>> +       REV64           V12.16B, V12.16B
>> +       REV64           V13.16B, V13.16B
>> +       EXT             V10.16B, V10.16B, V10.16B, #8
>> +       EXT             V11.16B, V11.16B, V11.16B, #8
>> +       EXT             V12.16B, V12.16B, V12.16B, #8
>> +       EXT             V13.16B, V13.16B, V13.16B, #8
>> +
>> +       EOR             V10.16B, V10.16B, V6.16B
>> +
>> +       SUB             X2, X2, #0x80
>> +       ADD             X5, X1, #0x20
>> +
>> +       /* deal data when the size of buffer bigger than 128 bytes */
>> +       /* _fold_64_B_loop */
>> +       LDR             Q6,=0xe658000000000000044c000000000000
>
> Could you move all these non-trivial constants to a separate location
> (after the end of the function), and name them?
>
>> +1:
>> +
>> +       LDP             Q16, Q17, [X1] ,#0x40
>> +       LDP             Q18, Q19, [X5], #0x40
>> +
>> +       /* carry-less multiply.
>> +        * V10 high-64bits carry-less multiply
>> +        * V6 high-64bits(PMULL2)
>> +        * V11 low-64bits carry-less multiply V6 low-64bits(PMULL)
>> +        */
>> +
>> +       PMULL2          V4.1Q, V10.2D, V6.2D
>> +       PMULL           V10.1Q, V10.1D, V6.1D
>> +       PMULL2          V5.1Q, V11.2D, V6.2D
>> +       PMULL           V11.1Q, V11.1D, V6.1D
>> +
>
> These instructions are only available if you have the PMULL extension,
> so this algorithm is not plain NEON.
>
>> +       REV64           V16.16B, V16.16B
>> +       REV64           V17.16B, V17.16B
>> +       REV64           V18.16B, V18.16B
>> +       REV64           V19.16B, V19.16B
>> +
>
> Endian swap on LE only?
>
>> +       PMULL2          V14.1Q, V12.2D, V6.2D
>> +       PMULL           V12.1Q, V12.1D, V6.1D
>> +       PMULL2          V15.1Q, V13.2D, V6.2D
>> +       PMULL           V13.1Q, V13.1D, V6.1D
>> +
>> +       EXT             V16.16B, V16.16B, V16.16B, #8
>> +       EOR             V10.16B, V10.16B, V4.16B
>> +
>> +       EXT             V17.16B, V17.16B, V17.16B, #8
>> +       EOR             V11.16B, V11.16B, V5.16B
>> +
>> +       EXT             V18.16B, V18.16B, V18.16B, #8
>> +       EOR             V12.16B, V12.16B, V14.16B
>> +
>> +       EXT             V19.16B, V19.16B, V19.16B, #8
>> +       EOR             V13.16B, V13.16B, V15.16B
>> +
>> +       SUB             X2, X2, #0x40
>> +
>> +
>> +       EOR             V10.16B, V10.16B, V16.16B
>> +       EOR             V11.16B, V11.16B, V17.16B
>> +
>> +       EOR             V12.16B, V12.16B, V18.16B
>> +       EOR             V13.16B, V13.16B, V19.16B
>> +
>> +       CMP             X2, #0x0
>> +       B.GE            1b                      // >=0
>> +
>> +       LDR             Q6, =0x06df0000000000002d56000000000000
>> +       MOV             V4.16B, V10.16B
>> +       /* V10 carry-less 0x06df000000000000([127:64]*[127:64]) */
>> +       PMULL           V4.1Q, V4.1D, V6.1D     //switch PMULL & PMULL2 order
>> +       PMULL2          V10.1Q, V10.2D, V6.2D
>> +       EOR             V11.16B, V11.16B, V4.16B
>> +       EOR             V11.16B, V11.16B, V10.16B
>> +
>> +       MOV             V4.16B, V11.16B
>> +       PMULL           V4.1Q, V4.1D, V6.1D     //switch PMULL & PMULL2 order
>> +       PMULL2          V11.1Q, V11.2D, V6.2D
>> +       EOR             V12.16B, V12.16B, V4.16B
>> +       EOR             V12.16B, V12.16B, V11.16B
>> +
>> +       MOV             V4.16B, V12.16B
>> +       PMULL           V4.1Q, V4.1D, V6.1D     //switch PMULL & PMULL2 order
>> +       PMULL2          V12.1Q, V12.2D, V6.2D
>> +       EOR             V13.16B, V13.16B, V4.16B
>> +       EOR             V13.16B, V13.16B, V12.16B
>> +
>> +       ADD             X2, X2, #48
>> +       CMP             X2, #0x0
>> +       B.LT            3f                      // _final_reduction_for_128, <0
>> +
>> +       /* _16B_reduction_loop */
>> +4:
>> +       /* unrelated load as early as possible*/
>> +       LDR             Q10, [X1], #0x10
>> +
>> +       MOV             V4.16B, V13.16B
>> +       PMULL2          V13.1Q, V13.2D, V6.2D
>> +       PMULL           V4.1Q, V4.1D, V6.1D
>> +       EOR             V13.16B, V13.16B, V4.16B
>> +
>> +       REV64           V10.16B, V10.16B
>> +       EXT             V10.16B, V10.16B, V10.16B, #8
>> +
>> +       EOR             V13.16B, V13.16B, V10.16B
>> +
>> +       SUB             X2, X2, #0x10
>> +       CMP             X2, #0x0
>> +       B.GE            4b                      // _16B_reduction_loop, >=0
>> +
>> +       /*  _final_reduction_for_128 */
>> +3:     ADD             X2, X2, #0x10
>> +       CMP             X2, #0x0
>> +       B.EQ            5f                      // _128_done, ==0
>> +
>> +       /* _get_last_two_xmms */
>
> Bogus comment. I guess you ported this code from x86, are you sure you
> don't need to credit the original author?
>
>> +6:     MOV             V12.16B, V13.16B
>> +       SUB             X1, X1, #0x10
>> +       ADD             X1, X1, X2
>> +       LDR             Q11, [X1], #0x10
>> +       REV64           V11.16B, V11.16B
>> +       EXT             V11.16B, V11.16B, V11.16B, #8
>> +
>> +       CMP             X2, #8
>> +       B.EQ            50f
>> +       B.LT            51f
>> +       B.GT            52f
>> +
>> +50:
>> +       /* dont use X register as temp one */
>> +       FMOV            D14, D12
>> +       MOVI            D12, #0
>> +       MOV             V12.D[1],V14.D[0]
>> +       B               53f
>> +51:
>> +       MOV             X9, #64
>> +       LSL             X13, X2, #3             // <<3 equal x8
>> +       SUB             X9, X9, X13
>> +       MOV             X5, V12.D[0]            // low 64-bit
>> +       MOV             X6, V12.D[1]            // high 64-bit
>> +       LSR             X10, X5, X9             // high bit of low 64-bit
>> +       LSL             X7, X5, X13
>> +       LSL             X8, X6, X13
>> +       ORR             X8, X8, X10             // combination of high 64-bit
>> +       MOV             V12.D[1], X8
>> +       MOV             V12.D[0], X7
>> +
>> +       B               53f
>> +52:
>> +       LSL             X13, X2, #3             // <<3 equal x8
>> +       SUB             X13, X13, #64
>> +
>> +       DUP             V18.2D, X13
>> +       FMOV            D16, D12
>> +       USHL            D16, D16, D18
>> +       EXT             V12.16B, V16.16B, V16.16B, #8
>> +
>> +53:
>> +       MOVI            D14, #0                 //add one zero constant
>> +
>> +       CMP             X2, #0
>> +       B.EQ    30f
>> +       CMP             X2, #1
>> +       B.EQ    31f
>> +       CMP             X2, #2
>> +       B.EQ    32f
>> +       CMP             X2, #3
>> +       B.EQ    33f
>> +       CMP             X2, #4
>> +       B.EQ    34f
>> +       CMP             X2, #5
>> +       B.EQ    35f
>> +       CMP             X2, #6
>> +       B.EQ    36f
>> +       CMP             X2, #7
>> +       B.EQ    37f
>> +       CMP             X2, #8
>> +       B.EQ    38f
>> +       CMP             X2, #9
>> +       B.EQ    39f
>> +       CMP             X2, #10
>> +       B.EQ    40f
>> +       CMP             X2, #11
>> +       B.EQ    41f
>> +       CMP             X2, #12
>> +       B.EQ    42f
>> +       CMP             X2, #13
>> +       B.EQ    43f
>> +       CMP             X2, #14
>> +       B.EQ    44f
>> +       CMP             X2, #15
>> +       B.EQ    45f
>> +
>
> This looks awful. If you make the snippets below a fixed size, you
> could use a computed goto instead
>
>> +       // >> 128bit
>> +30:
>> +       EOR             V13.16B, V13.16B, V13.16B
>> +       EOR             V8.16B, V8.16B, V8.16B
>> +       LDR             Q9,=0xffffffffffffffffffffffffffffffff
>
> Shouldn't you initialize q8 here as well.

Never mind, I just spotted the EOR which intializes it to 0x0

> And in general, couldn't you
> use some kind of shift to generate these constants (in all cases
> below)?
>> +       B               46f
>> +
>> +       // >> 120bit
>> +31:
>> +       USHR            V13.2D, V13.2D, #56
>> +       EXT             V13.16B, V13.16B, V14.16B, #8
>> +       LDR             Q8,=0xff
>> +       LDR             Q9,=0xffffffffffffffffffffffffffffff00
>> +       B               46f
>> +
>> +       // >> 112bit
>> +32:
>> +       USHR             V13.2D, V13.2D, #48
>> +       EXT             V13.16B, V13.16B, V14.16B, #8
>> +       LDR             Q8,=0xffff
>> +       LDR             Q9,=0xffffffffffffffffffffffffffff0000
>> +       B               46f
>> +
>> +       // >> 104bit
>> +33:
>> +       USHR            V13.2D, V13.2D, #40
>> +       EXT             V13.16B, V13.16B, V14.16B, #8
>> +       LDR             Q8,=0xffffff
>> +       LDR             Q9,=0xffffffffffffffffffffffffff000000
>> +       B               46f
>> +
>> +       // >> 96bit
>> +34:
>> +       USHR            V13.2D, V13.2D, #32
>> +       EXT             V13.16B, V13.16B, V14.16B, #8
>> +       LDR             Q8,=0xffffffff
>> +       LDR             Q9,=0xffffffffffffffffffffffff00000000
>> +       B               46f
>> +
>> +       // >> 88bit
>> +35:
>> +       USHR            V13.2D, V13.2D, #24
>> +       EXT             V13.16B, V13.16B, V14.16B, #8
>> +       LDR             Q8,=0xffffffffff
>> +       LDR             Q9,=0xffffffffffffffffffffff0000000000
>> +       B               46f
>> +
>> +       // >> 80bit
>> +36:
>> +       USHR            V13.2D, V13.2D, #16
>> +       EXT             V13.16B, V13.16B, V14.16B, #8
>> +       LDR             Q8,=0xffffffffffff
>> +       LDR             Q9,=0xffffffffffffffffffff000000000000
>> +       B               46f
>> +
>> +       // >> 72bit
>> +37:
>> +       USHR            V13.2D, V13.2D, #8
>> +       EXT             V13.16B, V13.16B, V14.16B, #8
>> +       LDR             Q8,=0xffffffffffffff
>> +       LDR             Q9,=0xffffffffffffffffff00000000000000
>> +       B               46f
>> +
>> +       // >> 64bit
>> +38:
>> +       EXT              V13.16B, V13.16B, V14.16B, #8
>> +       LDR             Q8,=0xffffffffffffffff
>> +       LDR             Q9,=0xffffffffffffffff0000000000000000
>> +       B               46f
>> +
>> +       // >> 56bit
>> +39:
>> +       EXT             V13.16B, V13.16B, V13.16B, #7
>> +       MOV             V13.S[3], V14.S[0]
>> +       MOV             V13.H[5], V14.H[0]
>> +       MOV             V13.B[9], V14.B[0]
>> +
>> +       LDR             Q8,=0xffffffffffffffffff
>> +       LDR             Q9,=0xffffffffffffff000000000000000000
>> +       B               46f
>> +
>> +       // >> 48bit
>> +40:
>> +       EXT             V13.16B, V13.16B, V13.16B, #6
>> +       MOV             V13.S[3], V14.S[0]
>> +       MOV             V13.H[5], V14.H[0]
>> +
>> +       LDR             Q8,=0xffffffffffffffffffff
>> +       LDR             Q9,=0xffffffffffff00000000000000000000
>> +       B               46f
>> +
>> +       // >> 40bit
>> +41:
>> +       EXT             V13.16B, V13.16B, V13.16B, #5
>> +       MOV             V13.S[3], V14.S[0]
>> +       MOV             V13.B[11], V14.B[0]
>> +
>> +       LDR             Q8,=0xffffffffffffffffffffff
>> +       LDR             Q9,=0xffffffffff0000000000000000000000
>> +       B               46f
>> +
>> +       // >> 32bit
>> +42:
>> +       EXT             V13.16B, V13.16B, V13.16B, #4
>> +       MOV             V13.S[3], V14.S[0]
>> +
>> +       LDR             Q8,=0xffffffffffffffffffffffff
>> +       LDR             Q9,=0xffffffff000000000000000000000000
>> +       B               46f
>> +
>> +       // >> 24bit
>> +43:
>> +       EXT             V13.16B, V13.16B, V13.16B, #3
>> +       MOV             V13.H[7], V14.H[0]
>> +       MOV             V13.B[13], V14.B[0]
>> +
>> +       LDR             Q8,=0xffffffffffffffffffffffffff
>> +       LDR             Q9,=0xffffff00000000000000000000000000
>> +       B               46f
>> +
>> +       // >> 16bit
>> +44:
>> +       EXT             V13.16B, V13.16B, V13.16B, #2
>> +       MOV             V13.H[7], V14.H[0]
>> +
>> +       LDR             Q8,=0xffffffffffffffffffffffffffff
>> +       LDR             Q9,=0xffff0000000000000000000000000000
>> +       B               46f
>> +
>> +       // >> 8bit
>> +45:
>> +       EXT              V13.16B, V13.16B, V13.16B, #1
>> +       MOV             V13.B[15], V14.B[0]
>> +
>> +       LDR             Q8,=0xffffffffffffffffffffffffffffff
>> +       LDR             Q9,=0xff000000000000000000000000000000
>> +
>> +       // backup V12 first
>> +       // pblendvb     xmm1, xmm2
>
> Another remnant of the x86 version, please remove
>
>> +46:
>> +       AND             V12.16B, V12.16B, V9.16B
>> +       AND             V11.16B, V11.16B, V8.16B
>> +       ORR             V11.16B, V11.16B, V12.16B
>> +
>> +       MOV             V12.16B, V11.16B
>> +       MOV             V4.16B, V13.16B
>> +       PMULL2          V13.1Q, V13.2D, V6.2D
>> +       PMULL           V4.1Q, V4.1D, V6.1D
>> +       EOR             V13.16B, V13.16B, V4.16B
>> +       EOR             V13.16B, V13.16B, V12.16B
>> +
>> +       /* _128_done. we change the Q6 D[0] and D[1] */
>> +5:     LDR             Q6, =0x2d560000000000001368000000000000
>> +       MOVI            D14, #0
>> +       MOV             V10.16B, V13.16B
>> +       PMULL2          V13.1Q, V13.2D, V6.2D
>> +
>> +       MOV             V10.D[1], V10.D[0]
>> +       MOV             V10.D[0], V14.D[0]    //set zero
>> +
>> +       EOR             V13.16B, V13.16B, V10.16B
>> +
>> +       MOV             V10.16B, V13.16B
>> +       LDR             Q7, =0x00000000FFFFFFFFFFFFFFFFFFFFFFFF
>> +       AND             V10.16B, V10.16B, V7.16B
>> +
>> +       MOV             S13, V13.S[3]
>> +
>> +       PMULL           V13.1Q, V13.1D, V6.1D
>> +       EOR             V13.16B, V13.16B, V10.16B
>> +
>> +       /* _barrett */
>
> What does '_barrett' mean?
>
>> +7:     LDR             Q6, =0x00000001f65a57f8000000018bb70000
>> +       MOVI            D14, #0
>> +       MOV             V10.16B, V13.16B
>> +       PMULL2          V13.1Q, V13.2D, V6.2D
>> +
>> +       EXT             V13.16B, V13.16B, V13.16B, #12
>> +       MOV             V13.S[0], V14.S[0]
>> +
>> +       EXT             V6.16B, V6.16B, V6.16B, #8
>> +       PMULL2          V13.1Q, V13.2D, V6.2D
>> +
>> +       EXT             V13.16B, V13.16B, V13.16B, #12
>> +       MOV             V13.S[0], V14.S[0]
>> +
>> +       EOR             V13.16B, V13.16B, V10.16B
>> +       MOV             X0, V13.D[0]
>> +
>> +       /* _cleanup */
>> +8:     MOV             X14, #48
>> +       LSR             X0, X0, X14
>
> Why the temp x14?
>
>> +99:
>> +       ADD             sp, sp, #0x20
>> +
>> +       LDP             Q18, Q19, [sp], #0x20
>> +       LDP             Q16, Q17, [sp], #0x20
>> +       LDP             Q14, Q15, [sp], #0x20
>> +
>> +       LDP             Q8, Q9, [sp], #0x20
>> +       LDP             Q6, Q7, [sp], #0x20
>> +       LDP             Q4, Q5, [sp], #0x20
>> +       LDP             Q12, Q13, [sp], #0x20
>> +       LDP             Q10, Q11, [sp], #0x20
>> +       LDP             X13, X14, [sp], #0x10
>> +       LDP             X11, X12, [sp], #0x10
>> +       LDP             X9, X10, [sp], #0x10
>> +       LDP             X7, X8, [sp], #0x10
>> +       LDP             X5, X6, [sp], #0x10
>> +
>
> None of these registers need to be restored. The only thing you need
> (to mirror the prologue)
>
> ldp x29, x30, [sp], #xxx
> ret
>
> where xxx is the same value you used at the beginning.
>
>
>> +       RET
>> +
>> +       /* _less_than_128 */
>> +2:     CMP             X2, #32
>> +       B.LT            9f                              // _less_than_32
>> +       LDR             Q6, =0x06df0000000000002d56000000000000
>> +
>> +       LSL             X0, X0, #48
>> +       LDR             Q10, =0x0
>
> Please use movi here
>
>> +       MOV             V10.D[1], X0
>> +       LDR             Q13, [X1], #0x10
>> +       REV64           V13.16B, V13.16B
>> +       EXT             V13.16B, V13.16B, V13.16B, #8
>> +
>> +       EOR             V13.16B, V13.16B, V10.16B
>> +
>> +       SUB             X2, X2, #32
>> +       B               4b
>> +
>> +       /* _less_than_32 */
>> +9:     CMP             X2, #0
>> +       B.EQ            99b                     // _cleanup
>
> You can use CBZ here
>
>> +       LSL             X0, X0, #48
>> +       LDR             Q10,=0x0
>
> Please use movi here
>
>> +       MOV             V10.D[1], X0
>> +
>> +       CMP             X2, #16
>> +       B.EQ            10f                     // _exact_16_left
>> +       B.LE            11f                     // _less_than_16_left
>> +       LDR             Q13, [X1], #0x10
>> +
>> +       REV64           V13.16B, V13.16B
>> +       EXT             V13.16B, V13.16B, V13.16B, #8
>> +
>> +       EOR             V13.16B, V13.16B, V10.16B
>> +       SUB             X2, X2, #16
>> +       LDR             Q6, =0x06df0000000000002d56000000000000
>> +       B               6b                      // _get_last_two_xmms
>
> Another bogus comment
>
>> +
>> +       /*  _less_than_16_left */
>> +11:    CMP             X2, #4
>> +       B.LT            13f                     // _only_less_than_4
>> +
>> +       /* backup the length of data, we used in _less_than_2_left */
>> +       MOV             X8, X2
>> +       CMP             X2, #8
>> +       B.LT            14f                     // _less_than_8_left
>> +
>> +       LDR             X14, [X1], #8
>> +       /* push the data to stack, we backup the data to V10 */
>> +       STR             X14, [sp, #0]
>> +       SUB             X2, X2, #8
>> +       ADD             X11, X11, #8
>> +
>> +       /* _less_than_8_left */
>> +14:    CMP             X2, #4
>> +       B.LT            15f                     // _less_than_4_left
>> +
>> +       /* get 32bit data */
>> +       LDR             W5, [X1], #4
>> +
>> +       /* push the data to stack */
>> +       STR             W5, [sp, X11]
>> +       SUB             X2, X2, #4
>> +       ADD             X11, X11, #4
>> +
>> +       /* _less_than_4_left */
>> +15:    CMP             X2, #2
>> +       B.LT            16f                     // _less_than_2_left
>> +
>> +       /* get 16bits data */
>> +       LDRH            W6, [X1], #2
>> +
>> +       /* push the data to stack */
>> +       STRH            W6, [sp, X11]
>> +       SUB             X2, X2, #2
>> +       ADD             X11, X11, #2
>> +
>> +       /* _less_than_2_left */
>> +16:
>> +       /* get 8bits data */
>> +       LDRB            W7, [X1], #1
>> +       STRB            W7, [sp, X11]
>> +       ADD             X11, X11, #1
>> +
>> +       /* POP data from stack, store to V13 */
>> +       LDR             Q13, [sp]
>> +       MOVI            D14, #0
>> +       REV64           V13.16B, V13.16B
>> +       MOV             V8.16B, V13.16B
>> +       MOV             V13.D[1], V8.D[0]
>> +       MOV             V13.D[0], V8.D[1]
>> +
>> +       EOR             V13.16B, V13.16B, V10.16B
>> +       CMP             X8, #15
>> +       B.EQ    80f
>> +       CMP             X8, #14
>> +       B.EQ    81f
>> +       CMP             X8, #13
>> +       B.EQ    82f
>> +       CMP             X8, #12
>> +       B.EQ    83f
>> +       CMP             X8, #11
>> +       B.EQ    84f
>> +       CMP             X8, #10
>> +       B.EQ    85f
>> +       CMP             X8, #9
>> +       B.EQ    86f
>> +       CMP             X8, #8
>> +       B.EQ    87f
>> +       CMP             X8, #7
>> +       B.EQ    88f
>> +       CMP             X8, #6
>> +       B.EQ    89f
>> +       CMP             X8, #5
>> +       B.EQ    90f
>> +       CMP             X8, #4
>> +       B.EQ    91f
>> +       CMP             X8, #3
>> +       B.EQ    92f
>> +       CMP             X8, #2
>> +       B.EQ    93f
>> +       CMP             X8, #1
>> +       B.EQ    94f
>> +       CMP             X8, #0
>> +       B.EQ    95f
>> +
>
> Again, please use a computed goto instead
>
>> +80:
>> +       EXT             V13.16B, V13.16B, V13.16B, #1
>> +       MOV             V13.B[15], V14.B[0]
>> +       B               5b
>> +
>> +81:
>> +       EXT             V13.16B, V13.16B, V13.16B, #2
>> +       MOV              V13.H[7], V14.H[0]
>> +       B               5b
>> +
>> +82:
>> +       EXT             V13.16B, V13.16B, V13.16B, #3
>> +       MOV             V13.H[7], V14.H[0]
>> +       MOV             V13.B[13], V14.B[0]
>> +       B               5b
>> +83:
>> +
>> +       EXT             V13.16B, V13.16B, V13.16B, #4
>> +       MOV             V13.S[3], V14.S[0]
>> +       B               5b
>> +
>> +84:
>> +       EXT             V13.16B, V13.16B, V13.16B, #5
>> +       MOV             V13.S[3], V14.S[0]
>> +       MOV             V13.B[11], V14.B[0]
>> +       B               5b
>> +
>> +85:
>> +       EXT             V13.16B, V13.16B, V13.16B, #6
>> +       MOV             V13.S[3], V14.S[0]
>> +       MOV             V13.H[5], V14.H[0]
>> +       B               5b
>> +
>> +86:
>> +       EXT             V13.16B, V13.16B, V13.16B, #7
>> +       MOV             V13.S[3], V14.S[0]
>> +       MOV             V13.H[5], V14.H[0]
>> +       MOV             V13.B[9], V14.B[0]
>> +       B               5b
>> +
>> +87:
>> +       MOV             V13.D[0], V13.D[1]
>> +       MOV             V13.D[1], V14.D[0]
>> +       B               5b
>> +
>> +88:
>> +       EXT             V13.16B, V13.16B, V13.16B, #9
>> +       MOV             V13.D[1], V14.D[0]
>> +       MOV             V13.B[7], V14.B[0]
>> +       B               5b
>> +
>> +89:
>> +       EXT             V13.16B, V13.16B, V13.16B, #10
>> +       MOV             V13.D[1], V14.D[0]
>> +       MOV              V13.H[3], V14.H[0]
>> +       B               5b
>> +
>> +90:
>> +       EXT             V13.16B, V13.16B, V13.16B, #11
>> +       MOV             V13.D[1], V14.D[0]
>> +       MOV             V13.H[3], V14.H[0]
>> +       MOV             V13.B[5], V14.B[0]
>> +       B               5b
>> +
>> +91:
>> +       MOV             V13.S[0], V13.S[3]
>> +       MOV             V13.D[1], V14.D[0]
>> +       MOV             V13.S[1], V14.S[0]
>> +       B               5b
>> +
>> +92:
>> +       EXT             V13.16B, V13.16B, V13.16B, #13
>> +       MOV             V13.D[1], V14.D[0]
>> +       MOV             V13.S[1], V14.S[0]
>> +       MOV             V13.B[3], V14.B[0]
>> +       B               5b
>> +
>> +93:
>> +       MOV             V15.H[0], V13.H[7]
>> +       MOV             V13.16B, V14.16B
>> +       MOV             V13.H[0], V15.H[0]
>> +       B               5b
>> +
>> +94:
>> +       MOV             V15.B[0], V13.B[15]
>> +       MOV             V13.16B, V14.16B
>> +       MOV             V13.B[0], V15.B[0]
>> +       B               5b
>> +
>> +95:
>> +       LDR             Q13,=0x0
>
> movi
>
>> +       B               5b                              // _128_done
>> +
>> +       /* _exact_16_left */
>> +10:
>> +       LD1             { V13.2D }, [X1], #0x10
>> +
>> +       REV64           V13.16B, V13.16B
>> +       EXT             V13.16B, V13.16B, V13.16B, #8
>> +       EOR             V13.16B, V13.16B, V10.16B
>> +       B               5b                              // _128_done
>> +
>> +       /* _only_less_than_4 */
>> +13:    CMP             X2, #3
>> +       MOVI            D14, #0
>> +       B.LT            17f                             //_only_less_than_3
>> +
>> +       LDR             S13, [X1], #4
>> +       MOV              V13.B[15], V13.B[0]
>> +       MOV             V13.B[14], V13.B[1]
>> +       MOV             V13.B[13], V13.B[2]
>> +       MOV             V13.S[0], V13.S[1]
>> +
>> +       EOR             V13.16B, V13.16B, V10.16B
>> +
>> +       EXT             V13.16B, V13.16B, V13.16B, #5
>> +
>> +       MOV             V13.S[3], V14.S[0]
>> +       MOV             V13.B[11], V14.B[0]
>> +
>> +       B               7b                              // _barrett
>> +       /* _only_less_than_3 */
>> +17:
>> +       CMP             X2, #2
>> +       B.LT            18f                             // _only_less_than_2
>> +
>> +       LDR             H13, [X1], #2
>> +       MOV             V13.B[15], V13.B[0]
>> +       MOV             V13.B[14], V13.B[1]
>> +       MOV             V13.H[0], V13.H[1]
>> +
>> +       EOR             V13.16B, V13.16B, V10.16B
>> +
>> +       EXT             V13.16B, V13.16B, V13.16B, #6
>> +       MOV             V13.S[3], V14.S[0]
>> +       MOV             V13.H[5], V14.H[0]
>> +
>> +       B               7b                              // _barrett
>> +
>> +       /* _only_less_than_2 */
>> +18:
>> +       LDRB            W7, [X1], #1
>> +       LDR             Q13, = 0x0
>> +       MOV             V13.B[15], W7
>> +
>> +       EOR             V13.16B, V13.16B, V10.16B
>> +
>> +       EXT             V13.16B, V13.16B, V13.16B, #7
>> +       MOV             V13.S[3], V14.S[0]
>> +       MOV             V13.H[5], V14.H[0]
>> +       MOV             V13.B[9], V14.B[0]
>> +
>> +       B               7b                              // _barrett
>
> Please end with ENDPROC()
>
>> diff --git a/arch/arm64/crypto/crct10dif-neon_glue.c b/arch/arm64/crypto/crct10dif-neon_glue.c
>> new file mode 100644
>> index 0000000..a6d8c5c
>> --- /dev/null
>> +++ b/arch/arm64/crypto/crct10dif-neon_glue.c
>> @@ -0,0 +1,115 @@
>> +/*
>> + * Copyright (c) 2016-2017 Hisilicon Limited.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +
>> +#include <linux/types.h>
>> +#include <linux/module.h>
>> +#include <linux/crc-t10dif.h>
>> +#include <crypto/internal/hash.h>
>> +#include <linux/init.h>
>> +#include <linux/string.h>
>> +#include <linux/kernel.h>
>> +
>> +asmlinkage __u16 crc_t10dif_neon(__u16 crc, const unsigned char *buf,
>> +                               size_t len);
>> +
>> +struct chksum_desc_ctx {
>> +       __u16 crc;
>> +};
>> +
>> +/*
>> + * Steps through buffer one byte at at time, calculates reflected
>> + * crc using table.
>> + */
>> +
>
> Where is the table?
>
>> +static int chksum_init(struct shash_desc *desc)
>> +{
>> +       struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
>> +
>> +       ctx->crc = 0;
>> +
>> +       return 0;
>> +}
>> +
>> +static int chksum_update(struct shash_desc *desc, const u8 *data,
>> +                        unsigned int length)
>> +{
>> +       struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
>> +
>> +       ctx->crc = crc_t10dif_neon(ctx->crc, data, length);
>
> You need kernel_neon_begin/kernel_neon_end here
>
>> +       return 0;
>> +}
>> +
>> +static int chksum_final(struct shash_desc *desc, u8 *out)
>> +{
>> +       struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
>> +
>> +       *(__u16 *)out = ctx->crc;
>> +       return 0;
>> +}
>> +
>> +static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
>> +                       u8 *out)
>> +{
>> +       *(__u16 *)out = crc_t10dif_neon(*crcp, data, len);
>
> ... and here
>
>> +       return 0;
>> +}
>> +
>> +static int chksum_finup(struct shash_desc *desc, const u8 *data,
>> +                       unsigned int len, u8 *out)
>> +{
>> +       struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
>> +
>> +       return __chksum_finup(&ctx->crc, data, len, out);
>> +}
>> +
>> +static int chksum_digest(struct shash_desc *desc, const u8 *data,
>> +                        unsigned int length, u8 *out)
>> +{
>> +       struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
>> +
>> +       return __chksum_finup(&ctx->crc, data, length, out);
>> +}
>> +
>> +static struct shash_alg alg = {
>> +       .digestsize             =       CRC_T10DIF_DIGEST_SIZE,
>> +       .init           =       chksum_init,
>> +       .update         =       chksum_update,
>> +       .final          =       chksum_final,
>> +       .finup          =       chksum_finup,
>> +       .digest         =       chksum_digest,
>> +       .descsize               =       sizeof(struct chksum_desc_ctx),
>> +       .base                   =       {
>> +               .cra_name               =       "crct10dif",
>> +               .cra_driver_name        =       "crct10dif-neon",
>> +               .cra_priority           =       200,
>> +               .cra_blocksize          =       CRC_T10DIF_BLOCK_SIZE,
>> +               .cra_module             =       THIS_MODULE,
>
>
> Please align the = characters here, and add only a single space after
>
> Note that you can do
>
> .base.cra_name = xxx,
> .base.xxx
>
> as well.
>
>> +       }
>> +};
>> +
>> +static int __init crct10dif_arm64_mod_init(void)
>> +{
>> +       return crypto_register_shash(&alg);
>
> You need to check here if your CPU has support for the 64x64->128
> PMULL instruction.
>
>> +}
>> +
>> +static void __exit crct10dif_arm64_mod_fini(void)
>> +{
>> +       crypto_unregister_shash(&alg);
>> +}
>> +
>> +module_init(crct10dif_arm64_mod_init);
>> +module_exit(crct10dif_arm64_mod_fini);
>> +
>> +MODULE_AUTHOR("YueHaibing <yuehaibing@huawei.com>");
>> +MODULE_DESCRIPTION("T10 DIF CRC calculation accelerated with ARM64 NEON instruction.");
>> +MODULE_LICENSE("GPL");
>> +
>> +MODULE_ALIAS_CRYPTO("crct10dif");
>> +MODULE_ALIAS_CRYPTO("crct10dif-neon");
>> --
>> 2.7.0
>>
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

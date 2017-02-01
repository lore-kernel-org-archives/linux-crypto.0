From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] crypto: arm64/crc32 - detect crc32 support in assembler
Date: Wed, 1 Feb 2017 14:58:41 +0100
Message-ID: <5ebb24d2-81d4-53c7-0365-f35a0eb3588b@suse.de>
References: <20170127104039.29351-1-mbrugger@suse.com>
 <CAKv+Gu8P3U6_u7FdRFSdDL9jdKaJQuqHbrQ-7Qu900f8R1voZw@mail.gmail.com>
 <20170127105244.GF21144@arm.com>
 <CAKv+Gu_LcU3mSSMdrjks02ZuhHLhkYqNuZGOcTp1AmS8cpzCDg@mail.gmail.com>
 <CAKv+Gu9gPAb-AMdbK32dXciX1mgh1sqSrxMAjB-ZGw7uAk2r2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Matthias Brugger <mbrugger@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Yazen Ghannam <yazen.ghannam@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48343 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750932AbdBAN6v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 08:58:51 -0500
In-Reply-To: <CAKv+Gu9gPAb-AMdbK32dXciX1mgh1sqSrxMAjB-ZGw7uAk2r2Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/01/2017 10:43 AM, Ard Biesheuvel wrote:
> On 1 February 2017 at 09:07, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> On 27 January 2017 at 10:52, Will Deacon <will.deacon@arm.com> wrote:
>>> On Fri, Jan 27, 2017 at 10:43:16AM +0000, Ard Biesheuvel wrote:
>>>> On 27 January 2017 at 10:40, Matthias Brugger <mbrugger@suse.com> wrote:
>>>>> Older compilers may not be able to detect the crc32 extended cpu type.
>>>> What do you mean 'detect'? Could you describe the failure in more detail
>>>> please?
>>>>
>>>>> Anyway only inline assembler code is used, which gets passed to the
>>>>> assembler. This patch moves the crc detection to the assembler.
>>>>>
>>>>> Suggested-by: Alexander Graf <agraf@suse.de>
>>>>> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
>>>>> ---
>>>>>   arch/arm64/crypto/Makefile      | 2 --
>>>>>   arch/arm64/crypto/crc32-arm64.c | 3 +++
>>>>>   2 files changed, 3 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
>>>>> index aa8888d7b744..0d779dac75cd 100644
>>>>> --- a/arch/arm64/crypto/Makefile
>>>>> +++ b/arch/arm64/crypto/Makefile
>>>>> @@ -48,8 +48,6 @@ CFLAGS_aes-glue-ce.o  := -DUSE_V8_CRYPTO_EXTENSIONS
>>>>>
>>>>>   obj-$(CONFIG_CRYPTO_CRC32_ARM64) += crc32-arm64.o
>>>>>
>>>>> -CFLAGS_crc32-arm64.o   := -mcpu=generic+crc
>>>>> -
>>>>>   $(obj)/aes-glue-%.o: $(src)/aes-glue.c FORCE
>>>>>          $(call if_changed_rule,cc_o_c)
>>>>>
>>>>> diff --git a/arch/arm64/crypto/crc32-arm64.c b/arch/arm64/crypto/crc32-arm64.c
>>>>> index 6a37c3c6b11d..10f5dd075323 100644
>>>>> --- a/arch/arm64/crypto/crc32-arm64.c
>>>>> +++ b/arch/arm64/crypto/crc32-arm64.c
>>>>> @@ -29,6 +29,9 @@ MODULE_AUTHOR("Yazen Ghannam <yazen.ghannam@linaro.org>");
>>>>>   MODULE_DESCRIPTION("CRC32 and CRC32C using optional ARMv8 instructions");
>>>>>   MODULE_LICENSE("GPL v2");
>>>>>
>>>>> +/* Request crc extension capabilities from the assembler */
>>>>> +asm(".arch_extension crc");
>>>>> +
>>>> Will should confirm, but I think this is a recent feature in GAS for
>>>> AArch64, so this may break older toolchains as well.
>>> Yes, the .arch_extension directive isn't universally supported by AArch64
>>> gas so we can't rely on it unconditionally. The best bet is to check for
>>> the support and, if it's not present, then disable whatever feature relies
>>> on it. See the lseinstr variable in Makefile.
>>>
>> Actually, this driver has become somewhat redundant now that we have
>> an alternative that combines an implementation based on 64x64
>> polynomial multiplication with an implementation based on the CRC32
>> instructions.
>>
>> I will propose a patch that makes the latter usable when only the
>> CRC32 instructions are supported.
> ... although you still haven't explained what the actual problem is
> that you are trying to solve.



The problem is that in Leap 42.2 (as well as SLES12 SP2) we have a 4.8 
based system compiler, but recent binutils. That means that while our 
assembler is happy to work with crc instructions, passing the -mcpu 
parameter to gcc fails because gcc isn't aware of the flavor yet.

That in turn means that we want to tell the assembler about feature 
requirements rather than the compiler. Fortunately the ".arch_extension" 
primitive allows you to do so.

As far as checking for availability of it goes, I agree that it'd be 
nice to check if ".arch_extension" is supported. But so would be to 
check if -mcpu=generic+crc is supported. IMHO this patch doesn't make 
the current non-checking situation any worse. But of course checking is 
always nicer than not checking :)


Alex

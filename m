From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm64/crc32 - detect crc32 support in assembler
Date: Wed, 1 Feb 2017 09:07:39 +0000
Message-ID: <CAKv+Gu_LcU3mSSMdrjks02ZuhHLhkYqNuZGOcTp1AmS8cpzCDg@mail.gmail.com>
References: <20170127104039.29351-1-mbrugger@suse.com> <CAKv+Gu8P3U6_u7FdRFSdDL9jdKaJQuqHbrQ-7Qu900f8R1voZw@mail.gmail.com>
 <20170127105244.GF21144@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Matthias Brugger <mbrugger@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Yazen Ghannam <yazen.ghannam@linaro.org>,
        Alexander Graf <agraf@suse.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35517 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751688AbdBAJHk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 04:07:40 -0500
Received: by mail-it0-f43.google.com with SMTP id 203so12542430ith.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Feb 2017 01:07:40 -0800 (PST)
In-Reply-To: <20170127105244.GF21144@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 27 January 2017 at 10:52, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Jan 27, 2017 at 10:43:16AM +0000, Ard Biesheuvel wrote:
>> On 27 January 2017 at 10:40, Matthias Brugger <mbrugger@suse.com> wrote:
>> > Older compilers may not be able to detect the crc32 extended cpu type.
>>
>> What do you mean 'detect'? Could you describe the failure in more detail
>> please?
>>
>> > Anyway only inline assembler code is used, which gets passed to the
>> > assembler. This patch moves the crc detection to the assembler.
>> >
>> > Suggested-by: Alexander Graf <agraf@suse.de>
>> > Signed-off-by: Matthias Brugger <mbrugger@suse.com>
>> > ---
>> >  arch/arm64/crypto/Makefile      | 2 --
>> >  arch/arm64/crypto/crc32-arm64.c | 3 +++
>> >  2 files changed, 3 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
>> > index aa8888d7b744..0d779dac75cd 100644
>> > --- a/arch/arm64/crypto/Makefile
>> > +++ b/arch/arm64/crypto/Makefile
>> > @@ -48,8 +48,6 @@ CFLAGS_aes-glue-ce.o  := -DUSE_V8_CRYPTO_EXTENSIONS
>> >
>> >  obj-$(CONFIG_CRYPTO_CRC32_ARM64) += crc32-arm64.o
>> >
>> > -CFLAGS_crc32-arm64.o   := -mcpu=generic+crc
>> > -
>> >  $(obj)/aes-glue-%.o: $(src)/aes-glue.c FORCE
>> >         $(call if_changed_rule,cc_o_c)
>> >
>> > diff --git a/arch/arm64/crypto/crc32-arm64.c b/arch/arm64/crypto/crc32-arm64.c
>> > index 6a37c3c6b11d..10f5dd075323 100644
>> > --- a/arch/arm64/crypto/crc32-arm64.c
>> > +++ b/arch/arm64/crypto/crc32-arm64.c
>> > @@ -29,6 +29,9 @@ MODULE_AUTHOR("Yazen Ghannam <yazen.ghannam@linaro.org>");
>> >  MODULE_DESCRIPTION("CRC32 and CRC32C using optional ARMv8 instructions");
>> >  MODULE_LICENSE("GPL v2");
>> >
>> > +/* Request crc extension capabilities from the assembler */
>> > +asm(".arch_extension crc");
>> > +
>>
>> Will should confirm, but I think this is a recent feature in GAS for
>> AArch64, so this may break older toolchains as well.
>
> Yes, the .arch_extension directive isn't universally supported by AArch64
> gas so we can't rely on it unconditionally. The best bet is to check for
> the support and, if it's not present, then disable whatever feature relies
> on it. See the lseinstr variable in Makefile.
>

Actually, this driver has become somewhat redundant now that we have
an alternative that combines an implementation based on 64x64
polynomial multiplication with an implementation based on the CRC32
instructions.

I will propose a patch that makes the latter usable when only the
CRC32 instructions are supported.

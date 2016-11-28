From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 4/4] crypto: arm/crct10dif - port x86 SSE implementation
 to ARM
Date: Mon, 28 Nov 2016 15:59:15 +0100
Message-ID: <CAKv+Gu_fh=UdMzh-K1E8zLNwnHFTtV0X+Opvxyf44yRfkGEO3w@mail.gmail.com>
References: <1480002201-1427-1-git-send-email-ard.biesheuvel@linaro.org>
 <1480002201-1427-5-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu8tPfX76ntdQmMz53waE73RHfB11oRs8w=Ufy7d=YqbGA@mail.gmail.com> <20161128131748.GA2757@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Steve Capper <steve.capper@linaro.org>,
        dingtinahong <dingtianhong@huawei.com>, yangshengkai@huawei.com,
        YueHaibing <yuehaibing@huawei.com>,
        Hanjun Guo <hanjun.guo@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34605 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932342AbcK1O7Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 09:59:16 -0500
Received: by mail-oi0-f51.google.com with SMTP id y198so152470487oia.1
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2016 06:59:16 -0800 (PST)
In-Reply-To: <20161128131748.GA2757@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 28 November 2016 at 14:17, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Nov 24, 2016 at 05:32:42PM +0000, Ard Biesheuvel wrote:
>> On 24 November 2016 at 15:43, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> > This is a straight transliteration of the Intel algorithm implemented
>> > using SSE and PCLMULQDQ instructions that resides under in the file
>> > arch/x86/crypto/crct10dif-pcl-asm_64.S.
>> >
>> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> > ---
>> >  arch/arm/crypto/Kconfig                        |   5 +
>> >  arch/arm/crypto/Makefile                       |   2 +
>> >  arch/{arm64 => arm}/crypto/crct10dif-ce-core.S | 457 +++++++++++---------
>> >  arch/{arm64 => arm}/crypto/crct10dif-ce-glue.c |  23 +-
>> >  4 files changed, 277 insertions(+), 210 deletions(-)
>> >
>>
>> This patch needs the following hunk folded in to avoid breaking the
>> Thumb2 build:
>>
>> """
>> diff --git a/arch/arm/crypto/crct10dif-ce-core.S
>> b/arch/arm/crypto/crct10dif-ce-core.S
>> index 30168b0f8581..4fdbca94dd0c 100644
>> --- a/arch/arm/crypto/crct10dif-ce-core.S
>> +++ b/arch/arm/crypto/crct10dif-ce-core.S
>> @@ -152,7 +152,8 @@ CPU_LE(     vrev64.8        q7, q7                  )
>>         // XOR the initial_crc value
>>         veor.8          q0, q0, q10
>>
>> -       adrl            ip, rk3
>> +ARM(   adrl            ip, rk3         )
>> +THUMB( adr             ip, rk3         )
>>         vld1.64         {q10}, [ip]     // xmm10 has rk3 and rk4
>>                                         // type of pmull instruction
>>                                         // will determine which constant to use
>> """
>
> I'm sorry but this patch doesn't apply on top of the other four.
> So please resend the whole series.
>

Yes, please disregard all CRC ARM/arm64 patches for now, I will
consolidate them into a single v2 and send it out after the merge
window.

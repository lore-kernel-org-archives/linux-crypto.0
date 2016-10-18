From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 0/8] crypto: ARM/arm64 - big endian fixes
Date: Tue, 18 Oct 2016 13:14:38 +0100
Message-ID: <CAKv+Gu9wuXnrq77a3Zk0GnHgnkpURh=EegwgP+vAwMC=rdm3qA@mail.gmail.com>
References: <1476209720-21114-1-git-send-email-ard.biesheuvel@linaro.org> <20161018114932.GG10115@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37177 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753089AbcJRMOj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 08:14:39 -0400
Received: by mail-it0-f48.google.com with SMTP id m138so77922713itm.0
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2016 05:14:39 -0700 (PDT)
In-Reply-To: <20161018114932.GG10115@e104818-lin.cambridge.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 October 2016 at 12:49, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Tue, Oct 11, 2016 at 07:15:12PM +0100, Ard Biesheuvel wrote:
>> As it turns out, none of the accelerated crypto routines under arch/arm64/crypto
>> currently work, or have ever worked correctly when built for big endian. So this
>> series fixes all of them. This v2 now includes a similar fix for 32-bit ARM as
>> well, and an additional fix for XTS which escaped my attention before.
>>
>> Each of these patches carries a fixes tag, and could be backported to stable.
>> However, for patches #1 and #5, the fixes tag denotes the oldest commit that the
>> fix is compatible with, not the patch that introduced the algorithm.
>
> I think for future reference, the Fixes tag should denote the commit
> that introduced the issue. An explicit Cc: stable tag would state how
> far back it should be applied.
>

OK, that sounds reasonable.

>> Ard Biesheuvel (8):
>>   crypto: arm64/aes-ce - fix for big endian
>>   crypto: arm64/ghash-ce - fix for big endian
>>   crypto: arm64/sha1-ce - fix for big endian
>>   crypto: arm64/sha2-ce - fix for big endian
>>   crypto: arm64/aes-ccm-ce: fix for big endian
>>   crypto: arm64/aes-neon - fix for big endian
>>   crypto: arm64/aes-xts-ce: fix for big endian
>>   crypto: arm/aes-ce - fix for big endian
>
> The changes look fine to me but I can't claim I fully understand these
> algorithms. FWIW:
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>
> (Will may pick them up for 4.9-rcX)

Thanks, although I was kind of expecting Herbert to pick these up,
given that #8 affects ARM not arm64.

But if you (or Will) can pick up #1 to #7, that is also fine, then I
can drop #8 into rmk's patch database.

Thanks,
Ard,

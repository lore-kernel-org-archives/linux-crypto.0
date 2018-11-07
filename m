Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:54324 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbeKHCVd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 21:21:33 -0500
Subject: Re: [RFC PATCH 1/4] kconfig: add as-instr macro to
 scripts/Kconfig.include
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
        yamada.masahiro@socionext.com, linux-crypto@vger.kernel.org,
        linux-kbuild@vger.kernel.org, kbuild-all@01.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <1541583608-26375-1-git-send-email-vladimir.murzin@arm.com>
 <1541583608-26375-2-git-send-email-vladimir.murzin@arm.com>
 <20181107145552.GC2623@brain-police>
From: Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <74f9cecb-4efa-718c-b147-f7adf956c7bd@arm.com>
Date: Wed, 7 Nov 2018 16:50:20 +0000
MIME-Version: 1.0
In-Reply-To: <20181107145552.GC2623@brain-police>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/11/18 14:55, Will Deacon wrote:
> On Wed, Nov 07, 2018 at 09:40:05AM +0000, Vladimir Murzin wrote:
>> There are cases where the whole feature, for instance arm64/lse or
>> arm/crypto, can depend on assembler. Current practice is to report
>> buildtime that selected feature is not supported, which can be quite
>> annoying...
> 
> Why is it annoying? You still end up with a working kernel.

.config doesn't really represent if option was built or not, annoying
part is digging build logs (if anyone's saved them at all!) or relevant
parts of dmesg (if option throws anything in there and which not always
part of reports).

> 
>> It'd nicer if we can check assembler first and opt-in feature
>> visibility in Kconfig.
>>
>> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>>  scripts/Kconfig.include | 4 ++++
>>  1 file changed, 4 insertions(+)
> 
> One issue I have with doing the check like this is that if somebody sends
> you a .config with e.g. ARM64_LSE_ATOMICS=y and you try to build a kernel
> using that .config and an old toolchain, the option is silently dropped.

I see... at least we have some tools like ./scripts/diffconfig

> 
> I think the diagnostic is actually useful in this case.

Fully agree on diagnostic side, any suggestions how it can be improved?

Cheers
Vladimir

> 
> Will
> 

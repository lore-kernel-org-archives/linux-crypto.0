From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/7] arm64: move literal data into .rodata section
Date: Thu, 18 Jan 2018 11:46:07 +0000
Message-ID: <CAKv+Gu_oh7q81mr=XPW+HM9zewETtbL=mnN0mkr83f5=n4zr6Q@mail.gmail.com>
References: <20180110121142.18291-1-ard.biesheuvel@linaro.org> <20180118114112.GA20091@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dann Frazier <dann.frazier@canonical.com>,
        Steve Capper <steve.capper@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34052 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754931AbeARLqI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 06:46:08 -0500
Received: by mail-io0-f172.google.com with SMTP id c17so24552230iod.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2018 03:46:08 -0800 (PST)
In-Reply-To: <20180118114112.GA20091@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 January 2018 at 11:41, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Jan 10, 2018 at 12:11:35PM +0000, Ard Biesheuvel wrote:
>> Prevent inadvertently creating speculative gadgets by moving literal data
>> into the .rodata section.
>>
>> Patch #1 enables this for C code, by reverting a change that disables the
>> GCC feature implementing this. Note that this conflicts with the mitigation
>> of erratum #843419 for Cortex-A53.
>
> Ard, which tree is this supposed to go through?
>

Hi Herbert,

I am going to drop that first patch, the remaining 6 patches can go
through the crypto tree as they are independent.

Thanks,
Ard.

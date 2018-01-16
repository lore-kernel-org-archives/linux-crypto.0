From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFT PATCH] crypto: arm64 - implement SHA-512 using special instructions
Date: Tue, 16 Jan 2018 08:19:31 +0000
Message-ID: <CAKv+Gu8dQ83_fZ_MPitKefaMxYn51T9XVUDxgjRQEgmZDQCMqA@mail.gmail.com>
References: <20180109182302.11521-1-ard.biesheuvel@linaro.org> <20180116081617.cq5iok2os6ylgjkc@capper-debian.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Steve Capper <steve.capper@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, "nd@arm.com@arm.com" <nd@arm.com>
To: Steve Capper <steve.capper@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:39945 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbeAPITc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jan 2018 03:19:32 -0500
Received: by mail-it0-f68.google.com with SMTP id 196so3854570iti.5
        for <linux-crypto@vger.kernel.org>; Tue, 16 Jan 2018 00:19:32 -0800 (PST)
In-Reply-To: <20180116081617.cq5iok2os6ylgjkc@capper-debian.cambridge.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 16 January 2018 at 08:16, Steve Capper <steve.capper@arm.com> wrote:
> On Tue, Jan 09, 2018 at 06:23:02PM +0000, Ard Biesheuvel wrote:
>> Implement the SHA-512 using the new special instructions that have
>> been introduced as an optional extension in ARMv8.2.
>
> Hi Ard,
> I have tested this applied on top of 4.15-rc7 running in a model.
>
> For sha512-ce, I verified that tcrypt successfully passed tests for modes:
> 12, 104, 189, 190, 306, 406 and 424.
> (and I double checked that sha512-ce was being used).
>
> Similarly for sha384-ce, I tested the following modes:
> 11, 103, 187, 188, 305 and 405.
>
> Also, I had:
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n
>
> So FWIW, please feel free to add:
> Tested-by: Steve Capper <steve.capper@arm.com>
>

Excellent! Thanks a lot Steve.

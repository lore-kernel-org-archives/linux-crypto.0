From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 0/3] sha3 fixes and new implementation for arm64
Date: Thu, 18 Jan 2018 13:43:59 +0000
Message-ID: <CAKv+Gu8-CGFukD-At57=3EAt+YGB--m9KfrVQ+GwwnYgB9gnGw@mail.gmail.com>
References: <20180114164118.18330-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@linaro.org>, jgarzik@redhat.com,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34116 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756197AbeARNoA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 08:44:00 -0500
Received: by mail-it0-f67.google.com with SMTP id m11so1942095iti.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2018 05:44:00 -0800 (PST)
In-Reply-To: <20180114164118.18330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 14 January 2018 at 16:41, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Add an implementation of SHA3 to arm64 using the new special instructions,
> and another one using scalar instructions but coded in assembler (#2)
>
> In preparation of that, fix a bug in the SHA3 (#1) and add some new test
> vectors to get better test coverage (#3).
>
> v2: Drop generic SHA3 as a fallback for the arm64 module. Instead, provide
>     a special arm64 version to use as a fallback when the instructions are
>     not available or when executing in a context that does not allow SIMD
>
>     Drop patches that simplify the generic SHA3 and make it reusable by
>     other modules.
>
> Ard Biesheuvel (3):
>   crypto/generic: sha3 - fixes for alignment and big endian operation
>   crypto/arm64: sha3 - new scalar + v8.2 Crypto Extensions
>     implementation
>   crypto/testmgr: sha3 - add new testcases
>
>  arch/arm64/crypto/Kconfig           |   4 +
>  arch/arm64/crypto/Makefile          |   3 +
>  arch/arm64/crypto/sha3-arm64-core.S | 512 ++++++++++++++++++
>  arch/arm64/crypto/sha3-arm64-glue.c | 192 +++++++
>  crypto/sha3_generic.c               |   5 +-
>  crypto/testmgr.h                    | 550 ++++++++++++++++++++
>  6 files changed, 1264 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm64/crypto/sha3-arm64-core.S
>  create mode 100644 arch/arm64/crypto/sha3-arm64-glue.c
>

Herbert,

Could you hold off on the SHA-3 patches for a little while? With the
performance fix for the generic code, it may no longer be worthwhile
to have a special arm64 implementation as well. I will respin a series
containing everything I think is needed.

The SM3 patch is independent, and is good to go IMO (with Steve's Tested-by)

Thanks,
Ard.

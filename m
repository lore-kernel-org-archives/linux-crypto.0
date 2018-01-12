From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/5] sha3 fixes and new implementation for arm64
Date: Fri, 12 Jan 2018 15:13:56 +0000
Message-ID: <CAKv+Gu9QYve=Tq+mBsmtSgbSi9n8Fsbdh2kiZCG-yM6GZ7+2gg@mail.gmail.com>
References: <20180112131522.25663-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@linaro.org>, jgarzik@redhat.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:40710 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933866AbeALPN5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 10:13:57 -0500
Received: by mail-it0-f68.google.com with SMTP id f190so9597214ita.5
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jan 2018 07:13:57 -0800 (PST)
In-Reply-To: <20180112131522.25663-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12 January 2018 at 13:15, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Add an implementation of SHA3 to arm64 using the new special instructions (#4)
>
> In preparation of that, fix a bug in the SHA3 and refactor it a bit so it
> can serve as a fallback for the other code. Also, add some new test vectors
> to get better test coverage.
>
> Ard Biesheuvel (5):
>   crypto/generic: sha3 - fixes for alignment and big endian operation
>   crypto/generic: sha3 - simplify code
>   crypto/generic: sha3 - export init/update/final routines
>   crypto/arm64: sha3 - new implementation based on special instructions

Forgot to mention: this is an RFT for patch #4, as it has not been
validated against a real implementation, only against my own QEMU
code.

>   crypto/testmgr: sha3 - add new testcases
>
>  arch/arm64/crypto/Kconfig        |   6 +
>  arch/arm64/crypto/Makefile       |   3 +
>  arch/arm64/crypto/sha3-ce-core.S | 224 ++++++++
>  arch/arm64/crypto/sha3-ce-glue.c | 156 ++++++
>  crypto/sha3_generic.c            | 198 +++----
>  crypto/testmgr.h                 | 550 ++++++++++++++++++++
>  include/crypto/sha3.h            |   6 +-
>  7 files changed, 1012 insertions(+), 131 deletions(-)
>  create mode 100644 arch/arm64/crypto/sha3-ce-core.S
>  create mode 100644 arch/arm64/crypto/sha3-ce-glue.c
>
> --
> 2.11.0
>

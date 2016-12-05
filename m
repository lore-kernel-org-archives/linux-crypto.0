From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 0/6] crypto: ARM/arm64 CRC-T10DIF/CRC32/CRC32C roundup
Date: Mon, 5 Dec 2016 09:20:34 +0000
Message-ID: <CAKv+Gu-k8exM5WuYHZrePUFX_5umUNc1GEZ7y=Gp2MgLJR_8EQ@mail.gmail.com>
References: <1480852447-25082-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36387 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752529AbcLEJ3C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Dec 2016 04:29:02 -0500
Received: by mail-io0-f169.google.com with SMTP id m5so448530745ioe.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 Dec 2016 01:29:02 -0800 (PST)
In-Reply-To: <1480852447-25082-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4 December 2016 at 11:54, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> This v2 combines the CRC-T10DIF and CRC32 implementations for both ARM and
> arm64 that I sent out a couple of weeks ago, and adds support to the latter
> for CRC32C.
>

Please don't apply yet. There is an issue in the 32-bit ARM code I
only spotted just now.


> Ard Biesheuvel (6):
>   crypto: testmgr - avoid overlap in chunked tests
>   crypto: testmgr - add/enhance test cases for CRC-T10DIF
>   crypto: arm64/crct10dif - port x86 SSE implementation to arm64
>   crypto: arm/crct10dif - port x86 SSE implementation to ARM
>   crypto: arm64/crc32 - accelerated support based on x86 SSE
>     implementation
>   crypto: arm/crc32 - accelerated support based on x86 SSE
>     implementation
>
>  arch/arm/crypto/Kconfig               |  10 +
>  arch/arm/crypto/Makefile              |   4 +
>  arch/arm/crypto/crc32-ce-core.S       | 306 +++++++++++++++++
>  arch/arm/crypto/crc32-ce-glue.c       | 195 +++++++++++
>  arch/arm/crypto/crct10dif-ce-core.S   | 349 ++++++++++++++++++++
>  arch/arm/crypto/crct10dif-ce-glue.c   |  95 ++++++
>  arch/arm64/crypto/Kconfig             |  11 +
>  arch/arm64/crypto/Makefile            |   6 +
>  arch/arm64/crypto/crc32-ce-core.S     | 266 +++++++++++++++
>  arch/arm64/crypto/crc32-ce-glue.c     | 188 +++++++++++
>  arch/arm64/crypto/crct10dif-ce-core.S | 317 ++++++++++++++++++
>  arch/arm64/crypto/crct10dif-ce-glue.c |  91 +++++
>  crypto/testmgr.c                      |   2 +-
>  crypto/testmgr.h                      |  70 ++--
>  14 files changed, 1881 insertions(+), 29 deletions(-)
>  create mode 100644 arch/arm/crypto/crc32-ce-core.S
>  create mode 100644 arch/arm/crypto/crc32-ce-glue.c
>  create mode 100644 arch/arm/crypto/crct10dif-ce-core.S
>  create mode 100644 arch/arm/crypto/crct10dif-ce-glue.c
>  create mode 100644 arch/arm64/crypto/crc32-ce-core.S
>  create mode 100644 arch/arm64/crypto/crc32-ce-glue.c
>  create mode 100644 arch/arm64/crypto/crct10dif-ce-core.S
>  create mode 100644 arch/arm64/crypto/crct10dif-ce-glue.c
>
> --
> 2.7.4
>

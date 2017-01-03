From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/6] crypto: ARM/arm64 - AES and ChaCha20 updates for v4.11
Date: Tue, 3 Jan 2017 20:01:24 +0000
Message-ID: <CAKv+Gu8wWW-c6dYcsRtD8LK4nrP=6pQwb63OkJTyGTYhK3Ryyw@mail.gmail.com>
References: <1483381268-12987-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36391 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752574AbdACUBZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2017 15:01:25 -0500
Received: by mail-io0-f174.google.com with SMTP id h133so201842715ioe.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2017 12:01:25 -0800 (PST)
In-Reply-To: <1483381268-12987-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2 January 2017 at 18:21, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> This series adds SIMD implementations for arm64 and ARM of ChaCha20 (*),
> and a port of the ARM bit-sliced AES algorithm to arm64, and
>
> Patch #1 is a prerequisite for the AES-XTS implementation in #6, which needs
> a secondary AES transform to generate the initial tweak.
>

Herbert,

I actually have a scalar AES implementation for arm64 which I could
use instead, making this patch unnecessary.

I could respin the entire series, or you could simply disregard #1 and
#6 for now, whichever you prefer.

Thanks,
Ard.


> Patch #2 optimizes the bit-sliced AES glue code for ARM to iterate over the
> input in the most efficient manner possible.
>
> Patch #3 adds a NEON implementation of ChaCha20 for ARM.
>
> Patch #4 adds a NEON implementation of ChaCha20 for arm64.
>
> Patch #5 modifies the existing NEON and ARMv8 Crypto Extensions implementations
> of AES-CTR to be available as a synchronous skcipher as well. This is intended
> for the mac80211 code, which uses synchronous encapsulations of ctr(aes)
> [ccm, gcm] in softirq context, which supports SIMD algorithms on arm64.
>
> Patch #6 adds a port of the ARM bit-sliced AES code to arm64, in ECB, CTR
> and XTS modes.
>
> Ard Biesheuvel (6):
>   crypto: generic/aes - export encrypt and decrypt entry points
>   crypto: arm/aes-neonbs - process 8 blocks in parallel if we can
>   crypto: arm/chacha20 - implement NEON version based on SSE3 code
>   crypto: arm64/chacha20 - implement NEON version based on SSE3 code
>   crypto: arm64/aes-blk - expose AES-CTR as synchronous cipher as well
>   crypto: arm64/aes - reimplement bit-sliced ARM/NEON implementation for
>     arm64
>
>  arch/arm/crypto/Kconfig                |   6 +
>  arch/arm/crypto/Makefile               |   2 +
>  arch/arm/crypto/aesbs-glue.c           |  67 +-
>  arch/arm/crypto/chacha20-neon-core.S   | 524 ++++++++++++
>  arch/arm/crypto/chacha20-neon-glue.c   | 128 +++
>  arch/arm64/crypto/Kconfig              |  13 +
>  arch/arm64/crypto/Makefile             |   6 +
>  arch/arm64/crypto/aes-glue.c           |  25 +-
>  arch/arm64/crypto/aes-neonbs-core.S    | 879 ++++++++++++++++++++
>  arch/arm64/crypto/aes-neonbs-glue.c    | 344 ++++++++
>  arch/arm64/crypto/chacha20-neon-core.S | 450 ++++++++++
>  arch/arm64/crypto/chacha20-neon-glue.c | 127 +++
>  crypto/aes_generic.c                   |  10 +-
>  include/crypto/aes.h                   |   3 +
>  14 files changed, 2549 insertions(+), 35 deletions(-)
>  create mode 100644 arch/arm/crypto/chacha20-neon-core.S
>  create mode 100644 arch/arm/crypto/chacha20-neon-glue.c
>  create mode 100644 arch/arm64/crypto/aes-neonbs-core.S
>  create mode 100644 arch/arm64/crypto/aes-neonbs-glue.c
>  create mode 100644 arch/arm64/crypto/chacha20-neon-core.S
>  create mode 100644 arch/arm64/crypto/chacha20-neon-glue.c
>
> --
> 2.7.4
>

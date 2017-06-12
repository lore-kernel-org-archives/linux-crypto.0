From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 00/12] arm64: crypto: prepare for new kernel mode NEON policy
Date: Mon, 12 Jun 2017 16:31:24 +0200
Message-ID: <CAKv+Gu8YG1zYSZ9wAG7AYFTgANB6z68=n26s2tUW9uLG__MXmw@mail.gmail.com>
References: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35472 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752212AbdFLOb0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jun 2017 10:31:26 -0400
Received: by mail-it0-f43.google.com with SMTP id m62so24138990itc.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jun 2017 07:31:25 -0700 (PDT)
In-Reply-To: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10 June 2017 at 18:22, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> TL;DR: preparatory work for expected changes in arm64's handling of kernel
>        mode SIMD
>
> @Herbert: The arm64 maintainers may want to take this through the arm64 tree,
>           and if not, we need their acks on patch #1. Thanks.
>

Please disregard this for merging for now. I am looking into whether
it is possible to use time invariant fallbacks instead for the AES
routines (and I missed a couple of AES MAC routines in the conversion)

> Currently, arm64 allows kernel mode NEON (KMN) in process, softirq or hardirq
> context. In the process case, we preserve/restore the NEON context lazily,
> but in the softirq/hardirq cases, we eagerly stash a slice of the NEON
> register file, and immediately restore it when kernel_neon_end() is called.
>
> Given the above, arm64 actually does not use the generic may_use_simd() API
> at all*, which was added to allow async wrappers of synchronous SIMD routines
> to be implemented in a generic manner. (On x86, kernel mode SIMD may be used
> in process context or while serving an interrupt taken from user space. On ARM,
> SIMD may only be used in process context)
>
> When adding support for the SVE architecture extension, which shared part of
> the NEON register file with the SIMD and crypto extensions, the eager preserve/
> restore in interrupt context is becoming a problem: it should either preserve
> and restore the entire SVE state (which may be up to 8 KB in size), or it
> should not be allowed to interrupt the lazy preserve, which does need to deal
> with the large SVE state anyway. Otherwise, such an interruption would corrupt
> the NEON state the lazy preserve sees after the interruption.
>
> Given how
> a) KMN is never actually used in hardirq context,
> b) KMN is only used in softirq context by mac80211 code running on behalf of
>    WiFi devices that don't perform the crypto in hardware,
> b) KMN in softirq context is statistically unlikely to interrupt the kernel
>    while it is doing kernel mode NEON in process context,
>
> the unconditional eager preserve/restore typically executes when no KMN in
> process context is in progress, and we can simplify things substantially by
> disallowing nested KMN, i.e., disallow KMN in hardirq context, and allow KMN
> in softirq only if no KMN in process context is already in progress.
>
> The no-nesting rule leaves only the outer SVE-aware lazy preserve/restore,
> which needs to execute with bottom halves disabled, but other than that, no
> intrusive changes should be needed to deal with the SVE payloads.
>
> Given that the no-nesting rule implies that SIMD is no longer allowed in any
> context, the KMN users need to be made aware of this. This series updates the
> current KMN users in the arm64 tree to take may_use_simd() into account. Since
> at this time, SIMD is still allowed in any context, an implementation of
> may_use_simd() is added that simply returns true (#1). It will be updated in
> the future when the no-nesting modifications are made.
>
> * may_use_simd() is only used as a hint in the SHA256 NEON code, since on some
>   microarchitectures, it is only marginally faster, and the eager preserve and
>   restore could actually make it slower.
>
> Ard Biesheuvel (12):
>   arm64: neon: replace generic definition of may_use_simd()
>   crypto: arm64/ghash-ce - add non-SIMD scalar fallback
>   crypto: arm64/crct10dif - add non-SIMD generic fallback
>   crypto: arm64/crc32 - add non-SIMD scalar fallback
>   crypto: arm64/sha1-ce - add non-SIMD generic fallback
>   crypto: arm64/sha2-ce - add non-SIMD scalar fallback
>   crypto: arm64/aes-ce-cipher - match round key endianness with generic
>     code
>   crypto: arm64/aes-ce-cipher: add non-SIMD generic fallback
>   crypto: arm64/aes-ce-ccm: add non-SIMD generic fallback
>   crypto: arm64/aes-blk - add a non-SIMD fallback for synchronous CTR
>   crypto: arm64/chacha20 - take may_use_simd() into account
>   crypto: arm64/aes-bs - implement non-SIMD fallback for AES-CTR
>
>  arch/arm64/crypto/Kconfig              |  22 ++-
>  arch/arm64/crypto/aes-ce-ccm-core.S    |  30 ++--
>  arch/arm64/crypto/aes-ce-ccm-glue.c    | 152 +++++++++++++++-----
>  arch/arm64/crypto/aes-ce-cipher.c      |  55 ++++---
>  arch/arm64/crypto/aes-ce.S             |  12 +-
>  arch/arm64/crypto/aes-ctr-fallback.h   |  55 +++++++
>  arch/arm64/crypto/aes-glue.c           |  17 ++-
>  arch/arm64/crypto/aes-neonbs-glue.c    |  48 ++++++-
>  arch/arm64/crypto/chacha20-neon-glue.c |   5 +-
>  arch/arm64/crypto/crc32-ce-glue.c      |  11 +-
>  arch/arm64/crypto/crct10dif-ce-glue.c  |  13 +-
>  arch/arm64/crypto/ghash-ce-glue.c      |  49 +++++--
>  arch/arm64/crypto/sha1-ce-glue.c       |  18 ++-
>  arch/arm64/crypto/sha2-ce-glue.c       |  30 +++-
>  arch/arm64/crypto/sha256-glue.c        |   1 +
>  arch/arm64/include/asm/Kbuild          |   1 -
>  arch/arm64/include/asm/simd.h          |  24 ++++
>  17 files changed, 420 insertions(+), 123 deletions(-)
>  create mode 100644 arch/arm64/crypto/aes-ctr-fallback.h
>  create mode 100644 arch/arm64/include/asm/simd.h
>
> --
> 2.7.4
>

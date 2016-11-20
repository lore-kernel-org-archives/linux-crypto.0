From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v4] crypto: arm64/sha2: integrate OpenSSL implementations
 of SHA256/SHA512
Date: Sun, 20 Nov 2016 11:43:57 +0000
Message-ID: <CAKv+Gu9SG5s=zddQaw+444191JGqmXfCh+AKyv3nZNqggmh=Kw@mail.gmail.com>
References: <1479642121-17912-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andy Polyakov <appro@openssl.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:35261 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753423AbcKTLn7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Nov 2016 06:43:59 -0500
Received: by mail-it0-f41.google.com with SMTP id c20so69524224itb.0
        for <linux-crypto@vger.kernel.org>; Sun, 20 Nov 2016 03:43:58 -0800 (PST)
In-Reply-To: <1479642121-17912-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 20 November 2016 at 11:42, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> This integrates both the accelerated scalar and the NEON implementations
> of SHA-224/256 as well as SHA-384/512 from the OpenSSL project.
>
> Relative performance compared to the respective generic C versions:
>
>                  |  SHA256-scalar  | SHA256-NEON* |  SHA512  |
>      ------------+-----------------+--------------+----------+
>      Cortex-A53  |      1.63x      |     1.63x    |   2.34x  |
>      Cortex-A57  |      1.43x      |     1.59x    |   1.95x  |
>      Cortex-A73  |      1.26x      |     1.56x    |     ?    |
>
> The core crypto code was authored by Andy Polyakov of the OpenSSL
> project, in collaboration with whom the upstream code was adapted so
> that this module can be built from the same version of sha512-armv8.pl.
>
> The version in this patch was taken from OpenSSL commit 32bbb62ea634
> ("sha/asm/sha512-armv8.pl: fix big-endian support in __KERNEL__ case.")
>
> * The core SHA algorithm is fundamentally sequential, but there is a
>   secondary transformation involved, called the schedule update, which
>   can be performed independently. The NEON version of SHA-224/SHA-256
>   only implements this part of the algorithm using NEON instructions,
>   the sequential part is always done using scalar instructions.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---

Missing changelog:

v4: fixed the big-endian build; this required an upstream change (even
    though upstream was not actually broken, since it explicitly defines
    __ARMEB__ on AArch64 big-endian builds), so this patch is now based
    on a more recent upstream OpenSSL commit (the __ILP32__ #ifdefs are
    still present but never active)

v3: at Will's request, the generated assembly files are now included
    as .S_shipped files, for which generic build rules are defined
    already.

Note that sizeable patches like this one have caused issues in the past with
patchwork, so for Herbert's convenience, the patch can be pulled from
http://git.kernel.org/cgit/linux/kernel/git/ardb/linux.git, branch
arm64-sha256 (based on today's cryptodev)

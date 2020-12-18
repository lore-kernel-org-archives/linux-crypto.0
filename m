Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBF2C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 16:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F53823B75
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 16:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgLRQbc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 11:31:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbgLRQbc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 11:31:32 -0500
X-Gm-Message-State: AOAM530cWsZCWv3orX1Amq1I3Mx3EECxEQslgfVZSEVQLt2rJqx+ty4g
        t8hoghLyBib8y0BOzYtsyVRMZIAQNgTiGYfBhZE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608309051;
        bh=Qtlbub79eWyPb9JwaXzBthC9Q58WYy2vlqEJWss/9Zs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZdFkPqvN4e52t6MgrvoQOHg69Xtg9Gp5CGVPbiXxTXIUrLt7ErOz4MgG5c9xK8ls5
         UjKU2Wzq1mJLOxmjgOWKijcxQsjPQZl5HcJdAolJ5xAzVv3m1TAasn0NNh7XFGtnvh
         ofyztZF7Ssc1o9RiqG22045sFcrfyI/MBlNJ1irKO/1nEZPkCm/wp1UTYMJCoHeLoF
         aEICYsO5+oQg0lHwzdHWvdGBU4Gm92vAt9lhBrRuMMKYBo4MU5Mz3I2sFzBMPuUvuS
         hObDlF/6nwY68P8PNCDXf6ky9IoDfABFRmkHOJplbkI3yVcNYbG9euDdHchXUo6ED6
         R9LKpCusPEE+A==
X-Google-Smtp-Source: ABdhPJyM1FoU4CTrk+dNHMZsY5g9rWZoxs202q0s5hz7yW/GGuA3gRN/TwA6GNcPo00lnRwiTBH5L9mR1SD8gpBohBs=
X-Received: by 2002:a9d:12c:: with SMTP id 41mr3404124otu.77.1608309050629;
 Fri, 18 Dec 2020 08:30:50 -0800 (PST)
MIME-Version: 1.0
References: <20201217222138.170526-1-ebiggers@kernel.org>
In-Reply-To: <20201217222138.170526-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 18 Dec 2020 17:30:39 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEa5YaxdvgkYQEqOP8hpAs7mJsUhKoEpDHo7BRYKuqEkw@mail.gmail.com>
Message-ID: <CAMj1kXEa5YaxdvgkYQEqOP8hpAs7mJsUhKoEpDHo7BRYKuqEkw@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] crypto: arm32-optimized BLAKE2b and BLAKE2s
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 17 Dec 2020 at 23:24, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This patchset adds 32-bit ARM assembly language implementations of
> BLAKE2b and BLAKE2s.
>
> The BLAKE2b implementation is NEON-accelerated, while the BLAKE2s
> implementation uses scalar instructions since NEON doesn't work very
> well for it.  The BLAKE2b implementation is faster and is expected to be
> useful as a replacement for SHA-1 in dm-verity, while the BLAKE2s
> implementation would be useful for WireGuard which uses BLAKE2s.
>
> Both implementations are provided via the shash API, while BLAKE2s is
> also provided via the library API.
>
> While adding these, I also reworked the generic implementations of
> BLAKE2b and BLAKE2s to provide helper functions that make implementing
> other "shash" providers for these algorithms much easier.
>
> See the individual commits for full details, including benchmarks.
>
> This patchset was tested on a Raspberry Pi 2 (which uses a Cortex-A7
> processor) with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, plus other tests.
>
> This patchset applies to mainline commit 0c6c887835b5.
>
> Changed since v1:
>    - Added BLAKE2s implementation.
>    - Adjusted the BLAKE2b helper functions to be consistent with what I
>      decided to do for BLAKE2s.
>    - Fixed build error in blake2b-neon-core.S in some configurations.
>
> Eric Biggers (11):
>   crypto: blake2b - rename constants for consistency with blake2s
>   crypto: blake2b - define shash_alg structs using macros
>   crypto: blake2b - export helpers for optimized implementations
>   crypto: blake2b - update file comment
>   crypto: arm/blake2b - add NEON-accelerated BLAKE2b
>   crypto: blake2s - define shash_alg structs using macros
>   crypto: x86/blake2s - define shash_alg structs using macros
>   crypto: blake2s - remove unneeded includes
>   crypto: blake2s - share the "shash" API boilerplate code
>   crypto: arm/blake2s - add ARM scalar optimized BLAKE2s
>   wireguard: Kconfig: select CRYPTO_BLAKE2S_ARM
>

Very nice!

For the series,

Acked-by: Ard Biesheuvel <ardb@kernel.org>


>  arch/arm/crypto/Kconfig             |  20 ++
>  arch/arm/crypto/Makefile            |   4 +
>  arch/arm/crypto/blake2b-neon-core.S | 345 ++++++++++++++++++++++++++++
>  arch/arm/crypto/blake2b-neon-glue.c | 105 +++++++++
>  arch/arm/crypto/blake2s-core.S      | 272 ++++++++++++++++++++++
>  arch/arm/crypto/blake2s-glue.c      |  78 +++++++
>  arch/x86/crypto/blake2s-glue.c      | 150 +++---------
>  crypto/Kconfig                      |   5 +
>  crypto/Makefile                     |   1 +
>  crypto/blake2b_generic.c            | 200 +++++++---------
>  crypto/blake2s_generic.c            | 161 +++----------
>  crypto/blake2s_helpers.c            |  87 +++++++
>  drivers/net/Kconfig                 |   1 +
>  include/crypto/blake2b.h            |  27 +++
>  include/crypto/internal/blake2b.h   |  33 +++
>  include/crypto/internal/blake2s.h   |  17 ++
>  16 files changed, 1139 insertions(+), 367 deletions(-)
>  create mode 100644 arch/arm/crypto/blake2b-neon-core.S
>  create mode 100644 arch/arm/crypto/blake2b-neon-glue.c
>  create mode 100644 arch/arm/crypto/blake2s-core.S
>  create mode 100644 arch/arm/crypto/blake2s-glue.c
>  create mode 100644 crypto/blake2s_helpers.c
>  create mode 100644 include/crypto/blake2b.h
>  create mode 100644 include/crypto/internal/blake2b.h
>
>
> base-commit: 0c6c887835b59c10602add88057c9c06f265effe
> --
> 2.29.2
>

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CA2C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Apr 2022 15:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239479AbiDNPKq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Apr 2022 11:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351199AbiDNOao (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Apr 2022 10:30:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5083022BF2
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 07:19:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B5030CE29FD
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 14:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069ABC385A5
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649945951;
        bh=Q1WpI1P2qqbFgHB/7bjfsFc19FhHImxCTccviOynmi4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HmbY9jAHlchFisUj26Z0tCXjqt61T3Gpr+PXMA+xpI0rmrQwd1ao/bvGNhjCoqMTW
         2sqzE7MOH5eEIb3iL5wAB9Eno6w2B/V6ltpzT5eOqR2r/ZNys1xUFjd9zFfs9DB3uB
         qwodabxc5qmi4N8+TeZ2cN6cJxwPB+SWrYIryF7aksQYTBgCh60i+Ztz9MCDxNOg+Z
         6ex0tUh/KNKUySVoho+CFg8prxWhJyLIiuuBe8NQsT++SLQonGO94RZUf46+HpKooa
         b8ELBGH2UekSx62l61lC3y7eh20XsEzRTin8Fsh5KkUCTP7bj4bnBTZsHExtZwUL0D
         iqbhhwe4kJL9g==
Received: by mail-oi1-f172.google.com with SMTP id w127so5500645oig.10
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 07:19:10 -0700 (PDT)
X-Gm-Message-State: AOAM532T1PY55VOZSRhzMtiZMdnqA+c47SCzDiob6loWDG7LFAfrWQT9
        U6hUy/C83VaEpH7JKBHZs/NxC44k/JWk0AkMCsk=
X-Google-Smtp-Source: ABdhPJxlhB00QTSTNNT0SDfuEthV4YMzN9dPxF0NacMc2/92RTBmRucwb49MeiOYMA0UmyVcV3mUWnVZ0WKT+Ko2fT4=
X-Received: by 2002:a05:6808:1513:b0:2fa:7a40:c720 with SMTP id
 u19-20020a056808151300b002fa7a40c720mr1446182oiw.126.1649945950087; Thu, 14
 Apr 2022 07:19:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220412172816.917723-1-nhuck@google.com>
In-Reply-To: <20220412172816.917723-1-nhuck@google.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 14 Apr 2022 16:18:58 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEFOQWohWXQKdgDUoZU83S9TA1Tyr+4Rw9WEPFna3eLHw@mail.gmail.com>
Message-ID: <CAMj1kXEFOQWohWXQKdgDUoZU83S9TA1Tyr+4Rw9WEPFna3eLHw@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] crypto: HCTR2 support
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 12 Apr 2022 at 19:28, Nathan Huckleberry <nhuck@google.com> wrote:
>
> HCTR2 is a length-preserving encryption mode that is efficient on
> processors with instructions to accelerate AES and carryless
> multiplication, e.g. x86 processors with AES-NI and CLMUL, and ARM
> processors with the ARMv8 Crypto Extensions.
>
> HCTR2 is specified in https://ia.cr/2021/1441 "Length-preserving encrypti=
on
> with HCTR2" which shows that if AES is secure and HCTR2 is instantiated
> with AES, then HCTR2 is secure.  Reference code and test vectors are at
> https://github.com/google/hctr2.
>
> As a length-preserving encryption mode, HCTR2 is suitable for application=
s
> such as storage encryption where ciphertext expansion is not possible, an=
d
> thus authenticated encryption cannot be used.  Currently, such applicatio=
ns
> usually use XTS, or in some cases Adiantum.  XTS has the disadvantage tha=
t
> it is a narrow-block mode: a bitflip will only change 16 bytes in the
> resulting ciphertext or plaintext.  This reveals more information to an
> attacker than necessary.
>
> HCTR2 is a wide-block mode, so it provides a stronger security property: =
a
> bitflip will change the entire message.  HCTR2 is somewhat similar to
> Adiantum, which is also a wide-block mode.  However, HCTR2 is designed to
> take advantage of existing crypto instructions, while Adiantum targets
> devices without such hardware support.  Adiantum is also designed with
> longer messages in mind, while HCTR2 is designed to be efficient even on
> short messages.
>
> The first intended use of this mode in the kernel is for the encryption o=
f
> filenames, where for efficiency reasons encryption must be fully
> deterministic (only one ciphertext for each plaintext) and the existing C=
BC
> solution leaks more information than necessary for filenames with common
> prefixes.
>
> HCTR2 uses two passes of an =CE=B5-almost-=E2=88=86-universal hash functi=
on called
> POLYVAL and one pass of a block cipher mode called XCTR.  POLYVAL is a
> polynomial hash designed for efficiency on modern processors and was
> originally specified for use in AES-GCM-SIV (RFC 8452).  XCTR mode is a
> variant of CTR mode that is more efficient on little-endian machines.
>
> This patchset adds HCTR2 to Linux's crypto API, including generic
> implementations of XCTR and POLYVAL, hardware accelerated implementations
> of XCTR and POLYVAL for both x86-64 and ARM64, a templated implementation
> of HCTR2, and an fscrypt policy for using HCTR2 for filename encryption.
>
> Changes in v4:
>  * Small style fixes in generic POLYVAL and XCTR
>  * Move HCTR2 hash exporting/importing to helper functions
>  * Rewrite montgomery reduction for x86-64 POLYVAL
>  * Rewrite partial block handling for x86-64 POLYVAL
>  * Optimize x86-64 POLYVAL loop handling
>  * Remove ahash wrapper from x86-64 POLYVAL
>  * Add simd-unavailable handling to x86-64 POLYVAL
>  * Rewrite montgomery reduction for ARM64 POLYVAL
>  * Rewrite partial block handling for ARM64 POLYVAL
>  * Optimize ARM64 POLYVAL loop handling
>  * Remove ahash wrapper from ARM64 POLYVAL
>  * Add simd-unavailable handling to ARM64 POLYVAL
>
> Changes in v3:
>  * Improve testvec coverage for XCTR, POLYVAL and HCTR2
>  * Fix endianness bug in xctr.c
>  * Fix alignment issues in polyval-generic.c
>  * Optimize hctr2.c by exporting/importing hash states
>  * Fix blockcipher name derivation in hctr2.c
>  * Move x86-64 XCTR implementation into aes_ctrby8_avx-x86_64.S
>  * Reuse ARM64 CTR mode tail handling in ARM64 XCTR
>  * Fix x86-64 POLYVAL comments
>  * Fix x86-64 POLYVAL key_powers type to match asm
>  * Fix ARM64 POLYVAL comments
>  * Fix ARM64 POLYVAL key_powers type to match asm
>  * Add XTS + HCTR2 policy to fscrypt
>
> Nathan Huckleberry (8):
>   crypto: xctr - Add XCTR support
>   crypto: polyval - Add POLYVAL support
>   crypto: hctr2 - Add HCTR2 support
>   crypto: x86/aesni-xctr: Add accelerated implementation of XCTR
>   crypto: arm64/aes-xctr: Add accelerated implementation of XCTR
>   crypto: x86/polyval: Add PCLMULQDQ accelerated implementation of
>     POLYVAL
>   crypto: arm64/polyval: Add PMULL accelerated implementation of POLYVAL
>   fscrypt: Add HCTR2 support for filename encryption
>

This is looking very good, thanks for your continued efforts on this.

Once Eric's feeback has been addressed, feel free to add

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

to the series.

>  Documentation/filesystems/fscrypt.rst   |   19 +-
>  arch/arm64/crypto/Kconfig               |   10 +-
>  arch/arm64/crypto/Makefile              |    3 +
>  arch/arm64/crypto/aes-glue.c            |   65 +-
>  arch/arm64/crypto/aes-modes.S           |  134 ++
>  arch/arm64/crypto/polyval-ce-core.S     |  366 ++++++
>  arch/arm64/crypto/polyval-ce-glue.c     |  240 ++++
>  arch/x86/crypto/Makefile                |    3 +
>  arch/x86/crypto/aes_ctrby8_avx-x86_64.S |  233 ++--
>  arch/x86/crypto/aesni-intel_asm.S       |   70 ++
>  arch/x86/crypto/aesni-intel_glue.c      |   89 ++
>  arch/x86/crypto/polyval-clmulni_asm.S   |  333 +++++
>  arch/x86/crypto/polyval-clmulni_glue.c  |  234 ++++
>  crypto/Kconfig                          |   40 +-
>  crypto/Makefile                         |    3 +
>  crypto/hctr2.c                          |  616 +++++++++
>  crypto/polyval-generic.c                |  214 ++++
>  crypto/tcrypt.c                         |   10 +
>  crypto/testmgr.c                        |   20 +
>  crypto/testmgr.h                        | 1536 +++++++++++++++++++++++
>  crypto/xctr.c                           |  191 +++
>  fs/crypto/fscrypt_private.h             |    2 +-
>  fs/crypto/keysetup.c                    |    7 +
>  fs/crypto/policy.c                      |    4 +
>  include/crypto/polyval.h                |   17 +
>  include/uapi/linux/fscrypt.h            |    3 +-
>  tools/include/uapi/linux/fscrypt.h      |    3 +-
>  27 files changed, 4376 insertions(+), 89 deletions(-)
>  create mode 100644 arch/arm64/crypto/polyval-ce-core.S
>  create mode 100644 arch/arm64/crypto/polyval-ce-glue.c
>  create mode 100644 arch/x86/crypto/polyval-clmulni_asm.S
>  create mode 100644 arch/x86/crypto/polyval-clmulni_glue.c
>  create mode 100644 crypto/hctr2.c
>  create mode 100644 crypto/polyval-generic.c
>  create mode 100644 crypto/xctr.c
>  create mode 100644 include/crypto/polyval.h
>
> --
> 2.35.1.1178.g4f1659d476-goog
>

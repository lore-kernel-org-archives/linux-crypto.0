Return-Path: <SRS0=UDVD=U6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58196C0650E
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jul 2019 11:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C83120881
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jul 2019 11:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfGALs5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jul 2019 07:48:57 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38022 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfGALs4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jul 2019 07:48:56 -0400
Received: by mail-ot1-f66.google.com with SMTP id d17so13186297oth.5
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jul 2019 04:48:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L7nv+0k5jPCe+/Br+DX4QwoajWjH5c2OanrJcWRtVVA=;
        b=KgKoZLeN6ECKyawC7ZAmT9n2hv+4Tg7wru/5LiqMghU1QvNLSitK/gCnz4E2rhwfbc
         IMr9OEf8WQiBeoeagCiF11i9ukNdKvurqtSGMUKpUhOgojOumFn2plpk4biyb0iAS7Ay
         vCMaVfYyAipK9COdNVa9IHbvvAu2PbxP1UF9vAjbCNQPqD3wEQbWvEym7+DHFu3Nk0IO
         uK2JK+mu3qO7+4kxjjyp5s1uIq2Z5u6IoK2BzNFPzw7nYer6CabrI8+EaMVYPUAIgA2e
         urLTo8WpeqWrlvZLao1204SLIw5tZj15/SgsOAIZp0KVWSnmCUT/MiUTR36L+P4k/l77
         075g==
X-Gm-Message-State: APjAAAVnlb1gT80H/fq+rmh1wjZSByuWEWc4lXODd4mijIBSGn+mYdk8
        4ra/c+uFf65AhdHBC7Cm4DgZdwFVRKbxXJIb8hrtXg==
X-Google-Smtp-Source: APXvYqxzhKVMRuV0w+3NI63Z1U1/1Z9WsOVTxrHdBzYkZF1xET+VxRH4Zg+wZLH+YMB6ZybaG/xTU8++W62XmXYd4Qg=
X-Received: by 2002:a9d:4c17:: with SMTP id l23mr18600435otf.367.1561981735781;
 Mon, 01 Jul 2019 04:48:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190630165031.26365-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190630165031.26365-1-ard.biesheuvel@linaro.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 1 Jul 2019 13:48:44 +0200
Message-ID: <CAFqZXNtJga4efgo_2zRnWhaDwV=F-PBFbZE1epWoUTVVMCvPsw@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] crypto: CAESAR final portfolio follow-up
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jun 30, 2019 at 6:50 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> From: Ard Biesheuvel <ard.biesheuvel@arm.com>
>
> This v2/v3 is a follow-up to both 'crypto: aegis128 - add NEON intrinsics
> version for ARM/arm64' [0] and 'crypto: morus - remove generic and x86
> implementations' [1]. Since there is some overlap, it makes sense to merge
> them and avoid merge conflicts.
>
> Now that aegis128 has been announced as one of the winners of the CAESAR
> competition, it's time to provide some better support for it on arm64 (and
> 32-bit ARM *)
>
> This time, instead of cloning the generic driver twice and rewriting half
> of it in arm64 and ARM assembly, add hooks for an accelerated SIMD path to
> the generic driver, and populate it with a C version using NEON intrinsics
> that can be built for both ARM and arm64. This results in a speedup of ~11x,
> resulting in a performance of 2.2 cycles per byte on Cortex-A53.
>
> Patches #3 and #4 are fixes/improvements for the generic code. Patch #5
> adds the plumbing for using a SIMD accelerated implementation. Patch #6
> adds the ARM and arm64 code, and patch #7 adds a speed test.
>
> Since aegis128l and aegis256 were not selected, and nor where any of the
> morus contestants (which are in fact found to be cryptographically broken),
> patches #1 and #2 remove these entirely.
>
> Changes since v2:
> - drop AEGIS128L/256 Kconfig symbols from crypto/Kconfig
> - ensure that aese/aesmc are issued in pairs
>
> Changes since v1s:
> - add reference to research paper (#1)
> - drop hunks against m68k defconfigs - these get regenerated automatically
>   anyway, and so it is better to avoid the potential merge conflicts.
> - drop patch to use unaligned accessors where it isn't needed
> - drop hunks against aegis variants that are being removed (#3)
> - add acks from Ondrej
>
> * 32-bit ARM today rarely provides the special AES instruction that the
>   implementation in this series relies on, but this may change in the future,
>   and the NEON intrinsics code can be compiled for both ISAs.
>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Steve Capper <steve.capper@arm.com>
> Cc: Milan Broz <gmazyland@gmail.com>
>
> [0] https://lore.kernel.org/linux-crypto/20190624073818.29296-1-ard.biesheuvel@linaro.org/
> [1] https://lore.kernel.org/linux-crypto/20190625145254.28510-1-ard.biesheuvel@linaro.org/
>
> Ard Biesheuvel (7):
>   crypto: morus - remove generic and x86 implementations
>   crypto: aegis128l/aegis256 - remove x86 and generic implementations
>   crypto: aegis128 - drop empty TFM init/exit routines
>   crypto: aegis - avoid prerotated AES tables
>   crypto: aegis128 - add support for SIMD acceleration
>   crypto: aegis128 - provide a SIMD implementation based on NEON
>     intrinsics
>   crypto: tcrypt - add a speed test for AEGIS128

LGTM; for the series:

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

>
>  arch/x86/crypto/Makefile               |   17 -
>  arch/x86/crypto/aegis128l-aesni-asm.S  |  826 ------
>  arch/x86/crypto/aegis128l-aesni-glue.c |  297 ---
>  arch/x86/crypto/aegis256-aesni-asm.S   |  703 -----
>  arch/x86/crypto/aegis256-aesni-glue.c  |  297 ---
>  arch/x86/crypto/morus1280-avx2-asm.S   |  622 -----
>  arch/x86/crypto/morus1280-avx2-glue.c  |   66 -
>  arch/x86/crypto/morus1280-sse2-asm.S   |  896 -------
>  arch/x86/crypto/morus1280-sse2-glue.c  |   65 -
>  arch/x86/crypto/morus1280_glue.c       |  209 --
>  arch/x86/crypto/morus640-sse2-asm.S    |  615 -----
>  arch/x86/crypto/morus640-sse2-glue.c   |   65 -
>  arch/x86/crypto/morus640_glue.c        |  204 --
>  crypto/Kconfig                         |   89 +-
>  crypto/Makefile                        |   16 +-
>  crypto/aegis.h                         |   28 +-
>  crypto/{aegis128.c => aegis128-core.c} |   53 +-
>  crypto/aegis128-neon-inner.c           |  149 ++
>  crypto/aegis128-neon.c                 |   43 +
>  crypto/aegis128l.c                     |  522 ----
>  crypto/aegis256.c                      |  473 ----
>  crypto/morus1280.c                     |  542 ----
>  crypto/morus640.c                      |  533 ----
>  crypto/tcrypt.c                        |    7 +
>  crypto/testmgr.c                       |   24 -
>  crypto/testmgr.h                       | 2691 --------------------
>  include/crypto/morus1280_glue.h        |   97 -
>  include/crypto/morus640_glue.h         |   97 -
>  include/crypto/morus_common.h          |   18 -
>  29 files changed, 266 insertions(+), 9998 deletions(-)
>  delete mode 100644 arch/x86/crypto/aegis128l-aesni-asm.S
>  delete mode 100644 arch/x86/crypto/aegis128l-aesni-glue.c
>  delete mode 100644 arch/x86/crypto/aegis256-aesni-asm.S
>  delete mode 100644 arch/x86/crypto/aegis256-aesni-glue.c
>  delete mode 100644 arch/x86/crypto/morus1280-avx2-asm.S
>  delete mode 100644 arch/x86/crypto/morus1280-avx2-glue.c
>  delete mode 100644 arch/x86/crypto/morus1280-sse2-asm.S
>  delete mode 100644 arch/x86/crypto/morus1280-sse2-glue.c
>  delete mode 100644 arch/x86/crypto/morus1280_glue.c
>  delete mode 100644 arch/x86/crypto/morus640-sse2-asm.S
>  delete mode 100644 arch/x86/crypto/morus640-sse2-glue.c
>  delete mode 100644 arch/x86/crypto/morus640_glue.c
>  rename crypto/{aegis128.c => aegis128-core.c} (89%)
>  create mode 100644 crypto/aegis128-neon-inner.c
>  create mode 100644 crypto/aegis128-neon.c
>  delete mode 100644 crypto/aegis128l.c
>  delete mode 100644 crypto/aegis256.c
>  delete mode 100644 crypto/morus1280.c
>  delete mode 100644 crypto/morus640.c
>  delete mode 100644 include/crypto/morus1280_glue.h
>  delete mode 100644 include/crypto/morus640_glue.h
>  delete mode 100644 include/crypto/morus_common.h
>
> --
> 2.17.1
>


-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.

Return-Path: <SRS0=TLUI=DM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC7AC46466
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 18:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 842B020E65
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 18:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601924102;
	bh=o0uZ3cy1uUvq1q42gg9ToRESHRIfyYhiAJYGZGaJ4a8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=rRFmIjNNUextKNtBvR42odkevvt/5CKFg6lk1rJ1R0ewZYgHEnuCypD369Lk7ZHcC
	 gR3JG1bMzoEM1R0iAApeIhNmtKr7IeP0RgkkhvzdGxvn7q5mJaOZai2lVIeoDQa870
	 7D2aDBiG1Ij7aNAqxI4ByRxklMiu2rUovP8FK7yY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgJESy7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbgJESy7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 14:54:59 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE716212CC;
        Mon,  5 Oct 2020 18:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601924098;
        bh=o0uZ3cy1uUvq1q42gg9ToRESHRIfyYhiAJYGZGaJ4a8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hb5erTv+Q7MnF65HqGf1maRgYcNOD6J+hfcjTDjozf7VWCe1xd0jt1IMK5L7d/cbf
         50e8UZA36NsTwi/ttQiYpN86dkwSLIeMlj5DZDhkofXY+YJCypXY4p2y6EToegV4HD
         S4seMCR6Hf1wVrLgwigsfHUTg6jENETvOs+CBaAM=
Received: by mail-oi1-f178.google.com with SMTP id x69so9739526oia.8;
        Mon, 05 Oct 2020 11:54:58 -0700 (PDT)
X-Gm-Message-State: AOAM5330Fwn8f4Z1VsTtfHzhoyX0zJ1jKB8yIZjB9/Q0mk8fAR3+TAC/
        6WyJrzy896E35gVGhu8VZ2Hil0t+rzbSnfpQSbA=
X-Google-Smtp-Source: ABdhPJxUf3YRHsN+3zOiuiFukAzNhJRe7DJu0hkIA4QXQZBgRak9hZTbV+MiN9GSPyztKl9WTMrWdlz4zGFc9skvM6I=
X-Received: by 2002:aca:d845:: with SMTP id p66mr438708oig.47.1601924097988;
 Mon, 05 Oct 2020 11:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <20201005181804.1331237-1-jeremy.linton@arm.com>
In-Reply-To: <20201005181804.1331237-1-jeremy.linton@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 5 Oct 2020 20:54:46 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEkrRvp5Xd_+D_V7Nr1uiKnfAEdZU4kciC5R7_H8aRNZA@mail.gmail.com>
Message-ID: <CAMj1kXEkrRvp5Xd_+D_V7Nr1uiKnfAEdZU4kciC5R7_H8aRNZA@mail.gmail.com>
Subject: Re: [BUG][PATCH] arm64: bti: fix BTI to handle local indirect branches
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 5 Oct 2020 at 20:18, Jeremy Linton <jeremy.linton@arm.com> wrote:
>
> The AES code uses a 'br x7' as part of a function called by
> a macro, that ends up needing a BTI_J as a target.

Could we instead just drop the tail call, i.e, replace it with a ret
and do a 'bl' after it returns? The indirect call does not really
serve a purpose here anyway


> Lets
> define SYN_CODE_START_LOCAL() for this and replace the
> SYM_FUNC_START_LOCAL with a SYM_FUNC_CODE_LOCAL in the AES block.
>
> Without this kernels compiled with the aes_neon_bs will OOPS
> at boot.
>
>   Bad mode in Synchronous Abort handler detected on CPU1, code 0x34000003 -- BTI
>   CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch64 #1
>   pstate: 20400c05 (nzCv daif +PAN -UAO BTYPE=j-)
>   pc : aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
>   lr : aesbs_xts_encrypt+0x48/0xe0 [aes_neon_bs]
>   sp : ffff80001052b730
>   x29: ffff80001052b730 x28: 0000000000000001
>   x27: ffff0001ec8f4000 x26: ffff0001ec5d27b0
>   x25: ffff0001ec8f4000 x24: ffff80001052bc00
>   x23: 0000000000000018 x22: 000000000000000a
>   x21: ffff0001ec5d2100 x20: ffff0001ec8f4080
>   x19: ffff0001ec8f4000 x18: 0000000000000004
>   x17: 0000000000000000 x16: ffffadb4db85d310
>   x15: 0000000000000200 x14: 0000000000000010
>   x13: 0000000000000200 x12: ffff0001ec5d2100
>   x11: 000000000000000a x10: 0000020000200000
>   x9 : ffffadb4db7e7488 x8 : 0000000000000000
>   x7 : ffffadb4614fb110 x6 : 0000000000000000
>   x5 : ffff80001052bc00 x4 : 0000000000000020
>   x3 : 000000000000000a x2 : ffff0001ec5d2100
>   x1 : ffff0001ec8f4000 x0 : ffff0001ec8f4000
>   Kernel panic - not syncing: bad mode
>   CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch64 #1
>   Call trace:
>    dump_backtrace+0x0/0x1c0
>    show_stack+0x24/0x30
>    dump_stack+0xc0/0x118
>    panic+0x144/0x358
>    arm64_serror_panic+0x0/0x98
>    el1_sync_handler+0x60/0x110
>    el1_sync+0xb4/0x180
>    aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
>    __xts_crypt+0xb0/0x2dc [aes_neon_bs]
>    xts_encrypt+0x28/0x3c [aes_neon_bs]
>   crypto_skcipher_encrypt+0x50/0x84
>   simd_skcipher_encrypt+0xc8/0xe0
>   crypto_skcipher_encrypt+0x50/0x84
>   test_skcipher_vec_cfg+0x224/0x5f0
>   test_skcipher+0xbc/0x120
>   alg_test_skcipher+0xa0/0x1b0
>   alg_test+0x3dc/0x47c
>   cryptomgr_test+0x38/0x60
>   kthread+0x11c/0x120
>   ret_from_fork+0x10/0x18
>  SMP: stopping secondary CPUs
>  Kernel Offset: 0x2db4cb7e0000 from 0xffff800010000000
>  PHYS_OFFSET: 0xffffcf2440000000
>  CPU features: 0x7e0152,20c02020
>  Memory Limit: none
>  ---[ end Kernel panic - not syncing: bad mode ]---
>
> Fixes: commit 0e89640b640d ("crypto: arm64 - Use modern annotations for assembly functions")
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> ---
>  arch/arm64/crypto/aes-neonbs-core.S | 8 ++++----
>  arch/arm64/include/asm/linkage.h    | 6 +++++-
>  2 files changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
> index b357164379f6..76de87ee80e1 100644
> --- a/arch/arm64/crypto/aes-neonbs-core.S
> +++ b/arch/arm64/crypto/aes-neonbs-core.S
> @@ -428,7 +428,7 @@ SYM_FUNC_START(aesbs_convert_key)
>  SYM_FUNC_END(aesbs_convert_key)
>
>         .align          4
> -SYM_FUNC_START_LOCAL(aesbs_encrypt8)
> +SYM_CODE_START_LOCAL(aesbs_encrypt8)
>         ldr             q9, [bskey], #16                // round 0 key
>         ldr             q8, M0SR
>         ldr             q24, SR
> @@ -488,10 +488,10 @@ SYM_FUNC_START_LOCAL(aesbs_encrypt8)
>         eor             v2.16b, v2.16b, v12.16b
>         eor             v5.16b, v5.16b, v12.16b
>         ret
> -SYM_FUNC_END(aesbs_encrypt8)
> +SYM_END(aesbs_encrypt8)
>
>         .align          4
> -SYM_FUNC_START_LOCAL(aesbs_decrypt8)
> +SYM_CODE_START_LOCAL(aesbs_decrypt8)
>         lsl             x9, rounds, #7
>         add             bskey, bskey, x9
>
> @@ -553,7 +553,7 @@ SYM_FUNC_START_LOCAL(aesbs_decrypt8)
>         eor             v3.16b, v3.16b, v12.16b
>         eor             v5.16b, v5.16b, v12.16b
>         ret
> -SYM_FUNC_END(aesbs_decrypt8)
> +SYM_END(aesbs_decrypt8)
>
>         /*
>          * aesbs_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
> diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
> index ba89a9af820a..92c81ae8ac1e 100644
> --- a/arch/arm64/include/asm/linkage.h
> +++ b/arch/arm64/include/asm/linkage.h
> @@ -11,7 +11,8 @@
>   * set the architecture version to v8.5 we use the hint instruction
>   * instead.
>   */
> -#define BTI_C hint 34 ;
> +#define BTI_C  hint 34 ;
> +#define BTI_JC hint 38 ;
>
>  /*
>   * When using in-kernel BTI we need to ensure that PCS-conformant assembly
> @@ -42,6 +43,9 @@
>         SYM_START(name, SYM_L_WEAK, SYM_A_NONE)         \
>         BTI_C
>
> +#define SYM_CODE_START_LOCAL(name)                     \
> +       SYM_START(name, SYM_L_LOCAL, SYM_A_ALIGN)       \
> +       BTI_JC
>  #endif
>
>  /*
> --
> 2.25.4
>

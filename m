Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B49C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 08:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E74B64DCC
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 08:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCJI4R (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Mar 2021 03:56:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230449AbhCJIzs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Mar 2021 03:55:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA48164FEF
        for <linux-crypto@vger.kernel.org>; Wed, 10 Mar 2021 08:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615366548;
        bh=RJ79dlbCddNgXQIMbC7ub+DVt/Zq8/cCY2nRvDu0Jkg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E74oHUI6Gb3oN8ZMPnZ3NGLaoHxkuvsVQ675eiBWs7HM+MV8lfjJ7UNW/ySmVLgfM
         PC6LDiUGLmbCr8vqMjps32OaKlVAuDKxu3X8cA/OIpOzqz8QlIStpntKaT1yHJuWfp
         pqJts3H9jA5L/PKofKQQu0Isp3JxS2KPexyvwPcL0vcc7NAQHBMM83VTcJrAAXqMPC
         7W5eA34Jwda8uudFPD9/EZdwjC4qexb7/YEEaRDQkW12FXATxYEZ1hdjEC0QuvAqvj
         1rlNxuOHRQhdIQlFbsw0+JgdISA7MhzShwfDB91bL9xB1mGfBeTVVzRyL1+rP/rMSw
         ybesommRljaag==
Received: by mail-oi1-f179.google.com with SMTP id x135so13814715oia.9
        for <linux-crypto@vger.kernel.org>; Wed, 10 Mar 2021 00:55:47 -0800 (PST)
X-Gm-Message-State: AOAM533nNZTSywJV3xj8bCtQgwch/HHsCNkPkvRESbU59UwNrKzAn1+E
        0ui6nKC9j6rm9ie/dssJR9bld8Y/wdPcOqhWaKw=
X-Google-Smtp-Source: ABdhPJy+gis3zrKPG4B3A9mY02x+xQxqPWuYuyX31/M9mW86MdLfT9sKWSgkn7rLFSaXM73Y/bSz2Boro1yhKDKKc6I=
X-Received: by 2002:aca:ab86:: with SMTP id u128mr1715405oie.47.1615366547207;
 Wed, 10 Mar 2021 00:55:47 -0800 (PST)
MIME-Version: 1.0
References: <20210310072726.288252-1-ebiggers@kernel.org>
In-Reply-To: <20210310072726.288252-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 10 Mar 2021 09:55:35 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF_9jdynzL3Dy=s4Bp21LoUMnqPi+hG1OnjJg7S6+uHpQ@mail.gmail.com>
Message-ID: <CAMj1kXF_9jdynzL3Dy=s4Bp21LoUMnqPi+hG1OnjJg7S6+uHpQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/blake2s - fix for big endian
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 10 Mar 2021 at 08:29, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The new ARM BLAKE2s code doesn't work correctly (fails the self-tests)
> in big endian kernel builds because it doesn't swap the endianness of
> the message words when loading them.  Fix this.
>
> Fixes: 5172d322d34c ("crypto: arm/blake2s - add ARM scalar optimized BLAKE2s")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm/crypto/blake2s-core.S | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/arch/arm/crypto/blake2s-core.S b/arch/arm/crypto/blake2s-core.S
> index bed897e9a181a..86345751bbf3a 100644
> --- a/arch/arm/crypto/blake2s-core.S
> +++ b/arch/arm/crypto/blake2s-core.S
> @@ -8,6 +8,7 @@
>   */
>
>  #include <linux/linkage.h>
> +#include <asm/assembler.h>
>
>         // Registers used to hold message words temporarily.  There aren't
>         // enough ARM registers to hold the whole message block, so we have to
> @@ -38,6 +39,23 @@
>  #endif
>  .endm
>
> +.macro _le32_bswap     a, tmp
> +#ifdef __ARMEB__
> +       rev_l           \a, \tmp
> +#endif
> +.endm
> +
> +.macro _le32_bswap_8x  a, b, c, d, e, f, g, h,  tmp
> +       _le32_bswap     \a, \tmp
> +       _le32_bswap     \b, \tmp
> +       _le32_bswap     \c, \tmp
> +       _le32_bswap     \d, \tmp
> +       _le32_bswap     \e, \tmp
> +       _le32_bswap     \f, \tmp
> +       _le32_bswap     \g, \tmp
> +       _le32_bswap     \h, \tmp
> +.endm
> +
>  // Execute a quarter-round of BLAKE2s by mixing two columns or two diagonals.
>  // (a0, b0, c0, d0) and (a1, b1, c1, d1) give the registers containing the two
>  // columns/diagonals.  s0-s1 are the word offsets to the message words the first
> @@ -180,8 +198,10 @@ ENTRY(blake2s_compress_arch)
>         tst             r1, #3
>         bne             .Lcopy_block_misaligned
>         ldmia           r1!, {r2-r9}
> +       _le32_bswap_8x  r2, r3, r4, r5, r6, r7, r8, r9,  r14
>         stmia           r12!, {r2-r9}
>         ldmia           r1!, {r2-r9}
> +       _le32_bswap_8x  r2, r3, r4, r5, r6, r7, r8, r9,  r14
>         stmia           r12, {r2-r9}
>  .Lcopy_block_done:
>         str             r1, [sp, #68]           // Update message pointer
> @@ -268,6 +288,7 @@ ENTRY(blake2s_compress_arch)
>  1:
>  #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>         ldr             r3, [r1], #4
> +       _le32_bswap     r3, r4
>  #else
>         ldrb            r3, [r1, #0]
>         ldrb            r4, [r1, #1]
> --
> 2.30.1
>

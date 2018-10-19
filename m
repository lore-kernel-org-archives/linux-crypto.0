Return-Path: <SRS0=GKHD=M7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EBCECDE3D
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Oct 2018 05:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 906BC20658
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Oct 2018 05:41:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="jxtxnnTj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 906BC20658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbeJSNqI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Oct 2018 09:46:08 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:51577 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbeJSNqI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Oct 2018 09:46:08 -0400
Received: by mail-it1-f193.google.com with SMTP id 74-v6so3100476itw.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Oct 2018 22:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=SWjMUMhSlfw/vzfR6YLGkz/PP59uVpXsVXbIb1urAcA=;
        b=jxtxnnTjKHVv2g/fLXwqE3mnC+J5QC13FrTlHuLKJlZC3tyReghhNaYcliPixRyMUJ
         P3ue2GxMWxFIRtW/5vF5Htoi/hhHQpjaixb+EV7eXD9ljD796Wphx14ALHM610d6R1iC
         3gnRFt8H1CqCRxQPG6Qxs5TuHtS9U4jhUKpF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=SWjMUMhSlfw/vzfR6YLGkz/PP59uVpXsVXbIb1urAcA=;
        b=jb++8JElOboWlwZ0SvLvVjPnM3a7UmtSKgxPmrGOA7teAxjlVUh8VLD6id70s94hxl
         DJsVdGZ4s2vNYyiJE9C80E8+KUrUllqrIheNPjtciOgIPOQJXj81KsWPBA5+2PAqUgkL
         yVkLaKAcOXFaY3t4d0Bd99ReOwT8E7vZgDmMOckdK6yjvX2FHwtlBsnB91kBFk2UCSC4
         skO4LjBABqQawf9jBqj+P+PN20as1uhkOXkq0hDVmePMAifn4X56j4LNWJexIL5Ochl1
         XoYQV9Anng8O/gT+3kxe0V3vS5xFc1q3LnZBJV1/tsC5zClT7Bpi5rBCERogvZIICJL8
         umUA==
X-Gm-Message-State: ABuFfojCE2TxfEehHxYC+ekgEpG2cVrpj1/PHM4EE7D4A4qhBJrvwpXz
        0vkCsUDGHKqCgszJuLQFbkiRA0a0rmeztTl35oi+W6YO
X-Google-Smtp-Source: ACcGV62ClHKwjE2gf5o7W6/65YM1Rgs+oMpUrKNgSb4kBOzxdOdj0aoU9/4OyYw8FNzm7Qz7WJDWH3mLIod5TdRKDeM=
X-Received: by 2002:a05:660c:383:: with SMTP id x3mr2048433itj.121.1539927696074;
 Thu, 18 Oct 2018 22:41:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Thu, 18 Oct 2018 22:41:35
 -0700 (PDT)
In-Reply-To: <20181018043759.7669-3-ebiggers@kernel.org>
References: <20181018043759.7669-1-ebiggers@kernel.org> <20181018043759.7669-3-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 19 Oct 2018 13:41:35 +0800
Message-ID:
 <CAKv+Gu9XJ0k82ZNPRirs3Qhda3375CUA8uhJmsK85=1a9VmaNQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] crypto: arm/aes - add some hardening against
 cache-timing attacks
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181019054135.4K386i9yq6rOgx0ET5q62Y9WJ_lQnqGEFt_6g-xaDpc@z>

On 18 October 2018 at 12:37, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Make the ARM scalar AES implementation closer to constant-time by
> disabling interrupts and prefetching the tables into L1 cache.  This is
> feasible because due to ARM's "free" rotations, the main tables are only
> 1024 bytes instead of the usual 4096 used by most AES implementations.
>
> On ARM Cortex-A7, the speed loss is only about 5%.  The resulting code
> is still over twice as fast as aes_ti.c.  Responsiveness is potentially
> a concern, but interrupts are only disabled for a single AES block.
>

So that would be in the order of 700 cycles, based on the numbers you
shared in v1 of the aes_ti.c patch. Does that sound about right? So
that would be around 1 microsecond, which is really not a number to
obsess about imo.

I considered another option, which is to detect whether an interrupt
has been taken (by writing some canary value below that stack pointer
in the location where the exception handler will preserve the value of
sp, and checking at the end whether it has been modified) and doing a
usleep_range(x, y) if that is the case.

But this is much simpler so let's only go there if we must.

> Note that even after these changes, the implementation still isn't
> necessarily guaranteed to be constant-time; see
> https://cr.yp.to/antiforgery/cachetiming-20050414.pdf for a discussion
> of the many difficulties involved in writing truly constant-time AES
> software.  But it's valuable to make such attacks more difficult.
>
> Much of this patch is based on patches suggested by Ard Biesheuvel.
>
> Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/Kconfig           |  9 +++++
>  arch/arm/crypto/aes-cipher-core.S | 62 ++++++++++++++++++++++++++-----
>  crypto/aes_generic.c              |  9 +++--
>  3 files changed, 66 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index ef0c7feea6e29..0473a8f683896 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -69,6 +69,15 @@ config CRYPTO_AES_ARM
>         help
>           Use optimized AES assembler routines for ARM platforms.
>
> +         On ARM processors without the Crypto Extensions, this is the
> +         fastest AES implementation for single blocks.  For multiple
> +         blocks, the NEON bit-sliced implementation is usually faster.
> +
> +         This implementation may be vulnerable to cache timing attacks,
> +         since it uses lookup tables.  However, as countermeasures it
> +         disables IRQs and preloads the tables; it is hoped this makes
> +         such attacks very difficult.
> +
>  config CRYPTO_AES_ARM_BS
>         tristate "Bit sliced AES using NEON instructions"
>         depends on KERNEL_MODE_NEON
> diff --git a/arch/arm/crypto/aes-cipher-core.S b/arch/arm/crypto/aes-cipher-core.S
> index 184d6c2d15d5e..f2d67c095e596 100644
> --- a/arch/arm/crypto/aes-cipher-core.S
> +++ b/arch/arm/crypto/aes-cipher-core.S
> @@ -10,6 +10,7 @@
>   */
>
>  #include <linux/linkage.h>
> +#include <asm/assembler.h>
>  #include <asm/cache.h>
>
>         .text
> @@ -41,7 +42,7 @@
>         .endif
>         .endm
>
> -       .macro          __hround, out0, out1, in0, in1, in2, in3, t3, t4, enc, sz, op
> +       .macro          __hround, out0, out1, in0, in1, in2, in3, t3, t4, enc, sz, op, oldcpsr
>         __select        \out0, \in0, 0
>         __select        t0, \in1, 1
>         __load          \out0, \out0, 0, \sz, \op
> @@ -73,6 +74,14 @@
>         __load          t0, t0, 3, \sz, \op
>         __load          \t4, \t4, 3, \sz, \op
>
> +       .ifnb           \oldcpsr
> +       /*
> +        * This is the final round and we're done with all data-dependent table
> +        * lookups, so we can safely re-enable interrupts.
> +        */
> +       restore_irqs    \oldcpsr
> +       .endif
> +
>         eor             \out1, \out1, t1, ror #24
>         eor             \out0, \out0, t2, ror #16
>         ldm             rk!, {t1, t2}
> @@ -83,14 +92,14 @@
>         eor             \out1, \out1, t2
>         .endm
>
> -       .macro          fround, out0, out1, out2, out3, in0, in1, in2, in3, sz=2, op
> +       .macro          fround, out0, out1, out2, out3, in0, in1, in2, in3, sz=2, op, oldcpsr
>         __hround        \out0, \out1, \in0, \in1, \in2, \in3, \out2, \out3, 1, \sz, \op
> -       __hround        \out2, \out3, \in2, \in3, \in0, \in1, \in1, \in2, 1, \sz, \op
> +       __hround        \out2, \out3, \in2, \in3, \in0, \in1, \in1, \in2, 1, \sz, \op, \oldcpsr
>         .endm
>
> -       .macro          iround, out0, out1, out2, out3, in0, in1, in2, in3, sz=2, op
> +       .macro          iround, out0, out1, out2, out3, in0, in1, in2, in3, sz=2, op, oldcpsr
>         __hround        \out0, \out1, \in0, \in3, \in2, \in1, \out2, \out3, 0, \sz, \op
> -       __hround        \out2, \out3, \in2, \in1, \in0, \in3, \in1, \in0, 0, \sz, \op
> +       __hround        \out2, \out3, \in2, \in1, \in0, \in3, \in1, \in0, 0, \sz, \op, \oldcpsr
>         .endm
>
>         .macro          __rev, out, in
> @@ -118,13 +127,14 @@
>         .macro          do_crypt, round, ttab, ltab, bsz
>         push            {r3-r11, lr}
>
> +       // Load keys first, to reduce latency in case they're not cached yet.
> +       ldm             rk!, {r8-r11}
> +
>         ldr             r4, [in]
>         ldr             r5, [in, #4]
>         ldr             r6, [in, #8]
>         ldr             r7, [in, #12]
>
> -       ldm             rk!, {r8-r11}
> -
>  #ifdef CONFIG_CPU_BIG_ENDIAN
>         __rev           r4, r4
>         __rev           r5, r5
> @@ -138,6 +148,25 @@
>         eor             r7, r7, r11
>
>         __adrl          ttab, \ttab
> +       /*
> +        * Disable interrupts and prefetch the 1024-byte 'ft' or 'it' table into
> +        * L1 cache, assuming cacheline size >= 32.  This is a hardening measure
> +        * intended to make cache-timing attacks more difficult.  They may not
> +        * be fully prevented, however; see the paper
> +        * https://cr.yp.to/antiforgery/cachetiming-20050414.pdf
> +        * ("Cache-timing attacks on AES") for a discussion of the many
> +        * difficulties involved in writing truly constant-time AES software.
> +        */
> +        save_and_disable_irqs  t0
> +       .set            i, 0
> +       .rept           1024 / 128
> +       ldr             r8, [ttab, #i + 0]
> +       ldr             r9, [ttab, #i + 32]
> +       ldr             r10, [ttab, #i + 64]
> +       ldr             r11, [ttab, #i + 96]
> +       .set            i, i + 128
> +       .endr
> +       push            {t0}            // oldcpsr
>
>         tst             rounds, #2
>         bne             1f
> @@ -151,8 +180,21 @@
>         \round          r4, r5, r6, r7, r8, r9, r10, r11
>         b               0b
>
> -2:     __adrl          ttab, \ltab
> -       \round          r4, r5, r6, r7, r8, r9, r10, r11, \bsz, b
> +2:     .ifb            \ltab
> +       add             ttab, ttab, #1
> +       .else
> +       __adrl          ttab, \ltab
> +       // Prefetch inverse S-box for final round; see explanation above
> +       .set            i, 0
> +       .rept           256 / 64
> +       ldr             t0, [ttab, #i + 0]
> +       ldr             t1, [ttab, #i + 32]
> +       .set            i, i + 64
> +       .endr
> +       .endif
> +
> +       pop             {rounds}        // oldcpsr
> +       \round          r4, r5, r6, r7, r8, r9, r10, r11, \bsz, b, rounds
>
>  #ifdef CONFIG_CPU_BIG_ENDIAN
>         __rev           r4, r4
> @@ -175,7 +217,7 @@
>         .endm
>
>  ENTRY(__aes_arm_encrypt)
> -       do_crypt        fround, crypto_ft_tab, crypto_ft_tab + 1, 2
> +       do_crypt        fround, crypto_ft_tab,, 2
>  ENDPROC(__aes_arm_encrypt)
>
>         .align          5
> diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
> index ca554d57d01e9..13df33aca4631 100644
> --- a/crypto/aes_generic.c
> +++ b/crypto/aes_generic.c
> @@ -63,7 +63,8 @@ static inline u8 byte(const u32 x, const unsigned n)
>
>  static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };
>
> -__visible const u32 crypto_ft_tab[4][256] = {
> +/* cacheline-aligned to facilitate prefetching into cache */
> +__visible const u32 crypto_ft_tab[4][256] __cacheline_aligned = {
>         {
>                 0xa56363c6, 0x847c7cf8, 0x997777ee, 0x8d7b7bf6,
>                 0x0df2f2ff, 0xbd6b6bd6, 0xb16f6fde, 0x54c5c591,
> @@ -327,7 +328,7 @@ __visible const u32 crypto_ft_tab[4][256] = {
>         }
>  };
>
> -__visible const u32 crypto_fl_tab[4][256] = {
> +__visible const u32 crypto_fl_tab[4][256] __cacheline_aligned = {
>         {
>                 0x00000063, 0x0000007c, 0x00000077, 0x0000007b,
>                 0x000000f2, 0x0000006b, 0x0000006f, 0x000000c5,
> @@ -591,7 +592,7 @@ __visible const u32 crypto_fl_tab[4][256] = {
>         }
>  };
>
> -__visible const u32 crypto_it_tab[4][256] = {
> +__visible const u32 crypto_it_tab[4][256] __cacheline_aligned = {
>         {
>                 0x50a7f451, 0x5365417e, 0xc3a4171a, 0x965e273a,
>                 0xcb6bab3b, 0xf1459d1f, 0xab58faac, 0x9303e34b,
> @@ -855,7 +856,7 @@ __visible const u32 crypto_it_tab[4][256] = {
>         }
>  };
>
> -__visible const u32 crypto_il_tab[4][256] = {
> +__visible const u32 crypto_il_tab[4][256] __cacheline_aligned = {
>         {
>                 0x00000052, 0x00000009, 0x0000006a, 0x000000d5,
>                 0x00000030, 0x00000036, 0x000000a5, 0x00000038,
> --
> 2.19.1
>

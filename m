Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44735C10DCE
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 19:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11FE020714
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 19:46:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vgXynoJT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgCWTqK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 15:46:10 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38282 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgCWTqK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 15:46:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id x7so7742376pgh.5
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2020 12:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TtqwWatKpD7SofVT0EoTqpDu0ZUD5i4Sz54oEJu3/Dw=;
        b=vgXynoJTySUcoHgVdDm+LazyPhMM1Y197xQjVT9YozDU8bvD3JlxvxI5QtTeUoOVmR
         PQ0ygD2K5NGp67x0Rc4Lyeb9ZhnN5yxMpTgnjXiRqoVLScrYlM+VDqc3WE9uQveI/1P8
         2znax2dxzmK1WFcFCb3ZvCGcY9chG6Xi5JyzXjHypU3WGqqp/J9WpSOmbxcYLBxsZJ8e
         FmRbscZdwxmnn1DfXwA6mTR5ywoEQwAacX608dJoUQKc7k/WBAbu/6b6EUd9pqt0iLjl
         i9sym3PfZv7MXeAKD/8/XGfqPg1atQkXVky/ji8FG2SkwmN+VBr6I7aJoqRXqB0mhvtM
         tj1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TtqwWatKpD7SofVT0EoTqpDu0ZUD5i4Sz54oEJu3/Dw=;
        b=KtWgVoBW0utiNOiYDG6dnxPPAGbAD5+3TEnXzMsTdXLPfL5qraCpFSIAnNE4jndNkn
         qoW0fwVf1HZ99TpSUt7NmR66u9jBnOQK2RudubL0xmzaHlECm6xQmzOKibre8Htel7pW
         ijvqWBBrctSoINZQSqMIegRH7xuwh5xe8drUIMFwOsQUBl0FlCRquYJmKvwMunGpKORJ
         N9Xiii8ZwCtx47RyFs0VbgTus1oilKmvaGZoUJDDWVaMV80LOpvNeQ0lJkj7p1fKci1e
         RUdCf6W8XmtYMMhCt/UhEF0oFV1J82IlEn/Szm1TXnukAhm49QMMuKhssM9dLK7sG1h8
         uDTw==
X-Gm-Message-State: ANhLgQ3jMBcWQYK5FTQ4DqS4ybbagkR6h5givNE7d7DJLmdp2ukB3u3R
        sRjbOFMA9upI1P97cXRUTAMp+eKDRzB5uNU6pWYSmA==
X-Google-Smtp-Source: ADFU+vshC7+kzkmu2zUDZAt4WA6bUsvpCEOCvNCXQOT/vtxbuGNUMhtlqdiIfBnsJCSlpdv8McZrNQlT5LxKHpC0owo=
X-Received: by 2002:a63:4453:: with SMTP id t19mr22402443pgk.381.1584992768425;
 Mon, 23 Mar 2020 12:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org>
In-Reply-To: <20200323020844.17064-1-masahiroy@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 23 Mar 2020 12:45:56 -0700
Message-ID: <CAKwvOdm1B=Wc6zcxpapcbeReX0_2V3AiqxGUgikL4ypztZkUEg@mail.gmail.com>
Subject: Re: [PATCH 0/7] x86: remove always-defined CONFIG_AS_* options
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Song Liu <songliubraving@fb.com>,
        Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 22, 2020 at 7:09 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> arch/x86/Makefile tests instruction code by $(call as-instr, ...)
>
> Some of them are very old.
> For example, the check for CONFIG_AS_CFI dates back to 2006.
>
> We raise GCC versions from time to time, and we clean old code away.
> The same policy applied to binutils.
>
> The current minimal supported version of binutils is 2.21
>
> This is new enough to recognize the instruction in most of
> as-instr calls.

I'm quite happy to see this series; a few weekends ago I was playing
around with adding dwarf-5 support to the Linux kernel, and was
looking at these noticing there was quite a bit of cruft.
Unfortunately, I got detoured filing bugs against GNU as for dwarf-5
bugs, but the developers were very responsive and fixed them all.  I
should go find and dust off that patchset.  In the meantime, I'll try
to help review these patches. Thank you for sending them.

>
>
>
> Masahiro Yamada (7):
>   x86: remove unneeded defined(__ASSEMBLY__) check from asm/dwarf2.h
>   x86: remove always-defined CONFIG_AS_CFI
>   x86: remove always-defined CONFIG_AS_CFI_SIGNAL_FRAME
>   x86: remove always-defined CONFIG_AS_CFI_SECTIONS
>   x86: remove always-defined CONFIG_AS_SSSE3
>   x86: remove always-defined CONFIG_AS_AVX
>   x86: add comments about the binutils version to support code in
>     as-instr
>
>  arch/x86/Makefile                             | 21 +++------
>  arch/x86/crypto/Makefile                      | 32 ++++++--------
>  arch/x86/crypto/aesni-intel_avx-x86_64.S      |  3 --
>  arch/x86/crypto/aesni-intel_glue.c            | 14 +-----
>  arch/x86/crypto/blake2s-core.S                |  2 -
>  arch/x86/crypto/poly1305-x86_64-cryptogams.pl |  8 ----
>  arch/x86/crypto/poly1305_glue.c               |  6 +--
>  arch/x86/crypto/sha1_ssse3_asm.S              |  4 --
>  arch/x86/crypto/sha1_ssse3_glue.c             |  9 +---
>  arch/x86/crypto/sha256-avx-asm.S              |  3 --
>  arch/x86/crypto/sha256_ssse3_glue.c           |  8 +---
>  arch/x86/crypto/sha512-avx-asm.S              |  2 -
>  arch/x86/crypto/sha512_ssse3_glue.c           |  7 +--
>  arch/x86/include/asm/dwarf2.h                 | 43 -------------------
>  arch/x86/include/asm/xor_avx.h                |  9 ----
>  lib/raid6/algos.c                             |  2 -
>  lib/raid6/recov_ssse3.c                       |  6 ---
>  lib/raid6/test/Makefile                       |  3 --
>  18 files changed, 26 insertions(+), 156 deletions(-)
>
> --
> 2.17.1
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200323020844.17064-1-masahiroy%40kernel.org.



-- 
Thanks,
~Nick Desaulniers

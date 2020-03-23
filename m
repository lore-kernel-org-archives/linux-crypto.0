Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0DBCC3F2CD
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 18:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7B1A2074D
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 18:06:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kLckJLXz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgCWSGi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 14:06:38 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:58345 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbgCWSGi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 14:06:38 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c8a2d632;
        Mon, 23 Mar 2020 17:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=FPZf4kVghzlSWSBHY6w3F8ZRqfw=; b=kLckJL
        XzpdN8QraJS6PfLqt3cwASnfpFIbUg2dkAHu06/Qbrp8xKiNtUSjgRsiNWeyAAa0
        MHwZ2Wi2iseZ9bbwDbGOMwIqaZgsfUFKJwRmBTlWklLiaY211PM+Y4sg2csYXxhc
        2vJxrqGRSZ+RPa/Xo+SvlZpI/9XemAk++VZJVefs82EhAU9y+JwA8vgcXNq8VFLA
        U8AyV8TtCPLqNknkbyc3yHVoZGvelUGXvfV2Za05MGF35DUOvF5OeV1Wl7bdxeen
        ZgtyY5TyS32elN9JYzrUEi4ocyuHcYU2UdDu2rylUkk4FWOYqs50OWWfao18+YYH
        YMpS4XX5+YPSMBUw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7a32da01 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Mar 2020 17:59:33 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id h8so15230879iob.2;
        Mon, 23 Mar 2020 11:06:34 -0700 (PDT)
X-Gm-Message-State: ANhLgQ04WlYE++ODZ1bQag63imAYhkVZYDxiL5l00GXx76VupkxMju/e
        GrRqGC5KgQiA7Rjkm2JyUs8QCwRt8NaEn+4eKv4=
X-Google-Smtp-Source: ADFU+vt+pDpeqWScbmvLs9OTr6OR3UtD7Q3r5qSpCUxhzqAWtqxjh7kbAn4P2ZYYhC5RjEDqPxVEXxLIypNeTI1dk9I=
X-Received: by 2002:a05:6638:308:: with SMTP id w8mr20677307jap.108.1584986793763;
 Mon, 23 Mar 2020 11:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <20200323020844.17064-6-masahiroy@kernel.org>
In-Reply-To: <20200323020844.17064-6-masahiroy@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 23 Mar 2020 12:06:22 -0600
X-Gmail-Original-Message-ID: <CAHmME9p3LAnrUMmcGPEUFqY5vOASe8MVk4=pzqFRj3E9C-bM+Q@mail.gmail.com>
Message-ID: <CAHmME9p3LAnrUMmcGPEUFqY5vOASe8MVk4=pzqFRj3E9C-bM+Q@mail.gmail.com>
Subject: Re: [PATCH 5/7] x86: remove always-defined CONFIG_AS_SSSE3
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     X86 ML <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 22, 2020 at 8:10 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index bf1b4765c8f6..77457ea5a239 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -103,9 +103,7 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
>  #ifdef CONFIG_AS_AVX2
>         &raid6_recov_avx2,
>  #endif
> -#ifdef CONFIG_AS_SSSE3
>         &raid6_recov_ssse3,
> -#endif
>  #ifdef CONFIG_S390
>         &raid6_recov_s390xc,
>  #endif

algos.c is compiled on all platforms, so you'll need to ifdef that x86
section where SSSE3 is no longer guarding it. The pattern in the rest
of the file, if you want to follow it, is "#if defined(__x86_64__) &&
!defined(__arch_um__)". That seems ugly and like there are better
ways, but in the interest of uniformity and a lack of desire to
rewrite all the raid6 code, I went with that in this cleanup:

https://git.zx2c4.com/linux-dev/commit/?h=jd/kconfig-assembler-support&id=512a00ddebbe5294a88487dcf1dc845cf56703d9

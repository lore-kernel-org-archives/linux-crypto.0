Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3603DC4332B
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 21:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 064592076F
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 21:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZlDyQMB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgCWVB4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 17:01:56 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:47999 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgCWVB4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 17:01:56 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 05ec56f2;
        Mon, 23 Mar 2020 20:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Dzejo8MYHCbr04lE7e7h/dcQGR0=; b=ZlDyQM
        B3eLmIe4Lzb9S1fZKMuVz0p6YPU14Sh2RKRK9T5t69tI+QitT251cxSL7DCTD82Q
        5UMSVeNjuCWIvg+UjKp6o8XxsdtuqFjGO+JytU+amWToRil3dy2zKWM38wa13Ek3
        Dg1pRn7Zdt/7SrVwP2wLpZIgi2ur71Mp0mLeiEccJ20jyfYRXHhfE7OJR9IR7l5w
        WqEXkJy3i7LfLeOXU5Xek1zGo+0K1ybvIAzAePfSxl9B63SOxKT1jczOOpsH8WfQ
        PyejD1IloUSTh14VsAETuGlZmR9hCGZ2k2Rg1wBCawkClzZyqhIs6UqPWIJS1YOm
        RM2flSbiCM/Vg+DQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0ed2ecef (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Mar 2020 20:54:50 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id r5so10024782ilq.6;
        Mon, 23 Mar 2020 14:01:53 -0700 (PDT)
X-Gm-Message-State: ANhLgQ0CwfgEJJsfD2EfC78COOFnm7OD/pKysM0CkUJyU+KQh1O8yrUd
        QefFExJ85mvcBmTu7FNgxca6a8evJAoTubHcfD4=
X-Google-Smtp-Source: ADFU+vvDFPmC+Zf1SrdmYagNkhzoBtUhqADiRrdFYfBgB18+BfHzDxaVVBEO9t6ZtFAL6weZTY9YjQCJRXktPBoLtWI=
X-Received: by 2002:a92:cece:: with SMTP id z14mr14770588ilq.38.1584997311836;
 Mon, 23 Mar 2020 14:01:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org> <20200323020844.17064-6-masahiroy@kernel.org>
 <CAHmME9p3LAnrUMmcGPEUFqY5vOASe8MVk4=pzqFRj3E9C-bM+Q@mail.gmail.com>
 <CAK7LNATVAq_Wkv=K-ezwnG=o8a9OoKspZJYOyq+4OXX7EZHPnA@mail.gmail.com> <CAHmME9pg0_EAG_YkGJQ2AE0n=9EvP2CVoj+bT8cCuiDAdHzUCQ@mail.gmail.com>
In-Reply-To: <CAHmME9pg0_EAG_YkGJQ2AE0n=9EvP2CVoj+bT8cCuiDAdHzUCQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 23 Mar 2020 15:01:40 -0600
X-Gmail-Original-Message-ID: <CAHmME9o9AmwvD=SWmf=xtuOgQXgGi1D504tE6v3s4yqF2pR8ug@mail.gmail.com>
Message-ID: <CAHmME9o9AmwvD=SWmf=xtuOgQXgGi1D504tE6v3s4yqF2pR8ug@mail.gmail.com>
Subject: Re: [PATCH 5/7] x86: remove always-defined CONFIG_AS_SSSE3
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Kees Cook <keescook@chromium.org>
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

On Mon, Mar 23, 2020 at 2:48 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> By the way, it looks like 5.7 will be raising the minimum binutils to
> 2.23: https://lore.kernel.org/lkml/20200316160259.GN26126@zn.tnic/ In
> light of this, I'll place another patch on top of my branch handling
> that transition.

That now lives at the top of the usual branch:
https://git.zx2c4.com/linux-dev/log/?h=jd/kconfig-assembler-support

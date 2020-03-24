Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E53C41621
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 17:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30B702080C
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 17:33:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l0XcA5O6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgCXRdq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Mar 2020 13:33:46 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38146 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCXRdp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Mar 2020 13:33:45 -0400
Received: by mail-pf1-f194.google.com with SMTP id z25so5305406pfa.5
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2020 10:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l8i/jKNKGTUjyZgUaJ4Q4T57WgO4guK2uBJsY6uqpzo=;
        b=l0XcA5O6RVgIo3bJA7443ZUE+xxIelr9CsIBjJs9tFuf9qQvm8YmOZt8DWsTdKo/jt
         sf6cqFgG3gcJyXEhJ3ePjo3pC6ZAAM+xbyt9/I5qhMZ9FuzXkKM0WIP7gOWI8sw+NLQA
         zAtSWXtA4kxu9BpkqHb5R3txEf1gF+QBmObPKWLw0F3APnCnlk5PpySxThMgKZIKReSH
         fadhc5DQxGgoVOX3HaMJH9drsNkbknSNYEFKl2MNBLJ5uBPOj3p7LDZp2cEqaPDA4Agl
         c9MVpbM6S6ehOpyntMODwdeLdDJgmqnKzxskXZqiSQ94M9H+5UROtxtEnf3Q5Nb5DiES
         jvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l8i/jKNKGTUjyZgUaJ4Q4T57WgO4guK2uBJsY6uqpzo=;
        b=gEMI8oCOGbKA7PS4+zdAj9fRQ8X6Hp5XDZkxTvuHGDXjBGikSAQvHpJiYGbKMpb53+
         NV+x6Ly6KEbc2I0RoXCAcWbzKufjtIBHATkadq26ciD4shXLvTLBkwCI/tXrqxF3wfkj
         qLpOAwJ2xuC0YVKZ/zMnysm+N3XuTUAiiiR2kajpFVvNY5qI3qF2FYr48Y3F/zhcnoD1
         G1iSOM2vHfWpbAyK3Oz70DmCo75zoB87fRmUPzerBb9SATdknxw5Ptd+1dNQz8FUgO7j
         htNuXzQVCc8qMo3jJvPH/GOmylce8O3S5Szi/WDhegCKWzQ5T2ldWqfmIrURPRBHOFWf
         Jg+Q==
X-Gm-Message-State: ANhLgQ1gbcfNF61jgK0pAXGQWTiAfuNLTqnxbSDhmqMAL9T7jUD9nmVq
        eMG450p/5lj/aALxKFkWDH8xv4cQkgMiY3PBTGeKEA==
X-Google-Smtp-Source: ADFU+vumwoGVKW5e7HNVBvJkvgDzk/FkczTUQunpToW6bcg/sTbgkxAIHKgmKJhQhPXrCtYgfRjNy6pDCfbW+x7s+k8=
X-Received: by 2002:aa7:87ca:: with SMTP id i10mr30843931pfo.169.1585071224082;
 Tue, 24 Mar 2020 10:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200324084821.29944-1-masahiroy@kernel.org> <20200324084821.29944-12-masahiroy@kernel.org>
 <CAKwvOdkj3dDNcbY4hwyManfviPdFoBooJJmFOAKL2YJCZNuhtA@mail.gmail.com> <CAHmME9pV93Zey2=XghxzThTHbZarFrnxwnGatXHyQjevPf7R=g@mail.gmail.com>
In-Reply-To: <CAHmME9pV93Zey2=XghxzThTHbZarFrnxwnGatXHyQjevPf7R=g@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 24 Mar 2020 10:33:32 -0700
Message-ID: <CAKwvOdmw5G+4F9eiZYK3JDHvnraDjGBPT+1hu=62Kc28PDa0Rw@mail.gmail.com>
Subject: Re: [PATCH 11/16] x86: probe assembler capabilities via kconfig
 instead of makefile
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 24, 2020 at 10:17 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, Mar 24, 2020 at 11:01 AM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > Can 11 just be rebased with 8 dropped?
>
> 8 adds comments to one place. 11 moves them to another place, while
> doing other things.
>
> Your desire is to skip the first step? I guess there's no problem with
> this, but I'm curious to learn why.

Before this series, there's no comments. After, the comments are in
arch/x86/Kconfig.assembler. Don't waste reviewers time by having other
patches in the set that move them around for fun. Just add them to the
final destination.

-- 
Thanks,
~Nick Desaulniers

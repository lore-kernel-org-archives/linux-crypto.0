Return-Path: <SRS0=nygc=5L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75ABDC2D0E5
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 17:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42A7F20848
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 17:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vk5A2110"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgCZR1s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Mar 2020 13:27:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45998 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgCZR1r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Mar 2020 13:27:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id r14so632232pfl.12
        for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2020 10:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4NpphCo6vE9dSdPy5tXFH6AEvJXO9V2xgWr809lDT+E=;
        b=vk5A2110hpX8Vi2G7l4CelrZ0PBKZxzXuC+ocVVr0YAJSJ+NV9SiEaG2QyVLsJarm4
         Ko9bvreoYNuKaZFdgG2YhPT53ncz9hlXKukNiqCVb8UKtyOb82zO5cqpqCEBesg5oID0
         fuwbqtW1njapxdxpGkCj39MIYKtnKXDqROO+Nf4V5JS+Q5QcnkcbYK+3UzcqFuKUwpdw
         +MnDrKcivQ7Ht+j/digPFASfivaJqZguRGJRPy6IVW51jKwCeWL17CZNQE5tUXljreys
         lrcAdAILbwZvmzi1KAgpQhUpiB/mEfhAlAK+NxJ7qFuOq/a2L4/zHI2w6dZZ6GG3CJjb
         gkSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4NpphCo6vE9dSdPy5tXFH6AEvJXO9V2xgWr809lDT+E=;
        b=aFmV6X08MSPpvoDFtWjcuWI5mv7zdPssamH3mKBsTwu5giJPTBWPVSuMqqxwARe39u
         1p6HiHnN5toLoAV9jrQx18O15UXPzXtLEfvEB8r75KYoRnZFVUF2o42DxWAIsTktTX25
         PKCkeMlAHMbOAF0JtC2X5b7kGP3ciiTHHt+PYirCf90e1AtfkqiYpUbVrzsAJ2nR7Glx
         uYTQVJYppzh+2faB/OGvg6OV7fJ4IbjhcHye0CmuKSHnVVZYQDxMdNvmsRxa3xwc7h5J
         qHimx6uTq+z2NSURC8zZzn07ABxSlVLVzhoEcWadAET9GcWgCNVEBUzSYclPfONDD0mY
         3iyw==
X-Gm-Message-State: ANhLgQ3ps8PqwGbjN3o6R9ug1JqjCthiklAtpxaTLcn5FMGblbcDcD7A
        lLdeu+aoP0MgQ69o9Je8KfI/dYNg2kd/RshmrA//CQ==
X-Google-Smtp-Source: ADFU+vsiPeXQcElObWb2nGl0HCkVtxk6f4mwf/y/m6oZlpernVWbNYrxUPYeukJrSSe7jeBfXaslhnuTzW2nqXvmWwE=
X-Received: by 2002:a05:6a00:42:: with SMTP id i2mr9962966pfk.108.1585243664874;
 Thu, 26 Mar 2020 10:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200324084821.29944-1-masahiroy@kernel.org> <20200324084821.29944-2-masahiroy@kernel.org>
 <CAKwvOd=AXnAjoa0iOhPc4S49ZpDDX9BYB-BZQc=6Z0dygVYLPA@mail.gmail.com> <CAK7LNATXz=x7M-HOfWLf1fc_km5qBYa5u1i3Bj30C7aoJPGjSA@mail.gmail.com>
In-Reply-To: <CAK7LNATXz=x7M-HOfWLf1fc_km5qBYa5u1i3Bj30C7aoJPGjSA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 26 Mar 2020 10:27:33 -0700
Message-ID: <CAKwvOdmGLmbghDAguisUZFUvGiBQVnfEogAFCtXaDLPxOLVYmA@mail.gmail.com>
Subject: Re: [PATCH 01/16] lib/raid6/test: fix build on distros whose /bin/sh
 is not bash
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
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
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        NeilBrown <neilb@suse.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 25, 2020 at 11:49 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Wed, Mar 25, 2020 at 1:36 AM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > On Tue, Mar 24, 2020 at 1:49 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > >
> > > You can test raid6 library code from user-space, like this:
> > >
> > >   $ cd lib/raid6/test
> > >   $ make
> > >
> > > The command in $(shell ...) function is evaluated by /bin/sh by default.
> > > (or, you can change the default shell by setting 'SHELL' in Makefile)
> > >
> > > Currently '>&/dev/null' is used to sink both stdout and stderr. Because
> > > this code is bash-ism, it only works when /bin/sh is a symbolic link to
> > > bash (this is the case on RHEL etc.)
> > >
> > > This does not work on Ubuntu where /bin/sh is a symbolic link to dash.
> > >
> > > I see lots of
> > >
> > >   /bin/sh: 1: Syntax error: Bad fd number
> > >
> > > and
> > >
> > >   warning "your version of binutils lacks ... support"
> > >
> > > Replace it with portable '>/dev/null 2>&1'.
> > >
> > > Fixes: 4f8c55c5ad49 ("lib/raid6: build proper files on corresponding arch")
> > > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > > Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> > > ---
> > >
> > >  lib/raid6/test/Makefile | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
> > > index 3ab8720aa2f8..b9e6c3648be1 100644
> > > --- a/lib/raid6/test/Makefile
> > > +++ b/lib/raid6/test/Makefile
> > > @@ -35,13 +35,13 @@ endif
> > >  ifeq ($(IS_X86),yes)
> > >          OBJS   += mmx.o sse1.o sse2.o avx2.o recov_ssse3.o recov_avx2.o avx512.o recov_avx512.o
> > >          CFLAGS += $(shell echo "pshufb %xmm0, %xmm0" |         \
> > > -                    gcc -c -x assembler - >&/dev/null &&       \
> > > +                    gcc -c -x assembler - >/dev/null 2>&1 &&   \
> > >                      rm ./-.o && echo -DCONFIG_AS_SSSE3=1)
> > >          CFLAGS += $(shell echo "vpbroadcastb %xmm0, %ymm1" |   \
> > > -                    gcc -c -x assembler - >&/dev/null &&       \
> > > +                    gcc -c -x assembler - >/dev/null 2>&1 &&   \
> > >                      rm ./-.o && echo -DCONFIG_AS_AVX2=1)
> > >         CFLAGS += $(shell echo "vpmovm2b %k1, %zmm5" |          \
> > > -                   gcc -c -x assembler - >&/dev/null &&        \
> > > +                   gcc -c -x assembler - >/dev/null 2>&1 &&    \
> >
> > These should all use $(CC) rather than hardcode gcc.
>
>
> Right, I had noticed this.
>
> We often fall between
> "let's fix this too while we are here"
> vs
> "do not do multiple things in a single patch"
>
>
> If we replace gcc -> $(CC),
> we also need to touch line 51 for consistency:
>
>        gcc -c -x c - >/dev/null && rm ./-.o && echo yes)
>
> ..., which is not our main interest now.
>
> So, I leave it to a follow-up patch
> if somebody has interest in it.

Haha, ok, no worries.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

-- 
Thanks,
~Nick Desaulniers

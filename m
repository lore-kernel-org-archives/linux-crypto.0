Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99546C47247
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 22:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7172B206B8
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 22:25:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="spGt4p/0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgEEWZn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 18:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgEEWZn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 18:25:43 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37364C061A0F;
        Tue,  5 May 2020 15:25:43 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id i27so390599ota.7;
        Tue, 05 May 2020 15:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UnIZKv+ULxeZ6m0Rl5baeyEV0lNzhevN8SqK1epATzE=;
        b=spGt4p/0/dKtwXmRZFrLA3V+LrjoMaNn/BjXDX8xg4KIcxpxozCqzlW8PWil9doKnz
         Miqccq7nEnBwGAZDBvUyK9xh18ozQM1jhGmUD95Tlq5IMevk7kkez3h1nw0Cyh4oxTiM
         oo9Mu9imekXv2N0v79ZN623+rGYGZFGJCrHJiRdza9HVGA5varEAuwtpAakw0/yxw/43
         d6zwNbF95WsVSkPtY11f6CsdAjbnRd15Hqul72j0F/d2N6I7zwHU48KS1mTNMmI78+jx
         Yu522Rn0IrT+Yik1GGkDoFDFc6XcjBKVpcWUd/pbIJVeQq17dD1mW6B6/h2Ty9GuPTI8
         05Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UnIZKv+ULxeZ6m0Rl5baeyEV0lNzhevN8SqK1epATzE=;
        b=bbJdX/4yre97zbPcPolTijmDY4/J01AkEl6cG4nqD3sNnr9X3H+XLSny9pYaTo+IB0
         Ouvf/1j//y5psA/+lyz0VGDBpAVjfvoYkjk72s1gFThwHBa4vjpTzmtOp4OOiT77Cvb2
         qFQPSmFF6xaNaKvEZFE5WnoYM1lwYqx+SqDqAdzz5ef8GwRwtknzBdaX7yNrTSEb8n1S
         qD1S+sD3HO8ULKM7ienyPFKMXS70K2jG7SntRH5NCjKgNkExNT08djp5grAOlAj2SKmu
         uiez7WrDaCPV6mOz4TPKaW2qJ+vfQCrm7idHsWABYLriqLwTYhVewwRqcu4jk1iQXEZh
         2B4A==
X-Gm-Message-State: AGi0PuYpjSg3hX0pEZyAEWH+zIC13nDteCh18Tt4x4asH9Nja4xjMVpp
        AzB01VVew/w6JZosQFme8D3ewvJ2
X-Google-Smtp-Source: APiQypINmRPopSXPt9L+rSTqy5lTYGfjS+LkYGxiaVUh/WgDh9Ei9+g50CV3RWyM1MxaHLHBa60itA==
X-Received: by 2002:a9d:4602:: with SMTP id y2mr4062509ote.199.1588717542246;
        Tue, 05 May 2020 15:25:42 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id 95sm36886otf.72.2020.05.05.15.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 15:25:41 -0700 (PDT)
Date:   Tue, 5 May 2020 15:25:40 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        George Burgess <gbiv@google.com>
Subject: Re: [PATCH] Kbuild: disable FORTIFY_SOURCE on clang-10
Message-ID: <20200505222540.GA230458@ubuntu-s3-xlarge-x86>
References: <CAHmME9oMcfY4nwkknwN9c4rB-O7xD4GCAOFPoZCbdnq=034=Vw@mail.gmail.com>
 <20200505215503.691205-1-Jason@zx2c4.com>
 <CAKwvOdk32cDowvrqRPKDRpf2ZiXh=jVnBTmhM-NWD=Ownq9v3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdk32cDowvrqRPKDRpf2ZiXh=jVnBTmhM-NWD=Ownq9v3w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 05, 2020 at 03:02:16PM -0700, 'Nick Desaulniers' via Clang Built Linux wrote:
> On Tue, May 5, 2020 at 2:55 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > clang-10 has a broken optimization stage that doesn't enable the
> > compiler to prove at compile time that certain memcpys are within
> > bounds, and thus the outline memcpy is always called, resulting in
> > horrific performance, and in some cases, excessive stack frame growth.
> > Here's a simple reproducer:
> >
> >     typedef unsigned long size_t;
> >     void *c(void *dest, const void *src, size_t n) __asm__("memcpy");
> >     extern inline __attribute__((gnu_inline)) void *memcpy(void *dest, const void *src, size_t n) { return c(dest, src, n); }
> >     void blah(char *a)
> >     {
> >       unsigned long long b[10], c[10];
> >       int i;
> >
> >       memcpy(b, a, sizeof(b));
> >       for (i = 0; i < 10; ++i)
> >         c[i] = b[i] ^ b[9 - i];
> >       for (i = 0; i < 10; ++i)
> >         b[i] = c[i] ^ a[i];
> >       memcpy(a, b, sizeof(b));
> >     }
> >
> > Compile this with clang-9 and clang-10 and observe:
> >
> > zx2c4@thinkpad /tmp/curve25519-hacl64-stack-frame-size-test $ clang-10 -Wframe-larger-than=0 -O3 -c b.c -o c10.o
> > b.c:5:6: warning: stack frame size of 104 bytes in function 'blah' [-Wframe-larger-than=]
> > void blah(char *a)
> >      ^
> > 1 warning generated.
> > zx2c4@thinkpad /tmp/curve25519-hacl64-stack-frame-size-test $ clang-9 -Wframe-larger-than=0 -O3 -c b.c -o c9.o
> >
> > Looking at the disassembly of c10.o and c9.o, one can see that c9.o is
> > properly optimized in the obvious way one would expect, while c10.o has
> > blown up and includes extern calls to memcpy.
> >
> > This is present on the most trivial bits of code. Thus, for clang-10, we
> > just set __NO_FORTIFY globally, so that this issue won't be incurred.
> >
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: LKML <linux-kernel@vger.kernel.org>
> > Cc: clang-built-linux <clang-built-linux@googlegroups.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: George Burgess <gbiv@google.com>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Link: https://bugs.llvm.org/show_bug.cgi?id=45802
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> I'm going to request this not be merged until careful comment from
> George and Kees. My hands are quite full at the moment with other
> regressions.  I suspect these threads may be relevant, though I
> haven't had time to read through them myself.
> https://github.com/ClangBuiltLinux/linux/issues/979
> https://github.com/ClangBuiltLinux/linux/pull/980

I believe these issues are one in the same. I did a reverse bisect with
Arnd's test case and converged on George's first patch:

https://github.com/llvm/llvm-project/commit/2dd17ff08165e6118e70f00e22b2c36d2d4e0a9a

I think that in lieu of this patch, we should have that patch and its
follow-up fix merged into 10.0.1.

I can file an upstream PR for Tom to take a look out later tonight.

Cheers,
Nathan

> > ---
> >  Makefile | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/Makefile b/Makefile
> > index 49b2709ff44e..f022f077591d 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -768,6 +768,13 @@ KBUILD_CFLAGS += -Wno-gnu
> >  # source of a reference will be _MergedGlobals and not on of the whitelisted names.
> >  # See modpost pattern 2
> >  KBUILD_CFLAGS += -mno-global-merge
> > +
> > +# clang-10 has a broken optimization stage that causes memcpy to always be
> > +# outline, resulting in excessive stack frame growth and poor performance.
> > +ifeq ($(shell test $(CONFIG_CLANG_VERSION) -ge 100000 && test $(CONFIG_CLANG_VERSION) -lt 110000; echo $$?),0)
> > +KBUILD_CFLAGS += -D__NO_FORTIFY
> > +endif
> > +
> >  else
> >
> >  # These warnings generated too much noise in a regular build.
> > --
> > 2.26.2
> >
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers
> 
> -- 
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CAKwvOdk32cDowvrqRPKDRpf2ZiXh%3DjVnBTmhM-NWD%3DOwnq9v3w%40mail.gmail.com.

Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B44C47247
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 22:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C77122075A
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 22:02:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n4aYqZKu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgEEWC3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 18:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729088AbgEEWC1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 18:02:27 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A8CC061A10
        for <linux-crypto@vger.kernel.org>; Tue,  5 May 2020 15:02:27 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y25so1601709pfn.5
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2020 15:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=meutyvpqi9+qTZ06UEsokNwwGPTMphxT3NcJSXe1Pt4=;
        b=n4aYqZKuQDutp5OyuzgrDrbOfw46qnS5p3WJa9OrEVIOe7YEDc6L8MVm0rNqy/CM0v
         EPXZs5B3vT9m/tCOyzVjW/ooXqk0Um9CTxmTKrdzOvr1UOvH2Qk+/a+xz1RKzAlgxxn/
         +pdlW8483sPcBESg7tKJJzIWd/1En/kGux6bn2UKHxYtc/9s18CqMNz47UQ6MYEfRyON
         uM9jikZBuhRPBp+wtcIzN7M6atPXrcF1VQeK5vlUAZCtcNvMhPHTK3gJNWy4Je8tr7UI
         10hnifAwGP79iZJF9wqmIjs6NXBm00T1eiSZGgBgbmWGwd3IxBq9B+PC6QeOHFPTBGiF
         B18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=meutyvpqi9+qTZ06UEsokNwwGPTMphxT3NcJSXe1Pt4=;
        b=HVZVa4iUGzLvef3WHqrhWHpKvUjsAdgZYodtBi9E7Ix3ltDzfvs5AWvW355ScluTpi
         BKRqsUvDvV6sPJJf5d0og/FGGqGS2QpIiyz7uFrCVKCUZaIczgnJC/WLlDNuugbsnlbr
         qwvXS4eQ5QBqkMC4xU4pm7iauHa9j0pUJ6NKuXQlIj8gE3zwOv811oxkpIZp0kIxg2Q4
         pkNDVV24+3l8QdqWUbItweXjia7a0FmBKyJmT3Lh1/riQZkFBOPMc5CRBSuUfM2Ms4JC
         fCL97BcZ3iSWpT/PapVx89WVK+bUevXz/rCrvctf4M6p3hiIVpTzKr5GmoEngEwvCiqR
         hGig==
X-Gm-Message-State: AGi0PubptDHc3KKK40PFnsmO9BTIHAFnZOTss6YTXIeg+e8iyzSQQc+9
        GvHK+5K5RCW5cBuYPPHVpbZstI8Tbppd0uiIUeolYQ==
X-Google-Smtp-Source: APiQypII92fzip+jhi9hD7251MPhAj00NvB2R8OUBsp6nQByudV49fC3OMI4LGDz7JOTRwkDao417VvP6RNTwjyMCU0=
X-Received: by 2002:a65:5ac4:: with SMTP id d4mr4267862pgt.381.1588716146345;
 Tue, 05 May 2020 15:02:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oMcfY4nwkknwN9c4rB-O7xD4GCAOFPoZCbdnq=034=Vw@mail.gmail.com>
 <20200505215503.691205-1-Jason@zx2c4.com>
In-Reply-To: <20200505215503.691205-1-Jason@zx2c4.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 5 May 2020 15:02:16 -0700
Message-ID: <CAKwvOdk32cDowvrqRPKDRpf2ZiXh=jVnBTmhM-NWD=Ownq9v3w@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: disable FORTIFY_SOURCE on clang-10
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        George Burgess <gbiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 5, 2020 at 2:55 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> clang-10 has a broken optimization stage that doesn't enable the
> compiler to prove at compile time that certain memcpys are within
> bounds, and thus the outline memcpy is always called, resulting in
> horrific performance, and in some cases, excessive stack frame growth.
> Here's a simple reproducer:
>
>     typedef unsigned long size_t;
>     void *c(void *dest, const void *src, size_t n) __asm__("memcpy");
>     extern inline __attribute__((gnu_inline)) void *memcpy(void *dest, const void *src, size_t n) { return c(dest, src, n); }
>     void blah(char *a)
>     {
>       unsigned long long b[10], c[10];
>       int i;
>
>       memcpy(b, a, sizeof(b));
>       for (i = 0; i < 10; ++i)
>         c[i] = b[i] ^ b[9 - i];
>       for (i = 0; i < 10; ++i)
>         b[i] = c[i] ^ a[i];
>       memcpy(a, b, sizeof(b));
>     }
>
> Compile this with clang-9 and clang-10 and observe:
>
> zx2c4@thinkpad /tmp/curve25519-hacl64-stack-frame-size-test $ clang-10 -Wframe-larger-than=0 -O3 -c b.c -o c10.o
> b.c:5:6: warning: stack frame size of 104 bytes in function 'blah' [-Wframe-larger-than=]
> void blah(char *a)
>      ^
> 1 warning generated.
> zx2c4@thinkpad /tmp/curve25519-hacl64-stack-frame-size-test $ clang-9 -Wframe-larger-than=0 -O3 -c b.c -o c9.o
>
> Looking at the disassembly of c10.o and c9.o, one can see that c9.o is
> properly optimized in the obvious way one would expect, while c10.o has
> blown up and includes extern calls to memcpy.
>
> This is present on the most trivial bits of code. Thus, for clang-10, we
> just set __NO_FORTIFY globally, so that this issue won't be incurred.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: LKML <linux-kernel@vger.kernel.org>
> Cc: clang-built-linux <clang-built-linux@googlegroups.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: George Burgess <gbiv@google.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Link: https://bugs.llvm.org/show_bug.cgi?id=45802
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

I'm going to request this not be merged until careful comment from
George and Kees. My hands are quite full at the moment with other
regressions.  I suspect these threads may be relevant, though I
haven't had time to read through them myself.
https://github.com/ClangBuiltLinux/linux/issues/979
https://github.com/ClangBuiltLinux/linux/pull/980


> ---
>  Makefile | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index 49b2709ff44e..f022f077591d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -768,6 +768,13 @@ KBUILD_CFLAGS += -Wno-gnu
>  # source of a reference will be _MergedGlobals and not on of the whitelisted names.
>  # See modpost pattern 2
>  KBUILD_CFLAGS += -mno-global-merge
> +
> +# clang-10 has a broken optimization stage that causes memcpy to always be
> +# outline, resulting in excessive stack frame growth and poor performance.
> +ifeq ($(shell test $(CONFIG_CLANG_VERSION) -ge 100000 && test $(CONFIG_CLANG_VERSION) -lt 110000; echo $$?),0)
> +KBUILD_CFLAGS += -D__NO_FORTIFY
> +endif
> +
>  else
>
>  # These warnings generated too much noise in a regular build.
> --
> 2.26.2
>


-- 
Thanks,
~Nick Desaulniers

Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77348C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 08:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 510E022B4D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 08:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598517747;
	bh=wclvkkKl9CY5goBsHBkmGVvOaKbHbv2Ix1uju0wU23g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=G596Fpz0Z7dqNWNd0HqARdCR+Ydfm5L2jpixeTB0gA8HS8sOMly2YL2aerIvfcIxj
	 yz7VOFd51BLmdS/98QkvV6ht/g1iid2rpzpdga2MuvKjWUgEo1VgxtYabd3tl1R9Jp
	 p1R0xFDjkCkOmEkggcwrlWGZq7M2vc5NOHwUiprk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgH0Im0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgH0Im0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 04:42:26 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FA7622B4D;
        Thu, 27 Aug 2020 08:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598517739;
        bh=wclvkkKl9CY5goBsHBkmGVvOaKbHbv2Ix1uju0wU23g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RJReixPE+FSBnG7x29B5LdCDWN9+OG8yPfiQFv1IZhYSHmZ2WlyPr/6Hud1+HdKDu
         VngWnI0dpwvHku88X2g/2xuK25+9a4sgeQK7XcXkIS7a7QVM2cxiwEHSFjts3Zrk+3
         mzEgWJRdDXA5q0TUunxOWz7IklAyVsZO9EVblQtM=
Received: by mail-oi1-f171.google.com with SMTP id u24so3970791oic.7;
        Thu, 27 Aug 2020 01:42:19 -0700 (PDT)
X-Gm-Message-State: AOAM530oQpE+WboUdK1t5ZXEvRwnJU/xOolZshGGDVZ6xxsXubdzCldV
        +MB+Ug7OjvrT7fHyLcK4tf9D4d0PV4jUHSTqPpk=
X-Google-Smtp-Source: ABdhPJy4Cn9ZwLqRgrx2W8ImrSTdx3Fc/IIoJjiGCvK5u3zFLd7AY/kARILiDgSveU+6toWXCsml+ZRuUgtOhUfdb1w=
X-Received: by 2002:aca:5401:: with SMTP id i1mr6242324oib.33.1598517738879;
 Thu, 27 Aug 2020 01:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <202008271145.xE8qIAjp%lkp@intel.com> <20200827080558.GA3024@gondor.apana.org.au>
 <CAMj1kXHJrLtnJWYBKBYRtNHVS6rv51+crMsjLEnSqkud0BBaWw@mail.gmail.com> <CAK8P3a3tjv78arTj75eKk5zYUhrGkPYRDLiqv3WJJC=U+Jia0Q@mail.gmail.com>
In-Reply-To: <CAK8P3a3tjv78arTj75eKk5zYUhrGkPYRDLiqv3WJJC=U+Jia0Q@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 27 Aug 2020 10:42:08 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHhmAdHjK5avXOySw43khzft1g8p48jX7aTeTC0FvS7tQ@mail.gmail.com>
Message-ID: <CAMj1kXHhmAdHjK5avXOySw43khzft1g8p48jX7aTeTC0FvS7tQ@mail.gmail.com>
Subject: Re: lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes
 is larger than 1024 bytes
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kbuild-all@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 27 Aug 2020 at 10:33, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Aug 27, 2020 at 10:10 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > On Thu, 27 Aug 2020 at 10:06, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > On Thu, Aug 27, 2020 at 11:52:50AM +0800, kernel test robot wrote:
> > > >
> > > > First bad commit (maybe != root cause):
> > > >
> > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > > > head:   15bc20c6af4ceee97a1f90b43c0e386643c071b4
> > > > commit: 5fb8ef25803ef33e2eb60b626435828b937bed75 crypto: chacha - move existing library code into lib/crypto
> > > > date:   9 months ago
> > > > config: i386-randconfig-r015-20200827 (attached as .config)
> > > > compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> > > > reproduce (this is a W=1 build):
> > > >         git checkout 5fb8ef25803ef33e2eb60b626435828b937bed75
> > > >         # save the attached .config to linux build tree
> > > >         make W=1 ARCH=i386
> > > >
> > > > If you fix the issue, kindly add following tag as appropriate
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > >
> > > > All warnings (new ones prefixed by >>):
> > > >
> > > >    lib/crypto/chacha.c: In function 'chacha_permute':
> > > > >> lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> > > >       65 | }
> > > >          | ^
> > >
> > > This doesn't happen with a normal configuration.  To recreate
> > > this warning, you need to enable both GCOV_KERNEL and UBSAN.
> > >
> > > This is the minimal gcc command-line to recreate it:
> > >
> > > gcc -Wframe-larger-than=1024 -fprofile-arcs -fsanitize=object-size -c -O2 chacha.c
> > >
> > > If you take away either profile-arcs or sanitize=object-size then
> > > the problem goes away.
> > >
> > > Any suggestions?
> > >
> >
> > Is it really worth it to obsess about this? Special compiler
> > instrumentation simply leads to a larger stack footprint in many
> > cases, which is why we use a larger stack to begin with (at least we
> > do so for Kasan, so if we don't for Ubsan, we should consider it)
> >
> > Past experience also shows that this is highly dependent on the exact
> > compiler version, so issues like these are often moving targets.
>
> Yes, I do think it is important to address these in some form,
> for multiple reasons:
>
> * With the limited amount of stack space in normal uninstrumented
>   kernels, I do think it is vital to have a fairly low default warning
>   limit in order to catch all cases that do something dangerously
>   stupid, either because of code bugs or compiler bugs.
>
> * I also think we do want the warning enabled in other configurations,
>   in particular because the compiler tends to make increasingly stupid
>   decisions when combining less common instrumentations, which
>   again can lead to instant exploitable bugs, e.g. when a function's
>   stack frame grows beyond the total stack size. In many cases the
>   gcc and clang developers are both able to address these quickly
>   when we send a good bug report (which unfortunately can be a lot of
>   work).
>
> * The crypto cipher code unfortunately is particularly prone to running
>   into these issues because each new compiler version tries to
>   find more clever tricks to optimize code that in turn implements
>   an algorithm that intentionally tries to not have any clever shortcuts.
>   In many cases the stack size warning that we see in some
>   configurations is an indicator for the compiler running into a false
>   optimization even on the non-instrumented code that leads to lower
>   performance from unnecessary register spilling that should be
>   avoided.
>

In that case, I suppose we should simply disable instrumentation for
chacha_permute()? It is a straight-forward arithmetic transformation
on a u32[16] array, where ubsan has limited value afaict.

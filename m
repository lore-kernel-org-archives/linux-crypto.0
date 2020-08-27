Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15B4C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 08:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A672422B49
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 08:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgH0Idj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:33:39 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:37459 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgH0Idi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 04:33:38 -0400
Received: from mail-qv1-f43.google.com ([209.85.219.43]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MC2o9-1kKn4M4AXd-00CVXW; Thu, 27 Aug 2020 10:33:36 +0200
Received: by mail-qv1-f43.google.com with SMTP id dd12so2270470qvb.0;
        Thu, 27 Aug 2020 01:33:35 -0700 (PDT)
X-Gm-Message-State: AOAM533w65KOeGr5/6BLw2G3GVKnaTF3Zgx3wY+kORC2uxIsepMPJ0qh
        YDz4V5KKzo6xhu4BJ2Y5rrm9RnEzuWx0RxQ1gcU=
X-Google-Smtp-Source: ABdhPJy+A9ryGmc9Z9SNAIE036Cbip+3nr6EZ78nveUf7BapYqShDy3eFJL4B4oN6JvR6A29WlmHvs0j1zLFmQ91Cdo=
X-Received: by 2002:a0c:f84b:: with SMTP id g11mr17691330qvo.184.1598517214730;
 Thu, 27 Aug 2020 01:33:34 -0700 (PDT)
MIME-Version: 1.0
References: <202008271145.xE8qIAjp%lkp@intel.com> <20200827080558.GA3024@gondor.apana.org.au>
 <CAMj1kXHJrLtnJWYBKBYRtNHVS6rv51+crMsjLEnSqkud0BBaWw@mail.gmail.com>
In-Reply-To: <CAMj1kXHJrLtnJWYBKBYRtNHVS6rv51+crMsjLEnSqkud0BBaWw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 27 Aug 2020 10:33:18 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3tjv78arTj75eKk5zYUhrGkPYRDLiqv3WJJC=U+Jia0Q@mail.gmail.com>
Message-ID: <CAK8P3a3tjv78arTj75eKk5zYUhrGkPYRDLiqv3WJJC=U+Jia0Q@mail.gmail.com>
Subject: Re: lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes
 is larger than 1024 bytes
To:     Ard Biesheuvel <ardb@kernel.org>
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
X-Provags-ID: V03:K1:4fSiqAbRXooZtwBnFX5yMtouECylvyAIbZj2dhj4C9kVFYl1Eta
 YsNtKCH4p0CgVomfbAYe36GVfMspR731sl+hDEYy/NXlnAlW1XB/kPxDbaTRFvKGCjEoWcL
 KegrviQLERM1gvA0FR72MDdMQFSpxRCv8kJlpkScEmKahbdul4EIJkZnpRIDsZhsayiiuX0
 YfwpfY6eW0kPL3f9esC2w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9kcirj4J0lo=:WHLLE2KUshOmHogpSVE0wE
 AJNvJ4KgJDgxpXgnwGZB71APRjzd6rxwFmoAgFEZabiQpZHXGVbh7fbWR+d9iBFnYaYb8n0fe
 +rRnuC175aGQ6mSzlGNRTVhfsI+ssJ7LaJwpQiMyu2IW6j27HmIi3H/bl2vE1G9aHMVC4FiYk
 H6H4OnHDozysruwOP7jFLEIrT0RMtgE0gkG9vAa7kiDOChuEcJVUmzqcZVYB28cupgm1XsoUa
 nOBNCc702VjZCmwybsKDY9/2r0v0h5AJsP6Q9SeLjA5/UXEjypLPJFHXpt7L06svQ/i08uMx5
 0OSzXRHqIurbOofawQuGgFsnFb0dDO46j6BmULIsFGrrSLfE/86e02omMLnuBrDRxbKNV+sDu
 oVqo6rDm4hVAhLhGgqcflzpv1suzvf+xgPqoEdNs3UnWxJ4FfZ+YT2VQAV4V6kpLIZsuz6qoN
 GXQD7d7uAtggCVDCs+qDJQquxR1XSh8FpMXy4BP8Z7MTg54sVj7i73tQNV4bqXvnCpuvLo0AQ
 sn3K0Xib1gRkq60mKIqWdbiFqafyd2CVmNaNseQx/Vrc2cwDCnxwnXwoNbp/89RUGj0NSDumd
 Y4dHB/mINzQCo1oCsezyRtFDMsT7qQfXqMIeyP72/uy3ekP+UlXob6FFjVMp5mVCMtuV3MipI
 6DLV39DGYdPxAACOayD0/krJH+sDLUdvZq5RE7HPBFivDILNaZtug7wVfqgo3bKvbjRWm7U0u
 Qg/2mrbBDQjeYCGEcxl2aTzwaEQDE8Yj7O9bkBHoLjgwkluVij9BD1CyWAQZg2NOOWGKzQ/Q1
 RqENOxecvev29and9/326exqM31S8DBdqqa/HkpiZRqlqw8hN2e6Bq4FpBY68a9EMvu3CJB
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 10:10 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> On Thu, 27 Aug 2020 at 10:06, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Thu, Aug 27, 2020 at 11:52:50AM +0800, kernel test robot wrote:
> > >
> > > First bad commit (maybe != root cause):
> > >
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > > head:   15bc20c6af4ceee97a1f90b43c0e386643c071b4
> > > commit: 5fb8ef25803ef33e2eb60b626435828b937bed75 crypto: chacha - move existing library code into lib/crypto
> > > date:   9 months ago
> > > config: i386-randconfig-r015-20200827 (attached as .config)
> > > compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> > > reproduce (this is a W=1 build):
> > >         git checkout 5fb8ef25803ef33e2eb60b626435828b937bed75
> > >         # save the attached .config to linux build tree
> > >         make W=1 ARCH=i386
> > >
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kernel test robot <lkp@intel.com>
> > >
> > > All warnings (new ones prefixed by >>):
> > >
> > >    lib/crypto/chacha.c: In function 'chacha_permute':
> > > >> lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> > >       65 | }
> > >          | ^
> >
> > This doesn't happen with a normal configuration.  To recreate
> > this warning, you need to enable both GCOV_KERNEL and UBSAN.
> >
> > This is the minimal gcc command-line to recreate it:
> >
> > gcc -Wframe-larger-than=1024 -fprofile-arcs -fsanitize=object-size -c -O2 chacha.c
> >
> > If you take away either profile-arcs or sanitize=object-size then
> > the problem goes away.
> >
> > Any suggestions?
> >
>
> Is it really worth it to obsess about this? Special compiler
> instrumentation simply leads to a larger stack footprint in many
> cases, which is why we use a larger stack to begin with (at least we
> do so for Kasan, so if we don't for Ubsan, we should consider it)
>
> Past experience also shows that this is highly dependent on the exact
> compiler version, so issues like these are often moving targets.

Yes, I do think it is important to address these in some form,
for multiple reasons:

* With the limited amount of stack space in normal uninstrumented
  kernels, I do think it is vital to have a fairly low default warning
  limit in order to catch all cases that do something dangerously
  stupid, either because of code bugs or compiler bugs.

* I also think we do want the warning enabled in other configurations,
  in particular because the compiler tends to make increasingly stupid
  decisions when combining less common instrumentations, which
  again can lead to instant exploitable bugs, e.g. when a function's
  stack frame grows beyond the total stack size. In many cases the
  gcc and clang developers are both able to address these quickly
  when we send a good bug report (which unfortunately can be a lot of
  work).

* The crypto cipher code unfortunately is particularly prone to running
  into these issues because each new compiler version tries to
  find more clever tricks to optimize code that in turn implements
  an algorithm that intentionally tries to not have any clever shortcuts.
  In many cases the stack size warning that we see in some
  configurations is an indicator for the compiler running into a false
  optimization even on the non-instrumented code that leads to lower
  performance from unnecessary register spilling that should be
  avoided.

      Arnd

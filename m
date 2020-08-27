Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C928C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 08:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59CD52177B
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 08:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598515834;
	bh=VQq8gbJUEziteqpJ/law0V4awYCnl+XPgKnJ/CJ7nhU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=KNEMn3beBEGfALXqZu8XqlBM9bm7T8WBOL8Hol3QnorrFFIgr3QjWwqtjQVP6ApVh
	 vqh000+wwr6ttVww6AJFehc2LfHh4g1QxbrKHecZdTxJhMzSVthZGaCaZpatU7qWFG
	 E4e/D+0GfFZkJAiqga+Hl/F4eHdo9Z7dApGwJSIU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgH0IKd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgH0IKb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 04:10:31 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87E432078A;
        Thu, 27 Aug 2020 08:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598515830;
        bh=VQq8gbJUEziteqpJ/law0V4awYCnl+XPgKnJ/CJ7nhU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=15SJ3yD8Is6a+Q6jBs/o3lxEua0UFKIlixM4FRf77NEtPSVWGxP6aAoor6Qcx2JWj
         kbtrsP+4aGU/KA9jaIvcs7QSKa1DWLlY7v2lBvm86dKIdxDpxwQWi1R2hRl6zrHVBh
         1AfsW/abZ4bzaqX4pzGHtvulQhyQ+QEq1hJ47q0A=
Received: by mail-oi1-f169.google.com with SMTP id d189so3474963oig.12;
        Thu, 27 Aug 2020 01:10:30 -0700 (PDT)
X-Gm-Message-State: AOAM53246beGQhI6gxPDBBsRts7zMH4IJEj/8kmvyUsDA/b4VLPRKUjw
        sUKdfDBK66U2g14S8P+QLF52oTJsheGsPEHoYPo=
X-Google-Smtp-Source: ABdhPJyrAmdgkcaY4Pd7jwr8+Re1j38tcJj2SS+fbk88DFETtHiSS1Sxa3NWEim4hhLy+AsXV5pC6jIUj1NcgDuNkmc=
X-Received: by 2002:aca:d8c5:: with SMTP id p188mr5752662oig.47.1598515829931;
 Thu, 27 Aug 2020 01:10:29 -0700 (PDT)
MIME-Version: 1.0
References: <202008271145.xE8qIAjp%lkp@intel.com> <20200827080558.GA3024@gondor.apana.org.au>
In-Reply-To: <20200827080558.GA3024@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 27 Aug 2020 10:10:19 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHJrLtnJWYBKBYRtNHVS6rv51+crMsjLEnSqkud0BBaWw@mail.gmail.com>
Message-ID: <CAMj1kXHJrLtnJWYBKBYRtNHVS6rv51+crMsjLEnSqkud0BBaWw@mail.gmail.com>
Subject: Re: lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes
 is larger than 1024 bytes
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     kernel test robot <lkp@intel.com>,
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

(+ Arnd)

On Thu, 27 Aug 2020 at 10:06, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 27, 2020 at 11:52:50AM +0800, kernel test robot wrote:
> >
> > First bad commit (maybe != root cause):
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   15bc20c6af4ceee97a1f90b43c0e386643c071b4
> > commit: 5fb8ef25803ef33e2eb60b626435828b937bed75 crypto: chacha - move existing library code into lib/crypto
> > date:   9 months ago
> > config: i386-randconfig-r015-20200827 (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> > reproduce (this is a W=1 build):
> >         git checkout 5fb8ef25803ef33e2eb60b626435828b937bed75
> >         # save the attached .config to linux build tree
> >         make W=1 ARCH=i386
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> >    lib/crypto/chacha.c: In function 'chacha_permute':
> > >> lib/crypto/chacha.c:65:1: warning: the frame size of 1604 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> >       65 | }
> >          | ^
>
> This doesn't happen with a normal configuration.  To recreate
> this warning, you need to enable both GCOV_KERNEL and UBSAN.
>
> This is the minimal gcc command-line to recreate it:
>
> gcc -Wframe-larger-than=1024 -fprofile-arcs -fsanitize=object-size -c -O2 chacha.c
>
> If you take away either profile-arcs or sanitize=object-size then
> the problem goes away.
>
> Any suggestions?
>

Is it really worth it to obsess about this? Special compiler
instrumentation simply leads to a larger stack footprint in many
cases, which is why we use a larger stack to begin with (at least we
do so for Kasan, so if we don't for Ubsan, we should consider it)

Past experience also shows that this is highly dependent on the exact
compiler version, so issues like these are often moving targets.

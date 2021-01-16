Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE3DC433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 18:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD51122472
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 18:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbhAPSFH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 13:05:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbhAPSFG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 13:05:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 358EF2339E
        for <linux-crypto@vger.kernel.org>; Sat, 16 Jan 2021 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610811421;
        bh=x4l1R8gCEd4dz4+3VSqSCWo48nh0BvgITV/Eyfeqkk4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=il3FDsOsXPawNmBAj4NyVMR6qeFnMj5y5nlBbKHXjQHI/B/NfN+I/BkeDaQWlrFZI
         ROuO0cTh6v/lOfgv075bMj/C31hadQNUNxXUukPeyhcS1RTaWCexBcHjGFUSxlBFnp
         4DQzuSAKNCa9WvzTpj0/fF6kr1/NPzGcfErQhrPMAqyx65K9IczeEIbrhLcoiEcRsF
         N0KUwq0DiAeD1C5nvHvk2O6fM9aIw85sW1dl5cBpLqqYFT+zk+0b/wpp56U7HaGFnO
         F8zjTTLc2DufQGolP9shEHCc8842fXUM1+pk3zYqiMM20jo9lHo535bNcOUiwHO/R/
         qeJW+dlOIHbcg==
Received: by mail-ot1-f43.google.com with SMTP id q25so11718233otn.10
        for <linux-crypto@vger.kernel.org>; Sat, 16 Jan 2021 07:37:01 -0800 (PST)
X-Gm-Message-State: AOAM532fbVPSWU0IKpwnvO9GPZEtIXFD8cAr3f09VH7s1yBsI9pasV71
        j1RFi4THyhhvQu17V+8KX2EU+DR/11nZBRNteTo=
X-Google-Smtp-Source: ABdhPJzz80o1MaCOj5HW0Hp2A2E0kn95lxBT8fGlBkJHK/Z9C2eOXyrULwJQJFAOQK2f9sPxPN9OR1frSgv/b3rvIdk=
X-Received: by 2002:a9d:7a4b:: with SMTP id z11mr12332724otm.305.1610811420486;
 Sat, 16 Jan 2021 07:37:00 -0800 (PST)
MIME-Version: 1.0
References: <202101160841.jUXjdS7j-lkp@intel.com> <YAJIhjzmvszXAXUb@gmail.com>
In-Reply-To: <YAJIhjzmvszXAXUb@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 16 Jan 2021 16:36:44 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1FTzwK=xK2eC5hiBSC+Xjq1eNO_cv3=CRB4csNiMpsUA@mail.gmail.com>
Message-ID: <CAK8P3a1FTzwK=xK2eC5hiBSC+Xjq1eNO_cv3=CRB4csNiMpsUA@mail.gmail.com>
Subject: Re: [linux-next:master 952/3956] crypto/blake2b_generic.c:73:13:
 warning: stack frame size of 9776 bytes in function 'blake2b_compress_one_generic'
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        George Popescu <georgepope@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jan 16, 2021 at 2:59 AM Eric Biggers <ebiggers@kernel.org> wrote:
> On Sat, Jan 16, 2021 at 08:59:50AM +0800, kernel test robot wrote
>
> Looks like the clang bug that causes large stack usage in this function
> (https://bugs.llvm.org/show_bug.cgi?id=45803 which is still unfixed) got
> triggered again.  Note that the function only has 264 bytes of local variables,
> so there's no reason why it should use anywhere near 9776 bytes of stack space.
>
> I'm not sure what we can do about this.  Last time the solution was commit
> 0c0408e86dbe which randomly added a 'pragma nounroll' to the loop at the end.
>
> Anyone have any better idea than randomly trying adding optimization pragmas and
> seeing what makes the report go away?
>
> Also this was reported with clang 12.0.0 which is a prerelease version, so I'm
> not sure how much I'm supposed to care about this report.

I sent a workaround to disable UBSAN_UNSIGNED_OVERFLOW an
x86-32, after showing that this did not affect arm32, arm64 or x86-64:
27c287b41659 ("ubsan: disable unsigned-overflow check for i386")

As the report is for ppc64, it appears that this is not just specific to x86-32
after all. I have had no success in isolating the problem in clang, but I
did not try too hard either. I see this .config also enables
CONFIG_UBSAN_UNSIGNED_OVERFLOW=y, so it would be a
reasonable assumption that this is the same problem as on x86-32.

There is also another thread on CONFIG_UBSAN_UNSIGNED_OVERFLOW
causing BUILD_BUG_ON() failures.

        Arnd

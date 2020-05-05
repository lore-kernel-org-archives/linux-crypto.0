Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F86CC47247
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 23:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AFD020721
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 23:22:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SeDwSbyn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgEEXWz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 19:22:55 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:48629 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgEEXWz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 19:22:55 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f738d374;
        Tue, 5 May 2020 23:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=l2C3eGUZm0cGSrtG5eEab6sxYaM=; b=SeDwSb
        yn2Zee+fmI/17Fiftl1FOfY1ba1n+vgk5HAZNms4Z2oPSAGJPMxoMFsplZ9K1l3V
        cGiraIm+5V3zyAynv3m1RIB/0qA5dTXLDpLd/YBKUb8HTL7jvssKJJ8dvigqD65A
        5rtC1o6fnJMFJgfBIE2V2eC6HdPgREalkossHOT7jVrAxd7xZkaiYLAfc2nXmKfo
        VzyHQy2gwbY2+3sNsCFChilNm2eOPxJNsViUVeVHgAMJ75Jc6cBEx7wucbcgvvH+
        SA3ST7ASFTqz7RC6QhqSGNAHhPwk5qHHdtR3OEgpK80fsC+pZmru9f+rX57CTUdd
        cIbZkugKXFiCrJsA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1ce01312 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 5 May 2020 23:10:18 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id w11so208087iov.8;
        Tue, 05 May 2020 16:22:53 -0700 (PDT)
X-Gm-Message-State: AGi0PublBl+yTXAVZIKw7Z+bJOSBoWqmwicskUHJr7l36wv9r/X/C7nr
        J37F8U+qEy17ZWHm2wh9lQWXp/9+PXPpsNiDQd8=
X-Google-Smtp-Source: APiQypJqRUfqrgcUx2pI/zt5ty6fSBfyjcvaFYUblPYalQ/j6fLp2KKxWN5jLWtm/o1Eba9uMrLwhZDX2cvbBF6VU1k=
X-Received: by 2002:a5e:9401:: with SMTP id q1mr5640448ioj.80.1588720973419;
 Tue, 05 May 2020 16:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oMcfY4nwkknwN9c4rB-O7xD4GCAOFPoZCbdnq=034=Vw@mail.gmail.com>
 <20200505215503.691205-1-Jason@zx2c4.com> <CAKwvOdk32cDowvrqRPKDRpf2ZiXh=jVnBTmhM-NWD=Ownq9v3w@mail.gmail.com>
 <20200505222540.GA230458@ubuntu-s3-xlarge-x86> <CAHmME9qs0iavoBqd_z_7Xibyz7oxY+FRt+sHyy+sBa1wQc66ww@mail.gmail.com>
 <202005051617.F9B32B5526@keescook> <CAHmME9q3zFe4e1xnpptJ27zywGqngZK2K7LCVzDSoG__ht=fNA@mail.gmail.com>
In-Reply-To: <CAHmME9q3zFe4e1xnpptJ27zywGqngZK2K7LCVzDSoG__ht=fNA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 5 May 2020 17:22:42 -0600
X-Gmail-Original-Message-ID: <CAHmME9oWTv8YE63FboK4qNmy5vt2pLGyOkP52gPWVRGrhN67SQ@mail.gmail.com>
Message-ID: <CAHmME9oWTv8YE63FboK4qNmy5vt2pLGyOkP52gPWVRGrhN67SQ@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: disable FORTIFY_SOURCE on clang-10
To:     Kees Cook <keescook@chromium.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>, George Burgess <gbiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 5, 2020 at 5:22 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, May 5, 2020 at 5:19 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Tue, May 05, 2020 at 04:37:38PM -0600, Jason A. Donenfeld wrote:
> > > On Tue, May 5, 2020 at 4:25 PM Nathan Chancellor
> > > <natechancellor@gmail.com> wrote:
> > > > I believe these issues are one in the same. I did a reverse bisect with
> > > > Arnd's test case and converged on George's first patch:
> > > >
> > > > https://github.com/llvm/llvm-project/commit/2dd17ff08165e6118e70f00e22b2c36d2d4e0a9a
> > > >
> > > > I think that in lieu of this patch, we should have that patch and its
> > > > follow-up fix merged into 10.0.1.
> > >
> > > If this is fixed in 10.0.1, do we even need to patch the kernel at
> > > all? Or can we just leave it be, considering most organizations using
> > > clang know what they're getting into? I'd personally prefer the
> > > latter, so that we don't clutter things.
> >
> > I agree: I'd rather this was fixed in 10.0.1 (but if we do want a
> > kernel-side work-around for 10.0.0, I would suggest doing the version
> > check in the Kconfig for FORTIFY_SOURCE instead of in the Makefile,
> > as that's where these things are supposed to live these days).
>
> Indeed this belongs in the Makefile. I can send a patch adjusting

er, Kconfig, is what I meant to type.

Return-Path: <SRS0=kY7N=DY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7648C43457
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Oct 2020 11:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BB1E2072D
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Oct 2020 11:02:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aOWznuCa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437541AbgJQLCj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Oct 2020 07:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437536AbgJQLCj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Oct 2020 07:02:39 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1122C0613D4
        for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2020 04:02:38 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id a4so5456933lji.12
        for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2020 04:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ryHcnFL3X2ubTpBi4U39WXt6C9kRreCQ/0huSf2L3do=;
        b=aOWznuCaQIlixDU6SOesCp6hl51I1s6KBDUb+jgvBaeife3h9N30l976G6IrkovzTQ
         FSIWj+wmSSx2kzywl0OajEnHOszeeqwksy0drW25QW6E0tqsJD4Qs53VdDkR0LoqUYxm
         rDoVg7ZYME194C3fODz2iU4P96FsjnkELXjqQy16AXZ4mBpFXdYcZWyo+fF33sL86Z3K
         9evbXoKZ+yEGX7TbxJmgjtyQvHdTJDj2ZNhfAU9l+E35NoqMjMSwmoS2YpVt7B3G8rM8
         IggfzkJlJ69uFBZD7IGI8u41HdWzXkHpW5AXjZynudtn7ekuNqQ3FOlqer1KlukwYjgC
         F3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ryHcnFL3X2ubTpBi4U39WXt6C9kRreCQ/0huSf2L3do=;
        b=hHe6j68/pqHD/Qg8cyz3JI6aoZKItkqOC6k614kJ7j8np2BmKjUbjnCyv70BSXMkY1
         tMxKP7Rf7WDoflDnh0U1pJGyNXlUOc+4SK1Stq/x0gcPReyagJpdbxTCLXal9EK5VxDV
         T3FlOP3lXkEFoiBSCxsuejaitSL99BrW0SK3rX3C3mfKJSwGIo3hPNqGgaO6pvq4RGWW
         wzVF/LP4bJOvtBaq65sVGKQnBAo3FaMuV4sloRFRKQ86zOz7idhgYcyw7KZYghgWlm9d
         7xLP4ArQbr/NAys+7fThS/XpC5RkVZhOMYURuEdP8zm4cF/xpiAWOiwFY6BvhTr599rE
         6eEQ==
X-Gm-Message-State: AOAM530zSFxpmYnU9mJPC1l+dlGTMhlw6Q5hlpTUC3OgcZDGU8QSjrGz
        CBbMkvwl+RfNxudjouVuPzzXlYIBuMQeSE10ZQcPvg==
X-Google-Smtp-Source: ABdhPJzEAJpkMmeWOAsIyaY5DQSRSQojEHMoHGdEt3bZzz+5k9SDt+ciMo/9jdZGqVTpXGdmFn57NiiVo2tLReq0cdY=
X-Received: by 2002:a2e:8816:: with SMTP id x22mr2949059ljh.377.1602932556614;
 Sat, 17 Oct 2020 04:02:36 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000014370305b1c55370@google.com> <202010162042.7C51549A16@keescook>
 <CACT4Y+bG=89ii+kzgGvNiZnB9ZEcAsy-3YofJeW5K_rynp_S7g@mail.gmail.com>
In-Reply-To: <CACT4Y+bG=89ii+kzgGvNiZnB9ZEcAsy-3YofJeW5K_rynp_S7g@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Sat, 17 Oct 2020 13:02:10 +0200
Message-ID: <CAG48ez0LKk7iEersZe-S25SGJm-AFVW2jzG32X=NkKon+1Fuxw@mail.gmail.com>
Subject: Re: UBSAN: array-index-out-of-bounds in alg_bind
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        syzbot <syzbot+92ead4eb8e26a26d465e@syzkaller.appspotmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-hardening@vger.kernel.org,
        Elena Petrova <lenaptr@google.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 17, 2020 at 12:50 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> On Sat, Oct 17, 2020 at 5:49 AM Kees Cook <keescook@chromium.org> wrote:
> > On Fri, Oct 16, 2020 at 01:12:24AM -0700, syzbot wrote:
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=92ead4eb8e26a26d465e
> > > [...]
> > > Reported-by: syzbot+92ead4eb8e26a26d465e@syzkaller.appspotmail.com
> > > [...]
> > > UBSAN: array-index-out-of-bounds in crypto/af_alg.c:166:2
> > > index 91 is out of range for type '__u8 [64]'
> >
> > This seems to be an "as intended", if very odd. false positive (the actual
> > memory area is backed by the on-stack _K_SS_MAXSIZE-sized sockaddr_storage
> > "address" variable in __sys_bind. But yes, af_alg's salg_name member
> > size here doesn't make sense.
>
> As Vegard noted elsewhere, compilers can start making assumptions
> based on absence of UB and compile code in surprising ways as the
> result leading to very serious and very real bugs.
>
> One example would be a compiler generating jump table for common sizes
> during PGO and leaving size > 64 as wild jump.
>
> Another example would be a compiler assuming that copy size <= 64.
> Then if there is another copy into a 64-byte buffer with a proper size
> check, the compiler can now drop that size check (since it now knows
> size <= 64) and we get real stack smash (for a copy that does have a
> proper size check before!).

FWIW, the kernel currently still has a bunch of places that use
C89-style length-1 arrays (which were in the past used to work around
C89's lack of proper flexible arrays). Gustavo A. R. Silva has a bunch
of patches pending to change those places now, but those are not
marked for stable backporting; so in all currently released kernels,
we'll probably keep having length-1 arrays at the ends of C structs
that are used as if they were flexible arrays. (Unless someone makes
the case that these patches are not just cleanups but actually fix
some sort of real bug, and therefore need to be backported.)

The code in this example looks just like one of those C89-style
length-1 arrays to me (except that the length isn't 1).

Of course I do agree that this should be cleaned up, and that having
bogus array lengths in the source code is a bad idea.

> And we do want compilers to be that smart today. Because of all levels
> of abstractions/macros/inlining we actually have lots of
> redundant/nonsensical code in the end after all inlining and
> expansions, and we do want compilers to infer things, remove redundant
> checks, etc so that we can have both nice abstract source code and
> efficient machine code at the same time.

I guess that kinda leads to the question: Do we just need to fix the
kernel code here (which is comparatively easy), or do you think that
this is a sufficiently big problem that we need to go and somehow
change the actual UAPI headers here (e.g. by deprecating the existing
UAPI struct and making a new one with a different name)?

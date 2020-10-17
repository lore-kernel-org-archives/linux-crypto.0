Return-Path: <SRS0=kY7N=DY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CFFC433DF
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Oct 2020 10:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76BDB20720
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Oct 2020 10:50:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Po3pnypk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411724AbgJQKuT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Oct 2020 06:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437411AbgJQKuS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Oct 2020 06:50:18 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F7AC0613D4
        for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2020 03:50:18 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id h140so3994928qke.7
        for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2020 03:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=055XhVIRqP1y92ksbeRYlOScnRv7buL/39+/wOdRWmc=;
        b=Po3pnypkJETwuaiQDhURNeD5V4DFZ+hAD8v5bMnK5CpIR198upQMrG9wMoIA6I1Wlq
         H1MvYarkmxPQEyEp0dXJArIcEldYcJxodnroi73Z8aSRx83RPsJYwL/1u1vCGyJJ5pVU
         VINV5Oi9oCr3pH9CLmw5bHedxbpibqH5pMH35ClZMEBt7tv7H5fj8Bl7OStEfO4rMFX4
         dD1spb06Z2C3ACNwaY/pWFCZ23Y2d6Hj1sMwpooVJPNPGB5PzjA5SO3IgsLEtfoF4xFN
         ETQ9AVpmNH4TUYLBRA1uPlT2z33MYdZn0ldeUxtw3lgpiFguldpuIDAW/LCLtISdC4fS
         4bIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=055XhVIRqP1y92ksbeRYlOScnRv7buL/39+/wOdRWmc=;
        b=SEOay6l5i7DPQTIGL8Ef7gn9+oSA6vVCidYJggpVUlFGMbgSDJ+E4wIqbHsICC3OIV
         511WbgndYvUHWjoK2+v8mkWGQ7z7txNAYH9q8kvxM0YAFn8Gi0lS4BGJzXTFsMYlll92
         lq04kysybI7L9HAicpu6rW2Q2l4zFi2SydWvs8bqijkrUADDgJgt6Y5FGpgz4EY1wiXC
         lOXD/1KzWxPuCXWOG7uQGPv7NF3Qi4Fh+Dgw2qOE3EMRem8MWL9UIdLHyal4Ng1TB69r
         8SxqBAuCof3Mda/VoW7vj9dWVUh7nTNUTe78NQZLPdB4r54mRuvQ0djOFEtAwR0pOgik
         5J1g==
X-Gm-Message-State: AOAM532wySse0JjlsIaTxEWmt1ifzV858ql0WQmFqPCpnSwaf8q/gDOh
        zJPbLaqiB8SdnGynSXxcLADwHOgt3yyA1sPjCEkKgg==
X-Google-Smtp-Source: ABdhPJxV3RXLH3GyiYBTqM9lre3tNUr3I5sMPtKZzoumySL+QLXDeoTsyj5EPEiy1paknIIPanyVGa+0Di2Di0LJ1yY=
X-Received: by 2002:a05:620a:1657:: with SMTP id c23mr8237965qko.231.1602931816990;
 Sat, 17 Oct 2020 03:50:16 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000014370305b1c55370@google.com> <202010162042.7C51549A16@keescook>
In-Reply-To: <202010162042.7C51549A16@keescook>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 17 Oct 2020 12:50:05 +0200
Message-ID: <CACT4Y+bG=89ii+kzgGvNiZnB9ZEcAsy-3YofJeW5K_rynp_S7g@mail.gmail.com>
Subject: Re: UBSAN: array-index-out-of-bounds in alg_bind
To:     Kees Cook <keescook@chromium.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        syzbot <syzbot+92ead4eb8e26a26d465e@syzkaller.appspotmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-hardening@vger.kernel.org,
        Elena Petrova <lenaptr@google.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 17, 2020 at 5:49 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Oct 16, 2020 at 01:12:24AM -0700, syzbot wrote:
> > dashboard link: https://syzkaller.appspot.com/bug?extid=92ead4eb8e26a26d465e
> > [...]
> > Reported-by: syzbot+92ead4eb8e26a26d465e@syzkaller.appspotmail.com
> > [...]
> > UBSAN: array-index-out-of-bounds in crypto/af_alg.c:166:2
> > index 91 is out of range for type '__u8 [64]'
>
> This seems to be an "as intended", if very odd. false positive (the actual
> memory area is backed by the on-stack _K_SS_MAXSIZE-sized sockaddr_storage
> "address" variable in __sys_bind. But yes, af_alg's salg_name member
> size here doesn't make sense.

As Vegard noted elsewhere, compilers can start making assumptions
based on absence of UB and compile code in surprising ways as the
result leading to very serious and very real bugs.

One example would be a compiler generating jump table for common sizes
during PGO and leaving size > 64 as wild jump.

Another example would be a compiler assuming that copy size <= 64.
Then if there is another copy into a 64-byte buffer with a proper size
check, the compiler can now drop that size check (since it now knows
size <= 64) and we get real stack smash (for a copy that does have a
proper size check before!).

And we do want compilers to be that smart today. Because of all levels
of abstractions/macros/inlining we actually have lots of
redundant/nonsensical code in the end after all inlining and
expansions, and we do want compilers to infer things, remove redundant
checks, etc so that we can have both nice abstract source code and
efficient machine code at the same time.


> The origin appears to be that 3f69cc60768b
> ("crypto: af_alg - Allow arbitrarily long algorithm names") intentionally
> didn't extend the kernel structure (which is actually just using the UAPI
> structure). I don't see a reason the UAPI couldn't have been extended:
> it's a sockaddr implementation, so the size is always passed in as part
> of the existing API.
>
> At the very least the kernel needs to switch to using a correctly-sized
> structure: I expected UBSAN_BOUNDS to be enabled globally by default at
> some point in the future (with the minimal runtime -- the
> instrumentation is tiny and catches real issues).
>
> Reproduction:
>
> struct sockaddr_alg sa = {
>     .salg_family = AF_ALG,
>     .salg_type = "skcipher",
>     .salg_name = "cbc(aes)"
> };
> fd = socket(AF_ALG, SOCK_SEQPACKET, 0);
> bind(fd, (void *)&sa, sizeof(sa));
>
> Replace "sizeof(sa)" with x where 64<x<=128.
>
> --
> Kees Cook
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/202010162042.7C51549A16%40keescook.

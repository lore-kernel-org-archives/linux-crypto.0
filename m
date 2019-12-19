Return-Path: <SRS0=xTm+=2J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5660C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 10:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA934227BF
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 10:42:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FWGpE+/t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfLSKmw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Dec 2019 05:42:52 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37787 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfLSKmw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Dec 2019 05:42:52 -0500
Received: by mail-qk1-f196.google.com with SMTP id 21so4265792qky.4
        for <linux-crypto@vger.kernel.org>; Thu, 19 Dec 2019 02:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TIJoAL5csx0AH4gB66J6qIB3eLqxZFfBPv363NryzWs=;
        b=FWGpE+/tATqsqoZhk4l/cJS3y5dgDzxaD16oz9r2KsraAID77vrBQFp6MJiPSLPaL0
         oY3Fq6R3LDIldJq3TnQw+39pNsIiso1cNmOVoa3KemvXixxLbUW49wIOg/KMNs+9JGk4
         pe6QEFUgk4NnxTrBnRn8dTGRjsooqDrSwV7PoHtc4Y3svj0PbGCLd1d33hlFTAdsgX0e
         LSOh2AuJi5YpV9/4clDFF/7uKx5CbBfXX2sQyOJ88zWpYv+d+KNeoDsqWRys+kJB0x6F
         Zu4PgJtbfcYZbslfN5r12sYdh/cXod2sGvBl2N0wTnsMZ+cNa97wd9ZmKcgCKGr3fD6/
         0d6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TIJoAL5csx0AH4gB66J6qIB3eLqxZFfBPv363NryzWs=;
        b=K7rUi6w7WSigG8pA71egAXOT0Su/DxCp2X2nax7vSq6YN4MXY6c5EpXm4sJgzYHNvA
         rpI5C+ZQ/l2q7mutb7fz7FgDRXFHzo6nhngtNr2RkhfjMReevx5og76iMdE5P8S48t6H
         QwIx9h1TAZoY+Trpjjkr8GwmA6h8zPmH+JotGSIJFFmXjt+UU3yCUA5CLHbfRHxIcrin
         3HfjgoCkQ0RauNvpG8TGS56EA4sTjmG4FJ6fj0WhUiFgL/INIJAU+OZ0qpOLgn1stkl6
         R+GjK2I1lCqEa2DAV5riNRnD+IXf9Boe2Ds/GdcsCgSLWKfvrykQZmouWzUi9hOBoPjq
         e+9g==
X-Gm-Message-State: APjAAAV05xV/H75ChH2XFjGiRg2pTBenFcXP4aM/Fpd90qpiDC4bW6Eq
        3hAlSiFcFVvUW5vkcv/aOKDapBr5pWiCXcPgvFa93Q==
X-Google-Smtp-Source: APXvYqw/yNawVnJ0g/UoZK4sjZJEHIQt2stccVEGiGHGtRLqhjXr4s7hTjInKYxTRBRNf6xwo9D1pmq14OCcP13kjqk=
X-Received: by 2002:ae9:e50c:: with SMTP id w12mr6739925qkf.407.1576752170800;
 Thu, 19 Dec 2019 02:42:50 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com> <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
In-Reply-To: <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 19 Dec 2019 11:42:39 +0100
Message-ID: <CACT4Y+Zs=SQwYS8yx3ds7HBhr1RHkDwRe_av2XjJty-5wMTFEA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: WireGuard secure network tunnel
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 19, 2019 at 11:07 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Dec 19, 2019 at 10:35 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > Is this precise enough for race
> > > condition bugs?
> >
> > It's finding lots of race conditions provoked bugs (I would say it's
> > the most common cause of kernel bugs).
>
> I meant -- are the reproducers it makes precise enough to retrigger
> network-level race conditions?

We provide a simple invariant: if it claims a reproducer, it was able
to provide the exact reported crash using that exact program on a
freshly booted kernel.
However, the crash may be reproducible on the first iteration, or may
require running it for a few seconds/minutes. And obviously for race
conditions the rate on your machine may be different (in both
directions) from the rate on the syzbot machine.
Reproducers don't try to fix the exact execution (generally not
feasible), instead they are just threaded stress tests with some
amount of natural randomness is execution. But as I notes, it was able
to trigger that exact crash using that exact program.

A shorter version: it's good enough to tr-trigger lots of race conditions.



> > Well, you are missing that wireguard is not the only subsystem
> > syzkaller tests (in fact, it does not test it at all) and there are
> > 3000 other subsystems :)
>
> Oooo! Everything is tested at the same time. I understand now; that
> makes a lot more sense.

Yes, it's generally whole kernel. Partitioning it into 3000 separate
instances is lots of problems on multiple fronts and in the end it's
not really possible to draw strict boundaries, in end whole kernel is
tied via mm/fs/pipes/splice/vmslice/etc. E.g. what if you vmsplice
some device-mapped memory into wireguard using io_uring and setup some
bpf filter somewhere and ptrace it at the same time while sending a
signal? :)


> I'll look into splitting out the option, as you've asked. Note,
> though, that there are currently only three spots that have the "extra
> checks" at the moment, and one of them can be optimized out by the
> compiler with aggressive enough inlining added everywhere. The other
> two will result in an immediately corrupted stack frame that should be
> caught immediately by other things. So for now, I think you can get
> away with turning the debug option off, and you won't be missing much
> from the "extra checks", at least until we add more.

I see. Maybe something to keep in mind for future.

> That's exciting about syzcaller having at it with WireGuard. Is there
> some place where I can "see" it fuzzing WireGuard, or do I just wait
> for the bug reports to come rolling in?

Well, unfortunately it does not test wireguard at the moment. I've
enabled the config as I saw it appeared in linux-next:
https://github.com/google/syzkaller/commit/240ba66ba8a0a99f27e1aac01f376331051a65c2
but that's it for now.
There are 3000 subsystems, are you ready to describe precise interface
for all of them with all the necessary setup and prerequisites? Nobody
can do it for all subsystems. Developer of a particular subsystem is
the best candidate for also describing what it takes to test it ;)

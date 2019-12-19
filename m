Return-Path: <SRS0=xTm+=2J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7FFC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 09:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC88424685
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 09:35:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RhZ4L+Xe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfLSJfa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Dec 2019 04:35:30 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:38165 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfLSJfa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Dec 2019 04:35:30 -0500
Received: by mail-qv1-f65.google.com with SMTP id t6so1966450qvs.5
        for <linux-crypto@vger.kernel.org>; Thu, 19 Dec 2019 01:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i3kinH9BKdcFWrmC53cr2rYC6iVhtIiNy5b7BJBTamU=;
        b=RhZ4L+XeesMX8bq4b7b4SjjJMIzYqW/kFA+aLP/E/omYTcpkyqrnaTSkIjYfnrC+j3
         Yu6QyJHygnNWgDy52rLc3Eh/goTp18pB1gv9G9C4WcM+mz+/8seuKGe5dwZ0ysIXekxD
         glDiT2rNr+LAgopPqiO0qLmlJ+vQ/FWNrQ6Oc6dHGrNQmZlu83rt2/ris1BRWkMzWbuV
         SuZoS5+E+tyGeGWAcOT6JApeE3sUyo3swp0HgZCvlT5gQyXCv89Kc5kHhbWNvxg4KaeR
         UkeCd56nvBhCCmUvgqcOdGB2XnVDvU1LIPPyAfx/JkAdgn4QE+WuguxvpCmcT4rhgA+3
         OD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i3kinH9BKdcFWrmC53cr2rYC6iVhtIiNy5b7BJBTamU=;
        b=di8uEyBeptZtr1sfAeSM8kHM+qdLy1+hRPrDvI1pP5+/P6yZvJodulKrj6CRh/+xjy
         hr8/Xcx9NSbnFOywCJxaiUru9apirSB0vX8EMybU8Fn3mOpq8f39mzvXUK1Fcp8aF6X7
         SjZJJo2PcUcoJ0b+Y2lxjIDnUQQM+RAdpW3EiLEU8VnzYVW5/TCpFEa9RnSKZ4R2gtVZ
         KI1HEI9/ZaJd8NXZzBO+yaYJix2lzPx4Yszs8qRkSwPly1m5XHMfceNyOTg4UQDtJHOA
         ONKfjHI4s/CBNYnYZJiIkqaSJi+rp8ZssJ1HjmZXmUeRZvMRP8RTYiRTbdCtinYSVlm9
         zTOw==
X-Gm-Message-State: APjAAAX2Kusel0/McYgZKtaFmPMV3NoCWexSXX7VDtfeECQOZ6iSm5Vn
        VxrNxuBz4DRSZJxmO+vo/40sS7G3RjatbW6BxM5sTg==
X-Google-Smtp-Source: APXvYqy6Yj7NLDWm5gkYIu8GE7GppWwnrEdh9KUENE1GXmBiReYe5mDSw8lgNZtD5WJAiQ4gh3ZGTlod9wsiTweaUJI=
X-Received: by 2002:a0c:c351:: with SMTP id j17mr6777104qvi.80.1576748128716;
 Thu, 19 Dec 2019 01:35:28 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com> <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
In-Reply-To: <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 19 Dec 2019 10:35:17 +0100
Message-ID: <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
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

On Wed, Dec 18, 2019 at 12:50 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Dmitry,
>
> On Wed, Dec 18, 2019 at 12:37 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > Actually with WireGuard, I think that's not the case. The WireGuard
> > > logging has been written with DoS in mind. You /should/ be able to
> > > safely run it on a production system exposed to the wild Internet, and
> > > while there will be some additional things in your dmesg, an attacker
> > > isn't supposed to be able to totally flood it without ratelimiting or
> > > inject malicious strings into it (such as ANSI escape sequence). In
> > > other words, I consider the logging to be fair game attack surface. If
> > > your fuzzer manages to craft some nasty sequence of packets that
> > > tricks some rate limiting logic and lets you litter all over dmesg
> > > totally unbounded, I'd consider that a real security bug worth
> > > stressing out about. So from the perspective of letting your fuzzers
> > > loose on WireGuard, I'd actually like to see this option kept on.
> >
> > This is the case even with CONFIG_WIREGUARD_DEBUG turned on, right? Or without?
>
> Turned on.
>
> > Well, it may be able to trigger unbounded printing, but that won't be
> > detected as a bug and won't be reported. To be reported it needs to
> > fall into a set of predefined bug cases (e.g. "BUG:" or "WARNING:" on
> > console). Unless of course it triggers total stall/hang.
>
> Bummer. Well, at least the stall case is interesting.
>
> > But I'm
> > afraid it will just dirty dmesg, make reading crashes harder and slow
> > down everything without benefit.
>
> Actually the point of the logging is usually to make it more obvious
> why a crash has come about, to provide some trail about the sequence
> of events. This was especially helpful in fixing old race conditions
> where subtle packet timing caused WireGuard's timer-based state
> machine to go haywire. Is syzkaller able to backtrack from crashes to
> the packets and packet timing that caused them, in order to make a
> test case to replay the crash?

Sometimes. You may sort by "Repro" column here to get the ratio:
https://syzkaller.appspot.com/upstream
https://syzkaller.appspot.com/upstream/fixed

> Is this precise enough for race
> condition bugs?

It's finding lots of race conditions provoked bugs (I would say it's
the most common cause of kernel bugs).

> If so, then when debugging the crashes I could always
> replay it later with logging turned on, in which case it might make
> sense to split out the debug logging into CONFIG_WIREGUARD_VERBOSE_LOG
> or similar (unless the logging itself changes the timing constraints
> and I can't repro that way). If this isn't possible, then it seems
> like logging might be something we would benefit from having in the
> crash reports, right? Or am I missing some other detail of how the
> system works?

Well, you are missing that wireguard is not the only subsystem
syzkaller tests (in fact, it does not test it at all) and there are
3000 other subsystems :)
If we enable verbose debug logging for all of them, we will get storm
of output and the wireguard logging you are interested in may simply
be evicted from the 1MB buffer. Also, the expected case is that a
program does not crash, in that case we waste performance for
unnecessary logging (and not finding bugs because of that).

In some cases there are reproducers, in some cases a bug is trivial to
debug based on the crash report (no tracing needed).

But additional debug checks are useful in any testing.

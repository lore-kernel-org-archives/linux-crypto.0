Return-Path: <SRS0=NTKo=2I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011B0C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 11:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4BBD24650
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 11:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aRf4sMeW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLRLho (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Dec 2019 06:37:44 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43133 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfLRLhn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Dec 2019 06:37:43 -0500
Received: by mail-qk1-f195.google.com with SMTP id t129so1238884qke.10
        for <linux-crypto@vger.kernel.org>; Wed, 18 Dec 2019 03:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+M8i39/jB6Cqau0xv7tzu7ie7N03vkjz45ADcmxSd0=;
        b=aRf4sMeWzpadW5YJrmob5NdYi06W4xs5sug9fKJBjCXVsXaWQTyeKCMHdYNRW4gUir
         o2k89xJ7NsawicDftFZF0m4Ydmc7VvW+wymYJJFcE2SA+28K7kUDG+s8NjIwJv8cA0PV
         RA3WKgbFfPQGjv62mEKfn16vDFaNdFOjC5VzPQh82/dIAsYQSupfL/Z437nK6PumzOPF
         +h+x6ROL/EONo82GvI6fAxLNWsZb0cEEmfUi3Kg1+v5RoNJbszmIjfgQUTQBMvmPpRU5
         mZ1Opk9FCvaWvglpbvXKaK4Qh6GF5guLxxq3DCKPIsFn5/BA0HwFiBtolnHtqM0xEge4
         h2uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+M8i39/jB6Cqau0xv7tzu7ie7N03vkjz45ADcmxSd0=;
        b=IHU+Va756EAVcdj/FN54VDojyl5kg35HcznzwvcFE3WcMD8Fv75sTpLky6j9CUlAj1
         wVKJoZeHwC9pNzK1D04MDnIrXgPG0AVc6MUXPkWK3d3w+vLwG+8EHjGHsGpzk1qjgPhN
         wzLbb/KtiH7m+/4zcsqfS0ECR9zJfbHOYAYQotvw1yanzdbmWFFo6pI673Rfihrwq6VZ
         qVCycQk/9BX1b4IWFUsf2TGO9m9sVLE49BRZ5KX+XGu1+xghb1lroL934zrgUErOGO64
         CWO6UEtN9U1LDwvczQ2xajelZd+raaEIkZgoM2Dr12GzWGsf9zjJKy0K5MbBMO+WqFwq
         trwQ==
X-Gm-Message-State: APjAAAUNHHUm6bFEe8GuNvBdkfBusFlDsCESwfJ/YGPjEepuOz2Gok05
        0aqBKlxQrKk32F/q2eThN9aNIMJBrUvgSZXJ0RZ15Q==
X-Google-Smtp-Source: APXvYqyKK+FDzDrpsx/z+doLr55we/uUU5vCPbMr4o16ebJXWlTeSoCgL+oyXSSiJUasHPhtkAICWMChBnTXKRzBoGQ=
X-Received: by 2002:a05:620a:1136:: with SMTP id p22mr1987714qkk.8.1576669062422;
 Wed, 18 Dec 2019 03:37:42 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
In-Reply-To: <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 18 Dec 2019 12:37:30 +0100
Message-ID: <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
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

On Wed, Dec 18, 2019 at 11:57 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Dmitry,
>
> On Wed, Dec 18, 2019 at 11:13 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > Does it really do "verbose debug log"? I only see it is used for
> > self-tests and debug checks:
>
> Yes, it does, via net_dbg and co. People with the Linux "dynamic
> debugging" feature turned also get the log by twiddling with some file
> at runtime.
>
> > In different contexts one may enable different sets of these.
> > In particular in fuzzing context one absolutely wants additional debug
> > checks, but not self tests and definitely no verbose logging. CI and
> > various manual scenarios will require different sets as well.
> > If this does verbose logging, we won't get debug checks as well during
> > fuzzing, which is unfortunate.
> > Can make sense splitting CONFIG_WIREGUARD_DEBUG into 2 or 3 separate
> > configs (that's what I see frequently). Unfortunately there is no
> > standard conventions for anything of this, so CIs will never find your
> > boot tests and fuzzing won't find the additional checks...
>
> I agree that it might make sense to split this up at some point, but
> for now I think it might be a bit overkill. Both the self-tests and
> debug tests are *very* light at the moment. Down the road if these
> become heavier, I think it'd probably be a good idea, but for the time
> being it'd mostly be more complexity for nothing.
>
> Another more interesting point, though, you wrote
> > and definitely no verbose logging.
>
> Actually with WireGuard, I think that's not the case. The WireGuard
> logging has been written with DoS in mind. You /should/ be able to
> safely run it on a production system exposed to the wild Internet, and
> while there will be some additional things in your dmesg, an attacker
> isn't supposed to be able to totally flood it without ratelimiting or
> inject malicious strings into it (such as ANSI escape sequence). In
> other words, I consider the logging to be fair game attack surface. If
> your fuzzer manages to craft some nasty sequence of packets that
> tricks some rate limiting logic and lets you litter all over dmesg
> totally unbounded, I'd consider that a real security bug worth
> stressing out about. So from the perspective of letting your fuzzers
> loose on WireGuard, I'd actually like to see this option kept on.

This is the case even with CONFIG_WIREGUARD_DEBUG turned on, right? Or without?

Well, it may be able to trigger unbounded printing, but that won't be
detected as a bug and won't be reported. To be reported it needs to
fall into a set of predefined bug cases (e.g. "BUG:" or "WARNING:" on
console). Unless of course it triggers total stall/hang. But I'm
afraid it will just dirty dmesg, make reading crashes harder and slow
down everything without benefit. O(1) output per test is generally not
OK in heavy stressing scenario, even if it's overall bounded and rate
limited.

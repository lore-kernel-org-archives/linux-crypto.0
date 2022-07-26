Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED85C00140
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 16:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiGZQvQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 12:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239220AbiGZQvQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 12:51:16 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C2863C1
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 09:51:15 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id w204so17742704oie.7
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 09:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wxzv/E+UaR2pmMOlye+KVg27MhKJv4mjPxrciwoZWQs=;
        b=llH6sggjdXZyQd02xSh5FKxh89JH9Z1dfE8gLo/c5Sihe4ItHLHGLKYc57+vjdgIae
         bzxnS6MmEY4SF4zoud7o47vZaBeNUI/2bT1gsbmiecoJ/s7DWxWcCjETESZSwsthEVuD
         K/dL0hGftznRZCWuV+piEsat5oCA2ussY9bWj+gVtAIxAzFee92a+EuwRouRtMRQkqoS
         R0lWVVE+MsqXvScHe2jtzdR/o9vwP/db4LYLRdA5wqhlkcE9q4Wfog84zsmbH6W2bunF
         l3hsgntQfOEBDrP4qgVV8L1lTMHLCcQwQspu9s4nuujrMGQgAWf2SQB2v8NH0v3lVWZb
         X4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wxzv/E+UaR2pmMOlye+KVg27MhKJv4mjPxrciwoZWQs=;
        b=5iT0RvPZ0Mb2SkIS04xNPiYBIXC5CJViCzloJluo1A0iGFNZw729YZitmKMsuuFp53
         A/GGSHPu5KX/rWTZ38sv8QLOOKCdR5gArkwb2IiLwkWuSdHlhEUqTES0ItjMebQsOs36
         B5W75egE9QoZOcZ/tpQIaFjgIZ9aaRBGkXA9e4Vb3ZcB9kQSkpAkQGYJudMAqGzsQGHU
         zl9SG8cyFP+jXuwEMR8qmSu17ZHe+kqWBM0+7HI116QdhoPYxX5FmYbmsWSDXdrFNceF
         oG7MfRn2K5DQDLlAZVUKUJ2GKV08GZTV1c/UhH0XYbgVIxzoUstnFjlYOJ1TDyyK+DJa
         cX1w==
X-Gm-Message-State: AJIora+CT1JfvNcOUX2kRoGahdV5q9SJ8Hj/kAda+2ZGMwcZKwnxoN5S
        B3eVqtESSHMLFA/PEw/dnKGmdeNHNGZTDSENRUI=
X-Google-Smtp-Source: AGRyM1vsuJ1rPiAGi4kZGlsA7p5B2rHWEPTLlj2r4WK04VfTO9wTQfARPgny53bX/mPo/7HGlwQHqTHjh/lpBtQgHlU=
X-Received: by 2002:aca:3946:0:b0:33a:7585:494b with SMTP id
 g67-20020aca3946000000b0033a7585494bmr69073oia.164.1658854274546; Tue, 26 Jul
 2022 09:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220725225728.824128-1-Jason@zx2c4.com> <20220725232810.843433-1-Jason@zx2c4.com>
 <CAMdZqKH=9mDhoW_gpL-pUEQAGuN=orc1doudyAuHdoPc7O53RQ@mail.gmail.com> <Yt/EySjdJjYW/EcB@zx2c4.com>
In-Reply-To: <Yt/EySjdJjYW/EcB@zx2c4.com>
From:   Mark Harris <mark.hsj@gmail.com>
Date:   Tue, 26 Jul 2022 09:51:03 -0700
Message-ID: <CAMdZqKGzhajnb5ejypnPFanJ2E=4Pk_96x8FAAShttvnrRenfQ@mail.gmail.com>
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason A. Donenfeld wrote:
> On Mon, Jul 25, 2022 at 06:10:06PM -0700, Mark Harris wrote:
> > Jason A. Donenfeld wrote:
> > > +      l = __getrandom_nocancel (p, n, 0);
> > > +      if (l > 0)
> > > +       {
> > > +         if ((size_t) l == n)
> > > +           return; /* Done reading, success. */
> > > +         p = (uint8_t *) p + l;
> > > +         n -= l;
> > > +         continue; /* Interrupted by a signal; keep going. */
> > > +       }
> > > +      else if (l == 0)
> > > +       arc4random_getrandom_failure (); /* Weird, should never happen. */
> > > +      else if (errno == ENOSYS)
> > > +       {
> > > +         have_getrandom = false;
> > > +         break; /* No syscall, so fallback to /dev/urandom. */
> > > +       }
> > > +      arc4random_getrandom_failure (); /* Unknown error, should never happen. */
> >
> > Isn't EINTR also possible?  Aborting in that case does not seem reasonable.
>
> Not in current kernels, where it always returns at least PAGE_SIZE bytes
> before checking for pending signals. In older kernels, if there was a
> signal pending at the top, it would do no work and return -ERESTARTSYS,
> which I believe should then get restarted by glibc's syscaller? I might
> be wrong about how restarts work though, so if you know better, please
> let me know. TEMP_FAILURE_RETRY relies on errno, so that's not what we
> want. I guess I can just add a case for it.
>
> > Also the __getrandom_nocancel function does not set errno on Linux; it
> > just returns INTERNAL_SYSCALL_CALL (getrandom, buf, buflen, flags).
> > So unless that is changed, it doesn't look like this ENOSYS check will
> > detect old Linux kernels.
>
> Thanks. It looks like INTERNAL_SYSCALL_CALL just returns the errno as-is
> as a return value, right? I'll adjust the code to account for that.

Yes INTERNAL_SYSCALL_CALL just returns the negated errno value that it
gets from the Linux kernel, but only on Linux does
__getrandom_nocancel use that.  The Hurd and generic implementations
set errno on error.  Previously the only call to this function did not
care about the specific error value so it didn't matter.  Since you
are now using the error value in generic code, __getrandom_nocancel
should be changed on Linux to set errno like most other _nocancel
calls, and then it should go back to checking errno here.

And as Adhemerval mentioned, you only added a Linux implementation of
__ppoll_infinity_nocancel, but are calling it from generic code.

Also, by the way your patches cc'd directly to me get quarantined
because DKIM signature verification failed.  The non-patch messages
pass DKIM and are fine.



 - Mark

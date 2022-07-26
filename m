Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBADC43334
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 10:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238483AbiGZKlW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 06:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiGZKlV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 06:41:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81886E0F1
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 03:41:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A419B812A2
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 10:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631C9C341C0;
        Tue, 26 Jul 2022 10:41:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="h/n1pjMJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658832075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s5T7GLuLEawFWgu0Mrm68OBBezaPyZ8IkeuWW81SFHc=;
        b=h/n1pjMJedGhQPGsBbzcJJwlGt/cWArUG/rvHGdZbtCE4jnhf64bJ2WYc/YNLXOfdVwg8K
        Re5WMVRccu8IDj7uQicPMhGgSIhz/6YBp14ae4m0Rg0ffDqDnWAqT6Rk7PQ7d+xcKOSr6d
        lzYegFb8a1Zw+ZxijkwqQnf1xx1IcwM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5d45f5c3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 10:41:15 +0000 (UTC)
Date:   Tue, 26 Jul 2022 12:41:13 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Mark Harris <mark.hsj@gmail.com>
Cc:     libc-alpha@sourceware.org, Florian Weimer <fweimer@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Message-ID: <Yt/EySjdJjYW/EcB@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <CAMdZqKH=9mDhoW_gpL-pUEQAGuN=orc1doudyAuHdoPc7O53RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMdZqKH=9mDhoW_gpL-pUEQAGuN=orc1doudyAuHdoPc7O53RQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Mark,

On Mon, Jul 25, 2022 at 06:10:06PM -0700, Mark Harris wrote:
> Jason A. Donenfeld wrote:
> > +      l = __getrandom_nocancel (p, n, 0);
> > +      if (l > 0)
> > +       {
> > +         if ((size_t) l == n)
> > +           return; /* Done reading, success. */
> > +         p = (uint8_t *) p + l;
> > +         n -= l;
> > +         continue; /* Interrupted by a signal; keep going. */
> > +       }
> > +      else if (l == 0)
> > +       arc4random_getrandom_failure (); /* Weird, should never happen. */
> > +      else if (errno == ENOSYS)
> > +       {
> > +         have_getrandom = false;
> > +         break; /* No syscall, so fallback to /dev/urandom. */
> > +       }
> > +      arc4random_getrandom_failure (); /* Unknown error, should never happen. */
> 
> Isn't EINTR also possible?  Aborting in that case does not seem reasonable.

Not in current kernels, where it always returns at least PAGE_SIZE bytes
before checking for pending signals. In older kernels, if there was a
signal pending at the top, it would do no work and return -ERESTARTSYS,
which I believe should then get restarted by glibc's syscaller? I might
be wrong about how restarts work though, so if you know better, please
let me know. TEMP_FAILURE_RETRY relies on errno, so that's not what we
want. I guess I can just add a case for it.

> Also the __getrandom_nocancel function does not set errno on Linux; it
> just returns INTERNAL_SYSCALL_CALL (getrandom, buf, buflen, flags).
> So unless that is changed, it doesn't look like this ENOSYS check will
> detect old Linux kernels.

Thanks. It looks like INTERNAL_SYSCALL_CALL just returns the errno as-is
as a return value, right? I'll adjust the code to account for that.

> > +      struct pollfd pfd = { .events = POLLIN };
> > +      pfd.fd = TEMP_FAILURE_RETRY (
> > +         __open64_nocancel ("/dev/random", O_RDONLY | O_CLOEXEC | O_NOCTTY));
> > +      if (pfd.fd < 0)
> > +       arc4random_getrandom_failure ();
> > +      if (__poll (&pfd, 1, -1) < 0)
> > +       arc4random_getrandom_failure ();
> > +      if (__close_nocancel (pfd.fd) < 0)
> > +       arc4random_getrandom_failure ();
> 
> The TEMP_FAILURE_RETRY handles EINTR on open, but __poll can also
> result in EINTR.

Thanks. I'll surround the __poll in TEMP_FAILURE_RETRY.

Thank you for the review! v3 will have the above changes.

Jason

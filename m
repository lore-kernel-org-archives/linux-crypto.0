Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC3CC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 11:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbiGZLEd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiGZLEd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 07:04:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306372F64B
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 04:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5C58B811C5
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 11:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89B8C341C0;
        Tue, 26 Jul 2022 11:04:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jdPdZN3i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658833467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g2RgjLln+xJNTK52Wm9pWE8jo2IoA4T7LjlDVKu/LMI=;
        b=jdPdZN3irEWzI080wFpQAjuFadRXbl7f8c358SDNn5pgmT0QuybLMIAM+7QW8eo5VBgPWb
        R0KvtVVWurYuN8me5fyRgWws2CI09ZtNVY/bOabK6KI0pc5VuCeAQ8gMojS1qIhGHPCd9a
        T4RjpvjaSbJACAdrv0rijG+Wq33D/qs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fbf47f6c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 11:04:27 +0000 (UTC)
Date:   Tue, 26 Jul 2022 13:04:25 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     libc-alpha@sourceware.org,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Message-ID: <Yt/KOQLPSnXFPtWH@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <87k080i4fo.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87k080i4fo.fsf@oldenburg.str.redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Florian,

On Tue, Jul 26, 2022 at 11:55:23AM +0200, Florian Weimer wrote:
> * Jason A. Donenfeld:
> 
> > +      pfd.fd = TEMP_FAILURE_RETRY (
> > +	  __open64_nocancel ("/dev/random", O_RDONLY | O_CLOEXEC | O_NOCTTY));
> > +      if (pfd.fd < 0)
> > +	arc4random_getrandom_failure ();
> > +      if (__poll (&pfd, 1, -1) < 0)
> > +	arc4random_getrandom_failure ();
> > +      if (__close_nocancel (pfd.fd) < 0)
> > +	arc4random_getrandom_failure ();
> 
> What happens if /dev/random is actually /dev/urandom?  Will the poll
> call fail?

Yes. I'm unsure if you're asking this because it'd be a nice
simplification to only have to open one fd, or because you're worried
about confusion. I don't think the confusion problem is one we should
take too seriously, but if you're concerned, we can always fstat and
check the maj/min. Seems a bit much, though.

> I think we need a no-cancel variant of poll here, and we also need to
> handle EINTR gracefully.

Thanks for the note about poll nocancel. I'll try to add this. I don't
totally know how to manage that pluming, but I'll give it my best shot.

> Performance-wise, my 1000 element shuffle benchmark runs about 14 times
> slower without userspace buffering.  (For comparison, just removing
> ChaCha20 while keeping a 256-byte buffer makes it run roughly 25% slower
> than current master.)  Our random() implementation is quite slow, so
> arc4random() as a replacement call is competitive.  The unbuffered
> version, not so much.

Yes, as mentioned, this is slower. But let's get something down first
that's *correct*, and then after we can start optimizing it. Let's not
prematurely optimize and create a problematic function that nobody
should use.

> Running the benchmark, I see 40% of the time spent in chacha_permute in
> the kernel, that is really quite odd.  Why doesn't the system call
> overhead dominate?

Huh, that is interesting. I guess if you're reading 4 bytes for an
integer, it winds up computing a whole chacha block each time, with half
of it doing fast key erasure and half of it being returnable to the
caller. When we later figure out a safer way to buffer, ostensibly this
will go away. But for now, we really should not prematurely optimize.

I'll have v3 out shortly with your suggested fixes.

Jason

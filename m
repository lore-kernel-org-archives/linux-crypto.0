Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6B4C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 11:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238816AbiGZLUm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238802AbiGZLUm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 07:20:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0925659B
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 04:20:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91507B81132
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 11:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9839C341C0;
        Tue, 26 Jul 2022 11:20:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Um4Kj6DL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658834435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sgPLwnfqIoDJuqj62sgNc5ELkrRNJRohBSBVnJ3v92Y=;
        b=Um4Kj6DLEJXmdcsBSMqQcJo+yK5sPlD2Pwq3gaRrkgqTr1eYNGTq+EQUFMfs+8iHKm/C7Z
        fFSYAiQr6zOZgdGIZOh1ta9AGDxb8uRTyMMWSMrrx2fLG5Q8RqS07pA4nbG1NyJ4ROX+LX
        QuDHRLZe4UufTeFJj4hAOJuq4Ftd4/8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 84e37221 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 26 Jul 2022 11:20:35 +0000 (UTC)
Date:   Tue, 26 Jul 2022 13:20:33 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     libc-alpha@sourceware.org,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
Message-ID: <Yt/OAZH0iX/0lj89@zx2c4.com>
References: <20220725225728.824128-1-Jason@zx2c4.com>
 <20220725232810.843433-1-Jason@zx2c4.com>
 <87k080i4fo.fsf@oldenburg.str.redhat.com>
 <Yt/KOQLPSnXFPtWH@zx2c4.com>
 <877d40i0v7.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <877d40i0v7.fsf@oldenburg.str.redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Florian,

On Tue, Jul 26, 2022 at 01:12:28PM +0200, Florian Weimer wrote:
> >> What happens if /dev/random is actually /dev/urandom?  Will the poll
> >> call fail?
> >
> > Yes. I'm unsure if you're asking this because it'd be a nice
> > simplification to only have to open one fd, or because you're worried
> > about confusion. I don't think the confusion problem is one we should
> > take too seriously, but if you're concerned, we can always fstat and
> > check the maj/min. Seems a bit much, though.
> 
> Turning /dev/random into /dev/urandom (e.g. with a symbolic link) used
> to be the only way to get some applications working because they tried
> to read from /dev/random at a higher rate than the system was estimating
> entropy coming in.  We may have to do something differently here if the
> failing poll causes too much breakage.

The "backup plan" would be to sleep-loop-read /proc/sys/kernel/random/entropy_avail
until it passes a certain threshold one time. This might also work on even older
kernels than the poll() trick. But that's pretty darn ugly, so it's not
obvious to me where the cut-off in frustration is, when we throw our
hands up and decide the ugliness is worth it compared to whatever
problems we happen to be facing at the time with the poll() technique.
But at least there is an alternative, should we need it.

Jason

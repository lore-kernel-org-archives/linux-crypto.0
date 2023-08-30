Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6072CC83F22
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Aug 2023 18:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbjH3Snz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243734AbjH3Lhv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2023 07:37:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2030F4
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 04:37:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3879C61456
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 11:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FA3C433C8;
        Wed, 30 Aug 2023 11:37:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mLRxTAV5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1693395463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L27v8IkqK5qUzSwHUP0sLRyipVjz6POq64H7/1njluk=;
        b=mLRxTAV5OdX2zQUA3PIfWPhnnCbrmQTaBUo6kZdID659hMyt2luMLN7fpuMiZAVF7IPNYY
        J2ABzO57hZYRG6NKivnlJh5+MfDgHUPJvrGg9kzyxaw4mizvOiUte0+KNOYe1+M99Ru44n
        QrK+o4+DjVvWyoGwH4C9iAgXEllqnN0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e0905308 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 30 Aug 2023 11:37:42 +0000 (UTC)
Date:   Wed, 30 Aug 2023 13:37:39 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Phil Elwell <phil@raspberrypi.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Stefan Wahren <wahrenst@gmx.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Andrei Coardos <aboutphysycs@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: bcm2835-rng: Performance regression since 96cb9d055445
Message-ID: <ZO8qAyNSKVkHWfjS@zx2c4.com>
References: <bc97ece5-44a3-4c4e-77da-2db3eb66b128@gmx.net>
 <ZOiP2H_6pfhKN3fj@zx2c4.com>
 <20e3c73c-7736-b010-516a-6618c88d8dad@gmx.net>
 <2a0fd8ef-8b43-b769-b4aa-c27405ead5e7@leemhuis.info>
 <CAMEGJJ1c8=gxK=2C3pg7d0dFonNQqiBRM2PGRDBoQ_6=QP8uMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMEGJJ1c8=gxK=2C3pg7d0dFonNQqiBRM2PGRDBoQ_6=QP8uMg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 30, 2023 at 11:44:31AM +0100, Phil Elwell wrote:
> Hi all,
> 
> On Wed, 30 Aug 2023 at 11:38, Thorsten Leemhuis
> <regressions@leemhuis.info> wrote:
> >
> > /me gets the impression he has to chime in here
> >
> > On 25.08.23 14:14, Stefan Wahren wrote:
> > > Am 25.08.23 um 13:26 schrieb Jason A. Donenfeld:
> > >> On Fri, Aug 25, 2023 at 01:14:55PM +0200, Stefan Wahren wrote:
> > >
> > >>> i didn't find the time to fix the performance regression in bcm2835-rng
> > >>> which affects Raspberry Pi 0 - 3, so report it at least. AFAIK the first
> > >>> report about this issue was here [1] and identified the offending
> > >>> commit:
> > >>>
> > >>> 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of
> > >>>    cpu_relax()")
> > >>>
> > >>> #regzbot introduced: 96cb9d055445
> > >>>
> > >>> I was able to reproduce this issue with a Raspberry Pi 3 B+ on Linux
> > >>> 6.5-rc6 (arm64/defconfig).
> > >>>
> > >>> Before:
> > >>> time sudo dd if=/dev/hwrng of=/dev/urandom count=1 bs=4096 status=none
> > >>>
> > >>> real    3m29,002s
> > >>> user    0m0,018s
> > >>> sys    0m0,054s
> > >> That's not surprising. But also, does it matter? That script has
> > >> *always* been wrong. Writing to /dev/urandom like that has *never*
> > >> ensured that those bytes are taken into account immediately after. It's
> > >> just not how that interface works. So any assumptions based on that are
> > >> bogus, and that line effectively does nothing.
> > >>
> > >> Fortunately, however, the kernel itself incorporates hwrng output into
> > >> the rng pool, so you don't need to think about doing it yourself.
> > >>
> > >> So go ahead and remove that line from your script.
> > >
> > > Thanks for your explanation. Unfortunately this isn't my script.
> >
> > And I assume it's in the standard install of the RpiOS or similarly
> > widespread?
> >
> > > I'm
> > > just a former BCM2835 maintainer and interested that more user stick to
> > > the mainline kernel instead of the vendor ones. I will try to report the
> > > script owner.
> >
> > thx
> >
> > >> Now as far as the "regression" goes, we've made an already broken
> > >> userspace script take 3 minutes longer than usual, but it still does
> > >> eventually complete, so it's not making boot impossible or something.
> > >> How this relates to the "don't break userspace" rule might be a matter
> > >> of opinion.
> >
> > Yup, but I'd say it bad enough to qualify as regression. If it would be
> > something like 10 seconds it might be something different, but 3 minutes
> > will look like a hang to many people, and I'm pretty sure that's
> > something Linus doesn't want to see. But let's not involve him for now
> > and first try to solve this differently.
> >
> > >> If you think it does, maybe send a patch to Herbert reducing
> > >> that sleep from 1000 to 100 and stating why with my background above,
> > >> and see if he agrees it's worth fixing.
> >
> > Stefan, did you try to see how long it would take when the sleep time is
> > reduced? I guess that might be our best chance to solve this, as
> > reverting the culprit afaics would lead to regressions for others.
> >
> > /me wonders if the sleep time could even be reduced futher that 100
> 
> FYI, this is how I tackled it downstream:
> 
> https://github.com/raspberrypi/linux/commit/6a825ed68f75bd768e31110ba825b75c5c09cf2d
> 
> I can send a patch if it looks appropriate for upstream use.
> 
> Phil

Upstream discussion: https://lore.kernel.org/all/ZOoe0lOR9zpcAw5I@zx2c4.com/

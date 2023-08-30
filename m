Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D564FC83F17
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Aug 2023 18:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242690AbjH3Sn7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243330AbjH3Koq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2023 06:44:46 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19211BB
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 03:44:42 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 3f1490d57ef6-d7ba4c5f581so544730276.0
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 03:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google; t=1693392282; x=1693997082; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kEkxxzA0TthGJR16AScaoyAkvW8C73WWinCGUiXZc+s=;
        b=jTg/akEyaQNSd5yMZPqqBWl+uy0HQMDcbDu5oEjg1bzobEIVlpEMEVO4p59Tnqfy8r
         4N5KMN/su67oNE6Ph3NK8wAUmgWaln4VdznEQXunH/IJpXR8lOkKIjciXTAsk/GViwNV
         qjJIbdlZivmi1zGBV9vokPe8O19GT5hz7yNl7ZY0Tm+2kmET4P4XdpGXAWpeJWpQnj26
         0BExxtJCnHPG/TonSO93xNs+/ULE45Eyw5EXBCOmp7iUaH2uObtP+1KL/MNiNmPjX/Rz
         +urTf2bSfaTvUub8xR+s5/NjzCkT7azH+QU4G4nwbG+fdgFS+a8BlfYC1RLr7ZJhOOz3
         PvDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693392282; x=1693997082;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kEkxxzA0TthGJR16AScaoyAkvW8C73WWinCGUiXZc+s=;
        b=eiFxcaXurxT456OGqS5zMrvFsuzvWe5uARdr7otvsaN2QycPB1iBlCpZZ4X6JrIQ1X
         92Dyd/4lIs/ds5sZg0IIZHtazRQwZAhtjQthVLcS54d3WcWO7xWfwhUv3hGPtgZcyNHN
         jXuu+fl08SQkVWOWTnfMdqcZXRyX6SGWLk3+O7CcExKteh1r1C7i2uLivI3kvPrCBa0e
         6o5cu6DjXbTru/zrPbsdhhVUiLPRvxc6yHSuUzTcSIEyJAZ1FVEnwYFmnaB7Me6aG8Dp
         Uki/lArGHwfvaiUyXY3toau/lXcEXxzd5vueNuPW6AzW8y/wbYK3G6iawK+eHkXsEnJQ
         Sn1Q==
X-Gm-Message-State: AOJu0YwvwpJ/S7kRiYdyj3uNQAdNKYkWBuku0iUUfuYEYW65LqyZihhI
        togWAYc08U2+A7rmCsrDKb5qbbgQfAdToD+2bxoBww==
X-Google-Smtp-Source: AGHT+IEspIeeEeFYPYME6t2Gr5efuuQkhkeXO4wFGw/AOG+e06wL/S1SLrMT9JWVnuG+tyzq4OikRR9sJol1OhLm/p0=
X-Received: by 2002:a25:be08:0:b0:d78:21e0:c06d with SMTP id
 h8-20020a25be08000000b00d7821e0c06dmr1641099ybk.64.1693392282091; Wed, 30 Aug
 2023 03:44:42 -0700 (PDT)
MIME-Version: 1.0
References: <bc97ece5-44a3-4c4e-77da-2db3eb66b128@gmx.net> <ZOiP2H_6pfhKN3fj@zx2c4.com>
 <20e3c73c-7736-b010-516a-6618c88d8dad@gmx.net> <2a0fd8ef-8b43-b769-b4aa-c27405ead5e7@leemhuis.info>
In-Reply-To: <2a0fd8ef-8b43-b769-b4aa-c27405ead5e7@leemhuis.info>
From:   Phil Elwell <phil@raspberrypi.com>
Date:   Wed, 30 Aug 2023 11:44:31 +0100
Message-ID: <CAMEGJJ1c8=gxK=2C3pg7d0dFonNQqiBRM2PGRDBoQ_6=QP8uMg@mail.gmail.com>
Subject: Re: bcm2835-rng: Performance regression since 96cb9d055445
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Stefan Wahren <wahrenst@gmx.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Andrei Coardos <aboutphysycs@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Linux regressions mailing list <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

On Wed, 30 Aug 2023 at 11:38, Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> /me gets the impression he has to chime in here
>
> On 25.08.23 14:14, Stefan Wahren wrote:
> > Am 25.08.23 um 13:26 schrieb Jason A. Donenfeld:
> >> On Fri, Aug 25, 2023 at 01:14:55PM +0200, Stefan Wahren wrote:
> >
> >>> i didn't find the time to fix the performance regression in bcm2835-rng
> >>> which affects Raspberry Pi 0 - 3, so report it at least. AFAIK the first
> >>> report about this issue was here [1] and identified the offending
> >>> commit:
> >>>
> >>> 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of
> >>>    cpu_relax()")
> >>>
> >>> #regzbot introduced: 96cb9d055445
> >>>
> >>> I was able to reproduce this issue with a Raspberry Pi 3 B+ on Linux
> >>> 6.5-rc6 (arm64/defconfig).
> >>>
> >>> Before:
> >>> time sudo dd if=/dev/hwrng of=/dev/urandom count=1 bs=4096 status=none
> >>>
> >>> real    3m29,002s
> >>> user    0m0,018s
> >>> sys    0m0,054s
> >> That's not surprising. But also, does it matter? That script has
> >> *always* been wrong. Writing to /dev/urandom like that has *never*
> >> ensured that those bytes are taken into account immediately after. It's
> >> just not how that interface works. So any assumptions based on that are
> >> bogus, and that line effectively does nothing.
> >>
> >> Fortunately, however, the kernel itself incorporates hwrng output into
> >> the rng pool, so you don't need to think about doing it yourself.
> >>
> >> So go ahead and remove that line from your script.
> >
> > Thanks for your explanation. Unfortunately this isn't my script.
>
> And I assume it's in the standard install of the RpiOS or similarly
> widespread?
>
> > I'm
> > just a former BCM2835 maintainer and interested that more user stick to
> > the mainline kernel instead of the vendor ones. I will try to report the
> > script owner.
>
> thx
>
> >> Now as far as the "regression" goes, we've made an already broken
> >> userspace script take 3 minutes longer than usual, but it still does
> >> eventually complete, so it's not making boot impossible or something.
> >> How this relates to the "don't break userspace" rule might be a matter
> >> of opinion.
>
> Yup, but I'd say it bad enough to qualify as regression. If it would be
> something like 10 seconds it might be something different, but 3 minutes
> will look like a hang to many people, and I'm pretty sure that's
> something Linus doesn't want to see. But let's not involve him for now
> and first try to solve this differently.
>
> >> If you think it does, maybe send a patch to Herbert reducing
> >> that sleep from 1000 to 100 and stating why with my background above,
> >> and see if he agrees it's worth fixing.
>
> Stefan, did you try to see how long it would take when the sleep time is
> reduced? I guess that might be our best chance to solve this, as
> reverting the culprit afaics would lead to regressions for others.
>
> /me wonders if the sleep time could even be reduced futher that 100

FYI, this is how I tackled it downstream:

https://github.com/raspberrypi/linux/commit/6a825ed68f75bd768e31110ba825b75c5c09cf2d

I can send a patch if it looks appropriate for upstream use.

Phil

Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F2BC48BD5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 18:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89B692086D
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 18:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbfFYS2d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 14:28:33 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32944 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfFYS2d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 14:28:33 -0400
Received: by mail-qt1-f195.google.com with SMTP id w40so8982626qtk.0
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jun 2019 11:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AGownEfa1AlTq1qY5SJf+FwodOscNpyfwaApYPrIOFQ=;
        b=t+2j9WYEEHpqoc2yEgYhAVOSV536gpMcpOarYvJgE8iJBKm50rJWfsKDAgtfMMHt/i
         Qz4BcCfWhjlXM8qIjMZ36JrzmX2dT+YGixW37ZZPADLrrOEpvHksuvlcGS7GujhptXpI
         mx+n18Np9DnmsQDdYWHwZLvyB0ESHxdaT3/31lnRW/6ik2y+MN++oJ2bzsm1maQHNi2A
         fthucXmeO/pxN3y6JrhWKrW5BX4f9CLMjht+yf1dUthTgKnt/7laQcNoRBGIhvU2KGX8
         Qhfev1PQyLbXmwzqB6KcjKgVRUO7MGWxrPumHCbB1mtuI7SPySJ2YLMTSbqxne7e4zek
         C6hg==
X-Gm-Message-State: APjAAAU0YIgp8SD4iDOjvq/qdLTbfRXehE6m2SA0aJOcY2hQr/rJZ/Lr
        9UwonDGWmU9RGUTRqJrP3PHiHOXf7epQW71WTcM3PA==
X-Google-Smtp-Source: APXvYqyqq88dKWZ/UALomF5KWaTVSHVRJdp4Zi4JKGykR2MZXO8rSTaRMtYmMGEeIUeI/1V+4ja94yXp4VXy1hlqxvk=
X-Received: by 2002:ac8:2379:: with SMTP id b54mr76733430qtb.168.1561487312373;
 Tue, 25 Jun 2019 11:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190625145254.28510-1-ard.biesheuvel@linaro.org>
 <CAMuHMdUbnHBQoTHVd9YyU_8yn6VHdcC1-8q3GqKftMrvRV_qag@mail.gmail.com> <CAKv+Gu-b5YdBypEdt247bu1bpFZoDaxW1R9Xjb62+mx6WpDO8A@mail.gmail.com>
In-Reply-To: <CAKv+Gu-b5YdBypEdt247bu1bpFZoDaxW1R9Xjb62+mx6WpDO8A@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 25 Jun 2019 20:28:19 +0200
Message-ID: <CAMuHMdUGx25P2KJpHM8RqGkjkrMK38F72Bukg2RNVOh-2C2Ygw@mail.gmail.com>
Subject: Re: [PATCH] crypto: morus - remove generic and x86 implementations
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Tue, Jun 25, 2019 at 5:58 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On Tue, 25 Jun 2019 at 17:27, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Tue, Jun 25, 2019 at 4:53 PM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > > MORUS was not selected as a winner in the CAESAR competition, which
> > > is not surprising since it is considered to be cryptographically
> > > broken. (Note that this is not an implementation defect, but a flaw
> > > in the underlying algorithm). Since it is unlikely to be in use
> > > currently, let's remove it before we're stuck with it.
> > >
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> > Thanks for your patch!
> >
> > >  arch/m68k/configs/amiga_defconfig     |    2 -
> > >  arch/m68k/configs/apollo_defconfig    |    2 -
> > >  arch/m68k/configs/atari_defconfig     |    2 -
> > >  arch/m68k/configs/bvme6000_defconfig  |    2 -
> > >  arch/m68k/configs/hp300_defconfig     |    2 -
> > >  arch/m68k/configs/mac_defconfig       |    2 -
> > >  arch/m68k/configs/multi_defconfig     |    2 -
> > >  arch/m68k/configs/mvme147_defconfig   |    2 -
> > >  arch/m68k/configs/mvme16x_defconfig   |    2 -
> > >  arch/m68k/configs/q40_defconfig       |    2 -
> > >  arch/m68k/configs/sun3_defconfig      |    2 -
> > >  arch/m68k/configs/sun3x_defconfig     |    2 -
> >
> > For the m68k defconfig changes:
> > Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >
> > (but they would be updated "automatically" during the next defconfig refresh
> >  anyway)
> >
>
> Thanks Geert.
>
> Would you prefer to leave this hunk out instead?

Up to you, I don't mind.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F316C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 22:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5722960FDA
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 22:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhJSW0Y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Oct 2021 18:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhJSW0Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Oct 2021 18:26:24 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ED4C061749
        for <linux-crypto@vger.kernel.org>; Tue, 19 Oct 2021 15:24:10 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so977222pjc.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 Oct 2021 15:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=1HjkJ/s77qpPQedlx0RgSf6Pe/gtFpXgvkvC8dCGFU0=;
        b=BxTLhk9+ebegQi7VeiuJ8gELz4u56+OXRjyqMZBoX0LqA7qfsOxJSz29PFrPQ2a5RY
         LcxqHlpG5bSgJ3CFC57RhTH/R1HJkTDhjH7E7MLDPRTHfCwF3VUpggNElqDqkUS2LMrz
         WrNip9ynF/P+x0QTDG0K5z9ZML7kLwU/Wcllgd4JYzKccvn0TPybqUlBx1mDIHh66jJF
         cahqD9ok9M1Xuk1xeoHgN0qA9CMsGamHAulesB+mv/0r6Qwjtu5IdwmFHnOlMxAZ7Zge
         8pj6oZJmyZ45JDp8Niu4HYLZB6PLDBK0UzjfbGSLG2hZeMLFKj0odEo1QVoz6EIjCDWe
         OMuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=1HjkJ/s77qpPQedlx0RgSf6Pe/gtFpXgvkvC8dCGFU0=;
        b=CS66/Uc0UQb+uuHvNT5a3tA75c0fLpCTSWChJBAZjYWCO4No17FnaijHGNJMFfyXp5
         n3dPWR/NGv2vk9+COkMKuDmi79iQkjh42InDatjfNivmHigFunqN0DDbu9vDp8wVWQ6X
         KtD/5C2xWaq6Yl+8YXS/+h2Y/pjRyPeB7u4in5SZWXDnm+NScvknnJtdIk1OpherDBAf
         Pk1navLtNY8Mf843PeN8sswd0KFIHy1uTJcPfK55qPwjn46hGDA9ptaF18VmHGLQ7AlV
         vZIQzckIoLmxn+rToi6kImkUKH5PoZnXkdxFASbQrYsC7gW5n5z1hlw7ROI4WwLAiIvx
         VVAg==
X-Gm-Message-State: AOAM533FnFqx7iunP19MTK4qOHlQ1NGuQL+OQKsSv9TVTeU/dUYvraqH
        qCCNb2eewwhgY5ShKnBQgINLfJmtoVIvXC66
X-Google-Smtp-Source: ABdhPJwLQqa9/353IjPEVTMx7skJRSXdLKW1mf1YwaUVOFV6ydmL3thqxJXuxdriUBbXxED+AQ4PcA==
X-Received: by 2002:a17:902:7804:b0:13e:d4c6:e701 with SMTP id p4-20020a170902780400b0013ed4c6e701mr35682103pll.66.1634682250190;
        Tue, 19 Oct 2021 15:24:10 -0700 (PDT)
Received: from localhost (c-71-197-186-152.hsd1.wa.comcast.net. [71.197.186.152])
        by smtp.gmail.com with ESMTPSA id z124sm227235pfb.108.2021.10.19.15.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 15:24:09 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Tim Bird <tbird20d@gmail.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Matt Porter <mporter@konsulko.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Tim Bird <tim.bird@sony.com>
Subject: Re: [PATCH] MAINTAINERS: Remove Matt Mackall as his identity is
 obsolete
In-Reply-To: <CAMuHMdVCrC5_AjNDJN+nwrnn=EVTfD-8ddG=FaFBBh_0UY5acQ@mail.gmail.com>
References: <20210920080635.253826-1-u.kleine-koenig@pengutronix.de>
 <CA+bK7J741D=DgZMNeEC5xg9kDDSaJu19QsRunVvXkBGx1mKGnQ@mail.gmail.com>
 <YW5r61ZQx+E9xfuH@pendragon.ideasonboard.com>
 <57122a67509bebdf0d1b9f5bc15db116e0124e5d.camel@infradead.org>
 <YW6UGP10hfGJ2kYy@pendragon.ideasonboard.com>
 <CAMuHMdVCrC5_AjNDJN+nwrnn=EVTfD-8ddG=FaFBBh_0UY5acQ@mail.gmail.com>
Date:   Tue, 19 Oct 2021 15:24:08 -0700
Message-ID: <7hlf2oejqv.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Tue, Oct 19, 2021 at 11:48 AM Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> On Tue, Oct 19, 2021 at 10:33:10AM +0100, David Woodhouse wrote:
>> > On Tue, 2021-10-19 at 09:55 +0300, Laurent Pinchart wrote:
>> > > On Mon, Oct 18, 2021 at 03:17:22PM -0600, Tim Bird wrote:
>> > > > I think an overhaul of the "EMBEDDED LINUX" MAINTAINERS entry
>> > > > is long-overdue.
>> > > >
>> > > > No offense to any of the 3 persons listed, but I think the kernel =
developer
>> > > > community would be better served by a group of individuals with a =
more
>> > > > current active role in embedded linux.  I have a few names I'll
>> > > > toss out for
>> > > > candidates: Matt Porter, Kevin Hilman, Thomas Gleixner,  Thomas
>> > > > Petazonni, Laurent Pinchart, and Uwe Kleine-K=C3=B6nig (and maybe =
even
>> > > > myself).
>> > > >
>> > > > This entry in the MAINTAINERS file is somewhat special, in that it
>> > > > covers a "field of endeavor" rather than a specific set of files or
>> > > > directories.
>> > > >
>> > > > Thoughts?
>> > >
>> > > Thank you for volunteering me :-)
>> > >
>> > > I was indeed wondering about this particular MAINTAINERS entry. As it
>> > > doesn't cover any particular set of files, directories, drivers,
>> > > subsystems or architectures, what does being listed here endeavour ?
>> >
>> > Basically nothing; I was going to suggest removing it entirely. There's
>> > certainly no point listing me there any more.
>> >
>> > Once upon a time it involved a certain amount of heckling about memory
>> > usage and "your hash table doesn't need to be that large" but that ship
>> > sailed a long time ago :)
>>
>> Heckling is still an option without a MAINTAINERS entry I suppose :-)
>
> Don't worry, I keep on sailing ;-)
>
>> I wouldn't object if we were to remove it.
>
> +1
>

Agreed.  Let's just drop this entry.

Kevin

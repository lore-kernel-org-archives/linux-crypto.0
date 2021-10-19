Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CA2C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 09:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6460661212
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 09:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbhJSJ6w convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Oct 2021 05:58:52 -0400
Received: from mail-vk1-f169.google.com ([209.85.221.169]:33720 "EHLO
        mail-vk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhJSJ6w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Oct 2021 05:58:52 -0400
Received: by mail-vk1-f169.google.com with SMTP id r26so656416vkq.0;
        Tue, 19 Oct 2021 02:56:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wa3+/NxbJXKxsVHmrMUZvmSmQSRoGR1Z/ThSOCypBgU=;
        b=RLiuBPgyDuMALuG+PDoK+Ix7F0gDK9B0QI+rfwFL+0gA8Gibk1OretBZt/ejSX30Uc
         y8ReFiGv2p8N3SShcWZGmGUqDLQEvMHJsC/aQ1P2lyMOH6cCM3+WW5Od+r/jNUuQJThH
         YvNgQCL5FJmbIzPXuWw0hH8xXh8MBQyMmylTcQ9VeyO+f5nT8Vj8nNMiGdGxZWVdkoam
         Gzz/xR5pQWg0xecxOFaJxgLs9Iy4WAB2hA1AB/rg5EgrA1z4Q4xzOOg3UIMwUXBn11W+
         AutH3+Q4CbC1nXJJ9zZzMJDXCFAGUEAOn+EcTG0nYg8a2Ni/ZDts4+qLYTvXPB2XWU5t
         CY7w==
X-Gm-Message-State: AOAM532gqlKOYIKq6Jb1rpc2najyFP6rw75RpVEO3XR16L9AzN6/k/jV
        ud06l5GsMVNHGbfJ6nIkhq1bfwnh6A0BqA==
X-Google-Smtp-Source: ABdhPJzo4xjW1UUlCXp9Z2apl1bmANu5bFYEOnoA/kQsv80ihNO15arTt5W1FGrYR9o/ka+IpNH0/w==
X-Received: by 2002:a1f:f241:: with SMTP id q62mr11152778vkh.12.1634637398714;
        Tue, 19 Oct 2021 02:56:38 -0700 (PDT)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id 33sm3452622vkn.2.2021.10.19.02.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 02:56:38 -0700 (PDT)
Received: by mail-ua1-f49.google.com with SMTP id u5so12529217uao.13;
        Tue, 19 Oct 2021 02:56:37 -0700 (PDT)
X-Received: by 2002:a05:6102:290c:: with SMTP id cz12mr33705536vsb.35.1634637397645;
 Tue, 19 Oct 2021 02:56:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210920080635.253826-1-u.kleine-koenig@pengutronix.de>
 <CA+bK7J741D=DgZMNeEC5xg9kDDSaJu19QsRunVvXkBGx1mKGnQ@mail.gmail.com>
 <YW5r61ZQx+E9xfuH@pendragon.ideasonboard.com> <57122a67509bebdf0d1b9f5bc15db116e0124e5d.camel@infradead.org>
 <YW6UGP10hfGJ2kYy@pendragon.ideasonboard.com>
In-Reply-To: <YW6UGP10hfGJ2kYy@pendragon.ideasonboard.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 19 Oct 2021 11:56:26 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVCrC5_AjNDJN+nwrnn=EVTfD-8ddG=FaFBBh_0UY5acQ@mail.gmail.com>
Message-ID: <CAMuHMdVCrC5_AjNDJN+nwrnn=EVTfD-8ddG=FaFBBh_0UY5acQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Remove Matt Mackall as his identity is obsolete
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Tim Bird <tbird20d@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Matt Porter <mporter@konsulko.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Tim Bird <tim.bird@sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 19, 2021 at 11:48 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Tue, Oct 19, 2021 at 10:33:10AM +0100, David Woodhouse wrote:
> > On Tue, 2021-10-19 at 09:55 +0300, Laurent Pinchart wrote:
> > > On Mon, Oct 18, 2021 at 03:17:22PM -0600, Tim Bird wrote:
> > > > I think an overhaul of the "EMBEDDED LINUX" MAINTAINERS entry
> > > > is long-overdue.
> > > >
> > > > No offense to any of the 3 persons listed, but I think the kernel developer
> > > > community would be better served by a group of individuals with a more
> > > > current active role in embedded linux.  I have a few names I'll
> > > > toss out for
> > > > candidates: Matt Porter, Kevin Hilman, Thomas Gleixner,  Thomas
> > > > Petazonni, Laurent Pinchart, and Uwe Kleine-König (and maybe even
> > > > myself).
> > > >
> > > > This entry in the MAINTAINERS file is somewhat special, in that it
> > > > covers a "field of endeavor" rather than a specific set of files or
> > > > directories.
> > > >
> > > > Thoughts?
> > >
> > > Thank you for volunteering me :-)
> > >
> > > I was indeed wondering about this particular MAINTAINERS entry. As it
> > > doesn't cover any particular set of files, directories, drivers,
> > > subsystems or architectures, what does being listed here endeavour ?
> >
> > Basically nothing; I was going to suggest removing it entirely. There's
> > certainly no point listing me there any more.
> >
> > Once upon a time it involved a certain amount of heckling about memory
> > usage and "your hash table doesn't need to be that large" but that ship
> > sailed a long time ago :)
>
> Heckling is still an option without a MAINTAINERS entry I suppose :-)

Don't worry, I keep on sailing ;-)

> I wouldn't object if we were to remove it.

+1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

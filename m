Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F673C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 06:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0930661260
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 06:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhJSG6S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Oct 2021 02:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJSG6M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Oct 2021 02:58:12 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DB1C06161C;
        Mon, 18 Oct 2021 23:55:59 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9AFD812A;
        Tue, 19 Oct 2021 08:55:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1634626557;
        bh=OO+JLZw3s7DOdbInpQnbJZU2fN1ohlbnRoqBrKztXU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bLmj2MXxlz4QB8gyho3+pNEevQKczc12viyitZPao7fbT+kDHXShETKWTAotLMOC5
         9c8RXgUC9qspX4sJx0xHNP6s3tuwWrISTs8wKP5BHKsaqikYhJD4VijVSqZ0kytWKM
         QOR4/KQNOZgThbDGXYVOyABceOwDti3IYu+nHeVo=
Date:   Tue, 19 Oct 2021 09:55:39 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Tim Bird <tbird20d@gmail.com>
Cc:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-embedded@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Matt Porter <mporter@konsulko.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        thomas.petazzoni@bootlin.com, Tim Bird <tim.bird@sony.com>
Subject: Re: [PATCH] MAINTAINERS: Remove Matt Mackall as his identity is
 obsolete
Message-ID: <YW5r61ZQx+E9xfuH@pendragon.ideasonboard.com>
References: <20210920080635.253826-1-u.kleine-koenig@pengutronix.de>
 <CA+bK7J741D=DgZMNeEC5xg9kDDSaJu19QsRunVvXkBGx1mKGnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+bK7J741D=DgZMNeEC5xg9kDDSaJu19QsRunVvXkBGx1mKGnQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Tim,

On Mon, Oct 18, 2021 at 03:17:22PM -0600, Tim Bird wrote:
> On Mon, Sep 20, 2021 at 3:52 AM Uwe Kleine-König  wrote:
> >
> > The mails I sent to Matt on September 14 and 20 both were refused by the
> > MTA responsible for selenic.com (i.e. waste.org) with:
> >
> >         554 5.7.1 <mpm@selenic.com>: Recipient address rejected: This identity is obsolete
> >
> > Also the most recent commit that involved him (ignoring "Cc: Matt
> > Mackall <mpm@selenic.com>" footers) is commit 330e0a01d54c (MAINTAINERS:
> > Theodore Ts'o is taking over the random driver) where he was removed
> > from the entry for random number drivers in 2012.
> >
> > So drop him completely from the list of maintainers.
> >
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  MAINTAINERS | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index d7b4f32875a9..805630c67a1f 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -6812,7 +6812,6 @@ F:        drivers/media/usb/em28xx/
> >
> >  EMBEDDED LINUX
> >  M:     Paul Gortmaker <paul.gortmaker@windriver.com>
> > -M:     Matt Mackall <mpm@selenic.com>
> >  M:     David Woodhouse <dwmw2@infradead.org>
> >  L:     linux-embedded@vger.kernel.org
> >  S:     Maintained
> > @@ -8157,7 +8156,6 @@ F:        include/trace/events/hwmon*.h
> >  K:     (devm_)?hwmon_device_(un)?register(|_with_groups|_with_info)
> 
> 
> I think an overhaul of the "EMBEDDED LINUX" MAINTAINERS entry
> is long-overdue.
> 
> No offense to any of the 3 persons listed, but I think the kernel developer
> community would be better served by a group of individuals with a more
> current active role in embedded linux.  I have a few names I'll toss out for
> candidates: Matt Porter, Kevin Hilman, Thomas Gleixner,  Thomas
> Petazonni, Laurent Pinchart, and Uwe Kleine-König (and maybe even
> myself).
> 
> This entry in the MAINTAINERS file is somewhat special, in that it
> covers a "field of endeavor" rather than a specific set of files or
> directories.
> 
> Thoughts?

Thank you for volunteering me :-)

I was indeed wondering about this particular MAINTAINERS entry. As it
doesn't cover any particular set of files, directories, drivers,
subsystems or architectures, what does being listed here endeavour ?

> ... Volunteers?
> 
> >  HARDWARE RANDOM NUMBER GENERATOR CORE
> > -M:     Matt Mackall <mpm@selenic.com>
> >  M:     Herbert Xu <herbert@gondor.apana.org.au>
> >  L:     linux-crypto@vger.kernel.org
> >  S:     Odd fixes

-- 
Regards,

Laurent Pinchart

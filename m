Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CC4C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 09:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2E9160F93
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Oct 2021 09:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbhJSJtj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Oct 2021 05:49:39 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:54070 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbhJSJti (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Oct 2021 05:49:38 -0400
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 163D512A;
        Tue, 19 Oct 2021 11:47:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1634636843;
        bh=9WpIKSjpHCw/alwPbMvvbFk/40a6krbHuMfWKlR1GB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SmesInog4R8l0uM1cVLwfoG/7ocuW2JwahC8DYBA7HH60IdBVEtNvkq/kuazDMg4L
         hS3w2xlaBDCwaOJi5dMyu70ZM3SIxH2EaSCOzuHB616tNKejlKDBNCUtpdrb9U7uxS
         BJK/rJwy+JRKA0xMMuYyH8n42vN8Q40VTViflhA4=
Date:   Tue, 19 Oct 2021 12:47:04 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Tim Bird <tbird20d@gmail.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-embedded@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Matt Porter <mporter@konsulko.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        thomas.petazzoni@bootlin.com, Tim Bird <tim.bird@sony.com>
Subject: Re: [PATCH] MAINTAINERS: Remove Matt Mackall as his identity is
 obsolete
Message-ID: <YW6UGP10hfGJ2kYy@pendragon.ideasonboard.com>
References: <20210920080635.253826-1-u.kleine-koenig@pengutronix.de>
 <CA+bK7J741D=DgZMNeEC5xg9kDDSaJu19QsRunVvXkBGx1mKGnQ@mail.gmail.com>
 <YW5r61ZQx+E9xfuH@pendragon.ideasonboard.com>
 <57122a67509bebdf0d1b9f5bc15db116e0124e5d.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57122a67509bebdf0d1b9f5bc15db116e0124e5d.camel@infradead.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 19, 2021 at 10:33:10AM +0100, David Woodhouse wrote:
> On Tue, 2021-10-19 at 09:55 +0300, Laurent Pinchart wrote:
> > Hi Tim,
> > 
> > On Mon, Oct 18, 2021 at 03:17:22PM -0600, Tim Bird wrote:
> > > I think an overhaul of the "EMBEDDED LINUX" MAINTAINERS entry
> > > is long-overdue.
> > > 
> > > No offense to any of the 3 persons listed, but I think the kernel developer
> > > community would be better served by a group of individuals with a more
> > > current active role in embedded linux.  I have a few names I'll
> > > toss out for
> > > candidates: Matt Porter, Kevin Hilman, Thomas Gleixner,  Thomas
> > > Petazonni, Laurent Pinchart, and Uwe Kleine-König (and maybe even
> > > myself).
> > > 
> > > This entry in the MAINTAINERS file is somewhat special, in that it
> > > covers a "field of endeavor" rather than a specific set of files or
> > > directories.
> > > 
> > > Thoughts?
> > 
> > Thank you for volunteering me :-)
> > 
> > I was indeed wondering about this particular MAINTAINERS entry. As it
> > doesn't cover any particular set of files, directories, drivers,
> > subsystems or architectures, what does being listed here endeavour ?
> 
> Basically nothing; I was going to suggest removing it entirely. There's
> certainly no point listing me there any more.
> 
> Once upon a time it involved a certain amount of heckling about memory
> usage and "your hash table doesn't need to be that large" but that ship
> sailed a long time ago :)

Heckling is still an option without a MAINTAINERS entry I suppose :-)

I wouldn't object if we were to remove it.

-- 
Regards,

Laurent Pinchart

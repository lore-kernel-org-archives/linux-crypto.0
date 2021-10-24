Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC80C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Oct 2021 09:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F26C460F9B
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Oct 2021 09:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhJXKAS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Oct 2021 06:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:32920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhJXKAS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Oct 2021 06:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55D0460F4F;
        Sun, 24 Oct 2021 09:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635069478;
        bh=4xCqj5G9GvzDzcYFIrwq9UPV3NhMM5vSXRX1UJk/qGI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sYwrI0qdBb6IRc3rucYOfHtRGyXXGgtRgpGSw686bw4ylbZB2VRrWRrP7r09Cuy3J
         No+5wVMkUfybPsdEHRCFhX4izvYAXnURfvuh+j1tm8DnPCuszh66YQFzh2UStKwF+f
         WXniifhRMYn3p/gsBoxQnS2iWhEOsqD4/bfMhZPw=
Date:   Sun, 24 Oct 2021 11:57:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rob Landley <rob@landley.net>
Cc:     Tim.Bird@sony.com, khilman@baylibre.com, geert@linux-m68k.org,
        laurent.pinchart@ideasonboard.com, dwmw2@infradead.org,
        tbird20d@gmail.com, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        linux-embedded@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        mporter@konsulko.com, tglx@linutronix.de,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] MAINTAINERS: Remove Matt Mackall as his identity is
 obsolete
Message-ID: <YXUuIIiL6EX8pWhQ@kroah.com>
References: <20210920080635.253826-1-u.kleine-koenig@pengutronix.de>
 <CA+bK7J741D=DgZMNeEC5xg9kDDSaJu19QsRunVvXkBGx1mKGnQ@mail.gmail.com>
 <YW5r61ZQx+E9xfuH@pendragon.ideasonboard.com>
 <57122a67509bebdf0d1b9f5bc15db116e0124e5d.camel@infradead.org>
 <YW6UGP10hfGJ2kYy@pendragon.ideasonboard.com>
 <CAMuHMdVCrC5_AjNDJN+nwrnn=EVTfD-8ddG=FaFBBh_0UY5acQ@mail.gmail.com>
 <7hlf2oejqv.fsf@baylibre.com>
 <BYAPR13MB250310153BF63EF3ED50F294FDBD9@BYAPR13MB2503.namprd13.prod.outlook.com>
 <f7c3aabd-8916-a0d2-7859-7088fab3114e@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7c3aabd-8916-a0d2-7859-7088fab3114e@landley.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 24, 2021 at 02:24:48AM -0500, Rob Landley wrote:
> > The linux-embedded mailing list was created about the same time.
> > The thinking was that there are issues that transcend any particular
> > sub-system, directory, or file, such as boot time or system size or
> > real-time. Changes to keep these system-wide metrics in check might
> > need the assistance of a respected upstream maintainer, who could
> > guide developers working in these areas, or who could help keep
> > other kernel maintainers apprised of requirements in these areas
> > for embedded products.
> 
> Greg KH wouldn't listen to me when I was Documention maintainer. He wouldn't
> listen when I was busybox maintainer. Maintainer-without-portfolio ain't gonna
> get him to start.
> 
> Keep in mind Greg and Kay Sievers were joined at the hip until Linus threw Kay
> out of Linux dev and he bogged off to systemd. If you point out things like
> "sysfs should to present a stable API to userspace" or "it's a bad idea to
> depend on magic packages like udev or systemd as things every Linux system must
> not only use verbatim from a single upstream supplier but must replace every
> time they upgrade the kernel", Greg is reliably against them.

I love you Rob, but I have no idea how the creation of mdev has anything
to do with the topic at hand.

Best of luck!

greg k-h

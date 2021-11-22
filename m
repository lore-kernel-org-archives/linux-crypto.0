Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8450CC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 06:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhKVG6o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 01:58:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229983AbhKVG6o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 01:58:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7361B60F24;
        Mon, 22 Nov 2021 06:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637564138;
        bh=9sWF9nSUVGV0i4pLdKdx1qVM9my9wJIVR0V3Phw76LI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fN1llHvererPl11l8RVyzsC2B1JQXlK84m1/JkIm2mdGsZfdqp82pFPe428+FrKNE
         n2+9ZJxwVFVgSPhWh0u9TXiOfKSvb86WyjAmlDDLd9VyAe8Np7sqoeLRMq80BiF+WU
         tGad+WR2InYID+Ft1yxR+I1rNlSvfGUHUxAFJhDo=
Date:   Mon, 22 Nov 2021 07:55:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, Tso Ted <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Jirka Hladky <jhladky@redhat.com>
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
Message-ID: <YZs+5ZGc1G5O3vF5@kroah.com>
References: <2036923.9o76ZdvQCi@positron.chronox.de>
 <2560758.ogP2UNPRoF@tauon.chronox.de>
 <YZsyZua9T8DD6JF5@kroah.com>
 <11035663.0FQYWtqqoJ@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11035663.0FQYWtqqoJ@tauon.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 22, 2021 at 07:42:02AM +0100, Stephan Mueller wrote:
> Am Montag, 22. November 2021, 07:02:14 CET schrieb Greg Kroah-Hartman:
> 
> Hi Greg,
> 
> > On Mon, Nov 22, 2021 at 06:34:43AM +0100, Stephan Mueller wrote:
> > > Am Sonntag, 21. November 2021, 23:42:33 CET schrieb Jason A. Donenfeld:
> > > 
> > > Hi Jason,
> > > 
> > > > Hi Stephan,
> > > > 
> > > > You've posted it again, and yet I still believe this is not the
> > > > correct design or direction. I do not think the explicit goal of
> > > > extended configurability ("flexibility") or the explicit goal of being
> > > > FIPS compatible represent good directions, and I think this introduces
> > > > new problems rather than solving any existing ones.
> > > 
> > > The members from the Linux distributions that are on copy on this may tell
> > > you a different story. They all developed their own downstream patches to
> > > somehow add the flexibility that is needed for them. So, we have a great
> > > deal of fragmentation at the resting-foundation of Linux cryptography.
> > 
> > What distros specifically have patches in their kernels that do
> > different things to the random code path?  Do you have pointers to those
> > patches anywhere?  Why have the distros not submitted their changes
> > upstream?
> 
> I will leave the representatives from the distros to chime in and point to 
> these patches.

Then why not work with the distros to get these changes merged into the
kernel tree?  They know that keeping things out-of-the-tree costs them
time and money, so why are they keeping them there?

I recommend getting the distros to chime in on what their requirements
are for the random code would probably be best as they are the ones that
take on the "random fips requirement of the day" more than anyone else.

> Yet, these changes are commonly a band-aid only that have some additional 
> drawbacks. Bottom line, there is no appropriate way with the current code to 
> allow vendors what they want to achieve. One hint to what changes vendors are 
> attempting can be found in [1] slide 20.

What exactly do vendors "want to achieve"?  Where are they saying this?

> [1] https://www.chronox.de/lrng/doc/lrng_presentation_v43.pdf

I see nothing on that slide that mentions actual requirements other than
"the current code does not match this random government regulation".

Please provide valid reasons, from distros.

thanks,

greg k-h

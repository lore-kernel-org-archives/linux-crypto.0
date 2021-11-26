Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87426C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 15:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378033AbhKZPvn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 10:51:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50050 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354238AbhKZPtm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 10:49:42 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 10:49:42 EST
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E893262280;
        Fri, 26 Nov 2021 15:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8DEC93056;
        Fri, 26 Nov 2021 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637941261;
        bh=Im5VF849xIzUXh0ZlVivy0q6fZf/DVopDZZz6TwRHAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yvXHVoc1kdgFjgoDZ58pKmf5wpd/G4OSrFB0YjODLbS1Mfl86blD0lRUxVFYTdQ0s
         ppETgLEcMQUynLAQKLXvtBgLp3ajqNC0OxSG/AUhO3gnOBfpu53SoZmzCrLrXscg/1
         8T6KurTekvnn+SkC2+oZBDfPbc9o7cggywvahnu0=
Date:   Fri, 26 Nov 2021 16:40:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     John Haxby <john.haxby@oracle.com>
Cc:     Stephan Mueller <smueller@chronox.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Tso Ted <tytso@mit.edu>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
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
        Alexander Lobakin <alobakin@mailbox.org>,
        Jirka Hladky <jhladky@redhat.com>
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
Message-ID: <YaEACllCbkaHiXpX@kroah.com>
References: <2036923.9o76ZdvQCi@positron.chronox.de>
 <4641592.OV4Wx5bFTl@positron.chronox.de>
 <CAHmME9oaS4TOpk7rQ73BRKeVLjMUNyt6EFyeOX=hZSkFBPDu0g@mail.gmail.com>
 <2560758.ogP2UNPRoF@tauon.chronox.de>
 <YZsyZua9T8DD6JF5@kroah.com>
 <DBF8E8A8-9968-4E81-8C6E-7BAD0C3F39FA@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBF8E8A8-9968-4E81-8C6E-7BAD0C3F39FA@oracle.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 22, 2021 at 04:56:24PM +0000, John Haxby wrote:
> 
> 
> > On 22 Nov 2021, at 06:02, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > On Mon, Nov 22, 2021 at 06:34:43AM +0100, Stephan Mueller wrote:
> >> Am Sonntag, 21. November 2021, 23:42:33 CET schrieb Jason A. Donenfeld:
> >> 
> >> Hi Jason,
> >> 
> >>> Hi Stephan,
> >>> 
> >>> You've posted it again, and yet I still believe this is not the
> >>> correct design or direction. I do not think the explicit goal of
> >>> extended configurability ("flexibility") or the explicit goal of being
> >>> FIPS compatible represent good directions, and I think this introduces
> >>> new problems rather than solving any existing ones.
> >> 
> >> The members from the Linux distributions that are on copy on this may tell you
> >> a different story. They all developed their own downstream patches to somehow
> >> add the flexibility that is needed for them. So, we have a great deal of
> >> fragmentation at the resting-foundation of Linux cryptography.
> > 
> > What distros specifically have patches in their kernels that do
> > different things to the random code path?  Do you have pointers to those
> > patches anywhere?  Why have the distros not submitted their changes
> > upstream?
> > 
> 
> We (Oracle) are carrying such a patch at the moment.  We want this
> patch to be a temporary workaround simply to get FIPS certification in
> the current kernel.
> 
> We're carrying this patch simply because the certification
> requirements changed and this was the quickest and easiest way to
> workaround today's problem.  It won't fix tomorrow's problem and next
> time we, and others, attempt FIPS certification then we, and others,
> will need a different /dev/random because neither the old one nor our
> quick and dirty workaround will actually be acceptable.
> 
> The commit we're carrying at the moment is here:
> https://github.com/oracle/linux-uek/commit/5ebe83413c7573d566e581461bc95f9f139c5d4d
> -- you'll notice that we have a different RNG in fips mode compared to
> normal mode.

Now that's a much smaller and simpler and easier to understand change,
compared to "rewrite the whole random number generator".

Why not work to get FIPS support merged properly upstream?  I know there
are many people working to get FIPS certification, and while the
requirements seem to constantly change and are vague and random, it
would be great to stop duplicating all of this effort all the time.

> We really don't want to have to work out a new hack for future FIPS
> certifications and I'm sure no other distros want to do that either.

Great, why not work to solve this within what we have?

Remember, wholesale replacement is NOT how kernel development happens.
It's incremental evolution based on external need.  It's not a "kill the
existing code and replace it from scratch" process.

> Personally, I'd far rather have any fips-certifiable /dev/random
> drivers be in mainline where everyone gets the same thing.  I don't
> like carrying out-of-tree patches like this, it's not healthy.

Great, please work to make this happen within what we have today.

But adding a stand-alone separate random subsystem just for this is not
a good idea and is one huge reason why this patch set keeps being
ignored by the kernel developers.

thanks,

greg k-h

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7909AC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 15:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351266AbhKZPvu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 10:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347171AbhKZPtt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 10:49:49 -0500
X-Greylist: delayed 99 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 Nov 2021 07:42:41 PST
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EBBC061757;
        Fri, 26 Nov 2021 07:42:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DEE66227D;
        Fri, 26 Nov 2021 15:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2404CC93056;
        Fri, 26 Nov 2021 15:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637941360;
        bh=Vhq8yU3kGBknXeTZBDZ+fg835/qqbi063NCjO7X64jY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0IV5GZFLrJZreyG9uUXtQnh9pIar2vRK3NA6fOpBBVn5m39QxAWPig9wr8YrrdDm6
         qzuzyi/hREKAc56vYgkTc3ikNhIZvi+BM1icEl4jyYwyxEq65udlKrELNoFon9uiuu
         UmIdOXmNO1N4nQ8ki2+7rdMPsHXNzMFpdUELZTkk=
Date:   Fri, 26 Nov 2021 16:42:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Simo Sorce <simo@redhat.com>
Cc:     Stephan Mueller <smueller@chronox.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Tso Ted <tytso@mit.edu>,
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
Message-ID: <YaEAbr/vk621GpMj@kroah.com>
References: <2036923.9o76ZdvQCi@positron.chronox.de>
 <2560758.ogP2UNPRoF@tauon.chronox.de>
 <YZsyZua9T8DD6JF5@kroah.com>
 <11035663.0FQYWtqqoJ@tauon.chronox.de>
 <YZs+5ZGc1G5O3vF5@kroah.com>
 <afdf9c4a4005f6aeaded9e976c48160933f3c447.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afdf9c4a4005f6aeaded9e976c48160933f3c447.camel@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 22, 2021 at 10:09:05AM -0500, Simo Sorce wrote:
> On Mon, 2021-11-22 at 07:55 +0100, Greg Kroah-Hartman wrote:
> > On Mon, Nov 22, 2021 at 07:42:02AM +0100, Stephan Mueller wrote:
> > > Am Montag, 22. November 2021, 07:02:14 CET schrieb Greg Kroah-Hartman:
> > > 
> > > Hi Greg,
> > > 
> > > > On Mon, Nov 22, 2021 at 06:34:43AM +0100, Stephan Mueller wrote:
> > > > > Am Sonntag, 21. November 2021, 23:42:33 CET schrieb Jason A. Donenfeld:
> > > > > 
> > > > > Hi Jason,
> > > > > 
> > > > > > Hi Stephan,
> > > > > > 
> > > > > > You've posted it again, and yet I still believe this is not the
> > > > > > correct design or direction. I do not think the explicit goal of
> > > > > > extended configurability ("flexibility") or the explicit goal of being
> > > > > > FIPS compatible represent good directions, and I think this introduces
> > > > > > new problems rather than solving any existing ones.
> > > > > 
> > > > > The members from the Linux distributions that are on copy on this may tell
> > > > > you a different story. They all developed their own downstream patches to
> > > > > somehow add the flexibility that is needed for them. So, we have a great
> > > > > deal of fragmentation at the resting-foundation of Linux cryptography.
> > > > 
> > > > What distros specifically have patches in their kernels that do
> > > > different things to the random code path?  Do you have pointers to those
> > > > patches anywhere?  Why have the distros not submitted their changes
> > > > upstream?
> > > 
> > > I will leave the representatives from the distros to chime in and point to 
> > > these patches.
> > 
> > Then why not work with the distros to get these changes merged into the
> > kernel tree?  They know that keeping things out-of-the-tree costs them
> > time and money, so why are they keeping them there?
> 
> I can speak for my distro.
> We have not proposed them because they are hacks, we know they are
> hacks, and we know they are not the long term solution.

Hacks that work today are the step toward a real solution.

So please, propose them and we can evolve from that.

> Yet we have no better way (in our products, today) so far to deal with
> these issues because what is needed is an effort like LRNG (does not
> have to be this specific implementation), because hacks will not cut it
> in the long term.

So you want to ship this separate driver instead?  Great, but as I said
elsewhere, doing a wholesale replacement is almost never the right thing
to do.

Work off of those known-working-and-certified hacks.  Submit them and
let's go from there please.

thanks,

greg k-h

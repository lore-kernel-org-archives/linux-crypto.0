From: Sven-Haegar Koch <haegar@sdinet.de>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Thu, 8 Sep 2011 00:46:23 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1109080042270.20323@aurora>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <1315429827.3576.61.camel@lappy> <4E67E396.702@redhat.com> <201109071743.16811.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jarod Wilson <jarod@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	Ted Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sdinet.de ([78.47.32.153]:34222 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071Ab1IGW6J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Sep 2011 18:58:09 -0400
In-Reply-To: <201109071743.16811.sgrubb@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 7 Sep 2011, Steve Grubb wrote:

> On Wednesday, September 07, 2011 05:35:18 PM Jarod Wilson wrote:
> > Another proposal that has been kicked around: a 3rd random chardev, 
> > which implements this functionality, leaving urandom unscathed. Some 
> > udev magic or a driver param could move/disable/whatever urandom and put 
> > this alternate device in its place. Ultimately, identical behavior, but 
> > the true urandom doesn't get altered at all.
> 
> Right, and that's what I was trying to say is that if we do all that and switch out 
> urandom with something new that does what we need, what's the difference in just 
> patching the behavior into urandom and calling it a day? Its simpler, less fragile, 
> admins won't make mistakes setting up the wrong one in a chroot, already has the 
> FIPS-140 dressing, and is auditable.

I as a 0815 admin would never want such a thing by default.

I already replace /dev/random with /dev/urandom to keep stupid sshd from 
dying because there just is no entropy - I care more about all my 
services staying alive than about perfect random.

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.

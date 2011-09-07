From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Wed, 7 Sep 2011 16:02:24 -0400
Message-ID: <201109071602.24519.sgrubb@redhat.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <4E67B75B.8010500@redhat.com> <20110907192737.GD20571@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jarod Wilson <jarod@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab1IGUCj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Sep 2011 16:02:39 -0400
In-Reply-To: <20110907192737.GD20571@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, September 07, 2011 03:27:37 PM Ted Ts'o wrote:
> On Wed, Sep 07, 2011 at 02:26:35PM -0400, Jarod Wilson wrote:
> > We're looking for a generic solution here that doesn't require
> > re-educating every single piece of userspace. And anything done in
> > userspace is going to be full of possible holes -- there needs to be
> > something in place that actually *enforces* the policy, and
> > centralized accounting/tracking, lest you wind up with multiple
> > processes racing to grab the entropy.
> 
> Yeah, but there are userspace programs that depend on urandom not
> blocking... so your proposed change would break them.

The only time this kicks in is when a system is under attack. If you have set this and 
the system is running as normal, you will never notice it even there. Almost all uses 
of urandom grab 4 bytes and seed openssl or libgcrypt or nss. It then uses those 
libraries. There are the odd cases where something uses urandom to generate a key or 
otherwise grab a chunk of bytes, but these are still small reads in the scheme of 
things. Can you think of any legitimate use of urandom that grabs 100K or 1M from 
urandom? Even those numbers still won't hit the sysctl on a normally function system.

When a system is underattack, do you really want to be using a PRNG for anything like 
seeding openssl? Because a PRNG is what urandom degrades into when its attacked. If 
enough bytes are read that an attacker can guess the internal state of the RNG, do you 
really want it seeding a openssh session? At that point you really need it to stop 
momentarily until it gets fresh entropy so the internal state is unknown. That's what 
this is really about.

-Steve

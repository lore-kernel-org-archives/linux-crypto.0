From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Date: Wed, 13 May 2009 12:53:16 -0400
Message-ID: <200905131253.16977.jarod@redhat.com>
References: <200905111006.32675.jarod@redhat.com> <20090513132752.GA17262@gondor.apana.org.au> <20090513140224.GB16406@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46505 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757703AbZEMQyF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2009 12:54:05 -0400
In-Reply-To: <20090513140224.GB16406@hmsreliant.think-freely.org>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 13 May 2009 10:02:25 Neil Horman wrote:
> On Wed, May 13, 2009 at 11:27:52PM +1000, Herbert Xu wrote:
> > On Wed, May 13, 2009 at 09:12:46AM -0400, Jarod Wilson wrote:
> > > 
> > > Hm... FIPS has the requirement that we test all algs before we use any
> > > algs, self-tests on demand before first use for each alg is
> > > insufficient. At first blush, I'm not seeing how we ensure this
> > > happens. How can we trigger a cbc(des3_ede) self-test from userspace?
> > > I see that modprobe'ing des.ko runs the base des and des3_ede
> > > self-tests, but modprobe'ing cbc.ko doesn't lead to any self-tests
> > > being run.
> > 
> > Once we have a user-space interface crypto API you will be able
> > to instantiate any given algorithm.
> > 
> Thats a good idea.  Jarod, didn't you create a generic netlink socket family
> module that created just such an interface for testing purposes?

Indeed. Works quite well for my somewhat specific needs...

> That might be
> worth polishing and submitting to provide that user space crypto api

It would likely need a LOT of polish, and I'm not sure if its at all
close to what we have (Herbert has?) in mind.... At the moment, it
consists of:

1) a kernel module, which duplicates many of the functions in testmgr,
more or less, but gets its input over a generic netlink socket, rather
than from a static array, and sends the result back out over the same
socket.

2) a userspace binary that feeds very specifically formatted vectors
to the kernel via the netlink socket, listens for the result and
spits it out -- it doesn't actually verify the correctness of the
result, but adding support for passing in an expected result and
checking against it would be trivial.

I guess the place to start would be to ask exactly what sort of
user-space interface to the crypto API did we have in mind here?
i.e., what sort of user-space<->kernel-space communication is
envisioned, and what sort of functionality should be present?

I could see the desire for a simpler interface that doesn't rely upon
a specific userspace binary -- something sysfs or proc-based -- but
netlink is reasonably flexible...

-- 
Jarod Wilson
jarod@redhat.com

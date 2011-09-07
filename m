From: Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Wed, 07 Sep 2011 22:05:30 +0300
Message-ID: <1315422330.3576.22.camel@lappy>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	 <1315417137-12093-1-git-send-email-jarod@redhat.com>
	 <1315419179.3576.6.camel@lappy>  <4E67B75B.8010500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E67B75B.8010500@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2011-09-07 at 14:26 -0400, Jarod Wilson wrote:
> Sasha Levin wrote:
> > On Wed, 2011-09-07 at 13:38 -0400, Jarod Wilson wrote:
> >> Certain security-related certifications and their respective review
> >> bodies have said that they find use of /dev/urandom for certain
> >> functions, such as setting up ssh connections, is acceptable, but if and
> >> only if /dev/urandom can block after a certain threshold of bytes have
> >> been read from it with the entropy pool exhausted. Initially, we were
> >> investigating increasing entropy pool contributions, so that we could
> >> simply use /dev/random, but since that hasn't (yet) panned out, and
> >> upwards of five minutes to establsh an ssh connection using an
> >> entropy-starved /dev/random is unacceptable, we started looking at the
> >> blocking urandom approach.
> >
> > Can't you accomplish this in userspace by trying to read as much as you
> > can out of /dev/random without blocking, then reading out
> > of /dev/urandom the minimum between allowed threshold and remaining
> > bytes, and then blocking on /dev/random?
> >
> > For example, lets say you need 100 bytes of randomness, and your
> > threshold is 30 bytes. You try reading out of /dev/random and get 50
> > bytes, at that point you'll read another 30 (=threshold) bytes
> > out /dev/urandom and then you'll need to block on /dev/random until you
> > get the remaining 20 bytes.
> 
> We're looking for a generic solution here that doesn't require 
> re-educating every single piece of userspace. [...]

A flip-side here is that you're going to break every piece of userspace
which assumed (correctly) that /dev/urandom never blocks. Since this is
a sysctl you can't fine tune which processes/threads/file-handles will
block on /dev/urandom and which ones won't.

> [..] And anything done in 
> userspace is going to be full of possible holes [..]

Such as? Is there an example of a case which can't be handled in
userspace?

>  [..] there needs to be 
> something in place that actually *enforces* the policy, and centralized 
> accounting/tracking, lest you wind up with multiple processes racing to 
> grab the entropy.

Does the weak entropy you get out of /dev/urandom get weaker the more
you pull out of it? I assumed that this change is done because you want
to limit the amount of weak entropy mixed in with strong entropy.


btw, Is the threshold based on a research done on the linux RNG? Or is
it an arbitrary number that would be set by your local sysadmin? 

-- 

Sasha.

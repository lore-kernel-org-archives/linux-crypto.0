From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a Chacha20-based CRNG
Date: Sun, 26 Jun 2016 21:10:27 +0200
Message-ID: <8840517.mXnBKpSaCu@positron.chronox.de>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu> <20160619231827.GB9848@thunk.org> <20160626184743.GA11162@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:38288 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbcFZTK3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 26 Jun 2016 15:10:29 -0400
In-Reply-To: <20160626184743.GA11162@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 26. Juni 2016, 20:47:43 schrieb Pavel Machek:

Hi Pavel,

> Hi!
> 
> > Yes, I understand the argument that the networking stack is now
> > requiring the crypto layer --- but not all IOT devices may necessarily
> > require the IP stack (they might be using some alternate wireless
> > communications stack) and I'd much rather not make things worse.
> > 
> > 
> > The final thing is that it's not at all clear that the accelerated
> > implementation is all that important anyway.  Consider the following
> > two results using the unaccelerated ChaCha20:
> > 
> > % dd if=/dev/urandom bs=4M count=32 of=/dev/null
> > 32+0 records in
> > 32+0 records out
> > 134217728 bytes (134 MB, 128 MiB) copied, 1.18647 s, 113 MB/s
> > 
> > % dd if=/dev/urandom bs=32 count=4194304 of=/dev/null
> > 4194304+0 records in
> > 4194304+0 records out
> > 134217728 bytes (134 MB, 128 MiB) copied, 7.08294 s, 18.9 MB/s
> > 
> > So in both cases, we are reading 128M from the CRNG.  In the first
> > case, we see the sort of speed we would get if we were using the CRNG
> > for some illegitimate, such as "dd if=/dev/urandom of=/dev/sdX bs=4M"
> > (because they were too lazy to type "apt-get install nwipe").
> > 
> > In the second case, we see the use of /dev/urandom in a much more
> > reasonable, proper, real-world use case for /de/urandom, which is some
> > userspace process needing a 256 bit session key for a TLS connection,
> > or some such.  In this case, we see that the other overheads of
> > providing the anti-backtracking protection, system call overhead,
> > etc., completely dominate the speed of the core crypto primitive.
> > 
> > So even if the AVX optimized is 100% faster than the generic version,
> > it would change the time needed to create a 256 byte session key from
> > 1.68 microseconds to 1.55 microseconds.  And this is ignoring the
> 
> Ok, so lets say I'm writing some TLS server, and I know that traffic
> is currently heavy because it was heavy in last 5 minutes. Would it
> make sense for me to request 128M of randomness from /dev/urandom, and
> then use that internally, to avoid the syscall overhead?
> 
> Ok, maybe 128M is a bit much because by requesting that much in single
> request i'd turn urandom into PRNG, but perhaps 1MB block makes sense?

I would definitely say that this is appropriate when you use the data stream 
from urandom directly as keying material.
> 
> And I guess even requesting 128M would make sense, as kernel can
> select best crypto implementation for CRNG, and I'd prefer to avoid
> that code in my application as it is hardware-specific...

The code in the server should only make sure it memset(0) any of the random 
data immediately after use. This way even when the server dumps core, all you 
see is *unused* random data which does not hurt.

Ciao
Stephan

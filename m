From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] random: make /dev/urandom scalable for silly
 userspace programs
Date: Mon, 2 May 2016 08:50:14 -0400
Message-ID: <20160502125014.GE4770@thunk.org>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-3-git-send-email-tytso@mit.edu>
 <1876896.u5f6KW2BnX@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35582 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbcEBMu3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 08:50:29 -0400
Content-Disposition: inline
In-Reply-To: <1876896.u5f6KW2BnX@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 02, 2016 at 09:00:22AM +0200, Stephan Mueller wrote:
> - reseed avalanche: I see that you added a time-based reseed code too (I am 
> glad about that one). What I fear is that there is a reseed avalanche when the 
> various RNGs are seeded initially closely after each other (and thus the 
> reseed timer will expire at the same time). That would mean that they can be 
> reseeded all at the same time again when the timer based threshold expires and 
> drain the input_pool such that if you have many nodes, the input pool will not 
> have sufficient capacity (I am not speaking about entropy, but the potential 
> to store entropy) to satisfy all RNGs at the same time. Hence, we would then 
> have the potential to have entropy-starved RNGs.

The crng is a CRNG, not an entropy pool.  So we don't pretend to track
entropy on the CRNG's at all.  The current rule is that when you draw
from a crng, if it has been over 5 mintues, it will reseed from its
"parent" source.  In the case of the primary_crng will draw between
128 and 256 bits of entropy from the input pool.  In the per-NUMA node
case, they draw from the primary_crng.

So if there are many secondary (per-NUMA node) CRNG's that are seeded
within five minutes of each other, the input pool only gets drawn down
once to seed the primary_crng.  The per-NUMA node crng's feed from the
primary crng, and absent some catastrophic security breach where the
adversary can read kernel memory (at which point you're toast anyway)
the output of the primary_crng is never exposed directly outside of
the system.  So even if you have some crazy SGI system with 1024 NUMA
nodes, the primary_crng will only be generating at most 32k worth of
data to seed the secondary crng's before it gets reseed --- and the
input pool is only going to be debited at most 128-256 bits of entropy
each time.

I thought about using the primary_crng to serve double duty as the
CRNG for NUMA node 0, but I decided that on a NUMA system you have
TB's and TB's of memory, and so blowing another 80 bytes or so on a
separate primary_crng state makes the security analysis much simpler,
and the code much simpler.  I also thought about only dynamically
initializing a node_id's CRNG if a spin_trylock on node 0's CRNG
failed, but again, decided against it in the itnerests of keeping
things simple and that NUMA people can afford to be profligate with
memory --- and they're blowing way more than 80 bytes per NUMA node
anyway.  Besides, manufactuers of crazy-expensive NUMA systems have to
feed their children, too.  :-)

> - entropy pool draining: when having a timer-based reseeding on a quiet 
> system, the entropy pool can be drained during the expiry of the timer. So, I 
> tried to handle that by increasing the timer by, say, 100 seconds for each new 
> NUMA node. Note, even the baseline of 300 seconds with CRNG_RESEED_INTERVAL is 
> low. When I experimented with that on a KVM test system and left it quiet, 
> entropy pool draining was prevented at around 500 seconds.

Sure, but if no one is actually *using* the system, who cares about
whether the input pool's entropy is getting drawn down?  The usual
reason why we might want to worry about reseeding frequently is if the
system is generating a huge amount of randomness for some reason.
This might be a good reason (you're running a IPSEC server and
generating lots of IKE session keys) or it might be for a really
stupid reason (dd if=/dev/urandom of=/dev/sdX bs=4k), but either way,
there will be lots of disk or networking interrupts to feed the input
pool.

I have thought about adding something a bit more sophisticated to
control the reseed logic (either tracking amount of data used, or
making the reseed interval adjustable, or dynamically adjustable), but
this was the simplest thing to do as a starting point.  Besides for
the people who believe that it's realistic to write academic papers
about recovering from catastrophic security exposures where the bad
guy can read arbitrary kernel memory, and somehow _not_ managed to
bootstrap that into a full privilege escalation attack and installed a
backdoor into your BIOS so that you are permanently pwned, they might
be happy that we will be trying to recover within 5 minutes.  :-)

					- Ted

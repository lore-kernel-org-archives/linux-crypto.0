From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/3] random: make /dev/urandom scalable for silly userspace programs
Date: Mon, 02 May 2016 09:00:22 +0200
Message-ID: <1876896.u5f6KW2BnX@tauon.atsec.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu> <1462170413-7164-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54412 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbcEBHAa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 03:00:30 -0400
In-Reply-To: <1462170413-7164-3-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 2. Mai 2016, 02:26:52 schrieb Theodore Ts'o:

Hi Theodore,

I have not digested the patch set yet, but I have the following questions to 
your patch set.

> On a system with a 4 socket (NUMA) system where a large number of
> application processes were all trying to read from /dev/urandom, this
> can result in the system spending 80% of its time contending on the
> global urandom spinlock.  The application have used its own PRNG, but
> let's try to help it from running, lemming-like, straight over the
> locking cliff.

- initialization: In my DRBG based patch-set I tried serialize the 
initialization of the per-NUMA node RNGs as follows: first the node 0 pool is 
seeded completely, followed by the other nodes in a completely serial fashion. 
If during that initialization time, say, node 3 wants some random number, but 
the RNG for node 3 is not yet fully seeded, it goes back to the "default" RNG 
of node 0. This way, it is ensured that we try to have properly seeded RNGs 
even during heavy load at boot time. Would that make sense here?

- reseed avalanche: I see that you added a time-based reseed code too (I am 
glad about that one). What I fear is that there is a reseed avalanche when the 
various RNGs are seeded initially closely after each other (and thus the 
reseed timer will expire at the same time). That would mean that they can be 
reseeded all at the same time again when the timer based threshold expires and 
drain the input_pool such that if you have many nodes, the input pool will not 
have sufficient capacity (I am not speaking about entropy, but the potential 
to store entropy) to satisfy all RNGs at the same time. Hence, we would then 
have the potential to have entropy-starved RNGs.

- entropy pool draining: when having a timer-based reseeding on a quiet 
system, the entropy pool can be drained during the expiry of the timer. So, I 
tried to handle that by increasing the timer by, say, 100 seconds for each new 
NUMA node. Note, even the baseline of 300 seconds with CRNG_RESEED_INTERVAL is 
low. When I experimented with that on a KVM test system and left it quiet, 
entropy pool draining was prevented at around 500 seconds.

Ciao
Stephan

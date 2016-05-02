From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] random: make /dev/urandom scalable for silly
 userspace programs
Date: Mon, 2 May 2016 09:48:57 -0400
Message-ID: <20160502134857.GG4770@thunk.org>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
 <1462170413-7164-3-git-send-email-tytso@mit.edu>
 <1876896.u5f6KW2BnX@tauon.atsec.com>
 <20160502125014.GE4770@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35740 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbcEBNtH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 09:49:07 -0400
Content-Disposition: inline
In-Reply-To: <20160502125014.GE4770@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 02, 2016 at 08:50:14AM -0400, Theodore Ts'o wrote:
> > - entropy pool draining: when having a timer-based reseeding on a quiet 
> > system, the entropy pool can be drained during the expiry of the timer. So, I 
> > tried to handle that by increasing the timer by, say, 100 seconds for each new 
> > NUMA node. Note, even the baseline of 300 seconds with CRNG_RESEED_INTERVAL is 
> > low. When I experimented with that on a KVM test system and left it quiet, 
> > entropy pool draining was prevented at around 500 seconds.

One other thought.  If your KVM test system was completely quiet, then
all of the entropy was coming from timer interrupts.  It is an open
question whether an adversary could predict the bit of "entropy" you
are generating with better than 50% probability if both the host and
the guest system are quiescent.  And if they can, then maybe assuming
one bit of entropy per interrupt might be a too optimistic.

This is especially true on bare metal where very often, especially on
smaller machines, where there is a single oscillator from which all of
the clocks on the SOC or motherboard are derived.  There is a reason
why I was being ultra conservative in sampling 64 interrupts into a
32-bit fast-mix pool before mixing it into the input pool, and only
crediting the pool with a single bit of entropy each time I did this.

(It's also because of this conservatism that I was comfortable with
having add_disk_randomness giving some extra credit for interrupts
that are probably more likely to be hard-to-predict by an adversary.
Especially if the interrupts are coming from a device with spinning
rust platters.)

						- Ted

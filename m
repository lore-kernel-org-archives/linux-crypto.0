From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/3] random: make /dev/urandom scalable for silly userspace programs
Date: Mon, 02 May 2016 15:53:55 +0200
Message-ID: <1679147.StTJyR8tOp@tauon.atsec.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu> <20160502125014.GE4770@thunk.org> <20160502134857.GG4770@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54464 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbcEBNx6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 09:53:58 -0400
In-Reply-To: <20160502134857.GG4770@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 2. Mai 2016, 09:48:57 schrieb Theodore Ts'o:

Hi Theodore,

> On Mon, May 02, 2016 at 08:50:14AM -0400, Theodore Ts'o wrote:
> > > - entropy pool draining: when having a timer-based reseeding on a quiet
> > > system, the entropy pool can be drained during the expiry of the timer.
> > > So, I tried to handle that by increasing the timer by, say, 100 seconds
> > > for each new NUMA node. Note, even the baseline of 300 seconds with
> > > CRNG_RESEED_INTERVAL is low. When I experimented with that on a KVM
> > > test system and left it quiet, entropy pool draining was prevented at
> > > around 500 seconds.
> 
> One other thought.  If your KVM test system was completely quiet, then
> all of the entropy was coming from timer interrupts.  It is an open
> question whether an adversary could predict the bit of "entropy" you
> are generating with better than 50% probability if both the host and
> the guest system are quiescent.  And if they can, then maybe assuming
> one bit of entropy per interrupt might be a too optimistic.

It is not entirely quiet -- systemd likes to dump data on the disk once in a 
while. So, it is no timer interrupt that I see.

Note, my test system runs as tickless kernel.
> 
> This is especially true on bare metal where very often, especially on
> smaller machines, where there is a single oscillator from which all of
> the clocks on the SOC or motherboard are derived.  There is a reason
> why I was being ultra conservative in sampling 64 interrupts into a
> 32-bit fast-mix pool before mixing it into the input pool, and only
> crediting the pool with a single bit of entropy each time I did this.

As I do not think that we see any timer interrupts, I think this argument may 
not count.

Besides, I have not seen any timer interrupts lately (with or without a 
tickless kernel). Thus, which interrupt do you think is a timer interrupt?


Ciao
Stephan

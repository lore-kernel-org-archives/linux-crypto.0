From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
Date: Sun, 10 Feb 2013 19:05:39 -0500
Message-ID: <20130211000539.GC10801@thunk.org>
References: <51157686.9000404@chronox.de>
 <20130209180629.GD8091@thunk.org>
 <20130210015751.GA13690@unpythonic.net>
 <5117969A.1080909@chronox.de>
 <20130210185002.GA10801@thunk.org>
 <5117F5D5.8040709@chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Epler <jepler@unpythonic.net>, linux-crypto@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47799 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab3BKAFq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Feb 2013 19:05:46 -0500
Content-Disposition: inline
In-Reply-To: <5117F5D5.8040709@chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 10, 2013 at 08:32:37PM +0100, Stephan Mueller wrote:
> 
> Given all your doubts on the high-precision timer, how can you
> reasonably state that the Linux kernel RNG is good then?

Because we're measuring intervals that are substantially larger than
"CPU jitter".  (i.e., inputs from keyboards and mice, interrupts from
hard drives and networks, etc.)

> The data from add_timer_randomness the kernel feeds into the input_pool
> is a concatenation of the event value, the jiffies and the get_cycles()
> value. The events hardly contains any entropy, the jiffies a little bit
> due to the coarse resolution of 250 or 1000 Hz. Only the processor
> cycles value provides real entropy.

Jiffies is defined by 250HZ (4ms) on modern Linux kernels, at least
for x86 systems.  Average seek times for common HDD's are 10ms, with
full-stroke seek times being roughly twice that, and seek times
perhaps 50% slower for laptop/mobile HDD's, and 50% faster for
high-end server drives.  So that's enough to get maybe a bit or two
worth's of entropy for HDD interrupts.

(Yes, this does imply that the entropy estimator for /dev/random is
probably overestimating the entropy in a number of cases; in general,
it's actually pretty difficult to measure entropy accurately in an
automated way.)

> Moreover, I cannot understand your comments on VMs -- on x86, the timer
> depends on the rdtsc instruction which should be available on current
> CPUs and is callable from user space. Hence, there should be no obstacle
> to use this instruction within a VM and get a good reading.

The problem is one of correctness versus performance.  (The TSC is
unsynchronized across different CPU cores, and the guest OS has no
idea when it gets switched to running on a different core on the host
CPU.)  As a result, on many/most VM's the TSC is emulated or
paravirtualized.  For example, see:

http://old-list-archives.xen.org/archives/html/xen-devel/2009-08/msg01103.html

for a discussion of the issues involved.

Regards,

						- Ted

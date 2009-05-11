From: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH] The VIA Hardware RNG driver is for the CPU, not Chipset
Date: Mon, 11 May 2009 10:58:52 +0800
Message-ID: <20090511025852.GE4005@prithivi.gnumonks.org>
References: <20090510062844.GD12152@prithivi.gnumonks.org> <4A076D61.1040608@list.nospam.xutrox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Arjan Koers <4kgluc2fa5qp@list.nospam.xutrox.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:47488 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbZEKDAK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 May 2009 23:00:10 -0400
Content-Disposition: inline
In-Reply-To: <4A076D61.1040608@list.nospam.xutrox.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Arjan,

On Mon, May 11, 2009 at 02:12:17AM +0200, Arjan Koers wrote:
> Harald Welte wrote:
> > This is a cosmetic change, fixing the MODULE_DESCRIPTION() of via-rng.c
> 
> Coincidentally, I was trying to make my RNG work for x86_64 today and I
> was wondering about this. 

I like those coincidences :)

> How can multiple RNGs in current dual-processor setups and in the future
> multicore Nano be handled?
 
That's actually a good question.  I'll probably forward that to the CPU
division and see what they come up with.  I would assume you just run the
initialization on every CPU, and that's it.

Now the more interesting question is: how can the hw_random framework deal
with it?  As far as I remember, it can only select one out of N available
concurrent providers of hardware randomness.  correct?

> The MSR wizardry in via_rng_init doesn't seem to work on my Nano. 

This is due to the fact that the MSR itself does no longer exist on the Nano.
It only exists on C3 to C7 silicon.

> I'm simply skipping it with the patch below, because my RNG is enabled by
> default. 

yes, this is the correct method.  On Nano you only have to see if it is enabled
in CPUID and forget about

> I don't know the proper way to initialize it because of lacking
> documentation. 

the quick reference for padlock on the nano is public, despite not
at a very well-known location:
ftp://ftp.vtbridge.org/Docs/CPU/Nano/padlock_quick_reference_V095.pdf

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison

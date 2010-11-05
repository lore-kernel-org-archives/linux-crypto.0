From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH] crypto: padlock: fix for non-64byte aligned data
Date: Fri, 5 Nov 2010 15:12:38 +0100
Message-ID: <20101105141238.GG29793@orbit.nwl.cc>
References: <1288893036-31704-1-git-send-email-phil@nwl.cc>
 <20101104184606.GA1994@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
	Nico Erfurth <ne@erfurth.eu>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.169.95]:39089 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab0KEOMj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Nov 2010 10:12:39 -0400
Content-Disposition: inline
In-Reply-To: <20101104184606.GA1994@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

On Thu, Nov 04, 2010 at 01:46:06PM -0500, Herbert Xu wrote:
> > On one hand, the original code is broken in padlock_xcrypt_cbc(): when
> > passing the "initial" bytes to xcryptcbc, 'count' is incorrectly used as
> > length. This may trigger prefetch-related issues, but will definitely
> > lead to data corruption as xcryptcbc is called again afterwards,
> > altering (count - initial) * AES_BLOCK_SIZE bytes after the end of
> > 'output' in memory.
> 
> Ouch, does the attached patch fix this problem for you?

Yes, kind of. With that trivial fix applied, the driver is stable most
of the time.

> > Another problem occurs when passing non-64byte aligned buffers, which
> > leads to memory corruption in userspace (running applications crash
> > randomly). This problem is too subtile for me to have more than vague
> > assumptions about it's origin. Anyways, this patch fixes them:
> 
> I'd like to determine whether this is due to the previous bug.
> If it still crashes randomly even with my one-line patch please
> let me know.

Yes, it does, but triggering the bug is not really trivial. I've had
best results with a speed testing tool using the asynchronous interface,
memory corruption occured in each run. The same tool operating
synchronously doesn't crash as soon, but having three or more instances
running in parallel yields the same result.

This problem is so racey, a simple printk statement at the beginning of
padlock_xcrypt_ecb() fixes it. Enclosing the same function's content in
lock_kernel()/unlock_kernel() statements helps as well.

> > Instead of handling the "odd" bytes (i.e., the remainder when dividing
> > into prefetch blocks of 64bytes) at the beginning, go for them in the
> > end, copying the data out if prefetching would run beyond the page
> > boundary.
> 
> I'd like to avoid this copying unless the hardware really needs
> it.

As stated initially, I'm not sure why the proposed change fixes
anything. AFAICT, both algorithms are correct in theory. I can't find a
case that breaks the original one reproducably. So my confidence
regarding the change's validity is based on trial and error. Maybe
someone with more knowledge about the various Via erratae can provide
some insights here.

> Can you provide some information on the CPU where you're seeing
> this?

This is the faulty one:
| -bash-4.0# cat /proc/cpuinfo 
| processor	: 0
| vendor_id	: CentaurHauls
| cpu family	: 6
| model		: 15
| model name	: VIA Nano processor L2200@1600MHz
| stepping	: 2
| cpu MHz	: 1599.696
| cache size	: 1024 KB
| fdiv_bug	: no
| hlt_bug	: no
| f00f_bug	: no
| coma_bug	: no
| fpu		: yes
| fpu_exception	: yes
| cpuid level	: 10
| wp		: yes
| flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush acpi mmx fxsr sse sse2 ss tm syscall nx fxsr_opt rdtscp lm constant_tsc rep_good pni monitor est tm2 ssse3 cx16 xtpr rng rng_en ace ace_en ace2 phe phe_en lahf_lm
| bogomips	: 3199.39
| clflush size	: 64
| cache_alignment	: 128
| address sizes	: 36 bits physical, 48 bits virtual
| power management:

I have a C7 for comparison:
| -bash-4.0# cat /proc/cpuinfo 
| processor	: 0
| vendor_id	: CentaurHauls
| cpu family	: 6
| model		: 13
| model name	: VIA C7 Processor 1500MHz
| stepping	: 0
| cpu MHz	: 1500.100
| cache size	: 128 KB
| fdiv_bug	: no
| hlt_bug	: no
| f00f_bug	: no
| coma_bug	: no
| fpu		: yes
| fpu_exception	: yes
| cpuid level	: 1
| wp		: yes
| flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge cmov pat clflush acpi mmx fxsr sse sse2 tm nx pni est tm2 xtpr rng rng_en ace ace_en ace2 ace2_en phe phe_en pmm pmm_en
| bogomips	: 3000.20
| clflush size	: 64
| cache_alignment	: 64
| address sizes	: 36 bits physical, 32 bits virtual
| power management:

The C7 is definitely not affected by this bug, so your one-liner fixes all
issues for it.

Greetings, Phil

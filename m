From: Alden Tondettar <alden.tondettar@gmail.com>
Subject: Re: [PATCH] random: Don't overwrite CRNG state in crng_initialize()
Date: Thu, 9 Feb 2017 01:13:22 -0700
Message-ID: <20170209081322.GA17535@rincewind>
References: <1486611086-2290-1-git-send-email-alden.tondettar@gmail.com>
 <20170209041931.xgkmysquazppiewx@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170209041931.xgkmysquazppiewx@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 08, 2017 at 11:19:31PM -0500, Theodore Ts'o wrote:
> How did you determine when crng_initialize() was being called?  On a
> VM generally there are fewer interrupts than on real hardware.  On
> KVM, for I see the random: fast_init message being printed 3.6 seconds
> into the boot.
> 
> On Google Compute Engine, the fast_init message happens 52 seconds into the
> boot.
> 
> So what VM where you using?  I'm trying to figure out whether this is
> hypothetical or real problem, and on what systems.

Adding a few printk()s to the latest kernel:

@@ -778,6 +778,8 @@ static void crng_initialize(struct crng_state *crng)
        int             i;
        unsigned long   rv;
 
+       printk("crng_initialize called\n");
+
        memcpy(&crng->state[0], "expand 32-byte k", 16);
        if (crng == &primary_crng)
                _extract_entropy(&input_pool, &crng->state[4],
@@ -1149,6 +1151,9 @@ void add_interrupt_randomness(int irq, int irq_flags)
        fast_mix(fast_pool);
        add_interrupt_bench(cycles);
 
+       if (fast_pool->count >= 64)
+              printk("add_interrupt_randomness: fast_pool->count >= 64, dumping entropy");
+
        if (!crng_ready()) {
                if ((fast_pool->count >= 64) &&
                    crng_fast_load((char *) fast_pool->pool,

And using:

$ qemu-system-x86_64 --version
QEMU emulator version 2.1.2 (Debian 1:2.1+dfsg-12+deb8u6), Copyright (c) 2003-2008 Fabrice Bellard
$ qemu-system-x86_64 -nographic -enable-kvm -m 1024M -kernel bzImage -append "root=/dev/sda1 loglevel=3 console=ttyS0" hd3

I get:

[    0.010247] mce: CPU supports 10 MCE banks
[    0.010317] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010318] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.064002] add_interrupt_randomness: fast_pool->count >= 64, dumping entropy
[    0.128003] add_interrupt_randomness: fast_pool->count >= 64, dumping entropy
[    0.160364] Freeing SMP alternatives memory: 36K
[    0.160428] ftrace: allocating 35771 entries in 140 pages
[    0.172384] smpboot: Max logical packages: 1
[    0.173964] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.184000] add_interrupt_randomness: fast_pool->count >= 64, dumping entropy
[    0.184000] add_interrupt_randomness: fast_pool->count >= 64, dumping entropy
[    0.184000] random: fast init done
[    0.184000] smpboot: CPU0: Intel QEMU Virtual CPU version 2.1.2 (family: 0x6,
 model: 0x6, stepping: 0x3)
[    0.184000] Performance Events: PMU not available due to virtualization, usin
g software events only.
[    0.184000] crng_initialize called
[    0.184000] crng_initialize called
[    0.184000] smp: Bringing up secondary CPUs ...
[    0.184000] smp: Brought up 1 node, 1 CPU

Sometimes I get three add_interrupt_randomness lines instead of four which
is fine but still cutting things awfully close.

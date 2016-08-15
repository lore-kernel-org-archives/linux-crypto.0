From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Mon, 15 Aug 2016 11:00:57 -0400
Message-ID: <20160815150057.GA10324@thunk.org>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
 <6876524.OiXCMsNJHH@tauon.atsec.com>
 <20160812192208.GA30280@thunk.org>
 <1756772.RGD5U4JGHJ@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56982 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbcHOPBK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Aug 2016 11:01:10 -0400
Content-Disposition: inline
In-Reply-To: <1756772.RGD5U4JGHJ@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 15, 2016 at 08:13:06AM +0200, Stephan Mueller wrote:
> 
> According to my understanding of NAPI, the network card sends one interrupt 
> when receiving the first packet of a packet stream and then the driver goes 
> into polling mode, disabling the interrupt. So, I cannot see any batching 
> based on some on-board timer where add_interrupt_randomness is affected.
>  
> Can you please elaborate?

>From https://wiki.linuxfoundation.org/networking/napi:

    NAPI (“New API”) is an extension to the device driver packet
    processing framework, which is designed to improve the performance
    of high-speed networking. NAPI works through:

    * Interrupt mitigation
    * High-speed networking can create thousands of interrupts per
      second, all of which tell the system something it already knew:
      it has lots of packets to process. NAPI allows drivers to run
      with (some) interrupts disabled during times of high traffic,
      with a corresponding decrease in system load.
      ...

The idea is to mitigate the CPU load from having a large number of
interrupts.  Spinning in a tight loop, wihch is what polling odoes,
doesn't help reduce the CPU load.  So it's *not* what you would want
to do on a small-count core CPU, or on a bettery operated device.

What you're thinking about is a technique to reduce interrupt latency,
which might be useful on a 32-core server CPU where trading off power
consumption for interrupt latency makes sense.  But NAPI is the exact
reverese thing --- it trades interrupt latency for CPU and power
efficiency.

NAPI in its traditional works by having the interrupt card *not* send
an interrupt after the packet comes in, and instead accumulate packets
in a buffer.  The interupt only gets sent after an short timeout, or
when the on-NIC buffer is in danger of filling.  As a result, when
interrupts get sent might be granularized based on some clock --- and
on small systems, there may only be a single CPU on that clock.

> Well, injecting a trojan to a system in user space as unprivileged user that 
> starts some X11 session and that can perform the following command is all you 
> need to get to the key commands of the console.
> 
> xinput list |   grep -Po 'id=\K\d+(?=.*slave\s*keyboard)' |   xargs -P0 -n1 
> xinput test
> 
> That is fully within reach of not only some agencies but also other folks. It 
> is similar for mice.

This doesn't result in keyboard and mice interrupts, which is how
add_input_randomness() works.  So it's mostly irrelevant.

> When you refer to my Jitter RNG, I think I have shown that its strength comes 
> from the internal state of the CPU (states of the internal building blocks 
> relative to each other which may cause internal wait states, state of branch 
> prediction or pipelines, etc.) and not of the layout of the CPU.

All of this is deterministic.  Just as AES_ENCRPT(NSA_KEY, COUNTER++)
is completely deterministic and dependant on the internal state of the
PRNG.  But it's not random, and if you don't know NSA_KEY you can't
prove that it's not really random.

> On VMs, the add_disk_randomness is always used with the exception of KVM when 
> using a virtio disk. All other VMs do not use virtio and offer the disk as a 
> SCSI or IDE device. In fact, add_disk_randomness is only disabled when the 
> kernel detects:
> 
> - SDDs
> 
> - virtio
> 
> - use of device mapper

AWS uses para-virtualized SCSI; Google Compute Engine uses
virtio-SCSI.  So the kernel should know that these are virtual
devices, and I'd argue that if we're setting the add_random flag, we
shouldn't be.

> > As far as whether you can get 5-6 bits of entropy from interrupt
> > timings --- that just doesn't pass the laugh test.  The min-entropy
> 
> May I ask what you find amusing? When you have a noise source for which you 
> have no theoretical model, all you can do is to revert to statistical 
> measurements.

So tell me, how much "minimum", "conservative" entropy do the non-IID
tests report when fed as input AES_ENCRYPT*NSA_KEY, COUNTER++)?

Sometimes, laughing is better than crying.  :-)

> Just see the guy that sent an email to linux-crypto today. His MIPS /dev/
> random cannot produce 16 bytes of data within 4 hours (which is similar to 
> what I see on POWER systems). This raises a very interesting security issue: /
> dev/urandom is not seeded properly. And we all know what folks do in the wild: 
> when /dev/random does not produce data, /dev/urandom is used -- all general 
> user space libs (OpenSSL, libgcrypt, nettle, ...) seed from /dev/urandom per 
> default.
>
> And I call that a very insecure state of affairs.

Overestimating entropy that isn't there doesn't actually make things
more secure.  It just makes people feel better.  This is especially
true if the goal is declare the /dev/urandom to be fully initialized
before userspace is started.  So if the claim is that your "LRNG" can
fully initialize the /dev/urandom pool, and it's using fundamentally
using the same interrupt sampling techniques as what is currently in
the kernel, then there is no substantive difference in security
between using /dev/urandom and using /dev/urandom with your patches
applied and enabled.

In the case of MIPS it doesn't have a high resolution timer, so it
*will* have less entropy that it can gather using interrupts compared
to an x86 system.  So i'd much rather be very conservative and
encourage people to use a CPU that *does* have a high resolution timer
or a hardware random number generator, or use some other very
carefully seeding via the bootloader or some such, rather than lull
them into a potentially false sense of security.

> As mentioned, to my very surprise, I found that interrupts are the only thing 
> in a VM that works extremely well even under attack scenarios. VMMs that I 
> quantiatively tested include QEMU/KVM, VirtualBox, VMWare ESXi and Hyper-V. 
> After more research, I came to the conclusion that even on the theoretical 
> side, it must be one of the better noise sources in a VM.

Again, how does your quantitive tests work on AES_ENCRYPT(NSA_KEY, COUNTER++)?

> I am concerned about the *two* separate injections of 64 bits. It should 
> rather be *one* injection of at least 112 bit (or 128 bits). This is what I 
> mean with "atomic" operation here.

We only consider urandom/getrandom CRNG to be initialized when 2
injections happen without an intervening extract operation.  If there
is an extract operation, we print a warning and then reset the
counter.  So by the time /dev/urandom is initialized, it has had two
"atomic" injections of entropy.  It's the same kind of atomicity which
is provided by the seqlock_t abstraction in the linux kernel.


> For example, the one key problem I have with the ChaCha20 DRNG is the 
> following: when final update of the internal state is made for enhanced 
> prediction resistance, ChaCha20 is used to generate one more block. That new 
> block has 512 bits in size. In your implementation, you use the first 256 bits 
> to inject it back into ChaCha20 as key. I use the entire 512 bits. I do not 
> know whether one is better than the other (in the sense that it does not loose 
> entropy). But barring any real research from other cryptographers, I guess we 
> both do not know. And I have seen that such subtle issues may lead to 
> catastrophic problems.

Chacha20 uses a 256-bit key, and what I'm doing is folding in 256 bits
into the ChaCha20 key.  The security strength that we're claiming fom
in the SP800-90A DRBG model is 256 bits (the maximum from the
SP800-90A set of 112, 128, 192, or 256), and so I'd argue that what
I'm doing is sufficient.

Entropy doesn't really have a meaning in a DRBG, so SP800-90A wouldn't
have anything to say anything about either alternative.

Cheers,

							- Ted

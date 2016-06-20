From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Mon, 20 Jun 2016 20:32:43 +0200
Message-ID: <8999970.pstTbGZv5G@positron.chronox.de>
References: <1466007463.20087.11.camel@redhat.com> <3381856.qSaz1KcX2Z@positron.chronox.de> <f22f4cd6-8198-71a0-9b79-9f10070758f3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	David =?utf-8?B?SmHFoWE=?= <djasa@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f22f4cd6-8198-71a0-9b79-9f10070758f3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 20. Juni 2016, 13:07:32 schrieb Austin S. Hemmelgarn:

Hi Austin,

> On 2016-06-18 12:31, Stephan Mueller wrote:
> > Am Samstag, 18. Juni 2016, 10:44:08 schrieb Theodore Ts'o:
> > 
> > Hi Theodore,
> > 
> >> At the end of the day, with these devices you really badly need a
> >> hardware RNG.  We can't generate randomness out of thin air.  The only
> >> thing you really can do requires user space help, which is to generate
> >> keys lazily, or as late as possible, so you can gather as much entropy
> >> as you can --- and to feed in measurements from the WiFi (RSSI
> >> measurements, MAC addresses seen, etc.)  This won't help much if you
> >> have an FBI van parked outside your house trying to carry out a
> >> TEMPEST attack, but hopefully it provides some protection against a
> >> remote attacker who isn't try to carry out an on-premises attack.
> > 
> > All my measurements on such small systems like MIPS or smaller/older ARMs
> > do not seem to support that statement :-)
> 
> Was this on real hardware, or in a virtual machine/emulator?  Because if
> it's not on real hardware, you're harvesting entropy from the host
> system, not the emulated one.  While I haven't done this with MIPS or
> ARM systems, I've taken similar measurements on SPARC64, x86_64, and
> PPC64 systems comparing real hardware and emulated hardware, and the
> emulated hardware _always_ has higher entropy, even when running the
> emulator on an identical CPU to the one being emulated and using KVM
> acceleration and passing through all the devices possible.
> 
> Even if you were testing on real hardware, I'm still rather dubious, as
> every single test I've ever done on any hardware (SPARC, PPC, x86, ARM,
> and even PA-RISC) indicates that you can't harvest entropy as
> effectively from a smaller CPU compared to a large one, and this effect
> is significantly more pronounced on RISC systems.

It was on real hardware. As part of my Jitter RNG project, I tested all major 
CPUs from small to big -- see Appendix F [1]. For MIPS/ARM, see the trailing 
part of the big table.

[1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf

Ciao
Stephan

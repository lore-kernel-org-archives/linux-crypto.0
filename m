From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: Don't overwrite CRNG state in crng_initialize()
Date: Wed, 8 Feb 2017 23:19:31 -0500
Message-ID: <20170209041931.xgkmysquazppiewx@thunk.org>
References: <1486611086-2290-1-git-send-email-alden.tondettar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alden Tondettar <alden.tondettar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49736 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751074AbdBIETe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2017 23:19:34 -0500
Content-Disposition: inline
In-Reply-To: <1486611086-2290-1-git-send-email-alden.tondettar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 08, 2017 at 08:31:26PM -0700, Alden Tondettar wrote:
> The new non-blocking system introduced in commit e192be9d9a30 ("random:
> replace non-blocking pool with a Chacha20-based CRNG") can under
> some circumstances report itself initialized while it still contains
> dangerously little entropy, as follows:
> 
> Approximately every 64th call to add_interrupt_randomness(), the "fast"
> pool of interrupt-timing-based entropy is fed into one of two places. At
> calls numbered <= 256, the fast pool is XORed into the primary CRNG state.
> At call 256, the CRNG is deemed initialized, getrandom(2) is unblocked,
> and reading from /dev/urandom no longer gives warnings.
> 
> At calls > 256, the fast pool is fed into the input pool, leaving the CRNG
> untouched.
> 
> The problem arises between call number 256 and 320. If crng_initialize()
> is called at this time, it will overwrite the _entire_ CRNG state with
> 48 bytes generated from the input pool.

So in practice this isn't a problem because crng_initialize is called
in early init.   For reference, the ordering of init calls are:

	"early",  <--- crng_initialize is here()
	"core",   <---- ftrace is initialized here()
	"postcore",
	"arch",
	"subsys",  <---- acpi_init is here()
	"fs",
	"device",  <---- device probing is here
	"late",

So in practice, call 256 typically happens **well** after
crng_initialize.  You can see where it is the boot messages, which is
after 2.5 seconds into the boot:

[    2.570733] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.570863] usbcore: registered new interface driver i2c-tiny-usb
[    2.571035] device-mapper: uevent: version 1.0.3
[    2.571215] random: fast init done  <-------------
[    2.571316] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
[    2.571678] device-mapper: multipath round-robin: version 1.1.0 loaded
[    2.571728] intel_pstate: Intel P-state driver initializing
[    2.572331] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    2.572462] intel_pstate: HWP enabled
[    2.572464] sdhci: Secure Digital Host Controller Interface driver

When is crng_initialize() called?  Sometime *before* 0.05 seconds into
the boot on my laptop:

[    0.054529] ftrace: allocating 29140 entries in 114 pages

> In short, the situation is:
> 
> A) No usable hardware RNG or arch_get_random() (or we don't trust it...)
> B) add_interrupt_randomness() called 256-320 times but other
>    add_*_randomness() functions aren't adding much entropy.
> C) then crng_initialize() is called
> D) not enough calls to add_*_randomness() to push the entropy
>    estimate over 128 (yet)
> E) getrandom(2) or /dev/urandom used for something important
> 
> Based on a few experiments with VMs, A) through D) can occur easily in
> practice. And with no HDD we have a window of about a minute or two for
> E) to happen before add_interrupt_randomness() finally pushes the
> estimate over 128 on its own.

How did you determine when crng_initialize() was being called?  On a
VM generally there are fewer interrupts than on real hardware.  On
KVM, for I see the random: fast_init message being printed 3.6 seconds
into the boot.

On Google Compute Engine, the fast_init message happens 52 seconds into the
boot.

So what VM where you using?  I'm trying to figure out whether this is
hypothetical or real problem, and on what systems.

	     	     	      	     - Ted

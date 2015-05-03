From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 0/6] Seeding DRBG with more entropy
Date: Sun, 3 May 2015 16:58:34 -0400
Message-ID: <20150503205834.GJ10014@thunk.org>
References: <1626703.0h1HzJAx4d@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, Paul Bolle <pebolle@tiscali.it>,
	Andreas Steffen <andreas.steffen@strongswan.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42335 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbbECU6j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 May 2015 16:58:39 -0400
Content-Disposition: inline
In-Reply-To: <1626703.0h1HzJAx4d@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 03, 2015 at 05:33:00PM +0200, Stephan Mueller wrote:
> The patch set adds an in-kernel /dev/random equivalent that was discussed with
> Ted Ts'o last July -- see [2] and [3]. A test module for testing the
> asynchronous operation of the in-kernel /dev/random is given with the code
> below.
> 
> Ted: shall we really create and maintain a new entropy pool (the kernel_pool),
> or should the in-kernel /dev/random logic draw directly from the input_pool?
> In other words, shall we drop the first patch and update the 2nd patch to
> use input_pool? Also, I would not recommend using the blocking_pool as this
> would mix kernel and user land operation.

I'd drop the 3rd pool, and just simply block until the non-blocking
pool has been initialized.  That's now considered the best practice
for userspace programs, which is to use getrandom(2), which by default
will block until the nonblocking pool has been initialized with an
estimated 128 bits of entropy, and after that point, all of the kernel
users should be quite satisfied with cryptographic entropy.

Certainly from the perspective of the perspective of a NIST evaluator
for a DRBG, using if they're happy using jitterentropy as a noise
source, they should be quite happy using the non-blocking pool as a
noise source, so long as it has been properly initialized.

As far as the concern of user space being able to block a kernel user
"indefinitely", in practice I really don't think that's going to be an
issue as far as boot-time initialization is concerned.  In practice
the urandom pool gets 128 bits of entropy *very* quickly, as in,
before the boot process is finished.

[    1.368585] random: systemd-udevd urandom read with 21 bits of entropy available
[    2.870497] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[    3.217209] EXT4-fs (sda3): re-mounted. Opts: errors=remount-ro
[    3.497191] random: nonblocking pool is initialized
[    7.705482] EXT4-fs (dm-9): mounted filesystem with ordered data mode. Opts: (null)
[    8.007435] EXT4-fs (dm-10): mounted filesystem with ordered data mode. Opts: (null)
[    8.165517] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)

(And if the attacker is able to inject arbitrary programs running
during the init sequence, they are almost certainly running as root,
and you've got other problems.)

					- Ted

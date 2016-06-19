From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Sun, 19 Jun 2016 19:18:28 -0400
Message-ID: <20160619231827.GB9848@thunk.org>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <1465832919-11316-6-git-send-email-tytso@mit.edu>
 <20160615145908.GA18866@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, smueller@chronox.de,
	andi@firstfloor.org, sandyinchina@gmail.com, jsd@av8n.com,
	hpa@zytor.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48976 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbcFSXSv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Jun 2016 19:18:51 -0400
Content-Disposition: inline
In-Reply-To: <20160615145908.GA18866@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 15, 2016 at 10:59:08PM +0800, Herbert Xu wrote:
> I think you should be accessing this through the crypto API rather
> than going direct.  We already have at least one accelerated
> implementation of chacha20 and there may well be more of them
> in future.  Going through the crypto API means that you will
> automatically pick up the best implementation for the platform.

While there are some benefits of going through the crypto API, there
are some downsides as well:

A) Unlike using ChaCha20 in cipher mode, only need the keystream, and
we don't need to XOR the output with plaintext.  We could supply a
dummy zero-filled buffer to archive the same result, but now the
"accelerated" version is having to do an extra memory reference.  Even
if the L1 cache is big enough so that we're not going all the way out
to DRAM, we're putting additional pressure the D cache.

B) The anti-backtracking feature involves taking the existing key and
XOR'ing it with unsued output from the keystream.  We can't do that
using the Crypto API without keeping our own copy of the key, and then
calling setkey --- which means yet more extra memory references.

C) Simply compiling in the Crypto layer and the ChaCha20 generic
handling (all of which is doing extra work which we would then be
undoing in the random layer --- and I haven't included the extra code
in the random driver needed interface with the crypto layer) costs an
extra 20k.  That's roughly the amount of extra kernel bloat that the
Linux kernel grew in its allnoconfig from version to version from 3.0
to 3.16.  I don't have the numbers from the more recent kernels, but
roughly speaking, we would be responsible for **all** of the extra
kernel bloat (and if there was any extra kernel bloat, we would
helping to double it) in the kernel release where this code would go
in.  I suspect the folks involved with the kernel tinificaiton efforts
wouldn't exactly be pleased with this.

Yes, I understand the argument that the networking stack is now
requiring the crypto layer --- but not all IOT devices may necessarily
require the IP stack (they might be using some alternate wireless
communications stack) and I'd much rather not make things worse.


The final thing is that it's not at all clear that the accelerated
implementation is all that important anyway.  Consider the following
two results using the unaccelerated ChaCha20:

% dd if=/dev/urandom bs=4M count=32 of=/dev/null
32+0 records in
32+0 records out
134217728 bytes (134 MB, 128 MiB) copied, 1.18647 s, 113 MB/s

% dd if=/dev/urandom bs=32 count=4194304 of=/dev/null
4194304+0 records in
4194304+0 records out
134217728 bytes (134 MB, 128 MiB) copied, 7.08294 s, 18.9 MB/s

So in both cases, we are reading 128M from the CRNG.  In the first
case, we see the sort of speed we would get if we were using the CRNG
for some illegitimate, such as "dd if=/dev/urandom of=/dev/sdX bs=4M"
(because they were too lazy to type "apt-get install nwipe").

In the second case, we see the use of /dev/urandom in a much more
reasonable, proper, real-world use case for /de/urandom, which is some
userspace process needing a 256 bit session key for a TLS connection,
or some such.  In this case, we see that the other overheads of
providing the anti-backtracking protection, system call overhead,
etc., completely dominate the speed of the core crypto primitive.

So even if the AVX optimized is 100% faster than the generic version,
it would change the time needed to create a 256 byte session key from
1.68 microseconds to 1.55 microseconds.  And this is ignoring the
extra overhead needed to set up AVX, the fact that this will require
the kernel to do extra work doing the XSAVE and XRESTORE because of
the use of the AVX registers, etc.

The bottom line is that optimized ChaCha20 optimizations might be
great for bulk encryption, but for the purposes of generating 256 byte
session keys, I don't think the costs outweigh the benefits.

Cheers,

							- Ted

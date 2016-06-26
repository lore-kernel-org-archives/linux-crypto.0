From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Sun, 26 Jun 2016 18:51:43 -0400
Message-ID: <20160626225143.GC7132@thunk.org>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <1465832919-11316-6-git-send-email-tytso@mit.edu>
 <20160615145908.GA18866@gondor.apana.org.au>
 <20160619231827.GB9848@thunk.org>
 <20160626184743.GA11162@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, smueller@chronox.de,
	andi@firstfloor.org, sandyinchina@gmail.com, jsd@av8n.com,
	hpa@zytor.com
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34116 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbcFZWv6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 26 Jun 2016 18:51:58 -0400
Content-Disposition: inline
In-Reply-To: <20160626184743.GA11162@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 26, 2016 at 08:47:43PM +0200, Pavel Machek wrote:
> Ok, so lets say I'm writing some TLS server, and I know that traffic
> is currently heavy because it was heavy in last 5 minutes. Would it
> make sense for me to request 128M of randomness from /dev/urandom, and
> then use that internally, to avoid the syscall overhead?

Probably not.  Keep in mind that even requesting a 256 bit key one at
a time, it's still only taking 1.7 microseconds.  The time to do the
Diffie-Hellman will vary depending on whether you are doing DH in a
log field or a ECC field, but whether it's around 18-20ms or 3-4ms,
it's over *three* orders of magnitude more than the time it takes to
generate a random session key.

So trying to grab 1M of randomness and managing it in your TLS server
is almost certainly optimizing for The Wrong Thing.  (Not to mention
the potential for disaster if that randomness gets stolen via some
kind of wild pointer bug, etc., etc.)

This is why I think it's a waste of time talknig about trying to use
AVX or SIMD optimized version of ChaCha20.  Even if the cost to do the
XSAVE / XRESTORE doesn't crush the optimization of advantages of
ChaCha20, and if you ignore the costs of adding backtracking defenses,
etc., bloating the kernel by adding support for the crypto layer
doesn't make sense when using the generic ChaCha20 already gets you
down into the microsecond arena.  You might be able to get the session
key generation down by another .3 or .4 microseconds, but even if you
cut it down by half to .9 microseconds, the public key operations and
the diffie-hellman operations are going to make such savings be almost
completely unnoticeable.

					- Ted

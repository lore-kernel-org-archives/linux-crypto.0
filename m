From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Mon, 20 Jun 2016 01:02:03 -0400
Message-ID: <20160620050203.GC9848@thunk.org>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <1465832919-11316-6-git-send-email-tytso@mit.edu>
 <20160615145908.GA18866@gondor.apana.org.au>
 <20160619231827.GB9848@thunk.org>
 <20160620012528.GA7471@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, smueller@chronox.de,
	andi@firstfloor.org, sandyinchina@gmail.com, jsd@av8n.com,
	hpa@zytor.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52418 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbcFTFCQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 01:02:16 -0400
Content-Disposition: inline
In-Reply-To: <20160620012528.GA7471@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 20, 2016 at 09:25:28AM +0800, Herbert Xu wrote:
> > Yes, I understand the argument that the networking stack is now
> > requiring the crypto layer --- but not all IOT devices may necessarily
> > require the IP stack (they might be using some alternate wireless
> > communications stack) and I'd much rather not make things worse.
> 
> Sure, but 99% of the kernels out there will have a crypto API.
> So why not use it if it's there and use the standalone chacha
> code otherwise?

It's work that I'm not convinced is worth the gain?  Perhaps I
shouldn't have buried the lede, but repeating a paragraph from later
in the message:

   So even if the AVX optimized is 100% faster than the generic version,
   it would change the time needed to create a 256 byte session key from
   1.68 microseconds to 1.55 microseconds.  And this is ignoring the
   extra overhead needed to set up AVX, the fact that this will require
   the kernel to do extra work doing the XSAVE and XRESTORE because of
   the use of the AVX registers, etc.

So in the absolute best case, this improves the time needed to create
a 256 bit session key by 0.13 microseconds.  And that assumes that the
extra setup and teardown overhead of an AVX optimized ChaCha20
(including the XSAVE and XRESTORE of the AVX registers, etc.) don't
end up making the CRNG **slower**.

The thing to remember about these optimizations is that they are great
for bulk encryption, but that's not what the getrandom(2) and
get_random_bytes() are used for, in general.  We don't need to create
multiple megabytes of random numbers at a time.  We need to create
them 256 bits at a time, with anti-backtracking protections in
between.  Think of this as the random number equivalent of artisinal
beer making, as opposed to Budweiser beer, which ferments the beer
literally in pipelines.  :-)

Yes, Budweiser may be made more efficiently using continuous
fermentation --- but would you want to drink it?   And if you have to
constantly start and stop the continuous fermentation pipeline, the net
result can actually be less efficient compared to doing it right in
the first place....

	     	     	       	       - Ted

P.S.  I haven't measured this to see, mainly because I really don't
care about the difference between 1.68 vs 1.55 microseconds, but there
is a good chance in the crypto layer that it might be a good idea to
have the system be smart enough to automatically fall back to using
the **non** optimized version if you only need to encrypt a small
amount of data.

From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Mon, 20 Jun 2016 11:01:47 -0400
Message-ID: <20160620150147.GD9848@thunk.org>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <1465832919-11316-6-git-send-email-tytso@mit.edu>
 <20160615145908.GA18866@gondor.apana.org.au>
 <20160619231827.GB9848@thunk.org>
 <20160620012528.GA7471@gondor.apana.org.au>
 <20160620050203.GC9848@thunk.org>
 <20160620051917.GA8719@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, smueller@chronox.de,
	andi@firstfloor.org, sandyinchina@gmail.com, jsd@av8n.com,
	hpa@zytor.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160620051917.GA8719@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 20, 2016 at 01:19:17PM +0800, Herbert Xu wrote:
> On Mon, Jun 20, 2016 at 01:02:03AM -0400, Theodore Ts'o wrote:
> > 
> > It's work that I'm not convinced is worth the gain?  Perhaps I
> > shouldn't have buried the lede, but repeating a paragraph from later
> > in the message:
> > 
> >    So even if the AVX optimized is 100% faster than the generic version,
> >    it would change the time needed to create a 256 byte session key from
> >    1.68 microseconds to 1.55 microseconds.  And this is ignoring the
> >    extra overhead needed to set up AVX, the fact that this will require
> >    the kernel to do extra work doing the XSAVE and XRESTORE because of
> >    the use of the AVX registers, etc.
> 
> We do have figures on the efficiency of the accelerated chacha
> implementation on 256-byte requests (I've picked the 8-block
> version):

Sorry, I typo'ed this.  s/bytes/bits/.  256 bits / 32 bytes is the
much more common amount that someone might be trying to extract, to
get a 256 **bit** session key.

And also note my comments about how we need to permute the key
directly, and not just go through the set_key abstraction.  And when
you did your benchmarks, how often was XSAVE / XRESTORE happening ---
in between every single block operation?

Remember, what we're talking about for getrandom(2) in the most common
case is syscall, extrate a 32 bytes worth of keystream, ***NOT***
XOR'ing it with plaintext buffer, and then permuting the key.

So simply doing chacha20 encryption in a tight loop in the kernel
might not be a good proxy for what would actually happen in real life
when someone calls getrandom(2).  (Another good question to ask is
when someone might be needing to generate millions of 256-bit session
keys per second, when the D-H setup, even if you were using ECCDH,
would be largely dominating the time for the connection setup anyway.)

Cheers,

						- Ted

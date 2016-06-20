From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Mon, 20 Jun 2016 13:19:17 +0800
Message-ID: <20160620051917.GA8719@gondor.apana.org.au>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <1465832919-11316-6-git-send-email-tytso@mit.edu>
 <20160615145908.GA18866@gondor.apana.org.au>
 <20160619231827.GB9848@thunk.org>
 <20160620012528.GA7471@gondor.apana.org.au>
 <20160620050203.GC9848@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, smueller@chronox.de,
	andi@firstfloor.org, sandyinchina@gmail.com, jsd@av8n.com,
	hpa@zytor.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51029 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbcFTGDt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 02:03:49 -0400
Content-Disposition: inline
In-Reply-To: <20160620050203.GC9848@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 20, 2016 at 01:02:03AM -0400, Theodore Ts'o wrote:
> 
> It's work that I'm not convinced is worth the gain?  Perhaps I
> shouldn't have buried the lede, but repeating a paragraph from later
> in the message:
> 
>    So even if the AVX optimized is 100% faster than the generic version,
>    it would change the time needed to create a 256 byte session key from
>    1.68 microseconds to 1.55 microseconds.  And this is ignoring the
>    extra overhead needed to set up AVX, the fact that this will require
>    the kernel to do extra work doing the XSAVE and XRESTORE because of
>    the use of the AVX registers, etc.

We do have figures on the efficiency of the accelerated chacha
implementation on 256-byte requests (I've picked the 8-block
version):

testing speed of chacha20 (chacha20-generic) encryption
test 2 (256 bit key, 256 byte blocks): 12702056 operations in 10 seconds (3251726336 bytes)

testing speed of chacha20 (chacha20-simd) encryption
test 2 (256 bit key, 256 byte blocks): 33028112 operations in 10 seconds (8455196672 bytes)

So it is a little bit more than 100%.

> So in the absolute best case, this improves the time needed to create
> a 256 bit session key by 0.13 microseconds.  And that assumes that the
> extra setup and teardown overhead of an AVX optimized ChaCha20
> (including the XSAVE and XRESTORE of the AVX registers, etc.) don't
> end up making the CRNG **slower**.

The figures above include all of these overheads.  The overheads
really only show up on 16-byte requests.
 
> P.S.  I haven't measured this to see, mainly because I really don't
> care about the difference between 1.68 vs 1.55 microseconds, but there
> is a good chance in the crypto layer that it might be a good idea to
> have the system be smart enough to automatically fall back to using
> the **non** optimized version if you only need to encrypt a small
> amount of data.

You're right.  chacha20-simd should use the generic version on
16-byte requests which is the only place where it is slower.
Something like this:

---8<---
Subject: crypto: chacha20-simd - Use generic code for small requests

On 16-byte requests the optimised version is actually slower than
the generic code, so we should simply use that instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 2d5c2e0b..f910d1d 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -70,7 +70,7 @@ static int chacha20_simd(struct blkcipher_desc *desc, struct scatterlist *dst,
 	struct blkcipher_walk walk;
 	int err;
 
-	if (!may_use_simd())
+	if (nbytes <= CHACHA20_BLOCK_SIZE || !may_use_simd())
 		return crypto_chacha20_crypt(desc, dst, src, nbytes);
 
 	state = (u32 *)roundup((uintptr_t)state_buf, CHACHA20_STATE_ALIGN);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

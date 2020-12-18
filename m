Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04737C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 20:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFF672343F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 20:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgLRUJO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:09:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730555AbgLRUJN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 15:09:13 -0500
Date:   Fri, 18 Dec 2020 12:08:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608322112;
        bh=2t7LOnx8WGStj6lzzBy6iamgKQbqo8o6v8MV+19/URA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=hDEejMurrRxEw2SCeZryZJwmTBQ3CgOyP4EKTZZvy7FN2Nq6iJhe4phVTxDfkTlpo
         0z/GvayfhFY0YOLCRhTkkkOh4HEl1QWhPop5mLKZ965SATjJKHeGNYrHS9FloC/32S
         sogKBwph+iTOAaGPEsZc6bBHoRS8xRJch7aHyLTwKaqVRce2Fq0xyJBf5vXfykLjR3
         ZR5bEY/Jdv5owJZ/wYs6Znx/LSsZQP4O1mPz/7dAhAC7wDkdj0gu8UkoTbpHFiSlxR
         mrw55ciL6eY9jibxAURgP6KbOgHJ/u8GVX353POYfhmoxwbziXd1TlLGG4bboOcfMp
         68p+fyCsKO2Pg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH v2 09/11] crypto: blake2s - share the "shash" API
 boilerplate code
Message-ID: <X90MPh/uwXXu3F/Y@sol.localdomain>
References: <20201217222138.170526-1-ebiggers@kernel.org>
 <20201217222138.170526-10-ebiggers@kernel.org>
 <CAHmME9oW-_GXJ+nVwyiEV7wfjmzqBgqrSynnJ6xoN5UA_Nzh1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oW-_GXJ+nVwyiEV7wfjmzqBgqrSynnJ6xoN5UA_Nzh1Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 18, 2020 at 05:14:58PM +0100, Jason A. Donenfeld wrote:
> On Thu, Dec 17, 2020 at 11:25 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Move the boilerplate code for setkey(), init(), update(), and final()
> > from blake2s_generic.ko into a new module blake2s_helpers.ko, and export
> > it so that it can be used by other shash implementations of BLAKE2s.
> >
> > setkey() and init() are exported as-is, while update() and final() have
> > a blake2s_compress_t function pointer argument added.  This allows the
> > implementation of the compression function to be overridden, which is
> > the only part that optimized implementations really care about.
> >
> > The helper functions are defined in a separate module blake2s_helpers.ko
> > (rather than just than in blake2s_generic.ko) because we can't simply
> > select CRYPTO_BLAKE2B from CRYPTO_BLAKE2S_X86.  Doing this selection
> > unconditionally would make the library API select the shash API, while
> > doing it conditionally on CRYPTO_HASH would create a recursive kconfig
> > dependency on CRYPTO_HASH.  As a bonus, using a separate module also
> > allows the generic implementation to be omitted when unneeded.
> >
> > These helper functions very closely match the ones I defined for
> > BLAKE2b, except the BLAKE2b ones didn't go in a separate module yet
> > because BLAKE2b isn't exposed through the library API yet.
> >
> > Finally, use these new helper functions in the x86 implementation of
> > BLAKE2s.  (This part should be a separate patch, but unfortunately the
> > x86 implementation used the exact same function names like
> > "crypto_blake2s_update()", so it had to be updated at the same time.)
> 
> There's a similar situation happening with chacha20poly1305 and with
> curve25519. Each of these uses a mildly different approach to how we
> split things up between library and crypto api code. The _helpers.ko
> is another one. There any opportunity here to take a more
> unified/consistant approach? Or is shash slightly different than the
> others and benefits from a third way?

What I'm doing isn't that new; it's basically the same thing that's already done
for sha1, sha256, sha512, sm3, and nhpoly1305.  The difference is just where the
shash helper functions are defined.  For sha1, sha256, sha512, and sm3 it's in
headers (include/crypto/{sha1,sha256,sha512,sm3}_base.h).  For nhpoly1305 it's
in the same module as the generic implementation (crypto/nhpoly1305.c).

As I mentioned in the commit message, putting the shash helpers in the same
module as the generic implementation doesn't work for blake2s due to the need
for the architecture-specific blake2s modules to support the library API (and
possibly *only* the library API) too.  So that mainly leaves the options of
adding include/crypto/blake2s_base.h, or adding blake2s_helpers.ko.  But these
approaches aren't fundamentally different -- it's just a matter of whether the
code is short enough for it to make sense to always inline it or not.

It's hard to compare to chacha20 and curve25519 (or chacha20poly1305), as those
are different types of algorithms.  poly1305 is the most comparable, but for
poly1305 the library API works differently in that there are
poly1305_{init,update,final}_arch(), not just blake2s_compress_arch().  This
seems to be due to some of the characteristics that optimized poly1305
implementations usually have -- they need to compute key powers differently, and
they may have an optimized implementation of emitting the final hash value, not
just processing blocks.

So that is going to result in a different implementation, as the
architecture-specific poly1305 modules have to implement the full
init/update/final sequence for the library API, while for blake2s they only need
that full sequence for the shash API.  Hence the usefulness of adding helper
functions for blake2s shash implementations but not poly1305.  I don't think
this difference is necessarily bad; it just means that optimized blake2s
implementations don't need to do as much themselves, in comparison to poly1305.

What we *could* do to reuse even more code than what I've proposed is to make
the functions in lib/crypto/blake2s.c usable as the helper functions for shash
implementations, like the following.  Then blake2s_helpers.ko wouldn't really be
necessary.  (A few bits would still be needed, but they could be inline
functions in a header.)  I thought this might be controversial though, as it
would add some indirection into the library implementation:

diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index 41025a30c524c..5188e1ca43c60 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -20,6 +20,16 @@
 bool blake2s_selftest(void);
 
 void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen)
+{
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S))
+		__blake2s_update(state, in, inlen, blake2s_compress_arch);
+	else
+		__blake2s_update(state, in, inlen, blake2s_compress_generic);
+}
+EXPORT_SYMBOL(blake2s_update);
+
+void __blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen,
+		      blake2s_compress_t compress)
 {
 	const size_t fill = BLAKE2S_BLOCK_SIZE - state->buflen;
 
@@ -27,12 +37,7 @@ void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen)
 		return;
 	if (inlen > fill) {
 		memcpy(state->buf + state->buflen, in, fill);
-		if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S))
-			blake2s_compress_arch(state, state->buf, 1,
-					      BLAKE2S_BLOCK_SIZE);
-		else
-			blake2s_compress_generic(state, state->buf, 1,
-						 BLAKE2S_BLOCK_SIZE);
+		(*compress)(state, state->buf, 1, BLAKE2S_BLOCK_SIZE);
 		state->buflen = 0;
 		in += fill;
 		inlen -= fill;
@@ -40,35 +45,37 @@ void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen)
 	if (inlen > BLAKE2S_BLOCK_SIZE) {
 		const size_t nblocks = DIV_ROUND_UP(inlen, BLAKE2S_BLOCK_SIZE);
 		/* Hash one less (full) block than strictly possible */
-		if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S))
-			blake2s_compress_arch(state, in, nblocks - 1,
-					      BLAKE2S_BLOCK_SIZE);
-		else
-			blake2s_compress_generic(state, in, nblocks - 1,
-						 BLAKE2S_BLOCK_SIZE);
+		(*compress)(state, in, nblocks - 1, BLAKE2S_BLOCK_SIZE);
 		in += BLAKE2S_BLOCK_SIZE * (nblocks - 1);
 		inlen -= BLAKE2S_BLOCK_SIZE * (nblocks - 1);
 	}
 	memcpy(state->buf + state->buflen, in, inlen);
 	state->buflen += inlen;
 }
-EXPORT_SYMBOL(blake2s_update);
+EXPORT_SYMBOL(__blake2s_update);
 
 void blake2s_final(struct blake2s_state *state, u8 *out)
+{
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S))
+		__blake2s_final(state, out, blake2s_compress_arch);
+	else
+		__blake2s_final(state, out, blake2s_compress_generic);
+}
+EXPORT_SYMBOL(blake2s_final);
+
+void __blake2s_final(struct blake2s_state *state, u8 *out,
+		     blake2s_compress_t compress)
 {
 	WARN_ON(IS_ENABLED(DEBUG) && !out);
 	blake2s_set_lastblock(state);
 	memset(state->buf + state->buflen, 0,
 	       BLAKE2S_BLOCK_SIZE - state->buflen); /* Padding */
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S))
-		blake2s_compress_arch(state, state->buf, 1, state->buflen);
-	else
-		blake2s_compress_generic(state, state->buf, 1, state->buflen);
+	(*compress)(state, state->buf, 1, state->buflen);
 	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
 	memcpy(out, state->h, state->outlen);
 	memzero_explicit(state, sizeof(*state));
 }
-EXPORT_SYMBOL(blake2s_final);
+EXPORT_SYMBOL(__blake2s_final);
 
 void blake2s256_hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen,
 		     const size_t keylen)

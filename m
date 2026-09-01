Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD5A481A94;
	Tue,  1 Sep 2026 16:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281639; cv=none; b=VWUQ6njBZT8ZAvP32VTlF3heZZ8gO9Mlx2/Vo4iH06CRQxi8XYmZqVHivqDULfGKjTYNmtezYuZPPA2hwe250pOfgh8M7oY5VpBt9kN9OvTLBmih18Zm1MUQ7wfsdlC0aMARuGtKgbx99fwZQcv0wTHl7ST1TWkRTlO/sb/HI8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281639; c=relaxed/simple;
	bh=GC0N5vr6MZj4SjETvMthe13Ho23hLrm9X8Dz3cwucio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nl3YT2O4paFiNH/o/hJXP6IxTvXEepyunacTjxLMJy0R+F9EHp/j7vbR4Jr2RPAbfsIFkgNHm1PmH276vxPPpYQ+1F9A0iTX72mpiNS5PVlXpkyDh4YBfa1Nei07FpyXXv2ThdbMqLUMrjDYqcTgB8BjFtFus6+tKUz4fkJk1L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5GNQNEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5GNQNEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A8B1F000E9;
	Tue,  1 Sep 2026 16:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788281637;
	bh=3o2BkarRCOxJdhLlpKyzUTsHTVM+DwUWlayVRBHvgzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R5GNQNEBOH9dw+c2rWRaw/7DcSumudYvkYYoj49kZnu5BEdTmkeIeYuMsVKWFAZf0
	 OkxquJXuwrlL1UNafkdnMRnUso5AIST/jeCE0rjWzvUMfN5IO5wmEq6uGoTVVw7Mlr
	 mN1grRxPEoVaK+EdxNRTX5HBUAsXe+H3mtQPOfJuAPvBrlsYT/3DbRDS/B86W+XTbt
	 DVbBOuoEBvlC46y3QPZgul3agjkpqceDjIfG876KsLmQneF0ave/Fnb2eTwAHWh683
	 4+qGQz4sSKV8SlJMD99mQhLD03ASomsz6bcT2B0JAr8eU23ys6Q6qOtnQydzwxo5dI
	 P/VP5ErcpXTlw==
Date: Tue, 1 Sep 2026 16:53:55 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, x86@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] libcrypto: Provide more __cleanup functions for
 zeroizing data
Message-ID: <20260901165355.GA2775257@google.com>
References: <20260813134953.979481-1-thuth@redhat.com>
 <20260901001245.GA220448@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901001245.GA220448@quark>

On Mon, Aug 31, 2026 at 05:12:45PM -0700, Eric Biggers wrote:
> Hi Thomas,
> 
> On Thu, Aug 13, 2026 at 03:49:38PM +0200, Thomas Huth wrote:
> > Code that uses crypto-related structures (containing keys or context data)
> > should zeroize their local structures on the stack after use to avoid
> > leaking this sensitive material via the stack when the function returns.
> > Using the __cleanup() marker is a very elegant way to assert that the
> > data is zeroized without having to painfully verify that each early return
> > in a function might miss it.
> > 
> > Thus this series introduces zeroization functions for many crypto-related
> > structures that can be used with __cleanup(). The series focuses on the
> > introduction of the functions - most call sights will be adjusted to use
> > these new functions in separate patch series later (since each subsystem
> > needs separate review from the corresponding maintainer). However, I
> > already included the two "safexcel" patches, since they already got ack'ed
> > by the maintainer Antoine, so I think they should be fine to go via the
> > libcrypto tree.
> > 
> > Note there is one minor ugliness in patch 10: Since sha2.h is also used
> > in the x86 purgatory code, and that code ships with its own implementation
> > of string functions, we have to compile the purgatory.c file with
> > -D__NO_FORTIFY now to be able to include <linux/string.h> in sha2.h.
> > I hope that solution is OK (especially since the sha256.c file in the
> > same folder gets that treatment already, too), if not - I'm certainly
> > open for other suggestions here!
> > 
> > Thomas Huth (11):
> >   lib/crypto: aes: Provide a wrapper function for zeroizing
> >     crypto_aes_ctx
> >   crypto: safexcel - Simplify the check for a valid AES key
> >   crypto: safexcel - zeroize crypto_aes_ctx with
> >     __cleanup(aes_zeroize_ctx)
> >   lib/crypto: aes: Provide functions for zeroizing aes_key and
> >     aes_enckey
> >   lib/crypto: aes: Use aes_zeroize_*key() instead of memzero_explicit()
> >   lib/crypto: md5: Provide a function for zeroizing hmac_md5_ctx
> >     structures
> >   lib/crypto: md5: Use hmac_md5_zeroize_ctx() instead of
> >     memzero_explicit()
> >   lib/crypto: sha1: Provide a wrapper for zeroizing hmac_sha1_ctx
> >   lib/crypto: sha1: Use hmac_sha1_zeroize_ctx() instead of
> >     memzero_explicit()
> >   x86/purgatory: Compile purgatory.c with -D__NO_FORTIFY
> >   lib/crypto: sha2: Provide wrappers for zeroizing SHA2 hmac_sha*_ctx
> >     structures
> 
> I'm taking a look at these again for 7.3.  This is still missing quite a
> few of the crypto library structs.  I would prefer to handle them all in
> a consistent way.
> 
> Also, given that we'll end up with a lot of these, we should be
> thoughtful about the kerneldoc.  Using aes_enckey as an example:
> 
> /**
>  * aes_zeroize_enckey() - Zeroize an aes_enckey structure
>  * @key: The location of the key structure that should be zeroized
>  *
>  * Explicitly fills the aes_enckey with zeroes. For example, use it with
>  * __cleanup() for local aes_enckey structures on the stack, so that their
>  * content is not leaked when the context is left.
>  */
> 
> It's not clear what is meant by "context".  And it doesn't explicitly
> connect the zeroization requirement to the lifetime of the struct, so I
> don't think it makes it clear when this should be called.  It also says
> nothing about kfree_sensitive() which many users should use instead.
> 
> Meanwhile, aes_prepareenckey() already has the following, which at least
> connects the zeroization requirement to the lifetime of the key:
> 
>    * The caller is responsible for zeroizing both the struct aes_enckey and the    
>    * raw key once they are no longer needed.
> 
> How about we remove that and the free-form description of
> aes_zeroize_enckey(), and instead expand the comment on the struct
> itself:
> 
> /**
>  * struct aes_enckey - An AES key prepared for encryption
>  * ...
>  * Once prepared, users must zeroize this struct at the end of its lifetime.     
>  * For stack-allocated structs, use __cleanup(aes_zeroize_enckey) to zeroize     
>  * when the variable goes out of scope.  For slab-allocated structs, use         
>  * kfree_sensitive() or else call aes_zeroize_enckey() before freeing.       
>  */
> 
> That would connect the zeroization requirement to the actual struct and
> its lifetime, and make it clear how to handle each case.  It would also
> make it clear that stack allocation is supported for this struct, which
> might not have been obvious before.
> 
> aes_zeroize_enckey() would then omit a free-form description, which
> makes sense as it's a trivial wrapper around memzero_explicit():
> 
> /**
>  * aes_zeroize_enckey() - Zeroize an aes_enckey structure
>  * @key: The aes_enckey to zeroize
>  */
> static inline void aes_zeroize_enckey(struct aes_enckey *key)
> {
> 	memzero_explicit(key, sizeof(*key));
> }
> 
> Similarly for all the other structs, of course.
> 
> (For the hash contexts, the struct comment should mention that the
> finalization function zeroizes as well.)
> 
> Does that sound good?

There's also the subtlety that __cleanup shouldn't be used in functions
that are already using goto-based cleanup.

And any kernel code preparing a key also has the raw key too and has to
zeroize that too, otherwise doing so for the prepared key is pointless.

... unless it's not actually a secret key, which sometimes it isn't.
We've been getting a lot of zeroization patches that try to add
zeroization for public keys, which is nonsense.  And also for pointers
to keys, which people confuse with the keys themselves.

There are also Rust bindings being proposed, and they handle zeroization
by calling memzero_explicit() directly.  So that's yet another case
where these new functions are not applicable.

I'm increasingly thinking that we shouldn't try to explain all the
zeroization stuff in the kerneldoc, and instead add a documentation file
in Documentation/crypto/ that properly explains the conventions for
crypto key zeroization in the kernel and defer to that.

The struct-specific zeroization functions are still worthwhile, but I
think they should be seen as trivial wrappers around memzero_explicit().
So maybe just add all of them with minimal comments like I suggested
above (maybe even just add them for all the algorithms in a single
patch), and add a file Documentation/crypto/zeroization.rst separately.

- Eric

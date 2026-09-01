Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBCE259C80;
	Tue,  1 Sep 2026 00:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788221568; cv=none; b=nfBu6s6LVoMP/mO0zybKY6+15NCzms7E9gGNsPLyYPosOYo8FjQSiOdiqthdw06ZunYEKN1TgWDPZ9kLwGZ6JaR0JrkVC6B3lQmSJmL98/LBb2O/fDDlINcB5TJZxruZMR/wrplCj6tML2tBb0UAbVS7omT2q2yPbD3RGi8xQbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788221568; c=relaxed/simple;
	bh=K4NdZu+IM3ROQcoM+lhgXbd1msX/19TWD1kA5ze/5xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RiuJu0bk9E79R3t5Z7KHxQNAi3UbE+N30/Mq2rYgOevSQ8mtm4PbkvGD8FZZNHpi9B5Vwc9e1+0BF1KbeBZkZPhiF8ujXpsJGOSx7syd9aZBCJmlbiT/k577Lk8zVBJAOtsA+19XrSPBpkHfTUm+vFWnDWr2EKdToWXx6z35VeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hdpiVe4x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hdpiVe4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63F31F000E9;
	Tue,  1 Sep 2026 00:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788221566;
	bh=8Kno6Crx30qqvJ21ms9zfoat0PJmJ4F/obERwMM83iw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hdpiVe4xkoBpZY4eaTNhEsvLSoRFeum/Dnp0AhjJfpysrbCMqjZ8hpSxlFW5vyKSp
	 GyUYU+vw3uHCGbajvDFbzVVRQ05tEMBiRCkwhWXJG4WCtXnFKmNHe8mCH4HfCmw4H/
	 9cQUuiWpLf9wdn6dMqE4iRRDqUDiGBAgzmbQVfStKxvIp7d+dRdjo6x5rwBfbcSzFu
	 KW1lXkUv6hv+vAT2sDebfOsjg+OELfPQlPdrcoZDSYD8jMMiDSizcJ56QkNrCKSwNE
	 DkqpSGjlR5lbS6IoE1c+fXmv/lrupnRbIq8faq01OyE2V5QO5g6brqKuWZ2H8uCKWl
	 Oj10nESeZKYzQ==
Date: Mon, 31 Aug 2026 17:12:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, x86@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] libcrypto: Provide more __cleanup functions for
 zeroizing data
Message-ID: <20260901001245.GA220448@quark>
References: <20260813134953.979481-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813134953.979481-1-thuth@redhat.com>

Hi Thomas,

On Thu, Aug 13, 2026 at 03:49:38PM +0200, Thomas Huth wrote:
> Code that uses crypto-related structures (containing keys or context data)
> should zeroize their local structures on the stack after use to avoid
> leaking this sensitive material via the stack when the function returns.
> Using the __cleanup() marker is a very elegant way to assert that the
> data is zeroized without having to painfully verify that each early return
> in a function might miss it.
> 
> Thus this series introduces zeroization functions for many crypto-related
> structures that can be used with __cleanup(). The series focuses on the
> introduction of the functions - most call sights will be adjusted to use
> these new functions in separate patch series later (since each subsystem
> needs separate review from the corresponding maintainer). However, I
> already included the two "safexcel" patches, since they already got ack'ed
> by the maintainer Antoine, so I think they should be fine to go via the
> libcrypto tree.
> 
> Note there is one minor ugliness in patch 10: Since sha2.h is also used
> in the x86 purgatory code, and that code ships with its own implementation
> of string functions, we have to compile the purgatory.c file with
> -D__NO_FORTIFY now to be able to include <linux/string.h> in sha2.h.
> I hope that solution is OK (especially since the sha256.c file in the
> same folder gets that treatment already, too), if not - I'm certainly
> open for other suggestions here!
> 
> Thomas Huth (11):
>   lib/crypto: aes: Provide a wrapper function for zeroizing
>     crypto_aes_ctx
>   crypto: safexcel - Simplify the check for a valid AES key
>   crypto: safexcel - zeroize crypto_aes_ctx with
>     __cleanup(aes_zeroize_ctx)
>   lib/crypto: aes: Provide functions for zeroizing aes_key and
>     aes_enckey
>   lib/crypto: aes: Use aes_zeroize_*key() instead of memzero_explicit()
>   lib/crypto: md5: Provide a function for zeroizing hmac_md5_ctx
>     structures
>   lib/crypto: md5: Use hmac_md5_zeroize_ctx() instead of
>     memzero_explicit()
>   lib/crypto: sha1: Provide a wrapper for zeroizing hmac_sha1_ctx
>   lib/crypto: sha1: Use hmac_sha1_zeroize_ctx() instead of
>     memzero_explicit()
>   x86/purgatory: Compile purgatory.c with -D__NO_FORTIFY
>   lib/crypto: sha2: Provide wrappers for zeroizing SHA2 hmac_sha*_ctx
>     structures

I'm taking a look at these again for 7.3.  This is still missing quite a
few of the crypto library structs.  I would prefer to handle them all in
a consistent way.

Also, given that we'll end up with a lot of these, we should be
thoughtful about the kerneldoc.  Using aes_enckey as an example:

/**
 * aes_zeroize_enckey() - Zeroize an aes_enckey structure
 * @key: The location of the key structure that should be zeroized
 *
 * Explicitly fills the aes_enckey with zeroes. For example, use it with
 * __cleanup() for local aes_enckey structures on the stack, so that their
 * content is not leaked when the context is left.
 */

It's not clear what is meant by "context".  And it doesn't explicitly
connect the zeroization requirement to the lifetime of the struct, so I
don't think it makes it clear when this should be called.  It also says
nothing about kfree_sensitive() which many users should use instead.

Meanwhile, aes_prepareenckey() already has the following, which at least
connects the zeroization requirement to the lifetime of the key:

   * The caller is responsible for zeroizing both the struct aes_enckey and the    
   * raw key once they are no longer needed.

How about we remove that and the free-form description of
aes_zeroize_enckey(), and instead expand the comment on the struct
itself:

/**
 * struct aes_enckey - An AES key prepared for encryption
 * ...
 * Once prepared, users must zeroize this struct at the end of its lifetime.     
 * For stack-allocated structs, use __cleanup(aes_zeroize_enckey) to zeroize     
 * when the variable goes out of scope.  For slab-allocated structs, use         
 * kfree_sensitive() or else call aes_zeroize_enckey() before freeing.       
 */

That would connect the zeroization requirement to the actual struct and
its lifetime, and make it clear how to handle each case.  It would also
make it clear that stack allocation is supported for this struct, which
might not have been obvious before.

aes_zeroize_enckey() would then omit a free-form description, which
makes sense as it's a trivial wrapper around memzero_explicit():

/**
 * aes_zeroize_enckey() - Zeroize an aes_enckey structure
 * @key: The aes_enckey to zeroize
 */
static inline void aes_zeroize_enckey(struct aes_enckey *key)
{
	memzero_explicit(key, sizeof(*key));
}

Similarly for all the other structs, of course.

(For the hash contexts, the struct comment should mention that the
finalization function zeroizes as well.)

Does that sound good?

- Eric

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63AA17A586;
	Thu,  2 Oct 2025 16:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759422508; cv=none; b=K0dpxB/dC8N2S0JT3ryJu7C7woPkpxJkbGezJA/AUDG/OOHswqKUTD05jj3r13rgXlE9Erqrqv0s9gbvzNeaK6VHvst1UcKC5l9SL+RPLfZJOXRZ/X89wUqCrmOS16URpbsdlM0k2a4fODD3OywV9J6tf7Jv5IH6CuEK4rYVFZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759422508; c=relaxed/simple;
	bh=S9bOtCwZhxV5bHAKlwTwXZBpoxyAsQjgOk5wu3tLpiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QsXzC7yd/HewxJqDIO2l3tVHpWK4X970ZnL3gz3QKti+LYZwonaewSc6Vzf8haVmJKMY8yT4d+auGH9QV3Np/gcFQbHpJHzXh+4ILkgY0CPP8PKbFgtCMbDY1jhp2z5uqdCU09u8bRN+jF1dgdIvS5o9gdFK8USoqlPBV/R7Ae0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUbOvZYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUbOvZYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F07C4CEF4;
	Thu,  2 Oct 2025 16:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759422508;
	bh=S9bOtCwZhxV5bHAKlwTwXZBpoxyAsQjgOk5wu3tLpiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nUbOvZYz/QG6XCHUJ7ZmT6C8NVBYhrnYsoxCx+p8xsn+/q3u/qNt6LCpk3U16IvR2
	 RdkU1VN/DPBNUb11cWostG00rcieThuuUaXjF6ClvI0CdMFZhNdhWo9Ez7eYsgUiDL
	 IntRXCtLNC1Fij4uLAHyam9q3jYt5J15ateIU3VtiRDs3w5O3+pfdnErUhgY58uImt
	 9pbKwAV7BffGfe18pVhQIC8CMXOnHCaF+pxADtEFJQ6Q/MBd/ezXx1YOeyNcCwl7ZD
	 2FH+h3LN/bWPgLiCHhnGKsjO/ySx46NyuVg6zwVdPWBmHF05Li+7xs8wAHKqhLue22
	 GYbduYN1monIQ==
Date: Thu, 2 Oct 2025 09:27:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] crypto, lib/crypto: Add SHAKE128/256 support and
 move SHA3 to lib/crypto
Message-ID: <20251002162705.GB1697@sol>
References: <20251001152826.GB1592@sol>
 <20250926141959.1272455-1-dhowells@redhat.com>
 <20250926195958.GA2163@sol>
 <2636609.1759410884@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2636609.1759410884@warthog.procyon.org.uk>

On Thu, Oct 02, 2025 at 02:14:44PM +0100, David Howells wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Have you had a chance to read this reply?
> 
> I have.
> 
> You held up your implementation of sha256 and sha224 as an example of how it
> perhaps should be implemented:
> 
> 	It would be worth considering separating the APIs for the different
> 	algorithms that are part of SHA-3, similar to what I did with SHA-224
> 	and SHA-256.
> 
> so I have followed that.  That defines a type for each, so I'll leave it at
> that.

In v3, you were pretty clear that you don't like the six-types solution:

    I have done what Eric required and made a separate wrapper struct
    and set of wrapper functions for each algorithm, though I think this
    is excessively bureaucratic as this multiplies the API load by 7
    (and maybe 9 in the future[*]).

    [*] The Kyber algorithm also uses CSHAKE variants in the SHA3 family - and
        NIST mentions some other variants too.

    This does, however, cause a problem for what I need to do as the
    ML-DSA prehash is dynamically selectable by certificate OID, so I
    have to add SHAKE128/256 support to the crypto shash API too -
    though hopefully it will only require an output of 16 or 32 bytes
    respectively for the prehash case and won't require multiple
    squeezing.

So, I listened.  And I realized that we can address my concern about the
digest vs. XOF confusion using just two types.

And I explained I didn't intend to require that we fully split the API
into all six variants, and apologized for not being clear.

Remember, we haven't done a SHA-3 library API before.  We're both
learning as we go...

If you've now changed your mind and strongly prefer six types, I can
tolerate that too.  But I want to make sure you actually want that, and
aren't choosing it just to try to prove a point or something.

> > All I'm really requesting is that we don't create footguns, like the
> > following that the API in the v2 patch permitted:
> 
> The way you did a separate type for each removed one more footgun - and
> arguably a more important one - as the *type* enforces[1] the output buffer
> size and the sha3_*_final() function has the same sized-array as the
> convenience wrappers.
> 
> It also eliminates the need to store the digest size as this is only needed at
> the final step for the digest variant algorithms.
> 
> David
> 
> [1] Inasmuch as this is effective in C.

Well, that "Inasmuch as this is effective in C" disclaimer is really
important, because it means it doesn't actually work properly.

Effectively, array bounds in function parameters are for humans, not the
compiler.

Which is still useful, but probably not to the extent that we should
have all those extra functions and types, vs. just documenting that
sha3_final() produces output of length matching the init function that
was called.  (As I mentioned, the BLAKE2s API does something similar.)

- Eric

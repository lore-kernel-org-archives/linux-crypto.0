Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A863236437
	for <linux-crypto@vger.kernel.org>; Tue, 14 Oct 2025 17:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760463095; cv=none; b=o84h1oWNTHnxE4xT22nyUrZBerGUK1VU3mZQGRRMqTNDpyhPJWdxxD4pzQaTWlttk7Wz8G+CfdGDkDaiwThMFUpWM3cxumpWwTiPaBkzYOqNTypqmZrYwXYmYKoh8iqVBXrh62b389NV28gMKu0EeJDbQPkfR9Ib8EnTbBU7MnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760463095; c=relaxed/simple;
	bh=w2ZipmYwgkbaTg68x7OQeqPVm2Eb58COLIrMJa33KKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpJWDlt8a5gaorzB+skxHGr2sZxElQuf66m21HyRdCVwPGQ2zgjsR0Tcae/3kFvYOn8KY5u4sgxUY7xy0Yg1vX/Mu9IH75xuXa6F+0Y7s0orzMJFpR1bKtf3o/R0xnkE1kZswohOKRZjdnQIdQJLk13IYhNLJBKW7KlpDwO7VIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=geF00ipo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="geF00ipo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3E6C4CEE7;
	Tue, 14 Oct 2025 17:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760463094;
	bh=w2ZipmYwgkbaTg68x7OQeqPVm2Eb58COLIrMJa33KKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=geF00ipoJc0GOHCdZDQtx7sRUrX8C3iiwbCsv79LWq+J8E3+DqF89bGD5S3oV7KKb
	 wwNJQnjtr/SlxD9HR+WbFXJc80dm1NpL1VH/jsnN8g8ERn0f+1/QCgLNgsjmU+AL8A
	 2XQkGkt5RoZrmPQQSkCfcMVzUNAoLXdS0OlLGC+0/Tw5RJ2pcFSQwYV5qYcVwytBwB
	 OdbtknA/nLqghPborICRasGbKlmK0+xH+OhqJV+DY8qsy6gQER4EeXOHu4u9iXOy70
	 o3VsQp0V78xK4QXVHNpodWmzsNNiMHfk+cCLAfuahmR2+UTeWzUYn0qMKU19/PVkhu
	 IWqIBzf9JXcvg==
Date: Tue, 14 Oct 2025 10:30:02 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-crypto@vger.kernel.org
Subject: Re: Adding algorithm agility to the crypto library functions
Message-ID: <20251014173002.GB1544@sol>
References: <d4449ec09cf103bf3d937f78a13720dcae93fb4e.camel@HansenPartnership.com>
 <20251014165541.GA1544@sol>
 <CAMj1kXHzGm53xL4zn-2fYpae2ayxL_GneWfHGunCXdtx6E1H4w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHzGm53xL4zn-2fYpae2ayxL_GneWfHGunCXdtx6E1H4w@mail.gmail.com>

On Tue, Oct 14, 2025 at 07:08:39PM +0200, Ard Biesheuvel wrote:
> On Tue, 14 Oct 2025 at 18:57, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> ...
> > > because the user has no input on the hmac hash algorithm so, although
> > > the TPM specifies it to be agile, we can simply choose sha256.
> > > However, we have plans to use what are called policy sessions, which
> > > have require the same hash as the user supplied object used for its
> > > name (essentially a hash chosen by the user).  In a TPM these hashes
> > > can be any of the family sha1 sha256, sha384 sha512 plus a few esoteric
> > > ones like sm3.  So the question becomes: to avoid going back to open
> > > coding the hmac and using the shash API, is there a way of adding hash
> > > agility to the library algorithms?  I suppose I could also do this
> > > inside our hmac code using a large set of switch statements, but that
> > > would be a bit gross.
> > >
> > > If no-one's planning to do this I can take a stab ... it would probably
> > > still be a bunch of switch statements, but not in my code ...
> >
> > This isn't the job of lib/crypto/.
> >
> > If a caller would like to support a certain set of algorithms, it should
> > just write the 'if' or 'switch' statement itself.
> >
> > The nice thing about that is that it results in the minimum number of
> > branches and the minimum stack usage for the possible set of algorithms
> > at that particular call site.  (Compare to crypto_shash which always
> > uses indirect calls and always uses almost 400 bytes for each
> > SHASH_DESC_ON_STACK().  SHASH_DESC_ON_STACK() has to be sized for the
> > worst possible case among every hash algorithm in existence, regardless
> > of whether the caller is actually using it or not.)
> >
> 
> I agree with this in principle, but couldn't we provide /some/ level
> of support in the library so that users don't have to do it, and end
> up breaking things, either functionally or in terms of security? The
> fact that you yourself have already implemented this in 3+ places
> suggests that there may be many other occurrences of this pattern in
> the future.
> 
> I agree that adding a generic hash API that takes a char[] algo_name
> and supports every flavor of hash that we happen to implement is a bad
> idea. But perhaps there is some middle ground here, with a build-time
> constant mask representing the algorithms that are actually supported
> at the call site, so that the compiler can prune the bits we don't
> need? I'm asking for the sake of discussion here, though - I don't
> have a use case myself where this is needed.

Right, it would be theoretically possible to have something like:

    static inline void hash(u32 supported_algos_bitmask, u32 algo,
                            const u8 *data, size_t len, u8 *out)
    {
            if ((supported_algos_bitmask & (1 << HASH_ALGO_SHA256)) &&
                algo == HASH_ALGO_SHA256)
                    sha256(data, len, out);
            else if ((supported_algos_bitmask & (1 << HASH_ALGO_SHA512)) &&
                    algo == HASH_ALGO_SHA512)
                    sha512(data, len, out);
            ... and so on
    }

And then something similar for init/update/final.  They'd have to take
in some sort of generic context type, which the caller would ensure is
sized to the maximum size needed by any supported algorithm.

I'm not sure I like this, though.  Just having the callers do it seems a
lot more straightforward.  (And again, crypto_shash remains an option
too.)

Of course, we should also keep in mind that usually in-kernel users only
want a single algorithm in the first place.  So this entire discussion
is about the less common case.

> > But I have to wonder, do you really need to add support for all these
> > hash algorithms?  Adding SHA-1 and SM3 support, really?
> >
> > What stops you from just saying that the kernel supports SHA-256 for
> > these user supplied objects, and that's it?
> >
> > Getting kernel developers to think carefully about what set of crypto
> > algorithms they'd like to support in their features, rather than punting
> > the problem to a generic crypto layer that supports all sorts of
> > insecure and esoteric options, isn't necessarily a bad thing...
> >
> 
> Yeah, that's a good point too.

- Eric

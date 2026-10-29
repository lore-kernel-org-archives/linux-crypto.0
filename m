Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793295082;
	b=kXHxCUfXD1ZSNw1giFJR+xEPCGs800iPWxRMdAnuYb2U1KOwQwx8UJL+fEwDP4T3ehqS
	 mHx51KKf8G5JYusIssmU3v2U06D53p5jxYMoHy+PByi8lrxQqZhb+cOmnB7R88nOLzvh8
	 gbnlXlW6/UUmiFwrCY3TS4JLls/xmb6emG1krxfGl9dofCm/W8f5GGzeDkgrFBNdb0/vC
	 VHpWcZmOzWJ77CGKGWH4X7tFvjRT29CFB9GqEPvNVGFLAGFqvMut7dP/mpG5MEvouCVce
	 MLWnPmgp9UAfwYKresYQlVSyXdsHcPg5P+uaOyjUe1nRizLTnOw2LqlxQpxbzlcewxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793295082;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UaecZCLo4s1tZwwFzdicmfEMCAz2hgk9vSpIeyDefmk=;
	b=cQMVVT0YeYEz8ehlCrthtWgbZUcPRVEK/aoeqb10cDuOgMh1JcNd+S9ZiQ3CwJk6nd0h
	 rCbr9MSAC0jtF3I3wIIL1yTyZS3AJhnzgTLvc+88Mo13J+Ai+W0PBVAS33cuItax6ATJk
	 yC1iIVuvLmfQ6Xaw/NxIw5RAuAYSrujTSOvtyoAAih8DPEsbMmebbF35RQDDbFkp0U3+E
	 u9BgQHmTCZ5rugvzkZYXfGzBbKcHnNegThowPvUPL+n/MBklpZ77k6lIydBo7qnIszIjS
	 CIN9LYcPEYenGr6EprbBlVI6RpXNTtkIQm9keAcJPUzlcLATd1ywD4ndJ7HKWRlYM+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=afAdiUjE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAA7606A31C;
	Thu, 29 Oct 2026 17:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=afAdiUjE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7867A1F01816;
	Thu, 29 Oct 2026 17:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793295081;
	bh=UaecZCLo4s1tZwwFzdicmfEMCAz2hgk9vSpIeyDefmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=afAdiUjEfW5cBzdgmIJZdBYQTXhAvTlDQGchS6iwThs7LgKXnlmDzwrClwvcrZLKc
	 6hKjHavCx+Z+PtZf0hJn6kmYwgQph8OtOmLHpjoYALQIx3mg45JE2nDrgAcsFBio3T
	 CAZljZXUF5lGiD7+Z27PbtMi8std6idwRKParQCPrJcm6pxB5PPLXL7UCN7oV8TSD2
	 V7KIUunSb/XcFnacnXgMyhrRbWOicDRRV2AP3emZpswxvQrB3+4tBCpcKMEa8ib7V5
	 SiMyRycOc4zdnYqDqmA+pB3AJx7xUqvvVQFf5mDO1EVx6Pv3AHlsePcUC0ELlemWse
	 QJTDnothmGogw==
Date: Thu, 29 Oct 2026 10:31:19 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>, ardb@kernel.org,
	Jason@zx2c4.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: aes: use memzero_explicit() instead of
 memset()
Message-ID: <20261029173119.GE1862@quark>
References: <20261028142636.5888-1-raizudeen.kerneldev@gmail.com>
 <20261028155134.GA4041913@google.com>
 <20261028205633.7625d789@pumpkin>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028205633.7625d789@pumpkin>

On Wed, Oct 28, 2026 at 08:56:33PM +0000, David Laight wrote:
> On Wed, 28 Oct 2026 15:51:34 +0000
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > On Wed, Oct 28, 2026 at 07:56:36PM +0530, Mohamad Raizudeen wrote:
> > > aes_gcm_decrypt() and aes_ccm_decrypt() use plain memset() to wipe the
> > > output buffer when authentication fails. But the compiler can optimize
> > > that wipe away, so use memzero_explicit() instead of memset().
> > > 
> > > This matches every other sensitive wipes in this file, which already
> > > uses memzero_explicit() for keystream blocks, tmp buffers, ctx
> > > teardowns.
> > > 
> > > Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> > > ---
> > >  lib/crypto/aes.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> > > index e1c191551736..7814ef525239 100644
> > > --- a/lib/crypto/aes.c
> > > +++ b/lib/crypto/aes.c
> > > @@ -1733,7 +1733,7 @@ int aes_gcm_decrypt(u8 *dst, const u8 *src, size_t data_len, const u8 *authtag,
> > >  		 * Clear the inauthentic decrypted data so that callers won't
> > >  		 * receive it even if they fail to correctly handle errors.
> > >  		 */
> > > -		memset(dst, 0, data_len);
> > > +		memzero_explicit(dst, data_len);  
> > 
> > This isn't for "zeroization" (making the data unavailable in ramdumps),
> > though.  It's just so the caller doesn't accidentally use the
> > inauthentic data, as the comment right above it states.
> 
> It is also a parameter so has to be zeroed anyway.
> memzero_explicit() is used to clear on-stack buffers.

Well, that assumes link-time optimization is not done.  The kernel
supports being built with link-time optimization.

I guess the motivation for this patch would be:

    (1) Shut up LLMs that think the use of memset() is inconsistent

    (2) Maybe the caller really does want "zeroization" for the dst
        buffer, even on failure -- and this guarantees it for them, even
        if LTO is enabled, without having to do it themselves.  (Though
        on success, they'll have to do it anyway.)

So I'm tempted to apply this patch anyway.

But the zeroization stuff is getting kind of annoying at this point,
when it's unreliable anyway (it's not like we zero out the registers,
which can then be spilled to the stack and/or written to the task_struct
on context switch) and can even be counterproductive (by forcing data to
be written to memory so that memset() can run on it, instead of kept
entirely in registers).  And Sashiko likes to flag them as Critical
issues, which is not at all accurate.

- Eric

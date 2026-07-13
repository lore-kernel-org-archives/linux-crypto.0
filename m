Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DBE388E51;
	Mon, 13 Jul 2026 23:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783986882; cv=none; b=HcKUKW3wAr+xSbixuNqnzPFHYpj+f1hhnickOjm+BN7ND7/qAgL/AcU+ITlYzHlwjAcTUyKVaNEkxcQFFZo/eBl+BUcLSuAJT396yBYRQtlzeWBdry5uSfNNR6+LagmiirVGOJ8ru74N0TYAmGewZFdw09+jAvAj/UHDalOeeVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783986882; c=relaxed/simple;
	bh=Q3fv/QGllSmNlQc112W52OMYL+8ZvWtlH4c2Ix/uAoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLX6TqKnRQ3P2PTIPvkoCOrGfsGRoFeYHhXVeQAw5Sw5eZRf9pQaSgGV7BI+oQcbxUgvqF8+j2407pym5D0NpaF1QHo1aMBm/pifPeptl/JgGHbpZNAas9WtQo6b1hWh0xFe1+z9nAC7snaxL3YyzYfWBjLTTA9thmD5ry+cDVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LaxUmI0h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LaxUmI0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A7A1F000E9;
	Mon, 13 Jul 2026 23:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783986881;
	bh=8+Mv6mEfJeXy9JpCdgv28fdyV5R8UKgbwGVh6rPlpqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LaxUmI0hFRZfWLiVESBb+y4x6ERK/J7x0dAH0aM7/us0pMFpi4fP8MGu1QiT8gbgf
	 5coaU19RF0AVpY19msfolopvcxSKmuMTUdcYKXYbiH1WIYuGhkQBxtyIXJgrd2kR5l
	 LOWEyIyxwHzUFZjSqv5L1bfs0BzH9XHsvvtLt6t9tbsWSIr04hgL7NOEL37IlLdDIK
	 2PM6KE/uyvgAB1tRDb8RIp/fja8PSi1jXyOu8QZ/OEmVgKMc1HqhylL6NgLAnxuJnO
	 Uk2PPEgAQLS6+m0/iz2cA6/GilvAkgf1V+CL5s7bpIN4Xt7kkTsDbMqEtnERsTShm5
	 n7jG1OPqQl4qQ==
Date: Mon, 13 Jul 2026 19:54:39 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/33] lib/crypto: aes: Add CTR and XCTR support
Message-ID: <20260713235439.GB24654@quark>
References: <20260707053503.209874-1-ebiggers@kernel.org>
 <20260707053503.209874-5-ebiggers@kernel.org>
 <40932e40-a909-4b95-b739-c4727c1cc153@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40932e40-a909-4b95-b739-c4727c1cc153@redhat.com>

On Mon, Jul 13, 2026 at 10:39:53AM +0200, Thomas Huth wrote:
> > diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
> > index fb8106034089..6aca01d715da 100644
> > --- a/Documentation/crypto/libcrypto-unauth-encryption.rst
> > +++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
> > @@ -27,6 +27,13 @@ Support for AES in the CBC and CBC-CTS modes of operation.
> >   .. kernel-doc:: include/crypto/aes-cbc.h
> > +AES-CTR and AES-XCTR
> > +--------------------
> > +
> > +Support for AES in the CTR and XCTR modes of operation.
> 
> I guess you already have this on your radar, but just in case: It would be
> nice to turn this into a full sentence, too.

Yes, I'm making all of them full sentences.

> > +/**
> > + * aes_ctr() - AES-CTR en/decryption
> > + * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
> > + *	 overlaps the behavior is unspecified.
> > + * @src: The source data
> > + * @len: Number of bytes to en/decrypt
> > + * @ctr: The counter.  It will be incremented by ceil(@len / AES_BLOCK_SIZE).
> > + * @key: The key
> > + *
> > + * This implements AES in counter mode with a 128-bit big endian counter.
> > + *
> > + * This supports incremental en/decryption.  The length of each non-final chunk
> > + * must be a multiple of AES_BLOCK_SIZE, and the updated @ctr must be passed in
> > + * each time.
> 
> Maybe add some wording that ctr ideally should not be 0 for the first call,
> i.e. a "nonce" value?

It depends on the usage.  If a distinct key is used for each message for
example, always starting at 0 is perfectly fine.

I'm not sure how far we should go to document the proper use of each
algorithm.  Really the AES-CTR support is just for internal use by
AES-GCM and AES-CCM, and a few odd users that implement specific other
protocols that need AES-CTR.  It's not intended to be a place to go to
receive an introduction to CTR mode.

> > +static __always_inline void inc_be128_ctr(u8 ctr[AES_BLOCK_SIZE])
> > +{
> > +	/* Casts to u8 are needed because of the implicit integer promotion. */
> > +	if (((u8)++ctr[AES_BLOCK_SIZE - 1]) != 0)
> > +		return;
> 
> Why do you handle the first value separately here? The code could be
> simplified to start with "int i = AES_BLOCK_SIZE -1" in the for-loop
> instead?

Just a trick to optimize performance by unrolling the first iteration,
since 255 times out of 256 the first iteration is enough.

> > +void aes_xctr(u8 *dst, const u8 *src, size_t len, u64 *ctr,
> > +	      const u8 iv[AES_BLOCK_SIZE], aes_encrypt_arg key)
> > +{
> > +	const __le64 iv0 = get_unaligned((const __le64 *)&iv[0]);
> > +	__le64 aes_input[2];
> > +	u8 keystream[AES_BLOCK_SIZE] __aligned(__alignof__(long));
> > +
> > +	if (likely(aes_xctr_arch(dst, src, len, ctr, iv, key.enc_key)))
> > +		return;
> > +
> > +	aes_input[1] = get_unaligned((const __le64 *)&iv[8]);
> > +	/* Handle the full blocks. */
> > +	for (; len >= AES_BLOCK_SIZE; len -= AES_BLOCK_SIZE) {
> > +		aes_input[0] = iv0 ^ cpu_to_le64((*ctr)++);
> 
> Do we want to have a BUG_ON or WARN_ON_ONCE somewhere to check that ctr does
> not wrap around (i.e. to make sure that ctr was really 1 for the first
> call)? Something like:
> 
> 	WARN_ON_ONCE((s64)(cpu_to_le64(*ctr) + len / AES_BLOCK_SIZE) < 0)
> 
> at the beginning of the function?

Maybe.  Since the counter is a u64, and this function isn't going to be
called from very many places, I don't think it would be a particularly
valuable WARN_ON_ONCE.  It shouldn't be BUG_ON.

- Eric

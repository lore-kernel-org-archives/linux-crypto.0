Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794599863;
	b=SVr2lN00LD5tYvJev5MMOS1DNDS+nPDCkpzBLxJgQBogtts+q+pmeFzv0/oB+DTBjUhd
	 rN4UfOJ8Mwe2vXsxuyn+f3WUOOOTCq97GNe9mIiyV8Ba98S18FORFlv9ZWoEReY6EUzZH
	 Ig93LzxWeHaZFkA452o5OYmzjZTHr0SElnUfk+qQz3XjVEOWLQHbHtg/1VaP8oU9P3dTI
	 cL//qqRTnrX1M7/60SqHjCDl5dqX2Hl7hcN84yNjDFLq76NdjQ9wy6cSdNeRcsQjBdjTx
	 pinQR+wu089H9IJX+3ysWB8qb1kg4V9TZBFtmOTfx3L8B5Jm3ND8Tbw42vail67L23Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794599863;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=w3WMTipPoApv9/f0brflAUXJdN29RsdV0N4wNdbKBcY=;
	b=0ghXBy2UzRmEOe/JnMy8QW3hBAbEbhc9Uwflg5/6zISGF9TOWpzJm7LsaK7wOQiGgydL
	 wzZCbZA5fr2opyhywuW0WuE9j295kWrDusmhfKXk5ljrQELBXZj6HJH6In/Dki5rD3EuC
	 BzkRaqAWVSnuPnvZRyJuwlUGq1EA331cpfRjY4PoDkLSwM2y89KwRYIZBwtDBQozgZRIK
	 h0sJqv1nhS0crv5qkjN0SxWTvESmqbz9ANI4BgGog7RLJy54LFe/2yhlYz/Q0eSjYtMxD
	 fNpXzh7k+j2vS3tVMgdX/KSK7c5oFhpv1KhtCN0emhGcnmiQMlofSO1WzEfpdfESojg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i8zWvxi0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953FA606A8A4
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 19:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i8zWvxi0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F921F000C4;
	Fri, 13 Nov 2026 19:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794599863;
	bh=w3WMTipPoApv9/f0brflAUXJdN29RsdV0N4wNdbKBcY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i8zWvxi0tF+hVZY1VLmdPUhZ0vy4POGLKxEtnuaIxIC9eDlfYPUFsTesnzzBQF7uU
	 pc1NblhEKL9QhRfXHBE+ZKhF2sSF/dqGjPWuac244vYVDmOC2sdpF4rhYdQ1+nGA4i
	 CNAa3CCDB3mAXfW+Iz0d52JHyMljXKgPXa25m3ci4v6HTMCBYhbBf3ZT1FpcqtaUrj
	 epq2OT+W6dsDfre57w3EQMR0ya+5kXx6g20CNcM06TqPqAgy0zzGvNft2hQb7SlWOb
	 rFFxbr4d5fKrxF/jPtcpwsJFbDUoiX/wcAEYu1oNh9XVgnV2c9eIE+J+NSQID5iKqh
	 lWIOIXc218Vrw==
Date: Fri, 13 Nov 2026 11:57:42 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 04/14] crypto: jitterentropy - Add library API
Message-ID: <20261113195742.GA2147@quark>
References: <20261018204618.104876-1-ebiggers@kernel.org>
 <20261018204618.104876-5-ebiggers@kernel.org>
 <cc552609-ece5-4f82-94b2-b00edf0f92a7@redhat.com>
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
In-Reply-To: <cc552609-ece5-4f82-94b2-b00edf0f92a7@redhat.com>

On Fri, Nov 13, 2026 at 12:28:12PM +0100, Thomas Huth wrote:
> Am 18.10.26 um 22:46 schrieb Eric Biggers:
> > Make the jitterentropy RNG accessible using a regular set of functions.
> > 
> > This will allow drbg.c to just access it directly, instead of going
> > through the overly-general crypto_rng abstraction.
> > 
> > Later commits will remove crypto_rng.
> > 
> > Note that the library API should also continue to meet all the same
> > certification requirements, including the health check which occurs on
> > the first call to crypto_jent_alloc().
> > 
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> ...
> > +int crypto_jent_get_bytes(struct jitterentropy *rng, u8 *out,
> > +			  unsigned int out_len)
> > +{
> > +	int ret;
> > +
> > +	guard(mutex)(&rng->jent_lock);
> > +
> > +	ret = jent_read_entropy(rng->entropy_collector, out, out_len);
> > +
> > +	if (ret == -3) {
> > +		/* Handle permanent health test error */
> > +		/*
> > +		 * If the kernel was booted with fips=1, it implies that
> > +		 * the entire kernel acts as a FIPS 140 module. In this case
> > +		 * an SP800-90B permanent health test error is treated as
> > +		 * a FIPS module error.
> > +		 */
> > +		if (fips_enabled)
> > +			panic("Jitter RNG permanent health test failure\n");
> > +
> > +		pr_err("Jitter RNG permanent health test failure\n");
> > +		return -EFAULT;
> EFAULT means "bad address" in the sense of a page fault ... not sure whether
> this is the appropriate error code here? Maybe -EIO would be a better fit?

I intentionally left the EFAULT unchanged from the old code in
jent_kcapi_random(), to limit the scope of this conversion.  I agree
that EFAULT is not an appropriate error code here though, and feel free
to send a separate patch that changes it to something else.  Thanks!

- Eric

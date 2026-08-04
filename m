Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77D23FD969;
	Tue,  4 Aug 2026 18:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785869646; cv=none; b=VginWI6kOrPFm3yZ4YKhUzpA/+Mq50zcghUnJtUoU79NJlQ/sVu7QhOk2Os/ukMNST823qroPCR68NzP5MODqcR9ZIEIhbIoNdWLj19Joh4bUAj0EcDP9GSgKT5c+HmQMl0o8EiX8lnVxNfOXr45ML+P4TH78jaV3ObZcmSCa0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785869646; c=relaxed/simple;
	bh=TRHeSamFtEeWBkzA8LF0gusIqdo9Fd8YFajv4eG/Jf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4rVJM8aHaVDjm8/2n1Yj8vO7da3E4B/T1diXNMhGJlW/eM9iJPK2M/0fJZYHaaj/mnDfnAsgP/JhX2zN4334Sdpi3KNDUK73Aog8Lr3XFxQ5AFlSaEmcqrlyQZcaBl/eakM6CP9pgOZJSvhoj3ltjPtL+k1gFIZSwL2NiBUPuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bNNBTzI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNNBTzI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504F51F000E9;
	Tue,  4 Aug 2026 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785869644;
	bh=tnMXzfe4LECRTPKRS4xu81OpslrgME/+c1t8fxSQ1V0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bNNBTzI5PyPFq7sOJ4Sq1D6jezCBC8iGI0CClaXiU8feND2eplyanbdX6Gl/kbX8E
	 6L8+/M224YffJxJLeCcUHeYXN55pf9i8ZRCLPgJksuZn5/Kgo7FC09Mmo+KbrR04iC
	 w+UiO2MHn3rxJmShUEGnB+J4VDHcVfja856BIqt/gEqxprDPZH0AFd9KiXRmyo37K6
	 X3GsKZKsaIzijUrm6TjrH+rNIHG/ua7so66sZWqeOScjUBusn1edck0yW1vzmQy/W0
	 ZUzU3vlr8B9tVymydHh+05alF5ycO4mvCbC1V/9mkSmLACezdBj/PFm7mFchuLwUZJ
	 2e7OpzQ6RFXDA==
Date: Tue, 4 Aug 2026 18:54:02 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Simo Sorce <simo@redhat.com>
Subject: Re: [PATCH v2 1/9] crypto: Provide a wrapper for zeroizing
 crypto_aes_ctx
Message-ID: <20260804185402.GD2904385@google.com>
References: <20260803094432.70505-1-thuth@redhat.com>
 <20260803094432.70505-2-thuth@redhat.com>
 <20260803190540.GD2062@quark>
 <46104b3b-ae4b-4255-b7ab-c994a59c9882@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46104b3b-ae4b-4255-b7ab-c994a59c9882@redhat.com>

On Tue, Aug 04, 2026 at 09:42:34AM +0200, Thomas Huth wrote:
> On 03/08/2026 21.05, Eric Biggers wrote:
> > On Mon, Aug 03, 2026 at 11:44:20AM +0200, Thomas Huth wrote:
> > > From: Thomas Huth <thuth@redhat.com>
> > > 
> > > Several crypto drivers need to zeroize their local crypto_aes_ctx
> > > structures after use to avoid leaking key material on the stack.
> > > Currently some call sites do this with their own memzero_explicit()
> > > call, which is error-prone since it is easy to miss a return path
> > > (what already happened in some drivers). Some other call sites miss
> > > to clear crypto_aes_ctx completely.
> > > 
> > > Provide an aes_clear_ctx() helper that can be used with __cleanup()
> > > to automatically zeroize the context when it goes out of scope.
> > > 
> > > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > > ---
> > >   include/crypto/aes.h | 13 +++++++++++++
> > >   1 file changed, 13 insertions(+)
> > > 
> > > diff --git a/include/crypto/aes.h b/include/crypto/aes.h
> > > index 3279cfa546085..5ca7b1ab50e8c 100644
> > > --- a/include/crypto/aes.h
> > > +++ b/include/crypto/aes.h
> > > @@ -159,6 +159,19 @@ static inline int aes_check_keylen(size_t keylen)
> > >   int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
> > >   		  unsigned int key_len);
> > > +/**
> > > + * aes_clear_ctx - Zeroize a crypto_aes_ctx structure
> > > + * @ctx:	The location of the context that should be zeroized
> > > + *
> > > + * Explicitly fills the crypto_aes_ctx with zeroes. This should be done
> > > + * once the context is not required anymore to avoid that its contents
> > > + * are leaked on the stack or heap.
> > > + */
> > > +static inline void aes_clear_ctx(struct crypto_aes_ctx *ctx)
> > > +{
> > > +	memzero_explicit(ctx, sizeof(*ctx));
> > > +}
> > 
> > Acked-by: Eric Biggers <ebiggers@kernel.org>
> > 
> > I guess we should start using __cleanup with type-specific zeroization
> > functions like this more often.
> 
> Yes, and I already got some more patches for other structure in the works
> already, just wanted to get review feedback on this series here first before
> sending them out / continuing that work.

By the way, in the function names could you consider using the verb
"zeroize" instead of "clear"?  So "aes_zeroize_ctx()".  We already have
sha3_zeroize_ctx(), shake_zeroize_ctx(), and chacha_zeroize_state().
And try 'git grep -i zeroize'.  It is the usual word used to mean
zeroization for crypto purposes specifically.

> > One gotcha is that __cleanup and 'goto'
> > should not be mixed in the same function; see the comment at
> > include/linux/cleanup.h line 148.  Patch 8 of this series doesn't follow
> > that in safexcel_aead_setkey().
> Ah, thanks for the hint, I wasn't aware of that recommendation yet!
> 
> As for safexcel_aead_setkey(), I think the change should be fine since the
> __cleanup() is declared at the very top of the function and not somewhere in
> an inner scope, so there is no way that the "gotos" could skip the cleanup
> here.
> 
> To get rid of the "gotos" here, I'd need to introduce another cleanup
> function for crypto_authenc_keys first, so if you insist of not mixing the
> __cleanup(aes_clear_ctx) with the gotos here, I think I'd rather drop that
> hunk from the patch for now, and provide another patch series with a cleanup
> for crypto_authenc_keys later that then adds the __cleanup() to both, struct
> crypto_authenc_keys keys and struct crypto_aes_ctx aes here and removes the
> gotos at the same time.
> 
> So WDYT, drop the hunk here for now and send a v3 with that, or keep the
> current v2 of this patch with its (hopefully unproblematic) ugliness?

Dropping that hunk sounds good.  I recommend avoiding the mixed
__cleanup and gotos even when they are done correctly, as it's easy to
get wrong and it raises questions.

Zeroziation of struct crypto_authenc_keys should just be removed, as
it's just a helper struct for parsing the key buffer.  It contains only
pointers into the key buffer, not the keys themselves.

- Eric

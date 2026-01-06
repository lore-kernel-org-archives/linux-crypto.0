Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2963009C1;
	Tue,  6 Jan 2026 06:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767682717; cv=none; b=cnU5FThlLyYF5k6JMBFmkwKIcMdobPhz4m+5PK9an800499sN0u3emGvXMS3GtxqPoF3BY9ZOMTr0c/UrAjEOeIw2TrXd5J7BJvSFB6nTRkYUSliST17+Cu7kVpEQRmPzQBILNXeYt4SHm1bVzM+exgcVzpSpzTQPk/dQVNx5Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767682717; c=relaxed/simple;
	bh=QQtOk2YRE84AoYQ+kSLZyLAyg4ikVDFr3IES1pY5ozA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kelyriLihvhEfn3FBmwnxP+T0oO3UP6MM4zoJYVf7BxamgWa00+LMs83kBCYkb/Wv7iABT3e4o6GCW+5Ka3SOI2A75Sma+B/yLvmnD1hrgIqlxjrEw+WPWBRbbkeO3eSz8wcvFqF4vXIVV3oyHqtpxSnOtM9QYoBWznZi+8DKBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gH/mbhwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gH/mbhwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076F4C116C6;
	Tue,  6 Jan 2026 06:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767682716;
	bh=QQtOk2YRE84AoYQ+kSLZyLAyg4ikVDFr3IES1pY5ozA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gH/mbhwWcmbSviWB2aCXqeJKPYzexAoK01Yg6s6cLwpp5mznoR4J9YtzBX0+JaB2Q
	 RGzl1CWYt5ctBprLFLGJSvPejfop4znvHRnWwqgqpJHcHC0j9ob/Np83XrO9+Cl3TX
	 VS8m3uLgzCzbvtCwipbPzokR0Dek9Wxm/0Ippytis8vLZ/I6x2I70gfKMwQbmEhFro
	 NAdguE5T18zqwp0QS2kDwlBde/OWsN6qjyPmGKZIp7wCv7/K32g7gRemPHItu6WY9g
	 OF83QkAKrc+JLLzKj3XjbpThHQLvD4g3n1HMYbOp1iZmU15u/EOi4JVaYquL+5oCoh
	 XLNrjl71mrNfw==
Date: Mon, 5 Jan 2026 22:58:17 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Jason@zx2c4.com,
	ardb@kernel.org, dengler@linux.ibm.com, freude@linux.ibm.com,
	herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 19/36] Bluetooth: SMP: Use new AES library API
Message-ID: <20260106065817.GB2630@sol>
References: <20260105051311.1607207-20-ebiggers@kernel.org>
 <859377de-cb72-4e87-8ee5-97f8c58a5720@citrix.com>
 <20260105190503.53cc31dd@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260105190503.53cc31dd@pumpkin>

On Mon, Jan 05, 2026 at 07:05:03PM +0000, David Laight wrote:
> On Mon, 5 Jan 2026 15:40:22 +0000
> Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> 
> > >  	/* Most significant octet of plaintextData corresponds to data[0] */
> > >  	swap_buf(r, data, 16);
> > >  
> > > - aes_encrypt(&ctx, data, data); + aes_encrypt_new(&aes, data, data);  
> > 
> > One thing you might want to consider, which reduces the churn in the series.
> > 
> > You can use _Generic() to do type-based dispatch on the first pointer. 
> > Something like this:
> > 
> > void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
> > void aes_encrypt_new(aes_encrypt_arg key, u8 out[at_least AES_BLOCK_SIZE],
> >              const u8 in[at_least AES_BLOCK_SIZE]);
> > 
> > #define aes_encrypt(ctx, out, in)                                       \
> >     _Generic(ctx,                                                       \
> >              const struct crypto_aes_ctx *: aes_encrypt(ctx, out, in),  \
> >              aes_encrypt_arg: aes_encrypt_new(ctx, out, in))
> > 
> > 
> > i.e. it keeps the _new()-ism in a single header, without needing to
> > change the drivers a second time.
> 
> You'll need to cast the 'ctx' argument in both calls.
> All the code in an _Generic() must compile cleanly in all the cases.
> (Totally annoying....)
> 
> 	David

It seems it would actually have to be:

#define aes_encrypt(key, out, in) \
_Generic(key, \
	 struct crypto_aes_ctx *: aes_encrypt_old((const struct crypto_aes_ctx *)key, out, in), \
	 const struct crypto_aes_ctx *: aes_encrypt_old((const struct crypto_aes_ctx *)key, out, in), \
	 struct aes_enckey *: aes_encrypt_new((const struct aes_enckey *)key, out, in), \
	 const struct aes_enckey *: aes_encrypt_new((const struct aes_enckey *)key, out, in), \
	 struct aes_key *: aes_encrypt_new((const struct aes_key *)key, out, in), \
	 const struct aes_key *: aes_encrypt_new((const struct aes_key *)key, out, in))

#define aes_decrypt(key, out, in) \
_Generic(key, \
	 struct crypto_aes_ctx *: aes_decrypt_old((const struct crypto_aes_ctx *)key, out, in), \
	 const struct crypto_aes_ctx *: aes_decrypt_old((const struct crypto_aes_ctx *)key, out, in), \
	 struct aes_key *: aes_decrypt_new((const struct aes_key *)key, out, in), \
	 const struct aes_key *: aes_decrypt_new((const struct aes_key *)key, out, in))

Note that both const and non-const args need to be handled.

It also doesn't work for any callers passing a 'void *' or
'const void *' and relying on an implicit cast.  I didn't notice any,
but that needs to be considered too.

I guess maybe it would still be worth it to avoid the "*_new" name
temporarily leaking into too many files.  (It goes away by the end of
the series anyway.)  It's just not quite as simple as you're suggesting,
and all the callers have to be checked for compatibility with it.

- Eric

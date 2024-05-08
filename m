Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF78114A8C;
	Wed,  8 May 2024 17:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715188776; cv=none; b=QSSPk5xp6dG8PwvOWwm7gejQZyRvlj0oUIQAnRtYJSzDOIm7cpQg0uze/4IOmD35ts73sel131NDGhfFN2HxQn8RoXnHz7bXrXJfGnhcAxkaDDswYngK5Hjbq1zxMKU+FDowhpah6Z9JQFg11fm/E4C1enPqLqnlulkRS9BRoVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715188776; c=relaxed/simple;
	bh=pb5+k8XHSQ0D1eISbFZIj5PJPfHcwqj3VC8RT4WOmu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHyHe7ciRBBe3xzIwi5FV1nwo+QvQwapeO3tnYyEmrATl6d3ty52XSaiCZEjYyKund01Fz4ouZkxCT60OCFtGgtLjDSGKUbJuV/MmGjhoDkTictUyMnO7X52SOvhF6MPhrzcLXLBkYUlgy2WRI+ySxKyiHGZbt1e2QlWaFYBVp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gOPGAxJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gOPGAxJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F62C2BD11;
	Wed,  8 May 2024 17:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715188775;
	bh=pb5+k8XHSQ0D1eISbFZIj5PJPfHcwqj3VC8RT4WOmu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gOPGAxJCwfQ//lFHHvGPvIptaT5wyEznoXu97Z6asxiORAI817VzhWZyu3W2mRax+
	 CUXO9V6guRw9JfI7R7h1be/J57Syt0Fhcs8G1u5vnojLk74DwZWeBKQ9nGnvZhVGeq
	 C0bLXWbiq4rP5Bv/N0qRnIfbJBYX/N48iy2O1bYWOXT7nCWI7rmCYZTC3HdwmMKVQS
	 Q36M7iPaC0mmDlClVh92kGaDFYZf8QTPER40KADP8jUN/5NQDFyTyA3rsSaGaPQayJ
	 HTEdMYIHGHio+1YpKc91NAj6m4qkR28PuX92R22tnDEqru7MlXeQKaSWDjrOiz1MSQ
	 jcRtgJeOiMYIg==
Date: Wed, 8 May 2024 10:19:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/aes-gcm - add VAES and AVX512 / AVX10
 optimized AES-GCM
Message-ID: <20240508171934.GA19059@sol.localdomain>
References: <20240508071734.199462-1-ebiggers@kernel.org>
 <CAMj1kXHnBA5qeyHa-b6w+cw5-iomA=3drk7yGGzp-gc_-4uKig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHnBA5qeyHa-b6w+cw5-iomA=3drk7yGGzp-gc_-4uKig@mail.gmail.com>

On Wed, May 08, 2024 at 11:01:25AM +0200, Ard Biesheuvel wrote:
> > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > index 5b25d2a58aeb..e4dec49023af 100644
> > --- a/arch/x86/crypto/aesni-intel_glue.c
> > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > @@ -1212,17 +1212,481 @@ static struct simd_skcipher_alg *aes_xts_simdalg_##suffix
> >  DEFINE_XTS_ALG(aesni_avx, "xts-aes-aesni-avx", 500);
> >  #if defined(CONFIG_AS_VAES) && defined(CONFIG_AS_VPCLMULQDQ)
> >  DEFINE_XTS_ALG(vaes_avx2, "xts-aes-vaes-avx2", 600);
> >  DEFINE_XTS_ALG(vaes_avx10_256, "xts-aes-vaes-avx10_256", 700);
> >  DEFINE_XTS_ALG(vaes_avx10_512, "xts-aes-vaes-avx10_512", 800);
> > -#endif
> > +
> > +#define NUM_KEY_POWERS         16 /* excludes zero padding */
> > +#define FULL_NUM_KEY_POWERS    (NUM_KEY_POWERS + 3) /* includes zero padding */
> > +
> > +struct aes_gcm_key_avx10 {
> > +       struct crypto_aes_ctx aes_key AESNI_ALIGN_ATTR;
> > +       u32 rfc4106_nonce AESNI_ALIGN_ATTR;
> 
> Is the alignment needed here?
> 
> > +       u8 ghash_key_powers[FULL_NUM_KEY_POWERS][16] AESNI_ALIGN_ATTR;
> > +};

It only has an effect on ghash_key_powers, so I'll probably drop it from the
other two fields.  This struct is also missing a comment, so I'll add one.  As
for why ghash_key_powers is aligned (and also aes_key by virtue of being at the
start of the struct), it slightly improves performance of the load instructions
vmovdqu8 and vbroadcasti32x4.  It's not absolutely required though.  I.e., the
assembly doesn't use instructions like vmovdqa8 that actually enforce alignment.

Semi-related note: I forgot to account for the alignment of the whole struct in
aead_alg::base::cra_ctxsize.  I'll fix that too.

> > +static int gcm_setkey_vaes_avx10(struct crypto_aead *tfm, const u8 *raw_key,
> > +                                unsigned int keylen, bool vl256)
> > +{
> > +       struct aes_gcm_key_avx10 *key = aes_align_addr(crypto_aead_ctx(tfm));
> > +       int err;
> > +
> > +       /* The assembly code assumes the following offsets. */
> > +       BUILD_BUG_ON(offsetof(typeof(*key), aes_key.key_enc) != 0);
> > +       BUILD_BUG_ON(offsetof(typeof(*key), aes_key.key_length) != 480);
> > +       BUILD_BUG_ON(offsetof(typeof(*key), ghash_key_powers) != 512);
> > +
> > +       if (likely(crypto_simd_usable())) {
> 
> Is it really necessary to have 3 different code paths here? If so,
> could you add a comment why?

I think it's worth optimizing setkey for AES-GCM, since the assembly version of
setkey is over 30x faster than the portable C version, and there are
circumstances in which setkey performance could be important.  For example
latency of connection establishment, and throughput for users who change keys
frequently.  The portable C version takes roughly the same amount of time as
encrypting 37 KB of data, which is a lot.

There are also cases where new AES-GCM keys might be set even more frequently
than expected.  These do not necessarily apply to Linux right now.  But these
are issues that could easily arise, especially if my assembly code gets reused
in userspace projects where it could see a wider range of use.  So I wanted to
have the assembly support pre-computing the hash key powers from the start.

First, sometimes people work around AES-GCM's short nonce length by using an
XChaCha-like construction.  This results in a unique AES-GCM key for every
message even if the key for the top-level mode does not change.

Second, people don't always use APIs in the optimal way.  The ability to pre-set
a key can be supported in the API, but some people will write a function like
'byte[] encrypt(byte[] key, byte[] data) anyway, resulting in a key being set
individually for every message, even if it doesn't change.  The OpenSSL API also
has a huge pitfall where to *not* set a new key, you have to explicitly pass
NULL, which I'm sure many people get wrong.

As for why have both aes_gcm_precompute_vaes_avx10_256() and
aes_gcm_precompute_vaes_avx10_512(), the value of the 512-bit one is marginal,
but it's easy to provide, and it does work nicely because the total size of the
key powers being computed is always a multiple of 512 bits anyway.  So the full
512 bits will always be used.  I.e. there's no issue like there is for the AAD,
where the AAD is usually <= 256 bits so I made it just use 256-bit vectors.

As for why have the portable C code path when there is assembly too, I think
that unfortunately this is required to fulfill the skcipher API contract on x86.
Assuming that crypto_skcipher_setkey() can be called in the same contexts as
crypto_skcipher_encrypt(), it can be called in a no-SIMD context.

- Eric

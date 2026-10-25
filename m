Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792968446;
	b=gQzlm/3QUTSRrgUeGp7nH84c4svaLcmqGnSzKd/cWPp7ejT6T7RT6sMLTMfSCpAkeZzC
	 tWxMt/GQDmj7+sNDoZQS0hGhIfhRYYqYf2IzMu5kp3bBhkPx1Txvf59eVZq6YDDDgSI10
	 QlgLIw1TfeBdipNbh9+qRA2X/MfYzRp/pScIcLTKPOwG5F9MTH8A2TG1z9JUgUlOgBiBe
	 ACHUnHHNjCISIcugHRbWfqaBR/o38PpqWRmFNB2EWkmXSlMvp5pjJbtMKta/1oYJAN0Ks
	 a5eqFtosP1Xr2aQj+4B6Js249EZ68Vbd6aPxwQHkPNnP/EucslwXKvAfJ2i17R2Eo5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792968446;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ma2+2HLgMxTP1puOQa7e+OwNUTUxPmA6Pa742T7EYWw=;
	b=Gy8CMjZmxYXxrcuvXbpHnUwYdr2OhDFdOJA+YaG2O/1zIXkJoC67MlFZ++KXzOzuRQPr
	 0ZFgZSJiRahOhkYha1G736nt3IDEGPgA4el2rYtXWX1aqv70vAQFQbOL06xR6O23bVtqV
	 jFigpuOGLi3dKL14YAGpNagtu4+UeSlS2xuVvuQczXvi+aqJ7tJ0M04j1s2ktIYJ8A9B2
	 tWJLTWvzC+dGyEOHXuqCTPdlB9zoMIsYl7L1Uzpr62QcdYcoCTOKjSEgOlQlPLIaysz9z
	 suFSCYFYtqJWz8aFBgNAZAnwLCdGAkFAQ2yhJ8EisNduldwHy5Wp+wU1REroXjPwKRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="gc3M/AUP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50EA606A31A;
	Sun, 25 Oct 2026 22:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gc3M/AUP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E6D1F01825;
	Sun, 25 Oct 2026 22:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792968445;
	bh=ma2+2HLgMxTP1puOQa7e+OwNUTUxPmA6Pa742T7EYWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gc3M/AUPKqKDfU3ZuLTyM6upCOoT2npeIb6TNKk16ntNH3pQkVVpgs1iWFXLVNYSk
	 q6zhnTk8z5OoKfgl/RxOyGgQOmjyKTKkgmwLqynU9mKisyYXk+1zit99DYLTrpp9Gy
	 UoltKfTvK2eQcuBhZ21gqRTbrVN0mHXt/BIRwx624Ib4bB2sx7YY7K+zXOdxpmqO9D
	 u6OEX9WWr5NchuXPL1K5krEwwfNPJKDm7hdeRamedzzGaxhoB36YMx34Z6vvOW+jQB
	 tp8e8ZjeWf8fXspQAzzbN7o8//Eke6/FQ+rtS30/8Pm8LASJ1wwRABxUeik/zgfTa1
	 hnDMLBlw4S2yg==
Date: Sun, 25 Oct 2026 15:47:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Check return value of crypto_kpp_set_secret()
Message-ID: <20261025224723.GA148998@quark>
References: <20261025211119.138277-1-ebiggers@kernel.org>
 <at5-ve5Ap7Oyp1Fo@kernel.org>
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
In-Reply-To: <at5-ve5Ap7Oyp1Fo@kernel.org>

On Mon, Oct 26, 2026 at 12:12:13AM +0200, Jarkko Sakkinen wrote:
> On Sun, Oct 25, 2026 at 02:11:19PM -0700, Eric Biggers wrote:
> > crypto_kpp_set_secret() can fail, for example if the kernel is booted
> > with fips=1 and the broken-by-design FIPS RNG used for ECC private key
> > generation doesn't feel like generating random bytes at the moment.
> > Check for error, cancelling the TPM session creation rather than
> > proceeding with a zero or uninitialized private key.
> > 
> > Fixes: 699e3efd6c64 ("tpm: Add HMAC session start and end functions")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  drivers/char/tpm/tpm2-sessions.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
> > index ca1e2bf424e14..2aaaad69760dc 100644
> > --- a/drivers/char/tpm/tpm2-sessions.c
> > +++ b/drivers/char/tpm/tpm2-sessions.c
> > @@ -527,7 +527,9 @@ static int tpm_buf_append_salt(struct tpm_buf *buf, struct tpm_chip *chip,
> >  	}
> >  	crypto_ecdh_encode_key(encoded_key, buf_len, &p);
> >  	/* this generates a random private key */
> 
> Could you delete this comment while at it? It's not helping with
> anything.
> 
> > -	crypto_kpp_set_secret(kpp, encoded_key, buf_len);
> > +	rc = crypto_kpp_set_secret(kpp, encoded_key, buf_len);
> > +	if (rc)
> > +		goto err_free_kpp;
> >  
> >  	/* salt is now the public point of this private key */
> >  	req = kpp_request_alloc(kpp, GFP_KERNEL);
> > 

I actually think the comment is helpful, because of how unreadable the
crypto_kpp API is.  It's generating a private key, but to request that,
crypto_kpp apparently requires that an empty key be encoded into a byte
string.  Then that key is "set", which actually generates a new key.

In comparison, the Curve25519 equivalent is
curve25519_generate_secret(), which is clearly named and also always
succeeds.  At some point we need to fix the ECDH API...

- Eric

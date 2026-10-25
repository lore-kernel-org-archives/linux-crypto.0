Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792970925;
	b=G19vOtxj1HuCSsO/ZOFyCXSO1BQcDbZkP/Z99Gc3RmHIN+kvHCcQWqQfPxyMI7zh8+TU
	 uKQ/2VD/UNJnutpOguSprtg0PL9nQ6P3+jqGCRquAexwVxiUMVXxMfBpDTDEuk7z9tFBM
	 LOKjuuFAQ3D7UArXl4ie8OmVbJkWPJsU8l+dgH1izVPVDtBKmcyOyaPUeu2aak9NxU1a1
	 0phd3PcCSxh1B3WWRrgpGrcwXjMCaaKoL7gR/Bf9vtjWC/pNMwGW0etJJzTge6WR2zVUd
	 +sqsaWg5+HFT0fAoUfa7FV3N8BrUdA6xrpij250DkXzxa3cZkp3mOZiCKZFwMlpbtKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792970925;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=iEFI99ZyRARrz+clfOCd9HOuHHG5pJ8vfkDQ7OOdfSo=;
	b=Jerp4rKiYfX+SZr2zLPDYiRI8z9gCTHydeENwLehIp7pCLAuTYQdiThxX3eSoW9eVrRw
	 l3PRlWLBJJ79gyWsfUIk1qphuMgr8KzlL0baO9eCZh2efw5yX4XJtkTch3t3netSQo7Mj
	 LMHNyRenyskYchaGmrTteur3r6mod3k6idtVxXCeF+9YX7vI0uYTDtQMknou5aoBJ9ILe
	 8QoeiMdyE2VkESwT4K0exiJp09+pir/ePLoaJz1nXd3Bp+rVJHxVZ9HfJSkntoK06aYSo
	 Zek8l2/Zr5V4SwyuaY85l60C+LOL2ti1Vey8dLBhfOb2I80owB2RnQd/sdhmQyRJodA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9sK3mpQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 712D0606A31A;
	Sun, 25 Oct 2026 23:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9sK3mpQ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6F7BD1F01825;
	Sun, 25 Oct 2026 23:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792970925;
	bh=iEFI99ZyRARrz+clfOCd9HOuHHG5pJ8vfkDQ7OOdfSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d9sK3mpQsKcEaXApFMwJIPwqCQE4dCIlv8zM+5Jajz71RXH/7OVSjeoTSpu149hSx
	 zNNb05tZGEm3EMqefMWzkaqf8gSha0Cs6H8UsNCa1rpuATeaJJcJLe5/7rKu387820
	 mg1p4GEUSeKwehMWx/B0zckxM/NO7c/c39LHFHRia+LStyQWE4dR3zD9IIPZ7yeDq0
	 7eIR010xxbrhbVwDn6GuIo2TqK8fcWKKaxpsvretOyKwS/A61P2w0jcpnzzORugtRz
	 uih8UQ2BF+YmPxyUlqc7Wx2nbFOpBG78DBL5dnPltoHHYHqyNoUaR/P8g1kEdb6a8O
	 yQjX6erBxolmA==
Date: Mon, 26 Oct 2026 01:28:41 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Check return value of crypto_kpp_set_secret()
Message-ID: <at6QqYWELUtDqUUT@kernel.org>
References: <20261025211119.138277-1-ebiggers@kernel.org>
 <at5-ve5Ap7Oyp1Fo@kernel.org>
 <20261025224723.GA148998@quark>
 <at6MlY1kpfa01tr4@kernel.org>
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
In-Reply-To: <at6MlY1kpfa01tr4@kernel.org>

On Mon, Oct 26, 2026 at 01:11:21AM +0200, Jarkko Sakkinen wrote:
> On Sun, Oct 25, 2026 at 03:47:23PM -0700, Eric Biggers wrote:
> > On Mon, Oct 26, 2026 at 12:12:13AM +0200, Jarkko Sakkinen wrote:
> > > On Sun, Oct 25, 2026 at 02:11:19PM -0700, Eric Biggers wrote:
> > > > crypto_kpp_set_secret() can fail, for example if the kernel is booted
> > > > with fips=1 and the broken-by-design FIPS RNG used for ECC private key
> > > > generation doesn't feel like generating random bytes at the moment.
> > > > Check for error, cancelling the TPM session creation rather than
> > > > proceeding with a zero or uninitialized private key.
> > > > 
> > > > Fixes: 699e3efd6c64 ("tpm: Add HMAC session start and end functions")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > > > ---
> > > >  drivers/char/tpm/tpm2-sessions.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
> > > > index ca1e2bf424e14..2aaaad69760dc 100644
> > > > --- a/drivers/char/tpm/tpm2-sessions.c
> > > > +++ b/drivers/char/tpm/tpm2-sessions.c
> > > > @@ -527,7 +527,9 @@ static int tpm_buf_append_salt(struct tpm_buf *buf, struct tpm_chip *chip,
> > > >  	}
> > > >  	crypto_ecdh_encode_key(encoded_key, buf_len, &p);
> > > >  	/* this generates a random private key */
> > > 
> > > Could you delete this comment while at it? It's not helping with
> > > anything.
> > > 
> > > > -	crypto_kpp_set_secret(kpp, encoded_key, buf_len);
> > > > +	rc = crypto_kpp_set_secret(kpp, encoded_key, buf_len);
> > > > +	if (rc)
> > > > +		goto err_free_kpp;
> > > >  
> > > >  	/* salt is now the public point of this private key */
> > > >  	req = kpp_request_alloc(kpp, GFP_KERNEL);
> > > > 
> > 
> > I actually think the comment is helpful, because of how unreadable the
> > crypto_kpp API is.  It's generating a private key, but to request that,
> > crypto_kpp apparently requires that an empty key be encoded into a byte
> > string.  Then that key is "set", which actually generates a new key.
> > 
> > In comparison, the Curve25519 equivalent is
> > curve25519_generate_secret(), which is clearly named and also always
> > succeeds.  At some point we need to fix the ECDH API...
> 
> Ah, right it gets zero filled echd. I've not consciously thought this
> detail before, thanks :-)
> 
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > - Eric
> 
> tpm2-sessions overall would need some refurbishing work now that also
> Matthew's hibernate patches depend on it. I have to take a serious
> look at it some point.

I'll apply this after Linus has accepted/rejected my TPM pull request.

I'm not sure if it already is but if it isn't, probably also at
linux-integrity turning on Sashiko would make sense.

Br, Jarkko

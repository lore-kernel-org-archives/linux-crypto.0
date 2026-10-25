Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792969882;
	b=ngxT/qjyewTqPX63S1UpvZ3A0sINshOb44Ii1yfyhSZYNyTSSmw0jcxQEj5Dk0FevJK3
	 s4cL9uvbdqED3ucOdc84B2DRB7ifUeXbcP7WsUrEC8t7/Xx3HbtO01KXLYs3lpGHUO8q6
	 mwoqk7MTw3SEi1yMjkbdcj5I19j0P/hq0tyd+MM0oWqYvyAFscxhIvDpDOf+ak1FGaYDV
	 KDeIzv/+kHCX3bX7W3lu7rRY55JNG96KCOpwr/hB/1zKmsPXFc9zOOqEH9zvTBL3YNiZ8
	 EHmv8xU5jgJgBsQjdEUrsP+ZrfoppcLVlfDo2d+DC7Sc+rNo9I93MD2R+E4mRsBkC3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792969882;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0mj2zpi7nl9gHfUwiUkIgugH9tcLboPqPYujRbCemh8=;
	b=04gtYOJAtkOtdcNhSLuylUNPb3aVPWs3z53PdTz0lOZ4/Vj4TEEaQOSoFNYlzTjpKeJy
	 KMUjpF2zDecpJBu/aetcgkRPBHwlypr/DmFpwVuSF5QS+2/x1+Sq0uzYkv/fHB3QCKwWH
	 /28Sv7xQ6yAiscs4iWnFysemQ1SLpAi+xUF2xhkQCPr8oi3s8ffVcwu/CdGFnT9A6i14X
	 1u/vRxQFqqse1rEp6rOZOLHYcXUlCA7E30e/gBY3K3Ll949wXh3JuzmX5kpcG9pCP3VkE
	 3yWE6JLuabZFOBwwH6h/9/W2c/R5f7J1GXrFZACqyoQbSe0LfyHPLzXsVx2IB8cU8Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vg+jdHAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B887E606A31A;
	Sun, 25 Oct 2026 23:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vg+jdHAW
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C81D21F01825;
	Sun, 25 Oct 2026 23:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792969881;
	bh=0mj2zpi7nl9gHfUwiUkIgugH9tcLboPqPYujRbCemh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vg+jdHAWMm6vROjT53RLVbAdfrAABddwxxUPPyaL2POhVJsXiXdKXuhgMohox0Ts7
	 TygZvhEDtMsorfUro/VNzflmVXI1Tt3EylVoR9k2KWgISKBbhcaZwWV8MLF9oNq5MN
	 v5jcu7BOhNt3IdCHACaoaYEU9bSF0PyLbU2PUQ37uUVJFm1UrPHJ+dqbaVJstDhadi
	 bPkmiW3JMOBxs3QmtezyjCaUnitvfQsIn7Q4mi/rWL0XAUGVc9HAEhah/JaO/m8IWd
	 PN0SLhEPkYHDwlQ4te7GkwXg98YLAdEXPp2hJ7c0lRrgtoqaRZH7wGIYwD8iVgv6yq
	 BYFZshtS7BgAg==
Date: Mon, 26 Oct 2026 01:11:17 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Check return value of crypto_kpp_set_secret()
Message-ID: <at6MlY1kpfa01tr4@kernel.org>
References: <20261025211119.138277-1-ebiggers@kernel.org>
 <at5-ve5Ap7Oyp1Fo@kernel.org>
 <20261025224723.GA148998@quark>
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
In-Reply-To: <20261025224723.GA148998@quark>

On Sun, Oct 25, 2026 at 03:47:23PM -0700, Eric Biggers wrote:
> On Mon, Oct 26, 2026 at 12:12:13AM +0200, Jarkko Sakkinen wrote:
> > On Sun, Oct 25, 2026 at 02:11:19PM -0700, Eric Biggers wrote:
> > > crypto_kpp_set_secret() can fail, for example if the kernel is booted
> > > with fips=1 and the broken-by-design FIPS RNG used for ECC private key
> > > generation doesn't feel like generating random bytes at the moment.
> > > Check for error, cancelling the TPM session creation rather than
> > > proceeding with a zero or uninitialized private key.
> > > 
> > > Fixes: 699e3efd6c64 ("tpm: Add HMAC session start and end functions")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > > ---
> > >  drivers/char/tpm/tpm2-sessions.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
> > > index ca1e2bf424e14..2aaaad69760dc 100644
> > > --- a/drivers/char/tpm/tpm2-sessions.c
> > > +++ b/drivers/char/tpm/tpm2-sessions.c
> > > @@ -527,7 +527,9 @@ static int tpm_buf_append_salt(struct tpm_buf *buf, struct tpm_chip *chip,
> > >  	}
> > >  	crypto_ecdh_encode_key(encoded_key, buf_len, &p);
> > >  	/* this generates a random private key */
> > 
> > Could you delete this comment while at it? It's not helping with
> > anything.
> > 
> > > -	crypto_kpp_set_secret(kpp, encoded_key, buf_len);
> > > +	rc = crypto_kpp_set_secret(kpp, encoded_key, buf_len);
> > > +	if (rc)
> > > +		goto err_free_kpp;
> > >  
> > >  	/* salt is now the public point of this private key */
> > >  	req = kpp_request_alloc(kpp, GFP_KERNEL);
> > > 
> 
> I actually think the comment is helpful, because of how unreadable the
> crypto_kpp API is.  It's generating a private key, but to request that,
> crypto_kpp apparently requires that an empty key be encoded into a byte
> string.  Then that key is "set", which actually generates a new key.
> 
> In comparison, the Curve25519 equivalent is
> curve25519_generate_secret(), which is clearly named and also always
> succeeds.  At some point we need to fix the ECDH API...

Ah, right it gets zero filled echd. I've not consciously thought this
detail before, thanks :-)

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> - Eric

tpm2-sessions overall would need some refurbishing work now that also
Matthew's hibernate patches depend on it. I have to take a serious
look at it some point.

Br, Jarkko

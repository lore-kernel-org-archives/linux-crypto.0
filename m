Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ABE17E8EF;
	Mon, 27 May 2024 22:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716848306; cv=none; b=YmGDaCSYfj/GZU3qQz5QMY4gH1p13ouu2iztyJ+KJpGCgpWPydYQ0HxkamwFO8w014MY8nSFmcrn+GHH+m1OLUuMm6KNk/PKB4iMbCTbd0EzNEFwPZs5mqAxsnNLWgmI1t6bVA9Ys8pRX56Py3LamtanzqfyYY4j41aZxGSGT5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716848306; c=relaxed/simple;
	bh=o1EUopSKyAUVhw1PeXaiwvfHyyxLj4NqXRQke6gSFAA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=sgrSmeB7gqXUmgKIV/mKaU6LqteYBxT2cy8n4vhTqCl54HtwnsW0e5lfJXhCK1QT+Zy4NDT80HFs4nl/MTsNOogv5C8v8Ea2ga+phKbc14zpu4rTAQSKen5niX1dIdndXwuoDaWG4W0QB1EB/pCjmIhcTYqGlYXsG2Mt8Oe85r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqClF0pw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqClF0pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DCBC2BBFC;
	Mon, 27 May 2024 22:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716848306;
	bh=o1EUopSKyAUVhw1PeXaiwvfHyyxLj4NqXRQke6gSFAA=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=oqClF0pwfy40TtMhLDTII3CiEnG50+pQntih2+fdVZaMvPlCcfz9oQbdOZRfgFDsR
	 eswe0QtPCuth8diiEyUeJvrdaPQggENvhjWikAyHLcCDW34XLjNkvfkmDdXvTPnte7
	 xDVgASiKXiSn26Q5/dYkx/67sp4jwnwcuqaFMPXEoGm0uSJ/sLixvkvfsDjtm/Mh1G
	 f6IhH0a8FImYHf8/BljCfWR8KlNGPGfrCqISyVFAkzRnLCW9s2lT4VN5mD87NbjsF1
	 DpdHgfUjNTYzf94Yd0lT76AftTwidEhw+tMs+EfGsWavYWk9Iwf4UoEWsHVDjOSvhY
	 ERIu1UFmjkHdw==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 May 2024 01:18:23 +0300
Message-Id: <D1KRXI87G4S0.1ROKTQENIZHT7@kernel.org>
Cc: <linux-crypto@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
 "Stefan Berger" <stefanb@linux.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ecdsa: Fix the public key format description
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>
X-Mailer: aerc 0.17.0
References: <20240527202840.4818-1-jarkko@kernel.org>
 <D1KQDPOZRWCW.1763CCYF1B84X@kernel.org>
 <D1KRILI1KRQ8.2CNPU7PFES0VI@kernel.org>
In-Reply-To: <D1KRILI1KRQ8.2CNPU7PFES0VI@kernel.org>

On Tue May 28, 2024 at 12:58 AM EEST, Jarkko Sakkinen wrote:
> On Tue May 28, 2024 at 12:05 AM EEST, Jarkko Sakkinen wrote:
> > On Mon May 27, 2024 at 11:28 PM EEST, Jarkko Sakkinen wrote:
> > > Public key blob is not just x and y concatenated. It follows RFC5480
> > > section 2.2. Address this by re-documenting the function with the
> > > correct description of the format.
> > >
> > > Link: https://datatracker.ietf.org/doc/html/rfc5480
> > > Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature=
 verification")
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > ---
> > > It is a bug fix that does not really need a stable backport. Still
> > > categorizes as a bug because by following the existing documentation
> > > you end up with an error code.
> > >  crypto/ecdsa.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
> > > index 258fffbf623d..55114146ff84 100644
> > > --- a/crypto/ecdsa.c
> > > +++ b/crypto/ecdsa.c
> > > @@ -215,9 +215,8 @@ static int ecdsa_ecc_ctx_reset(struct ecc_ctx *ct=
x)
> > >  }
> > > =20
> > >  /*
> > > - * Set the public key given the raw uncompressed key data from an X5=
09
> > > - * certificate. The key data contain the concatenated X and Y coordi=
nates of
> > > - * the public key.
> > > + * Set the public ECC key as defined by RFC5480 section 2.2 "Subject=
 Public
> > > + * Key". Only the uncompressed format is supported.
> > >   */
> > >  static int ecdsa_set_pub_key(struct crypto_akcipher *tfm, const void=
 *key, unsigned int keylen)
> > >  {
> >
> > Based on this, is this now along the lines of correct format":
> >
> >        *ptr++ =3D 0x04; /* uncompressed */
> >        ptr =3D asn1_encode_octet_string(&ptr[0], &in[sizeof(in)], &x[0]=
, x_size);
> >        ptr =3D asn1_encode_octet_string(&ptr[0], &in[sizeof(in)], &x[x_=
size + 2], x_size);
> >        in_len =3D ptr - in;
> >        ret =3D crypto_akcipher_set_pub_key(tfm, in, in_len);
>
>
> I fixed up the above as it should be only single octect string to this:
>
> 	ptr =3D &in[0];
>         *ptr++ =3D 0x04; /* uncompressed */
>         ptr =3D asn1_encode_octet_string(&ptr[0], &in[sizeof(in)],
>                                        &data[0], 2 * x_size);
>         in_len =3D ptr - in;
>         pr_info("in_len=3D%u\n", in_len);
>         ret =3D crypto_akcipher_set_pub_key(tfm, in, in_len);
>         crypto_free_akcipher(tfm);
>
> It fails in:
>
> 	ndigits =3D DIV_ROUND_UP(digitlen, sizeof(u64));
> 	if (ndigits !=3D ctx->curve->g.ndigits)
> 		return -EINVAL;
>
> I checked that in_len=3D67.
>
> The tfm is deleted at instant because the above code is part of *_query.
> TPM2 ECDSA asymmetric key that way that signature verification will work
> when it is needed. The key type signs with TPM and verifies with the
> software cipher.

3rd trial, i.e. no octect encoding at all but with the undocumented
(in the current mainline) prefix byte:

        ptr =3D &data[0];
        *ptr++ =3D 0x04; /* uncompressed */
        memcpy(&ptr[0], &x[0], x_size);
        memcpy(&ptr[x_size], &x[x_size + 2], x_size);
        ret =3D crypto_akcipher_set_pub_key(tfm, data, 3 * x_size + 1);
        crypto_free_akcipher(tfm);

I added also kprobe:

echo 'r:ecdsa ecdsa_set_pub_key $retval' >> /sys/kernel/tracing/kprobe_even=
ts
echo 1 > /sys/kernel/tracing/events/kprobes/enable
cat /sys/kernel/tracing/dynamic_events

Results:

ecdsa: (ecdsa_set_pub_key+0xc1/0xe0 <- ecc_is_pubkey_valid_full) arg1=3D0xf=
fffffea

So I guess this is on a right track reverse engineering the format used
in this API at least :-)

BR, Jarkko

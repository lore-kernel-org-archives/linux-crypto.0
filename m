Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7FC179A8;
	Mon, 27 May 2024 21:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716847138; cv=none; b=dcq6tLvXfNiBYxRu75Cp242DBiNAz6Z/k1HpdaLd8n2s/dRKLtvh3i+7M+qIZtcE0YLX41mtsHb774MAkEdbq+kxMEvlonLgHwnBLwx5ON8KiOyjBeMCeQCg92Rqtlb+Uyp5Ubv/aYvSnLWWYMjEI1ZDnURyIipj7+hk27mGlt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716847138; c=relaxed/simple;
	bh=27X3OpWXeYz+3UvmmbSLZOSMgK7993GPNRHShnJDtmM=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=Rf/96AMjEoXB6NehDT1qbAv7g+XW8SzHAxXoQ2lysJplawgcgrS4u6SmuAoHmAjOt0jC0hjnW2B8/3qtMtYSxsOSbQ8CEVt3JYVvvwXhXog+64tOm62aRPC9V3WzbPaYrFZzBGxxaMrWV51VL5TnPLJ4dsK3BPaKMJKv078HzAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lc7AvNri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lc7AvNri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06ECC32781;
	Mon, 27 May 2024 21:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716847138;
	bh=27X3OpWXeYz+3UvmmbSLZOSMgK7993GPNRHShnJDtmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lc7AvNriCWXUeeaK4Agj0Lff3GY0cqORFdpn522SmV+GYYxrWcPHMcjTCFJoTLS5V
	 chcUSdF8PN+B9XFfpShK9JuXtuM0WdFV1SPWXV0rqxFBxmGkh7WcWb6kEiRyNZDDPF
	 V3XfUCbiGkQkFtMLNUEK1IhPJ7C0YCU9jBIIfwgGjTcCurHx3tlL5lnSqPA8ikUo/p
	 JsvqKuAisIjgIUAtDF/DlFdig8orS8I5VYZaSq06NZL+ggOPbiIrHoUlXekxBX7Fts
	 DbswiVwyQs/OPEJGghUgf+x1b7xWDP+8m870tWn3Kt4yFuuKOUZqNpEMRm0n9CkMil
	 BZDVRdR3iO9rw==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 May 2024 00:58:54 +0300
Message-Id: <D1KRILI1KRQ8.2CNPU7PFES0VI@kernel.org>
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>
Cc: <linux-crypto@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
 "Stefan Berger" <stefanb@linux.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ecdsa: Fix the public key format description
X-Mailer: aerc 0.17.0
References: <20240527202840.4818-1-jarkko@kernel.org>
 <D1KQDPOZRWCW.1763CCYF1B84X@kernel.org>
In-Reply-To: <D1KQDPOZRWCW.1763CCYF1B84X@kernel.org>

On Tue May 28, 2024 at 12:05 AM EEST, Jarkko Sakkinen wrote:
> On Mon May 27, 2024 at 11:28 PM EEST, Jarkko Sakkinen wrote:
> > Public key blob is not just x and y concatenated. It follows RFC5480
> > section 2.2. Address this by re-documenting the function with the
> > correct description of the format.
> >
> > Link: https://datatracker.ietf.org/doc/html/rfc5480
> > Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature v=
erification")
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> > It is a bug fix that does not really need a stable backport. Still
> > categorizes as a bug because by following the existing documentation
> > you end up with an error code.
> >  crypto/ecdsa.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
> > index 258fffbf623d..55114146ff84 100644
> > --- a/crypto/ecdsa.c
> > +++ b/crypto/ecdsa.c
> > @@ -215,9 +215,8 @@ static int ecdsa_ecc_ctx_reset(struct ecc_ctx *ctx)
> >  }
> > =20
> >  /*
> > - * Set the public key given the raw uncompressed key data from an X509
> > - * certificate. The key data contain the concatenated X and Y coordina=
tes of
> > - * the public key.
> > + * Set the public ECC key as defined by RFC5480 section 2.2 "Subject P=
ublic
> > + * Key". Only the uncompressed format is supported.
> >   */
> >  static int ecdsa_set_pub_key(struct crypto_akcipher *tfm, const void *=
key, unsigned int keylen)
> >  {
>
> Based on this, is this now along the lines of correct format":
>
>        *ptr++ =3D 0x04; /* uncompressed */
>        ptr =3D asn1_encode_octet_string(&ptr[0], &in[sizeof(in)], &x[0], =
x_size);
>        ptr =3D asn1_encode_octet_string(&ptr[0], &in[sizeof(in)], &x[x_si=
ze + 2], x_size);
>        in_len =3D ptr - in;
>        ret =3D crypto_akcipher_set_pub_key(tfm, in, in_len);


I fixed up the above as it should be only single octect string to this:

	ptr =3D &in[0];
        *ptr++ =3D 0x04; /* uncompressed */
        ptr =3D asn1_encode_octet_string(&ptr[0], &in[sizeof(in)],
                                       &data[0], 2 * x_size);
        in_len =3D ptr - in;
        pr_info("in_len=3D%u\n", in_len);
        ret =3D crypto_akcipher_set_pub_key(tfm, in, in_len);
        crypto_free_akcipher(tfm);

It fails in:

	ndigits =3D DIV_ROUND_UP(digitlen, sizeof(u64));
	if (ndigits !=3D ctx->curve->g.ndigits)
		return -EINVAL;

I checked that in_len=3D67.

The tfm is deleted at instant because the above code is part of *_query.
TPM2 ECDSA asymmetric key that way that signature verification will work
when it is needed. The key type signs with TPM and verifies with the
software cipher.

BR, Jarkko

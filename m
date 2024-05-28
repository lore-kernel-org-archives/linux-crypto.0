Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D7316F267;
	Tue, 28 May 2024 13:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716902299; cv=none; b=Jg/62Nj2Ibvcva1FeDW+KUqzND2l1nfOJfmWITid5jHYXLaHhyAw1fNqafYv2x39VHzwaxFmKAnRgaYqSlIPmEaAEO0+b/AfK47nkEdt5OJ+njFZeunOmCKIRISuqD43FO7uwQishAEJB1PmsluVZr0zq9O5jJ2uS/i37WfyHHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716902299; c=relaxed/simple;
	bh=kQx5Fhui9sLzkibbMBYKjsbxRayzrXDKW6SH7ELKM40=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Bi6OeKif4QIoMv1Gztf/9Ek03F8KTm4BJThbPY5+wVYLDfYAKlTeWvd+tmCcyAXaFv1pGyS44v0O9rNrD+sViINDtiOkgF3zQ3xnjZBLNaWVw6gpR6k6+aA2UEtWbSdoU9fnVDKkF5Z0wP0oLAAQMWhUwHSIax19vpsitVuYXmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sLD8XQLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sLD8XQLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A99C3277B;
	Tue, 28 May 2024 13:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716902299;
	bh=kQx5Fhui9sLzkibbMBYKjsbxRayzrXDKW6SH7ELKM40=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=sLD8XQLBtZrI0+zoFHodU5TKsRwx13O66cO6vfKRqM3/+KspMM/tEx2SL18HYj7uw
	 hxqdt5g6APJKFkkcM9HdtH8I1OmtbLWGJtkdpgIrIuGSN87FoxKTbD1ex8Iuty8Ypu
	 EFUtg3Ce1neTuJqXFcRJZ7EAG3fGwRs7D2mvQ5QV4xYvkHPwrEjr2/fvtJVKpa4Dip
	 4ey7/zGvFu9nlu4YGmET3fghEpmU6g4I55nysXV9h68yf50IQexg2dNg5UD1/Y+wRp
	 q+mUXAiZzaf8i8Vh2fFQG0D2TtcUtb3ialt7wpBiBKcDke/4EqKfhwmlSDBo1WA0Cr
	 4LdLKeNUKmLJQ==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 May 2024 16:18:15 +0300
Message-Id: <D1LB2I56RGYG.MSKZ1944OXFB@kernel.org>
Cc: <linux-crypto@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ecdsa: Fix the public key format description
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Stefan Berger" <stefanb@linux.ibm.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>
X-Mailer: aerc 0.17.0
References: <20240527202840.4818-1-jarkko@kernel.org>
 <D1KQDPOZRWCW.1763CCYF1B84X@kernel.org>
 <D1KRILI1KRQ8.2CNPU7PFES0VI@kernel.org>
 <D1KRXI87G4S0.1ROKTQENIZHT7@kernel.org>
 <D1KS7LCALKD4.1J13QGYGZ6LBW@kernel.org>
 <D1KSLKGUWGFO.21T4OBXQQ88D@kernel.org>
 <D1KSSWD7FA94.5705Z3J7LKZA@kernel.org>
 <b5ff9003-065f-437f-bf6b-7f1ae0a0364a@linux.ibm.com>
In-Reply-To: <b5ff9003-065f-437f-bf6b-7f1ae0a0364a@linux.ibm.com>

On Tue May 28, 2024 at 3:37 PM EEST, Stefan Berger wrote:
>
>
> On 5/27/24 18:59, Jarkko Sakkinen wrote:
> > On Tue May 28, 2024 at 1:49 AM EEST, Jarkko Sakkinen wrote:
> >> On Tue May 28, 2024 at 1:31 AM EEST, Jarkko Sakkinen wrote:
> >>>>          ret =3D crypto_akcipher_set_pub_key(tfm, data, 3 * x_size +=
 1);
> >>
> >> Noticed this mistake i.e. fixed it with "2 * x_size + 1"
> >>
> >> This is results earlier failure:
> >>
> >> ecdsa: (tpm2_key_ecdsa_query+0x10d/0x170 <- ecdsa_set_pub_key) arg1=3D=
0xffffffea
> >>
> >> Totally lost with the expected input format after trying out various
> >> options.
> >=20
> > OK got it working with:
> >=20
> >          ptr =3D &data[0];
> >          *ptr++ =3D 0x04; /* uncompressed */
> >          memcpy(&ptr[0], &x[2], x_size);
> >          memcpy(&ptr[x_size], &x[2 + x_size + 2], x_size);
> >          ret =3D crypto_akcipher_set_pub_key(tfm, data, 2 * x_size + 1)=
;
> >          crypto_free_akcipher(tfm);
> >=20
> > Had still a few "off-bys".
> >=20
> > Makes me wonder why this is not in ASN.1.
> > E.g. TPM2 stuff and for instance RSA code takes ASN.1.
> >=20
> > This all and the required prefix byte really should be explained in
> > the documentation of this function. I.e. follows the RFC in the sense
> > that number is big-endian and has the prefix byte, but it does not
> > follow it in the sense that x and y are not in input octect strings.
> >=20
> > Why is that? Does not feel right intuitively.
>
> You found the appropriate documentation -- thanks.
> The old function documentation stated that it takes 'raw uncompressed=20
> key data from an x509 certificate'. So, one should take the data from=20
> the x509 certificate starting with 0x04 as shown here.
>
>          Subject Public Key Info:
>              Public Key Algorithm: id-ecPublicKey
>                  Public-Key: (256 bit)
>                  pub:
>                      04:c0:55:b4:68:7a:80:bc:0e:ba:b3:66:40:5f:07:
>                      aa:27:d4:da:b4:79:2e:4d:a4:f4:f4:33:b1:22:6a:
>                      6c:e9:8c:30:8d:6c:df:ac:65:f0:93:d9:7a:70:7a:
>                      05:dc:7a:7d:b3:91:18:22:9a:5c:86:9a:87:72:3b:
>                      32:1a:92:81:1d
>                  ASN1 OID: prime256v1
>                  NIST CURVE: P-256
>
>
> These are two concatenated x & y coordinates with a leading 0x4. The=20
> numbers are not ints in ASN.1 format but 'plain' integers.
>
> A *signature*, however, is in ASN.1:
>
>      Signature Value:
>          30:45:02:21:00:d9:d7:64:ba:5d:03:07:ee:20:a0:12:16:46:
>          31:e6:8e:66:0c:17:0d:74:07:87:58:5a:13:fc:14:62:98:9a:
>          99:02:20:59:ff:29:9c:52:b9:0a:35:3c:4b:03:bb:47:0e:c8:
>          3e:2d:cb:3e:1c:d3:51:88:91:b1:40:e3:03:86:1b:2a:e8
>
> 30:45 =3D> sequence containing 69 bytes
>    02:21: =3D> first coordinate with 0x21 bytes
>      00:d9 =3D> 0x21 bytes of ASN.1 integer with leading 0 to make the=20
> following 0x20-byte integer a positive number (its most significant bit=
=20
> is set).
>    02:20: =3D> int with 0x20 bytes
>     ...

Ah, thanks for this insight! I found this out by trial and error but
good to see that it matches with the "theory". Thank you.

BR, Jarkko

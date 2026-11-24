Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795522160;
	b=LhRFK47cbzRH3pKrF9mJCHN1HEVs8o1YG5upLZFWYRXn8fZAn8lAGjKDUuWb+1A+5u6d
	 tA8HcbqOEmlE+zAqSRPP0ti6thsq67GXsrb7FpiF1BLmuCgsXv10dl/KeDsUWC9F1aDlx
	 769uCax4C/J/HISocwG3K89kPeqWrQv0x7/6/xWb8zAjT2dv8FhWyaKLTcQogDkLVy6Zs
	 lh9L1YZRmKeKQP2ksLtOBg+jAVBbXoJbOBIAy1a77UVfX4c+CaUfdgBwWbKbVXzW3Dt8j
	 1dVGZoGLbWGEQl2dVN2esXlsekHLckCqHzHml0qeBEfUmBHzG8pqj5i3/d9JDUAMNbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795522160;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JkwzHwAiyLcAfQEMgbF2n6uo+MvubUF3zejyJJrt1NQ=;
	b=rvLh9taIN7rreondCQ9uLMSR4kM7y8rCf469vpfro1Zagn25WEt3RYWiIZrstbcjGEhW
	 Xnsitf5S7DwFNv3LU2CtZQXJ3XOcV4CGCkuiMObVYPYp1Uvu4+UsLGvVviyOkSuKX8COD
	 F/3rLACW1j4Vc4vhFZ49aW9ex8Fz2/7niRmS59XfFkB+wXiIoF8KapHvH/qaOOXN0jK+o
	 6VOqMDE3K01T7ZKVNGf+8HXoOO+7HXzIP0G4cqZMmsLCGG28KIQPIurA6pFRsv+fEgkdd
	 mV+oKrtl+leL+pqGB/NNucgURc7ePqToVfw3FfkBfhyK/NvcQd3cITwt/wT3ioETemg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oc73Sxwh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95328606A31E;
	Tue, 24 Nov 2026 12:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oc73Sxwh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCF91F000CF;
	Tue, 24 Nov 2026 12:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795522159;
	bh=JkwzHwAiyLcAfQEMgbF2n6uo+MvubUF3zejyJJrt1NQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Oc73Sxwh4kQb2F91bkT+ljU6EOPoDPex7LjOekxrrkCPk5Gz2mRFb5+jS15T0nPS5
	 eR3S0eZyj9Fxy3CF6Vtt9bSeD76iVL9Aok+V80PM2nxf+T8YYtuWE/Fn5t72KN31wZ
	 Le9iQKqSHvWoaoNM+xNug/qBHEt3+E5yp5aGkDfQntFuVhvG945Wntp2lX1qxIKjR3
	 q8BEfwDiVGJxEAOqmMbSDvP16rg8nh+ckuhWB5/LyDYA+pIKCOm7E9sPsoHvZ9ZHUF
	 ackyR2iNPwG+OvGgIEBl03EoLcZEE93kolxpPYgdL5VT/rsbufzuP2//qtbr+IvIum
	 C0SZj6RxT4raA==
Message-ID: <sashiko-outbox-231100@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/9] lib/asn1_encoder: Add asn1_encode_integer_bytes()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>, keyrings@vger.kernel.org
Cc: dm-devel@lists.linux.dev, linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org, "Alasdair
 Kergon" <agk@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "David Howells" <dhowells@redhat.com>, "David
 S. Miller" <davem@davemloft.net>, "David Woodhouse" <dwmw2@infradead.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Ignat Korchagin" <ignat@linux.win>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "James Morris" <jmorris@namei.org>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Jonathan Corbet" <corbet@lwn.net>, "Lukas
 Wunner" <lukas@wunner.de>, "Mike Snitzer" <snitzer@kernel.org>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Mimi Zohar" <zohar@linux.ibm.com>, "Paul
 Moore" <paul@paul-moore.com>, "Peter Huewe" <peterhuewe@gmx.de>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>
In-Reply-To: <20261124120044.1481752-3-jarkko@kernel.org>
References: <20261124120044.1481752-1-jarkko@kernel.org>
 <20261124120044.1481752-3-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 12:09:18 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] lib/asn1_encoder: unreachable !bytes_len branch in
  asn1_encode_integer_bytes()
--

commit 881f7930374a268f10571bcbb28c0f38ce090851
Author: Jarkko Sakkinen <jarkko@kernel.org>

lib/asn1_encoder: Add asn1_encode_integer_bytes()

This commit adds asn1_encode_integer_bytes() to encode a positive integer
from a big-endian byte array into ASN.1 format while stripping leading
zeros.

> diff --git a/lib/asn1_encoder.c b/lib/asn1_encoder.c
> index 92f35aae13b13..22e0acd6fe08d 100644
> --- a/lib/asn1_encoder.c
> +++ b/lib/asn1_encoder.c

[ ... ]

> @@ -85,6 +87,66 @@ asn1_encode_integer(unsigned char *data, const unsigne=
d char *end_data,
>  }
>  EXPORT_SYMBOL_GPL(asn1_encode_integer);
> =20
> +/**
> + * asn1_encode_integer_bytes() - encode positive integer bytes to ASN.1
> + * @data:		pointer to the pointer to the data
> + * @end_data:		end of data pointer, points one beyond last usable byte i=
n @data
> + * @bytes:		integer bytes
> + * @bytes_len:		amount of bytes
> + *
> + * Encode a positive integer from a byte array in big-endian format. Str=
ip
> + * leading zeros.
> + */
> +unsigned char *
> +asn1_encode_integer_bytes(unsigned char *data, const unsigned char *end_=
data,
> +			  const unsigned char *bytes, u32 bytes_len)
> +{
> +	static const unsigned char zero;
> +	int data_len =3D end_data - data;
> +	bool add_pad =3D false;
> +	int ret;
> +
> +	if (IS_ERR(data))
> +		return data;
> +
> +	if (!bytes || !bytes_len)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Strip leading zeros: */
> +	while (bytes_len > 1 && bytes[0] =3D=3D 0) {
> +		bytes++;
> +		bytes_len--;
> +	}
> +
> +	if (!bytes_len) {
> +		bytes =3D &zero;
> +		bytes_len =3D 1;
> +	} else {
> +		add_pad =3D bytes[0] & 0x80;
> +	}

[Severity: Low]
Is the !bytes_len branch and static zero variable reachable here?

The function returns ERR_PTR(-EINVAL) on entry when bytes_len is 0, and
the while loop stops decrementing once bytes_len reaches 1, so bytes_len
is always at least 1 after the loop.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124120044.1481=
752-1-jarkko@kernel.org?part=3D2

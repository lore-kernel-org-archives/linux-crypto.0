Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794481220;
	b=l5NkKSIqsBfMcuXnGBJCDiIc92e6eR/oRFR8DSSncYxBVTnUa8cxeKGQDFMYGeLFw9/X
	 rYizAHNbATZjdmbHS61aY4FSUfT66nxtsU43KKXD2Guch/Cp3GVtb1JLuXIe6a3b+MBR4
	 ujF0aqkJxYk9pi++WPuGq+JuM/qbPxhk3RYF3FbXPdVeWV3frA897q+jHWXv8L/Z1MPsH
	 x+CWcEb5eOULuGoSbvP110ocACCxdcWJAa+a5DsyX6Xi/6RyZUe6Wa/Sok/F+Z852qka5
	 wOPlb4prZYCx46+XWoraSpvPeT7nrfgSbXM4celuM+Jbe7bEKvHUpY/M8lr55STVETQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794481220;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ji73FbGWrdaMviN2yljUtW8HkBEVveCjduuH/AySRBw=;
	b=x5dO9jLOA4lfxnER2l7VOU23gMF+KUAcQvJkGpesan+u4wbgEFDR7rg+g8CZq7r0HRVz
	 QTWIEWsFf6eKQtQMEOGD0yl3YBHaPDsHAPnpRnxrt7ugs1Hh3Vf6FIWnP6qVRGC8cv3By
	 FivaIMKEt7Ws/vlkdgmZ40HvmxhiV6zJtmGaRXJtwu/bvDE7rSUxXkrX+2o2MW7lVTbB1
	 eRdjYVaG0/e9E2pz3jEFEF0docKDj9jeKbLkdHBKngxGhLeJSf19akKtOTcODjPw8RJCQ
	 9GnzQ8gFHOakdRC5YwWvZXQ0LCE5bvJDXa4osa1r+0aw5f6T2s+ZSMx+mrrJFB5js3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="eB/oB02a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B0F606A321;
	Thu, 12 Nov 2026 11:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eB/oB02a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AAD1F00A05;
	Thu, 12 Nov 2026 11:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794481219;
	bh=Ji73FbGWrdaMviN2yljUtW8HkBEVveCjduuH/AySRBw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eB/oB02atLGi6Z1dPMiOSd78bKpNvo9PnonbLmcNYBhMV2mbIgJgDTESUpyJySRyt
	 Ej9BMJgd7RgZN3L+9Tq7Agj2xwPdLCYEN5jv0Ldsw9Vz9ieIqwPabvINbHwkca6trl
	 dtLCLxz47SS+j2BvoBeAv+9K4B20x4MNL+Ze3ZPNRBpFRFZ5AmA9xfErYEF5AslOAh
	 3NiJ9+Wc3Jas5qeKmXi7zKUIC9TixJm94jRXksNRy2h+Tzc3bD/Yigx//XlCtV3Sm/
	 T21MSeE6qu0zn+7cjDwUh46tyEqpD8LjvjCg5x1HaDkyxSedp1IyiUJvN/kAGhEQEs
	 3gfO5oFWcXlWw==
Message-ID: <sashiko-outbox-210983@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: ecdsa - Reject non-DER X9.62 signatures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Florian Bauckholt" <florian.bauckholt@cispa.de>, "Lukas Wunner" <lukas@wunner.de>, "Ignat
 Korchagin" <ignat@linux.win>, "Stefan Berger" <stefanb@linux.ibm.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
In-Reply-To: <20261112-ecdsa-x962-der-v1-1-36b24c5f5e11@cispa.de>
References: <20261112-ecdsa-x962-der-v1-1-36b24c5f5e11@cispa.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 11:00:18 +0000
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
- [High] crypto: ecdsa - keyctl_pkey_params_get_2() breaks
  ecdsa_x962_verify()
--

commit 507f70b0a1dc8642ced214dd9427e506b434b4b9
Author: Florian Bauckholt <florian.bauckholt@cispa.de>

crypto: ecdsa - Reject non-DER X9.62 signatures

This commit enforces strict DER encoding for X9.62 ECDSA signatures by
validating the INTEGER and SEQUENCE headers and rejecting trailing bytes,
along with adding Wycheproof test vectors for invalid BER encodings.

> diff --git a/crypto/ecdsa-x962.c b/crypto/ecdsa-x962.c
> index ee71594d10a06..69e932bbd5511 100644
> --- a/crypto/ecdsa-x962.c
> +++ b/crypto/ecdsa-x962.c
[ ... ]
> @@ -73,6 +88,24 @@ int ecdsa_get_signature_s(void *context, size_t hdrlen=
, unsigned char tag,
>  				      sig_ctx->ndigits);
>  }
> =20
> +/*
> + * The BER decoder accepts a SEQUENCE tag without the constructed bit,
> + * long-form and indefinite lengths, and ignores data following the SEQU=
ENCE.
> + * DER permits only the constructed tag, the shortest length encoding and
> + * nothing after the SEQUENCE.  The decoder has already checked that r a=
nd s
> + * fill a definite-length SEQUENCE exactly.
> + */
> +static bool ecdsa_x962_seq_is_der(const u8 *src, unsigned int slen)
> +{
> +	if (src[0] !=3D (ASN1_CONS_BIT | ASN1_SEQ))
> +		return false;
> +
> +	if (src[1] < 0x80)
> +		return slen =3D=3D 2 + src[1];
> +
> +	return src[1] =3D=3D 0x81 && src[2] >=3D 0x80 && slen =3D=3D 3 + src[2];
> +}
> +
>  static int ecdsa_x962_verify(struct crypto_sig *tfm,
>  			     const void *src, unsigned int slen,
>  			     const void *digest, unsigned int dlen)
> @@ -88,6 +121,9 @@ static int ecdsa_x962_verify(struct crypto_sig *tfm,
>  	if (err < 0)
>  		return err;
> =20
> +	if (!ecdsa_x962_seq_is_der(src, slen))
> +		return -EINVAL;

[Severity: High]
Does requiring slen to match the exact DER SEQUENCE length break
keyctl(KEYCTL_PKEY_VERIFY) for valid X9.62 signatures in this tree?

In struct kernel_pkey_params, out_len and in2_len share an anonymous union.
Since commit cb481e59ea6c ("KEYS: fix overflow in
keyctl_pkey_params_get_2()"), keyctl_pkey_params_get_2() overwrites
params->in2_len with info.max_sig_size:

security/keys/keyctl_pkey.c:keyctl_pkey_params_get_2() {
    ...
	case KEYCTL_PKEY_VERIFY:
		if (uparams.in_len  > info.max_data_size ||
		    uparams.in2_len > info.max_sig_size)
			return -EINVAL;

		params->out_len =3D info.max_sig_size;
		break;
    ...
}

keyctl_pkey_verify() -> asymmetric_key_verify_signature() then passes
info.max_sig_size as slen to ecdsa_x962_verify().  As noted in the patch
commentary, until the separate keyctl fix is applied in this tree, any
valid DER-encoded X9.62 signature shorter than max_sig_size (for example, a
70- or 71-byte NIST P-256 signature where max_sig_size is 72) fails the
slen check in ecdsa_x962_seq_is_der() with -EINVAL.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-ecdsa-x962=
-der-v1-1-36b24c5f5e11@cispa.de?part=3D1

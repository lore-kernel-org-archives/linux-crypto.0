Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523148;
	b=0MOXEym76qN9X9QW37f2oES+fz/l1KZExKzL9TAT9RZcIKR/JM95QbToT7F01kjH74vJ
	 VzHDjYsEjgdkY5xi/10tGHJG1zwtEHScgdH8rol8fisjeJATi5jcxBtAUYyGL+rOvItY5
	 Hd66vAXL14tbr/FTcBdhFx2a1w9ftelkaEDXOYBq3zffOJVeckSnNQbrIdRtghXZDFdff
	 ksgV1NL+IWHLYjz5Z5Y5uN608HRsQqSqTNYSlNEngSMo/4jxgSRMai1c6TCZMUVwy/okf
	 CviOP52Q4+cgvzeu2oI7tJ8IlllhOBVlDzoueanA4MbFhiZ52Qn/sdlhWsLfjxXTWOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523148;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tSOYltX4QNcDiHz2028+EWsSXO1m1H4x04+sAWIROUA=;
	b=xaqrxVuAjY6Wr2/emevxKZTgMDe5eo6pDC+XpeGo8p2MQVohNAvqvtZ+xUz4Fc7xkSkw
	 QLWroPRHHNJjo0EOvta6Zdjxv3FgoCmQIFIncEvmqsrVX/VRuYzh25YEcuVuD9Wn/gnZd
	 s4Ix0zXzv7hlldwtmcw60rIl/3NT97bYiaambAtLUVXhA2qcnu7g3G9Qsq4CyI4YSK9Ip
	 Rn9gMS4mvKsugkCuup1oknO/nfS/zYgkKv6KN++JBy8jWiOV8YebY1Fwv5MUJyDYcMB/w
	 pC3hmgsBFFkHf5hNiAh97MGnTwA2lUv22bIs0pN9IoCslu/F7r4VzZ4nm3p3HSJSzSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="TuE2+Z/s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB230606A31E;
	Tue, 24 Nov 2026 12:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TuE2+Z/s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681C61F000CF;
	Tue, 24 Nov 2026 12:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795523146;
	bh=tSOYltX4QNcDiHz2028+EWsSXO1m1H4x04+sAWIROUA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TuE2+Z/sAuCcbGgFz2/FokuqyaInILB38mxwMPHz3ZjlbD7I41q/exTjGfnoLMzMd
	 tCAU+oUX59GQNY64kNMdzilR/OgvpDxlEFnEX2TljN0M9cR7/T0bUCuJV0khwcAChn
	 llEGFk2P3QpYZJ/qso0ODdgLpX6QzaHJsSDE8xejHQ/PKDNrfLCy1+lXc6YpWqki/a
	 jTt1FWsIEXHfnz11LCETEMxherMh0UK1wg6RxLoX72LvydFC+NpJbtWipU1aAdMGCW
	 FDwf/EBlfIg7Icz3Gpuo5atIXmCd1jGyTNzE7ydgHRnw6lTEGOM0WnbBr0GQiGwyFh
	 1L4ID8cGA1mlQ==
Message-ID: <sashiko-outbox-231131@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 9/9] KEYS: trusted: Add asymmetric key support for TPM2
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
 Khan" <skhan@linuxfoundation.org>, "James Prestwood" <prestwoj@gmail.com>
In-Reply-To: <20261124120044.1481752-10-jarkko@kernel.org>
References: <20261124120044.1481752-1-jarkko@kernel.org>
 <20261124120044.1481752-10-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 12:25:44 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] KEYS: trusted: 32-bit param_size overflow in
  tpm2_asym_rsa_decrypt()
- [Low] KEYS: trusted: blob_len mismatch in tpm2_load_cmd() and
  tpm2_asym_load()
--

commit 9a2d1dec7eb8e2fb4164f93f474ab53d2345c7be
Author: Jarkko Sakkinen <jarkko@kernel.org>

KEYS: trusted: Add asymmetric key support for TPM2

This commit extends the TPM 2.0 trusted key backend to load
OID_TPMLoadableKey RSA and ECC keys and expose query, sign, verify, and
RSA encrypt/decrypt operations through key_type_trusted.

> diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/tr=
usted-keys/trusted_tpm2.c
> index e3cd02e19857e..e4731724908a7 100644
> --- a/security/keys/trusted-keys/trusted_tpm2.c
> +++ b/security/keys/trusted-keys/trusted_tpm2.c
[ ... ]
> @@ -750,10 +987,799 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
>  	if (rc)
>  		goto out;
> =20
> -	rc =3D tpm2_unseal_cmd(chip, payload, options, blob_handle);
> +	if (!private->alg_type)
> +		rc =3D tpm2_unseal_cmd(chip, payload, options, blob_handle);
>  	tpm2_flush_context(chip, blob_handle);
> =20
>  out:
>  	tpm_put_ops(chip);
>  	return tpm_ret_to_err(rc);
>  }
> +
> +#ifdef CONFIG_TRUSTED_KEYS_ASYMMETRIC
> +static int tpm2_asym_load(struct tpm_chip *chip,
> +			  const struct trusted_key_payload *payload,
> +			  struct trusted_key_tpm *private,
> +			  u32 *key_handle)
> +{
> +	u8 *blob __free(kfree) =3D NULL;
> +	unsigned int blob_len;
> +	int rc;
> +
> +	rc =3D tpm2_key_decode(payload, private, NULL, &blob, &blob_len, NULL);
> +	if (rc)
> +		return rc;
> +
> +	return tpm2_load_blob(chip, private, blob, blob_len, key_handle);
> +}

[Severity: Low]
Can tpm2_asym_load() pass a different blob_len to tpm2_load_blob() than
tpm2_load_cmd() did when the key was instantiated?

In tpm2_load_cmd(), blob_len is clamped to private_len + public_len + 4,
which strips any trailing bytes in the ASN.1 OCTET STRINGs before loading.
tpm2_asym_load() passes the untruncated ctx.priv_len + ctx.pub_len from
tpm2_key_decode() directly to tpm2_load_blob(), so a key with trailing
bytes will load during add_key() but fail on subsequent pkey operations.

[ ... ]

> +static int tpm2_asym_rsa_decrypt(struct tpm_chip *chip,
> +				 const struct trusted_key_payload *payload,
> +				 struct trusted_key_tpm *private,
> +				 struct kernel_pkey_params *params,
> +				 const void *in, void *out)
> +{
[ ... ]
> +	offset =3D TPM_HEADER_SIZE;
> +	param_size =3D tpm_buf_read_u32(buf, &offset);
> +	decrypted_len =3D tpm_buf_read_u16(buf, &offset);
> +	if ((buf->flags & TPM_BUF_INVALID) ||
> +	    param_size < 2 + decrypted_len ||
> +	    offset - 2 + param_size > buf->length) {
> +		rc =3D -EIO;
> +		goto out_key;
> +	}
> +	if (params->out_len < decrypted_len) {
> +		rc =3D -EMSGSIZE;
> +		goto out_key;
> +	}
> +
> +	memcpy(out, &buf->data[offset], decrypted_len);

[Severity: Medium]
Can offset - 2 + param_size wrap around on 32-bit architectures?

When off_t is 32-bit, a malformed unauthenticated TPM response with
param_size >=3D 0xfffffff2 wraps offset - 2 + param_size past buf->length
while satisfying param_size >=3D 2 + decrypted_len, allowing memcpy() to
read up to decrypted_len bytes past buf->length from buf->data.  The same
32-bit overflow can occur in tpm2_asym_parse_signature() at
offset + param_size > buf->length.  Checking
param_size > buf->length - (offset - 2) and
param_size > buf->length - offset avoids the wraparound.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124120044.1481=
752-1-jarkko@kernel.org?part=3D9

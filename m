Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630586;
	b=2b5IWSe6amoCGunvUYPvwzUa9GcoUFGbgQJo6C7XxN2bzS0Qc4nno4CwW6Uz2VquBgD3
	 jsPkuO8mCB7CPk5yiL42q6kjieoM0NozN8lHWRd+zNi6mThwCgNXSpVTgEApSNkFqBy+W
	 3Slie4nfsPlwD3lut1gF4EJKlMPdZvZ/qXet5OuzAIs+xzGkzpttzj+wTHG2XdFnerx0d
	 r2w+Z4PJczAt1W+YXIXkqzHftQmzBEew3vIYwuBwAuhxBR1Q8Qg8qtN9AlzJ8z7PmwCAF
	 72z0TmAWYV4Er+1VNtwLeZEVKhvzDP9GWBFxCmJuWOl/1p665DkkgKI7QrYOxHcCNZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630586;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ItE++LU8TqRI5uK7Gs6LAsm2atS10aLNL14Kugvc9Uw=;
	b=h4kgIOA7rL4z2pA1i+onQQzk3u+wfEvHmH8XBZ3ZALydxZF0DSIsL9qPh0MV2QR6qa/c
	 TOHBjG1eADEg9qBXrEJHRX7f4Xm7lZ2eQ8UUCkbu2fnFLmv+hmglmEO5cbYBeeWPig5XI
	 +PBq88K0o7nnWGKVZPTPAuBuQU43+NA7y4o5oil3lYIs0PI79E6zP1B5mrY7r5Jv2hok2
	 Bgl/T96rrZfYC/7l+dtS7vlHhXozr7sPT0hK1xZ3shPkAwekCEUzkwJSc49snNrvDzz/r
	 OdvyyTRUDC5rYR0/oZBCFWKzoLG9FrtTYex6tZNjJvkO32fEuAfq3aweRLQy40oWOHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nJ6Bjuz3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D5E606A337;
	Wed, 25 Nov 2026 18:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nJ6Bjuz3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F90A1F000C0;
	Wed, 25 Nov 2026 18:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795630585;
	bh=ItE++LU8TqRI5uK7Gs6LAsm2atS10aLNL14Kugvc9Uw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nJ6Bjuz3fmmoHjdiLDCMLyP1UOstkuqTbgO8ivNdvSKr9k78qx2vRf0hA05DS70jk
	 p9RzNOIg3GbFM8BFfZLo1xur4Zu+1ho9gIfDHjEDvX4aBVPTLVWnCn3HETEDHRUrYA
	 I6fxzfOrOWKy5IjbJxpmELKaYW/50kVHCDqOryiVLF5gGXyQ2amixbI2HWMOSuUx5q
	 oOwhayZFSAsplJHdEF2/NuVZpN4ClFX3GjWSMQzs5tPeOKrvBlDiSVEcDccg+bIz8z
	 L+chIqaYI0ceCWqH0B4X9HAlyTH1GI/NjcYpEutzTYVCBJrxch10D3P//R+VaY5+bW
	 1ifNxyL9uus0w==
Message-ID: <sashiko-outbox-233944@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 8/9] KEYS: trusted: Factor out TPM2 blob loading
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>, keyrings@vger.kernel.org
Cc: dm-devel@lists.linux.dev, linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org, "Ahmad
 Fatoum" <a.fatoum@pengutronix.de>, "Alasdair Kergon" <agk@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Benjamin Marzinski" <bmarzins@redhat.com>, "David
 Gstir" <david@sigma-star.at>, "David Howells" <dhowells@redhat.com>, "David
 Laight" <david.laight.linux@gmail.com>, "David S. Miller" <davem@davemloft.net>, "David
 Woodhouse" <dwmw2@infradead.org>, "Eric Biggers" <ebiggers@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Ignat Korchagin" <ignat@linux.win>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "James Morris" <jmorris@namei.org>, "James
 Prestwood" <prestwoj@gmail.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Jonathan
 Corbet" <corbet@lwn.net>, "Lukas Wunner" <lukas@wunner.de>, "Mike Snitzer" <snitzer@kernel.org>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Mimi Zohar" <zohar@linux.ibm.com>, "Paul
 Moore" <paul@paul-moore.com>, "Peter Huewe" <peterhuewe@gmx.de>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Sumit Garg" <sumit.garg@kernel.org>
In-Reply-To: <20261125180616.1854753-9-jarkko@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
 <20261125180616.1854753-9-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 18:16:23 +0000
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
- [Low] KEYS: trusted: changelog omits payload->private and
  tpm2_load_cmd() check
--

commit 94f02a37d277c89d23fb05c1b5c6ea51d598832f
Author: Jarkko Sakkinen <jarkko@kernel.org>

> KEYS: trusted: Factor out TPM2 blob loading
>
> Factor out TPM2 blob loading:
>
> 1. tpm2_key_decode() from trusted_key_options.
> 2. tpm2_load_blob() and tpm2_buf_append_key_auth() from tpm2_load_cmd()
>    and tpm2_unseal_cmd().
>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

> diff --git a/include/keys/trusted-type.h b/include/keys/trusted-type.h
> index 3db61b57cf73d..790ffabb0d184 100644
> --- a/include/keys/trusted-type.h
> +++ b/include/keys/trusted-type.h
> @@ -33,6 +33,7 @@ struct trusted_key_payload {
>  	unsigned int blob_len;
>  	unsigned char migratable;
>  	unsigned char old_format;
> +	void *private;
>  	unsigned char key[MAX_KEY_SIZE + 1];
>  	unsigned char blob[MAX_BLOB_SIZE];
>  };
> diff --git a/security/keys/trusted-keys/trusted_core.c b/security/keys/tr=
usted-keys/trusted_core.c
> index 3721980ed83af..b8f980da606d1 100644
> --- a/security/keys/trusted-keys/trusted_core.c
> +++ b/security/keys/trusted-keys/trusted_core.c
> @@ -149,6 +149,14 @@ static struct trusted_key_payload *trusted_payload_a=
lloc(struct key *key)
>  	return p;
>  }
> =20
> +static void trusted_payload_free(struct trusted_key_payload *p)
> +{
> +	if (!p)
> +		return;
> +	kfree_sensitive(p->private);
> +	kfree_sensitive(p);
> +}
> +

[ ... ]

> diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/tr=
usted-keys/trusted_tpm2.c
> index 0a81608844ff6..231062fd17b6b 100644
> --- a/security/keys/trusted-keys/trusted_tpm2.c
> +++ b/security/keys/trusted-keys/trusted_tpm2.c

[ ... ]

> @@ -527,6 +595,9 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
>  	if (private_len + 2 + public_len + 2 > blob_len)
>  		return -E2BIG;
> =20
> +	if (public_len < 8)
> +		return -EINVAL;
> +
>  	pub =3D blob + 2 + private_len + 2;
>  	/* key attributes are always at offset 4 */
>  	attrs =3D get_unaligned_be32(pub + 4);

[Severity: Low]
This isn't a bug, but the commit message only mentions factoring out
tpm2_key_decode(), tpm2_load_blob(), and tpm2_buf_append_key_auth(),
without explaining why this refactoring is needed (to prepare for
asymmetric key support in the following patch).  It also omits adding
payload->private and trusted_payload_free() in the core trusted keys code,
as well as the new public_len < 8 bounds check before reading pub + 4 in
tpm2_load_cmd().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125180616.1854=
753-1-jarkko@kernel.org?part=3D8

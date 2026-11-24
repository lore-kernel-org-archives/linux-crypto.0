Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795522547;
	b=ykEpdSAYxbWxu01JijkwbiVo4QIOsXCB0vjDGsEXz9l883ZYGZo5Irc0X85jdWgsG2A7
	 xGGdTpR0PlS+RK40KNnFjh1Iy9osV3P6NFVfQex+GmDy0Q/c4JPdSmn6/FKsy/FgXmqG2
	 LufUchcD1QLXq3IK2HdalZ2iRkIjqkuw/hr8WraP5lXW5jtIB3+meL6gi9IjSvA953p9w
	 0n8Df+18W+KWee0pLZGDvm49bI+VBQ6fCXF9/hoWMIWHqPhcosNxmZCXKeX2B9zxlZCLN
	 vPGNOGjZNNqvp1Rk62KuAdyBoeuk23puenVy4ceA4UKlS6dL6g1W1yznkYdelmQ6EhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795522547;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hyvXtY0R5WjT4lGU5lwKY3+6qkEL16KysklWv0aRcVg=;
	b=Rpu4carEvngqcrG/bexUSEbr0znbyokLBDs8v5y6qP9S2Is9n1Pb5JeYAVBprbZH/KzR
	 wP04xZTNTQbV4DxpRM//orxOwmEEmlqD1BskDjb5blzx75tiZ4kIQFmP6FuRtRyB9Jp5D
	 qxx9ZTnAVBxSLmasy7e7iZ4jrx0KzKzhiYjoxWiGu+KXloGcyT/c88F556Rt+xGaphnYJ
	 YscRcq7IUYepKBTNHzAKt3bzx13aTCVtJ/KD0KlteRDGZCJ4tUO4apb3v4kzEqzG/Vm0C
	 I8E5VFen8vB/aCFMfXNz7tSV+q0Ml7wtKFIAqnZsqyaIziKpoBfLu7/DXAriN+P7IYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XsqaDW8j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE349606A322;
	Tue, 24 Nov 2026 12:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XsqaDW8j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A741F000D0;
	Tue, 24 Nov 2026 12:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795522547;
	bh=hyvXtY0R5WjT4lGU5lwKY3+6qkEL16KysklWv0aRcVg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XsqaDW8jRuAmflmHxIIdh4syx+OsVQg1s4KPCQyMtpgrXLk7dNGYP+4KScaIDUQvM
	 KpEapFtUDMDh8YOwLkO45d9gSsWst23EGqZgWSP9ZVFBE9WCuJQkOvQci/fnrVZsu7
	 mOEFmSURk3IH6H8cIMvqtiAK22FLWtANsFBjt2/Q5l2cDXRA9KLqZKdq4zKVsWQDMY
	 eGFv4lM6oshtADv4QA8NtqP0SVWk5jGrf4D15S18bp1PVsJJCFwo6C+jIr5NXTuubJ
	 1XzEEh1/DfwTVUAbq3jrJRQ5CCsQGME6oNDd3HCyu8TpPctxJmrE/tjsU8Zk9zGTk5
	 n/Z3IO7ShF9hA==
Message-ID: <sashiko-outbox-231115@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/9] tpm: Add persistent hierarchies to
 tpm2_create_primary()
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
In-Reply-To: <20261124120044.1481752-5-jarkko@kernel.org>
References: <20261124120044.1481752-1-jarkko@kernel.org>
 <20261124120044.1481752-5-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 12:15:46 +0000
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
- [Medium] tpm: OOB read and premature state mutation in
  tpm2_parse_create_primary()
--

commit 92830ac1679c3da842e2672d38ef677266816bbc
Author: Jarkko Sakkinen <jarkko@kernel.org>

tpm: Add persistent hierarchies to tpm2_create_primary()

This commit updates tpm2_parse_create_primary() to only populate
chip->null_ec_key_x and chip->null_ec_key_y when the hierarchy is
TPM2_RH_NULL, verifies the returned key name against the locally computed
TPMT_PUBLIC digest, and flushes the transient handle on validation failure.

> diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-ses=
sions.c
> index b3b4f7a89d9d3..98f668874c3e2 100644
> --- a/drivers/char/tpm/tpm2-sessions.c
> +++ b/drivers/char/tpm/tpm2-sessions.c
[ ... ]
> @@ -1170,85 +1170,87 @@ static int tpm2_parse_create_primary(struct tpm_c=
hip *chip, struct tpm_buf *buf,
>  	param_len +=3D TPM_HEADER_SIZE;
> =20
>  	if (param_len + 8 > total_len)
> -		return -EINVAL;
> +		goto err;
>  	len =3D tpm_buf_read_u16(buf, &offset_r);
>  	offset_t =3D offset_r;
>  	if (offset_r + len > tpm_buf_length(buf))
> -		return -EINVAL;
> -	if (name) {
> -		/*
> -		 * now we have the public area, compute the name of
> -		 * the object
> -		 */
> -		put_unaligned_be16(TPM_ALG_SHA256, name);
> -		sha256(&buf->data[offset_r], len, name + 2);
> -	}
> +		goto err;
> +
> +	/*
> +	 * Now we have the public area, compute the name of the object.
> +	 */
> +	put_unaligned_be16(TPM_ALG_SHA256, resp_name);
> +	sha256(&buf->data[offset_r], len, resp_name + 2);
> +	if (name)
> +		memcpy(name, resp_name, sizeof(resp_name));
[ ... ]
>  	/* extract public key (x and y points) */
>  	val =3D tpm_buf_read_u16(buf, &offset_t);
>  	if (val !=3D EC_PT_SZ)
> -		return -EINVAL;
> +		goto err;
>  #ifdef CONFIG_TCG_TPM2_HMAC
> -	memcpy(chip->null_ec_key_x, &buf->data[offset_t], val);
> +	if (hierarchy =3D=3D TPM2_RH_NULL)
> +		memcpy(chip->null_ec_key_x, &buf->data[offset_t], val);
>  #endif
>  	offset_t +=3D val;
>  	val =3D tpm_buf_read_u16(buf, &offset_t);
>  	if (val !=3D EC_PT_SZ)
> -		return -EINVAL;
> +		goto err;
>  #ifdef CONFIG_TCG_TPM2_HMAC
> -	memcpy(chip->null_ec_key_y, &buf->data[offset_t], val);
> +	if (hierarchy =3D=3D TPM2_RH_NULL)
> +		memcpy(chip->null_ec_key_y, &buf->data[offset_t], val);
>  #endif
>  	offset_t +=3D val;
> =20
> @@ -1257,38 +1259,38 @@ static int tpm2_parse_create_primary(struct tpm_c=
hip *chip, struct tpm_buf *buf,
> =20
>  	/* should have exactly consumed the TPM2B public structure */
>  	if (offset_t !=3D offset_r)
> -		return -EINVAL;
> +		goto err;

[Severity: Medium]
Can a truncated TPM2B_PUBLIC response cause the memcpy() calls into
chip->null_ec_key_x and chip->null_ec_key_y to read past buf->length and
overwrite chip->null_ec_key_{x,y} before validation completes?

At the start of tpm2_parse_create_primary(), only offset_r + len <=3D
tpm_buf_length(buf) is checked, without a minimum bound on len, and the
exact consumption check (offset_t !=3D offset_r) runs only after both
32-byte copies have already executed.

In addition, unlike *handle =3D keyhandle (which was moved to the end of the
function), the caller's name buffer and chip->null_ec_key_{x,y} are still
updated before the public area, creation ticket, and returned object name
are validated.  Because this patch also removes the comparison against
chip->null_key_name, a post-boot TPM2_RH_NULL call with a mismatched
response overwrites the EC coordinates used by tpm2_start_auth_session()
to encrypt session salts.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124120044.1481=
752-1-jarkko@kernel.org?part=3D4

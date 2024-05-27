Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E831667C0;
	Mon, 27 May 2024 21:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716843935; cv=none; b=erDAvcPjDgYrMZyluC3RMdCql18gjA89jXIvFant5hV3ff4i18gf8tyqr9iFwxrWK3lXut7qsMXZbRRTc+a8YGW1LhUq2Mo9WIsGVmFjZid46UV8NSVO8d+NPqVqTEbnOoPSi3RdAEbP8VFzlXj5fgbFspDisuEVoxcgHU99bVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716843935; c=relaxed/simple;
	bh=ea7mLNiKRQvyJJ92mwtw0D8ByawVemiSa6F3vLC2IpU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=gtZmHeor/zQv9NkzvL+GNpDotA35FU8eWgAyBxf+iHqboudGUpDUBxeDTGohHIo/WeTtdZEmGRPj3pVinbsKJHXWgxs75RoWBCl5ixmT3ngtBYUOU2/E1rNiLrG48hRpIIFEUzRblNaLYR8v2iO1UIcncACeH6Luku3W/F7fU9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ipgeIIq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ipgeIIq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B48C2BBFC;
	Mon, 27 May 2024 21:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716843934;
	bh=ea7mLNiKRQvyJJ92mwtw0D8ByawVemiSa6F3vLC2IpU=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=ipgeIIq+xpIJ4/KC6FU+ZN8DDS2gyLLT3WRRDjQqSonFcSFFzAQ3fQF4hG/nsEL3P
	 BT0fgg8OOqppbs7woCGoSuJyqYoOV//eFHMhYayJzLQE7OCEkbNJ2GcBodyfPed6bG
	 d8gTDdVE1qxgXWDtEg0OOhMLEQDKTK8LPjKBBsWvFLXO1QdOEP1z9OBrdGPmAJT6qI
	 5lOXZz428DTFcvKzt6HLwQubWSxZrB80e7yDTm4Md6G3SxVCZBHrHBysQpfXCVAxtv
	 H5zu7uSvF+90Ndyy9wNhvfy9+zR6KYs/H2bzIFfp01xLTfZWlBg38rf/3WhWgbo27j
	 UkaqIofuKb66Q==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 May 2024 00:05:31 +0300
Message-Id: <D1KQDPOZRWCW.1763CCYF1B84X@kernel.org>
Cc: <linux-crypto@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
 "Stefan Berger" <stefanb@linux.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ecdsa: Fix the public key format description
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>
X-Mailer: aerc 0.17.0
References: <20240527202840.4818-1-jarkko@kernel.org>
In-Reply-To: <20240527202840.4818-1-jarkko@kernel.org>

On Mon May 27, 2024 at 11:28 PM EEST, Jarkko Sakkinen wrote:
> Public key blob is not just x and y concatenated. It follows RFC5480
> section 2.2. Address this by re-documenting the function with the
> correct description of the format.
>
> Link: https://datatracker.ietf.org/doc/html/rfc5480
> Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature ver=
ification")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> It is a bug fix that does not really need a stable backport. Still
> categorizes as a bug because by following the existing documentation
> you end up with an error code.
>  crypto/ecdsa.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
> index 258fffbf623d..55114146ff84 100644
> --- a/crypto/ecdsa.c
> +++ b/crypto/ecdsa.c
> @@ -215,9 +215,8 @@ static int ecdsa_ecc_ctx_reset(struct ecc_ctx *ctx)
>  }
> =20
>  /*
> - * Set the public key given the raw uncompressed key data from an X509
> - * certificate. The key data contain the concatenated X and Y coordinate=
s of
> - * the public key.
> + * Set the public ECC key as defined by RFC5480 section 2.2 "Subject Pub=
lic
> + * Key". Only the uncompressed format is supported.
>   */
>  static int ecdsa_set_pub_key(struct crypto_akcipher *tfm, const void *ke=
y, unsigned int keylen)
>  {

Based on this, is this now along the lines of correct format":

       *ptr++ =3D 0x04; /* uncompressed */
       ptr =3D asn1_encode_octet_string(&ptr[0], &in[sizeof(in)], &x[0], x_=
size);
       ptr =3D asn1_encode_octet_string(&ptr[0], &in[sizeof(in)], &x[x_size=
 + 2], x_size);
       in_len =3D ptr - in;
       ret =3D crypto_akcipher_set_pub_key(tfm, in, in_len);

Notes:

- ptr points to the beginning of in (initially)
- x: "u16, u8[x_size], u16, u8[x_size]"
- x_size is length of ecc i.e. 32 in the case of p256.

I actually did the snippet by reading the RFC so this is pretty good
test for the patch.

BR, Jarkko

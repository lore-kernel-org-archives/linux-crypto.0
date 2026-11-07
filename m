Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794080096;
	b=Q6u6/nIwRWy34gIfNWvSKMxfBA0+A1Cw60uXh+n5l5WHnD+6uMJhzQDMCTwFllBnY32F
	 2yeSVeg0lQiUZqay24xBpdcIEicmHl2MD5NuXquCMYW7PcHjmtLHGmTgHFcJtTuoKPb6S
	 jkaj4+OMTm5I7iQfmmomgtk7wU2ta0ygn+IAHv5ZIzmIgYXVT4BA4fYANpyeHPpOe/N/r
	 D9sLHNSIKMRxtEcMbrH8fvLh0qOJefjOGgLNrCUJpObfFJdE0hMSncvvcUGs0V0e78TIF
	 7oXjJps5lYdaHHbtsTa8wp7g7E19nU4rUR4B6I0MQqvfCElYMZokm3RCnHEYrfFH3ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794080096;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xGm+aEPkCG2mHxOhWyC2m5RAgLXTk8CznK8+AvtCYXc=;
	b=xbXaV4o8GZadeqHk3wR6KrvM/YbLP6WFRT7vFL0hNgupP0j3UuX9bGheIqsjfnZ9CR/m
	 ZSaMCYj1tVocsoaFp9zHi2EBfYHcFlJCb+aaDuxw8KbZKm98vW6cE/RP/VEpBMiv3TxK0
	 HUBeF8CRlLg16A9MIP+4fA1sYz9gEgPGZPUMB2lvlyn/QigJ2h7f1QMp+ZdM2tV+fc067
	 zqB4ZBU01wkx3wi8ugC0mCZU0+h5XSkIjhmjNFRrLhUDqab77KmlEIQSRQ6fZDZ4GDUR9
	 kTxL9woc1fmAgTOcGSfEK8ZGhcdj19Q9FZWz12YmKNq0AorWnU8dG63R0nNXRPomc9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZGgd+GY4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84058606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 19:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZGgd+GY4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302511F0089F;
	Sat,  7 Nov 2026 19:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794080096;
	bh=xGm+aEPkCG2mHxOhWyC2m5RAgLXTk8CznK8+AvtCYXc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZGgd+GY4Kq/PpJE90h0rIPoWHUOZspvg11zl8Wrv/hHFmHpw+vKz42hJIYdu1g+Oe
	 i79YZMCbdZJ0HdQOIXVOYPvxeQ3L+d7TTJN1ou8ljZOkTCBYMG1VQNdfgKahURFobD
	 wj8aeIQPTxD2paBigsUehU9DvnQC1zFkYa8TNqsBwDv6zqdFYC4dJEeLb5d2Gw1yI4
	 efFDLfgLBvrwxUdKfO8nw+PdVl2WKeL+eZltrRX/HTSVhp93vUZmNbhwuIng/Kmusn
	 6jU1isceRZbOk/keFMxTSLVvqpqoIQdwq4BaHPxhbhqdNnyIHBSAOmI0mKdE/NPGzS
	 CJ7UcyoR1TSRQ==
Message-ID: <sashiko-outbox-203214@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.18] crypto: sa2ul - Fix HMAC key preparation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, "Herbert Xu" <herbert@gondor.apana.org.au>
In-Reply-To: <20261107192358.47287-1-ebiggers@kernel.org>
References: <20261107192358.47287-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 19:34:55 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] crypto: sa2ul: negative index out-of-bounds read in
  sa_aead_setkey() [1]
--

commit 44d71286f88be3b8e50cd6afb3ed5b5d01ae3f54
Author: Eric Biggers <ebiggers@kernel.org>

crypto: sa2ul - Fix HMAC key preparation

This commit replaces the manual shash-based HMAC ipad/opad derivation in
sa_prepare_iopads() with the crypto library helpers hmac_sha1_preparekey()
and hmac_sha256_preparekey(), and removes the unused shash allocation and
indirect call.

> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index 4a766e4351970..563e0f0d574ad 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c

[ ... ]

> @@ -1785,7 +1720,6 @@ static int sa_aead_setkey(struct crypto_aead *authe=
nc,
>  	if (key_idx >=3D 3)
>  		return -EINVAL;
> =20
> -	ad->ctx =3D ctx;
>  	ad->enc_eng.eng_id =3D SA_ENG_ID_EM1;
>  	ad->enc_eng.sc_size =3D SA_CTX_ENC_TYPE1_SZ;
>  	ad->auth_eng.eng_id =3D SA_ENG_ID_AM1;

[Severity: Critical]
This problem wasn't introduced by this patch, but can a negative key_idx
cause an out-of-bounds read on mci_cbc_enc_no_iv_array[] and
mci_cbc_dec_no_iv_array[] [1]?

Unlike skcipher, the AEAD framework does not enforce a minimum encryption
key size before calling ->setkey().  When crypto_authenc_extractkeys()
extracts an encryption key with keys.enckeylen < 16, key_idx =3D
(keys.enckeylen >> 3) - 2 is negative, bypassing the signed key_idx >=3D 3
check:

drivers/crypto/sa2ul.c:sa_aead_setkey() {
    ...
	key_idx =3D (keys.enckeylen >> 3) - 2;
	if (key_idx >=3D 3)
		return -EINVAL;
    ...
	ad->mci_enc =3D mci_cbc_enc_no_iv_array[key_idx];
	ad->mci_dec =3D mci_cbc_dec_no_iv_array[key_idx];
    ...
}

This loads out-of-bounds memory into the hardware mode control instruction
pointers mci_enc and mci_dec.  Note that non-multiples of 8 (such as
enckeylen =3D=3D 17) also pass this check, so validating keys.enckeylen with
aes_check_keylen() before computing key_idx would catch both.

[1] https://sashiko.dev/#/bug/linux-3f578a84-38a7-46fe-bc7b-117d71d9d394

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107192358.4728=
7-1-ebiggers@kernel.org?part=3D1

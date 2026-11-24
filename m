Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795512880;
	b=wtkdnCdIDJun1utQQbJK0Mg/bYP3SyGuH0HtxvUMPkV6LG3z/WEImci20AfpGqwK/WAF
	 bAa6QIzJu46ivx2EVOFDM8hWN4bKW1Ip8fpqmxXDB7hCTZ9Kx8C6Z6FHpdDfCN1vbk2/h
	 jsIG7avtJUSvbnNGfU1uJLJ+929+sNA4hkLijvnI9gtveheh2SoSqL+GNcw+Bd8rbqwLe
	 fMalfEuYmBCk441Q4gwOZs3jGcejdZg4vwR3yDxSFD6AIAQ3Rc/+DNIAea7uu2RZecyTD
	 J0xpeA1zVcyJh9VO3PJhQF6Rry1cTKb3/utyEd98udRy43Rk18eSVXoXZGCCFii3ydw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795512880;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0PTzdluLuVhmVOqzTQm40Ko6pmjBsKDDK1U/Z1G1x1c=;
	b=anbYbUsgr7IPrmYOIGJUSUgq48bxwWgV3Mkl7xj7tkiAN/6ZSIf0Rw7G09HzW1F9N37c
	 dqCNsPl9K1hsaqe6ZqH8caJEn1aDtYUzNvEcyKVMAmQr6zbM2/N1q5gF6LDI4WLzZ+dPM
	 0+R6JpX41oBlfnHzSFBErbYF2+m46f4uArElTaa0BdD8YQ66SjlidmIZ/RYsitv+uhBu9
	 tIVhMkQ7lhwcAq7V5lu9nYpUH1+T3I3bk5opTMgBfd+CMNb92vNBD9Se9BvGpAOo79Q0x
	 ErXCdx3ZUfnMsleYlqcHhuejvwX8du/NwvoiX6Y36TPFkilca1G08UztfSuYOwbUrPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mLYYlyvV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2620606A32A
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 09:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mLYYlyvV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AF61F000C4;
	Tue, 24 Nov 2026 09:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795512879;
	bh=0PTzdluLuVhmVOqzTQm40Ko6pmjBsKDDK1U/Z1G1x1c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mLYYlyvVwYBwQQTGxkvK+5iBYXmCIzF+pwgnkCkqeBaEVoxC2L5sRFJ8QD12eAftO
	 88agfn1l3f2bz0kY0vt/t0mUl4ciqa0z/CFB6WyXcCYgPm+k0ZWFH7PWT+I15+JHGl
	 PTvPvASVdz4RXJgAgKbUWKIzbtccLg7a8yxmUigBwbpTb8qmIAy7bZZ2FTPhRDsS8X
	 nkR7DyfTV+7YqmOH5urcLBI0+CIsz4Q7qqbe38s+5XvyZtQeP3PrEOd/Su+qbex8mb
	 /rAJ/uQCs9BFyZ38qSjQ40mhyaqr0DgguSnP7Zj6kKg8KlqYWfAzUPJKAcTfpKaKiu
	 KG3KtpzidEaRg==
Message-ID: <sashiko-outbox-230844@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] crypto: hisilicon/hpre - fix heap overflow on
 oversized ECDH public key
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Prinz" <rc4d5a@protonmail.com>, "Zhiqi Song" <songzhiqi1@huawei.com>, "Longfang
 Liu" <liulongfang@huawei.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
In-Reply-To: <20261124092546.1712228-2-rc4d5a@protonmail.com>
References: <20261124092546.1712228-1-rc4d5a@protonmail.com>
 <20261124092546.1712228-2-rc4d5a@protonmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 09:34:38 +0000
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
- [High] crypto: hisilicon/hpre: KPP API violation in
  hpre_ecdh_msg_request_set() [1]
--

commit 5f542f1173f567ac087c4ed6d0f299ee8ae8b2d3
Author: Ryan Prinz <rc4d5a@protonmail.com>

crypto: hisilicon/hpre - fix heap overflow on oversized ECDH public key

This commit adds an explicit upper-bound check on len against
ctx->key_sz << 1 in hpre_ecdh_src_data_init() to prevent an odd length of
2 * ctx->key_sz + 1 from bypassing the len >> 1 check and overflowing the
DMA-coherent buffer.

> diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto=
/hisilicon/hpre/hpre_crypto.c
> index 80666bb71508e..0759465dd87ff 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> @@ -1557,6 +1557,9 @@ static int hpre_ecdh_src_data_init(struct hpre_asym=
_request *hpre_req,
>  	int shift;
> =20
>  	/* Src_data include gx and gy. */
> +	if (unlikely(len > ctx->key_sz << 1))
> +		return -EINVAL;
> +
>  	shift =3D ctx->key_sz - (len >> 1);
>  	if (unlikely(shift < 0))
>  		return -EINVAL;

[Severity: High]
This problem wasn't introduced by this patch, but in the adjacent
hpre_ecdh_msg_request_set(), does checking req->dst_len < ctx->key_sz << 1
reject valid KPP shared-secret requests [1]?

drivers/crypto/hisilicon/hpre/hpre_crypto.c:hpre_ecdh_msg_request_set() {
	...
	if (req->dst_len < ctx->key_sz << 1) {
		req->dst_len =3D ctx->key_sz << 1;
		return -EOVERFLOW;
	}
	...
}

Standard KPP ECDH callers such as the Bluetooth subsystem expect only the
X coordinate of the shared secret and allocate a destination buffer of
ctx->key_sz bytes (e.g. 32 bytes for NIST P-256).  Because the HPRE
hardware outputs both the X and Y coordinates and the driver writes
directly to req->dst instead of using a bounce buffer to copy out only the
X coordinate, those requests fail in hpre_ecdh_msg_request_set().

[1] https://sashiko.dev/#/bug/linux-8b3c97e2-4579-4201-94f1-2d9889a040fa

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124092546.1712=
228-1-rc4d5a@protonmail.com?part=3D2

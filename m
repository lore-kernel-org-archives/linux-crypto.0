Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794182154;
	b=iHs6VlM9zmZ9NP8/1PdsOMMqXJd+BZovMpXDyzRpbMjRz0mJGH6C6crwpqSFS/2D0b02
	 KCk/T1Y4wgscIW0l7qqoYsWRfaZe8ee3TKUWGA0+ZcFXkNsWFnPfxo32U2BZpirWqawhJ
	 p1hD4K1i87LpXsw2Fi24NwhrR3A8s21Lzw5XhCi9SZFoxVuST8ksjSNt7ZYThedCUPENa
	 l6Q12Wnxwkwwecoo1cy9u8OSlvhXWgI+18sPnKvx41vAf+qOtKBJsH3AtZxP5I7DxaLZ5
	 3vU6whk8+LWA1mYYK4xRdFyxTLQ0j8/680aqrUTUt5CrrHcxVlKvcTbcE3SK4XUkx5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794182154;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Mb+Fo3hSfznTTYAhqEX3wHTCo11aEebJbdyVVsKSRnE=;
	b=PoBIENpktjEAKAe8e0R4OSmvK3KXq2D+BYZlz3hxanharEoE0subvvFw4NlEa6/+c9IL
	 1AJxqz21TBstqjU9+nY2/4DBurpDJDPs60AXcoDHF/+RNWmO+tbzP8/7apn0/Lu+CDvDG
	 4UcO4gk3b8eFDHbwwlcw2P3AKrIyOVLGCzQzx4B+feHA93O1y9Gqb9Ktje19z9PGFS3Tj
	 6BsA08gE5L0PmXs48MZ0aRySRo4T95TnknULIXWfL4okbw/0k86d+f5ik3Dxpf98wVSCH
	 Pqajtj2dT7Xd10gnr4Tivb1LsYW8g6vrFE+YfcQq5JsYqavie8Jzv+503Rp1sm+asxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OJSkGJfX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF03606A322
	for <linux-crypto@vger.kernel.org>; Sun,  8 Nov 2026 23:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OJSkGJfX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DBE1F008A3;
	Sun,  8 Nov 2026 23:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794182153;
	bh=Mb+Fo3hSfznTTYAhqEX3wHTCo11aEebJbdyVVsKSRnE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OJSkGJfXn44aspTJ3uiDQCNEKQswOZTfhIVnCZcFr4kNm9jEwK34OGrCkLNjDW7Ag
	 Nd50ag9stX6o74J9mdVroyRUx1AhOlHBOLGOwTfHQfN1NNomn3vq7fLQcNYWKCDGHY
	 VudXfpiwmQfq2N32J92tIlXFl8Zwykji5XrmwoHiUVy07slHwJfi+fJwTxKCFb0Kp7
	 DaC/RSTGAvXuhFhA9/z6ZujuYI/UuhSPZ5HoJmoAFVP65B3ovdRvURpTKz5npiwzNn
	 Hl66xVmJKsmB9v6014Kqul1oPlBL+f7YLoFbwQyB+aWp+6NZFe1Lx2BkIb+i/bLHEk
	 lqbDkwmz0wzfA==
Message-ID: <sashiko-outbox-204176@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC] crypto: caam - never share the gcm and skcipher
 descriptors serially
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Jardin" <vjardin@free.fr>, =?utf-8?b?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>, "Pankaj
 Gupta" <pankaj.gupta@nxp.com>, "Sahil Malhotra" <sahil.malhotra@nxp.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
In-Reply-To: <20261109-for-upstream-caam-shdsc-share-never-v1-v1-1-65a1dd146db2@free.fr>
References: <20261109-for-upstream-caam-shdsc-share-never-v1-v1-1-65a1dd146db2@free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 23:55:52 +0000
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
- [Low] crypto: caam: dead sharing jumps and HDR_SAVECTX with
  HDR_SHARE_NEVER
--

commit 9b09bbe924ba4f39f4ea4b61b1bb908c38315173
Author: Vincent Jardin <vjardin@free.fr>

crypto: caam - never share the gcm and skcipher descriptors serially

This commit changes the GCM and skcipher shared descriptors from
HDR_SHARE_SERIAL to HDR_SHARE_NEVER so jobs using the same key are not
serialized by the SEC hardware.

> diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caa=
malg_desc.c
> index 04c1105eb1f58..32d614a3431da 100644
> --- a/drivers/crypto/caam/caamalg_desc.c
> +++ b/drivers/crypto/caam/caamalg_desc.c
> @@ -639,7 +639,7 @@ void cnstr_shdsc_gcm_encap(u32 * const desc, struct a=
lginfo *cdata,
>  	u32 *key_jump_cmd, *zero_payload_jump_cmd, *zero_assoc_jump_cmd1,
>  	    *zero_assoc_jump_cmd2;
> =20
> -	init_sh_desc(desc, HDR_SHARE_SERIAL);
> +	init_sh_desc(desc, HDR_SHARE_NEVER);
> =20
>  	/* skip key loading if they are loaded due to sharing */
>  	key_jump_cmd =3D append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
> @@ -765,7 +765,7 @@ void cnstr_shdsc_gcm_decap(u32 * const desc, struct a=
lginfo *cdata,
>  {
>  	u32 *key_jump_cmd, *zero_payload_jump_cmd, *zero_assoc_jump_cmd1;
> =20
> -	init_sh_desc(desc, HDR_SHARE_SERIAL);
> +	init_sh_desc(desc, HDR_SHARE_NEVER);
> =20
>  	/* skip key loading if they are loaded due to sharing */
>  	key_jump_cmd =3D append_jump(desc, JUMP_JSL |
> @@ -1463,7 +1463,7 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc, s=
truct alginfo *cdata,
>  	bool is_chacha20 =3D ((cdata->algtype & OP_ALG_ALGSEL_MASK) =3D=3D
>  			    OP_ALG_ALGSEL_CHACHA20);
> =20
> -	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
> +	init_sh_desc(desc, HDR_SHARE_NEVER | HDR_SAVECTX);
>  	/* Skip if already shared */
>  	key_jump_cmd =3D append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
>  				   JUMP_COND_SHRD);
> @@ -1539,7 +1539,7 @@ void cnstr_shdsc_skcipher_decap(u32 * const desc, s=
truct alginfo *cdata,
>  	bool is_chacha20 =3D ((cdata->algtype & OP_ALG_ALGSEL_MASK) =3D=3D
>  			    OP_ALG_ALGSEL_CHACHA20);
> =20
> -	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
> +	init_sh_desc(desc, HDR_SHARE_NEVER | HDR_SAVECTX);
>  	/* Skip if already shared */
>  	key_jump_cmd =3D append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
>  				   JUMP_COND_SHRD);

[Severity: Low]
With HDR_SHARE_NEVER, should HDR_SAVECTX and the JUMP_COND_SHRD jumps also
be dropped from these four descriptors?

All CAAM job backends defer sharing mode to the shared descriptor header,
so HDR_SHARE_NEVER disables descriptor sharing across jobs and JUMP_COND_SH=
RD
is never true. Keeping key_jump_cmd and the JUMP_COND_SHRD branch in
append_dec_op1() called by cnstr_shdsc_skcipher_decap() leaves unreachable
instructions in the descriptors that waste space and DECO cycles on every
job, and HDR_SAVECTX only applies when a descriptor is self-shared.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-for-upstre=
am-caam-shdsc-share-never-v1-v1-1-65a1dd146db2@free.fr?part=3D1

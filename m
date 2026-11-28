Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795841537;
	b=WVoKlQjCrI0Z5ac0HMvt6P5YGXnJtzMqYNXoE8Ct+WIFmRyp5xvS7nwZHuQdHVSahu4K
	 0pDdWzBJw78DGvdbCb7ZFXW5MSnypXZNkJdqr0QnEeN7CYtK22Dgec7CSDZBRSEkDhPuV
	 cUHPr9qMaVrk88gtwZ/O6Pdd3iEMHTzNuOYwET3zidVpJLx6WPBC1/dszJ1aa2R+OfZRi
	 gC40uyW3+eCr3X+g5IJr6G9Od7oz3Wh9isw3dEWMV2GJuAG17rx8JbOsOlRNJxpAsvTTe
	 9IizkmN4wbwsvcLKm/r8eYVqyezVkhqsldZSRi99XAnWxUoGEbiraDF7thVGJdgJj8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795841537;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Vj9dT2EUBDfRXnL8b/O6b5BnEnZcAlx9DkgJmVXD4fI=;
	b=Xww5+35QluLJvyReg6dmaFMlgVwZkWqnLJpQ5LCBP6EaaeGqpICdUxxJHMigrEylVtow
	 qTbGsljVwql4bSBl0S9gCga5IQwS8CeRIzhoHlxbJRt8aBbFpIDUEPIaiJ2iyrAbUWRof
	 8UT3GJq7ehUIYlJs6oF+ATqpdP7kapaURJnuPIW/lsGz3wVCCops1LiGcpNPkgBLC/Fdj
	 o1L/ENxGzLEija3RxYt4VTF9TRVGQfDGLPYuxzXy+LDusEUbUyYY0AfVj/A2pKg3SloJn
	 lq4Rk/jmquhM1r3FEmbEM2k6gC/B6FhKYUj8m48922XxAt/hCm0MNOunF2d4Iu/svaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m7onyYVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA9F606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 04:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m7onyYVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630201F00893;
	Sat, 28 Nov 2026 04:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795841536;
	bh=Vj9dT2EUBDfRXnL8b/O6b5BnEnZcAlx9DkgJmVXD4fI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m7onyYVGmtwmOaLgjhDZ77bEm0fQ3q0Rt+jMC3I1y2eRBhBnxlVN+skY5q+RST5o6
	 JAG83a3pmgqHzyk+nro7WvVqI1r1MMXeEsllSGvwGAVEGBUTOCUQGMaxXe1wQy8Wau
	 WnOZRAz/HYaosPd8gi9vnHSUFp4+sOP8jT4yjaXU0/qR0j0J4m5W3kB1NGIpzY9b2v
	 yz9PDdBNUppVMa5vQ1/tYluiTPVHWOTOBj8YJ7Ree4w0WVxRtK5q5XuTf3nKrtIwpi
	 8+MoGjuz5E4aPZxUjKRytxMyJKy2yQGoEAMGpe1df4CD6vhzIc3vAtke/9JX/AEyXj
	 +D6I6MYm41y8g==
Message-ID: <sashiko-outbox-238463@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/8] crypto: cesa - finish long hashes on the non-TDMA
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rosen Penev" <rosenp@gmail.com>, linux-crypto@vger.kernel.org, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: "Srujana Challa" <schalla@marvell.com>, "Bharat Bhushan" <bbhushan2@marvell.com>, "David
 S. Miller" <davem@davemloft.net>, "Arnaud Ebalard" <arno@natisbad.org>, "Boris
 Brezillon" <bbrezillon@kernel.org>, "Russell King" <rmk+kernel@arm.linux.org.uk>, "Romain
 Perier" <romain.perier@free-electrons.com>
In-Reply-To: <20261128044050.722617-9-rosenp@gmail.com>
References: <20261128044050.722617-1-rosenp@gmail.com>
 <20261128044050.722617-9-rosenp@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 04:52:16 +0000
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
- [High] crypto: cesa: buffer overflow on creq->cache in
  mv_cesa_ahash_std_step()
--

commit 819442c312cc2cf884cbbf9084155d8ab97dd609
Author: Rosen Penev <rosenp@gmail.com>

crypto: cesa - finish long hashes on the non-TDMA path

This commit fixes hash finalization on the non-TDMA path for messages of
64 KiB or more by entering the manual padding block whenever the last
request's source data is consumed, carrying partial blocks across steps,
and tracking final step emission via sreq->final_issued.

> diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/=
cesa/hash.c
> index b51315cd01dfa..5e867e688ffa5 100644
> --- a/drivers/crypto/marvell/cesa/hash.c
> +++ b/drivers/crypto/marvell/cesa/hash.c
[ ... ]
> @@ -221,16 +222,17 @@ static void mv_cesa_ahash_std_step(struct ahash_req=
uest *req)
> =20
>  	frag_mode =3D mv_cesa_get_op_cfg(op) & CESA_SA_DESC_CFG_FRAG_MSK;
> =20
> -	if (creq->last_req && sreq->offset =3D=3D req->nbytes &&
> -	    creq->len <=3D CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
> +	/* All data of the last request is in SRAM: finish the hash. */
> +	final =3D creq->last_req && sreq->offset =3D=3D req->nbytes;
> +
> +	if (final && creq->len <=3D CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
>  		if (frag_mode =3D=3D CESA_SA_DESC_CFG_FIRST_FRAG)
>  			frag_mode =3D CESA_SA_DESC_CFG_NOT_FRAG;
>  		else if (frag_mode =3D=3D CESA_SA_DESC_CFG_MID_FRAG)
>  			frag_mode =3D CESA_SA_DESC_CFG_LAST_FRAG;
>  	}
> =20
> -	if (frag_mode =3D=3D CESA_SA_DESC_CFG_NOT_FRAG ||
> -	    frag_mode =3D=3D CESA_SA_DESC_CFG_LAST_FRAG) {
> +	if (final) {
>  		if (len &&
>  		    creq->len <=3D CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
>  			mv_cesa_set_mac_op_total_len(op, creq->len);
> @@ -238,8 +240,13 @@ static void mv_cesa_ahash_std_step(struct ahash_requ=
est *req)
>  			int trailerlen =3D mv_cesa_ahash_pad_len(creq) + 8;
> =20
>  			if (len + trailerlen > CESA_SA_SRAM_PAYLOAD_SIZE) {
> -				len &=3D CESA_HASH_BLOCK_SIZE_MSK;
> -				new_cache_ptr =3D 64 - trailerlen;
> +				/*
> +				 * No room for the padding: hash the whole
> +				 * blocks now and carry the partial one over
> +				 * to the next step, which adds the padding.
> +				 */
> +				new_cache_ptr =3D len & CESA_HASH_BLOCK_SIZE_MSK;
> +				len &=3D ~CESA_HASH_BLOCK_SIZE_MSK;
>  				if (engine->pool)
>  					memcpy(creq->cache,
>  					       engine->sram_pool +
> @@ -262,15 +269,20 @@ static void mv_cesa_ahash_std_step(struct ahash_req=
uest *req)
>  						    CESA_SA_DATA_SRAM_OFFSET,
>  						    creq->cache, i);
>  				len +=3D i;
> +				sreq->final_issued =3D true;
>  			}

[Severity: High]
Can mv_cesa_ahash_pad_req(creq, creq->cache) overflow creq->cache[] when
creq->len > CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX and (creq->len & 63) >=3D 56?

Previously, the manual padding branch was only reachable when len =3D=3D 0
and creq->len <=3D 0xffff, which only occurred on block-aligned lengths
where padlen + 8 is 64 bytes.  Now that long hashes enter this branch for
any remainder, a message with (creq->len & 63) in 56..63 has a padlen of
57..64 bytes, so mv_cesa_ahash_pad_req() writes 65..72 bytes (padlen plus
the 8-byte bit length) into creq->cache[CESA_MAX_HASH_BLOCK_SIZE], which
is only 64 bytes.

That overwrites the adjacent creq->cache_ptr and creq->len fields in
struct mv_cesa_ahash_req, and the subsequent memcpy() of i bytes reads
past creq->cache[] (triggering a FORTIFY_SOURCE panic when engine->pool
is used).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128044050.7226=
17-1-rosenp@gmail.com?part=3D8

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793772097;
	b=AJh+hFnCa0a4gwGHkMOIC1x7lcLbJEmCKOomCwN+0nd7yvcb70ly4A6GLedTnOUsqZU0
	 GYgdzpRXf20cKxQNN4VnCJZSpgnyz+o2MLp/f0XirbhMi2+9OimZV26y6pkN6h0G414gE
	 5ow5arUJN8GpteqBC95v5pY5b9H462c82sQ4ktdqxZZxrTDsnhnxPxWDgvlTBZRhkVgrR
	 rNfjp8TYv5pflCmdsMTYYLtdRy8tG5nCqKBmrKIi5NNC6D6an00pfrtQMN9aoeCDg8Wep
	 jfaJcfDWvxy0tjeomjNTegHXpRRlyRXyvVCNRkv5PkBzRnUuu0wDnoIa3azns3PgBPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793772097;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UpO2ja8bvkLz/Tkbbn7AaRd5+1pDhj745tBViHfmvh0=;
	b=aKW770W7QGH/3J2zGqLuxnbxNdgCFGC/l/+06Sv3HawEPmoHQnm3eI7mb2fnRCNrlfRn
	 xPQKqQopkCPf+8D2TNeRLulxg/EaXpAuPvvHOnNiB/kC9XSBBmr7VQFrEa2A9VRUnPo7q
	 rusI060S/LSKfXjNR0iF1d69c/lCqoxUXNjc9/5x78zB1hdVyfh6eyGYzKO3Lj3JG0dqS
	 JINZ5eI16eQHTfTwKDf0A50DnSaZwm8teSEG7I8ydt3Uluv3Of0R2Ocvnd6Q8YoThBM/L
	 YHkO8M8ftdDAIeR9q5yyklgMG+psO237+/whD6qQVu4HW8swnj95gEanP19tFt1AHlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QmsA5PXY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC5B606A31B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 06:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QmsA5PXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FAC1F000C1;
	Wed,  4 Nov 2026 06:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793772096;
	bh=UpO2ja8bvkLz/Tkbbn7AaRd5+1pDhj745tBViHfmvh0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QmsA5PXYAWUrTprf8CR3NXFCW07P7s/S0Cr3jaktvNbRklzsfpSXM5K23jrmQb3JI
	 gbCUBJB7EnsX+HLMPE05dAPPx7wg52mzej8GsxN9SKJNZRILIDaBy1paAdvBwM/hiu
	 06D9R2Ksz31Bf+MVKycNX/vTU29n1f+ETllZHiTddWKHWqfPbKDG+GFRTAV49WyhJx
	 zfErW3DMVkybs5FWLOAtB9tnBndZ7jisP0wj4PvUCW1tQ1L9uEqDS6Rh9m0WLhtZit
	 IVw146l6oNVzBxhr7XQdZkWc9xuB9QHwfY6CsxlJDdhFOOVFxQiuWriT0UCem+bnKb
	 Aca9ejBpVsMug==
Message-ID: <sashiko-outbox-196714@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 22/30] crypto: sa2ul - validate scatterlist setup and
 unwind DMA mappings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manorit Chawdhry" <m-chawdhry@ti.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>, "Colin Ian
 King" <colin.i.king@gmail.com>
Cc: "Andrew Davis" <afd@ti.com>, "Pratham T" <t-pratham@ti.com>, "Kamlesh
 Gurudasani" <kamlesh@ti.com>, "Udit Kumar" <u-kumar1@ti.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-22-15ab90b3f9c2@ti.com>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
 <20261104-b4-upstream-sa2ul-cleanup-v2-22-15ab90b3f9c2@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 06:01:35 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] crypto: sa2ul: sa_run() passes 0 nents to dma_map_sgtable() when s=
ize is 0
--

commit 615706b20f3b90ba270a289c49acc68499b974e6
Author: Manorit Chawdhry <m-chawdhry@ti.com>

crypto: sa2ul - validate scatterlist setup and unwind DMA mappings

This commit validates source and destination scatterlist lengths with
sg_nents_for_len(), aborts on sg_split() failures, and routes partial setup
errors in sa_run() through sa_free_sa_rx_data().

> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index 2964aa44d50e4..b33fac66c93fc 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c
> @@ -1071,6 +1071,10 @@ static int sa_run(struct sa_req *req)
>  	 */
>  	src =3D req->src;
>  	sg_nents =3D sg_nents_for_len(src, req->size);
> +	if (sg_nents < 0) {
> +		ret =3D sg_nents;
> +		goto err_cleanup;
> +	}
> =20
>  	split_size =3D req->size;
> =20
> @@ -1086,7 +1090,7 @@ static int sa_run(struct sa_req *req)
>  		mapped_sg->sgt.orig_nents =3D src_nents;
>  		ret =3D dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
>  		if (ret) {
> -			kfree(rxd);
> +			sa_free_sa_rx_data(rxd);
>  			return ret;
>  		}
> =20
> @@ -1097,7 +1101,7 @@ static int sa_run(struct sa_req *req)
>  		mapped_sg->sgt.orig_nents =3D sg_nents;
>  		ret =3D dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
>  		if (ret) {
> -			kfree(rxd);
> +			sa_free_sa_rx_data(rxd);
>  			return ret;
>  		}
> =20
> @@ -1106,12 +1110,10 @@ static int sa_run(struct sa_req *req)
> =20
>  		ret =3D sg_split(mapped_sg->sgt.sgl, mapped_sg->sgt.nents, 0, 1,
>  			       &split_size, &src, &src_nents, gfp_flags);
> -		if (ret) {
> -			src_nents =3D mapped_sg->sgt.nents;
> -			src =3D mapped_sg->sgt.sgl;
> -		} else {
> -			mapped_sg->split_sg =3D src;
> -		}
> +		if (ret)
> +			goto err_cleanup;
> +
> +		mapped_sg->split_sg =3D src;
>  	}
> =20
>  	dma_sync_sgtable_for_device(ddev, &mapped_sg->sgt, DMA_TO_DEVICE);
> @@ -1121,6 +1123,10 @@ static int sa_run(struct sa_req *req)
>  		dst =3D src;
>  	} else {
>  		dst_nents =3D sg_nents_for_len(req->dst, req->size);
> +		if (dst_nents < 0) {
> +			ret =3D dst_nents;
> +			goto err_cleanup;
> +		}

[Severity: High]
What happens in sa_run() when req->size is 0?

In sa_aead_run(), an AEAD request with req->assoclen =3D=3D 0 and zero plai=
ntext
length (req->cryptlen =3D=3D 0 on encryption, or req->cryptlen =3D=3D
crypto_aead_authsize(tfm) on decryption) results in auth_size =3D=3D 0. Unl=
ike
sa_cipher_run() and sa_sha_run(), sa_aead_run() does not divert zero-length
requests to the software fallback:

drivers/crypto/sa2ul.c:sa_aead_run() {
	...
	if (auth_size > SA_MAX_DATA_SZ ||
	    (auth_size >=3D SA_UNSAFE_DATA_SZ_MIN &&
	     auth_size <=3D SA_UNSAFE_DATA_SZ_MAX)) {
		...
	}
	...
	sa_req.size =3D auth_size;
	...
	return sa_run(&sa_req);
}

When sa_run() calls sg_nents_for_len() with a length of 0, sg_nents_for_len=
()
returns 0. Because the new checks only test sg_nents < 0 and dst_nents < 0,=
 a
return value of 0 bypasses the error check, skips the sg_nents =3D=3D 1 bra=
nch,
and enters the else branch:

	} else {
		mapped_sg->sgt.sgl =3D req->src;
		mapped_sg->sgt.orig_nents =3D sg_nents;
		ret =3D dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);

Passing orig_nents =3D=3D 0 to dma_map_sgtable() triggers the WARN_ON_ONCE(=
nents
<=3D 0) in __dma_map_sg_attrs() and fails the request with -EINVAL.

Should sa_run() reject sg_nents <=3D 0 and dst_nents <=3D 0 (or should
sa_aead_run() route auth_size =3D=3D 0 to the software fallback)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-b4-upstrea=
m-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com?part=3D22

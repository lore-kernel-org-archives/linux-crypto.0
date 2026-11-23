Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447156;
	b=wHe0ArNFQZGaD/b8aPzrnZILE9bdiQWmZhVfqBgOmxC+Htfm2JzC3J4HO/Rrc91p3anc
	 BvVywgu90SQRELHWgbWm/bGAT2Fy5J1zZEzFmc899fAtuQa8GdZx6esa2QzCjg9tDr13C
	 gEoZh7uMYTZOtiATfQt7g7+HWBtoeVvG18auONFWvzl6mnEWcyomxNEuOE3gCnOBEBsuP
	 CLfBoXArEf9Rr2Ttq4F6A4OX/TQ48UNr1I2aJEmdl+we3X7moO9afVNv6ZKYdjmMVGvin
	 RRbHEE6DU+FsHBn+G2WBHOPJKhJdPT0VfQIGseunMmov192mwZhI6mF1/8QAizl/0LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447156;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bnR0GRPXHELQrNbzQsdwgxPcGmVpehX4wb/dxh3Lceg=;
	b=z18eedN72YTVUahblKYCyJEJ4ShJlgXIivqr3Bfs0Jj91YqgKUkgcLDsq4aMjwoQk6OG
	 eSPW9Q3cpBq5rmcSaudVWoX5IMzc0zEUiGzqhwkK2TmrXWlwGD8OJKzFnWLm7d/mYqL1K
	 zS77fd+EgDwQJ89CLdu8MDW6m/1JA1ATj4WIO/C1I4/b5FSqGhcB6eFEe9PoxE17nmd2Q
	 PQNTV1T0Vu7ZgAnDWLtYMJJceyBHQbSqvCXWFfWlZ5M11Ua0oTSX0qPpNBhdtJGCwHIzS
	 L2PI1oUH64S/jvdAcb2drOfQQZhKrZjGHdX7AhTY86kLtvDLMRtp3kjqZO5zejGVhhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FuhgQugu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B9B606A32D
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 15:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FuhgQugu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1391F000C0;
	Mon, 23 Nov 2026 15:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795447156;
	bh=bnR0GRPXHELQrNbzQsdwgxPcGmVpehX4wb/dxh3Lceg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=FuhgQuguGB2Fz/hE/3cRj93UY/VMwU3jGAkSZO7K783+Mw0OvDZtO4FshES+aP1fn
	 if6YOv/7UtimWNMmygE6FOdddoo4wADGetPCyDZxO875bEWfvKHGTJ1n/8s+FxRUqN
	 4/e8jhtAmlJZ8oAgQ2/eTEdEP6sufKlAB1k+av0H1H0mCwOLXZRbCdsicyZjYPg8SC
	 QkReVwEpY5N8Az+MjKgPTz/E2oVrh2jdOR/Cwa+bw+RvB7a7pzs5KdXrdtia1lCF4B
	 k0UnzlGA2CQxUVJfTjIuiIHA0ebf98Yq9Umk0ejJNDWEma2GY223jFRZKF8nDeCMPj
	 q5NszXN/PN3NA==
Message-ID: <sashiko-outbox-229527@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/10] crypto: talitos - Remove duplicate IV unmap in
 AEAD encrypt path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lee Jones" <lee@kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Paul Louvel" <paul.louvel@bootlin.com>, "Evgeniy
 Polyakov" <johnpol@2ka.mipt.ru>, "Kim Phillips" <kim.phillips@freescale.com>, "Christophe
 Leroy" <chleroy@kernel.org>, linux-crypto@vger.kernel.org
In-Reply-To: <20261123151055.2533735-7-lee@kernel.org>
References: <20261123151055.2533735-1-lee@kernel.org>
 <20261123151055.2533735-7-lee@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 15:19:15 +0000
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
- [Critical] crypto: talitos: DMA address truncation in
  unmap_single_talitos_ptr() [1]
--

commit 7421990fbcd39641bb3ac45651a2ed7bcb79c461
Author: Lee Jones <lee@kernel.org>

crypto: talitos - Remove duplicate IV unmap in AEAD encrypt path

This commit removes a duplicate dma_unmap_single() call on edesc->iv_dma in
ipsec_esp_encrypt_done(), relying on ipsec_esp_unmap() to unmap civ_ptr via
unmap_single_talitos_ptr().

> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index c7d9ce2905be7..be7a281319450 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -1097,16 +1097,12 @@ static void ipsec_esp_encrypt_done(struct device =
*dev,
>  				   int err)
>  {
>  	struct aead_request *areq =3D context;
> -	struct crypto_aead *authenc =3D crypto_aead_reqtfm(areq);
> -	unsigned int ivsize =3D crypto_aead_ivsize(authenc);
>  	struct talitos_edesc *edesc;
> =20
>  	edesc =3D container_of(desc, struct talitos_edesc, desc);
> =20
>  	ipsec_esp_unmap(dev, edesc, areq, true);
> =20
> -	dma_unmap_single(dev, edesc->iv_dma, ivsize, DMA_TO_DEVICE);

[Severity: Critical]
This problem wasn't introduced by this patch, but does
unmap_single_talitos_ptr() truncate >32-bit DMA addresses [1] when
ipsec_esp_unmap() unmaps civ_ptr?

While to_talitos_ptr() stores the upper bits of a >32-bit DMA address in
ptr->eptr on non-SEC1 hardware, unmap_single_talitos_ptr() ignores
ptr->eptr and only passes the lower 32 bits to dma_unmap_single():

drivers/crypto/talitos.c:unmap_single_talitos_ptr() {
	struct talitos_private *priv =3D dev_get_drvdata(dev);\
	bool is_sec1 =3D has_ftr_sec1(priv);

	dma_unmap_single(dev, be32_to_cpu(ptr->ptr),
			 from_talitos_ptr_len(ptr, is_sec1), dir);
}

On systems with >4GB physical memory, this leaks the intended IOMMU mapping
and unmaps an unrelated truncated DMA address, which can cause IOMMU faults
and memory corruption.

[1] https://sashiko.dev/#/bug/linux-fc697335-3f0d-4823-8b99-a6069def8475

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123151055.2533=
735-1-lee@kernel.org?part=3D6

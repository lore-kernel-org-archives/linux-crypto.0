Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793772098;
	b=nyj3RX9RPyLfVkrnC4cmZH53jsWFTg8SYu/L67Vphqj60SuV5hrL05SpBM0arTuRvmb+
	 tfSPRJCH+58l91/HjEDj419YmuziqVgL55PHsklT8sxFq+kICHSyPQ1FeynpZx/RZAanB
	 JHhJS6hKaTgqlmb1Kst1epBP5d+8PZjMQbqOQoEQb5iSG/a9MZ12NQwoFOANmQEtriGFF
	 +sy5jRHr2+ULslJS34PHy28jPBdtA14B1TOx4w4pfIe0OEtXfiFZsYpkQ0+VOhHK37J4d
	 OD3FNgEGNKq+TnXmTSvmnD/Det5JO2ZFIbAMshQ8PalDGZlbUWjICfu6zOPtW4abgZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793772098;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xUGH808RUJLFxJ+09dW9nLh8ZyoELHBxCb9ooxg9ms8=;
	b=YFFR1wO1P9DgAFbxigb4vJGsqFxaR1T3xx8VtlOwEJHok6n2GLd9JjA79y9rMoWHwxu1
	 Ctw+T5JLhHvsJJ/PJpBW5VI44p4xzrbDiIRBPxddqMpxkVi4l8Fwiq19WBP4M5MKoKZN4
	 IRsTNsA9MbC+kAfZhikBMZap53UBsjR4hE26rs2urEQisk+OTqdl2sVZVk2DhdK01dozx
	 C+5YzLi1sp1ASAyS0pPVikpukiDd/RKqSKxCB+81V5u0Yy+93v4G+A4wXYz4LjgB5oera
	 0As5iAEjzC0z46R+hSYyixY43Iy4fKSkdTT51Tf8k/PFdZDdL6nxnkRZtbPm5dZtsKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mj8il5Ao;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260B3606A31B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 06:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mj8il5Ao
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C311F00919;
	Wed,  4 Nov 2026 06:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793772097;
	bh=xUGH808RUJLFxJ+09dW9nLh8ZyoELHBxCb9ooxg9ms8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mj8il5Aolrg6iR1rCq0E8vc9WITAqeMieZaXK469oviHYitfZMBnLdAZUYNVcJ0yD
	 qIcYpjPKEmGr/feO+KMIOFG+ppChBj3osPqQxRplwZDhAjN8jg0qCDSsTipzjkiROU
	 hGz7prvB8XrqlZHAzzk4ZSDjFaDsJ7PTzvEvnp4CDW75x/3GcDuJf9+jpZa0rHMDyI
	 Qr49DgfeijPKyoLKT20YEM1YSWmqJU35lsSCJldQ72a1EP2QNmTMIztJn80bTPmEWG
	 rRMPkQiDLBSAL++xWQHJSUi1CKGWgfhgm6SdmLtGjW8Wsq8J0R83+r11VjgV4Fdux5
	 1gHYBRN7t2PaQ==
Message-ID: <sashiko-outbox-196715@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 30/30] crypto: sa2ul - add SA3UL_CM AES support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manorit Chawdhry" <m-chawdhry@ti.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>, "Colin Ian
 King" <colin.i.king@gmail.com>
Cc: "Andrew Davis" <afd@ti.com>, "Pratham T" <t-pratham@ti.com>, "Kamlesh
 Gurudasani" <kamlesh@ti.com>, "Udit Kumar" <u-kumar1@ti.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-30-15ab90b3f9c2@ti.com>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
 <20261104-b4-upstream-sa2ul-cleanup-v2-30-15ab90b3f9c2@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 06:01:36 +0000
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
- [Low] crypto: sa2ul: missing kernel-doc entry for aes_cm in struct sa_cry=
pto_data
--

commit bbd9935e2ba3dc8e6f81dc7c3285e99df2e66513
Author: Manorit Chawdhry <m-chawdhry@ti.com>

crypto: sa2ul - add SA3UL_CM AES support

This commit adds support for SA3UL_CM revision 3.1 by deriving an extra
key-schedule round 15 for AES-256 decryption and running a TRNG-seeded
AES-ECB priming operation during probe before registering algorithms.

> diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
> index ba3fb91daaa49..199eff4467d79 100644
> --- a/drivers/crypto/sa2ul.h
> +++ b/drivers/crypto/sa2ul.h
> @@ -194,6 +194,8 @@ struct sa_crypto_data {
>  	spinlock_t		request_lock; /* request admission */
>  	struct mutex		dma_lock; /* DMA setup and cancellation */
>  	bool			stopping;
> +	/* true if HW is SA3UL_CM (SA_REVISION major=3D3 minor=3D1) */
> +	bool aes_cm;
>  };

[Severity: Low]
This isn't a bug, but struct sa_crypto_data in drivers/crypto/sa2ul.h has a
kernel-doc comment block above it documenting its members. Should @aes_cm be
added to that kernel-doc comment so that running scripts/kernel-doc or
building with W=3D1 does not emit a warning?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-b4-upstrea=
m-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com?part=3D30

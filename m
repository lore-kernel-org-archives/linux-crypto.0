Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795445466;
	b=5Xr3at681z02awAUmK6FyYjorZzhg9qnaJVl3mzR50LbPYNgk98qX0v33BphMNXaftzs
	 tP2UTzklzDFviwRzVcS8AU7/zLHSFPAchQSubTAHmxHU9eUZ4GeogNOzXv3XgfHZgkLxG
	 fr7S4XL5FqAsnkiPmO3txPl6QNGrIzceVX9eEGAfZ2yZBEH1pN1dgNXlN6dbY+5bGgCU/
	 Lc5NyRWcZHtWXjEigd47iqtCequY7myZoRer2dDDO860wDYmpU8uviGe4OwvOdVdjFsrh
	 8WgJv7n2h/Oz2Rf0jvEz4tUyxDvDKy/bkS05BH9TW0E8HpmyuAOM2KWD9i7RTXgVp8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445466;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9+2mMwqVddPeL2aiYlDt195shdZrHemZKitjpFvASi8=;
	b=a91m8krq623TiKz/KX5vmddea0n+++ovdP1gBNYB2CRzwt2yiihdcHejDuXEklhpkCH6
	 XGkifOsEf81F/qMerLUkINgFgJGLZD2unYHE25hbVAnJorqckCR2oJWUmJglYwZ46V3l2
	 +Xtn5SZKNKCBcDq8iJcrIRnPV4PdnoIPxveu4bGK1svoPVz3KVEbnljbsRknFkIBxAlj2
	 PcyAuLWETR96UKgXSLEsYJ74IzFh57q1DWRDJnlpDr6cyHv9L1jEtqMQNx60f4A2KKE77
	 BlpNbciIQYKUadTPbckQuWlXr0ctwLmIRbgL74sMtrI42NQ4raBGXAUtagxHYCaeS8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XYkiRiZV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D344606A31A
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 14:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XYkiRiZV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2D41F000C0;
	Mon, 23 Nov 2026 14:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795445465;
	bh=9+2mMwqVddPeL2aiYlDt195shdZrHemZKitjpFvASi8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XYkiRiZVdzftrEQ1TyyersJTYx1+OZK0MrOjRS29YUADCnJlSG7XJ7mCV5R66sta/
	 0UQaKTRf4SDIoWCeVqXc7o/U78wyWmJFfystI1GUq5zMv79IPGAw47spb00dL46mMf
	 UImF5gsf7T1z5pDP8dvJ/c5nuKTg3HMLPYdgiri6rU3zehhuqbZWnJORjnlXnyNsLb
	 ir4GrORp5K1hgUk9bBi7ACTvpnQ/qt6aVfywgYgrKNAoZNGAEoUPxqe+zUrW3afWH0
	 pJCCQIDPV7X7mE9MKb2VY8QMbPPH6goiJ+nEmE6bp6n4ar0ry+lYz9tQOxj8Tieo0i
	 K3bdWDqdvm7Mw==
Message-ID: <sashiko-outbox-229446@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 1/2] crypto: ti - Add support for SHA224/256/384/512
 in DTHEv2 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "T Pratham" <t-pratham@ti.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>
Cc: "Sebin Francis" <sebin.francis@ti.com>, "Manorit Chawdhry" <m-chawdhry@ti.com>, "Vishal
 Mahaveer" <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>, linux-crypto@vger.kernel.org
In-Reply-To: <20261123142918.3451969-2-t-pratham@ti.com>
References: <20261123142918.3451969-1-t-pratham@ti.com>
 <20261123142918.3451969-2-t-pratham@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 14:51:05 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] crypto: ti - HZ passed as microsecond timeout to
  readl_relaxed_poll_timeout()
- [Low] crypto: ti - open-coded DMA callback assignment in
  dthe_hash_dma_start()
- [Low] crypto: ti - kernel-doc warnings from /** comments in
  dthev2-hash.c
--

commit 126808907819f62702aad01a36f54c290b6711fe
Author: T Pratham <t-pratham@ti.com>

crypto: ti - Add support for SHA224/256/384/512 in DTHEv2 driver

This commit adds ahash support for SHA224, SHA256, SHA384, and SHA512
using the DTHEv2 hashing engine and separates the AES and hash crypto
engine instances.

> diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2=
-common.h
> index f1b0396b322a0..8d243006d4dd2 100644
> --- a/drivers/crypto/ti/dthev2-common.h
> +++ b/drivers/crypto/ti/dthev2-common.h
> @@ -24,16 +25,28 @@
>  #include <linux/dmapool.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/io.h>
> +#include <linux/iopoll.h>
>  #include <linux/scatterlist.h>
> =20
>  #define DTHE_REG_SIZE		4
>  #define DTHE_DMA_TIMEOUT_MS	2000
> +#define DTHE_POLL_TIMEOUT_INTERVAL	HZ

[Severity: Medium]
Should DTHE_POLL_TIMEOUT_INTERVAL be defined in microseconds (such as
USEC_PER_SEC) instead of HZ?

dthe_hash_dma_start() and dthe_aead_read_tag() pass
DTHE_POLL_TIMEOUT_INTERVAL as the timeout_us argument to
readl_relaxed_poll_timeout(), which evaluates the timeout in microseconds
rather than jiffies.  A timeout of HZ microseconds (100 to 1000 us) can
cause spurious -ETIMEDOUT failures if the crypto engine worker thread is
preempted while polling for hardware completion.

[ ... ]

> diff --git a/drivers/crypto/ti/dthev2-hash.c b/drivers/crypto/ti/dthev2-h=
ash.c
> new file mode 100644
> index 0000000000000..ac6119e4e4d68
> --- /dev/null
> +++ b/drivers/crypto/ti/dthev2-hash.c

[ ... ]

> +static int dthe_hash_dma_start(struct ahash_request *req, struct scatter=
list *src,
> +			       int src_nents, size_t len)
> +{

[ ... ]

> +	desc_out =3D dmaengine_prep_slave_sg(dev_data->dma_sha_tx, src, mapped_=
nents,
> +					   DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +	if (!desc_out) {
> +		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
> +		ret =3D -EINVAL;
> +		goto hash_prep_err;
> +	}
> +
> +	desc_out->callback =3D dthe_hash_dma_in_callback;
> +	desc_out->callback_param =3D req;

[Severity: Low]
This isn't a bug, but should this use dmaengine_desc_set_callback() like
dthe_aes_run() does, instead of accessing desc_out->callback and
desc_out->callback_param directly?

[ ... ]

> +	/* Poll output ready status register */
> +	if (!ret)
> +		ret =3D readl_relaxed_poll_timeout(sha_base_reg + DTHE_P_HASH_IRQSTATU=
S, _status,
> +						 (_status & DTHE_HASH_IRQSTATUS_OP_READY),
> +						 0, DTHE_POLL_TIMEOUT_INTERVAL);
> +
> +	/**
> +	 * We need to read the output registers even in case of failure (ret !=
=3D 0) to clear
> +	 * them properly for future operations. But the function returning a no=
n-zero value
> +	 * should indicate that something went wrong and the result value shoul=
d not be used.
> +	 */

[Severity: Low]
This comment and a similar comment in dthe_hash_final() start with "/**"
instead of "/*", which causes scripts/kernel-doc warnings under W=3D1 build=
s.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123142918.3451=
969-1-t-pratham@ti.com?part=3D1

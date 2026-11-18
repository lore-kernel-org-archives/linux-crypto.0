Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794985380;
	b=x8rEh6LODlf68d/dK5kUAN+GbFOmUiUAohr+NQYTYrg/Kc+f3w1Ys6orJ67W/6BAR+YT
	 tmwtA3eigoW60bVBg9I1OFSdoub9cCADt7ldjQGf5nddumtdMffVhIFSek/FlOlxXg7aw
	 Srbgwusju3hyOnswbkJg7SSFLe1BlWJ5F+kM9P0L6H7hLroqkX5J2urYOwtTp23L+tLat
	 Ln3N8CvygCIq/6rLEa/cVukXYYRJt8Zl0CGjkA090vsvKtF3iU0sn2LI6sMUad028OxWu
	 FBP733backBA2ufHjSl8MXiBpI/0XTSs1UX/FajWXXaCx6I8aLefJNB1erPtIH1rHew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794985380;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SevIeu+mOjoRZRNZ4BNvAhnG6Y1Gdw64UBJT33ewGFI=;
	b=5C6puwEBnE+jp506y10doujs57POqNsblq3MHOdcpxgXR15OMcAC+Fk+0ZqJJHC5BzeH
	 UpXceIld0a7yxp8UZloP5YG4g4D39Htf+9JP8q8q0OUyg2RG8PB9Iq4/pKGTD+OtxdBQE
	 LQ3kOxcycxs4jX9WHu1bQ/ilz4Qdzm8ka7BkrKvXV2Oql1BbbW6+kawBpao+DZpDlXNzZ
	 BRjCyXq7KGSS2K9EKXCECgagySyjb/+H+UxMvaZcYnsTt1ujOSwv2WHEADj+bM1akHjJk
	 Z5vG8juGChytrVJl2HY0IyLiZ/E7E6wZTOjWoyNRIP1xGwb6IXQtoTVaBepgJQipglw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PB7TZHOZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B544606A325;
	Wed, 18 Nov 2026 07:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PB7TZHOZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789FE1F000C4;
	Wed, 18 Nov 2026 07:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794985380;
	bh=SevIeu+mOjoRZRNZ4BNvAhnG6Y1Gdw64UBJT33ewGFI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PB7TZHOZNXZSPEiE4U1pObmoZyB1q4y9hlUzRJyg7EucbCJ7R4b89pj9ugmAq4q//
	 uqc92JcgYQsbI+arPpiWjT+ABa2rgZ8bORkugRnkTfLSERRtK0wUGPpUfSjMz6uW7g
	 395Z8I7kKJmll17tFEI0NB2glyrmoO6zz5rXATWy2JVT0MkK7sydlS+S74ywruK6Qq
	 Mv6HUW2/q+b8IxtO5dSsvzYubZmu+QK3F7RZJDoBvNNd/dU1A5y1GL/MKEiyr2TOt7
	 GktbX57mJJlJB+7ikO0eoND0OUC3ILdMMJGpbuwy6ZUu+knIOwtrGPDXtLPx7k8Kvn
	 Y18KlwQZpbqlg==
Message-ID: <sashiko-outbox-220283@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v30 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pavitrakumar Managutte" <pavitrakumarm@vayavyalabs.com>, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org
Cc: krzk@kernel.org, conor+dt@kernel.org, ruud.derwig@gf.com, rbannerm@synopsys.com, manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com, nazim.khan@vayavyalabs.com
In-Reply-To: <20261118063504.835259-5-pavitrakumarm@vayavyalabs.com>
References: <20261118063504.835259-1-pavitrakumarm@vayavyalabs.com>
 <20261118063504.835259-5-pavitrakumarm@vayavyalabs.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 07:02:59 +0000
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
- [Medium] crypto: spacc: DMA buffer and DDT leak in
  spacc_xof_stringsize_autodetect()
--

commit 7f28b560104fe0765e17ef1a3786eb35ead09c4e
Author: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>

crypto: spacc - Add SPAcc Kconfig and Makefile

This commit adds the Kconfig and Makefile for the Synopsys DesignWare SPAcc
driver and hooks it into the crypto subsystem build.

[ ... ]

> diff --git a/drivers/crypto/dwc-spacc/Makefile b/drivers/crypto/dwc-spacc=
/Makefile
> new file mode 100644
> index 0000000000000..b7125a7797ba0
> --- /dev/null
> +++ b/drivers/crypto/dwc-spacc/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_CRYPTO_DEV_SPACC) +=3D snps-spacc.o
> +
> +snps-spacc-y :=3D spacc_hal.o spacc_core.o \
> +spacc_manager.o spacc_interrupt.o spacc_device.o

[Severity: Medium]
Does the err_timeout path in spacc_xof_stringsize_autodetect() leak the
coherent DMA buffer virt and the DDT entry ddt?

drivers/crypto/dwc-spacc/spacc_core.c:spacc_xof_stringsize_autodetect() {
	...
	virt =3D dma_alloc_coherent(spacc->dptr, SPACC_TEST_DMA_BUFF_SIZE,
				  &dma, GFP_KERNEL);
	...
	if (pdu_ddt_init(spacc->dptr, &ddt, 1)) {
		kfree(buf);
		dma_free_coherent(spacc->dptr, SPACC_TEST_DMA_BUFF_SIZE,
				  virt, dma);
		return -EIO;
	}
	...
			ret =3D spacc_wait_for_job_completion(spacc, virt,
							    md[alg], &match);
			if (ret)
				goto err_timeout;
	...
	kfree(buf);
	pdu_ddt_free(&ddt);
	dma_free_coherent(spacc->dptr, SPACC_TEST_DMA_BUFF_SIZE,
			  virt, dma);

	return spacc->config.string_size ? 0 : -ENODEV;

err_timeout:
	dev_err(spacc->dptr,
		"XOF autodetect job timed out, engine not responding\n");
	kfree(buf);
	return -ETIMEDOUT;
}

When spacc_wait_for_job_completion() times out during spacc_init(),
err_timeout only frees buf, omitting pdu_ddt_free(&ddt),
dma_free_coherent(), and the register cleanup done on the normal exit path.
The error unwind in spacc_init_device() then calls pdu_mem_deinit(), which
calls dma_pool_destroy(priv->ddt4_pool) while ddt.virt is still allocated
from that pool.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118063504.8352=
59-1-pavitrakumarm@vayavyalabs.com?part=3D4

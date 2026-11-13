Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553606;
	b=m4MeChPnJiDfPefX8bYXXvOf0KEVRgOFI2fS4mWPo/5pL0UuDbOoPlGt1hm7/t4LZQsK
	 Ifs90GkKUMSPUes4P1g7hCOMUQGQen1XNvVS6W1R24L6c/lmuc+ZVuU1EB6fV8MneDtBT
	 fwyi6hmQ8EJxYqbDrViuzMntfLnKqG+rKb7PW0iKAgv0mwH9eqkuxnYUPXrQiejUOqGAW
	 iKOt+czW808vimpBRBSYNRmTzUVD6tXF+9FH2o2LQqu3eIvJSwrgv3o/+wgqI+W19iFvP
	 Z3wgk6BNMCXMyF7Ih151xd7G6LgWdsqT5096nxDI9LjFG4+JKBWjMiA4y6XIREAWSnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553606;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3TV3g7zOfu7fkK5ZmgtZwz4OduUzKXxvMiSwi+P8bIk=;
	b=XBRFmg4I/n66sddQHU+VqMNzMMTALZSp4iVzgqytuj4iPQAaMvnKQ2rHcPxTUs+7vPa9
	 5VXMPyChhbxHMJLLPG/ffcToz4FIhbWS9i5I0l6Q01AvE+isJ8/4TZOxkz9qKBAYhFV0/
	 Vx8Fka6QTOdZ2zCAElwhC3fBMvxrqywbPvCOrTlPTk68+ZhVBzzfw8bDzxWTM2dYjM5yX
	 F8epInpnxQO7zjG2nxnKWsVvqeoDnRbaQmbZpTLjQUuFVw+NBkUWF+W4Bz+vMQ24/zo+M
	 6N2Ez+9MyyovWWjwLjdbSyVcFB7G+Z0blGDIOpua9vUzPadUA4GuDWs8bqtrJO5NKdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxR4GfYP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158C3606A321
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 07:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxR4GfYP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C681F000C4;
	Fri, 13 Nov 2026 07:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794553605;
	bh=3TV3g7zOfu7fkK5ZmgtZwz4OduUzKXxvMiSwi+P8bIk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IxR4GfYPmS5xe5erzJMqR/+DAmmB5XrHzPMSsPhqNwz6K1l55Ekfx9T9Ijd/4H+Sb
	 0Tl9d+1MWaUiZkaTkbO4zrOOf/2yPvAJ5lDB3nYcFprpGjBa6CSTgAQAx4TwU3sGkh
	 EwM6jg8kAM6+USt4MR6ulhJLAVpUifP64tHBGGzgjEd5aKfejroIitszKd9e5KouB2
	 LaNs+sTkKYCdzGFrjw2DhaVOX0hMospf4eugSYtyapXMnHFflhbAbR9L3aH7AG2x9f
	 qvUOtuz/CKlppkVdLdMIezGWLhluJD73MnljhDaqY+JQGwJT/EWvyS2wGUdAcgJ2qo
	 FRdkJsR3hJ9gw==
Message-ID: <sashiko-outbox-212317@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/7] crypto: qce - fix memory leak of the CCM AAD
 buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: ZhaoJinming <zhaojinming@uniontech.com>, "Bartosz Golaszewski" <brgl@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Thara
 Gopinath" <thara.gopinath@linaro.org>
Cc: linux-crypto@vger.kernel.org, "Eric Biggers" <ebiggers@kernel.org>, "Bartosz
 Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>
In-Reply-To: <20261113-fix-qce-ccm-adata-leak-v2-2-914501377a62@uniontech.com>
References: <20261113-fix-qce-ccm-adata-leak-v2-0-914501377a62@uniontech.com>
 <20261113-fix-qce-ccm-adata-leak-v2-2-914501377a62@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:06:44 +0000
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
- [High] crypto: qce: single-word name in Signed-off-by trailer
--

commit 8b5fc4cf5bc1b9c0817753d0bd63aca7091e3300
Author: ZhaoJinming <zhaojinming@uniontech.com>

> crypto: qce - fix memory leak of the CCM AAD buffer
>
> qce_aead_ccm_prepare_buf_assoclen() allocates rctx->adata with kzalloc()
> for every CCM request that carries associated data, but the buffer is
> never freed: qce_aead_done() releases only the scatterlist tables, and
> none of the error paths release it either.  Every such request therefore
> leaks a small allocation.
>
> Free rctx->adata in the completion handler and on all error paths: the
> sg_copy_to_buffer() and sg_alloc_table() failures in
> qce_aead_ccm_prepare_buf_assoclen() (through the new err_free_adata
> label) and the error cleanup of qce_aead_async_req_handle().
>
> The buffer is referenced by a scatterlist that is DMA-mapped, so it is
> freed only after dma_unmap_sg() has run.  The frees are guarded the same
> way as the surrounding sg_free_table() calls, so no path frees the
> buffer twice or frees a stale pointer.
>
> Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
> Reported-by: Eric Biggers <ebiggers@kernel.org>
> Link: https://lore.kernel.org/linux-crypto/20260723183438.GB93534@quark/
> Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>

[Severity: High]
Should the Author and Signed-off-by lines separate the given name and
family name with a space (e.g., "Zhao Jinming" or "Jinming Zhao") instead
of using the single word "ZhaoJinming", as required by the Developer's
Certificate of Origin in Documentation/process/submitting-patches.rst?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-fix-qce-cc=
m-adata-leak-v2-0-914501377a62@uniontech.com?part=3D2

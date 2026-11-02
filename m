Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640855;
	b=U30MNV6SFjnEcZ2mqDy1gOxWZjkwW13T8vuhQJCu6oGE9Ls85jrXW9aFLejMUyBTRqcp
	 UllFCf92xzr7TxBMuhjhecEzo1F6bjrszH83mOkaIMCCvWaTsl6uhUvylcDLExcACEUty
	 0hMQQALSI86hCcKdD4zdWU2UWOd3hhAV9LDAgP9Dk/1mjkipS7tJpf8K5OSbiH7FE8AKr
	 4gVzS4i88beoQrWZq8pr1DrJ2Sj/WhKTJ51U4GgcKjKwZwNM6F7dFm3KFYiR+awlExQhc
	 YJUphhFipOe7ByE9oEDxU8uzyw4Wx5h3+VT5zL6E6FxKGxaOKXIrb5nOyPL8qNFp1wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640855;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XSPCp+WIcHbdpqO5iyoSucAVoJTXBn3u+PbDuncVOEI=;
	b=mlNLLqkSB/7ER61UcMasp2s4A1oE7sEj5bRWjHQbCnwLT1fWH/8FuC8jv/SPz4JgjZa6
	 S05Kxb+vJaqKq77NaltJUSDKT5sMuzfyplvsRhAVu3SHPio/OtILRjg/OPLBh+9MYr2wr
	 MeEsxnnN86+Ytn7klp2HR1f0wxUkf7O55wiD1PpwrxrfJvGJrC4foLbwxcDIJ4QYFasAS
	 53nRSnN/a3/VlxosHlrr5BWtlbL65//WPD5jUrk1tW4Y3E/N6bK7pSfBZZcDPGooBKJhf
	 gBhWl4LJ7eLt142d1KQrOYKWyygHk5DfbbSmoZfutoEbmP7ZhOblbt8fnAqYXomT8fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="boGGx8/S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2593606C3FB;
	Mon,  2 Nov 2026 17:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=boGGx8/S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52571F00A16;
	Mon,  2 Nov 2026 17:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793640854;
	bh=XSPCp+WIcHbdpqO5iyoSucAVoJTXBn3u+PbDuncVOEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=boGGx8/SSCrZHnJH6HokzRuuYeNmfCfWN6e7hNmfmHRo0cfCQb+W5zOEJ3PoC2dSy
	 3wTaRM1IRiygAzVdUoIb+/L1wZ8lkaKAZ/gmNIuiKUePK8+6FOyfAvjbKJbWiUllct
	 MvJTD4zwtcDkwREOWFWBk1rR4p6zrFov4skl6TlvbkTq6Bjepcx4FlkYFiyBQxzRtW
	 vlUOgz1Zf5EH+chkGPr4uCb4oJTR+SizKci10BmQ09OR+ImPTrfLFdIJ4fckAJRXza
	 UrnHrZTNXd9VS1+cQHSFFzBYFn8R27tGVDe4VhGU6SwuVqbuECKLhMaaC0B7xy8kYG
	 XbY7HjMPxEzyg==
Date: Mon, 2 Nov 2026 18:34:05 +0100
From: Thorsten Blum <blum@kernel.org>
To: Frank.Li@oss.nxp.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	T Pratham <t-pratham@ti.com>, Frank Li <Frank.Li@nxp.com>,
	Pan Chuang <panchuang@vivo.com>,
	Maxime =?iso-8859-1?Q?M=E9r=E9?= <maxime.mere@foss.st.com>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	"moderated list:ARM/Microchip (AT91) SoC support" <linux-arm-kernel@lists.infradead.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:QUALCOMM CRYPTO DRIVERS" <linux-arm-msm@vger.kernel.org>,
	"moderated list:ARM/STM32 ARCHITECTURE" <linux-stm32@st-md-mailman.stormreply.com>,
	imx@lists.linux.dev, vkoul@kernel.org
Subject: Re: [PATCH 1/1] crypto: use dmaengine_desc_set_callback()
Message-ID: <aujJjW1ploEzmcZ4@kernel.org>
References: <20261102164538.3834039-1-Frank.Li@oss.nxp.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102164538.3834039-1-Frank.Li@oss.nxp.com>

Hi Frank,

On Mon, Nov 02, 2026 at 11:45:30AM -0500, Frank.Li@oss.nxp.com wrote:
> From: Frank Li <Frank.Li@nxp.com>
> 
> Replace open-coded assignments to callback and callback_param fields
> of struct dma_async_tx_descriptor with calls to the
> dmaengine_desc_set_callback() helper across various crypto drivers.
> 
> No functional change intended. Prepare make to struct
                                         ^^^^^^^ to make?

> dma_async_tx_descriptor private to the DMA engine.
> 
> Signed-off-by: Frank Li <Frank.Li@nxp.com>
> ---
>  drivers/crypto/atmel-aes.c            | 3 +--
>  drivers/crypto/atmel-sha.c            | 6 ++----
>  drivers/crypto/atmel-tdes.c           | 3 +--
>  drivers/crypto/img-hash.c             | 3 +--
>  drivers/crypto/omap-aes.c             | 8 +++-----
>  drivers/crypto/omap-des.c             | 5 ++---
>  drivers/crypto/omap-sham.c            | 3 +--
>  drivers/crypto/qce/dma.c              | 3 +--
>  drivers/crypto/sa2ul.c                | 3 +--
>  drivers/crypto/starfive/jh7110-aes.c  | 3 +--
>  drivers/crypto/starfive/jh7110-hash.c | 3 +--
>  drivers/crypto/stm32/stm32-cryp.c     | 9 +++------
>  drivers/crypto/stm32/stm32-hash.c     | 3 +--
>  drivers/crypto/ti/dthev2-aes.c        | 9 +++------
>  14 files changed, 22 insertions(+), 42 deletions(-)

Reviewed-by: Thorsten Blum <blum@kernel.org>

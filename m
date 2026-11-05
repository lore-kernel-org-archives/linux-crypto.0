Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793866584;
	b=G877EUFJWXsT/sWXysSdhl0SVHkbmc8ap9YMbIUFXzjsBSZ8D6UFGhNQZgrbI+H6tWKh
	 Nf5/NB18Q/ex87r7uoCsfd2n7o9T9ZpGrZ+iidhT34VhuqxczcClrLjFn+meQvOn64+Oy
	 B9q3PzdpfOW5b+3zO50NKvmYtxrdYeBC1XKSyuGo52PYzyfJtizT4VoxvaC13LCBiDgof
	 9ktvjSwLdiWGU76C5Os2tfd8VXfkKHY8bY+8iLGDlFRX0v5fToeuT3Lz9zFINTREJ2YF0
	 BpgJ3V6bsoSBlWYMuL0qIqrWaDGXkMPw/LBHh1D+oZg5FO/Lbn4MUQjd78QsX6/cj1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793866584;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=aCqimnZwAFGyowHxGlAlEMRT7cLaOWAjaF+PQzroRbY=;
	b=KMq4lWrNSOrIBt5NW5PElkrS9WsbCO7Z0ed7K0nneewt7jFfQAShaFVKQ3fYlemUIs+K
	 l/ayFruQu5TWnTsQ148/Qw4r4SiotJZzK2xDgjk9oEBmf/SYnPFIaNXdcPzXewgSYaEe6
	 H7gy8zTVsxpWldNBDlXir7uyogxCi45nvUIdbPbDZ45+XkqVJXEbICUk+N5dohrsJWhry
	 YvSzdJKO8ZG3FkM3wHTWHh7YgTnl7wYWRMhaJF866ZF8WYcOK5JLFyjTuVO6vNuY2QWDX
	 NRg3rhMgfdF46XTecWYvaewBdBsxWMk+4ZtWG++G/yYzpfXHORsNOOn0N2QeBUvlw2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4HEJQmN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 64AA6606A31B;
	Thu,  5 Nov 2026 08:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4HEJQmN
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2CC5D1F000C1;
	Thu,  5 Nov 2026 08:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793866584;
	bh=aCqimnZwAFGyowHxGlAlEMRT7cLaOWAjaF+PQzroRbY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P4HEJQmNW8JflOOJimMB1ufM60UtpVCT7i2H/JZMGolOesBwaicWwAoP+7XGeRUx5
	 n4pPm2NgpYFgl8xhRPdq+GZqMLRk74kHgespXBg6iXwzQb/OovDkVOjTiLOT5dKzCW
	 5e4JBWrs+16xt47L/Yx1qP16aZzUmeK2tyMet7MZUXIu9Kqxo1BNokGAgfkW+j2Fb6
	 aOdOYy7K5Gsr30p32CUrIqdzpn+4AkzBT8527s1M2AwcbIIXYNNNSVqAooQ0yb92MA
	 zJubGfq3ZRff9+jBPiN9WAJSSv0PJ2vk42DibQp6jsKIZq4E7ba0K1e/fB/1DHAii9
	 abufRnmE2Ff0Q==
Date: Thu, 5 Nov 2026 09:16:16 +0100
From: Bartosz Golaszewski <brgl@kernel.org>
To: Frank.Li@oss.nxp.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	Jia Jie Ho <jiajie.ho@starfivetech.com>, William Qiu <william.qiu@starfivetech.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	T Pratham <t-pratham@ti.com>, Thorsten Blum <blum@kernel.org>, Frank Li <Frank.Li@nxp.com>, 
	Pan Chuang <panchuang@vivo.com>, Maxime =?utf-8?B?TcOpcsOp?= <maxime.mere@foss.st.com>, 
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>, 
	"moderated list:ARM/Microchip (AT91) SoC support" <linux-arm-kernel@lists.infradead.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:QUALCOMM CRYPTO DRIVERS" <linux-arm-msm@vger.kernel.org>, 
	"moderated list:ARM/STM32 ARCHITECTURE" <linux-stm32@st-md-mailman.stormreply.com>, imx@lists.linux.dev, vkoul@kernel.org
Subject: Re: [PATCH 1/1] crypto: use dmaengine_desc_set_callback()
Message-ID: <rbrhsoidlozxq3fjrnoeqf6ehb75fmbs7tv7de6dehocc4thxi@5sfhcuwuda3o>
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

On Mon, Nov 02, 2026 at 11:45:30AM -0500, Frank.Li@oss.nxp.com wrote:
> From: Frank Li <Frank.Li@nxp.com>
> 
> Replace open-coded assignments to callback and callback_param fields
> of struct dma_async_tx_descriptor with calls to the
> dmaengine_desc_set_callback() helper across various crypto drivers.
> 
> No functional change intended. Prepare make to struct
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

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com> # QCE

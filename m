Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793708915;
	b=BFEHJT17tRnjg/Nh/4YFArO53bXnB1COBO4IeyQkB12YVaJ2bCB2m5aKssX8AKY+w9oH
	 AU/yvsFYsRA487/+FV2USbLHVVGwU4PK/lvSbntf8teh3A0e75Saq3BEQiBnpplJEdJ/F
	 66NPJCKQOQ9Xiz5LebwRwKuN/SnZEyFEKskevgyJbA/l2qNCtJerCGcGq1qFZslaDziY2
	 IKdoCKHwN/F6qSQaA8T1G9+Q/VL1oTQQO5QinBocjrHqNoz9pJSoUvb7ZyeADZoAs8phx
	 T8Q1/O4h+2gidt6/0A9p0jdTgM3yut9cgsidgfQxRfQBmR9ChI3SrBoChjn3+jL/mXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793708915;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=tzXxdVEyLXVO2/FV72+l5Df+V+BelTThZGSFGoey7bI=;
	b=EVwVCfdFGgmNQ/0mhAtpIzsDumo4wB6Pygn9IVumurmamAiLuOCvyB5ZbZojPXsRjdOn
	 nzK7O/qSJQPM0CHFTLKIafBOsDXI1dBeP84AOEsz0R5N8wNjLf4QqbYKuBOFwjAzsAkyT
	 DdgiPkDseGaAOLeMfNvpUd1hbIg9ULk3CEpr9/ulLKHgeapRCbV296KyKZCtDBeZX0IJd
	 Lg9w09tPa2Kbn3b0rcfN9EO7ff7jV8cMRxqx4HvG/GaP1HwZlAEOX5PABNp3i2v9XmBSj
	 fOU4x5UYXTZcyJsMRshlFncIvesGKINU77WTFjemHGaoZZ3uTn0mrmbjv42ABnHGt1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzz3Dc8e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id AEB70606A324;
	Tue,  3 Nov 2026 12:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzz3Dc8e
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C06101F000C1;
	Tue,  3 Nov 2026 12:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793708914;
	bh=tzXxdVEyLXVO2/FV72+l5Df+V+BelTThZGSFGoey7bI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gzz3Dc8eQN7SGupVnRsWtaQfdhOfTHCRgsu8krzfPuhn70ZtBNbQy3vEPEPTvyeqk
	 dHSSzy05TO4trP+bPXcvYWlP3Tom+tRRxh4tevtlcx10WNdE8wg61ka8obdu+MHXPD
	 xHycSxCsVorPtyQErm0fAg2zqcEJ1/xZBupOqfBQ1khKizhTCpFsoBeU/Ol5uOVaEJ
	 mEnui+LUdHKOgIDMrQ1QM8NJlcYfdUA9d97l4k3UVWK6duBjU70+41HPmRmN1RMtox
	 jrAsM3Jm7Hj2YEX+cvHEaWEjxE+r/5Kw0/3IxXbVaTG3F3UosyklUFbKjgEubWLpIe
	 eTraP5kbPULnQ==
Date: Tue, 3 Nov 2026 13:28:31 +0100
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
Message-ID: <7fhjiip7dupqjf4rgdhz4sh3hkjr6gibbxftnmkxq5ihq5orm4@wfalqdnrwkei>
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
 
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

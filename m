Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575112;
	b=dpOP7LJ4wQG2sq5uAtdAPcK44GdFXT4+Ro0xS7bOAlYfgI8ymFhFzQ6l2PxFymqy6oDM
	 6s37wgvP3VWPPbPjnVOqgLqx4GiJ16aM7z8kcyXis8Z5rW1Wk/kYTsxG6Jz9hf69qIT7L
	 RoxHDB1MM5uuH3qJFO9lccHOSywUNWNymKEbMo43iaQkesMCYajJYhvAoM5U51AewbQhj
	 f0Sn8zO+cBY2Me/u+kiRQbyiExkGNFPu+4/RJwEcnt64c9JVvt4j/gnG7o+TUXuEyKYyI
	 XTa4Qti966gp9/bfdOhgvfwfUBHkaen/VnJm7BPYw4IxI2UAL/p1wo2JbomtHq9GmsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575112;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=sBw3P7XEecuUSrnOX7EuT/qRSUKWDAXXiFgzDBf5980=;
	b=ax4mn1jRqzxQkNGiwLOFyhQahZLWqtZGtWqDH5MqFJtWRHWJdxJu3VG6rD7xyLZJyI50
	 Zy2Pg15DAPe25w1Ju7qFIJopGpt4/9Qgdh2IsvSV0nBtlqgNYC3/ktY1s/dQj5+QE0jUF
	 ksm4baQlJBNu6B36mfe5tgLF3S0gstfj6p3CxwnIcb0damz7AhcAAw/2oDbObuNxdIeA2
	 +412Dv/zGR1ZJTnlh4EhDdQVydZC3mWPnrEw6UHt9ri+O0zUaSo38toqnIArYV1HjCeip
	 pOR4sEH4JX1lCZy+t5dFBvyFU9Q8/y8h+ONufWVHLKnFoCq/x9QnTcLzJoDvik9OtBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=BG6GxORi;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47819606A88F;
	Fri, 13 Nov 2026 13:05:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47819606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=BG6GxORi
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=sBw3P7XEecuUSrnOX7EuT/qRSUKWDAXXiFgzDBf5980=; 
	b=BG6GxORi3Hgn6fmiF3iJoLXnALrcRu7/DWSuWkLSjwtM14z1LDCE9Pk+ohHHk7Rw3LKZ6mI6G9o
	vLbHQV1Dg3af3NiYd5QQpUFvjTVoz+W9pHNiX8eA531UB4Gu4oxChZRqjaMrqpmYCFI9lDTIxa7i/
	IDPl+d6U6zkc5sMVwafPfqRM4zeeqZIECnDDJ4gQIDsC/OcYv7Y29VsS4EWmtT3GYFgSQhLYQ9k7m
	HTEhtyrfTmMVgrXiqaB5B9CpIkkf6E5oIvC79IjGm/g2jLc5gTFI9Q+lP7bZlY5EIYEBknZm4oCDK
	jaICX6gwvaTmuWHOrMgW2evLXVqir8trjFwg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqxO-0000000EfDG-00ou;
	Fri, 13 Nov 2026 21:04:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:04:41 +0800
Date: Fri, 13 Nov 2026 21:04:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Frank.Li@oss.nxp.com
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	T Pratham <t-pratham@ti.com>, Thorsten Blum <blum@kernel.org>,
	Frank Li <Frank.Li@nxp.com>, Pan Chuang <panchuang@vivo.com>,
	Maxime =?iso-8859-1?Q?M=E9r=E9?= <maxime.mere@foss.st.com>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	"moderated list:ARM/Microchip (AT91) SoC support" <linux-arm-kernel@lists.infradead.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:QUALCOMM CRYPTO DRIVERS" <linux-arm-msm@vger.kernel.org>,
	"moderated list:ARM/STM32 ARCHITECTURE" <linux-stm32@st-md-mailman.stormreply.com>,
	imx@lists.linux.dev, vkoul@kernel.org
Subject: Re: [PATCH 1/1] crypto: use dmaengine_desc_set_callback()
Message-ID: <avcK6e1eMqcyW66R@gondor.apana.org.au>
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
>  drivers/crypto/sa2ul.c                | 3 +--
>  drivers/crypto/starfive/jh7110-aes.c  | 3 +--
>  drivers/crypto/starfive/jh7110-hash.c | 3 +--
>  drivers/crypto/stm32/stm32-cryp.c     | 9 +++------
>  drivers/crypto/stm32/stm32-hash.c     | 3 +--
>  drivers/crypto/ti/dthev2-aes.c        | 9 +++------
>  14 files changed, 22 insertions(+), 42 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

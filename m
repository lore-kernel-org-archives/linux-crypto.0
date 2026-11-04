Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814681;
	b=c2cCMtLSJONPoSLhq53se+jj8WKGz5Ropk/OQlKwSeD9yz9RX5Tgvfldh6ozXoSGBOa1
	 fKqTIdY64Qp9sixKqNJx73zmQ5tQ/279OzUjdXTSuapfcVPunno2wvQ3oODLBdT5GSoep
	 mtBu03Ak130YsXh2JIwtjZgoL4TDQPXAx7p6+wgOor7kS2FoVNAr+PvrltUIJOjVzydJ1
	 67bpterV7s8nLJozy+3vOJLqQEV2QyNI0WhgHMmhx6NDPAviABeDkS1nUcGilzYd3jj4q
	 vvlN06U3S05kiI1dA2ouqojyAx7rzMRs3y5WcDyrYzT9wGxeCZRhM98ASUTdmzF5FnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814681;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=d5VQc0NVFmwQmNrNgit0f6JDQ4FL4SdVcOTRhJBmZU0=;
	b=r06EWv7UQ1OX27OgDiRIV7efg11BRrVP7u5j7WKCax3pAwTXaQhFZvmzLVd1/EdWhqDG
	 K9RJapW3EhoytFSLZGNCWxykk8HniJRzpmZnsPsm92y/CKRMeWmTp7dMAcVKbWUJz3r6w
	 CxEq6KzzbE6+TRMLDns/O5j8jrb2F63XcJXNZjWDeVIrf1PeI0ZAa+uBqGxV+v5YChSPS
	 WEpwCIoUyP+kLNIkWLlzcuIy5oZf9exKSqsw7QcZ/zWfIZg356PUKwBQKLB/UA5G1TSl4
	 9zA35ex91NZEFGY2MaV0+2aXWiuS+jZlaN/7sfAdplx1QLry1ZmHDU4LuKKN37hXeMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dCLagkxm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DD9606A68D;
	Wed,  4 Nov 2026 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dCLagkxm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB281F000C1;
	Wed,  4 Nov 2026 17:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814681;
	bh=d5VQc0NVFmwQmNrNgit0f6JDQ4FL4SdVcOTRhJBmZU0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dCLagkxmbIiyQGkMFzHs2oA8HlsKSAEJaJgVuwRlOocY030r7PqqFX3dkeMyvO3QN
	 qX0NTOgKw+QgB3nagHSQpZ4EaTADuqeNdSvV5C+1qY5yaM5/vHtK+M4bzdQ/+2xoUw
	 2q24Wkv0uvhKpkSzpaudI8n9BNlYEulgt2ubBJyxtPsk3APA4fQeWe485Ih6Kai230
	 OwWVx83G3fcgygwH6WSC/Dn5qg8PF1rRzHX9WDqHksPLHzQ8Mgx6sj7ks3dtQQ8kyK
	 Dar7lTXCYLGHAE8GzVImwxRqNQebyXdlO7UBR6CNJgE2H9+wfnCaPvw3J3NW+6uoTx
	 jkNNN/jBvlWCA==
Message-ID: <7b476c24-3185-49ff-9a72-fbd865dc0d65@kernel.org>
Date: Wed, 4 Nov 2026 18:51:10 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] crypto: use dmaengine_desc_set_callback()
To: Frank.Li@oss.nxp.com, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Nicolas Ferre <nicolas.ferre@microchip.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Claudiu Beznea <claudiu.beznea@tuxon.dev>,
 Bartosz Golaszewski <brgl@kernel.org>,
 Jia Jie Ho <jiajie.ho@starfivetech.com>,
 William Qiu <william.qiu@starfivetech.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>, T Pratham
 <t-pratham@ti.com>, Thorsten Blum <blum@kernel.org>,
 Frank Li <Frank.Li@nxp.com>, Pan Chuang <panchuang@vivo.com>,
 =?UTF-8?B?TWF4aW1lIE3DqXLDqQ==?= <maxime.mere@foss.st.com>,
 "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
 "moderated list:ARM/Microchip (AT91) SoC support"
 <linux-arm-kernel@lists.infradead.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:QUALCOMM CRYPTO DRIVERS" <linux-arm-msm@vger.kernel.org>,
 "moderated list:ARM/STM32 ARCHITECTURE"
 <linux-stm32@st-md-mailman.stormreply.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: imx@lists.linux.dev, vkoul@kernel.org
References: <20261102164538.3834039-1-Frank.Li@oss.nxp.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20261102164538.3834039-1-Frank.Li@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/11/2026 17:45, Frank.Li@oss.nxp.com wrote:
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
> 
> diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
> index 84392411b98d8..49f1bf19747d8 100644
> --- a/drivers/crypto/atmel-aes.c
> +++ b/drivers/crypto/atmel-aes.c
> @@ -824,8 +824,7 @@ static int atmel_aes_dma_transfer_start(struct atmel_aes_dev *dd,
>  	if (!desc)
>  		return -ENOMEM;
>  
> -	desc->callback = callback;
> -	desc->callback_param = dd;
> +	dmaengine_desc_set_callback(desc, callback, NULL, dd);
>  	dmaengine_submit(desc);
>  	dma_async_issue_pending(dma->chan);
>  

Apparently reviewing only a few lines of entire patch is still reviewing:
https://lore.kernel.org/all/9e39502a-dd17-4fa2-98a3-9019523cb5e8@kernel.org/

Therefore:
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof


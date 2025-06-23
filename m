Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3607C24468A;
	Mon, 23 Jun 2025 10:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750675341; cv=none; b=NcPsjO1KwcGcMkmDxU2Mn7UGZ3UWQYs5VL7zfQPSzoKn/97N6mWWlXUkzwF7yLekW45E3B1k2fY5dHK8IG9VWpneLJiflJw9AA49JKqDiuqE/2ZR4nZq7vW9BLVjLMPc/3B5LqRAevA0sW64HaFcnqUrF14LVTOh77ZvxyXaOzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750675341; c=relaxed/simple;
	bh=l931bTX5MDMkwV6ZzTaGAigtZpZ8cMxO2lXHTUUf198=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rrTYbqjn8fjujjDqWtLUsBqZEBs8q/Juj3C+qpsX9lKzoTuliu6Gq70PrzlvQbVZG71wxz2ZHS1fansHdzJv01VJv9x9W9yODnEwxbGM1M1Kss1JY2VbHpX7v2dAvBHFSqcurEKwrnYW/BfuzQYMBMd0gYAQUzpIORh6gFjhtG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C3R9Dd9S; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C3R9Dd9S"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ad89c32a7b5so652406866b.2;
        Mon, 23 Jun 2025 03:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750675337; x=1751280137; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Yw6imxd4BTDTWrkr9aN2QlmFrVCvg38lQ/oem6/zBU=;
        b=C3R9Dd9S1iFYWKRJ577v3wxWopK2h+mwxqGU0NWxLlhLSVkzm0mS+3eE9Vq8GPULmL
         MVO5tu9RUe4IU4wcoRg+ayut5PopPQhOezUUmNIhZE0HwnjTspOxMKs3v2u2+dTx0f4v
         LVYv4ohW7L126OFDJZjXtU1UhklFmkcl/VCEw8asNfHKKf70/M+vfVjr2xird1P7yFKG
         5O7ZkI4obnvUb2ziE3wNEITFi1pUSJbm+wHN+x1WL8mrcSi3eQ4bBWVWJpGMLQ6ZA1DB
         yf2PCEX1Zo3naYmejzFqfecuPiQv5ASXP9djBC/Bs+MikJt+rDoaukoOH1Tj4p6GUfBH
         rIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750675337; x=1751280137;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Yw6imxd4BTDTWrkr9aN2QlmFrVCvg38lQ/oem6/zBU=;
        b=tD2u8ngwR7moyU+GkJ+W8ZhfzHFbdPzvgdO9UjTj7QnrqGO26BSBPLNO+nnQDm8vWZ
         fuwvFsVBZiItvgzehkw0e1s9lAH4GntGceYQ5Oyfo3lR9kRSQUX32LhO7yxXe14WNeTX
         182hLpFeNxI1i3TSVDoGJ4AN7nj3KSUwC/VQYLVouuumdBG3YxsShIMLUdD1l3+vELMz
         6lvi325cPjoZaNrVig6NeG7LrMf8DxJ35tmm+y27VbhBh6W2RA5EcYeVkNCNnW3RvrRv
         Ly1gVwI49CUH0M9mm771yS4o/fLNKjqtS2dXd5xOp7cZBBWfh7WAVUSmZm1lLEb8/xng
         hnPQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6CmKln5lma4tJNCqQx6ad0GdQQEQZdY/AYPCmMGay46VCOCpbPYlfZZa8iS5WWrQZ/NcU3fyGq//KJe3H@vger.kernel.org, AJvYcCVKTZ1/HOogqqWrOzbs8U8Fe+M1eaaul/LaCR71lhpwGodUNDggPFJGRhaAjmX+uJlzC1VjITEtje0YoMs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye7pGylcKyQMCCD09jOHg6SyrH3XQ4rw0Me9Hx2AAWPrUqz3MH
	NHF8dtC25ul9IP8hAFzvzNUkYUr3Ef9rVrhu+sUkrtCCQB/5YVRz0nWC
X-Gm-Gg: ASbGncsbCOEOu9CBRWTfpG4nA/rHnwsgi/Uu1VxVV8uYqE/n0f0JFECczMjVQTee9kT
	mpsiYg5DKezc11NryI/lW9e434YyJ/zBiNMWTCsysxG2SduvF3ZkVMeA/4Y8UpAprQ807+y+Nq6
	WoIFk/haz6Q4/NC0HTV+L6vqVFCsaG+hYAsAiH5yz/3hoSYlRzk42FWsQWxY03/y58x7rrczwy0
	JsGELfP+u+zoTzVKfBjomVSeE+8Vlpt1gzZB0AgWQuJwOSrVbMOFbatuJ0+O2bcWWXOVxu4pOiX
	V8fPMItEOfo9h+lJWKH2TFDUepvpyHPmYHXc45sN389c/HbuXXk69hFDn2W0mdk3+rhpetfKaU4
	vse0clyRaFrOm1PCZEAwK5VIWLUgd1ehc07eVUGTZ57CW6To=
X-Google-Smtp-Source: AGHT+IEfNTyPHjwPJEzLQfQoS55yQsLH7CzoYZynUgBsxDONAr3ULxD/B75b39rL0u4RhOVhHN1eXA==
X-Received: by 2002:a17:906:6a1a:b0:ad2:1cd6:aacf with SMTP id a640c23a62f3a-ae057c0d793mr1084866966b.47.1750675337254;
        Mon, 23 Jun 2025 03:42:17 -0700 (PDT)
Received: from ?IPV6:2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069? ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae0541b6894sm687693066b.111.2025.06.23.03.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 03:42:16 -0700 (PDT)
Message-ID: <0b963009-85fe-473a-a65b-6b427bee98c5@gmail.com>
Date: Mon, 23 Jun 2025 13:42:15 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: sun8i-ce: Fix `dma_unmap_sg()` nents value
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Chen-Yu Tsai <wens@csie.org>,
 Jernej Skrabec <jernej.skrabec@gmail.com>,
 Samuel Holland <samuel@sholland.org>, Andre Przywara
 <andre.przywara@arm.com>, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250623091009.65436-2-fourier.thomas@gmail.com>
Content-Language: en-US
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
In-Reply-To: <20250623091009.65436-2-fourier.thomas@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Thomas,

On 6/23/25 12:10 PM, Thomas Fourier wrote:
> The `dma_unmap_sg()` functions should be called with the same nents as the
> `dma_map_sg()`, not the value the map function returned.
> 

This should already be fixed by:
https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=b6cd3cfb5afe49952f8f6be947aeeca9ba0faebb

The sg nents are saved to request context during prepare() and then used
in unprepare().

Thanks,
Ovidiu

> Fixes: 0605fa0f7826 ("crypto: sun8i-ce - split into prepare/run/unprepare")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> index f9cf00d690e2..ce9d071f5693 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> @@ -326,8 +326,8 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
>  	struct sun8i_ce_flow *chan;
>  	struct ce_task *cet;
>  	unsigned int ivsize, offset;
> -	int nr_sgs = rctx->nr_sgs;
> -	int nr_sgd = rctx->nr_sgd;
> +	int ns = sg_nents_for_len(areq->src, areq->cryptlen);
> +	int nd = sg_nents_for_len(areq->dst, areq->cryptlen);
>  	int flow;
>  
>  	flow = rctx->flow;
> @@ -336,11 +336,11 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
>  	ivsize = crypto_skcipher_ivsize(tfm);
>  
>  	if (areq->src == areq->dst) {
> -		dma_unmap_sg(ce->dev, areq->src, nr_sgs, DMA_BIDIRECTIONAL);
> +		dma_unmap_sg(ce->dev, areq->src, ns, DMA_BIDIRECTIONAL);
>  	} else {
> -		if (nr_sgs > 0)
> -			dma_unmap_sg(ce->dev, areq->src, nr_sgs, DMA_TO_DEVICE);
> -		dma_unmap_sg(ce->dev, areq->dst, nr_sgd, DMA_FROM_DEVICE);
> +		if (rctx->nr_sgs > 0)
> +			dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
> +		dma_unmap_sg(ce->dev, areq->dst, nd, DMA_FROM_DEVICE);
>  	}
>  
>  	if (areq->iv && ivsize > 0) {


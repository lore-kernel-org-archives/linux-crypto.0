Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2901E21D018;
	Tue,  8 Jul 2025 18:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751999806; cv=none; b=uzCHhRB6BYZJJiEraV1ywBWz/oNG6+91G4mm9F8QymTmW0woNrq86MpB4H73dB2RU6Dj1bRedxHLunEoGs1lYFbxDIdMp9W8LsWT7OKZtHhb8+laHb/hGzKNnpwmJCKdMNmyB1a+G0jrFQ69bRU6qWT83i7NvJ5UYy7IwrR4h1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751999806; c=relaxed/simple;
	bh=+vaofl95bqvvnLYwDszC8RbyTM4tCMvnw5NvGQbXRrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dalaGatPiVRx5ue8LqLU9EVCy8maGkwyj+FrhqJueHvLur5zFRWPouyVQLATINr1RWR1iUNWhgh7lU0EMXtlfHnwWzTXSJBmVngbQjM5FRoqiqom+86ZzLqGkbySgvZxEcmdrHCybnMzBqBMnWhvasGaqAYy/spgZyYQRllUc6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nq6895W3; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nq6895W3"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-453066fad06so33829695e9.2;
        Tue, 08 Jul 2025 11:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751999802; x=1752604602; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8ZzB0X2FsBXzqI5HGqH1OR/QsRNZjrSGBBRmka+LrH0=;
        b=Nq6895W3QLWM5yrVYsKgMWWdZXF/8Iw+BIrLbIfz9RJ9F8VSDBf/RCa53vB31qB4JR
         7bmvX/aqb7fq4m6wUr3tSGpGluqIgqc8Y3/9PyvdnCdFZDiQy8Xopbf12+Gh4fXRatmB
         sp/XEp8BBJ7d/r8LdOkQUZyZlCdsKQy2EQ7aAk4HWJombZHVKkiod8zuD/HyDVlBngmd
         o+WkkpT2WZkHmKh5btvGXZz4ER5d9pNvRigBUjWeWbMvutIjR3zs5JGqv/JMxg1sKzWm
         Nv8csb1ePynBy0GSHrBVU9YMKgUqgFeFc4L5+Gt4CWrP4enN7hZZm93CYicFEzvTAoTI
         X+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751999802; x=1752604602;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZzB0X2FsBXzqI5HGqH1OR/QsRNZjrSGBBRmka+LrH0=;
        b=WG5IEpdRqi/QNyaOe8Xth8CpHvOwxWQQtd4IfjHsFQznof4OE+/0AYngCyG4Uz0Vcm
         vGP6QUgxr29ZaRcRnFEynRkObeRj+hJrUhuEPYnrOxGrEoiNwgAHuI3hCUDkY4CdbhGL
         wtCAwWrns6qeTTblMhQepLC6n9cL3UgTvcWyuxrV0snXfuZgKRji41NRYDjwuVaOsERd
         H8uGl+ZID8uo8TD0iP3ryUTSwN9AYM7y8r467TM1amu2RQj0w2gpdhqwpIGeNmBHax0L
         wHn+DFHpYiOX6A7jmTZU3gA/LJImkP/ZnTildcc/MSB95O6lavNm/2ndoxE8Z5a4uszn
         lxJA==
X-Forwarded-Encrypted: i=1; AJvYcCWQ652sL/Ly+kWtIVJM7rlibJbP/KnZBPO3s1RoHObAYQWHbnpb8oRIu0kCFB6G0vuaa4SbC3CbLCZMOBqE@vger.kernel.org, AJvYcCXrptCmNQdq3fagPkE86+UxRr7allkFbQkm3J6i39VE/vzjtyXeHh+G24u4SHDN9H2Wd0lsSGt+mfTaFwM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTC/DOqU6VnG0+wtxNONZAFeP5L8BtgPpAHba2pvDwi3kIJydH
	11uQ9b4LUeeb7d08AaTeFstju1C8QrwwjKa0wxuTB9FzBbxQeVmSyTF9ryXoOA==
X-Gm-Gg: ASbGncsguEyOfjcN3rl3SvreBLNy+k1Fxg8ApUtt5v37BX2D61+5yFHxdp+Oc6IMulo
	+Tvs8CugbwNSbyziG4bWsHHfFzFDzqcipE4bd0OcRShty+DTVLuLShDWX2gmsWpBa2yqOQkyQvI
	CBqTt5s7yWaI0lJ/VKOON5/OMRxp//XlTp9SrF+RmvNoUxXTf4sV0vrKhilrb4vl7/0d7PtKEoL
	8TfpZXr0IUDJhBQHnQEMO9J69LvRJ0oEPo5eUXazH+VrEJOFD0CKMRBOyyiwSQ68A7Vcla5eKAm
	QwicpAn22w5e6Jekxeo4Zgl8YrmT2xppg85W6oL7LU6XotSJL4WD/OAIqaCMJRDO1uwYGcmesQ=
	=
X-Google-Smtp-Source: AGHT+IGzirJ3lcOZbMfjaWTE+B8TfpMfBT54EdWIh7tTV0hajxIMDDBeGmh91j5QzxZyK7lYKyBaXw==
X-Received: by 2002:a05:600c:4683:b0:43c:f1b8:16ad with SMTP id 5b1f17b1804b1-454cd5447a2mr53481945e9.30.1751999801979;
        Tue, 08 Jul 2025 11:36:41 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3b5dfd4657dsm2083334f8f.17.2025.07.08.11.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 11:36:41 -0700 (PDT)
Date: Tue, 8 Jul 2025 20:36:39 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/10] crypto: sun8i-ce - move bounce_iv and backup_iv
 to request context
Message-ID: <aG1lN94feb4OJVsI@Red>
References: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
 <20250626095813.83963-4-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250626095813.83963-4-ovidiu.panait.oss@gmail.com>

Le Thu, Jun 26, 2025 at 12:58:06PM +0300, Ovidiu Panait a écrit :
> Currently, the iv buffers are allocated once per flow during driver probe.
> Having a single iv buffer for all requests works with the current setup
> where requests are processed one by one, but it wouldn't work if multiple
> requests are chained together and processed in one go.
> 
> In preparation for introducing request batching, allocate iv buffers per
> request, rather than per flow.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  .../allwinner/sun8i-ce/sun8i-ce-cipher.c       | 18 +++++++++---------
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c  | 12 ------------
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h   |  8 ++++----
>  3 files changed, 13 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> index 113a1100f2ae..9963e5962551 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> @@ -209,11 +209,11 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
>  	if (areq->iv && ivsize > 0) {
>  		if (rctx->op_dir & CE_DECRYPTION) {
>  			offset = areq->cryptlen - ivsize;
> -			scatterwalk_map_and_copy(chan->backup_iv, areq->src,
> +			scatterwalk_map_and_copy(rctx->backup_iv, areq->src,
>  						 offset, ivsize, 0);
>  		}
> -		memcpy(chan->bounce_iv, areq->iv, ivsize);
> -		rctx->addr_iv = dma_map_single(ce->dev, chan->bounce_iv, ivsize,
> +		memcpy(rctx->bounce_iv, areq->iv, ivsize);
> +		rctx->addr_iv = dma_map_single(ce->dev, rctx->bounce_iv, ivsize,
>  					       DMA_TO_DEVICE);
>  		if (dma_mapping_error(ce->dev, rctx->addr_iv)) {
>  			dev_err(ce->dev, "Cannot DMA MAP IV\n");
> @@ -299,13 +299,13 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
>  
>  		offset = areq->cryptlen - ivsize;
>  		if (rctx->op_dir & CE_DECRYPTION) {
> -			memcpy(areq->iv, chan->backup_iv, ivsize);
> -			memzero_explicit(chan->backup_iv, ivsize);
> +			memcpy(areq->iv, rctx->backup_iv, ivsize);
> +			memzero_explicit(rctx->backup_iv, ivsize);
>  		} else {
>  			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
>  						 ivsize, 0);
>  		}
> -		memzero_explicit(chan->bounce_iv, ivsize);
> +		memzero_explicit(rctx->bounce_iv, ivsize);
>  	}
>  
>  	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
> @@ -348,13 +348,13 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
>  					 DMA_TO_DEVICE);
>  		offset = areq->cryptlen - ivsize;
>  		if (rctx->op_dir & CE_DECRYPTION) {
> -			memcpy(areq->iv, chan->backup_iv, ivsize);
> -			memzero_explicit(chan->backup_iv, ivsize);
> +			memcpy(areq->iv, rctx->backup_iv, ivsize);
> +			memzero_explicit(rctx->backup_iv, ivsize);
>  		} else {
>  			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
>  						 ivsize, 0);
>  		}
> -		memzero_explicit(chan->bounce_iv, ivsize);
> +		memzero_explicit(rctx->bounce_iv, ivsize);
>  	}
>  
>  	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> index 79ec172e5c99..930a6579d853 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> @@ -757,18 +757,6 @@ static int sun8i_ce_allocate_chanlist(struct sun8i_ce_dev *ce)
>  			err = -ENOMEM;
>  			goto error_engine;
>  		}
> -		ce->chanlist[i].bounce_iv = devm_kmalloc(ce->dev, AES_BLOCK_SIZE,
> -							 GFP_KERNEL | GFP_DMA);
> -		if (!ce->chanlist[i].bounce_iv) {
> -			err = -ENOMEM;
> -			goto error_engine;
> -		}
> -		ce->chanlist[i].backup_iv = devm_kmalloc(ce->dev, AES_BLOCK_SIZE,
> -							 GFP_KERNEL);
> -		if (!ce->chanlist[i].backup_iv) {
> -			err = -ENOMEM;
> -			goto error_engine;
> -		}
>  	}
>  	return 0;
>  error_engine:
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
> index f12c32d1843f..0d46531c475c 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
> @@ -188,8 +188,6 @@ struct ce_task {
>   * @status:	set to 1 by interrupt if task is done
>   * @t_phy:	Physical address of task
>   * @tl:		pointer to the current ce_task for this flow
> - * @backup_iv:		buffer which contain the next IV to store
> - * @bounce_iv:		buffer which contain the IV
>   * @stat_req:	number of request done by this flow
>   */
>  struct sun8i_ce_flow {
> @@ -198,8 +196,6 @@ struct sun8i_ce_flow {
>  	int status;
>  	dma_addr_t t_phy;
>  	struct ce_task *tl;
> -	void *backup_iv;
> -	void *bounce_iv;
>  #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
>  	unsigned long stat_req;
>  #endif
> @@ -264,6 +260,8 @@ static inline __le32 desc_addr_val_le32(struct sun8i_ce_dev *dev,
>   * @nr_sgd:		The number of destination SG (as given by dma_map_sg())
>   * @addr_iv:		The IV addr returned by dma_map_single, need to unmap later
>   * @addr_key:		The key addr returned by dma_map_single, need to unmap later
> + * @bounce_iv:		Current IV buffer
> + * @backup_iv:		Next IV buffer
>   * @fallback_req:	request struct for invoking the fallback skcipher TFM
>   */
>  struct sun8i_cipher_req_ctx {
> @@ -273,6 +271,8 @@ struct sun8i_cipher_req_ctx {
>  	int nr_sgd;
>  	dma_addr_t addr_iv;
>  	dma_addr_t addr_key;
> +	u8 bounce_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
> +	u8 backup_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
>  	struct skcipher_request fallback_req;   // keep at the end

Hello

Are you sure you could do DMA on sun8i_cipher_req_ctx ?

Regards

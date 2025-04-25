Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F699253949;
	Fri, 25 Apr 2025 13:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745587834; cv=none; b=ZlkMWNVY8jGohDNbGerUSaf2xEcQ5SKafRg3gNivsivjpeUthie8eDd0zFLbt736cL/Z6BfEH8DRyRA9IUMRkm6guCT+DpyECoHIHRjNPKPhf9TLG4QT67Vf76AC0wc1vc/EZILUeYinidFZMKlFLXcNuuSLvw1iamQhcQE8qzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745587834; c=relaxed/simple;
	bh=WMPNN23hTTSzf665lOinNQAD+n0lrk8hBHf4iWIYd7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ea29fl44zrI9iRDX8HELQLsTII9m0HdGVK3LMGg5jNOrgTb60DtrOPD3QxOo4uWArQJIMri54h3KwAndDqfF5ZDVXC9rN495Lt8yi2YhJT5uWfOiIlMM0YjQ6p3O2Y0eYhcQf0eB2sJ7y/YRZ0j3ha+wyHv27bMunl2L3ky6teg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPEuKYWf; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPEuKYWf"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cfdc2c8c9so12016185e9.2;
        Fri, 25 Apr 2025 06:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745587831; x=1746192631; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2UqX8ZjtCt77K2Fit3CqVXamabKOpdFvwhUpSSi7NtE=;
        b=WPEuKYWfeSorAwenCP3yD5f7PGyZVWyltE3SAgrUNR3+RLESx7Vtd5xUBeNVGH0q/O
         JyiGAlT4W/klPweZoCEvo1A8707WmXgHvRkPCAQidnRofh8KaIZSEKuwOPooC22h3Pc1
         8Vh2/qkrHOp0XEjed3Z02LF04KWjkedQkx+PmH3J+iTfv9eaadAUlFVV4yf7jN/VQBMQ
         VLk7H/IlBhlZsDcUqdjflX3jUDADX4DSdoRpxi96TKLFiBRwttUlyoJHwKmkGBGBZNaJ
         HzBCVTySR6yxTdSm6xht5wQ6IUkHSU4u4fxfl0own7Xus97qGlkKbGA8SZxqjEy+AHUf
         6+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745587831; x=1746192631;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2UqX8ZjtCt77K2Fit3CqVXamabKOpdFvwhUpSSi7NtE=;
        b=JkRCgJXsl4Z0Ia16ilwHI+gw9Fk6eKI+F6m2XpRt8cKttkchJt38glTiFcS+NaLQXg
         2JytaBu14BWpCskccSbQxalGJuIi5faCuqETMyB6xUyB/XFM6Q4JQpZGo8l1gqzRl40g
         uBj6zwRSrVhScEMUSpWaFl9/xHgCnPzCbH9jBbhGYdZUPKsYpgTvOeek3mnG2iSIbnq1
         8EmdZiph5HBGLl3q9URVn1ZRghtpgyw6HHovuAkFigvoKfnT9V6OcWe+oykaFyo0Bvmn
         pV6Jz1eo9eFWGu6OBUTYLsO+e5KZTGp90qzq9P0SiPTp2weAGdV05eLn1WXRRROkVINQ
         vGCg==
X-Forwarded-Encrypted: i=1; AJvYcCUQGGe7rF/Cb9hMjo9hAjUiDZCRQ1ZCOQkHK7WyytjGomuS2cOJ3tI/pX23fABME/YPGyD/vkJcicD4Jrw0@vger.kernel.org, AJvYcCWAlY8W+b8ckilJgTNOrcRGVo4t7PJ4mY6Eu9n9beIicgn0dnYfotsufOab3vpE17+s173cH6Vg8Z0ZFQ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmJWu9dqDyOhng21gXpSwugr1CnN7xMl6ekSk+NuzAYXlSQMOU
	U7FKJy0ODd6NPHVubXEsj1oKPSDKs7qVnIt17su1NvQJR5C0U76W
X-Gm-Gg: ASbGncuRYBWXC+PKs0EKC0ZaMuZZDYXZiZ4cWkJ0hO+gYPvjhonIoa1toRXuT7c7xdM
	kospK15RtrO60Zp1HMT+tuWsaIeWkjnmP93N9Za13GWI1fLzUK3APHVFhywmSKWyWaGoqGHRiIv
	DcFXo+Et1tzqqIK1e7YDM2cHWO2DN9QpfjF+JcPD4JvKfo8TsCYYWITl9TZ6o9v9qfrfS0EfPQC
	NO+67HhFtk0UFm2VZsp31wl9oKtg9Jz/B+JmfbUemZwIwxTqEBRH/+q8bPuB90H2s73lPODhJSm
	5q2l9/NrNGSYxkwo4gr0KVV1wrlEf0FXQAGuxNI1
X-Google-Smtp-Source: AGHT+IH4MAUOUOX1z32Y5YjXpUZYGNNANOzJfIUTq3LFTRzfoVT+ERQaNUzYocvxmVzREj0gMHwqtw==
X-Received: by 2002:a05:600c:1c0a:b0:440:68db:a045 with SMTP id 5b1f17b1804b1-440a66abaffmr18515515e9.26.1745587831225;
        Fri, 25 Apr 2025 06:30:31 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4409d2a2386sm58831505e9.14.2025.04.25.06.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 06:30:30 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:30:28 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] crypto: sun8i-ce-cipher - use IS_ENABLED() checks
 for debugfs stats
Message-ID: <aAuOdDhpnLE5bM_y@Red>
References: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
 <20250425124517.2225963-3-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250425124517.2225963-3-ovidiu.panait.oss@gmail.com>

Le Fri, Apr 25, 2025 at 03:45:16PM +0300, Ovidiu Panait a écrit :
> Add IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG) checks before the
> fallback counter updates to make sure the code is not included when
> debugfs statistics support is not enabled.
> 
> Also, drop the existing ifdef guards, since 'struct sun8i_ce_alg_template'
> is always defined, even with CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG disabled.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 46 ++++++++++++-------
>  1 file changed, 30 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> index f03a8fa7bfa2..433cd18f0b5b 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> @@ -34,22 +34,30 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
>  
>  	if (sg_nents_for_len(areq->src, areq->cryptlen) > MAX_SG ||
>  	    sg_nents_for_len(areq->dst, areq->cryptlen) > MAX_SG) {
> -		algt->stat_fb_maxsg++;
> +		if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
> +			algt->stat_fb_maxsg++;
> +
>  		return true;
>  	}
>  
>  	if (areq->cryptlen < crypto_skcipher_ivsize(tfm)) {
> -		algt->stat_fb_leniv++;
> +		if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
> +			algt->stat_fb_leniv++;
> +
>  		return true;
>  	}
>  
>  	if (areq->cryptlen == 0) {
> -		algt->stat_fb_len0++;
> +		if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
> +			algt->stat_fb_len0++;
> +
>  		return true;
>  	}
>  
>  	if (areq->cryptlen % 16) {
> -		algt->stat_fb_mod16++;
> +		if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
> +			algt->stat_fb_mod16++;
> +
>  		return true;
>  	}
>  
> @@ -57,12 +65,16 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
>  	sg = areq->src;
>  	while (sg) {
>  		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
> -			algt->stat_fb_srcali++;
> +			if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
> +				algt->stat_fb_srcali++;
> +
>  			return true;
>  		}
>  		todo = min(len, sg->length);
>  		if (todo % 4) {
> -			algt->stat_fb_srclen++;
> +			if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
> +				algt->stat_fb_srclen++;
> +
>  			return true;
>  		}
>  		len -= todo;
> @@ -73,12 +85,16 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
>  	sg = areq->dst;
>  	while (sg) {
>  		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
> -			algt->stat_fb_dstali++;
> +			if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
> +				algt->stat_fb_dstali++;
> +
>  			return true;
>  		}
>  		todo = min(len, sg->length);
>  		if (todo % 4) {
> -			algt->stat_fb_dstlen++;
> +			if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
> +				algt->stat_fb_dstlen++;
> +
>  			return true;
>  		}
>  		len -= todo;
> @@ -101,9 +117,7 @@ static int sun8i_ce_cipher_fallback(struct skcipher_request *areq)
>  		algt = container_of(alg, struct sun8i_ce_alg_template,
>  				    alg.skcipher.base);
>  
> -#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
>  		algt->stat_fb++;
> -#endif

Hello

You put IS_ENABLED everywhere, but here you remove it, why ?
I think you forgot it.

Thanks
Regards


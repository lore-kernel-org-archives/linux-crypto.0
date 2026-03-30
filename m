Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917163AB29D
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 09:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774863454; cv=none; b=bLRRQHrm+2N2Jx+qhLzN5lHh4W+3+tLVAbWmJfx9upAOlp3LWvuSN97YWG/N3/IF9ZMFSIt4/oHRYY2u6qzIgwwFwUPAI7LsPWVOHesCQrPV10/naR81FtPYl326NOwDe7WgC/g+3DqzqGt4QnL6cLSeWLuFNWTKpyjalm9Nug0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774863454; c=relaxed/simple;
	bh=v/KejTXhe3Zobl17Vlv8GeZMvuW60lczEwBitAa+7XA=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLzGS4rO1maJG948ofKM0y0X46IU0B8mjzEkUuTM9METu+TGqkHLsy9d9BRVL8qGxJfMv2+ZLAxXQfkejV6AYz0jR2Q4LmkJmZPQ5Oskbmm9nmIqrwlI6WCaLBSanymQqqXjGnFggC0fnKUsKjDz4JcgOB8q+6qXZzZxwzBAY88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Odn278ys; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Odn278ys"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-486fd3a577eso37656635e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 02:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774863449; x=1775468249; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pI4JUCEtE5qRlwuJumNxTzoSp2/TgL1Oh7MLg7cH5Is=;
        b=Odn278ysLnV1x5LZUsi8JtPbQ9iLZ64GqOX3HMOTGGXka9u/T6+/ALsdkoJFdEMlLw
         VvX413eXiZAOdJvyMejA0cQAn+oJdFvX5Pspkt0R/9LSuBrOwAeCvTsGruWuIYn4jiS6
         oL4iNtuINIXrzfXUEu3cCrAhfep6ufXlEmRD9OqcwFGh/8eK+XMtg0xNnXHxfKrYa0KB
         Gj2fvWEjBEOWYmKJgYWXzZiWLsEPN9bYu9X20MCJGrQSZt68U9+jDTZ9Z2g/CndDxCMV
         4MisH/Dkx2q5AU4H5amAqLb0kUz2MknIrSyshjOzbnIdlck9qHbF1FG5+6i0lOUN7db2
         wPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774863449; x=1775468249;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pI4JUCEtE5qRlwuJumNxTzoSp2/TgL1Oh7MLg7cH5Is=;
        b=ZLFjOg/SEyFdy/1HgZ8X+m+DIaiBh1kE1X4R5weRPTouZK76oq10p82BzycdNb8He8
         Fi9OG5PuBS1bZy+AzKqUQlgAFzIkZvbK6V/4g7TPu2bXYKM8MZGR8SOzJ383t/bWPGGm
         2Y8klGx/BivzRCFOP/VO6czto/F2qF54D6/0JrgfGTpY+aBauvQfLoanr6FHqRGF5iIR
         +tHVgqCr5k4sN9SNFW1qumD7iqOf3taM2JsO8/r0XJcpLHWZZNRsqD29t/G9JRgZppvO
         Jw0VcQ2UFa9+a8IX57p7Xj2siyJ3iCqtgS/j4DtBohbIFmGO9KitCzvSv3do0ORVJCiv
         ZvOg==
X-Forwarded-Encrypted: i=1; AJvYcCXauySuXsRgtKCEbYsBhwm2Va7zOeIdf9tJOxsExKmyfPmonD0psn3KuebYs6S+x9T/Mzfqry4qC/wPrKE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy6wtSntx7g4AzNx1p98jXL4go41Cc61KapZanNtQ/zH0uu6DE
	iq5dgXcj3HGruVboD5Pagr3qdQKIbAs5cGoIdpQte8+IoJK+nr+Vvtd3
X-Gm-Gg: ATEYQzz3jMhg0ikIvSim9T0+HM6/YJcbjaP4uWlu73fXWxdcUY4TlBl70LUd57/vMmL
	uLWf869/dFg3PirJ4Wjkitbj1paQ8+V+2kqIMOKR1oq24DxNuXmBj9q6HJvG+hHGFPlpOzkvCoD
	Uzh1pftRe+YwEc+SdyHZaWYfIDzRJ8r6dL1sq+vt9fC3NZy3HEktDokDuSEcHR1ipFVG6dFmCuw
	4JTXQ/i5hp03eV0lSxEx5fIcooukB18ikU0O4Tw3Xs4s3Zr3K3rTTsFo2xY6iq4hl+rAvlXUsFZ
	w9WCjyZM73fcLgLBbHYhlSS6wTCQl8s9Y5z7nRVk6CwDhgKhMcX51ASOEOrkI9+JLoeKiI3M0BO
	5We896BNkKicgEIH8VwyLOFvqTYPz5fqBgaGFcg+sALV38jNQHRrF5JrKh3+OdrP4kIZe7ocAQ9
	EfAPFENVwIgyiblmXha2C01Z86zpQJF5ITEXvcbsVOJvFlrOpzwRn3IQ==
X-Received: by 2002:a05:600c:c493:b0:487:575:5e1 with SMTP id 5b1f17b1804b1-48727ef5571mr186959755e9.24.1774863448505;
        Mon, 30 Mar 2026 02:37:28 -0700 (PDT)
Received: from Ansuel-XPS. (93-34-88-122.ip49.fastwebnet.it. [93.34.88.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722d49c18sm262788815e9.14.2026.03.30.02.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 02:37:28 -0700 (PDT)
Message-ID: <69ca4458.050a0220.3569e7.2980@mx.google.com>
X-Google-Original-Message-ID: <acpEVX2A5bhnShFI@Ansuel-XPS.>
Date: Mon, 30 Mar 2026 11:37:25 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: eip93 - Fix dma_unmap_single() direction in
 eip93_hash_handle_result()
References: <20260330091817.25797-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330091817.25797-2-fourier.thomas@gmail.com>

On Mon, Mar 30, 2026 at 11:18:14AM +0200, Thomas Fourier wrote:
> The buffer rctx->sa_record_base was mapped in eip93_hash_update();
> rctx->sa_state_ctr_base and rctx->sa_state_base in eip93_send_req()
> with direction DMA_TO_DEVICE but unmap with DMA_FROM_DEVICE in
> eip93_hash_handle_result() and eip93_handle_result().
> 
> Change the unmap to match the mapping.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>

Hi,

was this tested with the crypto self test?

I need to check the code again but in theory with handle result, we should
get the data from device in sa_state and cache should be invalidated. If we
want to use matching maybe we should change to BIDIRECTIONAL?

The mismatched flag was to invalidate relevant cache on tramissing to device and
then invalidate relevant cache when reading it.

> ---
>  drivers/crypto/inside-secure/eip93/eip93-common.c | 4 ++--
>  drivers/crypto/inside-secure/eip93/eip93-hash.c   | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
> index f4ad6beff15e..75659a45ea5a 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-common.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
> @@ -687,12 +687,12 @@ void eip93_handle_result(struct eip93_device *eip93, struct eip93_cipher_reqctx
>  	if (rctx->sa_state_ctr)
>  		dma_unmap_single(eip93->dev, rctx->sa_state_ctr_base,
>  				 sizeof(*rctx->sa_state_ctr),
> -				 DMA_FROM_DEVICE);
> +				 DMA_TO_DEVICE);
>  
>  	if (rctx->sa_state)
>  		dma_unmap_single(eip93->dev, rctx->sa_state_base,
>  				 sizeof(*rctx->sa_state),
> -				 DMA_FROM_DEVICE);
> +				 DMA_TO_DEVICE);
>  
>  	if (!IS_ECB(rctx->flags))
>  		memcpy(reqiv, rctx->sa_state->state_iv, rctx->ivsize);
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
> index 2705855475b2..19a41a0db667 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
> @@ -67,7 +67,7 @@ void eip93_hash_handle_result(struct crypto_async_request *async, int err)
>  	int i;
>  
>  	dma_unmap_single(eip93->dev, rctx->sa_state_base,
> -			 sizeof(*sa_state), DMA_FROM_DEVICE);
> +			 sizeof(*sa_state), DMA_TO_DEVICE);
>  
>  	/*
>  	 * With partial_hash assume SHA256_DIGEST_SIZE buffer is passed.
> -- 
> 2.43.0
> 

-- 
	Ansuel

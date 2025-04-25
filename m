Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC488F5E;
	Fri, 25 Apr 2025 13:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745587439; cv=none; b=Cg+jLeNqfygGaQqRRX0c8Ont0pB/YNVx2svad6rWzP0jBhnrWf3VRwEhImk+P4vNm6ubgKih/d4yllpDr/8paJIU/b0qKZMqK6JUes4USZAdhyDj6MiGjFoBgRcEql8cW9ML7EkiUyVh/SpBrhCkXuonsX0GFuX71iM3AAxh9Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745587439; c=relaxed/simple;
	bh=1wzGwsHJk6GM4JVSRc5JQFv98aaci3bQp14s5F5hZj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FsiYHW4LIIi1KlzZl1uM1gSMA0ALgMyntrp0E0drJBCmICc+ExdP5/X3B9UufrY6WIScNfK8yNP8/sMiH0DmAlo9pvpBCYFSOVS/25uYkqJsMCIYd9spl445H5p2Ap7hPVCULCgEF9J5qdAzbyxPbu1O9xAc042ikH6hUhT5md8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C0CALfVR; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C0CALfVR"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39c14016868so2116122f8f.1;
        Fri, 25 Apr 2025 06:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745587436; x=1746192236; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pKYXe62kLy/PK+NiFHwGFhROYiWY2U4thO9lzKIe64I=;
        b=C0CALfVRdwOze56YM4iy6F/xUCcLuVmr99HqY2Oa8L80J6nQZUJjY1acyOYLbjSAmz
         L7wtGA3Xds/HREylvIKVZyTDkfgAwBRFjHXwZ1SLJlSr54LvuyE3W25bWak517SnhO42
         nUROsblKDKpnf/XnGDfg7Y9EDnLZPtUBd9ZwpQSdFWRWM0YAJ8MM8i0Q5pYRB/qJQN7w
         Dt2Ho4mJN5surkqcwzgBbuBAC+ECdMTpVzkSYYO01W1QqMh8deY63liWTAmB2qw1AiPX
         /YcKj38ux42TWpoDWI+ySwSJJJypnnDNRUlvLoFrxGnrztP+pPg38MvZJVlCWeXfY7fO
         IDSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745587436; x=1746192236;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pKYXe62kLy/PK+NiFHwGFhROYiWY2U4thO9lzKIe64I=;
        b=ZPmknTIhuNk/ELxTRvyWxBH7CN/zfeop7ai7pp5apT8BTTTziBFuX3+c9wXVJBTXnM
         e+hLTXQcW1XIr+zmSrog6eXoJWyPVmpbamFTK10A6AADSkjSi6mDj89zMUx+ugXfH92Y
         J9R0vwUBoKKJOX9wIiTXz7qI9tq4Z2w3oNe3h4Apwpxf4LQ1QOb+SmzbfsuIXPzTK6kI
         LvzmBm6s9GMkk9P/HChIWGWmZFw55ohl6EbIizwxPIWJJdrbJGq6sP/ms8aBupmzD0aJ
         vJ0jNXLMoCuosbgL3ZvraCnyyk8yI2Zjx1e/fpRuQzN3ZgZs2CO3EbSZhrIRe1Wszqiq
         jhsg==
X-Forwarded-Encrypted: i=1; AJvYcCXa5Ru79abPQypukA3AdYfa8o2RCMoTfWI2fAC7yCC09ydWbtXS3+RHQ+EdLzAC8khW30Hvgi11BMoLArc=@vger.kernel.org, AJvYcCXhuDua/ZrhJB+l1I9DBfmBXR219SW6TM84B052HqXzQNbTfw+/4QDvag8ftoar6VNktntQv2noSZwBWATE@vger.kernel.org
X-Gm-Message-State: AOJu0YxpWsF+88eQHhvqw0GmyaaxGczZ27wAbAxhBmF+D+9kL6MniwPA
	bHDa26sWUi4eTpvdoI1hUCKVS7ec2MzFnFAoCd5mw1/8G+wHeUl3
X-Gm-Gg: ASbGnctBUvxj/6Cl74nd+0Z5HinWkhO9u08aX2cHeNgowoOsN2guY7JNuLn0e8K6EuR
	YNeWzMtseNOZbvN2UWHB5W+elPRN8dIvvkAsq3A22057uwvcggkBgQOy7ucs1y7s8HrNFybGwZ0
	1cH9x0oUVSt4XseWDELc8sucO5uPnYXqkiqs++MPKdmDs8wMY5cM6B11SqjZrkGjdqT7aLWkD/E
	FqkPpkWSGQs7oG7vbRLW1Gh5RvASJqHInM8UDFYwPhI/HDAX606ixHP0148TmGQ1o57vKdoUvJs
	4FjL0dU6+LR4ie4YDFBpUYHIvqriFNIQH8S5aJta
X-Google-Smtp-Source: AGHT+IFII0EqynEWPZzvrGLmpKWfS7u49UoGkuCQiAlKncT8hgoImF1ZrCzzJCNwbFrIyYmCHxOPfw==
X-Received: by 2002:a05:6000:400f:b0:39c:266c:12a5 with SMTP id ffacd0b85a97d-3a074e2e6a3mr2130241f8f.13.1745587436006;
        Fri, 25 Apr 2025 06:23:56 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a073e5d4b0sm2320381f8f.89.2025.04.25.06.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 06:23:55 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:23:53 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] crypto: sun8i-ce-cipher - use
 crypto_skcipher_driver_name()
Message-ID: <aAuM6SmS4Dhsdxfo@Red>
References: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
 <20250425124517.2225963-2-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250425124517.2225963-2-ovidiu.panait.oss@gmail.com>

Le Fri, Apr 25, 2025 at 03:45:15PM +0300, Ovidiu Panait a écrit :
> Use crypto_skcipher_driver_name() helper from <crypto/skcipher.h>, instead
> of accessing struct crypto_alg directly.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> index 05f67661553c..f03a8fa7bfa2 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> @@ -17,6 +17,7 @@
>  #include <linux/io.h>
>  #include <linux/pm_runtime.h>
>  #include <crypto/scatterwalk.h>
> +#include <crypto/skcipher.h>
>  #include <crypto/internal/des.h>
>  #include <crypto/internal/skcipher.h>
>  #include "sun8i-ce.h"
> @@ -438,7 +439,7 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
>  				    crypto_skcipher_reqsize(op->fallback_tfm));
>  
>  	memcpy(algt->fbname,
> -	       crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)),
> +	       crypto_skcipher_driver_name(op->fallback_tfm),
>  	       CRYPTO_MAX_ALG_NAME);
>  
>  	err = pm_runtime_get_sync(op->ce->dev);
> -- 
> 2.48.1
> 

Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>

Thanks

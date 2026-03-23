Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C45438737A
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257550; cv=none; b=jXw5srMMMdovgY40reYz4Ty4P3LwHviICoWkTmIMDqvQX67TKNQ+jZrZLPjDMw1dKcabmn+ybq9WEo4Anzbc7k6Xj1LvGHBloIDqeLv4TdVqXVIv3b1fZT+usmHpSUgFwFRT+M6WixgIjEAoAc3BhTfm642iqVphuSWdBkgNSv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257550; c=relaxed/simple;
	bh=K7REZkDAcZwdetyAbVxHzmV0iZC+YoLWQ7Vq6/U6y7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/UHtAKd81zg+I9YjIwK/1DIbgeybc7qddUSUWc21HQLpW97n1NkAsvQS1JIaLTC92dgTRpzZGbWSjeSB2OtQzQTlqN52cYwV1gJQDj4MpJRxkJ5JhHKbsfJhvfPVjrlRzpVc1ZDKfqU0AUs1fIBvwo5oKFq+HNQ/TdwbKo1s0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVFbdsLx; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVFbdsLx"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b04d051664so34388055ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774257548; x=1774862348; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=shLiW9iDulZYVV8E7sxkKBUY68U6X7Rz6R4rhdod6S0=;
        b=AVFbdsLx3CMV8J6enzEJjzqn5+ov2Bd0UJIRUZ70NL9TEZxZ2zcPbeQWQ/0yGq94El
         /rcKA6JHkerXXytmAl7nQXLehpT06bdvig5KD7CAXPsB2iVzGqhEpAcIa0IjGUo1RNcl
         BsLbHyWp+7gfxognKxeQfgBNAm5b38DrjnwW3lBvRa7TvcdBk2MHDBNgXVwiteLxzOH5
         sBmdMkAr/KrFoAVRcj5XdTLBw6n7vFDcbY8ZlSyszFFTvvM3ysDeHrh0SclEzgpvS+sN
         9wFcbiOCMOANKDf3wqiuODrVXCdPGXbEJzk0S1Dm0WtekY/kmBLmwylGBqiZmZqqlzg4
         nXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257548; x=1774862348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=shLiW9iDulZYVV8E7sxkKBUY68U6X7Rz6R4rhdod6S0=;
        b=TPiOevJ/KrQdrwl3klMQSMbH224CU1/+zPhl1/BEzQWj4R8ahIgubNm+H00G1QQ/Pz
         VkD4V9gsY8oy6NbsnlYOo3TONWw6TJWiIty0WV6wJ0vWxbKX/MDAxeYTDzl08vVLYLhl
         uOHOhVMzeILt4dW3LTCVmnaWC4UbyeJ+Rw+yFyT14uY0y33MmTpgXPuJ1/PSiJwOtpSl
         dvhI6DAwPjDE73edWMILNPbrEdA32YqyCdNDYCoVqc6foPflZGJUIS2ELVICp4dHnQHy
         LzfkDsF4SnQZmDypOYdyz2FhQY2V19GcKSNt58ndkI1FhTpNnLrCIAhd4kamugC4h6ZZ
         I0WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNrVYEhwPeWa2Ulqek9y8Y9HdvTIyl3d+d6CHVxTV4ny/Jl30I2nzq7JrqP4rF/Q7NQ499CXo5CG9kWm8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKeckNGnvDG3fymAQFkd2Xbtx84mxkyRskC5/aAFDwKvZY7Rbi
	JpJ68cnqfqvtMMl+VXMLa59w/1Mxj9hOZ58yq0RJa/3Adhsqh2kzDKiR
X-Gm-Gg: ATEYQzwB5JvNM/JazrYDzHsXHcBVwUm6+LtUMasE763N0peAjspqPKHK012inlBjEe1
	qM6dvwfwfRDVy6l5K2cGLmQ7l3eUylFn8wbyNiqkvpJf4nUKxzhZx/TCBuzld2O0x0tguy1vjIi
	3x9/tT5n+0eyQ6eW0+xouijniXB/nyRRZ7nBoLr4GnwEvcH+UAPyfVrOXk3iUfabBr0EwEJBpuS
	nGDRa/GhRQpb1P+tuTvOWgZVj8p3E+Pz2WY95JiimNpk1evdYHYgw/bNgoOfVmwGLjs5qV2aKlO
	ziYfw2eLN49rv4+yYSTWoFgVw0GsB9ztYTOFUO1gkcPauaMa4M86wkYTYFvuYhewJPEnrBFVeN9
	fu+gm/SMZokIDXd8Cg6abKclOqgPwT/xdkQAtcGK9faAxLpaMG2jn7S+nY8hlFZ5TTq8HyJIai5
	/MU2RKJ/bzJalkNqoZHKuEdvQ5qL84gpjBzSpE1wY=
X-Received: by 2002:a17:902:c950:b0:2b0:5be9:f419 with SMTP id d9443c01a7336-2b0827d196fmr116885885ad.43.1774257548493;
        Mon, 23 Mar 2026 02:19:08 -0700 (PDT)
Received: from DESKTOP-TIT0J8O.localdomain ([49.47.198.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083655718sm106060165ad.39.2026.03.23.02.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:19:08 -0700 (PDT)
Date: Mon, 23 Mar 2026 13:19:03 +0400
From: Ahmed Naseef <naseefkm@gmail.com>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: cjd@cjdns.fr, ansuelsmth@gmail.com, atenart@kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - make it selectable for
 ECONET
Message-ID: <acEFh+X66/YAGMK0@DESKTOP-TIT0J8O.localdomain>
References: <20260320211931.829476-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260320211931.829476-1-olek2@wp.pl>

On Fri, Mar 20, 2026 at 10:19:23PM +0100, Aleksander Jan Bajkowski wrote:
> Econet SoCs feature an integrated EIP93 in revision 3.0p1. It is identical
> to the one used by the Airoha AN7581 and the MediaTek MT7621. Ahmed reports
> that the EN7528 passes testmgr's self-tests. This driver should also work
> on other little endian Econet SoCs.
> 
> CC: Ahmed Naseef <naseefkm@gmail.com>
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Tested-by: Ahmed Naseef <naseefkm@gmail.com>

Regards,
Ahmed Naseef


> ---
>  drivers/crypto/inside-secure/eip93/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/eip93/Kconfig b/drivers/crypto/inside-secure/eip93/Kconfig
> index 8353d3d7ec9b..29523f6927dd 100644
> --- a/drivers/crypto/inside-secure/eip93/Kconfig
> +++ b/drivers/crypto/inside-secure/eip93/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  config CRYPTO_DEV_EIP93
>  	tristate "Support for EIP93 crypto HW accelerators"
> -	depends on SOC_MT7621 || ARCH_AIROHA ||COMPILE_TEST
> +	depends on SOC_MT7621 || ARCH_AIROHA || ECONET || COMPILE_TEST
>  	select CRYPTO_LIB_AES
>  	select CRYPTO_LIB_DES
>  	select CRYPTO_SKCIPHER
> -- 
> 2.51.0
> 

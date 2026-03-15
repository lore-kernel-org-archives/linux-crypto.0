Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D6D371867
	for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2026 15:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773590121; cv=none; b=XN3Uoj2VJkO+9u5fxiNVrnxFCMUTq6JeRIRpbV3mKjfGFtu6Hqn0+hMsdSO4cVG8pcthSV+jDfJlCMDtztrXOaEAEjil70Qii8aRvMPRWuzXsj3KtKDYYJzv9h4Y/D1WWHE7RH0+Rb9sMPp7brObcINSVPlfouUapXHyQR239HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773590121; c=relaxed/simple;
	bh=2qTLxckE9oMDjwMxGCBaza0lbBYLuX0cOOAxPmFeG0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=To1xSh3kFwgNvvuuQ9rpKt0kIe3uJfI6kQFNrO8298tmkRggr8d+Rdj4bY19W4w2EsVdpnLBOruJ9sOng2FkDMobOA4SZJUpnCHHhvCT6ZAFr3A3M6ttOkEjbBeu5WYupD2zbIK28fx6pC5f+laphuBmW1HylnLN/9Z2Jo+cUBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KGkfcsd/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=F+2ZAl0y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KGkfcsd/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="F+2ZAl0y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773590119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xQ3rAvJPMukjRlEJsiY79XXn5O5j6UdqZxcxui6ZZRY=;
	b=KGkfcsd/xLDztUSyaML8zaQLFMYhRRGWYT5cL4pCuxiGAQyWiFQMK/xF41XglfYTV69H91
	jpwYziov3CZsKHowhUO2NKt/6M3DaN+4xU6Av42sqqgmR/OSwv1zCqzmCbLRa2+/0gkALn
	3S/ZokidttAMS75T+y3fqSQpjXJLgYk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-agnFnaPbOFKy6Jf8o-foSg-1; Sun, 15 Mar 2026 11:55:17 -0400
X-MC-Unique: agnFnaPbOFKy6Jf8o-foSg-1
X-Mimecast-MFC-AGG-ID: agnFnaPbOFKy6Jf8o-foSg_1773590116
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b059511554so2661705ad.0
        for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2026 08:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773590116; x=1774194916; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xQ3rAvJPMukjRlEJsiY79XXn5O5j6UdqZxcxui6ZZRY=;
        b=F+2ZAl0yeFz29YJNQWKx8AbT6mMBx/3iserbsufjJib9A5R0ZiGwyfe/0Y1T4x6Afe
         v94+LclcBsr+V85l0yfk7jswguN//VMErIiTu55GvEWSdWSd8W8FqH1PteOm52euJt8K
         5u8koHdOUZ1pthQguz9N/95OOVqhzrFEH/Y3NXmpU3v1Wrv0sPzw2WkSoI5L/WVVIcyP
         q1zIkDyadboWs/gSLaFwX68fXVTfY2d5MOOIA4oBl1J0UCG+dRABUNaVGgvG8CdmWk7H
         rRwu+T3DMYYR4+qMPfHIFtwo/21IkZiouqgEylXFjq76Tqz0XtikKIau5md9+Yssmar2
         cRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773590116; x=1774194916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xQ3rAvJPMukjRlEJsiY79XXn5O5j6UdqZxcxui6ZZRY=;
        b=sjGEkXuIylB0kVDynErhduxvALuAPzOYGtOW1dlw/qX+2GWLfHOG0XwHSrcwucu3j8
         s3q+2HWV+GGa7JVtUgOckpAxyh26TvWr+xGaBkpoRgK+5q4UdeRIOo3UpI6/gZSRJF/f
         cfl8ncIr5uLz9Nyh2G/ynvgZclTajNQudDi9JcSEw7ovd/qj4NS3gcXet64uKuIbdb0P
         QN7jtw4VeIxpR9gsIOU4PpVkeW0Vtr+c8O0+2U9wJpbYl2DKxO2xg27rx6uwL4IQmJMU
         djzcBguilw8de6yaSOdeCoCR0WoU25N0JyCGXVbq023Je2PMyqFV+XI3L3BDop75zUTg
         2X4g==
X-Forwarded-Encrypted: i=1; AJvYcCVEjkJNQv7UuYMiz5/Uj4KVfpE6N3/gWOij/AYpBsMx+kh6d6dqdomQ9uUVQjvG4G4y6OhbTPysmZZ5zk4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yws11dGnlPXZ90TAiCyXacScpSKlT7JBTx6lcoCFezNUVWcfoEA
	f3En5+uCOUBvBJdvdET3tBNagW4CqOJ0+9LaKRs7fp+KMzLbbcyBHWMvSVME9HEI+gNRMtBARnu
	C2aoRrgquzCpn+4cnujQztOM5Lv16VH9ScuO/6MKzAnF5EKaUJ6mU7bN32YaZ914jHA==
X-Gm-Gg: ATEYQzyFXPXd7/uNnPWuY1S3upsgopiDV9hoGgQi25s0lweaUk4crAn/z+FhPtkXPFb
	wwLalFvprulDb4MmBuolddT5z0QHWPTgo8v8woRC/SOh0QTfh/zDqKsN8h2ncQ/tSmhM/glf7a3
	Z9iAnWdJxdp+cnK00WwJCF4KBwxIqFnTAgIqrb51wwT4LNZXlGDPLceqjVOyMAz0oH2yRAsrCny
	k6H4DAC8BUz7fa3GOJfdxk09LYAeC/2EkkxI3MtIn1g3Ygv+qaJG4rRmt3HYtM7gPFENQ+MNT1T
	mBQA/B6LpwVLSEzKC/2mJUh58pthUjCOv4ALgnCF74Uw2ZG11P6P5d7zrbob+PeSE8Ll6Olp4Ka
	ytvjYzjBGXzFepjgmAw==
X-Received: by 2002:a17:902:ea06:b0:2ae:4b91:8407 with SMTP id d9443c01a7336-2aecaaa861amr105927325ad.34.1773590116464;
        Sun, 15 Mar 2026 08:55:16 -0700 (PDT)
X-Received: by 2002:a17:902:ea06:b0:2ae:4b91:8407 with SMTP id d9443c01a7336-2aecaaa861amr105927135ad.34.1773590116029;
        Sun, 15 Mar 2026 08:55:16 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece62c701sm106718375ad.37.2026.03.15.08.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 08:55:15 -0700 (PDT)
Date: Sun, 15 Mar 2026 23:55:10 +0800
From: Zorro Lang <zlang@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org,
	Akhil R <akhilrajeev@nvidia.com>
Subject: Re: [PATCH] crypto: tegra - Add missing CRYPTO_ALG_ASYNC
Message-ID: <20260315155510.myp3i7jhzs654zr2@doltdoltdolt>
References: <20260314165515.9678-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314165515.9678-1-ebiggers@kernel.org>

On Sat, Mar 14, 2026 at 09:55:15AM -0700, Eric Biggers wrote:
> The tegra crypto driver failed to set the CRYPTO_ALG_ASYNC on its
> asynchronous algorithms, causing the crypto API to select them for users
> that request only synchronous algorithms.  This causes crashes (at
> least).  Fix this by adding the flag like what the other drivers do.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Closes: https://lore.kernel.org/r/20260314080937.pghb4aa7d4je3mhh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Cc: stable@vger.kernel.org
> Cc: Akhil R <akhilrajeev@nvidia.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Thanks for you quick response, Eric. This fix works on my side. With this patch,
same reproducer can't trigger that bug anymore.

Thanks,
Zorro

> 
> This patch is targeting crypto/master
> 
>  drivers/crypto/tegra/tegra-se-aes.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
> index 0e07d0523291a..cb97a59084519 100644
> --- a/drivers/crypto/tegra/tegra-se-aes.c
> +++ b/drivers/crypto/tegra/tegra-se-aes.c
> @@ -592,10 +592,11 @@ static struct tegra_se_alg tegra_aes_algs[] = {
>  			.ivsize	= AES_BLOCK_SIZE,
>  			.base = {
>  				.cra_name = "xts(aes)",
>  				.cra_driver_name = "xts-aes-tegra",
>  				.cra_priority = 500,
> +				.cra_flags = CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = AES_BLOCK_SIZE,
>  				.cra_ctxsize	   = sizeof(struct tegra_aes_ctx),
>  				.cra_alignmask	   = (__alignof__(u64) - 1),
>  				.cra_module	   = THIS_MODULE,
>  			},
> @@ -1920,10 +1921,11 @@ static struct tegra_se_alg tegra_aead_algs[] = {
>  			.ivsize	= GCM_AES_IV_SIZE,
>  			.base = {
>  				.cra_name = "gcm(aes)",
>  				.cra_driver_name = "gcm-aes-tegra",
>  				.cra_priority = 500,
> +				.cra_flags = CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = 1,
>  				.cra_ctxsize = sizeof(struct tegra_aead_ctx),
>  				.cra_alignmask = 0xf,
>  				.cra_module = THIS_MODULE,
>  			},
> @@ -1942,10 +1944,11 @@ static struct tegra_se_alg tegra_aead_algs[] = {
>  			.chunksize = AES_BLOCK_SIZE,
>  			.base = {
>  				.cra_name = "ccm(aes)",
>  				.cra_driver_name = "ccm-aes-tegra",
>  				.cra_priority = 500,
> +				.cra_flags = CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = 1,
>  				.cra_ctxsize = sizeof(struct tegra_aead_ctx),
>  				.cra_alignmask = 0xf,
>  				.cra_module = THIS_MODULE,
>  			},
> @@ -1969,11 +1972,11 @@ static struct tegra_se_alg tegra_cmac_algs[] = {
>  			.halg.statesize = sizeof(struct tegra_cmac_reqctx),
>  			.halg.base = {
>  				.cra_name = "cmac(aes)",
>  				.cra_driver_name = "tegra-se-cmac",
>  				.cra_priority = 300,
> -				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
> +				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = AES_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct tegra_cmac_ctx),
>  				.cra_alignmask = 0,
>  				.cra_module = THIS_MODULE,
>  				.cra_init = tegra_cmac_cra_init,
> 
> base-commit: 1c9982b4961334c1edb0745a04cabd34bc2de675
> -- 
> 2.53.0
> 


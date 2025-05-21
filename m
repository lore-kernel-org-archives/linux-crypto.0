Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE6211185;
	Wed, 21 May 2025 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747835933; cv=none; b=jhiW0tKbEYHGapgvkAiiTHkCDDPysqns3BPkzrqEd+LgvmOIfBtYsiNOn/DaJn+FnvOtFmnHfiGZMHkxsjs/Z8V889KIDTuoG8xnfq7WZHgKxwtnXNzOEzjhItDnhMUwsn2sW2OIR0cXxt7gulKUU1vuaNYj0tWDMieT+QC6NOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747835933; c=relaxed/simple;
	bh=82+Fcv7k8/WK3IJaQrZQreUiL7oH7xl2lRQLtCA+3+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M8o92nlmh0peugWgxqkRv2yGZNySN6w+HKhdsLu2obIMMBteF4hzZXdE2z/A7soWqELQUkD9TdIqOh6x6Oo/FXpk9YLAqL7MgssQoYhDfGCZLg5WmIRY7GAxTH/Ab2oISL62/rrKTx3kaxd6glWc3HjSSJRdbNKbT+8Vnc+dy0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JN0NYKMy; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JN0NYKMy"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a375d758a0so2288150f8f.0;
        Wed, 21 May 2025 06:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747835930; x=1748440730; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EcJ9QyF6XxTHP1+onmIFipuIbPi5hIUZeY2LzEWe7kg=;
        b=JN0NYKMyzZaoM+wYVyg+X13qW+AXEi/ZS2lDTL2adjtjoXKg74AWLKS3mJsLlmXmWr
         x+5/olMbNepo5TNpAwE177Z+5PPHYTtvLEQZG7Kz1LmwTsO1h1Up3FkuE5raMvJBI+cX
         XD5K0PHLlExt0VivZ9BL3p+4qq6KzTU9iE6lapOx0JGCTcQhRWizjQf6f5DMsMb3tSC/
         8KZkMK56Tu9/I1Xt4QOvul7eAHB304IQn2BtSvW6B/0JXSGik9+tG27xk+zxu1/kks/m
         e11dw4MdoPaZ14X/9UzCGMfB5THSuIjG1cXvr2GOmmPgasW2ewO1oKfhRENBQzc44N9B
         sK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747835930; x=1748440730;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EcJ9QyF6XxTHP1+onmIFipuIbPi5hIUZeY2LzEWe7kg=;
        b=kP1zaZSbh8/xsaKPUFLIuB5jyhzEBjYod+PSQz3HfiO3IAAlHboGjpSHo6h74HZPbj
         VW1QCT0/XKbQsTZAxfA5XuAqnjFXT016AOHQnWsbWGyLHuoXvk5JRz4/Q0tLHwDqgjdt
         57RWqYd4l3e1KuibzPzYcfm585F5r1yTdJN6v/Qd7nkKYfZaaOk2laWkm34yrFmrdmH4
         B9D1GqERd8nzhCHHZzbdt5vomfmI8duFzKjEXi9kZCIJ1KtYaqE6p1qnD9HGZ1xH/oGR
         h/JD6spyx5WfYkq0UU2UtHwBcHx7PgNiTn8/GA1e6e7qA18+G1k28RE3IdKJOC+EqPms
         G0MQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdyB2i8dNQiN2ZtMmfZ6fIfGvrfuT7lFwnXxidKZGbc6FSXkK5oNmalrA/myy8r/wJdMBMnAcWrKc/WnIK@vger.kernel.org, AJvYcCWd6vqLnAklxzgeTWKY2bTSklUMj1YpPEaPL+5AJ9q+PRZ6zJXqfQzMql+A9dCbhSUrqVBQCLYbPKwOcMA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn914lCVtw+5DgQGbDlM8W7TAhk+Pgcd3gkArjt5bTmOYCBOlB
	HON0dZrVbNwetAeYIidNMmCnBXwxU2vOmGB1whM4+PLvovRrD8bo2gCr
X-Gm-Gg: ASbGnctW7P80ZZnh7iOHX41fMSC7Crdu6S8niTt4iPfmPj1gfhyjvUPUVMqkLJQLFpk
	bEyDKujS269f/BdiGiyuKHUtlH74dCI4A703i4/BG8nZU7Wh6wYMEkLEl898Ra2KD8p6OaE2XQj
	xmzOr/DTOuU24Vn52Ln2pXFtz4F14eN62fqNEVPX3ne+2CbrT1qx3vwCqUOj9OA5YesaWYd5Pyr
	rkITBnMimMqIfPDXjqu2CWnJUB6OhOh19fuKs4mMYYxqrTwkQr1eM3aYkaVwbElIKki1N/4Su4G
	w6R31t8CpsJZWdhwNbICHhHDMxnUk48kgkJexvvTnGy+CE7B+Xd3ApKo/+oWy2g=
X-Google-Smtp-Source: AGHT+IEKmJou6eKOZdh3bNkiAFAL1JQdTSpaHxtOtuWtj38tVZqXysBlJAZWbsx+Pa1hxmp1Ms9f+w==
X-Received: by 2002:a05:6000:178f:b0:3a3:7435:9a30 with SMTP id ffacd0b85a97d-3a374359b6fmr8525817f8f.47.1747835929784;
        Wed, 21 May 2025 06:58:49 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a35ca8899bsm19700296f8f.62.2025.05.21.06.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 06:58:49 -0700 (PDT)
Date: Wed, 21 May 2025 15:58:47 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aC3cF0-bWb-Jiz4i@Red>
References: <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
 <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
 <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <aC2uvvzlR89iVFGW@Red>
 <aC2xTI1ZuXoZjgjX@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aC2xTI1ZuXoZjgjX@gondor.apana.org.au>

Le Wed, May 21, 2025 at 06:56:12PM +0800, Herbert Xu a écrit :
> On Wed, May 21, 2025 at 12:45:18PM +0200, Corentin Labbe wrote:
> >
> > It fails to build with:
> > ERROR: modpost: "arch_sync_dma_for_device" [drivers/crypto/marvell/cesa/marvell-cesa.ko] undefined!
> 
> OK, what about this patch?
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
> index 6815eddc9068..5c46cd267789 100644
> --- a/drivers/crypto/marvell/cesa/hash.c
> +++ b/drivers/crypto/marvell/cesa/hash.c
> @@ -49,8 +49,7 @@ mv_cesa_ahash_req_iter_next_op(struct mv_cesa_ahash_dma_iter *iter)
>  static inline int
>  mv_cesa_ahash_dma_alloc_cache(struct mv_cesa_ahash_dma_req *req, gfp_t flags)
>  {
> -	req->cache = dma_pool_alloc(cesa_dev->dma->cache_pool, flags,
> -				    &req->cache_dma);
> +	req->cache = kmalloc(CESA_MAX_HASH_BLOCK_SIZE, flags);
>  	if (!req->cache)
>  		return -ENOMEM;
>  
> @@ -63,8 +62,8 @@ mv_cesa_ahash_dma_free_cache(struct mv_cesa_ahash_dma_req *req)
>  	if (!req->cache)
>  		return;
>  
> -	dma_pool_free(cesa_dev->dma->cache_pool, req->cache,
> -		      req->cache_dma);
> +	dma_unmap_single(cesa_dev->dev, req->cache_dma, CESA_MAX_HASH_BLOCK_SIZE, DMA_TO_DEVICE);
> +	kfree(req->cache);
>  }
>  
>  static int mv_cesa_ahash_dma_alloc_padding(struct mv_cesa_ahash_dma_req *req,
> @@ -533,6 +532,13 @@ mv_cesa_ahash_dma_add_cache(struct mv_cesa_tdma_chain *chain,
>  
>  	memcpy(ahashdreq->cache, creq->cache, creq->cache_ptr);
>  
> +	ahashdreq->cache_dma = dma_map_single(cesa_dev->dev, ahashdreq->cache, CESA_MAX_HASH_BLOCK_SIZE, DMA_TO_DEVICE);
> +	if (dma_mapping_error(cesa_dev->dev, ahashdreq->cache_dma)) {
> +		dev_err(cesa_dev->dev, "dma_map_single failed\n");
> +		kfree(ahashdreq->cache);
> +		return -ENOMEM;
> +	}
> +
>  	return mv_cesa_dma_add_data_transfer(chain,
>  					     CESA_SA_DATA_SRAM_OFFSET,
>  					     ahashdreq->cache_dma,

Hello

It still fail:
http://kernel.montjoie.ovh/479319.log

but I have still all old patch of you stacked, perhaps could you do a branch somewhere to be sure ?
current state is: http://kernel.montjoie.ovh/cesa.diff

Regards

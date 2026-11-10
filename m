Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794289020;
	b=kJsmVtVxfuQNicoVJ5vsDTbB5Q8AOkHki5GTqQEgBYu3MVLGPqy+BtmrDdChcwf2UY1t
	 R7hJg7FkTkRJsjKBvZqv9cTflGvesD9W4x0GR+c2m6vXWYu7YmV+zGi0aZ7IIde7doqMc
	 yAqJwmhBbogf92GT/Ha1PLpbhDsaohyuymI/5IMjXSZnmYDmrTwVqXL+O0yANfE+FFdRp
	 8dq56l4QsuezwJqSxvJn+AKLMN8GiqL/I2V5atarlW1dR03fPMlkwmRWriomvXw4GvnoT
	 L7UkJWQx4PW+UGlnGgLXstfwJK1cTfnaA2lB/SUkjaWZnaFrmOvadW41cz2t+xusNkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794289020;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=upBQHvhIXS9jA4rn/T2U6OyiZNi8Uwc76Ij6dQGz7TA=;
	b=bcMHC8n9EIoR4XojSGYKqGnf4PB+3RJ/YXmwSklebV/lXGnbEDBxVTPlHvz92IyFzi3g
	 bn/ubOrJ1dsafDTEs6JZPgtygGVfZY6GLjxH8QfNVN7mcVNvsICuiVU3GmJUVO8FB8Djc
	 zu3U+zvv66Mzp2jSgY1jJHtEMX7HlE9AgHOBoAHRNop01Z6oWAKwZLLYoEi1n+QHRvVRd
	 THkZJTOMcGwLPdTspdKC6FVOtoQtD4/HuHLT7neLRjuE1NB2Ay0/b+YC+lwJN+DN14Z6D
	 cdyXeC1CPWKQ+OpnJn+nWpLyMAF/piFrP6Ja0/TyGZp5neeVpd2t4oirUgC32/1gdfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=a20xVX7N;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57B660A2621
	for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2026 05:36:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E57B660A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=a20xVX7N
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8b29b83fdf1so684596b3a.2
        for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 21:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289019; x=1794893819; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=upBQHvhIXS9jA4rn/T2U6OyiZNi8Uwc76Ij6dQGz7TA=;
        b=a20xVX7NeZjvXNyM41dYWvLkg80id1Mtm74DkyBWYfM0GGXgLb8i1+nApuqtrL8uLo
         zE4qrJ3gNwkeUVWkpUNiFHGrdIzZeRo9Bur+lQwMh5IboV/ahqD2hnLAdr9gSwVdEq52
         47ewJ4dnUp54hAJDfsvJlQHVaRbFtqFrQtWkI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289019; x=1794893819;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=upBQHvhIXS9jA4rn/T2U6OyiZNi8Uwc76Ij6dQGz7TA=;
        b=RJe4CqDGjNWMp4SIiRwe7XNMMuLqRLaY2S3JJ+GAZbghMSNk7iqFN6Uu0DCDFHuEx0
         JyIrT6FpD5GRSFo1i5En9e3YOx3jO+xmp3APPIJfYqPQCXJ1/8WUSZsTGuiw5XwOowQn
         IV7mVTI1B8Pvv6O3dRDUsSGJScuNLEqY94lwB1FxwGGFaNps+5O8RgpsdUyYfi2Y1oI+
         3h+xLkK2zY7caCsvhPSBC5wkdGRRDBHrtorn9tqLxy15mM/XoExPLRJyp75YVjit3FnT
         Oim2a3Kw6k6dtzn/Gnt8NHQvS9kWSmP80dunlF2VO4oRAcTZOnclVxxzxWQqwSAu2b6B
         /X9w==
X-Forwarded-Encrypted: i=1; AL+hErHZDwdXUrV7KrM0jeOYLDH9MnCtNfJAuaYDfAHUVNtjb49j/uXgH39QVtq2HJ+hwKLAXYxMdOi8fCgtugE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/xx7DesmGhr5ATwMul/nShZo8Q9ZHG+IvgRYDPqsuQ2MCs4uHg
	0mYaz61eZKPqnMugu/TmhPADDMG2NKQSUP5o86n/I60oCF4n6axT3zr1OfpYRx/4aw==
X-Gm-Gg: AYBFou17pg6j+Au12j+1aNuwCnH7IDQUpgnovnST7j/SFeX9Cmm+bgol9QQkqEew8+M
	ch7/VnQDDg56c9pZBvTUBdskIAtNRSznoaVC4INm84fnh+8Q1xqaeTwTIQlKgSb5fXmutnl5NY3
	wS9HOX6Uxd1z1YCV3rcfFKUKtPdAZ4o80ZWX45NOQoezQ0WPN7k4bsk0o2cYy7fASw3U71BmsoJ
	kL/T13BgdDvzZkf4wkwWQFyIJwkP8QiKz1bQULI/Wmvtg009U3BFdlRBThqWqqj5zEZSDgPO0PJ
	BL0NsCrusdINkVBjAQar/aXHQP77X+f4CaiogGfkvngMgZE8DXhkHiAC5MWYN/Kw2WVQa17073T
	WoCR4CcQbfn4HPuxuQfdujdodNhmhnksH3J3ZX6Es0WWKrXjQYH8v7EKU9iEkO8nOhgqB+IJduC
	Eocwf0cNlI0Vi6u+tSS50Zb0G+OGA5oEGyvelBwd8APnGf8JhYgzngHkcrp+t4NeqHgxaVjixwo
	GYEPNU5YudwOmI+SYMN1B3fZGQ84scHcPGTiiV8ctVNS4bsIACuw4UxG9P+yBbyk2L/HIuDZGWU
	dUj17HLnSqc+Oi7/aiatZpafz2vaKOd3HoYo/nJwx+Op+XzcxCnrbjNv3wRv5sPHWFeTDg==
X-Received: by 2002:a05:6a00:1492:b0:89f:5c84:46ec with SMTP id d2e1a72fcca58-8ba89661da0mr1558178b3a.40.1794289019108;
        Mon, 09 Nov 2026 21:36:59 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab8dccc7sm405355b3a.52.2026.11.09.21.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:36:58 -0800 (PST)
Date: Tue, 10 Nov 2026 14:36:48 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Russell King <linux@armlinux.org.uk>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>, 
	Nick Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, David Laight <david.laight.linux@gmail.com>, 
	Sungguk <sungguk.na@samsung.com>, Jaehoon Chung <jh80.chung@samsung.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 10/15] lib/lz4: switch the compressor to the vendored
 sources
Message-ID: <avKs4_S7r6EiUVgC@google.com>
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
 <CGME20261106144305eucas1p17b3b27d403dc7d13b85cdd9a4bea83b9@eucas1p1.samsung.com>
 <20261106-lz4-vendor-upstream-v2-10-ee04c3f0d7dc@samsung.com>
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
In-Reply-To: <20261106-lz4-vendor-upstream-v2-10-ee04c3f0d7dc@samsung.com>

On (26/11/06 15:42), Michal Wilczynski wrote:
[..]
> diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
> index 1e4ad31d39a63f45b3bddd3d8a467d8d7d095beb..50265e3ce256490994cb6dae32a45da376e408e0 100644
> --- a/drivers/block/zram/backend_lz4.c
> +++ b/drivers/block/zram/backend_lz4.c
> @@ -42,7 +42,7 @@ static int lz4_setup_params(struct zcomp_params *params)
>  	if (!params->dict || !params->dict_sz)
>  		return 0;
>  
> -	dict_stream = kzalloc_obj(*dict_stream);
> +	dict_stream = kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
>  	if (!dict_stream)
>  		return -ENOMEM;
>  
> @@ -88,7 +88,7 @@ static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>  		if (!zctx->dstrm)
>  			goto error;
>  
> -		zctx->cstrm = kzalloc_obj(*zctx->cstrm);
> +		zctx->cstrm = kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
>  		if (!zctx->cstrm)
>  			goto error;
>  	}
> @@ -112,7 +112,7 @@ static int lz4_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
>  					zctx->mem);
>  	} else {
>  		/* Cstrm needs to be reset */
> -		memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm));
> +		memcpy(zctx->cstrm, params->drv_data, LZ4_MEM_COMPRESS);
>  		ret = LZ4_compress_fast_continue(zctx->cstrm, req->src,
>  						 req->dst, req->src_len,
>  						 req->dst_len, params->level);

The zram code here is outdated, it has been reworked quite a bit
(patches are in linux-next and Andrew's trees).

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794289195;
	b=Ax+0ALOJ1+Gf3/Tr/+nj/NIG1yaBrbqPBT5VMnA7a6vHG51oss/devSxzT3tphqqd18d
	 +mg99MpcWZOP0oBxhNrBq8COnZBVVKo/6zrsdx4StVakX1NacbaE9IwjZiHSGx4w2RRN0
	 MtaQE5ReH/Xp2E8a2Uo8T8Ane2Hd8C+cHPYG8XFbny+GoYY6EstFpikf74XnWcAyOoGec
	 yXKYfmNGEcXd/Z1QoZ0N21giI+gOUrkFfY9IEakQ/a3O1Y9OdTrsA5REqjafUKnY+S5ZR
	 5zx6mC9idwcKppu56V/MAgx+2B3JU6PI1AB3YFXQFPhpk1JxQDWTnNTTO1KKA/MjiIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794289195;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Y4IpnFVFMm5fXSXAtzV8xsgRv9+hQP6OGl0+r2a9VT0=;
	b=5awuFuCm3neMxcQ+xI01rp3fuKUEWudBBKWuLJ4qckbw3k2Wfwsfnwns7z4xz5sqrDHl
	 eKffvif6VOE8gFtvw8jeauemU1Hni1s4jlhQcwJgSnh0oB/ToUQ3OQPZw6e7yAsMPiUvs
	 FfqgxhO3qyh9d09gZhchP+VjHWgmrA+IFOxFn3XMzYsCHBRfRnTuuT/U/DtXuHN2//zHJ
	 AVF95zEx9MeH1mXqaXwPk+Px+GkEto9MOBHk5U+9FT61MG/SVuZuEHhK84cvBlApyWAlE
	 8/BeSsX0775ta3NVvwqbp237wbcFZ5++5T5FenrlHF6SV7/jYJ23SiRITwJjxQ+P01w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=nYCjfLCg;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D359D606A321
	for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2026 05:39:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D359D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=nYCjfLCg
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ad787e0593so924261a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 21:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289194; x=1794893994; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y4IpnFVFMm5fXSXAtzV8xsgRv9+hQP6OGl0+r2a9VT0=;
        b=nYCjfLCguMBjFt7Df/pwcAS/GPhBqgvi5e16XKr+oU3FTl4s7XEOa/w4lwVhENYNEy
         6HUfXInt0Qich4WYX2Rx0OD0rQnYQrTfrGD4byFmAPHBXNocTXgLKiro4pJRUUMPvCHC
         Ilr6Z8eXaJfgpRD2l9SSOO7VTdw3nLqZlt0Jw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289194; x=1794893994;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y4IpnFVFMm5fXSXAtzV8xsgRv9+hQP6OGl0+r2a9VT0=;
        b=ssOTiXKrfjpvfUAiCtoTfZqnjkJUpjh9x4CB0xiRyEN2cOImxDlvO7JdoW2f4TlRgy
         XGafPTNDyrNleaxz28ynwCp/Kf1YEU4zkAC6wxhDcnsAkLBpcB3yAGDPibhD/eFQxla1
         IWaxrDMDbaSFtprIyT4Ex2x3WxdIHNEQr+XWS7NLP6aW6/KVT5bEkJitfNcrbXyy5H0p
         lhHwLff+uLvQLjav0u2/LtjmzJB8thsq2dp+DekbF08qzOLiQgGn6ERr86+baReXy0+m
         z9PoDEAPeb4bsW26YNtZO9TQAy5vChBVynx7ZAiSq+pHZNkXokQFxAruy8PCcerf7P0j
         215w==
X-Forwarded-Encrypted: i=1; AL+hErExaMwMpfmGSfW1AwSRiyPyBtUFEPqqYfziJsRN1ml+40ZX+zZcZNlPZkEBEPF3fIcG8InMACVjTRrjTYc=@vger.kernel.org
X-Gm-Message-State: APuU4Z/0Zjr+6wroi84I4idbk+QMY6Ea4EmO7RUjJVpDKQp/5GCWtiKL
	DeVm5urKFLnC+Z6j2515LAGAvZWJp9rlC4UpdBnhoKvNleBK7DcMy8mx0vP/Dux2+Q==
X-Gm-Gg: AYBFou3LoNA84dIgWsPtT7iIaY/S13GNO3ncDRZXQBuTQHSaygzn+9oBrryNMV88ctC
	MXlZUDvsuowuILJAEIg+cIHrXWbEdHI+bgwLSBNbFtGvfh64fWl2HxkEHDdHFoGk/jC83+dNKEw
	ac5788n6rdjFvPfItB1upTF474SbCWGBTk08c8O1VzMUqF/cwmdkWQqTI5/g9dCfkf6IxAULIoJ
	8S0Lb/jOc/Z5V6DSX34iW6YKyOxOdN3glVASctYdgrPeIFccB/JWtPVCUcNjn2tXYNtoRHBgYZe
	09vom6jjaKX167d9G/aOqx44vfYGwsPyIzBQG6XTM1uuVEsWq8Jk6tnuic3QpD7ByVB+VadZqOs
	x5yWvsmVkitWjIYccxVsh4MjmbMiVygyovddDqFHJ6iyeTVVmvz7lLYm3oP3ke28j3AJt+GRaFG
	huEUbRdY5Ih08fJDryyFki+eCQ6NiHpbW2Hywuf9+HkDw1ADZlxKR+0nPHg0PkYhY5RPgsCvwoF
	PBX1RGtrXvXuKgO4mfcN5q49SWod/rj18rmwhlu9dCojW/DJhIz+ufqQBGuZOR+zv4eGgRf6WfC
	ksRwgh3BgDoPtUxT8oO3yHbCmEu+COHTzJOungfhVY96Q/ZyOymA4z/qE7+vdhALbJ60yt7fDRf
	u1cT9rnqDEEYVqhM=
X-Received: by 2002:a17:90b:380f:b0:3ac:9599:a689 with SMTP id 98e67ed59e1d1-3b166d02addmr1882552a91.34.1794289194303;
        Mon, 09 Nov 2026 21:39:54 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b168ff86e7sm1041404a91.2.2026.11.09.21.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:39:53 -0800 (PST)
Date: Tue, 10 Nov 2026 14:39:43 +0900
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
Subject: Re: [PATCH v2 13/15] lib/lz4: switch the decompressor to the
 vendored sources
Message-ID: <avKtyCOOmK3AH0xy@google.com>
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
 <CGME20261106144310eucas1p1d60fe5c2e0170c49f38a3142bb1d8f94@eucas1p1.samsung.com>
 <20261106-lz4-vendor-upstream-v2-13-ee04c3f0d7dc@samsung.com>
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
In-Reply-To: <20261106-lz4-vendor-upstream-v2-13-ee04c3f0d7dc@samsung.com>

On (26/11/06 15:42), Michal Wilczynski wrote:
[..]
> diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
> index 50265e3ce256490994cb6dae32a45da376e408e0..b9b8a5f678c155442fa3fd2c1984e45182e6fc38 100644
> --- a/drivers/block/zram/backend_lz4.c
> +++ b/drivers/block/zram/backend_lz4.c
> @@ -84,7 +84,7 @@ static int lz4_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>  		if (!zctx->mem)
>  			goto error;
>  	} else {
> -		zctx->dstrm = kzalloc_obj(*zctx->dstrm);
> +		zctx->dstrm = kzalloc(LZ4_MEM_DECOMPRESS, GFP_KERNEL);
>  		if (!zctx->dstrm)
>  			goto error;
>  
> diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
> index e7ee3740219852f079d1e0866da6b213a3f3a583..1e09c93016264259c149e2913b2819571b56fab6 100644
> --- a/drivers/block/zram/backend_lz4hc.c
> +++ b/drivers/block/zram/backend_lz4hc.c
> @@ -65,7 +65,7 @@ static int lz4hc_create(struct zcomp_params *params, struct zcomp_ctx *ctx)
>  		if (!zctx->mem)
>  			goto error;
>  	} else {
> -		zctx->dstrm = kzalloc_obj(*zctx->dstrm);
> +		zctx->dstrm = kzalloc(LZ4_MEM_DECOMPRESS, GFP_KERNEL);
>  		if (!zctx->dstrm)
>  			goto error;

Ditto, outdated zram code.

My ask would be to not squash zram changes with lz4 changes, when (iff)
possible.

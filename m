Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209F63B2FE7
	for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2026 06:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790748489; cv=none; b=RNoNYWILt7LMd+BMLcBmDsxGl9a/Ln7YCkmZ2OsG2RKMc7gSklwifMWcVmdU+mKzH+ua4atURhcXNwYc2JouxY7g6h5rKu/oN8FDwBmz1xtyNwoZfT9q+IVfNXbf2xoUwJf4V3YpmMrrf3ikquWj+FT4WOkVMFvz6WTVSFMU3oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790748489; c=relaxed/simple;
	bh=FQT7C9mEtUI9zyQeAiy/rz7mwvm/L9IqR2P4MCxmtag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pJKDZcnzH+2jAyESJOMvJIV1HdvjF1agxe5SafmTeM9n0q/8vSTUX+88Eua4APy0+qFZRjitunv+YBUJOF5DxENddmyN7D4LljRjSudi+ZNbHNJfGh6Ma1ZU9C+Xe/tABGs1wI1JM78/MJYD9oVRjThIv0fEOdqpKPjpDiDzf0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=GpLOQ885; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GpLOQ885"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc797656e44so1670751a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 29 Sep 2026 23:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790748487; x=1791353287; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CgFmFj2igJGpmbRflOSd7wans++uMlq7r70gUY54Vy0=;
        b=GpLOQ885YueQnMRr7aYksbM090881sDEr8Fe1usp/q0pr6fKEwx2Cglw8wGIeuqXfo
         z9+qdro7WLQlY5O7IK5f2JeUGmrO0obUFcd+Na/uUiQIuolwIOhoYcdmwDhyJuUCflos
         uNc3Zr3tAz8ZSh0r82sTNNcJOP6oSeRIpn2Zg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790748487; x=1791353287;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CgFmFj2igJGpmbRflOSd7wans++uMlq7r70gUY54Vy0=;
        b=uV8lxJBmw2vXkKNWtY66I2fsYOAKpWpaG8HOIY9eEmRLhFKU8bJiNJMreaE+Iawjq/
         domD7Woc6jYgaD48W0NXh3lZvEFf1gdTLG7ZKhc/aScLhGy7Iwqr9SHXe/Bu7DJWeSrK
         NnEb8YziSK+kXcWfX0m9Hu64UzMxESvtBCgNgHYGWLeEu7CgXuu6GWHUcWQ/KLrKdCp2
         58ehGiC8HlDxhaS7v8pkA7F6xSLTTiS3EvrweJ7iyw9r9PoXmxgr7FMyVqynMu3xlASy
         msKRf6bPbSwgGh6/HO81BpZeXGKvVx2bUc7PJkJI/5diZ0YL9z0AeIJ60thjqSjn+tqz
         n8KA==
X-Forwarded-Encrypted: i=1; AKwUvBxjbVLU7Q2OqSLfq2+iwKHkUVfJ75p4FLSbbJIjfZbwy9JiXU2MLbPXsoMelA+PHZ2IWDFP/2QkXIyFs/A=@vger.kernel.org
X-Gm-Message-State: AFuF++mcvSwm2VS26kaGjIGAwbWTFY8Lx9jbwINlFyj1Bd2MXdMQR3Ew
	FyBXqHICt+R8aK0WmXzZP+wKrykcHepqlNnEIT6TdWqKnMabvtZFxQhdNgAax13KYA==
X-Gm-Gg: AYBFou12M80zXMWjem4auL1EbXyPAK5/6TCYFPED8vav0XbDtONl7Ipy/PwmPItaUyP
	0pqutKKYzXg7y4i2/anBMM+CE4I+vdu9MN10nsMijF9HIEW78UBqlcz0XmjvqazTpdQ8UnIR2H5
	7V7/m/Rwu/+6acRemDZfz0WUYLY3RpSthnMQV3MDnL6vU7KauJFi5gag9XARfmFewrohArM+xs2
	vPGB2GHM4tXA7H86ef4wT47aY0QLZqkkw+KNudR6mjBEF/8FCv4gCo4aXiA/PGNhtSQTIvS9h2c
	Uo6kfSfj8y4FZydOU6e2BB4K2IBYsbQTuZpamKrCh0op8saWv21v1P+CTy5CJxi4X68uWqOxo/O
	ptPxA/Q3rrpKXbsw6ewIZaXFHrxiuW0cf2Zndndj6QClSvv/Uy5AflsQTX7Q4olux80SV4T8PNq
	3NkcrmnV3TQ7YfBXYluuj4PUqM9Rxqvex+2MSf47+N8R6t8jS/1Dwl42pDaTUmvm9RWx1SvThZq
	ukNOqaCtJWwinrryetJuhb+3kPrJxH76rfU0A3opLKO7Ea/zA==
X-Received: by 2002:a05:6a21:492:b0:3de:3bd5:604c with SMTP id adf61e73a8af0-3de9e87f358mr387844637.41.1790748487167;
        Tue, 29 Sep 2026 23:08:07 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:31b3:f8c3:893a:d0bb])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88725d68389sm247895b3a.39.2026.09.29.23.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 23:08:06 -0700 (PDT)
Date: Wed, 30 Sep 2026 15:07:56 +0900
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
	Jaegeuk Kim <jaegeuk@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Sungguk <sungguk.na@samsung.com>, 
	Jaehoon Chung <jh80.chung@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC 1/9] lib/lz4: import upstream LZ4 sources verbatim
Message-ID: <aryehUJml8fTy0o-@google.com>
References: <20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com>
 <CGME20260925113452eucas1p170bfdb34dfbf670a14a6f8f0c2f5094a@eucas1p1.samsung.com>
 <20260925-lz4-vendor-upstream-v1-1-1c7ffbe21c4b@samsung.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925-lz4-vendor-upstream-v1-1-1c7ffbe21c4b@samsung.com>

On (26/09/25 13:27), Michal Wilczynski wrote:
[..]

> +void LZ4_resetStream_fast(LZ4_stream_t* ctx) {
> +    LZ4_prepareTable(&(ctx->internal_donotuse), 0, byU32);
> +}

[..]

> +void LZ4_attach_dictionary(LZ4_stream_t* workingStream, const LZ4_stream_t* dictionaryStream)
> +{
> +    const LZ4_stream_t_internal* dictCtx = (dictionaryStream == NULL) ? NULL :
> +        &(dictionaryStream->internal_donotuse);
> +
> +    DEBUGLOG(4, "LZ4_attach_dictionary (%p, %p, size %u)",
> +             workingStream, dictionaryStream,
> +             dictCtx != NULL ? dictCtx->dictSize : 0);
> +
> +    if (dictCtx != NULL) {
> +        /* If the current offset is zero, we will never look in the
> +         * external dictionary context, since there is no value a table
> +         * entry can take that indicate a miss. In that case, we need
> +         * to bump the offset to something non-zero.
> +         */
> +        if (workingStream->internal_donotuse.currentOffset == 0) {
> +            workingStream->internal_donotuse.currentOffset = 64 KB;
> +        }
> +
> +        /* Don't actually attach an empty dictionary.
> +         */
> +        if (dictCtx->dictSize == 0) {
> +            dictCtx = NULL;
> +        }
> +    }
> +    workingStream->internal_donotuse.dictCtx = dictCtx;
> +}

Just a side note,
there is a bunch of new helpful API added in this release.  Currently,
we do some memcpy hacks to avoid re-init of lz4 C/D-dict in zram, but
once this series lands I'll be happy to send some trivial EXPORT_SYMBOL
patches so that zram (and other lz4 users) can use standard lz4 dict
API instead of hacks.

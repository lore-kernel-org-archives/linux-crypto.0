Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBED31D74B
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 04:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767589006; cv=none; b=XaYJ48Qa2NanfDcLf05gurS1RM2B3ci5r3dSmCsNMSYWHVsF53q6Z1JfpAUJCkI1mbwAocgtiWgIEy2WHl2t/qV9Aj4FREyL8J+Xgfnz2EwftjaSNqqr+ALEZaYvObMD1CozoPrtUOSvnL0MQNHy/K2jm5eV6qdID/VoyDymiOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767589006; c=relaxed/simple;
	bh=jBwvhnDfidsek4dpH3nFNU7R+wPfEwm8oFGbdpxTVpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WuSD/tr10xTMpsVeRK6CM+I2b80vs4KXOs4TX0lvaPUt0LpTwSWr9lxU569IU749erXbKlrkE3J+Fk2cyJwOCWaDpZnOJKAKtPxQlF0uvzh8zmOuuAHJsku0NakZva+rCyT0sBet6yV8xA81TYki3je6rcCnSSP5do43EgqJ+dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DjZdAnPS; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DjZdAnPS"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34c565b888dso15013660a91.0
        for <linux-crypto@vger.kernel.org>; Sun, 04 Jan 2026 20:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767589004; x=1768193804; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3hFH3lNfVrL079RvxBKm1qFjwG/jqKdNHXIh3f8h06U=;
        b=DjZdAnPSKhJjowEybd/uJ3UxV4OTWKNcfMD3RPhr7GOQBhEU1ggmKlEbgpwq3nYYd7
         vMjDrXkBziU78LtkXjQM6vRVvpdeUtbLuUtGpzs+mUFwiV8moSiDCztvjjZ6KfJmT78F
         XE9GUMAsvxex901xRgK8DUbCEP0oBhxREssCW+UjXtCSTVKSvjdhTUTB3jBTfhKS82xU
         ogWEp4HXMt8SBoqXAqIVM1cOVzYVjo59TK7XKFWzWMalXOsSLTCuLFLXe6uCkMvPfIJJ
         w6gP28JLvMgVR8c3/qLtEHJ4NlgRdYX9QvVd05WhbZ57HD/OBYup3pPGDa3a0+z26Ujx
         wckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767589004; x=1768193804;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3hFH3lNfVrL079RvxBKm1qFjwG/jqKdNHXIh3f8h06U=;
        b=bcrlEW24Y6bj2wnq8W8tRQEs0EOLo1FUY0/ZT/jQJEJ6YOMKMIWVv+KLjxuiY84il4
         IAuD35apjRSEtgPBrg2nMQELBF3+gJTnU4yUIYo7kW3ojLq9kOOUNUtETt71k6x/dMYz
         /rNoy5HFnIuHHiGqe7Mt2upMWBWQj0urzZu+7VsfAFvTKhHcOUW4pdGR268+ik4BADSK
         SIvl9W9c0zfx2gBXdEcrBRIK2bT1BZac74ekxqVzQlTQspxD0R1FgxFQxZNS6b1YT8yh
         39spDmr8RUr59bKBPjzYYtveTR4i0F5WQ4yrRZ/ci/aRdNuHoZYGOLUjAJyo6/yk9s4M
         WPmg==
X-Forwarded-Encrypted: i=1; AJvYcCXqJ+ePhJAB9jDhH2VG7WrmuthsPMpx/wjQ2gRflEtVguQvCgiygV2xp4Q3jBsWZbuHg69mM7KPY4E5zX0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp1bLYCRJUZCWPbLmpAQa560S5QAOj+t85dUux+jfxjwS3okxH
	zH2s5aEq3GlsmUf4Wcwo1gtAZKcQDyzfb0PNPgAZZh3dimYmMSvFAwqhUaBM4NRW5vI=
X-Gm-Gg: AY/fxX5byz4yUDYOb5sH/KU3VXT19eI94+PeUjZYAP8zu/mi8XUwThqGQL63Ot2YCFu
	rFrCkQsW2+6INpDphj7cpH60/SsNCqv4K2O2UoL6Qrac+Vds+6C/ikIZcJPWSIS5vAia8E4/otc
	EBIVXwPrkcvAmhM7r+ZqsmPN64z35RpwHiAKmISjg3OhMdNwFfqNwq8/ZPHNb39oKpEPBmxRJ4m
	fJC+bFyyuSvc1YkundmnMv9tEzGTacOdaOw9M5SANeCTZ+TmGvDFQq48KQQ+8Ylh3Bn+ehYYWpJ
	qW/vtG5W630qV+9VgkEDsk8cwC3GJJokFeNL1stqiycpH7xmBeg7u+Vb1N2Yba0316ZqbTHLKJF
	QFwEaMNEuAYS77mbW8qP43iBPe8jEuj35yyCzIZg/DOi8pwvmt/GxSXgaFbICYm0SFnvz6AmDik
	Vk+b9VXfPt3vM=
X-Google-Smtp-Source: AGHT+IFZ00gScIfn7Z/S2C4S8PPgyPbUGX5mTMlgh0Rzf0TnKH5YXmLt4fA7cx6w6t8/JqVkxOTy2w==
X-Received: by 2002:a05:6a20:918e:b0:364:13aa:a526 with SMTP id adf61e73a8af0-376a9ce54bbmr44864432637.60.1767589003573;
        Sun, 04 Jan 2026 20:56:43 -0800 (PST)
Received: from localhost ([122.172.80.63])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7bd61b4csm40590900a12.18.2026.01.04.20.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 20:56:42 -0800 (PST)
Date: Mon, 5 Jan 2026 10:26:40 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Petr Tesarik <ptesarik@suse.com>, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org, iommu@lists.linux.dev, 
	kvm@vger.kernel.org, netdev@vger.kernel.org, 
	"Enrico Weigelt, metux IT consult" <info@metux.net>, Viresh Kumar <vireshk@kernel.org>, 
	Linus Walleij <linusw@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	linux-gpio@vger.kernel.org
Subject: Re: [PATCH RFC 14/13] gpio: virtio: fix DMA alignment
Message-ID: <nyz6mnesozpu5u6p2mxrg37fwuj3sy7hjo2xkyepd3aybm7m52@7weoocg2pbs5>
References: <cover.1767089672.git.mst@redhat.com>
 <6f2f2a7a74141fa3ad92e001ee276c01ffe9ae49.1767112757.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f2f2a7a74141fa3ad92e001ee276c01ffe9ae49.1767112757.git.mst@redhat.com>

On 30-12-25, 11:40, Michael S. Tsirkin wrote:
> The res and ires buffers in struct virtio_gpio_line and struct
> vgpio_irq_line respectively are used for DMA_FROM_DEVICE via virtqueue_add_sgs().
> However, within these structs, even though these elements are tagged
> as ____cacheline_aligned, adjacent struct elements
> can share DMA cachelines on platforms where ARCH_DMA_MINALIGN >
> L1_CACHE_BYTES (e.g., arm64 with 128-byte DMA alignment but 64-byte
> cache lines).
> 
> The existing ____cacheline_aligned annotation aligns to L1_CACHE_BYTES
> which is now always sufficient for DMA alignment. For example,
> with L1_CACHE_BYTES = 32 and ARCH_DMA_MINALIGN = 128
>   - irq_lines[0].ires at offset 128
>   - irq_lines[1].type at offset 192
> both in same 128-byte DMA cacheline [128-256)
> 
> When the device writes to irq_lines[0].ires and the CPU concurrently
> modifies one of irq_lines[1].type/disabled/masked/queued flags,
> corruption can occur on non-cache-coherent platform.
> 
> Fix by using __dma_from_device_aligned_begin/end annotations on the
> DMA buffers. Drop ____cacheline_aligned - it's not required to isolate
> request and response, and keeping them would increase the memory cost.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/gpio/gpio-virtio.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh

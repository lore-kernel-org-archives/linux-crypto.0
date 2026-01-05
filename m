Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5280324B1A
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 04:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767589037; cv=none; b=Z2RVouvIVg7X2w2HVahuUT9Y1USAWd6JwF7c2vB2lsXraCnrSCvL3Q8KId0U67jARfpgOKYDZ1FFRBxDD/8M6fJBs5t9LfM4RUNvqGaxKa0bItdZjHf+WHQzJ2D6EvKxB7PC7RrAVlx44J6ps+vEjUpbfWQulUW5VAN+VMliwsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767589037; c=relaxed/simple;
	bh=wdM/b8hJbUaslNLfaUyaSG8t8yHTFzri8J0kMFatf2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Acz3kkG9GWqQzyk8r5JRklfAJ3Tz1ncZ2GK2M6WHwMV2GRn8dHePukH0zzDJ8Tl3fkr1ok0ni+sefPF+clOx3yb5hfbnyJMpOdueF0nYxFLlrbe75K/jUdcEOq2JAF+G47zN3KPqesy6hsGJrW5hc+pGqM1pCVFuHtgfpaWX4pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ho85gyha; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ho85gyha"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34ca40c1213so11676811a91.0
        for <linux-crypto@vger.kernel.org>; Sun, 04 Jan 2026 20:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767589034; x=1768193834; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EOEgCzmZP0GTJHcnce/bEe96Bif2a5t1CJ7MWxViYzU=;
        b=ho85gyhaKzhQd2LkobbDGyUs+P/owvm/KOpiZS4dO+Gf4YuFWvgFamob9qdCJ9r9lk
         CLr9/RyFtHqQFUBotNoAM7KhHAtZt1Jp5d0KrfTfEbwagr6SxMdsx/4fE0BSAkcxMDYW
         hBxIWUZzrdi1VxRIajuMMCUWM94J/ABCw0OqR1S9Q7KJQTpTvaIEnHNlkPc5J/4jESGd
         XTIkIW6zDUqzcVTAuqoCRGwL3BR2rGk9MaM3FmQJSNYeqluqV2cf553LNAaO+Ru5IIr6
         vpnPaBULT5dfb6ydqqvBTOTjU7RSO1ix7RqULQUiOx2UaSolPasj3CB9WpJAXHp8n2jn
         ZWag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767589034; x=1768193834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EOEgCzmZP0GTJHcnce/bEe96Bif2a5t1CJ7MWxViYzU=;
        b=m6JnMqL1uARkVWLOK74C+6/rthoHhi4jECZreDBw7UWIIavAdypT2i+NvdDUMH0Pgw
         UhsgK/U35JkNPxWsJDjUoPvYsgtkfpNN5cnU4gr19CN6ycFAqBk0Ol7OAYGmLJLcEe/1
         eAlSGNxPat1O9+oc7KrFNO8gQLzHT1vi3v+Kj2ItBYPOy/8kSja+GiS+SKKOzEMx0QVA
         9GAfgVImYk08ac6iVoeOl9UriqiH6FXLAo1VdbBAvFM/oP/B3IIW8YNS3xP/34gBJ+LD
         Z5MRY8tmYLjnnz+CvaWbTc6gPoFT8tZt/BG1Gxmcl09UXxwzamNBlhX5WfFOkkqfWhfb
         Egdg==
X-Forwarded-Encrypted: i=1; AJvYcCW0n4CRwU44mprCJo/RbNYZtdO6GQYZqYpENi7FF7/11sArS8maBTqHEgcfIeH4yhc0uIMxFsCi4oufHko=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh57zLp8ZhYPNHpph2YBSY/Lf6BsIBjNwnl5oScKS4NkH4MpxW
	vkuNJ7YkBKl9tbrhDfnfh5SoZ/LEWuMZTQ8G0SYuYo4C3O0XmD8RKiGt+eV0SlL49Ks=
X-Gm-Gg: AY/fxX7diK15KR+vQ0+vBA6LcNyMEduEcce5/l/yDglKYZllek5JIxG9b0g1fUhNMj7
	GnLCT0ktK6BBL/c2gdvUtF3F5UF0qYJb9Mh21ol0dcJHZ4foBckUTU0l2/bKM1YzkOXjajUFZjM
	/18Rkdiu1PurTC05gB8CmJZIqbbW42xOqUT04Yh1jOMIS28O1UHCg4L1ocQJImIfdVYBY+7JBLH
	VwvxebIrfyY1nKt+vXaCJuGXogqUYryii+xh2D0MeDUm8jY5mu5F+6x4YQYoKFUXgbnxHYzu8Ln
	zMsT/JHAHez3D90m6wvz8+e9QV2qRGK9HPiHWk1auOKIiUs//0g9cfYBj4aYO4fr/TT3TREm/+/
	vnwHs+f0+JcCBAdiVwwOmm1qWzuV7Aiv8nfOIFFCqd4ZG7Ula7Mk+V3V0nBIZve1ssSc5kZwjIP
	E09qUw7zyOLPfkI0fXAg2SGA==
X-Google-Smtp-Source: AGHT+IECK/LcBFPZYYyRh4cCx6nIWU2Vivu4V4Wo0++VXRb6DotO+ATVsJPLekWH+2yfoIoKe3qHow==
X-Received: by 2002:a17:90b:278d:b0:32e:3c57:8a9e with SMTP id 98e67ed59e1d1-34e921f0439mr39742351a91.35.1767589033897;
        Sun, 04 Jan 2026 20:57:13 -0800 (PST)
Received: from localhost ([122.172.80.63])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f476ec31dsm4899585a91.3.2026.01.04.20.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 20:57:13 -0800 (PST)
Date: Mon, 5 Jan 2026 10:27:11 +0530
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
Subject: Re: [PATCH RFC 15/13] gpio: virtio: reorder fields to reduce struct
 padding
Message-ID: <w6to6itartzrxgapaj6dys2q3yqqoz3zetpb5bejnjb4heof2c@jkhmal3chyn2>
References: <cover.1767089672.git.mst@redhat.com>
 <55e9351282f530e2302e11497c6339c4a2e74471.1767112757.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55e9351282f530e2302e11497c6339c4a2e74471.1767112757.git.mst@redhat.com>

On 30-12-25, 11:40, Michael S. Tsirkin wrote:
> Reorder struct virtio_gpio_line fields to place the DMA buffers (req/res)
> last. This eliminates the need for __dma_from_device_aligned_end padding
> after the DMA buffer, since struct tail padding naturally protects it,
> making the struct a bit smaller.
> 
> Size reduction estimation when ARCH_DMA_MINALIGN=128:
> - request is 8 bytes
> - response is 2 bytes
> - removing _end saves up to 128-6=122 bytes padding to align rxlen field
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/gpio/gpio-virtio.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh

Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E0032F747
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 09:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606050; cv=none; b=Ye28E1x0EQUQw7qEkLk8MbDrkuepX2A2BooqTo9gE2C94rVJFqIDdGaifOBP5KgpZjCnV3onv32J2STxUiuwGqv+Tw+ZlB6+rovCNaQLPbgvxmFHgUBtScPitRwNpYBpxZxeG/xHxHNi5FCu2wYycrXfQKLEL4rZHdmTeIIIoPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606050; c=relaxed/simple;
	bh=kfKJrQ5a7Po2zi22PzxrbpGrQhRcJMv+xYYFiP1AGz8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uizENka6VUeCM5k1WZg9acYZi0LjRyUC/p7eaqWAHA2zpIf0GEfwFxfU8wSowut7u6MU2kbMduYRqjHzhRfhfzyYsIPLPcEl5YotVJTFgOVym7HpZEDKarNd/Z/OfH6bkXk0w8AHlAOE3Ds+M3w3m3ELp7KIoVPD/wj/UJvoR+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bqTttIPN; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bqTttIPN"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42fb8388c35so512040f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 Jan 2026 01:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767606040; x=1768210840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uoPF4qbo+ysXILWF9RMN1mDoAoivYGl4rzNQocqtbj4=;
        b=bqTttIPNXYA02SvzTJN+Iq2teAV4gvhztpFmGuTDYNQmZSW73vvAB1E9iAMwQAdG95
         +2dN6IzaMbz96nWQwBsJuSmXZEKRAZW6cGZNlG5prU3nO/SaQLFCAsLrDDY1ehMxp5h+
         z/AMR8rEXiTZLYVksNz1E4ouEDHzfO9p17we+pJqDgK2Jn5N4hh0imjGEBnl2wqDQDOd
         ORs5/0peeGMBqvb1bzqjT8PY/f+CUXiWQJUT/jALouTFuJNYCGLZ7rZL25+yY1KxBbAy
         JlS6gdFy47ebCoiUqTo0jN3T9SpiOTqtc50xJix+6jvOH+Q0OFRVVePn2z61tJQF8SnP
         2p/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767606040; x=1768210840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uoPF4qbo+ysXILWF9RMN1mDoAoivYGl4rzNQocqtbj4=;
        b=d0k2WKKSzU+MP7QgukyUWmPYwwgetBFJsbqCQghk0LqHXRB1+DwOxLIS9rynsQgHaw
         r/nD/E6TIUJPANoeDpdRQdwDracKM9q8ta5iqbArbgkvkYBfsrruJFBITdXnFf7rp1O8
         jEchPXjZITo+JvkcQknjC/IASDMOo4EQ8Oh3df5FB+/cWTNex01h1lioA4nQJkC2QLoR
         1AbZ/YNuIWTfF24WGzzCfG1H42c0S37qk9XkkPJBmVaI0eO5NKau4MwAczN+TUGyysfM
         JB8GkIBCTv/0s8JGByiSEL8a0R6k1nxWBUxvm/NiIbWy+4nb60a9Uad3RUiJmrATRfbt
         wB/g==
X-Forwarded-Encrypted: i=1; AJvYcCXNL0TSZilhLJXDmmVoe7eyb/usW9YSf7sZPetUOXggHQZz/PLRy7pBob0i708oMJ9Tebd9JB+aDL7QwlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCJjW5LJxXhJlUixe29y8EgWlNmpaUbYjYizGXQP2ngQ0TomFB
	sURBP7Tuacij4YGUnfpz4F5qkk95qkebF+kSq23mvIysMB4ti+zppNbnNdMxfU70M1A=
X-Gm-Gg: AY/fxX7x2YdiN0leLqrSKLqqJQGRdBX28dcXpeUUcdQd7MRjwZ3TsePMuMeK5W596dm
	s7pN8qVq8tkMOr0vF9+GRHnBmGJA/YiKO84HRT53XAhh8pZlCcvAlnfFR/3Cs7dR5FhdtL1Em2A
	zZCWq7To+ZJ4iO0JNXl5kQQn9RHD1+jnZ7VotrND3iO9tAlsB/cJ2v4TcURuYYEJUCgsJtV8ZSO
	5c3WpDAorsVtYySdCGKt4GLFVETwY4VOed2dIqiTNgQzqyYwxCRCqclsie0FM/jA9oBIy3Odhzw
	xPk5bd/A211tJuS1zvij34FGo0mywhpHjlRloAmcKzDMUkiHGNs3fm+92sk6ipjGL0vwxMesOzL
	xD9oZViGC9YlmtDuVe4vXgDmfB37xfuQS8Kw6YOV/G3z/q2Qdr5PBTZrNgE1XkXpDu68iWDf0dw
	D0g/CpFB7AgoKwC2X5wu1r2hyxONn0+snYAtJWOXddU//gY/hkcoUFlfjbZy2pDO1H65gAkHRp+
	6YPEutYog4WhFs=
X-Google-Smtp-Source: AGHT+IH9uJ6jLlQ3sMbfjfqB2tBZwtUo3Z4YZNjyI98ICTrDJSXZI/68FFDolBTS/hTy3IR7RjNHZw==
X-Received: by 2002:a05:6000:1841:b0:432:84fc:46bb with SMTP id ffacd0b85a97d-43284fc4782mr21485079f8f.6.1767606040029;
        Mon, 05 Jan 2026 01:40:40 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324e9ba877sm100563291f8f.0.2026.01.05.01.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 01:40:39 -0800 (PST)
Date: Mon, 5 Jan 2026 10:40:36 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Eugenio =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella
 <sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Leon Romanovsky
 <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski
 <brgl@kernel.org>, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
 virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 01/15] dma-mapping: add
 __dma_from_device_group_begin()/end()
Message-ID: <20260105104036.09a77f13@mordecai>
In-Reply-To: <19163086d5e4704c316f18f6da06bc1c72968904.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
	<19163086d5e4704c316f18f6da06bc1c72968904.1767601130.git.mst@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jan 2026 03:22:54 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> When a structure contains a buffer that DMA writes to alongside fields
> that the CPU writes to, cache line sharing between the DMA buffer and
> CPU-written fields can cause data corruption on non-cache-coherent
> platforms.
> 
> Add __dma_from_device_group_begin()/end() annotations to ensure proper
> alignment to prevent this:
> 
> struct my_device {
> 	spinlock_t lock1;
> 	__dma_from_device_group_begin();
> 	char dma_buffer1[16];
> 	char dma_buffer2[16];
> 	__dma_from_device_group_end();
> 	spinlock_t lock2;
> };
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

LGTM. I'm not formally a reviewer, but FWIW:

Reviewed-by: Petr Tesarik <ptesarik@suse.com>

> ---
>  include/linux/dma-mapping.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index aa36a0d1d9df..29ad2ce700f0 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -7,6 +7,7 @@
>  #include <linux/dma-direction.h>
>  #include <linux/scatterlist.h>
>  #include <linux/bug.h>
> +#include <linux/cache.h>
>  
>  /**
>   * List of possible attributes associated with a DMA mapping. The semantics
> @@ -703,6 +704,18 @@ static inline int dma_get_cache_alignment(void)
>  }
>  #endif
>  
> +#ifdef ARCH_HAS_DMA_MINALIGN
> +#define ____dma_from_device_aligned __aligned(ARCH_DMA_MINALIGN)
> +#else
> +#define ____dma_from_device_aligned
> +#endif
> +/* Mark start of DMA buffer */
> +#define __dma_from_device_group_begin(GROUP)			\
> +	__cacheline_group_begin(GROUP) ____dma_from_device_aligned
> +/* Mark end of DMA buffer */
> +#define __dma_from_device_group_end(GROUP)			\
> +	__cacheline_group_end(GROUP) ____dma_from_device_aligned
> +
>  static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
>  		dma_addr_t *dma_handle, gfp_t gfp)
>  {


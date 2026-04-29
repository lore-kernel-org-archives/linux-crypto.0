Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE173B19CA
	for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 08:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777451286; cv=none; b=QMVg5XEJv0Sxva5nyYhiBd+PMe/MZFUdtAzGjdsK0agj1rvaJ5dp4UzRgplc2nbtQYrGoEZ54/eU9exRt0ljZwjFrZF1Dx4K8N4dCFx/kBLWLAGvBjD/pfM1RpXja4NAXBnR2Dke2KRA5vJro8uyPWAZR7T2AY1S62NDYMWJDUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777451286; c=relaxed/simple;
	bh=bvamQ3l35cFLPtZdqvVZiYpwIVHhkDduX/ENHhE2C8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tbGmnfqObkRy9VEFblo5uGiUgWvHsGbOrroQ1GWX8jgbU0HCz6mauYy4j5kUGtJ4+vvgRNb3+SAfPa0CMfGG/0s5uD2jw3hOM/eYwNHXraTlrudUqOqr3yAFvGDkkCeDB5A2iOaEC+dptipoG454gHP1tBKi+fOaB0loSlC35cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F941fKa3; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F941fKa3"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4462f8d2488so83107f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 01:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777451283; x=1778056083; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a6r5zoRed3cna0I19y5JMpbpxuUFXytgkFqQKV8Cc1c=;
        b=F941fKa3GvoCqfrf7eqkLj8U6Mz6ixqTBOuiDaBnSyC3MFi0xUyuPQd3Pb3tCQixmi
         HgUTAKlhYvztaOCCqyIREoL833OYe4vg0b7p+KtnwZYFJXwb4Xj0WYwtQEzQzsuGD9vK
         HzKJ77Vp9oHLuhV5EyYalF5r0LsYFW2XLFdHNWKo2Zj9cBfD0pf6BhClJVsgAuuK/OLT
         jxjWC6X4MSREtvyolPrGCCMbPzHH6KVaXGeCLtnARaakIcXz2JY2eAjW5vKfitPW/Fs2
         kjIqxysLDvyWfedKqCGaud9NQDbm1H0eyimReaPkNqFmURDezuXoaSJfgHPMBASNfMQj
         asYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777451283; x=1778056083;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a6r5zoRed3cna0I19y5JMpbpxuUFXytgkFqQKV8Cc1c=;
        b=eFOuDD2FIZ/RjCuBq1MbetJZCMWIjncw5KGlRjYRNimNl2BShd53CD5gCEcCntpKMw
         +v7+HmPxqS+LStu5Wp/rbLfqwUdQpZCHPLFoISGQFligy2BsYjCqvxLfWPQVi+QQnV7Z
         akxx2KgsWabcT1waOyCDUTXd6hAt3tzL1xwIb4KomtKjmlZ5mgnJLAf2zQQuPi5Wxmp1
         yxdh4FiSbM6B58ni8Y3+jAS1lCIgbLNu6vso8SLMcza44j1pIds3XwOHB6pZJBELiNk3
         DgqElbhZVzMxMbw17/X/A7HL/Yh75v+Ly8eVNDoLMSDaSypaooBaiLWIK8B68AK5O98B
         0Avg==
X-Forwarded-Encrypted: i=1; AFNElJ+ujNDiBIe94u7v52BsGhO4JjRiKDLgjUEWw+0gbknjQg6AqGYpi2uS3r82Sd2PVW4Y9kjH4AC4ejJkRsw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwunpNq+DQVXSNM1j2etUt7y9RbicIHtfF9Tz8uUmgrDAQNpH5/
	gZh9p0zQBwzvQJ5huP0x+/02B8TAU86/CenY4Fa+nUUg9JL6C8URdxLCa5ixr1ne2tI=
X-Gm-Gg: AeBDiesAy+wmI6mFlDZ1ax9Ao8WN6iUVdDLJUntGzytrosifrl7vHRPEh2w5NOp7Cql
	RsF38FJp4WZGWCZNrBY4ZXb5pIRfzpk033VYJhuM4N3eZG1kgZKxOCu23qYWc1Udn0atUympA7d
	YB07F+LOo5oi1sR629QAxskD4p2VMfV230LrKG+0nIV9Y4RlIc3KjiIiJC8nSNnxG26rBA3mIru
	1ZWdqPZ/YxPikHy/+TWpUu3XU8lUrg9qNQCld0V+7pSuef/CmbNSH5u5iDGDT2DtKl9w+6gDU5Q
	h3WW6n/nfVZpFHWOJBX2X96+6GNaB/0fPWElSTorjIjNdAVp+SD+q7uSGXSkrdSx8TAK2OBT4UT
	CMh5ovH5LDj+Xkse85+IIFgEIHjERTY0QztkKpu79el4rrWTlxrzFFX/J8qBiFhbj7de9oNjLjY
	Wn9hxusfQPTR566eyAFuU0ozOp2fe/y86S8xe3+yhSe2Wa33c0K/e1sa08yquj+6a4HcHH
X-Received: by 2002:a05:6000:299b:10b0:43d:1d3a:b60a with SMTP id ffacd0b85a97d-446425e4722mr3931356f8f.7.1777451283369;
        Wed, 29 Apr 2026 01:28:03 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b7217afesm4158791f8f.23.2026.04.29.01.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2026 01:28:03 -0700 (PDT)
Message-ID: <2d996917-60bb-4ef9-b397-65decf3b296d@suse.com>
Date: Wed, 29 Apr 2026 10:28:02 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/slab: Add kvfree_atomic() helper
Content-Language: en-US
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>
References: <20260428161419.94695-1-urezki@gmail.com>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260428161419.94695-1-urezki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

+Cc SLAB maintainers. Please use get_maintainers.pl next time.

On 4/28/26 18:14, Uladzislau Rezki (Sony) wrote:
> kvmalloc() now supports non-sleeping GFP flags, including
> the vmalloc fallback path. This means it may return vmalloc
> memory even for GFP_ATOMIC and GFP_NOWAIT allocations.
> 
> Freeing such memory with kvfree() may then end up calling
> vfree(), which is not safe for non-sleeping contexts.
> 
> Introduce kvfree_atomic() helper for such cases. It mirrors
> kvfree(), but uses vfree_atomic() for vmalloced memory.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/slab.h |  3 +++
>  mm/slub.c            | 16 ++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 15a60b501b95..2b5ab488e96b 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -1234,6 +1234,9 @@ void *kvrealloc_node_align_noprof(const void *p, size_t size, unsigned long alig
>  extern void kvfree(const void *addr);
>  DEFINE_FREE(kvfree, void *, if (!IS_ERR_OR_NULL(_T)) kvfree(_T))
>  
> +extern void kvfree_atomic(const void *addr);
> +DEFINE_FREE(kvfree_atomic, void *, if (!IS_ERR_OR_NULL(_T)) kvfree_atomic(_T))
> +
>  extern void kvfree_sensitive(const void *addr, size_t len);
>  
>  unsigned int kmem_cache_size(struct kmem_cache *s);
> diff --git a/mm/slub.c b/mm/slub.c
> index 2b2d33cc735c..b096677c8152 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6802,6 +6802,22 @@ void kvfree(const void *addr)
>  }
>  EXPORT_SYMBOL(kvfree);
>  
> +/**
> + * kvfree_atomic() - Free memory.
> + * @addr: Pointer to allocated memory.
> + *
> + * Same as kvfree(), but uses vfree_atomic() for vmalloc
> + * backed memory. Must not be called from NMI context.
> + */
> +void kvfree_atomic(const void *addr)
> +{
> +	if (is_vmalloc_addr(addr))
> +		vfree_atomic(addr);
> +	else
> +		kfree(addr);
> +}
> +EXPORT_SYMBOL(kvfree_atomic);
> +
>  /**
>   * kvfree_sensitive - Free a data object containing sensitive information.
>   * @addr: address of the data object to be freed.


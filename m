Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590314;
	b=xQOGyQoALGVUEeV05tg5MRX58Ok/DzqojmcR4h2aZAyloAnSySXquG9XbykhuzuzNiN7
	 w1JRgCzNTw2KrNz2XMqkUdEOEc3vxevzwN08I7B3SQH4oz04XGq1r4EUL7zwIhXcQqh7a
	 aKSyIi48+jeomNPu9n1vRnyj/0f4kEs8d0i5a63pCj2qqMg8FEDwT2jQL2Wad95/e5oRo
	 CxGNCa1tlqFmZanEX9MLkEuCKiOebCM+cfqoAqiiJkFC+pjyP3NLJpysJ0AhkhWuUlsr3
	 zbRyWnsuSOJmLbAQRByG+DG3iuIjFxjbUmPOqFvemrrj4H3eWDOsTnbzJTzDuiFLuOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590314;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=hnhSF7Az6Z9lY2PNjeRQ4LQp1XBnKkpuWvbgZfPvipQ=;
	b=VgTw4RuDCaWKbBKVElTpGjQ3NResLQVbhcXFaOQcYUmhcojCi1w3Rn8WeKybkl1z9H3J
	 1T7BxsSYKykwQZh9bz4Ztbf6RC8AXANxBQDOEb8sPrskBGMq+FqMhRBnS/Xgo3C1BEUYM
	 30X9Fllr10xPdq3rbPji9IXplWihJsb7ZluNqm5UDPVKi03P3wrRGF5rmlhT7MpQVRBPb
	 zL5VS/jgvqdLANMgzgsAuwn+j2m2m7P4t7j6poZrCzu+szMHGJFjCAknC8+03pZOjGbiX
	 FtvlkbRiT3zR1fCLpJSQkBhV1QeVcqYsjh3otGM2ZsU/8qK6f5NgD3MVsOXa7Ob5wFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=UbInh4Sj;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72146607D2E3
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 17:18:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72146607D2E3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=UbInh4Sj
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8b5c3288e6cso559275b3a.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 09:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794590314; x=1795195114; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hnhSF7Az6Z9lY2PNjeRQ4LQp1XBnKkpuWvbgZfPvipQ=;
        b=UbInh4SjclTw3m9sFrAEO7wdu2DfXCd7BAfmA+mmL1eQXzHGJVs3SiLI8jfyrizMJo
         1tlZcvJj2J8M1KgSnRdWTjdls/BdnSvxp8nPua0FdH202+fYd8iGVZxsgr5kIms2mHPo
         L05c/z2bcQ2+N2UnSs6YycD+ZROaQmh8IGZv0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794590314; x=1795195114;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hnhSF7Az6Z9lY2PNjeRQ4LQp1XBnKkpuWvbgZfPvipQ=;
        b=wIoH2Jh2D5xQAKsXn1mHdDh0DZM2yyR/EW8zju51DBePMqzEx47a2/iaINbHi2E2sq
         fYKMy9g6W2I8rvJfyn6tgtOaPA43xGDH2Vd0+/L+aoDj6qZQpmYbFjT/fLjYP7wvth2l
         RKKsXxXM0VUEd4i4CM4mQiq6rNX0nMLfpSXWGweZYmNROxq33A+9gkxsMAKU27rxajh9
         wAPjEWXMwDq7g6dU2J/OdKpj8Kid+wLVVXRwkhd7z3CRXAW5Iki2RCjnRw+PMXx3HgLu
         VfVDHwT/cGTKkdsI00Tt6/6TA+R4eMmQszlxBMGxW2QfW/02FaZ/rX2uUkubpF9hQxif
         FXwA==
X-Forwarded-Encrypted: i=1; AL+hErHQm1TTc8wv3tWkyTq7vRQ67Ac2YwIzugcBz50tuNlmez9d0FBY7qAnkIVs8XP2huJ3HnA1wt8QXJ9nBec=@vger.kernel.org
X-Gm-Message-State: APuU4Z+efXFzuqG7vT/1W9q+5qsZC1k/9jOKA5jGzjX0cDjKlG2AQk5N
	JKCtg9tdSnDcARnp94PKCVMu1R593Q6tJQRCr1Kngu2lZhO3OAo6jhM7WYeFafrR4vU=
X-Gm-Gg: AYBFou1FLSceiog3vIvrEFpFhqFIp7QL7aOrFrIk6R7sE+gpZphFq2CIB/Wqv6tyvv2
	8/tD8tm6ArXYC70jDyyNeOAohOX6lPaINon0+ZNATCTTUNGE9ZJl3zuisOiG45Np/b32Mj7eK2q
	KGcS3sMvoVTzPPF2OK2KO9Kml91Z/sdV1y2KPH3NmhVftrM3AauD+mQolUFcejeU7Dyqns5WFCO
	G8MniWKV5Nt8fhBGhQK48AWmmDIVUPuc0Y8j1OdB6QhH2r6910+SLiNFN94AHxpygIBI/mv7VlV
	FWJnhNrlSCA6Gfc7D0oHCDEXGBz0kC2tK7pNr96VWHL26+ahGP9InJsVry7IkYwpAdCndgDpXfI
	iJ8oYyMhMJitfmCVuxA5MWRucdAKHKC/wfjn8jtY2QrGH56zGm3U7/0MlCacUqVX2pK7/KJMpIO
	GKaVzAx0XQCnb7mV6dFYOYwdhsC4Edr5zXxyHmhEHu5vuAQWySUUDohso6CEqjM+D1Qf3nrqqDQ
	LtXvUdLW0SR4Bvfz5raiQKp3dHfOl+pYtKYQwxWtohXA+rEVBNdPQ2Hgd4Z/bBINK0wnTwMVS/4
	ihyUHIkUq5jmUnBBHQBUVCgyl4hxP8R6G3vqvKrZdh0pjtLYaBNpyumWIpgrRdTjUgcT3RGrtF1
	9G6vODc66aTr5Rpszse4S2qULK6l74RH3ZK0+Lj7Bn2PkEXtc8Qu0hOBJ3b3zzv3yOdcQWEdLLA
	E/Wf1NfyFkg4xclECVdie8hBeoAxWwlbytltZeZUek29XpdSI7X1R70JbOJ1Y=
X-Received: by 2002:a05:6a00:2c89:b0:893:12e5:c07c with SMTP id d2e1a72fcca58-8beb619a61emr2835248b3a.27.1794590313819;
        Fri, 13 Nov 2026 09:18:33 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed1a6dbbdsm1460009b3a.24.2026.11.13.09.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 09:18:33 -0800 (PST)
Date: Fri, 13 Nov 2026 09:18:30 -0800
From: Chris Down <chris@chrisdown.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, terrelln@fb.com, dsterba@suse.com, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 1/2] crypto: zstd - use vmalloc() for stream workspaces
In-Reply-To: <20261111153532.1036709-2-usama.arif@linux.dev>
References: <20261111153532.1036709-1-usama.arif@linux.dev> <20261111153532.1036709-2-usama.arif@linux.dev>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113091830.c58bbfda1f249304@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Usama,

Usama Arif writes:
>Use vmalloc() and vfree() directly to avoid the high-order allocation.

vmalloc() doesn't avoid high-order allocations any more. Since
a06157804399 ("mm/vmalloc: request large order pages from buddy
allocator"), vm_area_alloc_pages() first tries the largest order that
fits, and splits the block up afterwards. So for these 383 pages it still
asks for an order-8 block first, then order 6, 5, 4, 3, 2 and 1.

What the patch does avoid is kmalloc() rounding the 1.5 MiB up to a 2 MiB
block, which is where the 516 KiB per stream comes from. Maybe say that
instead?

Once that's fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

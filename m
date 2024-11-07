Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9341215034
	for <linux-crypto@vger.kernel.org>; Thu,  7 Nov 2024 17:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731000692; cv=none; b=WJmtubeyYHjZxSCZOu55hqi432HE1IGLUGJnW4s4vLVQY8T2s+ona2BAm41ciS+3KCHO5oxkBdhYk7EjsmvnmaFxxDDV114unpkHTg5G6GURVAGhzX2Z9OfJpojBfZZUMryajzTAVdv5NGiUnrGgTAAA7grnRPHMx6jnMxiHlxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731000692; c=relaxed/simple;
	bh=SEx+/U30fqNvvjSFTG6xjgtq4mLvscYki2ck/E3wgG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9dRSRRcL0qjzgkkhGd/10cS8r2CYLEPL3wLGX9p7NqKUVE8SxkLUXGX8m9X8O5dZb8Bs1iuDtPZ3O2RzbFgmEre0RVI0nI7HqHmiR1trzCm6ujgv06JY8T4qpTWZfE8nTWDBBWrIIOPN1/q0tEvj5hZJIx4oVfoZbcLHuxrWlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=AtYGdgJ3; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="AtYGdgJ3"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6cbe9914487so7776326d6.1
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2024 09:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1731000689; x=1731605489; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/52dHnIzYVGUdsWhfYMIa1Gi94aRC9NLX3XTIQyp/vE=;
        b=AtYGdgJ3hy1pAx09Flqs3LPOM9qzsReMIz7Q79VSJSt7afTWy/YJYrvSoD2HE6btWy
         vmkj9sMaWEM2t3/rcr2hJBRIefXb0pk8Ra0t9C25vtbQpTeu8PXgZjdfnussmF4tpe4R
         KTtJJJ6QwGhR8jyZ7IRjguZ+uK7WYi3aXn2q7pFLuj5Tnf1in5FUD4vyd4D2Oa75CC79
         qkuoRh4FZTZmdyfhr4BJ3LI4X0aXy7hr2eNtmBtQYkXHbKG990lIHuWMVEaZQzmEUtdu
         ek8h/sbZBxy/dJ6NECX362gRVCU7H6C9njJ5m/EwUK8M6oslLS0Gq13I7M1dscZJ0niG
         4GHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731000689; x=1731605489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/52dHnIzYVGUdsWhfYMIa1Gi94aRC9NLX3XTIQyp/vE=;
        b=NOt/15xYbZy5wEDisYhGgQiE4srEbXbYrdIgtuqJ2e0RNq4i7wQcU9yFPkIoaE6cQF
         A1Ouj6qb3EaOmVDg8KUSJWxmMAQGQQu1iNlCKqIFckSOCMMSXKQf7QS2FlX4A/RtSJ7Q
         v66U3UqCBqAqflM76d1TanigdkHfNIdOch7vrBAH9/u0Xb4l8wLQv7NJkSlYr3XsduGX
         JwEMuHe0oJkiway55cYMSa0CuEnUlHM0VzYAKtoJAoC0xSYvigH12rgGMVVQQmJszriI
         8eBwEeEXR1nkPUie1bbAnwP2xVzeatQFFbuNsCEWYZWOC1ToZli7fSZAhUVxdZ9N9RkI
         oxeA==
X-Forwarded-Encrypted: i=1; AJvYcCVIJ/foPVmr1oCa896m++sE4hSfcNnnI01baxLEnYWm+K7+BsBliZj7cNxqsjHIu7qaScpqngVKF0mbE0c=@vger.kernel.org
X-Gm-Message-State: AOJu0YypSQT2p4GRSutd3ayqjMWb/r8zDZrdWhiThNradRr3KkX3Yml2
	YHJGoPZ1Cu92qnerG0HiRUHldMN2n5N6FDild39zjNhK40Qlaa3LjJLFFRivbJ4=
X-Google-Smtp-Source: AGHT+IEZ6SHobqwmBLku5T22g3qb1tqmYJPcUGBA8+Da3y8UJVplvgda5z5x27uRTa0Tc+2qWv1/fg==
X-Received: by 2002:a05:6214:329:b0:6d3:9dad:6869 with SMTP id 6a1803df08f44-6d39dad6888mr801246d6.16.1731000689463;
        Thu, 07 Nov 2024 09:31:29 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:da5e:d3ff:fee7:26e7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d396637613sm9658116d6.116.2024.11.07.09.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 09:31:28 -0800 (PST)
Date: Thu, 7 Nov 2024 12:31:24 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, yosryahmed@google.com,
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, ying.huang@intel.com, 21cnbao@gmail.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com, zanussi@kernel.org,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v3 11/13] mm: zswap: Allocate acomp_batch_ctx resources
 for a given zswap_pool.
Message-ID: <20241107173124.GD1172372@cmpxchg.org>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-12-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106192105.6731-12-kanchana.p.sridhar@intel.com>

On Wed, Nov 06, 2024 at 11:21:03AM -0800, Kanchana P Sridhar wrote:
> If the zswap_pool is associated with an acomp_alg/crypto_acomp that has
> registered batch_compress() and batch_decompress() API, we can allocate the
> necessary batching resources for the pool's acomp_batch_ctx.
> 
> This patch makes the above determination on incurring the per-cpu memory
> footprint cost for batching, and if so, goes ahead and allocates
> SWAP_CRYPTO_BATCH_SIZE (i.e. 8) acomp_reqs/buffers for the
> pool->acomp_batch_ctx on that specific cpu.
> 
> It also "remembers" the pool's batching readiness as a result of the above,
> through a new
> 
>    	enum batch_comp_status can_batch_comp;
> 
> member added to struct zswap_pool, for fast retrieval during
> zswap_store().
> 
> This allows us a way to only incur the memory footprint cost of the
> pool->acomp_batch_ctx resources for a given cpu on which zswap_store()
> needs to process a large folio.
> 
> Suggested-by: Yosry Ahmed <yosryahmed@google.com>
> Suggested-by: Ying Huang <ying.huang@intel.com>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

A general observation: this is a lot of code for a hardware specific
feature that many CPUs and architectures do not support. Please keep
the code self-contained, and wrap struct members and functions in a
new CONFIG option, so that not everybody has to compile this in.

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794009592;
	b=2Hb2rGZWQO0QHMwMVAOIrK1fom/g/Jlf8c+O0EbKrttwqwk0fQJNG/hYbhf+KOtZHcS7
	 n1Lh0ZrkYc1+/tWybD/Ct9SUxlGsM7+z8fxwzJAVl5IKqTnt0JlGaS/mxN+3X9AkzevCK
	 VOCTQ12ZO3oTH24ru8LcysN+6okQWg/vNWxdS/+cYKohVcvWskXgB273AQ8KqnZ9BrtX/
	 LxjHBZVn6wQU7e048T9tYEyC+o59bkRel+XcpCOKi4j/mom03fWH6z9N62vsuEkkVRZgl
	 LTccecNg541WA+sFiZ2t8Ktli9SQDZ3I3yj8vw7DDPK8Ds3OzT1O1zkLbn9FJKLnhnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794009592;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kSvS5npMsYGUescqYNHuwns+vY8BLGHpBcdfwZNgI9Y=;
	b=ky63OViHFRmwwq9wwlT8c9CmPgrd3xoe1Qca+TO125zSJPlwX78CRaUBAvaGR9OlPu/F
	 IvDYHgOohebdbp8pOKj0TmCtsG9aA86MAQMesqTqG56bYkf9FzMCJupUgLyPoyzwKzfO5
	 4v98afW1l9wFojkC09Qv3cvg0jA7k26oMFhcJfDhgrFPYjoWzyqCsbTZJ/BwGXItM5Id0
	 hHvB8vz9nRBHtXy3ONjD2vb4RAgjxuIBINBvBsdDxL7VaxZTxqOJumlqBuqt+tWB0tbqk
	 A8DFr7Mn68887i+PIWnhXr1Fq1O8zT/sqNeRbHA5aAN89e3EhuKWHfibtSFSh0GdOQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O+UuiM0f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3C8606A326;
	Fri,  6 Nov 2026 23:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O+UuiM0f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B601F0089F;
	Fri,  6 Nov 2026 23:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794009591;
	bh=kSvS5npMsYGUescqYNHuwns+vY8BLGHpBcdfwZNgI9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O+UuiM0fK4oR8EZ2meSl5yH/TC+kEPKIlSb/W1Vwccx2Z1x/oaRBC0rUxhzH3Q1FI
	 wRyLE3mJycmci5fqln5NuoRHSLuj6uxKspkUt30qVSe6ZMLC2t0HcSDa1QCk6rmUKv
	 5/lxEFfmz9oieM+b0kn/ggjdQzHdPIreM/pACSH1F7tXbDeuJH50ISgWKKLkxqOgN5
	 DVti3roP66ChIWz4VIi8l2vpKFLkTPWljvM1kRxcKDPLo7BRWmAUjYmgKQi8KzBLX/
	 9JTm2A0Xd7dQPFJbfWN/sa7XazXvjBwFWbXK2Yf5UM55JxgnYaFUmLkHKXzbUi8eSy
	 MAbKibWYgvpeQ==
Date: Fri, 6 Nov 2026 23:59:49 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v3 0/8] Batched zswap_store() framework with compression
 batching.
Message-ID: <au5l3KEjG_mri-br@google.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
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
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>

On Thu, Nov 05, 2026 at 11:24:04PM -0800, Kanchana P. Sridhar wrote:
>  =============================================================================
>    usemem PMD THP BPFTRACE
>  =============================================================================
>            Baseline           zswap           zswap          Change    Change
>         mm-unstable           store        compress            with      with
>          10-25-2026        batching        batching        compress  compress
>                         (patch 6-7)       (patch 8)        batching  batching
>                                                                (ns)       %
>  =============================================================================
>   zswap_store_order0_folio (ns):
>  =============================================================================
>   p50        39,631          37,538          37,765          -1,866    -4.71% 
>   p95        53,088          49,690          49,349          -3,739    -7.04% 
>   p99        65,065          63,529          57,404          -7,661   -11.77%
>  =============================================================================
>   zswap_store_higher_order_folio (ns):
>  =============================================================================
>   p50    21,460,366      21,201,411      20,383,233      -1,077,133    -5.02%
>   p95    25,975,341      27,558,253      25,045,350        -929,991    -3.58%
>   p99    29,538,493      61,926,648      27,184,835      -2,353,658    -7.97%
>  =============================================================================
>   zswap_single_compress_per_page (ns):
>  =============================================================================
>   p50        37,545          39,320          37,218            -327    -0.87%
>   p95        51,549          66,503          51,481             -68    -0.13%
>   p99        89,866         134,854          87,091          -2,775    -3.09%
>  =============================================================================
>   zswap_batch_compress_per_page (ns):            
>  =============================================================================
>   p50                                        40,493           2,948     7.85%
>   p95                                        56,944           5,395    10.47%
>   p99                                        76,242         -13,624   -15.16%
>  =============================================================================

As with previous versions, I cannot reproduce these results. I tried
with a QEMU VM on a Cascade Lake host. I saw marginal improvements with
patch 6 and no significant gain with patches 7-8.

I noticed that you omitted high-level metrics (e.g. throughput), I
didn't see significant changes in throughput, and I also ran a kernel
build and saw a small regression in some cases (probably with order-0
folios) and no significant improvement otherwise. Even if latency for
some functions does improve slightly, it doesn't matter if it doesn't
show up on higher-level metrics.

It could be the difference in setups, or the overhead of bpftrace hooks
for zswap_compress() might affect measured zswap_store() latencies, as
you will have fewer zswap_compress() calls with patch 8.

As advised previously, I would trim down patch 6 to the bare minimum
(without all the scaffolding and prep work for patches 7-8), and send it
separately (with patch 5), and we can check if it's worth adding, I am
still concerned it might be adding overhead for order-0 to be honest.

I am questioning the benefit of batching here without HW batching, so
far the results are more concerning than encouraging. I already spent
too much time trying to reproduce the performance gains. Also, sending
new versions without resolving discussions on previous ones is not
really productive.

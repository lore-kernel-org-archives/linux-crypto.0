Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC58042315F
	for <linux-crypto@vger.kernel.org>; Wed,  4 Feb 2026 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770229075; cv=none; b=su/BSWfnb2YoOrDBVCFbPtmbSLJQK4gViPVu4Ys1ocBxGEE4NN1IPm+uCOK56QQbe6Wm9i6gr/oLOgk697uLkqm4EzIKTsC5cw/UsJU7Ee5/wt5eQaxRivpal+9jn9qPWbmdW6mDeRIPXgBmcbLt8uXCTve7bszQXhNdNq6ndts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770229075; c=relaxed/simple;
	bh=DTm81OOxuKcM5jcQrOcdVAZb70MeL94rcb0lD5hTqPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fx4e9hc/er9oPNh+GSsaydzQWVk7bcJbwS54wgDds1V7CcYqtC5jzVEQKCegyqljcbcCxV77UhCsQPRlcXq+ZwfSbI22tCToGzeZAxi6zHCTTwM4k+aJPaCIdJby2NHXxmwnmtzwW+6VSeTpKJx5ZxljGMB9oUw/Cqu/00iHV2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vl/cR+vx; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vl/cR+vx"
Date: Wed, 4 Feb 2026 18:17:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770229073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vw3PSnoy6sYwGPshV5lDvteVYd7nzV8fPjKvcpV88qA=;
	b=vl/cR+vxrM2HuZ36TIUC8//EEbfGNwG+ngOf+qvLTz568hLldOn+1hVJI0Mfk6ti3vLFVM
	TjOAsRffosZ7voJRy14QnzTx3z15qkFYZNx5ln+1TOPkyX1I2K4Sc2nQkazs9wDld/ndWj
	9xhjoSj3u9alpLtp7NKxoONXx/KhD1Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
Message-ID: <dhw3loxu2myculgk5vhpsbe5nupzvtnkei7u4zknc5ce5c6w62@csablv6vl2e5>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jan 24, 2026 at 07:35:37PM -0800, Kanchana P Sridhar wrote:
> We introduce a new batching implementation of zswap_compress() for
> compressors that do and do not support batching. This eliminates code
> duplication and facilitates code maintainability with the introduction
> of compress batching.
> 
> The vectorized implementation of calling the earlier zswap_compress()
> sequentially, one page at a time in zswap_store_pages(), is replaced
> with this new version of zswap_compress() that accepts multiple pages to
> compress as a batch.
> 
> If the compressor does not support batching, each page in the batch is
> compressed and stored sequentially. If the compressor supports batching,
> for e.g., 'deflate-iaa', the Intel IAA hardware accelerator, the batch
> is compressed in parallel in hardware.
> 
> If the batch is compressed without errors, the compressed buffers for
> the batch are stored in zsmalloc. In case of compression errors, the
> current behavior based on whether the folio is enabled for zswap
> writeback, is preserved.
> 
> The batched zswap_compress() incorporates Herbert's suggestion for
> SG lists to represent the batch's inputs/outputs to interface with the
> crypto API [1].
> 
> Performance data:
> =================
> As suggested by Barry, this is the performance data gathered on Intel
> Sapphire Rapids with two workloads:
> 
> 1) 30 usemem processes in a 150 GB memory limited cgroup, each
>    allocates 10G, i.e, effectively running at 50% memory pressure.
> 2) kernel_compilation "defconfig", 32 threads, cgroup memory limit set
>    to 1.7 GiB (50% memory pressure, since baseline memory usage is 3.4
>    GiB): data averaged across 10 runs.
> 
> To keep comparisons simple, all testing was done without the
> zswap shrinker.
> 
>  =========================================================================
>   IAA                 mm-unstable-1-23-2026             v14
>  =========================================================================
>     zswap compressor            deflate-iaa     deflate-iaa   IAA Batching
>                                                                   vs.
>                                                             IAA Sequential
>  =========================================================================
>  usemem30, 64K folios:
> 
>     Total throughput (KB/s)       6,226,967      10,551,714       69%
>     Average throughput (KB/s)       207,565         351,723       69%
>     elapsed time (sec)                99.19           67.45      -32%
>     sys time (sec)                 2,356.19        1,580.47      -33%
> 
>  usemem30, PMD folios:
> 
>     Total throughput (KB/s)       6,347,201      11,315,500       78%
>     Average throughput (KB/s)       211,573         377,183       78%
>     elapsed time (sec)                88.14           63.37      -28%
>     sys time (sec)                 2,025.53        1,455.23      -28%
> 
>  kernel_compilation, 64K folios:
> 
>     elapsed time (sec)               100.10           98.74     -1.4%
>     sys time (sec)                   308.72          301.23       -2%
> 
>  kernel_compilation, PMD folios:
> 
>     elapsed time (sec)                95.29           93.44     -1.9%
>     sys time (sec)                   346.21          344.48     -0.5%
>  =========================================================================
> 
>  =========================================================================
>   ZSTD                mm-unstable-1-23-2026             v14
>  =========================================================================
>     zswap compressor                   zstd            zstd     v14 ZSTD
>                                                              Improvement
>  =========================================================================
>  usemem30, 64K folios:
> 
>     Total throughput (KB/s)       6,032,326       6,047,448      0.3%
>     Average throughput (KB/s)       201,077         201,581      0.3%
>     elapsed time (sec)                97.52           95.33     -2.2%
>     sys time (sec)                 2,415.40        2,328.38       -4%
> 
>  usemem30, PMD folios:
> 
>     Total throughput (KB/s)       6,570,404       6,623,962      0.8%
>     Average throughput (KB/s)       219,013         220,798      0.8%
>     elapsed time (sec)                89.17           88.25       -1%
>     sys time (sec)                 2,126.69        2,043.08       -4%
> 
>  kernel_compilation, 64K folios:
> 
>     elapsed time (sec)               100.89           99.98     -0.9%
>     sys time (sec)                   417.49          414.62     -0.7%
> 
>  kernel_compilation, PMD folios:
> 
>     elapsed time (sec)                98.26           97.38     -0.9%
>     sys time (sec)                   487.14          473.16     -2.9%
>  =========================================================================
> 
> Architectural considerations for the zswap batching framework:
> ==============================================================
> We have designed the zswap batching framework to be
> hardware-agnostic. It has no dependencies on Intel-specific features and
> can be leveraged by any hardware accelerator or software-based
> compressor. In other words, the framework is open and inclusive by
> design.
> 
> Potential future clients of the batching framework:
> ===================================================
> This patch-series demonstrates the performance benefits of compression
> batching when used in zswap_store() of large folios. Compression
> batching can be used for other use cases such as batching compression in
> zram, batch compression of different folios during reclaim, kcompressd,
> file systems, etc. Decompression batching can be used to improve
> efficiency of zswap writeback (Thanks Nhat for this idea), batching
> decompressions in zram, etc.
> 
> Experiments with kernel_compilation "allmodconfig" that combine zswap
> compress batching, folio reclaim batching, and writeback batching show
> that 0 pages are written back with deflate-iaa and zstd. For comparison,
> the baselines for these compressors see 200K-800K pages written to disk.
> Reclaim batching relieves memory pressure faster than reclaiming one
> folio at a time, hence alleviates the need to scan slab memory for
> writeback.
> 
> [1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

Herbert, could you please review this patch since most of it is using
new crypto APIs?

Thanks!

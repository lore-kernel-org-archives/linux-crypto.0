Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61EF346AEF
	for <linux-crypto@vger.kernel.org>; Wed,  4 Feb 2026 18:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770229331; cv=none; b=rlEeMhKnM1YHXEh0M2cDi4ZkIJv9lCItQz6GGXtEeC768YV99XBfVCHUiCgTjxFSuKI0cauUcOic/xG6RGX3LjVFbJDnDVHHs/Zfz9qm4TxGMLRemgPuznNc2ErNKPpweTUV4Y/U2rRWf/3xip0xKFtH2Mq/+2sVwTkDRaEZRZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770229331; c=relaxed/simple;
	bh=vUWCJrV+pOWqToCpJVwe/GdpIU3EppV23Er4Xz2Z0/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrdIvv1++MN3JnfQ7z14lEgXqT/zj78mSyt4I18GXGzMcgRrS5zVdsEvoJ5v+omwFF3yFfXZMVhJH8T4nt/fUKKurPposPHPaRQNCj0vElxQGT1SydajoKSgwAyFXFkuGqGbN2xEs58TGZvqPl3BfafVput66V9n3R81AHyKsrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d/uRtbkw; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d/uRtbkw"
Date: Wed, 4 Feb 2026 18:21:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770229319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wBQi2IHq6aU5FZogCigX9J35/KRWrbQVb6t63SL+sQY=;
	b=d/uRtbkwit9hzr9WRSeAlVqDQY6HUb2t+kUSxV6yKZ3URZKHtEiSEngbsWwe8grmSqZIVO
	Z7TBhClohlOnGSzdZKObmZ71tF8ZRjiFuadIteOrw4MhaaRiO5iMsbDkT2/V+2ahIaxG9O
	PpbQNkTyB1ytmvjeCyF4NL6zxeWECZg=
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
Subject: Re: [PATCH v14 00/26] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <nlsqmn3x56ug7vfxw3vmpsmlyc6sie2plr22hpu7q6j7jq3adx@jbgg7sza67mv>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jan 24, 2026 at 07:35:11PM -0800, Kanchana P Sridhar wrote:
[..] 

I think this series is really hard to move and respin in its current
form.

Herbert, could we take in the crypto patches separately (if they are
ready)? Not sure if it's better to take them through the crypto tree
(and provide a tag for Andrew?), or through the mm tree. But either way,
most review is on the later zswap patches and respinning all these
crypto patch every time is a pain.

> 
> Kanchana P Sridhar (26):
>   crypto: iaa - Reorganize the iaa_crypto driver code.
>   crypto: iaa - Replace sprintf with sysfs_emit in sysfs show functions
>   crypto: iaa - New architecture for IAA device WQ [de]comp usage & core
>     mapping.
>   crypto: iaa - Simplify, consistency of function parameters, minor
>     stats bug fix.
>   crypto: iaa - Descriptor allocation timeouts with mitigations.
>   crypto: iaa - iaa_wq uses percpu_refs for get/put reference counting.
>   crypto: iaa - Simplify the code flow in iaa_compress() and
>     iaa_decompress().
>   crypto: iaa - Refactor hardware descriptor setup into separate
>     procedures.
>   crypto: iaa - Simplified, efficient job submissions for non-irq mode.
>   crypto: iaa - Deprecate exporting add/remove IAA compression modes.
>   crypto: iaa - Expect a single scatterlist for a [de]compress request's
>     src/dst.
>   crypto: iaa - Rearchitect iaa_crypto to have clean interfaces with
>     crypto_acomp.
>   crypto: acomp - Define a unit_size in struct acomp_req to enable
>     batching.
>   crypto: acomp - Add bit to indicate segmentation support
>   crypto: acomp - Add trivial segmentation wrapper
>   crypto: iaa - IAA Batching for parallel compressions/decompressions.
>   crypto: iaa - Submit the two largest source buffers first in batch
>     decompress.
>   crypto: acomp, iaa - crypto_acomp integration of IAA Batching.
>   crypto: iaa - Enable async mode and make it the default.
>   crypto: iaa - Disable iaa_verify_compress by default.
>   crypto: iaa - Add deflate-iaa-dynamic compression mode.
>   crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's
>     batch-size.
>   mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
>   mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
>     resources.

Andrew, I think this two zswap patches are in good shape, and are
standalone improvements. Do they apply to mm-unstable? Could we take
them in separately to lighten the load of respinning this?

>   mm: zswap: Store large folios in batches.
>   mm: zswap: Batched zswap_compress() for compress batching of large
>     folios.
> 
>  .../driver-api/crypto/iaa/iaa-crypto.rst      |  168 +-
>  crypto/acompress.c                            |  110 +-
>  crypto/testmgr.c                              |   10 +
>  crypto/testmgr.h                              |   74 +
>  drivers/crypto/intel/iaa/Makefile             |    4 +-
>  drivers/crypto/intel/iaa/iaa_crypto.h         |   95 +-
>  .../intel/iaa/iaa_crypto_comp_dynamic.c       |   22 +
>  drivers/crypto/intel/iaa/iaa_crypto_main.c    | 2926 ++++++++++++-----
>  drivers/crypto/intel/iaa/iaa_crypto_stats.c   |    8 +
>  drivers/crypto/intel/iaa/iaa_crypto_stats.h   |    2 +
>  include/crypto/acompress.h                    |   68 +
>  include/crypto/algapi.h                       |    5 +
>  include/crypto/internal/acompress.h           |   15 +
>  include/linux/crypto.h                        |    3 +
>  mm/zswap.c                                    |  724 ++--
>  15 files changed, 3144 insertions(+), 1090 deletions(-)
>  create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c
> 
> -- 
> 2.27.0
> 

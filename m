Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C492C38DC53;
	Tue, 13 Oct 2026 09:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883746; cv=none; b=PGzRsff9nxoNw/OT4lk+FLyq1Ljq3qe8/Jatfs7g25u4GTaLslqbz31a4XXy79JUZ2EIeIlBbmtefsHNHoF5uTkB/Tuew9/PIaofMm/XwKU/aPQc49GET5iyNzibWZl2P/+j5o0ocnL6aBpDw6ESYuorrSh8GkcNyuToKRKRiDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883746; c=relaxed/simple;
	bh=VOrBNeeotCBvrE6nzVveJn0StREXe/HIMgVnGyG7zdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j6ipjqAIqiDfQJuerzXSa0CpHWAfQjUdSdTpPuN2qKPWRLhLLu4jcs2PZfBHIdQM3yfiJV09m4HDYzEaTEmYl9FvdNgAcTiKCCiPwup8+oKgksaWZgcgRP7/CkQLjrcj1AK1KoLnLSHS2CC89Yxeoqo6c4VZWPqKJh3/jAoNwIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WfMo1nIj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WfMo1nIj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6hJ13YiNASF4v9jSRm8CUr3MziD7bZPk/IbsIdHVuFU=; 
	b=WfMo1nIjEzj7fpCgP4aFArUaV808tG2tyogpXRRg9RJOYydOToeyO7xCsqHucNu/SdxI55N6WyZ
	4dnHOK4CeQfsl3Bal/2OZQawNC7fqfSl/fjRbfb2fQzs3Btoul+qpoFoRXcAcoTgnjyphUNHoyNKa
	scRapRGfZ+rPDTTiZ046p91yb75HXHMPC6S/L/VrmpLMty3xoiXnli3ADscj6CobnvpSQyIFOLL+d
	WvUoAI27XPCA5e/81QBGI9E5Hzz2GZpPH2TJ8FRHCVljToqGwQLh9wImHGfjdxs1XieG7kyAKh+R2
	cqd8zfKJlyb98aeCnaNM/8fr51DA0ilOZwsA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xGYo8-00000003JrW-2cU7;
	Tue, 13 Oct 2026 17:28:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Oct 2026 20:28:28 +1100
Date: Tue, 13 Oct 2026 20:28:28 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev,
	dsterba@suse.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, nphamcs@gmail.com, terrelln@fb.com,
	yosry@kernel.org, riel@surriel.com, shakeel.butt@linux.dev,
	alex@ghiti.fr, senozhatsky@chromium.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and
 decompression requests
Message-ID: <as35vERorcRxFwGb@gondor.apana.org.au>
References: <20261009163146.83112-1-usama.arif@linux.dev>
 <20261009163146.83112-2-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009163146.83112-2-usama.arif@linux.dev>

On Fri, Oct 09, 2026 at 09:30:30AM -0700, Usama Arif wrote:
> Stores and loads serialize on the same per-CPU acomp request and mutex.
> A low-priority store can be preempted as soon as the compressor drops
> its stream lock, while it still holds the mutex. A higher-priority load
> on that CPU then waits until the store runs again, which can take a
> long time when other tasks are runnable.
> 
> Give compression and decompression their own request, completion wait
> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> compression, so group it with the compression request. Independent
> requests can share the per-CPU transform; the codecs and drivers
> synchronize their shared state internally. Loads can still wait for
> each other on the decompression mutex, and stores still serialize on
> the compression mutex.
> 
> acomp_request_free() ignores NULL requests, so drop the check in
> acomp_ctx_free().
> 
> This follows the proposal from Sergey Senozhatsky for the same split
> for zram [1].
> 
> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/zswap.c | 108 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 64 insertions(+), 44 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

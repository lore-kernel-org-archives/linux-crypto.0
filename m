Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168367;
	b=rNs2biX7prh6EBnb6yGRXzbr/zeAdbHT1IPhpOx/mrlJP+Ha99EWrYZmw8fNb5KJUuEF
	 XoAske3J1x3tXwtnwFvW1e+HXUVWyWzfzqsvp0J8HBLhGMNU9OFkXq7Ujy18WFM0b+jTb
	 MXZydtdMGdyjvIoxRVgCcgizo88p82MO2zZkcEiDw0yq3Idb9uoeIsekcaAOGeZkjajm2
	 aYUxzXrWS9+gdiWSTac4FpW4e0oxBJU+b06zqzwlU3ibdOHA6KVYpGjG0uiYVT6kvDVt/
	 NRovFbovBswjuHCvAubi8kftWpvaQgqSG46iL0gkrVNLKqcWHlOQxEwsBMe1rlMNZnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168367;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=aWI42pcN1z/Hd5o40uFRHKZPgvOeoK3APx1Ezx3rCNQ=;
	b=Ng8hAI5X1yn64v+B6bJ4X4LTfy2nxUnMM/BbRgVUAHkypViT481PSwYGpmre9fpPt5ts
	 Ci4gzq2K0CB0S+Jygk3LL7m/b9RLb6nfaO28ZFQje+TZ8WHmjwLz4UaEt6YeFZW102VpG
	 q3sOrIUwILl9d5Ey+W18ynNTOjxBmX3sXROHJ/3DvuJX0sTuRv8XityUqRgEAKgC4AB5X
	 +xtVanyohCq2v2CPcLaVWzQYHCg621Kr6Vom1/eGJp6myD7qdcv/XhZlbdnHRczZrmTNm
	 LXtk1QB9uwtex2BbdbevEd/SWxYovZuve4JXaKrRINJsZ5oEKQm3gYd57PeiPBlhHDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=ZjGjgkEj;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB7F606A320;
	Fri, 20 Nov 2026 09:52:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BB7F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=ZjGjgkEj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aWI42pcN1z/Hd5o40uFRHKZPgvOeoK3APx1Ezx3rCNQ=; 
	b=ZjGjgkEjaAwURjO2ORIJHmEgyNAtDuXhDLBELVNjmH7N6D7EFTOozczmz5YZyc46EL2RCSmbNCI
	9HJjmo1qMXeFT+zg/2YFQmIq0I4aj3HhMZEk7+bOMIlv+9YCeiSss5xVFuVoeP9e6/fFt/MyA/f/P
	qqOGJRknuAgA5fO1qHpr/njyf6hXDb/jybHhSf1QPtDg1ybg+8CohyrDJp0RWUVUzh7Nu/FVqarsV
	pOE+y4leDJL5OrQnTmuftdexzmyGOjqGhZOx4axT8pptHMaL7EbQtfg26BUJpnMCku7oIQF7GCCmh
	mBmaxHUzXjH8vNg0V+GTnrBN/ZGHuQ5kaj1w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULIK-0000000HYdr-2Vgn;
	Fri, 20 Nov 2026 17:52:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:52:36 +0800
Date: Fri, 20 Nov 2026 17:52:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Usama Arif <usama.arif@linux.dev>
Cc: davem@davemloft.net, terrelln@fb.com, dsterba@suse.com,
	hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, riel@surriel.com,
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 0/2] crypto: use vmalloc() for large stream workspaces
Message-ID: <awAYZHFnq2NBTDdA@gondor.apana.org.au>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261111153532.1036709-1-usama.arif@linux.dev>

On Wed, Nov 11, 2026 at 07:07:38AM -0800, Usama Arif wrote:
> The zstd and deflate acomp implementations retain per-CPU stream
> workspaces until the algorithms are unregistered. On x86-64 with 4 KiB
> pages, kvmalloc() can back them with order-9 and order-6 kmalloc()
> blocks, respectively.
> 
> Use vmalloc() and vfree() instead. For a server with 384 CPUs, if
> we have streams on all of the CPUs and kvmalloc() takes the
> kmalloc() path for every stream, their workspaces use 193.5 MiB more
> for zstd and 42 MiB for deflate.
> 
> In five before/after boot pairs on a 96-vCPU x86-64 VM with 8 GiB RAM,
> the test populated both algorithms crypto workspaces on every CPU. All
> 192 baseline workspaces used kmalloc() without these patches. The patches
> reduced workspace backing by 48.375 MiB for zstd and 10.5 MiB for deflate
> —58.875 MiB combined—in each pair.
> 
> In five before/after runs in a 4-vCPU x86-64 VM, median compression
> and decompression throughput changed by less than 1% (-0.93% to +0.64%).
> Inputs were 4 KiB and 64 KiB synthetic buffers containing pseudorandom
> data or a 50/50 mix of repeating-pattern and pseudorandom bytes.
> The differences were within the observed run-to-run variation.
>  
> Usama Arif (2):
>   crypto: zstd - use vmalloc() for stream workspaces
>   crypto: deflate - use vmalloc() for stream workspaces
> 
>  crypto/deflate.c | 5 +++--
>  crypto/zstd.c    | 4 ++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> -- 
> 2.53.0-Meta

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

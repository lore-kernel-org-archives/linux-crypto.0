Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253B0313524
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 20:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763065563; cv=none; b=hC5LuMiNyiNtiJJjhVafcwbsrrtGek8Kw9D/MKoY8BB1QykvEHc/L3TqQoLoXo9/NorxXmiuKjKTF52WuuzUpE2jNBO2n61a/359vHyKWNM3n8NhbltMWE945LrrwPZvgtXeK2PfDjIwXGT58/V3vRZEedTe39bEnaLuuLhApK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763065563; c=relaxed/simple;
	bh=zkCTvnSluFZwxX9hg2dtxpd/SynkivQkUad1SKp294E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MaSXv8O/iyTiVwvxtriaqTg7P7Wl+pYZK3Ml+Cz59Ne8U4UZU/08PDNQiTGofIFdbuX5FnDl1Z2il9U4K/MLbCDYoqECnx6Ak5n90tqoMblyCjLbDtRZvas6cLAia6PuEETwBfwRVeUQD8aL1Az+V2/+wb8dBWf0aGBLOMsufmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BKyNhrNw; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BKyNhrNw"
Date: Thu, 13 Nov 2025 20:25:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763065557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JxfMEHb09Ixm8iqYkNkNYHc7f7AyW9umoGrG0t4Mmi8=;
	b=BKyNhrNwF8t6KIJPv3u8VI6tLHV+cMp5wGdxr4fiOceyNCOsAao2WPZKibM6R2rrnw7Z2G
	G3fF5UobVl/uTM0M30jLnJhsDJtLHfUQzdoCocHSPF0N0jKc0C4HUYNBUYNTksaKMZS43X
	J83FHL00x1D7Qd54mfmrZ30yv99IShI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, 
	vinodh.gopal@intel.com
Subject: Re: [PATCH v13 20/22] mm: zswap: Consistently use IS_ERR_OR_NULL()
 to check acomp_ctx resources.
Message-ID: <dcpuzzl4bqnuhf7tshead6fatbjre2uo5kybdzllsjwkpvbv5a@kqbja24fetlb>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-21-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104091235.8793-21-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 04, 2025 at 01:12:33AM -0800, Kanchana P Sridhar wrote:
> This patch uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check
> for valid acomp/req, thereby making it consistent with
> acomp_ctx_dealloc().

Instead of "This patch..":

Use IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for valid
acomp/req, making it consistent with acomp_ctx_dealloc().

> 
> This is based on this earlier comment [1] from Yosry, when reviewing v8.

Drop this statement, it loses its meaning after the code is merged.

With those changes:
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> 
> [1] https://patchwork.kernel.org/comment/26282128/
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 87d50786f61f..cb384eb7c815 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -780,7 +780,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  		return ret;
>  
>  	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> -	if (IS_ERR(acomp_ctx->acomp)) {
> +	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
>  		pr_err("could not alloc crypto acomp %s : %ld\n",
>  				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
>  		ret = PTR_ERR(acomp_ctx->acomp);
> @@ -789,7 +789,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
>  
>  	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
> -	if (!acomp_ctx->req) {
> +	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
>  		pr_err("could not alloc crypto acomp_request %s\n",
>  		       pool->tfm_name);
>  		goto fail;
> -- 
> 2.27.0
> 

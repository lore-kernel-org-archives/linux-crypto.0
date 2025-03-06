Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45E126E655
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 19:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741290193; cv=none; b=LZYfvsTrLBIky7T0Gnxe8icPjwNY3mVxkC4qJ6/68GTTas+QuwOpNgHFojgW7ucSeNn2iivZeHB8pmC4fHzHQMzYbHdHa8csrSoF8V80VGwMfyqzETKbhlYggVsiQcu+386sC9m7eHGMc3cj5gZwqaajFfAV3mpQp67mLDMSYMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741290193; c=relaxed/simple;
	bh=ijSTguDYD3CiC3bfM/pvDLo9/ExMqUBmThDH6aL+DvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/xuaSgAGKaSVU1KjPsIKK3Dr5na0fjNLvAMBqbANOfiSvUg2nKCmjoPFrE1UokaatkPmhfRoZmbMxfr9L/I08WXmhDlVnf4Vorsyp62SN9AIRPgjrXfoQqMuxdYoyB6ebzNfbzPgJ+uhkV43gVDDeyPbB9P2HI/dtuhRt6wCmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BrXza8wq; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BrXza8wq"
Date: Thu, 6 Mar 2025 19:42:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741290179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VgoJ7d5Va9BAZXYpGq4C2//c7YKoou3T9bz0+JoLsBo=;
	b=BrXza8wqQyE6QPXncYpu7CYcgmKyBl5VH2VDa31/Ox5/mXeaYRMOe5mc1SGMxtNlLnxE3S
	MK8K63oyC91haUhkdlOtHNfiFpvQWSwfGr2VTENFD0g6pQG73r4bm0WYM/tv9N32z6b+x7
	pk1FV1JC3MZXpUmA3816HuEqvj90IK8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Message-ID: <Z8n6vA9BjNlIICss@google.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 03, 2025 at 12:47:22AM -0800, Kanchana P Sridhar wrote:
> This patch modifies the acomp_ctx resources' lifetime to be from pool
> creation to deletion. A "bool __online" and "u8 nr_reqs" are added to
> "struct crypto_acomp_ctx" which simplify a few things:
> 
> 1) zswap_pool_create() will initialize all members of each percpu acomp_ctx
>    to 0 or NULL and only then initialize the mutex.
> 2) CPU hotplug will set nr_reqs to 1, allocate resources and set __online
>    to true, without locking the mutex.
> 3) CPU hotunplug will lock the mutex before setting __online to false. It
>    will not delete any resources.
> 4) acomp_ctx_get_cpu_lock() will lock the mutex, then check if __online
>    is true, and if so, return the mutex for use in zswap compress and
>    decompress ops.
> 5) CPU onlining after offlining will simply check if either __online or
>    nr_reqs are non-0, and return 0 if so, without re-allocating the
>    resources.
> 6) zswap_pool_destroy() will call a newly added zswap_cpu_comp_dealloc() to
>    delete the acomp_ctx resources.
> 7) Common resource deletion code in case of zswap_cpu_comp_prepare()
>    errors, and for use in zswap_cpu_comp_dealloc(), is factored into a new
>    acomp_ctx_dealloc().
> 
> The CPU hot[un]plug callback functions are moved to "pool functions"
> accordingly.
> 
> The per-cpu memory cost of not deleting the acomp_ctx resources upon CPU
> offlining, and only deleting them when the pool is destroyed, is as follows:
> 
>     IAA with batching: 64.8 KB
>     Software compressors: 8.2 KB

I am assuming this is specifically on x86_64, so let's call that out.

Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841B61C28E
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 00:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081178; cv=none; b=hw1hH0/I1M2M2uq27Jj6ReP3JioC37IuPu6YInmEX9S9VdOwV1z/crS5N6IbD5+Oj3i7JhUkjevmm40AaH+qRfZ9LChcYDvlTnQLrwRDf80ZBS388VFzwzuFaCsI7+p79Ci5MyCDH1eJmO4L+DvhXCazl3Cz4XAOWSl6UJcinq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081178; c=relaxed/simple;
	bh=ey27USmbIAxcbkxEg4s37ji5e1JRNnE70fXh7408myY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pDsRpvBgvo8wGVXqMfNnwDCCDBjLqorG8GPW82SUfpdNUDp5OvL4OO/47ambNUNBdWIYn4t/duv/dm+hlIaik9kP97vzUiKmkzE2pdHmlrk5OE32pBc5b0Kvi8IxphxzRd9ZqkTZjdofCkZHhQ0CTo4xSgvxcTbhcBbnUaJ1cuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p9VZ+sWm; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p9VZ+sWm"
Date: Fri, 14 Nov 2025 00:46:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763081171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X/iGyGoK6DUAfKx0bXTPWyfeMNYwedRqSwZFE0W+ZJ8=;
	b=p9VZ+sWm9oGYqVxQAqnF6D1oX7c4m2zFMYaGSUefHHgKszKmLUqdRLehx5rb6HR5sy8FAS
	d2NXLuD1NEqD+q4IytLYAvcNKUdNw/QDez71n/RdDUINd3eIjRp/oi9tbK/RXRXzRE8KYH
	r3KG12OhyZqMLP53kjHAkj1ZAW2jWBY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <vc65dxjoledwtojbcdgyxh2xt3hhlqrzgxcnbgufji7sgnhkus@fqkcflhwbags>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 13, 2025 at 11:55:10PM +0000, Sridhar, Kanchana P wrote:
> 
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Thursday, November 13, 2025 1:35 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> > compress batching of large folios.
> > 
> > On Tue, Nov 04, 2025 at 01:12:35AM -0800, Kanchana P Sridhar wrote:
> > > This patch introduces a new unified implementation of zswap_compress()
> > > for compressors that do and do not support batching. This eliminates
> > > code duplication and facilitates code maintainability with the
> > > introduction of compress batching.
> > >
> > > The vectorized implementation of calling the earlier zswap_compress()
> > > sequentially, one page at a time in zswap_store_pages(), is replaced
> > > with this new version of zswap_compress() that accepts multiple pages to
> > > compress as a batch.
> > >
> > > If the compressor does not support batching, each page in the batch is
> > > compressed and stored sequentially. If the compressor supports batching,
> > > for e.g., 'deflate-iaa', the Intel IAA hardware accelerator, the batch
> > > is compressed in parallel in hardware. If the batch is compressed
> > > without errors, the compressed buffers are then stored in zsmalloc. In
> > > case of compression errors, the current behavior is preserved for the
> > > batching zswap_compress(): if the folio's memcg is writeback enabled,
> > > pages with compression errors are store uncompressed in zsmalloc; if
> > > not, we return an error for the folio in zswap_store().
> > >
> > > As per Herbert's suggestion in [1] for batching to be based on SG lists
> > > to interface with the crypto API, a "struct sg_table *sg_outputs" is
> > > added to the per-CPU acomp_ctx. In zswap_cpu_comp_prepare(), memory
> > is
> > > allocated for @pool->compr_batch_size scatterlists in
> > > @acomp_ctx->sg_outputs. The per-CPU @acomp_ctx->buffers' addresses
> > are
> > > statically mapped to the respective SG lists. The existing non-NUMA
> > > sg_alloc_table() was found to give better performance than a NUMA-aware
> > > allocation function, hence is used in this patch.
> > >
> > > Batching compressors should initialize the output SG lengths to
> > > PAGE_SIZE as part of the internal compress batching setup, to avoid
> > > having to do multiple traversals over the @acomp_ctx->sg_outputs->sgl.
> > > This is exactly how batching is implemented in the iaa_crypto driver's
> > > compress batching procedure, iaa_comp_acompress_batch().
> > >
> > > The batched zswap_compress() implementation is generalized as much as
> > > possible for non-batching and batching compressors, so that the
> > > subsequent incompressible page handling, zs_pool writes, and error
> > > handling code is seamless for both, without the use of conditionals to
> > > switch to specialized code for either.
> > >
> > > The new batching implementation of zswap_compress() is called with a
> > > batch of @nr_pages sent from zswap_store() to zswap_store_pages().
> > > zswap_compress() steps through the batch in increments of the
> > > compressor's batch-size, sets up the acomp_ctx->req's src/dst SG lists
> > > to contain the folio pages and output buffers, before calling
> > > crypto_acomp_compress().
> > >
> > > Some important requirements of this batching architecture for batching
> > > compressors:
> > >
> > >   1) The output SG lengths for each sg in the acomp_req->dst should be
> > >      intialized to PAGE_SIZE as part of other batch setup in the batch
> > >      compression function. zswap will not take care of this in the
> > >      interest of avoiding repetitive traversals of the
> > >      @acomp_ctx->sg_outputs->sgl so as to not lose the benefits of
> > >      batching.
> > >
> > >   2) In case of a compression error for any page in the batch, the
> > >      batching compressor should set the corresponding @sg->length to a
> > >      negative error number, as suggested by Herbert. Otherwise, the
> > >      @sg->length will contain the compressed output length.
> > >
> > >   3) Batching compressors should set acomp_req->dlen to
> > >      acomp_req->dst->length, i.e., the sg->length of the first SG in
> > >      acomp_req->dst.
> > >
> > > Another important change this patch makes is with the acomp_ctx mutex
> > > locking in zswap_compress(). Earlier, the mutex was held per page's
> > > compression. With the new code, [un]locking the mutex per page caused
> > > regressions for software compressors when testing with 30 usemem
> > > processes, and also kernel compilation with 'allmod' config. The
> > > regressions were more eggregious when PMD folios were stored. The
> > > implementation in this commit locks/unlocks the mutex once per batch,
> > > that resolves the regression.
> > >
> > > Architectural considerations for the zswap batching framework:
> > >
> > ==============================================================
> > > We have designed the zswap batching framework to be
> > > hardware-agnostic. It has no dependencies on Intel-specific features and
> > > can be leveraged by any hardware accelerator or software-based
> > > compressor. In other words, the framework is open and inclusive by
> > > design.
> > >
> > > Other ongoing work that can use batching:
> > > =========================================
> > > This patch-series demonstrates the performance benefits of compress
> > > batching when used in zswap_store() of large folios. shrink_folio_list()
> > > "reclaim batching" of any-order folios is the major next work that uses
> > > the zswap compress batching framework: our testing of kernel_compilation
> > > with writeback and the zswap shrinker indicates 10X fewer pages get
> > > written back when we reclaim 32 folios as a batch, as compared to one
> > > folio at a time: this is with deflate-iaa and with zstd. We expect to
> > > submit a patch-series with this data and the resulting performance
> > > improvements shortly. Reclaim batching relieves memory pressure faster
> > > than reclaiming one folio at a time, hence alleviates the need to scan
> > > slab memory for writeback.
> > >
> > > Nhat has given ideas on using batching with the ongoing kcompressd work,
> > > as well as beneficially using decompression batching & block IO batching
> > > to improve zswap writeback efficiency.
> > >
> > > Experiments that combine zswap compress batching, reclaim batching,
> > > swapin_readahead() decompression batching of prefetched pages, and
> > > writeback batching show that 0 pages are written back with deflate-iaa
> > > and zstd. For comparison, the baselines for these compressors see
> > > 200K-800K pages written to disk (kernel compilation 'allmod' config).
> > >
> > > To summarize, these are future clients of the batching framework:
> > >
> > >    - shrink_folio_list() reclaim batching of multiple folios:
> > >        Implemented, will submit patch-series.
> > >    - zswap writeback with decompress batching:
> > >        Implemented, will submit patch-series.
> > >    - zram:
> > >        Implemented, will submit patch-series.
> > >    - kcompressd:
> > >        Not yet implemented.
> > >    - file systems:
> > >        Not yet implemented.
> > >    - swapin_readahead() decompression batching of prefetched pages:
> > >        Implemented, will submit patch-series.
> > >
> > > Additionally, any place we have folios that need to be compressed, can
> > > potentially be parallelized.
> > >
> > > Performance data:
> > > =================
> > >
> > > As suggested by Barry, this is the performance data gathered on Intel
> > > Sapphire Rapids with usemem 30 processes running at 50% memory
> > pressure
> > > and kernel_compilation/allmod config run with 2G limit using 32
> > > threads. To keep comparisons simple, all testing was done without the
> > > zswap shrinker.
> > >
> > >   usemem30 with 64K folios:
> > >   =========================
> > >
> > >      zswap shrinker_enabled = N.
> > >
> > >      -----------------------------------------------------------------------
> > >                      mm-unstable-10-24-2025             v13
> > >      -----------------------------------------------------------------------
> > >      zswap compressor          deflate-iaa     deflate-iaa   IAA Batching
> > >                                                                  vs.
> > >                                                              IAA Sequential
> > >      -----------------------------------------------------------------------
> > >      Total throughput (KB/s)     6,118,675       9,901,216       62%
> > >      Average throughput (KB/s)     203,955         330,040       62%
> > >      elapsed time (sec)              98.94           70.90      -28%
> > >      sys time (sec)               2,379.29        1,686.18      -29%
> > >      -----------------------------------------------------------------------
> > >
> > >      -----------------------------------------------------------------------
> > >                      mm-unstable-10-24-2025             v13
> > >      -----------------------------------------------------------------------
> > >      zswap compressor                 zstd            zstd   v13 zstd
> > >                                                              improvement
> > >      -----------------------------------------------------------------------
> > >      Total throughput (KB/s)     5,983,561       6,003,851      0.3%
> > >      Average throughput (KB/s)     199,452         200,128      0.3%
> > >      elapsed time (sec)             100.93           96.62     -4.3%
> > >      sys time (sec)               2,532.49        2,395.83       -5%
> > >      -----------------------------------------------------------------------
> > >
> > >   usemem30 with 2M folios:
> > >   ========================
> > >
> > >      -----------------------------------------------------------------------
> > >                      mm-unstable-10-24-2025             v13
> > >      -----------------------------------------------------------------------
> > >      zswap compressor          deflate-iaa     deflate-iaa   IAA Batching
> > >                                                                  vs.
> > >                                                              IAA Sequential
> > >      -----------------------------------------------------------------------
> > >      Total throughput (KB/s)     6,309,635      10,558,225       67%
> > >      Average throughput (KB/s)     210,321         351,940       67%
> > >      elapsed time (sec)              88.70           67.84      -24%
> > >      sys time (sec)               2,059.83        1,581.07      -23%
> > >      -----------------------------------------------------------------------
> > >
> > >      -----------------------------------------------------------------------
> > >                      mm-unstable-10-24-2025             v13
> > >      -----------------------------------------------------------------------
> > >      zswap compressor                 zstd            zstd   v13 zstd
> > >                                                              improvement
> > >      -----------------------------------------------------------------------
> > >      Total throughput (KB/s)     6,562,687       6,567,946      0.1%
> > >      Average throughput (KB/s)     218,756         218,931      0.1%
> > >      elapsed time (sec)              94.69           88.79       -6%
> > >      sys time (sec)               2,253.97        2,083.43       -8%
> > >      -----------------------------------------------------------------------
> > >
> > >     The main takeaway from usemem, a workload that is mostly compression
> > >     dominated (very few swapins) is that the higher the number of batches,
> > >     such as with larger folios, the more the benefit of batching cost
> > >     amortization, as shown by the PMD usemem data. This aligns well
> > >     with the future direction for batching.
> > >
> > > kernel_compilation/allmodconfig, 64K folios:
> > > ============================================
> > >
> > >      --------------------------------------------------------------------------
> > >                mm-unstable-10-24-2025             v13
> > >      --------------------------------------------------------------------------
> > >      zswap compressor    deflate-iaa     deflate-iaa    IAA Batching
> > >                                                              vs.
> > >                                                         IAA Sequential
> > >      --------------------------------------------------------------------------
> > >      real_sec                 836.64          806.94      -3.5%
> > >      sys_sec                3,897.57        3,661.83        -6%
> > >      --------------------------------------------------------------------------
> > >
> > >      --------------------------------------------------------------------------
> > >                mm-unstable-10-24-2025             v13
> > >      --------------------------------------------------------------------------
> > >      zswap compressor           zstd            zstd    Improvement
> > >      --------------------------------------------------------------------------
> > >      real_sec                 880.62          850.41      -3.4%
> > >      sys_sec                5,171.90        5,076.51      -1.8%
> > >      --------------------------------------------------------------------------
> > >
> > > kernel_compilation/allmodconfig, PMD folios:
> > > ============================================
> > >
> > >      --------------------------------------------------------------------------
> > >                mm-unstable-10-24-2025             v13
> > >      --------------------------------------------------------------------------
> > >      zswap compressor    deflate-iaa     deflate-iaa    IAA Batching
> > >                                                              vs.
> > >                                                         IAA Sequential
> > >      --------------------------------------------------------------------------
> > >      real_sec                 818.48          779.67      -4.7%
> > >      sys_sec                4,226.52        4,245.18       0.4%
> > >      --------------------------------------------------------------------------
> > >
> > >      --------------------------------------------------------------------------
> > >               mm-unstable-10-24-2025             v13
> > >      --------------------------------------------------------------------------
> > >      zswap compressor          zstd             zstd    Improvement
> > >      --------------------------------------------------------------------------
> > >      real_sec                888.45           849.54      -4.4%
> > >      sys_sec               5,866.72         5,847.17      -0.3%
> > >      --------------------------------------------------------------------------
> > >
> > > [1]:
> > https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99
> > aea2ce3d284e6c5a3253061d97b08c4752a798
> > >
> > > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > 
> > I won't go through the commit log and rewrite for this one too, but
> > please do so similar to how I did for the previous patches. Do not
> > describe the code, give a high-level overview of what is happening and
> > why it's happeneing, as well as very concise performance results.
> 
> With all due respect, I am not describing the code. zswap compress batching
> is a major architectural change and I am documenting the changes from the
> status quo, for other zswap developers. Yes, some of this might involve
> weaving in repetition of current behavior, again to stress the backward
> compatibility of main concepts.

As I said, I did not go through the commit log as I did for previous
ones, which did include unnecessary description of the code. What I
asked is for you to do similar changes here, if needed, because the
commit log is too big.

For example, you should remove mentions of ongoing work and future work,
simply because things change and they may not land. Just briefly
mentioning that there are future use cases (with maybe an example) is
sufficient.

> 
> I believe there is not one redundant datapoint when it comes to performance
> metrics in this summary - please elaborate. Thanks.

I never said they were redundant, I said we should make them more
concise. For example, the first table can be replaced by stating that
throughput improves by ~62% and the time is reduced by 28-29% and so on.

> 
> > 
> > Do not include things that only make sense in the context of a patch and
> > won't make sense as part of git histroy.
> 
> This makes sense, duly noted and will be addressed.
> 
> > 
> > That being said, I'd like Herbert to review this patch and make sure the
> > scatterlist and crypto APIs are being used correctly as he advised
> > earlier. I do have some comments on the zswap side though.
> > 
[..]
> > > @@ -869,84 +892,177 @@ static int zswap_cpu_comp_prepare(unsigned
> > int cpu, struct hlist_node *node)
> > >  	return ret;
> > >  }
> > >
> > > -static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> > > -			   struct zswap_pool *pool, bool wb_enabled)
> > > +/*
> > > + * Unified code path for compressors that do and do not support batching.
> > This
> > > + * procedure will compress multiple @nr_pages in @folio starting from the
> > > + * @start index.
> > > + *
> > > + * It is assumed that @nr_pages <= ZSWAP_MAX_BATCH_SIZE.
> > zswap_store() makes
> > > + * sure of this by design and zswap_store_pages() warns if this is not
> > > + * true.
> > > + *
> > > + * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the
> > compressor does not
> > > + * support batching.
> > > + *
> > > + * If @pool->compr_batch_size is 1, each page is processed sequentially.
> > > + *
> > > + * If @pool->compr_batch_size is > 1, compression batching is invoked
> > within
> > > + * the algorithm's driver, except if @nr_pages is 1: if so, the driver can
> > > + * choose to call the sequential/non-batching compress API.
> > > + *
> > > + * In both cases, if all compressions are successful, the compressed buffers
> > > + * are stored in zsmalloc.
> > > + *
> > > + * Traversing multiple SG lists when @nr_comps is > 1 is expensive, and
> > impacts
> > > + * batching performance if we were to repeat this operation multiple
> > times,
> > > + * such as:
> > > + *   - to map destination buffers to each SG list in the @acomp_ctx-
> > >sg_outputs
> > > + *     sg_table.
> > > + *   - to initialize each output SG list's @sg->length to PAGE_SIZE.
> > > + *   - to get the compressed output length in each @sg->length.
> > > + *
> > > + * These are some design choices made to optimize batching with SG lists:
> > > + *
> > > + * 1) The source folio pages in the batch are directly submitted to
> > > + *    crypto_acomp via acomp_request_set_src_folio().
> > > + *
> > > + * 2) The per-CPU @acomp_ctx->sg_outputs scatterlists are used to set up
> > > + *    destination buffers for interfacing with crypto_acomp.
> > > + *
> > > + * 3) To optimize performance, we map the per-CPU @acomp_ctx->buffers
> > to the
> > > + *    @acomp_ctx->sg_outputs->sgl SG lists at pool creation time. The only
> > task
> > > + *    remaining to be done for the output SG lists in zswap_compress() is to
> > > + *    set each @sg->length to PAGE_SIZE. This is done in zswap_compress()
> > > + *    for non-batching compressors. This needs to be done within the
> > compress
> > > + *    batching driver procedure as part of iterating through the SG lists for
> > > + *    batch setup, so as to minimize expensive traversals through the SG
> > lists.
> > > + *
> > > + * 4) Important requirements for batching compressors:
> > > + *    - Each @sg->length in @acomp_ctx->req->sg_outputs->sgl should
> > reflect the
> > > + *      compression outcome for that specific page, and be set to:
> > > + *      - the page's compressed length, or
> > > + *      - the compression error value for that page.
> > > + *    - The @acomp_ctx->req->dlen should be set to the first page's
> > > + *      @sg->length. This enables code generalization in zswap_compress()
> > > + *      for non-batching and batching compressors.
> > > + *
> > > + * acomp_ctx mutex locking:
> > > + *    Earlier, the mutex was held per page compression. With the new code,
> > > + *    [un]locking the mutex per page caused regressions for software
> > > + *    compressors. We now lock the mutex once per batch, which resolves
> > the
> > > + *    regression.
> > > + */
> > 
> > Please, no huge comments describing what the code is doing. If there's
> > anything that is not clear from reading the code or needs to be
> > explained or documented, please do so **concisely** in the relevant part
> > of the function.
> 
> Again, these are important requirements related to the major change, i.e.,
> batching, wrt why/how. I think it is important to note considerations for the
> next batching algorithm, just like I have done within the IAA driver. To be very
> clear, I am not describing code.
> 
> If questions arise as to why the mutex is being locked per batch as against
> per page, I think the comment above is helpful and saves time for folks to
> understand the "why".

Having a huge comment above the function does not help. For things like
this, you should add a brief comment above the mutex locking (where it's
relevant). Otherwise it's easy for someone to move the mutex locking
without reading this comment.

Same applies for other things. I am not saying we should throw away the
entire comment, but it's not helpful in its current form. Concise
comments in the relevant parts are much more helpful. Keep comments
above the function to general notes and things that are important to
callers, not implementation details.

> 
> > 
> > > +static bool zswap_compress(struct folio *folio, long start, unsigned int
> > nr_pages,
> > > +			   struct zswap_entry *entries[], struct zswap_pool
> > *pool,
> > > +			   int nid, bool wb_enabled)
> > >  {
> > > +	gfp_t gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM |
> > __GFP_MOVABLE;
> > > +	unsigned int nr_comps = min(nr_pages, pool->compr_batch_size);
> > > +	unsigned int slen = nr_comps * PAGE_SIZE;
> > >  	struct crypto_acomp_ctx *acomp_ctx;
> > > -	struct scatterlist input, output;
> > > -	int comp_ret = 0, alloc_ret = 0;
> > > -	unsigned int dlen = PAGE_SIZE;
> > > +	int err = 0, err_sg = 0;
> > > +	struct scatterlist *sg;
> > > +	unsigned int i, j, k;
> > >  	unsigned long handle;
> > > -	gfp_t gfp;
> > > -	u8 *dst;
> > > -	bool mapped = false;
> > > +	int *errp, dlen;
> > > +	void *dst;
> > >
> > >  	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
> > >  	mutex_lock(&acomp_ctx->mutex);
> > >
> > > -	dst = acomp_ctx->buffers[0];
> > > -	sg_init_table(&input, 1);
> > > -	sg_set_page(&input, page, PAGE_SIZE, 0);
> > > -
> > > -	sg_init_one(&output, dst, PAGE_SIZE);
> > > -	acomp_request_set_params(acomp_ctx->req, &input, &output,
> > PAGE_SIZE, dlen);
> > > +	errp = (pool->compr_batch_size == 1) ? &err : &err_sg;
> > 
> > err_sg is not used anywhere, so *errp could end up being garbage. Why do
> > we need this?
> 
> err_sg is initialized to 0 and never changes. It can never be garbage.
> We need this because of the current dichotomy between software compressors
> and IAA in the sg->length based error handling per Herbert's suggestions,
> included in the huge function comment block. It is needed to avoid branches
> and have the zswap_compress() code look seamless for all compressors.

This is exactly what I meant by saying the huge comment doesn't help. It
should be documented where it is implemented.

That being said, the code is confusing and not readable, why do we need
to do such manuevring with the error codes? It's really hard to track.

> 
> > 
> > >
> > >  	/*
> > > -	 * it maybe looks a little bit silly that we send an asynchronous
> > request,
> > > -	 * then wait for its completion synchronously. This makes the process
> > look
> > > -	 * synchronous in fact.
> > > -	 * Theoretically, acomp supports users send multiple acomp requests
> > in one
> > > -	 * acomp instance, then get those requests done simultaneously. but
> > in this
> > > -	 * case, zswap actually does store and load page by page, there is no
> > > -	 * existing method to send the second page before the first page is
> > done
> > > -	 * in one thread doing zswap.
> > > -	 * but in different threads running on different cpu, we have different
> > > -	 * acomp instance, so multiple threads can do (de)compression in
> > parallel.
> > > +	 * [i] refers to the incoming batch space and is used to
> > > +	 *     index into the folio pages.
> > > +	 *
> > > +	 * [j] refers to the incoming batch space and is used to
> > > +	 *     index into the @entries for the folio's pages in this
> > > +	 *     batch, per compress call while iterating over the output SG
> > > +	 *     lists. Also used to index into the folio's pages from @start,
> > > +	 *     in case of compress errors.
> > > +	 *
> > > +	 * [k] refers to the @acomp_ctx space, as determined by
> > > +	 *     @pool->compr_batch_size, and is used to index into
> > > +	 *     @acomp_ctx->sg_outputs->sgl and @acomp_ctx->buffers.
> > >  	 */
> > > -	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx-
> > >req), &acomp_ctx->wait);
> > > -	dlen = acomp_ctx->req->dlen;
> > > +	for (i = 0; i < nr_pages; i += nr_comps) {
> > 
> > What are looping over here? I thought zswap_compress() takes in exactly
> > one batch.
> 
> We are iterating once over one batch for batching compressors, and one
> page at a time for software.

I thought we wanted to have a single acomp API that takes in a batch of
pages, and then either hands them over to HW compressors, or loops over
them for SW compressors. This would simplify the users like zswap
because the differences between SW and HW compressors would be handled
internally.

> 
> > 
> > > +		acomp_request_set_src_folio(acomp_ctx->req, folio,
> > > +					    (start + i) * PAGE_SIZE,
> > > +					    slen);
> > >
> > > -	/*
> > > -	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
> > > -	 * save the content as is without a compression, to keep the LRU
> > order
> > > -	 * of writebacks.  If writeback is disabled, reject the page since it
> > > -	 * only adds metadata overhead.  swap_writeout() will put the page
> > back
> > > -	 * to the active LRU list in the case.
> > > -	 */
> > > -	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
> > > -		if (!wb_enabled) {
> > > -			comp_ret = comp_ret ? comp_ret : -EINVAL;
> > > -			goto unlock;
> > > -		}
> > > -		comp_ret = 0;
> > > -		dlen = PAGE_SIZE;
> > > -		dst = kmap_local_page(page);
> > > -		mapped = true;
> > > -	}
> > > +		acomp_ctx->sg_outputs->sgl->length = slen;
> > >
> > > -	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM |
> > __GFP_MOVABLE;
> > > -	handle = zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page));
> > > -	if (IS_ERR_VALUE(handle)) {
> > > -		alloc_ret = PTR_ERR((void *)handle);
> > > -		goto unlock;
> > > -	}
> > > +		acomp_request_set_dst_sg(acomp_ctx->req,
> > > +					 acomp_ctx->sg_outputs->sgl,
> > > +					 slen);
> > > +
> > > +		err = crypto_wait_req(crypto_acomp_compress(acomp_ctx-
> > >req),
> > > +				      &acomp_ctx->wait);
> > > +
> > > +		acomp_ctx->sg_outputs->sgl->length = acomp_ctx->req-
> > >dlen;
> > > +
> > > +		/*
> > > +		 * If a page cannot be compressed into a size smaller than
> > > +		 * PAGE_SIZE, save the content as is without a compression,
> > to
> > > +		 * keep the LRU order of writebacks.  If writeback is disabled,
> > > +		 * reject the page since it only adds metadata overhead.
> > > +		 * swap_writeout() will put the page back to the active LRU
> > list
> > > +		 * in the case.
> > > +		 *
> > > +		 * It is assumed that any compressor that sets the output
> > length
> > > +		 * to 0 or a value >= PAGE_SIZE will also return a negative
> > > +		 * error status in @err; i.e, will not return a successful
> > > +		 * compression status in @err in this case.
> > > +		 */
> > 
> > Ugh, checking the compression error and checking the compression length
> > are now in separate places so we need to check if writeback is disabled
> > in separate places and store the page as-is. It's ugly, and I think the
> > current code is not correct.
> 
> The code is 100% correct. You need to spend more time understanding
> the code. I have stated my assumption above in the comments to
> help in understanding the "why".
> 
> From a maintainer, I would expect more responsible statements than
> this. A flippant remark made without understanding the code (and,
> disparaging the comments intended to help you do this), can impact
> someone's career. I am held accountable in my job based on your
> comments.
> 
> That said, I have worked tirelessly and innovated to make the code
> compliant with Herbert's suggestions (which btw have enabled an
> elegant batching implementation and code commonality for IAA and
> software compressors), validated it thoroughly for IAA and ZSTD to
> ensure that both demonstrate performance improvements, which
> are crucial for memory savings. I am proud of this work.

I really do NOT appreciate the personal attack here. I am not sure why
my comment came across as a "flippant remark".

Let me be clear, I never said anything bad about "this work", or
expressed that I do not want to see it merged. You did a good job and
you should be proud of your work.

That being said, code review is part of the process, and you should know
better than anyone given how much this series evolved over 13 revisions
of careful reviews. I spent a considerable amount of time reviewing
previous revisions, pointing out problems, and helping this series
evolve. Telling me that I "should spend more time understanding the
code" is enraging at this point.

To be even more clear, I gain NOTHING by reviewing your code and helping
you land this work. I also have a job, and it's not reviewing your code.
I would tread very carefully if I were you.

Let's keep the discussion technical and civil. I will NOT tolerate such
comments going forward.

> 
> 
> > 
> > > +		if (err && !wb_enabled)
> > > +			goto compress_error;
> > > +
> > > +		for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k) {
> > > +			j = k + i;
> > 
> > Please use meaningful iterator names rather than i, j, and k and the huge
> > comment explaining what they are.
> 
> I happen to have a different view: having longer iterator names firstly makes
> code seem "verbose" and detracts from readability, not to mention exceeding the
> 80-character line limit. The comments are essential for code maintainability
> and avoid out-of-bounds errors when the next zswap developer wants to
> optimize the code.
> 
> One drawback of i/j/k iterators is mis-typing errors which cannot be caught
> at compile time. Let me think some more about how to strike a good balance.

I think if we get rid of the outer loop things will get much simpler. I
initially thought the acomp API will handle the looping internally for
SW compressors.

> 
> > 
> > > +			dst = acomp_ctx->buffers[k];
> > > +			dlen = sg->length | *errp;
> > 
> > Why are we doing this?
> > 
> > > +
> > > +			if (dlen < 0) {
> > 
> > We should do the incompressible page handling also if dlen is PAGE_SIZE,
> > or if the compression failed (I guess that's the intention of bit OR'ing
> > with *errp?)
> 
> Yes, indeed: that's the intention of bit OR'ing with *errp.

This is not very readable.

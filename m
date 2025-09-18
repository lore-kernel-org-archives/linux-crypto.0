Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7D6208994;
	Thu, 18 Sep 2025 02:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758163137; cv=none; b=rvPN59nTmk0pYTPE7F/lGm04Ve52/4UK42KUHO5ze15uqvtPqs4s7rrPM0F/iJQBVQIzRM0jOQ9kcwSdKhaXCWkhobvfFidUB2tQULOoLoVOXYyGHjTatuyAd14AlgDZ8si1VbpOqbGTN0fn9RZ2h0Lr+lByMF3Emu3233sbB5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758163137; c=relaxed/simple;
	bh=glzPTCePYs69f+6RJwlYy3RgZTdITfTPdrN5Cqrf5NE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UiPh1C20zt3GyIo9DCeXXC9p+jEM707LnoHVG8IYB4XCkP4P5/WpiU87OHjcT01+pQ1HozWyf5mljehI2Gvo4AcbV0eQvWdb4BhFWZuDjVBy/2CMyegjdVfWwxnff49fqzai0JWYNSj9htbjL2bDKjDmjF71ytDvWAIqsmn/1/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EJ0G8cFG; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EJ0G8cFG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758163133; x=1789699133;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=glzPTCePYs69f+6RJwlYy3RgZTdITfTPdrN5Cqrf5NE=;
  b=EJ0G8cFGmpeJDFfqIDwEVP92R+fROzHz6hc4ChkRPRfaWf8hxHk3/4Vh
   Y00aVWG3vYsSmTfylMLXhP3tTbmSUc8uxU+A6Qb297BfPBieMUBuoNMv4
   kQCady/Wv0skjtR6fpYRJLz/Tl9QHiOStREGQEvD+RYRiMnhdbXRmJxYv
   IEhBsjHQqLkaChkrLpvJS0DtZSlnZjoaR2AHO0C4Z/FovxbccqJgq+7qo
   VpHdQTA5E6L2TKjqzPfLHjuDeSi/0aouhZgn3KyOY+UPdiyL4Z4OAC4X5
   c77YoKUAR47i54zuqRBPsNObSGN8jTgzl4alc0SobJ+zAv65oeUDngptp
   Q==;
X-CSE-ConnectionGUID: uyt8QORVQ0mvEZfba8fRxQ==
X-CSE-MsgGUID: vEtIj0hBTOuTXwcSA9xFKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="83078540"
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="83078540"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 19:38:52 -0700
X-CSE-ConnectionGUID: 0sjl9AEoQ4ClaMqXYxDmKg==
X-CSE-MsgGUID: mMiSQtGXQBO4mASnVJPABw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="180539023"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO vcostago-mobl3) ([10.125.111.253])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 19:38:50 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Nhat Pham <nphamcs@gmail.com>, Kanchana P Sridhar
 <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
 yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com,
 ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com,
 akpm@linux-foundation.org, senozhatsky@chromium.org,
 linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
 ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
 wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
In-Reply-To: <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
Date: Wed, 17 Sep 2025 19:38:49 -0700
Message-ID: <87wm5wpjra.fsf@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Kanchana,

Nhat Pham <nphamcs@gmail.com> writes:

> On Thu, Jul 31, 2025 at 9:36=E2=80=AFPM Kanchana P Sridhar
> <kanchana.p.sridhar@intel.com> wrote:
>>
>
> Can we get some comments from crypto tree maintainers as well? I feel
> like this patch series is more crypto patch than zswap patch, at this
> point.
>
> Can we land any zswap parts without the crypto API change? Grasping at
> straws here, in case we can parallelize the reviewing and merging
> process.
>

Late to the game, but I have a similar suggestion: send a more
targeted/smaller series that only focus on the Crypto API changes,
(perhaps including the zswap bits?). Have those accepted/agreed upon,
and then we can work on the iaa_crypto optimizations/improvements in a
separate series, with a smaller audience.

Do you think it could work?

>>
>> Following Andrew's suggestion, the next two paragraphs emphasize general=
ity
>> and alignment with current kernel efforts.
>>
>> Architectural considerations for the zswap batching framework:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> We have designed the zswap batching framework to be
>> hardware-agnostic. It has no dependencies on Intel-specific features and
>> can be leveraged by any hardware accelerator or software-based
>> compressor. In other words, the framework is open and inclusive by
>> design.
>>
>> Other ongoing work that can use batching:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> This patch-series demonstrates the performance benefits of compress
>> batching when used in zswap_store() of large folios. shrink_folio_list()
>> "reclaim batching" of any-order folios is the next major work that uses
>> this zswap compress batching framework: our testing of kernel_compilation
>> with writeback and the zswap shrinker indicates 10X fewer pages get
>> written back when we reclaim 32 folios as a batch, as compared to one
>> folio at a time: this is with deflate-iaa and with zstd. We expect to
>> submit a patch-series with this data and the resulting performance
>> improvements shortly. Reclaim batching relieves memory pressure faster
>> than reclaiming one folio at a time, hence alleviates the need to scan
>> slab memory for writeback.
>>
>> Many thanks to Nhat for suggesting ideas on using batching with the
>> ongoing kcompressd work, as well as beneficially using decompression
>> batching & block IO batching to improve zswap writeback efficiency.
>
> My pleasure :)
>
>>
>> Experiments with kernel compilation benchmark (allmod config) that
>> combine zswap compress batching, reclaim batching, swapin_readahead()
>> decompression batching of prefetched pages, and writeback batching show
>> that 0 pages are written back to disk with deflate-iaa and zstd. For
>> comparison, the baselines for these compressors see 200K-800K pages
>> written to disk.
>>
>> To summarize, these are future clients of the batching framework:
>>
>>    - shrink_folio_list() reclaim batching of multiple folios:
>>        Implemented, will submit patch-series.
>>    - zswap writeback with decompress batching:
>>        Implemented, will submit patch-series.
>>    - zram:
>>        Implemented, will submit patch-series.
>>    - kcompressd:
>>        Not yet implemented.
>>    - file systems:
>>        Not yet implemented.
>>    - swapin_readahead() decompression batching of prefetched pages:
>>        Implemented, will submit patch-series.
>>
>>
>> iaa_crypto Driver Rearchitecting and Optimizations:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>>
>> The most significant highlight of v11 is a new, lightweight and highly
>> optimized iaa_crypto driver, resulting directly in the latency and
>> throughput improvements noted later in this cover letter.
>>
>>  1) Better stability, more functionally versatile to support zswap and
>>     zram with better performance on different Intel platforms.
>>
>>     a) Patches 0002, 0005 and 0010 together resolve a race condition in
>>        mainline v6.15, reported from internal validation, when IAA
>>        wqs/devices are disabled while workloads are using IAA.
>>
>>     b) Patch 0002 introduces a new architecture for mapping cores to
>>        IAAs based on packages instead of NUMA nodes, and generalizing
>>        how WQs are used: as package level shared resources for all
>>        same-package cores (default for compress WQs), or dedicated to
>>        mapped cores (default for decompress WQs). Further, users are
>>        able to configure multiple WQs and specify how many of those are
>>        for compress jobs only vs. decompress jobs only. sysfs iaa_crypto
>>        driver parameters can be used to change the default settings for
>>        performance tuning.
>>
>>     c) idxd descriptor allocation moved from blocking to non-blocking
>>        with retry limits and mitigations if limits are exceeded.
>>
>>     d) Code cleanup for readability and clearer code flow.
>>
>>     e) Fixes IAA re-registration errors upon disabling/enabling IAA wqs
>>        and devices that exists in the mainline v6.15.
>>
>>     f) Rearchitecting iaa_crypto to be independent of crypto_acomp to
>>        enable a zram/zcomp backend_deflate_iaa.c, while fully supporting
>>        the crypto_acomp interfaces for zswap. A new
>>        include/linux/iaa_comp.h is added.
>>
>>     g) New Dynamic compression mode for Granite Rapids to get better
>>        compression ratio by echo-ing 'deflate-iaa-dynamic' as the zswap
>>        compressor.
>>
>>     h) New crypto_acomp API crypto_acomp_batch_size() that will return
>>        the driver's max batch size if the driver has registered the new
>>        get_batch_size() acomp_alg interface; or 1 if there is no driver
>>        specific implementation of get_batch_size().
>>
>>        Accordingly, iaa_crypto provides an implementation for
>>        get_batch_size().
>>
>>     i) A versatile set of interfaces independent of crypto_acomp for use
>>        in developing a zram zcomp backend for iaa_crypto.
>>
>>  2) Performance optimizations (please refer to the latency data per
>>     optimization in the commit logs):
>>
>>     a) Distributing [de]compress jobs in round-robin manner to available
>>        IAAs on package.
>>
>>     b) Replacing the compute-intensive iaa_wq_get()/iaa_wq_put() with a
>>        percpu_ref in struct iaa_wq, thereby eliminating acquiring a
>>        spinlock in the fast path, while using a combination of the
>>        iaa_crypto_enabled atomic with spinlocks in the slow path to
>>        ensure the compress/decompress code sees a consistent state of the
>>        wq tables.
>>
>>     c) Directly call movdir64b for non-irq use cases, i.e., the most
>>        common usage. Avoid the overhead of irq-specific computes in
>>        idxd_submit_desc() to gain latency.
>>
>>     d) Batching of compressions/decompressions using async submit-poll
>>        mechanism to derive the benefits of hardware parallelism.
>>
>>     e) Batching compressors need to manage their own "request"
>>        abstraction, and remove this driver-specific aspect from being
>>        managed by kernel users such as zswap. iaa_crypto maintains
>>        per-CPU "struct iaa_req **reqs" to submit multiple jobs to the
>>        hardware accelerator to run in parallel.
>>
>>     f) Add a "void *kernel_data" member to struct acomp_req for use by
>>        kernel modules to pass batching data to algorithms that support
>>        batching. This allows us to enable compress batching with only
>>        the crypto_acomp_batch_size() API, and without changes to
>>        existing crypto_acomp API.
>>
>>     g) Submit the two largest data buffers first for decompression
>>        batching, so that the longest running jobs get a head start,
>>        reducing latency for the batch.
>>
>>
>> Main Changes in Zswap Compression Batching:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>  Note to zswap maintainers:
>>  --------------------------
>>  Patches 20 and 21 can be reviewed and improved/merged independently
>>  of this series, since they are zswap centric. These 2 patches help
>>  batching but the crypto_acomp_batch_size() from the iaa_crypto commits
>>  in this series is not a requirement, unlike patches 22-24.
>>
>>  1) v11 preserves the pool acomp_ctx resources creation/deletion
>>     simplification of v9, namely, lasting from pool creation-deletion,
>>     persisting through CPU hot[un]plug operations. Further, zswap no
>>     longer needs to create multiple "struct acomp_req" in the per-CPU
>>     acomp_ctx. zswap only needs to manage multiple "u8 **buffers".
>>
>>  2) We store the compressor's batch-size (@pool->compr_batch_size) and
>>     the batch-size to use during compression batching
>>     (@pool->batch_size) directly in struct zswap_pool for quick
>>     retrieval in the zswap_store() fast path.
>>
>>  3) Optimizations to not cause regressions in software compressors with
>>     the introduction of the new unified zswap_compress() procedure that
>>     implements compression batching for all compressors. Since v9, the
>>     new zpool_malloc() interface that allocates pool memory on the NUMA
>>     node, when used in the new zswap_compress() batching implementation,
>>     caused some performance loss (verified by replacing
>>     page_to_nid(page) with NUMA_NO_NODE). These optimizations help
>>     recover the performance and are included in this series:
>>
>>     a) kmem_cache_alloc_bulk(), kmem_cache_free_bulk() to allocate/free
>>        batch zswap_entry-s. These kmem_cache API allow allocator
>>        optimizations with internal locks for multiple allocations.
>>
>>     b) Writes to the zswap_entry right after it is allocated without
>>        modifying the publishing order. This avoids different code blocks
>>        in zswap_store_pages() having to bring the zswap_entries to the
>>        cache for writing, potentially evicting other working set
>>        structures, impacting performance.
>>
>>     c) ZSWAP_MAX_BATCH_SIZE is used as the batch-size for software
>>        compressors, since this gives the best performance with zstd when
>>        writeback is enabled, and does not regress performance when
>>        writeback is not enabled.
>>
>>     d) More likely()/unlikely() annotations to try and minimize branch
>>        mis-predicts.
>>
>>  4) "struct swap_batch_comp_data" and "struct swap_batch_decomp_data"
>>      added in mm/swap.h:
>>
>>      /*
>>       * A compression algorithm that wants to batch compressions/decompr=
essions
>>       * must define its own internal data structures that exactly mirror
>>       * @struct swap_batch_comp_data and @struct swap_batch_decomp_data.
>>       */
>>
>>      Accordingly, zswap_compress() uses struct swap_batch_comp_data to
>>      pass batching data in the acomp_req->kernel_data
>>      pointer if the compressor supports batching.
>>
>>      include/linux/iaa_comp.h has matching definitions of
>>      "struct iaa_batch_comp_data" and "struct iaa_batch_decomp_data".
>>
>>      Feedback from the zswap maintainers is requested on whether this
>>      is a good approach. Suggestions for alternative approaches are also
>>      very welcome.
>>
>>
>> Compression Batching:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> This patch-series introduces batch compression of pages in large folios =
to
>> improve zswap swapout latency. It preserves the existing zswap protocols
>> for non-batching software compressors by calling crypto_acomp sequential=
ly
>> per page in the batch. Additionally, in support of hardware accelerators
>> that can process a batch as an integral unit, the patch-series allows
>> zswap to call crypto_acomp without API changes, for compressors
>> that intrinsically support batching.
>>
>> The patch series provides a proof point by using the Intel Analytics
>> Accelerator (IAA) for implementing the compress/decompress batching API
>> using hardware parallelism in the iaa_crypto driver and another proof po=
int
>> with a sequential software compressor, zstd.
>>
>> SUMMARY:
>> =3D=3D=3D=3D=3D=3D=3D=3D
>>
>>   The first proof point is to test with IAA using a sequential call (ful=
ly
>>   synchronous, compress one page at a time) vs. a batching call (fully
>>   asynchronous, submit a batch to IAA for parallel compression, then pol=
l for
>>   completion statuses).
>>
>>     The performance testing data with 30 usemem processes/64K folios
>>     shows 52% throughput gains and 24% elapsed/sys time reductions with
>>     deflate-iaa; and 11% sys time reduction with zstd for a small
>>     throughput increase.
>>
>>     Kernel compilation test with 64K folios using 28 threads and the
>>     zswap shrinker_enabled set to "Y", demonstrates similar
>>     improvements: zswap_store() large folios using IAA compress batching
>>     improves the workload performance by 6.8% and reduces sys time by
>>     19% as compared to IAA sequential. For zstd, compress batching
>>     improves workload performance by 5.2% and reduces sys time by
>>     27.4% as compared to sequentially calling zswap_compress() per page
>>     in a folio.
>>
>>   The second proof point is to make sure that software algorithms such as
>>   zstd do not regress. The data indicates that for sequential software
>>   algorithms a performance gain is achieved.
>>
>>     With the performance optimizations implemented in patches 22-24
>>     of v11:
>>     *  zstd usemem30 throughput with PMD folios increases by
>>        1%. Throughput with 64K folios is within range of variation
>>        with a slight improvement. Workload performance with zstd
>>        improves by 8%-6%, and sys time reduces by 11%-8% with 64K/PMD
>>        folios.
>>
>>     *  With kernel compilation using zstd with the zswap shrinker, we
>>        get a 27.4%-28.2% reduction in sys time, a 5.2%-2.1% improvement
>>        in workload performance, and 65%-59% fewer pages written back to
>>        disk for 64K/PMD folios respectively.
>>
>>     These optimizations pertain to ensuring common code paths, removing
>>     redundant branches/computes, using prefetchw() of the zswap entry
>>     before it is written, and selectively annotating branches with
>>     likely()/unlikely() compiler directives to minimize branch
>>     mis-prediction penalty. Additionally, using the batching code for
>>     non-batching compressors to sequentially compress/store batches of up
>>     to ZSWAP_MAX_BATCH_SIZE pages seems to help, most likely due to
>>     cache locality of working set structures such as the array of
>>     zswap_entry-s for the batch.
>>
>>     Our internal validation of zstd with the batching interface vs. IAA =
with
>>     the batching interface on Emerald Rapids has shown that IAA
>>     compress/decompress batching gives 21.3% more memory savings as comp=
ared
>>     to zstd, for 5% performance loss as compared to the baseline without=
 any
>>     memory pressure. IAA batching demonstrates more than 2X the memory
>>     savings obtained by zstd at this 95% performance KPI.
>>     The compression ratio with IAA is 2.23, and with zstd 2.96. Even with
>>     this compression ratio deficit for IAA, batching is extremely
>>     beneficial. As we improve the compression ratio of the IAA accelerat=
or,
>>     we expect to see even better memory savings with IAA as compared to
>>     software compressors.
>>
>>
>>   Batching Roadmap:
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>   1) Compression batching within large folios (this series).
>>
>>   2) zswap writeback decompression batching:
>>
>>      This is being co-developed with Nhat Pham, and shows promising
>>      results. We plan to submit an RFC shortly.
>>
>>   3) Reclaim batching of hybrid folios:
>>
>>      We can expect to see even more significant performance and throughp=
ut
>>      improvements if we use the parallelism offered by IAA to do reclaim
>>      batching of 4K/large folios (really any-order folios), and using the
>>      zswap_store() high throughput compression pipeline to batch-compress
>>      pages comprising these folios, not just batching within large
>>      folios. This is the reclaim batching patch 13 in v1, which we expect
>>      to submit in a separate patch-series. As mentioned earlier, reclaim
>>      batching reduces the # of writeback pages by 10X for zstd and
>>      deflate-iaa.
>>
>>   4) swapin_readahead() decompression batching:
>>
>>      We have developed a zswap load batching interface to be used
>>      for parallel decompression batching, using swapin_readahead().
>>
>>   These capabilities are architected so as to be useful to zswap and
>>   zram. We are actively working on integrating these components with zra=
m.
>>
>>
>>   v11 Performance Summary:
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>>
>>   This is a performance testing summary of results with usemem30
>>   (30 usemem processes running in a cgroup limited at 150G, each trying =
to
>>    allocate 10G).
>>
>>   zswap shrinker_enabled =3D N.
>>
>>   usemem30 with 64K folios:
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>>
>>      -------------------------------------------------------------------=
----
>>                      mm-unstable-7-30-2025             v11
>>      -------------------------------------------------------------------=
----
>>      zswap compressor          deflate-iaa     deflate-iaa   IAA Batching
>>                                                                  vs.
>>                                                              IAA Sequent=
ial
>>      -------------------------------------------------------------------=
----
>>      Total throughput (KB/s)     7,153,359      10,856,388        52%
>>      Avg throughput (KB/s)         238,445         361,879
>>      elapsed time (sec)              92.61           70.50       -24%
>>      sys time (sec)               2,193.59        1,675.32       -24%
>>      -------------------------------------------------------------------=
----
>>
>>      -------------------------------------------------------------------=
----
>>                      mm-unstable-7-30-2025             v11
>>      -------------------------------------------------------------------=
----
>>      zswap compressor                 zstd            zstd   v11 zstd
>>                                                              improvement
>>      -------------------------------------------------------------------=
----
>>      Total throughput (KB/s)     6,866,411       6,874,244       0.1%
>>      Avg throughput (KB/s)         228,880         229,141
>>      elapsed time (sec)              96.45           89.05        -8%
>>      sys time (sec)               2,410.72        2,150.63       -11%
>>      -------------------------------------------------------------------=
----
>>
>>
>>   usemem30 with 2M folios:
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>>
>>      -------------------------------------------------------------------=
----
>>                      mm-unstable-7-30-2025             v11
>>      -------------------------------------------------------------------=
----
>>      zswap compressor          deflate-iaa     deflate-iaa   IAA Batching
>>                                                                  vs.
>>                                                              IAA Sequent=
ial
>>      -------------------------------------------------------------------=
----
>>      Total throughput (KB/s)     7,268,929      11,312,195        56%
>>      Avg throughput (KB/s)         242,297         377,073
>>      elapsed time (sec)              80.40           68.73       -15%
>>      sys time (sec)               1,856.54        1,599.25       -14%
>>      -------------------------------------------------------------------=
----
>>
>>      -------------------------------------------------------------------=
----
>>                      mm-unstable-7-30-2025             v11
>>      -------------------------------------------------------------------=
----
>>      zswap compressor                 zstd            zstd   v11 zstd
>>                                                              improvement
>>      -------------------------------------------------------------------=
----
>>      Total throughput (KB/s)     7,560,441       7,627,155       0.9%
>>      Avg throughput (KB/s)         252,014         254,238
>>      elapsed time (sec)              88.89           83.22        -6%
>>      sys time (sec)               2,132.05        1,952.98        -8%
>>      -------------------------------------------------------------------=
----
>>
>>
>>   This is a performance testing summary of results with
>>   kernel_compilation test (allmod config, 28 cores, cgroup limited to 2G=
).
>>
>>   Writeback to disk is enabled by setting zswap shrinker_enabled =3D Y.
>>
>>   kernel_compilation with 64K folios:
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>      -------------------------------------------------------------------=
-------
>>                         mm-unstable-7-30-2025             v11
>>      -------------------------------------------------------------------=
-------
>>      zswap compressor             deflate-iaa     deflate-iaa    IAA Bat=
ching
>>                                                                      vs.
>>                                                                  IAA Seq=
uential
>>      -------------------------------------------------------------------=
-------
>>      real_sec                          901.81          840.60       -6.8%
>>      sys_sec                         2,672.93        2,171.17        -19%
>>      zswpout                       34,700,692      24,076,095        -31%
>>      zswap_written_back_pages       2,612,474       1,451,961        -44%
>>      -------------------------------------------------------------------=
-------
>>
>>      -------------------------------------------------------------------=
-------
>>                         mm-unstable-7-30-2025             v11
>>      -------------------------------------------------------------------=
-------
>>      zswap compressor                    zstd            zstd    Improve=
ment
>>      -------------------------------------------------------------------=
-------
>>      real_sec                          882.67          837.21       -5.2%
>>      sys_sec                         3,573.31        2,593.94      -27.4%
>>      zswpout                       42,768,967      22,660,215        -47%
>>      zswap_written_back_pages       2,109,739         727,919        -65%
>>      -------------------------------------------------------------------=
-------
>>
>>
>>   kernel_compilation with PMD folios:
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>      -------------------------------------------------------------------=
-------
>>                         mm-unstable-7-30-2025             v11
>>      -------------------------------------------------------------------=
-------
>>      zswap compressor             deflate-iaa     deflate-iaa    IAA Bat=
ching
>>                                                                      vs.
>>                                                                  IAA Seq=
uential
>>      -------------------------------------------------------------------=
-------
>>      real_sec                          838.76          804.83         -4%
>>      sys_sec                         3,173.57        2,422.63        -24%
>>      zswpout                       59,544,198      38,093,995        -36%
>>      zswap_written_back_pages       2,726,367         929,614        -66%
>>      -------------------------------------------------------------------=
-------
>>
>>
>>      -------------------------------------------------------------------=
-------
>>                         mm-unstable-7-30-2025             v11
>>      -------------------------------------------------------------------=
-------
>>      zswap compressor                    zstd            zstd    Improve=
ment
>>      -------------------------------------------------------------------=
-------
>>      real_sec                          831.09          813.40       -2.1%
>>      sys_sec                         4,251.11        3,053.95      -28.2%
>>      zswpout                       59,452,638      35,832,407        -40%
>>      zswap_written_back_pages       1,041,721         423,334        -59%
>>      -------------------------------------------------------------------=
-------
>
> I see a lot of good numbers for both IAA and zstd here. Thanks for
> working on it, Kanchana!
>
>>
>>
>>
>> DETAILS:
>> =3D=3D=3D=3D=3D=3D=3D=3D
>>
>> (A) From zswap's perspective, the most significant changes are:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> 1) A unified zswap_compress() API is added to compress multiple
>>    pages:
>>
>>    - If the compressor has multiple acomp requests, i.e., internally
>>      supports batching, crypto_acomp_batch_compress() is called. If all
>>      pages are successfully compressed, the batch is stored in zpool.
>>
>>    - If the compressor can only compress one page at a time, each page
>>      is compressed and stored sequentially.
>>
>>    Many thanks to Yosry for this suggestion, because it is an essential
>>    component of unifying common code paths between sequential/batching
>>    compressions.
>>
>>    prefetchw() is used in zswap_compress() to minimize cache-miss
>>    latency by moving the zswap entry to the cache before it is written
>>    to; reducing sys time by ~1.5% for zstd (non-batching software
>>    compression). In other words, this optimization helps both batching a=
nd
>>    software compressors.
>>
>>    Overall, the prefetchw() and likely()/unlikely() annotations prevent
>>    regressions with software compressors like zstd, and generally improve
>>    non-batching compressors' performance with the batching code by ~8%.
>>
>> 2) A new zswap_store_pages() is added, that stores multiple pages in a
>>    folio in a range of indices. This is an extension of the earlier
>>    zswap_store_page(), except it operates on a batch of pages.
>>
>> 3) zswap_store() is modified to store the folio's pages in batches
>>    by calling zswap_store_pages(). If the compressor supports batching,
>>    the folio will be compressed in batches of
>>    "pool->compr_batch_size". If the compressor does not support
>>    batching, the folio will be compressed in batches of
>>    ZSWAP_MAX_BATCH_SIZE pages, where each page in the batch is
>>    compressed sequentially. We see better performance by processing
>>    the folio in batches of ZSWAP_MAX_BATCH_SIZE, due to cache locality
>>    of working set structures such as the array of zswap_entry-s for the
>>    batch.
>>
>>    Many thanks to Yosry and Johannes for steering towards a common
>>    design and code paths for sequential and batched compressions (i.e.,
>>    for software compressors and hardware accelerators such as IAA). As p=
er
>>    Yosry's suggestion in v8, the "batch_size" is an attribute of the
>>    compressor/pool, and hence is stored in struct zswap_pool instead of
>>    in struct crypto_acomp_ctx.
>>
>> 4) Simplifications to the acomp_ctx resources allocation/deletion
>>    vis-a-vis CPU hot[un]plug. This further improves upon v8 of this
>>    patch-series based on the discussion with Yosry, and formalizes the
>>    lifetime of these resources from pool creation to pool
>>    deletion. zswap does not register a CPU hotplug teardown
>>    callback. The acomp_ctx resources will persist through CPU
>>    online/offline transitions. The main changes made to avoid UAF/race
>>    conditions, and correctly handle process migration, are:
>>
>>    a) No acomp_ctx mutex locking in zswap_cpu_comp_prepare().
>>    b) No CPU hotplug teardown callback, no acomp_ctx resources deleted.
>>    c) New acomp_ctx_dealloc() procedure that cleans up the acomp_ctx
>>       resources, and is shared by
>>       zswap_cpu_comp_prepare()/zswap_pool_create() error handling and
>>       zswap_pool_destroy().
>>    d) The zswap_pool node list instance is removed right after the node
>>       list add function in zswap_pool_create().
>>    e) We directly call mutex_[un]lock(&acomp_ctx->mutex) in
>>       zswap_[de]compress(). acomp_ctx_get_cpu_lock()/acomp_ctx_put_unloc=
k()
>>       are deleted.
>>
>>    The commit log of patch 0020 has a more detailed analysis.
>>
>>
>> (B) Main changes in crypto_acomp and iaa_crypto:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> 1) A new architecture is introduced for IAA device WQs' usage as:
>>    - compress only
>>    - decompress only
>>    - generic, i.e., both compress/decompress.
>>
>>    Further, IAA devices/wqs are assigned to cores based on packages
>>    instead of NUMA nodes.
>>
>>    The WQ rebalancing algorithm that is invoked as WQs are
>>    discovered/deleted has been made very general and flexible so that
>>    the user can control exactly how IAA WQs are used. In addition to the
>>    user being able to specify a WQ type as comp/decomp/generic, the user
>>    can also configure if WQs need to be shared among all same-package
>>    cores, or, whether the cores should be divided up amongst the
>>    available IAA devices.
>>
>>    If distribute_[de]comps is enabled, from a given core's perspective,
>>    the iaa_crypto driver will distribute comp/decomp jobs among all
>>    devices' WQs in round-robin manner. This improves batching latency
>>    and can improve compression/decompression throughput for workloads
>>    that see a lot of swap activity.
>>
>>    The commit log of patch 0002 provides more details on new iaa_crypto
>>    driver parameters added, along with recommended settings (defaults
>>    are optimal settings).
>>
>> 2) Compress/decompress batching are implemented using
>>    crypto_acomp_[de]compress() with batching data passed to the driver
>>    using the acomp_req->kernel_data pointer.
>>
>>
>> (C) The patch-series is organized as follows:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>  1) crypto acomp & iaa_crypto driver enablers for batching: Relevant
>>     patches are tagged with "crypto:" in the subject:
>>
>>     Patch 1) Reorganizes the iaa_crypto driver code into logically relat=
ed
>>              sections and avoids forward declarations, in order to facil=
itate
>>              subsequent iaa_crypto patches. This patch makes no
>>              functional changes.
>>
>>     Patch 2) Makes an infrastructure change in the iaa_crypto driver
>>              to map IAA devices/work-queues to cores based on packages
>>              instead of NUMA nodes. This doesn't impact performance on
>>              the Sapphire Rapids system used for performance
>>              testing. However, this change fixes functional problems we
>>              found on Granite Rapids during internal validation, where t=
he
>>              number of NUMA nodes is greater than the number of packages,
>>              which was resulting in over-utilization of some IAA devices
>>              and non-usage of other IAA devices as per the current NUMA
>>              based mapping infrastructure.
>>
>>              This patch also develops a new architecture that
>>              generalizes how IAA device WQs are used. It enables
>>              designating IAA device WQs as either compress-only or
>>              decompress-only or generic. Once IAA device WQ types are
>>              thus defined, it also allows the configuration of whether
>>              device WQs will be shared by all cores on the package, or
>>              used only by "mapped cores" obtained by a simple allocation
>>              of available IAAs to cores on the package.
>>
>>              As a result of the overhaul of wq_table definition,
>>              allocation and rebalancing, this patch eliminates
>>              duplication of device WQs in per-CPU wq_tables, thereby
>>              saving 140MiB on a 384 cores dual socket Granite Rapids ser=
ver
>>              with 8 IAAs.
>>
>>              Regardless of how the user has configured the WQs' usage,
>>              the next WQ to use is obtained through a direct look-up in
>>              per-CPU "cpu_comp_wqs" and "cpu_decomp_wqs" structures so
>>              as to minimize latency in the critical path driver compress
>>              and decompress routines.
>>
>>     Patch 3) Code cleanup, consistency of function parameters.
>>
>>     Patch 4) Makes a change to iaa_crypto driver's descriptor allocation,
>>              from blocking to non-blocking with retries/timeouts and
>>              mitigations in case of timeouts during compress/decompress
>>              ops. This prevents tasks getting blocked indefinitely, which
>>              was observed when testing 30 cores running workloads, with
>>              only 1 IAA enabled on Sapphire Rapids (out of 4). These
>>              timeouts are typically only encountered, and associated
>>              mitigations exercised, only in configurations with 1 IAA
>>              device shared by 30+ cores.
>>
>>     Patch 5) Optimize iaa_wq refcounts using a percpu_ref instead of
>>              spinlocks and "int refcount".
>>
>>     Patch 6) Code simplification and restructuring for understandability
>>              in core iaa_compress() and iaa_decompress() routines.
>>
>>     Patch 7) Refactor hardware descriptor setup to their own procedures
>>              to reduce code clutter.
>>
>>     Patch 8) Simplify and optimize (i.e. reduce computes) job submission
>>              for the most commonly used non-irq async mode by directly
>>              calling movdir64b.
>>
>>     Patch 9) Deprecate exporting symbols for adding IAA compression
>>              modes.
>>
>>     Patch 10) Rearchitect iaa_crypto to be agnostic of crypto_acomp for
>>               it be usable in both zswap and zram. crypto_acomp interfac=
es are
>>               maintained as earlier, for use in zswap.
>>
>>     Patch 11) Descriptor submit and polling mechanisms, enablers for bat=
ching.
>>
>>     Patch 12) Add a "void *kernel_data" member to struct acomp_req. This
>>               gets initialized to NULL in acomp_request_set_params().
>>
>>     Patch 13) Implement IAA batching of compressions and decompressions
>>               for deriving hardware parallelism.
>>
>>     Patch 14) Enables the "async" mode, sets it as the default.
>>
>>     Patch 15) Disables verify_compress by default.
>>
>>     Patch 16) Decompress batching optimization: Find the two largest
>>               buffers in the batch and submit them first.
>>
>>     Patch 17) Add a new Dynamic compression mode that can be used on
>>               Granite Rapids.
>>
>>     Patch 18) Add get_batch_size() to structs acomp_alg/crypto_acomp and
>>               a crypto_acomp_batch_size() API that returns the compresso=
r's
>>               batch-size, if it has provided an implementation for
>>               get_batch_size(); 1 otherwise.
>>
>>     Patch 19) iaa-crypto implementation for get_batch_size(), that
>>               returns an iaa_driver specific constant,
>>               IAA_CRYPTO_MAX_BATCH_SIZE (set to 8U currently).
>>
>>
>>  2) zswap modifications to enable compress batching in zswap_store()
>>     of large folios (including pmd-mappable folios):
>>
>>     Patch 20) Simplifies the zswap_pool's per-CPU acomp_ctx resource
>>               management and lifetime to be from pool creation to pool
>>               deletion.
>>
>>     Patch 21) Uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check=
 for
>>               valid acomp/req, thereby making it consistent with the res=
ource
>>               de-allocation code.
>>
>>     Patch 22) Defines a zswap-specific ZSWAP_MAX_BATCH_SIZE (currently s=
et
>>               as 8U) to denote the maximum number of acomp_ctx batching
>>               resources to allocate, thus limiting the amount of extra
>>               memory used for batching. Further, the "struct
>>               crypto_acomp_ctx" is modified to contain multiple buffers.
>>               New "u8 compr_batch_size" and "u8 batch_size" members are
>>               added to "struct zswap_pool" to track the number of dst
>>               buffers associated with the compressor (more than 1 if
>>               the compressor supports batching) and the unit for storing
>>               large folios using compression batching respectively.
>>
>>     Patch 23) Modifies zswap_store() to store the folio in batches of
>>               pool->batch_size by calling a new zswap_store_pages() that=
 takes
>>               a range of indices in the folio to be stored.
>>               zswap_store_pages() pre-allocates zswap entries for the ba=
tch,
>>               calls zswap_compress() for each page in this range, and st=
ores
>>               the entries in xarray/LRU.
>>
>>     Patch 24) Introduces a new unified implementation of zswap_compress()
>>               for compressors that do and do not support batching. This
>>               eliminates code duplication and facilitates maintainabilit=
y of
>>               the code with the introduction of compress batching. Furth=
er,
>>               there are many optimizations to this common code that resu=
lt
>>               in workload throughput and performance improvements with
>>               software compressors and hardware accelerators such as IAA.
>>
>>               zstd performance is better or on par with mm-unstable. We
>>               see impressive throughput/performance improvements with
>>               IAA and zstd batching vs. no-batching.
>>
>>
>> With v11 of this patch series, the IAA compress batching feature will be
>> enabled seamlessly on Intel platforms that have IAA by selecting
>> 'deflate-iaa' as the zswap compressor, and using the iaa_crypto 'async'
>> sync_mode driver attribute (the default).
>>
>>
>> System setup for testing:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>> Testing of this patch-series was done with mm-unstable as of 7-30-2025,
>> commit 01da54f10fdd, without and with this patch-series. Data was
>> gathered on an Intel Sapphire Rapids (SPR) server, dual-socket 56 cores
>> per socket, 4 IAA devices per socket, each IAA has total 128 WQ entries,
>> 503 GiB RAM and 525G SSD disk partition swap. Core frequency was fixed
>> at 2500MHz.
>>
>> Other kernel configuration parameters:
>>
>>     zswap compressor  : zstd, deflate-iaa
>>     zswap allocator   : zsmalloc
>>     vm.page-cluster   : 0
>>
>> IAA "compression verification" is disabled and IAA is run in the async
>> mode (the defaults with this series).
>>
>> I ran experiments with these workloads:
>>
>> 1) usemem 30 processes with zswap shrinker_enabled=3DN. Two sets of
>>    experiments, one with 64K folios, another with PMD folios.
>>
>> 2) Kernel compilation allmodconfig with 2G max memory, 28 threads, with
>>    zswap shrinker_enabled=3DY to test batching performance impact when
>>    writeback is enabled. Two sets of experiments, one with 64K folios,
>>    another with PMD folios.
>>
>> IAA configuration is done by a CLI: script is included at the end of the
>> cover letter.
>>
>>
>> Performance testing (usemem30):
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>> The vm-scalability "usemem" test was run in a cgroup whose memory.high
>> was fixed at 150G. The is no swap limit set for the cgroup. 30 usemem
>> processes were run, each allocating and writing 10G of memory, and
>> sleeping for 10 sec before exiting:
>>
>>  usemem --init-time -w -O -b 1 -s 10 -n 30 10g
>>  echo 0 > /sys/module/zswap/parameters/shrinker_enabled
>>
>>  IAA WQ Configuration (script is iincluded at the end of the cover
>>  letter):
>>
>>    ./enable_iaa.sh -d 4 -q 1
>>
>>  This enables all 4 IAAs on the socket, and configures 1 WQ per IAA
>>  device, each containing 128 entries. The driver distributes compress
>>  jobs from each core to wqX.0 of all same-package IAAs in a
>>  round-robin manner. Decompress jobs are send to the wqX.0 of the
>>  mapped IAA device.
>>
>>  Since usemem has significantly more swapouts than swapins, this
>>  configuration is the most optimal.
>>
>>  64K folios: usemem30: deflate-iaa:
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>  -----------------------------------------------------------------------=
--------
>>                     mm-unstable-7-30-2025             v11
>>  -----------------------------------------------------------------------=
--------
>>  zswap compressor             deflate-iaa     deflate-iaa    IAA Batching
>>                                                                  vs.
>>                                                              IAA Sequent=
ial
>>  -----------------------------------------------------------------------=
--------
>>  Total throughput (KB/s)        7,153,359      10,856,388         52%
>>  Avg throughput (KB/s)            238,445         361,879
>>  elapsed time (sec)                 92.61           70.50        -24%
>>  sys time (sec)                  2,193.59        1,675.32        -24%
>>
>>  -----------------------------------------------------------------------=
--------
>>  memcg_high                     1,061,494       1,340,863
>>  memcg_swap_fail                    1,496             240
>>  64kB_swpout_fallback               1,496             240
>>  zswpout                       61,642,322      71,374,066
>>  zswpin                               130             250
>>  pswpout                                0               0
>>  pswpin                                 0               0
>>  ZSWPOUT-64kB                   3,851,135       4,460,571
>>  SWPOUT-64kB                            0               0
>>  pgmajfault                         2,446           2,545
>>  zswap_reject_compress_fail             0               0
>>  zswap_reject_reclaim_fail              0               0
>>  zswap_pool_limit_hit                   0               0
>>  zswap_written_back_pages               0               0
>>  IAA incompressible pages               0               0
>>  -----------------------------------------------------------------------=
--------
>>
>>
>>  2M folios: usemem30: deflate-iaa:
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>  -----------------------------------------------------------------------=
--------
>>                     mm-unstable-7-30-2025             v11
>>  -----------------------------------------------------------------------=
--------
>>  zswap compressor             deflate-iaa     deflate-iaa     IAA Batchi=
ng
>>                                                                   vs.
>>                                                               IAA Sequen=
tial
>>  -----------------------------------------------------------------------=
--------
>>  Total throughput (KB/s)        7,268,929      11,312,195         56%
>>  Avg throughput (KB/s)            242,297         377,073
>>  elapsed time (sec)                 80.40           68.73        -15%
>>  sys time (sec)                  1,856.54        1,599.25        -14%
>>
>>  -----------------------------------------------------------------------=
--------
>>  memcg_high                        99,426         119,834
>>  memcg_swap_fail                      371             293
>>  thp_swpout_fallback                  371             293
>>  zswpout                       63,227,705      71,567,857
>>  zswpin                               456             482
>>  pswpout                                0               0
>>  pswpin                                 0               0
>>  ZSWPOUT-2048kB                   123,119         139,505
>>  thp_swpout                             0               0
>>  pgmajfault                         2,901           2,813
>>  zswap_reject_compress_fail             0               0
>>  zswap_reject_reclaim_fail              0               0
>>  zswap_pool_limit_hit                   0               0
>>  zswap_written_back_pages               0               0
>>  IAA incompressible pages               0               0
>>  -----------------------------------------------------------------------=
--------
>>
>>
>>
>>  64K folios: usemem30: zstd:
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>>
>>  -----------------------------------------------------------------------=
--------
>>                     mm-unstable-7-30-2025             v11
>>  -----------------------------------------------------------------------=
--------
>>  zswap compressor                    zstd            zstd        v11 zstd
>>                                                                  improve=
ment
>>  -----------------------------------------------------------------------=
--------
>>  Total throughput (KB/s)        6,866,411       6,874,244        0.1%
>>  Avg throughput (KB/s)            228,880         229,141
>>  elapsed time (sec)                 96.45           89.05         -8%
>>  sys time (sec)                  2,410.72        2,150.63        -11%
>>
>>  -----------------------------------------------------------------------=
--------
>>  memcg_high                     1,070,285       1,075,178
>>  memcg_swap_fail                    2,404              66
>>  64kB_swpout_fallback               2,404              66
>>  zswpout                       49,767,024      49,672,972
>>  zswpin                               454             192
>>  pswpout                                0               0
>>  pswpin                                 0               0
>>  ZSWPOUT-64kB                   3,108,029       3,104,433
>>  SWPOUT-64kB                            0               0
>>  pgmajfault                         2,758           2,481
>>  zswap_reject_compress_fail             0               0
>>  zswap_reject_reclaim_fail              0               0
>>  zswap_pool_limit_hit                   0               0
>>  zswap_written_back_pages               0               0
>>  -----------------------------------------------------------------------=
--------
>>
>>
>>  2M folios: usemem30: zstd:
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>>
>>  -----------------------------------------------------------------------=
--------
>>                     mm-unstable-7-30-2025             v11
>>  -----------------------------------------------------------------------=
--------
>>  zswap compressor                    zstd            zstd        v11 zstd
>>                                                                  improve=
ment
>>  -----------------------------------------------------------------------=
--------
>>  Total throughput (KB/s)        7,560,441       7,627,155        0.9%
>>  Avg throughput (KB/s)            252,014         254,238
>>  elapsed time (sec)                 88.89           83.22         -6%
>>  sys time (sec)                  2,132.05        1,952.98         -8%
>>
>>  -----------------------------------------------------------------------=
--------
>>  memcg_high                        89,486          88,982
>>  memcg_swap_fail                      183              41
>>  thp_swpout_fallback                  183              41
>>  zswpout                       48,947,054      48,598,306
>>  zswpin                               472             252
>>  pswpout                                0               0
>>  pswpin                                 0               0
>>  ZSWPOUT-2048kB                    95,420          94,876
>>  thp_swpout                             0               0
>>  pgmajfault                         2,789           2,540
>>  zswap_reject_compress_fail             0               0
>>  zswap_reject_reclaim_fail              0               0
>>  zswap_pool_limit_hit                   0               0
>>  zswap_written_back_pages               0               0
>>  -----------------------------------------------------------------------=
--------
>>
>>
>>
>> Performance testing (Kernel compilation, allmodconfig):
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>>
>> The experiments with kernel compilation test use 28 threads and build
>> the "allmodconfig" that takes ~14 minutes, and has considerable
>> swapout/swapin activity. The cgroup's memory.max is set to 2G. We
>> trigger writeback by enabling the zswap shrinker.
>>
>>  echo 1 > /sys/module/zswap/parameters/shrinker_enabled
>>
>>  IAA WQ Configuration (script is at the end of the cover letter):
>>
>>    ./enable_iaa.sh -d 4 -q 2
>>
>>  This enables all 4 IAAs on the socket, and configures 2 WQs per IAA,
>>  each containing 64 entries. The driver sends decompresses to wqX.0 of
>>  the mapped IAA device, and distributes compresses to wqX.1 of all
>>  same-package IAAs in a round-robin manner.
>>
>>  64K folios: Kernel compilation/allmodconfig: deflate-iaa:
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>  -----------------------------------------------------------------------=
--------
>>                     mm-unstable-7-30-2025             v11
>>  -----------------------------------------------------------------------=
--------
>>  zswap compressor             deflate-iaa     deflate-iaa    IAA Batching
>>                                                                  vs.
>>                                                              IAA Sequent=
ial
>>  -----------------------------------------------------------------------=
--------
>>  real_sec                          901.81          840.60       -6.8%
>>  user_sec                       15,499.45       15,431.54
>>  sys_sec                         2,672.93        2,171.17        -19%
>>  -----------------------------------------------------------------------=
--------
>>  Max_Res_Set_Size_KB            1,872,984       1,872,884
>>  -----------------------------------------------------------------------=
--------
>>  memcg_high                             0               0
>>  memcg_swap_fail                    2,633               0
>>  64kB_swpout_fallback               2,630               0
>>  zswpout                       34,700,692      24,076,095        -31%
>>  zswpin                         7,791,832       4,937,822
>>  pswpout                        2,624,324       1,459,681
>>  pswpin                         2,486,667       1,229,416
>>  ZSWPOUT-64kB                   1,254,622         896,433
>>  SWPOUT-64kB                           36              18
>>  pgmajfault                    10,613,272       6,305,623
>>  zswap_reject_compress_fail            64             111
>>  zswap_reject_reclaim_fail            301              59
>>  zswap_pool_limit_hit                   0               0
>>  zswap_written_back_pages       2,612,474       1,451,961        -44%
>>  IAA incompressible pages              64             111
>>  -----------------------------------------------------------------------=
--------
>>
>>
>>  2M folios: Kernel compilation/allmodconfig: deflate-iaa:
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>  -----------------------------------------------------------------------=
--------
>>                     mm-unstable-7-30-2025             v11
>>  -----------------------------------------------------------------------=
--------
>>  zswap compressor             deflate-iaa     deflate-iaa    IAA Batching
>>                                                                  vs.
>>                                                              IAA Sequent=
ial
>>  -----------------------------------------------------------------------=
--------
>>  real_sec                          838.76          804.83         -4%
>>  user_sec                       15,624.57       15,566.49
>>  sys_sec                         3,173.57        2,422.63        -24%
>>  -----------------------------------------------------------------------=
--------
>>  Max_Res_Set_Size_KB            1,874,680       1,872,892
>>  -----------------------------------------------------------------------=
--------
>>  memcg_high                             0               0
>>  memcg_swap_fail                   10,350             906
>>  thp_swpout_fallback               10,342             906
>>  zswpout                       59,544,198      38,093,995        -36%
>>  zswpin                        17,933,865      10,220,321
>>  pswpout                        2,740,024         935,226
>>  pswpin                         3,179,590       1,346,338
>>  ZSWPOUT-2048kB                     6,464          10,435
>>  thp_swpout                             4               3
>>  pgmajfault                    21,609,542      11,819,882
>>  zswap_reject_compress_fail            50               8
>>  zswap_reject_reclaim_fail          2,335           2,377
>>  zswap_pool_limit_hit                   0               0
>>  zswap_written_back_pages       2,726,367         929,614        -66%
>>  IAA incompressible pages              50               8
>>  -----------------------------------------------------------------------=
--------
>>
>> With the iaa_crypto driver changes for non-blocking descriptor allocatio=
ns,
>> no timeouts-with-mitigations were seen in compress/decompress jobs, for =
all
>> of the above experiments.
>>
>>
>>  64K folios: Kernel compilation/allmodconfig: zstd:
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>>
>>  -----------------------------------------------------------------------=
--------
>>                     mm-unstable-7-30-2025             v11
>>  -----------------------------------------------------------------------=
--------
>>  zswap compressor                    zstd            zstd    Improvement
>>  -----------------------------------------------------------------------=
--------
>>  real_sec                          882.67          837.21       -5.2%
>>  user_sec                       15,533.14       15,434.03
>>  sys_sec                         3,573.31        2,593.94      -27.4%
>>  -----------------------------------------------------------------------=
--------
>>  Max_Res_Set_Size_KB            1,872,960       1,872,788
>>  -----------------------------------------------------------------------=
--------
>>  memcg_high                             0               0
>>  memcg_swap_fail                        0               0
>>  64kB_swpout_fallback                   0               0
>>  zswpout                       42,768,967      22,660,215        -47%
>>  zswpin                        10,146,520       4,750,133
>>  pswpout                        2,118,745         731,419
>>  pswpin                         2,114,735         824,655
>>  ZSWPOUT-64kB                   1,484,862         824,976
>>  SWPOUT-64kB                            6               3
>>  pgmajfault                    12,698,613       5,697,281
>>  zswap_reject_compress_fail            13               8
>>  zswap_reject_reclaim_fail            624             211
>>  zswap_pool_limit_hit                   0               0
>>  zswap_written_back_pages       2,109,739         727,919        -65%
>>  -----------------------------------------------------------------------=
--------
>>
>>
>>  2M folios: Kernel compilation/allmodconfig: zstd:
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>>
>>  -----------------------------------------------------------------------=
--------
>>                     mm-unstable-7-30-2025             v11
>>  -----------------------------------------------------------------------=
--------
>>  zswap compressor                    zstd            zstd    Improvement
>>  -----------------------------------------------------------------------=
--------
>>  real_sec                          831.09          813.40       -2.1%
>>  user_sec                       15,648.65       15,566.01
>>  sys_sec                         4,251.11        3,053.95      -28.2%
>>  -----------------------------------------------------------------------=
--------
>>  Max_Res_Set_Size_KB            1,872,892       1,874,684
>>  -----------------------------------------------------------------------=
--------
>>  memcg_high                             0               0
>>  memcg_swap_fail                    7,525           1,455
>>  thp_swpout_fallback                7,499           1,452
>>  zswpout                       59,452,638      35,832,407        -40%
>>  zswpin                        17,690,718       9,550,640
>>  pswpout                        1,047,676         426,042
>>  pswpin                         2,155,989         840,514
>>  ZSWPOUT-2048kB                     8,254           8,651
>>  thp_swpout                             4               2
>>  pgmajfault                    20,278,921      10,581,456
>>  zswap_reject_compress_fail            47              20
>>  zswap_reject_reclaim_fail          2,342             451
>>  zswap_pool_limit_hit                   0               0
>>  zswap_written_back_pages       1,041,721         423,334        -59%
>>  -----------------------------------------------------------------------=
--------
>>
>>
>>
>> IAA configuration script "enable_iaa.sh":
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>  Acknowledgements: Binuraj Ravindran and Rakib Al-Fahad.
>>
>>  Usage:
>>  ------
>>
>>    ./enable_iaa.sh -d <num_IAAs> -q <num_WQs_per_IAA>
>>
>>
>>  #---------------------------------<cut here>---------------------------=
-------
>>  #!/usr/bin/env bash
>>  #SPDX-License-Identifier: BSD-3-Clause
>>  #Copyright (c) 2025, Intel Corporation
>>  #Description: Configure IAA devices
>>
>>  VERIFY_COMPRESS_PATH=3D"/sys/bus/dsa/drivers/crypto/verify_compress"
>>
>>  iax_dev_id=3D"0cfe"
>>  num_iaa=3D$(lspci -d:${iax_dev_id} | wc -l)
>>  sockets=3D$(lscpu | grep Socket | awk '{print $2}')
>>  echo "Found ${num_iaa} instances in ${sockets} sockets(s)"
>>
>>  #  The same number of devices will be configured in each socket, if the=
re
>>  #  are  more than one socket.
>>  #  Normalize with respect to the number of sockets.
>>  device_num_per_socket=3D$(( num_iaa/sockets ))
>>  num_iaa_per_socket=3D$(( num_iaa / sockets ))
>>
>>  iaa_wqs=3D2
>>  verbose=3D0
>>  iaa_engines=3D8
>>  mode=3D"dedicated"
>>  wq_type=3D"kernel"
>>  iaa_crypto_mode=3D"async"
>>  verify_compress=3D0
>>
>>
>>  # Function to handle errors
>>  handle_error() {
>>      echo "Error: $1"
>>      exit 1
>>  }
>>
>>  # Process arguments
>>
>>  while getopts "d:hm:q:vD" opt; do
>>    case $opt in
>>      d)
>>        device_num_per_socket=3D$OPTARG
>>        ;;
>>      m)
>>        iaa_crypto_mode=3D$OPTARG
>>        ;;
>>      q)
>>        iaa_wqs=3D$OPTARG
>>        ;;
>>      D)
>>        verbose=3D1
>>        ;;
>>      v)
>>        verify_compress=3D1
>>        ;;
>>      h)
>>        echo "Usage: $0 [-d <device_count>][-q <wq_per_device>][-v]"
>>        echo "       -d - number of devices"
>>        echo "       -q - number of WQs per device"
>>        echo "       -v - verbose mode"
>>        echo "       -h - help"
>>        exit
>>        ;;
>>      \?)
>>        echo "Invalid option: -$OPTARG" >&2
>>        exit
>>        ;;
>>    esac
>>  done
>>
>>  LOG=3D"configure_iaa.log"
>>
>>  # Update wq_size based on number of wqs
>>  wq_size=3D$(( 128 / iaa_wqs ))
>>
>>  # Take care of the enumeration, if DSA is enabled.
>>  dsa=3D`lspci | grep -c 0b25`
>>  # set first,step counters to correctly enumerate iax devices based on
>>  # whether running on guest or host with or without dsa
>>  first=3D0
>>  step=3D1
>>  [[ $dsa -gt 0 && -d /sys/bus/dsa/devices/dsa0 ]] && first=3D1 && step=
=3D2
>>  echo "first index: ${first}, step: ${step}"
>>
>>
>>  #
>>  # Switch to software compressors and disable IAAs to have a clean start
>>  #
>>  COMPRESSOR=3D/sys/module/zswap/parameters/compressor
>>  last_comp=3D`cat ${COMPRESSOR}`
>>  echo lzo > ${COMPRESSOR}
>>
>>  echo "Disable IAA devices before configuring"
>>
>>  for ((i =3D ${first}; i < ${step} * ${num_iaa}; i +=3D ${step})); do
>>      for ((j =3D 0; j < ${iaa_wqs}; j +=3D 1)); do
>>          cmd=3D"accel-config disable-wq iax${i}/wq${i}.${j} >& /dev/null"
>>         [[ $verbose =3D=3D 1 ]] && echo $cmd; eval $cmd
>>       done
>>      cmd=3D"accel-config disable-device iax${i} >& /dev/null"
>>      [[ $verbose =3D=3D 1 ]] && echo $cmd; eval $cmd
>>  done
>>
>>  rmmod iaa_crypto
>>  modprobe iaa_crypto
>>
>>  # apply crypto parameters
>>  echo $verify_compress > ${VERIFY_COMPRESS_PATH} || handle_error "did no=
t change verify_compress"
>>  # Note: This is a temporary solution for during the kernel transition.
>>  if [ -f /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa ];then
>>      echo 1 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa || handle_e=
rror "did not set g_comp_wqs_per_iaa"
>>  elif [ -f /sys/bus/dsa/drivers/crypto/g_wqs_per_iaa ];then
>>      echo 1 > /sys/bus/dsa/drivers/crypto/g_wqs_per_iaa || handle_error =
"did not set g_wqs_per_iaa"
>>  fi
>>  if [ -f /sys/bus/dsa/drivers/crypto/g_consec_descs_per_gwq ];then
>>      echo 1 > /sys/bus/dsa/drivers/crypto/g_consec_descs_per_gwq || hand=
le_error "did not set g_consec_descs_per_gwq"
>>  fi
>>  echo ${iaa_crypto_mode} > /sys/bus/dsa/drivers/crypto/sync_mode || hand=
le_error "could not set sync_mode"
>>
>>
>>
>>  echo "Configuring ${device_num_per_socket} device(s) out of $num_iaa_pe=
r_socket per socket"
>>  if [ "${device_num_per_socket}" -le "${num_iaa_per_socket}" ]; then
>>      echo "Configuring all devices"
>>      start=3D${first}
>>      end=3D$(( ${step} * ${device_num_per_socket} ))
>>  else
>>     echo "ERROR: Not enough devices"
>>     exit
>>  fi
>>
>>
>>  #
>>  # enable all iax devices and wqs
>>  #
>>  for (( socket =3D 0; socket < ${sockets}; socket +=3D 1 )); do
>>  for ((i =3D ${start}; i < ${end}; i +=3D ${step})); do
>>
>>      echo "Configuring iaa$i on socket ${socket}"
>>
>>      for ((j =3D 0; j < ${iaa_engines}; j +=3D 1)); do
>>          cmd=3D"accel-config config-engine iax${i}/engine${i}.${j} --gro=
up-id=3D0"
>>          [[ $verbose =3D=3D 1 ]] && echo $cmd; eval $cmd
>>      done
>>
>>      # Config  WQs
>>      for ((j =3D 0; j < ${iaa_wqs}; j +=3D 1)); do
>>          # Config WQ: group 0,  priority=3D10, mode=3Dshared, type =3D k=
ernel name=3Dkernel, driver_name=3Dcrypto
>>          cmd=3D"accel-config config-wq iax${i}/wq${i}.${j} -g 0 -s ${wq_=
size} -p 10 -m ${mode} -y ${wq_type} -n iaa_crypto${i}${j} -d crypto"
>>          [[ $verbose =3D=3D 1 ]] && echo $cmd; eval $cmd
>>       done
>>
>>      # Enable Device and WQs
>>      cmd=3D"accel-config enable-device iax${i}"
>>      [[ $verbose =3D=3D 1 ]] && echo $cmd; eval $cmd
>>
>>      for ((j =3D 0; j < ${iaa_wqs}; j +=3D 1)); do
>>          cmd=3D"accel-config enable-wq iax${i}/wq${i}.${j}"
>>          [[ $verbose =3D=3D 1 ]] && echo $cmd; eval $cmd
>>       done
>>
>>  done
>>      start=3D$(( start + ${step} * ${num_iaa_per_socket} ))
>>      end=3D$(( start + (${step} * ${device_num_per_socket}) ))
>>  done
>>
>>  # Restore the last compressor
>>  echo "$last_comp" > ${COMPRESSOR}
>>
>>  # Check if the configuration is correct
>>  echo "Configured IAA devices:"
>>  accel-config list | grep iax
>>
>>  #---------------------------------<cut here>---------------------------=
-------
>>
>>
>> Changes since v10:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> 1) Rebased to mm-unstable as of 7-30-2025, commit 01da54f10fdd.
>> 2) Added change logging in patch 0024 on there being no Intel-specific
>>    dependencies in the batching framework, as suggested by
>>    Andrew Morton. Thanks Andrew!
>> 3) Added change logging in patch 0024 on other ongoing work that can use
>>    batching, as per Andrew's suggestion. Thanks Andrew!
>> 4) Added the IAA configuration script in the cover letter, as suggested
>>    by Nhat Pham. Thanks Nhat!
>> 5) As suggested by Nhat, dropped patch 0020 from v10, that moves CPU
>>    hotplug procedures to pool functions.
>> 6) Gathered kernel_compilation 'allmod' config performance data with
>>    writeback and zswap shrinker_enabled=3DY.
>> 7) Changed the pool->batch_size for software compressors to be
>>    ZSWAP_MAX_BATCH_SIZE since this gives better performance with the zsw=
ap
>>    shrinker enabled.
>> 8) Was unable to replicate in v11 the issue seen in v10 with higher
>>    memcg_swap_fail than in the baseline, with usemem30/zstd.
>>
>> Changes since v9:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> 1) Rebased to mm-unstable as of 6-24-2025, commit 23b9c0472ea3.
>> 2) iaa_crypto rearchitecting, mainline race condition fix, performance
>>    optimizations, code cleanup.
>> 3) Addressed Herbert's comments in v9 patch 10, that an array based
>>    crypto_acomp interface is not acceptable.
>> 4) Optimized the implementation of the batching zswap_compress() and
>>    zswap_store_pages() added in v9, to recover performance when
>>    integrated with the changes in commit 56e5a103a721 ("zsmalloc: prefer
>>    the the original page's node for compressed data").
>>
>> Changes since v8:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> 1) Rebased to mm-unstable as of 4-21-2025, commit 2c01d9f3c611.
>> 2) Backported commits for reverting request chaining, since these are
>>    in cryptodev-2.6 but not yet in mm-unstable: without these backports,
>>    deflate-iaa is non-functional in mm-unstable:
>>    commit 64929fe8c0a4 ("crypto: acomp - Remove request chaining")
>>    commit 5976fe19e240 ("Revert "crypto: testmgr - Add multibuffer acomp
>>                          testing"")
>>    Backported this hotfix as well:
>>    commit 002ba346e3d7 ("crypto: scomp - Fix off-by-one bug when
>>    calculating last page").
>> 3) crypto_acomp_[de]compress() restored to non-request chained
>>    implementations since request chaining has been removed from acomp in
>>    commit 64929fe8c0a4 ("crypto: acomp - Remove request chaining").
>> 4) New IAA WQ architecture to denote WQ type and whether or not a WQ
>>    should be shared among all package cores, or only to the "mapped"
>>    ones from an even cores-to-IAA distribution scheme.
>> 5) Compress/decompress batching are implemented in iaa_crypto using new
>>    crypto_acomp_batch_compress()/crypto_acomp_batch_decompress() API.
>> 6) Defines a "void *data" in struct acomp_req, based on Herbert advising
>>    against using req->base.data in the driver. This is needed for async
>>    submit-poll to work.
>> 7) In zswap.c, moved the CPU hotplug callbacks to reside in "pool
>>    functions", per Yosry's suggestion to move procedures in a distinct
>>    patch before refactoring patches.
>> 8) A new "u8 nr_reqs" member is added to "struct zswap_pool" to track
>>    the number of requests/buffers associated with the per-cpu acomp_ctx,
>>    as per Yosry's suggestion.
>> 9) Simplifications to the acomp_ctx resources allocation, deletion,
>>    locking, and for these to exist from pool creation to pool deletion,
>>    based on v8 code review discussions with Yosry.
>> 10) Use IS_ERR_OR_NULL() consistently in zswap_cpu_comp_prepare() and
>>     acomp_ctx_dealloc(), as per Yosry's v8 comment.
>> 11) zswap_store_folio() is deleted, and instead, the loop over
>>     zswap_store_pages() is moved inline in zswap_store(), per Yosry's
>>     suggestion.
>> 12) Better structure in zswap_compress(), unified procedure that
>>     compresses/stores a batch of pages for both, non-batching and
>>     batching compressors. Renamed from zswap_batch_compress() to
>>     zswap_compress(): Thanks Yosry for these suggestions.
>>
>>
>> Changes since v7:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> 1) Rebased to mm-unstable as of 3-3-2025, commit 5f089a9aa987.
>> 2) Changed the acomp_ctx->nr_reqs to be u8 since ZSWAP_MAX_BATCH_SIZE is
>>    defined as 8U, for saving memory in this per-cpu structure.
>> 3) Fixed a typo in code comments in acomp_ctx_get_cpu_lock():
>>    acomp_ctx->initialized to acomp_ctx->__online.
>> 4) Incorporated suggestions from Yosry, Chengming, Nhat and Johannes,
>>    thanks to all!
>>    a) zswap_batch_compress() replaces zswap_compress(). Thanks Yosry
>>       for this suggestion!
>>    b) Process the folio in sub-batches of ZSWAP_MAX_BATCH_SIZE, regardle=
ss
>>       of whether or not the compressor supports batching. This gets rid =
of
>>       the kmalloc(entries), and allows us to allocate an array of
>>       ZSWAP_MAX_BATCH_SIZE entries on the stack. This is implemented in
>>       zswap_store_pages().
>>    c) Use of a common structure and code paths for compressing a folio in
>>       batches, either as a request chain (in parallel in IAA hardware) or
>>       sequentially. No code duplication since zswap_compress() has been
>>       replaced with zswap_batch_compress(), simplifying maintainability.
>> 5) A key difference between compressors that support batching and
>>    those that do not, is that for the latter, the acomp_ctx mutex is
>>    locked/unlocked per ZSWAP_MAX_BATCH_SIZE batch, so that decompressions
>>    to handle page-faults can make progress. This fixes the zstd kernel
>>    compilation regression seen in v7. For compressors that support
>>    batching, for e.g. IAA, the mutex is locked/released once for storing
>>    the folio.
>> 6) Used likely/unlikely compiler directives and prefetchw to restore
>>    performance with the common code paths.
>>
>> Changes since v6:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> 1) Rebased to mm-unstable as of 2-27-2025, commit d58172d128ac.
>>
>> 2) Deleted crypto_acomp_batch_compress() and
>>    crypto_acomp_batch_decompress() interfaces, as per Herbert's
>>    suggestion. Batching is instead enabled by chaining the requests. For
>>    non-batching compressors, there is no request chaining involved. Both,
>>    batching and non-batching compressions are accomplished by zswap by
>>    calling:
>>
>>    crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx=
->wait);
>>
>> 3) iaa_crypto implementation of batch compressions/decompressions using
>>    request chaining, as per Herbert's suggestions.
>> 4) Simplification of the acomp_ctx resource allocation/deletion with
>>    respect to CPU hot[un]plug, to address Yosry's suggestions to explore=
 the
>>    mutex options in zswap_cpu_comp_prepare(). Yosry, please let me know =
if
>>    the per-cpu memory cost of this proposed change is acceptable (IAA:
>>    64.8KB, Software compressors: 8.2KB). On the positive side, I believe
>>    restarting reclaim on a CPU after it has been through an offline-onli=
ne
>>    transition, will be much faster by not deleting the acomp_ctx resourc=
es
>>    when the CPU gets offlined.
>> 5) Use of lockdep assertions rather than comments for internal locking
>>    rules, as per Yosry's suggestion.
>> 6) No specific references to IAA in zswap.c, as suggested by Yosry.
>> 7) Explored various solutions other than the v6 zswap_store_folio()
>>    implementation, to fix the zstd regression seen in v5, to attempt to
>>    unify common code paths, and to allocate smaller arrays for the zswap
>>    entries on the stack. All these options were found to cause usemem30
>>    latency regression with zstd. The v6 version of zswap_store_folio() is
>>    the only implementation that does not cause zstd regression, confirmed
>>    by 10 consecutive runs, each giving quite consistent latency
>>    numbers. Hence, the v6 implementation is carried forward to v7, with
>>    changes for branching for batching vs. sequential compression API
>>    calls.
>>
>>
>> Changes since v5:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> 1) Rebased to mm-unstable as of 2-1-2025, commit 7de6fd8ab650.
>>
>> Several improvements, regression fixes and bug fixes, based on Yosry's
>> v5 comments (Thanks Yosry!):
>>
>> 2) Fix for zstd performance regression in v5.
>> 3) Performance debug and fix for marginal improvements with IAA batching
>>    vs. sequential.
>> 4) Performance testing data compares IAA with and without batching, inst=
ead
>>    of IAA batching against zstd.
>> 5) Commit logs/zswap comments not mentioning crypto_acomp implementation
>>    details.
>> 6) Delete the pr_info_once() when batching resources are allocated in
>>    zswap_cpu_comp_prepare().
>> 7) Use kcalloc_node() for the multiple acomp_ctx buffers/reqs in
>>    zswap_cpu_comp_prepare().
>> 8) Simplify and consolidate error handling cleanup code in
>>    zswap_cpu_comp_prepare().
>> 9) Introduce zswap_compress_folio() in a separate patch.
>> 10) Bug fix in zswap_store_folio() when xa_store() failure can cause all
>>     compressed objects and entries to be freed, and UAF when zswap_store=
()
>>     tries to free the entries that were already added to the xarray prior
>>     to the failure.
>> 11) Deleting compressed_bytes/bytes. zswap_store_folio() also comprehends
>>     the recent fixes in commit bf5eaaaf7941 ("mm/zswap: fix inconsistency
>>     when zswap_store_page() fails") by Hyeonggon Yoo.
>>
>> iaa_crypto improvements/fixes/changes:
>>
>> 12) Enables asynchronous mode and makes it the default. With commit
>>     4ebd9a5ca478 ("crypto: iaa - Fix IAA disabling that occurs when
>>     sync_mode is set to 'async'"), async mode was previously just sync. =
We
>>     now have true async support.
>> 13) Change idxd descriptor allocations from blocking to non-blocking with
>>     timeouts, and mitigations for compress/decompress ops that fail to
>>     obtain a descriptor. This is a fix for tasks blocked errors seen in
>>     configurations where 30+ cores are running workloads under high memo=
ry
>>     pressure, and sending comps/decomps to 1 IAA device.
>> 14) Fixes a bug with unprotected access of "deflate_generic_tfm" in
>>     deflate_generic_decompress(), which can cause data corruption and
>>     zswap_decompress() kernel crash.
>> 15) zswap uses crypto_acomp_batch_compress() with async polling instead =
of
>>     request chaining for slightly better latency. However, the request
>>     chaining framework itself is unchanged, preserved from v5.
>>
>>
>> Changes since v4:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> 1) Rebased to mm-unstable as of 12-20-2024, commit 5555a83c82d6.
>> 2) Added acomp request chaining, as suggested by Herbert. Thanks Herbert!
>> 3) Implemented IAA compress batching using request chaining.
>> 4) zswap_store() batching simplifications suggested by Chengming, Yosry =
and
>>    Nhat, thanks to all!
>>    - New zswap_compress_folio() that is called by zswap_store().
>>    - Move the loop over folio's pages out of zswap_store() and into a
>>      zswap_store_folio() that stores all pages.
>>    - Allocate all zswap entries for the folio upfront.
>>    - Added zswap_batch_compress().
>>    - Branch to call zswap_compress() or zswap_batch_compress() inside
>>      zswap_compress_folio().
>>    - All iterations over pages kept in same function level.
>>    - No helpers other than the newly added zswap_store_folio() and
>>      zswap_compress_folio().
>>
>>
>> Changes since v3:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> 1) Rebased to mm-unstable as of 11-18-2024, commit 5a7056135bb6.
>> 2) Major re-write of iaa_crypto driver's mapping of IAA devices to cores,
>>    based on packages instead of NUMA nodes.
>> 3) Added acomp_has_async_batching() API to crypto acomp, that allows
>>    zswap/zram to query if a crypto_acomp has registered batch_compress a=
nd
>>    batch_decompress interfaces.
>> 4) Clear the poll bits on the acomp_reqs passed to
>>    iaa_comp_a[de]compress_batch() so that a module like zswap can be
>>    confident about the acomp_reqs[0] not having the poll bit set before
>>    calling the fully synchronous API crypto_acomp_[de]compress().
>>    Herbert, I would appreciate it if you can review changes 2-4; in patc=
hes
>>    1-8 in v4. I did not want to introduce too many iaa_crypto changes in
>>    v4, given that patch 7 is already making a major change. I plan to wo=
rk
>>    on incorporating the request chaining using the ahash interface in v5
>>    (I need to understand the basic crypto ahash better). Thanks Herbert!
>> 5) Incorporated Johannes' suggestion to not have a sysctl to enable
>>    compress batching.
>> 6) Incorporated Yosry's suggestion to allocate batching resources in the
>>    cpu hotplug onlining code, since there is no longer a sysctl to contr=
ol
>>    batching. Thanks Yosry!
>> 7) Incorporated Johannes' suggestions related to making the overall
>>    sequence of events between zswap_store() and zswap_batch_store() simi=
lar
>>    as much as possible for readability and control flow, better naming of
>>    procedures, avoiding forward declarations, not inlining error path
>>    procedures, deleting zswap internal details from zswap.h, etc. Thanks
>>    Johannes, really appreciate the direction!
>>    I have tried to explain the minimal future-proofing in terms of the
>>    zswap_batch_store() signature and the definition of "struct
>>    zswap_batch_store_sub_batch" in the comments for this struct. I hope =
the
>>    new code explains the control flow a bit better.
>>
>>
>> Changes since v2:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> 1) Rebased to mm-unstable as of 11-5-2024, commit 7994b7ea6ac8.
>> 2) Fixed an issue in zswap_create_acomp_ctx() with checking for NULL
>>    returned by kmalloc_node() for acomp_ctx->buffers and for
>>    acomp_ctx->reqs.
>> 3) Fixed a bug in zswap_pool_can_batch() for returning true if
>>    pool->can_batch_comp is found to be equal to BATCH_COMP_ENABLED, and =
if
>>    the per-cpu acomp_batch_ctx tests true for batching resources having
>>    been allocated on this cpu. Also, changed from per_cpu_ptr() to
>>    raw_cpu_ptr().
>> 4) Incorporated the zswap_store_propagate_errors() compilation warning f=
ix
>>    suggested by Dan Carpenter. Thanks Dan!
>> 5) Replaced the references to SWAP_CRYPTO_SUB_BATCH_SIZE in comments in
>>    zswap.h, with SWAP_CRYPTO_BATCH_SIZE.
>>
>> Changes since v1:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> 1) Rebased to mm-unstable as of 11-1-2024, commit 5c4cf96cd702.
>> 2) Incorporated Herbert's suggestions to use an acomp_req flag to indica=
te
>>    async/poll mode, and to encapsulate the polling functionality in the
>>    iaa_crypto driver. Thanks Herbert!
>> 3) Incorporated Herbert's and Yosry's suggestions to implement the batch=
ing
>>    API in iaa_crypto and to make its use seamless from zswap's
>>    perspective. Thanks Herbert and Yosry!
>> 4) Incorporated Yosry's suggestion to make it more convenient for the us=
er
>>    to enable compress batching, while minimizing the memory footprint
>>    cost. Thanks Yosry!
>> 5) Incorporated Yosry's suggestion to de-couple the shrink_folio_list()
>>    reclaim batching patch from this series, since it requires a broader
>>    discussion.
>>
>>
>> I would greatly appreciate code review comments for the iaa_crypto driver
>> and mm patches included in this series!
>>
>> Thanks,
>> Kanchana
>>
>>
>>
>>
>> Kanchana P Sridhar (24):
>>   crypto: iaa - Reorganize the iaa_crypto driver code.
>>   crypto: iaa - New architecture for IAA device WQ comp/decomp usage &
>>     core mapping.
>>   crypto: iaa - Simplify, consistency of function parameters, minor
>>     stats bug fix.
>>   crypto: iaa - Descriptor allocation timeouts with mitigations.
>>   crypto: iaa - iaa_wq uses percpu_refs for get/put reference counting.
>>   crypto: iaa - Simplify the code flow in iaa_compress() and
>>     iaa_decompress().
>>   crypto: iaa - Refactor hardware descriptor setup into separate
>>     procedures.
>>   crypto: iaa - Simplified, efficient job submissions for non-irq mode.
>>   crypto: iaa - Deprecate exporting add/remove IAA compression modes.
>>   crypto: iaa - Rearchitect the iaa_crypto driver to be usable by zswap
>>     and zram.
>>   crypto: iaa - Enablers for submitting descriptors then polling for
>>     completion.
>>   crypto: acomp - Add "void *kernel_data" in "struct acomp_req" for
>>     kernel users.
>>   crypto: iaa - IAA Batching for parallel compressions/decompressions.
>>   crypto: iaa - Enable async mode and make it the default.
>>   crypto: iaa - Disable iaa_verify_compress by default.
>>   crypto: iaa - Submit the two largest source buffers first in
>>     decompress batching.
>>   crypto: iaa - Add deflate-iaa-dynamic compression mode.
>>   crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's
>>     batch-size.
>>   crypto: iaa - IAA acomp_algs register the get_batch_size() interface.
>>   mm: zswap: Per-CPU acomp_ctx resources exist from pool creation to
>>     deletion.
>>   mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
>>     resources.
>>   mm: zswap: Allocate pool batching resources if the compressor supports
>>     batching.
>>   mm: zswap: zswap_store() will process a large folio in batches.
>>   mm: zswap: Batched zswap_compress() with compress batching of large
>>     folios.
>>
>>  .../driver-api/crypto/iaa/iaa-crypto.rst      |  168 +-
>>  crypto/acompress.c                            |    1 +
>>  crypto/testmgr.c                              |   10 +
>>  crypto/testmgr.h                              |   74 +
>>  drivers/crypto/intel/iaa/Makefile             |    4 +-
>>  drivers/crypto/intel/iaa/iaa_crypto.h         |   59 +-
>>  .../intel/iaa/iaa_crypto_comp_dynamic.c       |   22 +
>>  drivers/crypto/intel/iaa/iaa_crypto_main.c    | 2902 ++++++++++++-----
>>  drivers/crypto/intel/iaa/iaa_crypto_stats.c   |    8 +
>>  drivers/crypto/intel/iaa/iaa_crypto_stats.h   |    2 +
>>  include/crypto/acompress.h                    |   30 +
>>  include/crypto/internal/acompress.h           |    3 +
>>  include/linux/iaa_comp.h                      |  159 +
>>  mm/swap.h                                     |   23 +
>>  mm/zswap.c                                    |  646 ++--
>>  15 files changed, 3085 insertions(+), 1026 deletions(-)
>>  create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c
>>  create mode 100644 include/linux/iaa_comp.h
>>
>> --
>> 2.27.0
>>

--=20
Vinicius

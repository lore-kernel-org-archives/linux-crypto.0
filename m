Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FF84B1E72;
	Thu,  8 May 2025 20:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746737771; cv=none; b=fQgPWH5GuaM+Nw0hYZOhCNzbgO6SQeqEJmFfyqC08F72fKmh5gECQumkXbbbu3RUb7XPSaqTpFzcZPspYHRFPS2MyaJDs2f3hN0vh1QoehUlveenK7veVMlJzSeTy/dRLfqr9drBpGjkVjZ4NfVcqvG7H4L2MNvkvFmgCl5ezLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746737771; c=relaxed/simple;
	bh=T7m7nMcarFq6hXjpfNsy3oRQOHPWb8XWUtWHNNcoIm4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IdDvnzKpNDJxqJ71s5ls/mCuh275+tKnJLK/rV6AWHGU+aQUVTJHG2iQqQymdv1mLQ9hKsuBcDFYW0YJ2rt+NgzJ7Tt8H+KoS88SDqbZKMVxyKMF59pBlc4FJdawT7fq31u7UgnqPmp+M0Beka7TRfWnMew7LUnUp2jgsuO6XkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mFmG2XEp; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mFmG2XEp"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6f544014883so8437036d6.0;
        Thu, 08 May 2025 13:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746737768; x=1747342568; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/rknBHYyMwZXgkEdcTA6PAMOPT6317SmuhhwhFBwIHk=;
        b=mFmG2XEpKo2swJ3dD8b6ztJ+yXStERAmHHdqdEjnkrc/lFY3Eh57lHA7rRDW2cFFV1
         vx8vBJr51WlM7yDA3NiCaR2QgPWb1dIJ+2rkZXkIqsMGlHeqr5fpWFxAi54/x8i6v4lZ
         dt9W8EAKc1TJk8Yh5Fq+MdED3rv0kCeGbg2DDyR5VJQjiPSd26V25gRKBUmAOOyZemkk
         2omc9wHNLNmONXpYSfoNhi0M25fbFVoF9GwnypjPDszNTNjyw64axau8KYf6EGH1FHRo
         GsIBrxTFah+y9lJNYTNimk8UVmKGX+DwwEId3sxLaLHCFeS3APKse0RbIthH8+QdLGV4
         16oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746737768; x=1747342568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rknBHYyMwZXgkEdcTA6PAMOPT6317SmuhhwhFBwIHk=;
        b=ARITdD1ED0QtoG2cbpcnKgB4WjLavk61ubw3iT0Ci31PRPgACVf79xKFwIydk1ym9E
         D6iZCDAj2biR+bkAQteQlTb9j8NxD3ux/b7SOyGPPIMfFk18c10jbZd63ym/rrtSbkmW
         0Jp5nUfD53HAXVI/0m+6Cg9pgX52HdmpB2f4n1FDmBGB0VAKeSBBsr0F5vZI4i6u3xBE
         R37Sw1cmQAIu0UPj8kh9n6TE0syr8NRDKC793APyFS0jSIWtszLAuXVsWHghgTaQ+dSo
         riiDXUkkeO4XOSzJm4GvCf2qGpxrrAur7qDH1qHOvmlqzdl/XezjJqxVNU1+Lho6j+3h
         HnvA==
X-Forwarded-Encrypted: i=1; AJvYcCU/pbRqSCes/Hw03uI+3s8Hm4uILmw9SRPnvSJJbbA+ECWkC8PH/eqUdNQawYBZXKm6bOnO7ztVMsIq3ao=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCJppop1JI3sH8Gncg3yUf/+cAl3j7J8Sk6HdvsAa8KOnD8YGr
	LJcbk2TeGms0kbCWgYjpHVFEc75iGPKixfEzaaRta6mDrpFT5bL0aPY7VOA9Q0hPFivd6Nsmeyf
	ff6Br/u5+gzQiEhftT56MdtKH868=
X-Gm-Gg: ASbGncuvThSLlWNKCPsRe1eMVABo6EU3c5980aRvXcVuGuudGKWEmg77ICc3DQ4BmHb
	/e9DfpbiarXKc6dRJK/fM+P78iu4o+JEToK9LQQ4yxPngBVWPRCRwAyKZQuwxyncH77Sn015Zk2
	3vYXwwZR+YYrs/CJtQJ3Ko5ahUVy2LsugG0gQ4qQ==
X-Google-Smtp-Source: AGHT+IEUut4r8qk+QoSpo5F6koJZhSo462/W0bXDn/jbsfF7FjELmT9bzJgz688jgoabFl4i7UAmIKPSfNGYqtEzuT0=
X-Received: by 2002:a05:6214:ca3:b0:6e6:6089:4978 with SMTP id
 6a1803df08f44-6f6e47f4988mr10023816d6.24.1746737767477; Thu, 08 May 2025
 13:56:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250508194134.28392-1-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 8 May 2025 13:55:56 -0700
X-Gm-Features: AX0GCFs9DktCmmLz6TH3HIzr9hI_u2tQ0JvbT3-6P6RGfcfGo91QnjoDJQImwU8
Message-ID: <CAKEwX=NJm-9zodgb_UC2z+vshw98MmcqZDw_xvbQWaaU29eGMw@mail.gmail.com>
Subject: Re: [RESEND PATCH v9 00/19] zswap compression batching
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 12:41=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
>
> Compression Batching:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> This patch-series introduces batch compression of pages in large folios t=
o
> improve zswap swapout latency. It preserves the existing zswap protocols
> for non-batching software compressors by calling crypto_acomp sequentiall=
y
> per page in the batch. Additionally, in support of hardware accelerators
> that can process a batch as an integral unit, the patch-series creates
> generic batching interfaces in crypto_acomp, and calls the
> crypto_acomp_batch_compress() interface in zswap_compress() for compresso=
rs
> that intrinsically support batching.
>
> The patch series provides a proof point by using the Intel Analytics
> Accelerator (IAA) for implementing the compress/decompress batching API
> using hardware parallelism in the iaa_crypto driver and another proof poi=
nt
> with a sequential software compressor, zstd.

Any plan on doing hardware accelerated/offloaded/parallelized zstd? :)

>
> SUMMARY:
> =3D=3D=3D=3D=3D=3D=3D=3D
>
>   The first proof point is to test with IAA using a sequential call (full=
y
>   synchronous, compress one page at a time) vs. a batching call (fully
>   asynchronous, submit a batch to IAA for parallel compression, then poll=
 for
>   completion statuses).
>
>     The performance testing data with usemem 30 processes and kernel
>     compilation test using 32 threads, show 67%-77% throughput gains and
>     28%-32% sys time reduction (usemem30) and 2-3% sys time reduction
>     (kernel compilation) with zswap_store() large folios using IAA compre=
ss
>     batching as compared to IAA sequential.
>
>   The second proof point is to make sure that software algorithms such as
>   zstd do not regress. The data indicates that for sequential software
>   algorithms a performance gain is achieved.
>
>     With the performance optimizations implemented in patches 18 and 19 o=
f
>     v9, zstd usemem30 throughput increases by 1%, along with a 6%-8% sys =
time
>     reduction. With kernel compilation using zstd, we get a 0.4%-3.2%
>     reduction in sys time. These optimizations pertain to common code
>     paths, removing redundant branches/computes, using prefetchw() of the
>     zswap entry before it is written, and selectively annotating branches
>     with likely()/unlikely() compiler directives to minimize branch
>     mis-prediction penalty. Additionally, using the batching code for
>     non-batching compressors to sequentially compress/store batches of up
>     to ZSWAP_MAX_BATCH_SIZE (8) pages seems to help, most likely due to
>     cache locality of working set structures such as the array of
>     zswap_entry-s for the batch.

Nice!

>
>     Our internal validation of zstd with the batching interface vs. IAA w=
ith
>     the batching interface on Emerald Rapids has shown that IAA
>     compress/decompress batching gives 21.3% more memory savings as compa=
red
>     to zstd, for 5% performance loss as compared to the baseline without =
any
>     memory pressure. IAA batching demonstrates more than 2X the memory
>     savings obtained by zstd at this 95% performance KPI.
>     The compression ratio with IAA is 2.23, and with zstd 2.96. Even with
>     this compression ratio deficit for IAA, batching is extremely

I'm confused. How does IAA give more memory savings, while having a
worse compression ratio? How do you define memory savings here?

>     beneficial. As we improve the compression ratio of the IAA accelerato=
r,
>     we expect to see even better memory savings with IAA as compared to
>     software compressors.
>
>
>   Batching Roadmap:
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>   1) Compression batching within large folios (this series).
>
>   2) Reclaim batching of hybrid folios:
>
>      We can expect to see even more significant performance and throughpu=
t
>      improvements if we use the parallelism offered by IAA to do reclaim
>      batching of 4K/large folios (really any-order folios), and using the
>      zswap_store() high throughput compression pipeline to batch-compress
>      pages comprising these folios, not just batching within large
>      folios. This is the reclaim batching patch 13 in v1, which we expect
>      to submit in a separate patch-series.

Are you aware of the current kcompressd work:

https://lore.kernel.org/all/20250430082651.3152444-1-qun-wei.lin@mediatek.c=
om/

It basically offloads compression work into a separate kernel thread
(kcompressd), for kswapd reclaim.

This might provide you with a more natural place to perform batch
compression - instead of compressing one page at a time from the
worker thread's queue, you can grab a batch worth of pages and feed it
to IAA.

Downside is it only applies to indirect reclaim. Proactive and direct
reclaimers are not covered, unfortunately.

>
>   3) Decompression batching:
>
>      We have developed a zswap load batching interface for IAA to be used
>      for parallel decompression batching, using swapin_readahead().
>
>   These capabilities are architected so as to be useful to zswap and
>   zram. We are actively working on integrating these components with zram=
.

Yeah problem with readahead is you can potentially get different
backends in the batch, and modifying readahead code is pretty ugly :)
But we'll see...

>
>   v9 Performance Summary:
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>   This is a performance testing summary of results with usemem30
>   (30 usemem processes running in a cgroup limited at 150G, each trying t=
o
>   allocate 10G).
>
>   usemem30 with 64K folios:
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>
>      --------------------------------------------------------------------=
---
>                     mm-unstable-4-21-2025              v9
>      --------------------------------------------------------------------=
---
>      zswap compressor         deflate-iaa     deflate-iaa    IAA Batching
>                                                                  vs.
>                                                              IAA Sequenti=
al
>      --------------------------------------------------------------------=
---
>      Total throughput (KB/s)    6,091,607      10,174,344         67%
>      Avg throughput (KB/s)        203,053         339,144
>      elapsed time (sec)            100.46           69.70        -31%
>      sys time (sec)              2,416.97        1,648.37        -32%
>      --------------------------------------------------------------------=
---
>
>      --------------------------------------------------------------------=
---
>                     mm-unstable-4-21-2025              v9
>      --------------------------------------------------------------------=
---
>      zswap compressor                zstd            zstd    v9 zstd
>                                                              improvement
>      --------------------------------------------------------------------=
---
>      Total throughput (KB/s)    6,574,380       6,632,230          1%
>      Avg throughput (KB/s)        219,146         221,074
>      elapsed time (sec)             96.58           90.60         -6%
>      sys time (sec)              2,416.52        2,224.78         -8%
>      --------------------------------------------------------------------=
---
>
>   usemem30 with 2M folios:
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>
>      --------------------------------------------------------------------=
--
>                      mm-unstable-4-21-2025             v9
>      --------------------------------------------------------------------=
--
>      zswap compressor          deflate-iaa    deflate-iaa    IAA Batching
>                                                                  vs.
>                                                              IAA Sequenti=
al
>      --------------------------------------------------------------------=
--
>      Total throughput (KB/s)     6,371,048     11,282,935         77%
>      Avg throughput (KB/s)         212,368        376,097
>      elapsed time (sec)              87.15          63.04        -28%
>      sys time (sec)               2,011.56       1,450.45        -28%
>      --------------------------------------------------------------------=
--
>
>      --------------------------------------------------------------------=
--
>                      mm-unstable-4-21-2025             v9
>      --------------------------------------------------------------------=
--
>      zswap compressor                 zstd           zstd    v9 zstd
>                                                              improvement
>      --------------------------------------------------------------------=
--
>      Total throughput (KB/s)     7,320,278      7,428,055          1%
>      Avg throughput (KB/s)         244,009        247,601
>      elapsed time (sec)              83.30          81.60         -2%
>      sys time (sec)               1,970.89       1,857.70         -6%
>      --------------------------------------------------------------------=
--

Oh nice, looks like with batching, IAA is now better than zstd? :)

>
>
>
> DETAILS:
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> (A) From zswap's perspective, the most significant changes are:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> 1) A unified zswap_compress() API is added to compress multiple
>    pages:
>
>    - If the compressor has multiple acomp requests, i.e., internally
>      supports batching, crypto_acomp_batch_compress() is called. If all
>      pages are successfully compressed, the batch is stored in zpool.
>
>    - If the compressor can only compress one page at a time, each page
>      is compressed and stored sequentially.
>
>    Many thanks to Yosry for this suggestion, because it is an essential
>    component of unifying common code paths between sequential/batching
>    compressions.
>
>    prefetchw() is used in zswap_compress() to minimize cache-miss
>    latency by moving the zswap entry to the cache before it is written
>    to; reducing sys time by ~1.5% for zstd (non-batching software
>    compression). In other words, this optimization helps both batching an=
d
>    software compressors.
>
>    Overall, the prefetchw() and likely()/unlikely() annotations prevent
>    regressions with software compressors like zstd, and generally improve
>    non-batching compressors' performance with the batching code by ~8%.
>
> 2) A new zswap_store_pages() is added, that stores multiple pages in a
>    folio in a range of indices. This is an extension of the earlier
>    zswap_store_page(), except it operates on a batch of pages.
>
> 3) zswap_store() is modified to store the folio's pages in batches
>    by calling zswap_store_pages(). If the compressor supports batching,
>    i.e., has multiple acomp requests, the folio will be compressed in
>    batches of "pool->nr_reqs". If the compressor has only one acomp
>    request, the folio will be compressed in batches of
>    ZSWAP_MAX_BATCH_SIZE pages, where each page in the batch is
>    compressed sequentially. We see better performance by processing
>    the folio in batches of ZSWAP_MAX_BATCH_SIZE, due to cache locality
>    of working set structures such as the array of zswap_entry-s for the
>    batch.
>
>    Many thanks to Yosry and Johannes for steering towards a common
>    design and code paths for sequential and batched compressions (i.e.,
>    for software compressors and hardware accelerators such as IAA). As pe=
r
>    Yosry's suggestion in v8, the nr_reqs is an attribute of the
>    compressor/pool, and hence is stored in struct zswap_pool instead of i=
n
>    struct crypto_acomp_ctx.
>
> 4) Simplifications to the acomp_ctx resources allocation/deletion
>    vis-a-vis CPU hot[un]plug. This further improves upon v8 of this
>    patch-series based on the discussion with Yosry, and formalizes the
>    lifetime of these resources from pool creation to pool
>    deletion. zswap does not register a CPU hotplug teardown
>    callback. The acomp_ctx resources will persist through CPU
>    online/offline transitions. The main changes made to avoid UAF/race
>    conditions, and correctly handle process migration, are:
>
>    a) No acomp_ctx mutex locking in zswap_cpu_comp_prepare().
>    b) No CPU hotplug teardown callback, no acomp_ctx resources deleted.
>    c) New acomp_ctx_dealloc() procedure that cleans up the acomp_ctx
>       resources, and is shared by zswap_cpu_comp_prepare() error
>       handling and zswap_pool_destroy().
>    d) The zswap_pool node list instance is removed right after the node
>       list add function in zswap_pool_create().
>    e) We directly call mutex_[un]lock(&acomp_ctx->mutex) in
>       zswap_[de]compress(). acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock=
()
>       are deleted.
>
>    The commit log of patch 0015 has a more detailed analysis.
>
>
> (B) Main changes in crypto_acomp and iaa_crypto:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> 1) A new architecture is introduced for IAA device WQs' usage as:
>    - compress only
>    - decompress only
>    - generic, i.e., both compress/decompress.
>
>    Further, IAA devices/wqs are assigned to cores based on packages
>    instead of NUMA nodes.
>
>    The WQ rebalancing algorithm that is invoked as WQs are
>    discovered/deleted has been made very general and flexible so that
>    the user can control exactly how IAA WQs are used. In addition to the
>    user being able to specify a WQ type as comp/decomp/generic, the user
>    can also configure if WQs need to be shared among all same-package
>    cores, or, whether the cores should be divided up amongst the
>    available IAA devices.
>
>    If distribute_[de]comps is enabled, from a given core's perspective,
>    the iaa_crypto driver will distribute comp/decomp jobs among all
>    devices' WQs in round-robin manner. This improves batching latency
>    and can improve compression/decompression throughput for workloads
>    that see a lot of swap activity.
>
>    The commit log of patch 0006 provides more details on new iaa_crypto
>    driver parameters added, along with recommended settings.
>
> 2) Compress/decompress batching are implemented using
>    crypto_acomp_batch_[de]compress(), along the lines of v6 since
>    request chaining is no longer the recommended approach.
>
>
> (C) The patch-series is organized as follows:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  1) crypto acomp & iaa_crypto driver enablers for batching: Relevant
>     patches are tagged with "crypto:" in the subject:
>
>     Patches 1-4) Backport some of the crypto patches that revert request
>                  chaining that are in the cryptodev-2.6 git tree and are
>                  yet to be included in mm-unstable. I have also
>                  backported the fix to the scomp off-by-one bug. Further,=
 the
>                  non-request-chaining implementations of
>                  crypto_acomp_[de]compress() are reinstated. Without
>                  patches 1/2/3, the crypto/testmgr issues errors that
>                  prevent deflate-iaa from being used as zswap's
>                  compressor. Once mm-unstable is updated with the
>                  request chaining reverts, patches 1/3/4 can be deleted
>                  from this patch-series.
>
>     Patch 5) Reorganizes the iaa_crypto driver code into logically relate=
d
>              sections and avoids forward declarations, in order to facili=
tate
>              subsequent iaa_crypto patches. This patch makes no
>              functional changes.
>
>     Patch 6) Makes an infrastructure change in the iaa_crypto driver
>              to map IAA devices/work-queues to cores based on packages
>              instead of NUMA nodes. This doesn't impact performance on
>              the Sapphire Rapids system used for performance
>              testing. However, this change fixes functional problems we
>              found on Granite Rapids during internal validation, where th=
e
>              number of NUMA nodes is greater than the number of packages,
>              which was resulting in over-utilization of some IAA devices
>              and non-usage of other IAA devices as per the current NUMA
>              based mapping infrastructure.
>
>              This patch also develops a new architecture that
>              generalizes how IAA device WQs are used. It enables
>              designating IAA device WQs as either compress-only or
>              decompress-only or generic. Once IAA device WQ types are
>              thus defined, it also allows the configuration of whether
>              device WQs will be shared by all cores on the package, or
>              used only by "mapped cores" obtained by a simple allocation
>              of available IAAs to cores on the package.
>
>              As a result of the overhaul of wq_table definition,
>              allocation and rebalancing, this patch eliminates
>              duplication of device WQs in per-cpu wq_tables, thereby
>              saving 140MiB on a 384 cores dual socket Granite Rapids serv=
er
>              with 8 IAAs.
>
>              Regardless of how the user has configured the WQs' usage,
>              the next WQ to use is obtained through a direct look-up in
>              per-cpu "cpu_comp_wqs" and "cpu_decomp_wqs" structures so
>              as to minimize latency in the critical path driver compress
>              and decompress routines.
>
>     Patch 7) Defines a "void *data" in struct acomp_req, in response to
>              Herbert's comments in v8 about avoiding use of
>              req->base.data. iaa_crypto requires the req->data to
>              store the idxd_desc allocated in the core
>              iaa_[de]compress() functions, for later retreival in the
>              iaa_comp_poll() function to check for the descriptor's
>              completion status. This async submit-poll is essential for
>              batching.
>
>     Patch 8) Makes a change to iaa_crypto driver's descriptor allocation,
>              from blocking to non-blocking with retries/timeouts and
>              mitigations in case of timeouts during compress/decompress
>              ops. This prevents tasks getting blocked indefinitely, which
>              was observed when testing 30 cores running workloads, with
>              only 1 IAA enabled on Sapphire Rapids (out of 4). These
>              timeouts are typically only encountered, and associated
>              mitigations exercised, only in configurations with 1 IAA
>              device shared by 30+ cores.
>
>     Patch 9) New CRYPTO_ACOMP_REQ_POLL acomp_req flag to act as a gate fo=
r
>              async poll mode in iaa_crypto.
>
>    Patch 10) Adds acomp_alg/crypto_acomp interfaces for get_batch_size(),
>              batch_compress() and batch_decompress() along with the
>              corresponding crypto_acomp_batch_size(),
>              crypto_acomp_batch_compress() and
>              crypto_acomp_batch_decompress() API for use in zswap.
>
>    Patch 11) iaa-crypto driver implementations for the newly added batchi=
ng
>              interfaces. iaa_crypto implements the crypto_acomp
>              get_batch_size() interface that returns an iaa_driver specif=
ic
>              constant, IAA_CRYPTO_MAX_BATCH_SIZE (set to 8U currently).
>
>              This patch also provides the iaa_crypto driver implementatio=
ns
>              for the batch_compress() and batch_decompress() crypto_acomp
>              interfaces.
>
>    Patch 12) Modifies the default iaa_crypto driver mode to async, now th=
at
>              iaa_crypto provides a truly async mode that gives
>              significantly better latency than sync mode for the batching
>              use case.
>
>    Patch 13) Disables verify_compress by default, to facilitate users to
>              run IAA easily for comparison with software compressors.
>
>
>  2) zswap modifications to enable compress batching in zswap_store()
>     of large folios (including pmd-mappable folios):
>
>    Patch 14) Moves the zswap CPU hotplug procedures under "pool functions=
",
>              because they are invoked upon pool creation/deletion.
>
>    Patch 15) Simplifies the zswap_pool's per-CPU acomp_ctx resource
>              management and lifetime to be from pool creation to pool
>              deletion.
>
>    Patch 16) Uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check f=
or
>              valid acomp/req, thereby making it consistent with the resou=
rce
>              de-allocation code.
>
>    Patch 17) Defines a zswap-specific ZSWAP_MAX_BATCH_SIZE (currently set
>              as 8U) to denote the maximum number of acomp_ctx batching
>              resources to allocate, thus limiting the amount of extra
>              memory used for batching. Further, the "struct
>              crypto_acomp_ctx" is modified to contain multiple acomp_reqs
>              and buffers. A new "u8 nr_reqs" member is added to "struct
>              zswap_pool" to track the number of requests/buffers associat=
ed
>              with the compressor.
>
>    Patch 18) Modifies zswap_store() to store the folio in batches of
>              pool->nr_reqs by calling a new zswap_store_pages() that take=
s
>              a range of indices in the folio to be stored.
>              zswap_store_pages() pre-allocates zswap entries for the batc=
h,
>              calls zswap_compress() for each page in this range, and stor=
es
>              the entries in xarray/LRU.
>
>    Patch 19) Introduces a new unified implementation of zswap_compress()
>              for compressors that do and do not support batching. This
>              eliminates code duplication and facilitates maintainability =
of
>              the code with the introduction of compress batching. Further=
,
>              there are many optimizations to this common code that result
>              in workload throughput and performance improvements with
>              software compressors and hardware accelerators such as IAA.
>
>              zstd performance is better or on par with mm-unstable. We
>              see impressive throughput/performance improvements with IAA
>              batching vs. no-batching.
>
>
> With v9 of this patch series, the IAA compress batching feature will be
> enabled seamlessly on Intel platforms that have IAA by selecting
> 'deflate-iaa' as the zswap compressor, and using the iaa_crypto 'async'
> sync_mode driver attribute (the default).
>
>
> System setup for testing:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> Testing of this patch-series was done with mm-unstable as of 4-21-2025,
> commit 2c01d9f3c611, without and with this patch-series. Data was
> gathered on an Intel Sapphire Rapids (SPR) server, dual-socket 56 cores
> per socket, 4 IAA devices per socket, 503 GiB RAM and 525G SSD disk
> partition swap. Core frequency was fixed at 2500MHz.
>
> Other kernel configuration parameters:
>
>     zswap compressor  : zstd, deflate-iaa
>     zswap allocator   : zsmalloc
>     vm.page-cluster   : 0
>
> IAA "compression verification" is disabled and IAA is run in the async
> mode (the defaults with this series).
>
> I ran experiments with these workloads:
>
> 1) usemem 30 processes with these large folios enabled to "always":
>    - 64k
>    - 2048k
>
>    IAA WQ Configuration:
>
>    Since usemem sees practically no swapin activity, we set up 1 WQ per
>    IAA device, so that all 128 entries are available for compress
>    jobs. All IAA's WQs are available to all package cores to send
>    compress/decompress jobs in a round-robin manner.
>
>      4 IAA devices
>      1 WQ per device
>      echo 0 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa
>      echo 1 > /sys/bus/dsa/drivers/crypto/distribute_comps
>      echo 1 > /sys/bus/dsa/drivers/crypto/distribute_decomps
>
> 2) Kernel compilation allmodconfig with 2G max memory, 32 threads, with
>    these large folios enabled to "always":
>    - 64k
>
>    IAA WQ Configuration:
>
>    Since kernel compilation sees considerable swapin activity, we set up
>    2 WQs per IAA device, each containing 64 entries. The driver sends
>    decompresses to wqX.0 and compresses to wqX.1. All IAAs' wqX.0 are
>    available to all package cores to send decompress jobs in a
>    round-robin manner. Likewise, all IAAs' wqX.1 are available to all
>    package cores to send decompress jobs in a round-robin manner.
>
>      4 IAA devices
>      2 WQs per device
>      echo 1 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa
>      echo 1 > /sys/bus/dsa/drivers/crypto/distribute_comps
>      echo 1 > /sys/bus/dsa/drivers/crypto/distribute_decomps
>
>
> Performance testing (usemem30):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> The vm-scalability "usemem" test was run in a cgroup whose memory.high
> was fixed at 150G. The is no swap limit set for the cgroup. 30 usemem
> processes were run, each allocating and writing 10G of memory, and sleepi=
ng
> for 10 sec before exiting:
>
> usemem --init-time -w -O -b 1 -s 10 -n 30 10g
>
>
>  64K folios: usemem30: deflate-iaa:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  ------------------------------------------------------------------------=
-------
>                  mm-unstable-4-21-2025             v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor         deflate-iaa     deflate-iaa    IAA Batching
>                                                              vs.
>                                                          IAA Sequential
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)    6,091,607      10,174,344         67%
>  Avg throughput (KB/s)        203,053         339,144
>  elapsed time (sec)            100.46           69.70        -31%
>  sys time (sec)              2,416.97        1,648.37        -32%
>
>  ------------------------------------------------------------------------=
-------
>  memcg_high                 1,262,996       1,403,680
>  memcg_swap_fail                2,712           2,105
>  zswpout                   58,146,954      64,508,450
>  zswpin                            91             256
>  pswpout                            0               0
>  pswpin                             0               0
>  thp_swpout                         0               0
>  thp_swpout_fallback                0               0
>  64kB_swpout_fallback           2,712           2,105
>  pgmajfault                     2,858           3,032
>  ZSWPOUT-64kB               3,631,559       4,029,802
>  SWPOUT-64kB                        0               0
>  ------------------------------------------------------------------------=
-------
>
>
>  2M folios: usemem30: deflate-iaa:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  ------------------------------------------------------------------------=
-------
>                  mm-unstable-4-21-2025              v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor          deflate-iaa     deflate-iaa     IAA Batching
>                                                                vs.
>                                                            IAA Sequential
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)     6,371,048      11,282,935       77%
>  Avg throughput (KB/s)         212,368         376,097
>  elapsed time (sec)              87.15           63.04      -28%
>  sys time (sec)               2,011.56        1,450.45      -28%
>
>  ------------------------------------------------------------------------=
-------
>  memcg_high                    116,156         125,138
>  memcg_swap_fail                   348             248
>  zswpout                    59,815,486      64,509,928
>  zswpin                            442             422
>  pswpout                             0               0
>  pswpin                              0               0
>  thp_swpout                          0               0
>  thp_swpout_fallback               348             248
>  pgmajfault                      3,575           3,272
>  ZSWPOUT-2048kB                116,480         125,759
>  SWPOUT-2048kB                       0               0
>  ------------------------------------------------------------------------=
-------
>
>
>  64K folios: usemem30: zstd:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>
>  ------------------------------------------------------------------------=
-------
>                mm-unstable-4-21-2025            v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor               zstd          zstd       v9 zstd
>                                                          improvement
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)   6,574,380     6,632,230        1%
>  Avg throughput (KB/s)       219,146       221,074
>  elapsed time (sec)            96.58         90.60       -6%
>  sys time (sec)             2,416.52      2,224.78       -8%
>
>  ------------------------------------------------------------------------=
-------
>  memcg_high                1,117,577     1,110,504
>  memcg_swap_fail                  65         2,217
>  zswpout                  48,771,672    48,806,988
>  zswpin                          137           429
>  pswpout                           0             0
>  pswpin                            0             0
>  thp_swpout                        0             0
>  thp_swpout_fallback               0             0
>  64kB_swpout_fallback             65         2,217
>  pgmajfault                    3,286         3,224
>  ZSWPOUT-64kB              3,048,122     3,048,198
>  SWPOUT-64kB                       0             0
>  ------------------------------------------------------------------------=
-------
>
>
>  2M folios: usemem30: zstd:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>
>  ------------------------------------------------------------------------=
-------
>                mm-unstable-4-21-2025            v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor               zstd          zstd      v9 zstd
>                                                         improvement
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)   7,320,278     7,428,055       1%
>  Avg throughput (KB/s)       244,009       247,601
>  elapsed time (sec)            83.30         81.60      -2%
>  sys time (sec)             1,970.89      1,857.70      -6%
>
>  ------------------------------------------------------------------------=
-------
>  memcg_high                   92,970        92,708
>  memcg_swap_fail                  59           172
>  zswpout                  48,043,615    47,896,223
>  zswpin                           77           416
>  pswpout                           0             0
>  pswpin                            0             0
>  thp_swpout                        0             0
>  thp_swpout_fallback              59           172
>  pgmajfault                    2,815         3,170
>  ZSWPOUT-2048kB               93,776        93,381
>  SWPOUT-2048kB                     0             0
>  ------------------------------------------------------------------------=
-------
>
>
>
> Performance testing (Kernel compilation, allmodconfig):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>
> The experiments with kernel compilation test use 32 threads and build
> the "allmodconfig" that takes ~14 minutes, and has considerable
> swapout/swapin activity. The cgroup's memory.max is set to 2G.
>
>
>  64K folios: Kernel compilation/allmodconfig:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  ------------------------------------------------------------------------=
-------
>                        mm-unstable               v9    mm-unstable       =
     v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor      deflate-iaa      deflate-iaa           zstd       =
   zstd
>  ------------------------------------------------------------------------=
-------
>  real_sec                   835.31           837.75         858.73       =
 852.22
>  user_sec                15,649.58        15,660.48      15,682.66     15=
,649.91
>  sys_sec                  3,705.03         3,642.59       4,858.46      4=
,703.58
>  ------------------------------------------------------------------------=
-------
>  Max_Res_Set_Size_KB     1,874,524        1,872,200      1,871,248     1,=
870,972
>  ------------------------------------------------------------------------=
-------
>  memcg_high                      0                0              0       =
      0
>  memcg_swap_fail                 0                0              0       =
      0
>  zswpout                89,767,776       91,376,740     76,444,847    73,=
771,346
>  zswpin                 26,362,204       27,700,717     22,138,662    21,=
287,433
>  pswpout                       360              574             52       =
    154
>  pswpin                        275              551             19       =
     63
>  thp_swpout                      0                0              0       =
      0
>  thp_swpout_fallback             0                0              0       =
      0
>  64kB_swpout_fallback            0            1,523              0       =
      0
>  pgmajfault             27,938,009       29,559,339     23,339,818    22,=
458,108
>  ZSWPOUT-64kB            2,958,806        2,992,126      2,444,259     2,=
382,986
>  SWPOUT-64kB                    21               30              3       =
      8
>  ------------------------------------------------------------------------=
-------
>
>
>  2M folios: Kernel compilation/allmodconfig:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  ------------------------------------------------------------------------=
-------
>                        mm-unstable               v9    mm-unstable       =
     v9
>  ------------------------------------------------------------------------=
-------
>  zswap compressor      deflate-iaa      deflate-iaa           zstd       =
   zstd
>  ------------------------------------------------------------------------=
-------
>  real_sec                   790.66           789.01         818.46       =
 819.08
>  user_sec                15,757.60        15,759.57      15,785.34     15=
,777.70
>  sys_sec                  4,307.92         4,184.09       5,602.95      5=
,582.45
>  ------------------------------------------------------------------------=
-------
>  Max_Res_Set_Size_KB     1,871,100        1,872,892      1,872,892     1,=
872,888
>  ------------------------------------------------------------------------=
-------
>  memcg_high                      0                0              0       =
      0
>  memcg_swap_fail                 0                0              0       =
      0
>  zswpout               107,349,845      101,481,140     90,083,661    90,=
818,923
>  zswpin                 37,486,883       35,081,184     29,823,462    29,=
597,292

That's interesting. Looks like zstd sees lower zswap activities,
indicating it is indeed more efficient at freeing up memory to resolve
memory pressure, thanks to its better compression ratio. And yet, IAA
still wins in real time, which I assume is thanks to:

1. Latency: IAA is probably quite a bit faster than zstd.

2. Asynchrony: please correct me if I'm wrong, but looks like zstd is
synchronous, whereas IAA is asynchronous, so we will release the core
while waiting for the compression result? In that case, the
aforementioned kcompressd might close the gap a bit (although I have
not seen huge difference in performance in kernel building test,
specifically).

It'd be nice if we can do a hardware offloaded + parallelized zstd to
get the best of both worlds :)


>  pswpout                     3,664            1,191          1,066       =
  1,617
>  pswpin                      1,594              138             37       =
  1,594
>  thp_swpout                      7                2              2       =
      3
>  thp_swpout_fallback         9,434            8,100          6,354       =
  5,809
>  pgmajfault             38,781,821       36,235,171     30,677,937    30,=
442,685
>  ZSWPOUT-2048kB              8,810            7,772          7,857       =
  8,515
>  ------------------------------------------------------------------------=
-------
>
>
> With the iaa_crypto driver changes for non-blocking descriptor allocation=
s,
> no timeouts-with-mitigations were seen in compress/decompress jobs, for a=
ll
> of the above experiments.
>
>
>

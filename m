Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008E821D5AE;
	Fri,  4 Jul 2025 18:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751654247; cv=none; b=bZX79nTCefT/Gfj9bZ+cmYZOZ6FZPujGMp4D/QcoRRTGz0A+f/ft/adyB4I6hLkKMXLR/xrsQ9MrNIG6OJ4Otw0dg+YsjB1+Fl5PpDGu5wrBw0+A77xilc5hKBecu5dmxS5MaJI/6nqo6x/FoSGAhXAAbBe69pAhR3YoSqbF8ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751654247; c=relaxed/simple;
	bh=5upg5gDpG0FLEklzRWHxra9PEkERb9PbXtlUoMgNE0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CG/Y3Jfcy3nJ2fmj/hKgDS8ABIoJMI7rJZzGkG9Yjs14DK0h2cFhFcp3qtvXEnZacc8gsp8jzAHxCj4g5KWO31CQ5MrQrO55Czc6FU8og5vZ8HxVqMlqYWxMgZFIbaNBDrPzlZCiCk6kV26HecmD9yyrrqH09bPkqhtLvdV/cxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bphaHcOT; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bphaHcOT"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6fd1b2a57a0so12813766d6.1;
        Fri, 04 Jul 2025 11:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751654243; x=1752259043; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXc+k3362cKUhNUT9l1sMgFc/0THtPpG07SZbcv3dn4=;
        b=bphaHcOT9FsuBM2nz2RBvmODAF8dwXR2mOJTGHhcnXdRK7Cc9FmjagichSbNWSYlKw
         q14vh6e/XZY3LqlTkKSn1rgfK0K4vyC9RcDb1I0URuw3z0i+zCBIVlVZfosWKrTUyJBA
         nnVyEcxVg6+vd+ujQfXhgZDdB2+Ss368H1IzcCsvtUXSA18JHDa05/otx6KK8HBx1974
         din9cs0SuF/QE6lcUVbS7gZ71Yxiqj9K27GO069Bz7BFv/Xj4IaHU2ZSTqLApTCKbr2D
         vgI6wQH2JL4gujfkEPgsjG0EmXrTCY9Lio9Ye0cDb4Up+5qI90y3jDYUzeWmcgY1F4+K
         dZnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751654243; x=1752259043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DXc+k3362cKUhNUT9l1sMgFc/0THtPpG07SZbcv3dn4=;
        b=M0ob8PMWZMIMdtjtQwlhLzRwtC53OWxCubuGpIF8VqTkPwQhFOgFMfyLNOlm6iHhkf
         O8XCApXefvPSr0n3WzO570f00WUxQXwoxffE8NxFPXSA/y9IdPdCdhS3+0gWOQyiFjTa
         2u3RVJs3BZzGV56i9SJ1AbCQIAyI9rpbpjXWvsPQim4MYgyrP73rdgIM3oYzGq+FBuPk
         IR1niGBsRyIA6YTFAyVCgjyUDmuR+mwFyB6bEvMW6X4zFdpzIdkUwWQykUQo1eGkxEnn
         GlS7SjaOVrAlTx4jVizYwZBqyaAsyv1GpXuIHWCXjQrxlbiA5C7x+arDtjaIdXmTQ4vm
         UVFA==
X-Forwarded-Encrypted: i=1; AJvYcCUVedkVWFTs6Jwo/6rOu4rl+hvlgjxpfBdFWLi+JxoF1SVblwh2VSa+qfE9S9as6jmA3fLuxzEMCZubS5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkoQNkbsB/dpadmZ+YO66bg49wx1DDJKEboM6rE1+DmVum6GZF
	T154/5hL4oOdnd5gkvPl5qUjfBr+IDaDV58e6vsEzluqBjRX05BNDuB4EIx6NBHG2I1WzhQTqh0
	1oMu0lS3g306PhVCbaCJHxBTLhw5ll3o=
X-Gm-Gg: ASbGncs03CgWw3/W0Niw9pamiBzI0iMuzLcmkAh+FOMTgdOgFUkvG8tewuC5zM5Ohkx
	pTuAWoOlGRFMT6FA8KzMCLkPiTnkjbSBoV1LwrtT6W73Xj7HPkZubIPGe6UwA9y1gWotuIDtWRk
	11K3rz6Js4iYRTDQDAsKABXEk9gsaI8lmrH4zgA9xi4SQ=
X-Google-Smtp-Source: AGHT+IH35Xb0nZyKlldtt1kqhAK8fccBc3HoBirQxuq5j7DiAQ7sIII7FW6fVnbcQNw1CxUo95J8iyAwt3cEjVx46/I=
X-Received: by 2002:a05:6214:76a:b0:6fa:b9e9:e799 with SMTP id
 6a1803df08f44-702c6db728cmr46661636d6.24.1751654241813; Fri, 04 Jul 2025
 11:37:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250704042323.10318-1-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250704042323.10318-1-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 4 Jul 2025 11:37:10 -0700
X-Gm-Features: Ac12FXyctdMFDmQDmg5aEF5PfgKVs0nhYrCnp_9hfCbPGLt-1rrlP4_PDQy70Uw
Message-ID: <CAKEwX=N6ngz4aYtVs4FDtK6fQOZaiMGvgH-PeZCZdeOTONxTKA@mail.gmail.com>
Subject: Re: [PATCH v10 00/25] zswap compression batching with optimized
 iaa_crypto driver
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

On Thu, Jul 3, 2025 at 9:23=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> v10: zswap compression batching with optimized iaa_crypto driver
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Can you include test setup instructions on this patch series cover
letter? I was having a lot of trouble trying to set up the system to
reproduce the results in the past. I think the default setup
compresses data very poorly - there were lots of compression failure
reported by zswap...

>
> iaa_crypto Driver Rearchitecting and Optimizations:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>
> The most significant highlight of v10 is a new, lightweight and highly
> optimized iaa_crypto driver, resulting directly in the latency and
> throughput improvements noted later in this cover letter.
>
>  1) Better stability, more functionally versatile to support zswap and
>     zram with better performance on different Intel platforms.
>
>     a) Patches 0002, 0005 and 0010 together resolve a race condition in
>        mainline v6.15, reported from internal validation, when IAA
>        wqs/devices are disabled while workloads are using IAA.
>
>     b) Patch 0002 introduces a new architecture for mapping cores to
>        IAAs based on packages instead of NUMA nodes, and generalizing
>        how WQs are used: as package level resources for all cores, or
>        dedicated to mapped cores. Further, users are able to configure
>        multiple WQs and specify how many of those are for compress jobs
>        only vs. decompress jobs only. By default, WQs for compress jobs
>        are shared among all same-package cores. sysfs iaa_crypto driver
>        parameters can be used to change the default settings for
>        performance tuning.
>
>     c) idxd descriptor allocation moved from blocking to non-blocking
>        with retry limits and mitigations if limits are exceeded.
>
>     d) Code cleanup for readability and clearer code flow.
>
>     e) Fixes IAA re-registration errors upon disabling/enabling IAA wqs
>        and devices that exists in the mainline v6.15.
>
>     f) Rearchitecting iaa_crypto to be independent of crypto_acomp to
>        enable a zram/zcomp backend_deflate_iaa.c, while fully supporting
>        the crypto_acomp interfaces for zswap. A new
>        include/linux/iaa_comp.h is added.
>
>     g) New Dynamic compression mode for Granite Rapids to get better
>        compression ratio by echo-ing 'deflate-iaa-dynamic' as the zswap
>        compressor.
>
>     h) New crypto_acomp API crypto_acomp_batch_size() that will return
>        the driver's max batch size if the driver has registered the new
>        get_batch_size() acomp_alg interface; or 1 if there is no driver
>        specific implementation of get_batch_size().
>
>        Accordingly, iaa_crypto provides an implementation for
>        get_batch_size().
>
>     i) A versatile set of interfaces independent of crypto_acomp for use
>        in developing a zram zcomp backend for iaa_crypto.
>
>  2) Performance optimizations (please refer to the latency data per
>     optimization in the commit logs):
>
>     a) Distributing [de]compress jobs in round-robin manner to available
>        IAAs on package.
>
>     b) Replacing the compute-intensive iaa_wq_get()/iaa_wq_put() with a
>        percpu_ref in struct iaa_wq, thereby eliminating acquiring a
>        spinlock in the fast path, while using a combination of the
>        iaa_crypto_enabled atomic with spinlocks in the slow path to
>        ensure the compress/decompress code sees a consistent state of the
>        wq tables.
>
>     c) Directly call movdir64b for non-irq use cases, i.e., the most
>        common usage. Avoid the overhead of irq-specific computes in
>        idxd_submit_desc() to gain latency.
>
>     d) Batching of compressions/decompressions using async submit-poll
>        mechanism to derive the benefits of hardware parallelism.
>
>     e) Batching compressors need to manage their own "request"
>        abstraction, and remove this driver-specific aspect from being
>        managed by kernel users such as zswap. iaa_crypto maintains
>        per-CPU "struct iaa_req **reqs" to submit multiple jobs to the
>        hardware accelerator to run in parallel.
>
>     f) Add a "void *kernel_data" member to struct acomp_req for use by
>        kernel modules to pass batching data to algorithms that support
>        batching. This allows us to enable compress batching with only
>        the crypto_acomp_batch_size() API, and without changes to
>        existing crypto_acomp API.
>
>     g) Submit the two largest data buffers first for decompression
>        batching, so that the longest running jobs get a head start,
>        reducing latency for the batch.
>
>
> Main Changes in Zswap Compression Batching:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  Note to zswap maintainers:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>  Patches 20, 21 and 22 can be reviewed and improved/merged independently
>  of this series, since they are zswap centric. These 3 patches help
>  batching but the crypto_acomp_batch_size() from the iaa_crypto commits
>  in this series is not a requirement, unlike patches 23-25.
>
>  1) v10 preserves the pool acomp_ctx resources creation/deletion
>     simplification of v9, namely, lasting from pool creation-deletion,
>     persisting through CPU hot[un]plug operations. Further, zswap no
>     longer needs to create multiple "struct acomp_req" in the per-CPU
>     acomp_ctx. zswap only needs to manage multiple "u8 **buffers".
>
>  2) We store the compressor's batch-size (@pool->compr_batch_size) and
>     the batch-size to use during compression batching
>     (@pool->batch_size) directly in struct zswap_pool for quick
>     retrieval in the zswap_store() fast path.
>
>  3) Optimizations to not cause regressions in software compressors with
>     the introduction of the new unified zswap_compress() procedure that
>     implements compression batching for all compressors. Since v9, the
>     new zpool_malloc() interface that allocates pool memory on the NUMA
>     node, when used in the new zswap_compress() batching implementation,
>     caused some performance loss (verified by replacing
>     page_to_nid(page) with NUMA_NO_NODE). These optimizations help
>     recover the performance and are submitted as an RFC:

which RFC is this?

>
>     a) kmem_cache_alloc_bulk(), kmem_cache_free_bulk() to allocate/free
>        batch zswap_entry's. These kmem_cache API allow allocator
>        optimizations with internal locks for multiple allocations.
>
>     b) Writes to the zswap_entry right after it is allocated without
>        modifying the publishing order. This avoids different code blocks
>        in zswap_store_pages() having to bring the zswap_entries to the
>        cache for writing, potentially evicting other working set
>        structures, impacting performance.
>
>     c) I ended up using a smaller batch-size for software compressors:
>        ZSWAP_MAX_BATCH_SIZE/4 since this gave the best performance with
>        zstd.
>
>     d) More likely()/unlikely() annotations to try and minimize branch
>        mis-predicts.
>
>  4) "struct swap_batch_comp_data" and "struct swap_batch_decomp_data"
>      added in mm/swap.h:
>
>      /*
>       * A compression algorithm that wants to batch compressions/decompre=
ssions
>       * must define its own internal data structures that exactly mirror
>       * @struct swap_batch_comp_data and @struct swap_batch_decomp_data.
>       */
>
>      Accordingly, zswap_compress() uses struct swap_batch_comp_data to
>      pass batching data in the acomp_req->kernel_data
>      pointer if the compressor supports batching.
>
>      include/linux/iaa_comp.h has matching definitions of
>      "struct iaa_batch_comp_data" and "struct iaa_batch_decomp_data".
>
>      Feedback from the zswap maintainers is requested on whether this
>      is a good approach. Suggestions for alternative approaches are also
>      very welcome.
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
> that can process a batch as an integral unit, the patch-series allows
> zswap to call crypto_acomp without API changes, for compressors
> that intrinsically support batching.
>
> The patch series provides a proof point by using the Intel Analytics
> Accelerator (IAA) for implementing the compress/decompress batching API
> using hardware parallelism in the iaa_crypto driver and another proof poi=
nt
> with a sequential software compressor, zstd.
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
>     compilation test using 32 threads, show 72% throughput gains and
>     23%-34% sys time reduction (usemem30) and 9% sys time reduction
>     (kernel compilation 64K folios) with zswap_store() large folios
>     using IAA compress batching as compared to IAA sequential.
>
>   The second proof point is to make sure that software algorithms such as
>   zstd do not regress. The data indicates that for sequential software
>   algorithms a performance gain is achieved.
>
>     With the performance optimizations implemented in patches 24 and 25
>     of v10:
>     *  zstd usemem30 throughput with PMD folios increases by
>        1%. Throughput with 64K folios is within range of variation
>        without a noticeable improvement. There is a 3%-13% sys time
>        reduction with zstd using 64K/PMD folios.
>
>     *  With kernel compilation using zstd, we get a 2%-3% reduction in
>        sys time.
>
>     These optimizations pertain to ensuring common code paths, removing
>     redundant branches/computes, using prefetchw() of the zswap entry
>     before it is written, and selectively annotating branches with
>     likely()/unlikely() compiler directives to minimize branch
>     mis-prediction penalty. Additionally, using the batching code for
>     non-batching compressors to sequentially compress/store batches of up
>     to ZSWAP_MAX_BATCH_SIZE/4 pages seems to help, most likely due to

Seems a bit random, no? Also isn't just batch size =3D=3D 2?

>     cache locality of working set structures such as the array of
>     zswap_entry-s for the batch.
>
>     Our internal validation of zstd with the batching interface vs. IAA w=
ith
>     the batching interface on Emerald Rapids has shown that IAA
>     compress/decompress batching gives 21.3% more memory savings as compa=
red

I still don't understand where these numbers come from. How do you
evaluate memory savings? Do you just compare peak memory usage? zstd
has better compression ratio, as you pointed out below (2.23 vs 2.96)

>     to zstd, for 5% performance loss as compared to the baseline without =
any
>     memory pressure. IAA batching demonstrates more than 2X the memory
>     savings obtained by zstd at this 95% performance KPI.
>     The compression ratio with IAA is 2.23, and with zstd 2.96. Even with
>     this compression ratio deficit for IAA, batching is extremely
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
>   2) zswap writeback decompression batching:
>
>      This is being co-developed with Nhat Pham, and shows promising
>      results. We plan to submit an RFC shortly. Many thanks Nhat, for
>      the ideas and collaboration.

:)

>
>   3) Reclaim batching of hybrid folios:
>
>      We can expect to see even more significant performance and throughpu=
t
>      improvements if we use the parallelism offered by IAA to do reclaim
>      batching of 4K/large folios (really any-order folios), and using the
>      zswap_store() high throughput compression pipeline to batch-compress
>      pages comprising these folios, not just batching within large
>      folios. This is the reclaim batching patch 13 in v1, which we expect
>      to submit in a separate patch-series.

Kcompressd will be yet another opportunity for batch compression once it la=
nds!

https://www.phoronix.com/news/Linux-Kcompressd-Memory

https://lore.kernel.org/lkml/20250430082651.3152444-1-qun-wei.lin@mediatek.=
com/


>
>   4) swapin_readahead() decompression batching:
>
>      We have developed a zswap load batching interface for IAA to be used
>      for parallel decompression batching, using swapin_readahead().
>
>   These capabilities are architected so as to be useful to zswap and
>   zram. We are actively working on integrating these components with zram=
.
>
>
>   v10 Performance Summary:
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
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
>                     mm-unstable-6-24-2025             v10
>      --------------------------------------------------------------------=
---
>      zswap compressor         deflate-iaa     deflate-iaa    IAA Batching
>                                                                  vs.
>                                                              IAA Sequenti=
al
>      --------------------------------------------------------------------=
---
>      Total throughput (KB/s)    6,078,729      10,465,906       72%
>      Avg throughput (KB/s)        202,624         348,863
>      elapsed time (sec)             98.42           66.63      -32%
>      sys time (sec)              2,361.88        1,563.67      -34%
>      --------------------------------------------------------------------=
---
>
>      --------------------------------------------------------------------=
---
>                     mm-unstable-6-24-2025             v10
>      --------------------------------------------------------------------=
---
>      zswap compressor                zstd            zstd    v10 zstd
>                                                              improvement
>      --------------------------------------------------------------------=
---
>      Total throughput (KB/s)    6,659,549       6,617,928       -1% **
>      Avg throughput (KB/s)        221,984         220,597
>      elapsed time (sec)             92.02           89.92       -2%
>      sys time (sec)              2,268.27        2,190.74       -3%
>      --------------------------------------------------------------------=
---
>      ** The 64K folios zstd throughput regression appears to be related t=
o
>         the recent change in commit 56e5a103a721 ("zsmalloc: prefer
>         the original page's node for compressed data") integrated with
>         the new zswap_compress() batching in this series: replacing the
>         page_to_nid() with NUMA_NO_NODE seems to recover the throughput.
>         Not sure if this is specific to x86.
>
>
>   usemem30 with 2M folios:
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>
>      --------------------------------------------------------------------=
--
>                      mm-unstable-6-24-2025            v10
>      --------------------------------------------------------------------=
--
>      zswap compressor          deflate-iaa    deflate-iaa    IAA Batching
>                                                                  vs.
>                                                              IAA Sequenti=
al
>      --------------------------------------------------------------------=
--
>      Total throughput (KB/s)     6,351,981     10,811,827       70%
>      Avg throughput (KB/s)         211,732        360,394
>      elapsed time (sec)              86.85          66.80      -23%
>      sys time (sec)               2,018.92       1,555.40      -23%
>      --------------------------------------------------------------------=
--
>
>      --------------------------------------------------------------------=
--
>                      mm-unstable-6-24-2025            v10
>      --------------------------------------------------------------------=
--
>      zswap compressor                 zstd           zstd    v10 zstd
>                                                              improvement
>      --------------------------------------------------------------------=
--
>      Total throughput (KB/s)     7,362,943      7,408,179        1%
>      Avg throughput (KB/s)         245,431        246,939
>      elapsed time (sec)              90.59          82.37       -9%
>      sys time (sec)               2,207.91       1,915.35      -13%
>      --------------------------------------------------------------------=
--
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
>    The commit log of patch 0021 has a more detailed analysis.
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
>    The commit log of patch 0002 provides more details on new iaa_crypto
>    driver parameters added, along with recommended settings.
>
> 2) Compress/decompress batching are implemented using
>    crypto_acomp_[de]compress() with batching data passed to the driver
>    using the acomp_req->kernel_data pointer.
>
>
> (C) The patch-series is organized as follows:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  1) crypto acomp & iaa_crypto driver enablers for batching: Relevant
>     patches are tagged with "crypto:" in the subject:
>
>     Patch 1) Reorganizes the iaa_crypto driver code into logically relate=
d
>              sections and avoids forward declarations, in order to facili=
tate
>              subsequent iaa_crypto patches. This patch makes no
>              functional changes.
>
>     Patch 2) Makes an infrastructure change in the iaa_crypto driver
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
>              duplication of device WQs in per-CPU wq_tables, thereby
>              saving 140MiB on a 384 cores dual socket Granite Rapids serv=
er
>              with 8 IAAs.
>
>              Regardless of how the user has configured the WQs' usage,
>              the next WQ to use is obtained through a direct look-up in
>              per-CPU "cpu_comp_wqs" and "cpu_decomp_wqs" structures so
>              as to minimize latency in the critical path driver compress
>              and decompress routines.
>
>     Patch 3) Code cleanup, consistency of function parameters.
>
>     Patch 4) Makes a change to iaa_crypto driver's descriptor allocation,
>              from blocking to non-blocking with retries/timeouts and
>              mitigations in case of timeouts during compress/decompress
>              ops. This prevents tasks getting blocked indefinitely, which
>              was observed when testing 30 cores running workloads, with
>              only 1 IAA enabled on Sapphire Rapids (out of 4). These
>              timeouts are typically only encountered, and associated
>              mitigations exercised, only in configurations with 1 IAA
>              device shared by 30+ cores.
>
>     Patch 5) Optimize iaa_wq refcounts using a percpu_ref instead of
>              spinlocks and "int refcount".
>
>     Patch 6) Code simplification and restructuring for understandability
>              in core iaa_compress() and iaa_decompress() routines.
>
>     Patch 7) Refactor hardware descriptor setup to their own procedures
>              to reduce code clutter.
>
>     Patch 8) Simplify and optimize (i.e. reduce computes) job submission
>              for the most commonly used non-irq async mode by directly
>              calling movdir64b.
>
>     Patch 9) Deprecate exporting symbols for adding IAA compression
>              modes.
>
>     Patch 10) Rearchitect iaa_crypto to be agnostic of crypto_acomp for
>               it be usable in both zswap and zram. crypto_acomp interface=
s are
>               maintained as earlier, for use in zswap.
>
>     Patch 11) Descriptor submit and polling mechanisms, enablers for batc=
hing.
>
>     Patch 12) Add a "void *kernel_data" member to struct acomp_req. This
>               gets initialized to NULL in acomp_request_set_params().
>
>     Patch 13) Implement IAA batching of compressions and decompressions
>               for deriving hardware parallelism.
>
>     Patch 14) Enables the "async" mode, sets it as the default.
>
>     Patch 15) Disables verify_compress by default.
>
>     Patch 16) Decompress batching optimization: Find the two largest
>               buffers in the batch and submit them first.
>
>     Patch 17) Add a new Dynamic compression mode that can be used on
>               Granite Rapids.
>
>     Patch 18) Add get_batch_size() to structs acomp_alg/crypto_acomp and
>               a crypto_acomp_batch_size() API that returns the compressor=
's
>               batch-size, if it has provided an implementation for
>               get_batch_size(); 1 otherwise.
>
>     Patch 19) iaa-crypto implementation for get_batch_size(), that
>               returns an iaa_driver specific constant,
>               IAA_CRYPTO_MAX_BATCH_SIZE (set to 8U currently).
>
>
>  2) zswap modifications to enable compress batching in zswap_store()
>     of large folios (including pmd-mappable folios):
>
>     Patch 20) Moves the zswap CPU hotplug procedures under "pool function=
s",
>               because they are invoked upon pool creation/deletion.
>
>     Patch 21) Simplifies the zswap_pool's per-CPU acomp_ctx resource
>               management and lifetime to be from pool creation to pool
>               deletion.
>
>     Patch 22) Uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check =
for
>               valid acomp/req, thereby making it consistent with the reso=
urce
>               de-allocation code.
>
>     Patch 23) Defines a zswap-specific ZSWAP_MAX_BATCH_SIZE (currently se=
t
>               as 8U) to denote the maximum number of acomp_ctx batching
>               resources to allocate, thus limiting the amount of extra
>               memory used for batching. Further, the "struct
>               crypto_acomp_ctx" is modified to contain multiple buffers.
>               New "u8 compr_batch_size" and "u8 batch_size" members are
>               added to "struct zswap_pool" to track the number of dst
>               buffers associated with the compressor (more than 1 if
>               the compressor supports batching) and the unit for storing
>               large folios using compression batching respectively.
>
>     Patch 24) Modifies zswap_store() to store the folio in batches of
>               pool->batch_size by calling a new zswap_store_pages() that =
takes
>               a range of indices in the folio to be stored.
>               zswap_store_pages() pre-allocates zswap entries for the bat=
ch,
>               calls zswap_compress() for each page in this range, and sto=
res
>               the entries in xarray/LRU.
>
>     Patch 25) Introduces a new unified implementation of zswap_compress()
>               for compressors that do and do not support batching. This
>               eliminates code duplication and facilitates maintainability=
 of
>               the code with the introduction of compress batching. Furthe=
r,
>               there are many optimizations to this common code that resul=
t
>               in workload throughput and performance improvements with
>               software compressors and hardware accelerators such as IAA.
>
>               zstd performance is better or on par with mm-unstable. We
>               see impressive throughput/performance improvements with IAA
>               batching vs. no-batching.
>
>
> With v10 of this patch series, the IAA compress batching feature will be
> enabled seamlessly on Intel platforms that have IAA by selecting
> 'deflate-iaa' as the zswap compressor, and using the iaa_crypto 'async'
> sync_mode driver attribute (the default).
>
>
> System setup for testing:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> Testing of this patch-series was done with mm-unstable as of 6-24-2025,
> commit 23b9c0472ea3, without and with this patch-series. Data was
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
> 2) Kernel compilation allmodconfig with 2G max memory, 32 threads, with
>    these large folios enabled to "always":
>    - 64k
>
> IAA WQ Configuration for both workloads:
>
>    2 WQs per IAA device, each containing 64 entries. The driver sends
>    decompresses to wqX.0 and compresses to wqX.1. All IAAs' wqX.1 are
>    available to all package cores to send compress jobs in a
>    round-robin manner.
>
>      4 IAA devices
>      2 WQs per device
>      echo 1 > /sys/bus/dsa/drivers/crypto/g_comp_wqs_per_iaa
>      echo 1 > /sys/bus/dsa/drivers/crypto/distribute_comps
>      echo 0 > /sys/bus/dsa/drivers/crypto/distribute_decomps
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
>                  mm-unstable-6-24-2025            v10
>  ------------------------------------------------------------------------=
-------
>  zswap compressor         deflate-iaa     deflate-iaa    IAA Batching
>                                                              vs.
>                                                          IAA Sequential
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)    6,078,729      10,465,906       72%
>  Avg throughput (KB/s)        202,624         348,863
>  elapsed time (sec)             98.42           66.63      -32%
>  sys time (sec)              2,361.88        1,563.67      -34%
>
>  ------------------------------------------------------------------------=
-------
>  memcg_high                 1,259,949       1,403,503
>  memcg_swap_fail                  977           2,394
>  zswpout                   57,996,932      64,508,737
>  zswpin                            56             395
>  pswpout                            0               0
>  pswpin                             0               0
>  thp_swpout                         0               0
>  thp_swpout_fallback                0               0
>  64kB_swpout_fallback             977           2,394
>  ZSWPOUT-64kB               3,623,824       4,029,537
>  SWPOUT-64kB                        0               0
>  pgmajfault                     2,342           2,712
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
>                  mm-unstable-6-24-2025             v10
>  ------------------------------------------------------------------------=
-------
>  zswap compressor          deflate-iaa     deflate-iaa     IAA Batching
>                                                                vs.
>                                                            IAA Sequential
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)     6,351,981      10,811,827      70%
>  Avg throughput (KB/s)         211,732         360,394
>  elapsed time (sec)              86.85           66.80     -23%
>  sys time (sec)               2,018.92        1,555.40     -23%
>
>  ------------------------------------------------------------------------=
-------
>  memcg_high                    115,436         125,209
>  memcg_swap_fail                   455              10
>  zswpout                    59,440,062      64,512,000
>  zswpin                            445               0
>  pswpout                             0               0
>  pswpin                              0               0
>  thp_swpout                          0               0
>  thp_swpout_fallback               455              10
>  ZSWPOUT-2048kB                115,638         125,990
>  pgmajfault                      2,763           2,278
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
>                mm-unstable-6-24-2025           v10
>  ------------------------------------------------------------------------=
-------
>  zswap compressor               zstd          zstd       v10 zstd
>                                                          improvement
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)   6,659,549     6,617,928       -1% **
>  Avg throughput (KB/s)       221,984       220,597
>  elapsed time (sec)            92.02         89.92       -2%
>  sys time (sec)             2,268.27      2,190.74       -3%
>
>  ------------------------------------------------------------------------=
-------
>  memcg_high                1,117,635     1,116,316
>  memcg_swap_fail                 940         2,001

Why is there so much more swap failure here? For 2M, this doesn't seem
to be the case.

>  zswpout                  48,745,750    48,720,035
>  zswpin                           85            83
>  pswpout                           0             0
>  pswpin                            0             0
>  thp_swpout                        0             0
>  thp_swpout_fallback               0             0
>  64kB_swpout_fallback            940         2,001

Similarly, why are we falling back more?

>  ZSWPOUT-64kB              3,045,706     3,043,064
>  SWPOUT-64kB                       0             0
>  pgmajfault                    2,391         2,365
>  ------------------------------------------------------------------------=
-------
>
>  ** The 64K folios zstd throughput regression appears to be related to
>     the recent change in zpool_malloc() in the context of my new
>     zswap_compress(): replacing the page_to_nid() with NUMA_NO_NODE
>     seems to recover the throughput.

Interesting. So there's some negative interaction between the new NUMA
node selection behavior and your patch?

>
>     zstd with PMD folios has no regression.
>
>
>  2M folios: usemem30: zstd:
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>
>  ------------------------------------------------------------------------=
-------
>                mm-unstable-6-24-2025           v10
>  ------------------------------------------------------------------------=
-------
>  zswap compressor               zstd          zstd      v10 zstd
>                                                         improvement
>  ------------------------------------------------------------------------=
-------
>  Total throughput (KB/s)   7,362,943     7,408,179       1%
>  Avg throughput (KB/s)       245,431       246,939
>  elapsed time (sec)            90.59         82.37      -9%
>  sys time (sec)             2,207.91      1,915.35     -13%
>
>  ------------------------------------------------------------------------=
-------
>  memcg_high                   93,086        92,842
>  memcg_swap_fail                 237             8
>  zswpout                  48,065,103    47,945,216
>  zswpin                          462             0
>  pswpout                           0             0
>  pswpin                            0             0
>  thp_swpout                        0             0
>  thp_swpout_fallback             237             8
>  ZSWPOUT-2048kB               93,649        93,635
>  pgmajfault                    2,760         2,462
>  ------------------------------------------------------------------------=
-------
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

64K number looks good. Usemem numbers probably don't matter as much as this=
?

>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  ------------------------------------------------------------------------=
-------
>                        mm-unstable              v10    mm-unstable       =
    v10
>  ------------------------------------------------------------------------=
-------
>  zswap compressor      deflate-iaa      deflate-iaa           zstd       =
   zstd
>  ------------------------------------------------------------------------=
-------
>  real_sec                   787.02           768.53         809.70       =
 801.72
>  user_sec                15,668.19        15,650.51      15,676.61     15=
,675.44
>  sys_sec                  3,964.43         3,619.90       5,083.25      4=
,937.68
>  ------------------------------------------------------------------------=
-------
>  Max_Res_Set_Size_KB     1,872,824        1,872,752      1,875,248     1,=
868,912
>  ------------------------------------------------------------------------=
-------
>  memcg_high                      0                0              0       =
      0
>  memcg_swap_fail                 0                0              0       =
      0
>  zswpout                96,465,374       89,832,641     82,908,162    79,=
263,919
>  zswpin                 29,557,410       25,861,919     24,214,968    22,=
890,145
>  pswpout                       281              182            132       =
     80
>  pswpin                         68               50            100       =
     48
>  thp_swpout                      0                0              0       =
      0
>  thp_swpout_fallback             0                0              0       =
      0
>  64kB_swpout_fallback            0                0              0       =
      0
>  ZSWPOUT-64kB            3,140,301        2,942,122      2,662,742     2,=
515,062
>  SWPOUT-64kB                    17               11              8       =
      5
>  pgmajfault             31,396,867       27,323,294     25,521,684    24,=
141,275
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
>                        mm-unstable              v10    mm-unstable       =
    v10
>  ------------------------------------------------------------------------=
-------
>  zswap compressor      deflate-iaa      deflate-iaa           zstd       =
   zstd
>  ------------------------------------------------------------------------=
-------
>  real_sec                   779.48           767.95         790.84       =
 794.18
>  user_sec                15,744.45        15,748.14      15,760.88     15=
,754.19
>  sys_sec                  4,317.77         4,366.68       5,723.42      5=
,629.16

The 2M number looks decent too. Seems like the "regression" in
real_sec for zstd comes from the disk swapping activity (see below)

>  ------------------------------------------------------------------------=
-------
>  Max_Res_Set_Size_KB     1,874,680        1,874,684      1,872,892     1,=
871,100
>  ------------------------------------------------------------------------=
-------
>  memcg_high                      0                0              0       =
      0
>  memcg_swap_fail                 0                0              0       =
      0
>  zswpout               106,917,762      109,984,153     95,116,327    92,=
744,107
>  zswpin                 37,863,668       38,873,716     31,417,475    31,=
011,508
>  pswpout                     1,638            2,158            518       =
  1,026
>  pswpin                         86            1,099            518       =
  1,026

Looks like there are 1026 pages swapped out to disk, which are all
swapped back in?

I assume this is due to compression failure?

>  thp_swpout                      3                4              1       =
      2
>  thp_swpout_fallback         9,136            8,848          6,004       =
  6,509
>  ZSWPOUT-2048kB              8,972            8,796          8,714       =
  7,827
>  pgmajfault             39,160,307       40,184,307     32,323,562    31,=
848,730
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
> Changes since v9:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 6-24-2025, commit 23b9c0472ea3.
> 2) iaa_crypto rearchitecting, mainline race condition fix, performance
>    optimizations, code cleanup.
> 3) Addressed Herbert's comments in v9 patch 10, that an array based
>    crypto_acomp interface is not acceptable.
> 4) Optimized the implementation of the batching zswap_compress() and
>    zswap_store_pages() added in v9, to recover performance when
>    integrated with the changes in commit 56e5a103a721 ("zsmalloc: prefer
>    the the original page's node for compressed data").

So the numbers above are already with these changes to recover performance?


>
> Changes since v8:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 4-21-2025, commit 2c01d9f3c611.
> 2) Backported commits for reverting request chaining, since these are
>    in cryptodev-2.6 but not yet in mm-unstable: without these backports,
>    deflate-iaa is non-functional in mm-unstable:
>    commit 64929fe8c0a4 ("crypto: acomp - Remove request chaining")
>    commit 5976fe19e240 ("Revert "crypto: testmgr - Add multibuffer acomp
>                          testing"")
>    Backported this hotfix as well:
>    commit 002ba346e3d7 ("crypto: scomp - Fix off-by-one bug when
>    calculating last page").
> 3) crypto_acomp_[de]compress() restored to non-request chained
>    implementations since request chaining has been removed from acomp in
>    commit 64929fe8c0a4 ("crypto: acomp - Remove request chaining").
> 4) New IAA WQ architecture to denote WQ type and whether or not a WQ
>    should be shared among all package cores, or only to the "mapped"
>    ones from an even cores-to-IAA distribution scheme.
> 5) Compress/decompress batching are implemented in iaa_crypto using new
>    crypto_acomp_batch_compress()/crypto_acomp_batch_decompress() API.
> 6) Defines a "void *data" in struct acomp_req, based on Herbert advising
>    against using req->base.data in the driver. This is needed for async
>    submit-poll to work.
> 7) In zswap.c, moved the CPU hotplug callbacks to reside in "pool
>    functions", per Yosry's suggestion to move procedures in a distinct
>    patch before refactoring patches.
> 8) A new "u8 nr_reqs" member is added to "struct zswap_pool" to track
>    the number of requests/buffers associated with the per-cpu acomp_ctx,
>    as per Yosry's suggestion.
> 9) Simplifications to the acomp_ctx resources allocation, deletion,
>    locking, and for these to exist from pool creation to pool deletion,
>    based on v8 code review discussions with Yosry.
> 10) Use IS_ERR_OR_NULL() consistently in zswap_cpu_comp_prepare() and
>     acomp_ctx_dealloc(), as per Yosry's v8 comment.
> 11) zswap_store_folio() is deleted, and instead, the loop over
>     zswap_store_pages() is moved inline in zswap_store(), per Yosry's
>     suggestion.
> 12) Better structure in zswap_compress(), unified procedure that
>     compresses/stores a batch of pages for both, non-batching and
>     batching compressors. Renamed from zswap_batch_compress() to
>     zswap_compress(): Thanks Yosry for these suggestions.
>
>
> Changes since v7:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 3-3-2025, commit 5f089a9aa987.
> 2) Changed the acomp_ctx->nr_reqs to be u8 since ZSWAP_MAX_BATCH_SIZE is
>    defined as 8U, for saving memory in this per-cpu structure.
> 3) Fixed a typo in code comments in acomp_ctx_get_cpu_lock():
>    acomp_ctx->initialized to acomp_ctx->__online.
> 4) Incorporated suggestions from Yosry, Chengming, Nhat and Johannes,
>    thanks to all!
>    a) zswap_batch_compress() replaces zswap_compress(). Thanks Yosry
>       for this suggestion!
>    b) Process the folio in sub-batches of ZSWAP_MAX_BATCH_SIZE, regardles=
s
>       of whether or not the compressor supports batching. This gets rid o=
f
>       the kmalloc(entries), and allows us to allocate an array of
>       ZSWAP_MAX_BATCH_SIZE entries on the stack. This is implemented in
>       zswap_store_pages().
>    c) Use of a common structure and code paths for compressing a folio in
>       batches, either as a request chain (in parallel in IAA hardware) or
>       sequentially. No code duplication since zswap_compress() has been
>       replaced with zswap_batch_compress(), simplifying maintainability.
> 5) A key difference between compressors that support batching and
>    those that do not, is that for the latter, the acomp_ctx mutex is
>    locked/unlocked per ZSWAP_MAX_BATCH_SIZE batch, so that decompressions
>    to handle page-faults can make progress. This fixes the zstd kernel
>    compilation regression seen in v7. For compressors that support
>    batching, for e.g. IAA, the mutex is locked/released once for storing
>    the folio.
> 6) Used likely/unlikely compiler directives and prefetchw to restore
>    performance with the common code paths.
>
> Changes since v6:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 2-27-2025, commit d58172d128ac.
>
> 2) Deleted crypto_acomp_batch_compress() and
>    crypto_acomp_batch_decompress() interfaces, as per Herbert's
>    suggestion. Batching is instead enabled by chaining the requests. For
>    non-batching compressors, there is no request chaining involved. Both,
>    batching and non-batching compressions are accomplished by zswap by
>    calling:
>
>    crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx-=
>wait);
>
> 3) iaa_crypto implementation of batch compressions/decompressions using
>    request chaining, as per Herbert's suggestions.
> 4) Simplification of the acomp_ctx resource allocation/deletion with
>    respect to CPU hot[un]plug, to address Yosry's suggestions to explore =
the
>    mutex options in zswap_cpu_comp_prepare(). Yosry, please let me know i=
f
>    the per-cpu memory cost of this proposed change is acceptable (IAA:
>    64.8KB, Software compressors: 8.2KB). On the positive side, I believe
>    restarting reclaim on a CPU after it has been through an offline-onlin=
e
>    transition, will be much faster by not deleting the acomp_ctx resource=
s
>    when the CPU gets offlined.
> 5) Use of lockdep assertions rather than comments for internal locking
>    rules, as per Yosry's suggestion.
> 6) No specific references to IAA in zswap.c, as suggested by Yosry.
> 7) Explored various solutions other than the v6 zswap_store_folio()
>    implementation, to fix the zstd regression seen in v5, to attempt to
>    unify common code paths, and to allocate smaller arrays for the zswap
>    entries on the stack. All these options were found to cause usemem30
>    latency regression with zstd. The v6 version of zswap_store_folio() is
>    the only implementation that does not cause zstd regression, confirmed
>    by 10 consecutive runs, each giving quite consistent latency
>    numbers. Hence, the v6 implementation is carried forward to v7, with
>    changes for branching for batching vs. sequential compression API
>    calls.
>
>
> Changes since v5:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 2-1-2025, commit 7de6fd8ab650.
>
> Several improvements, regression fixes and bug fixes, based on Yosry's
> v5 comments (Thanks Yosry!):
>
> 2) Fix for zstd performance regression in v5.
> 3) Performance debug and fix for marginal improvements with IAA batching
>    vs. sequential.
> 4) Performance testing data compares IAA with and without batching, inste=
ad
>    of IAA batching against zstd.
> 5) Commit logs/zswap comments not mentioning crypto_acomp implementation
>    details.
> 6) Delete the pr_info_once() when batching resources are allocated in
>    zswap_cpu_comp_prepare().
> 7) Use kcalloc_node() for the multiple acomp_ctx buffers/reqs in
>    zswap_cpu_comp_prepare().
> 8) Simplify and consolidate error handling cleanup code in
>    zswap_cpu_comp_prepare().
> 9) Introduce zswap_compress_folio() in a separate patch.
> 10) Bug fix in zswap_store_folio() when xa_store() failure can cause all
>     compressed objects and entries to be freed, and UAF when zswap_store(=
)
>     tries to free the entries that were already added to the xarray prior
>     to the failure.
> 11) Deleting compressed_bytes/bytes. zswap_store_folio() also comprehends
>     the recent fixes in commit bf5eaaaf7941 ("mm/zswap: fix inconsistency
>     when zswap_store_page() fails") by Hyeonggon Yoo.
>
> iaa_crypto improvements/fixes/changes:
>
> 12) Enables asynchronous mode and makes it the default. With commit
>     4ebd9a5ca478 ("crypto: iaa - Fix IAA disabling that occurs when
>     sync_mode is set to 'async'"), async mode was previously just sync. W=
e
>     now have true async support.
> 13) Change idxd descriptor allocations from blocking to non-blocking with
>     timeouts, and mitigations for compress/decompress ops that fail to
>     obtain a descriptor. This is a fix for tasks blocked errors seen in
>     configurations where 30+ cores are running workloads under high memor=
y
>     pressure, and sending comps/decomps to 1 IAA device.
> 14) Fixes a bug with unprotected access of "deflate_generic_tfm" in
>     deflate_generic_decompress(), which can cause data corruption and
>     zswap_decompress() kernel crash.
> 15) zswap uses crypto_acomp_batch_compress() with async polling instead o=
f
>     request chaining for slightly better latency. However, the request
>     chaining framework itself is unchanged, preserved from v5.
>
>
> Changes since v4:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 12-20-2024, commit 5555a83c82d6.
> 2) Added acomp request chaining, as suggested by Herbert. Thanks Herbert!
> 3) Implemented IAA compress batching using request chaining.
> 4) zswap_store() batching simplifications suggested by Chengming, Yosry a=
nd
>    Nhat, thanks to all!
>    - New zswap_compress_folio() that is called by zswap_store().
>    - Move the loop over folio's pages out of zswap_store() and into a
>      zswap_store_folio() that stores all pages.
>    - Allocate all zswap entries for the folio upfront.
>    - Added zswap_batch_compress().
>    - Branch to call zswap_compress() or zswap_batch_compress() inside
>      zswap_compress_folio().
>    - All iterations over pages kept in same function level.
>    - No helpers other than the newly added zswap_store_folio() and
>      zswap_compress_folio().
>
>
> Changes since v3:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 11-18-2024, commit 5a7056135bb6.
> 2) Major re-write of iaa_crypto driver's mapping of IAA devices to cores,
>    based on packages instead of NUMA nodes.
> 3) Added acomp_has_async_batching() API to crypto acomp, that allows
>    zswap/zram to query if a crypto_acomp has registered batch_compress an=
d
>    batch_decompress interfaces.
> 4) Clear the poll bits on the acomp_reqs passed to
>    iaa_comp_a[de]compress_batch() so that a module like zswap can be
>    confident about the acomp_reqs[0] not having the poll bit set before
>    calling the fully synchronous API crypto_acomp_[de]compress().
>    Herbert, I would appreciate it if you can review changes 2-4; in patch=
es
>    1-8 in v4. I did not want to introduce too many iaa_crypto changes in
>    v4, given that patch 7 is already making a major change. I plan to wor=
k
>    on incorporating the request chaining using the ahash interface in v5
>    (I need to understand the basic crypto ahash better). Thanks Herbert!
> 5) Incorporated Johannes' suggestion to not have a sysctl to enable
>    compress batching.
> 6) Incorporated Yosry's suggestion to allocate batching resources in the
>    cpu hotplug onlining code, since there is no longer a sysctl to contro=
l
>    batching. Thanks Yosry!
> 7) Incorporated Johannes' suggestions related to making the overall
>    sequence of events between zswap_store() and zswap_batch_store() simil=
ar
>    as much as possible for readability and control flow, better naming of
>    procedures, avoiding forward declarations, not inlining error path
>    procedures, deleting zswap internal details from zswap.h, etc. Thanks
>    Johannes, really appreciate the direction!
>    I have tried to explain the minimal future-proofing in terms of the
>    zswap_batch_store() signature and the definition of "struct
>    zswap_batch_store_sub_batch" in the comments for this struct. I hope t=
he
>    new code explains the control flow a bit better.
>
>
> Changes since v2:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 11-5-2024, commit 7994b7ea6ac8.
> 2) Fixed an issue in zswap_create_acomp_ctx() with checking for NULL
>    returned by kmalloc_node() for acomp_ctx->buffers and for
>    acomp_ctx->reqs.
> 3) Fixed a bug in zswap_pool_can_batch() for returning true if
>    pool->can_batch_comp is found to be equal to BATCH_COMP_ENABLED, and i=
f
>    the per-cpu acomp_batch_ctx tests true for batching resources having
>    been allocated on this cpu. Also, changed from per_cpu_ptr() to
>    raw_cpu_ptr().
> 4) Incorporated the zswap_store_propagate_errors() compilation warning fi=
x
>    suggested by Dan Carpenter. Thanks Dan!
> 5) Replaced the references to SWAP_CRYPTO_SUB_BATCH_SIZE in comments in
>    zswap.h, with SWAP_CRYPTO_BATCH_SIZE.
>
> Changes since v1:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 11-1-2024, commit 5c4cf96cd702.
> 2) Incorporated Herbert's suggestions to use an acomp_req flag to indicat=
e
>    async/poll mode, and to encapsulate the polling functionality in the
>    iaa_crypto driver. Thanks Herbert!
> 3) Incorporated Herbert's and Yosry's suggestions to implement the batchi=
ng
>    API in iaa_crypto and to make its use seamless from zswap's
>    perspective. Thanks Herbert and Yosry!
> 4) Incorporated Yosry's suggestion to make it more convenient for the use=
r
>    to enable compress batching, while minimizing the memory footprint
>    cost. Thanks Yosry!
> 5) Incorporated Yosry's suggestion to de-couple the shrink_folio_list()
>    reclaim batching patch from this series, since it requires a broader
>    discussion.
>
>
> I would greatly appreciate code review comments for the iaa_crypto driver
> and mm patches included in this series!
>
> Thanks,
> Kanchana
>
>
>
>
>
> Kanchana P Sridhar (25):
>   crypto: iaa - Reorganize the iaa_crypto driver code.
>   crypto: iaa - New architecture for IAA device WQ comp/decomp usage &
>     core mapping.
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
>   crypto: iaa - Rearchitect the iaa_crypto driver to be usable by zswap
>     and zram.
>   crypto: iaa - Enablers for submitting descriptors then polling for
>     completion.
>   crypto: acomp - Add "void *kernel_data" in "struct acomp_req" for
>     kernel users.
>   crypto: iaa - IAA Batching for parallel compressions/decompressions.
>   crypto: iaa - Enable async mode and make it the default.
>   crypto: iaa - Disable iaa_verify_compress by default.
>   crypto: iaa - Submit the two largest source buffers first in
>     decompress batching.
>   crypto: iaa - Add deflate-iaa-dynamic compression mode.
>   crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's
>     batch-size.
>   crypto: iaa - IAA acomp_algs register the get_batch_size() interface.
>   mm: zswap: Move the CPU hotplug procedures under "pool functions".
>   mm: zswap: Per-CPU acomp_ctx resources exist from pool creation to
>     deletion.
>   mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
>     resources.
>   mm: zswap: Allocate pool batching resources if the compressor supports
>     batching.
>   mm: zswap: zswap_store() will process a large folio in batches.
>   mm: zswap: Batched zswap_compress() with compress batching of large
>     folios.
>
>  .../driver-api/crypto/iaa/iaa-crypto.rst      |  166 +-
>  crypto/acompress.c                            |    1 +
>  crypto/testmgr.c                              |   10 +
>  crypto/testmgr.h                              |   74 +
>  drivers/crypto/intel/iaa/Makefile             |    4 +-
>  drivers/crypto/intel/iaa/iaa_crypto.h         |   59 +-
>  .../intel/iaa/iaa_crypto_comp_dynamic.c       |   22 +
>  drivers/crypto/intel/iaa/iaa_crypto_main.c    | 2898 ++++++++++++-----
>  drivers/crypto/intel/iaa/iaa_crypto_stats.c   |    8 +
>  drivers/crypto/intel/iaa/iaa_crypto_stats.h   |    2 +
>  include/crypto/acompress.h                    |   30 +
>  include/crypto/internal/acompress.h           |    3 +
>  include/linux/iaa_comp.h                      |  159 +
>  mm/swap.h                                     |   23 +
>  mm/zswap.c                                    |  700 ++--
>  15 files changed, 3106 insertions(+), 1053 deletions(-)
>  create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c
>  create mode 100644 include/linux/iaa_comp.h
>
> --
> 2.27.0
>

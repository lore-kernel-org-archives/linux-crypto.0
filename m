Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795568340;
	b=GsVbWEgskg9ZuJaXjJlvKhs89AnpDUlMNfqSwcK5aYe6zni+WpcQCvrZuuT7tXuWtDPl
	 MxqEuPquK1Gx1YjcwmQo24wAqm92U/X3TsVU8eHryXgRQW0BQ4LFWh2hfFFHiDz7ArJJ0
	 1dpymC2GCt0pFPPM5xiZ+DUx0XU0lUEGiMvYpUO3fcAMQW2XWHLXP/Ffq1fxLHTIYaRsS
	 GMlWvffIVdahwr+rdozlVJAp48AS7GKZ0Sgn0/gtg251mzJekT2SOvqDMhh4n6bWDdJQx
	 2eovnVhkS4wG7A9dvY+k++qT0BD3J3MHtups5hhFTOfkihue5rgkUOTDFJdP9DIu1FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795568340;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=dKiOmNB/wL8PK/VYoD9bXTOiao/WG65tctz9b6e9EvU=;
	b=AbuqQaepLf8Os6j93OK9+/ADivyN76Z5Kx7Mp/jONrbgPPGCgJvuMNHMxLzcw5xs46Cx
	 jSnZMviN/ORhuyBnEF28rv/84VKqdqz4rur//D+jWbAf8REGYvHZmfXDPkcxL1PyBaixX
	 n4OyXZrfR4CZer+qSr476MD21yAZDIop8FE78CIM2fOrMFDCZkSy0y8oxdpPKU2YV6npv
	 u6MZW0HjdEfC3SBaN4h3EExqr1FBd6em+wYEDk2j5eBnBtC0YwDbjSZXXVgJ++8JobkJE
	 lhy4ogLSy/pB4szlTuev1mMjiYcFHIyXpQo+qevYst6TmBlq8g5Jz6yPFqclHGki/CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4FVoxd9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E2A606A31E;
	Wed, 25 Nov 2026 00:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4FVoxd9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05E91F000C4;
	Wed, 25 Nov 2026 00:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795568340;
	bh=dKiOmNB/wL8PK/VYoD9bXTOiao/WG65tctz9b6e9EvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P4FVoxd9Eg0VsucVuGUOODM3qiX3BNDn6ApFltNWVFEyV4OIbBhhM/6R8wF1JGr+F
	 jjVBTq40su7OkPbDqFFCQG1+NeNFlI1TbUy6FBkRzRg8oYGZpRL/41+FjmFH1L9Xhv
	 bu8Iosh9wLVsMcPVgrD+P+5bjvTflSeB6sqEZ10QGb7Z8FLRaE/fktrpUNDejQsKAt
	 oVm3dGa9NJUk0vY1FkSKXWs4yzykSEmN/G1RPLo3/lp1/GgTgyQCxyG2MXSnDVg2/M
	 AeFH5O7tWyGWIah9pFCPBsJhJtt8guOsll4rqwmFM6alm6f8+ReiPDW8HyxDh2r//I
	 /44BxjZQTXbqA==
Date: Wed, 25 Nov 2026 00:58:58 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression
 batching
Message-ID: <awYsDfYqrS2ldOTw@google.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com>
 <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
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
In-Reply-To: <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>

On Tue, Nov 24, 2026 at 03:45:52PM -0800, Kanchana P. Sridhar wrote:
> On Tue, Nov 24, 2026 at 12:29 PM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Fri, Nov 20, 2026 at 03:16:32PM -0800, Nhat Pham wrote:
> [...]
> > > Have you tried perf-ing the store path to see what was the overhead
> > > source (before and after this optimization)? I'm curious.
> >
> > So I was able to reproduce the usemem30 sys/wall time improvements here
> > on a Sapphire Rapids machine (both in a VM and on baremetal), and I
> > threw my LLM at perf-ing to figure out what the overhead was. It's
> > important to note that the sys/wall time improvement I observed was on
> > the free phase, the write phase / throughput (which involves zswap
> > store) didn't show much of a change.
> >
> > Batching made more consecutive pages that compress to the same zsmalloc
> > class more likely to land in the same zspage, so the freeing path gets
> > faster as the zspage and metadata are hot in the cache, which alleviates
> > contention on the class lock.
> 
> This is a real performance gain with batching, correct?

Yes, but I don't think batching stores is the right way to get it, see below.

> > I think the memory allocated by usemem all compresses to the same class
> > size, which makes holding the class lock in the freeing path a
> > bottleneck. I confirmed this by a hacky patch to shard the class lock
> > into 32 locks, which caused the same usemem improvements and the series
> > doesn't improve performance anymore on top of that change.
> 
> I think we all agree that vm-scalability/usemem is a
> microbenchmark/standard. I am not sure I understand the value of these
> "hacks", when my patch-series posts data with the standard mm-unstable
> and my patch series with a standard usemem microbenchmark.

I think the real gain comes from making the freeing path faster. What I
am saying is that we should optimize the freeing path rather than
batching stores to get better locality in zsmalloc pages, as this only
speeds up the freeing path when most data in a batch falls into the same
size class in zsmalloc, which isn't the case for real data (e.g.
Silesia).

I am not arguing that usemem results are not valuable, I am arguing that
there's more to the data than just usemem latency/throughput being
better with the patches.

The hacks were just a way to test the theory by eliminating zsmalloc
class contention. I am looking into proper optimizations for this path,
the goal was just to see if optimizing the class lock contention in the
freeing path would achieve the desired result.

> 
> >
> > I also tried usemem with Silesia to get realistic compression data
> > (similar to Kanchana's testing on previous versions), and didn't see
> > similar improvements (because the compressed pages get distributed
> > across multiple classes). I also tried a kernel build and the munmap
> > microbenchmark in [1] (which Sergey quoted in [2]), which also didn't
> > show improvements.
> >
> > That got me curious tho, and I had my LLM explore other optimizations to
> > the freeing path. I think we can get similar improvements in usemem
> > as well as the munmap microbenchmark [1] by batching zswap entries
> > freeing. We can batch both the zsmalloc object freeing as well as the
> > LRU deletion. I am still looking into it and I might send out patches.
> >
> > But I think this series doesn't really move the needle on realistic
> > workloads, as I previously mentioned.
> 
> Your statements and hypothesis based on the kernel hacks don't explain
> why I see 6.56% additional Sys time savings with compress batching
> over the gains observed with store batching alone. I am not sure how
> to interpret your statement above without your posting any data.
> 
> Did you get a chance to see the usemem/ZSTD data with/without compress
> batching that I posted in [1], and my analysis of the breakdown
> between performance gains from store batching vs. compress batching in
> [2]?


Yes. I tried rerunning usemem on a similar setup to yours, and
aggregating throughput, total sys/wall time, as well as write/free times
over 10 runs (write comes from throughput lines, free comes from freeing
lines). I did this at the baseline, with patches 1-7, and with patch 8
on top.

usemem30 (usemem -w -O -b 5 -s 10 -n 30 10g):
      kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (KB/s)
      base     2355.6 +- 25.3       94.24    55.62    26.82    212,239
      p1-7     2366.7 +- 22.9       94.65    55.91    26.90    211,108
      p1-8     2197.0 +- 37.9       89.65    55.48    21.66    212,853
               (-6.73% vs base,
                -7.17% vs p1-7)

AFAICT the speed up happens on the freeing side, not the writing side,
so it's not really zswap stores getting faster. In the freeing phase
(66%-100% of the run), ~90-92% of cycles are spinning in zs_free(), and
total cycles drop from ~1.64T to ~1.30T (-21%).

Running perf on the baseline:
---------------------------------------------------------------------
    # Total Lost Samples: 0
    #
    # Samples: 465K of event 'cpu/cycles/P' (time slices: 66%-100%)
    # Event count (approx.): 1636895619486
    #
    # Overhead  Symbol
    # ........  ............................................
    #
        92.29%  [k] queued_spin_lock_slowpath
                |
                 --92.26%--queued_spin_lock_slowpath
                           |
                            --92.17%--zs_free
                                      zswap_entry_free
                                      zswap_invalidate
                                      __swap_cluster_free_entries
                                      swap_put_entries_cluster
                                      swap_put_entries_direct
                                      __zap_vma_range
                                      unmap_vmas
                                      unmap_region
                                      vms_complete_munmap_vmas
                                      do_vmi_align_munmap
                                      do_vmi_munmap
                                      __vm_munmap
                                      __x64_sys_munmap
                                      do_syscall_64
                                      entry_SYSCALL_64_after_hwframe
                                      0x430ef7
---------------------------------------------------------------------

With your patches:
---------------------------------------------------------------------
    # Total Lost Samples: 0
    #
    # Samples: 372K of event 'cpu/cycles/P' (time slices: 66%-100%)
    # Event count (approx.): 1295809013413
    #
    # Overhead  Symbol
    # ........  ..................................................
    #
        90.75%  [k] queued_spin_lock_slowpath
                |
                 --90.72%--queued_spin_lock_slowpath
                           |
                            --90.03%--zs_free
                                      zswap_entry_free
                                      zswap_invalidate
                                      __swap_cluster_free_entries
                                      swap_put_entries_cluster
                                      swap_put_entries_direct
                                      __zap_vma_range
                                      unmap_vmas
                                      unmap_region
                                      vms_complete_munmap_vmas
                                      do_vmi_align_munmap
                                      do_vmi_munmap
                                      __vm_munmap
                                      __x64_sys_munmap
                                      do_syscall_64
                                      entry_SYSCALL_64_after_hwframe
                                      0x430ef7
---------------------------------------------------------------------

Adding some instrumentation I figured out that ~all memory from usemem
ends up in the same size class, hence the better zspage locality from
the batching in patch 8.

Here's the bpftrace data I collected, I don't see a material change when
probing zswap_store():

    zswap_store() (2048kB PMD folios, 178.9k calls):
      metric         base           p1-8           delta
      p50            10.76 ms       10.85 ms       +0.87%
      p95            11.34 ms       11.40 ms       +0.59%
      p99            12.15 ms       12.05 ms       -0.82%
      avg            10.80 ms       10.84 ms       +0.40%


Also if I run your modified usemem with Silesia like your previous
versions, the improvement goes away (because data no longer all goes in
the same zsmalloc class):

    usemem30 + Silesia (usemem -w --read-silesia -O -b 5 -s 10 -n 30 2560m,
    memory.high=38G):
      kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (KB/s)
      base     1779.0 +- 8.5        72.84    55.34    6.92     53,290
      p1-7     1775.7 +- 7.3        72.81    55.29    6.86     53,337
      p1-8     1771.8 +- 7.8        72.58    55.19    6.83     53,435
               (-0.40% vs base,
                -0.22% vs p1-7)


> As per the data I posted, compress batching of PMD THP with ZSTD
> yields an additional 6.56% Sys time savings and additional 1.12%
> Throughput improvement over zswap store batching. Combined zswap store
> + compress batching yields 13.87% Sys time reduction and 3.85%
> Throughput increase over mm-unstable. I think this clearly
> demonstrates performance benefits to a well established
> microbenchmark, run at scale, using upstream kernel git trees and my
> patch series.

I am not saying there is no performance improvement, I am saying the
performance improvement is a side effect of locality in zsmalloc, not
faster stores, and that it doesn't reproduce on real data. If we want to
address lock contention in zsmalloc freeing we should address it as
such, not by batching compression.

> 
> I would appreciate comments from Nhat, Johannes and Andrew on these
> posted gains/analysis:
> 
> [1]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar2026@gmail.com/T/#m33e586ec89ed46790da284e7a2f6d99b50c9f935
> [2]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar2026@gmail.com/T/#m51d7d13809d508a9116904c01bf3c94fdf2981dc
> 
> An independent replication of the gains posted by me in this
> patch-series, using standard mm-unstable and vm-scalability/usemem
> would also be very useful.
> 
> Thanks,
> Kanchana
> 
> > Regarding the bpftrace
> > measurements, I couldn't reproduce them. I think one factor is that
> > probing both zswap_store() and zswap_compress() makes the zswap_store()
> > numbers different based on how many zswap_compress() calls we make
> > (which are less with batching) due to the overhead of the probe itself.
> > When I trace zswap_store() without zswap_compress(), I don't see
> > meaningful changes in latency.
> >
> > [1] https://lore.kernel.org/linux-mm/20261016120927.3191690-1-hongfengchen@xiaomi.com/
> > [2] https://lore.kernel.org/linux-mm/20261123054746.2579253-1-senozhatsky@chromium.org/

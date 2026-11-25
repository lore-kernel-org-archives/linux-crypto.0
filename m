Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585862;
	b=ALTNyed4bF70R/8O0W2K/oVSEcGHzf8ImczR8nkAAZaGuohy4q4sxProPOGhquaoy5S3
	 jcm1ARaEQVL27ooj2HNysMAFaNdnHYZ+o6w/0zPAcKUL/xzV1LaT4A8Uve5oZlu3WbSmD
	 Su1yhGMnfvrDTHVBI9nB0L113T8yMyU4MugYal2nq1qejBQUzlgEQV8h3WZnx8d7+d+uo
	 /UMQnHHl6LLJtbOeb84AbsCjkv2S6hOYLBQOsZx1MQMEAmW9ajyOZBN98LivmiUjmbjR/
	 UmRxqLd6tx4SGjJLsYRto0Qgbp4ZZZavb6uwDQASuZ4s97PdjmV1hJHhhhg3RlbR+nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585862;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=Z3+0AEVtBqRYPmd3pDOG3DH8fjFIwFx/rMlidxGEFVI=;
	b=QOQw9VuXXzG5GJOJObS0BypT0fL9mJi2V8GbBzmNNSFQoG8LAR5e9VcG2CaO5hWGwc8Z
	 dv95f9t8xIqCk6unJZ1hKRwG1IuN2yrY3kzYrhcLlYXp7Cb4AQcJgdlkB99mars2/xssj
	 a8aWS9fqqAsxXxCRwzHRC9DE7sOSbbaWjtAfBiPx1uD7ih2EoyWHu1OXh1CuQ34Dl2vr3
	 BqH4gYu9LOtYUEX3iEjbn5Wh26ytiv59EnEa/UA08ATfzNSCt1KnNnFMClCVNuifPXsd0
	 dQKt66EwrupuuWEbEQU0AI08r4qV7t1dd+zUQH8Jq6HvcAesoZoqvBW4E5CgdNHI+dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B13O7WUj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4BF606A329;
	Wed, 25 Nov 2026 05:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B13O7WUj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C941F000D1;
	Wed, 25 Nov 2026 05:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795585861;
	bh=Z3+0AEVtBqRYPmd3pDOG3DH8fjFIwFx/rMlidxGEFVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B13O7WUjH464avzvlS3E/9Qh4guHneCId8SUBboU9UeS4qpTG9Vlm4khlCg3oz+q4
	 Sg87/Pw3xlFPTSyaY+3F7SuyeWZ6tuSgoI347fdSZydpnySn9eoKLXeTpfLqIGWOOB
	 GJPyVhsNNACCZ8JO9tdsJ7m5KDtT1n48emtODuMYBDZZFgNP690sjGjr1mEaPFe59y
	 vbf3RCz4mRMkzYcaunHjhQOhRyxOu2vVInLuazeVg6Dlh6Nmn5yUiA9zhLxzl1vP/w
	 2k9ME+iY3IwUi4c31JDjagzdmotUjLPTWBsx3kbuNXG6epOzxISfmNbb7Ys7XPK2fC
	 z7ZfeHVwEZHDQ==
Date: Wed, 25 Nov 2026 05:51:00 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression
 batching
Message-ID: <awZt7P_p-GNZ3A2i@google.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com>
 <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
 <awYsDfYqrS2ldOTw@google.com>
 <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>
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
In-Reply-To: <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>

On Tue, Nov 24, 2026 at 06:10:25PM -0800, Kanchana P. Sridhar wrote:
> On Tue, Nov 24, 2026 at 4:59 PM Yosry Ahmed <yosry@kernel.org> wrote:
> [...]
> >
> > I think the real gain comes from making the freeing path faster. What I
> > am saying is that we should optimize the freeing path rather than
> > batching stores to get better locality in zsmalloc pages, as this only
> > speeds up the freeing path when most data in a batch falls into the same
> > size class in zsmalloc, which isn't the case for real data (e.g.
> > Silesia).
> >
> > I am not arguing that usemem results are not valuable, I am arguing that
> > there's more to the data than just usemem latency/throughput being
> > better with the patches.
> >
> > The hacks were just a way to test the theory by eliminating zsmalloc
> > class contention. I am looking into proper optimizations for this path,
> > the goal was just to see if optimizing the class lock contention in the
> > freeing path would achieve the desired result.
> >
> [...]
> > Yes. I tried rerunning usemem on a similar setup to yours, and
> > aggregating throughput, total sys/wall time, as well as write/free times
> > over 10 runs (write comes from throughput lines, free comes from freeing
> > lines). I did this at the baseline, with patches 1-7, and with patch 8
> > on top.
> >
> > usemem30 (usemem -w -O -b 5 -s 10 -n 30 10g):
> >       kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (KB/s)
> >       base     2355.6 +- 25.3       94.24    55.62    26.82    212,239
> >       p1-7     2366.7 +- 22.9       94.65    55.91    26.90    211,108
> >       p1-8     2197.0 +- 37.9       89.65    55.48    21.66    212,853
> >                (-6.73% vs base,
> >                 -7.17% vs p1-7)
> >
> > AFAICT the speed up happens on the freeing side, not the writing side,
> > so it's not really zswap stores getting faster. In the freeing phase
> > (66%-100% of the run), ~90-92% of cycles are spinning in zs_free(), and
> > total cycles drop from ~1.64T to ~1.30T (-21%).
> 
> Can you please clarify what "write_s" and "free_s" refer to, and how
> are they measured? If you are referring to the gettimeofday() reported
> timing done in user-space by usemem, these times measure child
> processes' fork, do_unit, join, etc. : IOW, not a reliable indicator
> of zswap_store() performance.

write_s and free_s are from usemem's output.

Without your patches, here's the raw data I got:

    12079595520 bytes / 36047550 usecs = 327247 KB/s
    12079595520 bytes / 36221811 usecs = 325673 KB/s
    12079595520 bytes / 36539948 usecs = 322837 KB/s
    12079595520 bytes / 36554520 usecs = 322709 KB/s
    12079595520 bytes / 36630659 usecs = 322038 KB/s
    12079595520 bytes / 36705879 usecs = 321378 KB/s
    12079595520 bytes / 36795396 usecs = 320596 KB/s
    12079595520 bytes / 36844030 usecs = 320173 KB/s
    12079595520 bytes / 36936923 usecs = 319368 KB/s
    12079595520 bytes / 36989604 usecs = 318913 KB/s
    12079595520 bytes / 37063935 usecs = 318273 KB/s
    12079595520 bytes / 37065296 usecs = 318262 KB/s
    12079595520 bytes / 37158608 usecs = 317462 KB/s
    12079595520 bytes / 37188329 usecs = 317209 KB/s
    12079595520 bytes / 37176041 usecs = 317314 KB/s
    12079595520 bytes / 37222619 usecs = 316916 KB/s
    12079595520 bytes / 37277605 usecs = 316449 KB/s
    12079595520 bytes / 37382137 usecs = 315564 KB/s
    12079595520 bytes / 37485910 usecs = 314691 KB/s
    12079595520 bytes / 37506482 usecs = 314518 KB/s
    12079595520 bytes / 37582493 usecs = 313882 KB/s
    12079595520 bytes / 37654025 usecs = 313286 KB/s
    12079595520 bytes / 37804401 usecs = 312039 KB/s
    12079595520 bytes / 37872179 usecs = 311481 KB/s
    12079595520 bytes / 38139663 usecs = 309296 KB/s
    12079595520 bytes / 38148594 usecs = 309224 KB/s
    12079595520 bytes / 38149377 usecs = 309218 KB/s
    12079595520 bytes / 38207236 usecs = 308749 KB/s
    12079595520 bytes / 38442241 usecs = 306862 KB/s
    12079595520 bytes / 38445731 usecs = 306834 KB/s
    11147897 usecs to free memory
    16392260 usecs to free memory
    22879204 usecs to free memory
    23382635 usecs to free memory
    23518192 usecs to free memory
    24023442 usecs to free memory
    24176849 usecs to free memory
    24461635 usecs to free memory
    24232157 usecs to free memory
    24571926 usecs to free memory
    24498438 usecs to free memory
    24500253 usecs to free memory
    24197624 usecs to free memory
    24424616 usecs to free memory
    24128275 usecs to free memory
    24646461 usecs to free memory
    24390349 usecs to free memory
    24522151 usecs to free memory
    24563204 usecs to free memory
    24270881 usecs to free memory
    24232957 usecs to free memory
    23980870 usecs to free memory
    24180573 usecs to free memory
    24068183 usecs to free memory
    23758087 usecs to free memory
    23799366 usecs to free memory
    23512788 usecs to free memory
    23749313 usecs to free memory
    23829669 usecs to free memory
    23532371 usecs to free memory

write_s would be calculated averaging the time in the ".. bytes / ..
usecs" lines, and free_s by averaging the time from the ".. usecs to free
memory" lines.

In this run:
write_s = 37.31 s
free_s = 23.39 s

With your patches, I got:
write_s = 37.03 s
free_s = 18.86 s

So most of the improvement is in the freeing time.

> Also, there are no calls to zs_free() from zswap_compress() and
> zswap_update_entries(), so, it is not clear why "free_s" reduces from
> patch 7 (26.90s) to patch 8 (21.66s), if what you are saying (as I
> understand it), is zs_free() results in the gains.
[..]
> Is this perf run at the workload level? Can you also share the
> zswap_store() perf breakdown? I don't see any zswap_store() callees
> here..

Here are perf reports collected with:

    perf report --stdio --children --sort sym --percentage absolute \
        --symbol-filter=zswap_ -g graph,1,caller,function,period

Baseline:

# Total Lost Samples: 0
# Samples: 923K of event 'cpu/cycles/P'
# Event count (approx.): 5783481013054
#
# Children      Self  Symbol
# ........  ........  ..................................................
#
52.06%     0.26%  [.] zswap_store
	|
	 --2995798359281--zswap_store
		   |
		   |--2724723679947--zstd_compress
		   |          |--2639614263267--ZSTD_compress2
		   |          ...
		   |           --66562348127--ZSTD_initStaticCCtx
		   |
		    --217649410880--zs_store
			      |
			       --126618473697--__pv_queued_spin_lock_slowpath
[...]
40.26%     0.01%  [.] zswap_invalidate
	|
	 --2327775248737--zswap_invalidate
		   |
		    --2322317048724--zswap_entry_free
			      |
			       --2233301817626--zs_free
					 |
					  --2178824329486--__pv_queued_spin_lock_slowpath

With the patches:

# Total Lost Samples: 0
# Samples: 863K of event 'cpu/cycles/P'
# Event count (approx.): 5420333292095
#
# Children      Self  Symbol
# ........  ........  ..................................................
#
55.49%     0.17%  [.] zswap_store
	|
	 --2998025641673--zswap_store
		   |
		   |--2724254313681--crypto_acomp_compress
		   |          |
		   |           --2718237550253--zstd_compress
		   |                     |--2634756568606--ZSTD_compress2
		   |                     ...
		   |                      --62825503508--ZSTD_initStaticCCtx
		   |
		    --206719808793--zs_store
			      |
			       --142932151337--__pv_queued_spin_lock_slowpath
[...]
36.25%     0.01%  [.] zswap_invalidate
	|
	 --1964269438386--zswap_invalidate
		   |
		    --1959142544382--zswap_entry_free
			      |
			       --1874286346020--zs_free
					 |
					  --1828012531673--__pv_queued_spin_lock_slowpath


You can see that the cycles spent on zswap_store() are almost the same,
and the cycle reduction happens in zswap_invalidate().

> > Adding some instrumentation I figured out that ~all memory from usemem
> > ends up in the same size class, hence the better zspage locality from
> > the batching in patch 8.
> 
> What does this have to do with batching? All usemem memory compresses
> to the same zsmalloc size class in the baseline too. Can you elaborate
> what you mean by "better zspage locality from the batching in patch
> 8"?

With compression batching, pages in a folio call zs_store() in a row, so
they have a higher chance of landing in the same zspage compared to the
baseline.

In the baseline, each page's zs_store() is separated by ZSTD
compression, during which the other 29 processes fill up the current
zspage. With the patches (especially patch 8), 4 pages are compressed
first and then stored via zs_store() back-to-back, so they are much more
likely to land in the same zspage.

I used an LLM-generated bpftrace script to map each folio to the zspage
its pages end up on (~450 folios sampled), and aggregate the results:

					 base        	patched
Distinct zspages per 512-page folio:
mean +- sd                               510.6+-2.8  	321.8+-24.0
median (p10 - p90)                       511 (509-512) 	322 (302-341)
min - max                                483 - 512   	215 - 407
Avg pages of same folio per zspage         1.00        	1.59	
Consecutive pages hitting same zspage      0.27%       	36.16%	
(same-zspage adjacent pairs / 231,483)   (618)       	(83,709)
Contiguous same-zspage run lengths:
len = 1                                  99.7%       	62.8%
len = 2                                   0.3%       	22.1%
len = 3                                   0.0%       	10.9%
len = 4                                   0.0%        	4.2%

This causes zs_free() to run faster (i.e. shorter lock critical section)
as the zspage (and its metadata) is hot in the cache during freeing.

> 
> >
> > Here's the bpftrace data I collected, I don't see a material change when
> > probing zswap_store():
> >
> >     zswap_store() (2048kB PMD folios, 178.9k calls):
> >       metric         base           p1-8           delta
> >       p50            10.76 ms       10.85 ms       +0.87%
> >       p95            11.34 ms       11.40 ms       +0.59%
> >       p99            12.15 ms       12.05 ms       -0.82%
> >       avg            10.80 ms       10.84 ms       +0.40%
> >
> >
> > Also if I run your modified usemem with Silesia like your previous
> > versions, the improvement goes away (because data no longer all goes in
> > the same zsmalloc class):
> >
> >     usemem30 + Silesia (usemem -w --read-silesia -O -b 5 -s 10 -n 30 2560m,
> >     memory.high=38G):
> >       kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (KB/s)
> >       base     1779.0 +- 8.5        72.84    55.34    6.92     53,290
> >       p1-7     1775.7 +- 7.3        72.81    55.29    6.86     53,337
> >       p1-8     1771.8 +- 7.8        72.58    55.19    6.83     53,435
> >                (-0.40% vs base,
> >                 -0.22% vs p1-7)
> 
> Is this with PMD mTHP? Also, we would get a better idea of concurrency
> by increasing the memory allocation duration by allocating 10g per
> process, for 30 processes under memory.high=150G. 2g gives much fewer
> samples to be helpful, imo.

Yes, with PMD mTHP.

2560m with memory.high=38G was chosen purely to stay under the default
max_pool_percent=20 (38G on a 190G host) with zero pool-limit hits or
disk swapout, since Silesia compresses ~2.5-3x instead of ~7x for
unmodified usemem. Because ZSTD on Silesia is heavier per page, the
write duration is actually the same as 10g unmodified usemem with ~31M
zswpout per run.

> 
> [...]
> > I am not saying there is no performance improvement, I am saying the
> > performance improvement is a side effect of locality in zsmalloc, not
> > faster stores, and that it doesn't reproduce on real data.
> 
> I don't see the connection between batching and "locality in
> zspage/zsmalloc" since compressed size is a net wash between baseline
> and my patch series. Are we drawing the right conclusions?

See above.

> 
> > If we want to address lock contention in zsmalloc freeing we should address it as
> > such, not by batching compression.
> 
> Lock contention in zsmalloc seems like an independent optimization
> that is good to solve. What I don't see is a way of explaining the
> gains in this series based on zs_free() lock contention, and hence
> drawing a questionable conclusion that this series does not optimize
> zswap_store(), and further that batch compression is not attributing
> to the gains. I have provided ~10 reasons as to why the combined
> zswap_store_pages() batching and zswap_compress() batching improves
> zswap_store() performance in [2].

See above. I think the performance improvement is a side effect of
calling zs_store() in rapid succession for pages in the same folio, and
more pages in the same folio ending up in the same zspage. As I
previously mentioned, this happens because all pages in usemem end up in
the same size class.

The right thing to do would be optimize the zs_free() path. I am looking
into batching zswap entries freeing, which I believe is the right path
to optimize given those results.

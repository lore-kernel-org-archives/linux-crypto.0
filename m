Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792449766;
	b=th4Q9s24/+bt6MtPj6vXWU2o6qtLMv2y+enJGf94dnrxGpPWh92dFDjR8oERl54Yvfnc
	 oM77bjUxNFYB620B6wQwX/8r311RauTkSHDa++pfDov3mH5ecZVwzbFbnFlsA/0pQrFLn
	 Hq31DjakvUv+vqdHvgFXOdgRfOFxM1Hr49BhD09wMO+/iL4aV5nq3o1XOhZXCIqFxhSr3
	 +qCJ5EwStaa/4DI3MDzWmjVCkeDV8XAGfRfZbESCupbqTrUn4njxSVGvdjRbafT2GjtgU
	 gnLXwVrhmjx26TG1Yl7ThuFAUsSA8MZY4n5OW8f57H16eXWSFhlsp+nX15QB5mgueiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792449766;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=tXbwnR2RlCJZXvS7RGs12P+e1RnZcsA+7Uc/5Gfouos=;
	b=M5Jr6TTIB3LQRKAkobptGf9D7dXZ1n/oBUtKpdXLvD3WCx8QzV/MUzY5kuZuPlNSzR3E
	 t1MfMUtW0DfNMXOVOxeNDiufnUXin6t0EWAPKz9TYWB7pfAK75wDh/pOawcOtDJ/KVIeG
	 nBQJPDLdnFeadK13jeDfCMfxKTpLOj1q/1yf0mpNlX8pBbYn52vHRUORChxm+YcqWaM/N
	 FEnDxPqTcRi1EhHPwL2ZXapX8AUAsXJqOoFo8kX19SrblPFo4a78h39T02pW426W5V0os
	 UvnQLN5lm+90Ar08alCJ3Hw2mxrFalX8J3S6SLA1Zt4FvsAP2uCVIvTMU2tfW1fdv5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqTGEjK2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8642606A31B;
	Mon, 19 Oct 2026 22:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqTGEjK2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36ECF1F000C5;
	Mon, 19 Oct 2026 22:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792449765;
	bh=tXbwnR2RlCJZXvS7RGs12P+e1RnZcsA+7Uc/5Gfouos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fqTGEjK2k/qk2/XNPXLr8ukixfoWwjB4gtEYaQfxQWiO7jazvPdblIhmtcV/ubSe/
	 XAunHnFhLU8uK2kDBgJt5hDKF98EqfQwe+3OhEr8+UV7/rEePiER9pTy7dYJzx25es
	 a72Xz382QF6geDuUejhjjhH4ezOmf4Es8L2uItUwzMWX5sOKdLue0feow2ju6bw1LK
	 4Aq2XSSp95TOrCEj9YS15xBlA+FlKrLzy4UJOI0I+78tXNTGBiPYI0VfxlROWCvuOs
	 GPzftPlxo16nmUBCFg/mfcOFhDdhx9+wklYbJyaS4LcpR13bXqgg9z87zjAikyFjjr
	 LPCUllYYuBfnw==
Date: Mon, 19 Oct 2026 22:42:43 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atacyPeRJeDiUs1X@google.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
 <CACpmpofN-JfCgJtW9D0wNu0_pL1pRWGfNphUQnE9Bse-P5tHpQ@mail.gmail.com>
 <CAO9r8zO+0h3LLuaFGi6RF02sBYrG71Zf9qMei73UPvRi2onGxg@mail.gmail.com>
 <CACpmpoe+krnso-b1h_g_Q=HzV5x8xpu=Ke9==+4PfWF0ZcAUgQ@mail.gmail.com>
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
In-Reply-To: <CACpmpoe+krnso-b1h_g_Q=HzV5x8xpu=Ke9==+4PfWF0ZcAUgQ@mail.gmail.com>

On Fri, Oct 16, 2026 at 08:53:26PM -0700, Kanchana P. Sridhar wrote:
> On Fri, Oct 16, 2026 at 2:48 PM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Fri, Oct 16, 2026 at 12:05 PM Kanchana P. Sridhar
> > <kanchanapsridhar2026@gmail.com> wrote:
> > >
> > > On Fri, Oct 16, 2026 at 9:14 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > > >
> > > > On Thu, Oct 8, 2026 at 11:28 AM Kanchana P. Sridhar
> > > > <kanchanapsridhar2026@gmail.com> wrote:
> > > > >
> > > > > v1: Batched zswap_store() with compression batching
> > > > > ===================================================
> > > > >
> > > > > This series is a spin-off of "v14: zswap compression batching with optimized
> > > > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
> > > > > compression batching enablers. Resuming work on this series following a gap
> > > > > since v14 (January 2026). Please note that my email address and affiliation have
> > > > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
> > > > > have retained the original Intel sign-offs on prior patches for historical
> > > > > attribution while signing off v1 of this series with my current address.
> > > > >
> > > > > To summarize the main contribution of this patch series: Batching is introduced
> > > > > in zswap_store() of large folios: we carve out a large folio into batches of
> > > > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
> > > > > batch. Moving the fundamental operations that need to be happen to store a page
> > > > > to now work at the granularity of a batch offers opportunities to optimize them
> > > > > from these perspectives:
> > > > >
> > > > > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> > > > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> > > > >
> > > > > 2) We keep the working set for each of the core store functionalities (alloc
> > > > >    entries, compress pages, store pages in zsmalloc) to be focused on a
> > > > >    batch, thereby minimizing cache evictions and benefiting from cache
> > > > >    locality.
> > > > >
> > > > > 3) Along the lines of (1), the main zswap_compress() batching routine obtains
> > > > >    the acomp_ctx mutex lock once per batch, and releases it after it has
> > > > >    processed all pages in that batch.
> > > > >
> > > > > 4) Any zswap store functionality that works on a batch can potentially be
> > > > >    parallelized as a next step, to further improve performance.
> > > > >
> > > > > Performance data: usemem with 60% over-commit:
> > > > > ==============================================
> > > > > Validation was done with mm-unstable as of 10-3-2026 (Baseline) and with this
> > > > > patch series.
> > > > >
> > > > > Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini.
> > > > >
> > > > > Chromebook Diagnostics reports:
> > > > >   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
> > > > >   RAM: 16GB
> > > > >
> > > > > vng setup:
> > > > >          Memory: 7G
> > > > >            Swap: 3G
> > > > >     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
> > > > >
> > > > > zswap compressor:
> > > > >   ZSTD
> > > > >
> > > > > mTHP enabled:
> > > > >   64kB
> > > > >
> > > > > vm-scalability/usemem setup:
> > > > >
> > > > >   cgroup memory.high: 3G
> > > > >   4 usemem processes, each allocates 1200M anonymous memory, reads the
> > > > >   Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
> > > > >   writes to each unsigned long in the 1200M, sleeps for 10 sec, then
> > > > >   frees the memory and exits.
> > > > >
> > > > >     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M
> > > >
> > > > What is --read-silesia? Is this a local change you made to usemem?
> > >
> > > Yes, this is a local change I made because I wanted to get compressed
> > > lengths besides 565, which is the only compressed length of data
> > > swapped out from the original usemem.
> > >
> > > To replicate my setup:
> >
> > Thanks for sharing the details. I am having trouble reproducing the
> > results, mainly because the standard deviation seems to be too high to
> > make conclusions. What is the standard deviation in your runs?
> 
> Sure thing! Let me know if it would be useful to upstream the
> --read-silesia option to the vm-scalability tree.
> 
> Yes, standard deviation is considerable, which is why I run usemem
> consecutively for 10 iterations and report the mean Average
> throughput. I could also report the median going forward if that
> helps. The cover letter vmstats are after 10 iterations. The last set
> of data I reported in this thread after applying patch 8 [batched
> version of zswap_compress()], had a mean of 20,946 KB/s, standard
> deviation of 5,391 KB/s and median of 22,477 KB/s. For reference, the
> stddev for the baseline mm-unstable was 5,397 KB/s.
> 
> I have found this methodology to be reliable in drawing conclusions
> because as zswap_store() performance improves, the outliers are fewer
> and the data is more clustered near the mean.

I think the stddev is too high to make any conclusions tbh, I will
respond to the other thread with Herbert.

> 
> >
> > Also, I tried measuring the latency of zswap_store() itself through
> > bpftrace, and it doesn't seem to change much throughout the series.
> 
> I ran bpftrace today to gather zswap_compress() latency per-page,
> before and after patch 8. It shows a clear performance improvement
> with compress batching for the reasons mentioned before:
> 
> Sequential_zswap_compress  nr_samples     p25     p50      p75
> p95       p99
> =================================================================================
> zswap_compress_ns_per_page  1,722,489  43,947  57,791   88,489
> 130,165   323,961
> 
> Batched_zswap_compress     nr_samples     p25     p50      p75
> p95       p99
> =================================================================================
> zswap_compress_ns_per_page    339,088  42,081  52,633   63,185
> 118,461   191,710
> =================================================================================
>  Latency saving (ns)                   -1,866  -5,159  -25,305
> -11,704  -132,251
> =================================================================================
> 
> Hope this helps. Thanks!

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794241427;
	b=vfUIoa8ykjB6oOHmVrXOWrXOSzRAXw3dQCEHQynM5pWY8QwvRjoxStNMaBLN6b0UAhkX
	 xApOMcBgNjmYmHZcv6JdZ2OLrdxKaHp9jH9p0dG6F4pMKGm9xd4oTfUEh3Qk0SvBv/J3j
	 hAMc7/Y88Zd4LnTzPazo6XxACYjUJ3hMhXpza2MIxgaBZcW1XlMl2wfPYc0IB42jq3Udi
	 DHVQekRhoDYIZbsDh0dKnox4EgA6sOcczOVD5utWD6NfS5Zj1W7Hg6RHUXDf4gejXsHkQ
	 7X3JecF3/fYp5JJJv5s0ThS92CqWltU8XxRZMiaAnMJcDDv15v4z9oZj6lP46+cxQHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794241427;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=jHf22tsdPPfDKAeOIiu4WmAuLGDaW8+V7RxrZhx4qXg=;
	b=rNpkmw2ikMwtNeZrOXZVUubAnUnTdH4OfnwHF+ZK0B4ItIlsu25zGVpbKjNG/8rU6uuO
	 +CFM8T9P0ChCNDnTuC3d2LDUzQeidTqp4VACFDbMds4V7AwyzxSwLBFRTh2h/PGeIK5+l
	 NE7a+o2Y1wM0gi/YsI5XLGHcvrVrXdyU2DD8VDjGxh9pqGW5ejYbee2qGgjsdTZVYSx16
	 UK870HrpcFVHIt5eUkfNbm9tPZw7sL+V4T+swqTt6yHJJKqL7HwavvW2ojIW7KcopNgud
	 Ol7XePOVz8PmGdJtQNCgjPIYUFjQWybUIGyFU0FQz+iW/L8IJCbgPkLptUCTY61jWqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OSyx9BAa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8A0606A32A
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 16:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OSyx9BAa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FC71F008A2
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 16:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794241427;
	bh=jHf22tsdPPfDKAeOIiu4WmAuLGDaW8+V7RxrZhx4qXg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OSyx9BAa9gS4PwuytH0sMUh2QyzhT6ozk6cj07WytrOmwfGLoC3KN8+wL4IsPkOuq
	 wgVG4zxb4RwB9DVXmyHCHLSeoSIKvTTlZ76dxEOgcxdgh5ZVMrJn8kDrYEAtmPICgj
	 HcIX0pl3w2Da+iZvLrqGiSOmus+BORZjtThdpKZxcWwrVxHQ3tcpSVyFpPj3394gtE
	 W/u9WJffOZKTRUz/cmPGbuIut3k0lBJh4Lr4fpD0eyNtl0EUMyMqtkOJKeWLayU18J
	 7bZqP5NO02E3HFuQ9seJ2dkgfPCb0vq+tUoiRTiANl8ZRgEB5+Iv1d7viNOQxetQoE
	 D1SEz81YkI70g==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4d5cb1b181so143654666b.3
        for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 08:23:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGJLhIQsobfznRBqKE/ZupejX3LtVupCgsG4qUEq1tW3wHT4JUEXZo3qdXzk92x0PmeeAdkX1QaFM8t+Ko=@vger.kernel.org
X-Gm-Message-State: APuU4Z8blRjv0Ub0TUsjwlxxMafxlphfscKcj8dULR8fpdgI6uRWIsSB
	fw2oUxm6UVGG06oehXyOYDIKahL4q9kcZSM6fIkTjMZaCmRGsoPQVdc3rLDYzFqdnf93eBC4HMt
	Xq27QaJ9vnlRXtVU/82fesqXxYGL8JVc=
X-Received: by 2002:a17:907:ea89:b0:c3f:7270:10ab with SMTP id
 a640c23a62f3a-c4d6d491847mr331944966b.14.1794241425829; Mon, 09 Nov 2026
 08:23:45 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <au5l3KEjG_mri-br@google.com> <CACpmpoc3R8gwkMouwyFLw9PEqyDN1i6OcmPxsvZ1d0QOPSS_fQ@mail.gmail.com>
In-Reply-To: <CACpmpoc3R8gwkMouwyFLw9PEqyDN1i6OcmPxsvZ1d0QOPSS_fQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 9 Nov 2026 08:23:34 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOVf+gN0nbKkMGraTGhnCOG+5mpNBJvsZ=C5jDOssBf+A@mail.gmail.com>
X-Gm-Features: AclHuK8wGQGw5PDN9FVkkzijzlP7nY0X41Q1fjXtSpx5oni4CF9QZzjxFkOpA7k
Message-ID: <CAO9r8zOVf+gN0nbKkMGraTGhnCOG+5mpNBJvsZ=C5jDOssBf+A@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] Batched zswap_store() framework with compression batching.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"

> > As with previous versions, I cannot reproduce these results. I tried
> > with a QEMU VM on a Cascade Lake host. I saw marginal improvements with
> > patch 6 and no significant gain with patches 7-8.
> >
> > I noticed that you omitted high-level metrics (e.g. throughput), I
> > didn't see significant changes in throughput, and I also ran a kernel
> > build and saw a small regression in some cases (probably with order-0
> > folios) and no significant improvement otherwise. Even if latency for
> > some functions does improve slightly, it doesn't matter if it doesn't
> > show up on higher-level metrics.
> >
> > It could be the difference in setups, or the overhead of bpftrace hooks
> > for zswap_compress() might affect measured zswap_store() latencies, as
> > you will have fewer zswap_compress() calls with patch 8.
> >
> > As advised previously, I would trim down patch 6 to the bare minimum
> > (without all the scaffolding and prep work for patches 7-8), and send it
> > separately (with patch 5), and we can check if it's worth adding, I am
> > still concerned it might be adding overhead for order-0 to be honest.
> >
> > I am questioning the benefit of batching here without HW batching, so
> > far the results are more concerning than encouraging. I already spent
> > too much time trying to reproduce the performance gains. Also, sending
> > new versions without resolving discussions on previous ones is not
> > really productive.
>
> Thanks for taking the time to test and provide feedback, Yosry.
>
> I omitted high-level metrics like throughput since you raised a
> concern about variation. Hence, I decided to go with the "ultimate
> truth" which is bpftrace latency measurements.

I didn't mean that we shouldn't look at high-level metrics, it's just
that the test setup had too much variance for the high-level metrics
to be useful so I checked the low-level latency. Ideally we'd test
performance with benchmarks that should have stable high-level
metrics.

> For performance validation, I only have access to a 16G Chromebook
> with a Crostini VM to which 13G is allocated. I am setting aside 3G
> for swap and 7G for QEMU. Within the QEMU VM, I am selecting 2 E-cores
> to run the 2 usemem processes to minimize variation due to frequency
> fluctuations. This setup has its own limitations such as being unable
> to fix the frequency.
>
> Despite all this, I have been able to consistently replicate the
> bpftrace latency improvements with patch 8. My results show regression
> with patch 6-7, and improvement only with patch 8. As noted in the
> cover-letter, patch 8 adds significant latency improvement for order-0
> folios. This is with ZSTD. FWIW, these are bpftrace latency
> improvements in a significantly memory constrained environment and
> this ought to be a useful data point. I have been posting general
> vmstat "system health" metrics to prove that nothing unexpected is
> going on.
>
> My data shows that order-0 zswap_store() tail latency improves by 11%
> over mm-unstable with patch 8, although p50 is roughly similar between
> patches 6-7 and 8. PMD store latency is significantly better at p50
> and p99 with patch 8.
>
> Likewise, p99 latency of zswap_compress() alone improves by 3% with
> patch 8, while it degrades with patch 6-7. p50 is almost the same with
> patch 8, although patch 6-7 regresses. The page-normalized
> batch_compress() p99 latency is better by 15%. All comparisons are wrt
> mm-unstable.
>
> Hence, I believe even in a memory-constrained setup such as mine,
> batching significantly (7-15%) improves p99 in all cases, with 4-5%
> gains in p50: for order-0 and PMD folios.
>
> In addition to the latency benefits shown through my validation, I
> would like to also emphasize the strategic benefit of moving zswap to
> use batching, as noted under "Conclusions" in my cover letter. IOW,
> batching within large folios to improve workload metrics can only do
> so much (in proportion to the # of large folios reclaimed and
> contribution of zswap_store() to the overall allocation-reclaim path).
> What this patch series attempts to provide is a zswap batching
> framework upon which additional improvements can be built, such as
> reclaiming multiple folios as a batch. I believe that compress
> batching is essential to support these next steps, which improve
> workload throughput/latency metrics even more than simply batching
> within folios. This is with ZSTD.

Without a direct line of sight for such features and consensus from
the community, landing the framework in zswap is not very useful, it
actually increases maintenance burden.

> Due to the environmental constraints, I haven't been able to reliably
> use kernel compilation for validation.
>
> I have been doing my best to resolve previous discussions by
> incorporating the calculate_high_delay() hack that you suggested to
> reduce variation. The data posted in v3 comprehends this suggestion.

Oh I wasn't suggesting you generally test with this hack, I just
noticed that the variance was resulting from memory.high throttling
and nullified it to see what the numbers look like without it. As I
mentioned above, ideally we see stable improvement in high-level
metrics. usemem is already a microbenchmark, if we can't demonstrate
stable improvements in its metrics and have to measure latency of
specific functions, the significance of the optimizations is
questionable.

It's a tradeoff between maintainability and performance. It doesn't
really make sense to add complexity for marginal performance benefits
on a small subset of setups.

>
> I would like to suggest/request the following, as next steps:
>
> 1) Can we reconcile our methodologies for usemem bpftrace
> measurements: # of vCPU, usemem command line, reading Silesia, etc.
> Also swap space and QEMU memory allocation, using linear lhists() in
> bpftrace, etc. If you can share these details, it would be very
> helpful. Thanks again for your time!

I ran a VM with 2 vCPUs, 8G of memory, and a 25G swapfile (although
the size of the swapfile doesn't matter much).

I used zstd with the default pool limit (20%) and the shrinker off,
with 2M THP enabled. I set memory.high to 3G for usemem like you.

I used this usemem command with the diff you posted in the last version:
$ usemem -w --read-silesia -O -b 1 -s 10 -n 2 2400M

For kernel build, I used:
$ kcbench --llvm -s 6.8 --nodownload -j 8 -i 1 -o <PATH>--detailed-results

I don't have the bpftrace commands but it should be pretty standard (I
think I used hist() not lhist() tho).

All that being said, I don't think I have more time to spend on this tbh.

>
> 2) Does the kernel community offer servers for contributors to test
> their optimizations at scale?

I don't believe so, but I am not sure.

> 3) Can I please request the help of other zswap maintainers/reviewers
> to validate this series with ZSTD on a server setup with usemem
> running on 30+ cores, under high over-commit ratios; through bpftrace
> and/or throughput metrics.

I can't ask people to spend time testing this, I already spent more
time than I have and I am sure other people are also busy. If someone
is interested in testing this and collecting performance numbers, that
would be up to them.

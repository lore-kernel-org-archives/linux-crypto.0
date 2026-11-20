Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795216606;
	b=CMcYp4zCBYtzK3/7J1Jy645n48VBBDtYnYCTmGmpv37TY67glvun4B5M9Z6u6ToZ5xcn
	 l30Nui8AzOVSou6K6r//Ti/zfEZOd7kSeoS42xg5PDQgC1I8RmlMwoRSFi7qmtj3sNMBs
	 k07NokW5UKEVmbOk18o3FF37SDTWDy8Bwvq4K7hgBs7cHGWO3vzPcpFbt+Wyk/wMMCF4S
	 uN/mXlcokEeCzrwUnKxKfkh71D8DFNKiVPsKHCCQT1h+weNIFNLgOMV3dLNtonLY5gxXr
	 MuGcjnz/igROazLwveH0JrRst39+dPRIK9/dGXopHQgKMtOXeSrq+JDviXwEgT07R6Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795216606;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=903vcvaogj9vIydiu/9sjTQzb/qPcKkDK3/+mqHxV6A=;
	b=t2AO5/koATq5EADQhGoSsz2muiJKpjU1NRzybTz+EtTZ7zAX9rcJYZPEqoLmh/ZMxvA7
	 5nchrgyVY50dhOdt4Pul+woX9INjFBtth2BFdkdtGs7ic20rFKq2U0viJeXEbwZVfExUn
	 sbfq017hblW1wQSu3HqICjSSHjfUeM1H/ksWauSsoTjVjLqSUSZM9+2kgvbHph39/UF7W
	 bBmxk+a+py7NcndEa33ljlrvpDgPvsABdZaz3gE8BYYZ51LdZ5Rnts/NCmW27ju7ts91d
	 FT3xhr7DTJQ0k0EnHyO5V7XqZwzAeMKUwiqgYnE2nQeQTPr8WcX2/IYjakD65JPvEdw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mGHK6HkC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269AE606A695
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 23:16:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 269AE606A695
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mGHK6HkC
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so13212245e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 15:16:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795216605; cv=none;
        d=google.com; s=arc-20260327;
        b=ToP3DtQSY+lSojaPS4b3uXO5vZg3nhs4x76f/FJZJs1GAUuFkt5z5Y/AMn7fclGFgj
         ub3n5Ign7pix1V8bKpvoxKEjOSJitnlupYkt6JU9qUt7xT60cEgPplQa0ZDy6CzGr/vi
         34HKJA5QegE4cGJhsI/6EvYhHv+wDOT2PEDgK2BIXUZQ6e8dPvKdXl8rOB2d4e9j+hVU
         jXGcOr6oRR3sZL8Z3TjFEiKOib/2T/6/HoA0RdlLR69nK8shvpyPSBQDi/vJQ50Z1H3w
         KspKl/w2/t/Ga+UF9neqKTBUxt2URPOwbks5ogFnzGZCEjQn9mGeP/WxoL2nnKOGP5Kc
         SpWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=903vcvaogj9vIydiu/9sjTQzb/qPcKkDK3/+mqHxV6A=;
        fh=O3KUGrXN/I5yBvz9I3TGYobHvOJbWl7gTH7huc0LkYA=;
        b=shokueiyxOP29c/NuIz6+0BdVA6f84G315fc1jNNkR53Terz8VFKghusPiKA7yQ9cy
         hhzvvSWMVcSjg8kTUhxNCs/XLNYOGT+rMgl5BhpFY23B41IB2DVpw7ZY5n8Qbo+y2VWT
         2HSt+pxUslEV9BJzPDYF+MlrX/JEt42E6ZHgo1fXDxgfT1eke541zs2IT0aVuPDvZHLU
         HgyF3E4FHeshUnTZlywHrqTupUZQpCXmet2uMQpbvDk96dQsfIkRWBfmk1DStm5fGu3x
         zYLmuXnkDrf7R4vMDcV57I7/nGDSmj2bYyYTa14CYlljLERbkOijYFV3vMndzwpWMSC5
         Updg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795216605; x=1795821405; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=903vcvaogj9vIydiu/9sjTQzb/qPcKkDK3/+mqHxV6A=;
        b=mGHK6HkCbSVQ39UCpesRtbsGfQNIK83yzGTreb091TXMOf4FPM1COKmFg0cjrJPs4G
         1flQTelx/F2UydcKnpCSZ41r3mz6hlsvSMHKy5kl0YL/lgx13KbFUgmHhIGji1LGTVWX
         35zhtgZaGrBrurStYi2nwFpANzq3eDhX6fecisyyDdKCc4SbOGpbYrbx7hFKPl6YUIu2
         IYWQNuOSsxOsC1+SwZRYcXV4iChxGXYpHuM9uiDmJHeKsW7sBcvTv3SGmPTyovnMD/sk
         /y18nNdkdOILxdAIpU7p1j2EAvyi8EkWa41skgvdUt+Zrbasyx0DBkOLDZ08iR/ePzlx
         KfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795216605; x=1795821405;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=903vcvaogj9vIydiu/9sjTQzb/qPcKkDK3/+mqHxV6A=;
        b=YLCX73TYqBcGZjJVlXQ2YM0kVQ3HQklOkAnOzCp0yXT/qpP4GWPR/g19iZ/TqxNQXt
         XhzYdDBeWwwCDkpHOfxugpXwlMxL/NwhUK2mvsmbYtOOEMJEZT2ZCopYudtfET0Ipye5
         /B/lc+Sw8Cg7QGIHcqjYSA7abNwFvN2R3IT76c3kd34ZwJdLZGVtWyOZgqqPkWIeixQO
         sTL5mhqrLll2Z08zkTSZ1rKcdnhsTOYJ8BsfFFZ98Brk60gnMJGbjPvxRQAJaDCHEYUr
         Jntj5cMBtuLFmTpGibw/+Fv/JgPyttm69srtTIHSHOScYmXCE8A8IAraG07XZsJl/EoS
         3nIg==
X-Forwarded-Encrypted: i=1; AL+hErFVT7L47+N8hZC7TGAyNpp13WhSf4k6O9QVQGmRZKWgrLrWoFhrk+M3tc4Wxf7AMoNEWz28MlfGDdUgTDk=@vger.kernel.org
X-Gm-Message-State: APuU4Z89VWPv1RqoqxXdIyWyIEbrZBRsY0q6rkSN/IPQGEQXVSoLFYSU
	3nnocnm2iXUqlo2L/I+L+YW7b+TULnPA7zlOnRo/OeVt10+ixySw/MM0bkAw4shvKrFq/mqF59t
	Mduz4Rh1imK+teYTzYxP/Giyruk5PBSg=
X-Gm-Gg: AYBFou33pc/dMfLDg/yEM6kYd3O4vcunjB3jSynUk8dI6RAjbh7KgevffsBxon1jbng
	5vs7HY/V6uOBjfZALAgig9a+VCA33NkBPTq+tA54IPDQfVtZuK9befSslOPkxi+aawYUrM4BFIf
	eYH+hbp/2LXyJQgUGWQNv4mGIA/1Bzitn5lghEKEqCBWnL82nBd/08xJp6VZqUwrAl+QwvIbmAQ
	nTurzr0nM63A3m83ew2+1MECcRsc3CQ4Pd0OABKxBctKV8cUTD9ceVmKYRiBFSs4s0pN1XlVwS6
	RjzB+NVFV6G5+DBoj3Ni0Ov5GVQZGh+P/0nya4sn/LKG27aJWFTHaiZyB0CxC1+urMY5cUNBNhn
	MEIoadXdkpMIMsn/MrZJDkTsbhLpHJZ9d2CCamNtDoyo1OS+fUiXzDzC858QSBG2QGZuH29O7gG
	xjLg6HpSJIm4UDyiBt2ocIOUR8rbDqFDhIDwSo2efqz2ndElMzALZ7go4=
X-Received: by 2002:a05:600c:4f0d:b0:4bb:5c97:f4b1 with SMTP id
 5b1f17b1804b1-4bb8881941bmr114007855e9.24.1795216604602; Fri, 20 Nov 2026
 15:16:44 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 20 Nov 2026 15:16:32 -0800
X-Gm-Features: Aa3M54qb-VRfw4aqDAJTkRsfWHOO2NSgtOCHUwUBMLX8ioDWk9vsNXzApVwB4Q0
Message-ID: <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
>
> v4: Batched zswap_store() framework with compression batching
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> This series is a spin-off of "v14: zswap compression batching with optimi=
zed
> iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
> compression batching enablers. Resuming work on this series following a g=
ap
> since v14 (January 2026). Please note that my email address and affiliati=
on have
> changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.c=
om. I
> have retained the original Intel sign-offs on prior patches for historica=
l
> attribution while signing off v4 of this series with my current address.
>
> The main focus of v4 was to establish a performance measurement methodolo=
gy to
> quantify the benefits to high level metrics by using zswap compression
> batching. This was done using an Intel Sapphire Rapids bare-metal instanc=
e with
> 48 physical cores and by running "usemem30", i.e., 30 concurrent usemem
> processes, each of which allocates 10G, in a 150G memory.high contrained =
cgroup,
> for 10 iterations. The environment was set up to minimize performance jit=
ter so
> we can understand the system-level/workload-level advantages of zswap
> compression batching when running workloads at scale.
>
> To summarize the main contribution of this patch series: Batching is intr=
oduced
> in zswap_store() of large folios: we carve out a large folio into batches=
 of
> ZSWAP_MAX_BATCH_SIZE (4 pages) for software compressors, and store each
> batch. Moving the fundamental operations that need to be happen to store =
a page
> to now work at the granularity of a batch offers opportunities to optimiz=
e them
> from these perspectives:
>
> 1) Utilize existing kernel API that minimize obtaining locks for bulk
>    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
>
> 2) We keep the working set for each of the core store functionalities
>    (alloc/initialize zswap entries, compress pages, store pages in zsmall=
oc,
>    pool/objcg reference increments, objcg charging) to be focused on a
>    batch, thereby minimizing cache evictions and benefiting from cache
>    locality.
>
> 3) Along the lines of (1), the main zswap_compress() batching routine obt=
ains
>    the comp_ctx mutex lock once per batch, and releases it after it has
>    processed all pages in that batch.
>
> 4) Any zswap store functionality that works on a batch can potentially be
>    optimized via bulk-processing/parallelized as a next step, to further =
improve
>    performance.
>
> Performance testing: usemem30 with 100% over-commit:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> Validation was done with mm-unstable as of 11-17-2026 (Baseline: commit
> 866f761fd414) and with this patch series.
>
> v4 was validated on an Intel Xeon Sapphire Rapids bare-metal instance wit=
h
> 48 cores.
>
>  Bare-metal instance specs:
>  --------------------------
>  - 48 physical cores
>  - 190G RAM
>  - 200G SWAP disk partition
>
>  Workload: 30 concurrent usemem processes, each allocates 10G:
>  -------------------------------------------------------------
>  The vm-scalability "usemem" test (unmodified version) was run in a
>  cgroup with memory.high fixed at 150G. There is no swap limit set for th=
e
>  cgroup.
>
>  To quantify the performance benefit of zswap compress batching at scale,
>  30 usemem processes were run ("usemem30"), each allocating and writing 1=
0G of
>  memory, and sleeping for 10 sec before exiting.
>
>   usemem -w -O -b 5 -s 10 -n 30 10g
>   echo 0 > /sys/module/zswap/parameters/shrinker_enabled
>
>  Performance validation methodology:
>  -----------------------------------
>  These settings were used to minimize variation:
>
>  - All cores were fixed to run at 2.4GHz with "performance" scaling gover=
nor.
>  - Turbo boost was disabled.
>  - CPU power-saving C-states restricted with:
>
>      GRUB_CMDLINE_LINUX_DEFAULT=3D"intel_idle.max_cstate=3D1 processor.ma=
x_cstate=3D1"
>
>  The usemem30 experiments were run with the baseline mm-unstable as of
>  11-17-2026 (commit 866f761fd414) and with this patch-series.
>
>  After booting into each kernel:
>
>   1) Constrain the cgroup's memory.high to 150G.
>
>   2) Run 2 warm-up iterations of usemem30. Don't use this data for benchm=
arking
>      since sys time typically skews higher for initial runs.
>
>   3) Next, run 10 benchmarking iterations of usemem30:
>      - Log these high-level metrics: Sys time and individual usemem throu=
ghput.
>
>   4) Sys time and Throughput metrics were gathered for three mTHP setting=
s:
>
>      - 2048kB
>      - 1024kB
>      - 64kB
>
>   5) Benchmark summary data includes Sys time and Throughput components f=
rom the
>      10 iterations of usemem30:
>
>      - Total Samples
>      - Mean Value
>      - Std Deviation
>      - CoV (Variance): Coefficient of variation (relative standard deviat=
ion)
>        measures spread relative to the mean rather than statistical varia=
nce.
>
>  An LLM was used to help generate the benchmarking and data processing sc=
ripts.
>
> usemem30 Benchmarking Summary:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>
>  ---------------------------------------------------
>     Improvement with v4 zswap compress batching
>  ---------------------------------------------------
>   mTHP enabled:       2048kB     1024kB       64kB
>  ---------------------------------------------------
>       Sys time:      -13.87%     -2.64%     -1.72%
>     Throughput:       +3.85%     +0.42%     +1.31%
>  ---------------------------------------------------

Have you tried perf-ing the store path to see what was the overhead
source (before and after this optimization)? I'm curious.

Mostly LGTM - still taking a look...

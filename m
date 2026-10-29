Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793308164;
	b=XqGtERCPxiGCpuEEAEc76xxU3QjDKN8EKAAG1oWMICNXjVWczY+tbb2OscY4c4LYsmaf
	 34iv6j+t9I2KSCRQm9SHPIVGlDG58KPAlgSNcT12ozLgVjKtF6ktE1pp4DCrt/PMUxGsS
	 qluq7AujnqfFjFgJP6QhP68Cc8Q1VX47pyXpejT1tX6wuJXl6By2koBu+nsDuuw0EtbII
	 QgJhOJZisVGdEWhf1ejAjQl2gO2CDjuCJLIzsQW0P/e/21VBGDbivc1CYUlTmw/uO+OCe
	 y2b767vC2Ds1pF2qfddEMO6DiYfkCxjk0K3dXFdvWrmdPd6LWM8kqkPP7iCBS8ZdJMA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793308164;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=7kYdsdZrgEIyd8GSLnE1/erB4mjt9X79rFFJFtO64kU=;
	b=pJCOlICsoccNfeivHC9g5DWx8Nz/IvFH2dyDs8XKp6bbIEik8z5NTVlP1Sc+0zOn4Ymc
	 XqKEvFMj5iCzmPgnsBPFmjjEH1fGo0N0+9+e7kvVdSoxBmBrzz5bbu1xy1vCnohP2dxRE
	 S8mHCcS9kNpt6xLrzWuw9y53E3eSq24AKxSSxEW6oyMIcl28N90/RvMFYZ3aiU/lKtzCB
	 12dm7OS5Megu9SN2JAi3MDBHYGs0/l0WXfMOUeMvFCHhuwkZVt2vT7kSX92cAOUuKLSh6
	 9v2k4IeefMyajDKil7nUG/1r4U7RidG53KL6c+6OR7NMuSmntcR+ZHReOgYgc90UPVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GJkAPnXc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.178
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F9C606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 21:09:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8F9C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GJkAPnXc
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3ab3dd966e1so839991fa.2
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 14:09:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793308162; cv=none;
        d=google.com; s=arc-20260327;
        b=VBX57PAAB+KGZvmdeePGmqm1wi3uu/ST69TGWsfkkZIUPJzMaDWn5cwhhBOhdZL2gz
         6wU3jTs71eBPEhCXkIXghQfAK6Lc39a8QlY0OKoeSvCvvAgYCOwl6Lq7jSHmtoSNlG50
         OO7th2RziF8LN2ch80Rtl+jFcPGVss6aeLctzIgPpWR6An5HKGcfw4Y9W/O5Ve0IdtfF
         iEmWqwvzkbNYxb5lVNVkZqunBJvqSAN70gskbvwdxCxXqBg0bhpv+RXaCuC5VdO9wq9I
         FmeVu3rfEeDHHZ1Y1p4WVyv2uC55y001AEiuXU6LMS5xUv+R5tpZtwfYKNiL6MJCLoyc
         5GNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7kYdsdZrgEIyd8GSLnE1/erB4mjt9X79rFFJFtO64kU=;
        fh=slv+58FBjjgt5nTjpaV+NzKQurok9KC5vlYhlAh0tYw=;
        b=ARjHdIPP9tFLrpJLjaNHTrBnL4W91lASZ60WABjsEkDYXjsPCPL2WWHeBWPef/o6/L
         srFbYAEfhDipJiS5lflplKE5Z4dmzCt7mUZ5fJIhkugq+4/eBHnQpBiZ3chopJ/SylFt
         58KyMs+AdPUsjnV/nFv/Ip+TDvQufDxFLQtqHqZoV0BVXP/025PtZU06KcOPk2jEYTn2
         vEPI7yWbmbuc4N24aT9zImpQ1V44tZDmOjyLSMsRpbo8Q56KlRWWqdYK1APMdhPwiX88
         wSXpekCQcMyuv9AhD/pnIC3nvFldXZw/XUbB+O7J7C8WkHXtSOEQE5x42OSQA+7K+6e4
         /48A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793308162; x=1793912962; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7kYdsdZrgEIyd8GSLnE1/erB4mjt9X79rFFJFtO64kU=;
        b=GJkAPnXcrUi4h3HatzovAOMoP85xhYxV+kQ182b3TNTPH0iqgpnF6S5IoS8oi85qCj
         AEWDm/91aA8JzjZ4XxxalQfl52S6vLsJsmbiLxbm7FJ46Xilk4ErlDXMjsvgNALPscpw
         T6IQt4u55seGSlBgG+qwSB4NSgN14WnH5bwqhnGqzJqOvuTN1XkJmuJVbA7TEpDT0TS+
         cWT84erM4hEdWlDbi6Mr/oc7U8Os+HjXFkOv6HnfY48ZCFLEI5YwTZxVR/028mGseeWR
         65rRGsRANfSGQUyGGK8aKqc/aZ5XfxGpRhzPyLRKXWxt0pMnQNcKByLrEX0USnASjDSU
         GiDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793308162; x=1793912962;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7kYdsdZrgEIyd8GSLnE1/erB4mjt9X79rFFJFtO64kU=;
        b=ZUKOeoek2dp2rFS3+KryPCkYl3mxFmXHbDiFZAwQL8PQEH7QzV02xmYorgFx/wqQb6
         kkHgcn/cacqDGqMYjt17pvXOf5xj5viNoEsXE/ZrW2IQkI9BFTIR5wTnv1n8aUAimTPx
         YK2w5Wnms3VipT1t6/qXybWfrA8VfZbDTFhuxgge4Mt7lqq20EG2wjM+qFwtNNhbM3q/
         1kKn/+k8QKb8XyOFfXI2TbrUje1EQfSxpzzvU3J/2n5sBqRmzIwhI+1cnTnJB1UtBEAT
         I65sBB+yhEBXYCFKc+5k2BfRtEqkljzDYvBpcW8k4L2oO1pib7RqgwMB787tBWO1yW82
         nhAg==
X-Forwarded-Encrypted: i=1; AKwUvBy9rlWI4jDDxv+hhdP4DrTJlJMjwelVMmaYyQaDdB9zKZoohtllqd0eN9LsG5Bga48nC0hjokv4GlEY2YY=@vger.kernel.org
X-Gm-Message-State: AFq9FYJKzj1AXKEdaOkL/vbi1ZFjD4hVBeqvs7ZOwZiuVR/TyVI05Ozc
	hyntLgQOkb+vpBJKR18TQWHX7Etm/Dj1BgA9ufdSUBhcMvLlqVHixQJSppuoVaIX7sb6pxOCegD
	BfbmEIcyDXCL0j976rOQOKAQe1hkLGHYyeQ==
X-Gm-Gg: AYBFou2YkT5KjYzUSNbKRArckuSJvtrUCbfn4ndlm/ok0auvGVSxE9GfEn0B0c/5Y01
	xE3v+kwRaCB/qfwdednMKwpVZES/owrVT01ZHyPJUHm5OWORePavpXrboIfMplYx0Ogop1A2Hv+
	uNiS8gzGtuwbIqSQPUDWik4J07EIaUgpeT3jQPtBCCwSN6jRfjaupdacqGXvgVqlwA8OrPrIjag
	nJTm+zx3d2JRURlma2JB0CcSlAgCLzaEKVxikLr9J0Iw/4zq2PR6ch7esJF6zHz2mF0d8XjhbVj
	kS36/C0duy6ujx6Dngz7ELUNJm/XmWPMUyVsh4IVHlfLf6vrzHgAOGJXPG90esKFYnrDKdnXdoD
	Gje0IRZFHhCHa3iCIloygXaub+CRIw4ztjWGo
X-Received: by 2002:a05:6512:a94:b0:5bf:b246:87a2 with SMTP id
 2adb3069b0e04-5bfd957b610mr43125e87.10.1793308161793; Thu, 29 Oct 2026
 14:09:21 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com> <auOZBtRqQGzFcbAT@google.com>
In-Reply-To: <auOZBtRqQGzFcbAT@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 14:09:09 -0700
X-Gm-Features: AclHuK-m7JH-ZqoB-jo0yDD7-BAXHkWcLwROF3ZmF0vmqG3Tfo8M-MSswHjw2Rs
Message-ID: <CACpmpocqHHa4z9hkZ6YEm-wmzMqSX5WpPLfku7Om=NenRq_05Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Batched zswap_store() framework with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 12:12=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Tue, Oct 27, 2026 at 08:04:55PM -0700, Kanchana P. Sridhar wrote:
> >
> > v2: Batched zswap_store() framework with compression batching
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > This series is a spin-off of "v14: zswap compression batching with opti=
mized
> > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zsw=
ap
> > compression batching enablers. Resuming work on this series following a=
 gap
> > since v14 (January 2026). Please note that my email address and affilia=
tion have
> > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail=
.com. I
> > have retained the original Intel sign-offs on prior patches for histori=
cal
> > attribution while signing off v2 of this series with my current address=
.
> >
> > The main focus of v2 was to establish a reliable and accurate performan=
ce
> > measurement methodology, that addressed the problems with variation in =
v1. This
> > is accomplished and used to validate v2, by reducing usemem to 2 proces=
ses and
> > enabling PMD THP. As the data shows, we get exactly the same "2048kB-zs=
wpout"
> > counts in the baseline and with this series.
> >
> > To summarize the main contribution of this patch series: Batching is in=
troduced
> > in zswap_store() of large folios: we carve out a large folio into batch=
es of
> > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
> > batch. Moving the fundamental operations that need to be happen to stor=
e a page
> > to now work at the granularity of a batch offers opportunities to optim=
ize them
> > from these perspectives:
> >
> > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> >
> > 2) We keep the working set for each of the core store functionalities
> >    (alloc/initialize zswap entries, compress pages, store pages in zsma=
lloc,
> >    pool/objcg reference increments, objcg charging) to be focused on a
> >    batch, thereby minimizing cache evictions and benefiting from cache
> >    locality.
> >
> > 3) Along the lines of (1), the main zswap_compress() batching routine o=
btains
> >    the comp_ctx mutex lock once per batch, and releases it after it has
> >    processed all pages in that batch.
> >
> > 4) Any zswap store functionality that works on a batch can potentially =
be
> >    optimized via bulk-processing/parallelized as a next step, to furthe=
r improve
> >    performance.
> >
> > Performance data: usemem with 56% over-commit:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Validation was done with mm-unstable as of 10-25-2026 (Baseline) and wi=
th this
> > patch series. To minimize variation in the data, I made these changes t=
o my
> > performance measurement methodology:
> >
> > 1) Reduced the number of usemem processes to 2. Each process tried to a=
llocate
> >    2400M, in a 3G cgroup memory.high budget, effectively accomplishing =
a 56.25%
> >    over-commit.
> >
> > 2) Increased the runtime of the workload to ~9 minutes by enabling PMD =
THP,
> >    i.e., 2048kB mTHP folios.
> >
> > 3) The use of PMD THP forces zswap_store()/zswap_compress() latency to =
be in the
> >    critical path, and thus enables very reliable measurements with bpft=
race.
> >
> > 4) I used lhist() instead of hist() in bpftrace to gather latencies at =
a finer
> >    level of granularity and accuracy.
> >
> > Testing was done on a Chromebook with a QEMU "vng" VM running in Crosti=
ni.
> >
> > Chromebook Diagnostics reports:
> >   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
> >   RAM: 16GB
> >
> > vng setup:
> >          Memory: 7G
> >            Swap: 3G
> >     Pinned CPUs: 2 (E-Cores: 2,3)
> >
> > zswap compressor:
> >   ZSTD
> >
> > mTHP enabled:
> >   2048kB (PMD THP)
> >
> > I used the help of an LLM to write the bpftrace data post-processing sc=
ripts
> > that generate latency percentiles.
> >
> > vm-scalability/usemem setup:
> >
> >   cgroup memory.high: 3G
> >   2 usemem processes, each allocates 2400M anonymous memory, reads the
> >   Silesia dataset [2] from a pre-fork-allocated buffer into the 2400M,
> >   writes to each unsigned long in the 2400M, sleeps for 10 sec, then
> >   frees the memory and exits.
> >
> >     usemem -w --read-silesia -O -b 1 -s 10 -n 2 2400M
> >
> >  usemem metrics are reported from a single run after starting the QEMU =
VM.
> >  Further, I have tabulated the bpftrace p50/p95/p99 latencies with thes=
e labels:
> >
> >  "zswap_store_higher_order":
> >     zswap_store() of PMD folios.
> >
> >  "zswap_store_order_0":
> >     zswap_store() of order-0 folios.
> >
> >  "zswap_batch_compress_per_page":
> >     zswap_compress() per-page latency of store batches generated from P=
MD
> >     folios.
> >
> >  "zswap_single_compress_per_page":
> >     zswap_compress() per-page latency of order-0 folios.
> >
> >
> >  ----------------------------------------------------------------------=
------
> >  usemem                       Baseline      zswap        zswap   Change=
 with
> >  PMD THP                   mm-unstable      store     compress      com=
press
> >                             10-25-2026   batching     batching      bat=
ching
> >                                         (patch 6)    (patch 8)         =
 %
> >  ----------------------------------------------------------------------=
------
> >  usemem process 1                6,353      7,240        7,428
> >   Throughput (KB/s)
> >
> >  usemem process 2                6,352      7,236        7,422
> >   Throughput (KB/s)
> >
> >  Average Throughput (KB/s)       6,353      7,238        7,425        1=
7%
> >  ----------------------------------------------------------------------=
------
> >  usemem process 1              484,580    308,903      257,230
> >   Time to free memory (usecs)
> >
> >  usemem process 2              518,928    438,585      446,958
> >   Time to free memory (usecs)
> >
> >  Average Time to               501,754    373,744      352,094       -3=
0%
> >   Free Memory (usecs)
> >  ----------------------------------------------------------------------=
---------
> >
> >  ----------------------------------------------------------------------=
---------
> >  usemem                          Baseline        zswap        zswap    =
   Change
> >  PMD THP                      mm-unstable        store     compress    =
     with
> >  BPFTRACE                      10-25-2026     batching     batching    =
 compress
> >                                              (patch 6)    (patch 8)    =
 batching
> >                                                                        =
     (ns)
> >  ----------------------------------------------------------------------=
---------
> >  zswap_batch_compress_per_page (ns):
> >                          p50                                 40,086    =
    1,569
> >                          p95                                 54,689    =
  -64,505
> >                          p99                                 83,248    =
  -88,488
> >  ----------------------------------------------------------------------=
---------
> >  zswap_single_compress_per_page (ns):
> >                          p50       38,517       38,352       36,650    =
   -1,867
> >                          p95      119,194      121,174      133,678    =
   14,484
> >                          p99      171,736      158,601      169,010    =
   -2,726
> >  ----------------------------------------------------------------------=
---------
> >  zswap_store_higher_order (ns):
> >                          p50   21,012,222   21,322,885   20,176,667    =
 -835,556
> >                          p95   25,643,500   26,204,375   24,485,000   -=
1,158,500
> >                          p99   28,567,400   38,577,750   26,158,000   -=
2,409,400
> >  ----------------------------------------------------------------------=
---------
> >  zswap_store_order_0 (ns):
> >                          p50       37,601       36,994       37,568    =
      -33
> >                          p95      123,731      137,034      128,366    =
    4,635
> >                          p99      159,965      169,282      175,618    =
   15,653
> >  ----------------------------------------------------------------------=
---------
> >  vmstat summary:
> >  ----------------------------------------------------------------------=
---------
> >  zswpin                         1,104,226      993,412    1,091,146
> >  zswpout                        1,688,181    1,582,664    1,669,671
> >  2048kB-alloc                       2,500        2,505        2,500
> >  2048kB-zswpout                     1,535        1,535        1,535
> >  2048kB-swpout-fallback               927          929          875
> >  ----------------------------------------------------------------------=
---------
> >
> >  Detailed vmstat & zswap stats after workload finishes:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> >
> >  ------------------------------------------------------
> >  usemem                          Baseline        zswap
> >  PMD THP                      mm-unstable     compress
> >                                10-25-2026     batching
> >                                              (patch 8)
> >
> >  ------------------------------------------------------
> >  vmstat:
> >  ------------------------------------------------------
> >  pswpin                               0              0
> >  pswpout                              0              0
> >  thp_swpout                           0              0
> >  thp_swpout_fallback                927            875
> >  swpin_zero                           0              0
> >  swpout_zero                          0              0
> >  zswpin                       1,104,226      1,091,146
> >  zswpout                      1,688,181      1,669,671
> >  zswpwb                               0              0
> >  nrswpin                              0              0
> >  nrswpout                             0              0
> >  pgmajfault                     173,554        173,774
> >  nr_free_pages                1,753,879      1,755,195
> >  nr_free_pages_blocks         1,651,712      1,667,072
> >  2048kB-alloc                     2,500          2,500
> >  2048kB-zswpout                   1,535          1,535
> >  2048kB-swpout                        0              0
> >  2048kB-swpout-fallback             927            875
> >  2048kB-swpin                         0              0
> >  memory.current                 352,256        499,712
> >  memory.swap.current                  0              0
> >  ------------------------------------------------------
> >  zswap stats:
> >  ------------------------------------------------------
> >  pool_limit_hit                       0              0
> >  written_back_pages                   0              0
> >  reject_alloc_fail                    0              0
> >  reject_kmemcache_fail                0              0
> >  reject_reclaim_fail                  0              0
> >  reject_compress_fail                 0              0
> >  reject_compress_poor                 0              0
> >  decompress_fail                      0              0
> >  stored_incompressible_pages          0              0
> >  stored_pages                         0              0
> >  pool_total_size                      0              0
> >  ------------------------------------------------------
>
> As mentioned in the previous version, I cannot reproduce these results,
> mainly because the noise is too high. Digging a bit deeper, it's because
> the throttling from memory.high varies. Hacking in a change to make
> calculate_high_delay() always return 0 (no memory.high stalls) paints a
> clearer picture about throughput improvements from the series up to
> patch 6 and patch 8. With that, I see 1-2% improvement in throughput
> with patch 6, and almost no improvement with patch 8 on top. Similarly,
> for zswap store latency for high-order folios, I see a slight (~1-2%)
> improvement with patch 6, but almost none with patch 8 on top.

Thanks Yosry, for sharing this. Let me also see if I can replicate
this hack on my end, and its impact on latency.

>
> In order to make meaningful progress, can you send patches 5-6
> separately? I assume that 1-4 are prep for 7-8, so 5-6 are standalone. I
> also think patch 6 will be simplified if we drop the prep work for
> patches 7-8?

It shouldn't be a problem to send patches 5-6 separately, but I would
like to measure the latency impact with the hack and confirm the
latency results in my environment, so we can figure out a plan on how
to proceed. Patches 5-6 alone only achieve bulk allocation of
zswap_entries. It could be possible to bundle in patch 8, which
generalizes the store batching framework, but let's revisit on how
best to make meaningful progress.

Patches 5-6 have a dependency on the batch_size for allocating
acomp_ctx resources, which is for the compress batching improvements
in patch 7-8.

>
> Also, PTAL at Sashiko reviews before respinning.

Sure.

Thanks,
Kanchana

Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795853393;
	b=eNBIKERcb8Z2vzz2ZTWiJMGyiQxJp2iKs4LTtzLJ1nyCDEpzRgJN6iUFR0acMctW2TJZ
	 CXAAyGkmzr7R2itcvE3CX/p+KwMj/4QVZiIth88gB+j5axcRFOOBTehqOOTidJyKhTqai
	 iZnuFqmT4ZhEeIpaHyfxPEmtcWqL1gwikq9W3aKDb7wTiabzpexgmSPcoDvYJ8EPSM82d
	 eF3p+Usf5Dl39NY3wq+zUQkJxYKGxCwaVnTtrYtWHuoW637JrnUibecRkNBZL9SUKntLk
	 EjjUl3rlUiF3+jepqihUSDD61d3oALTXa9t/nwTBYnPDGwQdCOhPLL+xrrZiq9PEyrw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795853393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2ulowdNAh4XwLKfaFs7pTuNCELaY3qcxAbIhfl2cRjc=;
	b=NoX1BusDbvVflVPDxZXC0TVgfqofXQXWUsgZ5JSzZQd/EqgorLrzk8pOqWyTQne0m4CY
	 1/X2TWdlRHbUfWhQxbZmfI2SfvWvhEDmfcBZMr9SEYIbAEpQ5fPi/VbF0fs/x27JETkUJ
	 fxRFFAN6zTJMhMK1WzYiHI58uLag4xl8dHNd5rYsmgUhMdy9hqxdXfZILSrEWf98Pgu2X
	 GXW7yX9Kg9hMTnsnMdO93BupoRywzH+9UBYh8HWSX8UgdLJ+gSiqpiycVgVDQ247eJEQN
	 ZL4F2MkM0IrPYmJk26a0VTM71mBKw8pI6v9BoHTPKYAZ8IxPfigTAvzd/tNFQJH2WmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FDw5q33F;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.178
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC492606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 08:09:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC492606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FDw5q33F
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3ae85add512so74132521fa.0
        for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 00:09:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795853391; cv=none;
        d=google.com; s=arc-20260327;
        b=Pu+NDRgpcQIKe0iQEQSOfssaQZATIciuIcJCTPj1p9lObUDhpw3GEjS1+7zKGB9UFf
         KX5yqJW8T3TN9Hu5eJnwXH9S2R88m+ezCPQUPaOtvb+8nGfwo4t941Ud9hficMvN58u7
         mKidIphmRqc3pqJl+260oWtvNHkYZ/gXBPYsWfo7r3jQBiLaDyBhqsgpUXwsP8lipqkb
         CQ6FS3cAWOOuVO4b9Ls2o+sF9OsgeqbJFK2R1Hm15TdXSYYyO5ZycgoaJWAhp22dipQp
         1y4TPBoQhGBus2Cw2g4D3NE3XcTeWu9jO6xK6NzAzAafSxPM1/9SLvUO6f/qILHS40nn
         DphA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2ulowdNAh4XwLKfaFs7pTuNCELaY3qcxAbIhfl2cRjc=;
        fh=YDXAb2WEtmAcJ0QcjiZLUqd13pH+/Q55Flc2hPTEbrk=;
        b=bL5x5v0udbBxwYZ4s6JvJp4T0BbrjvbJQrZZeRKHztMFsQDT3Q35xaSsedBpVYf6EK
         dOA2UXG/F/G9KM2TKXrA9yrVA72mrIWPSh76+8bGJe44PpAn5/pIvUOC3WrjT+psClb2
         WyPmkWLmwmHNwHFLkAAapSzW6E+sqb4Yyy65BqK2dLPl4pawE+NHvWuV8W8cgbjsquoM
         +wwVXpaTtWS9NAHzdEigwCLTSavuqEPtMh5SbuQBT94Q8WyjspOAc+VQjb3FVETG6Svk
         e8um9VsjkHANFKSthlLHSnCtoucW7+A0scnVnZahThN90Xy8uVgOIb4lfgwIA6/wGMAw
         ZbgQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795853391; x=1796458191; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2ulowdNAh4XwLKfaFs7pTuNCELaY3qcxAbIhfl2cRjc=;
        b=FDw5q33FY2EYV1s9fMLiJMZq1LsGa0ws5B2UKS7JALyQCipSORfGH6To+JE9oZ7YsI
         LImqIQUDLokTZKcrsnpoE+wVKtvwcUvEKnWsVsP6XF9bREF97zqdaoRR8+hhOcp4t0pj
         4AU/P9dUz/bxW1fR2K57H7rf4iU2TraIMKWeJVzCYuZaqCjxrSE0VvcocnUTY7EdPRps
         KfASP4oFYn4K3sSKsBiZmxkZD6NSxSOrFA9InVAUabIVfInHrf4f5m7aQ4XLzBy8MRdo
         sycnOqFovUc6KKyzb/IoxSLhrQ6OPlE9t6WwcxrMxN+A2e3hxoQEs6fpk6dBxHzaUuMg
         Rodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795853391; x=1796458191;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ulowdNAh4XwLKfaFs7pTuNCELaY3qcxAbIhfl2cRjc=;
        b=djcs2hvPhqJHCjkFsNSsa6RMmzP8KVE/IWnJsEU0ejLjTcWTCZcgesUT+kxwLIcf6R
         pBjrOglVGB1/jGQGdnWBqW9cm2MKz8Z10zM6Sic7SOpBhSx/Ugyyt/kEI0fGe0EM6w/+
         52d3FE7IFZihntO/ENHla5NXw5IFNWBuzNl5e9AjeZRGnHjRcnoT5VxhBdWDbreQmere
         nFM5lRlhugV2FFFp0xgB0lCiVu32OQDRf1T1FAGxsHlNHDzLHwlu00uezbTxlMebfAvE
         1+kRKh0uJgAC/zA+g7vxyJq+h3LmrfDmQ4ktVxEM+RTpCWQfwneLAcA9DbPoOwhXDL7C
         mMFg==
X-Forwarded-Encrypted: i=1; AL+hErEuCOXH8bduhUSGNHjs/swcKlcodJFejsmOJXE+lhvtfFFVchXMeDAHZQPVxXPuEs3S647iEkKviyU08TM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+krgzrskGSSXHtRQvNVT5wzcCNgUdfSLKv1MvMLDKIFks0NjKV
	G9uYcWWv/9isTl2VXrMFcI8uDiY37Yf8x8/ilgEgYW42ubrTN37OfUGLLcNb1wrrZVBali0yN1S
	yuOHlCIp6AirzAjPAMsBX+QusAn1gVOU=
X-Gm-Gg: AZFdTZcVjJyAzFJH+1rMAoE9mtGFSQhxdDqnJ1VFKpmKIFRkySyuPBMQ3D1pm6e25KI
	5/ujpKNO2WvyWvBUPBn3LXlWd2qL5q1Hhkbnf4Uw01lU28zptSySEgqy31yyd9rpv/ZloZNQdbv
	1/G5sdx2ujRaP4VWAE12WRWtKiOgBJX1rz2N6xFrTuKKR/lEkfVzLW07HCeP+oD4PfbpBMLvx5z
	bANsL/gZ2Nl+XidnTWrzvq9wKL7Pm36Th+YOqexF2xeUv8dp+XJwBpffx96fOJBRckcmCcFomgR
	1pAFSqagfQ3RhSZ3YMPqCcWw9VKlbrSBKDHcU1df0ZWw+FgrqNo2FDZIE6IB5sbokcZ9/vbExL/
	Ic3WoUFCcOjzxVKE3cuvzMlWB7fAdSMppBTl1
X-Received: by 2002:a05:6512:1315:b0:5c1:5b62:8bc8 with SMTP id
 2adb3069b0e04-5c1bc7daf87mr8455801e87.35.1795853390568; Sat, 28 Nov 2026
 00:09:50 -0800 (PST)
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
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com> <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
 <awYsDfYqrS2ldOTw@google.com> <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>
 <awZt7P_p-GNZ3A2i@google.com> <CACpmpod_87WY_PcOsNmPZvFzmJyBtCpyvvq1a_BqmZgGmO1e5A@mail.gmail.com>
 <awcK9oNDbc1QFJr6@google.com> <CACpmpoenPZ_SqhxL70r8q09WBfrnqvPu3H+F8Tz3nVwO=rvUTw@mail.gmail.com>
 <CAO9r8zP3Skc=X8+cxnV4V=CKaAqcndnAVniMvcfeOHVeSk4oAA@mail.gmail.com>
In-Reply-To: <CAO9r8zP3Skc=X8+cxnV4V=CKaAqcndnAVniMvcfeOHVeSk4oAA@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sat, 28 Nov 2026 00:09:37 -0800
X-Gm-Features: Aa3M54r35m-gWbG0MnDGTb0eGIJGp46YnS80xudhrHl0F044wd57z5-qF-W55Eg
Message-ID: <CACpmpofUGBENyQDO7FdMhx0H-NPhenySWjkQdHkh7OGyAg0e2Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 11:46=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Wed, Nov 25, 2026 at 10:06=E2=80=AFAM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Wed, Nov 25, 2026 at 8:31=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > [..]
> > > > > write_s would be calculated averaging the time in the ".. bytes /=
 ..
> > > > > usecs" lines, and free_s by averaging the time from the ".. usecs=
 to free
> > > > > memory" lines.
> > > > >
> > > > > In this run:
> > > > > write_s =3D 37.31 s
> > > > > free_s =3D 23.39 s
> > > > >
> > > > > With your patches, I got:
> > > > > write_s =3D 37.03 s
> > > > > free_s =3D 18.86 s
> > > >
> > > > I am not sure how useful it is to apply user-space gettimeofday()
> > > > results that time many higher level C code API, as an indicator of
> > > > zswap_store() performance.
> > >
> > > It is useful to see where the time is being spent, and it is consiste=
nt
> > > with the perf profiles.
> > >
> > > [..]
> > > > > You can see that the cycles spent on zswap_store() are almost the=
 same,
> > > > > and the cycle reduction happens in zswap_invalidate().
> > > >
> > > > The cycles spent in zswap_store() should be normalized to the # of
> > > > zswpout events that these CPU cycles represent, for this to be a
> > > > reliable measure of latency improvement. There could be an increase=
 in
> > > > reclaimed folios for any number of reasons, all of which are not
> > > > necessarily due to performance-improvement/degradation of
> > > > zswap_store() itself. IOW, more work for less latency per unit of w=
ork
> > > > is not always indicative of a performance degradation in this case.
> > > >
> > > > A realistic scenario would be that with zswap_store() becoming more
> > > > efficient, the 30 allocating threads cause more memory.high breache=
s,
> > > > that causes more zswpout..
> > > > This would cause more CPU cycles in zswap_store(), but the fact
> > > > remains that zswap_store() efficiency has improved due to batching.
> > >
> > > The zswpout number is almost identical: 45,796,107 vs 45,796,089.
> >
> > Can you also share these vmstat/zswap stats for this run (baseline and
> > with patches):
> >
> >  pswpin
> >  pswpout
> >  thp_swpout
> >  thp_swpout_fallback
> >  zswpin
> >  zswpout
> >  zswpwb
> >  pgmajfault
> >  2048kB-alloc
> >  2048kB-zswpout
> >  2048kB-swpout
> >  2048kB-swpout-fallback
> >  zswap_pool_total_size
> >  zswap_pool_limit_hit
> >  zswap_written_back_pages
>
> These are the ones I have. I only enable 2M mTHP so I think most
> 2048kB-* stats can be derived:
>
>                                base          p1-8
>       pswpin                      0             0
>       pswpout                     0             0
>       thp_swpout                  0             0
>       thp_swpout_fallback         0             0
>       zswpin                    265           247
>       zswpout            45,796,107    45,796,089
>       zswpwb                      0             0
>       pgmajfault              2,811         4,231
>       thp_fault_alloc       153,600       153,600
>
> The increase in pgmajfault is unrelated, probably because I dropped
> caches before runs and these are file page faults. The number of
> swapins is ~the same. zswap_pool_limit_hit, zswap_written_back_pages,
> and post-run zswap_pool_total_size are all 0 (consistent with
> pswpout=3D0 and zswpwb=3D0).

I ran some experiments today to measure the zswap_store() latency
gains with PMD folios, baseline vs. zswap compress batching.

Summary of new data:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

1) Ran Unmodified Usemem and Usemem with Silesia for 10 iterations.
2) Gathered zswap_store() bpftrace kernel latencies for each
iteration, with the help of LLM generated scripts:
   a) Each iteration reports Sys time along with cumulative
zswap_store() latency for that iteration.
   b) bpftrace aggegrates nsec spent in zswap_store() calls.
   c) bpftrace uses lhist windows: Much better accuracy than log2 hist:

        PMD folios lhist:
        /* 10000 us - 25000 us in 15 us steps (1000 buckets, covers
baseline & batched) */
        @zswap_higher_order_folio_store_ns =3D lhist($lat, 10000000,
25000000, 15000);

        Order-0 folios lhist:
        /* 0 - 500 us in 500 ns steps (1000 buckets) */
        @zswap_order0_folio_store_ns      =3D lhist($lat, 0, 500000, 500);

3) Ran with/without zswap shrinker enabled.

Conclusions based on the results:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
1) Gains in zswap_store() latency are unambiguously established with
zswap compress batching, both, for unmodified usemem and usemem
reading Silesia.

2) Gains in zswap_store() latency are seen without and with zswap
shrinker enabled.

3) More significant zswap_store() latency gains are seen with the
zswap shrinker:

   Unmodified usemem:   Sys time -2.4%, zswap_store() total latency -1.10%
   Usemem with Silesia: Sys time -4.11%, zswap_store() total latency -3.43%

4) With zswap shrinker, up to 4.10% fewer zswpout and up to 10.06%
fewer zswap_written_back_pages are observed with the patch series wrt
baseline.

5) Without zswap shrinker, the usemem30 Silesia experiments show 38%
fewer zswpout, 62% fewer PMD folio allocations and 49% fewer PMD THP
zswpouts, with 0 pswpout/zswapwb/pool_limit_hit. This is indicative of
the zswap_store() speed-up resulting in less memory pressure.

6) zswap_store() bpftrace avg, p50, p95, p99 latency distributions
improve consistently for PMD folios.


A) zswap_compressor =3D ZSTD, zswap_shrinker =3D N:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 Unmodified Usemem (100% over-commit):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
         usemem -w -O -b 5 -s 10 -n 30 10g
         cgroup memory.high =3D 150G
         zswap max_pool_percent =3D 20% (default)
 --------------------------------------------------------------------------=
------

 Baseline:
 =3D=3D=3D=3D=3D=3D=3D=3D=3D
 [+] Starting benchmark suite: 10 runs (Limit: 150G).
 --------------------------------------------------------------------------=
--
 [Run 1/10] Sys Time: 2082.624s | zswap_store: 1279.346867s
 [Run 2/10] Sys Time: 2076.123s | zswap_store: 1279.284415s
 [Run 3/10] Sys Time: 2067.660s | zswap_store: 1279.446595s
 [Run 4/10] Sys Time: 2087.806s | zswap_store: 1279.958761s
 [Run 5/10] Sys Time: 2105.170s | zswap_store: 1278.988750s
 [Run 6/10] Sys Time: 2059.407s | zswap_store: 1278.937106s
 [Run 7/10] Sys Time: 2076.392s | zswap_store: 1279.162205s
 [Run 8/10] Sys Time: 2078.407s | zswap_store: 1279.057718s
 [Run 9/10] Sys Time: 2074.148s | zswap_store: 1279.366872s
 [Run 10/10] Sys Time: 2045.885s | zswap_store: 1279.217773s
 --------------------------------------------------------------------------=
--

 zswap_compress_batching:
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 [+] Starting benchmark suite: 10 runs (Limit: 150G).
 --------------------------------------------------------------------------=
--
 [Run 1/10] Sys Time: 1980.633s | zswap_store: 1274.292791s
 [Run 2/10] Sys Time: 2029.989s | zswap_store: 1274.619375s
 [Run 3/10] Sys Time: 1983.237s | zswap_store: 1274.533935s
 [Run 4/10] Sys Time: 2022.402s | zswap_store: 1274.328900s
 [Run 5/10] Sys Time: 1989.381s | zswap_store: 1275.065320s
 [Run 6/10] Sys Time: 1976.409s | zswap_store: 1274.698973s
 [Run 7/10] Sys Time: 1984.453s | zswap_store: 1274.511715s
 [Run 8/10] Sys Time: 1967.692s | zswap_store: 1274.588755s
 [Run 9/10] Sys Time: 1984.806s | zswap_store: 1274.987864s
 [Run 10/10] Sys Time: 1929.026s | zswap_store: 1274.268613s
 --------------------------------------------------------------------------=
--

 --------------------------------------------------------------------------=
------
 Avg of 10 usemem30             baseline   zswap compress         Gain     =
Gain
         iterations                              batching       actual     =
  %
 --------------------------------------------------------------------------=
------
 Avg Sys time    (seconds)    2,075.3622     1,984.8028     -90.56 sec    -=
4.36%
 Avg Throughput  (KB/s)          248,769        249,663        894 KB/s    =
0.36%
 Avg zswap_store (seconds)    1,279.2767     1,274.5896    -4.6871 sec    -=
0.37%
 cumulative latency
 from bpftrace

 --------------------------------------------------------------------------=
------
 PMD folios: zswap_store() latency distribution across 10 usemem30
iterations
 --------------------------------------------------------------------------=
------
 Calls                        894,463           894,462         -1
 Avg (us)                  14,302.107        14,249.720    -52.387 us     -=
0.37%
 p50 (us)                  14,368.092        14,310.851    -57.241 us     -=
0.40%
 p95 (us)                  14,456.748        14,419.225    -37.523 us     -=
0.26%
 p99 (us)                  14,602.678        14,610.077      7.399 us      =
0.05%

 --------------------------------------------------------------------------=
------
 Order-0 folios: zswap_store() latency distribution across 10 usemem30
iterations
 --------------------------------------------------------------------------=
------
 Calls                          3,516             3,532         16
 Avg (us)                      17.591            17.877      0.286 us      =
1.63%
 p50 (us)                      14.797            15.197      0.400 us      =
2.70%
 p95 (us)                      29.124            29.628      0.504 us      =
1.73%
 p99 (us)                      57.710            65.340      7.630 us     1=
3.22%

 --------------------------------------------------------------------------=
------
 vmstats (includes 2 warm-up iterations)
 --------------------------------------------------------------------------=
------
 pswpin                             0                 0          0
 pswpout                            0                 0          0
 zswpin                         3,754             3,844         90
 zswpout                  549,561,421       549,560,490       -931
 zswpwb                             0                 0          0
 2048kB-alloc               1,843,260         1,843,260          0
 2048kB-zswpout             1,073,354         1,073,352         -2
 2048kB-swpout                      0                 0          0
 2048kB-swpout-fallback             0                 0          0
 zswap_pool_limit_hit               0                 0          0
 zswap_written_back_pages           0                 0          0
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 Usemem Silesia (100% over-commit):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
         usemem -w --read-silesia -O -b 5 -s 10 -n 30 6g
         cgroup memory.high =3D 90G
         zswap max_pool_percent =3D 50%

 Baseline:
 =3D=3D=3D=3D=3D=3D=3D=3D=3D
 [+] Starting benchmark suite: 10 runs of Usemem with Silesia Dataset
(Limit: 90G).
 --------------------------------------------------------------------------=
--
 [Run 1/10] Sys Time: 3843.464s | zswap_store: 2277.627313s
 [Run 2/10] Sys Time: 3836.637s | zswap_store: 2278.318722s
 [Run 3/10] Sys Time: 3856.074s | zswap_store: 2278.190603s
 [Run 4/10] Sys Time: 3823.647s | zswap_store: 2278.387886s
 [Run 5/10] Sys Time: 3813.093s | zswap_store: 2278.740563s
 [Run 6/10] Sys Time: 3788.743s | zswap_store: 2277.697021s
 [Run 7/10] Sys Time: 3868.892s | zswap_store: 2277.858950s
 [Run 8/10] Sys Time: 3797.672s | zswap_store: 2278.514745s
 [Run 9/10] Sys Time: 3865.027s | zswap_store: 2279.041594s
 [Run 10/10] Sys Time: 3789.124s | zswap_store: 2279.485606s
 --------------------------------------------------------------------------=
--

 zswap_compress_batching:
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 [+] Starting benchmark suite: 10 runs (Limit: 90G).
 --------------------------------------------------------------------------=
--
 [Run 1/10] Sys Time: 3852.547s | zswap_store: 2266.829664s
 [Run 2/10] Sys Time: 3824.707s | zswap_store: 2267.232763s
 [Run 3/10] Sys Time: 3839.655s | zswap_store: 2266.313908s
 [Run 4/10] Sys Time: 3805.258s | zswap_store: 2265.486178s
 [Run 5/10] Sys Time: 3775.986s | zswap_store: 2266.747005s
 [Run 6/10] Sys Time: 3842.518s | zswap_store: 2266.647259s
 [Run 7/10] Sys Time: 3837.615s | zswap_store: 2266.726275s
 [Run 8/10] Sys Time: 3848.061s | zswap_store: 2266.902372s
 [Run 9/10] Sys Time: 3831.397s | zswap_store: 2266.195312s
 [Run 10/10] Sys Time: 3826.463s | zswap_store: 2267.386639s
 --------------------------------------------------------------------------=
--

 --------------------------------------------------------------------------=
------
 Avg of 10 usemem30             baseline   zswap compress         Gain     =
Gain
         iterations                              batching       actual     =
  %
 --------------------------------------------------------------------------=
------
 Avg Sys time    (seconds)    3,828.2373     3,828.4207        0.18
sec     0.00%
 Avg Throughput  (KB/s)           61,506         61,383        -123
KB/s   -0.20%
 Avg zswap_store (seconds)    2,278.3863     2,266.6467    -11.7396
sec    -0.52%
 cumulative latency
 from bpftrace

 --------------------------------------------------------------------------=
------
 PMD folios: zswap_store() latency distribution across 10 usemem30
iterations
 --------------------------------------------------------------------------=
------
 Calls                        922,600           922,601             1
 Avg (us)                  16,035.212        15,816.040      -219.172
us   -1.37%
 p50 (us)                  16,916.945        16,682.504      -234.441
us   -1.39%
 p95 (us)                  20,518.592        20,134.788      -383.804
us   -1.87%
 p99 (us)                  20,866.739        20,474.772      -391.967
us   -1.88%

 --------------------------------------------------------------------------=
------
 Order-0 folios: zswap_store() latency distribution across 10 usemem30
iterations
 --------------------------------------------------------------------------=
------
 Calls                    275,102,932       275,099,516        -3,416
 Avg (us)                      29.043            29.351         0.308
us    1.63%
 p50 (us)                      28.975            29.273         0.298
us    2.70%
 p95 (us)                      31.528            31.841         0.313
us    1.73%
 p99 (us)                      33.273            33.523         0.250
us   13.22%

 --------------------------------------------------------------------------=
------
 vmstats (includes 2 warm-up iterations)
 --------------------------------------------------------------------------=
------
 pswpin                             0                 0              0
 pswpout                            0                 0              0
 zswpin                   566,262,293       566,273,230         10,937
 zswpout                1,446,525,371       896,978,740   -549,546,631
   -37.99%
 zswpwb                             0                 0              0
 2048kB-alloc               2,950,440         1,107,181     -1,843,259
   -62.47%
 2048kB-zswpout             2,180,497         1,107,145     -1,073,352
   -49.23%
 2048kB-swpout                      0                 0              0
 2048kB-swpout-fallback             0                 0              0
 zswap_pool_limit_hit               0                 0              0
 zswap_written_back_pages           0                 0              0
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

B) zswap_compressor =3D ZSTD, zswap_shrinker =3D Y:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 Unmodified Usemem (100% over-commit):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
         usemem -w -O -b 5 -s 10 -n 30 10g
         cgroup memory.high =3D 150G
         zswap max_pool_percent =3D 20% (default)
 --------------------------------------------------------------------------=
------
 Avg of 10 usemem30             baseline   zswap compress         Gain     =
Gain
         iterations                              batching       actual     =
  %
 --------------------------------------------------------------------------=
------
 Avg Sys time    (seconds)    1,798.0412     1,754.8673      -43.17
sec    -4.36%
 Avg Throughput  (KB/s)           35,794         36,239         445
KB/s    0.36%
 Avg zswap_store (seconds)    1,243.6329     1,229.9446    -13.6883
sec    -0.37%
 cumulative latency
 from bpftrace

 --------------------------------------------------------------------------=
------
 PMD folios: zswap_store() latency distribution across 10 usemem30
iterations
 --------------------------------------------------------------------------=
------
 Calls                        857,921         854,237        -3,684
 Avg (us)                  14,495.816      14,398.087       -97.729 us
    -0.67%
 p50 (us)                  14,535.149      14,412.360      -122.789 us
    -0.84%
 p95 (us)                  15,012.265      14,923.469       -88.796 us
    -0.59%
 p99 (us)                  15,241.253      15,120.714      -120.539 us
    -0.79%

 --------------------------------------------------------------------------=
------
 Order-0 folios: zswap_store() latency distribution across 10 usemem30
iterations
 --------------------------------------------------------------------------=
------
 Calls                          3,602           3,607             5
 Avg (us)                      17.660          18.530         0.870 us
     4.93%
 p50 (us)                      14.939          14.801        -0.138 us
    -0.92%
 p95 (us)                      29.822          30.622         0.800 us
     2.68%
 p99 (us)                      58.990         182.465       123.475 us
   209.32%

 --------------------------------------------------------------------------=
------
 vmstats (includes 2 warm-up iterations)
 --------------------------------------------------------------------------=
------
 pswpin                           2,325           2,215          -110
 pswpout                     12,976,001      13,093,265       117,264
 zswpin                           1,881           1,952            71
 zswpout                    526,979,887     524,858,122    -2,121,765
    -0.40%
 zswpwb                      12,976,001      13,093,265       117,264
 2048kB-alloc                 1,843,259       1,843,258            -1
     0.00%
 2048kB-zswpout               1,029,249       1,025,105        -4,144
    -0.40%
 2048kB-swpout                        0               0             0
 2048kB-swpout-fallback               0               0             0
 zswap_pool_limit_hit                 0               0             0
 zswap_written_back_pages    10,852,812      10,656,928      -195,884
    -1.80%
 zswap_reject_reclaim_fail            2               0            -2
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 Usemem Silesia (50% over-commit):
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
         usemem -w --read-silesia -O -b 5 -s 10 -n 30 3g
         cgroup memory.high =3D 60G
         zswap max_pool_percent =3D 50%
 --------------------------------------------------------------------------=
------
 Avg of 10 usemem30             baseline   zswap compress         Gain     =
Gain
         iterations                              batching       actual     =
  %
 --------------------------------------------------------------------------=
------
 Avg Sys time    (seconds)    1,484.1499       1,423.1080     -61.04
sec   -4.11%
 Avg Throughput  (KB/s)           20,286           26,221      5,935
KB/s  29.26%
 Avg zswap_store (seconds)      931.9412         899.9983   -31.9429
sec   -3.43%
 cumulative latency
 from bpftrace

 --------------------------------------------------------------------------=
------
 PMD folios: zswap_store() latency distribution across 10 usemem30
iterations
 --------------------------------------------------------------------------=
------
 Calls                        443,054           442,711          -343
 Avg (us)                  16,133.793        15,843.956      -289.837
us   -1.80%
 p50 (us)                  16,995.086        16,690.560      -304.526
us   -1.79%
 p95 (us)                  20,599.966        20,175.044      -424.922
us   -2.06%
 p99 (us)                  20,985.086        20,519.836      -465.250
us   -2.22%


 --------------------------------------------------------------------------=
------
 Order-0 folios: zswap_store() latency distribution across 10 usemem30
iterations
 --------------------------------------------------------------------------=
------
 Calls                     72,463,111        65,014,011    -7,449,100
 Avg (us)                      29.964            30.542         0.578
us    1.63%
 p50 (us)                      29.148            29.585         0.437
us    2.70%
 p95 (us)                      40.240            41.857         1.617
us    1.73%
 p99 (us)                      46.286            48.478         2.192
us   13.22%

 --------------------------------------------------------------------------=
------
 vmstats (includes 2 warm-up iterations)
 --------------------------------------------------------------------------=
------
 pswpin                     16,738,539       15,222,068
-1,516,471
 pswpout                    17,397,394       15,573,879
-1,823,515
 zswpin                    255,766,769      253,289,826
-2,476,943
 zswpout                   364,661,348      349,709,030
-14,952,318    -4.10%
 zswpwb                     17,397,394       15,573,879
-1,823,515
 2048kB-alloc                  554,218          554,266
48     0.01%
 2048kB-zswpout                535,430          534,030
-1,400    -0.26%
 2048kB-swpout                       0                0
0
 2048kB-swpout-fallback              0                0
0
 zswap_pool_limit_hit                0                0
0
 zswap_written_back_page    14,180,330       12,753,257
-1,427,073   -10.06%
 zswap_reject_reclaim_fail           4                4
0
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

 Measurement methodology notes:
 ------------------------------
 - The performance measurement scripts and grub options set the following:
   - Fixing CPU frequency at 2.4GHz for all cores, disabling
turbo_boost and power-saving C-states.
   - Run 2 warm-up iterations before starting the 10 benchmarking
iterations of usemem30.
   - Reset Memory State before each iteration to reduce incidental
page/slab cache noise:
      echo 3 | sudo tee /proc/sys/vm/drop_caches

Thanks,
Kanchana

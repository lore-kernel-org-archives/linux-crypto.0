Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090931E3DDE
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792101620; cv=pass; b=k0tQtvUs2g+IhZglo0zZXLH+fLeF+0IBibruCdaua2swdoq3xDXJN3O0S4mYZR6agWKYcZurikTyJmWaELcoM3/TYpzmgNogwgXSIpfzezlK9bOrw1euZabof29Gd6ytlOVtE/3UqZt52jjUxEJ/uqg+aMCnAN6hqo4DkNAVQPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792101620; c=relaxed/simple;
	bh=0lIuejf4gFVEpO7pdYZ1N86WReM/08RMUqiZxFJOshE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O++lsZY4YAH5/3sqnUzJeLxaBwp5O/SQ5IGfwNayIaPrS827emMV/kyHYVutFZmbBKEKDPfODbifGXb3UOdppdELjoTJ4cUBTUeBLHcXckzi+8Kvba6xwxfx6JOUSN/opmZvDaBTMS1HIAufVCmIgGlikUvxnnPtstbCP9bC0ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G75yutGJ; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G75yutGJ"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5ba36cc21cdso5281272e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 15:00:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792101617; cv=none;
        d=google.com; s=arc-20260327;
        b=RuDY0fmX4N38yE9lxk60jEjjF90yynW3+mjOa2z6kX9Au12Jnke73V03wFxzFRTZ2p
         UfxLQmlIWIPApa9aOEI5xs9EANnX0vl3fsLPVUitQNXKg+J5wyO71y9NKmjYLxVmDmNq
         PxUAL9KTS+VylzKYAsRghPkjWU+R9onpR8Ifo5SeeXrwSbMG8lFhqMuZgpHT7Z0lHu8s
         XVR0L06gjTPzaKWGwjvxIJE7uoTYiiMYbT09UqqfFbI3cwtO6FMAsk5L6rtLe9mdL5FA
         LpBS1CTaIsgHpWJ/wJbEE0ipEB7SkiE9BiFrxzsrvmtjk4ZoVBOM6cXSStAb3xX7HDkq
         UfBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZXTcogsoKal9GQ4e/20qywfrmylbUPYtqmzlO2SqYCM=;
        fh=OZjFOpqB7m4/FwLjzSZUVw89LASQwE5b+/r1iAiIFDU=;
        b=jcTTiBcLGIf8ZB5AFTA8GTIOYZGV/qFSovv2h1hI8FRbMs53Inm1YjTZbinrvzl+6s
         0XhBohxNf9lTQt4URBQLp30wpGE6hIu2PE5tkevRH8aZFVjjcrm9SGcmF7oi/tO7tssn
         SZIDNjoZPww4+j3A0Fsv/vWhayuZr7JJ/s+52VUec9CW5EX6FC37k38MhMCichm6MJH+
         jQ+f2XoyFUpYvQfi6tse4yCx7Lyh1JRVQJwdQB5lYqXkyZksg0v8l8IrfOuSbn10r6ms
         syMoAYZfiiXjHwEKgmADW3A9mEVIeTz6tXpvp2SA1o4bkDK+wGu092G5bF1cSI/mzLHx
         QJyA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792101617; x=1792706417; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZXTcogsoKal9GQ4e/20qywfrmylbUPYtqmzlO2SqYCM=;
        b=G75yutGJwM8lhpvrziwi6IzSeEi2LEH6FTzqHkV1fnNCyO12BierUb652Ee1kt5FrV
         5Obf4KplHSrh78XrlQk0nYpawmhLs8Cs0lzB7oYVRO48895/nZ2oUAYKKuhY77V7hmSY
         Uo1ITNt4Hu9H8++ZIOk/X9xaKQ09rCrrhqdkcd2yYDfxepS1TA4mUTFsB2f30yzBQYwY
         HwomTZXUGN/QWI3o1R6CJF21+gET3oS8QlItEH4fq+6yb126XylJdxH1XIyAC3JrSPWj
         yvCMYr1/IZp8/Z2mhSmkc8kAoi8sPbss04QpX5REmeA4H7j24i7ZKj/+xQmk1y3WRmlr
         luTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792101617; x=1792706417;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZXTcogsoKal9GQ4e/20qywfrmylbUPYtqmzlO2SqYCM=;
        b=Fxmx+75/yt6Fnt6i83TT3jbwSiz+YQ9jtGdaJHKZpqHGec77OlNTxMfYejyai5ImBu
         iSjmURMqzUVnezPH/k6VSZz1YxQ0CerZnVVBDWoYYh7OyjrYFi3lXUyAOSVJ5lXfuLnY
         Ji9CMtc8rZFeBvn7GcTIXn2nf37DmKrnoXD9rNxcScmUdTeLBQLa94+eRmRe2nlbtI6l
         bTlrAOzxVNVlKeMl7AVNWONe4LJJ4roMXmGYoqdFXZmz27C1zJiPLhGRvZaPS9LQbFpG
         Zwo9WpSJqf9bbz01UyxcJZpMOG17uAZRjkZOVgxDbrq6Zd5FezHZN/oWc5wxF5g6heCy
         f7og==
X-Forwarded-Encrypted: i=1; AKwUvBwNmQcNl+OEEgPibSBivzfnUAKEJSfR0yEbQgdOhTw/t76l2xaE+CSD2hQ8dE/vEt0tK9/4nXDXTvdW25c=@vger.kernel.org
X-Gm-Message-State: AFq9FYKaYqvKoXUUesJp3BijQCFfXjjpElQg+HFvTwIjFhbxv+pn8aUy
	8oR8OeHVUEBAk55FTq5NEz0BnedM/bd8vdlq64WxNN0ONbOt1rCL7zmE+uvXEYffoYQD2AlUt+O
	VpkW52P1/USPLKqncMCax1lb1T9pVzd8=
X-Gm-Gg: AYBFou19lHsnQ0FLP/DOIgkVcz2aaynJR9csfwDAFFc8SS7RPZZA5IMcbV36itedQTk
	gpK6xjFL8vSqMxL3f32hqgO/igiun6UVznGOcLNDHRmi5rtj06J2bLmHehzlJnBOJXLcGtFtTB3
	u65U0R5ywKUo7oIYlqRlvR2pk3tevhd7mD8A//7LV2jB2POzbGP+fieZ6ulm9sTuVyei0FuJWOk
	CgYasHg1ei6dMcEmwsuTYkLgi1tjDyKgu3xvnAoNu4A9XOUnTPguWSbtZWgEPF2tEkKWbTroK81
	wGYUvmlMpdmumUTPhhwN0dskxlwr/6aQuYs3AnXB44/Hw1F1gXDCJ6o=
X-Received: by 2002:a05:6512:31d4:b0:5bc:dd57:d0d8 with SMTP id
 2adb3069b0e04-5bcde8d9836mr7918589e87.58.1792101616768; Thu, 15 Oct 2026
 15:00:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com> <as-jZopKRfuYAiTE@google.com>
In-Reply-To: <as-jZopKRfuYAiTE@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 15:00:03 -0700
X-Gm-Features: AclHuK98HimEr86Vs09-7RY4Cc9mv6ZAaNh6uyS_4CH-ibjoMM62Yx1375aQNm8
Message-ID: <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 8:45=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 08, 2026 at 11:28:06AM -0700, Kanchana P. Sridhar wrote:
> > v1: Batched zswap_store() with compression batching
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
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
> > attribution while signing off v1 of this series with my current address=
.
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
> > 2) We keep the working set for each of the core store functionalities (=
alloc
> >    entries, compress pages, store pages in zsmalloc) to be focused on a
> >    batch, thereby minimizing cache evictions and benefiting from cache
> >    locality.
> >
> > 3) Along the lines of (1), the main zswap_compress() batching routine o=
btains
> >    the acomp_ctx mutex lock once per batch, and releases it after it ha=
s
> >    processed all pages in that batch.
> >
> > 4) Any zswap store functionality that works on a batch can potentially =
be
> >    parallelized as a next step, to further improve performance.
> >
> > Performance data: usemem with 60% over-commit:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> How much of the performance benefits come from patch 6 vs patch 8?

This is how the performance changes: Average throughput is averaged
from 10 iterations of usemem.

patch 6: 19,119 KB/s
patch 8: 17,593 KB/s

So the acomp_do_req_chain() path that ZSTD goes through with patch 8
causes a regression, even though it provides a generic batching
framework in acomp.

I was able to retrieve performance with the following change in acompress.c=
:

patch 3 with this change in acompress.c: 19,578 KB/s

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 192ea996e779..dc609bd7d927 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
                return -EAGAIN;

        if (likely(req->unit_size && acomp_request_issg(req))) {
-               if (!crypto_acomp_req_seg(tfm))
-                       return acomp_do_req_chain(req, true);
+               if (!crypto_acomp_req_seg(tfm)) {
+                       int err =3D tfm->compress(req);
+
+                       req->dst->length =3D unlikely(err) ? err : req->dle=
n;
+                       return err;
+               }

                return tfm->compress(req);
        }

Herbert, would you be Ok with this change in patch 3?

Thanks,
Kanchana

>
> > Validation was done with mm-unstable as of 10-3-2026 (Baseline) and wit=
h this
> > patch series.
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
> >     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
> >
> > zswap compressor:
> >   ZSTD
> >
> > mTHP enabled:
> >   64kB
> >
> > vm-scalability/usemem setup:
> >
> >   cgroup memory.high: 3G
> >   4 usemem processes, each allocates 1200M anonymous memory, reads the
> >   Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
> >   writes to each unsigned long in the 1200M, sleeps for 10 sec, then
> >   frees the memory and exits.
> >
> >     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M
> >
> >  usemem metrics averaged across 10 iterations*:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  ----------------------------------------------------------------------=
----
> >                                           Baseline       Patch     Chan=
ge
> >                                        mm-unstable      series       wi=
th
> >                                          10-3-2026          v1         =
v1
> >  ----------------------------------------------------------------------=
----
> >  Average Throughput (KB/s)                  11,794      17,810    +51.0=
0%
> >  Total Throughput (KB/s)                    47,179      71,242    +51.0=
0%
> >  Average Time to Free Memory (usecs)       490,973     294,920    -39.9=
3%
> >  Total Time to Free Memory (usecs)       1,963,892   1,179,682    -39.9=
3%
> >  ----------------------------------------------------------------------=
----
> >  * vmstats are as reported at the end of the 10th iteration:
> >
> >  64kB-alloc                                834,567     828,199     -0.7=
6%
> >  64kB-zswpout                              700,138     743,697      6.2=
2%
> >  64kB-swpout-fallback                       35,342      17,978    -49.1=
3%
> >  64kB-swpout                                     0           0
> >  ----------------------------------------------------------------------=
----
> >
> >  The speedup with zswap store batching of large folios has a propelling=
 effect
> >  on other parts of mm, especially, by enabling large folios to be swapp=
ed out
> >  without splitting, as the data shows. This enables other mm components=
 that are
> >  optimized for large folios, such as munmap(), folio refcounts/mapcount=
s
> >  updates, PTE invalidation upon freeing memory, zswap_invalidate(); whi=
ch
> >  benefit from xarray offsets/range continuity. As a result, subsequent =
large
> >  folio swapouts are more likely to find contiguous swap slots, there ar=
e fewer
> >  large folio splits during reclaim, more mTHP zswpouts and the cycle
> >  continues. As the data demonstrates, this directly contributes to more=
 memory
> >  over-commit opportunity.
> >
> > Detailed usemem metrics/cgroup memory utilization/vmstats:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  A) MAX zswap pool_total_size vmstats:
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >  This is a snapshot at the 10th iteration's peak zswap pool usage:
> >
> >  ----------------------------------------------------------------------=
----
> >                                     Baseline             Patch     Chan=
ge
> >                                  mm-unstable            series       wi=
th
> >                                    10-3-2026                v1         =
v1
> >  ----------------------------------------------------------------------=
----
> >  pswpin                                    0                 0
> >  pswpout                                   0                 0
> >  thp_swpout                                0                 0
> >  thp_swpout_fallback                       0                 0
> >  swpin_zero                              594               548
> >  swpout_zero                           1,062               864
> >  zswpin                           10,603,882        11,070,673
> >  zswpout                          16,594,356        16,509,201     -0.5=
1%
> >  zswpwb                                    0                 0
> >  nrswpin                                   0                 0
> >  nrswpout                                  0                 0
> >  pgmajfault                        1,460,360         1,470,092      0.6=
7%
> >  nr_free_pages                       897,249           908,935      1.3=
0%
> >  nr_free_pages_blocks                892,928           903,680      1.2=
0%
> >  64kB-alloc                          831,788           825,556     -0.7=
5%
> >  64kB-zswpout                        690,961           735,863      6.5=
0%
> >  64kB-swpout                               0                 0
> >  64kB-swpout-fallback                 32,982            16,545    -49.8=
4%
> >  64kB-swpin                                0                 0
> >  zswap_pool_total_size         1,420,120,064     1,377,210,368     -3.0=
2%
> >  memory.current                3,390,189,568     3,299,569,664     -2.6=
7%
> >  memory.swap.current           3,221,221,376     3,221,221,376
> >  ----------------------------------------------------------------------=
----
> >
> >   B) STEADY STATE vmstats after usemem finishes:
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >   This is a snapshot after the 10th iteration finishes:
> >
> >  ----------------------------------------------------------------------=
----
> >                                     Baseline             Patch     Chan=
ge
> >                                  mm-unstable            series       wi=
th
> >                                    10-3-2026                v1         =
v1
> >  ----------------------------------------------------------------------=
----
> >  pswpin                                    0                 0
> >  pswpout                                   0                 0
> >  thp_swpout                                0                 0
> >  thp_swpout_fallback                       0                 0
> >  swpin_zero                              594               548
> >  swpout_zero                           1,062               949
> >  zswpin                           11,526,695        11,963,729
> >  zswpout                          17,293,120        17,219,911     -0.4=
2%
> >  zswpwb                                    0                 0
> >  nrswpin                                   0                 0
> >  nrswpout                                  0                 0
> >  pgmajfault                        1,591,298         1,596,095      0.3=
0%
> >  nr_free_pages                     1,752,789         1,753,264      0.0=
3%
> >  nr_free_pages_blocks              1,258,496         1,240,064     -1.4=
6%
> >  64kB-alloc                          834,567           828,199     -0.7=
6%
> >  64kB-zswpout                        700,138           743,697      6.2=
2%
> >  64kB-swpout                               0                 0
> >  64kB-swpout-fallback                 35,342            17,978    -49.1=
3%
> >  64kB-swpin                                0                 0
> >  zswap_pool_total_size                     0                 0
> >  memory.current                      757,760           802,816      5.9=
5%
> >  memory.swap.current                       0                 0
> >  ----------------------------------------------------------------------=
----
> >  zswap debugfs counters:
> >
> >   pool_limit_hit                           0                 0
> >   written_back_pages                       0                 0
> >   reject_alloc_fail                        0                 0
> >   reject_kmemcache_fail                    0                 0
> >   reject_reclaim_fail                      0                 0
> >   reject_compress_fail                     0                 0
> >   reject_compress_poor                     0                 0
> >   decompress_fail                          0                 0
> >   stored_incompressible_pages              0                 0
> >   stored_pages                             0                 0
> >  ----------------------------------------------------------------------=
----
> >
> >
> > [1]: https://patchwork.kernel.org/project/linux-mm/cover/20260125033537=
.334628-1-kanchana.p.sridhar@intel.com/
> > [2]: https://wanos.co/assets/silesia.tar
> >
> >
> > Changes since [1]:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > 1) Better cacheline placement of struct zswap_pool and struct zswap_ent=
ry
> >    members for temporal memory access efficiency in zswap store/load ho=
t paths,
> >    while minimizing holes.
> >
> > 2) Refactored the core compression batching functionality to a separate
> >    __zswap_compress() function, which is called by zswap_compress(), as=
 per
> >    Nhat's and Yosry's comments. Hopefully this helps explain the outer =
"store
> >    batching" zswap_compress() vis-a-vis the inner "compress batching"
> >    __zswap_compress() distinction.
> >
> > 3) The acomp_ctx is locked once and is passed to the routine that compr=
esses a
> >    batch, per the algorithm's batch-size. Similarly, the folio's node i=
d and
> >    writeback_enabled status are computed once and passed to the routine=
s that
> >    implement the different store functionalities, to save latency by av=
oid
> >    localized recomputes of information that doesn't change.
> >
> > 4) Moved the folio node id being stored in zswap_entry to a separate pa=
tch, per
> >    Yosry's comment.
> >
> > 5) Addressed the kunmap_local() issue flagged by Jixin He in the
> >    IS_ERR_VALUE(handle) error path
> >    (https://patchwork.kernel.org/comment/27095925) - thanks!
> >
> > 6) Moved comments inline, per Yosry's suggestions.
> >
> > Thanks,
> > Kanchana
> >
> >
> > Kanchana P. Sridhar (8):
> >   crypto: acomp - Define a unit_size in struct acomp_req to enable
> >     batching. mm: zswap: Set the unit size for zswap to PAGE_SIZE.
> >   crypto: acomp - Add bit to indicate segmentation support.
> >   crypto: acomp - Add trivial segmentation wrapper.
> >   crypto: acomp - Add API to get a compression algorithm's batch-size.
> >   mm: zswap: Store the folio's node id in the zswap_entry.
> >   mm: zswap: Store large folios in batches.
> >   mm: zswap: Optimally place members of struct zswap_pool, struct
> >     zswap_entry.
> >   mm: zswap: Batched zswap_compress() for storing large folios in
> >     batches.
> >
> >  crypto/acompress.c                  |  47 ++-
> >  include/crypto/acompress.h          |  62 +++
> >  include/crypto/algapi.h             |   5 +
> >  include/crypto/internal/acompress.h |   8 +
> >  include/linux/crypto.h              |   3 +
> >  mm/zswap.c                          | 571 ++++++++++++++++++++--------
> >  6 files changed, 528 insertions(+), 168 deletions(-)
> >
> > --
> > 2.39.5
> >

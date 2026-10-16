Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601764FE2F3
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 16:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167259; cv=none; b=em30fS9yol/ao9WsVXPLmxhZk2mighBc0dP7xTRvnpfplGViFMweI6JaSlJFIXQC069bKg2KKdaUHS5cxsieOXuufbRlouGNLvnqrwYxhi+SvbVl93JWMumVFyFfKDHfQvvChIjQnNg0DaCNSO7ldvHiv5jOgzX4vXsbcdWekNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167259; c=relaxed/simple;
	bh=EEgSJxUHXytv+88ivCC7IE5/Yv/QjkjdVtmqS56qz3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZwM2qpWMOiAyXuQn66V80UNpmXMwzocubxMfI+AnoJKIRLndb2y2wXtUBFd9iaeXZ3F9uVf/GMW8Nm9JFOah1wZFsLRlug7dg6g4KALaeFrdnCDoQpGg6ol0XhGGjdT92Fzg6jJdSZMHh6V1p60nE359WRQkZ+LyMhv9APRqB0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ce2iQ+aN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ce2iQ+aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1B11F000CE
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167257;
	bh=Dn+zQ94Xx5nbXHRqVu2X2ak1EC4Zynh6vHRjEPrbNFM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ce2iQ+aNWDa3bNAHmS+VFScdYtMvOZUU12Ia3m21vTFFw6XVN/tklXYG1bX4+2X+y
	 k/63DtKhqTyKvJ8SnUvR5bs+7rWzwPH/j2jfYzPZmSHrW499daGHRt+/ZMYm3LwhLX
	 TY7cE0YeUZauHk5fbEFqH7s4m7nYKwpAAP0RV3A1qW0W2wDh7wwzbAEEU1cLuxDUm7
	 oOjM5zPgBSZfGMc3l4PVGhb4xN4+0TGJCPjyb7OGvAffKJVeVfGpZbAodk8yCM0xgm
	 s4XopY+7vjcZ3PagXHVppWtm5mHfsR718FyeLi6/18ox3d4BUzVJThVQ6IPvy20fwc
	 TuMUjEowDwiCg==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2e69aa07c3so9044566b.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 09:14:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzDbBShGCylXif6lScfb/5TfMUhDsgVs8NeudA6J36c2SkcuYi46lxBelE0amu5RXdNmgjEWOexFnGD6XE=@vger.kernel.org
X-Gm-Message-State: AFq9FYLkc+2YU0HxAUDpK1QzK8WN2N8QSY2oujNIRcc14NRyT9oeQnaX
	KF2Kz67mtsihK6rvrM+ILLCvMagFqZtRNfIjqG3XBfeW4Olv4uGKH5NhRTeL6zNKj8I2/xfXfes
	peZinRxV3WjGKV+OxlCsYJIrnQrftFOE=
X-Received: by 2002:a17:906:9f86:b0:c40:560a:45e with SMTP id
 a640c23a62f3a-c419f416b79mr22483966b.35.1792167255917; Fri, 16 Oct 2026
 09:14:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 16 Oct 2026 09:14:04 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
X-Gm-Features: AclHuK-wTWiI_HWFi3__wF5R0bm5SgzhJD-59mYqegifCIi_SvzEA4blKihevCg
Message-ID: <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 11:28=E2=80=AFAM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> v1: Batched zswap_store() with compression batching
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
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
> attribution while signing off v1 of this series with my current address.
>
> To summarize the main contribution of this patch series: Batching is intr=
oduced
> in zswap_store() of large folios: we carve out a large folio into batches=
 of
> ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
> batch. Moving the fundamental operations that need to be happen to store =
a page
> to now work at the granularity of a batch offers opportunities to optimiz=
e them
> from these perspectives:
>
> 1) Utilize existing kernel API that minimize obtaining locks for bulk
>    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
>
> 2) We keep the working set for each of the core store functionalities (al=
loc
>    entries, compress pages, store pages in zsmalloc) to be focused on a
>    batch, thereby minimizing cache evictions and benefiting from cache
>    locality.
>
> 3) Along the lines of (1), the main zswap_compress() batching routine obt=
ains
>    the acomp_ctx mutex lock once per batch, and releases it after it has
>    processed all pages in that batch.
>
> 4) Any zswap store functionality that works on a batch can potentially be
>    parallelized as a next step, to further improve performance.
>
> Performance data: usemem with 60% over-commit:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Validation was done with mm-unstable as of 10-3-2026 (Baseline) and with =
this
> patch series.
>
> Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini=
.
>
> Chromebook Diagnostics reports:
>   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
>   RAM: 16GB
>
> vng setup:
>          Memory: 7G
>            Swap: 3G
>     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
>
> zswap compressor:
>   ZSTD
>
> mTHP enabled:
>   64kB
>
> vm-scalability/usemem setup:
>
>   cgroup memory.high: 3G
>   4 usemem processes, each allocates 1200M anonymous memory, reads the
>   Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
>   writes to each unsigned long in the 1200M, sleeps for 10 sec, then
>   frees the memory and exits.
>
>     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M

What is --read-silesia? Is this a local change you made to usemem?

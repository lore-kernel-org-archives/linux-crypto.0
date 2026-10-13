Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7B855820A
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 20:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791925052; cv=none; b=u7QHrTz62DEmns7zp4T83bujtpi8g1yS7s1O/TvjbH7KkraB0B5F4COXUTGU0q+Ozh/z8cdZmEsLqzwgURvguB0Oj7sZKRFFzhZlO7lvWszX/UpoWiVxdM2o0XG5PaF81MsFAit+/aYy8FbMYICzbaWS1f5wyM/KzT1o0PeYtCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791925052; c=relaxed/simple;
	bh=E6UA2GC8/NUE7noMCWkBEn0l/hqn2tcmYIb2UgJLaOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HbF714XLVkffpQm/or9qLHEJbq2Yh7tq26DaU8+QCGU6DBFj8jo69DExGNSzZx1l/tnActbnHv3qlkqE127nk5EQVsyhkwK8s8ArwU00vaUEVCCf1PNO0TwqvEAYbhpdNcRoFklFoMskfDIOdA87K8bhyJAmI0hQyZGnDpEqnAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+YJVFkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+YJVFkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493D31F00898
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 20:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791925047;
	bh=swgyvDADh7aeJQJNNx7+x0lhh5sd5zqR0J3CqoTV4l4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=C+YJVFkOF9c2RKGomBEkLsdb7XpO46ieksvz698VJ+S9y1JDMAkBAA74T+3eggGaK
	 EA32LLp1WyxGlbnOaOIthy/dv7aGQJk6zNV9M80A270KWi3KKfveOArTw7FFUOplH1
	 pP4lJlSUeP+IOeJUKsR5R2pEEmMkQXgLPOf7yFvudnoSFqjb2DZHOaUeWgEIa2SVkY
	 56YzotlLmAPaWhzK3bdVr21R2qxq710WYgMmoe1tpPD8uB9O8wPdms8XivyGB7G/vi
	 /MO4xJymJdVLyQmtsbO3/Yw6SsAhnnXB7ihAj2+JaEoc6H8BjjXzPdPgM+5wvJEa1C
	 FHC30gNwvRv3g==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c3762b0d45aso143342466b.3
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 13:57:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByH+iFYHloOeCkcAjbdeLGzugbv2NAWl1VVnaTNfVcINidso1YsWIV1p13YiVTyMKHmzSDkazAzmgAOF9c=@vger.kernel.org
X-Gm-Message-State: AFq9FYKwENl+FJ8cazQZkpYdSo/7LKuE75RXVRBN8yLnpLsOdwjxI2nU
	nn4GMiRK/bQS0K6lE0VsRqFc+RmlIvQUnNs4JeSHtjRaTQPz6PUgj01kMrgtx/+BqUxjS7rS3Ar
	6CpYAB5IaezyTnBg8OKahd6UmE+duk5U=
X-Received: by 2002:a17:907:c26:b0:c2a:3473:6780 with SMTP id
 a640c23a62f3a-c31a9ffff31mr1312422266b.25.1791925046208; Tue, 13 Oct 2026
 13:57:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261013151007.2093943-1-usama.arif@linux.dev> <20261013151007.2093943-2-usama.arif@linux.dev>
In-Reply-To: <20261013151007.2093943-2-usama.arif@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 13 Oct 2026 13:57:14 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM-utRFYGBfaEb=89LWM0DOKc8dywcDLSb6L7f4c80yuQ@mail.gmail.com>
X-Gm-Features: AclHuK_lRc7F0Bg3qaR5eej13vxAe2hsWEYGgSw8MGRsbo0q5ZL77DQKttmVvso
Message-ID: <CAO9r8zM-utRFYGBfaEb=89LWM0DOKc8dywcDLSb6L7f4c80yuQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: zswap: use separate compression and
 decompression requests
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, terrelln@fb.com, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 8:10=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> Stores and loads serialize on the same per-CPU acomp request and mutex.
> A low-priority store can be preempted as soon as the compressor drops
> its stream lock, while it still holds the mutex. A higher-priority load
> on that CPU then waits until the store runs again, which can take a
> long time when other tasks are runnable.
>
> Give compression and decompression their own request, completion wait
> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> compression, so group it with the compression request. Independent
> requests can share the per-CPU transform; the codecs and drivers
> synchronize their shared state internally. Loads can still wait for
> each other on the decompression mutex, and stores still serialize on
> the compression mutex.
>
> acomp_request_free() ignores NULL requests, so drop the check in
> acomp_ctx_free().
>
> This follows the proposal from Sergey Senozhatsky for the same split
> for zram [1].
>
> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chro=
mium.org/
>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Why didn't you take Herbert's Ack?

LGTM with one nit below:

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  mm/zswap.c | 108 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 64 insertions(+), 44 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ae19e301fced7..23c4298765795 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -137,14 +137,25 @@ bool zswap_never_enabled(void)
>  * data structures
>  **********************************/
>
> -struct crypto_acomp_ctx {
> -       struct crypto_acomp *acomp;
> +struct zswap_acomp_req {
>         struct acomp_req *req;
>         struct crypto_wait wait;
> -       u8 *buffer;
>         struct mutex mutex;
>  };
>
> +/* The compression mutex also protects the output buffer. */
> +struct zswap_comp_ctx {
> +       struct zswap_acomp_req areq;
> +       u8 *buffer;
> +};
> +
> +/* Separate requests, so that decompression does not wait for compressio=
n. */
> +struct crypto_acomp_ctx {
> +       struct crypto_acomp *acomp;
> +       struct zswap_comp_ctx comp;
> +       struct zswap_acomp_req decomp;
> +};
> +
>  /*
>   * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
>   * The only case where lru_lock is not acquired while holding tree.lock =
is
> @@ -270,14 +281,10 @@ static void acomp_ctx_free(struct crypto_acomp_ctx =
*acomp_ctx)
>         if (!acomp_ctx)
>                 return;
>
> -       /*
> -        * If there was an error in allocating @acomp_ctx->req, it
> -        * would be set to NULL.
> -        */
> -       if (acomp_ctx->req)
> -               acomp_request_free(acomp_ctx->req);
> -
> -       acomp_ctx->req =3D NULL;
> +       acomp_request_free(acomp_ctx->comp.areq.req);
> +       acomp_ctx->comp.areq.req =3D NULL;
> +       acomp_request_free(acomp_ctx->decomp.req);
> +       acomp_ctx->decomp.req =3D NULL;
>
>         /*
>          * We have to handle both cases here: an error pointer return fro=
m
> @@ -289,8 +296,8 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *a=
comp_ctx)
>
>         acomp_ctx->acomp =3D NULL;
>
> -       kfree(acomp_ctx->buffer);
> -       acomp_ctx->buffer =3D NULL;
> +       kfree(acomp_ctx->comp.buffer);
> +       acomp_ctx->comp.buffer =3D NULL;
>  }
>
>  static struct zswap_pool *zswap_pool_create(char *compressor)
> @@ -796,6 +803,28 @@ static void zswap_entry_free(struct zswap_entry *ent=
ry)
>  /*********************************
>  * compressed storage functions
>  **********************************/
> +static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
> +                               struct crypto_acomp *acomp)
> +{
> +       /* acomp_request_alloc() returns NULL in case of an error. */
> +       areq->req =3D acomp_request_alloc(acomp);
> +       if (!areq->req)
> +               return -ENOMEM;
> +
> +       crypto_init_wait(&areq->wait);
> +
> +       /*
> +        * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
> +        * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
> +        * won't be called, crypto_wait_req() will return without blockin=
g.
> +        */
> +       acomp_request_set_callback(areq->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +                                  crypto_req_done, &areq->wait);
> +
> +       mutex_init(&areq->mutex);
> +       return 0;
> +}
> +
>  static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *n=
ode)
>  {
>         struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
> @@ -811,8 +840,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
>                 return 0;
>         }
>
> -       acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_=
node(cpu));
> -       if (!acomp_ctx->buffer)
> +       acomp_ctx->comp.buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cp=
u_to_node(cpu));
> +       if (!acomp_ctx->comp.buffer)
>                 return ret;
>
>         /*
> @@ -827,25 +856,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>                 goto fail;
>         }
>
> -       /* acomp_request_alloc() returns NULL in case of an error. */
> -       acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> -       if (!acomp_ctx->req) {
> +       if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp)=
 ||
> +           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {

We stop propagating the output of these functions to the caller here.
It still works because ret is initialized as -ENOMEM, and that's the
only possible failure of zswap_acomp_req_init(), but that's really
subtle.

I'd rather either propagate the return value as-is on failure, or make
zswap_acomp_req_init() a boolean so that it's obvious there's one
failure mode and future changes can't just return a new error code
that would be silently thrown away.

>                 pr_err("could not alloc crypto acomp_request %s\n",
>                        pool->tfm_name);
>                 goto fail;
>         }
>
> -       crypto_init_wait(&acomp_ctx->wait);
> -
> -       /*
> -        * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
> -        * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
> -        * won't be called, crypto_wait_req() will return without blockin=
g.
> -        */
> -       acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BAC=
KLOG,
> -                                  crypto_req_done, &acomp_ctx->wait);
> -
> -       mutex_init(&acomp_ctx->mutex);
>         return 0;
>
>  fail:

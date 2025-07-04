Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69132116EE;
	Fri,  4 Jul 2025 18:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751654382; cv=none; b=k7bfq/Im6o9c8u2tWS2snDiNGPECLu2LVVwkMhMG+otlNJybH2nmFHNQoae9zmeF+eigKOS+WPZEiRXIV03aruECvJ+EAwW4OHS0Ulj/HdqJa8pCIWcIi755yw7wFj7MdhvCs7LnPbodcUJDEhgRPzufqOfM3UL4skH+ilVIhOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751654382; c=relaxed/simple;
	bh=oIiPtbnQd8XpJxbubKts0sTbQUNsG/DmXU9eAiM+z60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UI6gb8hLF37UQABHOSPBC0s4ttucWec65XyvwSeh+cIToYItVRohZgWHYijeUwZC8svQHwj+yXBwI9JxzZPvirImROErFdXst/eC6XfvFOyImXAPsNVItHeX5HUg6xs0fSKZBwZACFSo/QX4Kt7w5jcsvwHIS6KW0EGBcvgmsgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eFlvWqi7; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eFlvWqi7"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6fd0a91ae98so9279376d6.1;
        Fri, 04 Jul 2025 11:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751654380; x=1752259180; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLSI4jmhCdQ92xJmwXMCUX4eg1LhZKqmG9IrE2rHlKE=;
        b=eFlvWqi78S72kkPhLL2jrlXIaT913xyticAZ2Xg7XpQIIgTwWsBodfAnPXqbCvGTQc
         DdByqLimRIO47M6yOGBSSzewPyUwH7gKn5HDl9ANKMdv1uBwYAzBvz0NU2qiYb2iGgTE
         NoRFFwBS5HfZrF2iGWmkV34F+cigXfy1YRlb9rF56vNSaPym22BV7SeHxeh99ECWybdR
         4TYXhIXWZ61jlfdihUtG47Lb+o2prk8ylJuvYTOEQj83yEOoymuDFIOcfjaWb11/BhOD
         DWxK5QHNMb8SR5p2jyvbiOYyiwipugEkqLIRFNr1M2HJ+b8EEJMdCaFyZRQ++XCeKxgB
         vwLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751654380; x=1752259180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLSI4jmhCdQ92xJmwXMCUX4eg1LhZKqmG9IrE2rHlKE=;
        b=XZchkIgqPqgc600onei3SOvC4f78kxZ1nct+q8WWGGpELW0z0j76dmKs7bc7MDjtxm
         MJ8gNMFtZKjlupd8ZOtZGSf4M5mESWgi1OutfUQqjLcNDFvkAs8M0NXFFwZrsgSHZh9c
         X74iR185vcU1LIh0bViZnd7GzuK5JTe4QbytPLYkLrI4+5Ki3pJBypzR3czuVkI1j95M
         vWM9lIfu2RHKn5CGJYw3LI+g9Xyq/52hQmIEI+8zeR/ZntYRRwIdivNoH459smeFi7FU
         YBaox46/VYTHLmUl8eEa6Wab82Rl47NVlwmYh3jhF6yc+7gKGdT3Yvi3u5CA6BYPyt5Y
         +gbw==
X-Forwarded-Encrypted: i=1; AJvYcCURkDrFmaLWRr86HwZl767r5QzZ/xAJEvNr7+8m0SiwF3I30Gh31AiFs6mGRyUiT3Bz348CSgGxrCOzeSI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIN6LC5mX4es7nQlBgHRxi+6E9biUPQnsQ48Cv0bE/kbBe3G0C
	QFFngHW8XjOH4HUnybJxITUOTyNLGfUoQSU88AAc4AcT7lM7kA38AygFAsahiNgnKBpY9pBKrlu
	HnbqakoLJrZEY/4N6/9sT9YOxoUEAfEY=
X-Gm-Gg: ASbGncsFuyDksNaPNrqapfM/EfED08xcg6rnXJCadHs4o7iwcz0+hnVtkSuHmovZm+5
	4WiA/opzilZ46mCuxRKM110Q6k7Sv5m1H0uR3zAmZ9sK2/aM6GY5ZrxjIonHf7MZ87HSxDjBjJ7
	8vxzKygDCtSDfz0ysiAwoHImgkWXQxAuBfTjXs2OnfBo8=
X-Google-Smtp-Source: AGHT+IH+JWc+g38J/FXavoBpRFG4t26kf9xdnO56cRpAbEuqXLbNRw6f7/YaTbEFWCoX0zCKHZqZhrMJuqELKkmF+OE=
X-Received: by 2002:ad4:5dcb:0:b0:6fa:fbde:7e23 with SMTP id
 6a1803df08f44-702c8b71f2fmr45565996d6.8.1751654379557; Fri, 04 Jul 2025
 11:39:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250704042323.10318-1-kanchana.p.sridhar@intel.com> <20250704042323.10318-21-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250704042323.10318-21-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 4 Jul 2025 11:39:28 -0700
X-Gm-Features: Ac12FXwCQLsXq5LlRFraBt2YLteHvlw4htbXYU6u9qy7Z6Cs1ldYzuebXMyBqvg
Message-ID: <CAKEwX=PFJzc0pErjMcfeeheGL8u4GWMu2yr-iqWmFvYMKfT3fg@mail.gmail.com>
Subject: Re: [PATCH v10 20/25] mm: zswap: Move the CPU hotplug procedures
 under "pool functions".
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 3, 2025 at 9:23=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch merely moves zswap_cpu_comp_prepare() and
> zswap_cpu_comp_dead() to be in the "pool functions" section because
> these functions are invoked upon pool creation/deletion.

Hmm idk, "compressed storage" section seems fitting for
zswap_cpu_comp_prepare() and zswap_cpu_comp_dead().

Is this patch necessary?

>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 188 ++++++++++++++++++++++++++---------------------------
>  1 file changed, 94 insertions(+), 94 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 3c0fd8a137182..3538ecaed5e16 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -248,6 +248,100 @@ static inline struct xarray *swap_zswap_tree(swp_en=
try_t swp)
>  **********************************/
>  static void __zswap_pool_empty(struct percpu_ref *ref);
>
> +static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *n=
ode)
> +{
> +       struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
> +       struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ct=
x, cpu);
> +       struct crypto_acomp *acomp =3D NULL;
> +       struct acomp_req *req =3D NULL;
> +       u8 *buffer =3D NULL;
> +       int ret;
> +
> +       buffer =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cp=
u));
> +       if (!buffer) {
> +               ret =3D -ENOMEM;
> +               goto fail;
> +       }
> +
> +       acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_no=
de(cpu));
> +       if (IS_ERR(acomp)) {
> +               pr_err("could not alloc crypto acomp %s : %ld\n",
> +                               pool->tfm_name, PTR_ERR(acomp));
> +               ret =3D PTR_ERR(acomp);
> +               goto fail;
> +       }
> +
> +       req =3D acomp_request_alloc(acomp);
> +       if (!req) {
> +               pr_err("could not alloc crypto acomp_request %s\n",
> +                      pool->tfm_name);
> +               ret =3D -ENOMEM;
> +               goto fail;
> +       }
> +
> +       /*
> +        * Only hold the mutex after completing allocations, otherwise we=
 may
> +        * recurse into zswap through reclaim and attempt to hold the mut=
ex
> +        * again resulting in a deadlock.
> +        */
> +       mutex_lock(&acomp_ctx->mutex);
> +       crypto_init_wait(&acomp_ctx->wait);
> +
> +       /*
> +        * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
> +        * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
> +        * won't be called, crypto_wait_req() will return without blockin=
g.
> +        */
> +       acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +                                  crypto_req_done, &acomp_ctx->wait);
> +
> +       acomp_ctx->buffer =3D buffer;
> +       acomp_ctx->acomp =3D acomp;
> +       acomp_ctx->is_sleepable =3D acomp_is_async(acomp);
> +       acomp_ctx->req =3D req;
> +       mutex_unlock(&acomp_ctx->mutex);
> +       return 0;
> +
> +fail:
> +       if (acomp)
> +               crypto_free_acomp(acomp);
> +       kfree(buffer);
> +       return ret;
> +}
> +
> +static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node=
)
> +{
> +       struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
> +       struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ct=
x, cpu);
> +       struct acomp_req *req;
> +       struct crypto_acomp *acomp;
> +       u8 *buffer;
> +
> +       if (IS_ERR_OR_NULL(acomp_ctx))
> +               return 0;
> +
> +       mutex_lock(&acomp_ctx->mutex);
> +       req =3D acomp_ctx->req;
> +       acomp =3D acomp_ctx->acomp;
> +       buffer =3D acomp_ctx->buffer;
> +       acomp_ctx->req =3D NULL;
> +       acomp_ctx->acomp =3D NULL;
> +       acomp_ctx->buffer =3D NULL;
> +       mutex_unlock(&acomp_ctx->mutex);
> +
> +       /*
> +        * Do the actual freeing after releasing the mutex to avoid subtl=
e
> +        * locking dependencies causing deadlocks.
> +        */
> +       if (!IS_ERR_OR_NULL(req))
> +               acomp_request_free(req);
> +       if (!IS_ERR_OR_NULL(acomp))
> +               crypto_free_acomp(acomp);
> +       kfree(buffer);
> +
> +       return 0;
> +}
> +
>  static struct zswap_pool *zswap_pool_create(char *type, char *compressor=
)
>  {
>         struct zswap_pool *pool;
> @@ -818,100 +912,6 @@ static void zswap_entry_free(struct zswap_entry *en=
try)
>  /*********************************
>  * compressed storage functions
>  **********************************/
> -static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *n=
ode)
> -{
> -       struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
> -       struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ct=
x, cpu);
> -       struct crypto_acomp *acomp =3D NULL;
> -       struct acomp_req *req =3D NULL;
> -       u8 *buffer =3D NULL;
> -       int ret;
> -
> -       buffer =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cp=
u));
> -       if (!buffer) {
> -               ret =3D -ENOMEM;
> -               goto fail;
> -       }
> -
> -       acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_no=
de(cpu));
> -       if (IS_ERR(acomp)) {
> -               pr_err("could not alloc crypto acomp %s : %ld\n",
> -                               pool->tfm_name, PTR_ERR(acomp));
> -               ret =3D PTR_ERR(acomp);
> -               goto fail;
> -       }
> -
> -       req =3D acomp_request_alloc(acomp);
> -       if (!req) {
> -               pr_err("could not alloc crypto acomp_request %s\n",
> -                      pool->tfm_name);
> -               ret =3D -ENOMEM;
> -               goto fail;
> -       }
> -
> -       /*
> -        * Only hold the mutex after completing allocations, otherwise we=
 may
> -        * recurse into zswap through reclaim and attempt to hold the mut=
ex
> -        * again resulting in a deadlock.
> -        */
> -       mutex_lock(&acomp_ctx->mutex);
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
> -       acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -                                  crypto_req_done, &acomp_ctx->wait);
> -
> -       acomp_ctx->buffer =3D buffer;
> -       acomp_ctx->acomp =3D acomp;
> -       acomp_ctx->is_sleepable =3D acomp_is_async(acomp);
> -       acomp_ctx->req =3D req;
> -       mutex_unlock(&acomp_ctx->mutex);
> -       return 0;
> -
> -fail:
> -       if (acomp)
> -               crypto_free_acomp(acomp);
> -       kfree(buffer);
> -       return ret;
> -}
> -
> -static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node=
)
> -{
> -       struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
> -       struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ct=
x, cpu);
> -       struct acomp_req *req;
> -       struct crypto_acomp *acomp;
> -       u8 *buffer;
> -
> -       if (IS_ERR_OR_NULL(acomp_ctx))
> -               return 0;
> -
> -       mutex_lock(&acomp_ctx->mutex);
> -       req =3D acomp_ctx->req;
> -       acomp =3D acomp_ctx->acomp;
> -       buffer =3D acomp_ctx->buffer;
> -       acomp_ctx->req =3D NULL;
> -       acomp_ctx->acomp =3D NULL;
> -       acomp_ctx->buffer =3D NULL;
> -       mutex_unlock(&acomp_ctx->mutex);
> -
> -       /*
> -        * Do the actual freeing after releasing the mutex to avoid subtl=
e
> -        * locking dependencies causing deadlocks.
> -        */
> -       if (!IS_ERR_OR_NULL(req))
> -               acomp_request_free(req);
> -       if (!IS_ERR_OR_NULL(acomp))
> -               crypto_free_acomp(acomp);
> -       kfree(buffer);
> -
> -       return 0;
> -}
> -
>  static struct crypto_acomp_ctx *acomp_ctx_get_cpu_lock(struct zswap_pool=
 *pool)
>  {
>         struct crypto_acomp_ctx *acomp_ctx;
> --
> 2.27.0
>

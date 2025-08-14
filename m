Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557CE244662;
	Thu, 14 Aug 2025 20:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755205114; cv=none; b=fsxSA9kBe44cU3xNmmAhORG04cPTvCkJ4qMFYOOTdlTZbelOwY+zzmhCpJLvIydzcv/s+LmOvFdP5bhGZY+4D/So6UB8tADVxXjoYav+ODowG8d5oRS7M1ZX5uzqsJtFA4F67g8ufdqKBnk4vnGGeYySVYV3FO8o8ZL8eftScKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755205114; c=relaxed/simple;
	bh=k1OBbRSMU8xXelrytHGhkT8sGA1CqLRuo1xDC/AdDtY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hHkBadSyLCmzA96mFoY/aiknaoxC0lu88b1as1Ed3pxw+02oweD6OkOpSWAPMO/ZWcP30bz8WPlqfBmUdQwSyYgm06sCCuHixs1kHiWGzDqptAeBlIfS2w2XiI+0SDnAaRnB1O9/uv3QCAMbLLZLStsYiuo+fpInBdhaPozCmXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dgGQKZgZ; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dgGQKZgZ"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3e57003ee3fso6680655ab.2;
        Thu, 14 Aug 2025 13:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755205111; x=1755809911; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B/DvcecNfaCyZ/2dBsbFRg7Z15sklMK4MZS2CFAwCmU=;
        b=dgGQKZgZUpqEUtk7GgjfU3i0u6eVXY7iigFZ2tkknZ9hGZVpFQ4GAtyz/Ppu8Vgf9h
         YUgRARdmiWgUnoQ54ULWPZLCqWmE4CVTBcwjVrFu+06im0RwKhEAMiSBjAsxRVLHxFe3
         UmclwTU5SctTDiwmOgB/wOunNUO1BCd3E2bhkL60W9UtXO11S/L2smhMWsSNJwYSk9Pz
         jf2C/HHkaV3wTXY+XPSuFnmHeo6M/z8j3Fhh11FVSXGE9mlYXxW11vtwLOs0PoXvAkBG
         Kcdp7l8/QqAW5f0CvEQyq1FCEJ6sxc0nFgkaDLL28CA2lPqG9eWMePHh8Vdj0i6O9IvY
         /xag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755205111; x=1755809911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B/DvcecNfaCyZ/2dBsbFRg7Z15sklMK4MZS2CFAwCmU=;
        b=JoWm/LEiJlMzo1bnyNUK1UwHTDE76J1k9kO7E83vkZZW37oHtRADLtAI2QquYYJSgj
         iYXF+L42uVtI/743Qk/j/LajQVF4+yirmzyylIxP7Q038BsALHCoK6wxlqN9zhnKWOUs
         duGM+Be1JEYqlmWuYNNEj3K5w1eAq0NY/LaQ+cQKQLy804Q4+ynrcZXMDrVfxCFjCvG+
         HOhMcvTFqStNKviA77BXbng7+9t9uK+ViQiT7huXw6hjebDiKZnWTPglCfDe2kvcb9U0
         WG26sYcF0ZFgFzvz+it8TWhlM4OOwpxHh9rh4cEZQ2MhG2Z0xELrkBjvj6It7EIyQArt
         71yA==
X-Forwarded-Encrypted: i=1; AJvYcCWDGDU/C6LnFJRaLZLZNoAn4t5AjcqRd0t0uaZ6YeB/gtPOo/edk7e4DzpBdLbCqimJQYQ2A9m6cUWRHE0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz4NpYtxt6NBRyySduqYnbcpINUAcN57lvsTRMTcm0Bana0Sqz
	xejzTi+0yaA2TojUuVydFKh4UvSldyJbGHE97NkV6AeZDQWL7heNAboe2ZBeJlrLtvTGphBUD6j
	ZLlsuIH6mYBZyNRd+mpZJiBAcJx/llV0=
X-Gm-Gg: ASbGnctWpLD9Tr4bYPjjQCuEaNkh8hfTwnvWUw4FmMyn5nUHCuzs/px2qOHeCHlginO
	rFMOizq6kqwW6/RDsFb7OYLu7hYq+PPwZn3NMFIz/lU5BcmE6FtkkX1MRxq1wQZO8d8qY8SFSFD
	ERCqCbFCo6YE/oyK96GSC1XqyNIBacku2ECioMsaD83mclt6PpMq1FplBPKbVZewVX3J4iVa69+
	k15XIIGLMeJc8HFfzSKJ6Q=
X-Google-Smtp-Source: AGHT+IFgFZhJs9UqzM/o4QK5/KKQVO4RuxrGKNaiXRMHhQRYN59D+ji06hiSpUfPH25P/9nSatfEHqOb68pCzsUmkQA=
X-Received: by 2002:a05:6e02:278a:b0:3e5:3a15:93b6 with SMTP id
 e9e14a558f8ab-3e57b9d0151mr10609915ab.8.1755205111077; Thu, 14 Aug 2025
 13:58:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 14 Aug 2025 13:58:19 -0700
X-Gm-Features: Ac12FXyONKGeDobAX5KFBeSfqGfnUrGztv8b4uIaiXScw_41fTc1M5FIYAMcooo
Message-ID: <CAKEwX=PV9-QhQaSBGd67s=CVMVJne=fzajRn3=Vf+7OXVuNFmA@mail.gmail.com>
Subject: Re: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
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

On Thu, Jul 31, 2025 at 9:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch sets up zswap for allocating per-CPU resources optimally for
> non-batching and batching compressors.
>
> A new ZSWAP_MAX_BATCH_SIZE constant is defined as 8U, to set an upper
> limit on the number of pages in large folios that will be batch
> compressed.
>
> As per Herbert's comments in [2] in response to the
> crypto_acomp_batch_compress() and crypto_acomp_batch_decompress() API
> proposed in [1], this series does not create new crypto_acomp batching
> API. Instead, zswap compression batching uses the existing
> crypto_acomp_compress() API in combination with the "void *kernel_data"
> member added to "struct acomp_req" earlier in this series.
>
> It is up to the compressor to manage multiple requests, as needed, to
> accomplish batch parallelism. zswap only needs to allocate the per-CPU
> dst buffers according to the batch size supported by the compressor.
>
> A "u8 compr_batch_size" member is added to "struct zswap_pool", as per
> Yosry's suggestion. pool->compr_batch_size is set as the minimum of the
> compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE. Accordingly, it
> proceeds to allocate the necessary compression dst buffers in the
> per-CPU acomp_ctx.
>
> Another "u8 batch_size" member is added to "struct zswap_pool" to store
> the unit for batching large folio stores: for batching compressors, this
> is the pool->compr_batch_size. For non-batching compressors, this is
> ZSWAP_MAX_BATCH_SIZE.
>
> zswap does not use more than one dst buffer yet. Follow-up patches will
> actually utilize the multiple acomp_ctx buffers for batch
> compression/decompression of multiple pages.
>
> Thus, ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used for
> batching. There is a small extra memory overhead of allocating
> the acomp_ctx->buffers array for compressors that do not support
> batching: On x86_64, the overhead is 1 pointer per-CPU (i.e. 8 bytes).
>
> [1]: https://patchwork.kernel.org/project/linux-mm/patch/20250508194134.2=
8392-11-kanchana.p.sridhar@intel.com/
> [2]: https://patchwork.kernel.org/comment/26382610
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

Mostly LGTM. Just a couple of questions below:

> ---
>  mm/zswap.c | 82 +++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 63 insertions(+), 19 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index efd501a7fe294..63a997b999537 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -80,6 +80,9 @@ static bool zswap_pool_reached_full;
>
>  #define ZSWAP_PARAM_UNSET ""
>
> +/* Limit the batch size to limit per-CPU memory usage for dst buffers. *=
/
> +#define ZSWAP_MAX_BATCH_SIZE 8U
> +
>  static int zswap_setup(void);
>
>  /* Enable/disable zswap */
> @@ -147,7 +150,7 @@ struct crypto_acomp_ctx {
>         struct crypto_acomp *acomp;
>         struct acomp_req *req;
>         struct crypto_wait wait;
> -       u8 *buffer;
> +       u8 **buffers;
>         struct mutex mutex;
>         bool is_sleepable;
>  };
> @@ -166,6 +169,8 @@ struct zswap_pool {
>         struct work_struct release_work;
>         struct hlist_node node;
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
> +       u8 compr_batch_size;
> +       u8 batch_size;

Apologies if this is explained elsewhere, but I'm very confused - why
do we need both of these two fields?

Seems like batch_size is defined below, and never changed:

      pool->batch_size =3D (pool->compr_batch_size > 1) ?
                            pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;

Can we just determine this in zswap_store() as a local variable?


>  };
>
>  /* Global LRU lists shared by all zswap pools. */
> @@ -258,8 +263,10 @@ static void __zswap_pool_empty(struct percpu_ref *re=
f);
>   *   zswap_cpu_comp_prepare(), not others.
>   * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
>   */
> -static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_=
buffers)
>  {
> +       u8 i;
> +
>         if (IS_ERR_OR_NULL(acomp_ctx))
>                 return;
>
> @@ -269,7 +276,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ct=
x *acomp_ctx)
>         if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
>                 crypto_free_acomp(acomp_ctx->acomp);
>
> -       kfree(acomp_ctx->buffer);
> +       if (acomp_ctx->buffers) {
> +               for (i =3D 0; i < nr_buffers; ++i)
> +                       kfree(acomp_ctx->buffers[i]);
> +               kfree(acomp_ctx->buffers);
> +       }
>  }
>
>  static struct zswap_pool *zswap_pool_create(char *type, char *compressor=
)
> @@ -290,6 +301,7 @@ static struct zswap_pool *zswap_pool_create(char *typ=
e, char *compressor)
>                         return NULL;
>         }
>
> +       /* Many things rely on the zero-initialization. */
>         pool =3D kzalloc(sizeof(*pool), GFP_KERNEL);
>         if (!pool)
>                 return NULL;
> @@ -352,13 +364,28 @@ static struct zswap_pool *zswap_pool_create(char *t=
ype, char *compressor)
>                 goto ref_fail;
>         INIT_LIST_HEAD(&pool->list);
>
> +       /*
> +        * Set the unit of compress batching for large folios, for quick
> +        * retrieval in the zswap_compress() fast path:
> +        * If the compressor is sequential (@pool->compr_batch_size is 1)=
,
> +        * large folios will be compressed in batches of ZSWAP_MAX_BATCH_=
SIZE
> +        * pages, where each page in the batch is compressed sequentially=
.
> +        * We see better performance by processing the folio in batches o=
f
> +        * ZSWAP_MAX_BATCH_SIZE, due to cache locality of working set
> +        * structures.
> +        */
> +       pool->batch_size =3D (pool->compr_batch_size > 1) ?
> +                               pool->compr_batch_size : ZSWAP_MAX_BATCH_=
SIZE;
> +
>         zswap_pool_debug("created", pool);
>
>         return pool;
>
>  ref_fail:
>         for_each_possible_cpu(cpu)
> -               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> +               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> +                                 pool->compr_batch_size);
> +
>  error:
>         if (pool->acomp_ctx)
>                 free_percpu(pool->acomp_ctx);
> @@ -417,7 +444,8 @@ static void zswap_pool_destroy(struct zswap_pool *poo=
l)
>         zswap_pool_debug("destroying", pool);
>
>         for_each_possible_cpu(cpu)
> -               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> +               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> +                                 pool->compr_batch_size);
>
>         free_percpu(pool->acomp_ctx);
>
> @@ -876,6 +904,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
>         struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
>         struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ct=
x, cpu);
>         int ret =3D -ENOMEM;
> +       u8 i;
>
>         /*
>          * The per-CPU pool->acomp_ctx is zero-initialized on allocation.
> @@ -888,10 +917,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, =
struct hlist_node *node)
>         if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
>                 return 0;
>
> -       acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu=
_to_node(cpu));
> -       if (!acomp_ctx->buffer)
> -               return ret;
> -
>         acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0=
, cpu_to_node(cpu));
>         if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
>                 pr_err("could not alloc crypto acomp %s : %ld\n",
> @@ -904,17 +929,36 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>         acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
>         if (IS_ERR_OR_NULL(acomp_ctx->req)) {
>                 pr_err("could not alloc crypto acomp_request %s\n",
> -                      pool->tfm_name);
> +                       pool->tfm_name);

Is this intentional? :)

>                 goto fail;
>         }
>
> -       crypto_init_wait(&acomp_ctx->wait);
> +       /*
> +        * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
> +        * compressor supports batching.
> +        */
> +       pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> +                                    crypto_acomp_batch_size(acomp_ctx->a=
comp));
> +
> +       acomp_ctx->buffers =3D kcalloc_node(pool->compr_batch_size, sizeo=
f(u8 *),
> +                                         GFP_KERNEL, cpu_to_node(cpu));
> +       if (!acomp_ctx->buffers)
> +               goto fail;
> +
> +       for (i =3D 0; i < pool->compr_batch_size; ++i) {
> +               acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE * 2, GFP=
_KERNEL,
> +                                                    cpu_to_node(cpu));
> +               if (!acomp_ctx->buffers[i])
> +                       goto fail;
> +       }
>
>         /*
>          * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
>          * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
>          * won't be called, crypto_wait_req() will return without blockin=
g.
>          */
> +       crypto_init_wait(&acomp_ctx->wait);
> +
>         acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BAC=
KLOG,
>                                    crypto_req_done, &acomp_ctx->wait);
>
> @@ -922,7 +966,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
>         return 0;
>
>  fail:
> -       acomp_ctx_dealloc(acomp_ctx);
> +       acomp_ctx_dealloc(acomp_ctx, pool->compr_batch_size);
>         return ret;
>  }
>
> @@ -942,7 +986,7 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>
>         mutex_lock(&acomp_ctx->mutex);
>
> -       dst =3D acomp_ctx->buffer;
> +       dst =3D acomp_ctx->buffers[0];
>         sg_init_table(&input, 1);
>         sg_set_page(&input, page, PAGE_SIZE, 0);
>
> @@ -1003,19 +1047,19 @@ static bool zswap_decompress(struct zswap_entry *=
entry, struct folio *folio)
>
>         acomp_ctx =3D raw_cpu_ptr(entry->pool->acomp_ctx);
>         mutex_lock(&acomp_ctx->mutex);
> -       obj =3D zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buf=
fer);
> +       obj =3D zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buf=
fers[0]);
>
>         /*
>          * zpool_obj_read_begin() might return a kmap address of highmem =
when
> -        * acomp_ctx->buffer is not used.  However, sg_init_one() does no=
t
> -        * handle highmem addresses, so copy the object to acomp_ctx->buf=
fer.
> +        * acomp_ctx->buffers[0] is not used.  However, sg_init_one() doe=
s not
> +        * handle highmem addresses, so copy the object to acomp_ctx->buf=
fers[0].
>          */
>         if (virt_addr_valid(obj)) {
>                 src =3D obj;
>         } else {
> -               WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffer);
> -               memcpy(acomp_ctx->buffer, obj, entry->length);
> -               src =3D acomp_ctx->buffer;
> +               WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffers[0]);
> +               memcpy(acomp_ctx->buffers[0], obj, entry->length);
> +               src =3D acomp_ctx->buffers[0];
>         }
>
>         sg_init_one(&input, src, entry->length);
> --
> 2.27.0
>

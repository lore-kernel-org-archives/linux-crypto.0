Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EDD26A087;
	Thu, 14 Aug 2025 21:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755206092; cv=none; b=oxm6ajgB+50p22r/Wh7IetuQkHUDdJvy9L0zCFJzHLggBy1yhyE2pxEwu7rfphxq+fCKFbuO63FTc3KanjKI0DVzpujqwmF4JqbXNRDjtGQS+QxtMzlRaQV3ED3nwIBu6jPZIbGZWIV4Xibja2TwwJ7BVXya9Go8XwKym7Z6vic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755206092; c=relaxed/simple;
	bh=ORTsZcImNIqVApE/0mXB58oc2paub55uPJ1TFxN08J8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XhvFJ54mOYGY8zX2588Q0VYn7r7rBDXkuRUlsJcCG77hFWoaFN1XllPSBSoKt58O03lAuohua7c/lYe1V1fZ9P7SoBfeKEf/jf8X1+hXRXuJoBGqUB1d+ZisTbKtLTGlZ1GnsRUjHT0cQzNS24O67RVpJ7ApB1XBpkobcIc81yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J6H5eKqQ; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J6H5eKqQ"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3e57376f57dso3864565ab.1;
        Thu, 14 Aug 2025 14:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755206089; x=1755810889; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOrS6aLPf1tvEjb+Rue+seVuAm04v8ANeD/QhOmLFrU=;
        b=J6H5eKqQkAYwroErOLfis6//5LifneBR4H0tF4NUP9jvW1LKm7Kdkhsxz8IgNWGA/U
         k0uhAy089F75s/uw5UC9T/KDMAmsL1ujpl6F7HsKJUCH5FCnDOJ4Xd7p+Nuulr82ne4s
         4D2U298ETrOlDqAR8mkADfBIHhuprP6888DfRlpo6Tn93IaAw3vkUX7O6SzsbMu13H1a
         Y+4HVaUYecSXUSOVdtp4Yo2q3gv4ieZ2W6IbYy0N5254rjGTlXsN4UdZLs+9EPWf/yDD
         HEBm1nsZvg6bdATmWdiKh6DY+nTtK4Yb3pYtehMPQfDf8O/o1SOrA4M6WocIAqzNzHMn
         aFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755206089; x=1755810889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOrS6aLPf1tvEjb+Rue+seVuAm04v8ANeD/QhOmLFrU=;
        b=ZGsvQ+iKoxyadcltjzvGeWDGn805cdIQee84bLmciKUgIcMeINpHx2dfy5mNggxv/4
         Xd64bF23AjE0ZHn0KcaWipzZIhe+enKRpFl7u+1cHVvCImii3N6ddSJ0wZVBPPdyjnCq
         DZWE3A7VpChgfaJKFRZcwVJY5ySQ8+NVBP5KJXNqfns5DznjSz4uanB8WMRWxsjFxOjA
         syr6TylcYp4R/eMx+5kANk7DY+JHj7HiE/8JXa8ts+u12yQDI2n1pB3DrKH2gKbU699W
         m8mT5JItuDAluo/QCZQpBt9uO93MgtG+P4ES3Dp3DGGOxhFXS8wK+3iANjQz4zzumwg1
         4EwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxkQBwF+lQhYPtrVrCT7zioO2vTC3ytDWjjwBC1wO8WEYRcbH1ipkjw+e9Y5m9huo+qhddB6tp/vq6NGU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvUFqzbtIL1Ex0k2PmlxdSR1XKhmSuTNaJauOGPPRaqccFYGRr
	StJfNYPJ96WGsK3q43gBI64f3JjtCyHnV8NRuFg9ncCbXGwTzsb8RoOiBVjgBmuD3pK7a+c1YVI
	LA4/GwBtHiV6zrid3RLnikQN8R0h0m8g=
X-Gm-Gg: ASbGncvBA+xFr8dOYnPEduk385ECrFCkjaQ2XS/mU+2473Gew6cPQggMR4ah60f/SaA
	umsdIY4Y7v7oCFjcLjSZQRqar1/rELCxBSTsMkXP87l3IDF3mdF7HBk9veRPXn7u5OyiqUehWzr
	3mMcHrIFerzyRL6psvCr6Ha1IFgJSCYxPhxwmKuZ3ANHhA8kcG+QaXELPbNSjN7Km9h22/9Bzlj
	YpEy31AKvoeqPXRAPva1/E=
X-Google-Smtp-Source: AGHT+IH9LzsXBhMNG39CJXE77FKK/CUXMa7NCbJejHcNb51cZTQHxBbIXUUnPqGxzipm380lMhIOCfqdiEdXyuBdPmo=
X-Received: by 2002:a05:6e02:1d9c:b0:3e5:5722:2433 with SMTP id
 e9e14a558f8ab-3e5708ea016mr94779085ab.21.1755206088860; Thu, 14 Aug 2025
 14:14:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-25-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-25-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 14 Aug 2025 14:14:37 -0700
X-Gm-Features: Ac12FXwHDTmM1wGQdgSMQOtLg0XPGNdtLZ7myFUgkvMOPfRa3YqjUxNck3lWUP4
Message-ID: <CAKEwX=NpZ5gjSUJ93BN1c8x1Qfmac6-gKcRxRdAztME2snyCaQ@mail.gmail.com>
Subject: Re: [PATCH v11 24/24] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
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
> This patch introduces a new unified implementation of zswap_compress()
> for compressors that do and do not support batching. This eliminates
> code duplication and facilitates maintainability of the code with the
> introduction of compress batching.
>
> The vectorized implementation of calling the earlier zswap_compress()
> sequentially, one page at a time in zswap_store_pages(), is replaced
> with this new version of zswap_compress() that accepts multiple pages to
> compress as a batch.
>
> If the compressor does not support batching, each page in the batch is
> compressed and stored sequentially.
>
> If the compressor supports batching, for e.g., 'deflate-iaa', the Intel
> IAA hardware accelerator, the batch is compressed in parallel in
> hardware by setting the acomp_ctx->req->kernel_data to contain the
> necessary batching data before calling crypto_acomp_compress(). If all
> requests in the batch are compressed without errors, the compressed
> buffers are then stored in zpool.
>
> Another important change this patch makes is with the acomp_ctx mutex
> locking in zswap_compress(). Earlier, the mutex was held per page's
> compression. With the new code, [un]locking the mutex per page caused
> regressions for software compressors when testing with usemem
> (30 processes) and also kernel compilation with 'allmod' config. The
> regressions were more eggregious when PMD folios were stored. The
> implementation in this commit locks/unlocks the mutex once per batch,
> that resolves the regression.
>
> The use of prefetchw() for zswap entries and likely()/unlikely()
> annotations prevent regressions with software compressors like zstd, and
> generally improve non-batching compressors' performance with the
> batching code by ~3%.
>
> Architectural considerations for the zswap batching framework:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> We have designed the zswap batching framework to be
> hardware-agnostic. It has no dependencies on Intel-specific features and
> can be leveraged by any hardware accelerator or software-based
> compressor. In other words, the framework is open and inclusive by
> design.
>
> Other ongoing work that can use batching:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> This patch-series demonstrates the performance benefits of compress
> batching when used in zswap_store() of large folios. shrink_folio_list()
> "reclaim batching" of any-order folios is the major next work that uses
> the zswap compress batching framework: our testing of kernel_compilation
> with writeback and the zswap shrinker indicates 10X fewer pages get
> written back when we reclaim 32 folios as a batch, as compared to one
> folio at a time: this is with deflate-iaa and with zstd. We expect to
> submit a patch-series with this data and the resulting performance
> improvements shortly. Reclaim batching relieves memory pressure faster
> than reclaiming one folio at a time, hence alleviates the need to scan
> slab memory for writeback.
>
> Nhat has given ideas on using batching with the ongoing kcompressd work,
> as well as beneficially using decompression batching & block IO batching
> to improve zswap writeback efficiency.
>
> Experiments that combine zswap compress batching, reclaim batching,
> swapin_readahead() decompression batching of prefetched pages, and
> writeback batching show that 0 pages are written back with deflate-iaa
> and zstd. For comparison, the baselines for these compressors see
> 200K-800K pages written to disk (kernel compilation 'allmod' config).
>
> To summarize, these are future clients of the batching framework:
>
>    - shrink_folio_list() reclaim batching of multiple folios:
>        Implemented, will submit patch-series.
>    - zswap writeback with decompress batching:
>        Implemented, will submit patch-series.
>    - zram:
>        Implemented, will submit patch-series.
>    - kcompressd:
>        Not yet implemented.
>    - file systems:
>        Not yet implemented.
>    - swapin_readahead() decompression batching of prefetched pages:
>        Implemented, will submit patch-series.
>
> Additionally, any place we have folios that need to be compressed, can
> potentially be parallelized.
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/swap.h  |  23 ++++++
>  mm/zswap.c | 201 ++++++++++++++++++++++++++++++++++++++---------------
>  2 files changed, 168 insertions(+), 56 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 911ad5ff0f89f..2afbf00f59fea 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -11,6 +11,29 @@ extern int page_cluster;
>  #include <linux/swapops.h> /* for swp_offset */
>  #include <linux/blk_types.h> /* for bio_end_io_t */
>
> +/* linux/mm/zswap.c */
> +/*
> + * A compression algorithm that wants to batch compressions/decompressio=
ns
> + * must define its own internal data structures that exactly mirror
> + * @struct swap_batch_comp_data and @struct swap_batch_decomp_data.
> + */
> +struct swap_batch_comp_data {
> +       struct page **pages;
> +       u8 **dsts;
> +       unsigned int *dlens;
> +       int *errors;
> +       u8 nr_comps;
> +};
> +
> +struct swap_batch_decomp_data {
> +       u8 **srcs;
> +       struct page **pages;
> +       unsigned int *slens;
> +       unsigned int *dlens;
> +       int *errors;
> +       u8 nr_decomps;
> +};

This struct is not being used yet right? I assume this is used for
batch zswap load and writeback etc.

Can we introduce them when those series are sent out? Just to limit
the amount of reviewing here :)

> +
>  /* linux/mm/page_io.c */
>  int sio_pool_init(void);
>  struct swap_iocb;
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 8ca69c3f30df2..c30c1f325f573 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -35,6 +35,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/workqueue.h>
>  #include <linux/list_lru.h>
> +#include <linux/prefetch.h>
>
>  #include "swap.h"
>  #include "internal.h"
> @@ -988,71 +989,163 @@ static int zswap_cpu_comp_prepare(unsigned int cpu=
, struct hlist_node *node)
>         return ret;
>  }
>
> -static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> -                          struct zswap_pool *pool)
> +/*
> + * Unified code path for compressors that do and do not support batching=
. This
> + * procedure will compress multiple @nr_pages in @folio starting from th=
e
> + * @start index.
> + *
> + * It is assumed that @nr_pages <=3D ZSWAP_MAX_BATCH_SIZE. zswap_store()=
 makes
> + * sure of this by design.

Maybe add a VM_WARN_ON_ONCE(nr_pages <=3D ZSWAP_MAX_BATCH_SIZE); in
zswap_store_pages() to codify this design choice?

> + *
> + * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor =
does not
> + * support batching.
> + *
> + * If @pool->compr_batch_size is 1, each page is processed sequentially.
> + *
> + * If @pool->compr_batch_size is > 1, compression batching is invoked, e=
xcept if
> + * @nr_pages is 1: if so, we call the fully synchronous non-batching
> + * crypto_acomp API.
> + *
> + * In both cases, if all compressions are successful, the compressed buf=
fers
> + * are stored in zpool.
> + *
> + * A few important changes made to not regress and in fact improve
> + * compression performance with non-batching software compressors, using=
 this
> + * new/batching code:
> + *
> + * 1) acomp_ctx mutex locking:
> + *    Earlier, the mutex was held per page compression. With the new cod=
e,
> + *    [un]locking the mutex per page caused regressions for software
> + *    compressors. We now lock the mutex once per batch, which resolves =
the
> + *    regression.

Makes sense, yeah.

> + *
> + * 2) The prefetchw() and likely()/unlikely() annotations prevent
> + *    regressions with software compressors like zstd, and generally imp=
rove
> + *    non-batching compressors' performance with the batching code by ~3=
%.
> + */
> +static bool zswap_compress(struct folio *folio, long start, unsigned int=
 nr_pages,
> +                          struct zswap_entry *entries[], struct zswap_po=
ol *pool,
> +                          int node_id)
>  {
>         struct crypto_acomp_ctx *acomp_ctx;
>         struct scatterlist input, output;
> -       int comp_ret =3D 0, alloc_ret =3D 0;
> -       unsigned int dlen =3D PAGE_SIZE;
> -       unsigned long handle;
> -       struct zpool *zpool;
> +       struct zpool *zpool =3D pool->zpool;
> +
> +       unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
> +       int errors[ZSWAP_MAX_BATCH_SIZE];
> +
> +       unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);
> +       unsigned int i, j;
> +       int err;
>         gfp_t gfp;
> -       u8 *dst;
> +
> +       gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
>
>         acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
>
>         mutex_lock(&acomp_ctx->mutex);
>
> -       dst =3D acomp_ctx->buffers[0];
> -       sg_init_table(&input, 1);
> -       sg_set_page(&input, page, PAGE_SIZE, 0);
> -
>         /*
> -        * We need PAGE_SIZE * 2 here since there maybe over-compression =
case,
> -        * and hardware-accelerators may won't check the dst buffer size,=
 so
> -        * giving the dst buffer with enough length to avoid buffer overf=
low.
> +        * Note:
> +        * [i] refers to the incoming batch space and is used to
> +        *     index into the folio pages, @entries and @errors.
>          */
> -       sg_init_one(&output, dst, PAGE_SIZE * 2);
> -       acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SI=
ZE, dlen);
> +       for (i =3D 0; i < nr_pages; i +=3D nr_comps) {
> +               if (nr_comps =3D=3D 1) {
> +                       sg_init_table(&input, 1);
> +                       sg_set_page(&input, folio_page(folio, start + i),=
 PAGE_SIZE, 0);
>
> -       /*
> -        * it maybe looks a little bit silly that we send an asynchronous=
 request,
> -        * then wait for its completion synchronously. This makes the pro=
cess look
> -        * synchronous in fact.
> -        * Theoretically, acomp supports users send multiple acomp reques=
ts in one
> -        * acomp instance, then get those requests done simultaneously. b=
ut in this
> -        * case, zswap actually does store and load page by page, there i=
s no
> -        * existing method to send the second page before the first page =
is done
> -        * in one thread doing zwap.
> -        * but in different threads running on different cpu, we have dif=
ferent
> -        * acomp instance, so multiple threads can do (de)compression in =
parallel.
> -        */
> -       comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
> -       dlen =3D acomp_ctx->req->dlen;
> -       if (comp_ret)
> -               goto unlock;
> +                       /*
> +                        * We need PAGE_SIZE * 2 here since there maybe o=
ver-compression case,
> +                        * and hardware-accelerators may won't check the =
dst buffer size, so
> +                        * giving the dst buffer with enough length to av=
oid buffer overflow.
> +                        */
> +                       sg_init_one(&output, acomp_ctx->buffers[0], PAGE_=
SIZE * 2);
> +                       acomp_request_set_params(acomp_ctx->req, &input,
> +                                                &output, PAGE_SIZE, PAGE=
_SIZE);
> +
> +                       errors[i] =3D crypto_wait_req(crypto_acomp_compre=
ss(acomp_ctx->req),
> +                                                   &acomp_ctx->wait);
> +                       if (unlikely(errors[i]))
> +                               goto compress_error;
> +
> +                       dlens[i] =3D acomp_ctx->req->dlen;
> +               } else {
> +                       struct page *pages[ZSWAP_MAX_BATCH_SIZE];
> +                       unsigned int k;
> +
> +                       for (k =3D 0; k < nr_pages; ++k)
> +                               pages[k] =3D folio_page(folio, start + k)=
;
> +
> +                       struct swap_batch_comp_data batch_comp_data =3D {
> +                               .pages =3D pages,
> +                               .dsts =3D acomp_ctx->buffers,
> +                               .dlens =3D dlens,
> +                               .errors =3D errors,
> +                               .nr_comps =3D nr_pages,
> +                       };
> +
> +                       acomp_ctx->req->kernel_data =3D &batch_comp_data;
> +
> +                       if (unlikely(crypto_acomp_compress(acomp_ctx->req=
)))
> +                               goto compress_error;

I assume this is a new crypto API?

I'll let Herbert decide whether this makes sense :)

> +               }
>
> -       zpool =3D pool->zpool;
> -       gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
> -       alloc_ret =3D zpool_malloc(zpool, dlen, gfp, &handle, page_to_nid=
(page));
> -       if (alloc_ret)
> -               goto unlock;
> -
> -       zpool_obj_write(zpool, handle, dst, dlen);
> -       entry->handle =3D handle;
> -       entry->length =3D dlen;
> -
> -unlock:
> -       if (comp_ret =3D=3D -ENOSPC || alloc_ret =3D=3D -ENOSPC)
> -               zswap_reject_compress_poor++;
> -       else if (comp_ret)
> -               zswap_reject_compress_fail++;
> -       else if (alloc_ret)
> -               zswap_reject_alloc_fail++;
> +               /*
> +                * All @nr_comps pages were successfully compressed.
> +                * Store the pages in zpool.
> +                *
> +                * Note:
> +                * [j] refers to the incoming batch space and is used to
> +                *     index into the folio pages, @entries, @dlens and @=
errors.
> +                * [k] refers to the @acomp_ctx space, as determined by
> +                *     @pool->compr_batch_size, and is used to index into
> +                *     @acomp_ctx->buffers.
> +                */
> +               for (j =3D i; j < i + nr_comps; ++j) {
> +                       unsigned int k =3D j - i;
> +                       unsigned long handle;
> +
> +                       /*
> +                        * prefetchw() minimizes cache-miss latency by
> +                        * moving the zswap entry to the cache before it
> +                        * is written to; reducing sys time by ~1.5% for
> +                        * non-batching software compressors.
> +                        */
> +                       prefetchw(entries[j]);
> +                       err =3D zpool_malloc(zpool, dlens[j], gfp, &handl=
e, node_id);
> +
> +                       if (unlikely(err)) {
> +                               if (err =3D=3D -ENOSPC)
> +                                       zswap_reject_compress_poor++;
> +                               else
> +                                       zswap_reject_alloc_fail++;
> +
> +                               goto err_unlock;
> +                       }
> +
> +                       zpool_obj_write(zpool, handle, acomp_ctx->buffers=
[k], dlens[j]);
> +                       entries[j]->handle =3D handle;
> +                       entries[j]->length =3D dlens[j];
> +               }
> +       } /* finished compress and store nr_pages. */
>
>         mutex_unlock(&acomp_ctx->mutex);
> -       return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
> +       return true;
> +
> +compress_error:
> +       for (j =3D i; j < i + nr_comps; ++j) {
> +               if (errors[j]) {
> +                       if (errors[j] =3D=3D -ENOSPC)
> +                               zswap_reject_compress_poor++;
> +                       else
> +                               zswap_reject_compress_fail++;
> +               }
> +       }
> +
> +err_unlock:
> +       mutex_unlock(&acomp_ctx->mutex);
> +       return false;
>  }
>
>  static bool zswap_decompress(struct zswap_entry *entry, struct folio *fo=
lio)
> @@ -1590,12 +1683,8 @@ static bool zswap_store_pages(struct folio *folio,
>                 INIT_LIST_HEAD(&entries[i]->lru);
>         }
>
> -       for (i =3D 0; i < nr_pages; ++i) {
> -               struct page *page =3D folio_page(folio, start + i);
> -
> -               if (!zswap_compress(page, entries[i], pool))
> -                       goto store_pages_failed;
> -       }
> +       if (unlikely(!zswap_compress(folio, start, nr_pages, entries, poo=
l, node_id)))
> +               goto store_pages_failed;
>
>         for (i =3D 0; i < nr_pages; ++i) {
>                 struct zswap_entry *old, *entry =3D entries[i];
> --
> 2.27.0
>

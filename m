Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1941C1F29
	for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 20:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732566044; cv=none; b=KdQS899LNrXdzEoBJDcUm/raPlIIQfHKBqMGIbzapjJp1O1YzkO0REvSy1R3c88XUignuvd1R78a+S8SryAMyzb/YWwWA87kPEwfucmmOvlCpBSVCCDrxrBio6Oabckh1ifw+1Gj9CqCNsaD+k9P+8c02YndEYqZaeWHA+CFWaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732566044; c=relaxed/simple;
	bh=6Yux4aOoBkL3PF1KQZO9qKPqMpl45vaTw4osBMhioHA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fm0S1Icj3lEBqgGPJNNK29Ay4dK16Kjs37i7GbpCjavvo4ZSyL/tWgrsMU4vmZEUrS0Mcry7PQ4vdZcWAno+gmtIKqNHwMGDcbjiRCChZzeH26EpMa/wEJAou+jpqDO3dNHKjKiJrwx+ZF6NvkD02LKDERg8z5sOWJjFzV3ctn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BAAdStHN; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BAAdStHN"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3ea3cc9a5ddso973911b6e.3
        for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 12:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732566039; x=1733170839; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K15Cxyi5+UfPaJ8EH8uzAU+dfC/JRq94yjguouGEAB4=;
        b=BAAdStHNCJWvDCJxbJYoF2CTJsz/N1tHJ9/Mf/zv1eVQJLp3ZygWZ6n0dHwKgjyg+g
         DFDxy6qzYKAU9bh+hkDickuHKgNtvz7ooafQ8rBLOg9g1QCAszWOL+tspE8DIXULdLhn
         DYdrl5UblNnTPa9CJuJ5Nq8PZuGFTDKdNS+U3+XDF8mfZ3+bngMQNH0zfQbamW1lI1xf
         ysIc7h840gm6asoTLxK7UQONGwmf8f7LqOm/KmjOQqh3A64GBoDKiLDQmxMZBSKJ3qPJ
         SelqVMd0wlvR+eSOEBXImNqqA/TSVe/y1V1xeSfxxswEeaSzvcCj0t/fYYYXM0+J/Myy
         P+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732566039; x=1733170839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K15Cxyi5+UfPaJ8EH8uzAU+dfC/JRq94yjguouGEAB4=;
        b=h99SuXapl6bBhuD2JrELbQFS4EXa/gPiLBb4DIC5QeQ36FI8wJHytx9YnGePAhndvA
         cqpEOYlECDkYYga1kWVSqg+vTWJmZz6fJsRliZ59YKatONAhO5cZskjzj4/IadsU6jLg
         V0CgX3tiG0wnYJ3zTds1rqORXn5fwX3cQdZHLL78yDz8HlaQ3XHz7PNlcJxGia/1moyG
         lCHqexn/HzAZ3yWn1tyv+xNRJP9FQJV9+I1R2nQb5FtBirptVsk8JDNf0LT6UkvljG7C
         ZCyyslijSniF9TInVLh7huRdoFXKrfdHK1wDDTJ35qMcdSWxcshxnoTSIDtX/YaJhJ8d
         mY9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUHGUVZyYebiEFRAcLwVSYN0XCa1y+Wnvue5T5er/DV4Vj4kmduCfV6oVoHMi8r59HLCi1WbzyDl7I6J9o=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm5aFC8bdFhKYvs1J1IIdDwR4Q1onRSDG/N5MMGcGOU9Jgj9cp
	0w0FRMTT0vMUdCHkQSR9FK0EHOUaZ7Mx2DUNiMfrXDuYq9PpdgySx2JSj4MkgxRJkSpQTZDxzsO
	A2aIsVIJ2Nt+bCiR9B97agikEVguR0sROVcWi
X-Gm-Gg: ASbGncsWkS/Ix/9uZmZUD1aAlP/AzhXkOTla7SWOR3qmd6Xc2IrY9OQXXAahtc4cE7a
	GJuZsF5nSCdeKfKdRWuVQb9tWs2QjDfp0lLvdesA+g/MtH4IoOmonC1BoNUOmNA==
X-Google-Smtp-Source: AGHT+IE6QjHsp3kBDJtsCsxWu/+ifV89iN6thOL391CoG5/nFYp1dPbOu4HThC+xfQ4XFQuaStN6StaC4VpIAntYl4M=
X-Received: by 2002:a05:6808:2445:b0:3e7:bd03:e44f with SMTP id
 5614622812f47-3e9157ab35emr12714769b6e.7.1732566038340; Mon, 25 Nov 2024
 12:20:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com> <20241123070127.332773-11-kanchana.p.sridhar@intel.com>
In-Reply-To: <20241123070127.332773-11-kanchana.p.sridhar@intel.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 25 Nov 2024 12:20:01 -0800
Message-ID: <CAJD7tkb0WyLD3hxQ5fHWHogyW5g+eF+GrR15r0PjK9YbFO3szg@mail.gmail.com>
Subject: Re: [PATCH v4 10/10] mm: zswap: Compress batching with Intel IAA in
 zswap_batch_store() of large folios.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, ying.huang@intel.com, 21cnbao@gmail.com, 
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, clabbe@baylibre.com, 
	ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, wajdi.k.feghali@intel.com, 
	vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 22, 2024 at 11:01=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch adds two new zswap API:
>
>  1) bool zswap_can_batch(void);
>  2) void zswap_batch_store(struct folio_batch *batch, int *errors);
>
> Higher level mm code, for instance, swap_writepage(), can query if the
> current zswap pool supports batching, by calling zswap_can_batch(). If so
> it can invoke zswap_batch_store() to swapout a large folio much more
> efficiently to zswap, instead of calling zswap_store().
>
> Hence, on systems with Intel IAA hardware compress/decompress accelerator=
s,
> swap_writepage() will invoke zswap_batch_store() for large folios.
>
> zswap_batch_store() will call crypto_acomp_batch_compress() to compress u=
p
> to SWAP_CRYPTO_BATCH_SIZE (i.e. 8) pages in large folios in parallel usin=
g
> the multiple compress engines available in IAA.
>
> On platforms with multiple IAA devices per package, compress jobs from al=
l
> cores in a package will be distributed among all IAA devices in the packa=
ge
> by the iaa_crypto driver.
>
> The newly added zswap_batch_store() follows the general structure of
> zswap_store(). Some amount of restructuring and optimization is done to
> minimize failure points for a batch, fail early and maximize the zswap
> store pipeline occupancy with SWAP_CRYPTO_BATCH_SIZE pages, potentially
> from multiple folios in future. This is intended to maximize reclaim
> throughput with the IAA hardware parallel compressions.
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Yosry Ahmed <yosryahmed@google.com>

This is definitely not what I suggested :)

I won't speak for Johannes here but I suspect it's not quite what he
wanted either.

More below.

> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  include/linux/zswap.h |  12 +
>  mm/page_io.c          |  16 +-
>  mm/zswap.c            | 639 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 666 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 9ad27ab3d222..a05f59139a6e 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -4,6 +4,7 @@
>
>  #include <linux/types.h>
>  #include <linux/mm_types.h>
> +#include <linux/pagevec.h>
>
>  struct lruvec;
>
> @@ -33,6 +34,8 @@ struct zswap_lruvec_state {
>
>  unsigned long zswap_total_pages(void);
>  bool zswap_store(struct folio *folio);
> +bool zswap_can_batch(void);
> +void zswap_batch_store(struct folio_batch *batch, int *errors);
>  bool zswap_load(struct folio *folio);
>  void zswap_invalidate(swp_entry_t swp);
>  int zswap_swapon(int type, unsigned long nr_pages);
> @@ -51,6 +54,15 @@ static inline bool zswap_store(struct folio *folio)
>         return false;
>  }
>
> +static inline bool zswap_can_batch(void)
> +{
> +       return false;
> +}
> +
> +static inline void zswap_batch_store(struct folio_batch *batch, int *err=
ors)
> +{
> +}
> +
>  static inline bool zswap_load(struct folio *folio)
>  {
>         return false;
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 4b4ea8e49cf6..271d3a40c0c1 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -276,7 +276,21 @@ int swap_writepage(struct page *page, struct writeba=
ck_control *wbc)
>                  */
>                 swap_zeromap_folio_clear(folio);
>         }
> -       if (zswap_store(folio)) {
> +
> +       if (folio_test_large(folio) && zswap_can_batch()) {
> +               struct folio_batch batch;
> +               int error =3D -1;
> +
> +               folio_batch_init(&batch);
> +               folio_batch_add(&batch, folio);
> +               zswap_batch_store(&batch, &error);
> +
> +               if (!error) {
> +                       count_mthp_stat(folio_order(folio), MTHP_STAT_ZSW=
POUT);
> +                       folio_unlock(folio);
> +                       return 0;
> +               }

First of all, why does the code outside of zswap has to care or be changed?

We should still call zswap_store() here, and within that figure out if
we can do batching or not. I am not sure what we gain by adding a
separate interface here, especially that we are creating a batch of a
single folio and passing it in anyway. I suspect that this leaked here
from the patch that batches unrelated folios swapout, but please don't
do that. This patch is about batching compression of pages in the same
folio, and for that, there is no need for the code here to do anything
differently or pass in a folio batch.

Also, eliminating the need for a folio batch eliminates the need to
call the batches in the zswap code "sub batches", which is really
confusing imo :)

> +       } else if (zswap_store(folio)) {
>                 count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
>                 folio_unlock(folio);
>                 return 0;
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 173f7632990e..53c8e39b778b 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -229,6 +229,80 @@ static DEFINE_MUTEX(zswap_init_lock);
>  /* init completed, but couldn't create the initial pool */
>  static bool zswap_has_pool;
>
> +/*
> + * struct zswap_batch_store_sub_batch:
> + *
> + * This represents a sub-batch of SWAP_CRYPTO_BATCH_SIZE pages during IA=
A
> + * compress batching of a folio or (conceptually, a reclaim batch of) fo=
lios.
> + * The new zswap_batch_store() API will break down the batch of folios b=
eing
> + * reclaimed into sub-batches of SWAP_CRYPTO_BATCH_SIZE pages, batch com=
press
> + * the pages by calling the iaa_crypto driver API crypto_acomp_batch_com=
press();
> + * and storing the sub-batch in zpool/xarray before updating objcg/vm/zs=
wap
> + * stats.
> + *
> + * Although the page itself is represented directly, the structure adds =
a
> + * "u8 folio_id" to represent an index for the folio in a conceptual
> + * "reclaim batch of folios" that can be passed to zswap_store(). Concep=
tually,
> + * this allows for up to 256 folios that can be passed to zswap_store().
> + * Even though the folio_id seems redundant in the context of a single l=
arge
> + * folio being stored by zswap, it does simplify error handling and redu=
ndant
> + * computes/rewinding state, all of which can add latency. Since the
> + * zswap_batch_store() of a large folio can fail for any of these reason=
s --
> + * compress errors, zpool malloc errors, xarray store errors -- the proc=
edures
> + * that detect these errors for a sub-batch, can all call a single clean=
up
> + * procedure, zswap_batch_cleanup(), which will de-allocate zpool memory=
 and
> + * zswap_entries for the sub-batch and set the "errors[folio_id]" to -EI=
NVAL.
> + * All subsequent procedures that operate on a sub-batch will do nothing=
 if the
> + * errors[folio_id] is non-0. Hence, the folio_id facilitates the use of=
 the
> + * "errors" passed to zswap_batch_store() as a global folio error status=
 for a
> + * single folio (which could also be a folio in the folio_batch).
> + *
> + * The sub-batch concept could be further evolved to use pipelining to
> + * overlap CPU computes with IAA computes. For instance, we could stage
> + * the post-compress computes for sub-batch "N-1" to happen in parallel =
with
> + * IAA batch compression of sub-batch "N".
> + *
> + * We begin by developing the concept of compress batching. Pipelining w=
ith
> + * overlap can be future work.

I suppose all this gets simplified once we eliminate passing in a
folio batch to zswap. In that case, a batch is just a construct
created by zswap if the allocator supports batching page compression.
There is also no need to describe what the code does, especially a
centralized comment like that rather than per-function docs/comments.

We also don't want the comments to be very specific to IAA. It is
currently the only implementation, but the code here is not specific
to IAA AFAICT. It should just be an example or so.

> + *
> + * @pages: The individual pages in the sub-batch. There are no assumptio=
ns
> + *         about all of them belonging to the same folio.
> + * @dsts: The destination buffers for batch compress of the sub-batch.
> + * @dlens: The destination length constraints, and eventual compressed l=
engths
> + *         of successful compressions.
> + * @comp_errors: The compress error status for each page in the sub-batc=
h, set
> + *               by crypto_acomp_batch_compress().
> + * @folio_ids: The containing folio_id of each sub-batch page.
> + * @swpentries: The page_swap_entry() for each corresponding sub-batch p=
age.
> + * @objcgs: The objcg for each corresponding sub-batch page.
> + * @entries: The zswap_entry for each corresponding sub-batch page.
> + * @nr_pages: Total number of pages in @sub_batch.
> + * @pool: A valid zswap_pool that can_batch.
> + *
> + * Note:
> + * The max sub-batch size is SWAP_CRYPTO_BATCH_SIZE, currently 8UL.
> + * Hence, if SWAP_CRYPTO_BATCH_SIZE exceeds 256, @nr_pages needs to beco=
me u16.
> + * The sub-batch representation is future-proofed to a small extent to b=
e able
> + * to easily scale the zswap_batch_store() implementation to handle a co=
nceptual
> + * "reclaim batch of folios"; without addding too much complexity, while
> + * benefiting from simpler error handling, localized sub-batch resources=
 cleanup
> + * and avoiding expensive rewinding state. If this conceptual number of =
reclaim
> + * folios sent to zswap_batch_store() exceeds 256, @folio_ids needs to
> + * become u16.
> + */
> +struct zswap_batch_store_sub_batch {
> +       struct page *pages[SWAP_CRYPTO_BATCH_SIZE];
> +       u8 *dsts[SWAP_CRYPTO_BATCH_SIZE];
> +       unsigned int dlens[SWAP_CRYPTO_BATCH_SIZE];
> +       int comp_errors[SWAP_CRYPTO_BATCH_SIZE]; /* folio error status. *=
/
> +       u8 folio_ids[SWAP_CRYPTO_BATCH_SIZE];
> +       swp_entry_t swpentries[SWAP_CRYPTO_BATCH_SIZE];
> +       struct obj_cgroup *objcgs[SWAP_CRYPTO_BATCH_SIZE];
> +       struct zswap_entry *entries[SWAP_CRYPTO_BATCH_SIZE];
> +       u8 nr_pages;
> +       struct zswap_pool *pool;
> +};
> +
>  /*********************************
>  * helpers and fwd declarations
>  **********************************/
> @@ -1705,6 +1779,571 @@ void zswap_invalidate(swp_entry_t swp)
>                 zswap_entry_free(entry);
>  }
>
> +/******************************************************
> + * zswap_batch_store() with compress batching.
> + ******************************************************/
> +
> +/*
> + * Note: If SWAP_CRYPTO_BATCH_SIZE exceeds 256, change the
> + * u8 stack variables in the next several functions, to u16.
> + */
> +bool zswap_can_batch(void)
> +{
> +       struct zswap_pool *pool;
> +       bool ret =3D false;
> +
> +       pool =3D zswap_pool_current_get();
> +
> +       if (!pool)
> +               return ret;
> +
> +       if (pool->can_batch)
> +               ret =3D true;
> +
> +       zswap_pool_put(pool);
> +
> +       return ret;
> +}
> +
> +/*
> + * If the zswap store fails or zswap is disabled, we must invalidate
> + * the possibly stale entries which were previously stored at the
> + * offsets corresponding to each page of the folio. Otherwise,
> + * writeback could overwrite the new data in the swapfile.
> + */
> +static void zswap_delete_stored_entries(struct folio *folio)
> +{
> +       swp_entry_t swp =3D folio->swap;
> +       unsigned type =3D swp_type(swp);
> +       pgoff_t offset =3D swp_offset(swp);
> +       struct zswap_entry *entry;
> +       struct xarray *tree;
> +       long index;
> +
> +       for (index =3D 0; index < folio_nr_pages(folio); ++index) {
> +               tree =3D swap_zswap_tree(swp_entry(type, offset + index))=
;
> +               entry =3D xa_erase(tree, offset + index);
> +               if (entry)
> +                       zswap_entry_free(entry);
> +       }
> +}
> +
> +static __always_inline void zswap_batch_reset(struct zswap_batch_store_s=
ub_batch *sb)
> +{
> +       sb->nr_pages =3D 0;
> +}
> +
> +/*
> + * Upon encountering the first sub-batch page in a folio with an error d=
ue to
> + * any of the following:
> + *  - compression
> + *  - zpool malloc
> + *  - xarray store
> + * , cleanup the sub-batch resources (zpool memory, zswap_entry) for all=
 other
> + * sub_batch elements belonging to the same folio, using the "error_foli=
o_id".
> + *
> + * Set the "errors[error_folio_id] to signify to all downstream computes=
 in
> + * zswap_batch_store(), that no further processing is required for the f=
olio
> + * with "error_folio_id" in the batch: this folio's zswap store status w=
ill
> + * be considered an error, and existing zswap_entries in the xarray will=
 be
> + * deleted before zswap_batch_store() exits.
> + */
> +static void zswap_batch_cleanup(struct zswap_batch_store_sub_batch *sb,
> +                               int *errors,
> +                               u8 error_folio_id)
> +{
> +       u8 i;
> +
> +       if (errors[error_folio_id])
> +               return;
> +
> +       for (i =3D 0; i < sb->nr_pages; ++i) {
> +               if (sb->folio_ids[i] =3D=3D error_folio_id) {
> +                       if (sb->entries[i]) {
> +                               if (!IS_ERR_VALUE(sb->entries[i]->handle)=
)
> +                                       zpool_free(sb->pool->zpool, sb->e=
ntries[i]->handle);
> +
> +                               zswap_entry_cache_free(sb->entries[i]);
> +                               sb->entries[i] =3D NULL;
> +                       }
> +               }
> +       }
> +
> +       errors[error_folio_id] =3D -EINVAL;
> +}
> +
> +/*
> + * Returns true if the entry was successfully
> + * stored in the xarray, and false otherwise.
> + */
> +static bool zswap_store_entry(swp_entry_t page_swpentry, struct zswap_en=
try *entry)
> +{
> +       struct zswap_entry *old =3D xa_store(swap_zswap_tree(page_swpentr=
y),
> +                                          swp_offset(page_swpentry),
> +                                          entry, GFP_KERNEL);
> +       if (xa_is_err(old)) {
> +               int err =3D xa_err(old);
> +
> +               WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error: %d\=
n", err);
> +               zswap_reject_alloc_fail++;
> +               return false;
> +       }
> +
> +       /*
> +        * We may have had an existing entry that became stale when
> +        * the folio was redirtied and now the new version is being
> +        * swapped out. Get rid of the old.
> +        */
> +       if (old)
> +               zswap_entry_free(old);
> +
> +       return true;
> +}
> +
> +/*
> + * The stats accounting makes no assumptions about all pages in the sub-=
batch
> + * belonging to the same folio, or having the same objcg; while still do=
ing
> + * the updates in aggregation.
> + */
> +static void zswap_batch_xarray_stats(struct zswap_batch_store_sub_batch =
*sb,
> +                                    int *errors)
> +{
> +       int nr_objcg_pages =3D 0, nr_pages =3D 0;
> +       struct obj_cgroup *objcg =3D NULL;
> +       size_t compressed_bytes =3D 0;
> +       u8 i;
> +
> +       for (i =3D 0; i < sb->nr_pages; ++i) {
> +               if (errors[sb->folio_ids[i]])
> +                       continue;
> +
> +               if (!zswap_store_entry(sb->swpentries[i], sb->entries[i])=
) {
> +                       zswap_batch_cleanup(sb, errors, sb->folio_ids[i])=
;
> +                       continue;
> +               }
> +
> +               /*
> +                * The entry is successfully compressed and stored in the=
 tree,
> +                * there is no further possibility of failure. Grab refs =
to the
> +                * pool and objcg. These refs will be dropped by
> +                * zswap_entry_free() when the entry is removed from the =
tree.
> +                */
> +               zswap_pool_get(sb->pool);
> +               if (sb->objcgs[i])
> +                       obj_cgroup_get(sb->objcgs[i]);
> +
> +               /*
> +                * We finish initializing the entry while it's already in=
 xarray.
> +                * This is safe because:
> +                *
> +                * 1. Concurrent stores and invalidations are excluded by=
 folio
> +                *    lock.
> +                *
> +                * 2. Writeback is excluded by the entry not being on the=
 LRU yet.
> +                *    The publishing order matters to prevent writeback f=
rom seeing
> +                *    an incoherent entry.
> +                */
> +               sb->entries[i]->pool =3D sb->pool;
> +               sb->entries[i]->swpentry =3D sb->swpentries[i];
> +               sb->entries[i]->objcg =3D sb->objcgs[i];
> +               sb->entries[i]->referenced =3D true;
> +               if (sb->entries[i]->length) {
> +                       INIT_LIST_HEAD(&(sb->entries[i]->lru));
> +                       zswap_lru_add(&zswap_list_lru, sb->entries[i]);
> +               }
> +
> +               if (!objcg && sb->objcgs[i]) {
> +                       objcg =3D sb->objcgs[i];
> +               } else if (objcg && sb->objcgs[i] && (objcg !=3D sb->objc=
gs[i])) {
> +                       obj_cgroup_charge_zswap(objcg, compressed_bytes);
> +                       count_objcg_events(objcg, ZSWPOUT, nr_objcg_pages=
);
> +                       compressed_bytes =3D 0;
> +                       nr_objcg_pages =3D 0;
> +                       objcg =3D sb->objcgs[i];
> +               }
> +
> +               if (sb->objcgs[i]) {
> +                       compressed_bytes +=3D sb->entries[i]->length;
> +                       ++nr_objcg_pages;
> +               }
> +
> +               ++nr_pages;
> +       } /* for sub-batch pages. */
> +
> +       if (objcg) {
> +               obj_cgroup_charge_zswap(objcg, compressed_bytes);
> +               count_objcg_events(objcg, ZSWPOUT, nr_objcg_pages);
> +       }
> +
> +       atomic_long_add(nr_pages, &zswap_stored_pages);
> +       count_vm_events(ZSWPOUT, nr_pages);
> +}
> +
> +static void zswap_batch_zpool_store(struct zswap_batch_store_sub_batch *=
sb,
> +                                   int *errors)
> +{
> +       u8 i;
> +
> +       for (i =3D 0; i < sb->nr_pages; ++i) {
> +               struct zpool *zpool;
> +               unsigned long handle;
> +               char *buf;
> +               gfp_t gfp;
> +               int err;
> +
> +               /* Skip pages belonging to folios that had compress error=
s. */
> +               if (errors[sb->folio_ids[i]])
> +                       continue;
> +
> +               zpool =3D sb->pool->zpool;
> +               gfp =3D __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLA=
IM;
> +               if (zpool_malloc_support_movable(zpool))
> +                       gfp |=3D __GFP_HIGHMEM | __GFP_MOVABLE;
> +               err =3D zpool_malloc(zpool, sb->dlens[i], gfp, &handle);
> +
> +               if (err) {
> +                       if (err =3D=3D -ENOSPC)
> +                               zswap_reject_compress_poor++;
> +                       else
> +                               zswap_reject_alloc_fail++;
> +
> +                       /*
> +                        * A zpool malloc error should trigger cleanup fo=
r
> +                        * other same-folio pages in the sub-batch, and z=
pool
> +                        * resources/zswap_entries for those pages should=
 be
> +                        * de-allocated.
> +                        */
> +                       zswap_batch_cleanup(sb, errors, sb->folio_ids[i])=
;
> +                       continue;
> +               }
> +
> +               buf =3D zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
> +               memcpy(buf, sb->dsts[i], sb->dlens[i]);
> +               zpool_unmap_handle(zpool, handle);
> +
> +               sb->entries[i]->handle =3D handle;
> +               sb->entries[i]->length =3D sb->dlens[i];
> +       }
> +}
> +
> +static void zswap_batch_proc_comp_errors(struct zswap_batch_store_sub_ba=
tch *sb,
> +                                        int *errors)
> +{
> +       u8 i;
> +
> +       for (i =3D 0; i < sb->nr_pages; ++i) {
> +               if (sb->comp_errors[i]) {
> +                       if (sb->comp_errors[i] =3D=3D -ENOSPC)
> +                               zswap_reject_compress_poor++;
> +                       else
> +                               zswap_reject_compress_fail++;
> +
> +                       if (!errors[sb->folio_ids[i]])
> +                               zswap_batch_cleanup(sb, errors, sb->folio=
_ids[i]);
> +               }
> +       }
> +}
> +
> +/*
> + * Batch compress up to SWAP_CRYPTO_BATCH_SIZE pages with IAA.
> + * It is important to note that the SWAP_CRYPTO_BATCH_SIZE resources
> + * resources are allocated for the pool's per-cpu acomp_ctx during cpu
> + * hotplug only if the crypto_acomp has registered either
> + * batch_compress() and batch_decompress().
> + * The iaa_crypto driver registers implementations for both these API.
> + * Hence, if IAA is the zswap compressor, the call to
> + * crypto_acomp_batch_compress() will compress the pages in parallel,
> + * resulting in significant performance improvements as compared to
> + * software compressors.
> + */
> +static void zswap_batch_compress(struct zswap_batch_store_sub_batch *sb,
> +                                int *errors)
> +{
> +       struct crypto_acomp_ctx *acomp_ctx =3D raw_cpu_ptr(sb->pool->acom=
p_ctx);
> +       u8 i;
> +
> +       mutex_lock(&acomp_ctx->mutex);
> +
> +       BUG_ON(acomp_ctx->nr_reqs !=3D SWAP_CRYPTO_BATCH_SIZE);
> +
> +       for (i =3D 0; i < sb->nr_pages; ++i) {
> +               sb->dsts[i] =3D acomp_ctx->buffers[i];
> +               sb->dlens[i] =3D PAGE_SIZE;
> +       }
> +
> +       /*
> +        * Batch compress sub-batch "N". If IAA is the compressor, the
> +        * hardware will compress multiple pages in parallel.
> +        */
> +       crypto_acomp_batch_compress(
> +               acomp_ctx->reqs,
> +               &acomp_ctx->wait,
> +               sb->pages,
> +               sb->dsts,
> +               sb->dlens,
> +               sb->comp_errors,
> +               sb->nr_pages);
> +
> +       /*
> +        * Scan the sub-batch for any compression errors,
> +        * and invalidate pages with errors, along with other
> +        * pages belonging to the same folio as the error page(s).
> +        * Set the folio's error status in "errors" so that no
> +        * further zswap_batch_store() processing is done for
> +        * the folio(s) with compression errors.
> +        */
> +       zswap_batch_proc_comp_errors(sb, errors);
> +
> +       zswap_batch_zpool_store(sb, errors);
> +
> +       mutex_unlock(&acomp_ctx->mutex);
> +}
> +
> +static void zswap_batch_add_pages(struct zswap_batch_store_sub_batch *sb=
,
> +                                 struct folio *folio,
> +                                 u8 folio_id,
> +                                 struct obj_cgroup *objcg,
> +                                 struct zswap_entry *entries[],
> +                                 long start_idx,
> +                                 u8 nr)
> +{
> +       long index;
> +
> +       for (index =3D start_idx; index < (start_idx + nr); ++index) {
> +               u8 i =3D sb->nr_pages;
> +               struct page *page =3D folio_page(folio, index);
> +               sb->pages[i] =3D page;
> +               sb->swpentries[i] =3D page_swap_entry(page);
> +               sb->folio_ids[i] =3D folio_id;
> +               sb->objcgs[i] =3D objcg;
> +               sb->entries[i] =3D entries[index - start_idx];
> +               sb->comp_errors[i] =3D 0;
> +               ++sb->nr_pages;
> +       }
> +}
> +
> +/* Allocate entries for the next sub-batch. */
> +static int zswap_batch_alloc_entries(struct zswap_entry *entries[], int =
node_id, u8 nr)
> +{
> +       u8 i;
> +
> +       for (i =3D 0; i < nr; ++i) {
> +               entries[i] =3D zswap_entry_cache_alloc(GFP_KERNEL, node_i=
d);
> +               if (!entries[i]) {
> +                       u8 j;
> +
> +                       zswap_reject_kmemcache_fail++;
> +                       for (j =3D 0; j < i; ++j)
> +                               zswap_entry_cache_free(entries[j]);
> +                       return -EINVAL;
> +               }
> +
> +               entries[i]->handle =3D (unsigned long)ERR_PTR(-EINVAL);
> +       }
> +
> +       return 0;
> +}
> +
> +static bool zswap_batch_comp_folio(struct folio *folio, int *errors, u8 =
folio_id,
> +                                  struct obj_cgroup *objcg,
> +                                  struct zswap_batch_store_sub_batch *su=
b_batch,
> +                                  bool last)
> +{
> +       long folio_start_idx =3D 0, nr_folio_pages =3D folio_nr_pages(fol=
io);
> +       struct zswap_entry *entries[SWAP_CRYPTO_BATCH_SIZE];
> +       int node_id =3D folio_nid(folio);
> +
> +       /*
> +        * Iterate over the pages in the folio passed in. Construct compr=
ess
> +        * sub-batches of up to SWAP_CRYPTO_BATCH_SIZE pages. Process eac=
h
> +        * sub-batch with IAA batch compression. Detect errors from batch
> +        * compression and set the folio's error status.
> +        */
> +       while (nr_folio_pages > 0) {
> +               u8 add_nr_pages;
> +
> +               /*
> +                * If we have accumulated SWAP_CRYPTO_BATCH_SIZE
> +                * pages, process the sub-batch.
> +                */
> +               if (sub_batch->nr_pages =3D=3D SWAP_CRYPTO_BATCH_SIZE) {
> +                       zswap_batch_compress(sub_batch, errors);
> +                       zswap_batch_xarray_stats(sub_batch, errors);
> +                       zswap_batch_reset(sub_batch);
> +                       /*
> +                        * Stop processing this folio if it had compress =
errors.
> +                        */
> +                       if (errors[folio_id])
> +                               goto ret_folio;
> +               }
> +
> +               /* Add pages from the folio to the compress sub-batch. */
> +               add_nr_pages =3D min3((
> +                               (long)SWAP_CRYPTO_BATCH_SIZE -
> +                               (long)sub_batch->nr_pages),
> +                               nr_folio_pages,
> +                               (long)SWAP_CRYPTO_BATCH_SIZE);
> +
> +               /*
> +                * Allocate zswap entries for this sub-batch. If we get e=
rrors
> +                * while doing so, we can fail early and flag an error fo=
r the
> +                * folio.
> +                */
> +               if (zswap_batch_alloc_entries(entries, node_id, add_nr_pa=
ges)) {
> +                       zswap_batch_reset(sub_batch);
> +                       errors[folio_id] =3D -EINVAL;
> +                       goto ret_folio;
> +               }
> +
> +               zswap_batch_add_pages(sub_batch, folio, folio_id, objcg,
> +                                     entries, folio_start_idx, add_nr_pa=
ges);
> +
> +               nr_folio_pages -=3D add_nr_pages;
> +               folio_start_idx +=3D add_nr_pages;
> +       } /* this folio has pages to be compressed. */
> +
> +       /*
> +        * Process last sub-batch: it could contain pages from multiple f=
olios.
> +        */
> +       if (last && sub_batch->nr_pages) {
> +               zswap_batch_compress(sub_batch, errors);
> +               zswap_batch_xarray_stats(sub_batch, errors);
> +       }
> +
> +ret_folio:
> +       return (!errors[folio_id]);
> +}
> +
> +/*
> + * Store a large folio and/or a batch of any-order folio(s) in zswap
> + * using IAA compress batching API.
> + *
> + * This the main procedure for batching within large folios and for batc=
hing
> + * of folios. Each large folio will be broken into sub-batches of
> + * SWAP_CRYPTO_BATCH_SIZE pages, the sub-batch pages will be compressed =
by
> + * IAA hardware compress engines in parallel, then stored in zpool/xarra=
y.
> + *
> + * This procedure should only be called if zswap supports batching of st=
ores.
> + * Otherwise, the sequential implementation for storing folios as in the
> + * current zswap_store() should be used. The code handles the unlikely e=
vent
> + * that the zswap pool changes from batching to non-batching between
> + * swap_writepage() and the start of zswap_batch_store().
> + *
> + * The signature of this procedure is meant to allow the calling functio=
n,
> + * (for instance, swap_writepage()) to pass a batch of folios @batch
> + * (the "reclaim batch") to be stored in zswap.
> + *
> + * @batch and @errors have folio_batch_count(@batch) number of entries,
> + * with one-one correspondence (@errors[i] represents the error status o=
f
> + * @batch->folios[i], for i in folio_batch_count(@batch)). Please also
> + * see comments preceding "struct zswap_batch_store_sub_batch" definitio=
n
> + * above.
> + *
> + * The calling function (for instance, swap_writepage()) should initiali=
ze
> + * @errors[i] to a non-0 value.
> + * If zswap successfully stores @batch->folios[i], it will set @errors[i=
] to 0.
> + * If there is an error in zswap, it will set @errors[i] to -EINVAL.
> + *
> + * @batch: folio_batch of folios to be batch compressed.
> + * @errors: zswap_batch_store() error status for the folios in @batch.
> + */
> +void zswap_batch_store(struct folio_batch *batch, int *errors)
> +{
> +       struct zswap_batch_store_sub_batch sub_batch;
> +       struct zswap_pool *pool;
> +       u8 i;
> +
> +       /*
> +        * If zswap is disabled, we must invalidate the possibly stale en=
try
> +        * which was previously stored at this offset. Otherwise, writeba=
ck
> +        * could overwrite the new data in the swapfile.
> +        */
> +       if (!zswap_enabled)
> +               goto check_old;
> +
> +       pool =3D zswap_pool_current_get();
> +
> +       if (!pool) {
> +               if (zswap_check_limits())
> +                       queue_work(shrink_wq, &zswap_shrink_work);
> +               goto check_old;
> +       }
> +
> +       if (!pool->can_batch) {
> +               for (i =3D 0; i < folio_batch_count(batch); ++i)
> +                       if (zswap_store(batch->folios[i]))
> +                               errors[i] =3D 0;
> +                       else
> +                               errors[i] =3D -EINVAL;
> +               /*
> +                * Seems preferable to release the pool ref after the cal=
ls to
> +                * zswap_store(), so that the non-batching pool cannot be
> +                * deleted, can be used for sequential stores, and the zs=
wap pool
> +                * cannot morph into a batching pool.
> +                */
> +               zswap_pool_put(pool);
> +               return;
> +       }
> +
> +       zswap_batch_reset(&sub_batch);
> +       sub_batch.pool =3D pool;
> +
> +       for (i =3D 0; i < folio_batch_count(batch); ++i) {
> +               struct folio *folio =3D batch->folios[i];
> +               struct obj_cgroup *objcg =3D NULL;
> +               struct mem_cgroup *memcg =3D NULL;
> +               bool ret;
> +
> +               VM_WARN_ON_ONCE(!folio_test_locked(folio));
> +               VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> +
> +               objcg =3D get_obj_cgroup_from_folio(folio);
> +               if (objcg && !obj_cgroup_may_zswap(objcg)) {
> +                       memcg =3D get_mem_cgroup_from_objcg(objcg);
> +                       if (shrink_memcg(memcg)) {
> +                               mem_cgroup_put(memcg);
> +                               goto put_objcg;
> +                       }
> +                       mem_cgroup_put(memcg);
> +               }
> +
> +               if (zswap_check_limits())
> +                       goto put_objcg;
> +
> +               if (objcg) {
> +                       memcg =3D get_mem_cgroup_from_objcg(objcg);
> +                       if (memcg_list_lru_alloc(memcg, &zswap_list_lru, =
GFP_KERNEL)) {
> +                               mem_cgroup_put(memcg);
> +                               goto put_objcg;
> +                       }
> +                       mem_cgroup_put(memcg);
> +               }
> +
> +               /*
> +                * By default, set zswap error status in "errors" to "suc=
cess"
> +                * for use in swap_writepage() when this returns. In case=
 of
> +                * errors encountered in any sub-batch in which this foli=
o's
> +                * pages are batch-compressed, a negative error number wi=
ll
> +                * over-write this when zswap_batch_cleanup() is called.
> +                */
> +               errors[i] =3D 0;
> +               ret =3D zswap_batch_comp_folio(folio, errors, i, objcg, &=
sub_batch,
> +                                            (i =3D=3D folio_batch_count(=
batch) - 1));
> +
> +put_objcg:
> +               obj_cgroup_put(objcg);
> +               if (!ret && zswap_pool_reached_full)
> +                       queue_work(shrink_wq, &zswap_shrink_work);
> +       } /* for batch folios */
> +
> +       zswap_pool_put(pool);
> +
> +check_old:
> +       for (i =3D 0; i < folio_batch_count(batch); ++i)
> +               if (errors[i])
> +                       zswap_delete_stored_entries(batch->folios[i]);
> +}
> +

I didn't look too closely at the code, but you are essentially
replicating the entire  zswap store code path and making it work with
batches. This is a maintenance nightmare, and the code could very
easily go out-of-sync.

What we really need to do (and I suppose what Johannes meant, but
please correct me if I am wrong), is to make the existing flow work
with batches.

For example, most of zswap_store() should remain the same. It is still
getting a folio to compress, the only difference is that we will
parallelize the page compressions. zswap_store_page() is where some
changes need to be made. Instead of a single function that handles the
storage of each page, we need a vectorized function that handles the
storage of N pages in a folio (allocate zswap_entry's, do xarray
insertions, etc). This should be refactoring in a separate patch.

Once we have that, the logic introduced by this patch should really be
mostly limited to zswap_compress(), where the acomp interfacing would
be different based on whether batching is supported or not. This could
be changes in zswap_compress() itself, or maybe at this point we can
have a completely different path (e.g. zswap_compress_batch()). But
outside of that, I don't see why we should have a completely different
store path for the batching.

>  int zswap_swapon(int type, unsigned long nr_pages)
>  {
>         struct xarray *trees, *tree;
> --
> 2.27.0
>

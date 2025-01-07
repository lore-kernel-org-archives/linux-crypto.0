Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F84A50
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jan 2025 01:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736212838; cv=none; b=qTVcO2J+3lYkFDWZxojCLkj5PsNfFrbYVhyFcswh5dI/8LOL36B4r1iniqob5MXg1RZFAgk4bIjZM5Ue4xK34uDg3iB4XLx6mrb6hX/0OHQHorYkU9S15ogTO2DR7Ql+sdKzCymw2PaV8mnQJco18cxFeqQGDHebLQqENO8+RAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736212838; c=relaxed/simple;
	bh=gqRT9Re3TvKZ0tSL3nK5cqoivxUqT7UhuQFhEvTVe9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sNnBpPU0x97fI7VTIdad3X6S4dO2mRrFpmqbWRjFE/XggBK9lgTC5uQGvl8w0e5RaQfhertyXvQfITwd2g5eRMGIizmi7Uo22o5F/zTTzUNHlN9H5fbsH98sENsxlxnAznLntMfpXBXhU+Lx7819PgVsd7ysX0CsTmuwwJpFJaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pJKwurrt; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pJKwurrt"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6dccccd429eso136133046d6.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jan 2025 17:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736212835; x=1736817635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NWbE6ucSaJO7drDBPdAWovR6FIHv6Ku8rtYoWX93WyI=;
        b=pJKwurrt7lk5Htn07wI2bJgk/cVaxVbkxY/34qjVMls70VyDFY+r2Ey9Nxx804RHUR
         gvDAgxkPSUuNrGsw2Oyd5nwj9TfdziRvJApJQrY9gabcmjm8wwd/m8+KfboNbjDkudFz
         719HLHi3QkUVPPEPT5jbSDlYuHyreJfCDrLrhJz31F4F1c2Wbj9LvhEq8AFRW5o09m/m
         HAFSGlLOdZNQfX43C247ED5L9R3yT5BcnZySn4xUIPPx1uzYDbjr4hmsg4hO/MiDsOe0
         lbHntLQU0SDEuCLvuOkGJbKs8vDYBnhl/shTVHwN5a3HoWCg9vqi1qVgUm6rnJMYjP+y
         viDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736212835; x=1736817635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NWbE6ucSaJO7drDBPdAWovR6FIHv6Ku8rtYoWX93WyI=;
        b=rAerPBZyNJLl5lpYaPkuBRwg8A394ut/I3aimfeHj9wGhonjKaUXqRWvP2sE+V+Gu4
         NJJ9UkR0aLtlbU9b++A91InEE7Eqw57pqiPY7R63plJGo7ZPxruiX8AO19Uc8amMAyhq
         PVtJeCuflQxaYzAtl9yLHk2q8fJha1ta5+UogENxXslEQgrnokp1EjbPo6JMNX5RdJXK
         y8AOTqmUCAnop/LCQ27Hduacl+inGZbOlpIJsoOBN3tbSt7rp6/3VhDvDBUmRtu0ryFt
         DDniiQsJlgZbmPKx1z7qAg74Nm2FqEHkBgvLHfObS3NtXldJS9gxErl21TPX1Qg4+HJ2
         kdtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOaUgh6Ty4YhgfIinFl7dCiV+yoHUt9muy2F7zJAxxCv7rz515fgvxUcuxBqHXtivysnbWJ5yFvfF+/hE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx45kyCiMaywz4ytEShL/YuX4Y+Hkr1L72AjA2HbvS12TsTmmVF
	PSUI2Z/fCZjGmRm87t15tHxWXQSzAE+Mtwba5rkWe8eDR+Iz+tnRjhwtB5yny8YJLVrBtyFjF5f
	Nr2ytQG8619vqSKvoIwiT0u4ghVNtjt+fiEGw
X-Gm-Gg: ASbGnct06iAYupTuX9NeMJr0inaFaDA0WXXDzuKfUOry7mNjo+gQkoIrIqkXbAd5B2Y
	GLEtTJ4D6szbBSJr2iuknxSjOD1v1u8zfm8s=
X-Google-Smtp-Source: AGHT+IHr4I1iTbF+x66FtXbkHGsjsWE5VQF+aOpcBcFKBDxhnQoU0/gXvCPLmkFVPhkWUCmCFi13oGxhfnQpbZvjwxo=
X-Received: by 2002:a05:6214:1bc7:b0:6d3:fa03:23f1 with SMTP id
 6a1803df08f44-6dd23331d7dmr980894016d6.13.1736212835067; Mon, 06 Jan 2025
 17:20:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com> <20241221063119.29140-13-kanchana.p.sridhar@intel.com>
In-Reply-To: <20241221063119.29140-13-kanchana.p.sridhar@intel.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 6 Jan 2025 17:19:58 -0800
X-Gm-Features: AbW1kvZYvCod58bLaFtH-8h2ST0WRrrRE-HFCzJNPjkFCbSRGs8S5ZmDN-fdihY
Message-ID: <CAJD7tkYLUXCumH7qZDE63qOUbrj3bxnBbgkkdCVGbvL6R_fS8w@mail.gmail.com>
Subject: Re: [PATCH v5 12/12] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, akpm@linux-foundation.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2024 at 10:31=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> zswap_compress_folio() is modified to detect if the pool's acomp_ctx has
> more than one "nr_reqs", which will be the case if the cpu onlining code
> has allocated batching resources in the acomp_ctx based on the queries to
> acomp_has_async_batching() and crypto_acomp_batch_size(). If multiple
> "nr_reqs" are available in the acomp_ctx, it means compress batching can =
be
> used with a batch-size of "acomp_ctx->nr_reqs".
>
> If compress batching can be used with the given zswap pool,
> zswap_compress_folio() will invoke the newly added zswap_batch_compress()
> procedure to compress and store the folio in batches of
> "acomp_ctx->nr_reqs" pages. The batch size is effectively
> "acomp_ctx->nr_reqs".
>
> zswap_batch_compress() calls crypto_acomp_batch_compress() to compress ea=
ch
> batch of (up to) "acomp_ctx->nr_reqs" pages. The iaa_crypto driver
> will compress each batch of pages in parallel in the Intel IAA hardware
> with 'async' mode and request chaining.
>
> Hence, zswap_batch_compress() does the same computes for a batch, as
> zswap_compress() does for a page; and returns true if the batch was
> successfully compressed/stored, and false otherwise.
>
> If the pool does not support compress batching, zswap_compress_folio()
> calls zswap_compress() for each individual page in the folio, as before.
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 105 insertions(+), 4 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 1be0f1807bfc..f336fafe24c4 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1467,17 +1467,118 @@ static void shrink_worker(struct work_struct *w)
>  * main API
>  **********************************/
>
> +static bool zswap_batch_compress(struct folio *folio,
> +                                long index,
> +                                unsigned int batch_size,
> +                                struct zswap_entry *entries[],
> +                                struct zswap_pool *pool,
> +                                struct crypto_acomp_ctx *acomp_ctx)
> +{
> +       int comp_errors[ZSWAP_MAX_BATCH_SIZE] =3D { 0 };
> +       unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
> +       struct page *pages[ZSWAP_MAX_BATCH_SIZE];
> +       unsigned int i, nr_batch_pages;
> +       bool ret =3D true;
> +
> +       nr_batch_pages =3D min((unsigned int)(folio_nr_pages(folio) - ind=
ex), batch_size);
> +
> +       for (i =3D 0; i < nr_batch_pages; ++i) {
> +               pages[i] =3D folio_page(folio, index + i);
> +               dlens[i] =3D PAGE_SIZE;
> +       }
> +
> +       mutex_lock(&acomp_ctx->mutex);
> +
> +       /*
> +        * Batch compress @nr_batch_pages. If IAA is the compressor, the
> +        * hardware will compress @nr_batch_pages in parallel.
> +        */
> +       ret =3D crypto_acomp_batch_compress(
> +               acomp_ctx->reqs,
> +               &acomp_ctx->wait,
> +               pages,
> +               acomp_ctx->buffers,
> +               dlens,
> +               comp_errors,
> +               nr_batch_pages);

I will hold off on reviewing this patch until the acomp interface is
settled, but I am wondering if this can be a vectorization of
zswap_compress() instead, since there's a lot of common code.

> +
> +       if (ret) {
> +               /*
> +                * All batch pages were successfully compressed.
> +                * Store the pages in zpool.
> +                */
> +               struct zpool *zpool =3D pool->zpool;
> +               gfp_t gfp =3D __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD=
_RECLAIM;
> +
> +               if (zpool_malloc_support_movable(zpool))
> +                       gfp |=3D __GFP_HIGHMEM | __GFP_MOVABLE;
> +
> +               for (i =3D 0; i < nr_batch_pages; ++i) {
> +                       unsigned long handle;
> +                       char *buf;
> +                       int err;
> +
> +                       err =3D zpool_malloc(zpool, dlens[i], gfp, &handl=
e);
> +
> +                       if (err) {
> +                               if (err =3D=3D -ENOSPC)
> +                                       zswap_reject_compress_poor++;
> +                               else
> +                                       zswap_reject_alloc_fail++;
> +
> +                               ret =3D false;
> +                               break;
> +                       }
> +
> +                       buf =3D zpool_map_handle(zpool, handle, ZPOOL_MM_=
WO);
> +                       memcpy(buf, acomp_ctx->buffers[i], dlens[i]);
> +                       zpool_unmap_handle(zpool, handle);
> +
> +                       entries[i]->handle =3D handle;
> +                       entries[i]->length =3D dlens[i];
> +               }
> +       } else {
> +               /* Some batch pages had compression errors. */
> +               for (i =3D 0; i < nr_batch_pages; ++i) {
> +                       if (comp_errors[i]) {
> +                               if (comp_errors[i] =3D=3D -ENOSPC)
> +                                       zswap_reject_compress_poor++;
> +                               else
> +                                       zswap_reject_compress_fail++;
> +                       }
> +               }
> +       }
> +
> +       mutex_unlock(&acomp_ctx->mutex);
> +
> +       return ret;
> +}
> +
>  static bool zswap_compress_folio(struct folio *folio,
>                                  struct zswap_entry *entries[],
>                                  struct zswap_pool *pool)
>  {
>         long index, nr_pages =3D folio_nr_pages(folio);
> +       struct crypto_acomp_ctx *acomp_ctx;
> +       unsigned int batch_size;
>
> -       for (index =3D 0; index < nr_pages; ++index) {
> -               struct page *page =3D folio_page(folio, index);
> +       acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> +       batch_size =3D acomp_ctx->nr_reqs;
>
> -               if (!zswap_compress(page, entries[index], pool))
> -                       return false;
> +       if ((batch_size > 1) && (nr_pages > 1)) {
> +               for (index =3D 0; index < nr_pages; index +=3D batch_size=
) {
> +
> +                       if (!zswap_batch_compress(folio, index, batch_siz=
e,
> +                                                 &entries[index], pool, =
acomp_ctx))
> +                               return false;
> +               }
> +       } else {
> +               for (index =3D 0; index < nr_pages; ++index) {
> +                       struct page *page =3D folio_page(folio, index);
> +
> +                       if (!zswap_compress(page, entries[index], pool))
> +                               return false;
> +               }
>         }
>
>         return true;
> --
> 2.27.0
>

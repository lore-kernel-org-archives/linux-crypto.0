Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF03347FC7
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762451171; cv=none; b=E6zRUQyt1zDos4A9LZOHj/vfk33nhzMehBXD3/h9924IfHiJWKdRqQU+2lUE7zpf+mA+otC2s+ETYDfSxA6E/9ZNVfd6DfSDnemx5x0xgqBy1GMIHVmN06pd0m8nkWnM7H95Q1jD0Nlhi+1QdW9RwSjd5FcFEwfVTaJSPciP5c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762451171; c=relaxed/simple;
	bh=T6brCKzB6C0fOBz9ZP6RYVancYmnXFKTuApWCVgow84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rAoSdrYU9MRa+iM17yo1Dyo9/btsxY0sjzV5Y7Pf0UhOQ3SYZp7Cemkpwd8vz/0Y9viZfgzTulCbxWL15QTkJTHxM45Yowi+iR/6+CrgEFe8Py21UllHlCBSFcWjtgEwjbqEnJANQtANi3hK/xPYDq0CZAjRL9yKq5B1YPRtymA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BqUxCnHQ; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BqUxCnHQ"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-429c48e05aeso869363f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 09:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762451165; x=1763055965; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XuqL/Wl9e/NoH3ehwAFRAdXC+fJYyatKnRax3XLipPU=;
        b=BqUxCnHQJ/dImp6PK/pMM1pFAiZWA9W25UwEt1aKsePcSiv1Iee3BbBMD2NncEyfGK
         flar9/c9nukX5jAEiTAYJtEHX0LqT9GgWWj2v1bId/qk3faR73shgE0/4gdEpXE+SFPq
         kvSSWPS24E+/JmJ4DKZHiHWmi0Sf7S9q9d115V5Ia9tynuV2EhsRlE1CASu/eRN6B/CB
         lyS0bCr9jJd/q924bD5nFiFMqel3ql16MO1+AXFP7p2Wj4VnEwK5kk4uCpuzyaO5rFTO
         jK+WJgRuXS88dKnNLi3gTY6vUplU7Znatpt24+wPYA7lpmE1ss5N4w2BYZzSTljizusW
         HP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762451165; x=1763055965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XuqL/Wl9e/NoH3ehwAFRAdXC+fJYyatKnRax3XLipPU=;
        b=C3mQ632rvu6J4jSLCQTA2cQ5qCqh2GvxZuqSGpJV2rwc/f4Cr+vsSPh6igxoa7dXaq
         KeZyjyUSWDPG1sanEiZyLDnwuzU4CH7SG00qYRhSR+uMQ4NCsiQBqQ8jwLmeowivxGOC
         6KqApg34E0idniH6CQtwZkhLMlfDDjO842x1lpVth7vFZ+pw29lTh108S9L6tEc7rNwI
         Ik7+lAo6ezJmyz1am2QmC68IZU/2ZwqQaQcw1RVBh0BsNHZ2Hbwk6tNqUPN/8ZaSY7P0
         NNxMcqgxErfN77fUNVGCOPBTBRBcumHp9F68jYKp+VMRRsl0nuv9Zo2nLzqf6txktj6Y
         5HLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoOmsXi1wTXU/4PyL4eOfw1nQcAHJqiLu+w8Y6UclIAwM9qye1htaMLvSIeu4oLgN406chpwuNT0O/JBI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy9mFSQB4uhY9h1+0oFZgXEeeRNx59pdbF+S44u16kw/ElTXrT
	Q4XxsAlh0MKfSSE5+phopNt3hGgPxBjrUXI3mHxQ/y5OMZFa3UyKe4lFO/mn3DXF/8bBhGLqIdv
	jaqxknIrwxIHEuXPKbbdBOqzbTZHVrIs=
X-Gm-Gg: ASbGnctP7MyjQN2GRT5ayxRQGGJkPaQYhj0DB5VENWmG1kvVHo05V4QfHfGngXL5Bey
	LSR3L/vtpqNpKgVCZSi2a/mLS/DquXF5YZUhDYNNDBfuIJC9VITdVpc4DbWv1HuBdy8UwmmCLDd
	I+xOO36IRFU6xzWvJQm5QaaLhMLYFkHw8lIN9LM6S4NGS1X6A1cf86aqR6TfcwBpnLG+TeDdchu
	KRhQhCsx9M7Nw8CUz56U8ObNwO8Qv1k3pcDlh3/BogrT8MSSV3mhsb23fo/hifhIXY7
X-Google-Smtp-Source: AGHT+IEFawWwq0jLtchfAtfV2bMZzjg837OrBmfi2630hVEv12RxFBc5Mi569pTBPw+Jx0fhBVi+AQjxNrOpiTaxHPw=
X-Received: by 2002:a05:6000:220f:b0:429:cff0:1929 with SMTP id
 ffacd0b85a97d-42a957abae9mr449584f8f.29.1762451165029; Thu, 06 Nov 2025
 09:46:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com> <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
In-Reply-To: <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 6 Nov 2025 09:45:54 -0800
X-Gm-Features: AWmQ_bl-bUbfgh-tgbtwi7OIawVv9zFYP4CJyFLME2PrDUDmGRzTAKOojNiGcsM
Message-ID: <CAKEwX=PmJcsQy5foaS6HecqLyF1gKBhbLvbw6kM9bZmJ7UMBFw@mail.gmail.com>
Subject: Re: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large
 folio in batches.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, 
	kasong@tencent.com, linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 1:12=E2=80=AFAM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch makes two major changes:
>
> First, we allocate pool batching resources if the compressor supports
> batching:
>
>   This patch sets up zswap for allocating per-CPU resources optimally
>   for non-batching and batching compressors.
>
>   A new ZSWAP_MAX_BATCH_SIZE constant is defined as 8U, to set an upper
>   limit on the number of pages in large folios that will be batch
>   compressed.
>
>   It is up to the compressor to manage multiple requests, as needed, to
>   accomplish batch parallelism. zswap only needs to allocate the per-CPU
>   dst buffers according to the batch size supported by the compressor.
>
>   A "u8 compr_batch_size" member is added to "struct zswap_pool", as per
>   Yosry's suggestion. pool->compr_batch_size is set as the minimum of
>   the compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE. Accordingly,
>   pool->compr_batch_size compression dst buffers are allocated in the
>   per-CPU acomp_ctx.
>
>   zswap does not use more than one dst buffer yet. Follow-up patches
>   will actually utilize the multiple acomp_ctx buffers for batch
>   compression/decompression of multiple pages.
>
>   Thus, ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used for
>   batching. There is a small extra memory overhead of allocating
>   the acomp_ctx->buffers array for compressors that do not support
>   batching: On x86_64, the overhead is 1 pointer per-CPU (i.e. 8 bytes).
>
> Next, we store the folio in batches:
>
>   This patch modifies zswap_store() to store a batch of pages in large
>   folios at a time, instead of storing one page at a time. It does this b=
y
>   calling a new procedure zswap_store_pages() with a range of indices in
>   the folio: for batching compressors, this range contains up to
>   pool->compr_batch_size pages. For non-batching compressors, we send up
>   to ZSWAP_MAX_BATCH_SIZE pages to be sequentially compressed and stored
>   in zswap_store_pages().
>
>   zswap_store_pages() implements all the computes done earlier in
>   zswap_store_page() for a single-page, for multiple pages in a folio,
>   namely the "batch":
>
>   1) It starts by allocating all zswap entries required to store the
>      batch. New procedures, zswap_entries_cache_alloc_batch() and
>      zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk()
>      to optimize the performance of this step.
>
>   2) The entry doesn't have to be allocated on the same node as the page
>      being stored in zswap: we let the slab allocator decide this in
>      kmem_cache_alloc_bulk(). However, to make sure the current zswap
>      LRU list/shrinker behavior is preserved, we store the folio's nid as
>      a new @nid member in the entry to enable adding it to the correct
>      LRU list (and deleting it from the right LRU list). This ensures
>      that when the folio's allocating NUMA node is under memory
>      pressure, the entries corresponding to its pages are written back.
>
>      The memory footprint of struct zswap_entry remains unchanged at
>      56 bytes with the addition of the "int nid" member by condensing
>      "length" and "referenced" into 4 bytes using bit fields and using
>      the 4 bytes available after "referenced" for the "int nid". Thanks
>      to Nhat and Yosry for these suggestions!
>
>   3) Next, the entries fields are written, computes that need to be happe=
n
>      anyway, without modifying the zswap xarray/LRU publishing order. Thi=
s
>      avoids bringing the entries into the cache for writing in different
>      code blocks within this procedure, hence improves latency.
>
>   4) Next, it calls zswap_compress() to sequentially compress each page i=
n
>      the batch.
>
>   5) Finally, it adds the batch's zswap entries to the xarray and LRU,
>      charges zswap memory and increments zswap stats.
>
>   6) The error handling and cleanup required for all failure scenarios
>      that can occur while storing a batch in zswap are consolidated to a
>      single "store_pages_failed" label in zswap_store_pages(). Here again=
,
>      we optimize performance by calling kmem_cache_free_bulk().
>
> This commit also makes a minor optimization in zswap_compress(), that
> takes a "bool wb_enabled" argument; computed once in zswap_store()
> rather than for each page in the folio.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 336 ++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 232 insertions(+), 104 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index cb384eb7c815..257567edc587 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -82,6 +82,9 @@ static bool zswap_pool_reached_full;
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
> @@ -139,7 +142,7 @@ struct crypto_acomp_ctx {
>         struct crypto_acomp *acomp;
>         struct acomp_req *req;
>         struct crypto_wait wait;
> -       u8 *buffer;
> +       u8 **buffers;
>         struct mutex mutex;
>         bool is_sleepable;
>  };
> @@ -149,6 +152,9 @@ struct crypto_acomp_ctx {
>   * The only case where lru_lock is not acquired while holding tree.lock =
is
>   * when a zswap_entry is taken off the lru for writeback, in that case i=
t
>   * needs to be verified that it's still valid in the tree.
> + *
> + * @compr_batch_size: The max batch size of the compression algorithm,
> + *                    bounded by ZSWAP_MAX_BATCH_SIZE.
>   */
>  struct zswap_pool {
>         struct zs_pool *zs_pool;
> @@ -158,6 +164,7 @@ struct zswap_pool {
>         struct work_struct release_work;
>         struct hlist_node node;
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
> +       u8 compr_batch_size;
>  };
>
>  /* Global LRU lists shared by all zswap pools. */
> @@ -182,6 +189,7 @@ static struct shrinker *zswap_shrinker;
>   *              writeback logic. The entry is only reclaimed by the writ=
eback
>   *              logic if referenced is unset. See comments in the shrink=
er
>   *              section for context.
> + * nid - NUMA node id of the page for which this is the zswap entry.
>   * pool - the zswap_pool the entry's data is in
>   * handle - zsmalloc allocation handle that stores the compressed page d=
ata
>   * objcg - the obj_cgroup that the compressed memory is charged to
> @@ -189,8 +197,11 @@ static struct shrinker *zswap_shrinker;
>   */
>  struct zswap_entry {
>         swp_entry_t swpentry;
> -       unsigned int length;
> -       bool referenced;
> +       struct {
> +               unsigned int length:31;
> +               bool referenced:1;
> +       };

Maybe make these macro-defined constants?

Code mostly LGTM otherwise.

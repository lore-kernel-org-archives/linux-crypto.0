Return-Path: <SRS0=0P/0=DF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461E7C4727F
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Sep 2020 12:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F070D22262
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Sep 2020 12:45:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=konsulko.com header.i=@konsulko.com header.b="AMVFs+1w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgI1MpQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Sep 2020 08:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI1MpM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Sep 2020 08:45:12 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A14C061755
        for <linux-crypto@vger.kernel.org>; Mon, 28 Sep 2020 05:45:12 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id c2so892118ljj.12
        for <linux-crypto@vger.kernel.org>; Mon, 28 Sep 2020 05:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YXljLBb7WSHoupsM0Xqkr22VPWZTvE5dPwNfIwwVnCU=;
        b=AMVFs+1wNzBRRRTGfbedhIslTFHfJbdLNFgdcIowi+Hg1SCO2sNFBGRGHZALQEaQZh
         osIJftxI0F6n4UAsF2+W2FgX9rRmBxpCcXj75+sQHDT79Sun/5bPiMaeVOU1ki/C0mfy
         4SiD0D0wRE/J5YKaHzAginF46uaEgRKI7TX+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YXljLBb7WSHoupsM0Xqkr22VPWZTvE5dPwNfIwwVnCU=;
        b=cLs3IIyCB8P+Ix4mxB2sgAqUO1ri/FSUaIGHTZ183xpWy4VpWrVqbf8W5VFrypdxLI
         MIS/fuCZMGm+sHgL95nRLw4Uwa01DP5ngi1m+nHC+BEq7k4zjLpxwEB1bhKgA2v5XY+j
         YEJj4miwEMfBiV8kr2lupiFatDxfJsrRawmMWJ3QPBLepDFfnGh33VQJp43JiBMAHTA5
         4cImT0dLkLidW12aKOQV8mN++wTVwzrhSFNVySqJSsIttinuM17+iKUiXYWzV12akpK9
         aMAZ3eWqcvMVQ4OaS4sFoyewZ/kAvCetlI1KqHvyL+m+iu8Gk5Vo75FmE1jZYAulA2cz
         G3pg==
X-Gm-Message-State: AOAM532oPEZbZ8a5U1xUSdMAFuNqdXF6EqfBNklqnt7DBRaP90fIzIjP
        TUfx9RoI+9C9sCYJfsonAaixVQSyDQnkeGeUuhp7tg==
X-Google-Smtp-Source: ABdhPJyPliqXeeh4EA3BeDzfKSJT7Pp7cWZ2aala9cMq5PMTQrg+eoDWfQbNAXnb+fVbkHl6vSpjs7ejU8r8nlLqAfM=
X-Received: by 2002:a2e:9bc5:: with SMTP id w5mr362123ljj.454.1601297110596;
 Mon, 28 Sep 2020 05:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200818123100.4140-1-song.bao.hua@hisilicon.com>
In-Reply-To: <20200818123100.4140-1-song.bao.hua@hisilicon.com>
From:   Vitaly Wool <vitaly.wool@konsulko.com>
Date:   Mon, 28 Sep 2020 14:44:59 +0200
Message-ID: <CAM4kBB+SPbmZZ-OoEbayfZkoOThSF9BTRJNWR0VmVd_50nGJYw@mail.gmail.com>
Subject: Re: [PATCH v6] mm/zswap: move to use crypto_acomp API for hardware acceleration
To:     Barry Song <song.bao.hua@hisilicon.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Colin Ian King <colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 18, 2020 at 2:34 PM Barry Song <song.bao.hua@hisilicon.com> wrote:
>
> Right now, all new ZIP drivers are adapted to crypto_acomp APIs rather
> than legacy crypto_comp APIs. Tradiontal ZIP drivers like lz4,lzo etc
> have been also wrapped into acomp via scomp backend. But zswap.c is still
> using the old APIs. That means zswap won't be able to work on any new
> ZIP drivers in kernel.
>
> This patch moves to use cryto_acomp APIs to fix the disconnected bridge
> between new ZIP drivers and zswap. It is probably the first real user
> to use acomp but perhaps not a good example to demonstrate how multiple
> acomp requests can be executed in parallel in one acomp instance.
> frontswap is doing page load and store page by page synchronously.
> swap_writepage() depends on the completion of frontswap_store() to
> decide if it should call __swap_writepage() to swap to disk.
>
> However this patch creates multiple acomp instances, so multiple threads
> running on multiple different cpus can actually do (de)compression
> parallelly, leveraging the power of multiple ZIP hardware queues. This
> is also consistent with frontswap's page management model.
>
> The old zswap code uses atomic context and avoids the race conditions
> while shared resources like zswap_dstmem are accessed. Here since acomp
> can sleep, per-cpu mutex is used to replace preemption-disable.
>
> While it is possible to make mm/page_io.c and mm/frontswap.c support
> async (de)compression in some way, the entire design requires careful
> thinking and performance evaluation. For the first step, the base with
> fixed connection between ZIP drivers and zswap should be built.
>
> Cc: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Mahipal Challa <mahipalreddy2006@gmail.com>
> Cc: Seth Jennings <sjenning@redhat.com>
> Cc: Dan Streetman <ddstreet@ieee.org>
> Cc: Vitaly Wool <vitaly.wool@konsulko.com>
> Cc: Zhou Wang <wangzhou1@hisilicon.com>
> Cc: Hao Fang <fanghao11@huawei.com>
> Cc: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>

Acked-by: Vitaly Wool <vitalywool@gmail.com>

> ---
>  -v6:
>  * rebase on top of 5.9-rc1;
>  * move to crypto_alloc_acomp_node() API to use local ZIP hardware
>
>  mm/zswap.c | 183 ++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 138 insertions(+), 45 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index fbb782924ccc..00b5f14a7332 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -24,8 +24,10 @@
>  #include <linux/rbtree.h>
>  #include <linux/swap.h>
>  #include <linux/crypto.h>
> +#include <linux/scatterlist.h>
>  #include <linux/mempool.h>
>  #include <linux/zpool.h>
> +#include <crypto/acompress.h>
>
>  #include <linux/mm_types.h>
>  #include <linux/page-flags.h>
> @@ -127,9 +129,17 @@ module_param_named(same_filled_pages_enabled, zswap_same_filled_pages_enabled,
>  * data structures
>  **********************************/
>
> +struct crypto_acomp_ctx {
> +       struct crypto_acomp *acomp;
> +       struct acomp_req *req;
> +       struct crypto_wait wait;
> +       u8 *dstmem;
> +       struct mutex *mutex;
> +};
> +
>  struct zswap_pool {
>         struct zpool *zpool;
> -       struct crypto_comp * __percpu *tfm;
> +       struct crypto_acomp_ctx __percpu *acomp_ctx;
>         struct kref kref;
>         struct list_head list;
>         struct work_struct release_work;
> @@ -388,23 +398,43 @@ static struct zswap_entry *zswap_entry_find_get(struct rb_root *root,
>  * per-cpu code
>  **********************************/
>  static DEFINE_PER_CPU(u8 *, zswap_dstmem);
> +/*
> + * If users dynamically change the zpool type and compressor at runtime, i.e.
> + * zswap is running, zswap can have more than one zpool on one cpu, but they
> + * are sharing dtsmem. So we need this mutex to be per-cpu.
> + */
> +static DEFINE_PER_CPU(struct mutex *, zswap_mutex);
>
>  static int zswap_dstmem_prepare(unsigned int cpu)
>  {
> +       struct mutex *mutex;
>         u8 *dst;
>
>         dst = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
>         if (!dst)
>                 return -ENOMEM;
>
> +       mutex = kmalloc_node(sizeof(*mutex), GFP_KERNEL, cpu_to_node(cpu));
> +       if (!mutex) {
> +               kfree(dst);
> +               return -ENOMEM;
> +       }
> +
> +       mutex_init(mutex);
>         per_cpu(zswap_dstmem, cpu) = dst;
> +       per_cpu(zswap_mutex, cpu) = mutex;
>         return 0;
>  }
>
>  static int zswap_dstmem_dead(unsigned int cpu)
>  {
> +       struct mutex *mutex;
>         u8 *dst;
>
> +       mutex = per_cpu(zswap_mutex, cpu);
> +       kfree(mutex);
> +       per_cpu(zswap_mutex, cpu) = NULL;
> +
>         dst = per_cpu(zswap_dstmem, cpu);
>         kfree(dst);
>         per_cpu(zswap_dstmem, cpu) = NULL;
> @@ -415,30 +445,54 @@ static int zswap_dstmem_dead(unsigned int cpu)
>  static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  {
>         struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> -       struct crypto_comp *tfm;
> -
> -       if (WARN_ON(*per_cpu_ptr(pool->tfm, cpu)))
> -               return 0;
> +       struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> +       struct crypto_acomp *acomp;
> +       struct acomp_req *req;
> +
> +       acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> +       if (IS_ERR(acomp)) {
> +               pr_err("could not alloc crypto acomp %s : %ld\n",
> +                               pool->tfm_name, PTR_ERR(acomp));
> +               return PTR_ERR(acomp);
> +       }
> +       acomp_ctx->acomp = acomp;
>
> -       tfm = crypto_alloc_comp(pool->tfm_name, 0, 0);
> -       if (IS_ERR_OR_NULL(tfm)) {
> -               pr_err("could not alloc crypto comp %s : %ld\n",
> -                      pool->tfm_name, PTR_ERR(tfm));
> +       req = acomp_request_alloc(acomp_ctx->acomp);
> +       if (!req) {
> +               pr_err("could not alloc crypto acomp_request %s\n",
> +                      pool->tfm_name);
> +               crypto_free_acomp(acomp_ctx->acomp);
>                 return -ENOMEM;
>         }
> -       *per_cpu_ptr(pool->tfm, cpu) = tfm;
> +       acomp_ctx->req = req;
> +
> +       crypto_init_wait(&acomp_ctx->wait);
> +       /*
> +        * if the backend of acomp is async zip, crypto_req_done() will wakeup
> +        * crypto_wait_req(); if the backend of acomp is scomp, the callback
> +        * won't be called, crypto_wait_req() will return without blocking.
> +        */
> +       acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +                                  crypto_req_done, &acomp_ctx->wait);
> +
> +       acomp_ctx->mutex = per_cpu(zswap_mutex, cpu);
> +       acomp_ctx->dstmem = per_cpu(zswap_dstmem, cpu);
> +
>         return 0;
>  }
>
>  static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
>  {
>         struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> -       struct crypto_comp *tfm;
> +       struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> +
> +       if (!IS_ERR_OR_NULL(acomp_ctx)) {
> +               if (!IS_ERR_OR_NULL(acomp_ctx->req))
> +                       acomp_request_free(acomp_ctx->req);
> +               if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> +                       crypto_free_acomp(acomp_ctx->acomp);
> +       }
>
> -       tfm = *per_cpu_ptr(pool->tfm, cpu);
> -       if (!IS_ERR_OR_NULL(tfm))
> -               crypto_free_comp(tfm);
> -       *per_cpu_ptr(pool->tfm, cpu) = NULL;
>         return 0;
>  }
>
> @@ -561,8 +615,9 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
>         pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
>
>         strlcpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> -       pool->tfm = alloc_percpu(struct crypto_comp *);
> -       if (!pool->tfm) {
> +
> +       pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
> +       if (!pool->acomp_ctx) {
>                 pr_err("percpu alloc failed\n");
>                 goto error;
>         }
> @@ -585,7 +640,8 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
>         return pool;
>
>  error:
> -       free_percpu(pool->tfm);
> +       if (pool->acomp_ctx)
> +               free_percpu(pool->acomp_ctx);
>         if (pool->zpool)
>                 zpool_destroy_pool(pool->zpool);
>         kfree(pool);
> @@ -596,14 +652,14 @@ static __init struct zswap_pool *__zswap_pool_create_fallback(void)
>  {
>         bool has_comp, has_zpool;
>
> -       has_comp = crypto_has_comp(zswap_compressor, 0, 0);
> +       has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
>         if (!has_comp && strcmp(zswap_compressor,
>                                 CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
>                 pr_err("compressor %s not available, using default %s\n",
>                        zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
>                 param_free_charp(&zswap_compressor);
>                 zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
> -               has_comp = crypto_has_comp(zswap_compressor, 0, 0);
> +               has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
>         }
>         if (!has_comp) {
>                 pr_err("default compressor %s not available\n",
> @@ -639,7 +695,7 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
>         zswap_pool_debug("destroying", pool);
>
>         cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
> -       free_percpu(pool->tfm);
> +       free_percpu(pool->acomp_ctx);
>         zpool_destroy_pool(pool->zpool);
>         kfree(pool);
>  }
> @@ -723,7 +779,7 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
>                 }
>                 type = s;
>         } else if (!compressor) {
> -               if (!crypto_has_comp(s, 0, 0)) {
> +               if (!crypto_has_acomp(s, 0, 0)) {
>                         pr_err("compressor %s not available\n", s);
>                         return -ENOENT;
>                 }
> @@ -774,7 +830,7 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
>                  * failed, maybe both compressor and zpool params were bad.
>                  * Allow changing this param, so pool creation will succeed
>                  * when the other param is changed. We already verified this
> -                * param is ok in the zpool_has_pool() or crypto_has_comp()
> +                * param is ok in the zpool_has_pool() or crypto_has_acomp()
>                  * checks above.
>                  */
>                 ret = param_set_charp(s, kp);
> @@ -876,7 +932,9 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
>         pgoff_t offset;
>         struct zswap_entry *entry;
>         struct page *page;
> -       struct crypto_comp *tfm;
> +       struct scatterlist input, output;
> +       struct crypto_acomp_ctx *acomp_ctx;
> +
>         u8 *src, *dst;
>         unsigned int dlen;
>         int ret;
> @@ -916,14 +974,21 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
>
>         case ZSWAP_SWAPCACHE_NEW: /* page is locked */
>                 /* decompress */
> +               acomp_ctx = this_cpu_ptr(entry->pool->acomp_ctx);
> +
>                 dlen = PAGE_SIZE;
>                 src = (u8 *)zhdr + sizeof(struct zswap_header);
> -               dst = kmap_atomic(page);
> -               tfm = *get_cpu_ptr(entry->pool->tfm);
> -               ret = crypto_comp_decompress(tfm, src, entry->length,
> -                                            dst, &dlen);
> -               put_cpu_ptr(entry->pool->tfm);
> -               kunmap_atomic(dst);
> +               dst = kmap(page);
> +
> +               mutex_lock(acomp_ctx->mutex);
> +               sg_init_one(&input, src, entry->length);
> +               sg_init_one(&output, dst, dlen);
> +               acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
> +               ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
> +               dlen = acomp_ctx->req->dlen;
> +               mutex_unlock(acomp_ctx->mutex);
> +
> +               kunmap(page);
>                 BUG_ON(ret);
>                 BUG_ON(dlen != PAGE_SIZE);
>
> @@ -1004,7 +1069,8 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>  {
>         struct zswap_tree *tree = zswap_trees[type];
>         struct zswap_entry *entry, *dupentry;
> -       struct crypto_comp *tfm;
> +       struct scatterlist input, output;
> +       struct crypto_acomp_ctx *acomp_ctx;
>         int ret;
>         unsigned int hlen, dlen = PAGE_SIZE;
>         unsigned long handle, value;
> @@ -1074,12 +1140,32 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>         }
>
>         /* compress */
> -       dst = get_cpu_var(zswap_dstmem);
> -       tfm = *get_cpu_ptr(entry->pool->tfm);
> -       src = kmap_atomic(page);
> -       ret = crypto_comp_compress(tfm, src, PAGE_SIZE, dst, &dlen);
> -       kunmap_atomic(src);
> -       put_cpu_ptr(entry->pool->tfm);
> +       acomp_ctx = this_cpu_ptr(entry->pool->acomp_ctx);
> +
> +       mutex_lock(acomp_ctx->mutex);
> +
> +       src = kmap(page);
> +       dst = acomp_ctx->dstmem;
> +       sg_init_one(&input, src, PAGE_SIZE);
> +       /* zswap_dstmem is of size (PAGE_SIZE * 2). Reflect same in sg_list */
> +       sg_init_one(&output, dst, PAGE_SIZE * 2);
> +       acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
> +       /*
> +        * it maybe looks a little bit silly that we send an asynchronous request,
> +        * then wait for its completion synchronously. This makes the process look
> +        * synchronous in fact.
> +        * Theoretically, acomp supports users send multiple acomp requests in one
> +        * acomp instance, then get those requests done simultaneously. but in this
> +        * case, frontswap actually does store and load page by page, there is no
> +        * existing method to send the second page before the first page is done
> +        * in one thread doing frontswap.
> +        * but in different threads running on different cpu, we have different
> +        * acomp instance, so multiple threads can do (de)compression in parallel.
> +        */
> +       ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
> +       dlen = acomp_ctx->req->dlen;
> +       kunmap(page);
> +
>         if (ret) {
>                 ret = -EINVAL;
>                 goto put_dstmem;
> @@ -1103,7 +1189,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>         memcpy(buf, &zhdr, hlen);
>         memcpy(buf + hlen, dst, dlen);
>         zpool_unmap_handle(entry->pool->zpool, handle);
> -       put_cpu_var(zswap_dstmem);
> +       mutex_unlock(acomp_ctx->mutex);
>
>         /* populate entry */
>         entry->offset = offset;
> @@ -1131,7 +1217,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>         return 0;
>
>  put_dstmem:
> -       put_cpu_var(zswap_dstmem);
> +       mutex_unlock(acomp_ctx->mutex);
>         zswap_pool_put(entry->pool);
>  freepage:
>         zswap_entry_cache_free(entry);
> @@ -1148,7 +1234,8 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
>  {
>         struct zswap_tree *tree = zswap_trees[type];
>         struct zswap_entry *entry;
> -       struct crypto_comp *tfm;
> +       struct scatterlist input, output;
> +       struct crypto_acomp_ctx *acomp_ctx;
>         u8 *src, *dst;
>         unsigned int dlen;
>         int ret;
> @@ -1175,11 +1262,17 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
>         src = zpool_map_handle(entry->pool->zpool, entry->handle, ZPOOL_MM_RO);
>         if (zpool_evictable(entry->pool->zpool))
>                 src += sizeof(struct zswap_header);
> -       dst = kmap_atomic(page);
> -       tfm = *get_cpu_ptr(entry->pool->tfm);
> -       ret = crypto_comp_decompress(tfm, src, entry->length, dst, &dlen);
> -       put_cpu_ptr(entry->pool->tfm);
> -       kunmap_atomic(dst);
> +       dst = kmap(page);
> +
> +       acomp_ctx = this_cpu_ptr(entry->pool->acomp_ctx);
> +       mutex_lock(acomp_ctx->mutex);
> +       sg_init_one(&input, src, entry->length);
> +       sg_init_one(&output, dst, dlen);
> +       acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
> +       ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
> +       mutex_unlock(acomp_ctx->mutex);
> +
> +       kunmap(page);
>         zpool_unmap_handle(entry->pool->zpool, entry->handle);
>         BUG_ON(ret);
>
> --
> 2.27.0
>
>

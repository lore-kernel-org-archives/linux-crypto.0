Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888D8C433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 11:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57C4523BDD
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 11:16:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=konsulko.com header.i=@konsulko.com header.b="hd/364vF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbgFULQl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 07:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729901AbgFULQl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 07:16:41 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB6CC061795
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 04:16:40 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id 9so16183776ljc.8
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 04:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mm2w+JiPkRaf4ON3iiLHs/qTuBwPzoBzezw7dXy6YY0=;
        b=hd/364vFSV7v9KErrfLKr9N6UalB3Us7THFhA/DS7JZTLSDZcjvFMCUkFEJT/F7do/
         t1f30w6q50GocCZvfUddJhmGnAZ1HLtUzC57EXFB0abMpA10tDYKrlMIaiI++YRL6ADn
         CpYanTtW1yXoPFvXgq8VTbWVRYZFfTLaEmBHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mm2w+JiPkRaf4ON3iiLHs/qTuBwPzoBzezw7dXy6YY0=;
        b=RaAoBq4JL9iF0Asah+eAOOoe6YIKL3YZ365/YKu4EqbsskAoY4sa9Lme3Z7mvWwatn
         ci/fKX3ZO+1wF2xq3yCRzk1zN5BA7aUavm/fpp920BIjDGVJhSMooQ/7zH5xIuASKyAG
         A9sims9mYYTghvdkh1tPkaRZxtM3zYNMxEWkzCTnfDxVQ4rnIlj8nLHif6aDRgn8tf/r
         3/kDlhx3HyTDWLFqx3axVCZh6mfipNkSYChWgDvEwFFo6FLTIpvXmvvfgzTzkcewIkc/
         c45262uDDQaNMeiNOcVxmGejh1Vb1k0T2GH+y6aBzy62Ku00efC1hPwG8XnlcnOhxs/V
         aPJw==
X-Gm-Message-State: AOAM5318cad0wbhWAAXRC4UmfullZo5jsvFT3/lCeQ4SzKMl3cTirkhD
        6k3YCQSmNiZzXWHj9g+zpUJrXLV9iEfv3Z/vdyeEsw==
X-Google-Smtp-Source: ABdhPJz0RMCHaxyvSa+QzXao7cgXQzGtpjzEm3k637SdpB/BfLCwB62g8RjbcdcrJPAgO9l0w631lGpcqZNINigTCKk=
X-Received: by 2002:a2e:9187:: with SMTP id f7mr6204508ljg.450.1592738199213;
 Sun, 21 Jun 2020 04:16:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200620235033.8420-1-song.bao.hua@hisilicon.com>
In-Reply-To: <20200620235033.8420-1-song.bao.hua@hisilicon.com>
From:   Vitaly Wool <vitaly.wool@konsulko.com>
Date:   Sun, 21 Jun 2020 13:16:28 +0200
Message-ID: <CAM4kBBKKR01hFpB02YLPHBHsLiBHuEDfC96RvDug0P4_h6eQzg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: move to use crypto_acomp API for hardware acceleration
To:     Barry Song <song.bao.hua@hisilicon.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Zhou Wang <wangzhou1@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jun 21, 2020 at 1:52 AM Barry Song <song.bao.hua@hisilicon.com> wrote:
>
> right now, all new ZIP drivers are using crypto_acomp APIs rather than
> legacy crypto_comp APIs. But zswap.c is still using the old APIs. That
> means zswap won't be able to use any new zip drivers in kernel.
>
> This patch moves to use cryto_acomp APIs to fix the problem. On the
> other hand, tradiontal compressors like lz4,lzo etc have been wrapped
> into acomp via scomp backend. So platforms without async compressors
> can fallback to use acomp via scomp backend.
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
> Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
> ---
>  -v2:
>  rebase to 5.8-rc1;
>  cleanup commit log;
>  cleanup to improve the readability according to Sebastian's comment
>
>  mm/zswap.c | 153 ++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 110 insertions(+), 43 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index fbb782924ccc..0d914ba6b4a0 100644
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
> +       struct mutex mutex;
> +};
> +
>  struct zswap_pool {
>         struct zpool *zpool;
> -       struct crypto_comp * __percpu *tfm;
> +       struct crypto_acomp_ctx * __percpu *acomp_ctx;
>         struct kref kref;
>         struct list_head list;
>         struct work_struct release_work;
> @@ -415,30 +425,60 @@ static int zswap_dstmem_dead(unsigned int cpu)
>  static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  {
>         struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> -       struct crypto_comp *tfm;
> +       struct crypto_acomp *acomp;
> +       struct acomp_req *req;
> +       struct crypto_acomp_ctx *acomp_ctx;
>
> -       if (WARN_ON(*per_cpu_ptr(pool->tfm, cpu)))
> +       if (WARN_ON(*per_cpu_ptr(pool->acomp_ctx, cpu)))
>                 return 0;
>
> -       tfm = crypto_alloc_comp(pool->tfm_name, 0, 0);
> -       if (IS_ERR_OR_NULL(tfm)) {
> -               pr_err("could not alloc crypto comp %s : %ld\n",
> -                      pool->tfm_name, PTR_ERR(tfm));
> +       acomp_ctx = kzalloc(sizeof(*acomp_ctx), GFP_KERNEL);
> +       if (IS_ERR_OR_NULL(acomp_ctx)) {
> +               pr_err("Could not initialize acomp_ctx\n");
> +               return -ENOMEM;
> +       }
> +       acomp = crypto_alloc_acomp(pool->tfm_name, 0, 0);
> +       if (IS_ERR_OR_NULL(acomp)) {
> +               pr_err("could not alloc crypto acomp %s : %ld\n",
> +                               pool->tfm_name, PTR_ERR(acomp));
>                 return -ENOMEM;
>         }

I bet you actually want to free acomp_ctx here. Overall, could you
please provide more careful error path implementation or explain why
it isn't necessary?

Best regards,
    Vitaly

> -       *per_cpu_ptr(pool->tfm, cpu) = tfm;
> +       acomp_ctx->acomp = acomp;
> +
> +       req = acomp_request_alloc(acomp_ctx->acomp);
> +       if (IS_ERR_OR_NULL(req)) {
> +               pr_err("could not alloc crypto acomp %s : %ld\n",
> +                      pool->tfm_name, PTR_ERR(acomp));
> +               return -ENOMEM;
> +       }
> +       acomp_ctx->req = req;
> +
> +       mutex_init(&acomp_ctx->mutex);
> +       crypto_init_wait(&acomp_ctx->wait);
> +       acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +                                  crypto_req_done, &acomp_ctx->wait);
> +
> +       acomp_ctx->dstmem = per_cpu(zswap_dstmem, cpu);
> +       *per_cpu_ptr(pool->acomp_ctx, cpu) = acomp_ctx;
> +
>         return 0;
>  }
>
>  static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
>  {
>         struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> -       struct crypto_comp *tfm;
> +       struct crypto_acomp_ctx *acomp_ctx;
> +
> +       acomp_ctx = *per_cpu_ptr(pool->acomp_ctx, cpu);
> +       if (!IS_ERR_OR_NULL(acomp_ctx)) {
> +               if (!IS_ERR_OR_NULL(acomp_ctx->req))
> +                       acomp_request_free(acomp_ctx->req);
> +               if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> +                       crypto_free_acomp(acomp_ctx->acomp);
> +               kfree(acomp_ctx);
> +       }
> +       *per_cpu_ptr(pool->acomp_ctx, cpu) = NULL;
>
> -       tfm = *per_cpu_ptr(pool->tfm, cpu);
> -       if (!IS_ERR_OR_NULL(tfm))
> -               crypto_free_comp(tfm);
> -       *per_cpu_ptr(pool->tfm, cpu) = NULL;
>         return 0;
>  }
>
> @@ -561,8 +601,9 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
>         pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
>
>         strlcpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> -       pool->tfm = alloc_percpu(struct crypto_comp *);
> -       if (!pool->tfm) {
> +
> +       pool->acomp_ctx = alloc_percpu(struct crypto_acomp_ctx *);
> +       if (!pool->acomp_ctx) {
>                 pr_err("percpu alloc failed\n");
>                 goto error;
>         }
> @@ -585,7 +626,7 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
>         return pool;
>
>  error:
> -       free_percpu(pool->tfm);
> +       free_percpu(pool->acomp_ctx);
>         if (pool->zpool)
>                 zpool_destroy_pool(pool->zpool);
>         kfree(pool);
> @@ -596,14 +637,14 @@ static __init struct zswap_pool *__zswap_pool_create_fallback(void)
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
> @@ -639,7 +680,7 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
>         zswap_pool_debug("destroying", pool);
>
>         cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
> -       free_percpu(pool->tfm);
> +       free_percpu(pool->acomp_ctx);
>         zpool_destroy_pool(pool->zpool);
>         kfree(pool);
>  }
> @@ -723,7 +764,7 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
>                 }
>                 type = s;
>         } else if (!compressor) {
> -               if (!crypto_has_comp(s, 0, 0)) {
> +               if (!crypto_has_acomp(s, 0, 0)) {
>                         pr_err("compressor %s not available\n", s);
>                         return -ENOENT;
>                 }
> @@ -774,7 +815,7 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
>                  * failed, maybe both compressor and zpool params were bad.
>                  * Allow changing this param, so pool creation will succeed
>                  * when the other param is changed. We already verified this
> -                * param is ok in the zpool_has_pool() or crypto_has_comp()
> +                * param is ok in the zpool_has_pool() or crypto_has_acomp()
>                  * checks above.
>                  */
>                 ret = param_set_charp(s, kp);
> @@ -876,7 +917,9 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
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
> @@ -916,14 +959,21 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
>
>         case ZSWAP_SWAPCACHE_NEW: /* page is locked */
>                 /* decompress */
> +               acomp_ctx = *this_cpu_ptr(entry->pool->acomp_ctx);
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
> +               mutex_lock(&acomp_ctx->mutex);
> +               sg_init_one(&input, src, entry->length);
> +               sg_init_one(&output, dst, dlen);
> +               acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
> +               ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
> +               dlen = acomp_ctx->req->dlen;
> +               mutex_unlock(&acomp_ctx->mutex);
> +
> +               kunmap(page);
>                 BUG_ON(ret);
>                 BUG_ON(dlen != PAGE_SIZE);
>
> @@ -1004,7 +1054,8 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>  {
>         struct zswap_tree *tree = zswap_trees[type];
>         struct zswap_entry *entry, *dupentry;
> -       struct crypto_comp *tfm;
> +       struct scatterlist input, output;
> +       struct crypto_acomp_ctx *acomp_ctx;
>         int ret;
>         unsigned int hlen, dlen = PAGE_SIZE;
>         unsigned long handle, value;
> @@ -1074,12 +1125,20 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>         }
>
>         /* compress */
> -       dst = get_cpu_var(zswap_dstmem);
> -       tfm = *get_cpu_ptr(entry->pool->tfm);
> -       src = kmap_atomic(page);
> -       ret = crypto_comp_compress(tfm, src, PAGE_SIZE, dst, &dlen);
> -       kunmap_atomic(src);
> -       put_cpu_ptr(entry->pool->tfm);
> +       acomp_ctx = *this_cpu_ptr(entry->pool->acomp_ctx);
> +
> +       mutex_lock(&acomp_ctx->mutex);
> +
> +       src = kmap(page);
> +       dst = acomp_ctx->dstmem;
> +       sg_init_one(&input, src, PAGE_SIZE);
> +       /* zswap_dstmem is of size (PAGE_SIZE * 2). Reflect same in sg_list */
> +       sg_init_one(&output, dst, PAGE_SIZE * 2);
> +       acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
> +       ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
> +       dlen = acomp_ctx->req->dlen;
> +       kunmap(page);
> +
>         if (ret) {
>                 ret = -EINVAL;
>                 goto put_dstmem;
> @@ -1103,7 +1162,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>         memcpy(buf, &zhdr, hlen);
>         memcpy(buf + hlen, dst, dlen);
>         zpool_unmap_handle(entry->pool->zpool, handle);
> -       put_cpu_var(zswap_dstmem);
> +       mutex_unlock(&acomp_ctx->mutex);
>
>         /* populate entry */
>         entry->offset = offset;
> @@ -1131,7 +1190,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
>         return 0;
>
>  put_dstmem:
> -       put_cpu_var(zswap_dstmem);
> +       mutex_unlock(&acomp_ctx->mutex);
>         zswap_pool_put(entry->pool);
>  freepage:
>         zswap_entry_cache_free(entry);
> @@ -1148,7 +1207,8 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
>  {
>         struct zswap_tree *tree = zswap_trees[type];
>         struct zswap_entry *entry;
> -       struct crypto_comp *tfm;
> +       struct scatterlist input, output;
> +       struct crypto_acomp_ctx *acomp_ctx;
>         u8 *src, *dst;
>         unsigned int dlen;
>         int ret;
> @@ -1175,11 +1235,18 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
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
> +       acomp_ctx = *this_cpu_ptr(entry->pool->acomp_ctx);
> +       mutex_lock(&acomp_ctx->mutex);
> +       sg_init_one(&input, src, entry->length);
> +       sg_init_one(&output, dst, dlen);
> +       acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
> +       ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
> +       dlen = acomp_ctx->req->dlen;
> +       mutex_unlock(&acomp_ctx->mutex);
> +
> +       kunmap(page);
>         zpool_unmap_handle(entry->pool->zpool, entry->handle);
>         BUG_ON(ret);
>
> --
> 2.27.0
>
>

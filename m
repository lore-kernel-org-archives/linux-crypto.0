Return-Path: <SRS0=sSQu=EN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4509C388F7
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Nov 2020 06:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FD21221FC
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Nov 2020 06:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgKGG5q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Nov 2020 01:57:46 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7425 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgKGG5q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Nov 2020 01:57:46 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CSp3d3dfPz742j;
        Sat,  7 Nov 2020 14:57:33 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.202.48) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Sat, 7 Nov 2020 14:57:28 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <akpm@linux-foundation.org>
CC:     <linuxarm@huawei.com>, <fanghao11@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        "Seth Jennings" <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH v7] mm/zswap: move to use crypto_acomp API for hardware acceleration
Date:   Sat, 7 Nov 2020 19:53:32 +1300
Message-ID: <20201107065332.26992-1-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.202.48]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Right now, all new ZIP drivers are adapted to crypto_acomp APIs rather
than legacy crypto_comp APIs. Tradiontal ZIP drivers like lz4,lzo etc
have been also wrapped into acomp via scomp backend. But zswap.c is still
using the old APIs. That means zswap won't be able to work on any new
ZIP drivers in kernel.

This patch moves to use cryto_acomp APIs to fix the disconnected bridge
between new ZIP drivers and zswap. It is probably the first real user
to use acomp but perhaps not a good example to demonstrate how multiple
acomp requests can be executed in parallel in one acomp instance.
frontswap is doing page load and store page by page synchronously.
swap_writepage() depends on the completion of frontswap_store() to
decide if it should call __swap_writepage() to swap to disk.

However this patch creates multiple acomp instances, so multiple threads
running on multiple different cpus can actually do (de)compression
parallelly, leveraging the power of multiple ZIP hardware queues. This
is also consistent with frontswap's page management model.

The old zswap code uses atomic context and avoids the race conditions
while shared resources like zswap_dstmem are accessed. Here since acomp
can sleep, per-cpu mutex is used to replace preemption-disable.

While it is possible to make mm/page_io.c and mm/frontswap.c support
async (de)compression in some way, the entire design requires careful
thinking and performance evaluation. For the first step, the base with
fixed connection between ZIP drivers and zswap should be built.

Acked-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Mahipal Challa <mahipalreddy2006@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Zhou Wang <wangzhou1@hisilicon.com>
Cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 -v7:
 1. Add Acked-by of Vitaly Wool, thanks!
 2. Address the issues pointed out by Sebastian Andrzej Siewior, thanks!
  * remove redundant kmap and move to use sg_set_page;
  * remove the warning if DEBUG_PREEMPTIBLE is enabled by using
    raw_cpu_ptr(). 
  * Regarding another code refinement issue, I am still not a big fan of
     a. get_cpu_ptr() for the acomp_ctx   //lock preemption
     b. this_cpu_ptr() for the dstmem and mutex
     c. put_cpu_ptr() for the acomp_ctx  //unlock preemption
 It seems the code is better looking to put all stuff in a struct,
 and get the per_cpu struct to get them all rather than adding a
 preemption-disabled context and getting them one by one.

 mm/zswap.c | 183 +++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 137 insertions(+), 46 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index fbb7829..73f04de 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -24,8 +24,10 @@
 #include <linux/rbtree.h>
 #include <linux/swap.h>
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include <linux/mempool.h>
 #include <linux/zpool.h>
+#include <crypto/acompress.h>
 
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
@@ -127,9 +129,17 @@ module_param_named(same_filled_pages_enabled, zswap_same_filled_pages_enabled,
 * data structures
 **********************************/
 
+struct crypto_acomp_ctx {
+	struct crypto_acomp *acomp;
+	struct acomp_req *req;
+	struct crypto_wait wait;
+	u8 *dstmem;
+	struct mutex *mutex;
+};
+
 struct zswap_pool {
 	struct zpool *zpool;
-	struct crypto_comp * __percpu *tfm;
+	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct kref kref;
 	struct list_head list;
 	struct work_struct release_work;
@@ -388,23 +398,43 @@ static struct zswap_entry *zswap_entry_find_get(struct rb_root *root,
 * per-cpu code
 **********************************/
 static DEFINE_PER_CPU(u8 *, zswap_dstmem);
+/*
+ * If users dynamically change the zpool type and compressor at runtime, i.e.
+ * zswap is running, zswap can have more than one zpool on one cpu, but they
+ * are sharing dtsmem. So we need this mutex to be per-cpu.
+ */
+static DEFINE_PER_CPU(struct mutex *, zswap_mutex);
 
 static int zswap_dstmem_prepare(unsigned int cpu)
 {
+	struct mutex *mutex;
 	u8 *dst;
 
 	dst = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
 	if (!dst)
 		return -ENOMEM;
 
+	mutex = kmalloc_node(sizeof(*mutex), GFP_KERNEL, cpu_to_node(cpu));
+	if (!mutex) {
+		kfree(dst);
+		return -ENOMEM;
+	}
+
+	mutex_init(mutex);
 	per_cpu(zswap_dstmem, cpu) = dst;
+	per_cpu(zswap_mutex, cpu) = mutex;
 	return 0;
 }
 
 static int zswap_dstmem_dead(unsigned int cpu)
 {
+	struct mutex *mutex;
 	u8 *dst;
 
+	mutex = per_cpu(zswap_mutex, cpu);
+	kfree(mutex);
+	per_cpu(zswap_mutex, cpu) = NULL;
+
 	dst = per_cpu(zswap_dstmem, cpu);
 	kfree(dst);
 	per_cpu(zswap_dstmem, cpu) = NULL;
@@ -415,30 +445,54 @@ static int zswap_dstmem_dead(unsigned int cpu)
 static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_comp *tfm;
-
-	if (WARN_ON(*per_cpu_ptr(pool->tfm, cpu)))
-		return 0;
+	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	struct crypto_acomp *acomp;
+	struct acomp_req *req;
+
+	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	if (IS_ERR(acomp)) {
+		pr_err("could not alloc crypto acomp %s : %ld\n",
+				pool->tfm_name, PTR_ERR(acomp));
+		return PTR_ERR(acomp);
+	}
+	acomp_ctx->acomp = acomp;
 
-	tfm = crypto_alloc_comp(pool->tfm_name, 0, 0);
-	if (IS_ERR_OR_NULL(tfm)) {
-		pr_err("could not alloc crypto comp %s : %ld\n",
-		       pool->tfm_name, PTR_ERR(tfm));
+	req = acomp_request_alloc(acomp_ctx->acomp);
+	if (!req) {
+		pr_err("could not alloc crypto acomp_request %s\n",
+		       pool->tfm_name);
+		crypto_free_acomp(acomp_ctx->acomp);
 		return -ENOMEM;
 	}
-	*per_cpu_ptr(pool->tfm, cpu) = tfm;
+	acomp_ctx->req = req;
+
+	crypto_init_wait(&acomp_ctx->wait);
+	/*
+	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
+	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
+	 * won't be called, crypto_wait_req() will return without blocking.
+	 */
+	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, &acomp_ctx->wait);
+
+	acomp_ctx->mutex = per_cpu(zswap_mutex, cpu);
+	acomp_ctx->dstmem = per_cpu(zswap_dstmem, cpu);
+
 	return 0;
 }
 
 static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_comp *tfm;
+	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+
+	if (!IS_ERR_OR_NULL(acomp_ctx)) {
+		if (!IS_ERR_OR_NULL(acomp_ctx->req))
+			acomp_request_free(acomp_ctx->req);
+		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
+			crypto_free_acomp(acomp_ctx->acomp);
+	}
 
-	tfm = *per_cpu_ptr(pool->tfm, cpu);
-	if (!IS_ERR_OR_NULL(tfm))
-		crypto_free_comp(tfm);
-	*per_cpu_ptr(pool->tfm, cpu) = NULL;
 	return 0;
 }
 
@@ -561,8 +615,9 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
 
 	strlcpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
-	pool->tfm = alloc_percpu(struct crypto_comp *);
-	if (!pool->tfm) {
+
+	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
+	if (!pool->acomp_ctx) {
 		pr_err("percpu alloc failed\n");
 		goto error;
 	}
@@ -585,7 +640,8 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 	return pool;
 
 error:
-	free_percpu(pool->tfm);
+	if (pool->acomp_ctx)
+		free_percpu(pool->acomp_ctx);
 	if (pool->zpool)
 		zpool_destroy_pool(pool->zpool);
 	kfree(pool);
@@ -596,14 +652,14 @@ static __init struct zswap_pool *__zswap_pool_create_fallback(void)
 {
 	bool has_comp, has_zpool;
 
-	has_comp = crypto_has_comp(zswap_compressor, 0, 0);
+	has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
 	if (!has_comp && strcmp(zswap_compressor,
 				CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
 		pr_err("compressor %s not available, using default %s\n",
 		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
 		param_free_charp(&zswap_compressor);
 		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
-		has_comp = crypto_has_comp(zswap_compressor, 0, 0);
+		has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
 	}
 	if (!has_comp) {
 		pr_err("default compressor %s not available\n",
@@ -639,7 +695,7 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 	zswap_pool_debug("destroying", pool);
 
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
-	free_percpu(pool->tfm);
+	free_percpu(pool->acomp_ctx);
 	zpool_destroy_pool(pool->zpool);
 	kfree(pool);
 }
@@ -723,7 +779,7 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
 		}
 		type = s;
 	} else if (!compressor) {
-		if (!crypto_has_comp(s, 0, 0)) {
+		if (!crypto_has_acomp(s, 0, 0)) {
 			pr_err("compressor %s not available\n", s);
 			return -ENOENT;
 		}
@@ -774,7 +830,7 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
 		 * failed, maybe both compressor and zpool params were bad.
 		 * Allow changing this param, so pool creation will succeed
 		 * when the other param is changed. We already verified this
-		 * param is ok in the zpool_has_pool() or crypto_has_comp()
+		 * param is ok in the zpool_has_pool() or crypto_has_acomp()
 		 * checks above.
 		 */
 		ret = param_set_charp(s, kp);
@@ -876,8 +932,10 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
 	pgoff_t offset;
 	struct zswap_entry *entry;
 	struct page *page;
-	struct crypto_comp *tfm;
-	u8 *src, *dst;
+	struct scatterlist input, output;
+	struct crypto_acomp_ctx *acomp_ctx;
+
+	u8 *src;
 	unsigned int dlen;
 	int ret;
 	struct writeback_control wbc = {
@@ -916,14 +974,20 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
 
 	case ZSWAP_SWAPCACHE_NEW: /* page is locked */
 		/* decompress */
+		acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+
 		dlen = PAGE_SIZE;
 		src = (u8 *)zhdr + sizeof(struct zswap_header);
-		dst = kmap_atomic(page);
-		tfm = *get_cpu_ptr(entry->pool->tfm);
-		ret = crypto_comp_decompress(tfm, src, entry->length,
-					     dst, &dlen);
-		put_cpu_ptr(entry->pool->tfm);
-		kunmap_atomic(dst);
+
+		mutex_lock(acomp_ctx->mutex);
+		sg_init_one(&input, src, entry->length);
+		sg_init_table(&output, 1);
+		sg_set_page(&output, page, PAGE_SIZE, 0);
+		acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
+		ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
+		dlen = acomp_ctx->req->dlen;
+		mutex_unlock(acomp_ctx->mutex);
+
 		BUG_ON(ret);
 		BUG_ON(dlen != PAGE_SIZE);
 
@@ -1004,7 +1068,8 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry, *dupentry;
-	struct crypto_comp *tfm;
+	struct scatterlist input, output;
+	struct crypto_acomp_ctx *acomp_ctx;
 	int ret;
 	unsigned int hlen, dlen = PAGE_SIZE;
 	unsigned long handle, value;
@@ -1074,12 +1139,32 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 	}
 
 	/* compress */
-	dst = get_cpu_var(zswap_dstmem);
-	tfm = *get_cpu_ptr(entry->pool->tfm);
-	src = kmap_atomic(page);
-	ret = crypto_comp_compress(tfm, src, PAGE_SIZE, dst, &dlen);
-	kunmap_atomic(src);
-	put_cpu_ptr(entry->pool->tfm);
+	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+
+	mutex_lock(acomp_ctx->mutex);
+
+	dst = acomp_ctx->dstmem;
+	sg_init_table(&input, 1);
+	sg_set_page(&input, page, PAGE_SIZE, 0);
+
+	/* zswap_dstmem is of size (PAGE_SIZE * 2). Reflect same in sg_list */
+	sg_init_one(&output, dst, PAGE_SIZE * 2);
+	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	/*
+	 * it maybe looks a little bit silly that we send an asynchronous request,
+	 * then wait for its completion synchronously. This makes the process look
+	 * synchronous in fact.
+	 * Theoretically, acomp supports users send multiple acomp requests in one
+	 * acomp instance, then get those requests done simultaneously. but in this
+	 * case, frontswap actually does store and load page by page, there is no
+	 * existing method to send the second page before the first page is done
+	 * in one thread doing frontswap.
+	 * but in different threads running on different cpu, we have different
+	 * acomp instance, so multiple threads can do (de)compression in parallel.
+	 */
+	ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
+	dlen = acomp_ctx->req->dlen;
+
 	if (ret) {
 		ret = -EINVAL;
 		goto put_dstmem;
@@ -1103,7 +1188,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 	memcpy(buf, &zhdr, hlen);
 	memcpy(buf + hlen, dst, dlen);
 	zpool_unmap_handle(entry->pool->zpool, handle);
-	put_cpu_var(zswap_dstmem);
+	mutex_unlock(acomp_ctx->mutex);
 
 	/* populate entry */
 	entry->offset = offset;
@@ -1131,7 +1216,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 	return 0;
 
 put_dstmem:
-	put_cpu_var(zswap_dstmem);
+	mutex_unlock(acomp_ctx->mutex);
 	zswap_pool_put(entry->pool);
 freepage:
 	zswap_entry_cache_free(entry);
@@ -1148,7 +1233,8 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
-	struct crypto_comp *tfm;
+	struct scatterlist input, output;
+	struct crypto_acomp_ctx *acomp_ctx;
 	u8 *src, *dst;
 	unsigned int dlen;
 	int ret;
@@ -1175,11 +1261,16 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
 	src = zpool_map_handle(entry->pool->zpool, entry->handle, ZPOOL_MM_RO);
 	if (zpool_evictable(entry->pool->zpool))
 		src += sizeof(struct zswap_header);
-	dst = kmap_atomic(page);
-	tfm = *get_cpu_ptr(entry->pool->tfm);
-	ret = crypto_comp_decompress(tfm, src, entry->length, dst, &dlen);
-	put_cpu_ptr(entry->pool->tfm);
-	kunmap_atomic(dst);
+
+	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+	mutex_lock(acomp_ctx->mutex);
+	sg_init_one(&input, src, entry->length);
+	sg_init_table(&output, 1);
+	sg_set_page(&output, page, PAGE_SIZE, 0);
+	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
+	ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
+	mutex_unlock(acomp_ctx->mutex);
+
 	zpool_unmap_handle(entry->pool->zpool, entry->handle);
 	BUG_ON(ret);
 
-- 
2.7.4


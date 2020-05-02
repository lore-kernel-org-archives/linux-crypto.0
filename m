Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5D2C47256
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 02:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B14F0208C3
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 02:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgEBCFU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 May 2020 22:05:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33980 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726381AbgEBCFT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 May 2020 22:05:19 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E0FE78A18043CA0096F8;
        Sat,  2 May 2020 10:05:16 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.201.216) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Sat, 2 May 2020 10:05:09 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <sjenning@redhat.com>,
        <ddstreet@ieee.org>, <vitaly.wool@konsulko.com>
CC:     <mahipalreddy2006@gmail.com>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH 1/1] mm/zswap: move to use crypto_acomp API for hardware acceleration
Date:   Sat, 2 May 2020 14:04:19 +1200
Message-ID: <20200502020419.11616-2-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20200502020419.11616-1-song.bao.hua@hisilicon.com>
References: <20200502020419.11616-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.201.216]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

right now, new drivers are adapted to crypto_acomp APIs rather than crypto_comp
APIs. Tradiontal compressors like lz4,lzo etc have been wrapped into acomp via
scomp backend as well.
To use the new hardware acceleration for compression, zswap should move to use
acomp APIs. Platforms without async accelerators can still work through scomp.

Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 mm/zswap.c | 150 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 108 insertions(+), 42 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index fbb782924ccc..44a982632deb 100644
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
@@ -127,9 +129,16 @@ module_param_named(same_filled_pages_enabled, zswap_same_filled_pages_enabled,
 * data structures
 **********************************/
 
+struct crypto_acomp_ctx {
+	struct crypto_acomp *acomp;
+	struct acomp_req *req;
+	struct crypto_wait wait;
+	struct mutex mutex;
+};
+
 struct zswap_pool {
 	struct zpool *zpool;
-	struct crypto_comp * __percpu *tfm;
+	struct crypto_acomp_ctx * __percpu *acomp_ctx;
 	struct kref kref;
 	struct list_head list;
 	struct work_struct release_work;
@@ -415,30 +424,59 @@ static int zswap_dstmem_dead(unsigned int cpu)
 static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_comp *tfm;
+	struct crypto_acomp *acomp;
+	struct acomp_req *req;
+	struct crypto_acomp_ctx *acomp_ctx;
 
-	if (WARN_ON(*per_cpu_ptr(pool->tfm, cpu)))
+	if (WARN_ON(*per_cpu_ptr(pool->acomp_ctx, cpu)))
 		return 0;
 
-	tfm = crypto_alloc_comp(pool->tfm_name, 0, 0);
-	if (IS_ERR_OR_NULL(tfm)) {
-		pr_err("could not alloc crypto comp %s : %ld\n",
-		       pool->tfm_name, PTR_ERR(tfm));
+	acomp_ctx = kzalloc(sizeof(*acomp_ctx), GFP_KERNEL);
+	if (IS_ERR_OR_NULL(acomp_ctx)) {
+		pr_err("Could not initialize acomp_ctx\n");
+		return -ENOMEM;
+	}
+	acomp = crypto_alloc_acomp(pool->tfm_name, 0, 0);
+	if (IS_ERR_OR_NULL(acomp)) {
+		pr_err("could not alloc crypto acomp %s : %ld\n",
+				pool->tfm_name, PTR_ERR(acomp));
+		return -ENOMEM;
+	}
+	acomp_ctx->acomp = acomp;
+
+	req = acomp_request_alloc(acomp_ctx->acomp);
+	if (IS_ERR_OR_NULL(req)) {
+		pr_err("could not alloc crypto acomp %s : %ld\n",
+		       pool->tfm_name, PTR_ERR(acomp));
 		return -ENOMEM;
 	}
-	*per_cpu_ptr(pool->tfm, cpu) = tfm;
+	acomp_ctx->req = req;
+
+	mutex_init(&acomp_ctx->mutex);
+	crypto_init_wait(&acomp_ctx->wait);
+	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, &acomp_ctx->wait);
+
+	*per_cpu_ptr(pool->acomp_ctx, cpu) = acomp_ctx;
+
 	return 0;
 }
 
 static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_comp *tfm;
+	struct crypto_acomp_ctx *acomp_ctx;
+
+	acomp_ctx = *per_cpu_ptr(pool->acomp_ctx, cpu);
+	if (!IS_ERR_OR_NULL(acomp_ctx)) {
+		if (!IS_ERR_OR_NULL(acomp_ctx->req))
+			acomp_request_free(acomp_ctx->req);
+		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
+			crypto_free_acomp(acomp_ctx->acomp);
+		kfree(acomp_ctx);
+	}
+	*per_cpu_ptr(pool->acomp_ctx, cpu) = NULL;
 
-	tfm = *per_cpu_ptr(pool->tfm, cpu);
-	if (!IS_ERR_OR_NULL(tfm))
-		crypto_free_comp(tfm);
-	*per_cpu_ptr(pool->tfm, cpu) = NULL;
 	return 0;
 }
 
@@ -561,8 +599,9 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
 
 	strlcpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
-	pool->tfm = alloc_percpu(struct crypto_comp *);
-	if (!pool->tfm) {
+
+	pool->acomp_ctx = alloc_percpu(struct crypto_acomp_ctx *);
+	if (!pool->acomp_ctx) {
 		pr_err("percpu alloc failed\n");
 		goto error;
 	}
@@ -585,7 +624,7 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 	return pool;
 
 error:
-	free_percpu(pool->tfm);
+	free_percpu(pool->acomp_ctx);
 	if (pool->zpool)
 		zpool_destroy_pool(pool->zpool);
 	kfree(pool);
@@ -596,14 +635,14 @@ static __init struct zswap_pool *__zswap_pool_create_fallback(void)
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
@@ -639,7 +678,7 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 	zswap_pool_debug("destroying", pool);
 
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
-	free_percpu(pool->tfm);
+	free_percpu(pool->acomp_ctx);
 	zpool_destroy_pool(pool->zpool);
 	kfree(pool);
 }
@@ -723,7 +762,7 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
 		}
 		type = s;
 	} else if (!compressor) {
-		if (!crypto_has_comp(s, 0, 0)) {
+		if (!crypto_has_acomp(s, 0, 0)) {
 			pr_err("compressor %s not available\n", s);
 			return -ENOENT;
 		}
@@ -774,7 +813,7 @@ static int __zswap_param_set(const char *val, const struct kernel_param *kp,
 		 * failed, maybe both compressor and zpool params were bad.
 		 * Allow changing this param, so pool creation will succeed
 		 * when the other param is changed. We already verified this
-		 * param is ok in the zpool_has_pool() or crypto_has_comp()
+		 * param is ok in the zpool_has_pool() or crypto_has_acomp()
 		 * checks above.
 		 */
 		ret = param_set_charp(s, kp);
@@ -876,7 +915,9 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
 	pgoff_t offset;
 	struct zswap_entry *entry;
 	struct page *page;
-	struct crypto_comp *tfm;
+	struct scatterlist input, output;
+	struct crypto_acomp_ctx *acomp_ctx;
+
 	u8 *src, *dst;
 	unsigned int dlen;
 	int ret;
@@ -916,14 +957,21 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
 
 	case ZSWAP_SWAPCACHE_NEW: /* page is locked */
 		/* decompress */
+		acomp_ctx = *this_cpu_ptr(entry->pool->acomp_ctx);
+
 		dlen = PAGE_SIZE;
 		src = (u8 *)zhdr + sizeof(struct zswap_header);
-		dst = kmap_atomic(page);
-		tfm = *get_cpu_ptr(entry->pool->tfm);
-		ret = crypto_comp_decompress(tfm, src, entry->length,
-					     dst, &dlen);
-		put_cpu_ptr(entry->pool->tfm);
-		kunmap_atomic(dst);
+		dst = kmap(page);
+
+		mutex_lock(&acomp_ctx->mutex);
+		sg_init_one(&input, src, entry->length);
+		sg_init_one(&output, dst, dlen);
+		acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
+		ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
+		dlen = acomp_ctx->req->dlen;
+		mutex_unlock(&acomp_ctx->mutex);
+
+		kunmap(page);
 		BUG_ON(ret);
 		BUG_ON(dlen != PAGE_SIZE);
 
@@ -1004,7 +1052,8 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry, *dupentry;
-	struct crypto_comp *tfm;
+	struct scatterlist input, output;
+	struct crypto_acomp_ctx *acomp_ctx;
 	int ret;
 	unsigned int hlen, dlen = PAGE_SIZE;
 	unsigned long handle, value;
@@ -1075,11 +1124,20 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 
 	/* compress */
 	dst = get_cpu_var(zswap_dstmem);
-	tfm = *get_cpu_ptr(entry->pool->tfm);
-	src = kmap_atomic(page);
-	ret = crypto_comp_compress(tfm, src, PAGE_SIZE, dst, &dlen);
-	kunmap_atomic(src);
-	put_cpu_ptr(entry->pool->tfm);
+	acomp_ctx = *this_cpu_ptr(entry->pool->acomp_ctx);
+	put_cpu_var(zswap_dstmem);
+
+	mutex_lock(&acomp_ctx->mutex);
+
+	src = kmap(page);
+	sg_init_one(&input, src, PAGE_SIZE);
+	/* zswap_dstmem is of size (PAGE_SIZE * 2). Reflect same in sg_list */
+	sg_init_one(&output, dst, PAGE_SIZE * 2);
+	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
+	dlen = acomp_ctx->req->dlen;
+	kunmap(page);
+
 	if (ret) {
 		ret = -EINVAL;
 		goto put_dstmem;
@@ -1103,7 +1161,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 	memcpy(buf, &zhdr, hlen);
 	memcpy(buf + hlen, dst, dlen);
 	zpool_unmap_handle(entry->pool->zpool, handle);
-	put_cpu_var(zswap_dstmem);
+	mutex_unlock(&acomp_ctx->mutex);
 
 	/* populate entry */
 	entry->offset = offset;
@@ -1131,7 +1189,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 	return 0;
 
 put_dstmem:
-	put_cpu_var(zswap_dstmem);
+	mutex_unlock(&acomp_ctx->mutex);
 	zswap_pool_put(entry->pool);
 freepage:
 	zswap_entry_cache_free(entry);
@@ -1148,7 +1206,8 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
-	struct crypto_comp *tfm;
+	struct scatterlist input, output;
+	struct crypto_acomp_ctx *acomp_ctx;
 	u8 *src, *dst;
 	unsigned int dlen;
 	int ret;
@@ -1175,11 +1234,18 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
 	src = zpool_map_handle(entry->pool->zpool, entry->handle, ZPOOL_MM_RO);
 	if (zpool_evictable(entry->pool->zpool))
 		src += sizeof(struct zswap_header);
-	dst = kmap_atomic(page);
-	tfm = *get_cpu_ptr(entry->pool->tfm);
-	ret = crypto_comp_decompress(tfm, src, entry->length, dst, &dlen);
-	put_cpu_ptr(entry->pool->tfm);
-	kunmap_atomic(dst);
+	dst = kmap(page);
+
+	acomp_ctx = *this_cpu_ptr(entry->pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
+	sg_init_one(&input, src, entry->length);
+	sg_init_one(&output, dst, dlen);
+	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
+	ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
+	dlen = acomp_ctx->req->dlen;
+	mutex_unlock(&acomp_ctx->mutex);
+
+	kunmap(page);
 	zpool_unmap_handle(entry->pool->zpool, entry->handle);
 	BUG_ON(ret);
 
-- 
2.23.0



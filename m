From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC 1/2] SPU-AES support (kernel side)
Date: Wed, 27 Jun 2007 01:00:27 +0200
Message-ID: <20070626230027.GA4581@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36772 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbXFZXA2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jun 2007 19:00:28 -0400
Content-Disposition: inline; filename="aes-spu-async2.diff"
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch implements the AES cipher algorithm which is executed on the
SPU using the crypto async interface. Currently only the ECB mode is
implemented. The AES code that is executed on the SPU has been left
apart (it is not exciting anyway).

Signed-off-by: Sebastian Siewior <bigeasy@breakpoint.cc>
--- a/arch/powerpc/platforms/cell/Makefile
+++ b/arch/powerpc/platforms/cell/Makefile
@@ -22,4 +22,5 @@ obj-$(CONFIG_SPU_BASE)			+= spu_callback
 					   $(spufs-modular-m) \
 					   $(spu-priv1-y) \
 					   $(spu-manage-y) \
+					   crypto/ \
 					   spufs/
--- /dev/null
+++ b/arch/powerpc/platforms/cell/crypto/Kconfig
@@ -0,0 +1,12 @@
+config CRYPTO_AES_SPU
+	tristate "AES cipher algorithm (SPU support)"
+	select CRYPTO_ABLKCIPHER
+	depends on SPU_KERNEL_SUPPORT
+	default m
+	help
+	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
+	  algorithm.
+	  The AES specifies three key sizes: 128, 192 and 256 bits.
+	  See <http://csrc.nist.gov/CryptoToolkit/aes/> for more information.
+
+	  This version of AES performs its work on a SPU core.
--- /dev/null
+++ b/arch/powerpc/platforms/cell/crypto/aes_spu_wrap.c
@@ -0,0 +1,479 @@
+/*
+ * AES interface module for the async crypto API.
+ *
+ * Author: Sebastian Siewior <bigeasy@breakpoint.cc>
+ * License: GPLv2
+ */
+
+#include <asm/byteorder.h>
+#include <asm/system.h>
+#include <asm/kspu/kspu.h>
+#include <asm/kspu/merged_code.h>
+#include <crypto/algapi.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/mutex.h>
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <linux/highmem.h>
+#include <linux/vmalloc.h>
+
+#include "aes_vmx_addon.h"
+
+struct map_key_spu {
+	struct list_head list;
+	unsigned int spu_slot;
+	struct aes_ctx *slot_content;
+};
+
+struct aes_ctx {
+	/* the key used for enc|dec purpose */
+	struct aes_key_struct key;
+	/* identify the slot on the SPU */
+	struct map_key_spu *key_mapping;
+	/* identify the SPU that is used */
+	struct async_aes *spe_ctx;
+};
+
+struct async_d_request {
+	enum SPU_FUNCTIONS crypto_operation;
+	 /*
+	  * If src|dst or iv is not properly aligned, we keep here a copy of
+	  * it that is properly aligned.
+	  */
+	struct kspu_work_item kspu_work;
+	unsigned char *al_data;
+/*	unsigned char *aligned_iv; */
+	unsigned char *mapped_src;
+	unsigned char *mapped_dst;
+	unsigned char *real_src;
+	unsigned char *real_dst;
+	unsigned int progress;
+};
+
+struct async_aes {
+	struct kspu_context *ctx;
+	struct map_key_spu mapping_key_spu[SPU_KEY_SLOTS];
+	struct list_head key_ring;
+};
+
+static struct async_aes async_spu;
+
+#define AES_MIN_KEY_SIZE	16
+#define AES_MAX_KEY_SIZE	32
+#define AES_BLOCK_SIZE		16
+#define ALIGN_MASK 15
+#define MAX_TRANSFER_SIZE	(16 * 1024)
+
+static void cleanup_requests(struct ablkcipher_request *req,
+		struct async_d_request *a_d_ctx)
+{
+	char *dst_addr;
+	char *aligned_addr;
+
+	if (a_d_ctx->al_data) {
+		aligned_addr = (char *) ALIGN((unsigned long)
+				a_d_ctx->al_data, ALIGN_MASK+1);
+		dst_addr = a_d_ctx->mapped_dst + req->dst->offset;
+
+		if ((unsigned long) dst_addr & ALIGN_MASK) {
+			memcpy(dst_addr, aligned_addr, req->nbytes);
+		}
+		vfree(a_d_ctx->al_data);
+		kunmap(a_d_ctx->mapped_dst);
+		kunmap(a_d_ctx->mapped_src);
+	}
+#if 0
+	if (a_d_ctx->aligned_iv) {
+		memcpy(req->info, a_d_ctx->aligned_iv, MAX_TRANSFER_SIZE);
+		kfree(a_d_ctx->aligned_iv);
+	}
+#endif
+}
+
+static void aes_finish_callback(struct kspu_work_item *kspu_work)
+{
+	struct async_d_request *a_d_ctx = container_of(kspu_work,
+			struct async_d_request, kspu_work);
+	struct ablkcipher_request *ablk_req = ablkcipher_ctx_cast(a_d_ctx);
+
+	a_d_ctx = ablkcipher_request_ctx(ablk_req);
+	cleanup_requests(ablk_req, a_d_ctx);
+
+	pr_debug("Request %p done, memory cleaned. Now calling crypto user\n",
+			kspu_work);
+	local_bh_disable();
+	ablk_req->base.complete(&ablk_req->base, 0);
+	local_bh_enable();
+	return;
+}
+
+static void update_key_on_spu(struct aes_ctx *aes_ctx)
+{
+	struct list_head *tail;
+	struct map_key_spu *entry;
+	struct aes_update_key *aes_update_key;
+	struct kspu_job *work_item;
+
+	tail = async_spu.key_ring.prev;
+	entry = list_entry(tail, struct map_key_spu, list);
+	list_move(tail, &async_spu.key_ring);
+
+	entry->slot_content = aes_ctx;
+	aes_ctx->key_mapping = entry;
+
+	pr_debug("key for %p is not on the SPU. new slot: %d\n",
+			aes_ctx, entry->spu_slot);
+	work_item = kspu_get_rb_slot(aes_ctx->spe_ctx->ctx);
+	work_item->operation = SPU_FUNC_aes_update_key;
+	work_item->in = (unsigned long long) &aes_ctx->key;
+	work_item->in_size = sizeof(aes_ctx->key);
+
+	aes_update_key = &work_item->aes_update_key;
+	aes_update_key->keyid = entry->spu_slot;
+
+	kspu_mark_rb_slot_ready(aes_ctx->spe_ctx->ctx, NULL);
+}
+
+static int prepare_request_mem(struct ablkcipher_request *req,
+		struct async_d_request *a_d_ctx, struct aes_ctx *aes_ctx)
+{
+	char *src_addr, *dst_addr;
+	char *aligned_addr;
+
+	a_d_ctx->mapped_src = kmap(req->src->page);
+	if (!a_d_ctx->mapped_src)
+		goto err;
+
+	a_d_ctx->mapped_dst = kmap(req->dst->page);
+	if (!a_d_ctx->mapped_dst) {
+		goto err_src;
+	}
+
+	src_addr = a_d_ctx->mapped_src + req->src->offset;
+	dst_addr = a_d_ctx->mapped_dst + req->dst->offset;
+
+	if ((unsigned long) src_addr & ALIGN_MASK ||
+			(unsigned long) dst_addr & ALIGN_MASK) {
+		/*
+		 * vmalloc() is somewhat slower than __get_free_page().
+		 * However, this is the slowpath. I expect the user to align
+		 * properly in first place :).
+		 * The reason for vmalloc() is that req->nbytes may be larger
+		 * than one page and I don't want distinguish later where that
+		 * memory come from.
+		 */
+		a_d_ctx->al_data = (char *) vmalloc(req->nbytes + ALIGN_MASK);
+		if (!a_d_ctx->al_data) {
+			goto err_dst;
+		}
+
+		aligned_addr = (char *) ALIGN((unsigned long)a_d_ctx->
+				al_data, ALIGN_MASK+1);
+		pr_debug("Unaligned data replaced with %p (%p)\n",
+				a_d_ctx->al_data, aligned_addr);
+
+		if ((unsigned long) src_addr & ALIGN_MASK) {
+			memcpy(aligned_addr, src_addr, req->nbytes);
+			a_d_ctx->real_src = aligned_addr;
+		}
+
+		if ((unsigned long) dst_addr & ALIGN_MASK) {
+			a_d_ctx->real_dst = aligned_addr;
+		}
+	} else {
+		a_d_ctx->al_data = NULL;
+		a_d_ctx->real_src = src_addr;
+		a_d_ctx->real_dst = dst_addr;
+	}
+#if 0
+	pr_debug("aligned_IV: %p\n", a_d_ctx->aligned_iv);
+
+	if ((unsigned long) req->info & ALIGN_MASK)
+		a_d_ctx->aligned_iv = NULL;
+	else
+		a_d_ctx->aligned_iv = NULL;
+#endif
+	return 0;
+err_dst:
+	kunmap(a_d_ctx->mapped_dst);
+err_src:
+	kunmap(a_d_ctx->mapped_src);
+err:
+	return -ENOMEM;
+
+}
+
+/*
+ * aes_queue_work_items() is called by kspu to queue the work item on the SPU.
+ * kspu ensures atleast one slot when calling. The function may return 0 if
+ * more slots were required but not available. In this case, kspu will call
+ * again with the same work item. The function has to notice that this work
+ * item has been allready started and continue.
+ * Other return values (!=0) will remove the work item from list.
+ */
+static int aes_queue_work_items(struct kspu_work_item *kspu_work)
+{
+	struct async_d_request *a_d_ctx = container_of(kspu_work,
+			struct async_d_request, kspu_work);
+	struct ablkcipher_request *ablk_req = ablkcipher_ctx_cast(a_d_ctx);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(ablk_req);
+	struct aes_ctx *aes_ctx = crypto_ablkcipher_ctx(tfm);
+	struct kspu_job *work_item;
+	struct aes_crypt *aes_crypt;
+	int size_left, ret;
+
+	BUG_ON(ablk_req->nbytes & (AES_BLOCK_SIZE-1));
+
+	if (!a_d_ctx->progress) {
+		if (!aes_ctx->key_mapping || aes_ctx !=
+				aes_ctx->key_mapping->slot_content)
+			update_key_on_spu(aes_ctx);
+
+		else
+			list_move(&aes_ctx->key_mapping->list,
+					&async_spu.key_ring);
+
+		ret = prepare_request_mem(ablk_req, a_d_ctx, aes_ctx);
+		if (ret)
+			return 0;
+	}
+
+	do {
+		size_left = ablk_req->nbytes - a_d_ctx->progress;
+
+		if (!size_left) {
+			a_d_ctx->kspu_work.notify = aes_finish_callback;
+			return 1;
+		}
+
+		work_item = kspu_get_rb_slot(aes_ctx->spe_ctx->ctx);
+		if (!work_item)
+			return 0;
+
+		aes_crypt = &work_item->aes_crypt;
+		work_item->operation = a_d_ctx->crypto_operation;
+		work_item->in = (unsigned long int) a_d_ctx->real_src +
+			a_d_ctx->progress;
+		aes_crypt->out = (unsigned long int) a_d_ctx->real_dst +
+			a_d_ctx->progress;
+
+		if (size_left > MAX_TRANSFER_SIZE) {
+			a_d_ctx->progress += MAX_TRANSFER_SIZE;
+			work_item->in_size = MAX_TRANSFER_SIZE;
+		} else {
+			a_d_ctx->progress += size_left;
+			work_item->in_size = size_left;
+		}
+
+		aes_crypt->iv = 0; /* XXX */
+		aes_crypt->keyid = aes_ctx->key_mapping->spu_slot;
+
+		pr_debug("in: %p, out %p, data_size: %u\n",
+				(void *) work_item->in,
+				(void *) aes_crypt->out,
+				work_item->in_size);
+		pr_debug("iv: %p, key slot: %d\n", (void *) aes_crypt->iv,
+				aes_crypt->keyid);
+
+		kspu_mark_rb_slot_ready(aes_ctx->spe_ctx->ctx,
+				a_d_ctx->progress == ablk_req->nbytes ?
+				kspu_work : NULL);
+	} while (1);
+}
+
+static int enqueue_request(struct ablkcipher_request *req,
+		enum SPU_FUNCTIONS op_type)
+{
+	struct async_d_request *asy_d_ctx = ablkcipher_request_ctx(req);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct kspu_work_item *work = &asy_d_ctx->kspu_work;
+
+	asy_d_ctx->crypto_operation = op_type;
+	asy_d_ctx->progress = 0;
+	work->enqueue = aes_queue_work_items;
+
+	kspu_enqueue_work_item(ctx->spe_ctx->ctx, &asy_d_ctx->kspu_work);
+	return -EINPROGRESS;
+}
+
+/*
+ * AltiVec and not SPU code is because the key may disappear after calling
+ * this func (for example if it is not properly aligned)
+ */
+static int aes_set_key_async(struct crypto_ablkcipher *parent,
+		const u8 *key, unsigned int keylen)
+{
+	struct aes_ctx *ctx = crypto_ablkcipher_ctx(parent);
+	int ret;
+
+	ctx->spe_ctx = &async_spu;
+	ctx->key.len = keylen / 4;
+	ctx->key_mapping = NULL;
+
+	preempt_disable();
+	enable_kernel_altivec();
+	ret = expand_key(key, keylen / 4, &ctx->key.enc[0], &ctx->key.dec[0]);
+	preempt_enable();
+
+	if (ret == -EINVAL)
+		crypto_ablkcipher_set_flags(parent, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+	return ret;
+}
+
+static int aes_encrypt_ecb_async(struct ablkcipher_request *req)
+{
+
+	req->info = NULL;
+	return enqueue_request(req, SPU_FUNC_aes_encrypt_ecb);
+}
+
+static int aes_decrypt_ecb_async(struct ablkcipher_request *req)
+{
+
+	req->info = NULL;
+	return enqueue_request(req, SPU_FUNC_aes_decrypt_ecb);
+}
+#if 0
+static int aes_encrypt_cbc_async(struct ablkcipher_request *req)
+{
+	return enqueue_request(req, SPU_FUNC_aes_encrypt_cbc);
+}
+
+static int aes_decrypt_cbc_async(struct ablkcipher_request *req)
+{
+	return enqueue_request(req, SPU_FUNC_aes_decrypt_cbc);
+}
+#endif
+static int async_d_init(struct crypto_tfm *tfm)
+{
+	tfm->crt_ablkcipher.reqsize = sizeof(struct async_d_request);
+	return 0;
+}
+
+static struct crypto_alg aes_ecb_alg_async = {
+	.cra_name		= "ecb(aes)",
+	.cra_driver_name	= "ecb-aes-spu-async",
+	.cra_priority		= 125,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_alignmask		= 15,
+	.cra_ctxsize		= sizeof(struct aes_ctx),
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(aes_ecb_alg_async.cra_list),
+	.cra_init		= async_d_init,
+	.cra_u	= {
+		.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= 0,
+			.setkey		= aes_set_key_async,
+			.encrypt	= aes_encrypt_ecb_async,
+			.decrypt	= aes_decrypt_ecb_async,
+		}
+	}
+};
+#if 0
+static struct crypto_alg aes_cbc_alg_async = {
+	.cra_name		= "cbc(aes)",
+	.cra_driver_name	= "cbc-aes-spu-async",
+	.cra_priority		= 125,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= AES_BLOCK_SIZE,
+	.cra_alignmask		= 15,
+	.cra_ctxsize		= sizeof(struct aes_ctx),
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(aes_cbc_alg_async.cra_list),
+	.cra_init		= async_d_init,
+	.cra_u	= {
+		.ablkcipher = {
+			.min_keysize	= AES_MIN_KEY_SIZE,
+			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
+			.setkey		= aes_set_key_async,
+			.encrypt	= aes_encrypt_cbc_async,
+			.decrypt	= aes_decrypt_cbc_async,
+		}
+	}
+};
+#endif
+
+static void init_spu_key_mapping(struct async_aes *spe_ctx)
+{
+	unsigned int i;
+
+	INIT_LIST_HEAD(&spe_ctx->key_ring);
+
+	for (i = 0; i < SPU_KEY_SLOTS; i++) {
+		list_add_tail(&spe_ctx->mapping_key_spu[i].list,
+				&spe_ctx->key_ring);
+		spe_ctx->mapping_key_spu[i].spu_slot = i;
+	}
+}
+
+static int init_async_ctx(struct async_aes *spe_ctx)
+{
+	int ret;
+
+	spe_ctx->ctx = kspu_get_kctx();
+	init_spu_key_mapping(spe_ctx);
+
+	ret = crypto_register_alg(&aes_ecb_alg_async);
+	if (ret) {
+		printk(KERN_ERR "crypto_register_alg(ecb) failed: %d\n", ret);
+		goto err_kthread;
+	}
+#if 0
+	ret = crypto_register_alg(&aes_cbc_alg_async);
+	if (ret) {
+		printk(KERN_ERR "crypto_register_alg(cbc) failed: %d\n", ret);
+		goto fail_cbc;
+	}
+#endif
+	return 0;
+#if 0
+fail_cbc:
+	crypto_unregister_alg(&aes_ecb_alg_async);
+#endif
+err_kthread:
+	return ret;
+}
+
+static void deinit_async_ctx(struct async_aes *async_aes)
+{
+
+	crypto_unregister_alg(&aes_ecb_alg_async);
+/*	crypto_unregister_alg(&aes_cbc_alg_async); */
+}
+
+static int __init aes_init(void)
+{
+	unsigned int ret;
+
+	ret = init_async_ctx(&async_spu);
+	if (ret) {
+		printk(KERN_ERR "async_api_init() failed\n");
+		return ret;
+	}
+	return 0;
+}
+
+static void __exit aes_fini(void)
+{
+	deinit_async_ctx(&async_spu);
+}
+
+module_init(aes_init);
+module_exit(aes_fini);
+
+MODULE_DESCRIPTION("AES Cipher Algorithm with SPU support");
+MODULE_AUTHOR("Sebastian Siewior <bigeasy@breakpoint.cc>");
+MODULE_LICENSE("GPL");
--- a/arch/powerpc/platforms/cell/spufs/spu_main.c
+++ b/arch/powerpc/platforms/cell/spufs/spu_main.c
@@ -13,6 +13,14 @@
 
 spu_operation spu_funcs[TOTAL_SPU_FUNCS] __attribute__((aligned(16))) = {
 	[SPU_FUNC_nop] = spu_nop,
+	[SPU_FUNC_aes_setkey] = spu_aes_setkey,
+	[SPU_FUNC_aes_update_key] = spu_aes_update_key,
+	[SPU_FUNC_aes_encrypt_ecb] = spu_aes_encrypt_ecb,
+	[SPU_FUNC_aes_decrypt_ecb] = spu_aes_decrypt_ecb,
+#if 0
+	[SPU_FUNC_aes_encrypt_cbc] = spu_aes_encrypt_cbc,
+	[SPU_FUNC_aes_decrypt_cbc] = spu_aes_decrypt_cbc,
+#endif
 };
 
 struct kspu_buffers kspu_buff[DMA_BUFFERS];
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -78,4 +78,5 @@ config ZCRYPT_MONOLITHIC
 	  that contains all parts of the crypto device driver (ap bus,
 	  request router and all the card drivers).
 
+source "arch/powerpc/platforms/cell/crypto/Kconfig"
 endmenu
--- /dev/null
+++ b/include/asm-powerpc/kspu/aes.h
@@ -0,0 +1,49 @@
+#ifndef  __SPU_AES_H__
+#define  __SPU_AES_H__
+
+#define MAX_AES_ROUNDS 15
+#define MAX_AES_KEYSIZE_INT (MAX_AES_ROUNDS *4)
+#define MAX_AES_KEYSIZE_BYTE (MAX_AES_KEYSIZE_INT *4)
+#define SPU_KEY_SLOTS 5
+
+struct aes_key_struct {
+	unsigned char enc[MAX_AES_KEYSIZE_BYTE] __attribute__((aligned(16)));
+	unsigned char dec[MAX_AES_KEYSIZE_BYTE] __attribute__((aligned(16)));
+	unsigned int len __attribute__((aligned(16)));
+};
+
+struct aes_set_key {
+	/* in */
+	unsigned long long plain __attribute__((aligned(16)));
+	unsigned int len __attribute__((aligned(16)));
+	unsigned int keyid __attribute__((aligned(16)));
+
+	/* out */
+	unsigned long long keys __attribute__((aligned(16)));
+};
+
+struct aes_update_key {
+	/* copy key from ea to ls into a specific slot */
+	unsigned int keyid __attribute__((aligned(16)));
+};
+
+struct aes_crypt {
+	/* in */
+	unsigned int keyid __attribute__((aligned(16)));
+
+	/* out */
+	unsigned long long iv __attribute__((aligned(16))); /* as well as in */
+	unsigned long long out __attribute__((aligned(16)));
+};
+
+/* exported calls */
+#if 0
+int spu_aes_encrypt_cbc(union possible_arguments *pa);
+int spu_aes_decrypt_cbc(union possible_arguments *pa);
+#endif
+
+int spu_aes_setkey(unsigned int cur, unsigned int cur_buf);
+int spu_aes_update_key(unsigned int cur, unsigned int cur_buf);
+int spu_aes_encrypt_ecb(unsigned int cur, unsigned int cur_buf);
+int spu_aes_decrypt_ecb(unsigned int cur, unsigned int cur_buf);
+#endif
--- a/include/asm-powerpc/kspu/merged_code.h
+++ b/include/asm-powerpc/kspu/merged_code.h
@@ -1,6 +1,7 @@
 #ifndef KSPU_MERGED_CODE_H
 #define KSPU_MERGED_CODE_H
 #include <linux/autoconf.h>
+#include <asm/kspu/aes.h>
 
 #define KSPU_LS_SIZE 0x40000
 
@@ -10,18 +11,30 @@
 #define DMA_BUFF_MASK (DMA_BUFFERS-1)
 #define ALL_DMA_BUFFS ((1 << DMA_BUFFERS)-1)
 
-typedef int (*spu_operation)(unsigned int cur);
+#define RB_MASK (RB_SLOTS-1)
+
+typedef int (*spu_operation)(unsigned int cur_job, unsigned int cur_buf);
 
 enum SPU_FUNCTIONS {
+	SPU_FUNC_nop,
+	SPU_FUNC_aes_setkey,
+	SPU_FUNC_aes_update_key,
+	SPU_FUNC_aes_encrypt_ecb,
+	SPU_FUNC_aes_decrypt_ecb,
+	SPU_FUNC_aes_encrypt_cbc,
+	SPU_FUNC_aes_decrypt_cbc,
 
 	TOTAL_SPU_FUNCS,
 };
 
-struct kspu_job {
+struct kspu_job {
 	enum SPU_FUNCTIONS operation __attribute__((aligned(16)));
 	unsigned long long in __attribute__((aligned(16)));
 	unsigned int in_size __attribute__((aligned(16)));
 	union {
+		struct aes_set_key aes_set_key;
+		struct aes_update_key aes_update_key;
+		struct aes_crypt aes_crypt;
 	} __attribute__((aligned(16)));
 };
 
@@ -32,7 +45,7 @@ struct kspu_ring_data {
 
 struct kernel_spu_data {
 	struct kspu_ring_data kspu_ring_data __attribute__((aligned(16)));
-	struct kspu_job work_item[RB_SLOTS] __attribute__((aligned(16)));
+	struct kspu_job work_item[RB_SLOTS] __attribute__((aligned(16)));
 };
 
 #define KERNEL_SPU_DATA_OFFSET (KSPU_LS_SIZE - sizeof(struct kernel_spu_data))

-- 

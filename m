From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: [patch 09/10] spufs: SPU-AES support (kernel side)
Date: Thu, 16 Aug 2007 22:01:14 +0200
Message-ID: <20070816200137.867399000@ml.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc>
Cc: <herbert@gondor.apana.org.au>, <arnd@arndb.de>, <jk@ozlabs.org>,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60608 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbXHPUFz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 16:05:55 -0400
Content-Disposition: inline; filename=aes-spu-async2.diff
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch implements the AES cipher algorithm in ECB & CBC blockmode
which is executed on the SPU using the crypto async interface & kspu.

CBC has one limitiation: The IV is written back in the notification
callback. That means that it is not available for crypto requests that
depend on the previous IV (as well as crypto requests >16 KiB). Herbert Xu
pointer out, that this is currently not the case. For instance:
- IPsec brings its own IV on with every packet. A packet is usually <=
	1500 bytes. The trouble starts with jumbo frames
- EcryptFS changes the IV on page bassis (every enc/dec request is
	PAGE_SIZE long).

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
--- a/arch/powerpc/platforms/cell/Makefile
+++ b/arch/powerpc/platforms/cell/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_SPU_BASE)			+= spu_callback
 					   $(spufs-modular-m) \
 					   $(spu-priv1-y) \
 					   $(spu-manage-y) \
-					   spufs/
+					   spufs/ \
+					   crypto/
 
 obj-$(CONFIG_PCI_MSI)			+= axon_msi.o
--- /dev/null
+++ b/arch/powerpc/platforms/cell/crypto/Makefile
@@ -0,0 +1,6 @@
+#
+# Crypto, arch specific
+#
+CFLAGS_aes_vmx_key.o += -O3  -maltivec
+aes_spu-objs := aes_spu_glue.o aes_vmx_key.o
+obj-$(CONFIG_CRYPTO_AES_SPU) += aes_spu.o
--- /dev/null
+++ b/arch/powerpc/platforms/cell/crypto/aes_spu_glue.c
@@ -0,0 +1,462 @@
+/*
+ * AES interface module for the async crypto API.
+ *
+ * Author: Sebastian Siewior <sebastian@breakpoint.cc>
+ * License: GPLv2
+ */
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
+#include "aes_vmx_key.h"
+
+struct map_key_spu {
+	struct list_head list;
+	unsigned int spu_slot;
+	struct aes_ctx *slot_content;
+};
+
+struct aes_ctx {
+	/* the key used for enc|dec purpose */
+	struct aes_key_struct key __attribute__((aligned(16)));
+	/* identify the slot on the SPU */
+	struct map_key_spu *key_mapping;
+	/* identify the SPU that is used */
+	struct async_aes *spe_ctx;
+};
+
+struct async_d_request {
+	enum SPU_OPERATIONS crypto_operation;
+	 /*
+	  * If src|dst is not properly aligned, we keep here a copy of
+	  * it that is properly aligned.
+	  */
+	struct kspu_work_item kspu_work;
+	unsigned char *al_data;
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
+		if ((unsigned long) dst_addr & ALIGN_MASK)
+			memcpy(dst_addr, aligned_addr, req->nbytes);
+		vfree(a_d_ctx->al_data);
+		kunmap(a_d_ctx->mapped_dst);
+		kunmap(a_d_ctx->mapped_src);
+	}
+
+}
+
+static void aes_finish_callback(struct kspu_work_item *kspu_work,
+		struct kspu_job *kjob)
+{
+	struct async_d_request *a_d_ctx = container_of(kspu_work,
+			struct async_d_request, kspu_work);
+	struct ablkcipher_request *ablk_req = ablkcipher_ctx_cast(a_d_ctx);
+
+	a_d_ctx = ablkcipher_request_ctx(ablk_req);
+	cleanup_requests(ablk_req, a_d_ctx);
+
+	if (ablk_req->info) {
+		struct aes_crypt *aes_crypt = (struct aes_crypt *) kjob;
+
+		memcpy(ablk_req->info, aes_crypt->iv, 16);
+	}
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
+	work_item->operation = SPU_OP_aes_update_key;
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
+
+	a_d_ctx->mapped_src = kmap(req->src->page);
+	if (!a_d_ctx->mapped_src)
+		goto err;
+
+	a_d_ctx->mapped_dst = kmap(req->dst->page);
+	if (!a_d_ctx->mapped_dst)
+		goto err_src;
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
+		a_d_ctx->al_data = vmalloc(req->nbytes);
+		if (!a_d_ctx->al_data)
+			goto err_dst;
+
+		pr_debug("Unaligned data replaced with %p\n",
+				a_d_ctx->al_data);
+
+		if ((unsigned long) src_addr & ALIGN_MASK) {
+			memcpy(a_d_ctx->al_data, src_addr, req->nbytes);
+			a_d_ctx->real_src = a_d_ctx->al_data;
+		}
+
+		if ((unsigned long) dst_addr & ALIGN_MASK)
+			a_d_ctx->real_dst = a_d_ctx->al_data;
+
+	} else {
+		a_d_ctx->al_data = NULL;
+		a_d_ctx->real_src = src_addr;
+		a_d_ctx->real_dst = dst_addr;
+	}
+	return 0;
+err_dst:
+	kunmap(a_d_ctx->mapped_dst);
+err_src:
+	kunmap(a_d_ctx->mapped_src);
+err:
+	return -ENOMEM;
+
+}
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
+	struct aes_ctx *aes_ctx = crypto_ablkcipher_ctx_aligned(tfm);
+	struct kspu_job *work_item;
+	struct aes_crypt *aes_crypt;
+	int size_left;
+	int ret;
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
+		if (!size_left)
+			return 1;
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
+		if (size_left > DMA_MAX_TRANS_SIZE) {
+			a_d_ctx->progress += DMA_MAX_TRANS_SIZE;
+			work_item->in_size = DMA_MAX_TRANS_SIZE;
+		} else {
+			a_d_ctx->progress += size_left;
+			work_item->in_size = size_left;
+		}
+
+		if (ablk_req->info)
+			memcpy(aes_crypt->iv, ablk_req->info, 16);
+
+		aes_crypt->keyid = aes_ctx->key_mapping->spu_slot;
+
+		pr_debug("in: %p, out %p, data_size: %u\n",
+				(void *) work_item->in,
+				(void *) aes_crypt->out,
+				work_item->in_size);
+		pr_debug("key slot: %d, IV from: %p\n", aes_crypt->keyid,
+				ablk_req->info);
+
+		kspu_mark_rb_slot_ready(aes_ctx->spe_ctx->ctx,
+				a_d_ctx->progress == ablk_req->nbytes ?
+				kspu_work : NULL);
+	} while (1);
+}
+
+static int enqueue_request(struct ablkcipher_request *req,
+		enum SPU_OPERATIONS op_type)
+{
+	struct async_d_request *asy_d_ctx = ablkcipher_request_ctx(req);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct aes_ctx *ctx = crypto_ablkcipher_ctx_aligned(tfm);
+	struct kspu_work_item *work = &asy_d_ctx->kspu_work;
+
+	asy_d_ctx->crypto_operation = op_type;
+	asy_d_ctx->progress = 0;
+	work->enqueue = aes_queue_work_items;
+	work->notify = aes_finish_callback;
+
+	return kspu_enqueue_work_item(ctx->spe_ctx->ctx, &asy_d_ctx->kspu_work,
+			KSPU_MUST_BACKLOG);
+}
+
+/*
+ * AltiVec and not SPU code is because the key may disappear after calling
+ * this func (for example if it is not properly aligned)
+ */
+static int aes_set_key_async(struct crypto_ablkcipher *parent,
+		const u8 *key, unsigned int keylen)
+{
+	struct aes_ctx *ctx = crypto_ablkcipher_ctx_aligned(parent);
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
+	req->info = NULL;
+	return enqueue_request(req, SPU_OP_aes_encrypt_ecb);
+}
+
+static int aes_decrypt_ecb_async(struct ablkcipher_request *req)
+{
+	req->info = NULL;
+	return enqueue_request(req, SPU_OP_aes_decrypt_ecb);
+}
+
+static int aes_encrypt_cbc_async(struct ablkcipher_request *req)
+{
+	return enqueue_request(req, SPU_OP_aes_encrypt_cbc);
+}
+
+static int aes_decrypt_cbc_async(struct ablkcipher_request *req)
+{
+	return enqueue_request(req, SPU_OP_aes_decrypt_cbc);
+}
+
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
+
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
+
+	ret = crypto_register_alg(&aes_cbc_alg_async);
+	if (ret) {
+		printk(KERN_ERR "crypto_register_alg(cbc) failed: %d\n", ret);
+		goto fail_cbc;
+	}
+
+	return 0;
+
+fail_cbc:
+	crypto_unregister_alg(&aes_ecb_alg_async);
+
+err_kthread:
+	return ret;
+}
+
+static void deinit_async_ctx(struct async_aes *async_aes)
+{
+
+	crypto_unregister_alg(&aes_ecb_alg_async);
+	crypto_unregister_alg(&aes_cbc_alg_async);
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
+MODULE_AUTHOR("Sebastian Siewior <sebastian@breakpoint.cc>");
+MODULE_LICENSE("GPL");
--- /dev/null
+++ b/arch/powerpc/platforms/cell/crypto/aes_vmx_key.c
@@ -0,0 +1,283 @@
+/*
+ * Key expansion in VMX.
+ * This is a rip of my first AES implementation in VMX. Only key expansion is
+ * required, other parts are left behind.
+ *
+ * Author: Sebastian Siewior (sebastian _at_ breakpoint.cc)
+ * License: GPL v2
+ */
+
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <altivec.h>
+#include "aes_vmx_key.h"
+
+static const vector unsigned char imm_7Fh = {
+	0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x7f,
+	0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x7f, 0x7f
+};
+
+/*
+ * This values are either defined in AES standard or can be
+ * computed.
+ */
+static const unsigned int Rcon[] = {
+	0x00000000, 0x01000000, 0x02000000, 0x04000000, 0x08000000,
+	0x10000000, 0x20000000, 0x40000000, 0x80000000, 0x1b000000,
+	0x36000000
+};
+
+static const vector unsigned char sbox_enc[16] = {
+	{ 0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
+	  0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76 },
+	{ 0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
+	  0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0 },
+	{ 0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
+	  0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15 },
+	{ 0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a,
+	  0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75 },
+	{ 0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0,
+	  0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84 },
+	{ 0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b,
+	  0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf },
+	{ 0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85,
+	  0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8 },
+	{ 0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5,
+	  0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2 },
+	{ 0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17,
+	  0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73 },
+	{ 0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88,
+	  0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb },
+	{ 0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c,
+	  0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79 },
+	{ 0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9,
+	  0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08 },
+	{ 0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6,
+	  0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a },
+	{ 0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e,
+	  0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e },
+	{ 0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94,
+	  0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf },
+	{ 0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
+	  0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16 }
+};
+
+static const vector unsigned char inv_select_0e = {
+	0x00, 0x01, 0x02, 0x03,
+	0x04, 0x05, 0x06, 0x07,
+	0x08, 0x09, 0x0a, 0x0b,
+	0x0c, 0x0d, 0x0e, 0x0f
+};
+
+static const vector unsigned char inv_select_0b = {
+	0x01, 0x02, 0x03, 0x00,
+	0x05, 0x06, 0x07, 0x04,
+	0x09, 0x0a, 0x0b, 0x08,
+	0x0d, 0x0e, 0x0f, 0x0c
+};
+
+static const vector unsigned char inv_select_0d = {
+	0x02, 0x03, 0x00, 0x01,
+	0x06, 0x07, 0x04, 0x05,
+	0x0a, 0x0b, 0x08, 0x09,
+	0x0e, 0x0f, 0x0c, 0x0d
+};
+
+static const vector unsigned char inv_select_09 = {
+	0x03, 0x00, 0x01, 0x02,
+	0x07, 0x04, 0x05, 0x06,
+	0x0b, 0x08, 0x09, 0x0a,
+	0x0f, 0x0c, 0x0d, 0x0e
+};
+
+static vector unsigned char ByteSub(vector unsigned char state)
+{
+	/* line of the s-box */
+	vector unsigned char line_01, line_23, line_45, line_67,
+		   line_89, line_AB, line_CD, line_EF;
+	/* selector */
+	vector unsigned char sel1, sel2, sel7;
+	/* correct lines */
+	vector unsigned char cor_0123, cor_4567, cor_89AB, cor_CDEF,
+		cor_0to7, cor_8toF;
+	vector unsigned char ret_state;
+	vector unsigned char state_shift2, state_shift1;
+
+	line_01 = vec_perm(sbox_enc[0], sbox_enc[1], state);
+	line_23 = vec_perm(sbox_enc[2], sbox_enc[3], state);
+	line_45 = vec_perm(sbox_enc[4], sbox_enc[5], state);
+	line_67 = vec_perm(sbox_enc[6], sbox_enc[7], state);
+	line_89 = vec_perm(sbox_enc[8], sbox_enc[9], state);
+	line_AB = vec_perm(sbox_enc[10], sbox_enc[11], state);
+	line_CD = vec_perm(sbox_enc[12], sbox_enc[13], state);
+	line_EF = vec_perm(sbox_enc[14], sbox_enc[15], state);
+
+	state_shift2 = vec_vslb(state, vec_splat_u8(2));
+	sel2 = (typeof (sel2))vec_vcmpgtub(state_shift2, imm_7Fh);
+	cor_0123 = vec_sel(line_01, line_23, sel2);
+	cor_4567 = vec_sel(line_45, line_67, sel2);
+	cor_89AB = vec_sel(line_89, line_AB, sel2);
+	cor_CDEF = vec_sel(line_CD, line_EF, sel2);
+
+	state_shift1 = vec_vslb(state, vec_splat_u8(1));
+	sel1 = (typeof (sel1))vec_vcmpgtub(state_shift1, imm_7Fh);
+	cor_0to7 = vec_sel(cor_0123, cor_4567, sel1);
+	cor_8toF = vec_sel(cor_89AB, cor_CDEF, sel1);
+
+	sel7 = (typeof (sel7))vec_vcmpgtub(state, imm_7Fh);
+	ret_state = vec_sel(cor_0to7, cor_8toF, sel7);
+
+	return ret_state;
+}
+
+static vector unsigned char InvMixColumn(vector unsigned char state)
+{
+	vector unsigned char op0, op1, op2, op3, op4, op5;
+	vector unsigned char mul_0e, mul_09, mul_0d, mul_0b;
+	vector unsigned char ret;
+	vector unsigned char imm_00h, imm_01h;
+	vector unsigned char need_add;
+	vector unsigned char shifted_vec, modul;
+	vector unsigned char toadd;
+	vector unsigned char mul_2, mul_4, mul_8;
+	vector unsigned char mul_2_4;
+
+	/* compute 0e, 0b, 0d, 09 in GF */
+	imm_00h = vec_splat_u8(0x00);
+	imm_01h = vec_splat_u8(0x01);
+
+	/* modul = 0x1b */
+	modul = vec_splat( vec_lvsr(0, (unsigned char *) 0), 0x0b);
+
+	need_add = (vector unsigned char)vec_vcmpgtub(state, imm_7Fh);
+	shifted_vec = vec_vslb(state, imm_01h);
+	toadd = vec_sel(imm_00h, modul, need_add);
+	mul_2 = vec_xor(toadd, shifted_vec);
+
+	need_add = (vector unsigned char)vec_vcmpgtub(mul_2, imm_7Fh);
+	shifted_vec = vec_vslb(mul_2, imm_01h);
+	toadd = vec_sel(imm_00h, modul, need_add);
+	mul_4 = vec_xor(toadd, shifted_vec);
+
+	need_add = (vector unsigned char)vec_vcmpgtub(mul_4, imm_7Fh);
+	shifted_vec = vec_vslb(mul_4, imm_01h);
+	toadd = vec_sel(imm_00h, modul, need_add);
+	mul_8 = vec_xor(toadd, shifted_vec);
+
+	mul_2_4 = vec_xor(mul_2, mul_4);
+	/* 09 = 8 * 1 */
+	mul_09 = vec_xor(mul_8, state);
+
+	/* 0e = 2 * 4 * 8 */
+	mul_0e = vec_xor(mul_2_4, mul_8);
+
+	/* 0b = 2 * 8 * 1 */
+	mul_0b = vec_xor(mul_2, mul_09);
+
+	/* 0d = 4 * 8 * 1 */
+	mul_0d = vec_xor(mul_4, mul_09);
+
+	/* prepare vectors for add */
+
+	op0 = vec_perm(mul_0e, mul_0e, inv_select_0e);
+	op1 = vec_perm(mul_0b, mul_0b, inv_select_0b);
+	op2 = vec_perm(mul_0d, mul_0d, inv_select_0d);
+	op3 = vec_perm(mul_09, mul_09, inv_select_09);
+
+	op4 = vec_xor(op0, op1);
+	op5 = vec_xor(op2, op3);
+	ret = vec_xor(op4, op5);
+	return ret;
+}
+
+static unsigned int SubWord(unsigned int in)
+{
+	unsigned char buff[16] __attribute__((aligned(16)));
+	vector unsigned char vec_buf;
+
+	buff[0] =  in >> 24;
+	buff[1] = (in >> 16) & 0xff;
+	buff[2] = (in >>  8) & 0xff;
+	buff[3] = in & 0xff;
+
+	vec_buf = vec_ld(0, buff);
+	vec_buf = ByteSub(vec_buf);
+	vec_st(vec_buf, 0, buff);
+	return buff[0] << 24 | buff[1] << 16 | buff[2] << 8 | buff[3];
+}
+
+static unsigned int  RotWord(unsigned int word)
+{
+	return (word << 8 | word >> 24);
+}
+
+int expand_key(const unsigned char *key, unsigned int keylen,
+		unsigned char exp_enc_key[15 *4*4],
+		unsigned char exp_dec_key[15*4*4])
+{
+	unsigned int tmp;
+	unsigned int i;
+	unsigned int rounds;
+	unsigned int expanded_key[15 *4] __attribute__((aligned(16)));
+	vector unsigned char expanded_dec_key[15];
+	vector unsigned char mixed_key;
+	vector unsigned char *cur_key;
+
+	switch (keylen) {
+	case 4:
+		rounds = 10;
+		break;
+
+	case 6:
+		rounds = 12;
+		break;
+
+	case 8:
+		rounds = 14;
+		break;
+
+	default:
+		/* wrong key size */
+		return -EINVAL;
+	}
+
+	memcpy(expanded_key, key, keylen*4);
+
+	i = keylen;
+
+	/* setup enc key */
+
+	for (; i < 4 * (rounds+1); i++) {
+		tmp = expanded_key[i-1];
+
+		if (!(i % keylen)) {
+			tmp = RotWord(tmp);
+			tmp = SubWord(tmp);
+			tmp ^= Rcon[i / keylen ];
+		} else if (keylen > 6 &&  (i % keylen == 4))
+				tmp = SubWord(tmp);
+
+		expanded_key[i] = expanded_key[i-keylen] ^ tmp;
+	}
+
+	memcpy(exp_enc_key, expanded_key, 15*4*4);
+
+	/* setup dec key: the key is turned arround and prepared for the
+	 * "alternative decryption" mode
+	 */
+
+	cur_key = (vector unsigned char *) expanded_key;
+
+	memcpy(&expanded_dec_key[rounds],      &expanded_key[0], 4*4);
+	memcpy(&expanded_dec_key[0], &expanded_key[rounds *4], 4*4);
+
+	cur_key++;
+	for (i = (rounds-1); i > 0; i--) {
+
+		mixed_key = InvMixColumn(*cur_key++);
+		expanded_dec_key[i] = mixed_key;
+	}
+
+	memcpy(exp_dec_key, expanded_dec_key, 15*4*4);
+	return 0;
+}
--- /dev/null
+++ b/arch/powerpc/platforms/cell/crypto/aes_vmx_key.h
@@ -0,0 +1,7 @@
+#ifndef __aes_vmx_addon_h__
+#define __aes_vmx_addon_h__
+
+int expand_key(const unsigned char *key, unsigned int keylen,
+		unsigned char exp_enc_key[15*4*4],
+		unsigned char exp_dec_key[15*4*4]);
+#endif
--- a/arch/powerpc/platforms/cell/spufs/Makefile
+++ b/arch/powerpc/platforms/cell/spufs/Makefile
@@ -11,7 +11,7 @@ SPU_CC		:= $(SPU_CROSS)gcc
 SPU_AS		:= $(SPU_CROSS)gcc
 SPU_LD		:= $(SPU_CROSS)ld
 SPU_OBJCOPY	:= $(SPU_CROSS)objcopy
-SPU_CFLAGS	:= -O2 -Wall -I$(srctree)/include \
+SPU_CFLAGS	:= -O3 -Wall -I$(srctree)/include \
 		   -I$(objtree)/include2 -D__KERNEL__ -ffreestanding
 SPU_AFLAGS	:= -c -D__ASSEMBLY__ -I$(srctree)/include \
 		   -I$(objtree)/include2 -D__KERNEL__
@@ -23,6 +23,7 @@ clean-files := spu_save_dump.h spu_resto
 $(obj)/kspu.o: $(obj)/spu_kspu_dump.h
 
 spu_kspu_code_obj-y += $(obj)/spu_main.o $(obj)/spu_runtime.o
+spu_kspu_code_obj-$(CONFIG_CRYPTO_AES_SPU) += $(obj)/spu_aes.o
 spu_kspu_code_obj-y += $(spu_kspu_code_obj-m)
 
 $(obj)/spu_kspu: $(spu_kspu_code_obj-y)
--- /dev/null
+++ b/arch/powerpc/platforms/cell/spufs/spu_aes.c
@@ -0,0 +1,677 @@
+/*
+ * AES implementation with spu support.
+ * v.03
+ *
+ * Author:
+ *			Sebastian Siewior (sebastian _at_ breakpoint.cc)
+ *			Arnd Bergmann (arnd _at_ arndb.de)
+ *
+ * License: GPL v2
+ *
+ * Code based on ideas from "Effincient Galois Field Arithmetic on SIMD
+ * Architectures" by Raghav Bhaskar, Prapdeep K. Dubey, Vijay Kumar, Atri Rudra
+ * and Animesh Sharma.
+ *
+ * This implementation makes use of spu and asumes therefore big endian.
+ * Tables for MixColumn() and InvMixColumn() are adjusted in order to omit
+ * ShiftRow in all but last round.
+ */
+#include <stddef.h>
+#include <spu_intrinsics.h>
+#include <spu_mfcio.h>
+
+#include <asm/kspu/aes.h>
+#include <asm/kspu/merged_code.h>
+#include "spu_runtime.h"
+
+#define BUG() ;
+/*
+ * This values are either defined in AES standard or can be
+ * computed.
+ */
+static const vector unsigned char sbox_enc[16] = {
+	{ 0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
+	  0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76 },
+	{ 0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
+	  0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0 },
+	{ 0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
+	  0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15 },
+	{ 0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a,
+	  0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75 },
+	{ 0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0,
+	  0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84 },
+	{ 0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b,
+	  0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf },
+	{ 0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85,
+	  0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8 },
+	{ 0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5,
+	  0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2 },
+	{ 0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17,
+	  0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73 },
+	{ 0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88,
+	  0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb },
+	{ 0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c,
+	  0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79 },
+	{ 0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9,
+	  0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08 },
+	{ 0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6,
+	  0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a },
+	{ 0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e,
+	  0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e },
+	{ 0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94,
+	  0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf },
+	{ 0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
+	  0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16 }
+};
+
+static const vector unsigned char shift_round = {
+	0x00, 0x05, 0x0a, 0x0f,
+	0x04, 0x09, 0x0e, 0x03,
+	0x08, 0x0d, 0x02, 0x07,
+	0x0c, 0x01, 0x06, 0x0b
+};
+
+static const vector unsigned char pre_xor_s0 = {
+	0x10, 0x00, 0x00, 0x10,
+	0x14, 0x04, 0x04, 0x14,
+	0x18, 0x08, 0x08, 0x18,
+	0x1c, 0x0c, 0x0c, 0x1c
+};
+
+static const vector unsigned char pre_xor_s1 = {
+	0x15, 0x15, 0x05, 0x00,
+	0x19, 0x19, 0x09, 0x04,
+	0x1d, 0x1d, 0x0d, 0x08,
+	0x11, 0x11, 0x01, 0x0c
+};
+
+static const vector unsigned char pre_xor_s2 = {
+	0x05, 0x1a, 0x1a, 0x05,
+	0x09, 0x1e, 0x1e, 0x09,
+	0x0d, 0x12, 0x12, 0x0d,
+	0x01, 0x16, 0x16, 0x01
+};
+
+static const vector unsigned char pre_xor_s3 = {
+	0x0a, 0x0a, 0x1f, 0x0a,
+	0x0e, 0x0e, 0x13, 0x0e,
+	0x02, 0x02, 0x17, 0x02,
+	0x06, 0x06, 0x1b, 0x06
+};
+
+static const vector unsigned char pre_xor_s4 = {
+	0x0f, 0x0f, 0x0f, 0x1f,
+	0x03, 0x03, 0x03, 0x13,
+	0x07, 0x07, 0x07, 0x17,
+	0x0b, 0x0b, 0x0b, 0x1b
+};
+
+static const vector unsigned char sbox_dec[16] = {
+	{ 0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38,
+	  0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb },
+	{ 0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87,
+	  0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb },
+	{ 0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d,
+	  0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e },
+	{ 0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2,
+	  0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25 },
+	{ 0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16,
+	  0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92 },
+	{ 0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda,
+	  0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84 },
+	{ 0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a,
+	  0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06 },
+	{ 0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02,
+	  0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b },
+	{ 0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea,
+	  0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73 },
+	{ 0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85,
+	  0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e },
+	{ 0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89,
+	  0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b },
+	{ 0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20,
+	  0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4 },
+	{ 0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31,
+	  0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f },
+	{ 0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d,
+	  0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef },
+	{ 0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0,
+	  0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61 },
+	{ 0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26,
+	  0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d }
+};
+
+static const vector unsigned char inv_shift_round = {
+	0x00, 0x0d, 0x0a, 0x07,
+	0x04, 0x01, 0x0e, 0x0B,
+	0x08, 0x05, 0x02, 0x0f,
+	0x0c, 0x09, 0x06, 0x03
+};
+
+static const vector unsigned char inv_select_0e_shifted = {
+	0x00, 0x0d, 0x0a, 0x07,
+	0x04, 0x01, 0x0e, 0x0B,
+	0x08, 0x05, 0x02, 0x0f,
+	0x0c, 0x09, 0x06, 0x03
+};
+
+static const vector unsigned char inv_select_0b_shifted = {
+	0x0d, 0x0a, 0x07, 0x00,
+	0x01, 0x0e, 0x0b, 0x04,
+	0x05, 0x02, 0x0f, 0x08,
+	0x09, 0x06, 0x03, 0x0c
+};
+
+static const vector unsigned char inv_select_0d_shifted = {
+	0x0a, 0x07, 0x00, 0x0d,
+	0x0e, 0x0b, 0x04, 0x01,
+	0x02, 0x0f, 0x08, 0x05,
+	0x06, 0x03, 0x0c, 0x09
+};
+
+static const vector unsigned char inv_select_09_shifted = {
+	0x07, 0x00, 0x0d, 0x0a,
+	0x0b, 0x04, 0x01, 0x0e,
+	0x0f, 0x08, 0x05, 0x02,
+	0x03, 0x0c, 0x09, 0x06
+};
+
+static const vector unsigned char inv_select_0e_norm = {
+	0x00, 0x01, 0x02, 0x03,
+	0x04, 0x05, 0x06, 0x07,
+	0x08, 0x09, 0x0a, 0x0b,
+	0x0c, 0x0d, 0x0e, 0x0f
+};
+
+static const vector unsigned char inv_select_0b_norm = {
+	0x01, 0x02, 0x03, 0x00,
+	0x05, 0x06, 0x07, 0x04,
+	0x09, 0x0a, 0x0b, 0x08,
+	0x0d, 0x0e, 0x0f, 0x0c
+};
+
+static const vector unsigned char inv_select_0d_norm = {
+	0x02, 0x03, 0x00, 0x01,
+	0x06, 0x07, 0x04, 0x05,
+	0x0a, 0x0b, 0x08, 0x09,
+	0x0e, 0x0f, 0x0c, 0x0d
+};
+
+static const vector unsigned char inv_select_09_norm = {
+	0x03, 0x00, 0x01, 0x02,
+	0x07, 0x04, 0x05, 0x06,
+	0x0b, 0x08, 0x09, 0x0a,
+	0x0f, 0x0c, 0x0d, 0x0e
+};
+/* encryption code */
+
+static vector unsigned char ByteSub(vector unsigned char state)
+{
+	/* line of the s-box */
+	vector unsigned char line_01, line_23, line_45, line_67,
+		   line_89, line_AB, line_CD, line_EF;
+	/* selector */
+	vector unsigned char sel1, sel2, sel7;
+	/* correct lines */
+	vector unsigned char cor_0123, cor_4567, cor_89AB, cor_CDEF,
+		cor_0to7, cor_8toF;
+	vector unsigned char ret_state, lower_state;
+	vector unsigned char state_shift2, state_shift1;
+
+	lower_state = spu_and(state, (unsigned char) 0x1f);
+	line_01 = spu_shuffle(sbox_enc[0], sbox_enc[1], lower_state);
+	line_23 = spu_shuffle(sbox_enc[2], sbox_enc[3], lower_state);
+	line_45 = spu_shuffle(sbox_enc[4], sbox_enc[5], lower_state);
+	line_67 = spu_shuffle(sbox_enc[6], sbox_enc[7], lower_state);
+	line_89 = spu_shuffle(sbox_enc[8], sbox_enc[9], lower_state);
+	line_AB = spu_shuffle(sbox_enc[10], sbox_enc[11], lower_state);
+	line_CD = spu_shuffle(sbox_enc[12], sbox_enc[13], lower_state);
+	line_EF = spu_shuffle(sbox_enc[14], sbox_enc[15], lower_state);
+
+	state_shift2 = spu_and(state, 0x3f);
+	sel2 = spu_cmpgt(state_shift2, 0x1f);
+	cor_0123 = spu_sel(line_01, line_23, sel2);
+	cor_4567 = spu_sel(line_45, line_67, sel2);
+	cor_89AB = spu_sel(line_89, line_AB, sel2);
+	cor_CDEF = spu_sel(line_CD, line_EF, sel2);
+
+	state_shift1 = spu_slqw(state, 1);
+	sel1 = spu_cmpgt(state_shift1, 0x7f);
+	cor_0to7 = spu_sel(cor_0123, cor_4567, sel1);
+	cor_8toF = spu_sel(cor_89AB, cor_CDEF, sel1);
+
+	sel7 = spu_cmpgt(state, 0x7f);
+	ret_state = spu_sel(cor_0to7, cor_8toF, sel7);
+
+	return ret_state;
+}
+
+static vector unsigned char ShiftRow(vector unsigned char state)
+{
+	return spu_shuffle(state, state, shift_round);
+}
+
+static vector unsigned char MixColumn(vector unsigned char state)
+{
+	vector unsigned char imm_00h;
+	vector unsigned char need_add, lower_state;
+	vector unsigned char shifted_vec, modul;
+	vector unsigned char toadd, xtimed;
+	vector unsigned char op1, op2, op3, op4, op5;
+	vector unsigned char xor_12, xor_34, xor_1234, ret;
+
+	imm_00h = spu_splats((unsigned char) 0x00);
+	modul = spu_splats((unsigned char) 0x1b);
+
+	need_add = (vector unsigned char)spu_cmpgt(state, 0x7f);
+	lower_state = spu_and(state, 0x7f);
+	shifted_vec = spu_slqw(lower_state, 0x01);
+	toadd = spu_sel(imm_00h, modul, need_add);
+
+	xtimed = spu_xor(toadd, shifted_vec);
+
+	op1 = spu_shuffle(state, xtimed, pre_xor_s0);
+	op2 = spu_shuffle(state, xtimed, pre_xor_s1);
+	op3 = spu_shuffle(state, xtimed, pre_xor_s2);
+	op4 = spu_shuffle(state, xtimed, pre_xor_s3);
+	op5 = spu_shuffle(state, xtimed, pre_xor_s4);
+
+	xor_12 = spu_xor(op1, op2);
+	xor_34 = spu_xor(op3, op4);
+	xor_1234 = spu_xor(xor_12, xor_34);
+	ret = spu_xor(xor_1234, op5);
+
+	return ret;
+}
+
+static vector unsigned char AddRoundKey(vector unsigned char state,
+		vector unsigned char key)
+{
+	return spu_xor(state, key);
+}
+
+static vector unsigned char normalRound(vector unsigned char state,
+		vector unsigned char key)
+{
+	vector unsigned char pstate;
+
+	pstate = ByteSub(state);
+	pstate = MixColumn(pstate);
+	pstate = AddRoundKey(pstate, key);
+	return pstate;
+}
+
+static vector unsigned char finalRound(vector unsigned char state,
+		vector unsigned char key)
+{
+	vector unsigned char pstate;
+
+	pstate = ByteSub(state);
+	pstate = ShiftRow(pstate);
+	pstate = AddRoundKey(pstate, key);
+	return pstate;
+}
+
+static vector unsigned char aes_encrypt_block(vector unsigned char in,
+		const vector unsigned char *key, unsigned char key_len)
+{
+	unsigned char i;
+	vector unsigned char pstate;
+
+	pstate = spu_xor(in, *key++);
+	switch (key_len) {
+	case 8: /* 14 rounds */
+		pstate = normalRound(pstate, *key++);
+		pstate = normalRound(pstate, *key++);
+
+	case 6: /* 12 rounds */
+		pstate = normalRound(pstate, *key++);
+		pstate = normalRound(pstate, *key++);
+
+	case 4: /* 10 rounds */
+		for (i = 0; i < 9; i++)
+			pstate = normalRound(pstate, *key++);
+
+		break;
+	default:
+		/* unsupported */
+		BUG();
+	}
+
+	pstate = finalRound(pstate, *key);
+	return pstate;
+}
+
+static int aes_encrypt_spu_block_char(unsigned char *buffer,
+		const unsigned char *kp, unsigned int key_len)
+{
+	vector unsigned char pstate;
+
+	pstate = (*((vector unsigned char *)(buffer)));
+	pstate = aes_encrypt_block(pstate, (const vector unsigned char*) kp,
+			key_len);
+
+	*((vec_uchar16 *)(buffer)) = pstate;
+	return 0;
+}
+
+/* decryption code, alternative version */
+
+static vector unsigned char InvByteSub(vector unsigned char state)
+{
+	/* line of the s-box */
+	vector unsigned char line_01, line_23, line_45, line_67,
+		   line_89, line_AB, line_CD, line_EF;
+	/* selector */
+	vector unsigned char sel1, sel2, sel7;
+	/* correct lines */
+	vector unsigned char cor_0123, cor_4567, cor_89AB, cor_CDEF,
+		cor_0to7, cor_8toF;
+	vector unsigned char ret_state, lower_state;
+	vector unsigned char state_shift2, state_shift1;
+
+	lower_state = spu_and(state, 0x1f);
+	line_01 = spu_shuffle(sbox_dec[0], sbox_dec[1], lower_state);
+	line_23 = spu_shuffle(sbox_dec[2], sbox_dec[3], lower_state);
+	line_45 = spu_shuffle(sbox_dec[4], sbox_dec[5], lower_state);
+	line_67 = spu_shuffle(sbox_dec[6], sbox_dec[7], lower_state);
+	line_89 = spu_shuffle(sbox_dec[8], sbox_dec[9], lower_state);
+	line_AB = spu_shuffle(sbox_dec[10], sbox_dec[11], lower_state);
+	line_CD = spu_shuffle(sbox_dec[12], sbox_dec[13], lower_state);
+	line_EF = spu_shuffle(sbox_dec[14], sbox_dec[15], lower_state);
+
+	state_shift2 = spu_and(state, 0x3f);
+	sel2 = spu_cmpgt(state_shift2, 0x1f);
+	cor_0123 = spu_sel(line_01, line_23, sel2);
+	cor_4567 = spu_sel(line_45, line_67, sel2);
+	cor_89AB = spu_sel(line_89, line_AB, sel2);
+	cor_CDEF = spu_sel(line_CD, line_EF, sel2);
+
+	state_shift1 = spu_slqw(state, 1);
+	sel1 = spu_cmpgt(state_shift1, 0x7f);
+	cor_0to7 = spu_sel(cor_0123, cor_4567, sel1);
+	cor_8toF = spu_sel(cor_89AB, cor_CDEF, sel1);
+
+	sel7 = spu_cmpgt(state, 0x7f);
+	ret_state = spu_sel(cor_0to7, cor_8toF, sel7);
+
+	return ret_state;
+}
+
+static vector unsigned char InvShiftRow(vector unsigned char state)
+{
+
+	return spu_shuffle(state, state, inv_shift_round);
+}
+
+static vector unsigned char InvMixColumn(vector unsigned char state)
+{
+	vector unsigned char op0, op1, op2, op3, op4, op5;
+	vector unsigned char mul_0e, mul_09, mul_0d, mul_0b;
+	vector unsigned char ret;
+	vector unsigned char imm_00h;
+	vector unsigned char need_add, statef_shift;
+	vector unsigned char shifted_vec, modul;
+	vector unsigned char toadd;
+	vector unsigned char mul_2, mul_4, mul_8;
+	vector unsigned char mul_2_4;
+
+	/* compute 0e, 0b, 0d, 09 in GF */
+	imm_00h = spu_splats((unsigned char) 0x00);
+	modul = spu_splats((unsigned char) 0x1b);
+
+	need_add = (vector unsigned char)spu_cmpgt(state, 0x7f);
+	toadd = spu_sel(imm_00h, modul, need_add);
+	statef_shift = spu_and(state, 0x7f);
+	shifted_vec = spu_slqw(statef_shift, 0x01);
+	mul_2 = spu_xor(toadd, shifted_vec);
+
+	need_add = (vector unsigned char)spu_cmpgt(mul_2, 0x7f);
+	toadd = spu_sel(imm_00h, modul, need_add);
+	statef_shift = spu_and(mul_2, 0x7f);
+	shifted_vec = spu_slqw(statef_shift, 0x01);
+	mul_4 = spu_xor(toadd, shifted_vec);
+
+	need_add = (vector unsigned char)spu_cmpgt(mul_4, 0x7f);
+	statef_shift = spu_and(mul_4, 0x7f);
+	shifted_vec = spu_slqw(statef_shift, 0x01);
+	toadd = spu_sel(imm_00h, modul, need_add);
+	mul_8 = spu_xor(toadd, shifted_vec);
+
+	mul_2_4 = spu_xor(mul_2, mul_4);
+	/* 09 = 8 * 1 */
+	mul_09 = spu_xor(mul_8, state);
+
+	/* 0e = 2 * 4 * 8 */
+	mul_0e = spu_xor(mul_2_4, mul_8);
+
+	/* 0b = 2 * 8 * 1 */
+	mul_0b = spu_xor(mul_2, mul_09);
+
+	/* 0d = 4 * 8 * 1 */
+	mul_0d = spu_xor(mul_4, mul_09);
+
+	/* prepare vectors for add */
+	op0 = spu_shuffle(mul_0e, mul_0e, inv_select_0e_shifted);
+	op1 = spu_shuffle(mul_0b, mul_0b, inv_select_0b_shifted);
+	op2 = spu_shuffle(mul_0d, mul_0d, inv_select_0d_shifted);
+	op3 = spu_shuffle(mul_09, mul_09, inv_select_09_shifted);
+
+	op4 = spu_xor(op0, op1);
+	op5 = spu_xor(op2, op3);
+	ret = spu_xor(op4, op5);
+	return ret;
+}
+
+static vector unsigned char InvNormalRound(vector unsigned char state,
+		vector unsigned char key)
+{
+	vector unsigned char pstate;
+
+	pstate = InvByteSub(state);
+	pstate = InvMixColumn(pstate);
+	pstate = AddRoundKey(pstate, key);
+	return pstate;
+}
+
+static vector unsigned char InvfinalRound(vector unsigned char state,
+		vector unsigned char key)
+{
+	vector unsigned char pstate;
+
+	pstate = InvByteSub(state);
+	pstate = InvShiftRow(pstate);
+	pstate = AddRoundKey(pstate, key);
+	return pstate;
+}
+
+
+static vector unsigned char aes_decrypt_block(vector unsigned char in,
+		const vector unsigned char *key, unsigned int key_len)
+{
+	vector unsigned char pstate;
+	unsigned int i;
+
+	pstate = spu_xor(in, *key++);
+
+	switch (key_len) {
+	case 8: /* 14 rounds */
+		pstate = InvNormalRound(pstate, *key++);
+		pstate = InvNormalRound(pstate, *key++);
+
+	case 6: /* 12 rounds */
+		pstate = InvNormalRound(pstate, *key++);
+		pstate = InvNormalRound(pstate, *key++);
+
+	case 4: /* 10 rounds */
+		for (i = 0; i < 9; i++)
+			pstate = InvNormalRound(pstate, *key++);
+
+		break;
+	default:
+		BUG();
+	}
+
+	pstate = InvfinalRound(pstate, *key);
+	return pstate;
+}
+
+static int aes_decrypt_block_char(unsigned char *buffer,
+		const unsigned char *kp, unsigned int key_len)
+{
+	vector unsigned char pstate;
+
+	pstate = (*((vector unsigned char *)(buffer)));
+	pstate = aes_decrypt_block(pstate, (const vector unsigned char*) kp,
+			key_len);
+	*((vec_uchar16 *)(buffer)) = pstate;
+	return 0;
+}
+
+static int aes_encrypt_ecb(unsigned char *buffer,
+		const unsigned char *kp, unsigned int key_len, unsigned int len)
+{
+	unsigned int left = len;
+
+	while (left >= 16) {
+		aes_encrypt_spu_block_char(buffer, kp, key_len);
+		left -= 16;
+		buffer += 16;
+	}
+
+	return len;
+}
+
+static int aes_decrypt_ecb(unsigned char *buffer,
+		const unsigned char *kp, unsigned int key_len, unsigned int len)
+{
+	unsigned int left = len;
+
+	while (left >= 16) {
+		aes_decrypt_block_char(buffer, kp, key_len);
+		left -= 16;
+		buffer += 16;
+	}
+	return len;
+}
+
+static int  aes_encrypt_cbc(unsigned char *buffer,
+		const unsigned char *kp, unsigned int key_len, unsigned int len,
+		unsigned char *iv_)
+{
+	unsigned int i;
+	vector unsigned char iv, input;
+
+	iv = (*((vector unsigned char *)(iv_)));
+	for (i = 0; i < len; i += 16) {
+		input = (*((vector unsigned char *)(buffer)));
+		input = spu_xor(input, iv);
+
+		iv = aes_encrypt_block(input, (const vector unsigned char*) kp,
+				key_len);
+
+		*((vec_uchar16 *)(buffer)) = iv;
+
+		buffer += 16;
+	}
+
+	*((vec_uchar16 *)(iv_)) = iv;
+	return len;
+}
+
+static int aes_decrypt_cbc(unsigned char *buffer,
+		const unsigned char *kp, unsigned int key_len, unsigned int len,
+		unsigned char *iv_)
+{
+	unsigned int i;
+	vector unsigned char iv, input, vret, decrypted;
+
+	iv = (*((vector unsigned char *)(iv_)));
+	for (i = 0; i < len; i += 16) {
+
+		input = (*((vector unsigned char *)(buffer)));
+		vret = aes_decrypt_block(input,
+				(const vector unsigned char*) kp, key_len);
+
+		decrypted = spu_xor(vret, iv);
+		iv = input;
+
+		*((vec_uchar16 *)(buffer)) = decrypted;
+
+		buffer += 16;
+	}
+
+	*((vec_uchar16 *)(iv_)) = iv;
+	return len;
+}
+
+static struct aes_key_struct keys[SPU_KEY_SLOTS];
+
+void spu_aes_update_key(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num)
+{
+	struct aes_update_key *aes_update_key = &kjob->aes_update_key;
+
+	memcpy_aligned(&keys[aes_update_key->keyid], buffer,
+			sizeof(struct aes_key_struct));
+}
+
+void spu_aes_encrypt_ecb(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num)
+{
+	struct aes_crypt *aes_crypt = &kjob->aes_crypt;
+	unsigned int cur_key;
+	unsigned long data_len;
+
+	data_len = kjob->in_size;
+	cur_key = aes_crypt->keyid;
+	aes_encrypt_ecb(buffer, keys[cur_key].enc, keys[cur_key].len, data_len);
+
+	init_put_data(buffer, aes_crypt->out, data_len, buf_num);
+}
+
+void spu_aes_decrypt_ecb(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num)
+{
+	struct aes_crypt *aes_crypt = &kjob->aes_crypt;
+	unsigned int cur_key;
+	unsigned long data_len;
+
+	data_len = kjob->in_size;
+	cur_key = aes_crypt->keyid;
+	aes_decrypt_ecb(buffer, keys[cur_key].dec, keys[cur_key].len, data_len);
+
+	init_put_data(buffer, aes_crypt->out, data_len, buf_num);
+}
+
+void spu_aes_encrypt_cbc(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num)
+{
+	struct aes_crypt *aes_crypt = &kjob->aes_crypt;
+	unsigned int cur_key;
+	unsigned long data_len;
+
+	data_len = kjob->in_size;
+	cur_key = aes_crypt->keyid;
+
+	aes_encrypt_cbc(buffer, keys[cur_key].enc, keys[cur_key].len,
+			data_len, aes_crypt->iv);
+
+	init_put_data(buffer, aes_crypt->out, data_len, buf_num);
+}
+
+void spu_aes_decrypt_cbc(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num)
+{
+	struct aes_crypt *aes_crypt = &kjob->aes_crypt;
+	unsigned int cur_key;
+	unsigned long data_len;
+
+	data_len = kjob->in_size;
+	cur_key = aes_crypt->keyid;
+
+	aes_decrypt_cbc(buffer, keys[cur_key].dec, keys[cur_key].len,
+			data_len, aes_crypt->iv);
+
+	init_put_data(buffer, aes_crypt->out, data_len, buf_num);
+}
--- a/arch/powerpc/platforms/cell/spufs/spu_main.c
+++ b/arch/powerpc/platforms/cell/spufs/spu_main.c
@@ -11,6 +11,11 @@
 
 static spu_operation_t spu_ops[TOTAL_SPU_OPS] __attribute__((aligned(16))) = {
 	[SPU_OP_nop] = spu_nop,
+	[SPU_OP_aes_update_key] = spu_aes_update_key,
+	[SPU_OP_aes_encrypt_ecb] = spu_aes_encrypt_ecb,
+	[SPU_OP_aes_decrypt_ecb] = spu_aes_decrypt_ecb,
+	[SPU_OP_aes_encrypt_cbc] = spu_aes_encrypt_cbc,
+	[SPU_OP_aes_decrypt_cbc] = spu_aes_decrypt_cbc,
 };
 static unsigned char kspu_buff[DMA_BUFFERS][DMA_MAX_TRANS_SIZE];
 
--- a/arch/powerpc/platforms/cell/spufs/spu_runtime.h
+++ b/arch/powerpc/platforms/cell/spufs/spu_runtime.h
@@ -26,4 +26,14 @@ void memcpy_aligned(void *dest, const vo
 void spu_nop(struct kspu_job *kjob, void *buffer,
 		unsigned int buf_num);
 
+void spu_aes_update_key(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num);
+void spu_aes_encrypt_ecb(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num);
+void spu_aes_decrypt_ecb(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num);
+void spu_aes_encrypt_cbc(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num);
+void spu_aes_decrypt_cbc(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num);
 #endif
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -48,6 +48,19 @@ config CRYPTO_DEV_PADLOCK_SHA
 
 source "arch/s390/crypto/Kconfig"
 
+config CRYPTO_AES_SPU
+	tristate "AES cipher algorithm (SPU support)"
+	select CRYPTO_ABLKCIPHER
+	depends on SPU_FS && KSPU
+	help
+	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
+	  algorithm.
+	  The AES specifies three key sizes: 128, 192 and 256 bits.
+	  See <http://csrc.nist.gov/CryptoToolkit/aes/> for more information.
+
+	  This version of AES performs its work on a SPU core and supports
+		ECB and CBC block mode
+
 config CRYPTO_DEV_GEODE
 	tristate "Support for the Geode LX AES engine"
 	depends on X86_32 && PCI
--- /dev/null
+++ b/include/asm-powerpc/kspu/aes.h
@@ -0,0 +1,28 @@
+#ifndef  __SPU_AES_H__
+#define  __SPU_AES_H__
+
+#define MAX_AES_ROUNDS 15
+#define MAX_AES_KEYSIZE_INT (MAX_AES_ROUNDS * 4)
+#define MAX_AES_KEYSIZE_BYTE (MAX_AES_KEYSIZE_INT * 4)
+#define SPU_KEY_SLOTS 5
+
+struct aes_key_struct {
+	unsigned char enc[MAX_AES_KEYSIZE_BYTE] __attribute__((aligned(16)));
+	unsigned char dec[MAX_AES_KEYSIZE_BYTE] __attribute__((aligned(16)));
+	unsigned int len __attribute__((aligned(16)));
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
+	unsigned char iv[16] __attribute__((aligned(16))); /* as well as in */
+	unsigned long long out __attribute__((aligned(16)));
+};
+#endif
--- a/include/asm-powerpc/kspu/merged_code.h
+++ b/include/asm-powerpc/kspu/merged_code.h
@@ -1,5 +1,6 @@
 #ifndef KSPU_MERGED_CODE_H
 #define KSPU_MERGED_CODE_H
+#include <asm/kspu/aes.h>
 
 #define KSPU_LS_SIZE 0x40000
 
@@ -17,6 +18,12 @@
  */
 enum SPU_OPERATIONS {
 	SPU_OP_nop,
+	SPU_OP_aes_setkey,
+	SPU_OP_aes_update_key,
+	SPU_OP_aes_encrypt_ecb,
+	SPU_OP_aes_decrypt_ecb,
+	SPU_OP_aes_encrypt_cbc,
+	SPU_OP_aes_decrypt_cbc,
 
 	TOTAL_SPU_OPS,
 };
@@ -30,6 +37,8 @@ struct kspu_job {
 	 * function.
 	 */
 	union {
+		struct aes_update_key aes_update_key;
+		struct aes_crypt aes_crypt;
 	} __attribute__((aligned(16)));
 };
 

-- 

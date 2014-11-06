From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC 4/4] crypto: qat - Add new algif interface for userspace
Date: Thu, 06 Nov 2014 11:59:53 -0800
Message-ID: <20141106195953.13328.77022.stgit@tstruk-mobl1>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4470 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaKFUDK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 15:03:10 -0500
In-Reply-To: <20141106195931.13328.90501.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add new socket algif interface for userspace for symmetric and asymmetric
crypto.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/Kconfig                     |    9 
 drivers/crypto/qat/qat_common/Makefile         |    3 
 drivers/crypto/qat/qat_common/adf_common_drv.h |   18 +
 drivers/crypto/qat/qat_common/adf_ctl_drv.c    |   12 
 drivers/crypto/qat/qat_common/algif_qat.c      |  532 ++++++++++++++++
 drivers/crypto/qat/qat_common/algif_qat_asym.c |  791 ++++++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_algs.c       |   22 -
 drivers/crypto/qat/qat_common/qat_bufs.h       |   65 ++
 8 files changed, 1432 insertions(+), 20 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/algif_qat.c
 create mode 100644 drivers/crypto/qat/qat_common/algif_qat_asym.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_bufs.h

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 49bede2..f0827f1 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -21,3 +21,12 @@ config CRYPTO_DEV_QAT_DH895xCC
 
 	  To compile this as a module, choose M here: the module
 	  will be called qat_dh895xcc.
+
+config CRYPTO_DEV_QAT_USERSPACE
+	bool "Support for userspace access to Intel(R) QAT (EXPERIMENTAL)"
+	depends on CRYPTO_DEV_QAT && CRYPTO_USER_API
+	default n
+	help
+	  Support for userspace access to Intel(R) QuickAssist Technology
+	  acceleration.
+	  If unsure, say N.
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index e0424dc..ead901d 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -12,3 +12,6 @@ intel_qat-objs := adf_cfg.o \
 	qat_hal.o
 
 intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o
+intel_qat-$(CONFIG_CRYPTO_DEV_QAT_USERSPACE) += algif_qat.o \
+	algif_qat_asym.o \
+	qat_crypto_user.o
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 9a00a07..73bd78b 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -136,6 +136,8 @@ struct qat_crypto_instance *qat_crypto_get_kernel_instance(void);
 struct qat_crypto_instance *qat_crypto_get_user_instance(void);
 void qat_crypto_put_instance(struct qat_crypto_instance *inst);
 void qat_alg_callback(void *resp);
+void qat_user_callback(void *resp);
+void qat_user_asym_callback(void *resp);
 int qat_algs_init(void);
 void qat_algs_exit(void);
 int qat_algs_register(void);
@@ -192,10 +194,26 @@ void qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle);
 int qat_uclo_map_uof_obj(struct icp_qat_fw_loader_handle *handle,
 			 void *addr_ptr, int mem_size);
 #ifdef CONFIG_CRYPTO_DEV_QAT_USERSPACE
+int algif_qat_init(void);
+void algif_qat_exit(void);
+int algif_qat_asym_init(void);
+void algif_qat_asym_exit(void);
 int qat_crypto_configure_user_instances(struct adf_accel_dev *accel_dev);
 int qat_crypto_create_user_instances(struct adf_accel_dev *accel_dev);
 void qat_crypto_free_user_instances(struct adf_accel_dev *accel_dev);
 #else
+static inline int algif_qat_init(void)
+{
+	return 0;
+}
+
+#define algif_qat_exit() do {} while (0)
+static inline int algif_qat_asym_init(void)
+{
+	return 0;
+}
+
+#define algif_qat_asym_exit() do {} while (0)
 static inline int qat_crypto_configure_user_instances(struct adf_accel_dev *dev)
 {
 	return 0;
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index a660539..464e50f 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -460,8 +460,18 @@ static int __init adf_register_ctl_device_driver(void)
 	if (qat_crypto_register())
 		goto err_crypto_register;
 
+	if (algif_qat_init())
+		goto err_algif;
+
+	if (algif_qat_asym_init())
+		goto err_all;
+
 	return 0;
 
+err_all:
+	algif_qat_exit();
+err_algif:
+	qat_crypto_unregister();
 err_crypto_register:
 	adf_exit_aer();
 err_aer:
@@ -479,6 +489,8 @@ static void __exit adf_unregister_ctl_device_driver(void)
 	adf_exit_aer();
 	qat_crypto_unregister();
 	qat_algs_exit();
+	algif_qat_exit();
+	algif_qat_asym_exit();
 	mutex_destroy(&adf_ctl_lock);
 }
 
diff --git a/drivers/crypto/qat/qat_common/algif_qat.c b/drivers/crypto/qat/qat_common/algif_qat.c
new file mode 100644
index 0000000..53c0669
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/algif_qat.c
@@ -0,0 +1,532 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+
+#include <crypto/if_alg.h>
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/net.h>
+#include <linux/types.h>
+#include <net/sock.h>
+#include <linux/slab.h>
+#include <linux/mempool.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include "adf_accel_devices.h"
+#include "adf_transport.h"
+#include "adf_common_drv.h"
+#include "qat_crypto.h"
+#include "qat_bufs.h"
+#include "icp_qat_hw.h"
+#include "icp_qat_fw.h"
+#include "icp_qat_fw_la.h"
+
+static unsigned int pool_id;
+
+#define SYM_BUF_NUM 16
+#define BUF_REQ_SIZE (sizeof(struct qat_alg_buf_list) + \
+		(SYM_BUF_NUM * sizeof(struct qat_alg_buf)))
+
+struct qat_algif_cy_ctx;
+
+struct qat_algif_request {
+	struct qat_alg_buf_list bufl;
+	struct qat_alg_buf buf_arr[SYM_BUF_NUM];
+	dma_addr_t src_paddr;
+	size_t data_len;
+	struct qat_algif_cy_ctx *ctx;
+	struct icp_qat_fw_la_resp resp;
+	atomic_t done;
+	struct list_head list;
+} __packed __aligned(64);
+
+struct qat_algif_cy_ctx {
+	struct crypto_ctx {
+			struct icp_qat_hw_cipher_algo_blk cipher;
+			struct icp_qat_hw_auth_algo_blk hash;
+		} crypto_ctx;
+	dma_addr_t ctx_paddr;
+	struct icp_qat_fw_la_bulk_req req;
+	struct qat_crypto_instance *inst;
+	struct qat_algif_request *current_req;
+	struct kmem_cache *cache;
+	mempool_t *pool;
+	struct list_head queue;
+	atomic_t data_available;
+} __aligned(64);
+
+static void qat_cache_constructor(void *v)
+{
+	memset(v, '\0', sizeof(struct qat_algif_request));
+}
+
+static void qat_mempool_free(void *_req, void *pool_data)
+{
+	struct qat_algif_cy_ctx *ctx = pool_data;
+	struct adf_accel_dev *accel_dev = ctx->inst->accel_dev;
+	struct kmem_cache *cache = ctx->cache;
+	struct qat_algif_request *req = _req;
+
+	dma_unmap_single(&GET_DEV(accel_dev), req->src_paddr,
+			 BUF_REQ_SIZE, DMA_TO_DEVICE);
+	kmem_cache_free(cache, _req);
+}
+
+static void *qat_mempool_alloc(gfp_t gfp_mask, void *pool_data)
+{
+	struct qat_algif_cy_ctx *ctx = pool_data;
+	struct adf_accel_dev *accel_dev = ctx->inst->accel_dev;
+	struct kmem_cache *cache = ctx->cache;
+	struct qat_algif_request *req;
+
+	req = kmem_cache_alloc_node(cache, gfp_mask,
+				    dev_to_node(&GET_DEV(accel_dev)));
+	if (req) {
+		req->src_paddr = dma_map_single(&GET_DEV(accel_dev), &req->bufl,
+						BUF_REQ_SIZE, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(&GET_DEV(accel_dev),
+					       req->src_paddr))) {
+			kmem_cache_free(cache, req);
+			return NULL;
+		}
+	}
+	return req;
+}
+
+static int qat_mempool_create_pool(struct qat_algif_cy_ctx *ctx,
+				   int num_elems, size_t size)
+{
+	struct adf_accel_dev *accel_dev = ctx->inst->accel_dev;
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "qat_algif_sym_pool_%d", pool_id++);
+	ctx->cache = kmem_cache_create(buf, size, 0, SLAB_HWCACHE_ALIGN,
+				       qat_cache_constructor);
+	if (unlikely(!ctx->cache))
+		return -ENOMEM;
+
+	ctx->pool = mempool_create_node(num_elems, qat_mempool_alloc,
+					qat_mempool_free, ctx, GFP_KERNEL,
+					dev_to_node(&GET_DEV(accel_dev)));
+
+	if (unlikely(!ctx->pool)) {
+		kmem_cache_destroy(ctx->cache);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void qat_mempool_destroy_pool(struct qat_algif_cy_ctx *ctx)
+{
+	if (ctx->pool)
+		mempool_destroy(ctx->pool);
+
+	if (ctx->cache)
+		kmem_cache_destroy(ctx->cache);
+
+	ctx->cache = NULL;
+	ctx->pool = NULL;
+}
+
+void qat_user_callback(void *_resp)
+{
+	struct icp_qat_fw_la_resp *resp = ACCESS_ONCE(_resp);
+	struct qat_algif_request *req =
+				(struct qat_algif_request *)resp->opaque_data;
+	struct qat_algif_cy_ctx *ctx = req->ctx;
+	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
+	struct qat_alg_buf_list *bufl = &req->bufl;
+	struct qat_alg_buf *buf = bufl->bufers;
+	int i;
+
+	for (i = 0; i < bufl->num_bufs; i++, buf++)
+		dma_unmap_single(dev, buf->addr, buf->len, DMA_BIDIRECTIONAL);
+
+	req->resp.comn_resp = resp->comn_resp;
+	atomic_set(&req->done, 1);
+	atomic_set(&ctx->data_available, 1);
+}
+
+static int qat_sendmsg(struct kiocb *unused, struct socket *sock,
+		       struct msghdr *msg, size_t size)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct qat_algif_cy_ctx *ctx = ask->private;
+	struct qat_algif_request *req;
+	int ret = -EINVAL;
+
+	lock_sock(sk);
+	if (unlikely(!ctx || !ctx->pool))
+		goto out;
+
+	if (ctx->current_req) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	if (unlikely(size != sizeof(struct icp_qat_fw_la_bulk_req)))
+		goto out;
+
+	ret = memcpy_fromiovec((unsigned char *)&ctx->req, msg->msg_iov, size);
+	if (ret)
+		goto out;
+
+	req = mempool_alloc(ctx->pool, GFP_KERNEL);
+	if (!req) {
+		pr_err("QAT: user mempool alloc failed\n");
+		ctx->current_req = NULL;
+		ret = -ENOMEM;
+		goto out;
+	}
+	req->data_len = ctx->req.comn_mid.src_length;
+	if (unlikely(!req->data_len))
+		goto out;
+	ctx->req.comn_mid.src_length = 0;
+	req->resp.opaque_data = ctx->req.comn_mid.opaque_data;
+	ctx->req.comn_mid.opaque_data = (uint64_t)(__force long)req;
+	ctx->req.comn_mid.src_data_addr = req->src_paddr;
+	ctx->req.comn_mid.dest_data_addr = req->src_paddr;
+	ctx->req.cd_pars.u.s.content_desc_addr = ctx->ctx_paddr;
+	req->ctx = ctx;
+	req->bufl.num_bufs = 0;
+	atomic_set(&req->done, 0);
+	ctx->current_req = req;
+	ret = size;
+out:
+	release_sock(sk);
+	return ret;
+}
+
+static ssize_t qat_sendpage(struct socket *sock, struct page *page,
+			    int offset, size_t size, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct qat_algif_cy_ctx *ctx = ask->private;
+	struct qat_algif_request *req;
+	struct device *dev;
+	struct qat_alg_buf_list *bufl;
+	struct qat_alg_buf *buf;
+	int ret = -EFAULT, i, ctr = 0;
+
+	lock_sock(sk);
+	if (unlikely(!ctx))
+		goto out;
+
+	req = ctx->current_req;
+	if (unlikely(!req || !req->data_len))
+		goto out;
+
+	dev = &GET_DEV(ctx->inst->accel_dev);
+	bufl = &req->bufl;
+	buf = bufl->bufers + bufl->num_bufs;
+	buf->addr = dma_map_single(dev, page_address(page) + offset, size,
+				   DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(dev, buf->addr))) {
+		dev_err(dev, "QAT: failed to dma_map error\n");
+		if (bufl->num_bufs)
+			goto unmap_out;
+		goto out;
+	}
+	buf->len = size;
+	bufl->num_bufs++;
+	if (unlikely(bufl->num_bufs >= SYM_BUF_NUM)) {
+		pr_err("QAT: too many user buffers\n");
+		goto unmap_out;
+	}
+	req->data_len -= size;
+	if (!(flags & MSG_SENDPAGE_NOTLAST)) {
+		/* It's much easier to keep retrying here
+		 * than to go back to userspace and retry from there */
+		do {
+			ret = adf_send_message(ctx->inst->sym_tx,
+					       (uint32_t *)&ctx->req);
+		} while (ret == -EAGAIN && ctr++ < 10);
+		if (ret == -EAGAIN) {
+			ctr = 0;
+			do {
+				usleep_range(10, 20);
+				ret = adf_send_message(ctx->inst->sym_tx,
+						       (uint32_t *)&ctx->req);
+			} while (ret == -EAGAIN && ctr++ < 300);
+		}
+		if (ret == -EAGAIN) {
+			pr_err("QAT: Can't put user msg\n");
+			goto unmap_out;
+		}
+		list_add(&req->list, &ctx->queue);
+		ctx->current_req = NULL;
+		WARN_ON(req->data_len);
+		req->data_len = 0;
+	}
+	ret = size;
+	goto out;
+unmap_out:
+	for (i = 0; i < bufl->num_bufs; i++) {
+		buf = bufl->bufers + i;
+		if (!dma_mapping_error(dev, buf->addr))
+			dma_unmap_single(dev, buf->addr, buf->len,
+					 DMA_BIDIRECTIONAL);
+	}
+	mempool_free(req, ctx->pool);
+out:
+	release_sock(sk);
+	return ret;
+}
+
+static unsigned int qat_poll(struct file *file, struct socket *sock,
+			     poll_table *wait)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct qat_algif_cy_ctx *ctx = ask->private;
+	unsigned int mask = 0;
+
+	if (unlikely(!ctx))
+		return 0;
+
+	sock_poll_wait(file, sk_sleep(sk), wait);
+
+	if (atomic_read(&ctx->data_available))
+		mask |= POLLIN | POLLRDNORM;
+	return mask;
+}
+
+static int qat_recvmsg(struct kiocb *unused, struct socket *sock,
+		       struct msghdr *msg, size_t ignored, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct qat_algif_cy_ctx *ctx = ask->private;
+	struct qat_algif_request *req;
+	struct list_head *list_ptr, *tmp;
+	struct iovec *iov = msg->msg_iov;
+	unsigned long iovlen = msg->msg_iovlen;
+	int ret = 0;
+
+	lock_sock(sk);
+
+	if (unlikely(!ctx || !ctx->pool))
+		goto out;
+
+	if (!atomic_read(&ctx->data_available))
+		goto out;
+
+	for (; iovlen > 0; iovlen--, iov++) {
+		unsigned long len = iov->iov_len;
+		char __user *ptr = iov->iov_base;
+		struct icp_qat_fw_la_resp *resp;
+
+		if (unlikely(len < sizeof(*resp))) {
+			ret = -EINVAL;
+			goto out;
+		}
+		list_for_each_safe(list_ptr, tmp, &ctx->queue) {
+			req = list_entry(list_ptr, struct qat_algif_request,
+					 list);
+			if (!atomic_read(&req->done))
+				break;
+			if (unlikely(len < sizeof(*resp))) {
+				WARN(len, "buff size not msg size aligned\n");
+				break;
+			}
+			resp = &req->resp;
+			if (copy_to_user(ptr, (void *)resp, sizeof(*resp)))
+				goto out;
+			ret += sizeof(*resp);
+			len -= sizeof(*resp);
+			ptr += sizeof(*resp);
+			list_del(list_ptr);
+			mempool_free(req, ctx->pool);
+		}
+	}
+out:
+	atomic_set(&ctx->data_available, list_empty(&ctx->queue) ? 0 : 1);
+	release_sock(sk);
+	return ret;
+}
+
+static struct proto_ops algif_qat_ops = {
+	.family		=	PF_ALG,
+	.connect	=	sock_no_connect,
+	.socketpair	=	sock_no_socketpair,
+	.getname	=	sock_no_getname,
+	.ioctl		=	sock_no_ioctl,
+	.listen		=	sock_no_listen,
+	.shutdown	=	sock_no_shutdown,
+	.getsockopt	=	sock_no_getsockopt,
+	.mmap		=	sock_no_mmap,
+	.bind		=	sock_no_bind,
+	.accept		=	sock_no_accept,
+	.setsockopt	=	sock_no_setsockopt,
+	.release	=	af_alg_release,
+	.sendmsg	=	qat_sendmsg,
+	.sendpage	=	qat_sendpage,
+	.recvmsg	=	qat_recvmsg,
+	.poll		=	qat_poll,
+};
+
+static void *qat_bind(const char *name, u32 type, u32 mask)
+{
+	struct qat_crypto_instance *inst;
+	struct qat_algif_cy_ctx *ctx = NULL;
+	struct device *dev;
+
+	if (strcmp(name, "sym_crypto"))
+		return ERR_PTR(-EINVAL);
+
+	inst = qat_crypto_get_user_instance();
+	if (!inst)
+		return ERR_PTR(-EFAULT);
+
+	dev = &GET_DEV(inst->accel_dev);
+	ctx = kzalloc_node(sizeof(*ctx), GFP_KERNEL, dev_to_node(dev));
+	if (!ctx)
+		goto err;
+
+	ctx->inst = inst;
+	INIT_LIST_HEAD(&ctx->queue);
+	ctx->ctx_paddr = dma_map_single(dev, &ctx->crypto_ctx,
+					sizeof(struct crypto_ctx),
+					DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, ctx->ctx_paddr)))
+		goto err2;
+
+	if (qat_mempool_create_pool(ctx, 512, sizeof(struct qat_algif_request)))
+		goto err3;
+
+	return ctx;
+err3:
+	dma_unmap_single(dev, ctx->ctx_paddr, sizeof(struct crypto_ctx),
+			 DMA_TO_DEVICE);
+err2:
+	kfree(ctx);
+err:
+	qat_crypto_put_instance(inst);
+	return ERR_PTR(-ENOMEM);
+}
+
+static int qat_setkey(void *private, const u8 *key, unsigned int keylen)
+{
+	struct qat_algif_cy_ctx *ctx = private;
+
+	if (!ctx)
+		return -EINVAL;
+	memcpy(&ctx->crypto_ctx, key, keylen);
+	return 0;
+}
+
+static void qat_release(void *private)
+{
+	struct qat_algif_cy_ctx *ctx = private;
+	struct device *dev;
+	struct qat_algif_request *req;
+	struct list_head *list_ptr, *tmp;
+	int ctr = 0;
+
+	if (!ctx)
+		return;
+
+	/* wait for outstanding requests */
+	while (!list_empty(&ctx->queue) && ctr++ < 100)
+		msleep(300);
+
+	dev = &GET_DEV(ctx->inst->accel_dev);
+	dma_unmap_single(dev, ctx->ctx_paddr, sizeof(struct crypto_ctx),
+			 DMA_TO_DEVICE);
+	list_for_each_safe(list_ptr, tmp, &ctx->queue) {
+		req = list_entry(list_ptr, struct qat_algif_request, list);
+		list_del(list_ptr);
+		mempool_free(req, ctx->pool);
+	}
+	qat_mempool_destroy_pool(ctx);
+	qat_crypto_put_instance(ctx->inst);
+	memset(ctx, '\0', sizeof(*ctx));
+	kfree(ctx);
+}
+
+static void qat_sock_destruct(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct qat_algif_cy_ctx *ctx = ask->private;
+
+	if (atomic_read(&ctx->data_available))
+		pr_info("QAT: still have data.\n");
+
+	af_alg_release_parent(sk);
+}
+
+static int qat_accept(void *private, struct sock *sk)
+{
+	struct qat_algif_cy_ctx *ctx = private;
+	struct alg_sock *ask = alg_sk(sk);
+
+	ask->private = ctx;
+	sk->sk_destruct = qat_sock_destruct;
+	return 0;
+}
+
+static const struct af_alg_type algif_type_qat = {
+	.bind = qat_bind,
+	.release = qat_release,
+	.setkey = qat_setkey,
+	.accept = qat_accept,
+	.ops = &algif_qat_ops,
+	.name = "qat_sym",
+	.owner = THIS_MODULE
+};
+
+int __init algif_qat_init(void)
+{
+	return af_alg_register_type(&algif_type_qat);
+}
+
+void __exit algif_qat_exit(void)
+{
+	af_alg_unregister_type(&algif_type_qat);
+}
diff --git a/drivers/crypto/qat/qat_common/algif_qat_asym.c b/drivers/crypto/qat/qat_common/algif_qat_asym.c
new file mode 100644
index 0000000..164f96d
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/algif_qat_asym.c
@@ -0,0 +1,791 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+
+#include <crypto/if_alg.h>
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/net.h>
+#include <linux/types.h>
+#include <net/sock.h>
+#include <linux/slab.h>
+#include <linux/mempool.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include "adf_accel_devices.h"
+#include "adf_transport.h"
+#include "adf_common_drv.h"
+#include "qat_crypto.h"
+#include "qat_bufs.h"
+#include "icp_qat_hw.h"
+#include "icp_qat_fw.h"
+#include "icp_qat_fw_pke.h"
+
+static unsigned int pool_id;
+#define NUM_PARAMS 8
+#define INPUT_SIZE (8 * NUM_PARAMS)
+#define ALIGN_PKE_ADDR(addr) ((void *)ALIGN((uint64_t)addr, 64))
+struct qat_algif_asym_cy_ctx;
+
+struct qat_asym_algif_req {
+	uint64_t in_params_tab[NUM_PARAMS];
+	uint64_t out_params_tab[NUM_PARAMS];
+	dma_addr_t in_paddr;
+	dma_addr_t out_paddr;
+	void *in_params[NUM_PARAMS];
+	void *out_params[NUM_PARAMS];
+	uint64_t in_params_v[NUM_PARAMS];
+	uint64_t out_params_v[NUM_PARAMS];
+	struct icp_qat_fw_pke_request pke_req;
+	struct icp_qat_fw_pke_resp resp;
+	dma_addr_t pke_req_paddr;
+	unsigned int in_param_sz;
+	unsigned int out_param_sz;
+	struct qat_algif_asym_cy_ctx *ctx;
+	atomic_t done;
+	struct list_head list;
+	struct list_head chain;
+} __packed __aligned(64);
+
+struct qat_algif_asym_cy_ctx {
+	struct qat_crypto_instance *inst;
+	struct kmem_cache *cache;
+	mempool_t *pool;
+	struct list_head queue;
+	atomic_t data_available;
+};
+
+static unsigned int pke_param_sizes[] = {
+	16, 20, 24, 28, 32, 48,
+	64, 72, 96, 128, 192,
+	256, 320, 384, 448, 512
+};
+
+static unsigned int qat_align_pke_param_size(unsigned int size)
+{
+	unsigned int mod = size % 64;
+	unsigned int diff = mod ? 64 - mod : 0;
+
+	return size + diff;
+}
+
+static unsigned int qat_get_pke_input_param_size(unsigned int val,
+						 unsigned int index)
+{
+	unsigned int mask = 0xf << (index * 4);
+
+	return pke_param_sizes[(val & mask) >> (index * 4)];
+}
+
+static unsigned int qat_get_pke_output_param_size(unsigned int val,
+						  unsigned int index)
+{
+	if (index > 3)
+		index = 3;
+	return qat_get_pke_input_param_size(val, index);
+}
+
+static void qat_cache_constructor(void *v)
+{
+	memset(v, '\0', sizeof(struct qat_asym_algif_req));
+}
+
+static void qat_mempool_free(void *_req, void *pool_data)
+{
+	struct qat_algif_asym_cy_ctx *ctx = pool_data;
+	struct adf_accel_dev *accel_dev = ctx->inst->accel_dev;
+	struct kmem_cache *cache = ctx->cache;
+	struct qat_asym_algif_req *req = _req;
+
+	dma_unmap_single(&GET_DEV(accel_dev), req->in_paddr, INPUT_SIZE,
+			 DMA_TO_DEVICE);
+	dma_unmap_single(&GET_DEV(accel_dev), req->out_paddr, INPUT_SIZE,
+			 DMA_BIDIRECTIONAL);
+	dma_unmap_single(&GET_DEV(accel_dev), req->pke_req_paddr,
+			 sizeof(struct icp_qat_fw_pke_request), DMA_TO_DEVICE);
+	kmem_cache_free(cache, _req);
+}
+
+static void *qat_mempool_alloc(gfp_t gfp_mask, void *pool_data)
+{
+	struct qat_algif_asym_cy_ctx *ctx = pool_data;
+	struct adf_accel_dev *accel_dev = ctx->inst->accel_dev;
+	struct kmem_cache *cache = ctx->cache;
+	struct qat_asym_algif_req *req;
+
+	req = kmem_cache_alloc_node(cache, gfp_mask,
+				    dev_to_node(&GET_DEV(accel_dev)));
+	if (req) {
+		req->in_paddr = dma_map_single(&GET_DEV(accel_dev),
+					       req->in_params_tab,
+					       INPUT_SIZE, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(&GET_DEV(accel_dev),
+					       req->in_paddr)))
+			goto err_free;
+
+		req->out_paddr = dma_map_single(&GET_DEV(accel_dev),
+					       req->out_params_tab,
+					       INPUT_SIZE, DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(&GET_DEV(accel_dev),
+					       req->out_paddr)))
+			goto err_unmap_input;
+
+		req->pke_req_paddr =
+			dma_map_single(&GET_DEV(accel_dev),
+				       &req->pke_req,
+				       sizeof(struct icp_qat_fw_pke_request),
+				       DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(&GET_DEV(accel_dev),
+					       req->pke_req_paddr)))
+			goto err_unmap_output;
+	}
+	return req;
+err_unmap_output:
+	dma_unmap_single(&GET_DEV(accel_dev), req->out_paddr,
+			 sizeof(req->out_params_tab), DMA_BIDIRECTIONAL);
+err_unmap_input:
+	dma_unmap_single(&GET_DEV(accel_dev), req->in_paddr,
+			 sizeof(req->in_params_tab), DMA_TO_DEVICE);
+err_free:
+	kmem_cache_free(cache, req);
+	return NULL;
+}
+
+static int qat_mempool_create_pool(struct qat_algif_asym_cy_ctx *ctx,
+				   int num_elems, size_t size)
+{
+	struct adf_accel_dev *accel_dev = ctx->inst->accel_dev;
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "qat_algif_asym_pool_%d", pool_id++);
+	ctx->cache = kmem_cache_create(buf, size, 0, SLAB_HWCACHE_ALIGN,
+				       qat_cache_constructor);
+	if (unlikely(!ctx->cache))
+		return -ENOMEM;
+
+	ctx->pool = mempool_create_node(num_elems, qat_mempool_alloc,
+					qat_mempool_free, ctx, GFP_KERNEL,
+					dev_to_node(&GET_DEV(accel_dev)));
+	if (unlikely(!ctx->pool)) {
+		kmem_cache_destroy(ctx->cache);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void qat_mempool_destroy_pool(struct qat_algif_asym_cy_ctx *ctx)
+{
+	if (ctx->pool)
+		mempool_destroy(ctx->pool);
+
+	if (ctx->cache)
+		kmem_cache_destroy(ctx->cache);
+
+	ctx->cache = NULL;
+	ctx->pool = NULL;
+}
+
+void qat_user_asym_callback(void *_resp)
+{
+	struct icp_qat_fw_pke_resp *resp = ACCESS_ONCE(_resp);
+	struct qat_asym_algif_req *req =
+			(struct qat_asym_algif_req *)resp->opaque_data;
+	struct qat_algif_asym_cy_ctx *ctx = req->ctx;
+
+	req->resp.pke_resp_hdr.comn_resp_flags =
+					resp->pke_resp_hdr.comn_resp_flags;
+	atomic_set(&req->done, 1);
+	atomic_set(&ctx->data_available, 1);
+}
+
+static void qat_unmap_input_params(struct qat_asym_algif_req *req)
+{
+	struct adf_accel_dev *accel_dev = req->ctx->inst->accel_dev;
+	int i;
+
+	for (i = 0; i < req->pke_req.input_param_count; i++) {
+		int size = qat_get_pke_input_param_size(req->in_param_sz, i);
+
+		if (!req->in_params_tab[i])
+			break;
+		dma_unmap_single(&GET_DEV(accel_dev), req->in_params_tab[i],
+				 size, DMA_TO_DEVICE);
+		kfree(req->in_params[i]);
+	}
+}
+
+static void qat_unmap_output_params(struct qat_asym_algif_req *req, int cp)
+{
+	struct adf_accel_dev *accel_dev = req->ctx->inst->accel_dev;
+	int i;
+
+	for (i = 0; i < req->pke_req.output_param_count; i++) {
+		int size = qat_get_pke_output_param_size(req->out_param_sz, i);
+
+		if (!req->out_params_tab[i])
+			break;
+		if (cp)
+			if (copy_to_user((void __user *)req->out_params_v[i],
+					 ALIGN_PKE_ADDR(req->out_params[i]),
+					 size))
+				pr_err("QAT: Failed to copy output param\n");
+
+		dma_unmap_single(&GET_DEV(accel_dev), req->out_params_tab[i],
+				 size, DMA_FROM_DEVICE);
+		kfree(req->out_params[i]);
+	}
+}
+
+static int qat_map_input_params(struct qat_asym_algif_req *req)
+{
+	struct adf_accel_dev *accel_dev = req->ctx->inst->accel_dev;
+	void __user *addr;
+	unsigned int i = 0, x, num_param = req->pke_req.input_param_count;
+	int ret = -EINVAL;
+
+	if (unlikely(num_param > NUM_PARAMS)) {
+		pr_err("QAT: too many input params: %d\n", num_param);
+		goto err;
+	}
+
+	addr = (void __user *)(long)req->pke_req.pke_mid.src_data_addr;
+	if (copy_from_user((void *)req->in_params_v, addr,
+			   sizeof(uint64_t) * num_param)) {
+		pr_err("QAT: copy input params table from user failed\n");
+		ret = -EFAULT;
+		goto err;
+	}
+	req->in_param_sz = req->pke_req.input_param_size;
+	req->pke_req.input_param_size = 0;
+	for (i = 0; i < num_param; i++) {
+		int size = qat_get_pke_input_param_size(req->in_param_sz, i);
+
+		if (unlikely(size > 512 || !size)) {
+			pr_err("QAT: invalid input param size: %d\n", size);
+			ret = -EINVAL;
+			goto err;
+		}
+		req->in_params[i] =
+				kmalloc_node(qat_align_pke_param_size(size),
+					     GFP_KERNEL,
+					     dev_to_node(&GET_DEV(accel_dev)));
+		if (unlikely(!req->in_params[i])) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		if (copy_from_user(ALIGN_PKE_ADDR(req->in_params[i]),
+				   (void __user *)req->in_params_v[i], size)) {
+			pr_err("QAT: copy input parameter from user failed\n");
+			ret = -EFAULT;
+			goto err;
+		}
+		req->in_params_tab[i] =
+			dma_map_single(&GET_DEV(accel_dev),
+				       ALIGN_PKE_ADDR(req->in_params[i]),
+				       size, DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(&GET_DEV(accel_dev),
+					       req->in_params_tab[i]))) {
+			pr_err("QAT: failed to map input param %d size %d\n",
+			       i, size);
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+	for (i = num_param; i < NUM_PARAMS; i++)
+		req->in_params_tab[i] = 0;
+
+	ACCESS_ONCE(req->pke_req.pke_mid.src_data_addr) = req->in_paddr;
+	return 0;
+err:
+	pr_err("QAT: Failed to map input parameters\n");
+	for (x = 0; x < i; x++) {
+		int size = qat_get_pke_input_param_size(req->in_param_sz, x);
+
+		if (!dma_mapping_error(&GET_DEV(accel_dev),
+				       req->in_params_tab[x]))
+			dma_unmap_single(&GET_DEV(accel_dev),
+					 req->in_params_tab[x],
+					 size, DMA_TO_DEVICE);
+		kfree(req->in_params[x]);
+	}
+	return ret;
+}
+
+static int qat_map_output_params(struct qat_asym_algif_req *req)
+{
+	struct adf_accel_dev *accel_dev = req->ctx->inst->accel_dev;
+	uint64_t __user *addr;
+	unsigned int i = 0, x, num_param = req->pke_req.output_param_count;
+	int ret = -EINVAL;
+
+	if (unlikely(num_param > NUM_PARAMS)) {
+		pr_err("QAT: too many output params: %d\n", num_param);
+		goto err;
+	}
+
+	addr = (void __user *)(long)req->pke_req.pke_mid.dest_data_addr;
+	if (copy_from_user((void *)req->out_params_v, addr,
+			   sizeof(uint64_t) * num_param)) {
+		pr_err("QAT: copy output params table from user failed\n");
+		ret = -EFAULT;
+		goto err;
+	}
+
+	req->out_param_sz = req->pke_req.output_param_size;
+	req->pke_req.output_param_size = 0;
+	for (i = 0; i < num_param; i++) {
+		int size = qat_get_pke_output_param_size(req->out_param_sz, i);
+
+		if (unlikely(size > 512)) {
+			pr_err("QAT: invalid output param size: %d\n", size);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		req->out_params[i] =
+				kmalloc_node(qat_align_pke_param_size(size),
+					     GFP_KERNEL,
+					     dev_to_node(&GET_DEV(accel_dev)));
+		if (unlikely(!req->out_params[i])) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		req->out_params_tab[i] =
+			dma_map_single(&GET_DEV(accel_dev),
+				       ALIGN_PKE_ADDR(req->out_params[i]),
+				       size, DMA_BIDIRECTIONAL);
+
+		if (unlikely(dma_mapping_error(&GET_DEV(accel_dev),
+					       req->out_params_tab[i]))) {
+			pr_err("QAT: failed to map input param %d size %d\n",
+			       i, size);
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+	for (i = num_param; i < NUM_PARAMS; i++)
+		req->out_params_tab[i] = 0;
+
+	ACCESS_ONCE(req->pke_req.pke_mid.dest_data_addr) = req->out_paddr;
+	return 0;
+err:
+	pr_err("QAT: Failed to map output parameters\n");
+	for (x = 0; x < i; x++) {
+		int size = qat_get_pke_input_param_size(req->out_param_sz, x);
+
+		if (!dma_mapping_error(&GET_DEV(accel_dev),
+				       req->out_params_tab[x]))
+			dma_unmap_single(&GET_DEV(accel_dev),
+					 req->out_params_tab[x], size,
+					 DMA_BIDIRECTIONAL);
+		kfree(req->out_params[x]);
+	}
+	return ret;
+}
+
+static int qat_asym_sendmsg(struct kiocb *unused, struct socket *sock,
+			    struct msghdr *msg, size_t not_used)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct qat_algif_asym_cy_ctx *ctx = ask->private;
+	struct adf_accel_dev *accel_dev = ctx->inst->accel_dev;
+	struct qat_asym_algif_req *req, *req_chain;
+	struct icp_qat_fw_pke_request *pke_req_prev;
+	struct iovec *iov = msg->msg_iov;
+	unsigned long iovlen = msg->msg_iovlen;
+	unsigned long data_len = iov->iov_len;
+	char __user *data = iov->iov_base;
+	char __user *pke_req_chain;
+	dma_addr_t pke_req_prev_paddr;
+	struct list_head *list_ptr, *tmp;
+	int ret = -EINVAL, copied = 0, ctr = 0, num_reqs = 0;
+
+	lock_sock(sk);
+	if (unlikely(!ctx || !ctx->pool))
+		goto out;
+
+	if (unlikely(iovlen != 1))
+		goto out;
+
+	if (unlikely(data_len != sizeof(struct icp_qat_fw_pke_request)))
+		goto out;
+
+	req = mempool_alloc(ctx->pool, GFP_KERNEL);
+	if (!req) {
+		pr_err("QAT: user mempool alloc failed\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	if (copy_from_user((void *)&req->pke_req, data, data_len)) {
+		pr_err("QAT: copy data from user failed\n");
+		ret = -EFAULT;
+		goto out_free;
+	}
+	copied += data_len;
+	req->ctx = ctx;
+	ret = qat_map_input_params(req);
+	if (ret)
+		goto out_free;
+	ret = qat_map_output_params(req);
+	if (ret)
+		goto out_free;
+	req->pke_req.pke_hdr.cd_pars.content_desc_addr =
+						accel_dev->fw_loader->mmp_addr;
+	req->resp.opaque_data = req->pke_req.pke_mid.opaque_data;
+	req->pke_req.pke_mid.opaque_data = (uint64_t)(__force long)req;
+	atomic_set(&req->done, 0);
+	INIT_LIST_HEAD(&req->chain);
+	pke_req_chain = (char __user *)req->pke_req.next_req_adr;
+	pke_req_prev = &req->pke_req;
+
+	while (pke_req_chain) {
+		if (unlikely(num_reqs++ > NUM_PARAMS)) {
+			pr_err("QAT: too many chained requests: %d\n",
+			       num_reqs);
+			ret = -EINVAL;
+			goto out_free_chain;
+		}
+		req_chain = mempool_alloc(ctx->pool, GFP_KERNEL);
+		if (!req_chain) {
+			pr_err("QAT: user mempool alloc failed\n");
+			ret = -ENOMEM;
+			goto out_free_chain;
+		}
+		list_add(&req_chain->chain, &req->chain);
+		if (copy_from_user((void *)&req_chain->pke_req, pke_req_chain,
+				   sizeof(req_chain->pke_req))) {
+			pr_err("QAT: copy from user failed\n");
+			ret = -EFAULT;
+			goto out_free_chain;
+		}
+		req_chain->ctx = ctx;
+		ret = qat_map_input_params(req_chain);
+		if (ret)
+			goto out_free_chain;
+		ret = qat_map_output_params(req_chain);
+		if (ret)
+			goto out_free_chain;
+		copied += sizeof(req_chain->pke_req);
+		req_chain->pke_req.pke_mid.opaque_data =
+					(uint64_t)(__force long)req;
+		req_chain->pke_req.pke_hdr.cd_pars.content_desc_addr =
+					accel_dev->fw_loader->mmp_addr;
+		pke_req_prev_paddr = req_chain->pke_req_paddr;
+		pke_req_prev->next_req_adr = (uint64_t)(__force long)
+						pke_req_prev_paddr;
+		pke_req_prev = &req_chain->pke_req;
+		pke_req_chain = (char __user *)req_chain->pke_req.next_req_adr;
+	}
+	do {
+		ret = adf_send_message(ctx->inst->pke_tx,
+				       (uint32_t *)&req->pke_req);
+	} while (ret == -EAGAIN && ctr++ < 10);
+	/* PKE jobs take longer. Try to wait for some to finish */
+	if (ret == -EAGAIN) {
+		ctr = 0;
+		do {
+			usleep_range(100, 120);
+			ret = adf_send_message(ctx->inst->pke_tx,
+					       (uint32_t *)&req->pke_req);
+		} while (ret == -EAGAIN && ctr++ < 20000);
+	}
+
+	if (ret == -EAGAIN) {
+		WARN_ONCE(true, "QAT: Can't put asym msg\n");
+		goto out_free_chain;
+	}
+	ret = copied;
+	list_add(&req->list, &ctx->queue);
+	goto out;
+out_free_chain:
+	list_for_each_safe(list_ptr, tmp, &req->chain) {
+		req_chain = list_entry(list_ptr, struct qat_asym_algif_req,
+				       chain);
+		qat_unmap_input_params(req_chain);
+		qat_unmap_output_params(req_chain, 0);
+		list_del(list_ptr);
+		mempool_free(req_chain, ctx->pool);
+	}
+out_free:
+	qat_unmap_input_params(req);
+	qat_unmap_output_params(req, 0);
+	mempool_free(req, ctx->pool);
+out:
+	release_sock(sk);
+	return ret;
+}
+
+static unsigned int qat_asym_poll(struct file *file, struct socket *sock,
+				  poll_table *wait)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct qat_algif_asym_cy_ctx *ctx = ask->private;
+	unsigned int mask = 0;
+
+	if (unlikely(!ctx))
+		return 0;
+
+	sock_poll_wait(file, sk_sleep(sk), wait);
+
+	if (atomic_read(&ctx->data_available))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+static int qat_asym_recvmsg(struct kiocb *unused, struct socket *sock,
+			    struct msghdr *msg, size_t ignored, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct qat_algif_asym_cy_ctx *ctx = ask->private;
+	struct qat_asym_algif_req *req, *req_chain;
+	struct list_head *list_ptr, *tmp;
+	struct list_head *list_ptr_chain, *tmp_chain;
+	struct iovec *iov = msg->msg_iov;
+	unsigned long iovlen = msg->msg_iovlen;
+	int ret = 0;
+
+	lock_sock(sk);
+
+	if (unlikely(!ctx || !ctx->pool))
+		goto out;
+
+	if (!atomic_read(&ctx->data_available))
+		goto out;
+
+	for (; iovlen > 0; iovlen--, iov++) {
+		unsigned long len = iov->iov_len;
+		char __user *ptr = iov->iov_base;
+		struct icp_qat_fw_pke_resp *resp;
+
+		list_for_each_safe(list_ptr, tmp, &ctx->queue) {
+			req = list_entry(list_ptr,
+					 struct qat_asym_algif_req,
+					 list);
+			if (!len)
+				break;
+			if (unlikely(len < sizeof(*resp))) {
+				ret = -EINVAL;
+				goto out;
+			}
+			if (!atomic_read(&req->done))
+				break;
+			resp = &req->resp;
+			if (copy_to_user(ptr, (void *)resp, sizeof(*resp))) {
+				pr_err("QAT: copy to user failed\n");
+				ret = -EFAULT;
+				goto out;
+			}
+			list_for_each_safe(list_ptr_chain,
+					   tmp_chain, &req->chain) {
+				req_chain =
+					list_entry(list_ptr_chain,
+						   struct qat_asym_algif_req,
+						   chain);
+				qat_unmap_input_params(req_chain);
+				qat_unmap_output_params(req_chain, 1);
+				list_del(list_ptr_chain);
+				mempool_free(req_chain, ctx->pool);
+			}
+			qat_unmap_input_params(req);
+			qat_unmap_output_params(req, 1);
+			list_del(list_ptr);
+			mempool_free(req, ctx->pool);
+			ret += sizeof(*resp);
+			len -= sizeof(*resp);
+			ptr += sizeof(*resp);
+		}
+	}
+out:
+	/* If something went wrong and there is still data
+	 * ready to be read we need to set the data_available
+	 * flag accordingly for the next poll to work */
+	atomic_set(&ctx->data_available, 0);
+	list_for_each(list_ptr, &ctx->queue) {
+		req = list_entry(list_ptr, struct qat_asym_algif_req, list);
+		if (atomic_read(&req->done)) {
+			atomic_set(&ctx->data_available, 1);
+			break;
+		}
+	}
+	release_sock(sk);
+	return ret;
+}
+
+static struct proto_ops algif_qat_asym_ops = {
+	.family		=	PF_ALG,
+	.connect	=	sock_no_connect,
+	.socketpair	=	sock_no_socketpair,
+	.getname	=	sock_no_getname,
+	.ioctl		=	sock_no_ioctl,
+	.listen		=	sock_no_listen,
+	.shutdown	=	sock_no_shutdown,
+	.getsockopt	=	sock_no_getsockopt,
+	.mmap		=	sock_no_mmap,
+	.bind		=	sock_no_bind,
+	.accept		=	sock_no_accept,
+	.setsockopt	=	sock_no_setsockopt,
+	.sendpage	=	sock_no_sendpage,
+	.release	=	af_alg_release,
+	.sendmsg	=	qat_asym_sendmsg,
+	.recvmsg	=	qat_asym_recvmsg,
+	.poll		=	qat_asym_poll,
+};
+
+static void *qat_asym_bind(const char *name, u32 type, u32 mask)
+{
+	struct qat_crypto_instance *inst;
+	struct qat_algif_asym_cy_ctx *ctx;
+	struct device *dev;
+
+	if (strcmp(name, "asym_crypto"))
+		return ERR_PTR(-EINVAL);
+
+	inst = qat_crypto_get_user_instance();
+	if (!inst)
+		return ERR_PTR(-EFAULT);
+
+	dev = &GET_DEV(inst->accel_dev);
+	ctx = kzalloc_node(sizeof(*ctx), GFP_KERNEL, dev_to_node(dev));
+	if (!ctx)
+		goto err;
+
+	INIT_LIST_HEAD(&ctx->queue);
+	ctx->inst = inst;
+	if (qat_mempool_create_pool(ctx, 1024,
+				    sizeof(struct qat_asym_algif_req)))
+		goto err2;
+	return ctx;
+err2:
+	kfree(ctx);
+err:
+	qat_crypto_put_instance(inst);
+	return ERR_PTR(-ENOMEM);
+}
+
+static void qat_asym_release(void *private)
+{
+	struct qat_algif_asym_cy_ctx *ctx = private;
+	struct qat_asym_algif_req *req, *req_chain;
+	struct list_head *list_ptr, *tmp;
+	struct list_head *list_ptr_chain, *tmp_chain;
+	int ctr = 0;
+
+	if (!ctx)
+		return;
+
+	/* wait for outstanding requests */
+	while (!list_empty(&ctx->queue) && ctr++ < 100)
+		msleep(300);
+
+	list_for_each_safe(list_ptr, tmp, &ctx->queue) {
+		req = list_entry(list_ptr, struct qat_asym_algif_req, list);
+		list_for_each_safe(list_ptr_chain, tmp_chain, &req->chain) {
+			req_chain = list_entry(list_ptr_chain,
+					       struct qat_asym_algif_req,
+					       chain);
+			qat_unmap_input_params(req_chain);
+			qat_unmap_output_params(req_chain, 0);
+			list_del(list_ptr_chain);
+			mempool_free(req_chain, ctx->pool);
+		}
+		qat_unmap_input_params(req);
+		qat_unmap_output_params(req, 0);
+		list_del(list_ptr);
+		mempool_free(req, ctx->pool);
+	}
+	qat_mempool_destroy_pool(ctx);
+	qat_crypto_put_instance(ctx->inst);
+	memset(ctx, '\0', sizeof(*ctx));
+	kfree(ctx);
+}
+
+static void qat_asym_destruct(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct qat_algif_asym_cy_ctx *ctx = ask->private;
+
+	if (atomic_read(&ctx->data_available))
+		pr_info("QAT: still have data.\n");
+
+	af_alg_release_parent(sk);
+}
+
+static int qat_asym_accept(void *private, struct sock *sk)
+{
+	struct qat_algif_asym_cy_ctx *ctx = private;
+	struct alg_sock *ask = alg_sk(sk);
+
+	ask->private = ctx;
+	sk->sk_destruct = qat_asym_destruct;
+	return 0;
+}
+
+static const struct af_alg_type algif_type_qat_asym = {
+	.bind = qat_asym_bind,
+	.release = qat_asym_release,
+	.accept = qat_asym_accept,
+	.ops = &algif_qat_asym_ops,
+	.name = "qat_asym",
+	.owner = THIS_MODULE
+};
+
+int __init algif_qat_asym_init(void)
+{
+	return af_alg_register_type(&algif_type_qat_asym);
+}
+
+void __exit algif_qat_asym_exit(void)
+{
+	af_alg_unregister_type(&algif_type_qat_asym);
+}
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 2269fda..79c6b19 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -62,6 +62,7 @@
 #include "icp_qat_hw.h"
 #include "icp_qat_fw.h"
 #include "icp_qat_fw_la.h"
+#include "qat_bufs.h"
 
 #define QAT_AES_HW_CONFIG_ENC(alg) \
 	ICP_QAT_HW_CIPHER_CONFIG_BUILD(ICP_QAT_HW_CIPHER_CBC_MODE, alg, \
@@ -75,19 +76,6 @@
 
 static atomic_t active_dev;
 
-struct qat_alg_buf {
-	uint32_t len;
-	uint32_t resrvd;
-	uint64_t addr;
-} __packed;
-
-struct qat_alg_buf_list {
-	uint64_t resrvd;
-	uint32_t num_bufs;
-	uint32_t num_mapped_bufs;
-	struct qat_alg_buf bufers[];
-} __packed __aligned(64);
-
 /* Common content descriptor */
 struct qat_alg_cd {
 	union {
@@ -123,11 +111,6 @@ struct qat_alg_session_ctx {
 	spinlock_t lock;	/* protects qat_alg_session_ctx struct */
 };
 
-static int get_current_node(void)
-{
-	return cpu_data(current_thread_info()->cpu).phys_proc_id;
-}
-
 static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
 {
 	switch (qat_hash_alg) {
@@ -500,9 +483,8 @@ static int qat_alg_setkey(struct crypto_aead *tfm, const uint8_t *key,
 		       sizeof(struct icp_qat_fw_la_bulk_req));
 	} else {
 		/* new key */
-		int node = get_current_node();
 		struct qat_crypto_instance *inst =
-				qat_crypto_get_instance_node(node);
+				qat_crypto_get_kernel_instance();
 		if (!inst) {
 			spin_unlock(&ctx->lock);
 			return -EINVAL;
diff --git a/drivers/crypto/qat/qat_common/qat_bufs.h b/drivers/crypto/qat/qat_common/qat_bufs.h
new file mode 100644
index 0000000..dcab80d
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_bufs.h
@@ -0,0 +1,65 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef _QAT_BUF_H_
+#define _QAT_BUF_H_
+
+#include <linux/types.h>
+
+struct qat_alg_buf {
+	uint32_t len;
+	uint32_t resrvd;
+	uint64_t addr;
+} __packed;
+
+struct qat_alg_buf_list {
+	uint64_t resrvd;
+	uint32_t num_bufs;
+	uint32_t num_mapped_bufs;
+	struct qat_alg_buf bufers[];
+} __packed __aligned(64);
+
+#endif

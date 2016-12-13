From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH v2 2/3] drivers: crypto: Add the Virtual Function driver for CPT
Date: Tue, 13 Dec 2016 14:03:20 +0000
Message-ID: <1481637801-1076-3-git-send-email-george.cherian@cavium.com>
References: <1481637801-1076-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        "George Cherian" <george.cherian@cavium.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481637801-1076-1-git-send-email-george.cherian@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Enable the CPT VF driver. CPT is the cryptographic Accelaration Unit
in Octeon-tx series of processors.

Signed-off-by: George Cherian <george.cherian@cavium.com>
---
 drivers/crypto/cavium/cpt/Makefile           |   3 +-
 drivers/crypto/cavium/cpt/cptvf.h            | 145 ++++
 drivers/crypto/cavium/cpt/cptvf_algs.c       | 424 ++++++++++++
 drivers/crypto/cavium/cpt/cptvf_algs.h       | 110 +++
 drivers/crypto/cavium/cpt/cptvf_main.c       | 971 +++++++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptvf_mbox.c       | 205 ++++++
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 581 ++++++++++++++++
 drivers/crypto/cavium/cpt/request_manager.h  | 147 ++++
 8 files changed, 2585 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/cavium/cpt/cptvf.h
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_algs.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_algs.h
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_main.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_mbox.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_reqmanager.c
 create mode 100644 drivers/crypto/cavium/cpt/request_manager.h

diff --git a/drivers/crypto/cavium/cpt/Makefile b/drivers/crypto/cavium/cpt/Makefile
index fe3d454..dbf055e 100644
--- a/drivers/crypto/cavium/cpt/Makefile
+++ b/drivers/crypto/cavium/cpt/Makefile
@@ -1,2 +1,3 @@
-obj-$(CONFIG_CAVIUM_CPT) += cptpf.o
+obj-$(CONFIG_CAVIUM_CPT) += cptpf.o cptvf.o
 cptpf-objs := cptpf_main.o cptpf_mbox.o
+cptvf-objs := cptvf_main.o cptvf_reqmanager.o cptvf_mbox.o cptvf_algs.o
diff --git a/drivers/crypto/cavium/cpt/cptvf.h b/drivers/crypto/cavium/cpt/cptvf.h
new file mode 100644
index 0000000..d649c5a
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf.h
@@ -0,0 +1,145 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef __CPTVF_H
+#define __CPTVF_H
+
+#include <linux/list.h>
+#include "cpt_common.h"
+
+/* Default command queue length */
+#define CPT_CMD_QLEN 2046
+#define CPT_CMD_QCHUNK_SIZE 1023
+
+/* Default command timeout in seconds */
+#define CPT_COMMAND_TIMEOUT 4
+#define CPT_TIMER_THOLD	0xFFFF
+#define CPT_NUM_QS_PER_VF 1
+#define CPT_INST_SIZE 64
+#define CPT_NEXT_CHUNK_PTR_SIZE 8
+
+#define	CPT_VF_MSIX_VECTORS 2
+#define CPT_VF_INTR_MBOX_MASK BIT(0)
+#define CPT_VF_INTR_DOVF_MASK BIT(1)
+#define CPT_VF_INTR_IRDE_MASK BIT(2)
+#define CPT_VF_INTR_NWRP_MASK BIT(3)
+#define CPT_VF_INTR_SERR_MASK BIT(4)
+
+/**
+ * Enumeration cpt_vf_int_vec_e
+ *
+ * CPT VF MSI-X Vector Enumeration
+ * Enumerates the MSI-X interrupt vectors.
+ */
+enum cpt_vf_int_vec_e {
+	CPT_VF_INT_VEC_E_MISC = 0x00,
+	CPT_VF_INT_VEC_E_DONE = 0x01
+};
+
+struct command_chunk {
+	u8 *head;
+	dma_addr_t dma_addr;
+	u32 size; /* Chunk size, max CPT_INST_CHUNK_MAX_SIZE */
+	struct hlist_node nextchunk;
+};
+
+struct command_queue {
+	spinlock_t lock; /* command queue lock */
+	u32 idx; /* Command queue host write idx */
+	u32 nchunks; /* Number of command chunks */
+	struct command_chunk *qhead;	/* Command queue head, instructions
+					 * are inserted here
+					 */
+	struct hlist_head chead;
+};
+
+struct command_qinfo {
+	u32 cmd_size;
+	u32 qchunksize; /* Command queue chunk size */
+	struct command_queue queue[CPT_NUM_QS_PER_VF];
+};
+
+struct pending_entry {
+	u8 busy; /* Entry status (free/busy) */
+
+	volatile u64 *completion_addr; /* Completion address */
+	void *post_arg;
+	void (*callback)(int, void *); /* Kernel ASYNC request callabck */
+	void *callback_arg; /* Kernel ASYNC request callabck arg */
+};
+
+struct pending_queue {
+	struct pending_entry *head;	/* head of the queue */
+	u32 front; /* Process work from here */
+	u32 rear; /* Append new work here */
+	atomic64_t pending_count;
+	spinlock_t lock; /* Queue lock */
+};
+
+struct pending_qinfo {
+	u32 nr_queues;	/* Number of queues supported */
+	u32 qlen; /* Queue length */
+	struct pending_queue queue[CPT_NUM_QS_PER_VF];
+};
+
+#define for_each_pending_queue(qinfo, q, i)	\
+	for (i = 0, q = &qinfo->queue[i]; i < qinfo->nr_queues; i++, \
+	     q = &qinfo->queue[i])
+
+struct cpt_vf {
+	u16 flags; /* Flags to hold device status bits */
+	u8 vfid; /* Device Index 0...CPT_MAX_VF_NUM */
+	u8 vftype; /* VF type of SE_TYPE(1) or AE_TYPE(1) */
+	u8 vfgrp; /* VF group (0 - 8) */
+	u8 node; /* Operating node: Bits (46:44) in BAR0 address */
+	u8 priority; /* VF priority ring: 1-High proirity round
+		      * robin ring;0-Low priority round robin ring;
+		      */
+	struct pci_dev *pdev; /* pci device handle */
+	void __iomem *reg_base; /* Register start address */
+	void *wqe_info;	/* BH worker info */
+	/* MSI-X */
+	bool msix_enabled;
+	struct msix_entry msix_entries[CPT_VF_MSIX_VECTORS];
+	bool irq_allocated[CPT_VF_MSIX_VECTORS];
+	cpumask_var_t affinity_mask[CPT_VF_MSIX_VECTORS];
+	/* Command and Pending queues */
+	u32 qsize;
+	u32 nr_queues;
+	struct command_qinfo cqinfo; /* Command queue information */
+	struct pending_qinfo pqinfo; /* Pending queue information */
+	/* VF-PF mailbox communication */
+	bool pf_acked;
+	bool pf_nacked;
+};
+
+#define CPT_NODE_ID_SHIFT 44u
+#define CPT_NODE_ID_MASK 3u
+
+enum dma_mode {
+	DMA_DIRECT_DIRECT, /* Input DIRECT, Output DIRECT */
+	DMA_GATHER_SCATTER
+};
+
+enum inputtype {
+	FROM_CTX = 0,
+	FROM_DPTR = 1
+};
+
+int cptvf_send_vf_up(struct cpt_vf *cptvf);
+int cptvf_send_vf_down(struct cpt_vf *cptvf);
+int cptvf_send_vf_to_grp_msg(struct cpt_vf *cptvf);
+int cptvf_send_vf_priority_msg(struct cpt_vf *cptvf);
+int cptvf_send_vq_size_msg(struct cpt_vf *cptvf);
+int cptvf_check_pf_ready(struct cpt_vf *cptvf);
+void cptvf_handle_mbox_intr(struct cpt_vf *cptvf);
+void cvm_crypto_exit(void);
+int cvm_crypto_init(struct cpt_vf *cptvf);
+void vq_post_process(struct cpt_vf *cptvf, u32 qno);
+void cptvf_write_vq_doorbell(struct cpt_vf *cptvf, u32 val);
+#endif /* __CPTVF_H */
diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
new file mode 100644
index 0000000..d7a95c7
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -0,0 +1,424 @@
+
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <crypto/cryptd.h>
+#include <crypto/crypto_wq.h>
+#include <linux/list.h>
+#include <linux/scatterlist.h>
+#include <linux/err.h>
+#include <crypto/aes.h>
+#include <crypto/authenc.h>
+#include <crypto/des.h>
+
+#include "request_manager.h"
+#include "cptvf.h"
+#include "cptvf_algs.h"
+
+struct cpt_device_handle {
+	void *cdev[MAX_DEVICES];
+	u32 dev_count;
+};
+
+static struct cpt_device_handle dev_handle;
+
+static void cvm_callback(u32 status, void *arg)
+{
+	struct crypto_async_request *req = (struct crypto_async_request *)arg;
+
+	req->complete(req, !status);
+}
+
+static inline void update_input_iv(struct cpt_request_info *req_info,
+				   u8 *iv, u32 enc_iv_len,
+				   u32 *argcnt)
+{
+	/* Setting the iv information */
+	req_info->in[*argcnt].vptr = (void *)iv;
+	req_info->in[*argcnt].size = enc_iv_len;
+	req_info->req.dlen += enc_iv_len;
+
+	++(*argcnt);
+}
+
+static inline void update_output_iv(struct cpt_request_info *req_info,
+				    u8 *iv, u32 enc_iv_len,
+				    u32 *argcnt)
+{
+	/* Setting the iv information */
+	req_info->out[*argcnt].vptr = (void *)iv;
+	req_info->out[*argcnt].size = enc_iv_len;
+	req_info->rlen += enc_iv_len;
+
+	++(*argcnt);
+}
+
+static inline void update_input_data(struct cpt_request_info *req_info,
+				     struct scatterlist *inp_sg,
+				     u32 nbytes, u32 *argcnt)
+{
+	req_info->req.dlen += nbytes;
+
+	while (nbytes) {
+		u32 len = min(nbytes, inp_sg->length);
+		u8 *ptr = page_address(sg_page(inp_sg)) + inp_sg->offset;
+
+		req_info->in[*argcnt].vptr = (void *)ptr;
+		req_info->in[*argcnt].size = len;
+		nbytes -= len;
+
+		++(*argcnt);
+		++inp_sg;
+	}
+}
+
+static inline void update_output_data(struct cpt_request_info *req_info,
+				      struct scatterlist *outp_sg,
+				      u32 nbytes, u32 *argcnt)
+{
+	req_info->rlen += nbytes;
+
+	while (nbytes) {
+		u32 len = min(nbytes, outp_sg->length);
+		u8 *ptr = page_address(sg_page(outp_sg)) +
+					    outp_sg->offset;
+
+		req_info->out[*argcnt].vptr = (void *)ptr;
+		req_info->out[*argcnt].size = len;
+		nbytes -= len;
+		++(*argcnt);
+		++outp_sg;
+	}
+}
+
+static inline u32 create_ctx_hdr(struct ablkcipher_request *req, u32 enc,
+				 u32 cipher_type, u32 aes_key_type,
+				 u32 *argcnt)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct cvm_enc_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct fc_context *fctx = &rctx->fctx;
+	u64 *offset_control = &rctx->control_word;
+	u32 enc_iv_len = crypto_ablkcipher_ivsize(tfm);
+	struct cpt_request_info *req_info = &rctx->cpt_req;
+	u64 *ctrl_flags = NULL;
+
+	req_info->ctrl.s.grp = 0;
+	req_info->ctrl.s.dma_mode = DMA_GATHER_SCATTER;
+	req_info->ctrl.s.se_req = SE_CORE_REQ;
+
+	req_info->req.opcode.s.major = MAJOR_OP_FC |
+					DMA_MODE_FLAG(DMA_GATHER_SCATTER);
+	if (enc)
+		req_info->req.opcode.s.minor = 2;
+	else
+		req_info->req.opcode.s.minor = 3;
+
+	req_info->req.param1 = req->nbytes; /* Encryption Data length */
+	req_info->req.param2 = 0; /*Auth data length */
+
+	fctx->enc.enc_ctrl.e.enc_cipher = cipher_type;
+	fctx->enc.enc_ctrl.e.aes_key = aes_key_type;
+	fctx->enc.enc_ctrl.e.iv_source = FROM_DPTR;
+
+	memcpy(fctx->enc.encr_key, ctx->enc_key, ctx->key_len);
+	ctrl_flags = (u64 *)&fctx->enc.enc_ctrl.flags;
+	*ctrl_flags = cpu_to_be64(*ctrl_flags);
+
+	*offset_control = cpu_to_be64(((u64)(enc_iv_len) << 16));
+	/* Storing  Packet Data Information in offset
+	 * Control Word First 8 bytes
+	 */
+	req_info->in[*argcnt].vptr = (u8 *)offset_control;
+	req_info->in[*argcnt].size = CONTROL_WORD_LEN;
+	req_info->req.dlen += CONTROL_WORD_LEN;
+
+	++(*argcnt);
+
+	req_info->in[*argcnt].vptr = (u8 *)fctx;
+	req_info->in[*argcnt].size = sizeof(struct fc_context);
+	req_info->req.dlen += sizeof(struct fc_context);
+
+	++(*argcnt);
+
+	return 0;
+}
+
+static inline u32 create_input_list(struct ablkcipher_request  *req, u32 enc,
+				    u32 cipher_type, u32 aes_key_type,
+				    u32 enc_iv_len)
+{
+	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct cpt_request_info *req_info = &rctx->cpt_req;
+	u32 argcnt =  0;
+
+	create_ctx_hdr(req, enc, cipher_type, aes_key_type, &argcnt);
+	update_input_iv(req_info, req->info, enc_iv_len, &argcnt);
+	update_input_data(req_info, req->src, req->nbytes, &argcnt);
+	req_info->incnt = argcnt;
+
+	return 0;
+}
+
+static inline void store_cb_info(struct ablkcipher_request *req,
+				 struct cpt_request_info *req_info)
+{
+	req_info->callback = (void *)cvm_callback;
+	req_info->callback_arg = (void *)&req->base;
+}
+
+static inline void create_output_list(struct ablkcipher_request *req,
+				      u32 cipher_type,
+				      u32 enc_iv_len)
+{
+	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct cpt_request_info *req_info = &rctx->cpt_req;
+	u32 argcnt = 0;
+
+	/* OUTPUT Buffer Processing
+	 * AES encryption/decryption output would be
+	 * received in the following format
+	 *
+	 * ------IV--------|------ENCRYPTED/DECRYPTED DATA-----|
+	 * [ 16 Bytes/     [   Request Enc/Dec/ DATA Len AES CBC ]
+	 */
+	/* Reading IV information */
+	update_output_iv(req_info, req->info, enc_iv_len, &argcnt);
+	update_output_data(req_info, req->dst, req->nbytes, &argcnt);
+	req_info->outcnt = argcnt;
+}
+
+static inline u32 cvm_enc_dec(struct ablkcipher_request *req, u32 enc,
+			      u32 cipher_type)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct cvm_enc_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	u32 key_type = AES_128_BIT;
+	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
+	u32 enc_iv_len = crypto_ablkcipher_ivsize(tfm);
+	struct fc_context *fctx = &rctx->fctx;
+	struct cpt_request_info *req_info = &rctx->cpt_req;
+	void *cdev = NULL;
+	u32 status = -1;
+
+	switch (ctx->key_len) {
+	case 16:
+		key_type = AES_128_BIT;
+		break;
+	case 24:
+		key_type = AES_192_BIT;
+		break;
+	case 32:
+		key_type = AES_256_BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (cipher_type == DES3_CBC)
+		key_type = 0;
+
+	memset(req_info, 0, sizeof(struct cpt_request_info));
+	memset(fctx, 0, sizeof(struct fc_context));
+	create_input_list(req, enc, cipher_type, key_type, enc_iv_len);
+	create_output_list(req, cipher_type, enc_iv_len);
+	store_cb_info(req, req_info);
+	cdev = dev_handle.cdev[smp_processor_id()];
+	status = cptvf_do_request(cdev, req_info);
+	/* We perform an asynchronous send and once
+	 * the request is completed the driver would
+	 * intimate through  registered call back functions
+	 */
+
+	if (status)
+		return status;
+	else
+		return -EINPROGRESS;
+}
+
+s32 cvm_des3_encrypt_cbc(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, true, DES3_CBC);
+}
+
+s32 cvm_des3_decrypt_cbc(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, false, DES3_CBC);
+}
+
+s32 cvm_aes_encrypt_xts(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, true, AES_XTS);
+}
+
+s32 cvm_aes_decrypt_xts(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, false, AES_XTS);
+}
+
+s32 cvm_aes_encrypt_cbc(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, true, AES_CBC);
+}
+
+s32 cvm_aes_decrypt_cbc(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, false, AES_CBC);
+}
+
+s32 cvm_enc_dec_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+		       u32 keylen)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct cvm_enc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if ((keylen == 16) || (keylen == 24) || (keylen == 32)) {
+		ctx->key_len = keylen;
+		memcpy(ctx->enc_key, key, keylen);
+		return 0;
+	}
+	crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+	return -EINVAL;
+}
+
+s32 cvm_enc_dec_init(struct crypto_tfm *tfm)
+{
+	struct cvm_enc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	tfm->crt_ablkcipher.reqsize = sizeof(struct cvm_req_ctx) +
+					sizeof(struct ablkcipher_request);
+	/* Additional memory for ablkcipher_request is
+	 * allocated since the cryptd daemon uses
+	 * this memory for request_ctx information
+	 */
+
+	return 0;
+}
+
+void cvm_enc_dec_exit(struct crypto_tfm *tfm)
+{
+	return;
+}
+
+struct crypto_alg algs[] = { {
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = AES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
+	.cra_alignmask = 7,
+	.cra_priority = 4001,
+	.cra_name = "xts(aes)",
+	.cra_driver_name = "cavium-xts-aes",
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_u = {
+		.ablkcipher = {
+			.ivsize = AES_BLOCK_SIZE,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.setkey = cvm_enc_dec_setkey,
+			.encrypt = cvm_aes_encrypt_xts,
+			.decrypt = cvm_aes_decrypt_xts,
+		},
+	},
+	.cra_init = cvm_enc_dec_init,
+	.cra_exit = cvm_enc_dec_exit,
+	.cra_module = THIS_MODULE,
+}, {
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = AES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
+	.cra_alignmask = 7,
+	.cra_priority = 4001,
+	.cra_name = "cbc(aes)",
+	.cra_driver_name = "cavium-cbc-aes",
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_u = {
+		.ablkcipher = {
+			.ivsize = AES_BLOCK_SIZE,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.setkey = cvm_enc_dec_setkey,
+			.encrypt = cvm_aes_encrypt_cbc,
+			.decrypt = cvm_aes_decrypt_cbc,
+		},
+	},
+	.cra_init = cvm_enc_dec_init,
+	.cra_exit = cvm_enc_dec_exit,
+	.cra_module = THIS_MODULE,
+}, {
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct cvm_des3_ctx),
+	.cra_alignmask = 7,
+	.cra_priority = 4001,
+	.cra_name = "cbc(des3_ede)",
+	.cra_driver_name = "cavium-cbc-des3_ede",
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize = DES_BLOCK_SIZE,
+			.setkey = cvm_enc_dec_setkey,
+			.encrypt = cvm_des3_encrypt_cbc,
+			.decrypt = cvm_des3_decrypt_cbc,
+		},
+	},
+	.cra_init = cvm_enc_dec_init,
+	.cra_exit = cvm_enc_dec_exit,
+	.cra_module = THIS_MODULE,
+} };
+
+static inline s32 cav_register_algs(void)
+{
+	s32 err = 0;
+
+	err = crypto_register_algs(algs, ARRAY_SIZE(algs));
+	if (err) {
+		pr_err("Error in aes module init %d\n", err);
+		return -1;
+	}
+
+	return 0;
+}
+
+static inline void cav_unregister_algs(void)
+{
+	crypto_unregister_algs(algs, ARRAY_SIZE(algs));
+}
+
+s32 cvm_crypto_init(struct cpt_vf *cptvf)
+{
+	u32 dev_count;
+
+	dev_count = dev_handle.dev_count;
+	dev_handle.cdev[dev_count] = cptvf;
+	dev_handle.dev_count++;
+
+	if (!dev_count) {
+		if (cav_register_algs()) {
+			pr_err("Error in registering crypto algorithms\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+void cvm_crypto_exit(void)
+{
+	u32 dev_count;
+
+	dev_count = --dev_handle.dev_count;
+	if (!dev_count)
+		cav_unregister_algs();
+}
diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.h b/drivers/crypto/cavium/cpt/cptvf_algs.h
new file mode 100644
index 0000000..fcb287b
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.h
@@ -0,0 +1,110 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef _CPTVF_ALGS_H_
+#define _CPTVF_ALGS_H_
+
+#define MAX_DEVICES 16
+#define MAJOR_OP_FC 0x33
+#define MAX_ENC_KEY_SIZE 32
+#define MAX_HASH_KEY_SIZE 64
+#define MAX_KEY_SIZE (MAX_ENC_KEY_SIZE + MAX_HASH_KEY_SIZE)
+#define CONTROL_WORD_LEN 8
+
+#define DMA_MODE_FLAG(dma_mode) \
+	(((dma_mode) == DMA_GATHER_SCATTER) ? (1 << 7) : 0)
+
+enum req_type {
+	AE_CORE_REQ,
+	SE_CORE_REQ,
+};
+
+enum cipher_type {
+	DES3_CBC = 0x1,
+	DES3_ECB = 0x2,
+	AES_CBC = 0x3,
+	AES_ECB = 0x4,
+	AES_CFB = 0x5,
+	AES_CTR = 0x6,
+	AES_GCM = 0x7,
+	AES_XTS = 0x8
+};
+
+enum aes_type {
+	AES_128_BIT = 0x1,
+	AES_192_BIT = 0x2,
+	AES_256_BIT = 0x3
+};
+
+union encr_ctrl {
+	u64 flags;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 enc_cipher:4;
+		u64 reserved1:1;
+		u64 aes_key:2;
+		u64 iv_source:1;
+		u64 hash_type:4;
+		u64 reserved2:3;
+		u64 auth_input_type:1;
+		u64 mac_len:8;
+		u64 reserved3:8;
+		u64 encr_offset:16;
+		u64 iv_offset:8;
+		u64 auth_offset:8;
+#else
+		u64 auth_offset:8;
+		u64 iv_offset:8;
+		u64 encr_offset:16;
+		u64 reserved3:8;
+		u64 mac_len:8;
+		u64 auth_input_type:1;
+		u64 reserved2:3;
+		u64 hash_type:4;
+		u64 iv_source:1;
+		u64 aes_key:2;
+		u64 reserved1:1;
+		u64 enc_cipher:4;
+#endif
+	} e;
+};
+
+struct enc_context {
+	union encr_ctrl enc_ctrl;
+	u8  encr_key[32];
+	u8  encr_iv[16];
+};
+
+struct fchmac_context {
+	u8  ipad[64];
+	u8  opad[64]; /* or OPAD */
+};
+
+struct fc_context {
+	struct enc_context enc;
+	struct fchmac_context hmac;
+};
+
+struct cvm_enc_ctx {
+	u32 key_len;
+	u8 enc_key[MAX_KEY_SIZE];
+};
+
+struct cvm_des3_ctx {
+	u32 key_len;
+	u8 des3_key[MAX_KEY_SIZE];
+};
+
+struct cvm_req_ctx {
+	struct cpt_request_info cpt_req;
+	u64 control_word;
+	struct fc_context fctx;
+};
+
+u32 cptvf_do_request(void *cptvf, struct cpt_request_info *req);
+#endif /*_CPTVF_ALGS_H_*/
diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
new file mode 100644
index 0000000..79e5043
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -0,0 +1,971 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+
+#include "cptvf.h"
+
+#define DRV_NAME	"thunder-cptvf"
+#define DRV_VERSION	"1.0"
+
+struct cptvf_wqe {
+	struct tasklet_struct twork;
+	void *cptvf;
+	u32 qno;
+};
+
+struct cptvf_wqe_info {
+	struct cptvf_wqe vq_wqe[CPT_NUM_QS_PER_VF];
+};
+
+static void vq_work_handler(unsigned long data)
+{
+	struct cptvf_wqe_info *cwqe_info = (struct cptvf_wqe_info *)data;
+	struct cptvf_wqe *cwqe = &cwqe_info->vq_wqe[0];
+
+	vq_post_process(cwqe->cptvf, cwqe->qno);
+}
+
+static s32 init_worker_threads(struct cpt_vf *cptvf)
+{
+	struct pci_dev *pdev = cptvf->pdev;
+	struct cptvf_wqe_info *cwqe_info;
+	s32 i;
+
+	cwqe_info = kzalloc(sizeof(*cwqe_info), GFP_KERNEL);
+	if (!cwqe_info)
+		return -ENOMEM;
+
+	if (cptvf->nr_queues) {
+		dev_info(&pdev->dev, "Creating VQ worker threads (%d)\n",
+			 cptvf->nr_queues);
+	}
+
+	for (i = 0; i < cptvf->nr_queues; i++) {
+		tasklet_init(&cwqe_info->vq_wqe[i].twork, vq_work_handler,
+			     (u64)cwqe_info);
+		cwqe_info->vq_wqe[i].qno = i;
+		cwqe_info->vq_wqe[i].cptvf = cptvf;
+	}
+
+	cptvf->wqe_info = cwqe_info;
+
+	return 0;
+}
+
+static void cleanup_worker_threads(struct cpt_vf *cptvf)
+{
+	struct cptvf_wqe_info *cwqe_info;
+	struct pci_dev *pdev = cptvf->pdev;
+	s32 i;
+
+	cwqe_info = (struct cptvf_wqe_info *)cptvf->wqe_info;
+	if (!cwqe_info)
+		return;
+
+	if (cptvf->nr_queues) {
+		dev_info(&pdev->dev, "Cleaning VQ worker threads (%u)\n",
+			 cptvf->nr_queues);
+	}
+
+	for (i = 0; i < cptvf->nr_queues; i++)
+		tasklet_kill(&cwqe_info->vq_wqe[i].twork);
+
+	kzfree(cwqe_info);
+	cptvf->wqe_info = NULL;
+}
+
+static void free_pending_queues(struct pending_qinfo *pqinfo)
+{
+	s32 i;
+	struct pending_queue *queue;
+
+	for_each_pending_queue(pqinfo, queue, i) {
+		if (!queue->head)
+			continue;
+
+		/* free single queue */
+		kzfree((queue->head));
+
+		queue->front = 0;
+		queue->rear = 0;
+
+		return;
+	}
+
+	pqinfo->qlen = 0;
+	pqinfo->nr_queues = 0;
+}
+
+static s32 alloc_pending_queues(struct pending_qinfo *pqinfo, u32 qlen,
+				u32 nr_queues)
+{
+	u32 i;
+	size_t size;
+	s32 ret;
+	struct pending_queue *queue = NULL;
+
+	pqinfo->nr_queues = nr_queues;
+	pqinfo->qlen = qlen;
+
+	size = (qlen * sizeof(struct pending_entry));
+
+	for_each_pending_queue(pqinfo, queue, i) {
+		queue->head = kzalloc((size), GFP_KERNEL);
+		if (!queue->head) {
+			pr_err("pending Q (%d) allocation failed\n", i);
+			ret = -ENOMEM;
+			goto pending_qfail;
+		}
+
+		queue->front = 0;
+		queue->rear = 0;
+		atomic64_set((&queue->pending_count), (0));
+
+		/* init queue spin lock */
+		spin_lock_init(&queue->lock);
+	}
+
+	return 0;
+
+pending_qfail:
+	free_pending_queues(pqinfo);
+
+	return ret;
+}
+
+static s32 init_pending_queues(struct cpt_vf *cptvf, u32 qlen, u32 nr_queues)
+{
+	s32 ret;
+
+	if (!nr_queues)
+		return 0;
+
+	ret = alloc_pending_queues(&cptvf->pqinfo, qlen, nr_queues);
+	if (ret) {
+		pr_err("failed to setup pending queues (%u)\n", nr_queues);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void cleanup_pending_queues(struct cpt_vf *cptvf)
+{
+	struct pci_dev *pdev = cptvf->pdev;
+
+	if (!cptvf->nr_queues)
+		return;
+
+	dev_info(&pdev->dev, "Cleaning VQ pending queue (%u)\n",
+		 cptvf->nr_queues);
+	free_pending_queues(&cptvf->pqinfo);
+}
+
+static void free_command_queues(struct cpt_vf *cptvf,
+				struct command_qinfo *cqinfo)
+{
+	s32 i, j;
+	struct command_queue *queue = NULL;
+	struct command_chunk *chunk = NULL, *next = NULL;
+	struct pci_dev *pdev = cptvf->pdev;
+	struct hlist_node *node;
+
+	/* clean up for each queue */
+	for (i = 0; i < cptvf->nr_queues; i++) {
+		queue = &cqinfo->queue[i];
+		if (hlist_empty(&cqinfo->queue[i].chead))
+			continue;
+
+		hlist_for_each(node, &cqinfo->queue[i].chead) {
+			chunk = hlist_entry(node, struct command_chunk,
+					    nextchunk);
+			break;
+		}
+
+		for (j = 0; j < queue->nchunks; j++) {
+			if (j < queue->nchunks) {
+				node = node->next;
+				next = hlist_entry(node, struct command_chunk,
+						   nextchunk);
+			}
+
+			dma_free_coherent(&pdev->dev, chunk->size,
+					  chunk->head,
+					  chunk->dma_addr);
+			chunk->head = NULL;
+			chunk->dma_addr = 0;
+			hlist_del(&chunk->nextchunk);
+			kzfree(chunk);
+			chunk = next;
+		}
+		queue->nchunks = 0;
+		queue->idx = 0;
+	}
+
+	/* common cleanup */
+	cqinfo->cmd_size = 0;
+}
+
+static s32 alloc_command_queues(struct cpt_vf *cptvf,
+				struct command_qinfo *cqinfo, size_t cmd_size,
+				u32 qlen)
+{
+	s32 i;
+	size_t q_size;
+	struct command_queue *queue = NULL;
+	struct pci_dev *pdev = cptvf->pdev;
+
+	/* common init */
+	cqinfo->cmd_size = cmd_size;
+	/* Qsize in dwords, needed for SADDR config, 1-next chunk pointer */
+	cptvf->qsize = min(qlen, cqinfo->qchunksize) *
+			CPT_NEXT_CHUNK_PTR_SIZE + 1;
+	/* Qsize in bytes to create space for alignment */
+	q_size = qlen * cqinfo->cmd_size;
+
+	/* per queue initialization */
+	for (i = 0; i < cptvf->nr_queues; i++) {
+		size_t c_size = 0;
+		size_t rem_q_size = q_size;
+		struct command_chunk *curr = NULL, *first = NULL, *last = NULL;
+		u32 qcsize_bytes = cqinfo->qchunksize * cqinfo->cmd_size;
+
+		queue = &cqinfo->queue[i];
+		INIT_HLIST_HEAD(&cqinfo->queue[i].chead);
+		do {
+			curr = kzalloc(sizeof(*curr), GFP_KERNEL);
+			if (!curr)
+				goto cmd_qfail;
+
+			c_size = (rem_q_size > qcsize_bytes) ? qcsize_bytes :
+					rem_q_size;
+			curr->head = (u8 *)dma_zalloc_coherent(&pdev->dev,
+					  c_size + CPT_NEXT_CHUNK_PTR_SIZE,
+					  &curr->dma_addr, GFP_KERNEL);
+			if (!curr->head) {
+				pr_err("Command Q (%d) chunk (%d) allocation failed\n",
+				       i, queue->nchunks);
+				goto cmd_qfail;
+			}
+
+			curr->size = c_size;
+			if (queue->nchunks == 0) {
+				hlist_add_head(&curr->nextchunk,
+					       &cqinfo->queue[i].chead);
+				first = curr;
+			} else {
+				hlist_add_behind(&curr->nextchunk,
+						 &last->nextchunk);
+			}
+
+			queue->nchunks++;
+			rem_q_size -= c_size;
+			if (last)
+				*((u64 *)(&last->head[last->size])) = (u64)curr->dma_addr;
+
+			last = curr;
+		} while (rem_q_size);
+
+		/* Make the queue circular */
+		/* Tie back last chunk entry to head */
+		curr = first;
+		*((u64 *)(&last->head[last->size])) = (u64)curr->dma_addr;
+		last->nextchunk.next = &curr->nextchunk;
+		queue->qhead = curr;
+		spin_lock_init(&queue->lock);
+	}
+	return 0;
+
+cmd_qfail:
+	free_command_queues(cptvf, cqinfo);
+	return -ENOMEM;
+}
+
+static s32 init_command_queues(struct cpt_vf *cptvf, u32 qlen)
+{
+	s32 ret;
+
+	/* setup AE command queues */
+	ret = alloc_command_queues(cptvf, &cptvf->cqinfo, CPT_INST_SIZE,
+				   qlen);
+	if (ret) {
+		pr_err("failed to allocate AE command queues (%u)\n",
+		       cptvf->nr_queues);
+		return ret;
+	}
+
+	return ret;
+}
+
+static void cleanup_command_queues(struct cpt_vf *cptvf)
+{
+	struct pci_dev *pdev = cptvf->pdev;
+
+	if (!cptvf->nr_queues)
+		return;
+
+	dev_info(&pdev->dev, "Cleaning VQ command queue (%u)\n",
+		 cptvf->nr_queues);
+	free_command_queues(cptvf, &cptvf->cqinfo);
+}
+
+static void cptvf_sw_cleanup(struct cpt_vf *cptvf)
+{
+	cleanup_worker_threads(cptvf);
+	cleanup_pending_queues(cptvf);
+	cleanup_command_queues(cptvf);
+}
+
+static s32 cptvf_sw_init(struct cpt_vf *cptvf, u32 qlen, u32 nr_queues)
+{
+	s32 ret = 0;
+	u32 max_dev_queues = 0;
+
+	max_dev_queues = CPT_NUM_QS_PER_VF;
+	/* possible cpus */
+	nr_queues = min_t(u32, nr_queues, max_dev_queues);
+	cptvf->nr_queues = nr_queues;
+
+	ret = init_command_queues(cptvf, qlen);
+	if (ret) {
+		pr_err("Failed to setup command queues (%u)\n", nr_queues);
+		return ret;
+	}
+
+	ret = init_pending_queues(cptvf, qlen, nr_queues);
+	if (ret) {
+		pr_err("Failed to setup pending queues (%u)\n", nr_queues);
+		goto setup_pqfail;
+	}
+
+	/* Create worker threads for BH processing */
+	ret = init_worker_threads(cptvf);
+	if (ret) {
+		pr_err("Failed to setup worker threads\n");
+		goto init_work_fail;
+	}
+
+	return 0;
+
+init_work_fail:
+	cleanup_worker_threads(cptvf);
+	cleanup_pending_queues(cptvf);
+
+setup_pqfail:
+	cleanup_command_queues(cptvf);
+
+	return ret;
+}
+
+static inline s32 cptvf_get_node_id(struct pci_dev *pdev)
+{
+	u64 addr = pci_resource_start(pdev, 0);
+
+	return ((addr >> CPT_NODE_ID_SHIFT) & CPT_NODE_ID_MASK);
+}
+
+static void cptvf_disable_msix(struct cpt_vf *cptvf)
+{
+	if (cptvf->msix_enabled) {
+		pci_disable_msix(cptvf->pdev);
+		cptvf->msix_enabled = 0;
+	}
+}
+
+static s32 cptvf_enable_msix(struct cpt_vf *cptvf)
+{
+	s32 i, ret;
+
+	for (i = 0; i < CPT_VF_MSIX_VECTORS; i++)
+		cptvf->msix_entries[i].entry = i;
+
+	ret = pci_enable_msix(cptvf->pdev, cptvf->msix_entries,
+			      CPT_VF_MSIX_VECTORS);
+	if (ret) {
+		dev_err(&cptvf->pdev->dev, "Request for #%d msix vectors failed\n",
+			CPT_VF_MSIX_VECTORS);
+		return ret;
+	}
+
+	cptvf->msix_enabled = 1;
+	/* Mark MSIX enabled */
+	cptvf->flags |= CPT_FLAG_MSIX_ENABLED;
+
+	return 0;
+}
+
+static void cptvf_free_all_interrupts(struct cpt_vf *cptvf)
+{
+	s32 irq;
+
+	for (irq = 0; irq < CPT_VF_MSIX_VECTORS; irq++) {
+		if (cptvf->irq_allocated[irq])
+			irq_set_affinity_hint(cptvf->msix_entries[irq].vector,
+					      NULL);
+		free_cpumask_var(cptvf->affinity_mask[irq]);
+		free_irq(cptvf->msix_entries[irq].vector, cptvf);
+		cptvf->irq_allocated[irq] = false;
+	}
+}
+
+static void cptvf_write_vq_ctl(struct cpt_vf *cptvf, bool val)
+{
+	union cptx_vqx_ctl vqx_ctl;
+
+	vqx_ctl.u = cpt_read_csr64(cptvf->reg_base, CPTX_VQX_CTL(0, 0));
+	vqx_ctl.s.ena = val;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_CTL(0, 0), vqx_ctl.u);
+}
+
+void cptvf_write_vq_doorbell(struct cpt_vf *cptvf, u32 val)
+{
+	union cptx_vqx_doorbell vqx_dbell;
+
+	vqx_dbell.u = cpt_read_csr64(cptvf->reg_base,
+				     CPTX_VQX_DOORBELL(0, 0));
+	vqx_dbell.s.dbell_cnt = val * 8; /* Num of Instructions * 8 words */
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_DOORBELL(0, 0),
+			vqx_dbell.u);
+}
+
+static void cptvf_write_vq_inprog(struct cpt_vf *cptvf, u8 val)
+{
+	union cptx_vqx_inprog vqx_inprg;
+
+	vqx_inprg.u = cpt_read_csr64(cptvf->reg_base, CPTX_VQX_INPROG(0, 0));
+	vqx_inprg.s.inflight = val;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_INPROG(0, 0), vqx_inprg.u);
+}
+
+static void cptvf_write_vq_done_numwait(struct cpt_vf *cptvf, u32 val)
+{
+	union cptx_vqx_done_wait vqx_dwait;
+
+	vqx_dwait.u = cpt_read_csr64(cptvf->reg_base,
+				     CPTX_VQX_DONE_WAIT(0, 0));
+	vqx_dwait.s.num_wait = val;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_DONE_WAIT(0, 0),
+			vqx_dwait.u);
+}
+
+static void cptvf_write_vq_done_timewait(struct cpt_vf *cptvf, u16 time)
+{
+	union cptx_vqx_done_wait vqx_dwait;
+
+	vqx_dwait.u = cpt_read_csr64(cptvf->reg_base,
+				     CPTX_VQX_DONE_WAIT(0, 0));
+	vqx_dwait.s.time_wait = time;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_DONE_WAIT(0, 0),
+			vqx_dwait.u);
+}
+
+static void cptvf_enable_swerr_interrupts(struct cpt_vf *cptvf)
+{
+	union cptx_vqx_misc_ena_w1s vqx_misc_ena;
+
+	vqx_misc_ena.u = cpt_read_csr64(cptvf->reg_base,
+					CPTX_VQX_MISC_ENA_W1S(0, 0));
+	/* Set mbox(0) interupts for the requested vf */
+	vqx_misc_ena.s.swerr = 1;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_MISC_ENA_W1S(0, 0),
+			vqx_misc_ena.u);
+}
+
+static void cptvf_enable_mbox_interrupts(struct cpt_vf *cptvf)
+{
+	union cptx_vqx_misc_ena_w1s vqx_misc_ena;
+
+	vqx_misc_ena.u = cpt_read_csr64(cptvf->reg_base,
+					CPTX_VQX_MISC_ENA_W1S(0, 0));
+	/* Set mbox(0) interupts for the requested vf */
+	vqx_misc_ena.s.mbox = 1;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_MISC_ENA_W1S(0, 0),
+			vqx_misc_ena.u);
+}
+
+static void cptvf_enable_done_interrupts(struct cpt_vf *cptvf)
+{
+	union cptx_vqx_done_ena_w1s vqx_done_ena;
+
+	vqx_done_ena.u = cpt_read_csr64(cptvf->reg_base,
+					CPTX_VQX_DONE_ENA_W1S(0, 0));
+	/* Set DONE interrupt for the requested vf */
+	vqx_done_ena.s.done = 1;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_DONE_ENA_W1S(0, 0),
+			vqx_done_ena.u);
+}
+
+static void cptvf_clear_dovf_intr(struct cpt_vf *cptvf)
+{
+	union cptx_vqx_misc_int vqx_misc_int;
+
+	vqx_misc_int.u = cpt_read_csr64(cptvf->reg_base,
+					CPTX_VQX_MISC_INT(0, 0));
+	/* W1C for the VF */
+	vqx_misc_int.s.dovf = 1;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_MISC_INT(0, 0),
+			vqx_misc_int.u);
+}
+
+static void cptvf_clear_irde_intr(struct cpt_vf *cptvf)
+{
+	union cptx_vqx_misc_int vqx_misc_int;
+
+	vqx_misc_int.u = cpt_read_csr64(cptvf->reg_base,
+					CPTX_VQX_MISC_INT(0, 0));
+	/* W1C for the VF */
+	vqx_misc_int.s.irde = 1;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_MISC_INT(0, 0),
+			vqx_misc_int.u);
+}
+
+static void cptvf_clear_nwrp_intr(struct cpt_vf *cptvf)
+{
+	union cptx_vqx_misc_int vqx_misc_int;
+
+	vqx_misc_int.u = cpt_read_csr64(cptvf->reg_base,
+					CPTX_VQX_MISC_INT(0, 0));
+	/* W1C for the VF */
+	vqx_misc_int.s.nwrp = 1;
+	cpt_write_csr64(cptvf->reg_base,
+			CPTX_VQX_MISC_INT(0, 0), vqx_misc_int.u);
+}
+
+static void cptvf_clear_mbox_intr(struct cpt_vf *cptvf)
+{
+	union cptx_vqx_misc_int vqx_misc_int;
+
+	vqx_misc_int.u = cpt_read_csr64(cptvf->reg_base,
+					CPTX_VQX_MISC_INT(0, 0));
+	/* W1C for the VF */
+	vqx_misc_int.s.mbox = 1;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_MISC_INT(0, 0),
+			vqx_misc_int.u);
+}
+
+static void cptvf_clear_swerr_intr(struct cpt_vf *cptvf)
+{
+	union cptx_vqx_misc_int vqx_misc_int;
+
+	vqx_misc_int.u = cpt_read_csr64(cptvf->reg_base,
+					CPTX_VQX_MISC_INT(0, 0));
+	/* W1C for the VF */
+	vqx_misc_int.s.swerr = 1;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_MISC_INT(0, 0),
+			vqx_misc_int.u);
+}
+
+static u64 cptvf_read_vf_misc_intr_status(struct cpt_vf *cptvf)
+{
+	return cpt_read_csr64(cptvf->reg_base, CPTX_VQX_MISC_INT(0, 0));
+}
+
+static irqreturn_t cptvf_misc_intr_handler(s32 irq, void *cptvf_irq)
+{
+	struct cpt_vf *cptvf = (struct cpt_vf *)cptvf_irq;
+	u64 intr;
+
+	intr = cptvf_read_vf_misc_intr_status(cptvf);
+	/*Check for MISC interrupt types*/
+	if (likely(intr & CPT_VF_INTR_MBOX_MASK)) {
+		pr_err("Mailbox interrupt 0x%llx on CPT VF %d\n",
+		       intr, cptvf->vfid);
+		cptvf_handle_mbox_intr(cptvf);
+		cptvf_clear_mbox_intr(cptvf);
+	} else if (unlikely(intr & CPT_VF_INTR_DOVF_MASK)) {
+		cptvf_clear_dovf_intr(cptvf);
+		/*Clear doorbell count*/
+		cptvf_write_vq_doorbell(cptvf, 0);
+		pr_err("Doorbell overflow error interrupt 0x%llx on CPT VF %d\n",
+		       intr, cptvf->vfid);
+	} else if (unlikely(intr & CPT_VF_INTR_IRDE_MASK)) {
+		cptvf_clear_irde_intr(cptvf);
+		pr_err("Instruction NCB read error interrupt 0x%llx on CPT VF %d\n",
+		       intr, cptvf->vfid);
+	} else if (unlikely(intr & CPT_VF_INTR_NWRP_MASK)) {
+		cptvf_clear_nwrp_intr(cptvf);
+		pr_err("NCB response write error interrupt 0x%llx on CPT VF %d\n",
+		       intr, cptvf->vfid);
+	} else if (unlikely(intr & CPT_VF_INTR_SERR_MASK)) {
+		cptvf_clear_swerr_intr(cptvf);
+		pr_err("Software error interrupt 0x%llx on CPT VF %d\n",
+		       intr, cptvf->vfid);
+	} else {
+		pr_err("Unhandled interrupt in CPT VF %d\n", cptvf->vfid);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static inline struct cptvf_wqe *get_cptvf_vq_wqe(struct cpt_vf *cptvf,
+						 s32 qno)
+{
+	struct cptvf_wqe_info *nwqe_info;
+
+	if (unlikely(qno >= cptvf->nr_queues))
+		return NULL;
+	nwqe_info = (struct cptvf_wqe_info *)cptvf->wqe_info;
+
+	return &nwqe_info->vq_wqe[qno];
+}
+
+static inline u32 cptvf_read_vq_done_count(struct cpt_vf *cptvf)
+{
+	union cptx_vqx_done vqx_done;
+
+	vqx_done.u = cpt_read_csr64(cptvf->reg_base, CPTX_VQX_DONE(0, 0));
+	return vqx_done.s.done;
+}
+
+static inline void cptvf_write_vq_done_ack(struct cpt_vf *cptvf,
+					   u32 ackcnt)
+{
+	union cptx_vqx_done_ack vqx_dack_cnt;
+
+	vqx_dack_cnt.u = cpt_read_csr64(cptvf->reg_base,
+					CPTX_VQX_DONE_ACK(0, 0));
+	vqx_dack_cnt.s.done_ack = ackcnt;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_DONE_ACK(0, 0),
+			vqx_dack_cnt.u);
+}
+
+static irqreturn_t cptvf_done_intr_handler(s32 irq, void *cptvf_irq)
+{
+	struct cpt_vf *cptvf = (struct cpt_vf *)cptvf_irq;
+	/* Read the number of completions */
+	u32 intr = cptvf_read_vq_done_count(cptvf);
+
+	if (intr) {
+		struct cptvf_wqe *wqe;
+
+		/* Acknowledge the number of
+		 * scheduled completions for processing
+		 */
+		cptvf_write_vq_done_ack(cptvf, intr);
+		wqe = get_cptvf_vq_wqe(cptvf, 0);
+		if (unlikely(!wqe)) {
+			pr_err("No work to schedule for VF (%d)",
+			       cptvf->vfid);
+			return 1;
+		}
+		tasklet_hi_schedule(&wqe->twork);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static s32 cptvf_register_misc_intr(struct cpt_vf *cptvf)
+{
+	s32 ret;
+	struct device *dev = &cptvf->pdev->dev;
+
+	/* Register misc interrupt handlers */
+	ret = request_irq(cptvf->msix_entries[CPT_VF_INT_VEC_E_MISC].vector,
+			  cptvf_misc_intr_handler, 0, "CPT VF misc intr",
+			  cptvf);
+	if (ret)
+		goto fail;
+
+	cptvf->irq_allocated[CPT_VF_INT_VEC_E_MISC] = true;
+
+	/* Enable mailbox interrupt */
+	cptvf_enable_mbox_interrupts(cptvf);
+	cptvf_enable_swerr_interrupts(cptvf);
+
+	return 0;
+
+fail:
+	dev_err(dev, "Request misc irq failed");
+	cptvf_free_all_interrupts(cptvf);
+	return ret;
+}
+
+static s32 cptvf_register_done_intr(struct cpt_vf *cptvf)
+{
+	s32 ret;
+	struct device *dev = &cptvf->pdev->dev;
+
+	/* Register DONE interrupt handlers */
+	ret = request_irq(cptvf->msix_entries[CPT_VF_INT_VEC_E_DONE].vector,
+			  cptvf_done_intr_handler, 0, "CPT VF done intr",
+			  cptvf);
+	if (ret)
+		goto fail;
+
+	cptvf->irq_allocated[CPT_VF_INT_VEC_E_DONE] = true;
+
+	/* Enable mailbox interrupt */
+	cptvf_enable_done_interrupts(cptvf);
+	return 0;
+
+fail:
+	dev_err(dev, "Request done irq failed\n");
+	cptvf_free_all_interrupts(cptvf);
+	return ret;
+}
+
+static void cptvf_unregister_interrupts(struct cpt_vf *cptvf)
+{
+	cptvf_free_all_interrupts(cptvf);
+	cptvf_disable_msix(cptvf);
+}
+
+static void cptvf_set_irq_affinity(struct cpt_vf *cptvf)
+{
+	s32 vec, cpu;
+	s32 irqnum;
+
+	for (vec = 0; vec < CPT_VF_MSIX_VECTORS; vec++) {
+		if (!cptvf->irq_allocated[vec])
+			continue;
+
+		if (!zalloc_cpumask_var(&cptvf->affinity_mask[vec],
+					GFP_KERNEL)) {
+			pr_err("Allocation failed for affinity_mask for VF %d",
+			       cptvf->vfid);
+			return;
+		}
+
+		cpu = cptvf->vfid % num_online_cpus();
+		cpumask_set_cpu(cpumask_local_spread(cpu, cptvf->node),
+				cptvf->affinity_mask[vec]);
+		irqnum = cptvf->msix_entries[vec].vector;
+		irq_set_affinity_hint(irqnum, cptvf->affinity_mask[vec]);
+	}
+}
+
+static void cptvf_write_vq_saddr(struct cpt_vf *cptvf, u64 val)
+{
+	union cptx_vqx_saddr vqx_saddr;
+
+	vqx_saddr.u = val;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_SADDR(0, 0), vqx_saddr.u);
+}
+
+void cptvf_device_init(struct cpt_vf *cptvf)
+{
+	u64 base_addr = 0;
+
+	/* Disable the VQ */
+	cptvf_write_vq_ctl(cptvf, 0);
+	/* Reset the doorbell */
+	cptvf_write_vq_doorbell(cptvf, 0);
+	/* Clear inflight */
+	cptvf_write_vq_inprog(cptvf, 0);
+	/* Write VQ SADDR */
+	/* TODO: for now only one queue, so hard coded */
+	base_addr = (u64)(cptvf->cqinfo.queue[0].qhead->dma_addr);
+	cptvf_write_vq_saddr(cptvf, base_addr);
+	/* Configure timerhold / coalescence */
+	cptvf_write_vq_done_timewait(cptvf, CPT_TIMER_THOLD);
+	cptvf_write_vq_done_numwait(cptvf, 1);
+	/* Enable the VQ */
+	cptvf_write_vq_ctl(cptvf, 1);
+	/* Flag the VF ready */
+	cptvf->flags |= CPT_FLAG_DEVICE_READY;
+}
+
+static s32 cptvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct cpt_vf *cptvf;
+	s32    err;
+
+	cptvf = devm_kzalloc(dev, sizeof(struct cpt_vf), GFP_KERNEL);
+	if (!cptvf)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, cptvf);
+	cptvf->pdev = pdev;
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(dev, "Failed to enable PCI device\n");
+		pci_set_drvdata(pdev, NULL);
+		return err;
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		dev_err(dev, "PCI request regions failed 0x%x\n", err);
+		goto cptvf_err_disable_device;
+	}
+	/* Mark as VF driver */
+	cptvf->flags |= CPT_FLAG_VF_DRIVER;
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
+	if (err) {
+		dev_err(dev, "Unable to get usable DMA configuration\n");
+		goto cptvf_err_release_regions;
+	}
+
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));
+	if (err) {
+		dev_err(dev, "Unable to get 48-bit DMA for consistent allocations\n");
+		goto cptvf_err_release_regions;
+	}
+
+	/* MAP PF's configuration registers */
+	cptvf->reg_base = pcim_iomap(pdev, 0, 0);
+	if (!cptvf->reg_base) {
+		dev_err(dev, "Cannot map config register space, aborting\n");
+		err = -ENOMEM;
+		goto cptvf_err_release_regions;
+	}
+
+	cptvf->node = cptvf_get_node_id(pdev);
+	/* Enable MSI-X */
+	err = cptvf_enable_msix(cptvf);
+	if (err) {
+		dev_err(dev, "cptvf_enable_msix() failed");
+		goto cptvf_err_release_regions;
+	}
+
+	/* Register mailbox interrupts */
+	cptvf_register_misc_intr(cptvf);
+
+	/* Check ready with PF */
+	/* Gets chip ID / device Id from PF if ready */
+	err = cptvf_check_pf_ready(cptvf);
+	if (err) {
+		dev_err(dev, "PF not responding to READY msg");
+		err = -EBUSY;
+		goto cptvf_err_release_regions;
+	}
+
+	/* CPT VF software resources initialization */
+	cptvf->cqinfo.qchunksize = CPT_CMD_QCHUNK_SIZE;
+	err = cptvf_sw_init(cptvf, CPT_CMD_QLEN, CPT_NUM_QS_PER_VF);
+	if (err) {
+		dev_err(dev, "cptvf_sw_init() failed");
+		goto cptvf_err_release_regions;
+	}
+	/* Convey VQ LEN to PF */
+	err = cptvf_send_vq_size_msg(cptvf);
+	if (err) {
+		dev_err(dev, "PF not responding to QLEN msg");
+		err = -EBUSY;
+		goto cptvf_err_release_regions;
+	}
+
+	/* CPT VF device initialization */
+	cptvf_device_init(cptvf);
+	/* Send msg to PF to assign currnet Q to required group */
+	cptvf->vfgrp = 1;
+	err = cptvf_send_vf_to_grp_msg(cptvf);
+	if (err) {
+		dev_err(dev, "PF not responding to VF_GRP msg");
+		err = -EBUSY;
+		goto cptvf_err_release_regions;
+	}
+
+	cptvf->priority = 1;
+	err = cptvf_send_vf_priority_msg(cptvf);
+	if (err) {
+		dev_err(dev, "PF not responding to VF_PRIO msg");
+		err = -EBUSY;
+		goto cptvf_err_release_regions;
+	}
+	/* Register DONE interrupts */
+	err = cptvf_register_done_intr(cptvf);
+	if (err)
+		goto cptvf_err_release_regions;
+
+	/* Set irq affinity masks */
+	cptvf_set_irq_affinity(cptvf);
+	/* Convey UP to PF */
+	err = cptvf_send_vf_up(cptvf);
+	if (err) {
+		dev_err(dev, "PF not responding to UP msg");
+		err = -EBUSY;
+		goto cptvf_up_fail;
+	}
+	err = cvm_crypto_init(cptvf);
+	if (err) {
+		dev_err(dev, "Algorithm register failed\n");
+		err = -EBUSY;
+		goto cptvf_up_fail;
+	}
+	return 0;
+
+cptvf_up_fail:
+	cptvf_unregister_interrupts(cptvf);
+cptvf_err_release_regions:
+	pci_release_regions(pdev);
+cptvf_err_disable_device:
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+
+	return err;
+}
+
+static void cptvf_remove(struct pci_dev *pdev)
+{
+	struct cpt_vf *cptvf = pci_get_drvdata(pdev);
+
+	if (!cptvf)
+		pr_err("Invalid CPT-VF device\n");
+
+	/* Convey DOWN to PF */
+	if (cptvf_send_vf_down(cptvf)) {
+		pr_err("PF not responding to DOWN msg");
+	} else {
+		cptvf_unregister_interrupts(cptvf);
+		cptvf_sw_cleanup(cptvf);
+		pci_set_drvdata(pdev, NULL);
+		pci_release_regions(pdev);
+		pci_disable_device(pdev);
+		cvm_crypto_exit();
+	}
+}
+
+static void cptvf_shutdown(struct pci_dev *pdev)
+{
+	cptvf_remove(pdev);
+}
+
+/* Supported devices */
+static const struct pci_device_id cptvf_id_table[] = {
+	{PCI_VDEVICE(CAVIUM, CPT_81XX_PCI_VF_DEVICE_ID), 0},
+	{ 0, }  /* end of table */
+};
+
+static struct pci_driver cptvf_pci_driver = {
+	.name = DRV_NAME,
+	.id_table = cptvf_id_table,
+	.probe = cptvf_probe,
+	.remove = cptvf_remove,
+	.shutdown = cptvf_shutdown,
+};
+
+static s32 __init cptvf_init_module(void)
+{
+	s32 ret = -1;
+
+	pr_info("%s, ver %s\n", DRV_NAME, DRV_VERSION);
+
+	ret = pci_register_driver(&cptvf_pci_driver);
+	if (ret)
+		pr_err("pci_register_driver() failed");
+
+	return ret;
+}
+
+static void __exit cptvf_cleanup_module(void)
+{
+	pci_unregister_driver(&cptvf_pci_driver);
+}
+
+module_init(cptvf_init_module);
+module_exit(cptvf_cleanup_module);
+
+MODULE_AUTHOR("George Cherian <george.cherian@cavium.com>, Murthy Nidadavolu");
+MODULE_DESCRIPTION("Cavium Thunder CPT Virtual Function Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(DRV_VERSION);
+MODULE_DEVICE_TABLE(pci, cptvf_id_table);
diff --git a/drivers/crypto/cavium/cpt/cptvf_mbox.c b/drivers/crypto/cavium/cpt/cptvf_mbox.c
new file mode 100644
index 0000000..7a8964b
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf_mbox.c
@@ -0,0 +1,205 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include "cptvf.h"
+
+static void cptvf_send_msg_to_pf(struct cpt_vf *cptvf, struct cpt_mbox *mbx)
+{
+	/* Writing mbox(1) causes interrupt */
+	cpt_write_csr64(cptvf->reg_base, CPTX_VFX_PF_MBOXX(0, 0, 0),
+			mbx->msg);
+	cpt_write_csr64(cptvf->reg_base, CPTX_VFX_PF_MBOXX(0, 0, 1),
+			mbx->data);
+}
+
+/* ACKs PF's mailbox message
+ */
+void cptvf_mbox_send_ack(struct cpt_vf *cptvf, struct cpt_mbox *mbx)
+{
+	mbx->msg = CPT_MBOX_MSG_TYPE_ACK;
+	cptvf_send_msg_to_pf(cptvf, mbx);
+}
+
+/* NACKs PF's mailbox message that VF is not able to
+ * complete the action
+ */
+void cptvf_mbox_send_nack(struct cpt_vf *cptvf, struct cpt_mbox *mbx)
+{
+	mbx->msg = CPT_MBOX_MSG_TYPE_NACK;
+	cptvf_send_msg_to_pf(cptvf, mbx);
+}
+
+/* Interrupt handler to handle mailbox messages from VFs */
+void cptvf_handle_mbox_intr(struct cpt_vf *cptvf)
+{
+	struct cpt_mbox mbx = {};
+
+	/*
+	 * MBOX[0] contains msg
+	 * MBOX[1] contains data
+	 */
+	mbx.msg  = cpt_read_csr64(cptvf->reg_base, CPTX_VFX_PF_MBOXX(0, 0, 0));
+	mbx.data = cpt_read_csr64(cptvf->reg_base, CPTX_VFX_PF_MBOXX(0, 0, 1));
+	dev_dbg(&cptvf->pdev->dev, "%s: Mailbox msg 0x%llx from PF\n",
+		__func__, mbx.msg);
+	switch (mbx.msg) {
+	case CPT_MSG_READY:
+	{
+		cptvf->pf_acked = true;
+		cptvf->vfid = mbx.data;
+		dev_dbg(&cptvf->pdev->dev, "Received VFID %d\n", cptvf->vfid);
+		break;
+	}
+	case CPT_MSG_QBIND_GRP:
+		cptvf->pf_acked = true;
+		cptvf->vftype = mbx.data;
+		dev_dbg(&cptvf->pdev->dev, "VF %d type %s group %d\n",
+			cptvf->vfid, ((mbx.data == SE_TYPES) ? "SE" : "AE"),
+			cptvf->vfgrp);
+		break;
+	case CPT_MBOX_MSG_TYPE_ACK:
+		cptvf->pf_acked = true;
+		break;
+	case CPT_MBOX_MSG_TYPE_NACK:
+		cptvf->pf_nacked = true;
+		break;
+	default:
+		dev_err(&cptvf->pdev->dev, "Invalid msg from PF, msg 0x%llx\n",
+			mbx.msg);
+		break;
+	}
+}
+
+static s32 cptvf_send_msg_to_pf_timeout(struct cpt_vf *cptvf,
+					struct cpt_mbox *mbx)
+{
+	s32 timeout = CPT_MBOX_MSG_TIMEOUT;
+	s32 sleep = 10;
+
+	cptvf->pf_acked = false;
+	cptvf->pf_nacked = false;
+	cptvf_send_msg_to_pf(cptvf, mbx);
+	/* Wait for previous message to be acked, timeout 2sec */
+	while (!cptvf->pf_acked) {
+		if (cptvf->pf_nacked)
+			return -EINVAL;
+		msleep(sleep);
+		if (cptvf->pf_acked)
+			break;
+		timeout -= sleep;
+		if (!timeout) {
+			dev_err(&cptvf->pdev->dev, "PF didn't ack to mbox msg %llx from VF%u\n",
+				(mbx->msg & 0xFF), cptvf->vfid);
+			return -EBUSY;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Checks if VF is able to comminicate with PF
+ * and also gets the CPT number this VF is associated to.
+ */
+s32 cptvf_check_pf_ready(struct cpt_vf *cptvf)
+{
+	struct cpt_mbox mbx = {};
+
+	mbx.msg = CPT_MSG_READY;
+	if (cptvf_send_msg_to_pf_timeout(cptvf, &mbx)) {
+		dev_err(&cptvf->pdev->dev, "PF didn't respond to READY msg\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Communicate VQs size to PF to program CPT(0)_PF_Q(0-15)_CTL of the VF.
+ * Must be ACKed.
+ */
+s32 cptvf_send_vq_size_msg(struct cpt_vf *cptvf)
+{
+	struct cpt_mbox mbx = {};
+
+	mbx.msg = CPT_MSG_QLEN;
+	mbx.data = cptvf->qsize;
+	if (cptvf_send_msg_to_pf_timeout(cptvf, &mbx)) {
+		dev_err(&cptvf->pdev->dev, "PF didn't respond to vq_size msg\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Communicate VF group required to PF and get the VQ binded to that group
+ */
+s32 cptvf_send_vf_to_grp_msg(struct cpt_vf *cptvf)
+{
+	struct cpt_mbox mbx = {};
+
+	mbx.msg = CPT_MSG_QBIND_GRP;
+	/* Convey group of the VF */
+	mbx.data = cptvf->vfgrp;
+	if (cptvf_send_msg_to_pf_timeout(cptvf, &mbx)) {
+		dev_err(&cptvf->pdev->dev, "PF didn't respond to vf_type msg\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Communicate VF group required to PF and get the VQ binded to that group
+ */
+s32 cptvf_send_vf_priority_msg(struct cpt_vf *cptvf)
+{
+	struct cpt_mbox mbx = {};
+
+	mbx.msg = CPT_MSG_VQ_PRIORITY;
+	/* Convey group of the VF */
+	mbx.data = cptvf->priority;
+	if (cptvf_send_msg_to_pf_timeout(cptvf, &mbx)) {
+		dev_err(&cptvf->pdev->dev, "PF didn't respond to vf_type msg\n");
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * Communicate to PF that VF is UP and running
+ */
+s32 cptvf_send_vf_up(struct cpt_vf *cptvf)
+{
+	struct cpt_mbox mbx = {};
+
+	mbx.msg = CPT_MSG_VF_UP;
+	if (cptvf_send_msg_to_pf_timeout(cptvf, &mbx)) {
+		dev_err(&cptvf->pdev->dev, "PF didn't respond to UP msg\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Communicate to PF that VF is DOWN and running
+ */
+s32 cptvf_send_vf_down(struct cpt_vf *cptvf)
+{
+	struct cpt_mbox mbx = {};
+
+	mbx.msg = CPT_MSG_VF_DOWN;
+	if (cptvf_send_msg_to_pf_timeout(cptvf, &mbx)) {
+		dev_err(&cptvf->pdev->dev, "PF didn't respond to DOWN msg\n");
+		return 1;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
new file mode 100644
index 0000000..c8d0e01
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -0,0 +1,581 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include "cptvf.h"
+#include "request_manager.h"
+
+/**
+ * get_free_pending_entry - get free entry from pending queue
+ * @param pqinfo: pending_qinfo structure
+ * @param qno: queue number
+ */
+static struct pending_entry *get_free_pending_entry(struct pending_queue *q,
+						    s32 qlen)
+{
+	struct pending_entry *ent = NULL;
+
+	ent = &q->head[q->rear];
+	if (unlikely(ent->busy)) {
+		ent = NULL;
+		goto no_free_entry;
+	}
+
+	q->rear++;
+	if (unlikely(q->rear == qlen))
+		q->rear = 0;
+
+no_free_entry:
+	return ent;
+}
+
+static inline void pending_queue_inc_front(struct pending_qinfo *pqinfo,
+					   s32 qno)
+{
+	struct pending_queue *queue = &pqinfo->queue[qno];
+
+	queue->front++;
+	if (unlikely(queue->front == pqinfo->qlen))
+		queue->front = 0;
+}
+
+static s32 setup_sgio_components(struct cpt_vf *cptvf, struct buf_ptr *list,
+				 s32 buf_count, u8 *buffer)
+{
+	s32 ret = 0, i, j;
+	s32 components;
+	struct sglist_component *sg_ptr = NULL;
+	struct pci_dev *pdev = cptvf->pdev;
+
+	if (unlikely(!list)) {
+		pr_err("Input List pointer is NULL\n");
+		ret = -EFAULT;
+		return ret;
+	}
+
+	for (i = 0; i < buf_count; i++) {
+		if (likely(list[i].vptr)) {
+			list[i].dma_addr = dma_map_single(&pdev->dev,
+							  list[i].vptr,
+							  list[i].size,
+							  DMA_BIDIRECTIONAL);
+			if (unlikely(dma_mapping_error(&pdev->dev,
+						       list[i].dma_addr))) {
+				pr_err("DMA map kernel buffer failed for component: %d\n",
+				       i);
+				ret = -EIO;
+				goto sg_cleanup;
+			}
+		}
+	}
+
+	components = buf_count / 4;
+	sg_ptr = (struct sglist_component *)buffer;
+	for (i = 0; i < components; i++) {
+		sg_ptr->u.s.len0 = cpu_to_be16(list[i * 4 + 0].size);
+		sg_ptr->u.s.len1 = cpu_to_be16(list[i * 4 + 1].size);
+		sg_ptr->u.s.len2 = cpu_to_be16(list[i * 4 + 2].size);
+		sg_ptr->u.s.len3 = cpu_to_be16(list[i * 4 + 3].size);
+		sg_ptr->ptr0 = cpu_to_be64(list[i * 4 + 0].dma_addr);
+		sg_ptr->ptr1 = cpu_to_be64(list[i * 4 + 1].dma_addr);
+		sg_ptr->ptr2 = cpu_to_be64(list[i * 4 + 2].dma_addr);
+		sg_ptr->ptr3 = cpu_to_be64(list[i * 4 + 3].dma_addr);
+		sg_ptr++;
+	}
+
+	components = buf_count % 4;
+
+	switch (components) {
+	case 3:
+		sg_ptr->u.s.len2 = cpu_to_be16(list[i * 4 + 2].size);
+		sg_ptr->ptr2 = cpu_to_be64(list[i * 4 + 2].dma_addr);
+		/* Fall through */
+	case 2:
+		sg_ptr->u.s.len1 = cpu_to_be16(list[i * 4 + 1].size);
+		sg_ptr->ptr1 = cpu_to_be64(list[i * 4 + 1].dma_addr);
+		/* Fall through */
+	case 1:
+		sg_ptr->u.s.len0 = cpu_to_be16(list[i * 4 + 0].size);
+		sg_ptr->ptr0 = cpu_to_be64(list[i * 4 + 0].dma_addr);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+
+sg_cleanup:
+	for (j = 0; j < i; j++) {
+		if (list[j].dma_addr) {
+			dma_unmap_single(&pdev->dev, list[i].dma_addr,
+					 list[i].size, DMA_BIDIRECTIONAL);
+		}
+
+		list[j].dma_addr = 0;
+	}
+
+	return ret;
+}
+
+static inline s32 setup_sgio_list(struct cpt_vf *cptvf,
+				  struct cpt_info_buffer *info,
+				  struct cpt_request_info *req)
+{
+	u16 g_sz_bytes = 0, s_sz_bytes = 0;
+	s32 ret = 0;
+	struct pci_dev *pdev = cptvf->pdev;
+
+	if (req->incnt > MAX_SG_IN_CNT || req->outcnt > MAX_SG_OUT_CNT) {
+		pr_err("Requestes SG components are higher than supported\n");
+		ret = -EINVAL;
+		goto  scatter_gather_clean;
+	}
+
+	/* Setup gather (input) components */
+	g_sz_bytes = ((req->incnt + 3) / 4) * sizeof(struct sglist_component);
+	info->gather_components = kzalloc((g_sz_bytes), GFP_KERNEL);
+	if (!info->gather_components) {
+		ret = -ENOMEM;
+		goto  scatter_gather_clean;
+	}
+
+	ret = setup_sgio_components(cptvf, req->in,
+				    req->incnt,
+				    info->gather_components);
+	if (ret) {
+		pr_err("Failed to setup gather list\n");
+		ret = -EFAULT;
+		goto  scatter_gather_clean;
+	}
+
+	/* Setup scatter (output) components */
+	s_sz_bytes = ((req->outcnt + 3) / 4) * sizeof(struct sglist_component);
+	info->scatter_components = kzalloc((s_sz_bytes), GFP_KERNEL);
+	if (!info->scatter_components) {
+		ret = -ENOMEM;
+		goto  scatter_gather_clean;
+	}
+
+	ret = setup_sgio_components(cptvf, req->out,
+				    req->outcnt,
+				    info->scatter_components);
+	if (ret) {
+		pr_err("Failed to setup gather list\n");
+		ret = -EFAULT;
+		goto  scatter_gather_clean;
+	}
+
+	/* Create and initialize DPTR */
+	info->dlen = g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
+	info->in_buffer = kzalloc((info->dlen), GFP_KERNEL);
+	if (!info->in_buffer) {
+		ret = -ENOMEM;
+		goto  scatter_gather_clean;
+	}
+
+	((u16 *)info->in_buffer)[0] = req->outcnt;
+	((u16 *)info->in_buffer)[1] = req->incnt;
+	((u16 *)info->in_buffer)[2] = 0;
+	((u16 *)info->in_buffer)[3] = 0;
+	*(u64 *)info->in_buffer = cpu_to_be64p((u64 *)info->in_buffer);
+
+	memcpy(&info->in_buffer[8], info->gather_components,
+	       g_sz_bytes);
+	memcpy(&info->in_buffer[8 + g_sz_bytes],
+	       info->scatter_components, s_sz_bytes);
+
+	info->dptr_baddr = dma_map_single(&pdev->dev,
+					  (void *)info->in_buffer,
+					  info->dlen,
+					  DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&pdev->dev, info->dptr_baddr)) {
+		pr_err("Mapping DPTR Failed %d\n", info->dlen);
+		ret = -EIO;
+		goto  scatter_gather_clean;
+	}
+
+	/* Create and initialize RPTR */
+	info->out_buffer = kzalloc((COMPLETION_CODE_SIZE), GFP_KERNEL);
+	if (!info->out_buffer) {
+		ret = -ENOMEM;
+		goto  scatter_gather_clean;
+	}
+
+	*((u64 *)info->out_buffer) = ~((u64)COMPLETION_CODE_INIT);
+	info->alternate_caddr = (u64 *)info->out_buffer;
+	info->rptr_baddr = dma_map_single(&pdev->dev,
+					  (void *)info->out_buffer,
+					  COMPLETION_CODE_SIZE,
+					  DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&pdev->dev, info->rptr_baddr)) {
+		pr_err("Mapping RPTR Failed %d\n", COMPLETION_CODE_SIZE);
+		ret = -EIO;
+		goto  scatter_gather_clean;
+	}
+
+	return 0;
+
+scatter_gather_clean:
+	return ret;
+}
+
+s32 send_cpt_command(struct cpt_vf *cptvf, union cpt_inst_s *cmd,
+		     u32 qno)
+{
+	struct command_qinfo *qinfo = NULL;
+	struct command_queue *queue;
+	struct command_chunk *chunk;
+	u8 *ent;
+	s32 ret = 0;
+
+	if (unlikely(qno >= cptvf->nr_queues)) {
+		pr_err("Invalid queue (qno: %d, nr_queues: %d)\n",
+		       qno, cptvf->nr_queues);
+		return -EINVAL;
+	}
+
+	qinfo = &cptvf->cqinfo;
+	queue = &qinfo->queue[qno];
+	/* lock commad queue */
+	spin_lock(&queue->lock);
+	ent = &queue->qhead->head[queue->idx * qinfo->cmd_size];
+	memcpy(ent, (void *)cmd, qinfo->cmd_size);
+
+	if (++queue->idx >= queue->qhead->size / 64) {
+		struct hlist_node *node;
+
+		hlist_for_each(node, &queue->chead) {
+			chunk = hlist_entry(node, struct command_chunk,
+					    nextchunk);
+			if (chunk == queue->qhead) {
+				continue;
+			} else {
+				queue->qhead = chunk;
+				break;
+			}
+		}
+		queue->idx = 0;
+	}
+	/* make sure all memory stores are done before ringing doorbell */
+	smp_wmb();
+	cptvf_write_vq_doorbell(cptvf, 1);
+	/* unlock command queue */
+	spin_unlock(&queue->lock);
+
+	return ret;
+}
+
+void do_request_cleanup(struct cpt_vf *cptvf,
+			struct cpt_info_buffer *info)
+{
+	s32 i;
+	struct pci_dev *pdev = cptvf->pdev;
+	struct cpt_request_info *req;
+
+	if (info->dptr_baddr)
+		dma_unmap_single(&pdev->dev, info->dptr_baddr,
+				 info->dlen, DMA_BIDIRECTIONAL);
+
+	if (info->rptr_baddr)
+		dma_unmap_single(&pdev->dev, info->rptr_baddr,
+				 COMPLETION_CODE_SIZE, DMA_BIDIRECTIONAL);
+
+	if (info->comp_baddr)
+		dma_unmap_single(&pdev->dev, info->comp_baddr,
+				 sizeof(union cpt_res_s), DMA_BIDIRECTIONAL);
+
+	if (info->req) {
+		req = info->req;
+		for (i = 0; i < req->outcnt; i++) {
+			if (req->out[i].dma_addr)
+				dma_unmap_single(&pdev->dev,
+						 req->out[i].dma_addr,
+						 req->out[i].size,
+						 DMA_BIDIRECTIONAL);
+		}
+
+		for (i = 0; i < req->incnt; i++) {
+			if (req->in[i].dma_addr)
+				dma_unmap_single(&pdev->dev,
+						 req->in[i].dma_addr,
+						 req->in[i].size,
+						 DMA_BIDIRECTIONAL);
+		}
+	}
+
+	if (info->scatter_components)
+		kzfree(info->scatter_components);
+
+	if (info->gather_components)
+		kzfree(info->gather_components);
+
+	if (info->out_buffer)
+		kzfree(info->out_buffer);
+
+	if (info->in_buffer)
+		kzfree(info->in_buffer);
+
+	if (info->completion_addr)
+		kzfree((void *)info->completion_addr);
+
+	kzfree(info);
+}
+
+void do_post_process(struct cpt_vf *cptvf, struct cpt_info_buffer *info)
+{
+	if (!info || !cptvf) {
+		pr_err("Input params are incorrect for post processing\n");
+		return;
+	}
+
+	do_request_cleanup(cptvf, info);
+}
+
+static inline void process_pending_queue(struct cpt_vf *cptvf,
+					 struct pending_qinfo *pqinfo,
+					 s32 qno)
+{
+	struct pending_queue *pqueue = &pqinfo->queue[qno];
+	struct pending_entry *pentry = NULL;
+	struct cpt_info_buffer *info = NULL;
+	union cpt_res_s *status = NULL;
+
+	while (1) {
+		spin_lock_bh(&pqueue->lock);
+		pentry = &pqueue->head[pqueue->front];
+		if (unlikely(!pentry->busy)) {
+			spin_unlock_bh(&pqueue->lock);
+			break;
+		}
+
+		info = (struct cpt_info_buffer *)pentry->post_arg;
+		if (unlikely(!info)) {
+			pr_err("Pending Entry post arg NULL\n");
+			pending_queue_inc_front(pqinfo, qno);
+			spin_unlock_bh(&pqueue->lock);
+			continue;
+		}
+
+		status = (union cpt_res_s *)pentry->completion_addr;
+		if ((status->s.compcode == CPT_COMP_E_FAULT) ||
+		    (status->s.compcode == CPT_COMP_E_SWERR)) {
+			pr_err("Request failed with %s\n",
+			       (status->s.compcode == CPT_COMP_E_FAULT) ?
+			       "DMA Fault" : "Software error");
+			pentry->completion_addr = NULL;
+			pentry->busy = false;
+			atomic64_dec((&pqueue->pending_count));
+			pentry->post_arg = NULL;
+			pending_queue_inc_front(pqinfo, qno);
+			do_request_cleanup(cptvf, info);
+			spin_unlock_bh(&pqueue->lock);
+			break;
+		} else if (status->s.compcode == COMPLETION_CODE_INIT) {
+			/* check for timeout */
+			if (time_after_eq(jiffies,
+					  (info->time_in +
+					  (CPT_COMMAND_TIMEOUT * HZ)))) {
+				pr_err("Request timed out");
+				pentry->completion_addr = NULL;
+				pentry->busy = false;
+				atomic64_dec((&pqueue->pending_count));
+				pentry->post_arg = NULL;
+				pending_queue_inc_front(pqinfo, qno);
+				do_request_cleanup(cptvf, info);
+				spin_unlock_bh(&pqueue->lock);
+				break;
+			} else if ((*info->alternate_caddr ==
+				(~COMPLETION_CODE_INIT)) &&
+				(info->extra_time < TIME_IN_RESET_COUNT)) {
+				info->time_in = jiffies;
+				info->extra_time++;
+				spin_unlock_bh(&pqueue->lock);
+				break;
+			}
+		}
+
+		pentry->completion_addr = NULL;
+		pentry->busy = false;
+		pentry->post_arg = NULL;
+		atomic64_dec((&pqueue->pending_count));
+		pending_queue_inc_front(pqinfo, qno);
+		spin_unlock_bh(&pqueue->lock);
+
+		do_post_process(info->cptvf, info);
+		/*
+		 * Calling callback after we find
+		 * that the request has been serviced
+		 */
+		pentry->callback(status->s.compcode, pentry->callback_arg);
+	}
+}
+
+s32 process_request(struct cpt_vf *cptvf, struct cpt_request_info *req)
+{
+	s32 ret = 0, clear = 0, queue = 0;
+	struct cpt_info_buffer *info = NULL;
+	struct cptvf_request *cpt_req = NULL;
+	union ctrl_info *ctrl = NULL;
+	struct pending_entry *pentry = NULL;
+	struct pending_queue *pqueue = NULL;
+	struct pci_dev *pdev = cptvf->pdev;
+	u8 group = 0;
+	struct cpt_vq_command vq_cmd;
+	union cpt_inst_s cptinst;
+
+	if (unlikely(!cptvf || !req)) {
+		pr_err("Invalid inputs (cptvf: %p, req: %p)\n", cptvf, req);
+		return -EINVAL;
+	}
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL | GFP_ATOMIC);
+	if (unlikely(!info)) {
+		pr_err("Unable to allocate memory for info_buffer\n");
+		return -ENOMEM;
+	}
+
+	cpt_req = (struct cptvf_request *)&req->req;
+	ctrl = (union ctrl_info *)&req->ctrl;
+
+	info->cptvf = cptvf;
+	group = ctrl->s.grp;
+	ret = setup_sgio_list(cptvf, info, req);
+	if (ret) {
+		pr_err("Setting up SG list failed");
+		goto request_cleanup;
+	}
+
+	cpt_req->dlen = info->dlen;
+	/*
+	 * Get buffer for union cpt_res_s response
+	 * structure and its physical address
+	 */
+	info->completion_addr = kzalloc(sizeof(union cpt_res_s),
+					     GFP_KERNEL | GFP_ATOMIC);
+	*((u8 *)(info->completion_addr)) = COMPLETION_CODE_INIT;
+	info->comp_baddr = dma_map_single(&pdev->dev,
+					       (void *)info->completion_addr,
+					       sizeof(union cpt_res_s),
+					       DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&pdev->dev, info->comp_baddr)) {
+		pr_err("mapping compptr Failed %lu\n", sizeof(union cpt_res_s));
+		ret = -EFAULT;
+		goto  request_cleanup;
+	}
+
+	/* Fill the VQ command */
+	vq_cmd.cmd.u64 = 0;
+	vq_cmd.cmd.s.opcode = cpu_to_be16(cpt_req->opcode.flags);
+	vq_cmd.cmd.s.param1 = cpu_to_be16(cpt_req->param1);
+	vq_cmd.cmd.s.param2 = cpu_to_be16(cpt_req->param2);
+	vq_cmd.cmd.s.dlen   = cpu_to_be16(cpt_req->dlen);
+
+	/* 64-bit swap for microcode data reads, not needed for addresses*/
+	vq_cmd.cmd.u64 = cpu_to_be64(vq_cmd.cmd.u64);
+	vq_cmd.dptr = info->dptr_baddr;
+	vq_cmd.rptr = info->rptr_baddr;
+	vq_cmd.cptr.u64 = 0;
+	vq_cmd.cptr.s.grp = group;
+	/* Get Pending Entry to submit command */
+	/* Always queue 0, because 1 queue per VF */
+	queue = 0;
+	pqueue = &cptvf->pqinfo.queue[queue];
+
+	if (atomic64_read(&pqueue->pending_count) > PENDING_THOLD) {
+		pr_err("pending threshold reached\n");
+		process_pending_queue(cptvf, &cptvf->pqinfo, queue);
+	}
+
+get_pending_entry:
+	spin_lock_bh(&pqueue->lock);
+	pentry = get_free_pending_entry(pqueue, cptvf->pqinfo.qlen);
+	if (unlikely(!pentry)) {
+		spin_unlock_bh(&pqueue->lock);
+		if (clear == 0) {
+			process_pending_queue(cptvf, &cptvf->pqinfo, queue);
+			clear = 1;
+			goto get_pending_entry;
+		}
+		pr_err("Get free entry failed\n");
+		pr_err("queue: %d, rear: %d, front: %d\n",
+		       queue, pqueue->rear, pqueue->front);
+		ret = -EFAULT;
+		goto request_cleanup;
+	}
+
+	pentry->completion_addr = info->completion_addr;
+	pentry->post_arg = (void *)info;
+	pentry->callback = req->callback;
+	pentry->callback_arg = req->callback_arg;
+	info->pentry = pentry;
+	pentry->busy = true;
+	atomic64_inc(&pqueue->pending_count);
+
+	/* Send CPT command */
+	info->pentry = pentry;
+	info->time_in = jiffies;
+	info->req = req;
+
+	/* Create the CPT_INST_S type command for HW intrepretation */
+	cptinst.s.doneint = true;
+	cptinst.s.res_addr = (u64)info->comp_baddr;
+	cptinst.s.tag = 0;
+	cptinst.s.grp = 0;
+	cptinst.s.wq_ptr = 0;
+	cptinst.s.ei0 = vq_cmd.cmd.u64;
+	cptinst.s.ei1 = vq_cmd.dptr;
+	cptinst.s.ei2 = vq_cmd.rptr;
+	cptinst.s.ei3 = vq_cmd.cptr.u64;
+
+	ret = send_cpt_command(cptvf, &cptinst, queue);
+	spin_unlock_bh(&pqueue->lock);
+	if (unlikely(ret)) {
+		spin_unlock_bh(&pqueue->lock);
+		pr_err("Send command failed for AE\n");
+		ret = -EFAULT;
+		goto request_cleanup;
+	}
+
+	return 0;
+
+request_cleanup:
+	pr_debug("Failed to submit CPT command\n");
+	do_request_cleanup(cptvf, info);
+
+	return ret;
+}
+
+void vq_post_process(struct cpt_vf *cptvf, u32 qno)
+{
+	if (unlikely(qno > cptvf->nr_queues)) {
+		pr_err("Request for post processing on invalid pending queue: %u\n",
+		       qno);
+		return;
+	}
+
+	process_pending_queue(cptvf, &cptvf->pqinfo, qno);
+}
+
+s32 cptvf_do_request(void *vfdev, struct cpt_request_info *req)
+{
+	struct cpt_vf *cptvf = (struct cpt_vf *)vfdev;
+
+	if (!cpt_device_ready(cptvf)) {
+		pr_err("CPT Device is not ready");
+		return -ENODEV;
+	}
+
+	if ((cptvf->vftype == SE_TYPES) && (!req->ctrl.s.se_req)) {
+		pr_err("CPTVF-%d of SE TYPE got AE request", cptvf->vfid);
+		return -EINVAL;
+	} else if ((cptvf->vftype == AE_TYPES) && (req->ctrl.s.se_req)) {
+		pr_err("CPTVF-%d of AE TYPE got SE request", cptvf->vfid);
+		return -EINVAL;
+	}
+
+	return process_request(cptvf, req);
+}
diff --git a/drivers/crypto/cavium/cpt/request_manager.h b/drivers/crypto/cavium/cpt/request_manager.h
new file mode 100644
index 0000000..6242b6f
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/request_manager.h
@@ -0,0 +1,147 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef __REQUEST_MANGER_H
+#define __REQUEST_MANGER_H
+
+#include "cpt_common.h"
+
+#define TIME_IN_RESET_COUNT  5
+#define COMPLETION_CODE_SIZE 8
+#define COMPLETION_CODE_INIT 0
+#define PENDING_THOLD  100
+#define MAX_SG_IN_CNT 12
+#define MAX_SG_OUT_CNT 13
+#define SG_LIST_HDR_SIZE  8
+#define MAX_BUF_CNT	16
+
+union ctrl_info {
+	u32 flags;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u32 reserved0:26;
+		u32 grp:3; /**< Group bits */
+		u32 dma_mode:2; /**< DMA mode */
+		u32 se_req:1;/**< To SE core */
+#else
+		u32 se_req:1; /**< To SE core */
+		u32 dma_mode:2; /**< DMA mode */
+		u32 grp:3; /* Group bits */
+		u32 reserved0:26;
+#endif
+	} s;
+};
+
+union opcode_info {
+	u16 flags;
+	struct {
+		u8 major;
+		u8 minor;
+	} s;
+};
+
+struct cptvf_request {
+	union opcode_info opcode;
+	u16 param1;
+	u16 param2;
+	u16 dlen;
+};
+
+struct buf_ptr {
+	u8 *vptr;
+	dma_addr_t dma_addr;
+	u16 size;
+};
+
+struct cpt_request_info {
+	u8 incnt; /**< Number of input buffers */
+	u8 outcnt; /**< Number of output buffers */
+	u16 rlen; /**< Output length */
+	union ctrl_info ctrl; /**< User control information */
+	struct cptvf_request req; /**< Request Information (Core specific) */
+
+	struct buf_ptr in[MAX_BUF_CNT];
+	struct buf_ptr out[MAX_BUF_CNT];
+
+	void (*callback)(int, void *); /**< Kernel ASYNC request callabck */
+	void *callback_arg; /**< Kernel ASYNC request callabck arg */
+};
+
+struct sglist_component {
+	union {
+		u64 len;
+		struct {
+			u16 len0;
+			u16 len1;
+			u16 len2;
+			u16 len3;
+		} s;
+	} u;
+	u64 ptr0;
+	u64 ptr1;
+	u64 ptr2;
+	u64 ptr3;
+};
+
+struct cpt_info_buffer {
+	struct cpt_vf *cptvf;
+	unsigned long time_in;
+	u8 extra_time;
+
+	struct cpt_request_info *req;
+	dma_addr_t dptr_baddr;
+	u32 dlen;
+	dma_addr_t rptr_baddr;
+	dma_addr_t comp_baddr;
+	u8 *in_buffer;
+	u8 *out_buffer;
+	u8 *gather_components;
+	u8 *scatter_components;
+
+	struct pending_entry *pentry;
+	volatile u64 *completion_addr;
+	volatile u64 *alternate_caddr;
+};
+
+/*
+ * CPT_INST_S software command definitions
+ * Words EI (0-3)
+ */
+union vq_cmd_word0 {
+	u64 u64;
+	struct {
+		u16 opcode;
+		u16 param1;
+		u16 param2;
+		u16 dlen;
+	} s;
+};
+
+union vq_cmd_word3 {
+	u64 u64;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 grp:3;
+		u64 cptr:61;
+#else
+		u64 cptr:61;
+		u64 grp:3;
+#endif
+	} s;
+};
+
+struct cpt_vq_command {
+	union vq_cmd_word0 cmd;
+	u64 dptr;
+	u64 rptr;
+	union vq_cmd_word3 cptr;
+};
+
+void vq_post_process(struct cpt_vf *cptvf, u32 qno);
+s32 process_request(struct cpt_vf *cptvf, struct cpt_request_info *req);
+#endif /* __REQUEST_MANGER_H */
-- 
2.1.4

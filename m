From: gcherianv@gmail.com
Subject: [PATCH 2/3] drivers: crypto: Add the Virtual Function driver for CPT
Date: Fri, 18 Nov 2016 15:00:08 +0000
Message-ID: <1479481209-11475-3-git-send-email-gcherianv@gmail.com>
References: <1479481209-11475-1-git-send-email-gcherianv@gmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        George Cherian <george.cherian@cavium.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33233 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbcKRPAe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2016 10:00:34 -0500
In-Reply-To: <1479481209-11475-1-git-send-email-gcherianv@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: George Cherian <george.cherian@cavium.com>

Enable the CPT VF driver. CPT is the cryptographic Accelaration Unit
in Octeon-tx series of processors.

Signed-off-by: George Cherian <george.cherian@cavium.com>
---
 drivers/crypto/cavium/cpt/Kconfig            |   10 +
 drivers/crypto/cavium/cpt/Makefile           |    2 +
 drivers/crypto/cavium/cpt/cptvf.h            |  255 +++++++
 drivers/crypto/cavium/cpt/cptvf_algs.c       |  446 +++++++++++
 drivers/crypto/cavium/cpt/cptvf_algs.h       |  159 ++++
 drivers/crypto/cavium/cpt/cptvf_main.c       | 1038 ++++++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptvf_mbox.c       |  208 ++++++
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c |  655 ++++++++++++++++
 drivers/crypto/cavium/cpt/request_manager.h  |  221 ++++++
 9 files changed, 2994 insertions(+)
 create mode 100644 drivers/crypto/cavium/cpt/cptvf.h
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_algs.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_algs.h
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_main.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_mbox.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_reqmanager.c
 create mode 100644 drivers/crypto/cavium/cpt/request_manager.h

diff --git a/drivers/crypto/cavium/cpt/Kconfig b/drivers/crypto/cavium/cpt/Kconfig
index 8fe3f44..d8c3f48 100644
--- a/drivers/crypto/cavium/cpt/Kconfig
+++ b/drivers/crypto/cavium/cpt/Kconfig
@@ -20,3 +20,13 @@ config OCTEONTX_CPT_PF
 
 	  To compile this as a module, choose M here: the module will be
 	  called cptpf.
+config OCTEONTX_CPT_VF
+	tristate "Octeon-tx CPT Virtual function driver"
+	depends on ARCH_THUNDER
+	select CRYPTO_DEV_CPT
+	help
+	  Support for Cavium CPT Virtual function found in octeon-tx
+	  series of processors.
+
+	  To compile this as a module, choose M here: the module will be
+	  called cptvf.
diff --git a/drivers/crypto/cavium/cpt/Makefile b/drivers/crypto/cavium/cpt/Makefile
index bf758e2..6f70b15 100644
--- a/drivers/crypto/cavium/cpt/Makefile
+++ b/drivers/crypto/cavium/cpt/Makefile
@@ -1,2 +1,4 @@
 obj-$(CONFIG_OCTEONTX_CPT_PF) += cptpf.o
 cptpf-objs := cpt_main.o cpt_pf_mbox.o
+obj-$(CONFIG_OCTEONTX_CPT_VF) += cptvf.o
+cptvf-objs := cptvf_main.o cptvf_reqmanager.o cptvf_mbox.o cptvf_algs.o
diff --git a/drivers/crypto/cavium/cpt/cptvf.h b/drivers/crypto/cavium/cpt/cptvf.h
new file mode 100644
index 0000000..1fafea8
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf.h
@@ -0,0 +1,255 @@
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
+struct command_chunk {
+	uint8_t *head; /* 128-byte aligned real_vaddr */
+	uint8_t *real_vaddr; /* Virtual address after dma_alloc_consistent */
+	dma_addr_t dma_addr; /* 128-byte aligned real_dma_addr */
+	dma_addr_t real_dma_addr; /* DMA address after dma_alloc_consistent */
+	uint32_t size; /* Chunk size, max CPT_INST_CHUNK_MAX_SIZE */
+	struct hlist_node nextchunk;
+};
+
+struct iq_stats {
+	atomic64_t instr_posted;
+	atomic64_t instr_dropped;
+};
+
+/**
+ * comamnd queue structure
+ */
+struct command_queue {
+	spinlock_t lock; /* command queue lock */
+	uint32_t idx; /* Command queue host write idx */
+	uint32_t dbell_count; /* outstanding commands */
+	uint32_t nchunks; /* Number of command chunks */
+	struct command_chunk *qhead;	/* Command queue head, instructions
+					 * are inserted here
+					 */
+	struct hlist_head chead;
+	struct iq_stats stats; /* Queue statistics */
+};
+
+struct command_qinfo {
+	uint32_t dbell_thold; /* Command queue doorbell threshold */
+	uint32_t cmd_size; /* Command size (32/64-Byte) */
+	uint32_t qchunksize; /* Command queue chunk size configured by user */
+	struct command_queue queue[DEFAULT_DEVICE_QUEUES];
+};
+
+/**
+ * pending entry structure
+ */
+struct pending_entry {
+	uint8_t busy; /* Entry status (free/busy) */
+	uint8_t done;
+	uint8_t is_ae;
+
+	volatile uint64_t *completion_addr; /* Completion address */
+	void *post_arg;
+	void (*callback)(int, void *); /* Kernel ASYNC request callabck */
+	void *callback_arg; /* Kernel ASYNC request callabck arg */
+};
+
+/**
+ * pending queue structure
+ */
+struct pending_queue {
+	struct pending_entry *head;	/* head of the queue */
+	uint32_t front; /* Process work from here */
+	uint32_t rear; /* Append new work here */
+	atomic64_t pending_count;
+	spinlock_t lock; /* Queue lock */
+};
+
+struct pending_qinfo {
+	uint32_t nr_queues;	/* Number of queues supported */
+	uint32_t qlen; /* Queue length */
+	struct pending_queue queue[DEFAULT_DEVICE_QUEUES];
+};
+
+#define for_each_pending_queue(qinfo, q, i)	\
+	for (i = 0, q = &qinfo->queue[i]; i < qinfo->nr_queues; i++, \
+	     q = &qinfo->queue[i])
+
+/**
+ * CPT VF device structure
+ */
+struct cpt_vf {
+	uint32_t chip_id; /* CPT Device ID */
+	uint16_t flags; /* Flags to hold device status bits */
+	uint8_t vfid; /* Device Index 0...CPT_MAX_VF_NUM */
+	uint8_t vftype; /* VF type of SE_TYPE(1) or AE_TYPE(1) */
+	uint8_t vfgrp; /* VF group (0 - 8) */
+	uint8_t node; /* Operating node: Bits (46:44) in BAR0 address */
+	uint8_t  priority; /* VF priority ring: 1-High proirity round
+			    * robin ring;0-Low priority round robin ring;
+			    */
+	uint8_t  reqmode; /* Request processing mode POLL/ASYNC */
+	struct pci_dev *pdev; /* pci device handle */
+	void *sysdev; /* sysfs device */
+	void *proc; /* proc dir */
+	void __iomem *reg_base; /* Register start address */
+	void *wqe_info;	/* BH worker threads */
+	void *context;	/* Context Specific Information*/
+	void *nqueue_info; /* Queue Specific Information*/
+	/* MSI-X */
+	bool msix_enabled;
+	uint8_t	num_vec;
+	struct msix_entry msix_entries[CPT_VF_MSIX_VECTORS];
+	bool irq_allocated[CPT_VF_MSIX_VECTORS];
+	cpumask_var_t affinity_mask[CPT_VF_MSIX_VECTORS];
+	uint64_t intcnt;
+	/* Command and Pending queues */
+	uint32_t qlen;
+	uint32_t qsize; /* Calculated queue size */
+	uint32_t nr_queues;
+	uint32_t max_queues;
+	struct command_qinfo cqinfo; /* Command queue information */
+	struct pending_qinfo pqinfo; /* Pending queue information */
+	/* VF-PF mailbox communication */
+	bool pf_acked;
+	bool pf_nacked;
+} ____cacheline_aligned_in_smp;
+
+#define CPT_NODE_ID_SHIFT (44u)
+#define CPT_NODE_ID_MASK (3u)
+
+#define MAX_CPT_AE_CORES 6
+#define MAX_CPT_SE_CORES 10
+
+enum req_mode {
+	BLOCKING,
+	NON_BLOCKING,
+	SPEED,
+	KERN_POLL,
+};
+
+enum dma_mode {
+	DMA_DIRECT_DIRECT, /* Input DIRECT, Output DIRECT */
+	DMA_GATHER_SCATTER
+};
+
+enum inputype {
+	FROM_CTX = 0,
+	FROM_DPTR = 1
+};
+
+enum CspErrorCodes {
+	/*Microcode errors*/
+	NO_ERR = 0x00,
+	ERR_OPCODE_UNSUPPORTED = 0x01,
+
+	/*SCATTER GATHER*/
+	ERR_SCATTER_GATHER_WRITE_LENGTH = 0x02,
+	ERR_SCATTER_GATHER_LIST = 0x03,
+	ERR_SCATTER_GATHER_NOT_SUPPORTED = 0x04,
+
+	/*AE*/
+	ERR_LENGTH_INVALID = 0x05,
+	ERR_MOD_LEN_INVALID = 0x06,
+	ERR_EXP_LEN_INVALID = 0x07,
+	ERR_DATA_LEN_INVALID = 0x08,
+	ERR_MOD_LEN_ODD = 0x09,
+	ERR_PKCS_DECRYPT_INCORRECT = 0x0a,
+	ERR_ECC_PAI = 0xb,
+	ERR_ECC_CURVE_UNSUPPORTED = 0xc,
+	ERR_ECC_SIGN_R_INVALID = 0xd,
+	ERR_ECC_SIGN_S_INVALID = 0xe,
+	ERR_ECC_SIGNATURE_MISMATCH = 0xf,
+
+	/*SE GC*/
+	ERR_GC_LENGTH_INVALID = 0x41,
+	ERR_GC_RANDOM_LEN_INVALID = 0x42,
+	ERR_GC_DATA_LEN_INVALID = 0x43,
+	ERR_GC_DRBG_TYPE_INVALID = 0x44,
+	ERR_GC_CTX_LEN_INVALID = 0x45,
+	ERR_GC_CIPHER_UNSUPPORTED = 0x46,
+	ERR_GC_AUTH_UNSUPPORTED = 0x47,
+	ERR_GC_OFFSET_INVALID = 0x48,
+	ERR_GC_HASH_MODE_UNSUPPORTED = 0x49,
+	ERR_GC_DRBG_ENTROPY_LEN_INVALID = 0x4a,
+	ERR_GC_DRBG_ADDNL_LEN_INVALID = 0x4b,
+	ERR_GC_ICV_MISCOMPARE = 0x4c,
+	ERR_GC_DATA_UNALIGNED = 0x4d,
+
+	/*SE IPSEC*/
+	ERR_IPSEC_AUTH_UNSUPPORTED = 0xB0,
+	ERR_IPSEC_ENCRYPT_UNSUPPORTED = 0xB1,
+	ERR_IPSEC_IP_VERSION = 0xB2,
+	ERR_IPSEC_PROTOCOL = 0xB3,
+	ERR_IPSEC_CONTEXT_INVALID = 0xB4,
+	ERR_IPSEC_CONTEXT_DIRECTION_MISMATCH = 0xB5,
+	ERR_IPSEC_IP_PAYLOAD_TYPE = 0xB6,
+	ERR_IPSEC_CONTEXT_FLAG_MISMATCH = 0xB7,
+	ERR_IPSEC_GRE_HEADER_MISMATCH = 0xB8,
+	ERR_IPSEC_GRE_PROTOCOL = 0xB9,
+	ERR_IPSEC_CUSTOM_HDR_LEN = 0xBA,
+	ERR_IPSEC_ESP_NEXT_HEADER = 0xBB,
+	ERR_IPSEC_IPCOMP_CONFIGURATION = 0xBC,
+	ERR_IPSEC_FRAG_SIZE_CONFIGURATION = 0xBD,
+	ERR_IPSEC_SPI_MISMATCH = 0xBE,
+	ERR_IPSEC_CHECKSUM = 0xBF,
+	ERR_IPSEC_IPCOMP_PACKET_DETECTED = 0xC0,
+	ERR_IPSEC_TFC_PADDING_WITH_PREFRAG = 0xC1,
+	ERR_IPSEC_DSIV_INCORRECT_PARAM = 0xC2,
+	ERR_IPSEC_AUTHENTICATION_MISMATCH = 0xC3,
+	ERR_IPSEC_PADDING = 0xC4,
+	ERR_IPSEC_DUMMY_PAYLOAD = 0xC5,
+	ERR_IPSEC_IPV6_EXTENSION_HEADERS_TOO_BIG = 0xC6,
+	ERR_IPSEC_IPV6_HOP_BY_HOP = 0xC7,
+	ERR_IPSEC_IPV6_RH_LENGTH = 0xC8,
+	ERR_IPSEC_IPV6_OUTBOUND_RH_COPY_ADDR = 0xC9,
+	ERR_IPSEC_IPV6_DECRYPT_RH_SEGS_LEFT = 0xCA,
+	ERR_IPSEC_IPV6_HEADER_INVALID = 0xCB,
+	ERR_IPSEC_SELECTOR_MATCH = 0xCC,
+
+	/*SE SSL*/
+	ERR_SSL_POM_LEN_INVALID = 0x81,
+	ERR_SSL_RECORD_LEN_INVALID = 0x82,
+	ERR_SSL_CTX_LEN_INVALID = 0x83,
+	ERR_SSL_CIPHER_UNSUPPORTED = 0x84,
+	ERR_SSL_MAC_UNSUPPORTED = 0x85,
+	ERR_SSL_VERSION_UNSUPPORTED = 0x86,
+	ERR_SSL_VERIFY_AUTH_UNSUPPORTED = 0x87,
+	ERR_SSL_MS_LEN_INVALID = 0x88,
+	ERR_SSL_MAC_MISMATCH = 0x89,
+
+	/* API Layer */
+	ERR_REQ_TIMEOUT      = (0x40000000 | 0x103),    /* 0x40000103 */
+	ERR_REQ_PENDING      = (0x40000000 | 0x110),    /* 0x40000110 */
+	ERR_BAD_INPUT_LENGTH = (0x40000000 | 384),    /* 0x40000180 */
+	ERR_BAD_KEY_LENGTH,
+	ERR_BAD_KEY_HANDLE,
+	ERR_BAD_CONTEXT_HANDLE,
+	ERR_BAD_SCALAR_LENGTH,
+	ERR_BAD_DIGEST_LENGTH,
+	ERR_BAD_INPUT_ARG,
+	ERR_BAD_SSL_MSG_TYPE,
+	ERR_BAD_RECORD_PADDING,
+	ERR_NB_REQUEST_PENDING,
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
+void vq_post_process(struct cpt_vf *cptvf, uint32_t qno);
+void cptvf_write_vq_doorbell(struct cpt_vf *cptvf, uint32_t val);
+#endif /* __CPTVF_H */
diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
new file mode 100644
index 0000000..4705e90
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -0,0 +1,446 @@
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
+#include <crypto/internal/aead.h>
+#include <crypto/aead.h>
+#include <crypto/authenc.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include "request_manager.h"
+#include "cptvf.h"
+#include "cptvf_algs.h"
+
+struct cpt_device_handle {
+	void *cdev[MAX_DEVICES];
+	uint32_t dev_count;
+};
+
+static struct cpt_device_handle dev_handle;
+
+static void cvm_callback(uint32_t status, void *arg)
+{
+	struct crypto_async_request *req = (struct crypto_async_request *)arg;
+
+	req->complete(req, !status);
+}
+
+static inline void update_input_iv(struct cpt_request_info *req_info,
+				   uint8_t *iv, uint32_t enc_iv_len,
+				   uint32_t *argcnt)
+{
+	/* Setting the iv information */
+	req_info->in[*argcnt].ptr.addr = (void *)iv;
+	req_info->in[*argcnt].size = enc_iv_len;
+	req_info->in[*argcnt].offset = enc_iv_len;
+	req_info->in[*argcnt].type = UNIT_8_BIT;
+	req_info->req.dlen += enc_iv_len;
+
+	++(*argcnt);
+}
+
+static inline void update_output_iv(struct cpt_request_info *req_info,
+				    uint8_t *iv, uint32_t enc_iv_len,
+				    uint32_t *argcnt)
+{
+	/* Setting the iv information */
+	req_info->out[*argcnt].ptr.addr = (void *)iv;
+	req_info->out[*argcnt].size = enc_iv_len;
+	req_info->out[*argcnt].offset = enc_iv_len;
+	req_info->out[*argcnt].type = UNIT_8_BIT;
+
+	req_info->rlen += enc_iv_len;
+
+	++(*argcnt);
+}
+
+static inline void update_input_data(struct cpt_request_info *req_info,
+				     struct scatterlist *inp_sg,
+				     uint32_t nbytes, uint32_t *argcnt)
+{
+	req_info->req.dlen += nbytes;
+
+	while (nbytes) {
+		uint32_t len = min(nbytes, inp_sg->length);
+		uint8_t *ptr = page_address(sg_page(inp_sg)) + inp_sg->offset;
+
+		req_info->in[*argcnt].ptr.addr = (void *)ptr;
+		req_info->in[*argcnt].size = len;
+		req_info->in[*argcnt].offset = len;
+		req_info->in[*argcnt].type = UNIT_8_BIT;
+		nbytes -= len;
+
+		++(*argcnt);
+		++inp_sg;
+	}
+}
+
+static inline void update_output_data(struct cpt_request_info *req_info,
+				      struct scatterlist *outp_sg,
+				      uint32_t nbytes, uint32_t *argcnt)
+{
+	req_info->rlen += nbytes;
+
+	while (nbytes) {
+		uint32_t len = min(nbytes, outp_sg->length);
+		uint8_t *ptr = page_address(sg_page(outp_sg)) +
+					    outp_sg->offset;
+
+		req_info->out[*argcnt].ptr.addr = (void *)ptr;
+		req_info->out[*argcnt].size = len;
+		req_info->out[*argcnt].offset = len;
+		req_info->out[*argcnt].type = UNIT_8_BIT;
+		nbytes -= len;
+		++(*argcnt);
+		++outp_sg;
+	}
+}
+
+static inline uint32_t create_ctx_hdr(struct ablkcipher_request *req,
+				      uint32_t enc, uint32_t cipher_type,
+				      uint32_t aes_key_type, uint32_t *argcnt)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct cvm_enc_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct fc_context *fctx = &rctx->fctx;
+	uint64_t *offset_control = &rctx->control_word;
+	uint32_t enc_iv_len = crypto_ablkcipher_ivsize(tfm);
+	struct cpt_request_info *req_info = &rctx->cpt_req;
+	uint64_t *ctrl_flags = NULL;
+	uint8_t iv_inp = FROM_DPTR;
+	uint8_t dma_mode = DMA_GATHER_SCATTER;
+
+	req_info->ctrl.s.grp = 0;
+	req_info->ctrl.s.dma_mode = dma_mode;
+	req_info->ctrl.s.req_mode = NON_BLOCKING;
+	req_info->ctrl.s.se_req = SE_CORE_REQ;
+
+	req_info->ctxl = sizeof(struct fc_context);
+	req_info->handle = 0;
+
+	req_info->req.opcode.s.major = MAJOR_OP_FC | DMA_MODE_FLAG(dma_mode);
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
+	fctx->enc.enc_ctrl.e.iv_source = iv_inp;
+
+	memcpy(fctx->enc.encr_key, ctx->enc_key, ctx->key_len);
+	ctrl_flags = (uint64_t *)&fctx->enc.enc_ctrl.flags;
+	*ctrl_flags = cpu_to_be64(*ctrl_flags);
+
+	*offset_control = cpu_to_be64(((uint64_t)(enc_iv_len) << 16));
+	/* Storing  Packet Data Information in offset
+	 * Control Word First 8 bytes
+	 */
+	req_info->in[*argcnt].ptr.addr = (uint8_t *)offset_control;
+	req_info->in[*argcnt].size = CONTROL_WORD_LEN;
+	req_info->in[*argcnt].offset = CONTROL_WORD_LEN;
+	req_info->in[*argcnt].type = UNIT_8_BIT;
+	req_info->req.dlen += CONTROL_WORD_LEN;
+
+	++(*argcnt);
+
+	req_info->in[*argcnt].ptr.addr = (uint8_t *)fctx;
+	req_info->in[*argcnt].size = sizeof(struct fc_context);
+	req_info->in[*argcnt].offset = sizeof(struct fc_context);
+	req_info->in[*argcnt].type = UNIT_8_BIT;
+	req_info->req.dlen += sizeof(struct fc_context);
+
+	++(*argcnt);
+
+	return 0;
+}
+
+static inline uint32_t create_input_list(struct ablkcipher_request  *req,
+					 uint32_t enc, uint32_t cipher_type,
+					 uint32_t aes_key_type,
+					 uint32_t enc_iv_len)
+{
+	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct cpt_request_info *req_info = &rctx->cpt_req;
+	uint32_t argcnt =  0;
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
+				      uint32_t cipher_type,
+				      uint32_t enc_iv_len)
+{
+	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct cpt_request_info *req_info = &rctx->cpt_req;
+	uint32_t argcnt = 0;
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
+static inline uint32_t cvm_enc_dec(struct ablkcipher_request *req,
+				   uint32_t enc, uint32_t cipher_type)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct cvm_enc_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	uint32_t key_type = AES_128_BIT;
+	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
+	uint32_t enc_iv_len = crypto_ablkcipher_ivsize(tfm);
+	struct fc_context *fctx = &rctx->fctx;
+	struct cpt_request_info *req_info = &rctx->cpt_req;
+	void *cdev = NULL;
+	uint32_t status = -1;
+
+	switch (ctx->key_len) {
+	case BYTE_16:
+		key_type = AES_128_BIT;
+		break;
+	case BYTE_24:
+		key_type = AES_192_BIT;
+		break;
+	case BYTE_32:
+		key_type = AES_256_BIT;
+		break;
+	default:
+		return ERR_GC_CIPHER_UNSUPPORTED;
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
+int cvm_des3_encrypt_cbc(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, true, DES3_CBC);
+}
+
+int cvm_des3_decrypt_cbc(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, false, DES3_CBC);
+}
+
+int cvm_aes_encrypt_xts(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, true, AES_XTS);
+}
+
+int cvm_aes_decrypt_xts(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, false, AES_XTS);
+}
+
+int cvm_aes_encrypt_cbc(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, true, AES_CBC);
+}
+
+int cvm_aes_decrypt_cbc(struct ablkcipher_request *req)
+{
+	return cvm_enc_dec(req, false, AES_CBC);
+}
+
+int cvm_enc_dec_setkey(struct crypto_ablkcipher *cipher, const uint8_t *key,
+		       uint32_t keylen)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct cvm_enc_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if ((keylen == BYTE_16) || (keylen == BYTE_24) ||
+	    (keylen == BYTE_32)) {
+		ctx->key_len = keylen;
+		memcpy(ctx->enc_key, key, keylen);
+		return 0;
+	}
+	crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+	return -EINVAL;
+}
+
+int cvm_enc_dec_init(struct crypto_tfm *tfm)
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
+	.cra_priority = CAV_PRIORITY,
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
+	.cra_priority = CAV_PRIORITY,
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
+	.cra_priority = CAV_PRIORITY,
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
+static inline int cav_register_algs(void)
+{
+	int err = 0;
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
+int cvm_crypto_init(struct cpt_vf *cptvf)
+{
+	uint32_t dev_count;
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
+	uint32_t dev_count;
+
+	dev_count = --dev_handle.dev_count;
+	if (!dev_count)
+		cav_unregister_algs();
+}
diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.h b/drivers/crypto/cavium/cpt/cptvf_algs.h
new file mode 100644
index 0000000..2e45797
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.h
@@ -0,0 +1,159 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef _CAVIUM_SYM_CRYPTO_H_
+#define _CAVIUM_SYM_CRYPTO_H_
+
+#define MAX_DEVICES 16
+/* AE opcodes*/
+#define MAJOR_OP_MISC         0x01
+#define MAJOR_OP_RANDOM       0x02
+#define MAJOR_OP_MODEXP       0x03
+#define MAJOR_OP_ECDSA        0x04
+#define MAJOR_OP_ECC          0x05
+#define MAJOR_OP_GENRSAPRIME  0x06
+#define MAJOR_OP_AE_RANDOM    0x32
+#define MAJOR_OP_AE_PASSTHRU  0x01
+#define MINOR_OP_AE_PASSTHRU  0x07
+
+/*SE opcodes*/
+#define MAJOR_OP_SE_MISC    0x31
+#define MAJOR_OP_SE_RANDOM  0x32
+#define MAJOR_OP_FC         0x33
+#define MAJOR_OP_HASH       0x34
+#define MAJOR_OP_HMAC       0x35
+#define MAJOR_OP_DSIV       0x36
+
+#define MAJOR_OP_SSL_FULL    0x10
+#define MAJOR_OP_SSL_VERIFY  0x11
+#define MAJOR_OP_SSL_RESUME  0x12
+#define MAJOR_OP_SSL_FINISH  0x13
+#define MAJOR_OP_SSL_ENCREC  0x14
+#define MAJOR_OP_SSL_DECREC  0x15
+
+#define MAJOR_OP_WRITESA_OUTBOUND 0x20
+#define MAJOR_OP_WRITESA_INBOUND  0x21
+#define MAJOR_OP_OUTBOUND         0x23
+#define MAJOR_OP_INBOUND          0x24
+
+#define MAJOR_OP_SE_PASSTHRU  0x01
+#define MINOR_OP_SE_PASSTHRU  0x07
+
+#define  CAV_PRIORITY 1000
+#define  MAX_ENC_KEY_SIZE 32
+#define  MAX_HASH_KEY_SIZE 64
+#define  MAX_KEY_SIZE (MAX_ENC_KEY_SIZE + MAX_HASH_KEY_SIZE)
+#define  CONTROL_WORD_LEN 8
+
+#define IV_OFFSET 8   /* Include SPI | SNO 8 Bytes */
+#define AES_CBC_ALG_NAME "cbc(aes)"
+#define AES_XTS_ALG_NAME "xts(aes)"
+#define DES3_ALG_NAME "cbc(des3_ede)"
+
+#define  BYTE_16 16
+#define  BYTE_24 24
+#define  BYTE_32 32
+
+#define DMA_MODE_FLAG(dma_mode) \
+	((dma_mode == DMA_GATHER_SCATTER) ? (1 << 7) : 0)
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
+/*Context length in words*/
+#define  FC_CTX_LENGTH       23
+#define  ENC_CTX_LENGTH       7
+#define  HASH_CTX_LENGTH     34
+#define  HMAC_CTX_LENGTH     34
+
+union encr_ctrl {
+	uint64_t flags;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		uint64_t enc_cipher:4;
+		uint64_t reserved1:1;
+		uint64_t aes_key:2;
+		uint64_t iv_source:1;
+		uint64_t hash_type:4;
+		uint64_t reserved2:3;
+		uint64_t auth_input_type:1;
+		uint64_t mac_len:8;
+		uint64_t reserved3:8;
+		uint64_t encr_offset:16;
+		uint64_t iv_offset:8;
+		uint64_t auth_offset:8;
+#else
+		uint64_t auth_offset:8;
+		uint64_t iv_offset:8;
+		uint64_t encr_offset:16;
+		uint64_t reserved3:8;
+		uint64_t mac_len:8;
+		uint64_t auth_input_type:1;
+		uint64_t reserved2:3;
+		uint64_t hash_type:4;
+		uint64_t iv_source:1;
+		uint64_t aes_key:2;
+		uint64_t reserved1:1;
+		uint64_t enc_cipher:4;
+#endif
+	} e;
+};
+
+struct enc_context {
+	union encr_ctrl enc_ctrl;
+	uint8_t  encr_key[32];
+	uint8_t  encr_iv[16];
+};
+
+struct fchmac_context {
+	uint8_t  ipad[64];
+	uint8_t  opad[64]; /* or OPAD */
+};
+
+struct fc_context {
+	struct enc_context enc;
+	struct fchmac_context hmac;
+};
+
+struct cvm_enc_ctx {
+	uint32_t key_len;
+	uint8_t enc_key[MAX_KEY_SIZE];
+};
+
+struct cvm_des3_ctx {
+	uint32_t key_len;
+	uint8_t des3_key[MAX_KEY_SIZE];
+};
+
+struct cvm_req_ctx {
+	struct cpt_request_info cpt_req;
+	uint64_t control_word;
+	struct fc_context fctx;
+};
+
+uint32_t cptvf_do_request(void *cptvf, struct cpt_request_info *);
+#endif /*_CAVIUM_SYM_CRYPTO_H_*/
diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
new file mode 100644
index 0000000..57b796f
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -0,0 +1,1038 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/version.h>
+#include <linux/aer.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/printk.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/cpumask.h>
+
+#include "cptvf.h"
+
+#define DRV_NAME	"thunder-cptvf"
+#define DRV_VERSION	"1.0"
+
+static uint32_t qlen = DEFAULT_CMD_QLEN;
+module_param(qlen, uint, 0644);
+MODULE_PARM_DESC(qlen, "Command queue length");
+
+static uint32_t chunksize = DEFAULT_CMD_QCHUNK_SIZE;
+module_param(chunksize, uint, 0644);
+MODULE_PARM_DESC(chunksize, "Command queue chunk size");
+
+static uint32_t group = 1; /* Default to SE group */
+module_param(group, uint, 0644);
+MODULE_PARM_DESC(group, "VF group (Value between 0 - 7)");
+
+static uint32_t priority;
+module_param(priority, uint, 0644);
+MODULE_PARM_DESC(priority, "VF/VQ Priority (0-1)");
+
+struct cptvf_wqe {
+	struct tasklet_struct twork;
+	void *cptvf;
+	uint32_t qno;
+};
+
+struct cptvf_wqe_info {
+	struct cptvf_wqe vq_wqe[DEFAULT_DEVICE_QUEUES];
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
+static int init_worker_threads(struct cpt_vf *cptvf)
+{
+	struct pci_dev *pdev = cptvf->pdev;
+	struct cptvf_wqe_info *cwqe_info;
+	int i;
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
+			     (uint64_t)cwqe_info);
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
+	int i;
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
+	int32_t i;
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
+static int32_t alloc_pending_queues(struct pending_qinfo *pqinfo,
+				    uint32_t qlen, uint32_t nr_queues)
+{
+	uint32_t i;
+	size_t size;
+	int32_t ret;
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
+static int32_t init_pending_queues(struct cpt_vf *cptvf, uint32_t qlen,
+				   uint32_t nr_queues)
+{
+	int32_t ret;
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
+	int i, j;
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
+					  chunk->real_vaddr,
+					  chunk->real_dma_addr);
+			chunk->real_vaddr = NULL;
+			chunk->real_dma_addr = 0;
+			chunk->head = NULL;
+			chunk->dma_addr = 0;
+			hlist_del(&chunk->nextchunk);
+			kzfree(chunk);
+			chunk = next;
+		}
+		queue->nchunks = 0;
+		queue->idx = 0;
+		queue->dbell_count = 0;
+	}
+
+	/* common cleanup */
+	cqinfo->cmd_size = 0;
+	cqinfo->dbell_thold = 0;
+}
+
+static int32_t alloc_command_queues(struct cpt_vf *cptvf,
+				    struct command_qinfo *cqinfo,
+				    size_t cmd_size, size_t align,
+				    uint32_t qlen, uint32_t nr_queues)
+{
+	int i;
+	size_t q_size;
+	struct command_queue *queue = NULL;
+	struct pci_dev *pdev = cptvf->pdev;
+
+	/* common init */
+	cqinfo->cmd_size = cmd_size;
+	cqinfo->dbell_thold = CPT_DBELL_THOLD;
+
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
+		uint32_t qcsize_bytes = cqinfo->qchunksize * cqinfo->cmd_size;
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
+			curr->real_vaddr = (uint8_t *)dma_zalloc_coherent(&pdev->dev,
+					  c_size + CPT_NEXT_CHUNK_PTR_SIZE,
+					  &curr->real_dma_addr, GFP_KERNEL);
+			if (!curr->real_vaddr) {
+				pr_err("Command Q (%d) chunk (%d) allocation failed\n",
+				       i, queue->nchunks);
+				goto cmd_qfail;
+			}
+
+			curr->head = (uint8_t *)PTR_ALIGN(curr->real_vaddr, align);
+			curr->dma_addr = (dma_addr_t)PTR_ALIGN(curr->real_dma_addr,
+								align);
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
+				*((uint64_t *)(&last->head[last->size])) = (uint64_t)curr->dma_addr;
+
+			last = curr;
+		} while (rem_q_size);
+
+		/* Make the queue circular */
+		/* Tie back last chunk entry to head */
+		curr = first;
+		*((uint64_t *)(&last->head[last->size])) = (uint64_t)curr->dma_addr;
+		last->nextchunk.next = &curr->nextchunk;
+		queue->qhead = curr;
+		queue->dbell_count = 0;
+		spin_lock_init(&queue->lock);
+	}
+	return 0;
+
+cmd_qfail:
+	free_command_queues(cptvf, cqinfo);
+	return -ENOMEM;
+}
+
+static int32_t init_command_queues(struct cpt_vf *cptvf, uint32_t qlen,
+				   uint32_t nr_queues)
+{
+	int32_t ret;
+
+	if (!nr_queues)
+		return 0;
+
+	/* setup AE command queues */
+	ret = alloc_command_queues(cptvf, &cptvf->cqinfo, CPT_INST_SIZE,
+				   CPT_VQ_CHUNK_ALIGN, qlen, nr_queues);
+	if (ret) {
+		pr_err("failed to allocate AE command queues (%u)\n",
+		       nr_queues);
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
+static int32_t cptvf_sw_init(struct cpt_vf *cptvf, uint32_t qlen,
+			     uint32_t nr_queues)
+{
+	int32_t ret = 0;
+	uint32_t max_dev_queues = 0, nr_cpus = num_online_cpus();
+
+	max_dev_queues = CPT_NUM_QS_PER_VF;
+	/* possible cpus */
+	nr_queues = max_t(uint32_t, nr_cpus, nr_queues);
+	nr_queues = min_t(uint32_t, nr_queues, max_dev_queues);
+	cptvf->max_queues = nr_queues;
+	cptvf->nr_queues = nr_queues;
+	cptvf->qlen = qlen;
+
+	ret = init_command_queues(cptvf, qlen, nr_queues);
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
+static inline int cptvf_get_node_id(struct pci_dev *pdev)
+{
+	uint64_t addr = pci_resource_start(pdev, CPT_CSR_BAR);
+
+	return ((addr >> CPT_NODE_ID_SHIFT) & CPT_NODE_ID_MASK);
+}
+
+static void cptvf_disable_msix(struct cpt_vf *cptvf)
+{
+	if (cptvf->msix_enabled) {
+		pci_disable_msix(cptvf->pdev);
+		cptvf->msix_enabled = 0;
+		cptvf->num_vec = 0;
+	}
+}
+
+static int cptvf_enable_msix(struct cpt_vf *cptvf)
+{
+	int i, ret;
+
+	cptvf->num_vec = CPT_VF_MSIX_VECTORS;
+
+	for (i = 0; i < cptvf->num_vec; i++)
+		cptvf->msix_entries[i].entry = i;
+
+	ret = pci_enable_msix(cptvf->pdev, cptvf->msix_entries,
+			      cptvf->num_vec);
+	if (ret) {
+		dev_err(&cptvf->pdev->dev, "Request for #%d msix vectors failed\n",
+			cptvf->num_vec);
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
+	int irq;
+
+	for (irq = 0; irq < cptvf->num_vec; irq++) {
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
+void cptvf_write_vq_doorbell(struct cpt_vf *cptvf, uint32_t val)
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
+static void cptvf_write_vq_inprog(struct cpt_vf *cptvf, uint8_t val)
+{
+	union cptx_vqx_inprog vqx_inprg;
+
+	vqx_inprg.u = cpt_read_csr64(cptvf->reg_base, CPTX_VQX_INPROG(0, 0));
+	vqx_inprg.s.inflight = val;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_INPROG(0, 0), vqx_inprg.u);
+}
+
+static void cptvf_write_vq_done_numwait(struct cpt_vf *cptvf, uint32_t val)
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
+static void cptvf_write_vq_done_timewait(struct cpt_vf *cptvf, uint16_t val)
+{
+	union cptx_vqx_done_wait vqx_dwait;
+
+	vqx_dwait.u = cpt_read_csr64(cptvf->reg_base,
+				     CPTX_VQX_DONE_WAIT(0, 0));
+	vqx_dwait.s.time_wait = val;
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
+static uint64_t cptvf_read_vf_misc_intr_status(struct cpt_vf *cptvf)
+{
+	return cpt_read_csr64(cptvf->reg_base, CPTX_VQX_MISC_INT(0, 0));
+}
+
+static irqreturn_t cptvf_misc_intr_handler(int irq, void *cptvf_irq)
+{
+	struct cpt_vf *cptvf = (struct cpt_vf *)cptvf_irq;
+	uint64_t intr;
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
+						 int qno)
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
+static inline uint32_t cptvf_read_vq_done_count(struct cpt_vf *cptvf)
+{
+	union cptx_vqx_done vqx_done;
+
+	vqx_done.u = cpt_read_csr64(cptvf->reg_base, CPTX_VQX_DONE(0, 0));
+	return vqx_done.s.done;
+}
+
+static inline void cptvf_write_vq_done_ack(struct cpt_vf *cptvf,
+					   uint32_t ackcnt)
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
+static irqreturn_t cptvf_done_intr_handler(int irq, void *cptvf_irq)
+{
+	struct cpt_vf *cptvf = (struct cpt_vf *)cptvf_irq;
+	/* Read the number of completions */
+	uint32_t intr = cptvf_read_vq_done_count(cptvf);
+
+	cptvf->intcnt += intr;
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
+static int cptvf_register_misc_intr(struct cpt_vf *cptvf)
+{
+	int ret;
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
+static int cptvf_register_done_intr(struct cpt_vf *cptvf)
+{
+	int ret;
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
+	int32_t vec, cpu;
+	int32_t irqnum;
+
+	for (vec = 0; vec < cptvf->num_vec; vec++) {
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
+static void cptvf_write_vq_saddr(struct cpt_vf *cptvf, uint64_t val)
+{
+	union cptx_vqx_saddr vqx_saddr;
+
+	vqx_saddr.u = val;
+	cpt_write_csr64(cptvf->reg_base, CPTX_VQX_SADDR(0, 0), vqx_saddr.u);
+}
+
+void cptvf_device_init(struct cpt_vf *cptvf)
+{
+	uint64_t base_addr = 0;
+
+	cptvf->chip_id = CPTVF_81XX_PASS1_0;
+	/* Disable the VQ */
+	cptvf_write_vq_ctl(cptvf, 0);
+	/* Reset the doorbell */
+	cptvf_write_vq_doorbell(cptvf, 0);
+	/* Clear inflight */
+	cptvf_write_vq_inprog(cptvf, 0);
+	/* Write VQ SADDR */
+	/* TODO: for now only one queue, so hard coded */
+	base_addr = (uint64_t)(cptvf->cqinfo.queue[0].qhead->dma_addr);
+	cptvf_write_vq_saddr(cptvf, base_addr);
+	/* Configure timerhold / coalescence */
+	cptvf_write_vq_done_timewait(cptvf, CPT_TIMER_THOLD);
+	cptvf_write_vq_done_numwait(cptvf, CPT_COUNT_THOLD);
+	/* Enable the VQ */
+	cptvf_write_vq_ctl(cptvf, 1);
+	/* Flag the VF ready */
+	cptvf->flags |= CPT_FLAG_DEVICE_READY;
+}
+
+static int cptvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct cpt_vf *cptvf;
+	int    err;
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
+	cptvf->reg_base = pcim_iomap(pdev, CPT_CSR_BAR, 0);
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
+	cptvf->cqinfo.qchunksize = chunksize;
+	err = cptvf_sw_init(cptvf, qlen, CPT_NUM_QS_PER_VF);
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
+	cptvf->vfgrp = group;
+	err = cptvf_send_vf_to_grp_msg(cptvf);
+	if (err) {
+		dev_err(dev, "PF not responding to VF_GRP msg");
+		err = -EBUSY;
+		goto cptvf_err_release_regions;
+	}
+
+	cptvf->priority = priority;
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
+static int __init cptvf_init_module(void)
+{
+	int ret = -1;
+
+	pr_info("%s, ver %s\n", DRV_NAME, DRV_VERSION);
+	if (group < 0 || group > 7) {
+		pr_warn("Invalid group. Should be (0-7), setting to default 1.\n");
+		group = 1;
+	}
+
+	if (chunksize > CPT_INST_CHUNK_MAX_SIZE || chunksize <= 0) {
+		pr_warn("Invalid instruction chunk size. Should be (1-1023). Setting to default 1023\n");
+		chunksize = CPT_INST_CHUNK_MAX_SIZE;
+	}
+
+	if ((qlen > chunksize) && (qlen % chunksize != 0)) {
+		pr_warn("qlen should be multiple of chunksize when qlen > chunksize, rounding up qlen\n");
+		qlen += chunksize - (qlen % chunksize);
+	}
+
+	if (priority < 0 || priority > 1) {
+		pr_warn("Invalid VQ/VF priority. Should be (0-1), setting to default 0.\n");
+		priority = 0;
+	}
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
+MODULE_DESCRIPTION("Cavium Thunder CPT Physical Function Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(DRV_VERSION);
+MODULE_DEVICE_TABLE(pci, cptvf_id_table);
diff --git a/drivers/crypto/cavium/cpt/cptvf_mbox.c b/drivers/crypto/cavium/cpt/cptvf_mbox.c
new file mode 100644
index 0000000..80de249
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf_mbox.c
@@ -0,0 +1,208 @@
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
+		union cpt_chipid_vfid cid;
+
+		cid.u16 = mbx.data;
+		cptvf->pf_acked = true;
+		cptvf->vfid = cid.s.vfid;
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
+static int32_t cptvf_send_msg_to_pf_timeout(struct cpt_vf *cptvf,
+					    struct cpt_mbox *mbx)
+{
+	int timeout = CPT_MBOX_MSG_TIMEOUT;
+	int sleep = 10;
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
+int cptvf_check_pf_ready(struct cpt_vf *cptvf)
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
+int cptvf_send_vq_size_msg(struct cpt_vf *cptvf)
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
+int cptvf_send_vf_to_grp_msg(struct cpt_vf *cptvf)
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
+int cptvf_send_vf_priority_msg(struct cpt_vf *cptvf)
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
+int cptvf_send_vf_up(struct cpt_vf *cptvf)
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
+int cptvf_send_vf_down(struct cpt_vf *cptvf)
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
index 0000000..e6fc3f9
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -0,0 +1,655 @@
+/*
+ * Copyright (C) 2016 Cavium, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/bitmap.h>
+#include <linux/kdev_t.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
+#include <linux/poll.h>
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
+						    int32_t qlen)
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
+					   int32_t qno)
+{
+	struct pending_queue *queue = &pqinfo->queue[qno];
+
+	queue->front++;
+	if (unlikely(queue->front == pqinfo->qlen))
+		queue->front = 0;
+}
+
+static int32_t setup_sgio_components(struct cpt_vf *cptvf,
+				     struct buf_ptr *list,
+				     int32_t buf_count, uint8_t *buffer)
+{
+	int32_t ret = 0, i, j;
+	int32_t components;
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
+static inline int32_t setup_sgio_list(struct cpt_vf *cptvf,
+				      struct cpt_info_buffer *info,
+				      struct cpt_request_info *req)
+{
+	uint16_t g_size_bytes = 0, s_size_bytes = 0;
+	int32_t i = 0, ret = 0;
+	struct pci_dev *pdev = cptvf->pdev;
+
+	if ((req->incnt + req->outcnt) > MAX_SG_IN_OUT_CNT) {
+		pr_err("Requestes SG components are higher than supported\n");
+		ret = -EINVAL;
+		goto  scatter_gather_clean;
+	}
+
+	/* Setup gather (input) components */
+	info->g_size = (req->incnt + 3) / 4;
+	info->glist_cnt = req->incnt;
+	g_size_bytes = info->g_size * sizeof(struct sglist_component);
+	for (i = 0; i < req->incnt; i++) {
+		info->glist_ptr[i].vptr = req->in[i].ptr.addr;
+		info->glist_ptr[i].size = req->in[i].size;
+	}
+
+	info->gather_components = kzalloc((g_size_bytes), GFP_KERNEL);
+	if (!info->gather_components) {
+		ret = -ENOMEM;
+		goto  scatter_gather_clean;
+	}
+
+	ret = setup_sgio_components(cptvf, info->glist_ptr,
+				    info->glist_cnt,
+				    info->gather_components);
+	if (ret) {
+		pr_err("Failed to setup gather list\n");
+		ret = -EFAULT;
+		goto  scatter_gather_clean;
+	}
+
+	/* Setup scatter (output) components */
+	info->s_size = (req->outcnt + 3) / 4;
+	info->slist_cnt = req->outcnt;
+	s_size_bytes = info->s_size * sizeof(struct sglist_component);
+	for (i = 0; i < info->slist_cnt ; i++) {
+		info->slist_ptr[i].vptr = req->out[i].ptr.addr;
+		info->slist_ptr[i].size = req->out[i].size;
+		info->outptr[i] = req->out[i].ptr.addr;
+		info->outsize[i] = req->out[i].size;
+		info->total_out += info->outsize[i];
+	}
+
+	info->scatter_components = kzalloc((s_size_bytes), GFP_KERNEL);
+	if (!info->scatter_components) {
+		ret = -ENOMEM;
+		goto  scatter_gather_clean;
+	}
+
+	ret = setup_sgio_components(cptvf, info->slist_ptr,
+				    info->slist_cnt,
+				    info->scatter_components);
+	if (ret) {
+		pr_err("Failed to setup gather list\n");
+		ret = -EFAULT;
+		goto  scatter_gather_clean;
+	}
+
+	/* Create and initialize DPTR */
+	info->dlen = g_size_bytes + s_size_bytes + SG_LIST_HDR_SIZE;
+	info->in_buffer = kzalloc((info->dlen), GFP_KERNEL);
+	if (!info->in_buffer) {
+		ret = -ENOMEM;
+		goto  scatter_gather_clean;
+	}
+
+	((uint16_t *)info->in_buffer)[0] = info->slist_cnt;
+	((uint16_t *)info->in_buffer)[1] = info->glist_cnt;
+	((uint16_t *)info->in_buffer)[2] = 0;
+	((uint16_t *)info->in_buffer)[3] = 0;
+	byte_swap_64((uint64_t *)info->in_buffer);
+
+	memcpy(&info->in_buffer[8], info->gather_components,
+	       g_size_bytes);
+	memcpy(&info->in_buffer[8 + g_size_bytes],
+	       info->scatter_components, s_size_bytes);
+
+	info->dptr_baddr = dma_map_single(&pdev->dev,
+					       (void *)info->in_buffer,
+					       info->dlen,
+					       DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&pdev->dev, info->dptr_baddr)) {
+		pr_err("Mapping DPTR Failed %d\n", info->dlen);
+		ret = -EIO;
+		goto  scatter_gather_clean;
+	}
+
+	/* Create and initialize RPTR */
+	info->rlen = COMPLETION_CODE_SIZE;
+	info->out_buffer = kzalloc((info->rlen), GFP_KERNEL);
+	if (!info->out_buffer) {
+		ret = -ENOMEM;
+		goto  scatter_gather_clean;
+	}
+
+	*((uint64_t *)info->out_buffer) = ~((uint64_t)COMPLETION_CODE_INIT);
+	info->alternate_caddr = (uint64_t *)info->out_buffer;
+	info->rptr_baddr = dma_map_single(&pdev->dev,
+					       (void *)info->out_buffer,
+					       info->rlen,
+					       DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&pdev->dev, info->rptr_baddr)) {
+		pr_err("Mapping RPTR Failed %d\n", info->rlen);
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
+int32_t send_cpt_command(struct cpt_vf *cptvf, union cpt_inst_s *cmd,
+			 uint32_t qno)
+{
+	struct command_qinfo *qinfo = NULL;
+	struct command_queue *queue;
+	struct command_chunk *chunk;
+	uint8_t *ent;
+	int32_t ret = 0;
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
+	int32_t i;
+	struct pci_dev *pdev = cptvf->pdev;
+
+	if (info->dptr_baddr) {
+		dma_unmap_single(&pdev->dev, info->dptr_baddr,
+				 info->dlen, DMA_BIDIRECTIONAL);
+		info->dptr_baddr = 0;
+	}
+
+	if (info->rptr_baddr) {
+		dma_unmap_single(&pdev->dev, info->rptr_baddr,
+				 info->rlen, DMA_BIDIRECTIONAL);
+		info->rptr_baddr = 0;
+	}
+
+	if (info->comp_baddr) {
+		dma_unmap_single(&pdev->dev, info->comp_baddr,
+				 sizeof(union cpt_res_s), DMA_BIDIRECTIONAL);
+		info->comp_baddr = 0;
+	}
+
+	if (info->dma_mode == DMA_GATHER_SCATTER) {
+		for (i = 0; i < info->slist_cnt; i++) {
+			if (info->slist_ptr[i].dma_addr) {
+				dma_unmap_single(&pdev->dev,
+						 info->slist_ptr[i].dma_addr,
+						 info->slist_ptr[i].size,
+						 DMA_BIDIRECTIONAL);
+				info->slist_ptr[i].dma_addr = 0ULL;
+			}
+		}
+		info->slist_cnt = 0;
+		if (info->scatter_components)
+			kzfree(info->scatter_components);
+
+		for (i = 0; i < info->glist_cnt; i++) {
+			if (info->glist_ptr[i].dma_addr) {
+				dma_unmap_single(&pdev->dev,
+						 info->glist_ptr[i].dma_addr,
+						 info->glist_ptr[i].size,
+						 DMA_BIDIRECTIONAL);
+				info->glist_ptr[i].dma_addr = 0ULL;
+			}
+		}
+		info->glist_cnt = 0;
+		if (info->gather_components)
+			kzfree((info->gather_components));
+	}
+
+	if (info->out_buffer) {
+		kzfree((info->out_buffer));
+		info->out_buffer = NULL;
+	}
+
+	if (info->in_buffer) {
+		kzfree((info->in_buffer));
+		info->in_buffer = NULL;
+	}
+
+	if (info->completion_addr) {
+		kzfree(((void *)info->completion_addr));
+		info->completion_addr = NULL;
+	}
+
+	if (info) {
+		kzfree((info));
+		info = NULL;
+	}
+}
+
+void do_post_process(struct cpt_vf *cptvf, struct cpt_info_buffer *info)
+{
+	uint64_t *p;
+	uint32_t i;
+
+	if (!info || !cptvf) {
+		pr_err("Input params are incorrect for post processing\n");
+		return;
+	}
+
+	if (info->rlen) {
+		for (i = 0; i < info->slist_cnt; i++) {
+			if (info->outunit[i] == UNIT_64_BIT) {
+				p = (uint64_t *)info->slist_ptr[i].vptr;
+				*p = cpu_to_be64(*p);
+			}
+		}
+	}
+
+	do_request_cleanup(cptvf, info);
+}
+
+static inline void process_pending_queue(struct cpt_vf *cptvf,
+					 struct pending_qinfo *pqinfo,
+					 int32_t qno)
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
+			    (info->time_in + (DEFAULT_COMMAND_TIMEOUT * HZ)))) {
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
+		info->status = 0;
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
+int32_t process_request(struct cpt_vf *cptvf, struct cpt_request_info *req)
+{
+	int32_t ret = 0, clear = 0, queue = 0;
+	struct cpt_info_buffer *info = NULL;
+	struct cptvf_request *cpt_req = NULL;
+	union ctrl_info *ctrl = NULL;
+	struct pending_entry *pentry = NULL;
+	struct pending_queue *pqueue = NULL;
+	struct pci_dev *pdev = cptvf->pdev;
+	uint64_t key_handle = 0ULL;
+	uint8_t group = 0;
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
+	key_handle = req->handle;
+
+	info->cptvf = cptvf;
+	info->outcnt = req->outcnt;
+	info->req_type = ctrl->s.req_mode;
+	info->dma_mode = ctrl->s.dma_mode;
+	info->dlen   = cpt_req->dlen;
+	/* Add 8-bytes more for microcode completion code */
+	info->rlen   = ROUNDUP8(req->rlen + COMPLETION_CODE_SIZE);
+
+	group = ctrl->s.grp;
+	ret = setup_sgio_list(cptvf, info, req);
+	if (ret) {
+		pr_err("Setting up SG list failed");
+		goto request_cleanup;
+	}
+
+	cpt_req->dlen = info->dlen;
+	info->opcode = cpt_req->opcode.flags;
+	/*
+	 * Get buffer for union cpt_res_s response
+	 * structure and its physical address
+	 */
+	info->completion_addr = kzalloc(sizeof(union cpt_res_s),
+					     GFP_KERNEL | GFP_ATOMIC);
+	*((uint8_t *)(info->completion_addr)) = COMPLETION_CODE_INIT;
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
+	/*queue = SMP_PROCESSOR_ID() % cptvf->nr_queues;*/
+	/* Always queue 0, because 1 queue per VF */
+	queue = 0;
+	info->queue = queue;
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
+	pentry->done = false;
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
+	info->status = ERR_REQ_PENDING;
+	info->time_in = jiffies;
+
+	/* Create the CPT_INST_S type command for HW intrepretation */
+	cptinst.s.doneint = true;
+	cptinst.s.res_addr = (uint64_t)info->comp_baddr;
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
+	/* Non-Blocking request */
+	req->request_id = (uint64_t)(info);
+	req->status = -EAGAIN;
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
+void vq_post_process(struct cpt_vf *cptvf, uint32_t qno)
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
+int32_t cptvf_do_request(void *vfdev, struct cpt_request_info *req)
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
+	cptvf->reqmode = req->ctrl.s.req_mode;
+
+	return process_request(cptvf, req);
+}
diff --git a/drivers/crypto/cavium/cpt/request_manager.h b/drivers/crypto/cavium/cpt/request_manager.h
new file mode 100644
index 0000000..d18d95b
--- /dev/null
+++ b/drivers/crypto/cavium/cpt/request_manager.h
@@ -0,0 +1,221 @@
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
+
+#if defined(__BIG_ENDIAN_BITFIELD)
+#define COMPLETION_CODE_SHIFT     56
+#else
+#define COMPLETION_CODE_SHIFT      0
+#endif
+
+#define PENDING_THOLD  100
+
+#define MAX_SG_IN_OUT_CNT (25u)
+#define SG_LIST_HDR_SIZE  (8u)
+
+union data_ptr {
+	uint64_t addr64;
+	uint8_t *addr;
+};
+
+struct cpt_buffer {
+	uint8_t type; /**< How to interpret the buffer */
+	uint8_t reserved0;
+	uint16_t size; /**< Sizeof of the data */
+	uint16_t offset;
+	uint16_t reserved1;
+	union data_ptr ptr; /**< Pointer to data */
+};
+
+union ctrl_info {
+	uint32_t flags;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		uint32_t reserved0:24;
+		uint32_t grp:3; /**< Group bits */
+		uint32_t dma_mode:2; /**< DMA mode */
+		uint32_t req_mode:2; /**< Requeset mode BLOCKING/NONBLOCKING*/
+		uint32_t se_req:1;/**< To SE core */
+#else
+		uint32_t se_req:1; /**< To SE core */
+		uint32_t req_mode:2; /**< Requeset mode BLOCKING/NONBLOCKING*/
+		uint32_t dma_mode:2; /**< DMA mode */
+		uint32_t grp:3; /* Group bits */
+		uint32_t reserved0:24;
+#endif
+	} s;
+};
+
+union opcode_info {
+	uint16_t flags;
+	struct {
+		uint8_t major;
+		uint8_t minor;
+	} s;
+};
+
+struct cptvf_request {
+	union opcode_info opcode;
+	uint16_t param1;
+	uint16_t param2;
+	uint16_t dlen;
+};
+
+#define MAX_BUF_CNT	16
+
+struct cpt_request_info {
+	uint8_t incnt; /**< Number of input buffers */
+	uint8_t outcnt; /**< Number of output buffers */
+	uint8_t ctxl; /**< Context length, if 0, then INLINE */
+	uint16_t rlen; /**< Output length */
+	union ctrl_info ctrl; /**< User control information */
+
+	struct cptvf_request req; /**< Request Information (Core specific) */
+
+	uint64_t handle; /**< key/context handle */
+	uint64_t request_id; /**< Request ID */
+
+	struct cpt_buffer in[MAX_BUF_CNT];
+	struct cpt_buffer out[MAX_BUF_CNT];
+
+	void (*callback)(int, void *); /**< Kernel ASYNC request callabck */
+	void *callback_arg; /**< Kernel ASYNC request callabck arg */
+
+	uint32_t status; /**< Request status */
+};
+
+enum {
+	UNIT_8_BIT,
+	UNIT_16_BIT,
+	UNIT_32_BIT,
+	UNIT_64_BIT
+};
+
+struct sglist_component {
+	union {
+		uint64_t len;
+		struct {
+			uint16_t len0;
+			uint16_t len1;
+			uint16_t len2;
+			uint16_t len3;
+		} s;
+	} u;
+	uint64_t ptr0;
+	uint64_t ptr1;
+	uint64_t ptr2;
+	uint64_t ptr3;
+};
+
+struct buf_ptr {
+	uint8_t *vptr;
+	dma_addr_t dma_addr;
+	uint16_t size;
+};
+
+#define MAX_OUTCNT	10
+#define MAX_INCNT	10
+
+struct cpt_info_buffer {
+	struct cpt_vf *cptvf;
+	uint8_t req_type;
+	uint8_t dma_mode;
+
+	uint16_t opcode;
+	uint8_t queue;
+	uint8_t extra_time;
+	uint8_t is_ae;
+
+	uint16_t glist_cnt;
+	uint16_t slist_cnt;
+	uint16_t g_size;
+	uint16_t s_size;
+
+	uint32_t outcnt;
+	uint32_t status;
+
+	unsigned long time_in;
+	uint64_t request_id;
+
+	uint32_t dlen;
+	uint32_t rlen;
+	uint32_t total_in;
+	uint32_t total_out;
+	uint64_t dptr_baddr;
+	uint64_t rptr_baddr;
+	uint64_t comp_baddr;
+	uint8_t *in_buffer;
+	uint8_t *out_buffer;
+	uint8_t *gather_components;
+	uint8_t *scatter_components;
+	uint32_t outsize[MAX_OUTCNT];
+	uint32_t outunit[MAX_OUTCNT];
+	uint8_t *outptr[MAX_OUTCNT];
+
+	struct pending_entry *pentry;
+	volatile uint64_t *completion_addr;
+	volatile uint64_t *alternate_caddr;
+
+	struct buf_ptr glist_ptr[MAX_INCNT];
+	struct buf_ptr slist_ptr[MAX_OUTCNT];
+};
+
+/*
+ * CPT_INST_S software command definitions
+ * Words EI (0-3)
+ */
+union vq_cmd_word0 {
+	uint64_t u64;
+	struct {
+		uint16_t opcode;
+		uint16_t param1;
+		uint16_t param2;
+		uint16_t dlen;
+	} s;
+};
+
+union vq_cmd_word3 {
+	uint64_t u64;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		uint64_t grp	: 3;
+		uint64_t cptr	: 61;
+#else
+		uint64_t cptr	: 61;
+		uint64_t grp	: 3;
+#endif
+	} s;
+};
+
+struct cpt_vq_command {
+	union vq_cmd_word0 cmd;
+	uint64_t dptr;
+	uint64_t rptr;
+	union vq_cmd_word3 cptr;
+};
+
+#if defined(__BIG_ENDIAN_BITFIELD)
+#define set_scatter_chunks(value, scatter_component)	{\
+	(value) |= (((uint64_t)scatter_component) << 25); }
+#else
+#define set_scatter_chunks(value, scatter_component)	{\
+	(value) |= (((uint64_t)scatter_component) << 32); }
+#endif
+
+void vq_post_process(struct cpt_vf *cptvf, uint32_t qno);
+int32_t process_request(struct cpt_vf *cptvf,
+			struct cpt_request_info *kern_req);
+#endif /* __REQUEST_MANGER_H */
-- 
2.1.4

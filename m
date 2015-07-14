From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH  v2 3/3] crypto: qat - Add support for RSA algorithm
Date: Tue, 14 Jul 2015 11:33:00 -0700
Message-ID: <20150714183259.18949.581.stgit@tstruk-mobl1>
References: <20150714183243.18949.93255.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:25821 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbbGNSdr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2015 14:33:47 -0400
In-Reply-To: <20150714183243.18949.93255.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add RSA support to QAT driver.
Removed unused RNG rings.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/Kconfig                     |    2 
 drivers/crypto/qat/qat_common/Makefile         |    1 
 drivers/crypto/qat/qat_common/adf_common_drv.h |   10 
 drivers/crypto/qat/qat_common/adf_init.c       |    4 
 drivers/crypto/qat/qat_common/icp_qat_fw.h     |    2 
 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h |  112 ++++
 drivers/crypto/qat/qat_common/qat_algs.c       |    5 
 drivers/crypto/qat/qat_common/qat_asym_algs.c  |  613 ++++++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_crypto.c     |   19 -
 drivers/crypto/qat/qat_common/qat_crypto.h     |    2 
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c      |   12 
 11 files changed, 743 insertions(+), 39 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_asym_algs.c

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 6fdb9e8..8629469 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -3,6 +3,8 @@ config CRYPTO_DEV_QAT
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_AKCIPHER
+	select CRYPTO_RSA
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index e0424dc..e69cdbb 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -8,6 +8,7 @@ intel_qat-objs := adf_cfg.o \
 	adf_transport.o \
 	qat_crypto.o \
 	qat_algs.o \
+	qat_asym_algs.o \
 	qat_uclo.o \
 	qat_hal.o
 
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 1e82ad4..3c33fee 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -55,7 +55,7 @@
 
 #define ADF_MAJOR_VERSION	0
 #define ADF_MINOR_VERSION	1
-#define ADF_BUILD_VERSION	3
+#define ADF_BUILD_VERSION	4
 #define ADF_DRV_VERSION		__stringify(ADF_MAJOR_VERSION) "." \
 				__stringify(ADF_MINOR_VERSION) "." \
 				__stringify(ADF_BUILD_VERSION)
@@ -94,6 +94,11 @@ struct service_hndl {
 	int admin;
 };
 
+static inline int get_current_node(void)
+{
+	return cpu_data(current_thread_info()->cpu).phys_proc_id;
+}
+
 int adf_service_register(struct service_hndl *service);
 int adf_service_unregister(struct service_hndl *service);
 
@@ -141,10 +146,13 @@ int qat_crypto_unregister(void);
 struct qat_crypto_instance *qat_crypto_get_instance_node(int node);
 void qat_crypto_put_instance(struct qat_crypto_instance *inst);
 void qat_alg_callback(void *resp);
+void qat_alg_asym_callback(void *resp);
 int qat_algs_init(void);
 void qat_algs_exit(void);
 int qat_algs_register(void);
 int qat_algs_unregister(void);
+int qat_asym_algs_register(void);
+void qat_asym_algs_unregister(void);
 
 int qat_hal_init(struct adf_accel_dev *accel_dev);
 void qat_hal_deinit(struct icp_qat_fw_loader_handle *handle);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 245f432..7f9dffa 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -257,7 +257,7 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	set_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
-	if (qat_algs_register()) {
+	if (qat_algs_register() || qat_asym_algs_register()) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to register crypto algs\n");
 		set_bit(ADF_STATUS_STARTING, &accel_dev->status);
@@ -296,6 +296,8 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to unregister crypto algs\n");
 
+	qat_asym_algs_unregister();
+
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (service->admin)
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw.h b/drivers/crypto/qat/qat_common/icp_qat_fw.h
index f1e30e2..46747f0 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw.h
@@ -249,6 +249,8 @@ struct icp_qat_fw_comn_resp {
 
 #define QAT_COMN_RESP_CRYPTO_STATUS_BITPOS 7
 #define QAT_COMN_RESP_CRYPTO_STATUS_MASK 0x1
+#define QAT_COMN_RESP_PKE_STATUS_BITPOS 6
+#define QAT_COMN_RESP_PKE_STATUS_MASK 0x1
 #define QAT_COMN_RESP_CMP_STATUS_BITPOS 5
 #define QAT_COMN_RESP_CMP_STATUS_MASK 0x1
 #define QAT_COMN_RESP_XLAT_STATUS_BITPOS 4
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_pke.h b/drivers/crypto/qat/qat_common/icp_qat_fw_pke.h
new file mode 100644
index 0000000..0d7a9b5
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_pke.h
@@ -0,0 +1,112 @@
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
+	* Redistributions of source code must retain the above copyright
+	  notice, this list of conditions and the following disclaimer.
+	* Redistributions in binary form must reproduce the above copyright
+	  notice, this list of conditions and the following disclaimer in
+	  the documentation and/or other materials provided with the
+	  distribution.
+	* Neither the name of Intel Corporation nor the names of its
+	  contributors may be used to endorse or promote products derived
+	  from this software without specific prior written permission.
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
+#ifndef _ICP_QAT_FW_PKE_
+#define _ICP_QAT_FW_PKE_
+
+#include "icp_qat_fw.h"
+
+struct icp_qat_fw_req_hdr_pke_cd_pars {
+	u64 content_desc_addr;
+	u32 content_desc_resrvd;
+	u32 func_id;
+};
+
+struct icp_qat_fw_req_pke_mid {
+	u64 opaque;
+	u64 src_data_addr;
+	u64 dest_data_addr;
+};
+
+struct icp_qat_fw_req_pke_hdr {
+	u8 resrvd1;
+	u8 resrvd2;
+	u8 service_type;
+	u8 hdr_flags;
+	u16 comn_req_flags;
+	u16 resrvd4;
+	struct icp_qat_fw_req_hdr_pke_cd_pars cd_pars;
+};
+
+struct icp_qat_fw_pke_request {
+	struct icp_qat_fw_req_pke_hdr pke_hdr;
+	struct icp_qat_fw_req_pke_mid pke_mid;
+	u8 output_param_count;
+	u8 input_param_count;
+	u16 resrvd1;
+	u32 resrvd2;
+	u64 next_req_adr;
+};
+
+struct icp_qat_fw_resp_pke_hdr {
+	u8 resrvd1;
+	u8 resrvd2;
+	u8 response_type;
+	u8 hdr_flags;
+	u16 comn_resp_flags;
+	u16 resrvd4;
+};
+
+struct icp_qat_fw_pke_resp {
+	struct icp_qat_fw_resp_pke_hdr pke_resp_hdr;
+	u64 opaque;
+	u64 src_data_addr;
+	u64 dest_data_addr;
+};
+
+#define ICP_QAT_FW_PKE_HDR_VALID_FLAG_BITPOS              7
+#define ICP_QAT_FW_PKE_HDR_VALID_FLAG_MASK                0x1
+#define ICP_QAT_FW_PKE_RESP_PKE_STAT_GET(status_word) \
+	QAT_FIELD_GET(((status_word >> ICP_QAT_FW_COMN_ONE_BYTE_SHIFT) & \
+		ICP_QAT_FW_COMN_SINGLE_BYTE_MASK), \
+		QAT_COMN_RESP_PKE_STATUS_BITPOS, \
+		QAT_COMN_RESP_PKE_STATUS_MASK)
+
+#define ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(hdr_t, val) \
+	QAT_FIELD_SET((hdr_t.hdr_flags), (val), \
+		ICP_QAT_FW_PKE_HDR_VALID_FLAG_BITPOS, \
+		ICP_QAT_FW_PKE_HDR_VALID_FLAG_MASK)
+#endif
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 067402c..31abfd0 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -129,11 +129,6 @@ struct qat_alg_ablkcipher_ctx {
 	spinlock_t lock;	/* protects qat_alg_ablkcipher_ctx struct */
 };
 
-static int get_current_node(void)
-{
-	return cpu_data(current_thread_info()->cpu).phys_proc_id;
-}
-
 static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
 {
 	switch (qat_hash_alg) {
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
new file mode 100644
index 0000000..5db476c
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -0,0 +1,613 @@
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
+	* Redistributions of source code must retain the above copyright
+	  notice, this list of conditions and the following disclaimer.
+	* Redistributions in binary form must reproduce the above copyright
+	  notice, this list of conditions and the following disclaimer in
+	  the documentation and/or other materials provided with the
+	  distribution.
+	* Neither the name of Intel Corporation nor the names of its
+	  contributors may be used to endorse or promote products derived
+	  from this software without specific prior written permission.
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
+#include <linux/module.h>
+#include <crypto/internal/rsa.h>
+#include <crypto/internal/akcipher.h>
+#include <crypto/akcipher.h>
+#include <linux/dma-mapping.h>
+#include "icp_qat_fw_pke.h"
+#include "adf_accel_devices.h"
+#include "adf_transport.h"
+#include "adf_common_drv.h"
+#include "qat_crypto.h"
+
+struct qat_rsa_input_params {
+	union {
+		struct {
+			dma_addr_t m;
+			dma_addr_t e;
+			dma_addr_t n;
+		} enc;
+		struct {
+			dma_addr_t c;
+			dma_addr_t d;
+			dma_addr_t n;
+		} dec;
+		u64 in_tab[8];
+	};
+} __packed __aligned(64);
+
+struct qat_rsa_output_params {
+	union {
+		struct {
+			dma_addr_t c;
+		} enc;
+		struct {
+			dma_addr_t m;
+		} dec;
+		u64 out_tab[8];
+	};
+} __packed __aligned(64);
+
+struct qat_rsa_ctx {
+	char *n;
+	char *e;
+	char *d;
+	dma_addr_t dma_n;
+	dma_addr_t dma_e;
+	dma_addr_t dma_d;
+	struct rsa_key key;
+	unsigned int key_sz;
+	struct qat_crypto_instance *inst;
+	struct crypto_akcipher *fallback;
+} __packed __aligned(64);
+
+struct qat_rsa_request {
+	struct qat_rsa_input_params in;
+	struct qat_rsa_output_params out;
+	dma_addr_t phy_in;
+	dma_addr_t phy_out;
+	char *src_align;
+	struct icp_qat_fw_pke_request req;
+	struct qat_rsa_ctx *ctx;
+	unsigned int param_sz;
+	int err;
+} __aligned(64);
+
+static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
+{
+	struct akcipher_request *areq = (void *)(__force long)resp->opaque;
+	struct qat_rsa_request *req = PTR_ALIGN(akcipher_request_ctx(areq), 64);
+	struct device *dev = &GET_DEV(req->ctx->inst->accel_dev);
+	int err = ICP_QAT_FW_PKE_RESP_PKE_STAT_GET(
+				resp->pke_resp_hdr.comn_resp_flags);
+	char *ptr = areq->dst;
+
+	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
+
+	if (req->src_align)
+		dma_free_coherent(dev, req->param_sz, req->src_align,
+				  req->in.enc.m);
+	else
+		dma_unmap_single(dev, req->in.enc.m, req->param_sz,
+				 DMA_TO_DEVICE);
+
+	dma_unmap_single(dev, req->out.enc.c, req->param_sz, DMA_FROM_DEVICE);
+	dma_unmap_single(dev, req->phy_in, sizeof(struct qat_rsa_input_params),
+			 DMA_TO_DEVICE);
+	dma_unmap_single(dev, req->phy_out,
+			 sizeof(struct qat_rsa_output_params),
+			 DMA_TO_DEVICE);
+
+	areq->dst_len = req->param_sz;
+	/* Need to set the corect length of the output */
+	while (!(*ptr) && areq->dst_len) {
+		areq->dst_len--;
+		ptr++;
+	}
+
+	if (areq->dst_len != req->param_sz)
+		memcpy(areq->dst, ptr, areq->dst_len);
+
+	akcipher_request_complete(areq, err);
+}
+
+void qat_alg_asym_callback(void *_resp)
+{
+	struct icp_qat_fw_pke_resp *resp = _resp;
+
+	qat_rsa_cb(resp);
+}
+
+#define PKE_RSA_EP_512 0x1c161b21
+#define PKE_RSA_EP_1024 0x35111bf7
+#define PKE_RSA_EP_1536 0x4d111cdc
+#define PKE_RSA_EP_2048 0x6e111dba
+#define PKE_RSA_EP_3072 0x7d111ea3
+#define PKE_RSA_EP_4096 0xa5101f7e
+
+static unsigned long qat_rsa_enc_fn_id(unsigned int len)
+{
+	unsigned int bitslen = len << 3;
+
+	switch (bitslen) {
+	case 512:
+		return PKE_RSA_EP_512;
+	case 1024:
+		return PKE_RSA_EP_1024;
+	case 1536:
+		return PKE_RSA_EP_1536;
+	case 2048:
+		return PKE_RSA_EP_2048;
+	case 3072:
+		return PKE_RSA_EP_3072;
+	case 4096:
+		return PKE_RSA_EP_4096;
+	default:
+		return 0;
+	};
+}
+
+#define PKE_RSA_DP1_512 0x1c161b3c
+#define PKE_RSA_DP1_1024 0x35111c12
+#define PKE_RSA_DP1_1536 0x4d111cf7
+#define PKE_RSA_DP1_2048 0x6e111dda
+#define PKE_RSA_DP1_3072 0x7d111ebe
+#define PKE_RSA_DP1_4096 0xa5101f98
+
+static unsigned long qat_rsa_dec_fn_id(unsigned int len)
+{
+	unsigned int bitslen = len << 3;
+
+	switch (bitslen) {
+	case 512:
+		return PKE_RSA_DP1_512;
+	case 1024:
+		return PKE_RSA_DP1_1024;
+	case 1536:
+		return PKE_RSA_DP1_1536;
+	case 2048:
+		return PKE_RSA_DP1_2048;
+	case 3072:
+		return PKE_RSA_DP1_3072;
+	case 4096:
+		return PKE_RSA_DP1_4096;
+	default:
+		return 0;
+	};
+}
+
+static int qat_rsa_enc(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct qat_crypto_instance *inst = ctx->inst;
+	const struct rsa_key *pkey = &ctx->key;
+	struct device *dev = &GET_DEV(inst->accel_dev);
+	struct qat_rsa_request *qat_req =
+			PTR_ALIGN(akcipher_request_ctx(req), 64);
+	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	int ret, ctr = 0;
+
+	if (ctx->fallback) {
+		akcipher_request_set_tfm(req, ctx->fallback);
+		return crypto_akcipher_encrypt(req);
+	}
+
+	if (unlikely(!pkey->n || !pkey->e))
+		return -EINVAL;
+
+	qat_req->param_sz = ctx->key_sz;
+	if (req->dst_len < qat_req->param_sz) {
+		req->dst_len = qat_req->param_sz;
+		return -EOVERFLOW;
+	}
+	memset(msg, '\0', sizeof(*msg));
+	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
+					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
+	msg->pke_hdr.cd_pars.func_id = qat_rsa_enc_fn_id(qat_req->param_sz);
+	if (unlikely(!msg->pke_hdr.cd_pars.func_id))
+		return -EINVAL;
+
+	qat_req->ctx = ctx;
+	msg->pke_hdr.service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_PKE;
+	msg->pke_hdr.comn_req_flags =
+		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
+					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
+
+	qat_req->in.enc.e = ctx->dma_e;
+	qat_req->in.enc.n = ctx->dma_n;
+	ret = -ENOMEM;
+
+	/*
+	 * src can be of any size in valid range, but HW expects it to be the
+	 * same as modulo n so in case it is different we need to allocate a
+	 * new buf and copy src data.
+	 * In other case we just need to map the user provided buffer.
+	 */
+	if (req->src_len < ctx->key_sz) {
+		int shift = ctx->key_sz - req->src_len;
+
+		qat_req->src_align = dma_zalloc_coherent(dev, ctx->key_sz,
+							 &qat_req->in.enc.m,
+							 GFP_KERNEL);
+		if (unlikely(!qat_req->src_align))
+			return ret;
+
+		memcpy(qat_req->src_align + shift, req->src, req->src_len);
+	} else {
+		qat_req->src_align = NULL;
+		qat_req->in.enc.m = dma_map_single(dev, req->src, req->src_len,
+					   DMA_TO_DEVICE);
+	}
+	qat_req->in.in_tab[3] = 0;
+	qat_req->out.enc.c = dma_map_single(dev, req->dst, req->dst_len,
+					    DMA_FROM_DEVICE);
+	qat_req->out.out_tab[1] = 0;
+	qat_req->phy_in = dma_map_single(dev, &qat_req->in.enc.m,
+					 sizeof(struct qat_rsa_input_params),
+					 DMA_TO_DEVICE);
+	qat_req->phy_out = dma_map_single(dev, &qat_req->out.enc.c,
+					  sizeof(struct qat_rsa_output_params),
+					    DMA_TO_DEVICE);
+
+	if (unlikely((!qat_req->src_align &&
+		      dma_mapping_error(dev, qat_req->in.enc.m)) ||
+		     dma_mapping_error(dev, qat_req->out.enc.c) ||
+		     dma_mapping_error(dev, qat_req->phy_in) ||
+		     dma_mapping_error(dev, qat_req->phy_out)))
+		goto unmap;
+
+	msg->pke_mid.src_data_addr = qat_req->phy_in;
+	msg->pke_mid.dest_data_addr = qat_req->phy_out;
+	msg->pke_mid.opaque = (uint64_t)(__force long)req;
+	msg->input_param_count = 3;
+	msg->output_param_count = 1;
+	do {
+		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+	} while (ret == -EBUSY && ctr++ < 100);
+
+	if (!ret)
+		return -EINPROGRESS;
+unmap:
+	if (qat_req->src_align)
+		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
+				  qat_req->in.enc.m);
+	else
+		if (!dma_mapping_error(dev, qat_req->in.enc.m))
+			dma_unmap_single(dev, qat_req->in.enc.m,
+					 qat_req->param_sz,
+					 DMA_TO_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->out.enc.c))
+		dma_unmap_single(dev, qat_req->out.enc.c, qat_req->param_sz,
+				 DMA_FROM_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->phy_in))
+		dma_unmap_single(dev, qat_req->phy_in,
+				 sizeof(struct qat_rsa_input_params),
+				 DMA_TO_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->phy_out))
+		dma_unmap_single(dev, qat_req->phy_out,
+				 sizeof(struct qat_rsa_output_params),
+				 DMA_TO_DEVICE);
+	return ret;
+}
+
+static int qat_rsa_dec(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct qat_crypto_instance *inst = ctx->inst;
+	const struct rsa_key *pkey = &ctx->key;
+	struct device *dev = &GET_DEV(inst->accel_dev);
+	struct qat_rsa_request *qat_req =
+			PTR_ALIGN(akcipher_request_ctx(req), 64);
+	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	int ret, ctr = 0;
+
+	if (ctx->fallback) {
+		akcipher_request_set_tfm(req, ctx->fallback);
+		return crypto_akcipher_decrypt(req);
+	}
+
+	if (unlikely(!pkey->n || !pkey->d))
+		return -EINVAL;
+
+	qat_req->param_sz = ctx->key_sz;
+	if (req->dst_len < qat_req->param_sz) {
+		req->dst_len = qat_req->param_sz;
+		return -EOVERFLOW;
+	}
+	memset(msg, '\0', sizeof(*msg));
+	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
+					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
+	msg->pke_hdr.cd_pars.func_id = qat_rsa_dec_fn_id(qat_req->param_sz);
+	if (unlikely(!msg->pke_hdr.cd_pars.func_id))
+		return -EINVAL;
+
+	qat_req->ctx = ctx;
+	msg->pke_hdr.service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_PKE;
+	msg->pke_hdr.comn_req_flags =
+		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
+					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
+
+	qat_req->in.dec.d = ctx->dma_d;
+	qat_req->in.dec.n = ctx->dma_n;
+	ret = -ENOMEM;
+
+	/*
+	 * src can be of any size in valid range, but HW expects it to be the
+	 * same as modulo n so in case it is different we need to allocate a
+	 * new buf and copy src data.
+	 * In other case we just need to map the user provided buffer.
+	 */
+	if (req->src_len < ctx->key_sz) {
+		int shift = ctx->key_sz - req->src_len;
+
+		qat_req->src_align = dma_zalloc_coherent(dev, ctx->key_sz,
+							 &qat_req->in.dec.c,
+							 GFP_KERNEL);
+		if (unlikely(!qat_req->src_align))
+			return ret;
+
+		memcpy(qat_req->src_align + shift, req->src, req->src_len);
+	} else {
+		qat_req->src_align = NULL;
+		qat_req->in.dec.c = dma_map_single(dev, req->src, req->src_len,
+						   DMA_TO_DEVICE);
+	}
+	qat_req->in.in_tab[3] = 0;
+	qat_req->out.dec.m = dma_map_single(dev, req->dst, req->dst_len,
+					    DMA_FROM_DEVICE);
+	qat_req->out.out_tab[1] = 0;
+	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dec.c,
+					 sizeof(struct qat_rsa_input_params),
+					 DMA_TO_DEVICE);
+	qat_req->phy_out = dma_map_single(dev, &qat_req->out.dec.m,
+					  sizeof(struct qat_rsa_output_params),
+					    DMA_TO_DEVICE);
+
+	if (unlikely((!qat_req->src_align &&
+		      dma_mapping_error(dev, qat_req->in.dec.c)) ||
+		     dma_mapping_error(dev, qat_req->out.dec.m) ||
+		     dma_mapping_error(dev, qat_req->phy_in) ||
+		     dma_mapping_error(dev, qat_req->phy_out)))
+		goto unmap;
+
+	msg->pke_mid.src_data_addr = qat_req->phy_in;
+	msg->pke_mid.dest_data_addr = qat_req->phy_out;
+	msg->pke_mid.opaque = (uint64_t)(__force long)req;
+	msg->input_param_count = 3;
+	msg->output_param_count = 1;
+	do {
+		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+	} while (ret == -EBUSY && ctr++ < 100);
+
+	if (!ret)
+		return -EINPROGRESS;
+unmap:
+	if (qat_req->src_align)
+		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
+				  qat_req->in.dec.c);
+	else
+		if (!dma_mapping_error(dev, qat_req->in.dec.c))
+			dma_unmap_single(dev, qat_req->in.dec.c,
+					 qat_req->param_sz,
+					 DMA_TO_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->out.dec.m))
+		dma_unmap_single(dev, qat_req->out.dec.m, qat_req->param_sz,
+				 DMA_FROM_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->phy_in))
+		dma_unmap_single(dev, qat_req->phy_in,
+				 sizeof(struct qat_rsa_input_params),
+				 DMA_TO_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->phy_out))
+		dma_unmap_single(dev, qat_req->phy_out,
+				 sizeof(struct qat_rsa_output_params),
+				 DMA_TO_DEVICE);
+	return ret;
+}
+
+static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
+			  unsigned int keylen)
+{
+	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
+	struct rsa_key *pkey = &ctx->key;
+	int ret, len, shift;
+
+	/* Free the old key if any */
+	if (ctx->key_sz) {
+		if (ctx->n)
+			dma_free_coherent(dev, ctx->key_sz, ctx->n, ctx->dma_n);
+		if (ctx->e)
+			dma_free_coherent(dev, ctx->key_sz, ctx->e, ctx->dma_e);
+		if (ctx->d) {
+			memset(ctx->d, '\0', ctx->key_sz);
+			dma_free_coherent(dev, ctx->key_sz, ctx->d, ctx->dma_d);
+		}
+	} else if (ctx->fallback) {
+		crypto_free_akcipher(ctx->fallback);
+	}
+
+	ret = rsa_parse_key(pkey, key, keylen);
+	if (ret)
+		return ret;
+
+	if (!pkey->n || !pkey->e) {
+		/* invalid key provided */
+		rsa_free_key(pkey);
+		return -EINVAL;
+	}
+
+	ctx->key_sz = mpi_get_size(pkey->n);
+	if (!qat_rsa_enc_fn_id(ctx->key_sz)) {
+		/* invalid key size provided falling back to sw */
+		rsa_free_key(pkey);
+		ctx->key_sz = 0;
+		ctx->n = NULL;
+		ctx->e = NULL;
+		ctx->d = NULL;
+
+		pr_info("QAT: RSA key size not supported by hardware.\n");
+		pr_info("Falling back to software");
+		ctx->fallback = crypto_alloc_akcipher("rsa-generic", 0, 0);
+
+		if (!ctx->fallback)
+			return -ENOMEM;
+
+		return crypto_akcipher_setkey(ctx->fallback, (void *)key,
+					      keylen);
+	}
+
+	ctx->fallback = NULL;
+	ret = -ENOMEM;
+	ctx->n = dma_zalloc_coherent(dev, ctx->key_sz, &ctx->dma_n,
+				    GFP_KERNEL);
+	if (!ctx->n)
+		return ret;
+
+	ctx->e = dma_zalloc_coherent(dev, ctx->key_sz, &ctx->dma_e, GFP_KERNEL);
+	if (!ctx->e)
+		goto free_n;
+
+	if (pkey->d) {
+		ctx->d = dma_zalloc_coherent(dev, ctx->key_sz, &ctx->dma_d,
+					    GFP_KERNEL);
+		if (!ctx->d)
+			goto free_e;
+	}
+
+	ret = mpi_read_buffer(pkey->n, ctx->n, ctx->key_sz, &len, NULL);
+	if (ret)
+		goto free_d;
+
+	shift = ctx->key_sz - mpi_get_size(pkey->e);
+	ret = mpi_read_buffer(pkey->e, ctx->e + shift, ctx->key_sz - shift,
+			      &len, NULL);
+	if (ret)
+		goto free_d;
+
+	if (pkey->d) {
+		shift = ctx->key_sz - mpi_get_size(pkey->d);
+		ret = mpi_read_buffer(pkey->d, ctx->d + shift, ctx->key_sz -
+				      shift, &len, NULL);
+		if (ret)
+			goto free_d;
+	}
+	return 0;
+free_d:
+	memset(ctx->d, '\0', ctx->key_sz);
+	dma_free_coherent(dev, ctx->key_sz, ctx->d, ctx->dma_d);
+	ctx->d = NULL;
+free_e:
+	dma_free_coherent(dev, ctx->key_sz, ctx->e, ctx->dma_e);
+	ctx->e = NULL;
+free_n:
+	dma_free_coherent(dev, ctx->key_sz, ctx->n, ctx->dma_n);
+	ctx->n = NULL;
+	ctx->key_sz = 0;
+	return ret;
+}
+
+static int qat_rsa_init_tfm(struct crypto_akcipher *tfm)
+{
+	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct qat_crypto_instance *inst =
+			qat_crypto_get_instance_node(get_current_node());
+
+	if (!inst)
+		return -EINVAL;
+
+	ctx->key_sz = 0;
+	ctx->inst = inst;
+	return 0;
+}
+
+static void qat_rsa_exit_tfm(struct crypto_akcipher *tfm)
+{
+	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
+	struct rsa_key *pkey = &ctx->key;
+
+	if (ctx->fallback) {
+		crypto_free_akcipher(ctx->fallback);
+	} else {
+		if (ctx->n)
+			dma_free_coherent(dev, ctx->key_sz, ctx->n, ctx->dma_n);
+		if (ctx->e)
+			dma_free_coherent(dev, ctx->key_sz, ctx->e, ctx->dma_e);
+		if (pkey->d) {
+			memset(ctx->d, '\0', ctx->key_sz);
+			dma_free_coherent(dev, ctx->key_sz, ctx->d, ctx->dma_d);
+		}
+	}
+	qat_crypto_put_instance(ctx->inst);
+	ctx->n = NULL;
+	ctx->d = NULL;
+	ctx->d = NULL;
+	rsa_free_key(pkey);
+}
+
+static struct akcipher_alg rsa = {
+	.encrypt = qat_rsa_enc,
+	.decrypt = qat_rsa_dec,
+	.sign = qat_rsa_dec,
+	.verify = qat_rsa_enc,
+	.setkey = qat_rsa_setkey,
+	.init = qat_rsa_init_tfm,
+	.exit = qat_rsa_exit_tfm,
+	.reqsize = sizeof(struct qat_rsa_request),
+	.base = {
+		.cra_name = "rsa",
+		.cra_driver_name = "qat-rsa",
+		.cra_priority = 1000,
+		.cra_module = THIS_MODULE,
+		.cra_ctxsize = sizeof(struct qat_rsa_ctx),
+	},
+};
+
+int qat_asym_algs_register(void)
+{
+	rsa.base.cra_flags = 0;
+	return crypto_register_akcipher(&rsa);
+}
+
+void qat_asym_algs_unregister(void)
+{
+	crypto_unregister_akcipher(&rsa);
+}
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 3bd705c..e23ce6f 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -88,12 +88,6 @@ static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
 		if (inst->pke_rx)
 			adf_remove_ring(inst->pke_rx);
 
-		if (inst->rnd_tx)
-			adf_remove_ring(inst->rnd_tx);
-
-		if (inst->rnd_rx)
-			adf_remove_ring(inst->rnd_rx);
-
 		list_del(list_ptr);
 		kfree(inst);
 	}
@@ -202,11 +196,6 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 				    msg_size, key, NULL, 0, &inst->sym_tx))
 			goto err;
 
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_RND_TX, i);
-		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
-				    msg_size, key, NULL, 0, &inst->rnd_tx))
-			goto err;
-
 		msg_size = msg_size >> 1;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
 		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
@@ -220,15 +209,9 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 				    &inst->sym_rx))
 			goto err;
 
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_RND_RX, i);
-		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
-				    msg_size, key, qat_alg_callback, 0,
-				    &inst->rnd_rx))
-			goto err;
-
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
 		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
-				    msg_size, key, qat_alg_callback, 0,
+				    msg_size, key, qat_alg_asym_callback, 0,
 				    &inst->pke_rx))
 			goto err;
 	}
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index d503007..dc0273f 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -57,8 +57,6 @@ struct qat_crypto_instance {
 	struct adf_etr_ring_data *sym_rx;
 	struct adf_etr_ring_data *pke_tx;
 	struct adf_etr_ring_data *pke_rx;
-	struct adf_etr_ring_data *rnd_tx;
-	struct adf_etr_ring_data *rnd_rx;
 	struct adf_accel_dev *accel_dev;
 	struct list_head list;
 	unsigned long state;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 1bde45b..d241037 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -167,12 +167,6 @@ static int adf_dev_configure(struct adf_accel_dev *accel_dev)
 						key, (void *)&val, ADF_DEC))
 			goto err;
 
-		val = 4;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_RND_TX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
 		val = 8;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
 		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
@@ -185,12 +179,6 @@ static int adf_dev_configure(struct adf_accel_dev *accel_dev)
 						key, (void *)&val, ADF_DEC))
 			goto err;
 
-		val = 12;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_RND_RX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
 		val = ADF_COALESCING_DEF_TIME;
 		snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT, i);
 		if (adf_cfg_add_key_value_param(accel_dev, "Accelerator0",

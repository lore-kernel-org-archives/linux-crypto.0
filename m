From: Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] crypto: brcm: Add Broadcom SPU driver
Date: Wed, 30 Nov 2016 15:07:32 -0500
Message-ID: <1480536453-24781-3-git-send-email-rob.rice@broadcom.com>
References: <1480536453-24781-1-git-send-email-rob.rice@broadcom.com>
Cc: Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,
        Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480536453-24781-1-git-send-email-rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add Broadcom Secure Processing Unit (SPU) crypto driver for SPU
hardware crypto offload. The driver supports ablkcipher, ahash,
and aead symmetric crypto operations.

Signed-off-by: Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/crypto/Kconfig      |   10 +
 drivers/crypto/Makefile     |    1 +
 drivers/crypto/bcm/Makefile |   15 +
 drivers/crypto/bcm/cipher.c | 4943 +++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/bcm/cipher.h |  472 +++++
 drivers/crypto/bcm/spu.c    | 1252 +++++++++++
 drivers/crypto/bcm/spu.h    |  288 +++
 drivers/crypto/bcm/spu2.c   | 1402 ++++++++++++
 drivers/crypto/bcm/spu2.h   |  228 ++
 drivers/crypto/bcm/spum.h   |  174 ++
 drivers/crypto/bcm/util.c   |  584 +++++
 drivers/crypto/bcm/util.h   |  117 +
 12 files changed, 9486 insertions(+)
 create mode 100644 drivers/crypto/bcm/Makefile
 create mode 100644 drivers/crypto/bcm/cipher.c
 create mode 100644 drivers/crypto/bcm/cipher.h
 create mode 100644 drivers/crypto/bcm/spu.c
 create mode 100644 drivers/crypto/bcm/spu.h
 create mode 100644 drivers/crypto/bcm/spu2.c
 create mode 100644 drivers/crypto/bcm/spu2.h
 create mode 100644 drivers/crypto/bcm/spum.h
 create mode 100644 drivers/crypto/bcm/util.c
 create mode 100644 drivers/crypto/bcm/util.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4d2b81f..9ec5bde 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -555,4 +555,14 @@ config CRYPTO_DEV_ROCKCHIP

 source "drivers/crypto/chelsio/Kconfig"

+config CRYPTO_DEV_BCM_SPU
+	tristate "Broadcom symmetric crypto/hash acceleration support"
+	depends on ARCH_BCM_IPROC
+	depends on BCM_PDC_MBOX
+	default m
+	help
+	This driver provides support for Broadcom crypto acceleration using the
+	Secure Processing Unit (SPU). The SPU driver registers ablkcipher,
+	ahash, and aead algorithms with the kernel cryptographic API.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index ad7250f..2702650 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -32,3 +32,4 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
 obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rockchip/
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chelsio/
+obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
diff --git a/drivers/crypto/bcm/Makefile b/drivers/crypto/bcm/Makefile
new file mode 100644
index 0000000..13cb80e
--- /dev/null
+++ b/drivers/crypto/bcm/Makefile
@@ -0,0 +1,15 @@
+# File: drivers/crypto/bcm/Makefile
+#
+# Makefile for crypto acceleration files for Broadcom SPU driver
+#
+# Uncomment to enable debug tracing in the SPU driver.
+# CFLAGS_util.o := -DDEBUG
+# CFLAGS_cipher.o := -DDEBUG
+# CFLAGS_spu.o := -DDEBUG
+# CFLAGS_spu2.o := -DDEBUG
+
+obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) := bcm_crypto_spu.o
+
+bcm_crypto_spu-objs :=  util.o spu.o spu2.o cipher.o
+
+ccflags-y += -I. -DBCMDRIVER
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
new file mode 100644
index 0000000..f6bbb06
--- /dev/null
+++ b/drivers/crypto/bcm/cipher.c
@@ -0,0 +1,4943 @@
+/*
+ * Copyright 2016 Broadcom
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation (the "GPL").
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 (GPLv2) for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 (GPLv2) along with this source code.
+ */
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
+#include <linux/kthread.h>
+#include <linux/rtnetlink.h>
+#include <linux/sched.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/io.h>
+#include <linux/bitops.h>
+
+#include <crypto/algapi.h>
+#include <crypto/aead.h>
+#include <crypto/internal/aead.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include <crypto/sha.h>
+#include <crypto/md5.h>
+#include <crypto/authenc.h>
+#include <crypto/skcipher.h>
+#include <crypto/hash.h>
+#include <crypto/aes.h>
+#include <crypto/sha3.h>
+
+#include "util.h"
+#include "cipher.h"
+#include "spu.h"
+#include "spum.h"
+#include "spu2.h"
+
+/* ================= Device Structure ================== */
+
+struct device_private iproc_priv;
+
+/* ==================== Parameters ===================== */
+
+int flow_debug_logging;
+int packet_debug_logging;
+int debug_logging_sleep;
+
+module_param(flow_debug_logging, int, 0644);
+MODULE_PARM_DESC(flow_debug_logging, "Enable Flow Debug Logging");
+
+module_param(packet_debug_logging, int, 0644);
+MODULE_PARM_DESC(packet_debug_logging, "Enable Packet Debug Logging");
+
+module_param(debug_logging_sleep, int, 0644);
+MODULE_PARM_DESC(debug_logging_sleep, "Packet Debug Logging Sleep");
+
+/*
+ * The value of these module parameters is used to set the priority for each
+ * algo type when this driver registers algos with the kernel crypto API.
+ * To use a priority other than the default, set the priority in the insmod or
+ * modprobe. Changing the module priority after init time has no effect.
+ *
+ * The default priorities are chosen to be lower (less preferred) than ARMv8 CE
+ * algos, but more preferred than generic software algos.
+ */
+static int cipher_pri = 150;
+static int hash_pri = 100;
+static int aead_pri = 150;
+
+module_param(cipher_pri, int, 0644);
+MODULE_PARM_DESC(cipher_pri, "Priority for cipher algos");
+module_param(hash_pri, int, 0644);
+MODULE_PARM_DESC(hash_pri, "Priority for hash algos");
+module_param(aead_pri, int, 0644);
+MODULE_PARM_DESC(aead_pri, "Priority for AEAD algos");
+
+#define MAX_SPUS 16
+
+/* A type 3 BCM header, expected to precede the SPU header for SPU-M.
+ * Bits 3 and 4 in the first byte encode the channel number (the dma ringset).
+ * 0x60 - ring 0
+ * 0x68 - ring 1
+ * 0x70 - ring 2
+ * 0x78 - ring 3
+ */
+char BCMHEADER[] = { 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x28 };
+/*
+ * Some SPU hw does not use BCM header on SPU messages. So BCM_HDR_LEN
+ * is set dynamically after reading SPU type from device tree.
+ */
+#define BCM_HDR_LEN  iproc_priv.bcm_hdr_len
+
+/* min and max time to sleep before retrying when mbox queue is full. usec */
+#define MBOX_SLEEP_MIN  800
+#define MBOX_SLEEP_MAX 1000
+
+static void handle_ablkcipher_resp(struct iproc_reqctx_s *rctx);
+static void handle_ahash_resp(struct iproc_reqctx_s *rctx);
+static int ahash_req_done(struct iproc_reqctx_s *rctx);
+static void handle_aead_resp(struct iproc_reqctx_s *rctx);
+
+/**
+ * select_channel() - Select a SPU channel to handle a crypto request. Selects
+ * channel in round robin order.
+ *
+ * Return:  channel index
+ */
+static u8 select_channel(void)
+{
+	u8 chan_idx = atomic_inc_return(&iproc_priv.next_chan);
+
+	return chan_idx % iproc_priv.spu.num_chan;
+}
+
+/**
+ * spu_ablkcipher_rx_sg_create() - Build up the scatterlist of buffers used to
+ * receive a SPU response message for an ablkcipher request. Includes buffers to
+ * catch SPU message headers and the response data.
+ * @mssg:	mailbox message containing the receive sg
+ * @rctx:	crypto request context
+ * @rx_frag_num: number of scatterlist elements required to hold the
+ *		SPU response message
+ * @chunksize:	Number of bytes of response data expected
+ * @stat_pad_len: Number of bytes required to pad the STAT field to
+ *		a 4-byte boundary
+ * Returns:
+ *   0 if successful
+ *   < 0 if an error
+ */
+static int
+spu_ablkcipher_rx_sg_create(struct brcm_message *mssg,
+			    struct iproc_reqctx_s *rctx,
+			    u8 rx_frag_num,
+			    unsigned int chunksize, u32 stat_pad_len)
+{
+	struct device *dev = &iproc_priv.pdev->dev;
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct scatterlist *sg;	/* used to build sgs in mbox message */
+	struct iproc_ctx_s *ctx = rctx->ctx;
+	u32 datalen;		/* Number of bytes of response data expected */
+
+	mssg->spu.dst = kcalloc(rx_frag_num, sizeof(struct scatterlist),
+				rctx->gfp);
+	if (!mssg->spu.dst)
+		return -ENOMEM;
+
+	sg = mssg->spu.dst;
+	sg_init_table(sg, rx_frag_num);
+	/* Space for SPU message header */
+	sg_set_buf(sg++, rctx->msg_buf.spu_resp_hdr, ctx->spu_resp_hdr_len);
+
+	/* If XTS tweak in payload, add buffer to receive encrypted tweak */
+	if ((ctx->cipher.mode == CIPHER_MODE_XTS) &&
+	    spu->spu_xts_tweak_in_payload())
+		sg_set_buf(sg++, rctx->msg_buf.c.supdt_tweak,
+			   SPU_XTS_TWEAK_SIZE);
+
+	/* Copy in each dst sg entry from request, up to chunksize */
+	datalen = spu_msg_sg_add(&sg, &rctx->dst_sg, &rctx->dst_skip,
+				 rctx->dst_nents, chunksize);
+	if (datalen < chunksize) {
+		dev_err(dev,
+			"%s(): failed to copy dst sg to mbox msg. chunksize %u, datalen %u",
+			__func__, chunksize, datalen);
+		return -EFAULT;
+	}
+
+	if (ctx->cipher.alg == CIPHER_ALG_RC4)
+		/* Add buffer to catch 260-byte SUPDT field for RC4 */
+		sg_set_buf(sg++, rctx->msg_buf.c.supdt_tweak, SPU_SUPDT_LEN);
+
+	if (stat_pad_len)
+		sg_set_buf(sg++, rctx->msg_buf.rx_stat_pad, stat_pad_len);
+
+	memset(rctx->msg_buf.rx_stat, 0, SPU_RX_STATUS_LEN);
+	sg_set_buf(sg, rctx->msg_buf.rx_stat, spu->spu_rx_status_len());
+
+	return 0;
+}
+
+/**
+ * spu_ablkcipher_tx_sg_create() - Build up the scatterlist of buffers used to
+ * send a SPU request message for an ablkcipher request. Includes SPU message
+ * headers and the request data.
+ * @mssg:	mailbox message containing the transmit sg
+ * @rctx:	crypto request context
+ * @tx_frag_num: number of scatterlist elements required to construct the
+ *		SPU request message
+ * @chunksize:	Number of bytes of request data
+ * @pad_len:	Number of pad bytes
+ * Returns:
+ *   0 if successful
+ *   < 0 if an error
+ */
+static int
+spu_ablkcipher_tx_sg_create(struct brcm_message *mssg,
+			    struct iproc_reqctx_s *rctx,
+			    u8 tx_frag_num, unsigned int chunksize, u32 pad_len)
+{
+	struct device *dev = &iproc_priv.pdev->dev;
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct scatterlist *sg;	/* used to build sgs in mbox message */
+	struct iproc_ctx_s *ctx = rctx->ctx;
+	u32 datalen;		/* Number of bytes of response data expected */
+	u32 stat_len;
+
+	mssg->spu.src = kcalloc(tx_frag_num, sizeof(struct scatterlist),
+				rctx->gfp);
+	if (unlikely(!mssg->spu.src))
+		return -ENOMEM;
+
+	sg = mssg->spu.src;
+	sg_init_table(sg, tx_frag_num);
+
+	sg_set_buf(sg++, rctx->msg_buf.bcm_spu_req_hdr,
+		   BCM_HDR_LEN + ctx->spu_req_hdr_len);
+
+	/* if XTS tweak in payload, copy from IV (where crypto API puts it) */
+	if ((ctx->cipher.mode == CIPHER_MODE_XTS) &&
+	    spu->spu_xts_tweak_in_payload())
+		sg_set_buf(sg++, rctx->msg_buf.iv_ctr, SPU_XTS_TWEAK_SIZE);
+
+	/* Copy in each src sg entry from request, up to chunksize */
+	datalen = spu_msg_sg_add(&sg, &rctx->src_sg, &rctx->src_skip,
+				 rctx->src_nents, chunksize);
+	if (unlikely(datalen < chunksize)) {
+		dev_err(dev, "%s(): failed to copy src sg to mbox msg",
+			__func__);
+		return -EFAULT;
+	}
+
+	if (pad_len)
+		sg_set_buf(sg++, rctx->msg_buf.spu_req_pad, pad_len);
+
+	stat_len = spu->spu_tx_status_len();
+	if (stat_len) {
+		memset(rctx->msg_buf.tx_stat, 0, stat_len);
+		sg_set_buf(sg, rctx->msg_buf.tx_stat, stat_len);
+	}
+	return 0;
+}
+
+/**
+ * handle_ablkcipher_req() - Submit as much of a block cipher request as fits in
+ * a single SPU request message, starting at the current position in the request
+ * data.
+ * @rctx:	Crypto request context
+ *
+ * This may be called on the crypto API thread, or, when a request is so large
+ * it must be broken into multiple SPU messages, on the thread used to invoke
+ * the response callback. When requests are broken into multiple SPU
+ * messages, we assume subsequent messages depend on previous results, and
+ * thus always wait for previous results before submitting the next message.
+ * Because requests are submitted in lock step like this, there is no need
+ * to synchronize access to request data structures.
+ *
+ * Return: -EINPROGRESS: request has been accepted and result will be returned
+ *			 asynchronously
+ *         Any other value indicates an error
+ */
+static int handle_ablkcipher_req(struct iproc_reqctx_s *rctx)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct crypto_async_request *areq = rctx->parent;
+	struct ablkcipher_request *req =
+	    container_of(areq, struct ablkcipher_request, base);
+	struct iproc_ctx_s *ctx = rctx->ctx;
+	struct spu_cipher_parms cipher_parms;
+	int err = 0;
+	unsigned int chunksize = 0;	/* Num bytes of request to submit */
+	int remaining = 0;	/* Bytes of request still to process */
+	int chunk_start;	/* Beginning of data for current SPU msg */
+
+	/* IV or ctr value to use in this SPU msg */
+	u8 local_iv_ctr[MAX_IV_SIZE];
+	u32 stat_pad_len;	/* num bytes to align status field */
+	u32 pad_len;		/* total length of all padding */
+	bool update_key = false;
+	struct brcm_message *mssg;	/* mailbox message */
+	int retry_cnt = 0;
+
+	/* number of entries in src and dst sg in mailbox message. */
+	u8 rx_frag_num = 2;	/* response header and STATUS */
+	u8 tx_frag_num = 1;	/* request header */
+
+	flow_log("%s\n", __func__);
+
+	cipher_parms.alg = ctx->cipher.alg;
+	cipher_parms.mode = ctx->cipher.mode;
+	cipher_parms.type = ctx->cipher_type;
+	cipher_parms.key_len = ctx->enckeylen;
+	cipher_parms.key_buf = ctx->enckey;
+	cipher_parms.iv_buf = local_iv_ctr;
+	cipher_parms.iv_len = rctx->iv_ctr_len;
+
+	mssg = &rctx->mb_mssg;
+	chunk_start = rctx->src_sent;
+	remaining = rctx->total_todo - chunk_start;
+
+	/* determine the chunk we are breaking off and update the indexes */
+	if ((ctx->max_payload != SPU_MAX_PAYLOAD_INF) &&
+	    (remaining > ctx->max_payload))
+		chunksize = ctx->max_payload;
+	else
+		chunksize = remaining;
+
+	rctx->src_sent += chunksize;
+	rctx->total_sent = rctx->src_sent;
+
+	/* Count number of sg entries to be included in this request */
+	rctx->src_nents = spu_sg_count(rctx->src_sg, rctx->src_skip, chunksize);
+	rctx->dst_nents = spu_sg_count(rctx->dst_sg, rctx->dst_skip, chunksize);
+
+	if ((ctx->cipher.mode == CIPHER_MODE_CBC) &&
+	    rctx->is_encrypt && chunk_start)
+		/*
+		 * Encrypting non-first first chunk. Copy last block of
+		 * previous result to IV for this chunk.
+		 */
+		sg_copy_part_to_buf(req->dst, rctx->msg_buf.iv_ctr,
+				    rctx->iv_ctr_len,
+				    chunk_start - rctx->iv_ctr_len);
+
+	if (rctx->iv_ctr_len) {
+		/* get our local copy of the iv */
+		__builtin_memcpy(local_iv_ctr, rctx->msg_buf.iv_ctr,
+				 rctx->iv_ctr_len);
+
+		/* generate the next IV if possible */
+		if ((ctx->cipher.mode == CIPHER_MODE_CBC) &&
+		    !rctx->is_encrypt) {
+			/*
+			 * CBC Decrypt: next IV is the last ciphertext block in
+			 * this chunk
+			 */
+			sg_copy_part_to_buf(req->src, rctx->msg_buf.iv_ctr,
+					    rctx->iv_ctr_len,
+					    rctx->src_sent - rctx->iv_ctr_len);
+		} else if (ctx->cipher.mode == CIPHER_MODE_CTR) {
+			/*
+			 * The SPU hardware increments the counter once for
+			 * each AES block of 16 bytes. So update the counter
+			 * for the next chunk, if there is one. Note that for
+			 * this chunk, the counter has already been copied to
+			 * local_iv_ctr. We can assume a block size of 16,
+			 * because we only support CTR mode for AES, not for
+			 * any other cipher alg.
+			 */
+			add_to_ctr(rctx->msg_buf.iv_ctr, chunksize >> 4);
+		}
+	}
+
+	if (ctx->cipher.alg == CIPHER_ALG_RC4) {
+		rx_frag_num++;
+		if (chunk_start) {
+			/*
+			 * for non-first RC4 chunks, use SUPDT from previous
+			 * response as key for this chunk.
+			 */
+			cipher_parms.key_buf = rctx->msg_buf.c.supdt_tweak;
+			update_key = true;
+			cipher_parms.type = CIPHER_TYPE_UPDT;
+		} else if (!rctx->is_encrypt) {
+			/*
+			 * First RC4 chunk. For decrypt, key in pre-built msg
+			 * header may have been changed if encrypt required
+			 * multiple chunks. So revert the key to the
+			 * ctx->enckey value.
+			 */
+			update_key = true;
+			cipher_parms.type = CIPHER_TYPE_INIT;
+		}
+	}
+
+	if (ctx->max_payload == SPU_MAX_PAYLOAD_INF)
+		flow_log("max_payload infinite\n");
+	else
+		flow_log("max_payload %u\n", ctx->max_payload);
+
+	flow_log("sent:%u start:%u remains:%u size:%u\n",
+		 rctx->src_sent, chunk_start, remaining, chunksize);
+
+	/* Copy SPU header template created at setkey time */
+	memcpy(rctx->msg_buf.bcm_spu_req_hdr, ctx->bcm_spu_req_hdr,
+	       sizeof(rctx->msg_buf.bcm_spu_req_hdr));
+
+	/*
+	 * Pass SUPDT field as key. Key field in finish() call is only used
+	 * when update_key has been set above for RC4. Will be ignored in
+	 * all other cases.
+	 */
+	spu->spu_cipher_req_finish(rctx->msg_buf.bcm_spu_req_hdr + BCM_HDR_LEN,
+				   ctx->spu_req_hdr_len, !(rctx->is_encrypt),
+				   &cipher_parms, update_key, chunksize);
+
+	atomic64_add(chunksize, &iproc_priv.bytes_out);
+
+	stat_pad_len = spu->spu_wordalign_padlen(chunksize);
+	if (stat_pad_len)
+		rx_frag_num++;
+	pad_len = stat_pad_len;
+	if (pad_len) {
+		tx_frag_num++;
+		spu->spu_request_pad(rctx->msg_buf.spu_req_pad, 0,
+				     0, ctx->auth.alg, ctx->auth.mode,
+				     rctx->total_sent, stat_pad_len);
+	}
+
+	spu->spu_dump_msg_hdr(rctx->msg_buf.bcm_spu_req_hdr + BCM_HDR_LEN,
+			      ctx->spu_req_hdr_len);
+	packet_log("payload:\n");
+	dump_sg(rctx->src_sg, rctx->src_skip, chunksize);
+	packet_dump("   pad: ", rctx->msg_buf.spu_req_pad, pad_len);
+
+	/*
+	 * Build mailbox message containing SPU request msg and rx buffers
+	 * to catch response message
+	 */
+	memset(mssg, 0, sizeof(*mssg));
+	mssg->type = BRCM_MESSAGE_SPU;
+	mssg->ctx = rctx;	/* Will be returned in response */
+
+	/* Create rx scatterlist to catch result */
+	rx_frag_num += rctx->dst_nents;
+
+	if ((ctx->cipher.mode == CIPHER_MODE_XTS) &&
+	    spu->spu_xts_tweak_in_payload())
+		rx_frag_num++;	/* extra sg to insert tweak */
+
+	err = spu_ablkcipher_rx_sg_create(mssg, rctx, rx_frag_num, chunksize,
+					  stat_pad_len);
+	if (err)
+		return err;
+
+	/* Create tx scatterlist containing SPU request message */
+	tx_frag_num += rctx->src_nents;
+	if (spu->spu_tx_status_len())
+		tx_frag_num++;
+
+	if ((ctx->cipher.mode == CIPHER_MODE_XTS) &&
+	    spu->spu_xts_tweak_in_payload())
+		tx_frag_num++;	/* extra sg to insert tweak */
+
+	err = spu_ablkcipher_tx_sg_create(mssg, rctx, tx_frag_num, chunksize,
+					  pad_len);
+	if (err)
+		return err;
+
+	err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx], mssg);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) {
+		while ((err == -ENOBUFS) && (retry_cnt < SPU_MB_RETRY_MAX)) {
+			/*
+			 * Mailbox queue is full. Since MAY_SLEEP is set, assume
+			 * not in atomic context and we can wait and try again.
+			 */
+			retry_cnt++;
+			usleep_range(MBOX_SLEEP_MIN, MBOX_SLEEP_MAX);
+			err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx],
+						mssg);
+			atomic_inc(&iproc_priv.mb_no_spc);
+		}
+	}
+	if (unlikely(err < 0)) {
+		atomic_inc(&iproc_priv.mb_send_fail);
+		return err;
+	}
+
+	return -EINPROGRESS;
+}
+
+/**
+ * handle_ablkcipher_resp() - Process a block cipher SPU response. Updates the
+ * total received count for the request and updates global stats.
+ * @rctx:	Crypto request context
+ */
+static void handle_ablkcipher_resp(struct iproc_reqctx_s *rctx)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+#ifdef DEBUG
+	struct crypto_async_request *areq = rctx->parent;
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
+#endif
+	struct iproc_ctx_s *ctx = rctx->ctx;
+	u32 payload_len;
+
+	/* See how much data was returned */
+	payload_len = spu->spu_payload_length(rctx->msg_buf.spu_resp_hdr);
+
+	/*
+	 * In XTS mode, the first SPU_XTS_TWEAK_SIZE bytes may be the
+	 * encrypted tweak ("i") value; we don't count those.
+	 */
+	if ((ctx->cipher.mode == CIPHER_MODE_XTS) &&
+	    spu->spu_xts_tweak_in_payload() &&
+	    (payload_len >= SPU_XTS_TWEAK_SIZE))
+		payload_len -= SPU_XTS_TWEAK_SIZE;
+
+	atomic64_add(payload_len, &iproc_priv.bytes_in);
+
+	flow_log("%s() offset: %u, bd_len: %u BD:\n",
+		 __func__, rctx->total_received, payload_len);
+
+	dump_sg(req->dst, rctx->total_received, payload_len);
+	if (ctx->cipher.alg == CIPHER_ALG_RC4)
+		packet_dump("  supdt ", rctx->msg_buf.c.supdt_tweak,
+			    SPU_SUPDT_LEN);
+
+	rctx->total_received += payload_len;
+	if (rctx->total_received == rctx->total_todo) {
+		atomic_inc(&iproc_priv.op_counts[SPU_OP_CIPHER]);
+		atomic_inc(
+		   &iproc_priv.cipher_cnt[ctx->cipher.alg][ctx->cipher.mode]);
+	}
+}
+
+/**
+ * spu_ahash_rx_sg_create() - Build up the scatterlist of buffers used to
+ * receive a SPU response message for an ahash request.
+ * @mssg:	mailbox message containing the receive sg
+ * @rctx:	crypto request context
+ * @rx_frag_num: number of scatterlist elements required to hold the
+ *		SPU response message
+ * @digestsize: length of hash digest, in bytes
+ * @stat_pad_len: Number of bytes required to pad the STAT field to
+ *		a 4-byte boundary
+ * Return:
+ *   0 if successful
+ *   < 0 if an error
+ */
+static int
+spu_ahash_rx_sg_create(struct brcm_message *mssg,
+		       struct iproc_reqctx_s *rctx,
+		       u8 rx_frag_num, unsigned int digestsize,
+		       u32 stat_pad_len)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct scatterlist *sg;	/* used to build sgs in mbox message */
+	struct iproc_ctx_s *ctx = rctx->ctx;
+
+	mssg->spu.dst = kcalloc(rx_frag_num, sizeof(struct scatterlist),
+				rctx->gfp);
+	if (!mssg->spu.dst)
+		return -ENOMEM;
+
+	sg = mssg->spu.dst;
+	sg_init_table(sg, rx_frag_num);
+	/* Space for SPU message header */
+	sg_set_buf(sg++, rctx->msg_buf.spu_resp_hdr, ctx->spu_resp_hdr_len);
+
+	/* Space for digest */
+	sg_set_buf(sg++, rctx->msg_buf.digest, digestsize);
+
+	if (stat_pad_len)
+		sg_set_buf(sg++, rctx->msg_buf.rx_stat_pad, stat_pad_len);
+
+	memset(rctx->msg_buf.rx_stat, 0, SPU_RX_STATUS_LEN);
+	sg_set_buf(sg, rctx->msg_buf.rx_stat, spu->spu_rx_status_len());
+	return 0;
+}
+
+/**
+ * spu_ahash_tx_sg_create() -  Build up the scatterlist of buffers used to send
+ * a SPU request message for an ahash request. Includes SPU message headers and
+ * the request data.
+ * @mssg:	mailbox message containing the transmit sg
+ * @rctx:	crypto request context
+ * @tx_frag_num: number of scatterlist elements required to construct the
+ *		SPU request message
+ * @spu_hdr_len: length in bytes of SPU message header
+ * @hash_carry_len: Number of bytes of data carried over from previous req
+ * @new_data_len: Number of bytes of new request data
+ * @pad_len:	Number of pad bytes
+ * Return:
+ *   0 if successful
+ *   < 0 if an error
+ */
+static int
+spu_ahash_tx_sg_create(struct brcm_message *mssg,
+		       struct iproc_reqctx_s *rctx,
+		       u8 tx_frag_num,
+		       u32 spu_hdr_len,
+		       unsigned int hash_carry_len,
+		       unsigned int new_data_len, u32 pad_len)
+{
+	struct device *dev = &iproc_priv.pdev->dev;
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct scatterlist *sg;	/* used to build sgs in mbox message */
+	u32 datalen;		/* Number of bytes of response data expected */
+	u32 stat_len;
+
+	mssg->spu.src = kcalloc(tx_frag_num, sizeof(struct scatterlist),
+				rctx->gfp);
+	if (!mssg->spu.src)
+		return -ENOMEM;
+
+	sg = mssg->spu.src;
+	sg_init_table(sg, tx_frag_num);
+
+	sg_set_buf(sg++, rctx->msg_buf.bcm_spu_req_hdr,
+		   BCM_HDR_LEN + spu_hdr_len);
+
+	if (hash_carry_len)
+		sg_set_buf(sg++, rctx->hash_carry, hash_carry_len);
+
+	if (new_data_len) {
+		/* Copy in each src sg entry from request, up to chunksize */
+		datalen = spu_msg_sg_add(&sg, &rctx->src_sg, &rctx->src_skip,
+					 rctx->src_nents, new_data_len);
+		if (datalen < new_data_len) {
+			dev_err(dev,
+				"%s(): failed to copy src sg to mbox msg",
+				__func__);
+			return -EFAULT;
+		}
+	}
+
+	if (pad_len)
+		sg_set_buf(sg++, rctx->msg_buf.spu_req_pad, pad_len);
+
+	stat_len = spu->spu_tx_status_len();
+	if (stat_len) {
+		memset(rctx->msg_buf.tx_stat, 0, stat_len);
+		sg_set_buf(sg, rctx->msg_buf.tx_stat, stat_len);
+	}
+
+	return 0;
+}
+
+/**
+ * handle_ahash_req() - Process an asynchronous hash request from the crypto
+ * API.
+ * @rctx:  Crypto request context
+ *
+ * Builds a SPU request message embedded in a mailbox message and submits the
+ * mailbox message on a selected mailbox channel. The SPU request message is
+ * constructed as a scatterlist, including entries from the crypto API's
+ * src scatterlist to avoid copying the data to be hashed. This function is
+ * called either on the thread from the crypto API, or, in the case that the
+ * crypto API request is too large to fit in a single SPU request message,
+ * on the thread that invokes the receive callback with a response message.
+ * Because some operations require the response from one chunk before the next
+ * chunk can be submitted, we always wait for the response for the previous
+ * chunk before submitting the next chunk. Because requests are submitted in
+ * lock step like this, there is no need to synchronize access to request data
+ * structures.
+ *
+ * Return:
+ *   -EINPROGRESS: request has been submitted to SPU and response will be
+ *		   returned asynchronously
+ *   -EAGAIN:      non-final request included a small amount of data, which for
+ *		   efficiency we did not submit to the SPU, but instead stored
+ *		   to be submitted to the SPU with the next part of the request
+ *   other:        an error code
+ */
+static int handle_ahash_req(struct iproc_reqctx_s *rctx)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct crypto_async_request *areq = rctx->parent;
+	struct ahash_request *req = ahash_request_cast(areq);
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_ahash_tfm(ahash);
+	unsigned int blocksize = crypto_tfm_alg_blocksize(tfm);
+	struct iproc_ctx_s *ctx = rctx->ctx;
+
+	/* number of bytes still to be hashed in this req */
+	unsigned int nbytes_to_hash = 0;
+	int err = 0;
+	unsigned int chunksize = 0;	/* length of hash carry + new data */
+	/*
+	 * length of new data, not from hash carry, to be submitted in
+	 * this hw request
+	 */
+	unsigned int new_data_len;
+
+	unsigned int chunk_start = 0;
+	u32 db_size;	 /* Length of data field, incl gcm and hash padding */
+	int pad_len = 0; /* total pad len, including gcm, hash, stat padding */
+	u32 data_pad_len = 0;	/* length of GCM/CCM padding */
+	u32 stat_pad_len = 0;	/* length of padding to align STATUS word */
+	struct brcm_message *mssg;	/* mailbox message */
+	struct spu_request_opts req_opts;
+	struct spu_cipher_parms cipher_parms;
+	struct spu_hash_parms hash_parms;
+	struct spu_aead_parms aead_parms;
+	unsigned int local_nbuf;
+	u32 spu_hdr_len;
+	unsigned int digestsize;
+	u16 rem = 0;
+	int retry_cnt = 0;
+
+	/*
+	 * number of entries in src and dst sg. Always includes SPU msg header.
+	 * rx always includes a buffer to catch digest and STATUS.
+	 */
+	u8 rx_frag_num = 3;
+	u8 tx_frag_num = 1;
+
+	flow_log("total_todo %u, total_sent %u\n",
+		 rctx->total_todo, rctx->total_sent);
+
+	memset(&req_opts, 0, sizeof(req_opts));
+	memset(&cipher_parms, 0, sizeof(cipher_parms));
+	memset(&hash_parms, 0, sizeof(hash_parms));
+	memset(&aead_parms, 0, sizeof(aead_parms));
+
+	req_opts.bd_suppress = true;
+	hash_parms.alg = ctx->auth.alg;
+	hash_parms.mode = ctx->auth.mode;
+	hash_parms.type = HASH_TYPE_NONE;
+	hash_parms.key_buf = (u8 *)ctx->authkey;
+	hash_parms.key_len = ctx->authkeylen;
+
+	/*
+	 * For hash algorithms below assignment looks bit odd but
+	 * it's needed for AES-XCBC and AES-CMAC hash algorithms
+	 * to differentiate between 128, 192, 256 bit key values.
+	 * Based on the key values, hash algorithm is selected.
+	 * For example for 128 bit key, hash algorithm is AES-128.
+	 */
+	cipher_parms.type = ctx->cipher_type;
+
+	mssg = &rctx->mb_mssg;
+	chunk_start = rctx->src_sent;
+
+	/*
+	 * Compute the amount remaining to hash. This may include data
+	 * carried over from previous requests.
+	 */
+	nbytes_to_hash = rctx->total_todo - rctx->total_sent;
+	chunksize = nbytes_to_hash;
+	if ((ctx->max_payload != SPU_MAX_PAYLOAD_INF) &&
+	    (chunksize > ctx->max_payload))
+		chunksize = ctx->max_payload;
+
+	/*
+	 * If this is not a final request and the request data is not a multiple
+	 * of a full block, then simply park the extra data and prefix it to the
+	 * data for the next request.
+	 */
+	if (!rctx->is_final) {
+		u8 *dest = rctx->hash_carry + rctx->hash_carry_len;
+		u16 new_len;  /* len of data to add to hash carry */
+
+		rem = chunksize % blocksize;   /* remainder */
+		if (rem) {
+			/* chunksize not a multiple of blocksize */
+			chunksize -= rem;
+			if (chunksize == 0) {
+				/* Don't have a full block to submit to hw */
+				new_len = rem - rctx->hash_carry_len;
+				sg_copy_part_to_buf(req->src, dest, new_len,
+						    rctx->src_sent);
+				rctx->hash_carry_len = rem;
+				flow_log("Exiting with hash carry len: %u\n",
+					 rctx->hash_carry_len);
+				packet_dump("  buf: ",
+					    rctx->hash_carry,
+					    rctx->hash_carry_len);
+				return -EAGAIN;
+			}
+		}
+	}
+
+	/* if we have hash carry, then prefix it to the data in this request */
+	local_nbuf = rctx->hash_carry_len;
+	rctx->hash_carry_len = 0;
+	if (local_nbuf)
+		tx_frag_num++;
+	new_data_len = chunksize - local_nbuf;
+
+	/* Count number of sg entries to be used in this request */
+	rctx->src_nents = spu_sg_count(rctx->src_sg, rctx->src_skip,
+				       new_data_len);
+
+	/* AES hashing keeps key size in type field, so need to copy it here */
+	if (hash_parms.alg == HASH_ALG_AES)
+		hash_parms.type = cipher_parms.type;
+	else
+		hash_parms.type = spu->spu_hash_type(rctx->total_sent);
+
+	digestsize = spu->spu_digest_size(ctx->digestsize, ctx->auth.alg,
+					  hash_parms.type);
+	hash_parms.digestsize =	digestsize;
+
+	/* update the indexes */
+	rctx->total_sent += chunksize;
+	/* if you sent a prebuf then that wasn't from this req->src */
+	rctx->src_sent += new_data_len;
+
+	if ((rctx->total_sent == rctx->total_todo) && rctx->is_final)
+		hash_parms.pad_len = spu->spu_hash_pad_len(hash_parms.alg,
+							   hash_parms.mode,
+							   chunksize,
+							   blocksize);
+
+	/*
+	 * If a non-first chunk, then include the digest returned from the
+	 * previous chunk so that hw can add to it (except for AES types).
+	 */
+	if ((hash_parms.type == HASH_TYPE_UPDT) &&
+	    (hash_parms.alg != HASH_ALG_AES)) {
+		hash_parms.key_buf = rctx->incr_hash;
+		hash_parms.key_len = digestsize;
+	}
+
+	atomic64_add(chunksize, &iproc_priv.bytes_out);
+
+	flow_log("%s() final: %u nbuf: %u ",
+		 __func__, rctx->is_final, local_nbuf);
+
+	if (ctx->max_payload == SPU_MAX_PAYLOAD_INF)
+		flow_log("max_payload infinite\n");
+	else
+		flow_log("max_payload %u\n", ctx->max_payload);
+
+	flow_log("chunk_start: %u chunk_size: %u\n", chunk_start, chunksize);
+
+	/* Prepend SPU header with type 3 BCM header */
+	memcpy(rctx->msg_buf.bcm_spu_req_hdr, BCMHEADER, BCM_HDR_LEN);
+
+	hash_parms.prebuf_len = local_nbuf;
+	spu_hdr_len = spu->spu_create_request(rctx->msg_buf.bcm_spu_req_hdr +
+					      BCM_HDR_LEN,
+					      &req_opts, &cipher_parms,
+					      &hash_parms, &aead_parms,
+					      new_data_len);
+
+	if (spu_hdr_len == 0) {
+		pr_err("Failed to create SPU request header\n");
+		return -EFAULT;
+	}
+
+	/*
+	 * Determine total length of padding required. Put all padding in one
+	 * buffer.
+	 */
+	data_pad_len = spu->spu_gcm_ccm_pad_len(ctx->cipher.mode, chunksize);
+	db_size = spu_real_db_size(0, 0, local_nbuf, new_data_len,
+				   0, 0, hash_parms.pad_len);
+	if (spu->spu_tx_status_len())
+		stat_pad_len = spu->spu_wordalign_padlen(db_size);
+	if (stat_pad_len)
+		rx_frag_num++;
+	pad_len = hash_parms.pad_len + data_pad_len + stat_pad_len;
+	if (pad_len) {
+		tx_frag_num++;
+		spu->spu_request_pad(rctx->msg_buf.spu_req_pad, data_pad_len,
+				     hash_parms.pad_len, ctx->auth.alg,
+				     ctx->auth.mode, rctx->total_sent,
+				     stat_pad_len);
+	}
+
+	spu->spu_dump_msg_hdr(rctx->msg_buf.bcm_spu_req_hdr + BCM_HDR_LEN,
+			      spu_hdr_len);
+	packet_dump("    prebuf: ", rctx->hash_carry, local_nbuf);
+	flow_log("Data:\n");
+	dump_sg(rctx->src_sg, rctx->src_skip, new_data_len);
+	packet_dump("   pad: ", rctx->msg_buf.spu_req_pad, pad_len);
+
+	/*
+	 * Build mailbox message containing SPU request msg and rx buffers
+	 * to catch response message
+	 */
+	memset(mssg, 0, sizeof(*mssg));
+	mssg->type = BRCM_MESSAGE_SPU;
+	mssg->ctx = rctx;	/* Will be returned in response */
+
+	/* Create rx scatterlist to catch result */
+	err = spu_ahash_rx_sg_create(mssg, rctx, rx_frag_num, digestsize,
+				     stat_pad_len);
+	if (err)
+		return err;
+
+	/* Create tx scatterlist containing SPU request message */
+	tx_frag_num += rctx->src_nents;
+	if (spu->spu_tx_status_len())
+		tx_frag_num++;
+	err = spu_ahash_tx_sg_create(mssg, rctx, tx_frag_num, spu_hdr_len,
+				     local_nbuf, new_data_len, pad_len);
+	if (err)
+		return err;
+
+	err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx], mssg);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) {
+		while ((err == -ENOBUFS) && (retry_cnt < SPU_MB_RETRY_MAX)) {
+			/*
+			 * Mailbox queue is full. Since MAY_SLEEP is set, assume
+			 * not in atomic context and we can wait and try again.
+			 */
+			retry_cnt++;
+			usleep_range(MBOX_SLEEP_MIN, MBOX_SLEEP_MAX);
+			err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx],
+						mssg);
+			atomic_inc(&iproc_priv.mb_no_spc);
+		}
+	}
+	if (err < 0) {
+		atomic_inc(&iproc_priv.mb_send_fail);
+		return err;
+	}
+	return -EINPROGRESS;
+}
+
+/**
+ * handle_ahash_resp() - Process a SPU response message for a hash request.
+ * Checks if the entire crypto API request has been processed, and if so,
+ * invokes post processing on the result.
+ * @rctx: Crypto request context
+ */
+static void handle_ahash_resp(struct iproc_reqctx_s *rctx)
+{
+	struct iproc_ctx_s *ctx = rctx->ctx;
+#ifdef DEBUG
+	struct crypto_async_request *areq = rctx->parent;
+	struct ahash_request *req = ahash_request_cast(areq);
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	unsigned int blocksize =
+		crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
+#endif
+	/*
+	 * Save hash to use as input to next op if incremental. Might be copying
+	 * too much, but that's easier than figuring out actual digest size here
+	 */
+	memcpy(rctx->incr_hash, rctx->msg_buf.digest, MAX_DIGEST_SIZE);
+
+	flow_log("%s() blocksize:%u digestsize:%u\n",
+		 __func__, blocksize, ctx->digestsize);
+
+	atomic64_add(ctx->digestsize, &iproc_priv.bytes_in);
+
+	if (rctx->is_final && (rctx->total_sent == rctx->total_todo))
+		ahash_req_done(rctx);
+}
+
+/**
+ * spu_hmac_outer_hash() - Request synchonous software compute of the outer hash
+ * for an HMAC request.
+ * @req:  The HMAC request from the crypto API
+ * @ctx:  The session context
+ *
+ * Return: 0 if synchronous hash operation successful
+ *         -EINVAL if the hash algo is unrecognized
+ *         any other value indicates an error
+ */
+static int spu_hmac_outer_hash(struct ahash_request *req,
+			       struct iproc_ctx_s *ctx)
+{
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	unsigned int blocksize =
+		crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
+	int rc;
+
+	switch (ctx->auth.alg) {
+	case HASH_ALG_MD5:
+		rc = do_shash("md5", req->result, ctx->opad, blocksize,
+			      req->result, ctx->digestsize, NULL, 0);
+		break;
+	case HASH_ALG_SHA1:
+		rc = do_shash("sha1", req->result, ctx->opad, blocksize,
+			      req->result, ctx->digestsize, NULL, 0);
+		break;
+	case HASH_ALG_SHA224:
+		rc = do_shash("sha224", req->result, ctx->opad, blocksize,
+			      req->result, ctx->digestsize, NULL, 0);
+		break;
+	case HASH_ALG_SHA256:
+		rc = do_shash("sha256", req->result, ctx->opad, blocksize,
+			      req->result, ctx->digestsize, NULL, 0);
+		break;
+	case HASH_ALG_SHA384:
+		rc = do_shash("sha384", req->result, ctx->opad, blocksize,
+			      req->result, ctx->digestsize, NULL, 0);
+		break;
+	case HASH_ALG_SHA512:
+		rc = do_shash("sha512", req->result, ctx->opad, blocksize,
+			      req->result, ctx->digestsize, NULL, 0);
+		break;
+	default:
+		pr_err("%s() Error : unknown hmac type\n", __func__);
+		rc = -EINVAL;
+	}
+	return rc;
+}
+
+/**
+ * ahash_req_done() - Process a hash result from the SPU hardware.
+ * @rctx: Crypto request context
+ *
+ * Return: 0 if successful
+ *         < 0 if an error
+ */
+static int ahash_req_done(struct iproc_reqctx_s *rctx)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct crypto_async_request *areq = rctx->parent;
+	struct ahash_request *req = ahash_request_cast(areq);
+	struct iproc_ctx_s *ctx = rctx->ctx;
+	int err;
+
+	memcpy(req->result, rctx->msg_buf.digest, ctx->digestsize);
+
+	if (spu->spu_type == SPU_TYPE_SPUM) {
+		/* byte swap the output from the UPDT function to network byte
+		 * order
+		 */
+		if (ctx->auth.alg == HASH_ALG_MD5) {
+			__swab32s((u32 *)req->result);
+			__swab32s(((u32 *)req->result) + 1);
+			__swab32s(((u32 *)req->result) + 2);
+			__swab32s(((u32 *)req->result) + 3);
+			__swab32s(((u32 *)req->result) + 4);
+		}
+	}
+
+	flow_dump("  digest ", req->result, ctx->digestsize);
+
+	/* if this an HMAC then do the outer hash */
+	if (rctx->is_sw_hmac) {
+		err = spu_hmac_outer_hash(req, ctx);
+		if (err < 0)
+			return err;
+		flow_dump("  hmac: ", req->result, ctx->digestsize);
+	}
+
+	if (rctx->is_sw_hmac || ctx->auth.mode == HASH_MODE_HMAC) {
+		atomic_inc(&iproc_priv.op_counts[SPU_OP_HMAC]);
+		atomic_inc(&iproc_priv.hmac_cnt[ctx->auth.alg]);
+	} else {
+		atomic_inc(&iproc_priv.op_counts[SPU_OP_HASH]);
+		atomic_inc(&iproc_priv.hash_cnt[ctx->auth.alg]);
+	}
+
+	return 0;
+}
+
+/**
+ * spu_aead_rx_sg_create() - Build up the scatterlist of buffers used to receive
+ * a SPU response message for an AEAD request. Includes buffers to catch SPU
+ * message headers and the response data.
+ * @mssg:	mailbox message containing the receive sg
+ * @rctx:	crypto request context
+ * @rx_frag_num: number of scatterlist elements required to hold the
+ *		SPU response message
+ * @assoc_len:	Length of associated data included in the crypto request
+ * @ret_iv_len: Length of IV returned in response
+ * @resp_len:	Number of bytes of response data expected to be written to
+ *              dst buffer from crypto API
+ * @digestsize: Length of hash digest, in bytes
+ * @stat_pad_len: Number of bytes required to pad the STAT field to
+ *		a 4-byte boundary
+ * Returns:
+ *   0 if successful
+ *   < 0 if an error
+ */
+static int spu_aead_rx_sg_create(struct brcm_message *mssg,
+				 struct aead_request *req,
+				 struct iproc_reqctx_s *rctx,
+				 u8 rx_frag_num,
+				 unsigned int assoc_len,
+				 u32 ret_iv_len, unsigned int resp_len,
+				 unsigned int digestsize, u32 stat_pad_len)
+{
+	struct device *dev = &iproc_priv.pdev->dev;
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct scatterlist *sg;	/* used to build sgs in mbox message */
+	struct iproc_ctx_s *ctx = rctx->ctx;
+	u32 datalen;		/* Number of bytes of response data expected */
+	u32 assoc_buf_len;
+	u8 data_padlen = 0;
+
+	if (ctx->is_rfc4543) {
+		/* RFC4543: only pad after data, not after AAD */
+		data_padlen = spu->spu_gcm_ccm_pad_len(ctx->cipher.mode,
+							  assoc_len + resp_len);
+		assoc_buf_len = assoc_len;
+	} else {
+		data_padlen = spu->spu_gcm_ccm_pad_len(ctx->cipher.mode,
+							  resp_len);
+		assoc_buf_len = spu->spu_assoc_resp_len(ctx->cipher.mode,
+						assoc_len, ret_iv_len,
+						rctx->is_encrypt);
+	}
+
+	if (ctx->cipher.mode == CIPHER_MODE_CCM)
+		/* ICV (after data) must be in the next 32-bit word for CCM */
+		data_padlen += spu->spu_wordalign_padlen(assoc_buf_len +
+							 resp_len +
+							 data_padlen);
+
+	if (data_padlen)
+		/* have to catch gcm pad in separate buffer */
+		rx_frag_num++;
+
+	mssg->spu.dst = kcalloc(rx_frag_num, sizeof(struct scatterlist),
+				rctx->gfp);
+	if (!mssg->spu.dst)
+		return -ENOMEM;
+
+	sg = mssg->spu.dst;
+	sg_init_table(sg, rx_frag_num);
+
+	/* Space for SPU message header */
+	sg_set_buf(sg++, rctx->msg_buf.spu_resp_hdr, ctx->spu_resp_hdr_len);
+
+	if (assoc_buf_len) {
+		/*
+		 * Don't write directly to req->dst, because SPU may pad the
+		 * assoc data in the response
+		 */
+		memset(rctx->msg_buf.a.resp_aad, 0, assoc_buf_len);
+		sg_set_buf(sg++, rctx->msg_buf.a.resp_aad, assoc_buf_len);
+	}
+
+	/*
+	 * Copy in each dst sg entry from request, up to chunksize.
+	 * dst sg catches just the data. digest caught in separate buf.
+	 */
+	datalen = spu_msg_sg_add(&sg, &rctx->dst_sg, &rctx->dst_skip,
+				 rctx->dst_nents, resp_len);
+	if (datalen < (resp_len)) {
+		dev_err(dev,
+			"%s(): failed to copy dst sg to mbox msg. expected len %u, datalen %u",
+			__func__, resp_len, datalen);
+		return -EFAULT;
+	}
+
+	/* If GCM/CCM data is padded, catch padding in separate buffer */
+	if (data_padlen) {
+		memset(rctx->msg_buf.a.gcmpad, 0, data_padlen);
+		sg_set_buf(sg++, rctx->msg_buf.a.gcmpad, data_padlen);
+	}
+
+	/* Always catch ICV in separate buffer */
+	sg_set_buf(sg++, rctx->msg_buf.digest, digestsize);
+
+	flow_log("stat_pad_len %u\n", stat_pad_len);
+	if (stat_pad_len) {
+		memset(rctx->msg_buf.rx_stat_pad, 0, stat_pad_len);
+		sg_set_buf(sg++, rctx->msg_buf.rx_stat_pad, stat_pad_len);
+	}
+
+	memset(rctx->msg_buf.rx_stat, 0, SPU_RX_STATUS_LEN);
+	sg_set_buf(sg, rctx->msg_buf.rx_stat, spu->spu_rx_status_len());
+
+	return 0;
+}
+
+/**
+ * spu_aead_tx_sg_create() - Build up the scatterlist of buffers used to send a
+ * SPU request message for an AEAD request. Includes SPU message headers and the
+ * request data.
+ * @mssg:	mailbox message containing the transmit sg
+ * @rctx:	crypto request context
+ * @tx_frag_num: number of scatterlist elements required to construct the
+ *		SPU request message
+ * @spu_hdr_len: length of SPU message header in bytes
+ * @assoc:	crypto API associated data scatterlist
+ * @assoc_len:	length of associated data
+ * @assoc_nents: number of scatterlist entries containing assoc data
+ * @aead_iv_len: length of AEAD IV, if included
+ * @chunksize:	Number of bytes of request data
+ * @aad_pad_len: Number of bytes of padding at end of AAD. For GCM/CCM.
+ * @pad_len:	Number of pad bytes
+ * @incl_icv:	If true, write separate ICV buffer after data and
+ *              any padding
+ * Return:
+ *   0 if successful
+ *   < 0 if an error
+ */
+static int spu_aead_tx_sg_create(struct brcm_message *mssg,
+				 struct iproc_reqctx_s *rctx,
+				 u8 tx_frag_num,
+				 u32 spu_hdr_len,
+				 struct scatterlist *assoc,
+				 unsigned int assoc_len,
+				 int assoc_nents,
+				 unsigned int aead_iv_len,
+				 unsigned int chunksize,
+				 u32 aad_pad_len, u32 pad_len, bool incl_icv)
+{
+	struct device *dev = &iproc_priv.pdev->dev;
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct scatterlist *sg;	/* used to build sgs in mbox message */
+	struct scatterlist *assoc_sg = assoc;
+	struct iproc_ctx_s *ctx = rctx->ctx;
+	u32 datalen;		/* Number of bytes of data to write */
+	u32 written;		/* Number of bytes of data written */
+	u32 assoc_offset = 0;
+	u32 stat_len;
+
+	mssg->spu.src = kcalloc(tx_frag_num, sizeof(struct scatterlist),
+				rctx->gfp);
+	if (!mssg->spu.src)
+		return -ENOMEM;
+
+	sg = mssg->spu.src;
+	sg_init_table(sg, tx_frag_num);
+
+	sg_set_buf(sg++, rctx->msg_buf.bcm_spu_req_hdr,
+		   BCM_HDR_LEN + spu_hdr_len);
+
+	if (assoc_len) {
+		/* Copy in each associated data sg entry from request */
+		written = spu_msg_sg_add(&sg, &assoc_sg, &assoc_offset,
+					 assoc_nents, assoc_len);
+		if (written < assoc_len) {
+			dev_err(dev,
+				"%s(): failed to copy assoc sg to mbox msg",
+				__func__);
+			return -EFAULT;
+		}
+	}
+
+	if (aead_iv_len)
+		sg_set_buf(sg++, rctx->msg_buf.iv_ctr, aead_iv_len);
+
+	if (aad_pad_len) {
+		memset(rctx->msg_buf.a.req_aad_pad, 0, aad_pad_len);
+		sg_set_buf(sg++, rctx->msg_buf.a.req_aad_pad, aad_pad_len);
+	}
+
+	datalen = chunksize;
+	if ((chunksize > ctx->digestsize) && incl_icv)
+		datalen -= ctx->digestsize;
+	if (datalen) {
+		/* For aead, a single msg should consume the entire src sg */
+		written = spu_msg_sg_add(&sg, &rctx->src_sg, &rctx->src_skip,
+					 rctx->src_nents, datalen);
+		if (written < datalen) {
+			dev_err(dev, "%s(): failed to copy src sg to mbox msg",
+				__func__);
+			return -EFAULT;
+		}
+	}
+
+	if (pad_len) {
+		memset(rctx->msg_buf.spu_req_pad, 0, pad_len);
+		sg_set_buf(sg++, rctx->msg_buf.spu_req_pad, pad_len);
+	}
+
+	if (incl_icv)
+		sg_set_buf(sg++, rctx->msg_buf.digest, ctx->digestsize);
+
+	stat_len = spu->spu_tx_status_len();
+	if (stat_len) {
+		memset(rctx->msg_buf.tx_stat, 0, stat_len);
+		sg_set_buf(sg, rctx->msg_buf.tx_stat, stat_len);
+	}
+	return 0;
+}
+
+/**
+ * handle_aead_req() - Submit a SPU request message for the next chunk of the
+ * current AEAD request.
+ * @rctx:  Crypto request context
+ *
+ * Unlike other operation types, we assume the length of the request fits in
+ * a single SPU request message. aead_enqueue() makes sure this is true.
+ * Comments for other op types regarding threads applies here as well.
+ *
+ * Unlike incremental hash ops, where the spu returns the entire hash for
+ * truncated algs like sha-224, the SPU returns just the truncated hash in
+ * response to aead requests. So digestsize is always ctx->digestsize here.
+ *
+ * Return: -EINPROGRESS: crypto request has been accepted and result will be
+ *			 returned asynchronously
+ *         Any other value indicates an error
+ */
+static int handle_aead_req(struct iproc_reqctx_s *rctx)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct crypto_async_request *areq = rctx->parent;
+	struct aead_request *req = container_of(areq,
+						struct aead_request, base);
+	struct iproc_ctx_s *ctx = rctx->ctx;
+	int err;
+	unsigned int chunksize;
+	unsigned int resp_len;
+	u32 spu_hdr_len;
+	u32 db_size;
+	u32 stat_pad_len;
+	u32 pad_len;
+	struct brcm_message *mssg;	/* mailbox message */
+	struct spu_request_opts req_opts;
+	struct spu_cipher_parms cipher_parms;
+	struct spu_hash_parms hash_parms;
+	struct spu_aead_parms aead_parms;
+	int assoc_nents = 0;
+	bool incl_icv = false;
+	unsigned int digestsize = ctx->digestsize;
+	int retry_cnt = 0;
+
+	/* number of entries in src and dst sg. Always includes SPU msg header.
+	 */
+	u8 rx_frag_num = 2;	/* and STATUS */
+	u8 tx_frag_num = 1;
+
+	/* doing the whole thing at once */
+	chunksize = rctx->total_todo;
+
+	flow_log("%s: chunksize %u\n", __func__, chunksize);
+
+	memset(&req_opts, 0, sizeof(req_opts));
+	memset(&hash_parms, 0, sizeof(hash_parms));
+	memset(&aead_parms, 0, sizeof(aead_parms));
+
+	req_opts.is_inbound = !(rctx->is_encrypt);
+	req_opts.auth_first = ctx->auth_first;
+	req_opts.is_aead = true;
+	req_opts.is_esp = ctx->is_esp;
+
+	cipher_parms.alg = ctx->cipher.alg;
+	cipher_parms.mode = ctx->cipher.mode;
+	cipher_parms.type = ctx->cipher_type;
+	cipher_parms.key_buf = ctx->enckey;
+	cipher_parms.key_len = ctx->enckeylen;
+	cipher_parms.iv_buf = rctx->msg_buf.iv_ctr;
+	cipher_parms.iv_len = rctx->iv_ctr_len;
+
+	hash_parms.alg = ctx->auth.alg;
+	hash_parms.mode = ctx->auth.mode;
+	hash_parms.type = HASH_TYPE_NONE;
+	hash_parms.key_buf = (u8 *)ctx->authkey;
+	hash_parms.key_len = ctx->authkeylen;
+	hash_parms.digestsize = digestsize;
+
+	if ((ctx->auth.alg == HASH_ALG_SHA224) &&
+	    (ctx->authkeylen < SHA224_DIGEST_SIZE))
+		hash_parms.key_len = SHA224_DIGEST_SIZE;
+
+	aead_parms.assoc_size = req->assoclen;
+	if (ctx->is_esp && !ctx->is_rfc4543) {
+		/*
+		 * 8-byte IV is included assoc data in request. SPU2
+		 * expects AAD to include just SPI and seqno. So
+		 * subtract off the IV len.
+		 */
+		aead_parms.assoc_size -= GCM_ESP_IV_SIZE;
+
+		if (rctx->is_encrypt) {
+			aead_parms.return_iv = true;
+			aead_parms.ret_iv_len = GCM_ESP_IV_SIZE;
+			aead_parms.ret_iv_off = GCM_ESP_SALT_SIZE;
+		}
+	} else {
+		aead_parms.ret_iv_len = 0;
+	}
+
+	/*
+	 * Count number of sg entries from the crypto API request that are to
+	 * be included in this mailbox message. For dst sg, don't count space
+	 * for digest. Digest gets caught in a separate buffer and copied back
+	 * to dst sg when processing response.
+	 */
+	rctx->src_nents = spu_sg_count(rctx->src_sg, rctx->src_skip, chunksize);
+	rctx->dst_nents = spu_sg_count(rctx->dst_sg, rctx->dst_skip, chunksize);
+	if (aead_parms.assoc_size)
+		assoc_nents = spu_sg_count(rctx->assoc, 0,
+					   aead_parms.assoc_size);
+
+	mssg = &rctx->mb_mssg;
+
+	rctx->total_sent = chunksize;
+	rctx->src_sent = chunksize;
+	if (spu->spu_assoc_resp_len(ctx->cipher.mode,
+				    aead_parms.assoc_size,
+				    aead_parms.ret_iv_len,
+				    rctx->is_encrypt))
+		rx_frag_num++;
+
+	aead_parms.iv_len = spu->spu_aead_ivlen(ctx->cipher.mode,
+						rctx->iv_ctr_len);
+
+	if (ctx->auth.alg == HASH_ALG_AES)
+		hash_parms.type = ctx->cipher_type;
+
+	/* General case AAD padding (CCM and RFC4543 special cases below) */
+	aead_parms.aad_pad_len = spu->spu_gcm_ccm_pad_len(ctx->cipher.mode,
+						 aead_parms.assoc_size);
+
+	/* General case data padding (CCM decrypt special case below) */
+	aead_parms.data_pad_len = spu->spu_gcm_ccm_pad_len(ctx->cipher.mode,
+							   chunksize);
+
+	if (ctx->cipher.mode == CIPHER_MODE_CCM) {
+		/*
+		 * for CCM, AAD len + 2 (rather than AAD len) needs to be
+		 * 128-bit aligned
+		 */
+		aead_parms.aad_pad_len = spu->spu_gcm_ccm_pad_len(
+					 ctx->cipher.mode,
+					 aead_parms.assoc_size + 2);
+
+		/*
+		 * And when decrypting CCM, need to pad without including
+		 * size of ICV which is tacked on to end of chunk
+		 */
+		if (!rctx->is_encrypt)
+			aead_parms.data_pad_len =
+				spu->spu_gcm_ccm_pad_len(ctx->cipher.mode,
+							chunksize - digestsize);
+
+		/* CCM also requires software to rewrite portions of IV: */
+		spu->spu_ccm_update_iv(digestsize, &cipher_parms, req->assoclen,
+				       chunksize, rctx->is_encrypt,
+				       ctx->is_esp);
+	}
+
+	if (ctx->is_rfc4543) {
+		/*
+		 * RFC4543: data is included in AAD, so don't pad after AAD
+		 * and pad data based on both AAD + data size
+		 */
+		aead_parms.aad_pad_len = 0;
+		if (!rctx->is_encrypt)
+			aead_parms.data_pad_len = spu->spu_gcm_ccm_pad_len(
+					ctx->cipher.mode,
+					aead_parms.assoc_size + chunksize -
+					digestsize);
+		else
+			aead_parms.data_pad_len = spu->spu_gcm_ccm_pad_len(
+					ctx->cipher.mode,
+					aead_parms.assoc_size + chunksize);
+
+		req_opts.is_rfc4543 = true;
+	}
+
+	if (spu_req_incl_icv(ctx->cipher.mode, rctx->is_encrypt)) {
+		incl_icv = true;
+		tx_frag_num++;
+		/* Copy ICV from end of src scatterlist to digest buf */
+		sg_copy_part_to_buf(req->src, rctx->msg_buf.digest, digestsize,
+				    req->assoclen + rctx->total_sent -
+				    digestsize);
+	}
+
+	atomic64_add(chunksize, &iproc_priv.bytes_out);
+
+	flow_log("%s()-sent chunksize:%u hmac_offset:%u\n",
+		 __func__, chunksize, hash_parms.hmac_offset);
+
+	/* Prepend SPU header with type 3 BCM header */
+	memcpy(rctx->msg_buf.bcm_spu_req_hdr, BCMHEADER, BCM_HDR_LEN);
+
+	spu_hdr_len = spu->spu_create_request(rctx->msg_buf.bcm_spu_req_hdr +
+					      BCM_HDR_LEN, &req_opts,
+					      &cipher_parms, &hash_parms,
+					      &aead_parms, chunksize);
+
+	/* Determine total length of padding. Put all padding in one buffer. */
+	db_size = spu_real_db_size(aead_parms.assoc_size, aead_parms.iv_len, 0,
+				   chunksize, aead_parms.aad_pad_len,
+				   aead_parms.data_pad_len, 0);
+
+	stat_pad_len = spu->spu_wordalign_padlen(db_size);
+
+	if (stat_pad_len)
+		rx_frag_num++;
+	pad_len = aead_parms.data_pad_len + stat_pad_len;
+	if (pad_len) {
+		tx_frag_num++;
+		spu->spu_request_pad(rctx->msg_buf.spu_req_pad,
+				     aead_parms.data_pad_len, 0,
+				     ctx->auth.alg, ctx->auth.mode,
+				     rctx->total_sent, stat_pad_len);
+	}
+
+	spu->spu_dump_msg_hdr(rctx->msg_buf.bcm_spu_req_hdr + BCM_HDR_LEN,
+			      spu_hdr_len);
+	dump_sg(rctx->assoc, 0, aead_parms.assoc_size);
+	packet_dump("    aead iv: ", rctx->msg_buf.iv_ctr, aead_parms.iv_len);
+	packet_log("BD:\n");
+	dump_sg(rctx->src_sg, rctx->src_skip, chunksize);
+	packet_dump("   pad: ", rctx->msg_buf.spu_req_pad, pad_len);
+
+	/*
+	 * Build mailbox message containing SPU request msg and rx buffers
+	 * to catch response message
+	 */
+	memset(mssg, 0, sizeof(*mssg));
+	mssg->type = BRCM_MESSAGE_SPU;
+	mssg->ctx = rctx;	/* Will be returned in response */
+
+	/* Create rx scatterlist to catch result */
+	rx_frag_num += rctx->dst_nents;
+	resp_len = chunksize;
+
+	/*
+	 * Always catch ICV in separate buffer. Have to for GCM/CCM because of
+	 * padding. Have to for SHA-224 and other truncated SHAs because SPU
+	 * sends entire digest back.
+	 */
+	rx_frag_num++;
+
+	if (((ctx->cipher.mode == CIPHER_MODE_GCM) ||
+	     (ctx->cipher.mode == CIPHER_MODE_CCM)) && !rctx->is_encrypt)
+		/*
+		 * Input is ciphertxt plus ICV, but ICV not incl
+		 * in output.
+		 */
+		resp_len -= ctx->digestsize;
+
+	err = spu_aead_rx_sg_create(mssg, req, rctx, rx_frag_num,
+				    aead_parms.assoc_size,
+				    aead_parms.ret_iv_len, resp_len, digestsize,
+				    stat_pad_len);
+	if (err)
+		return err;
+
+	/* Create tx scatterlist containing SPU request message */
+	tx_frag_num += rctx->src_nents;
+	tx_frag_num += assoc_nents;
+	if (aead_parms.aad_pad_len)
+		tx_frag_num++;
+	if (aead_parms.iv_len)
+		tx_frag_num++;
+	if (spu->spu_tx_status_len())
+		tx_frag_num++;
+	err = spu_aead_tx_sg_create(mssg, rctx, tx_frag_num, spu_hdr_len,
+				    rctx->assoc, aead_parms.assoc_size,
+				    assoc_nents, aead_parms.iv_len, chunksize,
+				    aead_parms.aad_pad_len, pad_len, incl_icv);
+	if (err)
+		return err;
+
+	err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx], mssg);
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) {
+		while ((err == -ENOBUFS) && (retry_cnt < SPU_MB_RETRY_MAX)) {
+			/*
+			 * Mailbox queue is full. Since MAY_SLEEP is set, assume
+			 * not in atomic context and we can wait and try again.
+			 */
+			retry_cnt++;
+			usleep_range(MBOX_SLEEP_MIN, MBOX_SLEEP_MAX);
+			err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx],
+						mssg);
+			atomic_inc(&iproc_priv.mb_no_spc);
+		}
+	}
+	if (err < 0) {
+		atomic_inc(&iproc_priv.mb_send_fail);
+		return err;
+	}
+
+	return -EINPROGRESS;
+}
+
+/**
+ * handle_aead_resp() - Process a SPU response message for an AEAD request.
+ * @rctx:  Crypto request context
+ */
+static void handle_aead_resp(struct iproc_reqctx_s *rctx)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct crypto_async_request *areq = rctx->parent;
+	struct aead_request *req = container_of(areq,
+						struct aead_request, base);
+	struct iproc_ctx_s *ctx = rctx->ctx;
+	u32 payload_len;
+	unsigned int icv_offset;
+	u32 result_len;
+
+	/* See how much data was returned */
+	payload_len = spu->spu_payload_length(rctx->msg_buf.spu_resp_hdr);
+	flow_log("payload_len %u\n", payload_len);
+
+	/* only count payload */
+	atomic64_add(payload_len, &iproc_priv.bytes_in);
+
+	if (req->assoclen)
+		packet_dump("  assoc_data ", rctx->msg_buf.a.resp_aad,
+			    req->assoclen);
+
+	/*
+	 * Copy the ICV back to the destination
+	 * buffer. In decrypt case, SPU gives us back the digest, but crypto
+	 * API doesn't expect ICV in dst buffer.
+	 */
+	result_len = req->cryptlen;
+	if (rctx->is_encrypt) {
+		icv_offset = req->assoclen + rctx->total_sent;
+		packet_dump("  ICV: ", rctx->msg_buf.digest, ctx->digestsize);
+		flow_log("copying ICV to dst sg at offset %u\n", icv_offset);
+		sg_copy_part_from_buf(req->dst, rctx->msg_buf.digest,
+				      ctx->digestsize, icv_offset);
+		result_len += ctx->digestsize;
+	}
+
+	packet_log("response data:  ");
+	dump_sg(req->dst, req->assoclen, result_len);
+
+	atomic_inc(&iproc_priv.op_counts[SPU_OP_AEAD]);
+	if (ctx->cipher.alg == CIPHER_ALG_AES) {
+		if (ctx->cipher.mode == CIPHER_MODE_CCM)
+			atomic_inc(&iproc_priv.aead_cnt[AES_CCM]);
+		else if (ctx->cipher.mode == CIPHER_MODE_GCM)
+			atomic_inc(&iproc_priv.aead_cnt[AES_GCM]);
+		else
+			atomic_inc(&iproc_priv.aead_cnt[AUTHENC]);
+	} else {
+		atomic_inc(&iproc_priv.aead_cnt[AUTHENC]);
+	}
+}
+
+/**
+ * spu_chunk_cleanup() - Do cleanup after processing one chunk of a request
+ * @rctx:  request context
+ *
+ * Mailbox scatterlists are allocated for each chunk. So free them after
+ * processing each chunk.
+ */
+static void spu_chunk_cleanup(struct iproc_reqctx_s *rctx)
+{
+	/* mailbox message used to tx request */
+	struct brcm_message *mssg = &rctx->mb_mssg;
+
+	kfree(mssg->spu.src);
+	kfree(mssg->spu.dst);
+	memset(mssg, 0, sizeof(struct brcm_message));
+}
+
+/**
+ * finish_req() - Used to invoke the complete callback from the requester when
+ * a request has been handled asynchronously.
+ * @rctx:  Request context
+ * @err:   Indicates whether the request was successful or not
+ *
+ * Ensures that cleanup has been done for request
+ */
+static void finish_req(struct iproc_reqctx_s *rctx, int err)
+{
+	struct crypto_async_request *areq = rctx->parent;
+
+	flow_log("%s() err:%d\n\n", __func__, err);
+
+	/* No harm done if already called */
+	spu_chunk_cleanup(rctx);
+
+	if (areq)
+		areq->complete(areq, err);
+}
+
+/**
+ * spu_rx_callback() - Callback from mailbox framework with a SPU response.
+ * @cl:		mailbox client structure for SPU driver
+ * @msg:	mailbox message containing SPU response
+ */
+static void spu_rx_callback(struct mbox_client *cl, void *msg)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct device *dev = &iproc_priv.pdev->dev;
+	struct brcm_message *mssg = msg;
+	struct iproc_reqctx_s *rctx;
+	struct iproc_ctx_s *ctx;
+	struct crypto_async_request *areq;
+	int err = 0;
+
+	rctx = mssg->ctx;
+	if (unlikely(!rctx)) {
+		/* This is fatal */
+		dev_err(dev, "%s(): no request context", __func__);
+		err = -EFAULT;
+		goto cb_finish;
+	}
+	areq = rctx->parent;
+	ctx = rctx->ctx;
+
+	/* process the SPU status */
+	err = spu->spu_status_process(rctx->msg_buf.rx_stat);
+	if (err != 0) {
+		if (err == SPU_INVALID_ICV)
+			atomic_inc(&iproc_priv.bad_icv);
+		err = -EBADMSG;
+		goto cb_finish;
+	}
+
+	/* Process the SPU response message */
+	switch (rctx->ctx->alg->type) {
+	case CRYPTO_ALG_TYPE_ABLKCIPHER:
+		handle_ablkcipher_resp(rctx);
+		break;
+	case CRYPTO_ALG_TYPE_AHASH:
+		handle_ahash_resp(rctx);
+		break;
+	case CRYPTO_ALG_TYPE_AEAD:
+		handle_aead_resp(rctx);
+		break;
+	default:
+		err = -EINVAL;
+		goto cb_finish;
+	}
+
+	/*
+	 * If this response does not complete the request, then send the next
+	 * request chunk.
+	 */
+	if (rctx->total_sent < rctx->total_todo) {
+		/* Deallocate anything specific to previous chunk */
+		spu_chunk_cleanup(rctx);
+
+		switch (rctx->ctx->alg->type) {
+		case CRYPTO_ALG_TYPE_ABLKCIPHER:
+			err = handle_ablkcipher_req(rctx);
+			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			err = handle_ahash_req(rctx);
+			if (err == -EAGAIN)
+				/*
+				 * we saved data in hash carry, but tell crypto
+				 * API we successfully completed request.
+				 */
+				err = 0;
+			break;
+		case CRYPTO_ALG_TYPE_AEAD:
+			err = handle_aead_req(rctx);
+			break;
+		default:
+			err = -EINVAL;
+		}
+
+		if (err == -EINPROGRESS)
+			/* Successfully submitted request for next chunk */
+			return;
+	}
+
+cb_finish:
+	finish_req(rctx, err);
+}
+
+/* ==================== Kernel Cryptographic API ==================== */
+
+/**
+ * ablkcipher_enqueue() - Handle ablkcipher encrypt or decrypt request.
+ * @req:	Crypto API request
+ * @encrypt:	true if encrypting; false if decrypting
+ *
+ * Return: -EINPROGRESS if request accepted and result will be returned
+ *			asynchronously
+ *	   < 0 if an error
+ */
+static int ablkcipher_enqueue(struct ablkcipher_request *req, bool encrypt)
+{
+	struct iproc_reqctx_s *rctx = ablkcipher_request_ctx(req);
+	struct iproc_ctx_s *ctx =
+	    crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
+	int err;
+
+	flow_log("%s() enc:%u\n", __func__, encrypt);
+
+	rctx->gfp = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	rctx->parent = &req->base;
+	rctx->is_encrypt = encrypt;
+	rctx->bd_suppress = false;
+	rctx->total_todo = req->nbytes;
+	rctx->src_sent = 0;
+	rctx->total_sent = 0;
+	rctx->total_received = 0;
+	rctx->ctx = ctx;
+
+	/* Initialize current position in src and dst scatterlists */
+	rctx->src_sg = req->src;
+	rctx->src_nents = 0;
+	rctx->src_skip = 0;
+	rctx->dst_sg = req->dst;
+	rctx->dst_nents = 0;
+	rctx->dst_skip = 0;
+
+	if (ctx->cipher.mode == CIPHER_MODE_CBC ||
+	    ctx->cipher.mode == CIPHER_MODE_CTR ||
+	    ctx->cipher.mode == CIPHER_MODE_OFB ||
+	    ctx->cipher.mode == CIPHER_MODE_XTS ||
+	    ctx->cipher.mode == CIPHER_MODE_GCM ||
+	    ctx->cipher.mode == CIPHER_MODE_CCM) {
+		rctx->iv_ctr_len =
+		    crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req));
+		memcpy(rctx->msg_buf.iv_ctr, req->info, rctx->iv_ctr_len);
+	} else {
+		rctx->iv_ctr_len = 0;
+	}
+
+	/* Choose a SPU to process this request */
+	rctx->chan_idx = select_channel();
+	err = handle_ablkcipher_req(rctx);
+	if (err != -EINPROGRESS)
+		/* synchronous result */
+		spu_chunk_cleanup(rctx);
+
+	return err;
+}
+
+static int des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+		      unsigned int keylen)
+{
+	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
+	u32 tmp[DES_EXPKEY_WORDS];
+
+	if (keylen == DES_KEY_SIZE) {
+		if (des_ekey(tmp, key) == 0) {
+			if (crypto_ablkcipher_get_flags(cipher) &
+			    CRYPTO_TFM_REQ_WEAK_KEY) {
+				u32 flags = CRYPTO_TFM_RES_WEAK_KEY;
+
+				crypto_ablkcipher_set_flags(cipher, flags);
+				return -EINVAL;
+			}
+		}
+
+		ctx->cipher_type = CIPHER_TYPE_DES;
+	} else {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int threedes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			   unsigned int keylen)
+{
+	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
+
+	if (keylen == (DES_KEY_SIZE * 3)) {
+		const u32 *K = (const u32 *)key;
+		u32 flags = CRYPTO_TFM_RES_BAD_KEY_SCHED;
+
+		if (!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
+		    !((K[2] ^ K[4]) | (K[3] ^ K[5]))) {
+			crypto_ablkcipher_set_flags(cipher, flags);
+			return -EINVAL;
+		}
+
+		ctx->cipher_type = CIPHER_TYPE_3DES;
+	} else {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+		      unsigned int keylen)
+{
+	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
+
+	if (ctx->cipher.mode == CIPHER_MODE_XTS)
+		/* XTS includes two keys of equal length */
+		keylen = keylen / 2;
+
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+		ctx->cipher_type = CIPHER_TYPE_AES128;
+		break;
+	case AES_KEYSIZE_192:
+		ctx->cipher_type = CIPHER_TYPE_AES192;
+		break;
+	case AES_KEYSIZE_256:
+		ctx->cipher_type = CIPHER_TYPE_AES256;
+		break;
+	default:
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	WARN_ON((ctx->max_payload != SPU_MAX_PAYLOAD_INF) &&
+		((ctx->max_payload % AES_BLOCK_SIZE) != 0));
+	return 0;
+}
+
+static int rc4_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+		      unsigned int keylen)
+{
+	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
+	int i;
+
+	ctx->enckeylen = ARC4_MAX_KEY_SIZE + ARC4_STATE_SIZE;
+
+	ctx->enckey[0] = 0x00;	/* 0x00 */
+	ctx->enckey[1] = 0x00;	/* i    */
+	ctx->enckey[2] = 0x00;	/* 0x00 */
+	ctx->enckey[3] = 0x00;	/* j    */
+	for (i = 0; i < ARC4_MAX_KEY_SIZE; i++)
+		ctx->enckey[i + ARC4_STATE_SIZE] = key[i % keylen];
+
+	ctx->cipher_type = CIPHER_TYPE_INIT;
+
+	return 0;
+}
+
+static int ablkcipher_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+			     unsigned int keylen)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
+	struct spu_cipher_parms cipher_parms;
+	u32 alloc_len = 0;
+	int err;
+
+	flow_log("ablkcipher_setkey() keylen: %d\n", keylen);
+	flow_dump("  key: ", key, keylen);
+
+	switch (ctx->cipher.alg) {
+	case CIPHER_ALG_DES:
+		err = des_setkey(cipher, key, keylen);
+		break;
+	case CIPHER_ALG_3DES:
+		err = threedes_setkey(cipher, key, keylen);
+		break;
+	case CIPHER_ALG_AES:
+		err = aes_setkey(cipher, key, keylen);
+		break;
+	case CIPHER_ALG_RC4:
+		err = rc4_setkey(cipher, key, keylen);
+		break;
+	default:
+		pr_err("%s() Error: unknown cipher alg\n", __func__);
+		err = -EINVAL;
+	}
+	if (err)
+		return err;
+
+	/* RC4 already populated ctx->enkey */
+	if (ctx->cipher.alg != CIPHER_ALG_RC4) {
+		memcpy(ctx->enckey, key, keylen);
+		ctx->enckeylen = keylen;
+	}
+	/* SPU needs XTS keys in the reverse order the crypto API presents */
+	if ((ctx->cipher.alg == CIPHER_ALG_AES) &&
+	    (ctx->cipher.mode == CIPHER_MODE_XTS)) {
+		unsigned int xts_keylen = keylen / 2;
+
+		memcpy(ctx->enckey, key + xts_keylen, xts_keylen);
+		memcpy(ctx->enckey + xts_keylen, key, xts_keylen);
+	}
+
+	if (spu->spu_type == SPU_TYPE_SPUM)
+		alloc_len = BCM_HDR_LEN + SPU_HEADER_ALLOC_LEN;
+	else if (spu->spu_type == SPU_TYPE_SPU2)
+		alloc_len = BCM_HDR_LEN + SPU2_HEADER_ALLOC_LEN;
+	memset(ctx->bcm_spu_req_hdr, 0, alloc_len);
+	cipher_parms.iv_buf = NULL;
+	cipher_parms.iv_len = crypto_ablkcipher_ivsize(cipher);
+	flow_log("%s: iv_len %u\n", __func__, cipher_parms.iv_len);
+
+	cipher_parms.alg = ctx->cipher.alg;
+	cipher_parms.mode = ctx->cipher.mode;
+	cipher_parms.type = ctx->cipher_type;
+	cipher_parms.key_buf = ctx->enckey;
+	cipher_parms.key_len = ctx->enckeylen;
+
+	/* Prepend SPU request message with BCM header */
+	memcpy(ctx->bcm_spu_req_hdr, BCMHEADER, BCM_HDR_LEN);
+	ctx->spu_req_hdr_len =
+	    spu->spu_cipher_req_init(ctx->bcm_spu_req_hdr + BCM_HDR_LEN,
+				     &cipher_parms);
+
+	ctx->spu_resp_hdr_len = spu->spu_response_hdr_len(ctx->authkeylen,
+							  ctx->enckeylen,
+							  false);
+
+	atomic_inc(&iproc_priv.setkey_cnt[SPU_OP_CIPHER]);
+
+	return 0;
+}
+
+static int ablkcipher_encrypt(struct ablkcipher_request *req)
+{
+	flow_log("ablkcipher_encrypt() nbytes:%u\n", req->nbytes);
+
+	return ablkcipher_enqueue(req, true);
+}
+
+static int ablkcipher_decrypt(struct ablkcipher_request *req)
+{
+	flow_log("ablkcipher_decrypt() nbytes:%u\n", req->nbytes);
+	return ablkcipher_enqueue(req, false);
+}
+
+static int ahash_enqueue(struct ahash_request *req)
+{
+	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
+	int err = 0;
+	const char *alg_name;
+
+	flow_log("ahash_enqueue() nbytes:%u\n", req->nbytes);
+
+	rctx->gfp = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	rctx->parent = &req->base;
+	rctx->ctx = ctx;
+	rctx->bd_suppress = true;
+	memset(&rctx->mb_mssg, 0, sizeof(struct brcm_message));
+
+	/* Initialize position in src scatterlist */
+	rctx->src_sg = req->src;
+	rctx->src_skip = 0;
+	rctx->src_nents = 0;
+	rctx->dst_sg = NULL;
+	rctx->dst_skip = 0;
+	rctx->dst_nents = 0;
+
+	/* SPU2 hardware does not compute hash of zero length data */
+	if ((rctx->is_final == 1) && (rctx->total_todo == 0) &&
+	    (iproc_priv.spu.spu_type == SPU_TYPE_SPU2)) {
+		alg_name = crypto_tfm_alg_name(crypto_ahash_tfm(tfm));
+		flow_log("Doing %sfinal %s zero-len hash request in software\n",
+			 rctx->is_final ? "" : "non-", alg_name);
+		err = do_shash((unsigned char *)alg_name, req->result,
+			       NULL, 0, NULL, 0, ctx->authkey,
+			       ctx->authkeylen);
+		if (err < 0)
+			flow_log("Hash request failed with error %d\n", err);
+		return err;
+	}
+	/* Choose a SPU to process this request */
+	rctx->chan_idx = select_channel();
+
+	err = handle_ahash_req(rctx);
+	if (err != -EINPROGRESS)
+		/* synchronous result */
+		spu_chunk_cleanup(rctx);
+
+	if (err == -EAGAIN)
+		/*
+		 * we saved data in hash carry, but tell crypto API
+		 * we successfully completed request.
+		 */
+		err = 0;
+
+	return err;
+}
+
+static int __ahash_init(struct ahash_request *req)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
+
+	flow_log("%s()\n", __func__);
+
+	/* Initialize the context */
+	rctx->hash_carry_len = 0;
+	rctx->is_final = 0;
+
+	rctx->total_todo = 0;
+	rctx->src_sent = 0;
+	rctx->total_sent = 0;
+	rctx->total_received = 0;
+
+	ctx->digestsize = crypto_ahash_digestsize(tfm);
+	/* If we add a hash whose digest is larger, catch it here. */
+	WARN_ON(ctx->digestsize > MAX_DIGEST_SIZE);
+
+	rctx->is_sw_hmac = false;
+
+	ctx->spu_resp_hdr_len = spu->spu_response_hdr_len(ctx->authkeylen, 0,
+							  true);
+
+	return 0;
+}
+
+/**
+ * spu_no_incr_hash() - Determine whether incremental hashing is supported.
+ * @ctx:  Crypto session context
+ *
+ * SPU-2 does not support incremental hashing (we'll have to revisit and
+ * condition based on chip revision or device tree entry if future versions do
+ * support incremental hash)
+ *
+ * SPU-M also doesn't support incremental hashing of AES-XCBC
+ *
+ * Return: true if incremental hashing is not supported
+ *         false otherwise
+ */
+bool spu_no_incr_hash(struct iproc_ctx_s *ctx)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+
+	if (spu->spu_type == SPU_TYPE_SPU2)
+		return true;
+
+	if ((ctx->auth.alg == HASH_ALG_AES) &&
+	    (ctx->auth.mode == HASH_MODE_XCBC))
+		return true;
+
+	/* Otherwise, incremental hashing is supported */
+	return false;
+}
+
+static int ahash_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
+	const char *alg_name;
+	struct crypto_shash *hash;
+	int ret;
+	gfp_t gfp;
+
+	if (spu_no_incr_hash(ctx)) {
+		/*
+		 * If we get an incremental hashing request and it's not
+		 * supported by the hardware, we need to handle it in software
+		 * by calling synchronous hash functions.
+		 */
+		alg_name = crypto_tfm_alg_name(crypto_ahash_tfm(tfm));
+		hash = crypto_alloc_shash(alg_name, 0, 0);
+		if (IS_ERR(hash)) {
+			ret = PTR_ERR(hash);
+			return ret;
+		}
+
+		gfp = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+		ctx->shash = kmalloc(sizeof(*ctx->shash) +
+				     crypto_shash_descsize(hash), gfp);
+		if (!ctx->shash) {
+			crypto_free_shash(hash);
+			return -ENOMEM;
+		}
+		ctx->shash->tfm = hash;
+		ctx->shash->flags = 0;
+
+		/* Set the key using data we already have from setkey */
+		if (ctx->authkeylen > 0) {
+			ret = crypto_shash_setkey(hash, ctx->authkey,
+						  ctx->authkeylen);
+			if (ret) {
+				crypto_free_shash(hash);
+				kfree(ctx->shash);
+				return ret;
+			}
+		}
+
+		/* Initialize hash w/ this key and other params */
+		ret = crypto_shash_init(ctx->shash);
+		if (ret) {
+			crypto_free_shash(hash);
+			kfree(ctx->shash);
+			return ret;
+		}
+	} else {
+		/* Otherwise call the internal function which uses SPU hw */
+		ret = __ahash_init(req);
+	}
+
+	return ret;
+}
+
+static int __ahash_update(struct ahash_request *req)
+{
+	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
+
+	flow_log("ahash_update() nbytes:%u\n", req->nbytes);
+
+	if (!req->nbytes)
+		return 0;
+	rctx->total_todo += req->nbytes;
+	rctx->src_sent = 0;
+
+	return ahash_enqueue(req);
+}
+
+static int ahash_update(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
+	u8 *tmpbuf;
+	int ret;
+	int nents;
+	gfp_t gfp;
+
+	if (spu_no_incr_hash(ctx)) {
+		/*
+		 * If we get an incremental hashing request and it's not
+		 * supported by the hardware, we need to handle it in software
+		 * by calling synchronous hash functions.
+		 */
+		if (req->src)
+			nents = sg_nents(req->src);
+		else
+			return -EINVAL;
+
+		/* Copy data from req scatterlist to tmp buffer */
+		gfp = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+		tmpbuf = kmalloc(req->nbytes, gfp);
+		if (!tmpbuf)
+			return -ENOMEM;
+
+		if (sg_copy_to_buffer(req->src, nents, tmpbuf, req->nbytes) !=
+				req->nbytes) {
+			kfree(tmpbuf);
+			return -EINVAL;
+		}
+
+		/* Call synchronous update */
+		ret = crypto_shash_update(ctx->shash, tmpbuf, req->nbytes);
+		kfree(tmpbuf);
+	} else {
+		/* Otherwise call the internal function which uses SPU hw */
+		ret = __ahash_update(req);
+	}
+
+	return ret;
+}
+
+static int __ahash_final(struct ahash_request *req)
+{
+	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
+
+	flow_log("ahash_final() nbytes:%u\n", req->nbytes);
+
+	rctx->is_final = 1;
+
+	return ahash_enqueue(req);
+}
+
+static int ahash_final(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
+	int ret;
+
+	if (spu_no_incr_hash(ctx)) {
+		/*
+		 * If we get an incremental hashing request and it's not
+		 * supported by the hardware, we need to handle it in software
+		 * by calling synchronous hash functions.
+		 */
+		ret = crypto_shash_final(ctx->shash, req->result);
+
+		/* Done with hash, can deallocate it now */
+		crypto_free_shash(ctx->shash->tfm);
+		kfree(ctx->shash);
+
+	} else {
+		/* Otherwise call the internal function which uses SPU hw */
+		ret = __ahash_final(req);
+	}
+
+	return ret;
+}
+
+static int __ahash_finup(struct ahash_request *req)
+{
+	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
+
+	flow_log("ahash_finup() nbytes:%u\n", req->nbytes);
+
+	rctx->total_todo += req->nbytes;
+	rctx->src_sent = 0;
+	rctx->is_final = 1;
+
+	return ahash_enqueue(req);
+}
+
+static int ahash_finup(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
+	u8 *tmpbuf;
+	int ret;
+	int nents;
+	gfp_t gfp;
+
+	if (spu_no_incr_hash(ctx)) {
+		/*
+		 * If we get an incremental hashing request and it's not
+		 * supported by the hardware, we need to handle it in software
+		 * by calling synchronous hash functions.
+		 */
+		if (req->src) {
+			nents = sg_nents(req->src);
+		} else {
+			ret = -EINVAL;
+			goto ahash_finup_exit;
+		}
+
+		/* Copy data from req scatterlist to tmp buffer */
+		gfp = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+		tmpbuf = kmalloc(req->nbytes, gfp);
+		if (!tmpbuf) {
+			ret = -ENOMEM;
+			goto ahash_finup_exit;
+		}
+
+		if (sg_copy_to_buffer(req->src, nents, tmpbuf, req->nbytes) !=
+				req->nbytes) {
+			kfree(tmpbuf);
+			ret = -EINVAL;
+			goto ahash_finup_exit;
+		}
+
+		/* Call synchronous update */
+		ret = crypto_shash_finup(ctx->shash, tmpbuf, req->nbytes,
+					 req->result);
+		kfree(tmpbuf);
+	} else {
+		/* Otherwise call the internal function which uses SPU hw */
+		return __ahash_finup(req);
+	}
+
+ahash_finup_exit:
+	/* Done with hash, can deallocate it now */
+	crypto_free_shash(ctx->shash->tfm);
+	kfree(ctx->shash);
+	return ret;
+}
+
+static int ahash_digest(struct ahash_request *req)
+{
+	int err = 0;
+
+	flow_log("ahash_digest() nbytes:%u\n", req->nbytes);
+
+	/* whole thing at once */
+	err = __ahash_init(req);
+	if (!err)
+		err = __ahash_finup(req);
+
+	return err;
+}
+
+static int ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
+			unsigned int keylen)
+{
+	struct iproc_ctx_s *ctx = crypto_ahash_ctx(ahash);
+
+	flow_log("%s() ahash:%p key:%p keylen:%u\n",
+		 __func__, ahash, key, keylen);
+	flow_dump("  key: ", key, keylen);
+
+	if (ctx->auth.alg == HASH_ALG_AES) {
+		switch (keylen) {
+		case AES_KEYSIZE_128:
+			ctx->cipher_type = CIPHER_TYPE_AES128;
+			break;
+		case AES_KEYSIZE_192:
+			ctx->cipher_type = CIPHER_TYPE_AES192;
+			break;
+		case AES_KEYSIZE_256:
+			ctx->cipher_type = CIPHER_TYPE_AES256;
+			break;
+		default:
+			pr_err("%s() Error: Invalid key length\n", __func__);
+			return -EINVAL;
+		}
+	} else {
+		pr_err("%s() Error: unknown hash alg\n", __func__);
+		return -EINVAL;
+	}
+	memcpy(ctx->authkey, key, keylen);
+	ctx->authkeylen = keylen;
+
+	return 0;
+}
+
+static int ahash_export(struct ahash_request *req, void *out)
+{
+	const struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
+
+	memcpy(out, rctx, offsetof(struct iproc_reqctx_s, msg_buf));
+	return 0;
+}
+
+static int ahash_import(struct ahash_request *req, const void *in)
+{
+	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
+
+	memcpy(rctx, in, offsetof(struct iproc_reqctx_s, msg_buf));
+	return 0;
+}
+
+static int ahash_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
+			     unsigned int keylen)
+{
+	struct iproc_ctx_s *ctx = crypto_ahash_ctx(ahash);
+	unsigned int blocksize =
+		crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
+	unsigned int digestsize = crypto_ahash_digestsize(ahash);
+	unsigned int index;
+	int rc;
+
+	flow_log("%s() ahash:%p key:%p keylen:%u blksz:%u digestsz:%u\n",
+		 __func__, ahash, key, keylen, blocksize, digestsize);
+	flow_dump("  key: ", key, keylen);
+
+	if (keylen > blocksize) {
+		switch (ctx->auth.alg) {
+		case HASH_ALG_MD5:
+			rc = do_shash("md5", ctx->authkey, key, keylen, NULL,
+				      0, NULL, 0);
+			break;
+		case HASH_ALG_SHA1:
+			rc = do_shash("sha1", ctx->authkey, key, keylen, NULL,
+				      0, NULL, 0);
+			break;
+		case HASH_ALG_SHA224:
+			rc = do_shash("sha224", ctx->authkey, key, keylen, NULL,
+				      0, NULL, 0);
+			break;
+		case HASH_ALG_SHA256:
+			rc = do_shash("sha256", ctx->authkey, key, keylen, NULL,
+				      0, NULL, 0);
+			break;
+		case HASH_ALG_SHA384:
+			rc = do_shash("sha384", ctx->authkey, key, keylen, NULL,
+				      0, NULL, 0);
+			break;
+		case HASH_ALG_SHA512:
+			rc = do_shash("sha512", ctx->authkey, key, keylen, NULL,
+				      0, NULL, 0);
+			break;
+		case HASH_ALG_SHA3_224:
+			rc = do_shash("sha3-224", ctx->authkey, key, keylen,
+				      NULL, 0, NULL, 0);
+			break;
+		case HASH_ALG_SHA3_256:
+			rc = do_shash("sha3-256", ctx->authkey, key, keylen,
+				      NULL, 0, NULL, 0);
+			break;
+		case HASH_ALG_SHA3_384:
+			rc = do_shash("sha3-384", ctx->authkey, key, keylen,
+				      NULL, 0, NULL, 0);
+			break;
+		case HASH_ALG_SHA3_512:
+			rc = do_shash("sha3-512", ctx->authkey, key, keylen,
+				      NULL, 0, NULL, 0);
+			break;
+		default:
+			pr_err("%s() Error: unknown hash alg\n", __func__);
+			return -EINVAL;
+		}
+		if (rc < 0) {
+			pr_err("%s() Error %d computing shash for %s\n",
+			       __func__, rc, hash_alg_name[ctx->auth.alg]);
+			return rc;
+		}
+		ctx->authkeylen = digestsize;
+
+		flow_log("  keylen > digestsize... hashed\n");
+		flow_dump("  newkey: ", ctx->authkey, ctx->authkeylen);
+	} else {
+		memcpy(ctx->authkey, key, keylen);
+		ctx->authkeylen = keylen;
+	}
+
+	/*
+	 * Full HMAC operation in SPUM is not verified,
+	 * So keeping the generation of IPAD, OPAD and
+	 * outer hashing in software.
+	 */
+	if (iproc_priv.spu.spu_type == SPU_TYPE_SPUM) {
+		memcpy(ctx->ipad, ctx->authkey, ctx->authkeylen);
+		memset(ctx->ipad + ctx->authkeylen, 0,
+		       blocksize - ctx->authkeylen);
+		ctx->authkeylen = 0;
+		memcpy(ctx->opad, ctx->ipad, blocksize);
+
+		for (index = 0; index < blocksize; index++) {
+			ctx->ipad[index] ^= 0x36;
+			ctx->opad[index] ^= 0x5c;
+		}
+
+		flow_dump("  ipad: ", ctx->ipad, blocksize);
+		flow_dump("  opad: ", ctx->opad, blocksize);
+	}
+	ctx->digestsize = digestsize;
+	atomic_inc(&iproc_priv.setkey_cnt[SPU_OP_HMAC]);
+
+	return 0;
+}
+
+static int ahash_hmac_init(struct ahash_request *req)
+{
+	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+
+	flow_log("ahash_hmac_init()\n");
+
+	/* init the context as a hash */
+	ahash_init(req);
+
+	if (!spu_no_incr_hash(ctx)) {
+		/* SPU-M can do incr hashing but needs sw for outer HMAC */
+		rctx->is_sw_hmac = true;
+		ctx->auth.mode = HASH_MODE_HASH;
+		/* start with a prepended ipad */
+		memcpy(rctx->hash_carry, ctx->ipad, blocksize);
+		rctx->hash_carry_len = blocksize;
+		rctx->total_todo += blocksize;
+	}
+
+	return 0;
+}
+
+static int ahash_hmac_update(struct ahash_request *req)
+{
+	flow_log("ahash_hmac_update() nbytes:%u\n", req->nbytes);
+
+	if (!req->nbytes)
+		return 0;
+
+	return ahash_update(req);
+}
+
+static int ahash_hmac_final(struct ahash_request *req)
+{
+	flow_log("ahash_hmac_final() nbytes:%u\n", req->nbytes);
+
+	return ahash_final(req);
+}
+
+static int ahash_hmac_finup(struct ahash_request *req)
+{
+	flow_log("ahash_hmac_finupl() nbytes:%u\n", req->nbytes);
+
+	return ahash_finup(req);
+}
+
+static int ahash_hmac_digest(struct ahash_request *req)
+{
+	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+
+	flow_log("ahash_hmac_digest() nbytes:%u\n", req->nbytes);
+
+	/* Perform initialization and then call finup */
+	__ahash_init(req);
+
+	if (iproc_priv.spu.spu_type == SPU_TYPE_SPU2) {
+		/*
+		 * SPU2 supports full HMAC implementation in the
+		 * hardware, need not to generate IPAD, OPAD and
+		 * outer hash in software.
+		 * Only for hash key len > hash block size, SPU2
+		 * expects to perform hashing on the key, shorten
+		 * it to digest size and feed it as hash key.
+		 */
+		rctx->is_sw_hmac = false;
+		ctx->auth.mode = HASH_MODE_HMAC;
+	} else {
+		rctx->is_sw_hmac = true;
+		ctx->auth.mode = HASH_MODE_HASH;
+		/* start with a prepended ipad */
+		memcpy(rctx->hash_carry, ctx->ipad, blocksize);
+		rctx->hash_carry_len = blocksize;
+		rctx->total_todo += blocksize;
+	}
+
+	return __ahash_finup(req);
+}
+
+/* aead helpers */
+
+static int aead_need_fallback(struct aead_request *req)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct iproc_ctx_s *ctx = crypto_aead_ctx(aead);
+	u32 payload_len;
+
+	/*
+	 * SPU hardware cannot handle the AES-GCM/CCM case where plaintext
+	 * and AAD are both 0 bytes long. So use fallback in this case.
+	 */
+	if (((ctx->cipher.mode == CIPHER_MODE_GCM) ||
+	     (ctx->cipher.mode == CIPHER_MODE_CCM)) &&
+	     (req->cryptlen + req->assoclen) == 0) {
+		flow_log("%s() AES GCM/CCM needs fallback for 0 len request\n",
+			 __func__);
+		return 1;
+	}
+
+	/* SPU-M hardware only supports CCM digest size of 8, 12, or 16 bytes */
+	if ((ctx->cipher.mode == CIPHER_MODE_CCM) &&
+	    (spu->spu_type == SPU_TYPE_SPUM) &&
+	    (ctx->digestsize != 8) && (ctx->digestsize != 12) &&
+	    (ctx->digestsize != 16)) {
+		flow_log("%s() AES CCM needs fallbck for digest size %d\n",
+			 __func__, ctx->digestsize);
+		return 1;
+	}
+
+	/*
+	 * SPU-M on NSP has an issue where AES-CCM hash is not correct
+	 * when AAD size is 0
+	 */
+	if ((ctx->cipher.mode == CIPHER_MODE_CCM) &&
+	    (spu->spu_subtype == SPU_SUBTYPE_SPUM_NSP) &&
+	    (req->assoclen == 0)) {
+		flow_log("%s() AES_CCM needs fallback for 0 len AAD on NSP\n",
+			 __func__);
+		return 1;
+	}
+
+	payload_len = req->cryptlen;
+	if (spu->spu_type == SPU_TYPE_SPUM)
+		payload_len += req->assoclen;
+
+	flow_log("%s() payload len: %u\n", __func__, payload_len);
+
+	if (ctx->max_payload == SPU_MAX_PAYLOAD_INF)
+		return 0;
+	else
+		return payload_len > ctx->max_payload;
+}
+
+static void aead_complete(struct crypto_async_request *areq, int err)
+{
+	struct aead_request *req =
+	    container_of(areq, struct aead_request, base);
+	struct iproc_reqctx_s *rctx = aead_request_ctx(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+
+	flow_log("%s() err:%d\n", __func__, err);
+
+	areq->tfm = crypto_aead_tfm(aead);
+
+	areq->complete = rctx->old_complete;
+	areq->data = rctx->old_data;
+
+	areq->complete(areq, err);
+}
+
+static int aead_do_fallback(struct aead_request *req, bool is_encrypt)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct iproc_reqctx_s *rctx = aead_request_ctx(req);
+	struct iproc_ctx_s *ctx = crypto_tfm_ctx(tfm);
+	int err;
+	u32 req_flags;
+
+	flow_log("%s() enc:%u\n", __func__, is_encrypt);
+
+	if (ctx->fallback_cipher) {
+		/* Store the cipher tfm and then use the fallback tfm */
+		rctx->old_tfm = tfm;
+		aead_request_set_tfm(req, ctx->fallback_cipher);
+		/*
+		 * Save the callback and chain ourselves in, so we can restore
+		 * the tfm
+		 */
+		rctx->old_complete = req->base.complete;
+		rctx->old_data = req->base.data;
+		req_flags = aead_request_flags(req);
+		aead_request_set_callback(req, req_flags, aead_complete, req);
+		err = is_encrypt ? crypto_aead_encrypt(req) :
+		    crypto_aead_decrypt(req);
+
+		if (err == 0) {
+			/*
+			 * fallback was synchronous (did not return
+			 * -EINPROGRESS). So restore request state here.
+			 */
+			aead_request_set_callback(req, req_flags,
+						  rctx->old_complete, req);
+			req->base.data = rctx->old_data;
+			aead_request_set_tfm(req, aead);
+			flow_log("%s() fallback completed successfully\n\n",
+				 __func__);
+		}
+	} else {
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+static int aead_enqueue(struct aead_request *req, bool is_encrypt)
+{
+	struct iproc_reqctx_s *rctx = aead_request_ctx(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct iproc_ctx_s *ctx = crypto_aead_ctx(aead);
+	int err;
+
+	flow_log("%s() enc:%u\n", __func__, is_encrypt);
+
+	if (req->assoclen > MAX_ASSOC_SIZE) {
+		pr_err
+		    ("%s() Error: associated data too long. (%u > %u bytes)\n",
+		     __func__, req->assoclen, MAX_ASSOC_SIZE);
+		return -EINVAL;
+	}
+
+	rctx->gfp = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	rctx->parent = &req->base;
+	rctx->is_encrypt = is_encrypt;
+	rctx->bd_suppress = false;
+	rctx->total_todo = req->cryptlen;
+	rctx->src_sent = 0;
+	rctx->total_sent = 0;
+	rctx->total_received = 0;
+	rctx->is_sw_hmac = false;
+	rctx->ctx = ctx;
+	memset(&rctx->mb_mssg, 0, sizeof(struct brcm_message));
+
+	/* assoc data is at start of src sg */
+	rctx->assoc = req->src;
+
+	/*
+	 * Init current position in src scatterlist to be after assoc data.
+	 * src_skip set to buffer offset where data begins. (Assoc data could
+	 * end in the middle of a buffer.)
+	 */
+	if (spu_sg_at_offset(req->src, req->assoclen, &rctx->src_sg,
+			     &rctx->src_skip) < 0) {
+		pr_err("%s() Error: Unable to find start of src data\n",
+		       __func__);
+		return -EINVAL;
+	}
+
+	rctx->src_nents = 0;
+	rctx->dst_nents = 0;
+	if (req->dst == req->src) {
+		rctx->dst_sg = rctx->src_sg;
+		rctx->dst_skip = rctx->src_skip;
+	} else {
+		/*
+		 * Expect req->dst to have room for assoc data followed by
+		 * output data and ICV, if encrypt. So initialize dst_sg
+		 * to point beyond assoc len offset.
+		 */
+		if (spu_sg_at_offset(req->dst, req->assoclen, &rctx->dst_sg,
+				     &rctx->dst_skip) < 0) {
+			pr_err("%s() Error: Unable to find start of dst data\n",
+			       __func__);
+			return -EINVAL;
+		}
+	}
+
+	if (ctx->cipher.mode == CIPHER_MODE_CBC ||
+	    ctx->cipher.mode == CIPHER_MODE_CTR ||
+	    ctx->cipher.mode == CIPHER_MODE_OFB ||
+	    ctx->cipher.mode == CIPHER_MODE_XTS ||
+	    ctx->cipher.mode == CIPHER_MODE_GCM) {
+		rctx->iv_ctr_len =
+			ctx->salt_len +
+			crypto_aead_ivsize(crypto_aead_reqtfm(req));
+	} else if (ctx->cipher.mode == CIPHER_MODE_CCM) {
+		rctx->iv_ctr_len = CCM_AES_IV_SIZE;
+	} else {
+		rctx->iv_ctr_len = 0;
+	}
+
+	rctx->hash_carry_len = 0;
+
+	flow_log("  src sg: %p\n", req->src);
+	flow_log("  rctx->src_sg: %p, src_skip %u\n",
+		 rctx->src_sg, rctx->src_skip);
+	flow_log("  assoc:  %p, assoclen %u\n", rctx->assoc, req->assoclen);
+	flow_log("  dst sg: %p\n", req->dst);
+	flow_log("  rctx->dst_sg: %p, dst_skip %u\n",
+		 rctx->dst_sg, rctx->dst_skip);
+	flow_log("  iv_ctr_len:%u\n", rctx->iv_ctr_len);
+	flow_dump("  iv: ", req->iv, rctx->iv_ctr_len);
+	flow_log("  authkeylen:%u\n", ctx->authkeylen);
+	flow_log("  is_esp: %s\n", ctx->is_esp ? "yes" : "no");
+
+	if (ctx->max_payload == SPU_MAX_PAYLOAD_INF)
+		flow_log("  max_payload infinite");
+	else
+		flow_log("  max_payload: %u\n", ctx->max_payload);
+
+	if (unlikely(aead_need_fallback(req)))
+		return aead_do_fallback(req, is_encrypt);
+
+	/*
+	 * Do memory allocations for request after fallback check, because if we
+	 * do fallback, we won't call finish_req() to dealloc.
+	 */
+	if (rctx->iv_ctr_len) {
+		if (ctx->salt_len)
+			memcpy(rctx->msg_buf.iv_ctr + ctx->salt_offset,
+			       ctx->salt, ctx->salt_len);
+		memcpy(rctx->msg_buf.iv_ctr + ctx->salt_offset + ctx->salt_len,
+		       req->iv,
+		       rctx->iv_ctr_len - ctx->salt_len - ctx->salt_offset);
+	}
+
+	rctx->chan_idx = select_channel();
+	err = handle_aead_req(rctx);
+	if (err != -EINPROGRESS)
+		/* synchronous result */
+		spu_chunk_cleanup(rctx);
+
+	return err;
+}
+
+static int aead_authenc_setkey(struct crypto_aead *cipher,
+			       const u8 *key, unsigned int keylen)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
+	struct crypto_tfm *tfm = crypto_aead_tfm(cipher);
+	struct rtattr *rta = (void *)key;
+	struct crypto_authenc_key_param *param;
+	const u8 *origkey = key;
+	const unsigned int origkeylen = keylen;
+
+	int ret = 0;
+
+	flow_log("%s() aead:%p key:%p keylen:%u\n", __func__, cipher, key,
+		 keylen);
+	flow_dump("  key: ", key, keylen);
+
+	if (!RTA_OK(rta, keylen))
+		goto badkey;
+	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
+		goto badkey;
+	if (RTA_PAYLOAD(rta) < sizeof(*param))
+		goto badkey;
+
+	param = RTA_DATA(rta);
+	ctx->enckeylen = be32_to_cpu(param->enckeylen);
+
+	key += RTA_ALIGN(rta->rta_len);
+	keylen -= RTA_ALIGN(rta->rta_len);
+
+	if (keylen < ctx->enckeylen)
+		goto badkey;
+	if (ctx->enckeylen > MAX_KEY_SIZE)
+		goto badkey;
+
+	ctx->authkeylen = keylen - ctx->enckeylen;
+
+	if (ctx->authkeylen > MAX_KEY_SIZE)
+		goto badkey;
+
+	memcpy(ctx->enckey, key + ctx->authkeylen, ctx->enckeylen);
+	/* May end up padding auth key. So make sure it's zeroed. */
+	memset(ctx->authkey, 0, sizeof(ctx->authkey));
+	memcpy(ctx->authkey, key, ctx->authkeylen);
+
+	switch (ctx->alg->cipher_info.alg) {
+	case CIPHER_ALG_DES:
+		if (ctx->enckeylen == DES_KEY_SIZE) {
+			u32 tmp[DES_EXPKEY_WORDS];
+			u32 flags = CRYPTO_TFM_RES_WEAK_KEY;
+
+			if (des_ekey(tmp, key) == 0) {
+				if (crypto_aead_get_flags(cipher) &
+				    CRYPTO_TFM_REQ_WEAK_KEY) {
+					crypto_aead_set_flags(cipher, flags);
+					return -EINVAL;
+				}
+			}
+
+			ctx->cipher_type = CIPHER_TYPE_DES;
+		} else {
+			goto badkey;
+		}
+		break;
+	case CIPHER_ALG_3DES:
+		if (ctx->enckeylen == (DES_KEY_SIZE * 3)) {
+			const u32 *K = (const u32 *)key;
+			u32 flags = CRYPTO_TFM_RES_BAD_KEY_SCHED;
+
+			if (!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
+			    !((K[2] ^ K[4]) | (K[3] ^ K[5]))) {
+				crypto_aead_set_flags(cipher, flags);
+				return -EINVAL;
+			}
+
+			ctx->cipher_type = CIPHER_TYPE_3DES;
+		} else {
+			crypto_aead_set_flags(cipher,
+					      CRYPTO_TFM_RES_BAD_KEY_LEN);
+			return -EINVAL;
+		}
+		break;
+	case CIPHER_ALG_AES:
+		switch (ctx->enckeylen) {
+		case AES_KEYSIZE_128:
+			ctx->cipher_type = CIPHER_TYPE_AES128;
+			break;
+		case AES_KEYSIZE_192:
+			ctx->cipher_type = CIPHER_TYPE_AES192;
+			break;
+		case AES_KEYSIZE_256:
+			ctx->cipher_type = CIPHER_TYPE_AES256;
+			break;
+		default:
+			goto badkey;
+		}
+		break;
+	case CIPHER_ALG_RC4:
+		ctx->cipher_type = CIPHER_TYPE_INIT;
+		break;
+	default:
+		pr_err("%s() Error: Unknown cipher alg\n", __func__);
+		return -EINVAL;
+	}
+
+	flow_log("  enckeylen:%u authkeylen:%u\n", ctx->enckeylen,
+		 ctx->authkeylen);
+	flow_dump("  enc: ", ctx->enckey, ctx->enckeylen);
+	flow_dump("  auth: ", ctx->authkey, ctx->authkeylen);
+
+	/* setkey the fallback just in case we needto use it */
+	if (ctx->fallback_cipher) {
+		flow_log("  running fallback setkey()\n");
+
+		ctx->fallback_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+		ctx->fallback_cipher->base.crt_flags |=
+		    tfm->crt_flags & CRYPTO_TFM_REQ_MASK;
+		ret =
+		    crypto_aead_setkey(ctx->fallback_cipher, origkey,
+				       origkeylen);
+		if (ret) {
+			flow_log("  fallback setkey() returned:%d\n", ret);
+			tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
+			tfm->crt_flags |=
+			    (ctx->fallback_cipher->
+			     base.crt_flags & CRYPTO_TFM_RES_MASK);
+		}
+	}
+
+	ctx->spu_resp_hdr_len = spu->spu_response_hdr_len(ctx->authkeylen,
+							  ctx->enckeylen,
+							  false);
+
+	atomic_inc(&iproc_priv.setkey_cnt[SPU_OP_AEAD]);
+
+	return ret;
+
+badkey:
+	ctx->enckeylen = 0;
+	ctx->authkeylen = 0;
+	ctx->digestsize = 0;
+
+	crypto_aead_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+}
+
+static int aead_gcm_ccm_setkey(struct crypto_aead *cipher,
+			       const u8 *key, unsigned int keylen)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
+	struct crypto_tfm *tfm = crypto_aead_tfm(cipher);
+
+	int ret = 0;
+
+	flow_log("%s() keylen:%u\n", __func__, keylen);
+	flow_dump("  key: ", key, keylen);
+
+	if (!ctx->is_esp)
+		ctx->digestsize = keylen;
+
+	ctx->enckeylen = keylen;
+	ctx->authkeylen = 0;
+	memcpy(ctx->enckey, key, ctx->enckeylen);
+
+	switch (ctx->enckeylen) {
+	case AES_KEYSIZE_128:
+		ctx->cipher_type = CIPHER_TYPE_AES128;
+		break;
+	case AES_KEYSIZE_192:
+		ctx->cipher_type = CIPHER_TYPE_AES192;
+		break;
+	case AES_KEYSIZE_256:
+		ctx->cipher_type = CIPHER_TYPE_AES256;
+		break;
+	default:
+		goto badkey;
+	}
+
+	flow_log("  enckeylen:%u authkeylen:%u\n", ctx->enckeylen,
+		 ctx->authkeylen);
+	flow_dump("  enc: ", ctx->enckey, ctx->enckeylen);
+	flow_dump("  auth: ", ctx->authkey, ctx->authkeylen);
+
+	/* setkey the fallback just in case we need to use it */
+	if (ctx->fallback_cipher) {
+		flow_log("  running fallback setkey()\n");
+
+		ctx->fallback_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+		ctx->fallback_cipher->base.crt_flags |=
+		    tfm->crt_flags & CRYPTO_TFM_REQ_MASK;
+		ret = crypto_aead_setkey(ctx->fallback_cipher, key,
+					 keylen + ctx->salt_len);
+		if (ret) {
+			flow_log("  fallback setkey() returned:%d\n", ret);
+			tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
+			tfm->crt_flags |=
+			    (ctx->fallback_cipher->
+			     base.crt_flags & CRYPTO_TFM_RES_MASK);
+		}
+	}
+
+	ctx->spu_resp_hdr_len = spu->spu_response_hdr_len(ctx->authkeylen,
+							  ctx->enckeylen,
+							  false);
+
+	atomic_inc(&iproc_priv.setkey_cnt[SPU_OP_AEAD]);
+
+	flow_log("  enckeylen:%u authkeylen:%u\n", ctx->enckeylen,
+		 ctx->authkeylen);
+
+	return ret;
+
+badkey:
+	ctx->enckeylen = 0;
+	ctx->authkeylen = 0;
+	ctx->digestsize = 0;
+
+	crypto_aead_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+}
+
+/**
+ * aead_gcm_esp_setkey() - setkey() operation for ESP variant of GCM AES.
+ * @cipher: AEAD structure
+ * @key:    Key followed by 4 bytes of salt
+ * @keylen: Length of key plus salt, in bytes
+ *
+ * Extracts salt from key and stores it to be prepended to IV on each request.
+ * Digest is always 16 bytes
+ *
+ * Return: Value from generic gcm setkey.
+ */
+static int aead_gcm_esp_setkey(struct crypto_aead *cipher,
+			       const u8 *key, unsigned int keylen)
+{
+	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
+
+	flow_log("%s\n", __func__);
+	ctx->salt_len = GCM_ESP_SALT_SIZE;
+	ctx->salt_offset = GCM_ESP_SALT_OFFSET;
+	memcpy(ctx->salt, key + keylen - GCM_ESP_SALT_SIZE, GCM_ESP_SALT_SIZE);
+	keylen -= GCM_ESP_SALT_SIZE;
+	ctx->digestsize = GCM_ESP_DIGESTSIZE;
+	ctx->is_esp = true;
+	flow_dump("salt: ", ctx->salt, GCM_ESP_SALT_SIZE);
+
+	return aead_gcm_ccm_setkey(cipher, key, keylen);
+}
+
+/**
+ * rfc4543_gcm_esp_setkey() - setkey operation for RFC4543 variant of GCM/GMAC.
+ * cipher: AEAD structure
+ * key:    Key followed by 4 bytes of salt
+ * keylen: Length of key plus salt, in bytes
+ *
+ * Extracts salt from key and stores it to be prepended to IV on each request.
+ * Digest is always 16 bytes
+ *
+ * Return: Value from generic gcm setkey.
+ */
+static int rfc4543_gcm_esp_setkey(struct crypto_aead *cipher,
+				  const u8 *key, unsigned int keylen)
+{
+	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
+
+	flow_log("%s\n", __func__);
+	ctx->salt_len = GCM_ESP_SALT_SIZE;
+	ctx->salt_offset = GCM_ESP_SALT_OFFSET;
+	memcpy(ctx->salt, key + keylen - GCM_ESP_SALT_SIZE, GCM_ESP_SALT_SIZE);
+	keylen -= GCM_ESP_SALT_SIZE;
+	ctx->digestsize = GCM_ESP_DIGESTSIZE;
+	ctx->is_esp = true;
+	ctx->is_rfc4543 = true;
+	flow_dump("salt: ", ctx->salt, GCM_ESP_SALT_SIZE);
+
+	return aead_gcm_ccm_setkey(cipher, key, keylen);
+}
+
+/**
+ * aead_ccm_esp_setkey() - setkey() operation for ESP variant of CCM AES.
+ * @cipher: AEAD structure
+ * @key:    Key followed by 4 bytes of salt
+ * @keylen: Length of key plus salt, in bytes
+ *
+ * Extracts salt from key and stores it to be prepended to IV on each request.
+ * Digest is always 16 bytes
+ *
+ * Return: Value from generic ccm setkey.
+ */
+static int aead_ccm_esp_setkey(struct crypto_aead *cipher,
+			       const u8 *key, unsigned int keylen)
+{
+	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
+
+	flow_log("%s\n", __func__);
+	ctx->salt_len = CCM_ESP_SALT_SIZE;
+	ctx->salt_offset = CCM_ESP_SALT_OFFSET;
+	memcpy(ctx->salt, key + keylen - CCM_ESP_SALT_SIZE, CCM_ESP_SALT_SIZE);
+	keylen -= CCM_ESP_SALT_SIZE;
+	ctx->is_esp = true;
+	flow_dump("salt: ", ctx->salt, CCM_ESP_SALT_SIZE);
+
+	return aead_gcm_ccm_setkey(cipher, key, keylen);
+}
+
+static int aead_setauthsize(struct crypto_aead *cipher, unsigned int authsize)
+{
+	struct iproc_ctx_s *ctx = crypto_aead_ctx(cipher);
+	int ret = 0;
+
+	flow_log("%s() authkeylen:%u authsize:%u\n",
+		 __func__, ctx->authkeylen, authsize);
+
+	ctx->digestsize = authsize;
+
+	/* setkey the fallback just in case we needto use it */
+	if (ctx->fallback_cipher) {
+		flow_log("  running fallback setauth()\n");
+
+		ret = crypto_aead_setauthsize(ctx->fallback_cipher, authsize);
+		if (ret)
+			flow_log("  fallback setauth() returned:%d\n", ret);
+	}
+
+	return ret;
+}
+
+static int aead_encrypt(struct aead_request *req)
+{
+	flow_log("%s() cryptlen:%u %08x\n", __func__, req->cryptlen,
+		 req->cryptlen);
+	dump_sg(req->src, 0, req->cryptlen + req->assoclen);
+	flow_log("  assoc_len:%u\n", req->assoclen);
+
+	return aead_enqueue(req, true);
+}
+
+static int aead_decrypt(struct aead_request *req)
+{
+	flow_log("%s() cryptlen:%u\n", __func__, req->cryptlen);
+	dump_sg(req->src, 0, req->cryptlen + req->assoclen);
+	flow_log("  assoc_len:%u\n", req->assoclen);
+
+	return aead_enqueue(req, false);
+}
+
+/* ==================== Supported Cipher Algorithms ==================== */
+
+static struct iproc_alg_s driver_algs[] = {
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "gcm(aes)",
+			.cra_driver_name = "gcm-aes-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK
+		 },
+		 .setkey = aead_gcm_ccm_setkey,
+		 .ivsize = GCM_AES_IV_SIZE,
+		.maxauthsize = AES_BLOCK_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_GCM,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_AES,
+		       .mode = HASH_MODE_GCM,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "ccm(aes)",
+			.cra_driver_name = "ccm-aes-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK
+		 },
+		 .setkey = aead_gcm_ccm_setkey,
+		 .ivsize = CCM_AES_IV_SIZE,
+		.maxauthsize = AES_BLOCK_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_CCM,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_AES,
+		       .mode = HASH_MODE_CCM,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "rfc4106(gcm(aes))",
+			.cra_driver_name = "gcm-aes-esp-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK
+		 },
+		 .setkey = aead_gcm_esp_setkey,
+		 .ivsize = GCM_ESP_IV_SIZE,
+		 .maxauthsize = AES_BLOCK_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_GCM,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_AES,
+		       .mode = HASH_MODE_GCM,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "rfc4309(ccm(aes))",
+			.cra_driver_name = "ccm-aes-esp-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK
+		 },
+		 .setkey = aead_ccm_esp_setkey,
+		 .ivsize = CCM_AES_IV_SIZE,
+		 .maxauthsize = AES_BLOCK_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_CCM,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_AES,
+		       .mode = HASH_MODE_CCM,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "rfc4543(gcm(aes))",
+			.cra_driver_name = "gmac-aes-esp-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK
+		 },
+		 .setkey = rfc4543_gcm_esp_setkey,
+		 .ivsize = GCM_ESP_IV_SIZE,
+		 .maxauthsize = AES_BLOCK_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_GCM,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_AES,
+		       .mode = HASH_MODE_GCM,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(md5),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-md5-cbc-aes-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		.ivsize = AES_BLOCK_SIZE,
+		.maxauthsize = MD5_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_MD5,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha1),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-sha1-cbc-aes-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = AES_BLOCK_SIZE,
+		 .maxauthsize = SHA1_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA1,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha256),cbc(aes))",
+			.cra_driver_name = "authenc-hmac-sha256-cbc-aes-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = AES_BLOCK_SIZE,
+		 .maxauthsize = SHA256_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA256,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(md5),cbc(des))",
+			.cra_driver_name = "authenc-hmac-md5-cbc-des-iproc",
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES_BLOCK_SIZE,
+		 .maxauthsize = MD5_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_MD5,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha1),cbc(des))",
+			.cra_driver_name = "authenc-hmac-sha1-cbc-des-iproc",
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES_BLOCK_SIZE,
+		 .maxauthsize = SHA1_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA1,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha224),cbc(des))",
+			.cra_driver_name = "authenc-hmac-sha224-cbc-des-iproc",
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES_BLOCK_SIZE,
+		 .maxauthsize = SHA224_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA224,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha256),cbc(des))",
+			.cra_driver_name = "authenc-hmac-sha256-cbc-des-iproc",
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES_BLOCK_SIZE,
+		 .maxauthsize = SHA256_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA256,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha384),cbc(des))",
+			.cra_driver_name = "authenc-hmac-sha384-cbc-des-iproc",
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES_BLOCK_SIZE,
+		 .maxauthsize = SHA384_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA384,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha512),cbc(des))",
+			.cra_driver_name = "authenc-hmac-sha512-cbc-des-iproc",
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES_BLOCK_SIZE,
+		 .maxauthsize = SHA512_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA512,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-md5-cbc-des3-iproc",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES3_EDE_BLOCK_SIZE,
+		 .maxauthsize = MD5_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_3DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_MD5,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha1-cbc-des3-iproc",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES3_EDE_BLOCK_SIZE,
+		 .maxauthsize = SHA1_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_3DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA1,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha224),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha224-cbc-des3-iproc",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES3_EDE_BLOCK_SIZE,
+		 .maxauthsize = SHA224_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_3DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA224,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha256),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha256-cbc-des3-iproc",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES3_EDE_BLOCK_SIZE,
+		 .maxauthsize = SHA256_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_3DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA256,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha384),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha384-cbc-des3-iproc",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES3_EDE_BLOCK_SIZE,
+		 .maxauthsize = SHA384_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_3DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA384,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AEAD,
+	 .alg.aead = {
+		 .base = {
+			.cra_name = "authenc(hmac(sha512),cbc(des3_ede))",
+			.cra_driver_name = "authenc-hmac-sha512-cbc-des3-iproc",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC
+		 },
+		 .setkey = aead_authenc_setkey,
+		 .ivsize = DES3_EDE_BLOCK_SIZE,
+		 .maxauthsize = SHA512_DIGEST_SIZE,
+	 },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_3DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA512,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 .auth_first = 0,
+	 },
+
+/* ABLKCIPHER algorithms. */
+	{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "ecb(arc4)",
+			.cra_driver_name = "ecb-arc4-iproc",
+			.cra_blocksize = ARC4_BLOCK_SIZE,
+			.cra_ablkcipher = {
+					   .min_keysize = ARC4_MIN_KEY_SIZE,
+					   .max_keysize = ARC4_MAX_KEY_SIZE,
+					   .ivsize = 0,
+					}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_RC4,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "ofb(des)",
+			.cra_driver_name = "ofb-des-iproc",
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ablkcipher = {
+					   .min_keysize = DES_KEY_SIZE,
+					   .max_keysize = DES_KEY_SIZE,
+					   .ivsize = DES_BLOCK_SIZE,
+					}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_DES,
+			 .mode = CIPHER_MODE_OFB,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "cbc(des)",
+			.cra_driver_name = "cbc-des-iproc",
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ablkcipher = {
+					   .min_keysize = DES_KEY_SIZE,
+					   .max_keysize = DES_KEY_SIZE,
+					   .ivsize = DES_BLOCK_SIZE,
+					}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "ecb(des)",
+			.cra_driver_name = "ecb-des-iproc",
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ablkcipher = {
+					   .min_keysize = DES_KEY_SIZE,
+					   .max_keysize = DES_KEY_SIZE,
+					   .ivsize = 0,
+					}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_DES,
+			 .mode = CIPHER_MODE_ECB,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "ofb(des3_ede)",
+			.cra_driver_name = "ofb-des3-iproc",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ablkcipher = {
+					   .min_keysize = DES3_EDE_KEY_SIZE,
+					   .max_keysize = DES3_EDE_KEY_SIZE,
+					   .ivsize = DES3_EDE_BLOCK_SIZE,
+					}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_3DES,
+			 .mode = CIPHER_MODE_OFB,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "cbc(des3_ede)",
+			.cra_driver_name = "cbc-des3-iproc",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ablkcipher = {
+					   .min_keysize = DES3_EDE_KEY_SIZE,
+					   .max_keysize = DES3_EDE_KEY_SIZE,
+					   .ivsize = DES3_EDE_BLOCK_SIZE,
+					}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_3DES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "ecb(des3_ede)",
+			.cra_driver_name = "ecb-des3-iproc",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ablkcipher = {
+					   .min_keysize = DES3_EDE_KEY_SIZE,
+					   .max_keysize = DES3_EDE_KEY_SIZE,
+					   .ivsize = 0,
+					}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_3DES,
+			 .mode = CIPHER_MODE_ECB,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "ofb(aes)",
+			.cra_driver_name = "ofb-aes-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ablkcipher = {
+					   .min_keysize = AES_MIN_KEY_SIZE,
+					   .max_keysize = AES_MAX_KEY_SIZE,
+					   .ivsize = AES_BLOCK_SIZE,
+					}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_OFB,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "cbc(aes)",
+			.cra_driver_name = "cbc-aes-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ablkcipher = {
+					   .min_keysize = AES_MIN_KEY_SIZE,
+					   .max_keysize = AES_MAX_KEY_SIZE,
+					   .ivsize = AES_BLOCK_SIZE,
+					}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_CBC,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "ecb(aes)",
+			.cra_driver_name = "ecb-aes-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ablkcipher = {
+					   .min_keysize = AES_MIN_KEY_SIZE,
+					   .max_keysize = AES_MAX_KEY_SIZE,
+					   .ivsize = 0,
+					}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_ECB,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "ctr(aes)",
+			.cra_driver_name = "ctr-aes-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ablkcipher = {
+					   /* .geniv = "chainiv", */
+					   .min_keysize = AES_MIN_KEY_SIZE,
+					   .max_keysize = AES_MAX_KEY_SIZE,
+					   .ivsize = AES_BLOCK_SIZE,
+					}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_CTR,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+{
+	 .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	 .alg.crypto = {
+			.cra_name = "xts(aes)",
+			.cra_driver_name = "xts-aes-iproc",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ablkcipher = {
+				.min_keysize = 2 * AES_MIN_KEY_SIZE,
+				.max_keysize = 2 * AES_MAX_KEY_SIZE,
+				.ivsize = AES_BLOCK_SIZE,
+				}
+			},
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_AES,
+			 .mode = CIPHER_MODE_XTS,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_NONE,
+		       .mode = HASH_MODE_NONE,
+		       },
+	 },
+
+/* AHASH algorithms. */
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = MD5_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "md5",
+				    .cra_driver_name = "md5-iproc",
+				    .cra_blocksize = MD5_BLOCK_WORDS * 4,
+				    .cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_MD5,
+		       .mode = HASH_MODE_HASH,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = MD5_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "hmac(md5)",
+				    .cra_driver_name = "hmac-md5-iproc",
+				    .cra_blocksize = MD5_BLOCK_WORDS * 4,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_MD5,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 },
+	{.type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA1_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "sha1",
+				    .cra_driver_name = "sha1-iproc",
+				    .cra_blocksize = SHA1_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA1,
+		       .mode = HASH_MODE_HASH,
+		       },
+	 },
+	{.type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA1_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "hmac(sha1)",
+				    .cra_driver_name = "hmac-sha1-iproc",
+				    .cra_blocksize = SHA1_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA1,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 },
+	{.type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+			.halg.digestsize = SHA224_DIGEST_SIZE,
+			.halg.base = {
+				    .cra_name = "sha224",
+				    .cra_driver_name = "sha224-iproc",
+				    .cra_blocksize = SHA224_BLOCK_SIZE,
+			}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA224,
+		       .mode = HASH_MODE_HASH,
+		       },
+	 },
+	{.type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA224_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "hmac(sha224)",
+				    .cra_driver_name = "hmac-sha224-iproc",
+				    .cra_blocksize = SHA224_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA224,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 },
+	{.type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA256_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "sha256",
+				    .cra_driver_name = "sha256-iproc",
+				    .cra_blocksize = SHA256_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA256,
+		       .mode = HASH_MODE_HASH,
+		       },
+	 },
+	{.type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA256_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "hmac(sha256)",
+				    .cra_driver_name = "hmac-sha256-iproc",
+				    .cra_blocksize = SHA256_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA256,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 },
+	{
+	.type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA384_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "sha384",
+				    .cra_driver_name = "sha384-iproc",
+				    .cra_blocksize = SHA384_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA384,
+		       .mode = HASH_MODE_HASH,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA384_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "hmac(sha384)",
+				    .cra_driver_name = "hmac-sha384-iproc",
+				    .cra_blocksize = SHA384_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA384,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA512_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "sha512",
+				    .cra_driver_name = "sha512-iproc",
+				    .cra_blocksize = SHA512_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA512,
+		       .mode = HASH_MODE_HASH,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA512_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "hmac(sha512)",
+				    .cra_driver_name = "hmac-sha512-iproc",
+				    .cra_blocksize = SHA512_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA512,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA3_224_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "sha3-224",
+				    .cra_driver_name = "sha3-224-iproc",
+				    .cra_blocksize = SHA3_224_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA3_224,
+		       .mode = HASH_MODE_HASH,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA3_224_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "hmac(sha3-224)",
+				    .cra_driver_name = "hmac-sha3-224-iproc",
+				    .cra_blocksize = SHA3_224_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA3_224,
+		       .mode = HASH_MODE_HMAC
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA3_256_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "sha3-256",
+				    .cra_driver_name = "sha3-256-iproc",
+				    .cra_blocksize = SHA3_256_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA3_256,
+		       .mode = HASH_MODE_HASH,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA3_256_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "hmac(sha3-256)",
+				    .cra_driver_name = "hmac-sha3-256-iproc",
+				    .cra_blocksize = SHA3_256_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA3_256,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA3_384_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "sha3-384",
+				    .cra_driver_name = "sha3-384-iproc",
+				    .cra_blocksize = SHA3_224_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA3_384,
+		       .mode = HASH_MODE_HASH,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA3_384_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "hmac(sha3-384)",
+				    .cra_driver_name = "hmac-sha3-384-iproc",
+				    .cra_blocksize = SHA3_384_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA3_384,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA3_512_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "sha3-512",
+				    .cra_driver_name = "sha3-512-iproc",
+				    .cra_blocksize = SHA3_512_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA3_512,
+		       .mode = HASH_MODE_HASH,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = SHA3_512_DIGEST_SIZE,
+		      .halg.base = {
+				    .cra_name = "hmac(sha3-512)",
+				    .cra_driver_name = "hmac-sha3-512-iproc",
+				    .cra_blocksize = SHA3_512_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_SHA3_512,
+		       .mode = HASH_MODE_HMAC,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = AES_BLOCK_SIZE,
+		      .halg.base = {
+				    .cra_name = "xcbc(aes)",
+				    .cra_driver_name = "xcbc-aes-iproc",
+				    .cra_blocksize = AES_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_AES,
+		       .mode = HASH_MODE_XCBC,
+		       },
+	 },
+	{
+	 .type = CRYPTO_ALG_TYPE_AHASH,
+	 .alg.hash = {
+		      .halg.digestsize = AES_BLOCK_SIZE,
+		      .halg.base = {
+				    .cra_name = "cmac(aes)",
+				    .cra_driver_name = "cmac-aes-iproc",
+				    .cra_blocksize = AES_BLOCK_SIZE,
+				}
+		      },
+	 .cipher_info = {
+			 .alg = CIPHER_ALG_NONE,
+			 .mode = CIPHER_MODE_NONE,
+			 },
+	 .auth_info = {
+		       .alg = HASH_ALG_AES,
+		       .mode = HASH_MODE_CMAC,
+		       },
+	 },
+};
+
+static int generic_cra_init(struct crypto_tfm *tfm,
+			    struct iproc_alg_s *cipher_alg)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct iproc_ctx_s *ctx = crypto_tfm_ctx(tfm);
+	unsigned int blocksize = crypto_tfm_alg_blocksize(tfm);
+
+	flow_log("%s()\n", __func__);
+
+	ctx->alg = cipher_alg;
+	ctx->cipher = cipher_alg->cipher_info;
+	ctx->auth = cipher_alg->auth_info;
+	ctx->auth_first = cipher_alg->auth_first;
+	ctx->max_payload = spu->spu_ctx_max_payload(ctx->cipher.alg,
+						    ctx->cipher.mode,
+						    blocksize);
+	ctx->fallback_cipher = NULL;
+
+	ctx->enckeylen = 0;
+	ctx->authkeylen = 0;
+
+	atomic_inc(&iproc_priv.stream_count);
+	atomic_inc(&iproc_priv.session_count);
+
+	return 0;
+}
+
+static int ablkcipher_cra_init(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct iproc_alg_s *cipher_alg;
+
+	flow_log("%s()\n", __func__);
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct iproc_reqctx_s);
+
+	cipher_alg = container_of(alg, struct iproc_alg_s, alg.crypto);
+	return generic_cra_init(tfm, cipher_alg);
+}
+
+static int ahash_cra_init(struct crypto_tfm *tfm)
+{
+	int err;
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct iproc_alg_s *cipher_alg;
+
+	cipher_alg = container_of(__crypto_ahash_alg(alg), struct iproc_alg_s,
+				  alg.hash);
+
+	err = generic_cra_init(tfm, cipher_alg);
+	flow_log("%s()\n", __func__);
+
+	/*
+	 * export state size has to be < 512 bytes. So don't include msg bufs
+	 * in state size.
+	 */
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct iproc_reqctx_s));
+
+	return err;
+}
+
+static int aead_cra_init(struct crypto_aead *aead)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct iproc_ctx_s *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct aead_alg *aalg = container_of(alg, struct aead_alg, base);
+	struct iproc_alg_s *cipher_alg = container_of(aalg, struct iproc_alg_s,
+						      alg.aead);
+
+	int err = generic_cra_init(tfm, cipher_alg);
+
+	flow_log("%s()\n", __func__);
+
+	crypto_aead_set_reqsize(aead, sizeof(struct iproc_reqctx_s));
+	ctx->is_esp = false;
+	ctx->salt_len = 0;
+	ctx->salt_offset = 0;
+
+	/* random first IV */
+	get_random_bytes(ctx->iv, MAX_IV_SIZE);
+	flow_dump("  iv: ", ctx->iv, MAX_IV_SIZE);
+
+	if (!err) {
+		if (alg->cra_flags & CRYPTO_ALG_NEED_FALLBACK) {
+			flow_log("%s() creating fallback cipher\n", __func__);
+
+			ctx->fallback_cipher =
+			    crypto_alloc_aead(alg->cra_name, 0,
+					      CRYPTO_ALG_ASYNC |
+					      CRYPTO_ALG_NEED_FALLBACK);
+			if (IS_ERR(ctx->fallback_cipher)) {
+				pr_err("%s() Error: failed to allocate fallback for %s\n",
+				       __func__, alg->cra_name);
+				return PTR_ERR(ctx->fallback_cipher);
+			}
+		}
+	}
+
+	return err;
+}
+
+static void generic_cra_exit(struct crypto_tfm *tfm)
+{
+	atomic_dec(&iproc_priv.session_count);
+}
+
+static void aead_cra_exit(struct crypto_aead *aead)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct iproc_ctx_s *ctx = crypto_tfm_ctx(tfm);
+
+	generic_cra_exit(tfm);
+
+	if (ctx->fallback_cipher) {
+		crypto_free_aead(ctx->fallback_cipher);
+		ctx->fallback_cipher = NULL;
+	}
+}
+
+/**
+ * spu_functions_register() - Specify hardware-specific SPU functions based on
+ * SPU type read from device tree.
+ * @dev:	device structure
+ * @spu_type:	SPU hardware generation
+ * @spu_subtype: SPU hardware version
+ */
+static void spu_functions_register(struct device *dev,
+				   enum spu_spu_type spu_type,
+				   enum spu_spu_subtype spu_subtype)
+{
+	struct spu_hw *spu = &iproc_priv.spu;
+
+	if (spu_type == SPU_TYPE_SPUM) {
+		dev_dbg(dev, "Registering SPUM functions");
+		spu->spu_dump_msg_hdr = spum_dump_msg_hdr;
+		spu->spu_payload_length = spum_payload_length;
+		spu->spu_response_hdr_len = spum_response_hdr_len;
+		spu->spu_hash_pad_len = spum_hash_pad_len;
+		spu->spu_gcm_ccm_pad_len = spum_gcm_ccm_pad_len;
+		spu->spu_assoc_resp_len = spum_assoc_resp_len;
+		spu->spu_aead_ivlen = spum_aead_ivlen;
+		spu->spu_hash_type = spum_hash_type;
+		spu->spu_digest_size = spum_digest_size;
+		spu->spu_create_request = spum_create_request;
+		spu->spu_cipher_req_init = spum_cipher_req_init;
+		spu->spu_cipher_req_finish = spum_cipher_req_finish;
+		spu->spu_request_pad = spum_request_pad;
+		spu->spu_tx_status_len = spum_tx_status_len;
+		spu->spu_rx_status_len = spum_rx_status_len;
+		spu->spu_status_process = spum_status_process;
+		spu->spu_xts_tweak_in_payload = spum_xts_tweak_in_payload;
+		spu->spu_ccm_update_iv = spum_ccm_update_iv;
+		spu->spu_wordalign_padlen = spum_wordalign_padlen;
+		if (spu_subtype == SPU_SUBTYPE_SPUM_NS2)
+			spu->spu_ctx_max_payload = spum_ns2_ctx_max_payload;
+		else
+			spu->spu_ctx_max_payload = spum_nsp_ctx_max_payload;
+	} else {
+		dev_dbg(dev, "Registering SPU2 functions");
+		spu->spu_dump_msg_hdr = spu2_dump_msg_hdr;
+		spu->spu_ctx_max_payload = spu2_ctx_max_payload;
+		spu->spu_payload_length = spu2_payload_length;
+		spu->spu_response_hdr_len = spu2_response_hdr_len;
+		spu->spu_hash_pad_len = spu2_hash_pad_len;
+		spu->spu_gcm_ccm_pad_len = spu2_gcm_ccm_pad_len;
+		spu->spu_assoc_resp_len = spu2_assoc_resp_len;
+		spu->spu_aead_ivlen = spu2_aead_ivlen;
+		spu->spu_hash_type = spu2_hash_type;
+		spu->spu_digest_size = spu2_digest_size;
+		spu->spu_create_request = spu2_create_request;
+		spu->spu_cipher_req_init = spu2_cipher_req_init;
+		spu->spu_cipher_req_finish = spu2_cipher_req_finish;
+		spu->spu_request_pad = spu2_request_pad;
+		spu->spu_tx_status_len = spu2_tx_status_len;
+		spu->spu_rx_status_len = spu2_rx_status_len;
+		spu->spu_status_process = spu2_status_process;
+		spu->spu_xts_tweak_in_payload = spu2_xts_tweak_in_payload;
+		spu->spu_ccm_update_iv = spu2_ccm_update_iv;
+		spu->spu_wordalign_padlen = spu2_wordalign_padlen;
+	}
+}
+
+/**
+ * spu_mb_init() - Initialize mailbox client. Request ownership of each mailbox
+ * channel in the device tree.
+ * @dev:  SPU driver device structure
+ *
+ * Return: 0 if successful
+ *	   < 0 otherwise
+ */
+static int spu_mb_init(struct device *dev)
+{
+	int i;
+	struct mbox_client *mcl = &iproc_priv.mcl;
+	int err;
+
+	iproc_priv.mbox = kcalloc(iproc_priv.spu.num_chan,
+				  sizeof(struct mbox_chan *), GFP_KERNEL);
+	if (!iproc_priv.mbox)
+		return -ENOMEM;
+
+	mcl->dev = dev;
+	mcl->tx_block = false;
+	mcl->tx_tout = 0;
+	mcl->knows_txdone = false;
+	mcl->rx_callback = spu_rx_callback;
+	mcl->tx_done = NULL;
+
+	for (i = 0; i < iproc_priv.spu.num_chan; i++) {
+		iproc_priv.mbox[i] = mbox_request_channel(mcl, i);
+		if (IS_ERR(iproc_priv.mbox[i])) {
+			err = (int)PTR_ERR(iproc_priv.mbox[i]);
+			dev_err(dev,
+				"Mbox channel %d request failed with err %d",
+				i, err);
+			iproc_priv.mbox[i] = NULL;
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static void spu_mb_release(struct platform_device *pdev)
+{
+	int i;
+
+	if (!iproc_priv.mbox)
+		return;
+
+	for (i = 0; i < iproc_priv.spu.num_chan; i++)
+		mbox_free_channel(iproc_priv.mbox[i]);
+
+	kfree(iproc_priv.mbox);
+	iproc_priv.mbox = NULL;
+}
+
+static void spu_counters_init(void)
+{
+	int i;
+	int j;
+
+	atomic_set(&iproc_priv.session_count, 0);
+	atomic_set(&iproc_priv.stream_count, 0);
+	atomic_set(&iproc_priv.next_chan, (int)iproc_priv.spu.num_chan);
+	atomic64_set(&iproc_priv.bytes_in, 0);
+	atomic64_set(&iproc_priv.bytes_out, 0);
+	for (i = 0; i < SPU_OP_NUM; i++) {
+		atomic_set(&iproc_priv.op_counts[i], 0);
+		atomic_set(&iproc_priv.setkey_cnt[i], 0);
+	}
+	for (i = 0; i < CIPHER_ALG_LAST; i++)
+		for (j = 0; j < CIPHER_MODE_LAST; j++)
+			atomic_set(&iproc_priv.cipher_cnt[i][j], 0);
+
+	for (i = 0; i < HASH_ALG_LAST; i++) {
+		atomic_set(&iproc_priv.hash_cnt[i], 0);
+		atomic_set(&iproc_priv.hmac_cnt[i], 0);
+	}
+	for (i = 0; i < AEAD_TYPE_LAST; i++)
+		atomic_set(&iproc_priv.aead_cnt[i], 0);
+
+	atomic_set(&iproc_priv.mb_no_spc, 0);
+	atomic_set(&iproc_priv.mb_send_fail, 0);
+	atomic_set(&iproc_priv.bad_icv, 0);
+}
+
+static int spu_register_ablkcipher(struct iproc_alg_s *driver_alg)
+{
+	struct device *dev = &iproc_priv.pdev->dev;
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct crypto_alg *crypto = &driver_alg->alg.crypto;
+	int err;
+
+	/* SPU2 does not support RC4 */
+	if ((driver_alg->cipher_info.alg == CIPHER_ALG_RC4) &&
+	    (spu->spu_type == SPU_TYPE_SPU2))
+		return 0;
+
+	crypto->cra_module = THIS_MODULE;
+	crypto->cra_priority = cipher_pri;
+	crypto->cra_alignmask = 0;
+	crypto->cra_ctxsize = sizeof(struct iproc_ctx_s);
+	INIT_LIST_HEAD(&crypto->cra_list);
+
+	crypto->cra_init = ablkcipher_cra_init;
+	crypto->cra_exit = generic_cra_exit;
+	crypto->cra_type = &crypto_ablkcipher_type;
+	crypto->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_KERN_DRIVER_ONLY;
+
+	crypto->cra_ablkcipher.setkey = ablkcipher_setkey;
+	crypto->cra_ablkcipher.encrypt = ablkcipher_encrypt;
+	crypto->cra_ablkcipher.decrypt = ablkcipher_decrypt;
+
+	err = crypto_register_alg(crypto);
+	/* Mark alg as having been registered, if successful */
+	if (err == 0)
+		driver_alg->registered = true;
+	dev_dbg(dev, "  registered ablkcipher %s\n", crypto->cra_driver_name);
+	return err;
+}
+
+static int spu_register_ahash(struct iproc_alg_s *driver_alg)
+{
+	struct device *dev = &iproc_priv.pdev->dev;
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct ahash_alg *hash = &driver_alg->alg.hash;
+	int err;
+
+	/* AES-XCBC is the only AES hash type currently supported on SPU-M */
+	if ((driver_alg->auth_info.alg == HASH_ALG_AES) &&
+	    (driver_alg->auth_info.mode != HASH_MODE_XCBC) &&
+	    (spu->spu_type == SPU_TYPE_SPUM))
+		return 0;
+
+	/* SHA3 algorithm variants are not registered for SPU-M or SPU2. */
+	if ((driver_alg->auth_info.alg >= HASH_ALG_SHA3_224) &&
+	    (spu->spu_subtype != SPU_SUBTYPE_SPU2_V2))
+		return 0;
+
+	hash->halg.base.cra_module = THIS_MODULE;
+	hash->halg.base.cra_priority = hash_pri;
+	hash->halg.base.cra_alignmask = 0;
+	hash->halg.base.cra_ctxsize = sizeof(struct iproc_ctx_s);
+	hash->halg.base.cra_init = ahash_cra_init;
+	hash->halg.base.cra_exit = generic_cra_exit;
+	hash->halg.base.cra_type = &crypto_ahash_type;
+	hash->halg.base.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC;
+	/*
+	 * export state size has to be < 512 bytes. So don't include msg bufs
+	 * in state size.
+	 */
+	hash->halg.statesize = offsetof(struct iproc_reqctx_s, msg_buf);
+
+	if (driver_alg->auth_info.mode != HASH_MODE_HMAC) {
+		hash->setkey = ahash_setkey;
+		hash->init = ahash_init;
+		hash->update = ahash_update;
+		hash->final = ahash_final;
+		hash->finup = ahash_finup;
+		hash->digest = ahash_digest;
+	} else {
+		hash->setkey = ahash_hmac_setkey;
+		hash->init = ahash_hmac_init;
+		hash->update = ahash_hmac_update;
+		hash->final = ahash_hmac_final;
+		hash->finup = ahash_hmac_finup;
+		hash->digest = ahash_hmac_digest;
+	}
+	hash->export = ahash_export;
+	hash->import = ahash_import;
+
+	err = crypto_register_ahash(hash);
+	/* Mark alg as having been registered, if successful */
+	if (err == 0)
+		driver_alg->registered = true;
+	dev_dbg(dev, "  registered ahash %s\n",
+		hash->halg.base.cra_driver_name);
+	return err;
+}
+
+static int spu_register_aead(struct iproc_alg_s *driver_alg)
+{
+	struct device *dev = &iproc_priv.pdev->dev;
+	struct aead_alg *aead = &driver_alg->alg.aead;
+	int err;
+
+	aead->base.cra_module = THIS_MODULE;
+	aead->base.cra_priority = aead_pri;
+	aead->base.cra_alignmask = 0;
+	aead->base.cra_ctxsize = sizeof(struct iproc_ctx_s);
+	INIT_LIST_HEAD(&aead->base.cra_list);
+
+	aead->base.cra_flags |= CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
+	/* setkey set in alg initialization */
+	aead->setauthsize = aead_setauthsize;
+	aead->encrypt = aead_encrypt;
+	aead->decrypt = aead_decrypt;
+	aead->init = aead_cra_init;
+	aead->exit = aead_cra_exit;
+
+	err = crypto_register_aead(aead);
+	/* Mark alg as having been registered, if successful */
+	if (err == 0)
+		driver_alg->registered = true;
+	dev_dbg(dev, "  registered aead %s\n", aead->base.cra_driver_name);
+	return err;
+}
+
+/* register crypto algorithms the device supports */
+static int spu_algs_register(struct device *dev)
+{
+	int i, j;
+	int err;
+
+	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
+		switch (driver_algs[i].type) {
+		case CRYPTO_ALG_TYPE_ABLKCIPHER:
+			err = spu_register_ablkcipher(&driver_algs[i]);
+			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			err = spu_register_ahash(&driver_algs[i]);
+			break;
+		case CRYPTO_ALG_TYPE_AEAD:
+			err = spu_register_aead(&driver_algs[i]);
+			break;
+		default:
+			dev_err(dev,
+				"iproc-crypto: unknown alg type: %d",
+				driver_algs[i].type);
+			err = -EINVAL;
+		}
+
+		if (err) {
+			dev_err(dev, "alg registration failed with error %d\n",
+				err);
+			goto err_algs;
+		}
+	}
+
+	return 0;
+
+err_algs:
+	for (j = 0; j < i; j++) {
+		/* Skip any algorithm not registered */
+		if (!driver_algs[j].registered)
+			continue;
+		switch (driver_algs[j].type) {
+		case CRYPTO_ALG_TYPE_ABLKCIPHER:
+			crypto_unregister_alg(&driver_algs[j].alg.crypto);
+			driver_algs[j].registered = false;
+			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			crypto_unregister_ahash(&driver_algs[j].alg.hash);
+			driver_algs[j].registered = false;
+			break;
+		case CRYPTO_ALG_TYPE_AEAD:
+			crypto_unregister_aead(&driver_algs[j].alg.aead);
+			driver_algs[j].registered = false;
+			break;
+		}
+	}
+	return err;
+}
+
+/* ==================== Kernel Platform API ==================== */
+
+static struct spu_type_subtype spum_ns2_types = {
+	SPU_TYPE_SPUM, SPU_SUBTYPE_SPUM_NS2
+};
+
+static struct spu_type_subtype spum_nsp_types = {
+	SPU_TYPE_SPUM, SPU_SUBTYPE_SPUM_NSP
+};
+
+static struct spu_type_subtype spu2_types = {
+	SPU_TYPE_SPU2, SPU_SUBTYPE_SPU2_V1
+};
+
+static struct spu_type_subtype spu2_v2_types = {
+	SPU_TYPE_SPU2, SPU_SUBTYPE_SPU2_V2
+};
+
+static const struct of_device_id bcm_spu_dt_ids[] = {
+	{
+		.compatible = "brcm,spum-crypto",
+		.data = &spum_ns2_types,
+	},
+	{
+		.compatible = "brcm,spum-nsp-crypto",
+		.data = &spum_nsp_types,
+	},
+	{
+		.compatible = "brcm,spu2-crypto",
+		.data = &spu2_types,
+	},
+	{
+		.compatible = "brcm,spu2-v2-crypto",
+		.data = &spu2_v2_types,
+	},
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, bcm_spu_dt_ids);
+
+static int spu_dt_read(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct spu_hw *spu = &iproc_priv.spu;
+	struct device_node *dn = pdev->dev.of_node;
+	struct resource *spu_ctrl_regs;
+	const struct of_device_id *match;
+	struct spu_type_subtype *matched_spu_type;
+	void __iomem *spu_reg_vbase[MAX_SPUS];
+	int i;
+	int err;
+
+	if (!of_device_is_available(dn)) {
+		dev_crit(dev, "SPU device not available");
+		return -ENODEV;
+	}
+
+	/* Count number of mailbox channels */
+	spu->num_chan = of_count_phandle_with_args(dn, "mboxes", "#mbox-cells");
+	dev_dbg(dev, "Device has %d SPU channels", spu->num_chan);
+
+	match = of_match_device(of_match_ptr(bcm_spu_dt_ids), dev);
+	matched_spu_type = (struct spu_type_subtype *)match->data;
+	spu->spu_type = matched_spu_type->type;
+	spu->spu_subtype = matched_spu_type->subtype;
+
+	/* Read registers and count number of SPUs */
+	i = 0;
+	while ((i < MAX_SPUS) && ((spu_ctrl_regs =
+		platform_get_resource(pdev, IORESOURCE_MEM, i)) != NULL)) {
+		dev_dbg(dev,
+			"SPU %d control register region res.start = %#x, res.end = %#x",
+			i,
+			(unsigned int)spu_ctrl_regs->start,
+			(unsigned int)spu_ctrl_regs->end);
+
+		spu_reg_vbase[i] = devm_ioremap_resource(dev, spu_ctrl_regs);
+		if (IS_ERR(spu_reg_vbase[i])) {
+			err = PTR_ERR(spu_reg_vbase[i]);
+			dev_err(&pdev->dev, "Failed to map registers: %d\n",
+				err);
+			spu_reg_vbase[i] = NULL;
+			return err;
+		}
+		i++;
+	}
+	spu->num_spu = i;
+	dev_dbg(dev, "Device has %d SPUs", spu->num_spu);
+
+	spu->reg_vbase = devm_kcalloc(dev, spu->num_spu,
+				      sizeof(*spu->reg_vbase), GFP_KERNEL);
+	if (!spu->reg_vbase)
+		return -ENOMEM;
+	memcpy(spu->reg_vbase, spu_reg_vbase,
+	       spu->num_spu * sizeof(*spu->reg_vbase));
+
+	return 0;
+}
+
+int bcm_spu_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct spu_hw *spu = &iproc_priv.spu;
+	int err = 0;
+
+	iproc_priv.pdev = pdev;
+	platform_set_drvdata(iproc_priv.pdev, &iproc_priv);
+
+	err = spu_dt_read(pdev);
+	if (err < 0)
+		goto failure;
+
+	if (spu->spu_type == SPU_TYPE_SPUM)
+		iproc_priv.bcm_hdr_len = 8;
+	else if (spu->spu_type == SPU_TYPE_SPU2)
+		iproc_priv.bcm_hdr_len = 0;
+
+	spu_functions_register(&pdev->dev, spu->spu_type, spu->spu_subtype);
+
+	err = spu_mb_init(&pdev->dev);
+	if (err < 0)
+		goto failure;
+
+	spu_counters_init();
+
+	spu_setup_debugfs();
+
+	err = spu_algs_register(dev);
+	if (err < 0)
+		goto fail_reg;
+
+	return 0;
+
+fail_reg:
+	spu_free_debugfs();
+failure:
+	spu_mb_release(pdev);
+	dev_err(dev, "%s failed with error %d.\n", __func__, err);
+
+	return err;
+}
+
+int bcm_spu_remove(struct platform_device *pdev)
+{
+	int i;
+	struct device *dev = &pdev->dev;
+
+	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
+		/*
+		 * Not all algorithms were registered, depending on whether
+		 * hardware is SPU or SPU2.  So here we make sure to skip
+		 * those algorithms that were not previously registered.
+		 */
+		if (!driver_algs[i].registered)
+			continue;
+
+		switch (driver_algs[i].type) {
+		case CRYPTO_ALG_TYPE_ABLKCIPHER:
+			crypto_unregister_alg(&driver_algs[i].alg.crypto);
+			dev_dbg(dev, "  unregistered cipher %s\n",
+				driver_algs[i].alg.crypto.cra_driver_name);
+			driver_algs[i].registered = false;
+			break;
+		case CRYPTO_ALG_TYPE_AHASH:
+			crypto_unregister_ahash(&driver_algs[i].alg.hash);
+			dev_dbg(dev, "  unregistered hash %s\n",
+				driver_algs[i].alg.hash.halg.
+				base.cra_driver_name);
+			driver_algs[i].registered = false;
+			break;
+		case CRYPTO_ALG_TYPE_AEAD:
+			crypto_unregister_aead(&driver_algs[i].alg.aead);
+			dev_dbg(dev, "  unregistered aead %s\n",
+				driver_algs[i].alg.aead.base.cra_driver_name);
+			driver_algs[i].registered = false;
+			break;
+		}
+	}
+	spu_free_debugfs();
+	spu_mb_release(pdev);
+	return 0;
+}
+
+/* ===== Kernel Module API ===== */
+
+static struct platform_driver bcm_spu_pdriver = {
+	.driver = {
+		   .name = "brcm-spu-crypto",
+		   .of_match_table = of_match_ptr(bcm_spu_dt_ids),
+		   },
+	.probe = bcm_spu_probe,
+	.remove = bcm_spu_remove,
+};
+module_platform_driver(bcm_spu_pdriver);
+
+MODULE_AUTHOR("Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>");
+MODULE_DESCRIPTION("Broadcom symmetric crypto offload driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/bcm/cipher.h b/drivers/crypto/bcm/cipher.h
new file mode 100644
index 0000000..2d856bd
--- /dev/null
+++ b/drivers/crypto/bcm/cipher.h
@@ -0,0 +1,472 @@
+/*
+ * Copyright 2016 Broadcom
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation (the "GPL").
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 (GPLv2) for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 (GPLv2) along with this source code.
+ */
+
+#ifndef _CIPHER_H
+#define _CIPHER_H
+
+#include <linux/atomic.h>
+#include <linux/mailbox/brcm-message.h>
+#include <linux/mailbox_client.h>
+#include <crypto/aes.h>
+#include <crypto/internal/hash.h>
+#include <crypto/aead.h>
+#include <crypto/sha.h>
+#include <crypto/sha3.h>
+
+#include "spu.h"
+#include "spum.h"
+#include "spu2.h"
+
+#define ARC4_MIN_KEY_SIZE   1
+#define ARC4_MAX_KEY_SIZE   256
+#define ARC4_BLOCK_SIZE     1
+#define ARC4_STATE_SIZE     4
+
+#define CCM_AES_IV_SIZE    16
+#define GCM_AES_IV_SIZE    12
+#define GCM_ESP_IV_SIZE     8
+#define CCM_ESP_IV_SIZE     8
+#define RFC4543_ICV_SIZE   16
+
+#define MAX_KEY_SIZE	ARC4_MAX_KEY_SIZE
+#define MAX_IV_SIZE	AES_BLOCK_SIZE
+#define MAX_DIGEST_SIZE	SHA3_512_DIGEST_SIZE
+#define MAX_ASSOC_SIZE	512
+
+/* size of salt value for AES-GCM-ESP and AES-CCM-ESP */
+#define GCM_ESP_SALT_SIZE   4
+#define CCM_ESP_SALT_SIZE   3
+#define MAX_SALT_SIZE       GCM_ESP_SALT_SIZE
+#define GCM_ESP_SALT_OFFSET 0
+#define CCM_ESP_SALT_OFFSET 1
+
+#define GCM_ESP_DIGESTSIZE 16
+
+#define MAX_HASH_BLOCK_SIZE SHA512_BLOCK_SIZE
+
+/*
+ * Maximum number of bytes from a non-final hash request that can be deferred
+ * until more data is available. With new crypto API framework, this
+ * can be no more than one block of data.
+ */
+#define HASH_CARRY_MAX  MAX_HASH_BLOCK_SIZE
+
+/* Force at least 4-byte alignment of all SPU message fields */
+#define SPU_MSG_ALIGN  4
+
+/* Number of times to resend mailbox message if mb queue is full */
+#define SPU_MB_RETRY_MAX  1000
+
+/* op_counts[] indexes */
+enum op_type {
+	SPU_OP_CIPHER,
+	SPU_OP_HASH,
+	SPU_OP_HMAC,
+	SPU_OP_AEAD,
+	SPU_OP_NUM
+};
+
+enum spu_spu_type {
+	SPU_TYPE_SPUM,
+	SPU_TYPE_SPU2,
+};
+
+/*
+ * SPUM_NS2 and SPUM_NSP are the SPU-M block on Northstar 2 and Northstar Plus,
+ * respectively.
+ */
+enum spu_spu_subtype {
+	SPU_SUBTYPE_SPUM_NS2,
+	SPU_SUBTYPE_SPUM_NSP,
+	SPU_SUBTYPE_SPU2_V1,
+	SPU_SUBTYPE_SPU2_V2
+};
+
+struct spu_type_subtype {
+	enum spu_spu_type type;
+	enum spu_spu_subtype subtype;
+};
+
+struct cipher_op {
+	enum spu_cipher_alg alg;
+	enum spu_cipher_mode mode;
+};
+
+struct auth_op {
+	enum hash_alg alg;
+	enum hash_mode mode;
+};
+
+struct iproc_alg_s {
+	u32 type;
+	union {
+		struct crypto_alg crypto;
+		struct ahash_alg hash;
+		struct aead_alg aead;
+	} alg;
+	struct cipher_op cipher_info;
+	struct auth_op auth_info;
+	bool auth_first;
+	bool registered;
+};
+
+/*
+ * Buffers for a SPU request/reply message pair. All part of one structure to
+ * allow a single alloc per request.
+ */
+struct spu_msg_buf {
+	/* Request message fragments */
+
+	/*
+	 * SPU request message header. For SPU-M, holds MH, EMH, SCTX, BDESC,
+	 * and BD header. For SPU2, holds FMD, OMD.
+	 */
+	u8 bcm_spu_req_hdr[ALIGN(SPU2_HEADER_ALLOC_LEN, SPU_MSG_ALIGN)];
+
+	/* IV or counter. Size to include salt. Also used for XTS tweek. */
+	u8 iv_ctr[ALIGN(2 * AES_BLOCK_SIZE, SPU_MSG_ALIGN)];
+
+	/* Hash digest. request and response. */
+	u8 digest[ALIGN(MAX_DIGEST_SIZE, SPU_MSG_ALIGN)];
+
+	/* SPU request message padding */
+	u8 spu_req_pad[ALIGN(SPU_PAD_LEN_MAX, SPU_MSG_ALIGN)];
+
+	/* SPU-M request message STATUS field */
+	u8 tx_stat[ALIGN(SPU_TX_STATUS_LEN, SPU_MSG_ALIGN)];
+
+	/* Response message fragments */
+
+	/* SPU response message header */
+	u8 spu_resp_hdr[ALIGN(SPU2_HEADER_ALLOC_LEN, SPU_MSG_ALIGN)];
+
+	/* SPU response message STATUS field padding */
+	u8 rx_stat_pad[ALIGN(SPU_STAT_PAD_MAX, SPU_MSG_ALIGN)];
+
+	/* SPU response message STATUS field */
+	u8 rx_stat[ALIGN(SPU_RX_STATUS_LEN, SPU_MSG_ALIGN)];
+
+	union {
+		/* Buffers only used for ablkcipher */
+		struct {
+			/*
+			 * Field used for either SUPDT when RC4 is used
+			 * -OR- tweak value when XTS/AES is used
+			 */
+			u8 supdt_tweak[ALIGN(SPU_SUPDT_LEN, SPU_MSG_ALIGN)];
+		} c;
+
+		/* Buffers only used for aead */
+		struct {
+			/* SPU response pad for GCM data */
+			u8 gcmpad[ALIGN(AES_BLOCK_SIZE, SPU_MSG_ALIGN)];
+
+			/* SPU request msg padding for GCM AAD */
+			u8 req_aad_pad[ALIGN(SPU_PAD_LEN_MAX, SPU_MSG_ALIGN)];
+
+			/* SPU response data to be discarded */
+			u8 resp_aad[ALIGN(MAX_ASSOC_SIZE + MAX_IV_SIZE,
+					  SPU_MSG_ALIGN)];
+		} a;
+	};
+};
+
+struct iproc_ctx_s {
+	u8 enckey[MAX_KEY_SIZE + ARC4_STATE_SIZE];
+	unsigned int enckeylen;
+
+	u8 authkey[MAX_KEY_SIZE + ARC4_STATE_SIZE];
+	unsigned int authkeylen;
+
+	u8 salt[MAX_SALT_SIZE];
+	unsigned int salt_len;
+	unsigned int salt_offset;
+	u8 iv[MAX_IV_SIZE];
+
+	unsigned int digestsize;
+
+	struct iproc_alg_s *alg;
+	bool is_esp;
+
+	struct cipher_op cipher;
+	enum spu_cipher_type cipher_type;
+
+	struct auth_op auth;
+	bool auth_first;
+
+	/*
+	 * The maximum length in bytes of the payload in a SPU message for this
+	 * context. For SPU-M, the payload is the combination of AAD and data.
+	 * For SPU2, the payload is just data. A value of SPU_MAX_PAYLOAD_INF
+	 * indicates that there is no limit to the length of the SPU message
+	 * payload.
+	 */
+	unsigned int max_payload;
+
+	struct crypto_aead *fallback_cipher;
+
+	/* auth_type is determined during processing of request */
+
+	u8 ipad[MAX_HASH_BLOCK_SIZE];
+	u8 opad[MAX_HASH_BLOCK_SIZE];
+
+	/*
+	 * Buffer to hold SPU message header template. Template is created at
+	 * setkey time for ablkcipher requests, since most of the fields in the
+	 * header are known at that time. At request time, just fill in a few
+	 * missing pieces related to length of data in the request and IVs, etc.
+	 */
+	u8 bcm_spu_req_hdr[ALIGN(SPU2_HEADER_ALLOC_LEN, SPU_MSG_ALIGN)];
+
+	/* Length of SPU request header */
+	u16 spu_req_hdr_len;
+
+	/* Expected length of SPU response header */
+	u16 spu_resp_hdr_len;
+
+	/*
+	 * shash descriptor - needed to perform incremental hashing in
+	 * in software, when hw doesn't support it.
+	 */
+	struct shash_desc *shash;
+
+	bool is_rfc4543;	/* RFC 4543 style of GMAC */
+};
+
+struct iproc_reqctx_s {
+	/* general context */
+	struct crypto_async_request *parent;
+
+	/* only valid after enqueue() */
+	struct iproc_ctx_s *ctx;
+
+	u8 chan_idx;   /* Mailbox channel to be used to submit this request */
+
+	/* total todo, rx'd, and sent for this request */
+	unsigned int total_todo;
+	unsigned int total_received;	/* only valid for ablkcipher */
+	unsigned int total_sent;
+
+	/*
+	 * num bytes sent to hw from the src sg in this request. This can differ
+	 * from total_sent for incremental hashing. total_sent includes previous
+	 * init() and update() data. src_sent does not.
+	 */
+	unsigned int src_sent;
+	unsigned int hmac_offset;
+
+	/*
+	 * For AEAD requests, start of associated data. This will typically
+	 * point to the beginning of the src scatterlist from the request,
+	 * since assoc data is at the beginning of the src scatterlist rather
+	 * than in its own sg.
+	 */
+	struct scatterlist *assoc;
+
+	/*
+	 * scatterlist entry and offset to start of data for next chunk. Crypto
+	 * API src scatterlist for AEAD starts with AAD, if present. For first
+	 * chunk, src_sg is sg entry at beginning of input data (after AAD).
+	 * src_skip begins at the offset in that sg entry where data begins.
+	 */
+	struct scatterlist *src_sg;
+	int src_nents;		/* Number of src entries with data */
+	u32 src_skip;		/* bytes of current sg entry already used */
+
+	/*
+	 * Same for destination. For AEAD, if there is AAD, output data must
+	 * be written at offset following AAD.
+	 */
+	struct scatterlist *dst_sg;
+	int dst_nents;		/* Number of dst entries with data */
+	u32 dst_skip;		/* bytes of current sg entry already written */
+
+	/* Mailbox message used to send this request to PDC driver */
+	struct brcm_message mb_mssg;
+
+	bool bd_suppress;	/* suppress BD field in SPU response? */
+
+	/* cipher context */
+	bool is_encrypt;
+
+	/*
+	 * CBC mode: IV.  CTR mode: counter.  Else empty. Used as a DMA
+	 * buffer for AEAD requests. So allocate as DMAable memory. If IV
+	 * concatenated with salt, includes the salt.
+	 */
+	u8 *iv_ctr;
+	/* Length of IV or counter, in bytes */
+	unsigned int iv_ctr_len;
+
+	/*
+	 * Hash requests can be of any size, whether initial, update, or final.
+	 * A non-final request must be submitted to the SPU as an integral
+	 * number of blocks. This may leave data at the end of the request
+	 * that is not a full block. Since the request is non-final, it cannot
+	 * be padded. So, we write the remainder to this hash_carry buffer and
+	 * hold it until the next request arrives. The carry data is then
+	 * submitted at the beginning of the data in the next SPU msg.
+	 * hash_carry_len is the number of bytes currently in hash_carry. These
+	 * fields are only used for ahash requests.
+	 */
+	u8 hash_carry[HASH_CARRY_MAX];
+	unsigned int hash_carry_len;
+	unsigned int is_final;	/* is this the final for the hash op? */
+
+	/*
+	 * Digest from incremental hash is saved here to include in next hash
+	 * operation. Cannot be stored in req->result for truncated hashes,
+	 * since result may be sized for final digest. Cannot be saved in
+	 * msg_buf because that gets deleted between incremental hash ops
+	 * and is not saved as part of export().
+	 */
+	u8 incr_hash[MAX_DIGEST_SIZE];
+
+	/* hmac context */
+	bool is_sw_hmac;
+
+	/* aead context */
+	struct crypto_tfm *old_tfm;
+	crypto_completion_t old_complete;
+	void *old_data;
+
+	gfp_t gfp;
+
+	/* Buffers used to build SPU request and response messages */
+	/* MUST BE LAST */
+	struct spu_msg_buf msg_buf;
+};
+
+/*
+ * Structure encapsulates a set of function pointers specific to the type of
+ * SPU hardware running. These functions handling creation and parsing of
+ * SPU request messages and SPU response messages. Includes hardware-specific
+ * values read from device tree.
+ */
+struct spu_hw {
+	void (*spu_dump_msg_hdr)(u8 *buf, unsigned int buf_len);
+	u32 (*spu_ctx_max_payload)(enum spu_cipher_alg cipher_alg,
+				   enum spu_cipher_mode cipher_mode,
+				   unsigned int blocksize);
+	u32 (*spu_payload_length)(u8 *spu_hdr);
+	u16 (*spu_response_hdr_len)(u16 auth_key_len, u16 enc_key_len,
+				    bool is_hash);
+	u16 (*spu_hash_pad_len)(enum hash_alg hash_alg,
+				enum hash_mode hash_mode, u32 chunksize,
+				u16 hash_block_size);
+	u32 (*spu_gcm_ccm_pad_len)(enum spu_cipher_mode cipher_mode,
+				   unsigned int data_size);
+	u32 (*spu_assoc_resp_len)(enum spu_cipher_mode cipher_mode,
+				  unsigned int assoc_len,
+				  unsigned int iv_len, bool is_encrypt);
+	u8 (*spu_aead_ivlen)(enum spu_cipher_mode cipher_mode,
+			     u16 iv_len);
+	enum hash_type (*spu_hash_type)(u32 src_sent);
+	u32 (*spu_digest_size)(u32 digest_size, enum hash_alg alg,
+			       enum hash_type);
+	u32 (*spu_create_request)(u8 *spu_hdr,
+				  struct spu_request_opts *req_opts,
+				  struct spu_cipher_parms *cipher_parms,
+				  struct spu_hash_parms *hash_parms,
+				  struct spu_aead_parms *aead_parms,
+				  unsigned int data_size);
+	u16 (*spu_cipher_req_init)(u8 *spu_hdr,
+				   struct spu_cipher_parms *cipher_parms);
+	void (*spu_cipher_req_finish)(u8 *spu_hdr,
+				      u16 spu_req_hdr_len,
+				      unsigned int is_inbound,
+				      struct spu_cipher_parms *cipher_parms,
+				      bool update_key,
+				      unsigned int data_size);
+	void (*spu_request_pad)(u8 *pad_start, u32 gcm_padding,
+				u32 hash_pad_len, enum hash_alg auth_alg,
+				enum hash_mode auth_mode,
+				unsigned int total_sent, u32 status_padding);
+	u8 (*spu_xts_tweak_in_payload)(void);
+	u8 (*spu_tx_status_len)(void);
+	u8 (*spu_rx_status_len)(void);
+	int (*spu_status_process)(u8 *statp);
+	void (*spu_ccm_update_iv)(unsigned int digestsize,
+				  struct spu_cipher_parms *cipher_parms,
+				  unsigned int assoclen, unsigned int chunksize,
+				  bool is_encrypt, bool is_esp);
+	u32 (*spu_wordalign_padlen)(u32 data_size);
+
+	/* The base virtual address of the SPU hw registers */
+	void __iomem **reg_vbase;
+
+	/* Version of the SPU hardware */
+	enum spu_spu_type spu_type;
+
+	/* Sub-version of the SPU hardware */
+	enum spu_spu_subtype spu_subtype;
+
+	/* The number of SPUs on this platform */
+	u32 num_spu;
+
+	/* The number of SPU channels on this platform */
+	u32 num_chan;
+};
+
+struct device_private {
+	struct platform_device *pdev;
+
+	struct spu_hw spu;
+
+	atomic_t session_count;	/* number of streams active */
+	atomic_t stream_count;	/* monotonic counter for streamID's */
+
+	/* Length of BCM header. Set to 0 when hw does not expect BCM HEADER. */
+	u8 bcm_hdr_len;
+
+	/* The index of the channel to use for the next crypto request */
+	atomic_t next_chan;
+
+	struct dentry *debugfs_dir;
+	struct dentry *debugfs_stats;
+
+	/* Number of request bytes processed and result bytes returned */
+	atomic64_t bytes_in;
+	atomic64_t bytes_out;
+
+	/* Number of operations of each type */
+	atomic_t op_counts[SPU_OP_NUM];
+
+	atomic_t cipher_cnt[CIPHER_ALG_LAST][CIPHER_MODE_LAST];
+	atomic_t hash_cnt[HASH_ALG_LAST];
+	atomic_t hmac_cnt[HASH_ALG_LAST];
+	atomic_t aead_cnt[AEAD_TYPE_LAST];
+
+	/* Number of calls to setkey() for each operation type */
+	atomic_t setkey_cnt[SPU_OP_NUM];
+
+	/* Number of times request was resubmitted because mb was full */
+	atomic_t mb_no_spc;
+
+	/* Number of mailbox send failures */
+	atomic_t mb_send_fail;
+
+	/* Number of ICV check failures for AEAD messages */
+	atomic_t bad_icv;
+
+	struct mbox_client mcl;
+	/* Array of mailbox channel pointers, one for each channel */
+	struct mbox_chan **mbox;
+};
+
+extern struct device_private iproc_priv;
+
+#endif
diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
new file mode 100644
index 0000000..0331267
--- /dev/null
+++ b/drivers/crypto/bcm/spu.c
@@ -0,0 +1,1252 @@
+/*
+ * Copyright 2016 Broadcom
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation (the "GPL").
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 (GPLv2) for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 (GPLv2) along with this source code.
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+
+#include "util.h"
+#include "spu.h"
+#include "spum.h"
+#include "cipher.h"
+
+/* This array is based on the hash algo type supported in spu.h */
+char *tag_to_hash_idx[] = { "none", "md5", "sha1", "sha224", "sha256" };
+
+char *hash_alg_name[] = { "None", "md5", "sha1", "sha224", "sha256", "aes",
+	"sha384", "sha512", "sha3_224", "sha3_256", "sha3_384", "sha3_512" };
+
+char *aead_alg_name[] = { "ccm(aes)", "gcm(aes)", "authenc" };
+
+/* Assumes SPU-M messages are in big endian */
+void spum_dump_msg_hdr(u8 *buf, unsigned int buf_len)
+{
+	u8 *ptr = buf;
+	struct SPUHEADER *spuh = (struct SPUHEADER *)buf;
+	unsigned int hash_key_len = 0;
+	unsigned int hash_state_len = 0;
+	unsigned int cipher_key_len = 0;
+	unsigned int iv_len;
+	u32 pflags;
+	u32 cflags;
+	u32 ecf;
+	u32 cipher_alg;
+	u32 cipher_mode;
+	u32 cipher_type;
+	u32 hash_alg;
+	u32 hash_mode;
+	u32 hash_type;
+	u32 sctx_size;   /* SCTX length in words */
+	u32 sctx_pl_len; /* SCTX payload length in bytes */
+
+	packet_log("\n");
+	packet_log("SPU Message header %p len: %u\n", buf, buf_len);
+
+	/* ========== Decode MH ========== */
+	packet_log("  MH 0x%08x\n", be32_to_cpu(*((u32 *)ptr)));
+	if (spuh->mh.flags & MH_SCTX_PRES)
+		packet_log("    SCTX  present\n");
+	if (spuh->mh.flags & MH_BDESC_PRES)
+		packet_log("    BDESC present\n");
+	if (spuh->mh.flags & MH_MFM_PRES)
+		packet_log("    MFM   present\n");
+	if (spuh->mh.flags & MH_BD_PRES)
+		packet_log("    BD    present\n");
+	if (spuh->mh.flags & MH_HASH_PRES)
+		packet_log("    HASH  present\n");
+	if (spuh->mh.flags & MH_SUPDT_PRES)
+		packet_log("    SUPDT present\n");
+	packet_log("    Opcode 0x%02x\n", spuh->mh.op_code);
+
+	ptr += sizeof(spuh->mh) + sizeof(spuh->emh);  /* skip emh. unused */
+
+	/* ========== Decode SCTX ========== */
+	if (spuh->mh.flags & MH_SCTX_PRES) {
+		pflags = be32_to_cpu(spuh->sa.proto_flags);
+		packet_log("  SCTX[0] 0x%08x\n", pflags);
+		sctx_size = pflags & SCTX_SIZE;
+		packet_log("    Size %u words\n", sctx_size);
+
+		cflags = be32_to_cpu(spuh->sa.cipher_flags);
+		packet_log("  SCTX[1] 0x%08x\n", cflags);
+		packet_log("    Inbound:%lu (1:decrypt/vrfy 0:encrypt/auth)\n",
+			   (cflags & CIPHER_INBOUND) >> CIPHER_INBOUND_SHIFT);
+		packet_log("    Order:%lu (1:AuthFirst 0:EncFirst)\n",
+			   (cflags & CIPHER_ORDER) >> CIPHER_ORDER_SHIFT);
+		packet_log("    ICV_IS_512:%lx\n",
+			   (cflags & ICV_IS_512) >> ICV_IS_512_SHIFT);
+		cipher_alg = (cflags & CIPHER_ALG) >> CIPHER_ALG_SHIFT;
+		cipher_mode = (cflags & CIPHER_MODE) >> CIPHER_MODE_SHIFT;
+		cipher_type = (cflags & CIPHER_TYPE) >> CIPHER_TYPE_SHIFT;
+		packet_log("    Crypto Alg:%u Mode:%u Type:%u\n",
+			   cipher_alg, cipher_mode, cipher_type);
+		hash_alg = (cflags & HASH_ALG) >> HASH_ALG_SHIFT;
+		hash_mode = (cflags & HASH_MODE) >> HASH_MODE_SHIFT;
+		hash_type = (cflags & HASH_TYPE) >> HASH_TYPE_SHIFT;
+		packet_log("    Hash   Alg:%x Mode:%x Type:%x\n",
+			   hash_alg, hash_mode, hash_type);
+		packet_log("    UPDT_Offset:%u\n", cflags & UPDT_OFST);
+
+		ecf = be32_to_cpu(spuh->sa.ecf);
+		packet_log("  SCTX[2] 0x%08x\n", ecf);
+		packet_log("    WriteICV:%lu CheckICV:%lu ICV_SIZE:%u ",
+			   (ecf & INSERT_ICV) >> INSERT_ICV_SHIFT,
+			   (ecf & CHECK_ICV) >> CHECK_ICV_SHIFT,
+			   (ecf & ICV_SIZE) >> ICV_SIZE_SHIFT);
+		packet_log("BD_SUPPRESS:%lu\n",
+			   (ecf & BD_SUPPRESS) >> BD_SUPPRESS_SHIFT);
+		packet_log("    SCTX_IV:%lu ExplicitIV:%lu GenIV:%lu ",
+			   (ecf & SCTX_IV) >> SCTX_IV_SHIFT,
+			   (ecf & EXPLICIT_IV) >> EXPLICIT_IV_SHIFT,
+			   (ecf & GEN_IV) >> GEN_IV_SHIFT);
+		packet_log("IV_OV_OFST:%lu EXP_IV_SIZE:%u\n",
+			   (ecf & IV_OFFSET) >> IV_OFFSET_SHIFT,
+			   ecf & EXP_IV_SIZE);
+
+		ptr += sizeof(struct SCTX);
+
+		if (hash_alg && hash_mode) {
+			char *name = "NONE";
+
+			switch (hash_alg) {
+			case HASH_ALG_MD5:
+				hash_key_len = 16;
+				name = "MD5";
+				break;
+			case HASH_ALG_SHA1:
+				hash_key_len = 20;
+				name = "SHA1";
+				break;
+			case HASH_ALG_SHA224:
+				hash_key_len = 28;
+				name = "SHA224";
+				break;
+			case HASH_ALG_SHA256:
+				hash_key_len = 32;
+				name = "SHA256";
+				break;
+			case HASH_ALG_SHA384:
+				hash_key_len = 48;
+				name = "SHA384";
+				break;
+			case HASH_ALG_SHA512:
+				hash_key_len = 64;
+				name = "SHA512";
+				break;
+			case HASH_ALG_AES:
+				hash_key_len = 0;
+				name = "AES";
+				break;
+			case HASH_ALG_NONE:
+				break;
+			}
+
+			packet_log("    Auth Key Type:%s Length:%u Bytes\n",
+				   name, hash_key_len);
+			packet_dump("    KEY: ", ptr, hash_key_len);
+			ptr += hash_key_len;
+		} else if ((hash_alg == HASH_ALG_AES) &&
+			   (hash_mode == HASH_MODE_XCBC)) {
+			char *name = "NONE";
+
+			switch (cipher_type) {
+			case CIPHER_TYPE_AES128:
+				hash_key_len = 16;
+				name = "AES128-XCBC";
+				break;
+			case CIPHER_TYPE_AES192:
+				hash_key_len = 24;
+				name = "AES192-XCBC";
+				break;
+			case CIPHER_TYPE_AES256:
+				hash_key_len = 32;
+				name = "AES256-XCBC";
+				break;
+			}
+			packet_log("    Auth Key Type:%s Length:%u Bytes\n",
+				   name, hash_key_len);
+			packet_dump("    KEY: ", ptr, hash_key_len);
+			ptr += hash_key_len;
+		}
+
+		if (hash_alg && (hash_mode == HASH_MODE_NONE) &&
+		    (hash_type == HASH_TYPE_UPDT)) {
+			char *name = "NONE";
+
+			switch (hash_alg) {
+			case HASH_ALG_MD5:
+				hash_state_len = 16;
+				name = "MD5";
+				break;
+			case HASH_ALG_SHA1:
+				hash_state_len = 20;
+				name = "SHA1";
+				break;
+			case HASH_ALG_SHA224:
+				hash_state_len = 32;
+				name = "SHA224";
+				break;
+			case HASH_ALG_SHA256:
+				hash_state_len = 32;
+				name = "SHA256";
+				break;
+			case HASH_ALG_SHA384:
+				hash_state_len = 48;
+				name = "SHA384";
+				break;
+			case HASH_ALG_SHA512:
+				hash_state_len = 64;
+				name = "SHA512";
+				break;
+			case HASH_ALG_AES:
+				hash_state_len = 0;
+				name = "AES";
+				break;
+			case HASH_ALG_NONE:
+				break;
+			}
+
+			packet_log("    Auth State Type:%s Length:%u Bytes\n",
+				   name, hash_state_len);
+			packet_dump("    State: ", ptr, hash_state_len);
+			ptr += hash_state_len;
+		}
+
+		if (cipher_alg) {
+			char *name = "NONE";
+
+			switch (cipher_alg) {
+			case CIPHER_ALG_DES:
+				cipher_key_len = 8;
+				name = "DES";
+				break;
+			case CIPHER_ALG_3DES:
+				cipher_key_len = 24;
+				name = "3DES";
+				break;
+			case CIPHER_ALG_RC4:
+				cipher_key_len = 260;
+				name = "ARC4";
+				break;
+			case CIPHER_ALG_AES:
+				switch (cipher_type) {
+				case CIPHER_TYPE_AES128:
+					cipher_key_len = 16;
+					name = "AES128";
+					break;
+				case CIPHER_TYPE_AES192:
+					cipher_key_len = 24;
+					name = "AES192";
+					break;
+				case CIPHER_TYPE_AES256:
+					cipher_key_len = 32;
+					name = "AES256";
+					break;
+				}
+				break;
+			case CIPHER_ALG_NONE:
+				break;
+			}
+
+			packet_log("    Cipher Key Type:%s Length:%u Bytes\n",
+				   name, cipher_key_len);
+
+			/* XTS has two keys */
+			if (cipher_mode == CIPHER_MODE_XTS) {
+				packet_dump("    KEY2: ", ptr, cipher_key_len);
+				ptr += cipher_key_len;
+				packet_dump("    KEY1: ", ptr, cipher_key_len);
+				ptr += cipher_key_len;
+
+				cipher_key_len *= 2;
+			} else {
+				packet_dump("    KEY: ", ptr, cipher_key_len);
+				ptr += cipher_key_len;
+			}
+
+			if (ecf & SCTX_IV) {
+				sctx_pl_len = sctx_size * sizeof(u32) -
+					sizeof(struct SCTX);
+				iv_len = sctx_pl_len -
+					(hash_key_len + hash_state_len +
+					 cipher_key_len);
+				packet_log("    IV Length:%u Bytes\n", iv_len);
+				packet_dump("    IV: ", ptr, iv_len);
+				ptr += iv_len;
+			}
+		}
+	}
+
+	/* ========== Decode BDESC ========== */
+	if (spuh->mh.flags & MH_BDESC_PRES) {
+#ifdef DEBUG
+		struct BDESC_HEADER *bdesc = (struct BDESC_HEADER *)ptr;
+#endif
+		packet_log("  BDESC[0] 0x%08x\n", be32_to_cpu(*((u32 *)ptr)));
+		packet_log("    OffsetMAC:%u LengthMAC:%u\n",
+			   be16_to_cpu(bdesc->offset_mac),
+			   be16_to_cpu(bdesc->length_mac));
+		ptr += sizeof(u32);
+
+		packet_log("  BDESC[1] 0x%08x\n", be32_to_cpu(*((u32 *)ptr)));
+		packet_log("    OffsetCrypto:%u LengthCrypto:%u\n",
+			   be16_to_cpu(bdesc->offset_crypto),
+			   be16_to_cpu(bdesc->length_crypto));
+		ptr += sizeof(u32);
+
+		packet_log("  BDESC[2] 0x%08x\n", be32_to_cpu(*((u32 *)ptr)));
+		packet_log("    OffsetICV:%u OffsetIV:%u\n",
+			   be16_to_cpu(bdesc->offset_icv),
+			   be16_to_cpu(bdesc->offset_iv));
+		ptr += sizeof(u32);
+	}
+
+	/* ========== Decode BD ========== */
+	if (spuh->mh.flags & MH_BD_PRES) {
+#ifdef DEBUG
+		struct BD_HEADER *bd = (struct BD_HEADER *)ptr;
+#endif
+		packet_log("  BD[0] 0x%08x\n", be32_to_cpu(*((u32 *)ptr)));
+		packet_log("    Size:%ubytes PrevLength:%u\n",
+			   be16_to_cpu(bd->size), be16_to_cpu(bd->prev_length));
+		ptr += 4;
+	}
+
+	/* Double check sanity */
+	if (buf + buf_len != ptr) {
+		packet_log(" Packet parsed incorrectly. ");
+		packet_log("buf:%p buf_len:%u buf+buf_len:%p ptr:%p\n",
+			   buf, buf_len, buf + buf_len, ptr);
+	}
+
+	packet_log("\n");
+}
+
+/**
+ * spum_ns2_ctx_max_payload() - Determine the max length of the payload for a
+ * SPU message for a given cipher and hash alg context.
+ * @cipher_alg:		The cipher algorithm
+ * @cipher_mode:	The cipher mode
+ * @blocksize:		The size of a block of data for this algo
+ *
+ * The max payload must be a multiple of the blocksize so that if a request is
+ * too large to fit in a single SPU message, the request can be broken into
+ * max_payload sized chunks. Each chunk must be a multiple of blocksize.
+ *
+ * Return: Max payload length in bytes
+ */
+u32 spum_ns2_ctx_max_payload(enum spu_cipher_alg cipher_alg,
+			     enum spu_cipher_mode cipher_mode,
+			     unsigned int blocksize)
+{
+	u32 max_payload = SPUM_NS2_MAX_PAYLOAD;
+	u32 excess;
+
+	/* In XTS on SPU-M, we'll need to insert tweak before input data */
+	if (cipher_mode == CIPHER_MODE_XTS)
+		max_payload -= SPU_XTS_TWEAK_SIZE;
+
+	excess = max_payload % blocksize;
+
+	return max_payload - excess;
+}
+
+/**
+ * spum_nsp_ctx_max_payload() - Determine the max length of the payload for a
+ * SPU message for a given cipher and hash alg context.
+ * @cipher_alg:		The cipher algorithm
+ * @cipher_mode:	The cipher mode
+ * @blocksize:		The size of a block of data for this algo
+ *
+ * The max payload must be a multiple of the blocksize so that if a request is
+ * too large to fit in a single SPU message, the request can be broken into
+ * max_payload sized chunks. Each chunk must be a multiple of blocksize.
+ *
+ * Return: Max payload length in bytes
+ */
+u32 spum_nsp_ctx_max_payload(enum spu_cipher_alg cipher_alg,
+			     enum spu_cipher_mode cipher_mode,
+			     unsigned int blocksize)
+{
+	u32 max_payload = SPUM_NSP_MAX_PAYLOAD;
+	u32 excess;
+
+	/* In XTS on SPU-M, we'll need to insert tweak before input data */
+	if (cipher_mode == CIPHER_MODE_XTS)
+		max_payload -= SPU_XTS_TWEAK_SIZE;
+
+	excess = max_payload % blocksize;
+
+	return max_payload - excess;
+}
+
+/** spum_payload_length() - Given a SPU-M message header, extract the payload
+ * length.
+ * @spu_hdr:	Start of SPU header
+ *
+ * Assumes just MH, EMH, BD (no SCTX, BDESC. Works for response frames.
+ *
+ * Return: payload length in bytes
+ */
+u32 spum_payload_length(u8 *spu_hdr)
+{
+	struct BD_HEADER *bd;
+	u32 pl_len;
+
+	/* Find BD header.  skip MH, EMH */
+	bd = (struct BD_HEADER *)(spu_hdr + 8);
+	pl_len = be16_to_cpu(bd->size);
+
+	return pl_len;
+}
+
+/**
+ * spum_response_hdr_len() - Given the length of the hash key and encryption
+ * key, determine the expected length of a SPU response header.
+ * @auth_key_len:	authentication key length (bytes)
+ * @enc_key_len:	encryption key length (bytes)
+ * @is_hash:		true if response message is for a hash operation
+ *
+ * Return: length of SPU response header (bytes)
+ */
+u16 spum_response_hdr_len(u16 auth_key_len, u16 enc_key_len, bool is_hash)
+{
+	if (is_hash)
+		return SPU_HASH_RESP_HDR_LEN;
+	else
+		return SPU_RESP_HDR_LEN;
+}
+
+/**
+ * spum_hash_pad_len() - Calculate the length of hash padding required to extend
+ * data to a full block size.
+ * @hash_alg:   hash algorithm
+ * @hash_mode:       hash mode
+ * @chunksize:  length of data, in bytes
+ * @hash_block_size:  size of a block of data for hash algorithm
+ *
+ * Reserve space for 1 byte (0x80) start of pad and the total length as u64
+ *
+ * Return:  length of hash pad in bytes
+ */
+u16 spum_hash_pad_len(enum hash_alg hash_alg, enum hash_mode hash_mode,
+		      u32 chunksize, u16 hash_block_size)
+{
+	unsigned int length_len;
+	unsigned int used_space_last_block;
+	int hash_pad_len;
+
+	/* AES-XCBC hash requires just padding to next block boundary */
+	if ((hash_alg == HASH_ALG_AES) && (hash_mode == HASH_MODE_XCBC)) {
+		used_space_last_block = chunksize % hash_block_size;
+		hash_pad_len = hash_block_size - used_space_last_block;
+		if (hash_pad_len >= hash_block_size)
+			hash_pad_len -= hash_block_size;
+		return hash_pad_len;
+	}
+
+	used_space_last_block = chunksize % hash_block_size + 1;
+	if ((hash_alg == HASH_ALG_SHA384) || (hash_alg == HASH_ALG_SHA512))
+		length_len = 2 * sizeof(u64);
+	else
+		length_len = sizeof(u64);
+
+	used_space_last_block += length_len;
+	hash_pad_len = hash_block_size - used_space_last_block;
+	if (hash_pad_len < 0)
+		hash_pad_len += hash_block_size;
+
+	hash_pad_len += 1 + length_len;
+	return hash_pad_len;
+}
+
+/**
+ * spum_gcm_ccm_pad_len() - Determine the required length of GCM or CCM padding.
+ * @cipher_mode:	Algo type
+ * @data_size:		Length of plaintext (bytes)
+ *
+ * @Return: Length of padding, in bytes
+ */
+u32 spum_gcm_ccm_pad_len(enum spu_cipher_mode cipher_mode,
+			 unsigned int data_size)
+{
+	u32 pad_len = 0;
+	u32 m1 = SPU_GCM_CCM_ALIGN - 1;
+
+	if ((cipher_mode == CIPHER_MODE_GCM) ||
+	    (cipher_mode == CIPHER_MODE_CCM))
+		pad_len = ((data_size + m1) & ~m1) - data_size;
+
+	return pad_len;
+}
+
+/**
+ * spum_assoc_resp_len() - Determine the size of the receive buffer required to
+ * catch associated data.
+ * @cipher_mode:	cipher mode
+ * @assoc_len:		length of associated data (bytes)
+ * @iv_len:		length of IV (bytes)
+ * @is_encrypt:		true if encrypting. false if decrypting.
+ *
+ * Return: length of associated data in response message (bytes)
+ */
+u32 spum_assoc_resp_len(enum spu_cipher_mode cipher_mode,
+			unsigned int assoc_len, unsigned int iv_len,
+			bool is_encrypt)
+{
+	u32 buflen = 0;
+	u32 pad;
+
+	if (assoc_len)
+		buflen = assoc_len;
+
+	if (cipher_mode == CIPHER_MODE_GCM) {
+		/* AAD needs to be padded in responses too */
+		pad = spum_gcm_ccm_pad_len(cipher_mode, buflen);
+		buflen += pad;
+	}
+	if (cipher_mode == CIPHER_MODE_CCM) {
+		/*
+		 * AAD needs to be padded in responses too
+		 * for CCM, len + 2 needs to be 128-bit aligned.
+		 */
+		pad = spum_gcm_ccm_pad_len(cipher_mode, buflen + 2);
+		buflen += pad;
+	}
+
+	return buflen;
+}
+
+/**
+ * spu_aead_ivlen() - Calculate the length of the AEAD IV to be included
+ * in a SPU request after the AAD and before the payload.
+ * @cipher_mode:  cipher mode
+ * @iv_ctr_len:   initialization vector length in bytes
+ *
+ * In Linux ~4.2 and later, the assoc_data sg includes the IV. So no need
+ * to include the IV as a separate field in the SPU request msg.
+ *
+ * Return: Length of AEAD IV in bytes
+ */
+u8 spum_aead_ivlen(enum spu_cipher_mode cipher_mode, u16 iv_len)
+{
+	return 0;
+}
+
+/**
+ * spum_hash_type() - Determine the type of hash operation.
+ * @src_sent:  The number of bytes in the current request that have already
+ *             been sent to the SPU to be hashed.
+ *
+ * We do not use HASH_TYPE_FULL for requests that fit in a single SPU message.
+ * Using FULL causes failures (such as when the string to be hashed is empty).
+ * For similar reasons, we never use HASH_TYPE_FIN. Instead, submit messages
+ * as INIT or UPDT and do the hash padding in sw.
+ */
+enum hash_type spum_hash_type(u32 src_sent)
+{
+	return src_sent ? HASH_TYPE_UPDT : HASH_TYPE_INIT;
+}
+
+/**
+ * spum_digest_size() - Determine the size of a hash digest to expect the SPU to
+ * return.
+ * alg_digest_size: Number of bytes in the final digest for the given algo
+ * alg:             The hash algorithm
+ * htype:           Type of hash operation (init, update, full, etc)
+ *
+ * When doing incremental hashing for an algorithm with a truncated hash
+ * (e.g., SHA224), the SPU returns the full digest so that it can be fed back as
+ * a partial result for the next chunk.
+ */
+u32 spum_digest_size(u32 alg_digest_size, enum hash_alg alg,
+		     enum hash_type htype)
+{
+	u32 digestsize = alg_digest_size;
+
+	/* SPU returns complete digest when doing incremental hash and truncated
+	 * hash algo.
+	 */
+	if ((htype == HASH_TYPE_INIT) || (htype == HASH_TYPE_UPDT)) {
+		if (alg == HASH_ALG_SHA224)
+			digestsize = SHA256_DIGEST_SIZE;
+		else if (alg == HASH_ALG_SHA384)
+			digestsize = SHA512_DIGEST_SIZE;
+	}
+	return digestsize;
+}
+
+/**
+ * spum_create_request() - Build a SPU request message header, up to and
+ * including the BD header. Construct the message starting at spu_hdr. Caller
+ * should allocate this buffer in DMA-able memory at least SPU_HEADER_ALLOC_LEN
+ * bytes long.
+ * @spu_hdr: Start of buffer where SPU request header is to be written
+ * @req_opts: SPU request message options
+ * @cipher_parms: Parameters related to cipher algorithm
+ * @hash_parms:   Parameters related to hash algorithm
+ * @aead_parms:   Parameters related to AEAD operation
+ * @data_size:    Length of data to be encrypted or authenticated. If AEAD, does
+ *		  not include length of AAD.
+
+ * Return: the length of the SPU header in bytes. 0 if an error occurs.
+ */
+u32 spum_create_request(u8 *spu_hdr,
+			struct spu_request_opts *req_opts,
+			struct spu_cipher_parms *cipher_parms,
+			struct spu_hash_parms *hash_parms,
+			struct spu_aead_parms *aead_parms,
+			unsigned int data_size)
+{
+	struct SPUHEADER *spuh;
+	struct BDESC_HEADER *bdesc;
+	struct BD_HEADER *bd;
+
+	u8 *ptr;
+	u32 protocol_bits = 0;
+	u32 cipher_bits = 0;
+	u32 ecf_bits = 0;
+	u8 sctx_words = 0;
+	unsigned int buf_len = 0;
+
+	/* size of the cipher payload */
+	unsigned int cipher_len = hash_parms->prebuf_len + data_size +
+				hash_parms->pad_len;
+
+	/* offset of prebuf or data from end of BD header */
+	unsigned int cipher_offset = aead_parms->assoc_size +
+		aead_parms->iv_len + aead_parms->aad_pad_len;
+
+	/* total size of the DB data (without STAT word padding) */
+	unsigned int real_db_size = spu_real_db_size(aead_parms->assoc_size,
+						 aead_parms->iv_len,
+						 hash_parms->prebuf_len,
+						 data_size,
+						 aead_parms->aad_pad_len,
+						 aead_parms->data_pad_len,
+						 hash_parms->pad_len);
+
+	unsigned int auth_offset = 0;
+	unsigned int offset_iv = 0;
+
+	/* size/offset of the auth payload */
+	unsigned int auth_len;
+
+	auth_len = real_db_size;
+
+	if (req_opts->is_aead && req_opts->is_inbound)
+		cipher_len -= hash_parms->digestsize;
+
+	if (req_opts->is_aead && req_opts->is_inbound)
+		auth_len -= hash_parms->digestsize;
+
+	if ((hash_parms->alg == HASH_ALG_AES) &&
+	    (hash_parms->mode == HASH_MODE_XCBC)) {
+		auth_len -= hash_parms->pad_len;
+		cipher_len -= hash_parms->pad_len;
+	}
+
+	flow_log("%s()\n", __func__);
+	flow_log("  in:%u authFirst:%u\n",
+		 req_opts->is_inbound, req_opts->auth_first);
+	flow_log("  %s. cipher alg:%u mode:%u type %u\n",
+		 spu_alg_name(cipher_parms->alg, cipher_parms->mode),
+		 cipher_parms->alg, cipher_parms->mode, cipher_parms->type);
+	flow_log("    key: %d\n", cipher_parms->key_len);
+	flow_dump("    key: ", cipher_parms->key_buf, cipher_parms->key_len);
+	flow_log("    iv: %d\n", cipher_parms->iv_len);
+	flow_dump("    iv: ", cipher_parms->iv_buf, cipher_parms->iv_len);
+	flow_log("  auth alg:%u mode:%u type %u\n",
+		 hash_parms->alg, hash_parms->mode, hash_parms->type);
+	flow_log("  digestsize: %u\n", hash_parms->digestsize);
+	flow_log("  authkey: %d\n", hash_parms->key_len);
+	flow_dump("  authkey: ", hash_parms->key_buf, hash_parms->key_len);
+	flow_log("  assoc_size:%u\n", aead_parms->assoc_size);
+	flow_log("  prebuf_len:%u\n", hash_parms->prebuf_len);
+	flow_log("  data_size:%u\n", data_size);
+	flow_log("  hash_pad_len:%u\n", hash_parms->pad_len);
+	flow_log("  real_db_size:%u\n", real_db_size);
+	flow_log(" auth_offset:%u auth_len:%u cipher_offset:%u cipher_len:%u\n",
+		 auth_offset, auth_len, cipher_offset, cipher_len);
+	flow_log("  hmac_offset:%u\n", hash_parms->hmac_offset);
+	flow_log("  aead_iv: %u\n", aead_parms->iv_len);
+
+	/* starting out: zero the header (plus some) */
+	ptr = spu_hdr;
+	memset(ptr, 0, sizeof(struct SPUHEADER));
+
+	/* format master header word */
+	/* Do not set the next bit even though the datasheet says to */
+	spuh = (struct SPUHEADER *)ptr;
+	ptr += sizeof(struct SPUHEADER);
+	buf_len += sizeof(struct SPUHEADER);
+
+	spuh->mh.op_code = SPU_CRYPTO_OPERATION_GENERIC;
+	spuh->mh.flags |= (MH_SCTX_PRES | MH_BDESC_PRES | MH_BD_PRES);
+
+	/* Format sctx word 0 (protocol_bits) */
+	sctx_words = 3;		/* size in words */
+
+	/* Format sctx word 1 (cipher_bits) */
+	if (req_opts->is_inbound)
+		cipher_bits |= CIPHER_INBOUND;
+	if (req_opts->auth_first)
+		cipher_bits |= CIPHER_ORDER;
+
+	/* Set the crypto parameters in the cipher.flags */
+	cipher_bits |= cipher_parms->alg << CIPHER_ALG_SHIFT;
+	cipher_bits |= cipher_parms->mode << CIPHER_MODE_SHIFT;
+	cipher_bits |= cipher_parms->type << CIPHER_TYPE_SHIFT;
+
+	/* Set the auth parameters in the cipher.flags */
+	cipher_bits |= hash_parms->alg << HASH_ALG_SHIFT;
+	cipher_bits |= hash_parms->mode << HASH_MODE_SHIFT;
+	cipher_bits |= hash_parms->type << HASH_TYPE_SHIFT;
+
+	/*
+	 * Format sctx extensions if required, and update main fields if
+	 * required)
+	 */
+	if (hash_parms->alg) {
+		/* Write the authentication key material if present */
+		if (hash_parms->key_len) {
+			memcpy(ptr, hash_parms->key_buf, hash_parms->key_len);
+			ptr += hash_parms->key_len;
+			buf_len += hash_parms->key_len;
+			sctx_words += hash_parms->key_len / 4;
+		}
+
+		if ((cipher_parms->mode == CIPHER_MODE_GCM) ||
+		    (cipher_parms->mode == CIPHER_MODE_CCM))
+			/* unpadded length */
+			offset_iv = aead_parms->assoc_size;
+
+		/* if GCM/CCM we need to write ICV into the payload */
+		if (!req_opts->is_inbound) {
+			if ((cipher_parms->mode == CIPHER_MODE_GCM) ||
+			    (cipher_parms->mode == CIPHER_MODE_CCM))
+				ecf_bits |= 1 << INSERT_ICV_SHIFT;
+		} else {
+			ecf_bits |= CHECK_ICV;
+		}
+
+		/* Inform the SPU of the ICV size (in words) */
+		if (hash_parms->digestsize == 64)
+			cipher_bits |= ICV_IS_512;
+		else
+			ecf_bits |=
+			(hash_parms->digestsize / 4) << ICV_SIZE_SHIFT;
+	}
+
+	if (req_opts->bd_suppress)
+		ecf_bits |= BD_SUPPRESS;
+
+	/* copy the encryption keys in the SAD entry */
+	if (cipher_parms->alg) {
+		if (cipher_parms->key_len) {
+			memcpy(ptr, cipher_parms->key_buf,
+			       cipher_parms->key_len);
+			ptr += cipher_parms->key_len;
+			buf_len += cipher_parms->key_len;
+			sctx_words += cipher_parms->key_len / 4;
+		}
+
+		/*
+		 * if encrypting then set IV size, use SCTX IV unless no IV
+		 * given here
+		 */
+		if (cipher_parms->iv_buf && cipher_parms->iv_len) {
+			/* Use SCTX IV */
+			ecf_bits |= SCTX_IV;
+
+			/* cipher iv provided so put it in here */
+			memcpy(ptr, cipher_parms->iv_buf, cipher_parms->iv_len);
+
+			ptr += cipher_parms->iv_len;
+			buf_len += cipher_parms->iv_len;
+			sctx_words += cipher_parms->iv_len / 4;
+		}
+	}
+
+	/*
+	 * RFC4543 (GMAC/ESP) requires data to be sent as part of AAD
+	 * so we need to override the BDESC parameters.
+	 */
+	if (req_opts->is_rfc4543) {
+		if (req_opts->is_inbound)
+			data_size -= hash_parms->digestsize;
+		offset_iv = aead_parms->assoc_size + data_size;
+		cipher_len = 0;
+		cipher_offset = offset_iv;
+		auth_len = cipher_offset + aead_parms->data_pad_len;
+	}
+
+	/* write in the total sctx length now that we know it */
+	protocol_bits |= sctx_words;
+
+	/* Endian adjust the SCTX */
+	spuh->sa.proto_flags = cpu_to_be32(protocol_bits);
+	spuh->sa.cipher_flags = cpu_to_be32(cipher_bits);
+	spuh->sa.ecf = cpu_to_be32(ecf_bits);
+
+	/* === create the BDESC section === */
+	bdesc = (struct BDESC_HEADER *)ptr;
+
+	bdesc->offset_mac = cpu_to_be16(auth_offset);
+	bdesc->length_mac = cpu_to_be16(auth_len);
+	bdesc->offset_crypto = cpu_to_be16(cipher_offset);
+	bdesc->length_crypto = cpu_to_be16(cipher_len);
+
+	/*
+	 * CCM in SPU-M requires that ICV not be in same 32-bit word as data or
+	 * padding.  So account for padding as necessary.
+	 */
+	if (cipher_parms->mode == CIPHER_MODE_CCM)
+		auth_len += spum_wordalign_padlen(auth_len);
+
+	bdesc->offset_icv = cpu_to_be16(auth_len);
+	bdesc->offset_iv = cpu_to_be16(offset_iv);
+
+	ptr += sizeof(struct BDESC_HEADER);
+	buf_len += sizeof(struct BDESC_HEADER);
+
+	/* === no MFM section === */
+
+	/* === create the BD section === */
+
+	/* add the BD header */
+	bd = (struct BD_HEADER *)ptr;
+	bd->size = cpu_to_be16(real_db_size);
+	bd->prev_length = 0;
+
+	ptr += sizeof(struct BD_HEADER);
+	buf_len += sizeof(struct BD_HEADER);
+
+	packet_dump("  SPU request header: ", spu_hdr, buf_len);
+
+	return buf_len;
+}
+
+/**
+ * spum_cipher_req_init() - Build a SPU request message header, up to and
+ * including the BD header.
+ * @spu_hdr:      Start of SPU request header (MH)
+ * @cipher_parms: Parameters that describe the cipher request
+ *
+ * Construct the message starting at spu_hdr. Caller should allocate this buffer
+ * in DMA-able memory at least SPU_HEADER_ALLOC_LEN bytes long.
+ *
+ * Return: the length of the SPU header in bytes. 0 if an error occurs.
+ */
+u16 spum_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms)
+{
+	struct SPUHEADER *spuh;
+	u32 protocol_bits = 0;
+	u32 cipher_bits = 0;
+	u32 ecf_bits = 0;
+	u8 sctx_words = 0;
+	u8 *ptr = spu_hdr;
+
+	flow_log("%s()\n", __func__);
+	flow_log("  cipher alg:%u mode:%u type %u\n", cipher_parms->alg,
+		 cipher_parms->mode, cipher_parms->type);
+	flow_log("  cipher_iv_len: %u\n", cipher_parms->iv_len);
+	flow_log("    key: %d\n", cipher_parms->key_len);
+	flow_dump("    key: ", cipher_parms->key_buf, cipher_parms->key_len);
+
+	/* starting out: zero the header (plus some) */
+	memset(spu_hdr, 0, sizeof(struct SPUHEADER));
+	ptr += sizeof(struct SPUHEADER);
+
+	/* format master header word */
+	/* Do not set the next bit even though the datasheet says to */
+	spuh = (struct SPUHEADER *)spu_hdr;
+
+	spuh->mh.op_code = SPU_CRYPTO_OPERATION_GENERIC;
+	spuh->mh.flags |= (MH_SCTX_PRES | MH_BDESC_PRES | MH_BD_PRES);
+
+	/* Format sctx word 0 (protocol_bits) */
+	sctx_words = 3;		/* size in words */
+
+	/* copy the encryption keys in the SAD entry */
+	if (cipher_parms->alg) {
+		if (cipher_parms->key_len) {
+			ptr += cipher_parms->key_len;
+			sctx_words += cipher_parms->key_len / 4;
+		}
+
+		/*
+		 * if encrypting then set IV size, use SCTX IV unless no IV
+		 * given here
+		 */
+		if (cipher_parms->iv_len) {
+			/* Use SCTX IV */
+			ecf_bits |= SCTX_IV;
+			ptr += cipher_parms->iv_len;
+			sctx_words += cipher_parms->iv_len / 4;
+		}
+	}
+
+	/* Set the crypto parameters in the cipher.flags */
+	cipher_bits |= cipher_parms->alg << CIPHER_ALG_SHIFT;
+	cipher_bits |= cipher_parms->mode << CIPHER_MODE_SHIFT;
+	cipher_bits |= cipher_parms->type << CIPHER_TYPE_SHIFT;
+
+	/* copy the encryption keys in the SAD entry */
+	if (cipher_parms->alg && cipher_parms->key_len)
+		memcpy(spuh + 1, cipher_parms->key_buf, cipher_parms->key_len);
+
+	/* write in the total sctx length now that we know it */
+	protocol_bits |= sctx_words;
+
+	/* Endian adjust the SCTX */
+	spuh->sa.proto_flags = cpu_to_be32(protocol_bits);
+
+	/* Endian adjust the SCTX */
+	spuh->sa.cipher_flags = cpu_to_be32(cipher_bits);
+	spuh->sa.ecf = cpu_to_be32(ecf_bits);
+
+	packet_dump("  SPU request header: ", spu_hdr,
+		    sizeof(struct SPUHEADER));
+
+	return sizeof(struct SPUHEADER) + cipher_parms->key_len +
+		cipher_parms->iv_len + sizeof(struct BDESC_HEADER) +
+		sizeof(struct BD_HEADER);
+}
+
+/**
+ * spum_cipher_req_finish() - Finish building a SPU request message header for a
+ * block cipher request. Assumes much of the header was already filled in at
+ * setkey() time in spu_cipher_req_init().
+ * @spu_hdr:         Start of the request message header (MH field)
+ * @spu_req_hdr_len: Length in bytes of the SPU request header
+ * @isInbound:       0 encrypt, 1 decrypt
+ * @cipher_parms:    Parameters describing cipher operation to be performed
+ * @update_key:      If true, rewrite the cipher key in SCTX
+ * @data_size:       Length of the data in the BD field
+ *
+ * Assumes much of the header was already filled in at setkey() time in
+ * spum_cipher_req_init().
+ * spum_cipher_req_init() fills in the encryption key. For RC4, when submitting
+ * a request for a non-first chunk, we use the 260-byte SUPDT field from the
+ * previous response as the key. update_key is true for this case. Unused in all
+ * other cases.
+ */
+void spum_cipher_req_finish(u8 *spu_hdr,
+			    u16 spu_req_hdr_len,
+			    unsigned int is_inbound,
+			    struct spu_cipher_parms *cipher_parms,
+			    bool update_key,
+			    unsigned int data_size)
+{
+	struct SPUHEADER *spuh;
+	struct BDESC_HEADER *bdesc;
+	struct BD_HEADER *bd;
+	u8 *bdesc_ptr = spu_hdr + spu_req_hdr_len -
+	    (sizeof(struct BD_HEADER) + sizeof(struct BDESC_HEADER));
+
+	u32 cipher_bits;
+
+	flow_log("%s()\n", __func__);
+	flow_log(" in: %u\n", is_inbound);
+	flow_log(" cipher alg: %u, cipher_type: %u\n", cipher_parms->alg,
+		 cipher_parms->type);
+	if (update_key) {
+		flow_log(" cipher key len: %u\n", cipher_parms->key_len);
+		flow_dump("  key: ", cipher_parms->key_buf,
+			  cipher_parms->key_len);
+	}
+
+	/*
+	 * In XTS mode, API puts "i" parameter (block tweak) in IV.  For
+	 * SPU-M, should be in start of the BD; tx_sg_create() copies it there.
+	 * IV in SPU msg for SPU-M should be 0, since that's the "j" parameter
+	 * (block ctr within larger data unit) - given we can send entire disk
+	 * block (<= 4KB) in 1 SPU msg, don't need to use this parameter.
+	 */
+	if (cipher_parms->mode == CIPHER_MODE_XTS)
+		memset(cipher_parms->iv_buf, 0, cipher_parms->iv_len);
+
+	flow_log(" iv len: %d\n", cipher_parms->iv_len);
+	flow_dump("    iv: ", cipher_parms->iv_buf, cipher_parms->iv_len);
+	flow_log(" data_size: %u\n", data_size);
+
+	/* format master header word */
+	/* Do not set the next bit even though the datasheet says to */
+	spuh = (struct SPUHEADER *)spu_hdr;
+
+	/* cipher_bits was initialized at setkey time */
+	cipher_bits = be32_to_cpu(spuh->sa.cipher_flags);
+
+	/* Format sctx word 1 (cipher_bits) */
+	if (is_inbound)
+		cipher_bits |= CIPHER_INBOUND;
+	else
+		cipher_bits &= ~CIPHER_INBOUND;
+
+	/* update encryption key for RC4 on non-first chunk */
+	if (update_key) {
+		spuh->sa.cipher_flags |=
+			cipher_parms->type << CIPHER_TYPE_SHIFT;
+		memcpy(spuh + 1, cipher_parms->key_buf, cipher_parms->key_len);
+	}
+
+	if (cipher_parms->alg && cipher_parms->iv_buf && cipher_parms->iv_len)
+		/* cipher iv provided so put it in here */
+		memcpy(bdesc_ptr - cipher_parms->iv_len, cipher_parms->iv_buf,
+		       cipher_parms->iv_len);
+
+	spuh->sa.cipher_flags = cpu_to_be32(cipher_bits);
+
+	/* === create the BDESC section === */
+	bdesc = (struct BDESC_HEADER *)bdesc_ptr;
+	bdesc->offset_mac = 0;
+	bdesc->length_mac = 0;
+	bdesc->offset_crypto = 0;
+
+	/* XTS mode, data_size needs to include tweak parameter */
+	if (cipher_parms->mode == CIPHER_MODE_XTS)
+		bdesc->length_crypto = cpu_to_be16(data_size +
+						  SPU_XTS_TWEAK_SIZE);
+	else
+		bdesc->length_crypto = cpu_to_be16(data_size);
+
+	bdesc->offset_icv = 0;
+	bdesc->offset_iv = 0;
+
+	/* === no MFM section === */
+
+	/* === create the BD section === */
+	/* add the BD header */
+	bd = (struct BD_HEADER *)(bdesc_ptr + sizeof(struct BDESC_HEADER));
+	bd->size = cpu_to_be16(data_size);
+
+	/* XTS mode, data_size needs to include tweak parameter */
+	if (cipher_parms->mode == CIPHER_MODE_XTS)
+		bd->size = cpu_to_be16(data_size + SPU_XTS_TWEAK_SIZE);
+	else
+		bd->size = cpu_to_be16(data_size);
+
+	bd->prev_length = 0;
+
+	packet_dump("  SPU request header: ", spu_hdr, spu_req_hdr_len);
+}
+
+/**
+ * spum_request_pad() - Create pad bytes at the end of the data.
+ * @pad_start:		Start of buffer where pad bytes are to be written
+ * @gcm_ccm_padding:	length of GCM/CCM padding, in bytes
+ * @hash_pad_len:	Number of bytes of padding extend data to full block
+ * @auth_alg:		authentication algorithm
+ * @auth_mode:		authentication mode
+ * @total_sent:		length inserted at end of hash pad
+ * @status_padding:	Number of bytes of padding to align STATUS word
+ *
+ * There may be three forms of pad:
+ *  1. GCM/CCM pad - for GCM/CCM mode ciphers, pad to 16-byte alignment
+ *  2. hash pad - pad to a block length, with 0x80 data terminator and
+ *                size at the end
+ *  3. STAT pad - to ensure the STAT field is 4-byte aligned
+ */
+void spum_request_pad(u8 *pad_start,
+		      u32 gcm_ccm_padding,
+		      u32 hash_pad_len,
+		      enum hash_alg auth_alg,
+		      enum hash_mode auth_mode,
+		      unsigned int total_sent, u32 status_padding)
+{
+	u8 *ptr = pad_start;
+
+	/* fix data alignent for GCM/CCM */
+	if (gcm_ccm_padding > 0) {
+		flow_log("  GCM: padding to 16 byte alignment: %u bytes\n",
+			 gcm_ccm_padding);
+		memset(ptr, 0, gcm_ccm_padding);
+		ptr += gcm_ccm_padding;
+	}
+
+	if (hash_pad_len > 0) {
+		/* clear the padding section */
+		memset(ptr, 0, hash_pad_len);
+
+		if ((auth_alg == HASH_ALG_AES) &&
+		    (auth_mode == HASH_MODE_XCBC)) {
+			/* AES/XCBC just requires padding to be 0s */
+			ptr += hash_pad_len;
+		} else {
+			/* terminate the data */
+			*ptr = 0x80;
+			ptr += (hash_pad_len - sizeof(u64));
+
+			/* add the size at the end as required per alg */
+			if (auth_alg == HASH_ALG_MD5)
+				*(u64 *)ptr = cpu_to_le64((u64)total_sent * 8);
+			else		/* SHA1, SHA2-224, SHA2-256 */
+				*(u64 *)ptr = cpu_to_be64((u64)total_sent * 8);
+			ptr += sizeof(u64);
+		}
+	}
+
+	/* pad to a 4byte alignment for STAT */
+	if (status_padding > 0) {
+		flow_log("  STAT: padding to 4 byte alignment: %u bytes\n",
+			 status_padding);
+
+		memset(ptr, 0, status_padding);
+		ptr += status_padding;
+	}
+}
+
+/**
+ * spum_xts_tweak_in_payload() - Indicate that SPUM DOES place the XTS tweak
+ * field in the packet payload (rather than using IV)
+ *
+ * Return: 1
+ */
+u8 spum_xts_tweak_in_payload(void)
+{
+	return 1;
+}
+
+/**
+ * spum_tx_status_len() - Return the length of the STATUS field in a SPU
+ * response message.
+ *
+ * Return: Length of STATUS field in bytes.
+ */
+u8 spum_tx_status_len(void)
+{
+	return SPU_TX_STATUS_LEN;
+}
+
+/**
+ * spum_rx_status_len() - Return the length of the STATUS field in a SPU
+ * response message.
+ *
+ * Return: Length of STATUS field in bytes.
+ */
+u8 spum_rx_status_len(void)
+{
+	return SPU_RX_STATUS_LEN;
+}
+
+/**
+ * spum_status_process() - Process the status from a SPU response message.
+ * @statp:  start of STATUS word
+ * Return:
+ *   0 - if status is good and response should be processed
+ *   !0 - status indicates an error and response is invalid
+ */
+int spum_status_process(u8 *statp)
+{
+	u32 status;
+
+	status = __be32_to_cpu(*(__be32 *)statp);
+	flow_log("SPU response STATUS %#08x\n", status);
+	if (status & SPU_STATUS_ERROR_FLAG) {
+		pr_err("%s() Warning: Error result from SPU: %#08x\n",
+		       __func__, status);
+		if (status & SPU_STATUS_INVALID_ICV)
+			return SPU_INVALID_ICV;
+		return -EBADMSG;
+	}
+	return 0;
+}
+
+/**
+ * spum_ccm_update_iv() - Update the IV as per the requirements for CCM mode.
+ *
+ * @digestsize:		Digest size of this request
+ * @cipher_parms:	(pointer to) cipher parmaeters, includes IV buf & IV len
+ * @assoclen:		Length of AAD data
+ * @chunksize:		length of input data to be sent in this req
+ * @is_encrypt:		true if this is an output/encrypt operation
+ * @is_esp:		true if this is an ESP / RFC4309 operation
+ *
+ */
+void spum_ccm_update_iv(unsigned int digestsize,
+			struct spu_cipher_parms *cipher_parms,
+			unsigned int assoclen,
+			unsigned int chunksize,
+			bool is_encrypt,
+			bool is_esp)
+{
+	u8 L;		/* L from CCM algorithm, length of plaintext data */
+	u8 mprime;	/* M' from CCM algo, (M - 2) / 2, where M=authsize */
+	u8 adata;
+
+	if (cipher_parms->iv_len != CCM_AES_IV_SIZE) {
+		pr_err("%s(): Invalid IV len %d for CCM mode, should be %d\n",
+		       __func__, cipher_parms->iv_len, CCM_AES_IV_SIZE);
+		return;
+	}
+
+	/*
+	 * IV needs to be formatted as follows:
+	 *
+	 * |          Byte 0               | Bytes 1 - N | Bytes (N+1) - 15 |
+	 * | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 | Bits 7 - 0  |    Bits 7 - 0    |
+	 * | 0 |Ad?|(M - 2) / 2|   L - 1   |    Nonce    | Plaintext Length |
+	 *
+	 * Ad? = 1 if AAD present, 0 if not present
+	 * M = size of auth field, 8, 12, or 16 bytes (SPU-M) -or-
+	 *                         4, 6, 8, 10, 12, 14, 16 bytes (SPU2)
+	 * L = Size of Plaintext Length field; Nonce size = 15 - L
+	 *
+	 * It appears that the crypto API already expects the L-1 portion
+	 * to be set in the first byte of the IV, which implicitly determines
+	 * the nonce size, and also fills in the nonce.  But the other bits
+	 * in byte 0 as well as the plaintext length need to be filled in.
+	 *
+	 * In rfc4309/esp mode, L is not already in the supplied IV and
+	 * we need to fill it in, as well as move the IV data to be after
+	 * the salt
+	 */
+	if (is_esp) {
+		L = CCM_ESP_L_VALUE;	/* RFC4309 has fixed L */
+	} else {
+		/* L' = plaintext length - 1 so Plaintext length is L' + 1 */
+		L = ((cipher_parms->iv_buf[0] & CCM_B0_L_PRIME) >>
+		      CCM_B0_L_PRIME_SHIFT) + 1;
+	}
+
+	mprime = (digestsize - 2) >> 1;  /* M' = (M - 2) / 2 */
+	adata = (assoclen > 0);  /* adata = 1 if any associated data */
+
+	cipher_parms->iv_buf[0] = (adata << CCM_B0_ADATA_SHIFT) |
+				  (mprime << CCM_B0_M_PRIME_SHIFT) |
+				  ((L - 1) << CCM_B0_L_PRIME_SHIFT);
+
+	/* Nonce is already filled in by crypto API, and is 15 - L bytes */
+
+	/* Don't include digest in plaintext size when decrypting */
+	if (!is_encrypt)
+		chunksize -= digestsize;
+
+	/* Fill in length of plaintext, formatted to be L bytes long */
+	format_value_ccm(chunksize, &cipher_parms->iv_buf[15 - L + 1], L);
+}
+
+/**
+ * spum_wordalign_padlen() - Given the length of a data field, determine the
+ * padding required to align the data following this field on a 4-byte boundary.
+ * @data_size: length of data field in bytes
+ *
+ * Return: length of status field padding, in bytes
+ */
+u32 spum_wordalign_padlen(u32 data_size)
+{
+	return ((data_size + 3) & ~3) - data_size;
+}
diff --git a/drivers/crypto/bcm/spu.h b/drivers/crypto/bcm/spu.h
new file mode 100644
index 0000000..e2eb925
--- /dev/null
+++ b/drivers/crypto/bcm/spu.h
@@ -0,0 +1,288 @@
+/*
+ * Copyright 2016 Broadcom
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation (the "GPL").
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 (GPLv2) for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 (GPLv2) along with this source code.
+ */
+
+/*
+ * This file contains the definition of SPU messages. There are currently two
+ * SPU message formats: SPU-M and SPU2. The hardware uses different values to
+ * identify the same things in SPU-M vs SPU2. So this file defines values that
+ * are hardware independent. Software can use these values for any version of
+ * SPU hardware. These values are used in APIs in spu.c. Functions internal to
+ * spu.c and spu2.c convert these to hardware-specific values.
+ */
+
+#ifndef _SPU_H
+#define _SPU_H
+
+#include <linux/types.h>
+#include <linux/scatterlist.h>
+#include <crypto/sha.h>
+
+enum spu_cipher_alg {
+	CIPHER_ALG_NONE = 0x0,
+	CIPHER_ALG_RC4 = 0x1,
+	CIPHER_ALG_DES = 0x2,
+	CIPHER_ALG_3DES = 0x3,
+	CIPHER_ALG_AES = 0x4,
+	CIPHER_ALG_LAST = 0x5
+};
+
+enum spu_cipher_mode {
+	CIPHER_MODE_NONE = 0x0,
+	CIPHER_MODE_ECB = 0x0,
+	CIPHER_MODE_CBC = 0x1,
+	CIPHER_MODE_OFB = 0x2,
+	CIPHER_MODE_CFB = 0x3,
+	CIPHER_MODE_CTR = 0x4,
+	CIPHER_MODE_CCM = 0x5,
+	CIPHER_MODE_GCM = 0x6,
+	CIPHER_MODE_XTS = 0x7,
+	CIPHER_MODE_LAST = 0x8
+};
+
+enum spu_cipher_type {
+	CIPHER_TYPE_NONE = 0x0,
+	CIPHER_TYPE_DES = 0x0,
+	CIPHER_TYPE_3DES = 0x0,
+	CIPHER_TYPE_INIT = 0x0,	/* used for ARC4 */
+	CIPHER_TYPE_AES128 = 0x0,
+	CIPHER_TYPE_AES192 = 0x1,
+	CIPHER_TYPE_UPDT = 0x1,	/* used for ARC4 */
+	CIPHER_TYPE_AES256 = 0x2,
+};
+
+enum hash_alg {
+	HASH_ALG_NONE = 0x0,
+	HASH_ALG_MD5 = 0x1,
+	HASH_ALG_SHA1 = 0x2,
+	HASH_ALG_SHA224 = 0x3,
+	HASH_ALG_SHA256 = 0x4,
+	HASH_ALG_AES = 0x5,
+	HASH_ALG_SHA384 = 0x6,
+	HASH_ALG_SHA512 = 0x7,
+	/* Keep SHA3 algorithms at the end always */
+	HASH_ALG_SHA3_224 = 0x8,
+	HASH_ALG_SHA3_256 = 0x9,
+	HASH_ALG_SHA3_384 = 0xa,
+	HASH_ALG_SHA3_512 = 0xb,
+	HASH_ALG_LAST
+};
+
+enum hash_mode {
+	HASH_MODE_NONE = 0x0,
+	HASH_MODE_HASH = 0x0,
+	HASH_MODE_XCBC = 0x0,
+	HASH_MODE_CMAC = 0x1,
+	HASH_MODE_CTXT = 0x1,
+	HASH_MODE_HMAC = 0x2,
+	HASH_MODE_RABIN = 0x4,
+	HASH_MODE_FHMAC = 0x6,
+	HASH_MODE_CCM = 0x5,
+	HASH_MODE_GCM = 0x6,
+};
+
+enum hash_type {
+	HASH_TYPE_NONE = 0x0,
+	HASH_TYPE_FULL = 0x0,
+	HASH_TYPE_INIT = 0x1,
+	HASH_TYPE_UPDT = 0x2,
+	HASH_TYPE_FIN = 0x3,
+	HASH_TYPE_AES128 = 0x0,
+	HASH_TYPE_AES192 = 0x1,
+	HASH_TYPE_AES256 = 0x2
+};
+
+enum aead_type {
+	AES_CCM,
+	AES_GCM,
+	AUTHENC,
+	AEAD_TYPE_LAST
+};
+
+extern char *hash_alg_name[HASH_ALG_LAST];
+extern char *aead_alg_name[AEAD_TYPE_LAST];
+
+struct spu_request_opts {
+	bool is_inbound;
+	bool auth_first;
+	bool is_aead;
+	bool is_esp;
+	bool bd_suppress;
+	bool is_rfc4543;
+};
+
+struct spu_cipher_parms {
+	enum spu_cipher_alg  alg;
+	enum spu_cipher_mode mode;
+	enum spu_cipher_type type;
+	u8                  *key_buf;
+	u16                  key_len;
+	/* iv_buf and iv_len include salt, if applicable */
+	u8                  *iv_buf;
+	u16                  iv_len;
+};
+
+struct spu_hash_parms {
+	enum hash_alg  alg;
+	enum hash_mode mode;
+	enum hash_type type;
+	u8             digestsize;
+	u8            *key_buf;
+	u16            key_len;
+	u16            prebuf_len;
+	u16            hmac_offset;
+	/* length of hash pad. signed, needs to handle roll-overs */
+	int            pad_len;
+};
+
+struct spu_aead_parms {
+	u32 assoc_size;
+	u16 iv_len;      /* length of IV field between assoc data and data */
+	u8  aad_pad_len; /* For AES GCM/CCM, length of padding after AAD */
+	u8  data_pad_len;/* For AES GCM/CCM, length of padding after data */
+	bool return_iv;  /* True if SPU should return an IV */
+	u32 ret_iv_len;  /* Length in bytes of returned IV */
+	u32 ret_iv_off;  /* Offset into full IV if partial IV returned */
+};
+
+/************** SPU sizes ***************/
+
+#define SPU_RX_STATUS_LEN  4
+
+/* Max length of padding for 4-byte alignment of STATUS field */
+#define SPU_STAT_PAD_MAX  4
+
+/* Max length of pad fragment. 4 is for 4-byte alignment of STATUS field */
+#define SPU_PAD_LEN_MAX (SPU_GCM_CCM_ALIGN + MAX_HASH_BLOCK_SIZE + \
+			 SPU_STAT_PAD_MAX)
+
+/* GCM and CCM require 16-byte alignment */
+#define SPU_GCM_CCM_ALIGN 16
+
+/* Length up SUPDT field in SPU response message for RC4 */
+#define SPU_SUPDT_LEN 260
+
+/* SPU status error codes. These used as common error codes across all
+ * SPU variants.
+ */
+#define SPU_INVALID_ICV  1
+
+/* Indicates no limit to the length of the payload in a SPU message */
+#define SPU_MAX_PAYLOAD_INF  0xFFFFFFFF
+
+/* Size of XTS tweak ("i" parameter), in bytes */
+#define SPU_XTS_TWEAK_SIZE 16
+
+/* CCM B_0 field definitions, common for SPU-M and SPU2 */
+#define CCM_B0_ADATA		0x40
+#define CCM_B0_ADATA_SHIFT	   6
+#define CCM_B0_M_PRIME		0x38
+#define CCM_B0_M_PRIME_SHIFT	   3
+#define CCM_B0_L_PRIME		0x07
+#define CCM_B0_L_PRIME_SHIFT	   0
+#define CCM_ESP_L_VALUE		   4
+
+/**
+ * spu_req_incl_icv() - Return true if SPU request message should include the
+ * ICV as a separate buffer.
+ * @cipher_mode:  the cipher mode being requested
+ * @is_encrypt:   true if encrypting. false if decrypting.
+ *
+ * Return:  true if ICV to be included as separate buffer
+ */
+static __always_inline  bool spu_req_incl_icv(enum spu_cipher_mode cipher_mode,
+					      bool is_encrypt)
+{
+	if ((cipher_mode == CIPHER_MODE_GCM) && !is_encrypt)
+		return true;
+	if ((cipher_mode == CIPHER_MODE_CCM) && !is_encrypt)
+		return true;
+
+	return false;
+}
+
+static __always_inline u32 spu_real_db_size(u32 assoc_size,
+					    u32 aead_iv_buf_len,
+					    u32 prebuf_len,
+					    u32 data_size,
+					    u32 aad_pad_len,
+					    u32 gcm_pad_len,
+					    u32 hash_pad_len)
+{
+	return assoc_size + aead_iv_buf_len + prebuf_len + data_size +
+	    aad_pad_len + gcm_pad_len + hash_pad_len;
+}
+
+/************** SPU Functions Prototypes **************/
+
+void spum_dump_msg_hdr(u8 *buf, unsigned int buf_len);
+
+u32 spum_ns2_ctx_max_payload(enum spu_cipher_alg cipher_alg,
+			     enum spu_cipher_mode cipher_mode,
+			     unsigned int blocksize);
+u32 spum_nsp_ctx_max_payload(enum spu_cipher_alg cipher_alg,
+			     enum spu_cipher_mode cipher_mode,
+			     unsigned int blocksize);
+u32 spum_payload_length(u8 *spu_hdr);
+u16 spum_response_hdr_len(u16 auth_key_len, u16 enc_key_len, bool is_hash);
+u16 spum_hash_pad_len(enum hash_alg hash_alg, enum hash_mode hash_mode,
+		      u32 chunksize, u16 hash_block_size);
+u32 spum_gcm_ccm_pad_len(enum spu_cipher_mode cipher_mode,
+			 unsigned int data_size);
+u32 spum_assoc_resp_len(enum spu_cipher_mode cipher_mode,
+			unsigned int assoc_len, unsigned int iv_len,
+			bool is_encrypt);
+u8 spum_aead_ivlen(enum spu_cipher_mode cipher_mode, u16 iv_len);
+bool spu_req_incl_icv(enum spu_cipher_mode cipher_mode, bool is_encrypt);
+enum hash_type spum_hash_type(u32 src_sent);
+u32 spum_digest_size(u32 alg_digest_size, enum hash_alg alg,
+		     enum hash_type htype);
+
+u32 spum_create_request(u8 *spu_hdr,
+			struct spu_request_opts *req_opts,
+			struct spu_cipher_parms *cipher_parms,
+			struct spu_hash_parms *hash_parms,
+			struct spu_aead_parms *aead_parms,
+			unsigned int data_size);
+
+u16 spum_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms);
+
+void spum_cipher_req_finish(u8 *spu_hdr,
+			    u16 spu_req_hdr_len,
+			    unsigned int is_inbound,
+			    struct spu_cipher_parms *cipher_parms,
+			    bool update_key,
+			    unsigned int data_size);
+
+void spum_request_pad(u8 *pad_start,
+		      u32 gcm_padding,
+		      u32 hash_pad_len,
+		      enum hash_alg auth_alg,
+		      enum hash_mode auth_mode,
+		      unsigned int total_sent, u32 status_padding);
+
+u8 spum_xts_tweak_in_payload(void);
+u8 spum_tx_status_len(void);
+u8 spum_rx_status_len(void);
+int spum_status_process(u8 *statp);
+
+void spum_ccm_update_iv(unsigned int digestsize,
+			struct spu_cipher_parms *cipher_parms,
+			unsigned int assoclen,
+			unsigned int chunksize,
+			bool is_encrypt,
+			bool is_esp);
+u32 spum_wordalign_padlen(u32 data_size);
+#endif
diff --git a/drivers/crypto/bcm/spu2.c b/drivers/crypto/bcm/spu2.c
new file mode 100644
index 0000000..d7b44b6
--- /dev/null
+++ b/drivers/crypto/bcm/spu2.c
@@ -0,0 +1,1402 @@
+/*
+ * Copyright 2016 Broadcom
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation (the "GPL").
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 (GPLv2) for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 (GPLv2) along with this source code.
+ */
+
+/*
+ * This file works with the SPU2 version of the SPU. SPU2 has different message
+ * formats than the previous version of the SPU. All SPU message format
+ * differences should be hidden in the spux.c,h files.
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+
+#include "util.h"
+#include "spu.h"
+#include "spu2.h"
+
+#define SPU2_TX_STATUS_LEN  0	/* SPU2 has no STATUS in input packet */
+
+/*
+ * Controlled by pkt_stat_cnt field in CRYPTO_SS_SPU0_CORE_SPU2_CONTROL0
+ * register. Defaults to 2.
+ */
+#define SPU2_RX_STATUS_LEN  2
+
+enum spu2_proto_sel {
+	SPU2_PROTO_RESV = 0,
+	SPU2_MACSEC_SECTAG8_ECB = 1,
+	SPU2_MACSEC_SECTAG8_SCB = 2,
+	SPU2_MACSEC_SECTAG16 = 3,
+	SPU2_MACSEC_SECTAG16_8_XPN = 4,
+	SPU2_IPSEC = 5,
+	SPU2_IPSEC_ESN = 6,
+	SPU2_TLS_CIPHER = 7,
+	SPU2_TLS_AEAD = 8,
+	SPU2_DTLS_CIPHER = 9,
+	SPU2_DTLS_AEAD = 10
+};
+
+char *spu2_cipher_type_names[] = { "None", "AES128", "AES192", "AES256",
+	"DES", "3DES"
+};
+
+char *spu2_cipher_mode_names[] = { "ECB", "CBC", "CTR", "CFB", "OFB", "XTS",
+	"CCM", "GCM"
+};
+
+char *spu2_hash_type_names[] = { "None", "AES128", "AES192", "AES256",
+	"Reserved", "Reserved", "MD5", "SHA1", "SHA224", "SHA256", "SHA384",
+	"SHA512", "SHA512/224", "SHA512/256", "SHA3-224", "SHA3-256",
+	"SHA3-384", "SHA3-512"
+};
+
+char *spu2_hash_mode_names[] = { "CMAC", "CBC-MAC", "XCBC-MAC", "HMAC",
+	"Rabin", "CCM", "GCM", "Reserved"
+};
+
+static char *spu2_ciph_type_name(enum spu2_cipher_type cipher_type)
+{
+	if (cipher_type >= SPU2_CIPHER_TYPE_LAST)
+		return "Reserved";
+	return spu2_cipher_type_names[cipher_type];
+}
+
+static char *spu2_ciph_mode_name(enum spu2_cipher_mode cipher_mode)
+{
+	if (cipher_mode >= SPU2_CIPHER_MODE_LAST)
+		return "Reserved";
+	return spu2_cipher_mode_names[cipher_mode];
+}
+
+static char *spu2_hash_type_name(enum spu2_hash_type hash_type)
+{
+	if (hash_type >= SPU2_HASH_TYPE_LAST)
+		return "Reserved";
+	return spu2_hash_type_names[hash_type];
+}
+
+static char *spu2_hash_mode_name(enum spu2_hash_mode hash_mode)
+{
+	if (hash_mode >= SPU2_HASH_MODE_LAST)
+		return "Reserved";
+	return spu2_hash_mode_names[hash_mode];
+}
+
+/*
+ * Convert from a software cipher mode value to the corresponding value
+ * for SPU2.
+ */
+static int spu2_cipher_mode_xlate(enum spu_cipher_mode cipher_mode,
+				  enum spu2_cipher_mode *spu2_mode)
+{
+	switch (cipher_mode) {
+	case CIPHER_MODE_ECB:
+		*spu2_mode = SPU2_CIPHER_MODE_ECB;
+		break;
+	case CIPHER_MODE_CBC:
+		*spu2_mode = SPU2_CIPHER_MODE_CBC;
+		break;
+	case CIPHER_MODE_OFB:
+		*spu2_mode = SPU2_CIPHER_MODE_OFB;
+		break;
+	case CIPHER_MODE_CFB:
+		*spu2_mode = SPU2_CIPHER_MODE_CFB;
+		break;
+	case CIPHER_MODE_CTR:
+		*spu2_mode = SPU2_CIPHER_MODE_CTR;
+		break;
+	case CIPHER_MODE_CCM:
+		*spu2_mode = SPU2_CIPHER_MODE_CCM;
+		break;
+	case CIPHER_MODE_GCM:
+		*spu2_mode = SPU2_CIPHER_MODE_GCM;
+		break;
+	case CIPHER_MODE_XTS:
+		*spu2_mode = SPU2_CIPHER_MODE_XTS;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * spu2_cipher_xlate() - Convert a cipher {alg/mode/type} triple to a SPU2
+ * cipher type and mode.
+ * @cipher_alg:  [in]  cipher algorithm value from software enumeration
+ * @cipher_mode: [in]  cipher mode value from software enumeration
+ * @cipher_type: [in]  cipher type value from software enumeration
+ * @spu2_type:   [out] cipher type value used by spu2 hardware
+ * @spu2_mode:   [out] cipher mode value used by spu2 hardware
+ *
+ * Return:  0 if successful
+ */
+static int spu2_cipher_xlate(enum spu_cipher_alg cipher_alg,
+			     enum spu_cipher_mode cipher_mode,
+			     enum spu_cipher_type cipher_type,
+			     enum spu2_cipher_type *spu2_type,
+			     enum spu2_cipher_mode *spu2_mode)
+{
+	int err;
+
+	err = spu2_cipher_mode_xlate(cipher_mode, spu2_mode);
+	if (err) {
+		flow_log("Invalid cipher mode %d\n", cipher_mode);
+		return err;
+	}
+
+	switch (cipher_alg) {
+	case CIPHER_ALG_NONE:
+		*spu2_type = SPU2_CIPHER_TYPE_NONE;
+		break;
+	case CIPHER_ALG_RC4:
+		/* SPU2 does not support RC4 */
+		err = -EINVAL;
+		*spu2_type = SPU2_CIPHER_TYPE_NONE;
+		break;
+	case CIPHER_ALG_DES:
+		*spu2_type = SPU2_CIPHER_TYPE_DES;
+		break;
+	case CIPHER_ALG_3DES:
+		*spu2_type = SPU2_CIPHER_TYPE_3DES;
+		break;
+	case CIPHER_ALG_AES:
+		switch (cipher_type) {
+		case CIPHER_TYPE_AES128:
+			*spu2_type = SPU2_CIPHER_TYPE_AES128;
+			break;
+		case CIPHER_TYPE_AES192:
+			*spu2_type = SPU2_CIPHER_TYPE_AES192;
+			break;
+		case CIPHER_TYPE_AES256:
+			*spu2_type = SPU2_CIPHER_TYPE_AES256;
+			break;
+		default:
+			err = -EINVAL;
+		}
+		break;
+	case CIPHER_ALG_LAST:
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	if (err)
+		flow_log("Invalid cipher alg %d or type %d\n",
+			 cipher_alg, cipher_type);
+	return err;
+}
+
+/*
+ * Convert from a software hash mode value to the corresponding value
+ * for SPU2. Note that HASH_MODE_NONE and HASH_MODE_XCBC have the same value.
+ */
+static int spu2_hash_mode_xlate(enum hash_mode hash_mode,
+				enum spu2_hash_mode *spu2_mode)
+{
+	switch (hash_mode) {
+	case HASH_MODE_XCBC:
+		*spu2_mode = SPU2_HASH_MODE_XCBC_MAC;
+		break;
+	case HASH_MODE_CMAC:
+		*spu2_mode = SPU2_HASH_MODE_CMAC;
+		break;
+	case HASH_MODE_HMAC:
+		*spu2_mode = SPU2_HASH_MODE_HMAC;
+		break;
+	case HASH_MODE_CCM:
+		*spu2_mode = SPU2_HASH_MODE_CCM;
+		break;
+	case HASH_MODE_GCM:
+		*spu2_mode = SPU2_HASH_MODE_GCM;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * spu2_hash_xlate() - Convert a hash {alg/mode/type} triple to a SPU2 hash type
+ * and mode.
+ * @hash_alg:  [in] hash algorithm value from software enumeration
+ * @hash_mode: [in] hash mode value from software enumeration
+ * @hash_type: [in] hash type value from software enumeration
+ * @ciph_type: [in] cipher type value from software enumeration
+ * @spu2_type: [out] hash type value used by SPU2 hardware
+ * @spu2_mode: [out] hash mode value used by SPU2 hardware
+ *
+ * Return:  0 if successful
+ */
+static int
+spu2_hash_xlate(enum hash_alg hash_alg, enum hash_mode hash_mode,
+		enum hash_type hash_type, enum spu_cipher_type ciph_type,
+		enum spu2_hash_type *spu2_type, enum spu2_hash_mode *spu2_mode)
+{
+	int err;
+
+	err = spu2_hash_mode_xlate(hash_mode, spu2_mode);
+	if (err) {
+		flow_log("Invalid hash mode %d\n", hash_mode);
+		return err;
+	}
+
+	switch (hash_alg) {
+	case HASH_ALG_NONE:
+		*spu2_type = SPU2_HASH_TYPE_NONE;
+		break;
+	case HASH_ALG_MD5:
+		*spu2_type = SPU2_HASH_TYPE_MD5;
+		break;
+	case HASH_ALG_SHA1:
+		*spu2_type = SPU2_HASH_TYPE_SHA1;
+		break;
+	case HASH_ALG_SHA224:
+		*spu2_type = SPU2_HASH_TYPE_SHA224;
+		break;
+	case HASH_ALG_SHA256:
+		*spu2_type = SPU2_HASH_TYPE_SHA256;
+		break;
+	case HASH_ALG_SHA384:
+		*spu2_type = SPU2_HASH_TYPE_SHA384;
+		break;
+	case HASH_ALG_SHA512:
+		*spu2_type = SPU2_HASH_TYPE_SHA512;
+		break;
+	case HASH_ALG_AES:
+		switch (ciph_type) {
+		case CIPHER_TYPE_AES128:
+			*spu2_type = SPU2_HASH_TYPE_AES128;
+			break;
+		case CIPHER_TYPE_AES192:
+			*spu2_type = SPU2_HASH_TYPE_AES192;
+			break;
+		case CIPHER_TYPE_AES256:
+			*spu2_type = SPU2_HASH_TYPE_AES256;
+			break;
+		default:
+			err = -EINVAL;
+		}
+		break;
+	case HASH_ALG_SHA3_224:
+		*spu2_type = SPU2_HASH_TYPE_SHA3_224;
+		break;
+	case HASH_ALG_SHA3_256:
+		*spu2_type = SPU2_HASH_TYPE_SHA3_256;
+		break;
+	case HASH_ALG_SHA3_384:
+		*spu2_type = SPU2_HASH_TYPE_SHA3_384;
+		break;
+	case HASH_ALG_SHA3_512:
+		*spu2_type = SPU2_HASH_TYPE_SHA3_512;
+	case HASH_ALG_LAST:
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	if (err)
+		flow_log("Invalid hash alg %d or type %d\n",
+			 hash_alg, hash_type);
+	return err;
+}
+
+/* Dump FMD ctrl0. The ctrl0 input is in host byte order */
+static void spu2_dump_fmd_ctrl0(u64 ctrl0)
+{
+	enum spu2_cipher_type ciph_type;
+	enum spu2_cipher_mode ciph_mode;
+	enum spu2_hash_type hash_type;
+	enum spu2_hash_mode hash_mode;
+	char *ciph_name;
+	char *ciph_mode_name;
+	char *hash_name;
+	char *hash_mode_name;
+	u8 cfb;
+	u8 proto;
+
+	packet_log(" FMD CTRL0 %#16llx\n", ctrl0);
+	if (ctrl0 & SPU2_CIPH_ENCRYPT_EN)
+		packet_log("  encrypt\n");
+	else
+		packet_log("  decrypt\n");
+
+	ciph_type = (ctrl0 & SPU2_CIPH_TYPE) >> SPU2_CIPH_TYPE_SHIFT;
+	ciph_name = spu2_ciph_type_name(ciph_type);
+	packet_log("  Cipher type: %s\n", ciph_name);
+
+	if (ciph_type != SPU2_CIPHER_TYPE_NONE) {
+		ciph_mode = (ctrl0 & SPU2_CIPH_MODE) >> SPU2_CIPH_MODE_SHIFT;
+		ciph_mode_name = spu2_ciph_mode_name(ciph_mode);
+		packet_log("  Cipher mode: %s\n", ciph_mode_name);
+	}
+
+	cfb = (ctrl0 & SPU2_CFB_MASK) >> SPU2_CFB_MASK_SHIFT;
+	packet_log("  CFB %#x\n", cfb);
+
+	proto = (ctrl0 & SPU2_PROTO_SEL) >> SPU2_PROTO_SEL_SHIFT;
+	packet_log("  protocol %#x\n", proto);
+
+	if (ctrl0 & SPU2_HASH_FIRST)
+		packet_log("  hash first\n");
+	else
+		packet_log("  cipher first\n");
+
+	if (ctrl0 & SPU2_CHK_TAG)
+		packet_log("  check tag\n");
+
+	hash_type = (ctrl0 & SPU2_HASH_TYPE) >> SPU2_HASH_TYPE_SHIFT;
+	hash_name = spu2_hash_type_name(hash_type);
+	packet_log("  Hash type: %s\n", hash_name);
+
+	if (hash_type != SPU2_HASH_TYPE_NONE) {
+		hash_mode = (ctrl0 & SPU2_HASH_MODE) >> SPU2_HASH_MODE_SHIFT;
+		hash_mode_name = spu2_hash_mode_name(hash_mode);
+		packet_log("  Hash mode: %s\n", hash_mode_name);
+	}
+
+	if (ctrl0 & SPU2_CIPH_PAD_EN) {
+		packet_log("  Cipher pad: %#2llx\n",
+			   (ctrl0 & SPU2_CIPH_PAD) >> SPU2_CIPH_PAD_SHIFT);
+	}
+}
+
+/* Dump FMD ctrl1. The ctrl1 input is in host byte order */
+static void spu2_dump_fmd_ctrl1(u64 ctrl1)
+{
+	u8 hash_key_len;
+	u8 ciph_key_len;
+	u8 ret_iv_len;
+	u8 iv_offset;
+	u8 iv_len;
+	u8 hash_tag_len;
+	u8 ret_md;
+
+	packet_log(" FMD CTRL1 %#16llx\n", ctrl1);
+	if (ctrl1 & SPU2_TAG_LOC)
+		packet_log("  Tag after payload\n");
+
+	packet_log("  Msg includes ");
+	if (ctrl1 & SPU2_HAS_FR_DATA)
+		packet_log("FD ");
+	if (ctrl1 & SPU2_HAS_AAD1)
+		packet_log("AAD1 ");
+	if (ctrl1 & SPU2_HAS_NAAD)
+		packet_log("NAAD ");
+	if (ctrl1 & SPU2_HAS_AAD2)
+		packet_log("AAD2 ");
+	if (ctrl1 & SPU2_HAS_ESN)
+		packet_log("ESN ");
+	packet_log("\n");
+
+	hash_key_len = (ctrl1 & SPU2_HASH_KEY_LEN) >> SPU2_HASH_KEY_LEN_SHIFT;
+	packet_log("  Hash key len %u\n", hash_key_len);
+
+	ciph_key_len = (ctrl1 & SPU2_CIPH_KEY_LEN) >> SPU2_CIPH_KEY_LEN_SHIFT;
+	packet_log("  Cipher key len %u\n", ciph_key_len);
+
+	if (ctrl1 & SPU2_GENIV)
+		packet_log("  Generate IV\n");
+
+	if (ctrl1 & SPU2_HASH_IV)
+		packet_log("  IV included in hash\n");
+
+	if (ctrl1 & SPU2_RET_IV)
+		packet_log("  Return IV in output before payload\n");
+
+	ret_iv_len = (ctrl1 & SPU2_RET_IV_LEN) >> SPU2_RET_IV_LEN_SHIFT;
+	packet_log("  Length of returned IV %u bytes\n",
+		   ret_iv_len ? ret_iv_len : 16);
+
+	iv_offset = (ctrl1 & SPU2_IV_OFFSET) >> SPU2_IV_OFFSET_SHIFT;
+	packet_log("  IV offset %u\n", iv_offset);
+
+	iv_len = (ctrl1 & SPU2_IV_LEN) >> SPU2_IV_LEN_SHIFT;
+	packet_log("  Input IV len %u bytes\n", iv_len);
+
+	hash_tag_len = (ctrl1 & SPU2_HASH_TAG_LEN) >> SPU2_HASH_TAG_LEN_SHIFT;
+	packet_log("  Hash tag length %u bytes\n", hash_tag_len);
+
+	packet_log("  Return ");
+	ret_md = (ctrl1 & SPU2_RETURN_MD) >> SPU2_RETURN_MD_SHIFT;
+	if (ret_md)
+		packet_log("FMD ");
+	if (ret_md == SPU2_RET_FMD_OMD)
+		packet_log("OMD ");
+	else if (ret_md == SPU2_RET_FMD_OMD_IV)
+		packet_log("OMD IV ");
+	if (ctrl1 & SPU2_RETURN_FD)
+		packet_log("FD ");
+	if (ctrl1 & SPU2_RETURN_AAD1)
+		packet_log("AAD1 ");
+	if (ctrl1 & SPU2_RETURN_NAAD)
+		packet_log("NAAD ");
+	if (ctrl1 & SPU2_RETURN_AAD2)
+		packet_log("AAD2 ");
+	if (ctrl1 & SPU2_RETURN_PAY)
+		packet_log("Payload");
+	packet_log("\n");
+}
+
+/* Dump FMD ctrl2. The ctrl2 input is in host byte order */
+static void spu2_dump_fmd_ctrl2(u64 ctrl2)
+{
+	packet_log(" FMD CTRL2 %#16llx\n", ctrl2);
+
+	packet_log("  AAD1 offset %llu length %llu bytes\n",
+		   ctrl2 & SPU2_AAD1_OFFSET,
+		   (ctrl2 & SPU2_AAD1_LEN) >> SPU2_AAD1_LEN_SHIFT);
+	packet_log("  AAD2 offset %llu\n",
+		   (ctrl2 & SPU2_AAD2_OFFSET) >> SPU2_AAD2_OFFSET_SHIFT);
+	packet_log("  Payload offset %llu\n",
+		   (ctrl2 & SPU2_PL_OFFSET) >> SPU2_PL_OFFSET_SHIFT);
+}
+
+/* Dump FMD ctrl3. The ctrl3 input is in host byte order */
+static void spu2_dump_fmd_ctrl3(u64 ctrl3)
+{
+	packet_log(" FMD CTRL3 %#16llx\n", ctrl3);
+
+	packet_log("  Payload length %llu bytes\n", ctrl3 & SPU2_PL_LEN);
+	packet_log("  TLS length %llu bytes\n",
+		   (ctrl3 & SPU2_TLS_LEN) >> SPU2_TLS_LEN_SHIFT);
+}
+
+static void spu2_dump_fmd(struct SPU2_FMD *fmd)
+{
+	spu2_dump_fmd_ctrl0(le64_to_cpu(fmd->ctrl0));
+	spu2_dump_fmd_ctrl1(le64_to_cpu(fmd->ctrl1));
+	spu2_dump_fmd_ctrl2(le64_to_cpu(fmd->ctrl2));
+	spu2_dump_fmd_ctrl3(le64_to_cpu(fmd->ctrl3));
+}
+
+static void spu2_dump_omd(u8 *omd, u16 hash_key_len, u16 ciph_key_len,
+			  u16 hash_iv_len, u16 ciph_iv_len)
+{
+	u8 *ptr = omd;
+
+	packet_log(" OMD:\n");
+
+	if (hash_key_len) {
+		packet_log("  Hash Key Length %u bytes\n", hash_key_len);
+		packet_dump("  KEY: ", ptr, hash_key_len);
+		ptr += hash_key_len;
+	}
+
+	if (ciph_key_len) {
+		packet_log("  Cipher Key Length %u bytes\n", ciph_key_len);
+		packet_dump("  KEY: ", ptr, ciph_key_len);
+		ptr += ciph_key_len;
+	}
+
+	if (hash_iv_len) {
+		packet_log("  Hash IV Length %u bytes\n", hash_iv_len);
+		packet_dump("  hash IV: ", ptr, hash_iv_len);
+		ptr += ciph_key_len;
+	}
+
+	if (ciph_iv_len) {
+		packet_log("  Cipher IV Length %u bytes\n", ciph_iv_len);
+		packet_dump("  cipher IV: ", ptr, ciph_iv_len);
+	}
+}
+
+/* Dump a SPU2 header for debug */
+void spu2_dump_msg_hdr(u8 *buf, unsigned int buf_len)
+{
+	struct SPU2_FMD *fmd = (struct SPU2_FMD *)buf;
+	u8 *omd;
+	u64 ctrl1;
+	u16 hash_key_len;
+	u16 ciph_key_len;
+	u16 hash_iv_len;
+	u16 ciph_iv_len;
+	u16 omd_len;
+
+	packet_log("\n");
+	packet_log("SPU2 message header %p len: %u\n", buf, buf_len);
+
+	spu2_dump_fmd(fmd);
+	omd = (u8 *)(fmd + 1);
+
+	ctrl1 = le64_to_cpu(fmd->ctrl1);
+	hash_key_len = (ctrl1 & SPU2_HASH_KEY_LEN) >> SPU2_HASH_KEY_LEN_SHIFT;
+	ciph_key_len = (ctrl1 & SPU2_CIPH_KEY_LEN) >> SPU2_CIPH_KEY_LEN_SHIFT;
+	hash_iv_len = 0;
+	ciph_iv_len = (ctrl1 & SPU2_IV_LEN) >> SPU2_IV_LEN_SHIFT;
+	spu2_dump_omd(omd, hash_key_len, ciph_key_len, hash_iv_len,
+		      ciph_iv_len);
+
+	/* Double check sanity */
+	omd_len = hash_key_len + ciph_key_len + hash_iv_len + ciph_iv_len;
+	if (FMD_SIZE + omd_len != buf_len) {
+		packet_log
+		    (" Packet parsed incorrectly. buf_len %u, sum of MD %zu\n",
+		     buf_len, FMD_SIZE + omd_len);
+	}
+	packet_log("\n");
+}
+
+/**
+ * spu2_fmd_init() - At setkey time, initialize the fixed meta data for
+ * subsequent ablkcipher requests for this context.
+ * @spu2_cipher_type:  Cipher algorithm
+ * @spu2_mode:         Cipher mode
+ * @cipher_key_len:    Length of cipher key, in bytes
+ * @cipher_iv_len:     Length of cipher initialization vector, in bytes
+ *
+ * Return:  0 (success)
+ */
+static int spu2_fmd_init(struct SPU2_FMD *fmd,
+			 enum spu2_cipher_type spu2_type,
+			 enum spu2_cipher_mode spu2_mode,
+			 u32 cipher_key_len, u32 cipher_iv_len)
+{
+	u64 ctrl0;
+	u64 ctrl1;
+	u64 ctrl2;
+	u64 ctrl3;
+	u32 aad1_offset;
+	u32 aad2_offset;
+	u16 aad1_len = 0;
+	u64 payload_offset;
+
+	ctrl0 = (spu2_type << SPU2_CIPH_TYPE_SHIFT) |
+	    (spu2_mode << SPU2_CIPH_MODE_SHIFT);
+
+	ctrl1 = (cipher_key_len << SPU2_CIPH_KEY_LEN_SHIFT) |
+	    ((u64)cipher_iv_len << SPU2_IV_LEN_SHIFT) |
+	    ((u64)SPU2_RET_FMD_ONLY << SPU2_RETURN_MD_SHIFT) | SPU2_RETURN_PAY;
+
+	/*
+	 * AAD1 offset is from start of FD. FD length is always 0 for this
+	 * driver. So AAD1_offset is always 0.
+	 */
+	aad1_offset = 0;
+	aad2_offset = aad1_offset;
+	payload_offset = 0;
+	ctrl2 = aad1_offset |
+	    (aad1_len << SPU2_AAD1_LEN_SHIFT) |
+	    (aad2_offset << SPU2_AAD2_OFFSET_SHIFT) |
+	    (payload_offset << SPU2_PL_OFFSET_SHIFT);
+
+	ctrl3 = 0;
+
+	fmd->ctrl0 = cpu_to_le64(ctrl0);
+	fmd->ctrl1 = cpu_to_le64(ctrl1);
+	fmd->ctrl2 = cpu_to_le64(ctrl2);
+	fmd->ctrl3 = cpu_to_le64(ctrl3);
+
+	return 0;
+}
+
+/**
+ * spu2_fmd_ctrl0_write() - Write ctrl0 field in fixed metadata (FMD) field of
+ * SPU request packet.
+ * @fmd:            Start of FMD field to be written
+ * @is_inbound:     true if decrypting. false if encrypting.
+ * @authFirst:      true if alg authenticates before encrypting
+ * @protocol:       protocol selector
+ * @cipher_type:    cipher algorithm
+ * @cipher_mode:    cipher mode
+ * @auth_type:      authentication type
+ * @auth_mode:      authentication mode
+ */
+static void spu2_fmd_ctrl0_write(struct SPU2_FMD *fmd,
+				 bool is_inbound, bool auth_first,
+				 enum spu2_proto_sel protocol,
+				 enum spu2_cipher_type cipher_type,
+				 enum spu2_cipher_mode cipher_mode,
+				 enum spu2_hash_type auth_type,
+				 enum spu2_hash_mode auth_mode)
+{
+	u64 ctrl0 = 0;
+
+	if ((cipher_type != SPU2_CIPHER_TYPE_NONE) && !is_inbound)
+		ctrl0 |= SPU2_CIPH_ENCRYPT_EN;
+
+	ctrl0 |= ((u64)cipher_type << SPU2_CIPH_TYPE_SHIFT) |
+	    ((u64)cipher_mode << SPU2_CIPH_MODE_SHIFT);
+
+	if (protocol)
+		ctrl0 |= (u64)protocol << SPU2_PROTO_SEL_SHIFT;
+
+	if (auth_first)
+		ctrl0 |= SPU2_HASH_FIRST;
+
+	if (is_inbound && (auth_type != SPU2_HASH_TYPE_NONE))
+		ctrl0 |= SPU2_CHK_TAG;
+
+	ctrl0 |= (((u64)auth_type << SPU2_HASH_TYPE_SHIFT) |
+		  ((u64)auth_mode << SPU2_HASH_MODE_SHIFT));
+
+	fmd->ctrl0 = cpu_to_le64(ctrl0);
+}
+
+/**
+ * spu2_fmd_ctrl1_write() - Write ctrl1 field in fixed metadata (FMD) field of
+ * SPU request packet.
+ * @fmd:            Start of FMD field to be written
+ * @assoc_size:     Length of additional associated data, in bytes
+ * @auth_key_len:   Length of authentication key, in bytes
+ * @cipher_key_len: Length of cipher key, in bytes
+ * @gen_iv:         If true, hw generates IV and returns in response
+ * @hash_iv:        IV participates in hash. Used for IPSEC and TLS.
+ * @return_iv:      Return IV in output packet before payload
+ * @ret_iv_len:     Length of IV returned from SPU, in bytes
+ * @ret_iv_offset:  Offset into full IV of start of returned IV
+ * @cipher_iv_len:  Length of input cipher IV, in bytes
+ * @digest_size:    Length of digest (aka, hash tag or ICV), in bytes
+ * @return_payload: Return payload in SPU response
+ * @return_md : return metadata in SPU response
+ *
+ * Packet can have AAD2 w/o AAD1. For algorithms currently supported,
+ * associated data goes in AAD2.
+ */
+static void spu2_fmd_ctrl1_write(struct SPU2_FMD *fmd, bool is_inbound,
+				 u64 assoc_size,
+				 u64 auth_key_len, u64 cipher_key_len,
+				 bool gen_iv, bool hash_iv, bool return_iv,
+				 u64 ret_iv_len, u64 ret_iv_offset,
+				 u64 cipher_iv_len, u64 digest_size,
+				 bool return_payload, bool return_md)
+{
+	u64 ctrl1 = 0;
+
+	if (is_inbound && digest_size)
+		ctrl1 |= SPU2_TAG_LOC;
+
+	if (assoc_size) {
+		ctrl1 |= SPU2_HAS_AAD2;
+		ctrl1 |= SPU2_RETURN_AAD2;  /* need aad2 for gcm aes esp */
+	}
+
+	if (auth_key_len)
+		ctrl1 |= ((auth_key_len << SPU2_HASH_KEY_LEN_SHIFT) &
+			  SPU2_HASH_KEY_LEN);
+
+	if (cipher_key_len)
+		ctrl1 |= ((cipher_key_len << SPU2_CIPH_KEY_LEN_SHIFT) &
+			  SPU2_CIPH_KEY_LEN);
+
+	if (gen_iv)
+		ctrl1 |= SPU2_GENIV;
+
+	if (hash_iv)
+		ctrl1 |= SPU2_HASH_IV;
+
+	if (return_iv) {
+		ctrl1 |= SPU2_RET_IV;
+		ctrl1 |= ret_iv_len << SPU2_RET_IV_LEN_SHIFT;
+		ctrl1 |= ret_iv_offset << SPU2_IV_OFFSET_SHIFT;
+	}
+
+	ctrl1 |= ((cipher_iv_len << SPU2_IV_LEN_SHIFT) & SPU2_IV_LEN);
+
+	if (digest_size)
+		ctrl1 |= ((digest_size << SPU2_HASH_TAG_LEN_SHIFT) &
+			  SPU2_HASH_TAG_LEN);
+
+	/* Let's ask for the output pkt to include FMD, but don't need to
+	 * get keys and IVs back in OMD.
+	 */
+	if (return_md)
+		ctrl1 |= ((u64)SPU2_RET_FMD_ONLY << SPU2_RETURN_MD_SHIFT);
+	else
+		ctrl1 |= ((u64)SPU2_RET_NO_MD << SPU2_RETURN_MD_SHIFT);
+
+	/* Crypto API does not get assoc data back. So no need for AAD2. */
+
+	if (return_payload)
+		ctrl1 |= SPU2_RETURN_PAY;
+
+	fmd->ctrl1 = cpu_to_le64(ctrl1);
+}
+
+/**
+ * spu2_fmd_ctrl2_write() - Set the ctrl2 field in the fixed metadata field of
+ * SPU2 header.
+ * @fmd:            Start of FMD field to be written
+ * @cipher_offset:  Number of bytes from Start of Packet (end of FD field) where
+ *                  data to be encrypted or decrypted begins
+ * @auth_key_len:   Length of authentication key, in bytes
+ * @auth_iv_len:    Length of authentication initialization vector, in bytes
+ * @cipher_key_len: Length of cipher key, in bytes
+ * @cipher_iv_len:  Length of cipher IV, in bytes
+ */
+static void spu2_fmd_ctrl2_write(struct SPU2_FMD *fmd, u64 cipher_offset,
+				 u64 auth_key_len, u64 auth_iv_len,
+				 u64 cipher_key_len, u64 cipher_iv_len)
+{
+	u64 ctrl2;
+	u64 aad1_offset;
+	u64 aad2_offset;
+	u16 aad1_len = 0;
+	u64 payload_offset;
+
+	/* AAD1 offset is from start of FD. FD length always 0. */
+	aad1_offset = 0;
+
+	aad2_offset = aad1_offset;
+	payload_offset = cipher_offset;
+	ctrl2 = aad1_offset |
+	    (aad1_len << SPU2_AAD1_LEN_SHIFT) |
+	    (aad2_offset << SPU2_AAD2_OFFSET_SHIFT) |
+	    (payload_offset << SPU2_PL_OFFSET_SHIFT);
+
+	fmd->ctrl2 = cpu_to_le64(ctrl2);
+}
+
+/**
+ * spu2_fmd_ctrl3_write() - Set the ctrl3 field in FMD
+ * @fmd:          Fixed meta data. First field in SPU2 msg header.
+ * @payload_len:  Length of payload, in bytes
+ */
+static void spu2_fmd_ctrl3_write(struct SPU2_FMD *fmd, u64 payload_len)
+{
+	u64 ctrl3;
+
+	ctrl3 = payload_len & SPU2_PL_LEN;
+
+	fmd->ctrl3 = cpu_to_le64(ctrl3);
+}
+
+/**
+ * spu2_ctx_max_payload() - Determine the maximum length of the payload for a
+ * SPU message for a given cipher and hash alg context.
+ * @cipher_alg:		The cipher algorithm
+ * @cipher_mode:	The cipher mode
+ * @blocksize:		The size of a block of data for this algo
+ *
+ * For SPU2, the hardware generally ignores the PayloadLen field in ctrl3 of
+ * FMD and just keeps computing until it receives a DMA descriptor with the EOF
+ * flag set. So we consider the max payload to be infinite. AES CCM is an
+ * exception.
+ *
+ * Return: Max payload length in bytes
+ */
+u32 spu2_ctx_max_payload(enum spu_cipher_alg cipher_alg,
+			 enum spu_cipher_mode cipher_mode,
+			 unsigned int blocksize)
+{
+	if ((cipher_alg == CIPHER_ALG_AES) &&
+	    (cipher_mode == CIPHER_MODE_CCM)) {
+		u32 excess = SPU2_MAX_PAYLOAD % blocksize;
+
+		return SPU2_MAX_PAYLOAD - excess;
+	} else {
+		return SPU_MAX_PAYLOAD_INF;
+	}
+}
+
+/**
+ * spu_payload_length() -  Given a SPU2 message header, extract the payload
+ * length.
+ * @spu_hdr:  Start of SPU message header (FMD)
+ *
+ * Return: payload length, in bytes
+ */
+u32 spu2_payload_length(u8 *spu_hdr)
+{
+	struct SPU2_FMD *fmd = (struct SPU2_FMD *)spu_hdr;
+	u32 pl_len;
+	u64 ctrl3;
+
+	ctrl3 = le64_to_cpu(fmd->ctrl3);
+	pl_len = ctrl3 & SPU2_PL_LEN;
+
+	return pl_len;
+}
+
+/**
+ * spu_response_hdr_len() - Determine the expected length of a SPU response
+ * header.
+ * @auth_key_len:  Length of authentication key, in bytes
+ * @enc_key_len:   Length of encryption key, in bytes
+ *
+ * For SPU2, includes just FMD. OMD is never requested.
+ *
+ * Return: Length of FMD, in bytes
+ */
+u16 spu2_response_hdr_len(u16 auth_key_len, u16 enc_key_len, bool is_hash)
+{
+	return FMD_SIZE;
+}
+
+/**
+ * spu_hash_pad_len() - Calculate the length of hash padding required to extend
+ * data to a full block size.
+ * @hash_alg:        hash algorithm
+ * @hash_mode:       hash mode
+ * @chunksize:       length of data, in bytes
+ * @hash_block_size: size of a hash block, in bytes
+ *
+ * SPU2 hardware does all hash padding
+ *
+ * Return:  length of hash pad in bytes
+ */
+u16 spu2_hash_pad_len(enum hash_alg hash_alg, enum hash_mode hash_mode,
+		      u32 chunksize, u16 hash_block_size)
+{
+	return 0;
+}
+
+/**
+ * spu2_gcm_ccm_padlen() -  Determine the length of GCM/CCM padding for either
+ * the AAD field or the data.
+ *
+ * Return:  0. Unlike SPU-M, SPU2 hardware does any GCM/CCM padding required.
+ */
+u32 spu2_gcm_ccm_pad_len(enum spu_cipher_mode cipher_mode,
+			 unsigned int data_size)
+{
+	return 0;
+}
+
+/**
+ * spu_assoc_resp_len() - Determine the size of the AAD2 buffer needed to catch
+ * associated data in a SPU2 output packet.
+ * @cipher_mode:   cipher mode
+ * @assoc_len:     length of additional associated data, in bytes
+ * @iv_len:        length of initialization vector, in bytes
+ * @is_encrypt:    true if encrypting. false if decrypt.
+ *
+ * Return: Length of buffer to catch associated data in response
+ */
+u32 spu2_assoc_resp_len(enum spu_cipher_mode cipher_mode,
+			unsigned int assoc_len, unsigned int iv_len,
+			bool is_encrypt)
+{
+	u32 resp_len = assoc_len;
+
+	if (is_encrypt)
+		/* gcm aes esp has to write 8-byte IV in response */
+		resp_len += iv_len;
+	return resp_len;
+}
+
+/*
+ * spu_aead_ivlen() - Calculate the length of the AEAD IV to be included
+ * in a SPU request after the AAD and before the payload.
+ * @cipher_mode:  cipher mode
+ * @iv_ctr_len:   initialization vector length in bytes
+ *
+ * For SPU2, AEAD IV is included in OMD and does not need to be repeated
+ * prior to the payload.
+ *
+ * Return: Length of AEAD IV in bytes
+ */
+u8 spu2_aead_ivlen(enum spu_cipher_mode cipher_mode, u16 iv_len)
+{
+	return 0;
+}
+
+/**
+ * spu2_hash_type() - Determine the type of hash operation.
+ * @src_sent:  The number of bytes in the current request that have already
+ *             been sent to the SPU to be hashed.
+ *
+ * SPU2 always does a FULL hash operation
+ */
+enum hash_type spu2_hash_type(u32 src_sent)
+{
+	return HASH_TYPE_FULL;
+}
+
+/**
+ * spu2_digest_size() - Determine the size of a hash digest to expect the SPU to
+ * return.
+ * alg_digest_size: Number of bytes in the final digest for the given algo
+ * alg:             The hash algorithm
+ * htype:           Type of hash operation (init, update, full, etc)
+ *
+ */
+u32 spu2_digest_size(u32 alg_digest_size, enum hash_alg alg,
+		     enum hash_type htype)
+{
+	return alg_digest_size;
+}
+
+/**
+ * spu_create_request() - Build a SPU2 request message header, includint FMD and
+ * OMD.
+ * @spu_hdr: Start of buffer where SPU request header is to be written
+ * @req_opts: SPU request message options
+ * @cipher_parms: Parameters related to cipher algorithm
+ * @hash_parms:   Parameters related to hash algorithm
+ * @aead_parms:   Parameters related to AEAD operation
+ * @data_size:    Length of data to be encrypted or authenticated. If AEAD, does
+ *		  not include length of AAD.
+ *
+ * Construct the message starting at spu_hdr. Caller should allocate this buffer
+ * in DMA-able memory at least SPU_HEADER_ALLOC_LEN bytes long.
+ *
+ * Return: the length of the SPU header in bytes. 0 if an error occurs.
+ */
+u32 spu2_create_request(u8 *spu_hdr,
+			struct spu_request_opts *req_opts,
+			struct spu_cipher_parms *cipher_parms,
+			struct spu_hash_parms *hash_parms,
+			struct spu_aead_parms *aead_parms,
+			unsigned int data_size)
+{
+	struct SPU2_FMD *fmd;
+	u8 *ptr;
+	unsigned int buf_len;
+	int err;
+	enum spu2_cipher_type spu2_ciph_type = SPU2_CIPHER_TYPE_NONE;
+	enum spu2_cipher_mode spu2_ciph_mode;
+	enum spu2_hash_type spu2_auth_type = SPU2_HASH_TYPE_NONE;
+	enum spu2_hash_mode spu2_auth_mode;
+	bool return_md = true;
+	enum spu2_proto_sel proto = SPU2_PROTO_RESV;
+
+	/* size of the payload */
+	unsigned int payload_len =
+	    hash_parms->prebuf_len + data_size + hash_parms->pad_len -
+	    ((req_opts->is_aead && req_opts->is_inbound) ?
+	     hash_parms->digestsize : 0);
+
+	/* offset of prebuf or data from start of AAD2 */
+	unsigned int cipher_offset = aead_parms->assoc_size +
+			aead_parms->aad_pad_len + aead_parms->iv_len;
+
+#ifdef DEBUG
+	/* total size of the data following OMD (without STAT word padding) */
+	unsigned int real_db_size = spu_real_db_size(aead_parms->assoc_size,
+						 aead_parms->iv_len,
+						 hash_parms->prebuf_len,
+						 data_size,
+						 aead_parms->aad_pad_len,
+						 aead_parms->data_pad_len,
+						 hash_parms->pad_len);
+#endif
+	unsigned int assoc_size = aead_parms->assoc_size;
+
+	if (req_opts->is_aead &&
+	    (cipher_parms->alg == CIPHER_ALG_AES) &&
+	    (cipher_parms->mode == CIPHER_MODE_GCM))
+		/*
+		 * On SPU 2, aes gcm cipher first on encrypt, auth first on
+		 * decrypt
+		 */
+		req_opts->auth_first = req_opts->is_inbound;
+
+	/* and do opposite for ccm (auth 1st on encrypt) */
+	if (req_opts->is_aead &&
+	    (cipher_parms->alg == CIPHER_ALG_AES) &&
+	    (cipher_parms->mode == CIPHER_MODE_CCM))
+		req_opts->auth_first = !req_opts->is_inbound;
+
+	flow_log("%s()\n", __func__);
+	flow_log("  in:%u authFirst:%u\n",
+		 req_opts->is_inbound, req_opts->auth_first);
+	flow_log("  cipher alg:%u mode:%u type %u\n", cipher_parms->alg,
+		 cipher_parms->mode, cipher_parms->type);
+	flow_log("  is_esp: %s\n", req_opts->is_esp ? "yes" : "no");
+	flow_log("    key: %d\n", cipher_parms->key_len);
+	flow_dump("    key: ", cipher_parms->key_buf, cipher_parms->key_len);
+	flow_log("    iv: %d\n", cipher_parms->iv_len);
+	flow_dump("    iv: ", cipher_parms->iv_buf, cipher_parms->iv_len);
+	flow_log("  auth alg:%u mode:%u type %u\n",
+		 hash_parms->alg, hash_parms->mode, hash_parms->type);
+	flow_log("  digestsize: %u\n", hash_parms->digestsize);
+	flow_log("  authkey: %d\n", hash_parms->key_len);
+	flow_dump("  authkey: ", hash_parms->key_buf, hash_parms->key_len);
+	flow_log("  assoc_size:%u\n", assoc_size);
+	flow_log("  prebuf_len:%u\n", hash_parms->prebuf_len);
+	flow_log("  data_size:%u\n", data_size);
+	flow_log("  hash_pad_len:%u\n", hash_parms->pad_len);
+	flow_log("  real_db_size:%u\n", real_db_size);
+	flow_log("  cipher_offset:%u payload_len:%u\n",
+		 cipher_offset, payload_len);
+	flow_log("  hmac_offset:%u\n", hash_parms->hmac_offset);
+	flow_log("  aead_iv: %u\n", aead_parms->iv_len);
+
+	/* Convert to spu2 values for cipher alg, hash alg */
+	err = spu2_cipher_xlate(cipher_parms->alg, cipher_parms->mode,
+				cipher_parms->type,
+				&spu2_ciph_type, &spu2_ciph_mode);
+
+	/* If we are doing GCM hashing only - either via rfc4543 transform
+	 * or because we happen to do GCM with AAD only and no payload - we
+	 * need to configure hardware to use hash key rather than cipher key
+	 * and put data into payload.  This is because unlike SPU-M, running
+	 * GCM cipher with 0 size payload is not permitted.
+	 */
+	if ((req_opts->is_rfc4543) ||
+	    ((spu2_ciph_mode == SPU2_CIPHER_MODE_GCM) &&
+	    (payload_len == 0))) {
+		/* Use hashing (only) and set up hash key */
+		spu2_ciph_type = SPU2_CIPHER_TYPE_NONE;
+		hash_parms->key_len = cipher_parms->key_len;
+		memcpy(hash_parms->key_buf, cipher_parms->key_buf,
+		       cipher_parms->key_len);
+		cipher_parms->key_len = 0;
+
+		if (req_opts->is_rfc4543)
+			payload_len += assoc_size;
+		else
+			payload_len = assoc_size;
+		cipher_offset = 0;
+		assoc_size = 0;
+	}
+
+	if (err)
+		return 0;
+
+	flow_log("spu2 cipher type %s, cipher mode %s\n",
+		 spu2_ciph_type_name(spu2_ciph_type),
+		 spu2_ciph_mode_name(spu2_ciph_mode));
+
+	err = spu2_hash_xlate(hash_parms->alg, hash_parms->mode,
+			      hash_parms->type,
+			      cipher_parms->type,
+			      &spu2_auth_type, &spu2_auth_mode);
+	if (err)
+		return 0;
+
+	flow_log("spu2 hash type %s, hash mode %s\n",
+		 spu2_hash_type_name(spu2_auth_type),
+		 spu2_hash_mode_name(spu2_auth_mode));
+
+	fmd = (struct SPU2_FMD *)spu_hdr;
+
+	spu2_fmd_ctrl0_write(fmd, req_opts->is_inbound, req_opts->auth_first,
+			     proto, spu2_ciph_type, spu2_ciph_mode,
+			     spu2_auth_type, spu2_auth_mode);
+
+	spu2_fmd_ctrl1_write(fmd, req_opts->is_inbound, assoc_size,
+			     hash_parms->key_len, cipher_parms->key_len,
+			     false, false,
+			     aead_parms->return_iv, aead_parms->ret_iv_len,
+			     aead_parms->ret_iv_off,
+			     cipher_parms->iv_len, hash_parms->digestsize,
+			     !req_opts->bd_suppress, return_md);
+
+	spu2_fmd_ctrl2_write(fmd, cipher_offset, hash_parms->key_len, 0,
+			     cipher_parms->key_len, cipher_parms->iv_len);
+
+	spu2_fmd_ctrl3_write(fmd, payload_len);
+
+	ptr = (u8 *)(fmd + 1);
+	buf_len = sizeof(struct SPU2_FMD);
+
+	/* Write OMD */
+	if (hash_parms->key_len) {
+		memcpy(ptr, hash_parms->key_buf, hash_parms->key_len);
+		ptr += hash_parms->key_len;
+		buf_len += hash_parms->key_len;
+	}
+	if (cipher_parms->key_len) {
+		memcpy(ptr, cipher_parms->key_buf, cipher_parms->key_len);
+		ptr += cipher_parms->key_len;
+		buf_len += cipher_parms->key_len;
+	}
+	if (cipher_parms->iv_len) {
+		memcpy(ptr, cipher_parms->iv_buf, cipher_parms->iv_len);
+		ptr += cipher_parms->iv_len;
+		buf_len += cipher_parms->iv_len;
+	}
+
+	packet_dump("  SPU request header: ", spu_hdr, buf_len);
+
+	return buf_len;
+}
+
+/**
+ * spu_cipher_req_init() - Build an ablkcipher SPU2 request message header,
+ * including FMD and OMD.
+ * @spu_hdr:       Location of start of SPU request (FMD field)
+ * @cipher_parms:  Parameters describing cipher request
+ *
+ * Called at setkey time to initialize a msg header that can be reused for all
+ * subsequent ablkcipher requests. Construct the message starting at spu_hdr.
+ * Caller should allocate this buffer in DMA-able memory at least
+ * SPU_HEADER_ALLOC_LEN bytes long.
+ *
+ * Return: the total length of the SPU header (FMD and OMD) in bytes. 0 if an
+ * error occurs.
+ */
+u16 spu2_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms)
+{
+	struct SPU2_FMD *fmd;
+	u8 *omd;
+	enum spu2_cipher_type spu2_type = SPU2_CIPHER_TYPE_NONE;
+	enum spu2_cipher_mode spu2_mode;
+	int err;
+
+	flow_log("%s()\n", __func__);
+	flow_log("  cipher alg:%u mode:%u type %u\n", cipher_parms->alg,
+		 cipher_parms->mode, cipher_parms->type);
+	flow_log("  cipher_iv_len: %u\n", cipher_parms->iv_len);
+	flow_log("    key: %d\n", cipher_parms->key_len);
+	flow_dump("    key: ", cipher_parms->key_buf, cipher_parms->key_len);
+
+	/* Convert to spu2 values */
+	err = spu2_cipher_xlate(cipher_parms->alg, cipher_parms->mode,
+				cipher_parms->type, &spu2_type, &spu2_mode);
+	if (err)
+		return 0;
+
+	flow_log("spu2 cipher type %s, cipher mode %s\n",
+		 spu2_ciph_type_name(spu2_type),
+		 spu2_ciph_mode_name(spu2_mode));
+
+	/* Construct the FMD header */
+	fmd = (struct SPU2_FMD *)spu_hdr;
+	err = spu2_fmd_init(fmd, spu2_type, spu2_mode, cipher_parms->key_len,
+			    cipher_parms->iv_len);
+	if (err)
+		return 0;
+
+	/* Write cipher key to OMD */
+	omd = (u8 *)(fmd + 1);
+	if (cipher_parms->key_buf && cipher_parms->key_len)
+		memcpy(omd, cipher_parms->key_buf, cipher_parms->key_len);
+
+	packet_dump("  SPU request header: ", spu_hdr,
+		    FMD_SIZE + cipher_parms->key_len + cipher_parms->iv_len);
+
+	return FMD_SIZE + cipher_parms->key_len + cipher_parms->iv_len;
+}
+
+/**
+ * spu_cipher_req_finish() - Finish building a SPU request message header for a
+ * block cipher request.
+ * @spu_hdr:         Start of the request message header (MH field)
+ * @spu_req_hdr_len: Length in bytes of the SPU request header
+ * @isInbound:       0 encrypt, 1 decrypt
+ * @cipher_parms:    Parameters describing cipher operation to be performed
+ * @update_key:      If true, rewrite the cipher key in SCTX
+ * @data_size:       Length of the data in the BD field
+ *
+ * Assumes much of the header was already filled in at setkey() time in
+ * spu_cipher_req_init().
+ * spu_cipher_req_init() fills in the encryption key. For RC4, when submitting a
+ * request for a non-first chunk, we use the 260-byte SUPDT field from the
+ * previous response as the key. update_key is true for this case. Unused in all
+ * other cases.
+ */
+void spu2_cipher_req_finish(u8 *spu_hdr,
+			    u16 spu_req_hdr_len,
+			    unsigned int is_inbound,
+			    struct spu_cipher_parms *cipher_parms,
+			    bool update_key,
+			    unsigned int data_size)
+{
+	struct SPU2_FMD *fmd;
+	u8 *omd;		/* start of optional metadata */
+	u64 ctrl0;
+	u64 ctrl3;
+
+	flow_log("%s()\n", __func__);
+	flow_log(" in: %u\n", is_inbound);
+	flow_log(" cipher alg: %u, cipher_type: %u\n", cipher_parms->alg,
+		 cipher_parms->type);
+	if (update_key) {
+		flow_log(" cipher key len: %u\n", cipher_parms->key_len);
+		flow_dump("  key: ", cipher_parms->key_buf,
+			  cipher_parms->key_len);
+	}
+	flow_log(" iv len: %d\n", cipher_parms->iv_len);
+	flow_dump("    iv: ", cipher_parms->iv_buf, cipher_parms->iv_len);
+	flow_log(" data_size: %u\n", data_size);
+
+	fmd = (struct SPU2_FMD *)spu_hdr;
+	omd = (u8 *)(fmd + 1);
+
+	/*
+	 * FMD ctrl0 was initialized at setkey time. update it to indicate
+	 * whether we are encrypting or decrypting.
+	 */
+	ctrl0 = le64_to_cpu(fmd->ctrl0);
+	if (is_inbound)
+		ctrl0 &= ~SPU2_CIPH_ENCRYPT_EN;	/* decrypt */
+	else
+		ctrl0 |= SPU2_CIPH_ENCRYPT_EN;	/* encrypt */
+	fmd->ctrl0 = cpu_to_le64(ctrl0);
+
+	if (cipher_parms->alg && cipher_parms->iv_buf && cipher_parms->iv_len) {
+		/* cipher iv provided so put it in here */
+		memcpy(omd + cipher_parms->key_len, cipher_parms->iv_buf,
+		       cipher_parms->iv_len);
+	}
+
+	ctrl3 = le64_to_cpu(fmd->ctrl3);
+	data_size &= SPU2_PL_LEN;
+	ctrl3 |= data_size;
+	fmd->ctrl3 = cpu_to_le64(ctrl3);
+
+	packet_dump("  SPU request header: ", spu_hdr, spu_req_hdr_len);
+}
+
+/**
+ * spu_request_pad() - Create pad bytes at the end of the data.
+ * @pad_start:      Start of buffer where pad bytes are to be written
+ * @gcm_padding:    Length of GCM padding, in bytes
+ * @hash_pad_len:   Number of bytes of padding extend data to full block
+ * @auth_alg:       Authentication algorithm
+ * @auth_mode:      Authentication mode
+ * @total_sent:     Length inserted at end of hash pad
+ * @status_padding: Number of bytes of padding to align STATUS word
+ *
+ * There may be three forms of pad:
+ *  1. GCM pad - for GCM mode ciphers, pad to 16-byte alignment
+ *  2. hash pad - pad to a block length, with 0x80 data terminator and
+ *                size at the end
+ *  3. STAT pad - to ensure the STAT field is 4-byte aligned
+ */
+void spu2_request_pad(u8 *pad_start, u32 gcm_padding, u32 hash_pad_len,
+		      enum hash_alg auth_alg, enum hash_mode auth_mode,
+		      unsigned int total_sent, u32 status_padding)
+{
+	u8 *ptr = pad_start;
+
+	/* fix data alignent for GCM */
+	if (gcm_padding > 0) {
+		flow_log("  GCM: padding to 16 byte alignment: %u bytes\n",
+			 gcm_padding);
+		memset(ptr, 0, gcm_padding);
+		ptr += gcm_padding;
+	}
+
+	if (hash_pad_len > 0) {
+		/* clear the padding section */
+		memset(ptr, 0, hash_pad_len);
+
+		/* terminate the data */
+		*ptr = 0x80;
+		ptr += (hash_pad_len - sizeof(u64));
+
+		/* add the size at the end as required per alg */
+		if (auth_alg == HASH_ALG_MD5)
+			*(u64 *)ptr = cpu_to_le64((u64)total_sent * 8);
+		else		/* SHA1, SHA2-224, SHA2-256 */
+			*(u64 *)ptr = cpu_to_be64((u64)total_sent * 8);
+		ptr += sizeof(u64);
+	}
+
+	/* pad to a 4byte alignment for STAT */
+	if (status_padding > 0) {
+		flow_log("  STAT: padding to 4 byte alignment: %u bytes\n",
+			 status_padding);
+
+		memset(ptr, 0, status_padding);
+		ptr += status_padding;
+	}
+}
+
+/**
+ * spu2_xts_tweak_in_payload() - Indicate that SPU2 does NOT place the XTS
+ * tweak field in the packet payload (it uses IV instead)
+ *
+ * Return: 0
+ */
+u8 spu2_xts_tweak_in_payload(void)
+{
+	return 0;
+}
+
+/**
+ * spu2_tx_status_len() - Return the length of the STATUS field in a SPU
+ * response message.
+ *
+ * Return: Length of STATUS field in bytes.
+ */
+u8 spu2_tx_status_len(void)
+{
+	return SPU2_TX_STATUS_LEN;
+}
+
+/**
+ * spu2_rx_status_len() - Return the length of the STATUS field in a SPU
+ * response message.
+ *
+ * Return: Length of STATUS field in bytes.
+ */
+u8 spu2_rx_status_len(void)
+{
+	return SPU2_RX_STATUS_LEN;
+}
+
+/**
+ * spu_status_process() - Process the status from a SPU response message.
+ * @statp:  start of STATUS word
+ *
+ * Return:  0 - if status is good and response should be processed
+ *         !0 - status indicates an error and response is invalid
+ */
+int spu2_status_process(u8 *statp)
+{
+	/* SPU2 status is 2 bytes by default - SPU_RX_STATUS_LEN */
+	u16 status = le16_to_cpu(*(__le16 *)statp);
+
+	if (status == 0)
+		return 0;
+
+	flow_log("rx status is %#x\n", status);
+	if (status == SPU2_INVALID_ICV)
+		return SPU_INVALID_ICV;
+
+	return -EBADMSG;
+}
+
+/**
+ * spu2_ccm_update_iv() - Update the IV as per the requirements for CCM mode.
+ *
+ * @digestsize:		Digest size of this request
+ * @cipher_parms:	(pointer to) cipher parmaeters, includes IV buf & IV len
+ * @assoclen:		Length of AAD data
+ * @chunksize:		length of input data to be sent in this req
+ * @is_encrypt:		true if this is an output/encrypt operation
+ * @is_esp:		true if this is an ESP / RFC4309 operation
+ *
+ */
+void spu2_ccm_update_iv(unsigned int digestsize,
+			struct spu_cipher_parms *cipher_parms,
+			unsigned int assoclen, unsigned int chunksize,
+			bool is_encrypt, bool is_esp)
+{
+	int L;  /* size of length field, in bytes */
+
+	/*
+	 * In RFC4309 mode, L is fixed at 4 bytes; otherwise, IV from
+	 * testmgr contains (L-1) in bottom 3 bits of first byte,
+	 * per RFC 3610.
+	 */
+	if (is_esp)
+		L = CCM_ESP_L_VALUE;
+	else
+		L = ((cipher_parms->iv_buf[0] & CCM_B0_L_PRIME) >>
+		      CCM_B0_L_PRIME_SHIFT) + 1;
+
+	/* SPU2 doesn't want these length bytes nor the first byte... */
+	cipher_parms->iv_len -= (1 + L);
+	memmove(cipher_parms->iv_buf, &cipher_parms->iv_buf[1],
+		cipher_parms->iv_len);
+}
+
+/**
+ * spu2_wordalign_padlen() - SPU2 does not require padding.
+ * @data_size: length of data field in bytes
+ *
+ * Return: length of status field padding, in bytes (always 0 on SPU2)
+ */
+u32 spu2_wordalign_padlen(u32 data_size)
+{
+	return 0;
+}
diff --git a/drivers/crypto/bcm/spu2.h b/drivers/crypto/bcm/spu2.h
new file mode 100644
index 0000000..ab1f599
--- /dev/null
+++ b/drivers/crypto/bcm/spu2.h
@@ -0,0 +1,228 @@
+/*
+ * Copyright 2016 Broadcom
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation (the "GPL").
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 (GPLv2) for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 (GPLv2) along with this source code.
+ */
+
+/*
+ * This file contains SPU message definitions specific to SPU2.
+ */
+
+#ifndef _SPU2_H
+#define _SPU2_H
+
+enum spu2_cipher_type {
+	SPU2_CIPHER_TYPE_NONE = 0x0,
+	SPU2_CIPHER_TYPE_AES128 = 0x1,
+	SPU2_CIPHER_TYPE_AES192 = 0x2,
+	SPU2_CIPHER_TYPE_AES256 = 0x3,
+	SPU2_CIPHER_TYPE_DES = 0x4,
+	SPU2_CIPHER_TYPE_3DES = 0x5,
+	SPU2_CIPHER_TYPE_LAST
+};
+
+enum spu2_cipher_mode {
+	SPU2_CIPHER_MODE_ECB = 0x0,
+	SPU2_CIPHER_MODE_CBC = 0x1,
+	SPU2_CIPHER_MODE_CTR = 0x2,
+	SPU2_CIPHER_MODE_CFB = 0x3,
+	SPU2_CIPHER_MODE_OFB = 0x4,
+	SPU2_CIPHER_MODE_XTS = 0x5,
+	SPU2_CIPHER_MODE_CCM = 0x6,
+	SPU2_CIPHER_MODE_GCM = 0x7,
+	SPU2_CIPHER_MODE_LAST
+};
+
+enum spu2_hash_type {
+	SPU2_HASH_TYPE_NONE = 0x0,
+	SPU2_HASH_TYPE_AES128 = 0x1,
+	SPU2_HASH_TYPE_AES192 = 0x2,
+	SPU2_HASH_TYPE_AES256 = 0x3,
+	SPU2_HASH_TYPE_MD5 = 0x6,
+	SPU2_HASH_TYPE_SHA1 = 0x7,
+	SPU2_HASH_TYPE_SHA224 = 0x8,
+	SPU2_HASH_TYPE_SHA256 = 0x9,
+	SPU2_HASH_TYPE_SHA384 = 0xa,
+	SPU2_HASH_TYPE_SHA512 = 0xb,
+	SPU2_HASH_TYPE_SHA512_224 = 0xc,
+	SPU2_HASH_TYPE_SHA512_256 = 0xd,
+	SPU2_HASH_TYPE_SHA3_224 = 0xe,
+	SPU2_HASH_TYPE_SHA3_256 = 0xf,
+	SPU2_HASH_TYPE_SHA3_384 = 0x10,
+	SPU2_HASH_TYPE_SHA3_512 = 0x11,
+	SPU2_HASH_TYPE_LAST
+};
+
+enum spu2_hash_mode {
+	SPU2_HASH_MODE_CMAC = 0x0,
+	SPU2_HASH_MODE_CBC_MAC = 0x1,
+	SPU2_HASH_MODE_XCBC_MAC = 0x2,
+	SPU2_HASH_MODE_HMAC = 0x3,
+	SPU2_HASH_MODE_RABIN = 0x4,
+	SPU2_HASH_MODE_CCM = 0x5,
+	SPU2_HASH_MODE_GCM = 0x6,
+	SPU2_HASH_MODE_RESERVED = 0x7,
+	SPU2_HASH_MODE_LAST
+};
+
+enum spu2_ret_md_opts {
+	SPU2_RET_NO_MD = 0,	/* return no metadata */
+	SPU2_RET_FMD_OMD = 1,	/* return both FMD and OMD */
+	SPU2_RET_FMD_ONLY = 2,	/* return only FMD */
+	SPU2_RET_FMD_OMD_IV = 3,	/* return FMD and OMD with just IVs */
+};
+
+/* Fixed Metadata format */
+struct SPU2_FMD {
+	u64 ctrl0;
+	u64 ctrl1;
+	u64 ctrl2;
+	u64 ctrl3;
+};
+
+#define FMD_SIZE  sizeof(struct SPU2_FMD)
+
+/* Fixed part of request message header length in bytes. Just FMD. */
+#define SPU2_REQ_FIXED_LEN FMD_SIZE
+#define SPU2_HEADER_ALLOC_LEN (SPU_REQ_FIXED_LEN + \
+				2 * MAX_KEY_SIZE + 2 * MAX_IV_SIZE)
+
+/* FMD ctrl0 field masks */
+#define SPU2_CIPH_ENCRYPT_EN            0x1 /* 0: decrypt, 1: encrypt */
+#define SPU2_CIPH_TYPE                 0xF0 /* one of spu2_cipher_type */
+#define SPU2_CIPH_TYPE_SHIFT              4
+#define SPU2_CIPH_MODE                0xF00 /* one of spu2_cipher_mode */
+#define SPU2_CIPH_MODE_SHIFT              8
+#define SPU2_CFB_MASK                0x7000 /* cipher feedback mask */
+#define SPU2_CFB_MASK_SHIFT              12
+#define SPU2_PROTO_SEL             0xF00000 /* MACsec, IPsec, TLS... */
+#define SPU2_PROTO_SEL_SHIFT             20
+#define SPU2_HASH_FIRST           0x1000000 /* 1: hash input is input pkt
+					     * data
+					     */
+#define SPU2_CHK_TAG              0x2000000 /* 1: check digest provided */
+#define SPU2_HASH_TYPE          0x1F0000000 /* one of spu2_hash_type */
+#define SPU2_HASH_TYPE_SHIFT             28
+#define SPU2_HASH_MODE         0xF000000000 /* one of spu2_hash_mode */
+#define SPU2_HASH_MODE_SHIFT             36
+#define SPU2_CIPH_PAD_EN     0x100000000000 /* 1: Add pad to end of payload for
+					     *    enc
+					     */
+#define SPU2_CIPH_PAD      0xFF000000000000 /* cipher pad value */
+#define SPU2_CIPH_PAD_SHIFT              48
+
+/* FMD ctrl1 field masks */
+#define SPU2_TAG_LOC                    0x1 /* 1: end of payload, 0: undef */
+#define SPU2_HAS_FR_DATA                0x2 /* 1: msg has frame data */
+#define SPU2_HAS_AAD1                   0x4 /* 1: msg has AAD1 field */
+#define SPU2_HAS_NAAD                   0x8 /* 1: msg has NAAD field */
+#define SPU2_HAS_AAD2                  0x10 /* 1: msg has AAD2 field */
+#define SPU2_HAS_ESN                   0x20 /* 1: msg has ESN field */
+#define SPU2_HASH_KEY_LEN            0xFF00 /* len of hash key in bytes.
+					     * HMAC only.
+					     */
+#define SPU2_HASH_KEY_LEN_SHIFT           8
+#define SPU2_CIPH_KEY_LEN         0xFF00000 /* len of cipher key in bytes */
+#define SPU2_CIPH_KEY_LEN_SHIFT          20
+#define SPU2_GENIV               0x10000000 /* 1: hw generates IV */
+#define SPU2_HASH_IV             0x20000000 /* 1: IV incl in hash */
+#define SPU2_RET_IV              0x40000000 /* 1: return IV in output msg
+					     *    b4 payload
+					     */
+#define SPU2_RET_IV_LEN         0xF00000000 /* length in bytes of IV returned.
+					     * 0 = 16 bytes
+					     */
+#define SPU2_RET_IV_LEN_SHIFT            32
+#define SPU2_IV_OFFSET         0xF000000000 /* gen IV offset */
+#define SPU2_IV_OFFSET_SHIFT             36
+#define SPU2_IV_LEN          0x1F0000000000 /* length of input IV in bytes */
+#define SPU2_IV_LEN_SHIFT                40
+#define SPU2_HASH_TAG_LEN  0x7F000000000000 /* hash tag length in bytes */
+#define SPU2_HASH_TAG_LEN_SHIFT          48
+#define SPU2_RETURN_MD    0x300000000000000 /* return metadata */
+#define SPU2_RETURN_MD_SHIFT             56
+#define SPU2_RETURN_FD    0x400000000000000
+#define SPU2_RETURN_AAD1  0x800000000000000
+#define SPU2_RETURN_NAAD 0x1000000000000000
+#define SPU2_RETURN_AAD2 0x2000000000000000
+#define SPU2_RETURN_PAY  0x4000000000000000 /* return payload */
+
+/* FMD ctrl2 field masks */
+#define SPU2_AAD1_OFFSET              0xFFF /* byte offset of AAD1 field */
+#define SPU2_AAD1_LEN               0xFF000 /* length of AAD1 in bytes */
+#define SPU2_AAD1_LEN_SHIFT              12
+#define SPU2_AAD2_OFFSET         0xFFF00000 /* byte offset of AAD2 field */
+#define SPU2_AAD2_OFFSET_SHIFT           20
+#define SPU2_PL_OFFSET   0xFFFFFFFF00000000 /* payload offset from AAD2 */
+#define SPU2_PL_OFFSET_SHIFT             32
+
+/* FMD ctrl3 field masks */
+#define SPU2_PL_LEN              0xFFFFFFFF /* payload length in bytes */
+#define SPU2_TLS_LEN         0xFFFF00000000 /* TLS encrypt: cipher len
+					     * TLS decrypt: compressed len
+					     */
+#define SPU2_TLS_LEN_SHIFT               32
+
+/*
+ * Max value that can be represented in the Payload Length field of the
+ * ctrl3 word of FMD.
+ */
+#define SPU2_MAX_PAYLOAD  SPU2_PL_LEN
+
+/* Error values returned in STATUS field of response messages */
+#define SPU2_INVALID_ICV  1
+
+void spu2_dump_msg_hdr(u8 *buf, unsigned int buf_len);
+u32 spu2_ctx_max_payload(enum spu_cipher_alg cipher_alg,
+			 enum spu_cipher_mode cipher_mode,
+			 unsigned int blocksize);
+u32 spu2_payload_length(u8 *spu_hdr);
+u16 spu2_response_hdr_len(u16 auth_key_len, u16 enc_key_len, bool is_hash);
+u16 spu2_hash_pad_len(enum hash_alg hash_alg, enum hash_mode hash_mode,
+		      u32 chunksize, u16 hash_block_size);
+u32 spu2_gcm_ccm_pad_len(enum spu_cipher_mode cipher_mode,
+			 unsigned int data_size);
+u32 spu2_assoc_resp_len(enum spu_cipher_mode cipher_mode,
+			unsigned int assoc_len, unsigned int iv_len,
+			bool is_encrypt);
+u8 spu2_aead_ivlen(enum spu_cipher_mode cipher_mode,
+		   u16 iv_len);
+enum hash_type spu2_hash_type(u32 src_sent);
+u32 spu2_digest_size(u32 alg_digest_size, enum hash_alg alg,
+		     enum hash_type htype);
+u32 spu2_create_request(u8 *spu_hdr,
+			struct spu_request_opts *req_opts,
+			struct spu_cipher_parms *cipher_parms,
+			struct spu_hash_parms *hash_parms,
+			struct spu_aead_parms *aead_parms,
+			unsigned int data_size);
+u16 spu2_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms);
+void spu2_cipher_req_finish(u8 *spu_hdr,
+			    u16 spu_req_hdr_len,
+			    unsigned int is_inbound,
+			    struct spu_cipher_parms *cipher_parms,
+			    bool update_key,
+			    unsigned int data_size);
+void spu2_request_pad(u8 *pad_start, u32 gcm_padding, u32 hash_pad_len,
+		      enum hash_alg auth_alg, enum hash_mode auth_mode,
+		      unsigned int total_sent, u32 status_padding);
+u8 spu2_xts_tweak_in_payload(void);
+u8 spu2_tx_status_len(void);
+u8 spu2_rx_status_len(void);
+int spu2_status_process(u8 *statp);
+void spu2_ccm_update_iv(unsigned int digestsize,
+			struct spu_cipher_parms *cipher_parms,
+			unsigned int assoclen, unsigned int chunksize,
+			bool is_encrypt, bool is_esp);
+u32 spu2_wordalign_padlen(u32 data_size);
+#endif
diff --git a/drivers/crypto/bcm/spum.h b/drivers/crypto/bcm/spum.h
new file mode 100644
index 0000000..d0a5b58
--- /dev/null
+++ b/drivers/crypto/bcm/spum.h
@@ -0,0 +1,174 @@
+/*
+ * Copyright 2016 Broadcom
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation (the "GPL").
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 (GPLv2) for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 (GPLv2) along with this source code.
+ */
+
+/*
+ * This file contains SPU message definitions specific to SPU-M.
+ */
+
+#ifndef _SPUM_H_
+#define _SPUM_H_
+
+#define SPU_CRYPTO_OPERATION_GENERIC	0x1
+
+/* Length of STATUS field in tx and rx packets */
+#define SPU_TX_STATUS_LEN  4
+
+/* SPU-M error codes */
+#define SPU_STATUS_MASK                 0x0000FF00
+#define SPU_STATUS_SUCCESS              0x00000000
+#define SPU_STATUS_INVALID_ICV          0x00000100
+
+#define SPU_STATUS_ERROR_FLAG           0x00020000
+
+/* Request message. MH + EMH + BDESC + BD header */
+#define SPU_REQ_FIXED_LEN 24
+
+/*
+ * Max length of a SPU message header. Used to allocate a buffer where
+ * the SPU message header is constructed. Can be used for either a SPU-M
+ * header or a SPU2 header.
+ * For SPU-M, sum of the following:
+ *    MH - 4 bytes
+ *    EMH - 4
+ *    SCTX - 3 +
+ *      max auth key len - 64
+ *      max cipher key len - 264 (RC4)
+ *      max IV len - 16
+ *    BDESC - 12
+ *    BD header - 4
+ * Total:  371
+ *
+ * For SPU2, FMD_SIZE (32) plus lengths of hash and cipher keys,
+ * hash and cipher IVs. If SPU2 does not support RC4, then
+ */
+#define SPU_HEADER_ALLOC_LEN  (SPU_REQ_FIXED_LEN + MAX_KEY_SIZE + \
+				MAX_KEY_SIZE + MAX_IV_SIZE)
+
+/*
+ * Response message header length. Normally MH, EMH, BD header, but when
+ * BD_SUPPRESS is used for hash requests, there is no BD header.
+ */
+#define SPU_RESP_HDR_LEN 12
+#define SPU_HASH_RESP_HDR_LEN 8
+
+/*
+ * Max value that can be represented in the Payload Length field of the BD
+ * header. This is a 16-bit field.
+ */
+#define SPUM_NS2_MAX_PAYLOAD  (BIT(16) - 1)
+
+/*
+ * NSP SPU is limited to ~9KB because of FA2 FIFO size limitations;
+ * Set MAX_PAYLOAD to 8k to allow for addition of header, digest, etc.
+ * and stay within limitation.
+ */
+
+#define SPUM_NSP_MAX_PAYLOAD	8192
+
+/* Buffer Descriptor Header [BDESC]. SPU in big-endian mode. */
+struct BDESC_HEADER {
+	u16 offset_mac;		/* word 0 [31-16] */
+	u16 length_mac;		/* word 0 [15-0]  */
+	u16 offset_crypto;	/* word 1 [31-16] */
+	u16 length_crypto;	/* word 1 [15-0]  */
+	u16 offset_icv;		/* word 2 [31-16] */
+	u16 offset_iv;		/* word 2 [15-0]  */
+};
+
+/* Buffer Data Header [BD]. SPU in big-endian mode. */
+struct BD_HEADER {
+	u16 size;
+	u16 prev_length;
+};
+
+/* Command Context Header. SPU-M in big endian mode. */
+struct MHEADER {
+	u8 flags;	/* [31:24] */
+	u8 op_code;	/* [23:16] */
+	u16 reserved;	/* [15:0] */
+};
+
+/* MH header flags bits */
+#define MH_SUPDT_PRES   BIT(0)
+#define MH_HASH_PRES    BIT(2)
+#define MH_BD_PRES      BIT(3)
+#define MH_MFM_PRES     BIT(4)
+#define MH_BDESC_PRES   BIT(5)
+#define MH_SCTX_PRES	BIT(7)
+
+/* SCTX word 0 bit offsets and fields masks */
+#define SCTX_SIZE               0x000000FF
+
+/* SCTX word 1 bit shifts and field masks */
+#define  UPDT_OFST              0x000000FF   /* offset of SCTX updateable fld */
+#define  HASH_TYPE              0x00000300   /* hash alg operation type */
+#define  HASH_TYPE_SHIFT                 8
+#define  HASH_MODE              0x00001C00   /* one of spu2_hash_mode */
+#define  HASH_MODE_SHIFT                10
+#define  HASH_ALG               0x0000E000   /* hash algorithm */
+#define  HASH_ALG_SHIFT                 13
+#define  CIPHER_TYPE            0x00030000   /* encryption operation type */
+#define  CIPHER_TYPE_SHIFT              16
+#define  CIPHER_MODE            0x001C0000   /* encryption mode */
+#define  CIPHER_MODE_SHIFT              18
+#define  CIPHER_ALG             0x00E00000   /* encryption algo */
+#define  CIPHER_ALG_SHIFT               21
+#define  ICV_IS_512                BIT(27)
+#define  ICV_IS_512_SHIFT		27
+#define  CIPHER_ORDER               BIT(30)
+#define  CIPHER_ORDER_SHIFT             30
+#define  CIPHER_INBOUND             BIT(31)
+#define  CIPHER_INBOUND_SHIFT           31
+
+/* SCTX word 2 bit shifts and field masks */
+#define  EXP_IV_SIZE                   0x7
+#define  IV_OFFSET                   BIT(3)
+#define  IV_OFFSET_SHIFT                 3
+#define  GEN_IV                      BIT(5)
+#define  GEN_IV_SHIFT                    5
+#define  EXPLICIT_IV                 BIT(6)
+#define  EXPLICIT_IV_SHIFT               6
+#define  SCTX_IV                     BIT(7)
+#define  SCTX_IV_SHIFT                   7
+#define  ICV_SIZE                   0x0F00
+#define  ICV_SIZE_SHIFT                  8
+#define  CHECK_ICV                  BIT(12)
+#define  CHECK_ICV_SHIFT                12
+#define  INSERT_ICV                 BIT(13)
+#define  INSERT_ICV_SHIFT               13
+#define  BD_SUPPRESS                BIT(19)
+#define  BD_SUPPRESS_SHIFT              19
+
+/* Generic Mode Security Context Structure [SCTX] */
+struct SCTX {
+/* word 0: protocol flags */
+	u32 proto_flags;
+
+/* word 1: cipher flags */
+	u32 cipher_flags;
+
+/* word 2: Extended cipher flags */
+	u32 ecf;
+
+};
+
+struct SPUHEADER {
+	struct MHEADER mh;
+	u32 emh;
+	struct SCTX sa;
+};
+
+#endif /* _SPUM_H_ */
diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
new file mode 100644
index 0000000..dca540f
--- /dev/null
+++ b/drivers/crypto/bcm/util.c
@@ -0,0 +1,584 @@
+/*
+ * Copyright 2016 Broadcom
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation (the "GPL").
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 (GPLv2) for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 (GPLv2) along with this source code.
+ */
+
+#include <linux/debugfs.h>
+
+#include "cipher.h"
+#include "util.h"
+
+/* offset of SPU_OFIFO_CTRL register */
+#define SPU_OFIFO_CTRL      0x40
+#define SPU_FIFO_WATERMARK  0x1FF
+
+/**
+ * spu_sg_at_offset() - Find the scatterlist entry at a given distance from the
+ * start of a scatterlist.
+ * @sg:         [in]  Start of a scatterlist
+ * @skip:       [in]  Distance from the start of the scatterlist, in bytes
+ * @sge:        [out] Scatterlist entry at skip bytes from start
+ * @sge_offset: [out] Number of bytes from start of sge buffer to get to
+ *                    requested distance.
+ *
+ * Return: 0 if entry found at requested distance
+ *         < 0 otherwise
+ */
+int spu_sg_at_offset(struct scatterlist *sg, unsigned int skip,
+		     struct scatterlist **sge, unsigned int *sge_offset)
+{
+	/* byte index from start of sg to the end of the previous entry */
+	unsigned int index = 0;
+	/* byte index from start of sg to the end of the current entry */
+	unsigned int next_index;
+
+	next_index = sg->length;
+	while (next_index <= skip) {
+		sg = sg_next(sg);
+		index = next_index;
+		if (!sg)
+			return -EINVAL;
+		next_index += sg->length;
+	}
+
+	*sge_offset = skip - index;
+	*sge = sg;
+	return 0;
+}
+
+/* Copy len bytes of sg data, starting at offset skip, to a dest buffer */
+void sg_copy_part_to_buf(struct scatterlist *src, u8 *dest,
+			 unsigned int len, unsigned int skip)
+{
+	size_t copied;
+	unsigned int nents = sg_nents(src);
+
+	copied = sg_pcopy_to_buffer(src, nents, dest, len, skip);
+	if (copied != len) {
+		flow_log("%s copied %u bytes of %u requested. ",
+			 __func__, (u32)copied, len);
+		flow_log("sg with %u entries and skip %u\n", nents, skip);
+	}
+}
+
+/*
+ * Copy data into a scatterlist starting at a specified offset in the
+ * scatterlist. Specifically, copy len bytes of data in the buffer src
+ * into the scatterlist dest, starting skip bytes into the scatterlist.
+ */
+void sg_copy_part_from_buf(struct scatterlist *dest, u8 *src,
+			   unsigned int len, unsigned int skip)
+{
+	size_t copied;
+	unsigned int nents = sg_nents(dest);
+
+	copied = sg_pcopy_from_buffer(dest, nents, src, len, skip);
+	if (copied != len) {
+		flow_log("%s copied %u bytes of %u requested. ",
+			 __func__, (u32)copied, len);
+		flow_log("sg with %u entries and skip %u\n", nents, skip);
+	}
+}
+
+/**
+ * spu_sg_count() - Determine number of elements in scatterlist to provide a
+ * specified number of bytes.
+ * @sg_list:  scatterlist to examine
+ * @skip:     index of starting point
+ * @nbytes:   consider elements of scatterlist until reaching this number of
+ *	      bytes
+ *
+ * Return: the number of sg entries contributing to nbytes of data
+ */
+int spu_sg_count(struct scatterlist *sg_list, unsigned int skip, int nbytes)
+{
+	struct scatterlist *sg;
+	int sg_nents = 0;
+	unsigned int offset;
+
+	if (!sg_list)
+		return 0;
+
+	if (spu_sg_at_offset(sg_list, skip, &sg, &offset) < 0)
+		return 0;
+
+	while (sg && (nbytes > 0)) {
+		sg_nents++;
+		nbytes -= (sg->length - offset);
+		offset = 0;
+		sg = sg_next(sg);
+	}
+	return sg_nents;
+}
+
+/**
+ * spu_msg_sg_add() - Copy scatterlist entries from one sg to another, up to a
+ * given length.
+ * @to_sg:       scatterlist to copy to
+ * @from_sg:     scatterlist to copy from
+ * @from_skip:   number of bytes to skip in from_sg. Non-zero when previous
+ *		 request included part of the buffer in entry in from_sg.
+ *		 Assumes from_skip < from_sg->length.
+ * @from_nents   number of entries in from_sg
+ * @length       number of bytes to copy. may reach this limit before exhausting
+ *		 from_sg.
+ *
+ * Copies the entries themselves, not the data in the entries. Assumes to_sg has
+ * enough entries. Does not limit the size of an individual buffer in to_sg.
+ *
+ * to_sg, from_sg, skip are all updated to end of copy
+ *
+ * Return: Number of bytes copied
+ */
+u32 spu_msg_sg_add(struct scatterlist **to_sg,
+		   struct scatterlist **from_sg, u32 *from_skip,
+		   u8 from_nents, u32 length)
+{
+	struct scatterlist *sg;	/* an entry in from_sg */
+	struct scatterlist *to = *to_sg;
+	struct scatterlist *from = *from_sg;
+	u32 skip = *from_skip;
+	u32 offset;
+	int i;
+	u32 entry_len = 0;
+	u32 frag_len = 0;	/* length of entry added to to_sg */
+	u32 copied = 0;		/* number of bytes copied so far */
+
+	if (length == 0)
+		return 0;
+
+	for_each_sg(from, sg, from_nents, i) {
+		/* number of bytes in this from entry not yet used */
+		entry_len = sg->length - skip;
+		frag_len = min(entry_len, length - copied);
+		offset = sg->offset + skip;
+		if (frag_len)
+			sg_set_page(to++, sg_page(sg), frag_len, offset);
+		copied += frag_len;
+		if (copied == entry_len) {
+			/* used up all of from entry */
+			skip = 0;	/* start at beginning of next entry */
+		}
+		if (copied == length)
+			break;
+	}
+	*to_sg = to;
+	*from_sg = sg;
+	if (frag_len < entry_len)
+		*from_skip = skip + frag_len;
+	else
+		*from_skip = 0;
+
+	return copied;
+}
+
+void add_to_ctr(u8 *ctr_pos, unsigned int increment)
+{
+	__be64 *high_be = (__be64 *)ctr_pos;
+	__be64 *low_be = high_be + 1;
+	u64 orig_low = __be64_to_cpu(*low_be);
+	u64 new_low = orig_low + (u64)increment;
+
+	*low_be = __cpu_to_be64(new_low);
+	if (new_low < orig_low)
+		/* there was a carry from the low 8 bytes */
+		*high_be = __cpu_to_be64(__be64_to_cpu(*high_be) + 1);
+}
+
+struct sdesc {
+	struct shash_desc shash;
+	char ctx[];
+};
+
+/* do a synchronous decrypt operation */
+int do_decrypt(char *alg_name,
+	       void *key_ptr, unsigned int key_len,
+	       void *iv_ptr, void *src_ptr, void *dst_ptr,
+	       unsigned int block_len)
+{
+	struct scatterlist sg_in[1], sg_out[1];
+	struct crypto_blkcipher *tfm =
+	    crypto_alloc_blkcipher(alg_name, 0, CRYPTO_ALG_ASYNC);
+	struct blkcipher_desc desc = {.tfm = tfm, .flags = 0 };
+	int ret = 0;
+	void *iv;
+	int ivsize;
+
+	flow_log("%s() name:%s block_len:%u\n", __func__, alg_name, block_len);
+
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	crypto_blkcipher_setkey((void *)tfm, key_ptr, key_len);
+
+	sg_init_table(sg_in, 1);
+	sg_set_buf(sg_in, src_ptr, block_len);
+
+	sg_init_table(sg_out, 1);
+	sg_set_buf(sg_out, dst_ptr, block_len);
+
+	iv = crypto_blkcipher_crt(tfm)->iv;
+	ivsize = crypto_blkcipher_ivsize(tfm);
+	memcpy(iv, iv_ptr, ivsize);
+
+	ret = crypto_blkcipher_decrypt(&desc, sg_out, sg_in, block_len);
+	crypto_free_blkcipher(tfm);
+
+	if (ret < 0)
+		pr_err("aes_decrypt failed %d\n", ret);
+
+	return ret;
+}
+
+/**
+ * do_shash() - Do a synchronous hash operation in software
+ * @name:       The name of the hash algorithm
+ * @result:     Buffer where digest is to be written
+ * @data1:      First part of data to hash. May be NULL.
+ * @data1_len:  Length of data1, in bytes
+ * @data2:      Second part of data to hash. May be NULL.
+ * @data2_len:  Length of data2, in bytes
+ * @key:	Key (if keyed hash)
+ * @key_len:	Length of key, in bytes (or 0 if non-keyed hash)
+ *
+ * Note that the crypto API will not select this driver's own transform because
+ * this driver only registers asynchronous algos.
+ *
+ * Return: 0 if hash successfully stored in result
+ *         < 0 otherwise
+ */
+int do_shash(unsigned char *name, unsigned char *result,
+	     const u8 *data1, unsigned int data1_len,
+	     const u8 *data2, unsigned int data2_len,
+	     const u8 *key, unsigned int key_len)
+{
+	int rc;
+	unsigned int size;
+	struct crypto_shash *hash;
+	struct sdesc *sdesc;
+
+	hash = crypto_alloc_shash(name, 0, 0);
+	if (IS_ERR(hash)) {
+		rc = PTR_ERR(hash);
+		pr_err("%s: Crypto %s allocation error %d", __func__, name, rc);
+		return rc;
+	}
+
+	size = sizeof(struct shash_desc) + crypto_shash_descsize(hash);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc) {
+		rc = -ENOMEM;
+		pr_err("%s: Memory allocation failure", __func__);
+		goto do_shash_err;
+	}
+	sdesc->shash.tfm = hash;
+	sdesc->shash.flags = 0x0;
+
+	if (key_len > 0) {
+		rc = crypto_shash_setkey(hash, key, key_len);
+		if (rc) {
+			pr_err("%s: Could not setkey %s shash", __func__, name);
+			goto do_shash_err;
+		}
+	}
+
+	rc = crypto_shash_init(&sdesc->shash);
+	if (rc) {
+		pr_err("%s: Could not init %s shash", __func__, name);
+		goto do_shash_err;
+	}
+	rc = crypto_shash_update(&sdesc->shash, data1, data1_len);
+	if (rc) {
+		pr_err("%s: Could not update1", __func__);
+		goto do_shash_err;
+	}
+	if (data2 && data2_len) {
+		rc = crypto_shash_update(&sdesc->shash, data2, data2_len);
+		if (rc) {
+			pr_err("%s: Could not update2", __func__);
+			goto do_shash_err;
+		}
+	}
+	rc = crypto_shash_final(&sdesc->shash, result);
+	if (rc)
+		pr_err("%s: Could not genereate %s hash", __func__, name);
+
+do_shash_err:
+	crypto_free_shash(hash);
+	kfree(sdesc);
+
+	return rc;
+}
+
+/* Dump len bytes of a scatterlist starting at skip bytes into the sg */
+void __dump_sg(struct scatterlist *sg, unsigned int skip, unsigned int len)
+{
+	u8 dbuf[16];
+	unsigned int idx = skip;
+	unsigned int num_out = 0;	/* number of bytes dumped so far */
+	unsigned int count;
+
+	if (packet_debug_logging) {
+		while (num_out < len) {
+			count = (len - num_out > 16) ? 16 : len - num_out;
+			sg_copy_part_to_buf(sg, dbuf, count, idx);
+			num_out += count;
+			print_hex_dump(KERN_ALERT, "  sg: ", DUMP_PREFIX_NONE,
+				       4, 1, dbuf, count, false);
+			idx += 16;
+		}
+	}
+	if (debug_logging_sleep)
+		msleep(debug_logging_sleep);
+}
+
+/* Returns the name for a given cipher alg/mode */
+char *spu_alg_name(enum spu_cipher_alg alg, enum spu_cipher_mode mode)
+{
+	switch (alg) {
+	case CIPHER_ALG_RC4:
+		return "rc4";
+	case CIPHER_ALG_AES:
+		switch (mode) {
+		case CIPHER_MODE_CBC:
+			return "cbc(aes)";
+		case CIPHER_MODE_ECB:
+			return "ecb(aes)";
+		case CIPHER_MODE_OFB:
+			return "ofb(aes)";
+		case CIPHER_MODE_CFB:
+			return "cfb(aes)";
+		case CIPHER_MODE_CTR:
+			return "ctr(aes)";
+		case CIPHER_MODE_XTS:
+			return "xts(aes)";
+		case CIPHER_MODE_GCM:
+			return "gcm(aes)";
+		default:
+			return "aes";
+		}
+		break;
+	case CIPHER_ALG_DES:
+		switch (mode) {
+		case CIPHER_MODE_CBC:
+			return "cbc(des)";
+		case CIPHER_MODE_ECB:
+			return "ecb(des)";
+		case CIPHER_MODE_CTR:
+			return "ctr(des)";
+		default:
+			return "des";
+		}
+		break;
+	case CIPHER_ALG_3DES:
+		switch (mode) {
+		case CIPHER_MODE_CBC:
+			return "cbc(des3_ede)";
+		case CIPHER_MODE_ECB:
+			return "ecb(des3_ede)";
+		case CIPHER_MODE_CTR:
+			return "ctr(des3_ede)";
+		default:
+			return "3des";
+		}
+		break;
+	default:
+		return "other";
+	}
+}
+
+static ssize_t spu_debugfs_read(struct file *filp, char __user *ubuf,
+				size_t count, loff_t *offp)
+{
+	struct device_private *ipriv;
+	char *buf;
+	ssize_t ret, out_offset, out_count;
+	int i;
+	u32 fifo_len;
+	u32 spu_ofifo_ctrl;
+	u32 alg;
+	u32 mode;
+	u32 op_cnt;
+
+	out_count = 2048;
+
+	buf = kmalloc(out_count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ipriv = filp->private_data;
+	out_offset = 0;
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Number of SPUs.........%u\n",
+			       ipriv->spu.num_spu);
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Number of channels.....%u\n",
+			       ipriv->spu.num_chan);
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Current sessions.......%u\n",
+			       atomic_read(&ipriv->session_count));
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Session count..........%u\n",
+			       atomic_read(&ipriv->stream_count));
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Cipher setkey..........%u\n",
+			       atomic_read(&ipriv->setkey_cnt[SPU_OP_CIPHER]));
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Cipher Ops.............%u\n",
+			       atomic_read(&ipriv->op_counts[SPU_OP_CIPHER]));
+	for (alg = 0; alg < CIPHER_ALG_LAST; alg++) {
+		for (mode = 0; mode < CIPHER_MODE_LAST; mode++) {
+			op_cnt = atomic_read(&ipriv->cipher_cnt[alg][mode]);
+			if (op_cnt) {
+				out_offset += snprintf(buf + out_offset,
+						       out_count - out_offset,
+			       "  %-13s%11u\n",
+			       spu_alg_name(alg, mode), op_cnt);
+			}
+		}
+	}
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Hash Ops...............%u\n",
+			       atomic_read(&ipriv->op_counts[SPU_OP_HASH]));
+	for (alg = 0; alg < HASH_ALG_LAST; alg++) {
+		op_cnt = atomic_read(&ipriv->hash_cnt[alg]);
+		if (op_cnt) {
+			out_offset += snprintf(buf + out_offset,
+					       out_count - out_offset,
+		       "  %-13s%11u\n",
+		       hash_alg_name[alg], op_cnt);
+		}
+	}
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "HMAC setkey............%u\n",
+			       atomic_read(&ipriv->setkey_cnt[SPU_OP_HMAC]));
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "HMAC Ops...............%u\n",
+			       atomic_read(&ipriv->op_counts[SPU_OP_HMAC]));
+	for (alg = 0; alg < HASH_ALG_LAST; alg++) {
+		op_cnt = atomic_read(&ipriv->hmac_cnt[alg]);
+		if (op_cnt) {
+			out_offset += snprintf(buf + out_offset,
+					       out_count - out_offset,
+		       "  %-13s%11u\n",
+		       hash_alg_name[alg], op_cnt);
+		}
+	}
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "AEAD setkey............%u\n",
+			       atomic_read(&ipriv->setkey_cnt[SPU_OP_AEAD]));
+
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "AEAD Ops...............%u\n",
+			       atomic_read(&ipriv->op_counts[SPU_OP_AEAD]));
+	for (alg = 0; alg < AEAD_TYPE_LAST; alg++) {
+		op_cnt = atomic_read(&ipriv->aead_cnt[alg]);
+		if (op_cnt) {
+			out_offset += snprintf(buf + out_offset,
+					       out_count - out_offset,
+		       "  %-13s%11u\n",
+		       aead_alg_name[alg], op_cnt);
+		}
+	}
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Bytes of req data......%llu\n",
+			       (u64)atomic64_read(&ipriv->bytes_out));
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Bytes of resp data.....%llu\n",
+			       (u64)atomic64_read(&ipriv->bytes_in));
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Mailbox full...........%u\n",
+			       atomic_read(&ipriv->mb_no_spc));
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Mailbox send failures..%u\n",
+			       atomic_read(&ipriv->mb_send_fail));
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "Check ICV errors.......%u\n",
+			       atomic_read(&ipriv->bad_icv));
+	if (ipriv->spu.spu_type == SPU_TYPE_SPUM)
+		for (i = 0; i < ipriv->spu.num_spu; i++) {
+			spu_ofifo_ctrl = ioread32(ipriv->spu.reg_vbase[i] +
+						  SPU_OFIFO_CTRL);
+			fifo_len = spu_ofifo_ctrl & SPU_FIFO_WATERMARK;
+			out_offset += snprintf(buf + out_offset,
+					       out_count - out_offset,
+				       "SPU %d output FIFO high water.....%u\n",
+				       i, fifo_len);
+		}
+
+	if (out_offset > out_count)
+		out_offset = out_count;
+
+	ret = simple_read_from_buffer(ubuf, count, offp, buf, out_offset);
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations spu_debugfs_stats = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = spu_debugfs_read,
+};
+
+/*
+ * Create the debug FS directories. If the top-level directory has not yet
+ * been created, create it now. Create a stats file in this directory for
+ * a SPU.
+ */
+void spu_setup_debugfs(void)
+{
+	if (!debugfs_initialized())
+		return;
+
+	if (!iproc_priv.debugfs_dir)
+		iproc_priv.debugfs_dir = debugfs_create_dir(KBUILD_MODNAME,
+							    NULL);
+
+	if (!iproc_priv.debugfs_stats)
+		/* Create file with permissions S_IRUSR */
+		debugfs_create_file("stats", 0400, iproc_priv.debugfs_dir,
+				    &iproc_priv, &spu_debugfs_stats);
+}
+
+void spu_free_debugfs(void)
+{
+	debugfs_remove_recursive(iproc_priv.debugfs_dir);
+	iproc_priv.debugfs_dir = NULL;
+}
+
+/**
+ * format_value_ccm() - Format a value into a buffer, using a specified number
+ *			of bytes (i.e. maybe writing value X into a 4 byte
+ *			buffer, or maybe into a 12 byte buffer), as per the
+ *			SPU CCM spec.
+ *
+ * @val:		value to write (up to max of unsigned int)
+ * @buf:		(pointer to) buffer to write the value
+ * @len:		number of bytes to use (0 to 255)
+ *
+ */
+void format_value_ccm(unsigned int val, u8 *buf, u8 len)
+{
+	int i;
+
+	/* First clear full output buffer */
+	memset(buf, 0, len);
+
+	/* Then, starting from right side, fill in with data */
+	for (i = 0; i < len; i++) {
+		buf[len - i - 1] = (val >> (8 * i)) & 0xff;
+		if (i >= 3)
+			break;  /* Only handle up to 32 bits of 'val' */
+	}
+}
diff --git a/drivers/crypto/bcm/util.h b/drivers/crypto/bcm/util.h
new file mode 100644
index 0000000..b858c45
--- /dev/null
+++ b/drivers/crypto/bcm/util.h
@@ -0,0 +1,117 @@
+/*
+ * Copyright 2016 Broadcom
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation (the "GPL").
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 (GPLv2) for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 (GPLv2) along with this source code.
+ */
+
+#ifndef _UTIL_H
+#define _UTIL_H
+
+#include <linux/kernel.h>
+#include <linux/delay.h>
+
+#include "spu.h"
+
+extern int flow_debug_logging;
+extern int packet_debug_logging;
+extern int debug_logging_sleep;
+
+#ifdef DEBUG
+#define flow_log(...)	                \
+	do {	                              \
+		if (flow_debug_logging) {	        \
+			printk(__VA_ARGS__);	          \
+			if (debug_logging_sleep)	      \
+				msleep(debug_logging_sleep);	\
+		}	                                \
+	} while (0)
+#define flow_dump(msg, var, var_len)	   \
+	do {	                                 \
+		if (flow_debug_logging) {	           \
+			print_hex_dump(KERN_ALERT, msg, DUMP_PREFIX_NONE,  \
+					16, 1, var, var_len, false); \
+				if (debug_logging_sleep)	       \
+					msleep(debug_logging_sleep);   \
+		}                                    \
+	} while (0)
+
+#define packet_log(...)               \
+	do {                                \
+		if (packet_debug_logging) {       \
+			printk(__VA_ARGS__);            \
+			if (debug_logging_sleep)        \
+				msleep(debug_logging_sleep);  \
+		}                                 \
+	} while (0)
+#define packet_dump(msg, var, var_len)   \
+	do {                                   \
+		if (packet_debug_logging) {          \
+			print_hex_dump(KERN_ALERT, msg, DUMP_PREFIX_NONE,  \
+					16, 1, var, var_len, false); \
+			if (debug_logging_sleep)           \
+				msleep(debug_logging_sleep);     \
+		}                                    \
+	} while (0)
+
+void __dump_sg(struct scatterlist *sg, unsigned int skip, unsigned int len);
+
+#define dump_sg(sg, skip, len)     __dump_sg(sg, skip, len)
+
+#else /* !DEBUG_ON */
+
+#define flow_log(...) do {} while (0)
+#define flow_dump(msg, var, var_len) do {} while (0)
+#define packet_log(...) do {} while (0)
+#define packet_dump(msg, var, var_len) do {} while (0)
+
+#define dump_sg(sg, skip, len) do {} while (0)
+
+#endif /* DEBUG_ON */
+
+int spu_sg_at_offset(struct scatterlist *sg, unsigned int skip,
+		     struct scatterlist **sge, unsigned int *sge_offset);
+
+/* Copy sg data, from skip, length len, to dest */
+void sg_copy_part_to_buf(struct scatterlist *src, u8 *dest,
+			 unsigned int len, unsigned int skip);
+/* Copy src into scatterlist from offset, length len */
+void sg_copy_part_from_buf(struct scatterlist *dest, u8 *src,
+			   unsigned int len, unsigned int skip);
+
+int spu_sg_count(struct scatterlist *sg_list, unsigned int skip, int nbytes);
+u32 spu_msg_sg_add(struct scatterlist **to_sg,
+		   struct scatterlist **from_sg, u32 *skip,
+		   u8 from_nents, u32 tot_len);
+
+void add_to_ctr(u8 *ctr_pos, unsigned int increment);
+
+/* do a synchronous decrypt operation */
+int do_decrypt(char *alg_name,
+	       void *key_ptr, unsigned int key_len,
+	       void *iv_ptr, void *src_ptr, void *dst_ptr,
+	       unsigned int block_len);
+
+/* produce a message digest from data of length n bytes */
+int do_shash(unsigned char *name, unsigned char *result,
+	     const u8 *data1, unsigned int data1_len,
+	     const u8 *data2, unsigned int data2_len,
+	     const u8 *key, unsigned int key_len);
+
+char *spu_alg_name(enum spu_cipher_alg alg, enum spu_cipher_mode mode);
+
+void spu_setup_debugfs(void);
+void spu_free_debugfs(void);
+void spu_free_debugfs_stats(void);
+void format_value_ccm(unsigned int val, u8 *buf, u8 len);
+
+#endif
--
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

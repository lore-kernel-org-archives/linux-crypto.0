From: Mahipal Challa <mahipalreddy2006@gmail.com>
Subject: [RFC PATCH v2 2/3] crypto: zip - Wire-up Compression / decompression HW offload
Date: Wed, 15 Feb 2017 10:45:09 +0530
Message-ID: <1487135710-9692-3-git-send-email-Mahipal.Challa@cavium.com>
References: <1487135710-9692-1-git-send-email-Mahipal.Challa@cavium.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan.Glauber@cavium.com,
        Vishnu.Nair@cavium.com, pathreya@cavium.com,
        Mahipal.Challa@cavium.com, Jan Glauber <jglauber@cavium.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35294 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751617AbdBOFPf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 00:15:35 -0500
In-Reply-To: <1487135710-9692-1-git-send-email-Mahipal.Challa@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This contains changes for adding compression/decompression h/w offload
functionality for both DEFLATE and LZS.

Signed-off-by: Mahipal Challa <Mahipal.Challa@cavium.com>
Signed-off-by: Jan Glauber <jglauber@cavium.com>
---
 drivers/crypto/cavium/zip/Makefile      |   5 +-
 drivers/crypto/cavium/zip/zip_crypto.c  | 314 ++++++++++++++++++++++++++++++++
 drivers/crypto/cavium/zip/zip_crypto.h  |   2 +
 drivers/crypto/cavium/zip/zip_deflate.c | 190 +++++++++++++++++++
 drivers/crypto/cavium/zip/zip_deflate.h |  62 +++++++
 drivers/crypto/cavium/zip/zip_device.c  |   1 +
 drivers/crypto/cavium/zip/zip_inflate.c | 211 +++++++++++++++++++++
 drivers/crypto/cavium/zip/zip_inflate.h |  62 +++++++
 drivers/crypto/cavium/zip/zip_main.c    |  57 ------
 9 files changed, 846 insertions(+), 58 deletions(-)

diff --git a/drivers/crypto/cavium/zip/Makefile b/drivers/crypto/cavium/zip/Makefile
index 2c07508..b2f3baaf 100644
--- a/drivers/crypto/cavium/zip/Makefile
+++ b/drivers/crypto/cavium/zip/Makefile
@@ -5,4 +5,7 @@
 obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += thunderx_zip.o
 thunderx_zip-y := zip_main.o    \
                   zip_device.o  \
-                  zip_mem.o
+                  zip_crypto.o  \
+                  zip_mem.o     \
+                  zip_deflate.o \
+                  zip_inflate.o
diff --git a/drivers/crypto/cavium/zip/zip_crypto.c b/drivers/crypto/cavium/zip/zip_crypto.c
new file mode 100644
index 0000000..1ceaa34
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_crypto.c
@@ -0,0 +1,314 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2017 Cavium, Inc.
+ * All rights reserved.
+ *
+ * License: one of 'Cavium License' or 'GNU General Public License Version 2'
+ *
+ * This file is provided under the terms of the Cavium License (see below)
+ * or under the terms of GNU General Public License, Version 2, as
+ * published by the Free Software Foundation. When using or redistributing
+ * this file, you may do so under either license.
+ *
+ * Cavium License:  Redistribution and use in source and binary forms, with
+ * or without modification, are permitted provided that the following
+ * conditions are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *
+ *  * Redistributions in binary form must reproduce the above
+ *    copyright notice, this list of conditions and the following
+ *    disclaimer in the documentation and/or other materials provided
+ *    with the distribution.
+ *
+ *  * Neither the name of Cavium Inc. nor the names of its contributors may be
+ *    used to endorse or promote products derived from this software without
+ *    specific prior written permission.
+ *
+ * This Software, including technical data, may be subject to U.S. export
+ * control laws, including the U.S. Export Administration Act and its
+ * associated regulations, and may be subject to export or import
+ * regulations in other countries.
+ *
+ * TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE SOFTWARE IS PROVIDED "AS IS"
+ * AND WITH ALL FAULTS AND CAVIUM INC. MAKES NO PROMISES, REPRESENTATIONS
+ * OR WARRANTIES, EITHER EXPRESS, IMPLIED, STATUTORY, OR OTHERWISE, WITH
+ * RESPECT TO THE SOFTWARE, INCLUDING ITS CONDITION, ITS CONFORMITY TO ANY
+ * REPRESENTATION OR DESCRIPTION, OR THE EXISTENCE OF ANY LATENT OR PATENT
+ * DEFECTS, AND CAVIUM SPECIFICALLY DISCLAIMS ALL IMPLIED (IF ANY)
+ * WARRANTIES OF TITLE, MERCHANTABILITY, NONINFRINGEMENT, FITNESS FOR A
+ * PARTICULAR PURPOSE, LACK OF VIRUSES, ACCURACY OR COMPLETENESS, QUIET
+ * ENJOYMENT, QUIET POSSESSION OR CORRESPONDENCE TO DESCRIPTION. THE
+ * ENTIRE  RISK ARISING OUT OF USE OR PERFORMANCE OF THE SOFTWARE LIES
+ * WITH YOU.
+ ***********************license end**************************************/
+
+#include "zip_crypto.h"
+
+static void zip_static_init_zip_ops(struct zip_operation *zip_ops,
+				    int lzs_flag)
+{
+	zip_ops->flush        = ZIP_FLUSH_FINISH;
+
+	/* equivalent to level 6 of opensource zlib */
+	zip_ops->speed          = 1;
+
+	if (!lzs_flag) {
+		zip_ops->ccode		= 0; /* Auto Huffman */
+		zip_ops->lzs_flag	= 0;
+		zip_ops->format		= ZLIB_FORMAT;
+	} else {
+		zip_ops->ccode		= 3; /* LZS Encoding */
+		zip_ops->lzs_flag	= 1;
+		zip_ops->format		= LZS_FORMAT;
+	}
+	zip_ops->begin_file   = 1;
+	zip_ops->history_len  = 0;
+	zip_ops->end_file     = 1;
+	zip_ops->compcode     = 0;
+	zip_ops->csum	      = 1; /* Adler checksum desired */
+}
+
+int zip_ctx_init(struct zip_kernel_ctx *zip_ctx, int lzs_flag)
+{
+	struct zip_operation  *comp_ctx   = &zip_ctx->zip_comp;
+	struct zip_operation  *decomp_ctx = &zip_ctx->zip_decomp;
+
+	zip_static_init_zip_ops(comp_ctx, lzs_flag);
+	zip_static_init_zip_ops(decomp_ctx, lzs_flag);
+
+	comp_ctx->input  = zip_data_buf_alloc(MAX_INPUT_BUFFER_SIZE);
+	if (!comp_ctx->input)
+		return -ENOMEM;
+
+	comp_ctx->output = zip_data_buf_alloc(MAX_OUTPUT_BUFFER_SIZE);
+	if (!comp_ctx->output)
+		goto err_comp_input;
+
+	decomp_ctx->input  = zip_data_buf_alloc(MAX_INPUT_BUFFER_SIZE);
+	if (!decomp_ctx->input)
+		goto err_comp_output;
+
+	decomp_ctx->output = zip_data_buf_alloc(MAX_OUTPUT_BUFFER_SIZE);
+	if (!decomp_ctx->output)
+		goto err_decomp_input;
+
+	return 0;
+
+err_decomp_input:
+	zip_data_buf_free(decomp_ctx->input, MAX_INPUT_BUFFER_SIZE);
+
+err_comp_output:
+	zip_data_buf_free(comp_ctx->output, MAX_OUTPUT_BUFFER_SIZE);
+
+err_comp_input:
+	zip_data_buf_free(comp_ctx->input, MAX_INPUT_BUFFER_SIZE);
+
+	return -ENOMEM;
+}
+
+void zip_ctx_exit(struct zip_kernel_ctx *zip_ctx)
+{
+	struct zip_operation  *comp_ctx   = &zip_ctx->zip_comp;
+	struct zip_operation  *dec_ctx = &zip_ctx->zip_decomp;
+
+	zip_data_buf_free(comp_ctx->input, MAX_INPUT_BUFFER_SIZE);
+	zip_data_buf_free(comp_ctx->output, MAX_OUTPUT_BUFFER_SIZE);
+
+	zip_data_buf_free(dec_ctx->input, MAX_INPUT_BUFFER_SIZE);
+	zip_data_buf_free(dec_ctx->output, MAX_OUTPUT_BUFFER_SIZE);
+}
+
+int zip_compress(const u8 *src, unsigned int slen,
+		 u8 *dst, unsigned int *dlen,
+		 struct zip_kernel_ctx *zip_ctx)
+{
+	struct zip_operation  *zip_ops   = NULL;
+	struct zip_state      zip_state;
+	struct zip_device     *zip = NULL;
+	int ret;
+
+	if (!zip_ctx || !src || !dst || !dlen)
+		return -ENOMEM;
+
+	zip = zip_get_device(zip_get_node_id());
+	if (!zip)
+		return -ENODEV;
+
+	memset(&zip_state, 0, sizeof(struct zip_state));
+	zip_ops = &zip_ctx->zip_comp;
+
+	zip_ops->input_len  = slen;
+	zip_ops->output_len = *dlen;
+	memcpy(zip_ops->input, src, slen);
+
+	ret = zip_deflate(zip_ops, &zip_state, zip);
+
+	if (!ret) {
+		*dlen = zip_ops->output_len;
+		memcpy(dst, zip_ops->output, *dlen);
+	}
+
+	return ret;
+}
+
+int zip_decompress(const u8 *src, unsigned int slen,
+		   u8 *dst, unsigned int *dlen,
+		   struct zip_kernel_ctx *zip_ctx)
+{
+	struct zip_operation  *zip_ops   = NULL;
+	struct zip_state      zip_state;
+	struct zip_device     *zip = NULL;
+	int ret;
+
+	if (!zip_ctx || !src || !dst || !dlen)
+		return -ENOMEM;
+
+	zip = zip_get_device(zip_get_node_id());
+	if (!zip)
+		return -ENODEV;
+
+	memset(&zip_state, 0, sizeof(struct zip_state));
+	zip_ops = &zip_ctx->zip_decomp;
+	memcpy(zip_ops->input, src, slen);
+
+	/* Work around for a bug in zlib which needs an extra bytes sometimes */
+	if (zip_ops->ccode != 3) /* Not LZS Encoding */
+		zip_ops->input[slen++] = 0;
+
+	zip_ops->input_len  = slen;
+	zip_ops->output_len = *dlen;
+
+	ret = zip_inflate(zip_ops, &zip_state, zip);
+
+	if (!ret) {
+		*dlen = zip_ops->output_len;
+		memcpy(dst, zip_ops->output, *dlen);
+	}
+
+	return ret;
+}
+
+/* Legacy Compress framework start */
+int zip_alloc_comp_ctx_deflate(struct crypto_tfm *tfm)
+{
+	int ret;
+	struct zip_kernel_ctx *zip_ctx = crypto_tfm_ctx(tfm);
+
+	ret = zip_ctx_init(zip_ctx, 0);
+
+	return ret;
+}
+
+int zip_alloc_comp_ctx_lzs(struct crypto_tfm *tfm)
+{
+	int ret;
+	struct zip_kernel_ctx *zip_ctx = crypto_tfm_ctx(tfm);
+
+	ret = zip_ctx_init(zip_ctx, 1);
+
+	return ret;
+}
+
+void zip_free_comp_ctx(struct crypto_tfm *tfm)
+{
+	struct zip_kernel_ctx *zip_ctx = crypto_tfm_ctx(tfm);
+
+	zip_ctx_exit(zip_ctx);
+}
+
+int  zip_comp_compress(struct crypto_tfm *tfm,
+		       const u8 *src, unsigned int slen,
+		       u8 *dst, unsigned int *dlen)
+{
+	int ret;
+	struct zip_kernel_ctx *zip_ctx = crypto_tfm_ctx(tfm);
+
+	ret = zip_compress(src, slen, dst, dlen, zip_ctx);
+
+	return ret;
+}
+
+int  zip_comp_decompress(struct crypto_tfm *tfm,
+			 const u8 *src, unsigned int slen,
+			 u8 *dst, unsigned int *dlen)
+{
+	int ret;
+	struct zip_kernel_ctx *zip_ctx = crypto_tfm_ctx(tfm);
+
+	ret = zip_decompress(src, slen, dst, dlen, zip_ctx);
+
+	return ret;
+} /* Legacy compress framework end */
+
+/* SCOMP framework start */
+void *zip_alloc_scomp_ctx_deflate(struct crypto_scomp *tfm)
+{
+	int ret;
+	struct zip_kernel_ctx *zip_ctx;
+
+	zip_ctx = kzalloc(sizeof(*zip_ctx), GFP_KERNEL);
+	if (!zip_ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ret = zip_ctx_init(zip_ctx, 0);
+
+	if (ret) {
+		kzfree(zip_ctx);
+		return ERR_PTR(ret);
+	}
+
+	return zip_ctx;
+}
+
+void *zip_alloc_scomp_ctx_lzs(struct crypto_scomp *tfm)
+{
+	int ret;
+	struct zip_kernel_ctx *zip_ctx;
+
+	zip_ctx = kzalloc(sizeof(*zip_ctx), GFP_KERNEL);
+	if (!zip_ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ret = zip_ctx_init(zip_ctx, 1);
+
+	if (ret) {
+		kzfree(zip_ctx);
+		return ERR_PTR(ret);
+	}
+
+	return zip_ctx;
+}
+
+void zip_free_scomp_ctx(struct crypto_scomp *tfm, void *ctx)
+{
+	struct zip_kernel_ctx *zip_ctx = ctx;
+
+	zip_ctx_exit(zip_ctx);
+	kzfree(zip_ctx);
+}
+
+int zip_scomp_compress(struct crypto_scomp *tfm,
+		       const u8 *src, unsigned int slen,
+		       u8 *dst, unsigned int *dlen, void *ctx)
+{
+	int ret;
+	struct zip_kernel_ctx *zip_ctx  = ctx;
+
+	ret = zip_compress(src, slen, dst, dlen, zip_ctx);
+
+	return ret;
+}
+
+int zip_scomp_decompress(struct crypto_scomp *tfm,
+			 const u8 *src, unsigned int slen,
+			 u8 *dst, unsigned int *dlen, void *ctx)
+{
+	int ret;
+	struct zip_kernel_ctx *zip_ctx = ctx;
+
+	ret = zip_decompress(src, slen, dst, dlen, zip_ctx);
+
+	return ret;
+} /* SCOMP framework end */
+
diff --git a/drivers/crypto/cavium/zip/zip_crypto.h b/drivers/crypto/cavium/zip/zip_crypto.h
index 2d91b05..b59ddfc 100644
--- a/drivers/crypto/cavium/zip/zip_crypto.h
+++ b/drivers/crypto/cavium/zip/zip_crypto.h
@@ -49,6 +49,8 @@
 #include <linux/crypto.h>
 #include <crypto/internal/scompress.h>
 #include "common.h"
+#include "zip_deflate.h"
+#include "zip_inflate.h"
 
 struct zip_kernel_ctx {
 	struct zip_operation zip_comp;
diff --git a/drivers/crypto/cavium/zip/zip_deflate.c b/drivers/crypto/cavium/zip/zip_deflate.c
new file mode 100644
index 0000000..b02789c
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_deflate.c
@@ -0,0 +1,190 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2017 Cavium, Inc.
+ * All rights reserved.
+ *
+ * License: one of 'Cavium License' or 'GNU General Public License Version 2'
+ *
+ * This file is provided under the terms of the Cavium License (see below)
+ * or under the terms of GNU General Public License, Version 2, as
+ * published by the Free Software Foundation. When using or redistributing
+ * this file, you may do so under either license.
+ *
+ * Cavium License:  Redistribution and use in source and binary forms, with
+ * or without modification, are permitted provided that the following
+ * conditions are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *
+ *  * Redistributions in binary form must reproduce the above
+ *    copyright notice, this list of conditions and the following
+ *    disclaimer in the documentation and/or other materials provided
+ *    with the distribution.
+ *
+ *  * Neither the name of Cavium Inc. nor the names of its contributors may be
+ *    used to endorse or promote products derived from this software without
+ *    specific prior written permission.
+ *
+ * This Software, including technical data, may be subject to U.S. export
+ * control laws, including the U.S. Export Administration Act and its
+ * associated regulations, and may be subject to export or import
+ * regulations in other countries.
+ *
+ * TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE SOFTWARE IS PROVIDED "AS IS"
+ * AND WITH ALL FAULTS AND CAVIUM INC. MAKES NO PROMISES, REPRESENTATIONS
+ * OR WARRANTIES, EITHER EXPRESS, IMPLIED, STATUTORY, OR OTHERWISE, WITH
+ * RESPECT TO THE SOFTWARE, INCLUDING ITS CONDITION, ITS CONFORMITY TO ANY
+ * REPRESENTATION OR DESCRIPTION, OR THE EXISTENCE OF ANY LATENT OR PATENT
+ * DEFECTS, AND CAVIUM SPECIFICALLY DISCLAIMS ALL IMPLIED (IF ANY)
+ * WARRANTIES OF TITLE, MERCHANTABILITY, NONINFRINGEMENT, FITNESS FOR A
+ * PARTICULAR PURPOSE, LACK OF VIRUSES, ACCURACY OR COMPLETENESS, QUIET
+ * ENJOYMENT, QUIET POSSESSION OR CORRESPONDENCE TO DESCRIPTION. THE
+ * ENTIRE  RISK ARISING OUT OF USE OR PERFORMANCE OF THE SOFTWARE LIES
+ * WITH YOU.
+ ***********************license end**************************************/
+
+#include <linux/delay.h>
+#include <linux/sched.h>
+
+#include "common.h"
+#include "zip_deflate.h"
+
+/* Prepares the deflate zip command */
+static int prepare_zip_command(struct zip_operation *zip_ops,
+			       struct zip_state *s, union zip_inst_s *zip_cmd)
+{
+	union zip_zres_s *result_ptr = &s->result;
+
+	memset(zip_cmd, 0, sizeof(s->zip_cmd));
+	memset(result_ptr, 0, sizeof(s->result));
+
+	/* IWORD #0 */
+	/* History gather */
+	zip_cmd->s.hg = 0;
+	/* compression enable = 1 for deflate */
+	zip_cmd->s.ce = 1;
+	/* sf (sync flush) */
+	zip_cmd->s.sf = 1;
+	/* ef (end of file) */
+	if (zip_ops->flush == ZIP_FLUSH_FINISH) {
+		zip_cmd->s.ef = 1;
+		zip_cmd->s.sf = 0;
+	}
+
+	zip_cmd->s.cc = zip_ops->ccode;
+	/* ss (compression speed/storage) */
+	zip_cmd->s.ss = zip_ops->speed;
+
+	/* IWORD #1 */
+	/* adler checksum */
+	zip_cmd->s.adlercrc32 = zip_ops->csum;
+	zip_cmd->s.historylength = zip_ops->history_len;
+	zip_cmd->s.dg = 0;
+
+	/* IWORD # 6 and 7 - compression input/history pointer */
+	zip_cmd->s.inp_ptr_addr.s.addr  = __pa(zip_ops->input);
+	zip_cmd->s.inp_ptr_ctl.s.length = (zip_ops->input_len +
+					   zip_ops->history_len);
+	zip_cmd->s.ds = 0;
+
+	/* IWORD # 8 and 9 - Output pointer */
+	zip_cmd->s.out_ptr_addr.s.addr  = __pa(zip_ops->output);
+	zip_cmd->s.out_ptr_ctl.s.length = zip_ops->output_len;
+	/* maximum number of output-stream bytes that can be written */
+	zip_cmd->s.totaloutputlength    = zip_ops->output_len;
+
+	/* IWORD # 10 and 11 - Result pointer */
+	zip_cmd->s.res_ptr_addr.s.addr = __pa(result_ptr);
+	/* Clearing completion code */
+	result_ptr->s.compcode = 0;
+
+	return 0;
+}
+
+/**
+ * zip_deflate - API to offload deflate operation to hardware
+ * @zip_ops: Pointer to zip operation structure
+ * @s:       Pointer to the structure representing zip state
+ * @zip_dev: Pointer to zip device structure
+ *
+ * This function prepares the zip deflate command and submits it to the zip
+ * engine for processing.
+ *
+ * Return: 0 if successful or error code
+ */
+int zip_deflate(struct zip_operation *zip_ops, struct zip_state *s,
+		struct zip_device *zip_dev)
+{
+	union zip_inst_s *zip_cmd = &s->zip_cmd;
+	union zip_zres_s *result_ptr = &s->result;
+	u32 queue;
+
+	/* Prepares zip command based on the input parameters */
+	prepare_zip_command(zip_ops, s, zip_cmd);
+
+	/* Loads zip command into command queues and rings door bell */
+	queue = zip_load_instr(zip_cmd, zip_dev);
+
+	while (!result_ptr->s.compcode)
+		continue;
+
+	zip_ops->compcode = result_ptr->s.compcode;
+	switch (zip_ops->compcode) {
+	case ZIP_CMD_NOTDONE:
+		zip_dbg("Zip instruction not yet completed");
+		return ZIP_ERROR;
+
+	case ZIP_CMD_SUCCESS:
+		zip_dbg("Zip instruction completed successfully");
+		zip_update_cmd_bufs(zip_dev, queue);
+		break;
+
+	case ZIP_CMD_DTRUNC:
+		zip_dbg("Output Truncate error");
+		/* Returning ZIP_ERROR to avoid copy to user */
+		return ZIP_ERROR;
+
+	default:
+		zip_err("Zip instruction failed. Code:%d", zip_ops->compcode);
+		return ZIP_ERROR;
+	}
+
+	/* Update the CRC depending on the format */
+	switch (zip_ops->format) {
+	case RAW_FORMAT:
+		zip_dbg("RAW Format: %d ", zip_ops->format);
+		/* Get checksum from engine, need to feed it again */
+		zip_ops->csum = result_ptr->s.adler32;
+		break;
+
+	case ZLIB_FORMAT:
+		zip_dbg("ZLIB Format: %d ", zip_ops->format);
+		zip_ops->csum = result_ptr->s.adler32;
+		break;
+
+	case GZIP_FORMAT:
+		zip_dbg("GZIP Format: %d ", zip_ops->format);
+		zip_ops->csum = result_ptr->s.crc32;
+		break;
+
+	case LZS_FORMAT:
+		zip_dbg("LZS Format: %d ", zip_ops->format);
+		break;
+
+	default:
+		zip_err("Unknown Format:%d\n", zip_ops->format);
+	}
+
+	/* Update output_len */
+	if (zip_ops->output_len < result_ptr->s.totalbyteswritten) {
+		/* Dynamic stop && strm->output_len < zipconstants[onfsize] */
+		zip_err("output_len (%d) < total bytes written(%d)\n",
+			zip_ops->output_len, result_ptr->s.totalbyteswritten);
+		zip_ops->output_len = 0;
+
+	} else {
+		zip_ops->output_len = result_ptr->s.totalbyteswritten;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/cavium/zip/zip_deflate.h b/drivers/crypto/cavium/zip/zip_deflate.h
new file mode 100644
index 0000000..1d32e76
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_deflate.h
@@ -0,0 +1,62 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2017 Cavium, Inc.
+ * All rights reserved.
+ *
+ * License: one of 'Cavium License' or 'GNU General Public License Version 2'
+ *
+ * This file is provided under the terms of the Cavium License (see below)
+ * or under the terms of GNU General Public License, Version 2, as
+ * published by the Free Software Foundation. When using or redistributing
+ * this file, you may do so under either license.
+ *
+ * Cavium License:  Redistribution and use in source and binary forms, with
+ * or without modification, are permitted provided that the following
+ * conditions are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *
+ *  * Redistributions in binary form must reproduce the above
+ *    copyright notice, this list of conditions and the following
+ *    disclaimer in the documentation and/or other materials provided
+ *    with the distribution.
+ *
+ *  * Neither the name of Cavium Inc. nor the names of its contributors may be
+ *    used to endorse or promote products derived from this software without
+ *    specific prior written permission.
+ *
+ * This Software, including technical data, may be subject to U.S. export
+ * control laws, including the U.S. Export Administration Act and its
+ * associated regulations, and may be subject to export or import
+ * regulations in other countries.
+ *
+ * TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE SOFTWARE IS PROVIDED "AS IS"
+ * AND WITH ALL FAULTS AND CAVIUM INC. MAKES NO PROMISES, REPRESENTATIONS
+ * OR WARRANTIES, EITHER EXPRESS, IMPLIED, STATUTORY, OR OTHERWISE, WITH
+ * RESPECT TO THE SOFTWARE, INCLUDING ITS CONDITION, ITS CONFORMITY TO ANY
+ * REPRESENTATION OR DESCRIPTION, OR THE EXISTENCE OF ANY LATENT OR PATENT
+ * DEFECTS, AND CAVIUM SPECIFICALLY DISCLAIMS ALL IMPLIED (IF ANY)
+ * WARRANTIES OF TITLE, MERCHANTABILITY, NONINFRINGEMENT, FITNESS FOR A
+ * PARTICULAR PURPOSE, LACK OF VIRUSES, ACCURACY OR COMPLETENESS, QUIET
+ * ENJOYMENT, QUIET POSSESSION OR CORRESPONDENCE TO DESCRIPTION. THE
+ * ENTIRE  RISK ARISING OUT OF USE OR PERFORMANCE OF THE SOFTWARE LIES
+ * WITH YOU.
+ ***********************license end**************************************/
+
+#ifndef __ZIP_DEFLATE_H__
+#define __ZIP_DEFLATE_H__
+
+/**
+ * zip_deflate - API to offload deflate operation to hardware
+ * @zip_ops: Pointer to zip operation structure
+ * @s:       Pointer to the structure representing zip state
+ * @zip_dev: Pointer to the structure representing zip device
+ *
+ * This function prepares the zip deflate command and submits it to the zip
+ * engine by ringing the doorbell.
+ *
+ * Return: 0 if successful or error code
+ */
+int zip_deflate(struct zip_operation *zip_ops, struct zip_state *s,
+		struct zip_device *zip_dev);
+#endif
diff --git a/drivers/crypto/cavium/zip/zip_device.c b/drivers/crypto/cavium/zip/zip_device.c
index e980f08..ccf21fb 100644
--- a/drivers/crypto/cavium/zip/zip_device.c
+++ b/drivers/crypto/cavium/zip/zip_device.c
@@ -44,6 +44,7 @@
  ***********************license end**************************************/
 
 #include "common.h"
+#include "zip_deflate.h"
 
 /**
  * zip_cmd_queue_consumed - Calculates the space consumed in the command queue.
diff --git a/drivers/crypto/cavium/zip/zip_inflate.c b/drivers/crypto/cavium/zip/zip_inflate.c
new file mode 100644
index 0000000..5f43a8c
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_inflate.c
@@ -0,0 +1,211 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2017 Cavium, Inc.
+ * All rights reserved.
+ *
+ * License: one of 'Cavium License' or 'GNU General Public License Version 2'
+ *
+ * This file is provided under the terms of the Cavium License (see below)
+ * or under the terms of GNU General Public License, Version 2, as
+ * published by the Free Software Foundation. When using or redistributing
+ * this file, you may do so under either license.
+ *
+ * Cavium License:  Redistribution and use in source and binary forms, with
+ * or without modification, are permitted provided that the following
+ * conditions are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *
+ *  * Redistributions in binary form must reproduce the above
+ *    copyright notice, this list of conditions and the following
+ *    disclaimer in the documentation and/or other materials provided
+ *    with the distribution.
+ *
+ *  * Neither the name of Cavium Inc. nor the names of its contributors may be
+ *    used to endorse or promote products derived from this software without
+ *    specific prior written permission.
+ *
+ * This Software, including technical data, may be subject to U.S. export
+ * control laws, including the U.S. Export Administration Act and its
+ * associated regulations, and may be subject to export or import
+ * regulations in other countries.
+ *
+ * TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE SOFTWARE IS PROVIDED "AS IS"
+ * AND WITH ALL FAULTS AND CAVIUM INC. MAKES NO PROMISES, REPRESENTATIONS
+ * OR WARRANTIES, EITHER EXPRESS, IMPLIED, STATUTORY, OR OTHERWISE, WITH
+ * RESPECT TO THE SOFTWARE, INCLUDING ITS CONDITION, ITS CONFORMITY TO ANY
+ * REPRESENTATION OR DESCRIPTION, OR THE EXISTENCE OF ANY LATENT OR PATENT
+ * DEFECTS, AND CAVIUM SPECIFICALLY DISCLAIMS ALL IMPLIED (IF ANY)
+ * WARRANTIES OF TITLE, MERCHANTABILITY, NONINFRINGEMENT, FITNESS FOR A
+ * PARTICULAR PURPOSE, LACK OF VIRUSES, ACCURACY OR COMPLETENESS, QUIET
+ * ENJOYMENT, QUIET POSSESSION OR CORRESPONDENCE TO DESCRIPTION. THE
+ * ENTIRE  RISK ARISING OUT OF USE OR PERFORMANCE OF THE SOFTWARE LIES
+ * WITH YOU.
+ ***********************license end**************************************/
+
+#include <linux/delay.h>
+#include <linux/sched.h>
+
+#include "common.h"
+#include "zip_inflate.h"
+
+static int prepare_inflate_zcmd(struct zip_operation *zip_ops,
+				struct zip_state *s, union zip_inst_s *zip_cmd)
+{
+	union zip_zres_s *result_ptr = &s->result;
+
+	memset(zip_cmd, 0, sizeof(s->zip_cmd));
+	memset(result_ptr, 0, sizeof(s->result));
+
+	/* IWORD#0 */
+
+	/* Decompression History Gather list - no gather list */
+	zip_cmd->s.hg = 0;
+	/* For decompression, CE must be 0x0. */
+	zip_cmd->s.ce = 0;
+	/* For decompression, SS must be 0x0. */
+	zip_cmd->s.ss = 0;
+	/* For decompression, SF should always be set. */
+	zip_cmd->s.sf = 1;
+
+	/* Begin File */
+	if (zip_ops->begin_file == 0)
+		zip_cmd->s.bf = 0;
+	else
+		zip_cmd->s.bf = 1;
+
+	zip_cmd->s.ef = 1;
+	/* 0: for Deflate decompression, 3: for LZS decompression */
+	zip_cmd->s.cc = zip_ops->ccode;
+
+	/* IWORD #1*/
+
+	/* adler checksum */
+	zip_cmd->s.adlercrc32 = zip_ops->csum;
+
+	/*
+	 * HISTORYLENGTH must be 0x0 for any ZIP decompress operation.
+	 * History data is added to a decompression operation via IWORD3.
+	 */
+	zip_cmd->s.historylength = 0;
+	zip_cmd->s.ds = 0;
+
+	/* IWORD # 8 and 9 - Output pointer */
+	zip_cmd->s.out_ptr_addr.s.addr  = __pa(zip_ops->output);
+	zip_cmd->s.out_ptr_ctl.s.length = zip_ops->output_len;
+
+	/* Maximum number of output-stream bytes that can be written */
+	zip_cmd->s.totaloutputlength    = zip_ops->output_len;
+
+	zip_dbg("Data Direct Input case ");
+
+	/* IWORD # 6 and 7 - input pointer */
+	zip_cmd->s.dg = 0;
+	zip_cmd->s.inp_ptr_addr.s.addr  = __pa((u8 *)zip_ops->input);
+	zip_cmd->s.inp_ptr_ctl.s.length = zip_ops->input_len;
+
+	/* IWORD # 10 and 11 - Result pointer */
+	zip_cmd->s.res_ptr_addr.s.addr = __pa(result_ptr);
+
+	/* Clearing completion code */
+	result_ptr->s.compcode = 0;
+
+	/* Returning 0 for time being.*/
+	return 0;
+}
+
+/**
+ * zip_inflate - API to offload inflate operation to hardware
+ * @zip_ops: Pointer to zip operation structure
+ * @s:       Pointer to the structure representing zip state
+ * @zip_dev: Pointer to zip device structure
+ *
+ * This function prepares the zip inflate command and submits it to the zip
+ * engine for processing.
+ *
+ * Return: 0 if successful or error code
+ */
+int zip_inflate(struct zip_operation *zip_ops, struct zip_state *s,
+		struct zip_device *zip_dev)
+{
+	union zip_inst_s *zip_cmd    = &s->zip_cmd;
+	union zip_zres_s  *result_ptr = &s->result;
+	u32 queue;
+
+	/* Prepare inflate zip command */
+	prepare_inflate_zcmd(zip_ops, s, zip_cmd);
+
+	/* Load inflate command to zip queue and ring the doorbell */
+	queue = zip_load_instr(zip_cmd, zip_dev);
+
+	while (!result_ptr->s.compcode)
+		continue;
+
+	zip_ops->compcode = result_ptr->s.compcode;
+	switch (zip_ops->compcode) {
+	case ZIP_CMD_NOTDONE:
+		zip_dbg("Zip Instruction not yet completed\n");
+		return ZIP_ERROR;
+
+	case ZIP_CMD_SUCCESS:
+		zip_dbg("Zip Instruction completed successfully\n");
+		break;
+
+	case ZIP_CMD_DYNAMIC_STOP:
+		zip_dbg(" Dynamic stop Initiated\n");
+		break;
+
+	default:
+		zip_dbg("Instruction failed. Code = %d\n", zip_ops->compcode);
+		zip_update_cmd_bufs(zip_dev, queue);
+		return ZIP_ERROR;
+	}
+
+	zip_update_cmd_bufs(zip_dev, queue);
+
+	if ((zip_ops->ccode == 3) && (zip_ops->flush == 4) &&
+	    (zip_ops->compcode != ZIP_CMD_DYNAMIC_STOP))
+		result_ptr->s.ef = 1;
+
+	zip_ops->csum = result_ptr->s.adler32;
+
+	if (zip_ops->output_len < result_ptr->s.totalbyteswritten) {
+		zip_err("output_len (%d) < total bytes written (%d)\n",
+			zip_ops->output_len, result_ptr->s.totalbyteswritten);
+		zip_ops->output_len = 0;
+	} else {
+		zip_ops->output_len = result_ptr->s.totalbyteswritten;
+	}
+
+	zip_ops->bytes_read = result_ptr->s.totalbytesread;
+	zip_ops->bits_processed = result_ptr->s.totalbitsprocessed;
+	zip_ops->end_file = result_ptr->s.ef;
+	if (zip_ops->end_file) {
+		switch (zip_ops->format) {
+		case RAW_FORMAT:
+			zip_dbg("RAW Format: %d ", zip_ops->format);
+			/* Get checksum from engine */
+			zip_ops->csum = result_ptr->s.adler32;
+			break;
+
+		case ZLIB_FORMAT:
+			zip_dbg("ZLIB Format: %d ", zip_ops->format);
+			zip_ops->csum = result_ptr->s.adler32;
+			break;
+
+		case GZIP_FORMAT:
+			zip_dbg("GZIP Format: %d ", zip_ops->format);
+			zip_ops->csum = result_ptr->s.crc32;
+			break;
+
+		case LZS_FORMAT:
+			zip_dbg("LZS Format: %d ", zip_ops->format);
+			break;
+
+		default:
+			zip_err("Format error:%d\n", zip_ops->format);
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/cavium/zip/zip_inflate.h b/drivers/crypto/cavium/zip/zip_inflate.h
new file mode 100644
index 0000000..6b20f17
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_inflate.h
@@ -0,0 +1,62 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2017 Cavium, Inc.
+ * All rights reserved.
+ *
+ * License: one of 'Cavium License' or 'GNU General Public License Version 2'
+ *
+ * This file is provided under the terms of the Cavium License (see below)
+ * or under the terms of GNU General Public License, Version 2, as
+ * published by the Free Software Foundation. When using or redistributing
+ * this file, you may do so under either license.
+ *
+ * Cavium License:  Redistribution and use in source and binary forms, with
+ * or without modification, are permitted provided that the following
+ * conditions are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *
+ *  * Redistributions in binary form must reproduce the above
+ *    copyright notice, this list of conditions and the following
+ *    disclaimer in the documentation and/or other materials provided
+ *    with the distribution.
+ *
+ *  * Neither the name of Cavium Inc. nor the names of its contributors may be
+ *    used to endorse or promote products derived from this software without
+ *    specific prior written permission.
+ *
+ * This Software, including technical data, may be subject to U.S. export
+ * control laws, including the U.S. Export Administration Act and its
+ * associated regulations, and may be subject to export or import
+ * regulations in other countries.
+ *
+ * TO THE MAXIMUM EXTENT PERMITTED BY LAW, THE SOFTWARE IS PROVIDED "AS IS"
+ * AND WITH ALL FAULTS AND CAVIUM INC. MAKES NO PROMISES, REPRESENTATIONS
+ * OR WARRANTIES, EITHER EXPRESS, IMPLIED, STATUTORY, OR OTHERWISE, WITH
+ * RESPECT TO THE SOFTWARE, INCLUDING ITS CONDITION, ITS CONFORMITY TO ANY
+ * REPRESENTATION OR DESCRIPTION, OR THE EXISTENCE OF ANY LATENT OR PATENT
+ * DEFECTS, AND CAVIUM SPECIFICALLY DISCLAIMS ALL IMPLIED (IF ANY)
+ * WARRANTIES OF TITLE, MERCHANTABILITY, NONINFRINGEMENT, FITNESS FOR A
+ * PARTICULAR PURPOSE, LACK OF VIRUSES, ACCURACY OR COMPLETENESS, QUIET
+ * ENJOYMENT, QUIET POSSESSION OR CORRESPONDENCE TO DESCRIPTION. THE
+ * ENTIRE  RISK ARISING OUT OF USE OR PERFORMANCE OF THE SOFTWARE LIES
+ * WITH YOU.
+ ***********************license end**************************************/
+
+#ifndef __ZIP_INFLATE_H__
+#define __ZIP_INFLATE_H__
+
+/**
+ * zip_inflate - API to offload inflate operation to hardware
+ * @zip_ops: Pointer to zip operation structure
+ * @s:       Pointer to the structure representing zip state
+ * @zip_dev: Pointer to the structure representing zip device
+ *
+ * This function prepares the zip inflate command and submits it to the zip
+ * engine for processing.
+ *
+ * Return: 0 if successful or error code
+ */
+int zip_inflate(struct zip_operation *zip_ops, struct zip_state *s,
+		struct zip_device *zip_dev);
+#endif
diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
index 89ea360..dd5814a 100644
--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -339,63 +339,6 @@ static void zip_remove(struct pci_dev *pdev)
 	zip_dev[zip->index] = NULL;
 }
 
-/* Dummy Functions */
-int  zip_alloc_comp_ctx_deflate(struct crypto_tfm *tfm)
-{
-	return 0;
-}
-
-int  zip_alloc_comp_ctx_lzs(struct crypto_tfm *tfm)
-{
-	return 0;
-}
-
-void zip_free_comp_ctx(struct crypto_tfm *tfm)
-{
-}
-
-int  zip_comp_compress(struct crypto_tfm *tfm,
-		       const u8 *src, unsigned int slen,
-		       u8 *dst, unsigned int *dlen)
-{
-	return 0;
-}
-
-int  zip_comp_decompress(struct crypto_tfm *tfm,
-			 const u8 *src, unsigned int slen,
-			 u8 *dst, unsigned int *dlen)
-{
-	return 0;
-}
-
-void *zip_alloc_scomp_ctx_deflate(struct crypto_scomp *tfm)
-{
-	return NULL;
-}
-
-void *zip_alloc_scomp_ctx_lzs(struct crypto_scomp *tfm)
-{
-	return NULL;
-}
-
-void  zip_free_scomp_ctx(struct crypto_scomp *tfm, void *zip_ctx)
-{
-}
-
-int   zip_scomp_compress(struct crypto_scomp *tfm,
-			 const u8 *src, unsigned int slen,
-			 u8 *dst, unsigned int *dlen, void *ctx)
-{
-	return 0;
-}
-
-int   zip_scomp_decompress(struct crypto_scomp *tfm,
-			   const u8 *src, unsigned int slen,
-			   u8 *dst, unsigned int *dlen, void *ctx)
-{
-	return 0;
-}
-
 /* PCI Sub-System Interface */
 static struct pci_driver zip_driver = {
 	.name	    =  DRV_NAME,
-- 
1.8.3.1

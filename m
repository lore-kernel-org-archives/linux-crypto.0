From: Jan Glauber <jglauber@cavium.com>
Subject: [RFC PATCH 1/3] crypto: zip - Add ThunderX ZIP driver core
Date: Mon, 12 Dec 2016 16:04:37 +0100
Message-ID: <20161212150439.18627-2-jglauber@cavium.com>
References: <20161212150439.18627-1-jglauber@cavium.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Mahipal Challa <Mahipal.Challa@cavium.com>,
        Vishnu Nair <Vishnu.Nair@cavium.com>,
        Jan Glauber <jglauber@cavium.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161212150439.18627-1-jglauber@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Mahipal Challa <Mahipal.Challa@cavium.com>

Add a driver for the ZIP engine found on Cavium ThunderX SOCs.
The ZIP engine supports hardware accelerated compression and
decompression. It includes 2 independent ZIP cores and supports:

- DEFLATE compression and decompression (RFC 1951)
- LZS compression and decompression (RFC 2395 and ANSI X3.241-1994)
- ADLER32 and CRC32 checksums for ZLIB (RFC 1950) and GZIP (RFC 1952)

The ZIP engine is presented as a PCI device. It supports DMA and
scatter-gather.

Signed-off-by: Mahipal Challa <Mahipal.Challa@cavium.com>
Signed-off-by: Vishnu Nair <Vishnu.Nair@cavium.com>
Signed-off-by: Jan Glauber <jglauber@cavium.com>
---
 drivers/crypto/Kconfig                 |    7 +
 drivers/crypto/Makefile                |    1 +
 drivers/crypto/cavium/Makefile         |    4 +
 drivers/crypto/cavium/zip/Makefile     |    8 +
 drivers/crypto/cavium/zip/common.h     |  258 +++++++
 drivers/crypto/cavium/zip/zip_crypto.h |   61 ++
 drivers/crypto/cavium/zip/zip_device.c |  208 +++++
 drivers/crypto/cavium/zip/zip_device.h |  138 ++++
 drivers/crypto/cavium/zip/zip_main.c   |  500 ++++++++++++
 drivers/crypto/cavium/zip/zip_main.h   |  126 +++
 drivers/crypto/cavium/zip/zip_mem.c    |  120 +++
 drivers/crypto/cavium/zip/zip_mem.h    |   78 ++
 drivers/crypto/cavium/zip/zip_regs.h   | 1326 ++++++++++++++++++++++++++++++++
 13 files changed, 2835 insertions(+)
 create mode 100644 drivers/crypto/cavium/Makefile
 create mode 100644 drivers/crypto/cavium/zip/Makefile
 create mode 100644 drivers/crypto/cavium/zip/common.h
 create mode 100644 drivers/crypto/cavium/zip/zip_crypto.h
 create mode 100644 drivers/crypto/cavium/zip/zip_device.c
 create mode 100644 drivers/crypto/cavium/zip/zip_device.h
 create mode 100644 drivers/crypto/cavium/zip/zip_main.c
 create mode 100644 drivers/crypto/cavium/zip/zip_main.h
 create mode 100644 drivers/crypto/cavium/zip/zip_mem.c
 create mode 100644 drivers/crypto/cavium/zip/zip_mem.h
 create mode 100644 drivers/crypto/cavium/zip/zip_regs.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4d2b81f..da48d93 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -485,6 +485,13 @@ config CRYPTO_DEV_MXS_DCP
 
 source "drivers/crypto/qat/Kconfig"
 
+config CRYPTO_DEV_CAVIUM_ZIP
+	tristate "Cavium ZIP driver"
+	depends on PCI && 64BIT && (ARM64 || COMPILE_TEST)
+	---help---
+	  Select this option if you want to enable compression/decompression
+	  acceleration on Cavium's ARM based SoCs
+
 config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
 	depends on (ARCH_QCOM || COMPILE_TEST) && HAS_DMA && HAS_IOMEM
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index ad7250f..3d152d4 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_CRYPTO_DEV_MXC_SCC) += mxc-scc.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
 obj-$(CONFIG_CRYPTO_DEV_QAT) += qat/
+obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += cavium/
 obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
 obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
 obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
diff --git a/drivers/crypto/cavium/Makefile b/drivers/crypto/cavium/Makefile
new file mode 100644
index 0000000..641268b
--- /dev/null
+++ b/drivers/crypto/cavium/Makefile
@@ -0,0 +1,4 @@
+#
+# Makefile for Cavium crypto device drivers
+#
+obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += zip/
diff --git a/drivers/crypto/cavium/zip/Makefile b/drivers/crypto/cavium/zip/Makefile
new file mode 100644
index 0000000..2c07508
--- /dev/null
+++ b/drivers/crypto/cavium/zip/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for Cavium's ZIP Driver.
+#
+
+obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += thunderx_zip.o
+thunderx_zip-y := zip_main.o    \
+                  zip_device.o  \
+                  zip_mem.o
diff --git a/drivers/crypto/cavium/zip/common.h b/drivers/crypto/cavium/zip/common.h
new file mode 100644
index 0000000..f0694f4
--- /dev/null
+++ b/drivers/crypto/cavium/zip/common.h
@@ -0,0 +1,258 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2016 Cavium, Inc.
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
+#ifndef __COMMON_H__
+#define __COMMON_H__
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/seq_file.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/version.h>
+
+/* Device specific zlib function definitions */
+#include "zip_device.h"
+
+/* ZIP device definitions */
+#include "zip_main.h"
+
+/* ZIP memory allocation/deallocation related definitions */
+#include "zip_mem.h"
+
+/* Device specific structure definitions */
+#include "zip_regs.h"
+
+#define ZIP_ERROR    -1
+
+#define ZIP_FLUSH_FINISH  4
+
+#define RAW_FORMAT		0  /* for rawpipe */
+#define ZLIB_FORMAT		1  /* for zpipe */
+#define GZIP_FORMAT		2  /* for gzpipe */
+#define LZS_FORMAT		3  /* for lzspipe */
+
+/* Max number of ZIP devices supported */
+#define MAX_ZIP_DEVICES		2
+
+/* Configures the number of zip queues to be used */
+#define ZIP_NUM_QUEUES		2
+
+#define DYNAMIC_STOP_EXCESS	1024
+
+/* Maximum buffer sizes in direct mode */
+#define MAX_INPUT_BUFFER_SIZE   ((64 * 1024) - 1)
+#define MAX_OUTPUT_BUFFER_SIZE  ((64 * 1024) - 1)
+
+/* ZIP invocation result completion status codes */
+#define ZIP_NOTDONE		0x0
+
+/* Successful completion. */
+#define ZIP_SUCCESS		0x1
+
+/* Output truncated */
+#define ZIP_DTRUNC		0x2
+
+/* Dynamic Stop */
+#define ZIP_DYNAMIC_STOP	0x3
+
+/* Uncompress ran out of input data when IWORD0[EF] was set */
+#define ZIP_ITRUNC		0x4
+
+/* Uncompress found the reserved block type 3 */
+#define ZIP_RBLOCK		0x5
+
+/* Uncompress found LEN != ZIP_NLEN in an uncompressed block in the input */
+#define ZIP_NLEN		0x6
+
+/* Uncompress found a bad code in the main Huffman codes. */
+#define ZIP_BADCODE		0x7
+
+/* Uncompress found a bad code in the 19 Huffman codes encoding lengths. */
+#define ZIP_BADCODE2	        0x8
+
+/* Compress found a zero-length input. */
+#define ZIP_ZERO_LEN	        0x9
+
+/* The compress or decompress encountered an internal parity error. */
+#define ZIP_PARITY		0xA
+
+/*
+ * Uncompress found a string identifier that precedes the uncompressed data and
+ * decompression history.
+ */
+#define ZIP_FATAL		0xB
+
+/**
+ * struct zip_operation - common data structure for comp and decomp operations
+ * @input:               Next input byte is read from here
+ * @output:              Next output byte written here
+ * @ctx_addr:            Inflate context buffer address
+ * @history:             Pointer to the history buffer
+ * @input_len:           Number of bytes available at next_in
+ * @input_total_len:     Total number of input bytes read
+ * @output_len:          Remaining free space at next_out
+ * @output_total_len:    Total number of bytes output so far
+ * @csum:                Checksum value of the uncompressed data
+ * @flush:               Flush flag
+ * @format:              Format (depends on stream's wrap)
+ * @speed:               Speed depends on stream's level
+ * @ccode:               Compression code ( stream's strategy)
+ * @lzs_flag:            Flag for LZS support
+ * @begin_file:          Beginning of file indication for inflate
+ * @history_len:         Size of the history data
+ * @end_file:            Ending of the file indication for inflate
+ * @compcode:            Completion status of the ZIP invocation
+ * @bytes_read:          Input bytes read in current instruction
+ * @bits_processed:      Total bits processed for entire file
+ * @sizeofptr:           To distinguish between ILP32 and LP64
+ * @sizeofzops:          Optional just for padding
+ *
+ * This structure is used to maintain the required meta data for the
+ * comp and decomp operations.
+ */
+struct zip_operation {
+	u8    *input;
+	u8    *output;
+	u64   ctx_addr;
+	u64   history;
+
+	u32   input_len;
+	u32   input_total_len;
+
+	u32   output_len;
+	u32   output_total_len;
+
+	u32   csum;
+	u32   flush;
+
+	u32   format;
+	u32   speed;
+	u32   ccode;
+	u32   lzs_flag;
+
+	u32   begin_file;
+	u32   history_len;
+
+	u32   end_file;
+	u32   compcode;
+	u32   bytes_read;
+	u32   bits_processed;
+
+	u32   sizeofptr;
+	u32   sizeofzops;
+};
+
+/* error messages */
+#define zip_err(fmt, args...) pr_err("ZIP ERR:%s():%d: " \
+			      fmt "\n", __func__, __LINE__, ## args)
+
+#ifdef MSG_ENABLE
+/* Enable all messages */
+#define zip_msg(fmt, args...) pr_info("ZIP_MSG:" fmt "\n", ## args)
+#else
+#define zip_msg(fmt, args...)
+#endif
+
+#if defined(ZIP_DEBUG_ENABLE) && defined(MSG_ENABLE)
+
+#ifdef DEBUG_LEVEL
+
+#define FILE_NAME (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : \
+	strrchr(__FILE__, '\\') ? strrchr(__FILE__, '\\') + 1 : __FILE__)
+
+#if DEBUG_LEVEL >= 4
+
+#define zip_dbg(fmt, args...) pr_info("ZIP DBG: %s: %s() : %d: " \
+			      fmt "\n", FILE_NAME, __func__, __LINE__, ## args)
+
+#define zip_dbg_enter(fmt, args...) pr_info("ZIP_DBG: %s() in %s" \
+				    fmt "\n", __func__, FILE_NAME, ## args)
+
+#define zip_dbg_exit(fmt, args...) pr_info("ZIP_DBG:Exit %s() in %s" \
+				   fmt "\n", __func__, FILE_NAME, ## args)
+
+#elif DEBUG_LEVEL >= 3
+
+#define zip_dbg(fmt, args...) pr_info("ZIP DBG: %s: %s() : %d: " \
+			      fmt "\n", FILE_NAME, __func__, __LINE__, ## args)
+
+#elif DEBUG_LEVEL >= 2
+
+#define zip_dbg(fmt, args...) pr_info("ZIP DBG: %s() : %d: " \
+			      fmt "\n", __func__, __LINE__, ## args)
+
+#else
+
+#define zip_dbg(fmt, args...) pr_info("ZIP DBG:" fmt "\n", ## args)
+
+#endif /* DEBUG LEVEL >= */
+
+#if DEBUG_LEVEL <= 3
+
+#define zip_dbg_enter(fmt, args...)
+#define zip_dbg_exit(fmt, args...)
+
+#endif /* DEBUG_LEVEL <= 3 */
+#else
+
+#define zip_dbg(fmt, args...) pr_info("ZIP DBG:" fmt "\n", ## args)
+
+#define zip_dbg_enter(fmt, args...)
+#define zip_dbg_exit(fmt, args...)
+
+#endif /* DEBUG_LEVEL */
+#else
+
+#define zip_dbg(fmt, args...)
+#define zip_dbg_enter(fmt, args...)
+#define zip_dbg_exit(fmt, args...)
+
+#endif /* ZIP_DEBUG_ENABLE */
+
+#endif
diff --git a/drivers/crypto/cavium/zip/zip_crypto.h b/drivers/crypto/cavium/zip/zip_crypto.h
new file mode 100644
index 0000000..1215049
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_crypto.h
@@ -0,0 +1,61 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2016 Cavium, Inc.
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
+#ifndef __ZIP_CRYPTO_H__
+#define __ZIP_CRYPTO_H__
+
+#include <linux/crypto.h>
+#include "common.h"
+
+struct zip_kernel_ctx {
+	struct zip_operation zip_comp;
+	struct zip_operation zip_decomp;
+};
+
+int  zip_alloc_zip_ctx(struct crypto_tfm *tfm);
+int  zip_alloc_lzs_ctx(struct crypto_tfm *tfm);
+void zip_free_zip_ctx(struct crypto_tfm *tfm);
+
+#endif
diff --git a/drivers/crypto/cavium/zip/zip_device.c b/drivers/crypto/cavium/zip/zip_device.c
new file mode 100644
index 0000000..ed21c5a
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_device.c
@@ -0,0 +1,208 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2016 Cavium, Inc.
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
+#include "common.h"
+
+/**
+ * zip_cmd_queue_consumed - Calculates the space consumed in the command queue.
+ *
+ * @zip_dev: Pointer to zip device structure
+ * @queue:   Queue number
+ *
+ * Return: Bytes consumed in the command queue buffer.
+ */
+static inline u32 zip_cmd_queue_consumed(struct zip_device *zip_dev, int queue)
+{
+	return ((zip_dev->iq[queue].sw_head - zip_dev->iq[queue].sw_tail) *
+		sizeof(u64 *));
+}
+
+/**
+ * zip_load_instr - Submits the instruction into the ZIP command queue
+ * @instr:      Pointer to the instruction to be submitted
+ * @zip_dev:    Pointer to ZIP device structure to which the instruction is to
+ *              be submitted
+ *
+ * This function copies the ZIP instruction to the command queue and rings the
+ * doorbell to notify the engine of the instruction submission. The command
+ * queue is maintained in a circular fashion. When there is space for exactly
+ * one instruction in the queue, next chunk pointer of the queue is made to
+ * point to the head of the queue, thus maintaining a circular queue.
+ *
+ * Return: Queue number to which the instruction was submitted
+ */
+u32 zip_load_instr(union zip_inst_s *instr,
+		   struct zip_device *zip_dev)
+{
+	union zip_quex_doorbell dbell;
+	u32 queue = 0;
+	u32 consumed = 0;
+	u64 *ncb_ptr = NULL;
+	union zip_nptr_s ncp;
+
+	/*
+	 * Distribute the instructions between the enabled queues based on
+	 * the CPU id.
+	 */
+	if (raw_smp_processor_id() % 2 == 0)
+		queue = 0;
+	else
+		queue = 1;
+
+	zip_dbg("CPU Core: %d Queue number:%d", raw_smp_processor_id(), queue);
+
+	/* Take cmd buffer lock */
+	spin_lock(&zip_dev->iq[queue].lock);
+
+	/*
+	 * Command Queue implementation
+	 * 1. If there is place for new instructions, push the cmd at sw_head.
+	 * 2. If there is place for exactly one instruction, push the new cmd
+	 *    at the sw_head. Make sw_head point to the sw_tail to make it
+	 *    circular. Write sw_head's physical address to the "Next-Chunk
+	 *    Buffer Ptr" to make it cmd_hw_tail.
+	 * 3. Ring the door bell.
+	 */
+	zip_dbg("sw_head : %lx", zip_dev->iq[queue].sw_head);
+	zip_dbg("sw_tail : %lx", zip_dev->iq[queue].sw_tail);
+
+	consumed = zip_cmd_queue_consumed(zip_dev, queue);
+	/* Check if there is space to push just one cmd */
+	if ((consumed + 128) == (ZIP_CMD_QBUF_SIZE - 8)) {
+		zip_dbg("Cmd queue space available for single command");
+		/* Space for one cmd, pust it and make it circular queue */
+		memcpy((u8 *)zip_dev->iq[queue].sw_head, (u8 *)instr,
+		       sizeof(union zip_inst_s));
+		zip_dev->iq[queue].sw_head += 16; /* 16 64_bit words = 128B */
+
+		/* Now, point the "Next-Chunk Buffer Ptr" to sw_head */
+		ncb_ptr = zip_dev->iq[queue].sw_head;
+
+		zip_dbg("ncb addr :0x%lx sw_head addr :0x%lx",
+			ncb_ptr, zip_dev->iq[queue].sw_head - 16);
+
+		/* Using Circular command queue */
+		zip_dev->iq[queue].sw_head = zip_dev->iq[queue].sw_tail;
+		/* Mark this buffer for free */
+		zip_dev->iq[queue].free_flag = 1;
+
+		/* Write new chunk buffer address at "Next-Chunk Buffer Ptr" */
+		ncp.u_reg64 = 0ull;
+		ncp.s.addr = __pa(zip_dev->iq[queue].sw_head);
+		*ncb_ptr = ncp.u_reg64;
+		zip_dbg("*ncb_ptr :0x%lx sw_head[phys] :0x%lx",
+			*ncb_ptr, __pa(zip_dev->iq[queue].sw_head));
+
+		zip_dev->iq[queue].pend_cnt++;
+
+	} else {
+		zip_dbg("Enough space is available for commands");
+		/* Push this cmd to cmd queue buffer */
+		memcpy((u8 *)zip_dev->iq[queue].sw_head, (u8 *)instr,
+		       sizeof(union zip_inst_s));
+		zip_dev->iq[queue].sw_head += 16; /* 16 64_bit words = 128B */
+
+		zip_dev->iq[queue].pend_cnt++;
+	}
+	zip_dbg("sw_head :0x%lx sw_tail :0x%lx hw_tail :0x%lx",
+		zip_dev->iq[queue].sw_head, zip_dev->iq[queue].sw_tail,
+		zip_dev->iq[queue].hw_tail);
+
+	zip_dbg(" Pushed the new cmd : pend_cnt : %d",
+		zip_dev->iq[queue].pend_cnt);
+
+	/* Ring the doorbell */
+	dbell.u_reg64     = 0ull;
+	dbell.s.dbell_cnt = 1;
+	zip_reg_write(dbell.u_reg64,
+		      (zip_dev->reg_base + ZIP_QUEX_DOORBELL(queue)));
+
+	/* Unlock cmd buffer lock */
+	spin_unlock(&zip_dev->iq[queue].lock);
+
+	/* Poll for the IQ cmd completion code */
+	zip_dbg_exit();
+
+	return queue;
+}
+
+/**
+ * zip_update_cmd_bufs - Updates the queue statistics after posting the
+ *                       instruction
+ * @zip_dev: Pointer to zip device structure
+ * @queue:   Queue number
+ */
+void zip_update_cmd_bufs(struct zip_device *zip_dev, u32 queue)
+{
+	zip_dbg_enter();
+
+	/* Take cmd buffer lock */
+	spin_lock(&zip_dev->iq[queue].lock);
+
+	/* Check if the previous buffer can be freed */
+	if (zip_dev->iq[queue].free_flag == 1) {
+		zip_dbg("Free flag. Free cmd buffer, adjust sw head and tail");
+		/* Reset the free flag */
+		zip_dev->iq[queue].free_flag = 0;
+
+		/* Point the hw_tail to start of the new chunk buffer */
+		zip_dev->iq[queue].hw_tail = zip_dev->iq[queue].sw_head;
+	} else {
+		zip_dbg("Free flag not set. increment hw tail");
+		zip_dev->iq[queue].hw_tail += 16; /* 16 64_bit words = 128B */
+	}
+
+	zip_dev->iq[queue].done_cnt++;
+	zip_dev->iq[queue].pend_cnt--;
+
+	zip_dbg("sw_head :0x%lx sw_tail :0x%lx hw_tail :0x%lx",
+		zip_dev->iq[queue].sw_head, zip_dev->iq[queue].sw_tail,
+		zip_dev->iq[queue].hw_tail);
+	zip_dbg(" Got CC : pend_cnt : %d\n", zip_dev->iq[queue].pend_cnt);
+
+	spin_unlock(&zip_dev->iq[queue].lock);
+
+	zip_dbg_exit();
+}
diff --git a/drivers/crypto/cavium/zip/zip_device.h b/drivers/crypto/cavium/zip/zip_device.h
new file mode 100644
index 0000000..7f864e0
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_device.h
@@ -0,0 +1,138 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2016 Cavium, Inc.
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
+#ifndef __ZIP_DEVICE_H__
+#define __ZIP_DEVICE_H__
+
+#include <linux/types.h>
+#include "zip_main.h"
+
+struct sg_info {
+	/*
+	 * Pointer to the input data when scatter_gather == 0 and
+	 * pointer to the input gather list buffer when scatter_gather == 1
+	 */
+	union zip_zptr_s *gather;
+
+	/*
+	 * Pointer to the output data when scatter_gather == 0 and
+	 * pointer to the output scatter list buffer when scatter_gather == 1
+	 */
+	union zip_zptr_s *scatter;
+
+	/*
+	 * Holds size of the output buffer pointed by scatter list
+	 * when scatter_gather == 1
+	 */
+	u64 scatter_buf_size;
+
+	/* for gather data */
+	u64 gather_enable;
+
+	/* for scatter data */
+	u64 scatter_enable;
+
+	/* Number of gather list pointers for gather data */
+	u32 gbuf_cnt;
+
+	/* Number of scatter list pointers for scatter data */
+	u32 sbuf_cnt;
+
+	/* Buffers allocation state */
+	u8 alloc_state;
+};
+
+/**
+ * struct zip_state - Structure representing the required information related
+ *                    to a command
+ * @zip_cmd: Pointer to zip instruction structure
+ * @result:  Pointer to zip result structure
+ * @ctx:     Context pointer for inflate
+ * @history: Decompression history pointer
+ * @sginfo:  Scatter-gather info structure
+ */
+struct zip_state {
+	union zip_inst_s zip_cmd;
+	union zip_zres_s result;
+	union zip_zptr_s *ctx;
+	union zip_zptr_s *history;
+	struct sg_info   sginfo;
+};
+
+static inline u64 zip_depth(void)
+{
+	struct zip_device *zip_dev = zip_get_device(zip_get_node_id());
+
+	if (!zip_dev)
+		return -ENODEV;
+
+	return zip_dev->depth;
+}
+
+static inline u64 zip_onfsize(void)
+{
+	struct zip_device *zip_dev = zip_get_device(zip_get_node_id());
+
+	if (!zip_dev)
+		return -ENODEV;
+
+	return zip_dev->onfsize;
+}
+
+static inline u64 zip_ctxsize(void)
+{
+	struct zip_device *zip_dev = zip_get_device(zip_get_node_id());
+
+	if (!zip_dev)
+		return -ENODEV;
+
+	return zip_dev->ctxsize;
+}
+
+#define ZIP_CONTEXT_SIZE          2048
+#define ZIP_INFLATE_HISTORY_SIZE  32768
+#define ZIP_DEFLATE_HISTORY_SIZE  32768
+
+#endif
diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
new file mode 100644
index 0000000..052c42d
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -0,0 +1,500 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2016 Cavium, Inc.
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
+#include "common.h"
+#include "zip_crypto.h"
+
+#define DRV_NAME		"ThunderX-ZIP"
+
+static struct zip_device *zip_dev[MAX_ZIP_DEVICES];
+
+static const struct pci_device_id zip_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVICE_ID_THUNDERX_ZIP) },
+	{ 0, }
+};
+
+void zip_reg_write(u64 val, u64 __iomem *addr)
+{
+	writeq(val, addr);
+}
+
+u64 zip_reg_read(u64 __iomem *addr)
+{
+	return readq(addr);
+}
+
+/*
+ * Allocates new ZIP device structure
+ * Returns zip_device pointer or NULL if cannot allocate memory for zip_device
+ */
+static struct zip_device *zip_alloc_device(struct pci_dev *pdev)
+{
+	struct zip_device *zip = NULL;
+	int idx = 0;
+
+	for (idx = 0; idx < MAX_ZIP_DEVICES; idx++) {
+		if (!zip_dev[idx])
+			break;
+	}
+
+	zip = kzalloc(sizeof(*zip), GFP_KERNEL);
+
+	if (!zip)
+		return NULL;
+
+	zip_dev[idx] = zip;
+	zip->index = idx;
+	return zip;
+}
+
+/**
+ * zip_get_device - Get ZIP device based on node id of cpu
+ *
+ * @node: Node id of the current cpu
+ * Return: Pointer to Zip device structure
+ */
+struct zip_device *zip_get_device(int node)
+{
+	if ((node < MAX_ZIP_DEVICES) && (node >= 0))
+		return zip_dev[node];
+
+	zip_err("ZIP device not found for node id %d\n", node);
+	return NULL;
+}
+
+/**
+ * zip_get_node_id - Get the node id of the current cpu
+ *
+ * Return: Node id of the current cpu
+ */
+int zip_get_node_id(void)
+{
+	return cpu_to_node(raw_smp_processor_id());
+}
+
+/**
+ * zip-get_zipeng_count - Returns No. of ZIP Cores present in CN88XX
+ *
+ * Return: Number of zip engines in the system
+ */
+int zip_get_zipeng_count(void)
+{
+	return ZIP_NUMENG_CN88XX;
+}
+
+/* Initializes the ZIP h/w sub-system */
+static int zip_init_hw(struct zip_device *zip)
+{
+	union zip_cmd_ctl    cmd_ctl;
+	union zip_constants  constants;
+	union zip_que_ena    que_ena;
+	union zip_quex_map   que_map;
+	union zip_que_pri    que_pri;
+
+	union zip_quex_sbuf_addr que_sbuf_addr;
+	union zip_quex_sbuf_ctl  que_sbuf_ctl;
+
+	int q = 0;
+
+	zip_dbg_enter();
+
+	/* ZIP Engine Init / Enable */
+
+	/* Enable the ZIP Engine(Core) Clock */
+	cmd_ctl.u_reg64 = zip_reg_read(zip->reg_base + ZIP_CMD_CTL);
+	cmd_ctl.s.forceclk = 1;
+	zip_reg_write(cmd_ctl.u_reg64 & 0xFF, (zip->reg_base + ZIP_CMD_CTL));
+
+	zip_msg("ZIP_CMD_CTL  : 0x%016llx",
+		zip_reg_read(zip->reg_base + ZIP_CMD_CTL));
+
+	constants.u_reg64 = zip_reg_read(zip->reg_base + ZIP_CONSTANTS);
+	zip->depth    = constants.s.depth;
+	zip->onfsize  = constants.s.onfsize;
+	zip->ctxsize  = constants.s.ctxsize;
+
+	zip_msg("depth: 0x%016llx , onfsize : 0x%016llx , ctxsize : 0x%016llx",
+		zip->depth, zip->onfsize, zip->ctxsize);
+
+	/*
+	 * Program ZIP_QUE(0..7)_SBUF_ADDR and ZIP_QUE(0..7)_SBUF_CTL to
+	 * have the correct buffer pointer and size configured for each
+	 * instruction queue.
+	 */
+	for (q = 0; q < ZIP_NUM_QUEUES; q++) {
+		que_sbuf_ctl.u_reg64 = 0ull;
+		que_sbuf_ctl.s.size = (ZIP_CMD_QBUF_SIZE / sizeof(u64));
+		que_sbuf_ctl.s.inst_be   = 0;
+		que_sbuf_ctl.s.stream_id = 0;
+		zip_reg_write(que_sbuf_ctl.u_reg64,
+			      (zip->reg_base + ZIP_QUEX_SBUF_CTL(q)));
+
+		zip_msg("QUEX_SBUF_CTL[%d]: 0x%016llx", q,
+			zip_reg_read(zip->reg_base + ZIP_QUEX_SBUF_CTL(q)));
+	}
+
+	for (q = 0; q < ZIP_NUM_QUEUES; q++) {
+		memset(&zip->iq[q], 0x0, sizeof(struct zip_iq));
+
+		spin_lock_init(&zip->iq[q].lock);
+
+		if (zip_cmd_qbuf_alloc(zip, q)) {
+			while (q != 0) {
+				q--;
+				zip_cmd_qbuf_free(zip, q);
+			}
+			return -ENOMEM;
+		}
+
+		/* Initialize tail ptr to head */
+		zip->iq[q].sw_tail = zip->iq[q].sw_head;
+		zip->iq[q].hw_tail = zip->iq[q].sw_head;
+
+		/* Write the physical addr to register */
+		que_sbuf_addr.u_reg64   = 0ull;
+		que_sbuf_addr.s.ptr = (__pa(zip->iq[q].sw_head) >>
+				       ZIP_128B_ALIGN);
+
+		zip_msg("QUE[%d]_PTR(PHYS): 0x%016llx", q,
+			(u64)que_sbuf_addr.s.ptr);
+
+		zip_reg_write(que_sbuf_addr.u_reg64,
+			      (zip->reg_base + ZIP_QUEX_SBUF_ADDR(q)));
+
+		zip_msg("QUEX_SBUF_ADDR[%d]: 0x%016llx", q,
+			zip_reg_read(zip->reg_base + ZIP_QUEX_SBUF_ADDR(q)));
+
+		zip_dbg("sw_head :0x%lx sw_tail :0x%lx hw_tail :0x%lx",
+			zip->iq[q].sw_head, zip->iq[q].sw_tail,
+			zip->iq[q].hw_tail);
+		zip_dbg("sw_head phy addr : 0x%lx", que_sbuf_addr.s.ptr);
+	}
+
+	/*
+	 * Queue-to-ZIP core mapping
+	 * If a queue is not mapped to a particular core, it is equivalent to
+	 * the ZIP core being disabled.
+	 */
+	que_ena.u_reg64 = 0x0ull;
+	/* Enabling queues based on ZIP_NUM_QUEUES */
+	for (q = 0; q < ZIP_NUM_QUEUES; q++)
+		que_ena.s.ena |= (0x1 << q);
+	zip_reg_write(que_ena.u_reg64, (zip->reg_base + ZIP_QUE_ENA));
+
+	zip_msg("QUE_ENA      : 0x%016llx",
+		zip_reg_read(zip->reg_base + ZIP_QUE_ENA));
+
+	for (q = 0; q < ZIP_NUM_QUEUES; q++) {
+		que_map.u_reg64 = 0ull;
+		/* Mapping each queue to two ZIP cores */
+		que_map.s.zce = 0x3;
+		zip_reg_write(que_map.u_reg64,
+			      (zip->reg_base + ZIP_QUEX_MAP(q)));
+
+		zip_msg("QUE_MAP(%d)   : 0x%016llx", q,
+			zip_reg_read(zip->reg_base + ZIP_QUEX_MAP(q)));
+	}
+
+	que_pri.u_reg64 = 0ull;
+	for (q = 0; q < ZIP_NUM_QUEUES; q++)
+		que_pri.s.pri |= (0x1 << q); /* Higher Priority RR */
+	zip_reg_write(que_pri.u_reg64, (zip->reg_base + ZIP_QUE_PRI));
+
+	zip_msg("QUE_PRI %016llx", zip_reg_read(zip->reg_base + ZIP_QUE_PRI));
+
+	zip_dbg_exit();
+	return 0;
+}
+
+static int zip_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct zip_device *zip = NULL;
+	int    err;
+
+	zip_dbg_enter();
+
+	zip = zip_alloc_device(pdev);
+
+	if (!zip)
+		return -ENOMEM;
+
+	pr_info("Found ZIP device %d %x:%x on Node %d\n", zip->index,
+		pdev->vendor, pdev->device, dev_to_node(dev));
+
+	zip->pdev = pdev;
+
+	pci_set_drvdata(pdev, zip);
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		zip_err("Failed to enable PCI device");
+		goto err_free_device;
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		zip_err("PCI request regions failed 0x%x", err);
+		goto err_disable_device;
+	}
+
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
+	if (err) {
+		dev_err(dev, "Unable to get usable DMA configuration\n");
+		goto err_release_regions;
+	}
+
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));
+	if (err) {
+		dev_err(dev, "Unable to get 48-bit DMA for allocations\n");
+		goto err_release_regions;
+	}
+
+	/* MAP configuration registers */
+	zip->reg_base = pci_ioremap_bar(pdev, PCI_CFG_ZIP_PF_BAR0);
+	if (!zip->reg_base) {
+		zip_err("ZIP: Cannot map BAR0 CSR memory space, aborting");
+		err = -ENOMEM;
+		goto err_release_regions;
+	}
+
+	/* Initialize ZIP Hardware */
+	err = zip_init_hw(zip);
+	if (err)
+		goto err_release_regions;
+
+	return 0;
+
+err_release_regions:
+	if (zip->reg_base)
+		iounmap(zip->reg_base);
+	pci_release_regions(pdev);
+
+err_disable_device:
+	pci_disable_device(pdev);
+
+err_free_device:
+	pci_set_drvdata(pdev, NULL);
+
+	/* remove zip_dev from zip_device list, free the zip_device memory */
+	zip_dev[zip->index] = NULL;
+	kfree(zip);
+
+	zip_dbg_exit();
+	return err;
+}
+
+static void zip_remove(struct pci_dev *pdev)
+{
+	struct zip_device *zip = pci_get_drvdata(pdev);
+	int q = 0;
+
+	zip_dbg_enter();
+
+	if (!zip)
+		return;
+
+	if (zip->reg_base) {
+		union zip_cmd_ctl cmd_ctl;
+
+		cmd_ctl.u_reg64 = 0x0ull;
+		cmd_ctl.s.reset = 1;  /* Forces ZIP cores to do reset */
+		zip_reg_write(cmd_ctl.u_reg64, (zip->reg_base + ZIP_CMD_CTL));
+		iounmap(zip->reg_base);
+	}
+
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+
+	/*
+	 * Free Command Queue buffers. This free should be called for all
+	 * the enabled Queues.
+	 */
+	for (q = 0; q < ZIP_NUM_QUEUES; q++)
+		zip_cmd_qbuf_free(zip, q);
+
+	pci_set_drvdata(pdev, NULL);
+
+	/* remove zip device from zip device list */
+	zip_dev[zip->index] = NULL;
+	kfree(zip);
+
+	zip_dbg_exit();
+}
+
+/* Dummy Functions */
+int zip_alloc_lzs_ctx(struct crypto_tfm *tfm)
+{
+	return 0;
+}
+
+int zip_alloc_zip_ctx(struct crypto_tfm *tfm)
+{
+	return 0;
+}
+
+void zip_free_zip_ctx(struct crypto_tfm *tfm)
+{
+}
+
+int  zip_deflate_comp(struct crypto_tfm *tfm,
+		      const u8 *src, unsigned int slen,
+		      u8 *dst, unsigned int *dlen)
+{
+	return 0;
+}
+
+int  zip_inflate_comp(struct crypto_tfm *tfm,
+		      const u8 *src, unsigned int slen,
+		      u8 *dst, unsigned int *dlen)
+{
+	return 0;
+}
+
+/* PCI Sub-System Interface */
+static struct pci_driver zip_driver = {
+	.name	    =  DRV_NAME,
+	.id_table   =  zip_id_table,
+	.probe	    =  zip_probe,
+	.remove     =  zip_remove,
+};
+
+/* Kernel Crypto Subsystem Interface */
+
+static struct crypto_alg zip_comp_deflate = {
+	.cra_name		= "deflate",
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct zip_kernel_ctx),
+	.cra_priority           = 300,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= zip_alloc_zip_ctx,
+	.cra_exit		= zip_free_zip_ctx,
+	.cra_u			= { .compress = {
+		.coa_compress	= zip_deflate_comp,
+		.coa_decompress	= zip_inflate_comp
+		 } }
+};
+
+static struct crypto_alg zip_comp_lzs = {
+	.cra_name		= "lzs",
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct zip_kernel_ctx),
+	.cra_priority           = 300,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= zip_alloc_lzs_ctx,
+	.cra_exit		= zip_free_zip_ctx,
+	.cra_u			= { .compress = {
+		.coa_compress	= zip_deflate_comp,
+		.coa_decompress	= zip_inflate_comp
+		 } }
+};
+
+static int zip_register_compression_device(void)
+{
+	int ret;
+
+	ret = crypto_register_alg(&zip_comp_deflate);
+	if (ret < 0) {
+		zip_err("Deflate algorithm registration failed\n");
+		return ret;
+	}
+
+	ret = crypto_register_alg(&zip_comp_lzs);
+	if (ret < 0) {
+		zip_err("LZS algorithm registration failed\n");
+		crypto_unregister_alg(&zip_comp_deflate);
+	}
+
+	return ret;
+}
+
+static void zip_unregister_compression_device(void)
+{
+	crypto_unregister_alg(&zip_comp_deflate);
+	crypto_unregister_alg(&zip_comp_lzs);
+}
+
+static int __init zip_init_module(void)
+{
+	int ret;
+
+	memset(&zip_dev, 0, sizeof(zip_dev));
+
+	zip_msg("%s\n", DRV_NAME);
+
+	ret = pci_register_driver(&zip_driver);
+	if (ret < 0) {
+		zip_err("ZIP: pci_register_driver() returned %d\n", ret);
+		return ret;
+	}
+
+	/* Register with the Kernel Crypto Interface */
+	ret = zip_register_compression_device();
+	if (ret < 0) {
+		zip_err("ZIP: Kernel Crypto Registration failed\n");
+		return 1;
+	}
+
+	return ret;
+}
+
+static void __exit zip_cleanup_module(void)
+{
+	/* Unregister this driver for pci zip devices */
+	pci_unregister_driver(&zip_driver);
+
+	/* Unregister from the kernel crypto interface */
+	zip_unregister_compression_device();
+
+	pr_info("ThunderX-ZIP driver is removed successfully\n");
+}
+
+module_init(zip_init_module);
+module_exit(zip_cleanup_module);
+
+MODULE_AUTHOR("Cavium Inc");
+MODULE_DESCRIPTION("Cavium Inc ThunderX ZIP Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(pci, zip_id_table);
diff --git a/drivers/crypto/cavium/zip/zip_main.h b/drivers/crypto/cavium/zip/zip_main.h
new file mode 100644
index 0000000..73b9e6d
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_main.h
@@ -0,0 +1,126 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2016 Cavium, Inc.
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
+#ifndef __ZIP_MAIN_H__
+#define __ZIP_MAIN_H__
+
+#include "zip_device.h"
+#include "zip_regs.h"
+
+/* PCI device IDs */
+#define PCI_DEVICE_ID_THUNDERX_ZIP   0xA01A
+
+/* ZIP device BARs */
+#define PCI_CFG_ZIP_PF_BAR0   0  /* Base addr for normal regs */
+#define PCI_CFG_ZIP_PF_BAR4   4  /* Base addr for MSI-X regs  */
+
+/* Maximum available zip queues */
+#define ZIP_MAX_NUM_QUEUES    8
+#define ZIP_MAXQ_PER_ZIPENG   4
+#define ZIP_NUMENG_CN88XX     2
+
+#define ZIP_128B_ALIGN        7
+
+/* Buffer size and alignment */
+#define ZIP_CMD_QBUF_SIZE     (8064 + 8)
+#define ZIP_CMD_QBUF_ALIGN    128
+#define ZIP_DATA_BUF_ALIGN    8
+
+/*
+ * There will be max of 2^20 zip cmds in the zip instruction queue.
+ * So no of zip Chunk buffers = ((2^20) / ((2*1024)/64))
+ */
+#define ZIP_MAX_CMD           (1024 * 1024)
+#define ZIP_CMD_PER_BUF       (ZIP_CMD_QBUF_SIZE / 64)
+#define ZIP_CMD_QBUF_MAX_CNT  (1 * 1024)
+
+/* Data buffer size 64K for time being */
+#define ZIP_DATA_BUF_SIZE     (64 * 1024)
+
+/* Number of data buffers */
+#define ZIP_DATA_BUF_CNT      (32 * 1024)
+
+struct zip_registers {
+	char  *reg_name;
+	u64   reg_offset;
+};
+
+/* ZIP Instruction Queue */
+struct zip_iq {
+	u64        *sw_head;
+	u64        *sw_tail;
+	u64        *hw_tail;
+	u64        done_cnt;
+	u64        pend_cnt;
+	u64        free_flag;
+
+	/* ZIP IQ lock */
+	spinlock_t  lock;
+};
+
+/* ZIP Device */
+struct zip_device {
+	u32               index;
+	void __iomem      *reg_base;
+	struct pci_dev    *pdev;
+
+	/* Different ZIP Constants */
+	u64               depth;
+	u64               onfsize;
+	u64               ctxsize;
+
+	struct zip_iq     iq[ZIP_MAX_NUM_QUEUES];
+};
+
+/* Prototypes */
+struct zip_device *zip_get_device(int node_id);
+int zip_get_node_id(void);
+int zip_get_zipeng_count(void);
+void zip_reg_write(u64 val, u64 __iomem *addr);
+u64 zip_reg_read(u64 __iomem *addr);
+void zip_update_cmd_bufs(struct zip_device *zip_dev, u32 queue);
+u32 zip_load_instr(union zip_inst_s *instr, struct zip_device *zip_dev);
+
+#endif /* ZIP_MAIN_H */
diff --git a/drivers/crypto/cavium/zip/zip_mem.c b/drivers/crypto/cavium/zip/zip_mem.c
new file mode 100644
index 0000000..cf1800f5
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_mem.c
@@ -0,0 +1,120 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2016 Cavium, Inc.
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
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+
+#include "common.h"
+
+/**
+ * zip_cmd_qbuf_alloc - Allocates a cmd buffer for ZIP Instruction Queue
+ * @zip: Pointer to zip device structure
+ * @q:   Queue number to allocate bufffer to
+ * Return: 0 if successful, -ENOMEM otherwise
+ */
+int zip_cmd_qbuf_alloc(struct zip_device *zip, int q)
+{
+	zip_dbg_enter();
+
+	zip->iq[q].sw_head = (u64 *)__get_free_pages((GFP_KERNEL | GFP_DMA),
+						get_order(ZIP_CMD_QBUF_SIZE));
+
+	if (!zip->iq[q].sw_head)
+		return -ENOMEM;
+
+	memset(zip->iq[q].sw_head, 0, ZIP_CMD_QBUF_SIZE);
+
+	zip_dbg("cmd_qbuf_alloc[%d] Success : %p\n", q, zip->iq[q].sw_head);
+	zip_dbg_exit();
+	return 0;
+}
+
+/**
+ * zip_cmd_qbuf_free - Frees the cmd Queue buffer
+ * @zip: Pointer to zip device structure
+ * @q:   Queue number to free buffer of
+ */
+void zip_cmd_qbuf_free(struct zip_device *zip, int q)
+{
+	zip_dbg("Freeing cmd_qbuf 0x%lx\n", zip->iq[q].sw_tail);
+
+	free_pages((u64)zip->iq[q].sw_tail, get_order(ZIP_CMD_QBUF_SIZE));
+}
+
+/**
+ * zip_data_buf_alloc - Allocates memory for a data bufffer
+ * @size:   Size of the buffer to allocate
+ * Returns: Pointer to the buffer allocated
+ */
+u8 *zip_data_buf_alloc(u64 size)
+{
+	u8 *ptr;
+
+	zip_dbg_enter();
+
+	ptr = (u8 *)__get_free_pages((GFP_ATOMIC | GFP_DMA),
+					get_order(size));
+
+	if (!ptr)
+		return NULL;
+
+	memset(ptr, 0, size);
+
+	zip_dbg("Data buffer allocation success\n");
+	zip_dbg_exit();
+	return ptr;
+}
+
+/**
+ * zip_data_buf_free - Frees the memory of a data buffer
+ * @ptr:  Pointer to the buffer
+ * @size: Buffer size
+ */
+void zip_data_buf_free(u8 *ptr, u64 size)
+{
+	zip_dbg("Freeing data buffer 0x%lx\n", ptr);
+
+	free_pages((u64)ptr, get_order(size));
+}
diff --git a/drivers/crypto/cavium/zip/zip_mem.h b/drivers/crypto/cavium/zip/zip_mem.h
new file mode 100644
index 0000000..23591d8
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_mem.h
@@ -0,0 +1,78 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2016 Cavium, Inc.
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
+#ifndef __ZIP_MEM_H__
+#define __ZIP_MEM_H__
+
+/**
+ * zip_cmd_qbuf_free - Frees the cmd Queue buffer
+ * @zip: Pointer to zip device structure
+ * @q:   Queue nmber to free buffer of
+ */
+void zip_cmd_qbuf_free(struct zip_device *zip, int q);
+
+/**
+ * zip_cmd_qbuf_alloc - Allocates a Chunk/cmd buffer for ZIP Inst(cmd) Queue
+ * @zip: Pointer to zip device structure
+ * @q:   Queue number to allocate bufffer to
+ * Return: 0 if successful, 1 otherwise
+ */
+int zip_cmd_qbuf_alloc(struct zip_device *zip, int q);
+
+/**
+ * zip_data_buf_alloc - Allocates memory for a data bufffer
+ * @size:   Size of the buffer to allocate
+ * Returns: Pointer to the buffer allocated
+ */
+u8 *zip_data_buf_alloc(u64 size);
+
+/**
+ * zip_data_buf_free - Frees the memory of a data buffer
+ * @ptr:  Pointer to the buffer
+ * @size: Buffer size
+ */
+void zip_data_buf_free(u8 *ptr, u64 size);
+
+#endif
diff --git a/drivers/crypto/cavium/zip/zip_regs.h b/drivers/crypto/cavium/zip/zip_regs.h
new file mode 100644
index 0000000..ec913ad
--- /dev/null
+++ b/drivers/crypto/cavium/zip/zip_regs.h
@@ -0,0 +1,1326 @@
+/***********************license start************************************
+ * Copyright (c) 2003-2016 Cavium, Inc.
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
+#ifndef __ZIP_REGS_H__
+#define __ZIP_REGS_H__
+
+/*
+ * Configuration and status register (CSR) address and type definitions for
+ * Cavium ZIP.
+ */
+
+#include <linux/kern_levels.h>
+
+/**
+ * enum zip_comp_e - ZIP Completion Enumeration, enumerates the values of
+ * ZIP_ZRES_S[COMPCODE].
+ */
+enum zip_comp_e {
+	ZIP_COMP_E_BADCODE = 0x7,
+	ZIP_COMP_E_BADCODE2 = 0x8,
+	ZIP_COMP_E_DTRUNC = 0x2,
+	ZIP_COMP_E_FATAL = 0xb,
+	ZIP_COMP_E_ITRUNC = 0x4,
+	ZIP_COMP_E_NLEN = 0x6,
+	ZIP_COMP_E_NOTDONE = 0x0,
+	ZIP_COMP_E_PARITY = 0xa,
+	ZIP_COMP_E_RBLOCK = 0x5,
+	ZIP_COMP_E_STOP = 0x3,
+	ZIP_COMP_E_SUCCESS = 0x1,
+	ZIP_COMP_E_ZERO_LEN = 0x9,
+	ZIP_COMP_E_ENUM_LAST = 0xc,
+};
+
+/**
+ * enum zip_int_vec_e - ZIP MSI-X Vector Enumeration, enumerates the MSI-X
+ * interrupt vectors.
+ */
+enum zip_int_vec_e {
+	ZIP_INT_VEC_E_ECCE = 0x10,
+	ZIP_INT_VEC_E_FIFE = 0x11,
+	ZIP_INT_VEC_E_QUE0_DONE = 0x0,
+	ZIP_INT_VEC_E_QUE0_ERR = 0x8,
+	ZIP_INT_VEC_E_QUE1_DONE = 0x1,
+	ZIP_INT_VEC_E_QUE1_ERR = 0x9,
+	ZIP_INT_VEC_E_QUE2_DONE = 0x2,
+	ZIP_INT_VEC_E_QUE2_ERR = 0xa,
+	ZIP_INT_VEC_E_QUE3_DONE = 0x3,
+	ZIP_INT_VEC_E_QUE3_ERR = 0xb,
+	ZIP_INT_VEC_E_QUE4_DONE = 0x4,
+	ZIP_INT_VEC_E_QUE4_ERR = 0xc,
+	ZIP_INT_VEC_E_QUE5_DONE = 0x5,
+	ZIP_INT_VEC_E_QUE5_ERR = 0xd,
+	ZIP_INT_VEC_E_QUE6_DONE = 0x6,
+	ZIP_INT_VEC_E_QUE6_ERR = 0xe,
+	ZIP_INT_VEC_E_QUE7_DONE = 0x7,
+	ZIP_INT_VEC_E_QUE7_ERR = 0xf,
+	ZIP_INT_VEC_E_ENUM_LAST = 0x12,
+};
+
+/**
+ * union zip_zptr_addr_s - ZIP Generic Pointer Structure for ADDR.
+ *
+ * It is the generic format of pointers in ZIP_INST_S.
+ */
+union zip_zptr_addr_s {
+	u64 u_reg64;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_49_63              : 15;
+		u64 addr                        : 49;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 addr                        : 49;
+		u64 reserved_49_63              : 15;
+#endif
+	} s;
+
+};
+
+/**
+ * union zip_zptr_ctl_s - ZIP Generic Pointer Structure for CTL.
+ *
+ * It is the generic format of pointers in ZIP_INST_S.
+ */
+union zip_zptr_ctl_s {
+	u64 u_reg64;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_112_127            : 16;
+		u64 length                      : 16;
+		u64 reserved_67_95              : 29;
+		u64 fw                          : 1;
+		u64 nc                          : 1;
+		u64 data_be                     : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 data_be                     : 1;
+		u64 nc                          : 1;
+		u64 fw                          : 1;
+		u64 reserved_67_95              : 29;
+		u64 length                      : 16;
+		u64 reserved_112_127            : 16;
+#endif
+	} s;
+};
+
+/**
+ * union zip_inst_s - ZIP Instruction Structure.
+ * Each ZIP instruction has 16 words (they are called IWORD0 to IWORD15 within
+ * the structure).
+ */
+union zip_inst_s {
+	u64 u_reg64[16];
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 doneint                     : 1;
+		u64 reserved_56_62              : 7;
+		u64 totaloutputlength           : 24;
+		u64 reserved_27_31              : 5;
+		u64 exn                         : 3;
+		u64 reserved_23_23              : 1;
+		u64 exbits                      : 7;
+		u64 reserved_12_15              : 4;
+		u64 sf                          : 1;
+		u64 ss                          : 2;
+		u64 cc                          : 2;
+		u64 ef                          : 1;
+		u64 bf                          : 1;
+		u64 ce                          : 1;
+		u64 reserved_3_3                : 1;
+		u64 ds                          : 1;
+		u64 dg                          : 1;
+		u64 hg                          : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 hg                          : 1;
+		u64 dg                          : 1;
+		u64 ds                          : 1;
+		u64 reserved_3_3                : 1;
+		u64 ce                          : 1;
+		u64 bf                          : 1;
+		u64 ef                          : 1;
+		u64 cc                          : 2;
+		u64 ss                          : 2;
+		u64 sf                          : 1;
+		u64 reserved_12_15              : 4;
+		u64 exbits                      : 7;
+		u64 reserved_23_23              : 1;
+		u64 exn                         : 3;
+		u64 reserved_27_31              : 5;
+		u64 totaloutputlength           : 24;
+		u64 reserved_56_62              : 7;
+		u64 doneint                     : 1;
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 historylength               : 16;
+		u64 reserved_96_111             : 16;
+		u64 adlercrc32                  : 32;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 adlercrc32                  : 32;
+		u64 reserved_96_111             : 16;
+		u64 historylength               : 16;
+#endif
+		union zip_zptr_addr_s ctx_ptr_addr;
+		union zip_zptr_ctl_s ctx_ptr_ctl;
+		union zip_zptr_addr_s his_ptr_addr;
+		union zip_zptr_ctl_s his_ptr_ctl;
+		union zip_zptr_addr_s inp_ptr_addr;
+		union zip_zptr_ctl_s inp_ptr_ctl;
+		union zip_zptr_addr_s out_ptr_addr;
+		union zip_zptr_ctl_s out_ptr_ctl;
+		union zip_zptr_addr_s res_ptr_addr;
+		union zip_zptr_ctl_s res_ptr_ctl;
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_817_831            : 15;
+		u64 wq_ptr                      : 49;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 wq_ptr                      : 49;
+		u64 reserved_817_831            : 15;
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_882_895            : 14;
+		u64 tt                          : 2;
+		u64 reserved_874_879            : 6;
+		u64 grp                         : 10;
+		u64 tag                         : 32;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 tag                         : 32;
+		u64 grp                         : 10;
+		u64 reserved_874_879            : 6;
+		u64 tt                          : 2;
+		u64 reserved_882_895            : 14;
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_896_959            : 64;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 reserved_896_959            : 64;
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_960_1023           : 64;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 reserved_960_1023           : 64;
+#endif
+	} s;
+};
+
+/**
+ * union zip_nptr_s - ZIP Instruction Next-Chunk-Buffer Pointer (NPTR)
+ * Structure
+ *
+ * ZIP_NPTR structure is used to chain all the zip instruction buffers
+ * together. ZIP instruction buffers are managed (allocated and released) by
+ * the software.
+ */
+union zip_nptr_s {
+	u64 u_reg64;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_49_63              : 15;
+		u64 addr                        : 49;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 addr                        : 49;
+		u64 reserved_49_63              : 15;
+#endif
+	} s;
+};
+
+/**
+ * union zip_zptr_s - ZIP Generic Pointer Structure.
+ *
+ * It is the generic format of pointers in ZIP_INST_S.
+ */
+union zip_zptr_s {
+	u64 u_reg64[2];
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_49_63              : 15;
+		u64 addr                        : 49;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 addr                        : 49;
+		u64 reserved_49_63              : 15;
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_112_127            : 16;
+		u64 length                      : 16;
+		u64 reserved_67_95              : 29;
+		u64 fw                          : 1;
+		u64 nc                          : 1;
+		u64 data_be                     : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 data_be                     : 1;
+		u64 nc                          : 1;
+		u64 fw                          : 1;
+		u64 reserved_67_95              : 29;
+		u64 length                      : 16;
+		u64 reserved_112_127            : 16;
+#endif
+	} s;
+};
+
+/**
+ * union zip_zres_s - ZIP Result Structure
+ *
+ * The ZIP coprocessor writes the result structure after it completes the
+ * invocation. The result structure is exactly 24 bytes, and each invocation of
+ * the ZIP coprocessor produces exactly one result structure.
+ */
+union zip_zres_s {
+	u64 u_reg64[3];
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 crc32                       : 32;
+		u64 adler32                     : 32;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 adler32                     : 32;
+		u64 crc32                       : 32;
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 totalbyteswritten           : 32;
+		u64 totalbytesread              : 32;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 totalbytesread              : 32;
+		u64 totalbyteswritten           : 32;
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 totalbitsprocessed          : 32;
+		u64 doneint                     : 1;
+		u64 reserved_155_158            : 4;
+		u64 exn                         : 3;
+		u64 reserved_151_151            : 1;
+		u64 exbits                      : 7;
+		u64 reserved_137_143            : 7;
+		u64 ef                          : 1;
+
+		volatile u64 compcode           : 8;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+
+		volatile u64 compcode           : 8;
+		u64 ef                          : 1;
+		u64 reserved_137_143            : 7;
+		u64 exbits                      : 7;
+		u64 reserved_151_151            : 1;
+		u64 exn                         : 3;
+		u64 reserved_155_158            : 4;
+		u64 doneint                     : 1;
+		u64 totalbitsprocessed          : 32;
+#endif
+	} s;
+};
+
+/**
+ * union zip_cmd_ctl - Structure representing the register that controls
+ * clock and reset.
+ */
+union zip_cmd_ctl {
+	u64 u_reg64;
+	struct zip_cmd_ctl_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_2_63               : 62;
+		u64 forceclk                    : 1;
+		u64 reset                       : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 reset                       : 1;
+		u64 forceclk                    : 1;
+		u64 reserved_2_63               : 62;
+#endif
+	} s;
+};
+
+#define ZIP_CMD_CTL 0x0ull
+
+/**
+ * union zip_constants - Data structure representing the register that contains
+ * all of the current implementation-related parameters of the zip core in this
+ * chip.
+ */
+union zip_constants {
+	u64 u_reg64;
+	struct zip_constants_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 nexec                       : 8;
+		u64 reserved_49_55              : 7;
+		u64 syncflush_capable           : 1;
+		u64 depth                       : 16;
+		u64 onfsize                     : 12;
+		u64 ctxsize                     : 12;
+		u64 reserved_1_7                : 7;
+		u64 disabled                    : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 disabled                    : 1;
+		u64 reserved_1_7                : 7;
+		u64 ctxsize                     : 12;
+		u64 onfsize                     : 12;
+		u64 depth                       : 16;
+		u64 syncflush_capable           : 1;
+		u64 reserved_49_55              : 7;
+		u64 nexec                       : 8;
+#endif
+	} s;
+};
+
+#define ZIP_CONSTANTS 0x00A0ull
+
+/**
+ * union zip_corex_bist_status - Represents registers which have the BIST
+ * status of memories in zip cores.
+ *
+ * Each bit is the BIST result of an individual memory
+ * (per bit, 0 = pass and 1 = fail).
+ */
+union zip_corex_bist_status {
+	u64 u_reg64;
+	struct zip_corex_bist_status_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_53_63              : 11;
+		u64 bstatus                     : 53;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 bstatus                     : 53;
+		u64 reserved_53_63              : 11;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_COREX_BIST_STATUS(u64 param1)
+{
+	if (((param1 <= 1)))
+		return 0x0520ull + (param1 & 1) * 0x8ull;
+	pr_err("ZIP_COREX_BIST_STATUS: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_ctl_bist_status - Represents register that has the BIST status of
+ * memories in ZIP_CTL (instruction buffer, G/S pointer FIFO, input data
+ * buffer, output data buffers).
+ *
+ * Each bit is the BIST result of an individual memory
+ * (per bit, 0 = pass and 1 = fail).
+ */
+union zip_ctl_bist_status {
+	u64 u_reg64;
+	struct zip_ctl_bist_status_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_9_63               : 55;
+		u64 bstatus                     : 9;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 bstatus                     : 9;
+		u64 reserved_9_63               : 55;
+#endif
+	} s;
+};
+
+#define ZIP_CTL_BIST_STATUS 0x0510ull
+
+/**
+ * union zip_ctl_cfg - Represents the register that controls the behavior of
+ * the ZIP DMA engines.
+ *
+ * It is recommended to keep default values for normal operation. Changing the
+ * values of the fields may be useful for diagnostics.
+ */
+union zip_ctl_cfg {
+	u64 u_reg64;
+	struct zip_ctl_cfg_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_52_63              : 12;
+		u64 ildf                        : 4;
+		u64 reserved_36_47              : 12;
+		u64 drtf                        : 4;
+		u64 reserved_27_31              : 5;
+		u64 stcf                        : 3;
+		u64 reserved_19_23              : 5;
+		u64 ldf                         : 3;
+		u64 reserved_2_15               : 14;
+		u64 busy                        : 1;
+		u64 reserved_0_0                : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 reserved_0_0                : 1;
+		u64 busy                        : 1;
+		u64 reserved_2_15               : 14;
+		u64 ldf                         : 3;
+		u64 reserved_19_23              : 5;
+		u64 stcf                        : 3;
+		u64 reserved_27_31              : 5;
+		u64 drtf                        : 4;
+		u64 reserved_36_47              : 12;
+		u64 ildf                        : 4;
+		u64 reserved_52_63              : 12;
+#endif
+	} s;
+};
+
+#define ZIP_CTL_CFG 0x0560ull
+
+/**
+ * union zip_dbg_corex_inst - Represents the registers that reflect the status
+ * of the current instruction that the ZIP core is executing or has executed.
+ *
+ * These registers are only for debug use.
+ */
+union zip_dbg_corex_inst {
+	u64 u_reg64;
+	struct zip_dbg_corex_inst_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 busy                        : 1;
+		u64 reserved_35_62              : 28;
+		u64 qid                         : 3;
+		u64 iid                         : 32;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 iid                         : 32;
+		u64 qid                         : 3;
+		u64 reserved_35_62              : 28;
+		u64 busy                        : 1;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_DBG_COREX_INST(u64 param1)
+{
+	if (((param1 <= 1)))
+		return 0x0640ull + (param1 & 1) * 0x8ull;
+	pr_err("ZIP_DBG_COREX_INST: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_dbg_corex_sta - Represents registers that reflect the status of
+ * the zip cores.
+ *
+ * They are for debug use only.
+ */
+union zip_dbg_corex_sta {
+	u64 u_reg64;
+	struct zip_dbg_corex_sta_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 busy                        : 1;
+		u64 reserved_37_62              : 26;
+		u64 ist                         : 5;
+		u64 nie                         : 32;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 nie                         : 32;
+		u64 ist                         : 5;
+		u64 reserved_37_62              : 26;
+		u64 busy                        : 1;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_DBG_COREX_STA(u64 param1)
+{
+	if (((param1 <= 1)))
+		return 0x0680ull + (param1 & 1) * 0x8ull;
+	pr_err("ZIP_DBG_COREX_STA: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_dbg_quex_sta - Represets registers that reflect status of the zip
+ * instruction queues.
+ *
+ * They are for debug use only.
+ */
+union zip_dbg_quex_sta {
+	u64 u_reg64;
+	struct zip_dbg_quex_sta_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 busy                        : 1;
+		u64 reserved_56_62              : 7;
+		u64 rqwc                        : 24;
+		u64 nii                         : 32;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 nii                         : 32;
+		u64 rqwc                        : 24;
+		u64 reserved_56_62              : 7;
+		u64 busy                        : 1;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_DBG_QUEX_STA(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x1800ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_DBG_QUEX_STA: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_ecc_ctl - Represents the register that enables ECC for each
+ * individual internal memory that requires ECC.
+ *
+ * For debug purpose, it can also flip one or two bits in the ECC data.
+ */
+union zip_ecc_ctl {
+	u64 u_reg64;
+	struct zip_ecc_ctl_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_19_63              : 45;
+		u64 vmem_cdis                   : 1;
+		u64 vmem_fs                     : 2;
+		u64 reserved_15_15              : 1;
+		u64 idf1_cdis                   : 1;
+		u64 idf1_fs                     : 2;
+		u64 reserved_11_11              : 1;
+		u64 idf0_cdis                   : 1;
+		u64 idf0_fs                     : 2;
+		u64 reserved_7_7                : 1;
+		u64 gspf_cdis                   : 1;
+		u64 gspf_fs                     : 2;
+		u64 reserved_3_3                : 1;
+		u64 iqf_cdis                    : 1;
+		u64 iqf_fs                      : 2;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 iqf_fs                      : 2;
+		u64 iqf_cdis                    : 1;
+		u64 reserved_3_3                : 1;
+		u64 gspf_fs                     : 2;
+		u64 gspf_cdis                   : 1;
+		u64 reserved_7_7                : 1;
+		u64 idf0_fs                     : 2;
+		u64 idf0_cdis                   : 1;
+		u64 reserved_11_11              : 1;
+		u64 idf1_fs                     : 2;
+		u64 idf1_cdis                   : 1;
+		u64 reserved_15_15              : 1;
+		u64 vmem_fs                     : 2;
+		u64 vmem_cdis                   : 1;
+		u64 reserved_19_63              : 45;
+#endif
+	} s;
+};
+
+#define ZIP_ECC_CTL 0x0568ull
+
+/* NCB - zip_ecce_ena_w1c */
+union zip_ecce_ena_w1c {
+	u64 u_reg64;
+	struct zip_ecce_ena_w1c_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_37_63              : 27;
+		u64 dbe                         : 5;
+		u64 reserved_5_31               : 27;
+		u64 sbe                         : 5;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 sbe                         : 5;
+		u64 reserved_5_31               : 27;
+		u64 dbe                         : 5;
+		u64 reserved_37_63              : 27;
+#endif
+	} s;
+};
+
+#define ZIP_ECCE_ENA_W1C 0x0598ull
+
+/* NCB - zip_ecce_ena_w1s */
+union zip_ecce_ena_w1s {
+	u64 u_reg64;
+	struct zip_ecce_ena_w1s_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_37_63              : 27;
+		u64 dbe                         : 5;
+		u64 reserved_5_31               : 27;
+		u64 sbe                         : 5;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 sbe                         : 5;
+		u64 reserved_5_31               : 27;
+		u64 dbe                         : 5;
+		u64 reserved_37_63              : 27;
+#endif
+	} s;
+};
+
+#define ZIP_ECCE_ENA_W1S 0x0590ull
+
+/**
+ * union zip_ecce_int - Represents the register that contains the status of the
+ * ECC interrupt sources.
+ */
+union zip_ecce_int {
+	u64 u_reg64;
+	struct zip_ecce_int_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_37_63              : 27;
+		u64 dbe                         : 5;
+		u64 reserved_5_31               : 27;
+		u64 sbe                         : 5;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 sbe                         : 5;
+		u64 reserved_5_31               : 27;
+		u64 dbe                         : 5;
+		u64 reserved_37_63              : 27;
+#endif
+	} s;
+};
+
+#define ZIP_ECCE_INT 0x0580ull
+
+/* NCB - zip_ecce_int_w1s */
+union zip_ecce_int_w1s {
+	u64 u_reg64;
+	struct zip_ecce_int_w1s_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_37_63              : 27;
+		u64 dbe                         : 5;
+		u64 reserved_5_31               : 27;
+		u64 sbe                         : 5;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 sbe                         : 5;
+		u64 reserved_5_31               : 27;
+		u64 dbe                         : 5;
+		u64 reserved_37_63              : 27;
+#endif
+	} s;
+};
+
+#define ZIP_ECCE_INT_W1S 0x0588ull
+
+/* NCB - zip_fife_ena_w1c */
+union zip_fife_ena_w1c {
+	u64 u_reg64;
+	struct zip_fife_ena_w1c_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_42_63              : 22;
+		u64 asserts                     : 42;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 asserts                     : 42;
+		u64 reserved_42_63              : 22;
+#endif
+	} s;
+};
+
+#define ZIP_FIFE_ENA_W1C 0x0090ull
+
+/* NCB - zip_fife_ena_w1s */
+union zip_fife_ena_w1s {
+	u64 u_reg64;
+	struct zip_fife_ena_w1s_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_42_63              : 22;
+		u64 asserts                     : 42;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 asserts                     : 42;
+		u64 reserved_42_63              : 22;
+#endif
+	} s;
+};
+
+#define ZIP_FIFE_ENA_W1S 0x0088ull
+
+/* NCB - zip_fife_int */
+union zip_fife_int {
+	u64 u_reg64;
+	struct zip_fife_int_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_42_63              : 22;
+		u64 asserts                     : 42;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 asserts                     : 42;
+		u64 reserved_42_63              : 22;
+#endif
+	} s;
+};
+
+#define ZIP_FIFE_INT 0x0078ull
+
+/* NCB - zip_fife_int_w1s */
+union zip_fife_int_w1s {
+	u64 u_reg64;
+	struct zip_fife_int_w1s_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_42_63              : 22;
+		u64 asserts                     : 42;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 asserts                     : 42;
+		u64 reserved_42_63              : 22;
+#endif
+	} s;
+};
+
+#define ZIP_FIFE_INT_W1S 0x0080ull
+
+/**
+ * union zip_msix_pbax - Represents the register that is the MSI-X PBA table
+ *
+ * The bit number is indexed by the ZIP_INT_VEC_E enumeration.
+ */
+union zip_msix_pbax {
+	u64 u_reg64;
+	struct zip_msix_pbax_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 pend                        : 64;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 pend                        : 64;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_MSIX_PBAX(u64 param1)
+{
+	if (((param1 == 0)))
+		return 0x0000838000FF0000ull;
+	pr_err("ZIP_MSIX_PBAX: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_msix_vecx_addr - Represents the register that is the MSI-X vector
+ * table, indexed by the ZIP_INT_VEC_E enumeration.
+ */
+union zip_msix_vecx_addr {
+	u64 u_reg64;
+	struct zip_msix_vecx_addr_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_49_63              : 15;
+		u64 addr                        : 47;
+		u64 reserved_1_1                : 1;
+		u64 secvec                      : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 secvec                      : 1;
+		u64 reserved_1_1                : 1;
+		u64 addr                        : 47;
+		u64 reserved_49_63              : 15;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_MSIX_VECX_ADDR(u64 param1)
+{
+	if (((param1 <= 17)))
+		return 0x0000838000F00000ull + (param1 & 31) * 0x10ull;
+	pr_err("ZIP_MSIX_VECX_ADDR: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_msix_vecx_ctl - Represents the register that is the MSI-X vector
+ * table, indexed by the ZIP_INT_VEC_E enumeration.
+ */
+union zip_msix_vecx_ctl {
+	u64 u_reg64;
+	struct zip_msix_vecx_ctl_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_33_63              : 31;
+		u64 mask                        : 1;
+		u64 reserved_20_31              : 12;
+		u64 data                        : 20;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 data                        : 20;
+		u64 reserved_20_31              : 12;
+		u64 mask                        : 1;
+		u64 reserved_33_63              : 31;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_MSIX_VECX_CTL(u64 param1)
+{
+	if (((param1 <= 17)))
+		return 0x0000838000F00008ull + (param1 & 31) * 0x10ull;
+	pr_err("ZIP_MSIX_VECX_CTL: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_quex_done - Represents the registers that contain the per-queue
+ * instruction done count.
+ */
+union zip_quex_done {
+	u64 u_reg64;
+	struct zip_quex_done_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_20_63              : 44;
+		u64 done                        : 20;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 done                        : 20;
+		u64 reserved_20_63              : 44;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_DONE(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x2000ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_DONE: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_quex_done_ack - Represents the registers on write to which will
+ * decrement the per-queue instructiona done count.
+ */
+union zip_quex_done_ack {
+	u64 u_reg64;
+	struct zip_quex_done_ack_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_20_63              : 44;
+		u64 done_ack                    : 20;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 done_ack                    : 20;
+		u64 reserved_20_63              : 44;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_DONE_ACK(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x2200ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_DONE_ACK: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_quex_done_ena_w1c - Represents the register which when written
+ * 1 to will disable the DONEINT interrupt for the queue.
+ */
+union zip_quex_done_ena_w1c {
+	u64 u_reg64;
+	struct zip_quex_done_ena_w1c_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_1_63               : 63;
+		u64 done_ena                    : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 done_ena                    : 1;
+		u64 reserved_1_63               : 63;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_DONE_ENA_W1C(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x2600ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_DONE_ENA_W1C: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_quex_done_ena_w1s - Represents the register that when written 1 to
+ * will enable the DONEINT interrupt for the queue.
+ */
+union zip_quex_done_ena_w1s {
+	u64 u_reg64;
+	struct zip_quex_done_ena_w1s_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_1_63               : 63;
+		u64 done_ena                    : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 done_ena                    : 1;
+		u64 reserved_1_63               : 63;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_DONE_ENA_W1S(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x2400ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_DONE_ENA_W1S: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_quex_done_wait - Represents the register that specifies the per
+ * queue interrupt coalescing settings.
+ */
+union zip_quex_done_wait {
+	u64 u_reg64;
+	struct zip_quex_done_wait_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_48_63              : 16;
+		u64 time_wait                   : 16;
+		u64 reserved_20_31              : 12;
+		u64 num_wait                    : 20;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 num_wait                    : 20;
+		u64 reserved_20_31              : 12;
+		u64 time_wait                   : 16;
+		u64 reserved_48_63              : 16;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_DONE_WAIT(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x2800ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_DONE_WAIT: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_quex_doorbell - Represents doorbell registers for the ZIP
+ * instruction queues.
+ */
+union zip_quex_doorbell {
+	u64 u_reg64;
+	struct zip_quex_doorbell_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_20_63              : 44;
+		u64 dbell_cnt                   : 20;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 dbell_cnt                   : 20;
+		u64 reserved_20_63              : 44;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_DOORBELL(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x4000ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_DOORBELL: %llu\n", param1);
+	return 0;
+}
+
+union zip_quex_err_ena_w1c {
+	u64 u_reg64;
+	struct zip_quex_err_ena_w1c_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_5_63               : 59;
+		u64 mdbe                        : 1;
+		u64 nwrp                        : 1;
+		u64 nrrp                        : 1;
+		u64 irde                        : 1;
+		u64 dovf                        : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 dovf                        : 1;
+		u64 irde                        : 1;
+		u64 nrrp                        : 1;
+		u64 nwrp                        : 1;
+		u64 mdbe                        : 1;
+		u64 reserved_5_63               : 59;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_ERR_ENA_W1C(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x3600ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_ERR_ENA_W1C: %llu\n", param1);
+	return 0;
+}
+
+union zip_quex_err_ena_w1s {
+	u64 u_reg64;
+	struct zip_quex_err_ena_w1s_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_5_63               : 59;
+		u64 mdbe                        : 1;
+		u64 nwrp                        : 1;
+		u64 nrrp                        : 1;
+		u64 irde                        : 1;
+		u64 dovf                        : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 dovf                        : 1;
+		u64 irde                        : 1;
+		u64 nrrp                        : 1;
+		u64 nwrp                        : 1;
+		u64 mdbe                        : 1;
+		u64 reserved_5_63               : 59;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_ERR_ENA_W1S(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x3400ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_ERR_ENA_W1S: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_quex_err_int - Represents registers that contain the per-queue
+ * error interrupts.
+ */
+union zip_quex_err_int {
+	u64 u_reg64;
+	struct zip_quex_err_int_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_5_63               : 59;
+		u64 mdbe                        : 1;
+		u64 nwrp                        : 1;
+		u64 nrrp                        : 1;
+		u64 irde                        : 1;
+		u64 dovf                        : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 dovf                        : 1;
+		u64 irde                        : 1;
+		u64 nrrp                        : 1;
+		u64 nwrp                        : 1;
+		u64 mdbe                        : 1;
+		u64 reserved_5_63               : 59;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_ERR_INT(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x3000ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_ERR_INT: %llu\n", param1);
+	return 0;
+}
+
+/* NCB - zip_que#_err_int_w1s */
+union zip_quex_err_int_w1s {
+	u64 u_reg64;
+	struct zip_quex_err_int_w1s_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_5_63               : 59;
+		u64 mdbe                        : 1;
+		u64 nwrp                        : 1;
+		u64 nrrp                        : 1;
+		u64 irde                        : 1;
+		u64 dovf                        : 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 dovf                        : 1;
+		u64 irde                        : 1;
+		u64 nrrp                        : 1;
+		u64 nwrp                        : 1;
+		u64 mdbe                        : 1;
+		u64 reserved_5_63               : 59;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_ERR_INT_W1S(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x3200ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_ERR_INT_W1S: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_quex_gcfg - Represents the registers that reflect status of the
+ * zip instruction queues,debug use only.
+ */
+union zip_quex_gcfg {
+	u64 u_reg64;
+	struct zip_quex_gcfg_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_4_63               : 60;
+		u64 iqb_ldwb                    : 1;
+		u64 cbw_sty                     : 1;
+		u64 l2ld_cmd                    : 2;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 l2ld_cmd                    : 2;
+		u64 cbw_sty                     : 1;
+		u64 iqb_ldwb                    : 1;
+		u64 reserved_4_63               : 60;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_GCFG(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x1A00ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_GCFG: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_quex_map - Represents the registers that control how each
+ * instruction queue maps to zip cores.
+ */
+union zip_quex_map {
+	u64 u_reg64;
+	struct zip_quex_map_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_2_63               : 62;
+		u64 zce                         : 2;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 zce                         : 2;
+		u64 reserved_2_63               : 62;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_MAP(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x1400ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_MAP: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_quex_sbuf_addr - Represents the registers that set the buffer
+ * parameters for the instruction queues.
+ *
+ * When quiescent (i.e. outstanding doorbell count is 0), it is safe to rewrite
+ * this register to effectively reset the command buffer state machine.
+ * These registers must be programmed after SW programs the corresponding
+ * ZIP_QUE(0..7)_SBUF_CTL.
+ */
+union zip_quex_sbuf_addr {
+	u64 u_reg64;
+	struct zip_quex_sbuf_addr_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_49_63              : 15;
+		u64 ptr                         : 42;
+		u64 off                         : 7;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 off                         : 7;
+		u64 ptr                         : 42;
+		u64 reserved_49_63              : 15;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_SBUF_ADDR(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x1000ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_SBUF_ADDR: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_quex_sbuf_ctl - Represents the registers that set the buffer
+ * parameters for the instruction queues.
+ *
+ * When quiescent (i.e. outstanding doorbell count is 0), it is safe to rewrite
+ * this register to effectively reset the command buffer state machine.
+ * These registers must be programmed before SW programs the corresponding
+ * ZIP_QUE(0..7)_SBUF_ADDR.
+ */
+union zip_quex_sbuf_ctl {
+	u64 u_reg64;
+	struct zip_quex_sbuf_ctl_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_45_63              : 19;
+		u64 size                        : 13;
+		u64 inst_be                     : 1;
+		u64 reserved_24_30              : 7;
+		u64 stream_id                   : 8;
+		u64 reserved_12_15              : 4;
+		u64 aura                        : 12;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 aura                        : 12;
+		u64 reserved_12_15              : 4;
+		u64 stream_id                   : 8;
+		u64 reserved_24_30              : 7;
+		u64 inst_be                     : 1;
+		u64 size                        : 13;
+		u64 reserved_45_63              : 19;
+#endif
+	} s;
+};
+
+static inline u64 ZIP_QUEX_SBUF_CTL(u64 param1)
+{
+	if (((param1 <= 7)))
+		return 0x1200ull + (param1 & 7) * 0x8ull;
+	pr_err("ZIP_QUEX_SBUF_CTL: %llu\n", param1);
+	return 0;
+}
+
+/**
+ * union zip_que_ena - Represents queue enable register
+ *
+ * If a queue is disabled, ZIP_CTL stops fetching instructions from the queue.
+ */
+union zip_que_ena {
+	u64 u_reg64;
+	struct zip_que_ena_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_8_63               : 56;
+		u64 ena                         : 8;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 ena                         : 8;
+		u64 reserved_8_63               : 56;
+#endif
+	} s;
+};
+
+#define ZIP_QUE_ENA 0x0500ull
+
+/**
+ * union zip_que_pri - Represents the register that defines the priority
+ * between instruction queues.
+ */
+union zip_que_pri {
+	u64 u_reg64;
+	struct zip_que_pri_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_8_63               : 56;
+		u64 pri                         : 8;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 pri                         : 8;
+		u64 reserved_8_63               : 56;
+#endif
+	} s;
+};
+
+#define ZIP_QUE_PRI 0x0508ull
+
+/**
+ * union zip_throttle - Represents the register that controls the maximum
+ * number of in-flight X2I data fetch transactions.
+ *
+ * Writing 0 to this register causes the ZIP module to temporarily suspend NCB
+ * accesses; it is not recommended for normal operation, but may be useful for
+ * diagnostics.
+ */
+union zip_throttle {
+	u64 u_reg64;
+	struct zip_throttle_s {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved_6_63               : 58;
+		u64 ld_infl                     : 6;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+		u64 ld_infl                     : 6;
+		u64 reserved_6_63               : 58;
+#endif
+	} s;
+};
+
+#define ZIP_THROTTLE 0x0010ull
+
+#endif /* _CSRS_ZIP__ */
-- 
2.9.0.rc0.21.g7777322

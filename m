From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: [patch 08/10] spufs: SPE side implementation of kspu
Date: Thu, 16 Aug 2007 22:01:13 +0200
Message-ID: <20070816200137.460008000@ml.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc>
Cc: <herbert@gondor.apana.org.au>, <arnd@arndb.de>, <jk@ozlabs.org>,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60617 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388AbXHPUF5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 16:05:57 -0400
Content-Disposition: inline; filename=spufs-add_kspu_spu_side.diff
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The SPU part of KSPU which consists of the a multiplexor and one helper
function. The multiplexor invokes the offloaded functions and performs multi
buffering (DMA_BUFFERS=2 -> double buffering, DMA_BUFFERS= -> triple \ldots).
The offloaded function cares only about processing the buffer and arranging
the transfer of the result. Waiting for the transfers to complete as well as
signaling the completion of functions is taken care of by the multiplexor.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

--- a/arch/powerpc/platforms/cell/spufs/Makefile
+++ b/arch/powerpc/platforms/cell/spufs/Makefile
@@ -12,13 +12,21 @@ SPU_AS		:= $(SPU_CROSS)gcc
 SPU_LD		:= $(SPU_CROSS)ld
 SPU_OBJCOPY	:= $(SPU_CROSS)objcopy
 SPU_CFLAGS	:= -O2 -Wall -I$(srctree)/include \
-		   -I$(objtree)/include2 -D__KERNEL__
+		   -I$(objtree)/include2 -D__KERNEL__ -ffreestanding
 SPU_AFLAGS	:= -c -D__ASSEMBLY__ -I$(srctree)/include \
 		   -I$(objtree)/include2 -D__KERNEL__
 SPU_LDFLAGS	:= -N -Ttext=0x0
 
 $(obj)/switch.o: $(obj)/spu_save_dump.h $(obj)/spu_restore_dump.h
-clean-files := spu_save_dump.h spu_restore_dump.h
+clean-files := spu_save_dump.h spu_restore_dump.h spu_kspu_dump.h
+
+$(obj)/kspu.o: $(obj)/spu_kspu_dump.h
+
+spu_kspu_code_obj-y += $(obj)/spu_main.o $(obj)/spu_runtime.o
+spu_kspu_code_obj-y += $(spu_kspu_code_obj-m)
+
+$(obj)/spu_kspu: $(spu_kspu_code_obj-y)
+	$(call if_changed,spu_ld)
 
 # Compile SPU files
       cmd_spu_cc = $(SPU_CC) $(SPU_CFLAGS) -c -o $@ $<
--- /dev/null
+++ b/arch/powerpc/platforms/cell/spufs/spu_main.c
@@ -0,0 +1,116 @@
+/*
+ * This code can be considered as crt0.S
+ * Compile with -O[123S] and make sure that here is only one function
+ * that starts at 0x0
+ * Author: Sebastian Siewior <sebastian@breakpoint.cc>
+ * License: GPLv2
+ */
+#include <asm/kspu/merged_code.h>
+#include <spu_mfcio.h>
+#include "spu_runtime.h"
+
+static spu_operation_t spu_ops[TOTAL_SPU_OPS] __attribute__((aligned(16))) = {
+	[SPU_OP_nop] = spu_nop,
+};
+static unsigned char kspu_buff[DMA_BUFFERS][DMA_MAX_TRANS_SIZE];
+
+void _start(void) __attribute__((noreturn));
+void _start(void)
+{
+	struct kernel_spu_data *spu_data;
+
+	spu_data = (struct kernel_spu_data *) KERNEL_SPU_DATA_OFFSET;
+
+	while (37) {
+		struct kspu_job *kjob;
+		unsigned char *dma_buff;
+		unsigned int consumed;
+		unsigned int outstanding;
+		unsigned int cur_req;
+		unsigned int cur_item;
+		unsigned int cur_buf;
+		unsigned int i;
+
+		spu_stop(1);
+		/*
+		 * Once started, it is guaranteed that atleast DMA_BUFFERS *2
+		 * requests are in ring buffer. The work order is:
+		 * 1. request DMA_BUFFERS transfers, every in a seperate buffer
+		 *    with its own tag.
+		 * 2. process those buffers and request new ones.
+		 * 3. if more than (DMA_BUFFERS *2) are available, than the
+		 *    main loop begins:
+		 *   - wait for tag to finish transfers
+		 *   - notify done work
+		 *   - process request
+		 *   - write back
+		 * 4. if no more request are available, process the last
+		 *    DMA_BUFFERS request that are left, write them back and
+		 *    wait until that transfers completes and spu_stop()
+		 */
+
+		consumed = spu_data->kspu_ring_data.consumed;
+		cur_req = consumed;
+		cur_item = consumed;
+
+		/* 1 */
+		for (cur_buf = 0; cur_buf < DMA_BUFFERS; cur_buf++) {
+			init_get_data(kspu_buff[cur_buf & DMA_BUFF_MASK],
+					&spu_data->work_item[cur_req & RB_MASK],
+					cur_buf & DMA_BUFF_MASK);
+			cur_req++;
+		}
+
+		/* 2 */
+		for (cur_buf = 0; cur_buf < DMA_BUFFERS; cur_buf++) {
+			wait_for_buffer(1 << (cur_buf & DMA_BUFF_MASK));
+
+			kjob = &spu_data->work_item[cur_item & RB_MASK];
+			dma_buff = kspu_buff[cur_buf & DMA_BUFF_MASK];
+			spu_ops[kjob->operation]
+				(kjob, dma_buff, cur_buf & DMA_BUFF_MASK);
+
+			init_get_data(dma_buff,
+					&spu_data->work_item[cur_req & RB_MASK],
+					cur_buf & DMA_BUFF_MASK);
+			cur_item++;
+			cur_req++;
+		}
+
+		outstanding = spu_data->kspu_ring_data.outstanding;
+		/* 3 */
+		while (cur_req != outstanding) {
+			wait_for_buffer(1 << (cur_buf & DMA_BUFF_MASK));
+			spu_data->kspu_ring_data.consumed++;
+			if (spu_stat_out_intr_mbox())
+				spu_write_out_intr_mbox(0x0);
+
+			kjob = &spu_data->work_item[cur_item & RB_MASK];
+			dma_buff = kspu_buff[cur_buf & DMA_BUFF_MASK];
+			spu_ops[kjob->operation]
+				(kjob, dma_buff, cur_buf & DMA_BUFF_MASK);
+
+			init_get_data(dma_buff,
+					&spu_data->work_item[cur_req & RB_MASK],
+					cur_buf & DMA_BUFF_MASK);
+			cur_item++;
+			cur_req++;
+			cur_buf++;
+			outstanding = spu_data->kspu_ring_data.outstanding;
+		}
+
+		/* 4 */
+		for (i = 0; i < DMA_BUFFERS; i++) {
+			wait_for_buffer(1 << (cur_buf & DMA_BUFF_MASK));
+			kjob = &spu_data->work_item[cur_item & RB_MASK];
+			dma_buff = kspu_buff[cur_buf & DMA_BUFF_MASK];
+			spu_ops[kjob->operation]
+				(kjob, dma_buff, cur_buf & DMA_BUFF_MASK);
+			cur_buf++;
+			cur_item++;
+		}
+
+		wait_for_buffer(ALL_DMA_BUFFS);
+		spu_data->kspu_ring_data.consumed = cur_item;
+	}
+}
--- /dev/null
+++ b/arch/powerpc/platforms/cell/spufs/spu_runtime.c
@@ -0,0 +1,40 @@
+/*
+ * Runtime helper functions, which intend to replace libc. They can't be merged
+ * into spu_main.c because it must be guaranteed that _start() starts at 0x0.
+ *
+ * Author: Sebastian Siewior <sebastian@breakpoint.cc>
+ * License: GPLv2
+ */
+
+#include <spu_intrinsics.h>
+#include <asm/kspu/merged_code.h>
+
+void spu_nop(struct kspu_job *kjob, void *buffer, unsigned int buf_num)
+{
+}
+
+/*
+ * memcpy_aligned - copy memory
+ * @src:	source of memory
+ * @dst:	destination
+ * @num:	number of bytes
+ *
+ * Copies @num bytes from @src to @dst. @src & @dst must be aligned at
+ * 16byte boundary. If @src or @dst is not properly aligned, wrong data will be
+ * read and or written. @num must be multiple of 16. If @num is not multiple of
+ * 16 than the function simply do nothing
+ */
+void memcpy_aligned(void *dest, const void *src, unsigned int num)
+{
+	const vector unsigned char *s = src;
+	vector unsigned char *d = dest;
+
+	if (num & 15)
+		return;
+	do {
+		*d = *s;
+		s++;
+		d++;
+		num -= 16;
+	} while (num);
+}
--- /dev/null
+++ b/arch/powerpc/platforms/cell/spufs/spu_runtime.h
@@ -0,0 +1,29 @@
+#ifndef SPU_RUNTIME_H
+#define SPU_RUNTIME_H
+#include <spu_mfcio.h>
+
+static inline void init_get_data(void *buf, struct kspu_job *job,
+		unsigned int dma_tag)
+{
+	mfc_getb(buf, job->in, job->in_size, dma_tag, 0, 0);
+}
+
+static inline void init_put_data(void *buf, unsigned long long ea,
+		unsigned int size, unsigned int dma_tag)
+{
+	mfc_putf(buf, ea, size, dma_tag, 0, 0);
+}
+
+static inline void wait_for_buffer(unsigned int dma_tag)
+{
+	mfc_write_tag_mask(dma_tag);
+	spu_mfcstat(MFC_TAG_UPDATE_ALL);
+}
+
+void memcpy_aligned(void *dest, const void *src, unsigned int n);
+
+/* exported offloaded functions */
+void spu_nop(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num);
+
+#endif
--- /dev/null
+++ b/include/asm-powerpc/kspu/merged_code.h
@@ -0,0 +1,51 @@
+#ifndef KSPU_MERGED_CODE_H
+#define KSPU_MERGED_CODE_H
+
+#define KSPU_LS_SIZE 0x40000
+
+#define RB_SLOTS 256
+#define RB_MASK (RB_SLOTS-1)
+
+#define DMA_MAX_TRANS_SIZE (16 * 1024)
+#define DMA_BUFFERS   2
+#define DMA_BUFF_MASK (DMA_BUFFERS-1)
+#define ALL_DMA_BUFFS ((1 << DMA_BUFFERS)-1)
+
+/*
+ * Every offloaded SPU operation has register itself in the SPU_OPERATIONS
+ * between SPU_OP_nop & TOTAL_SPU_OPS
+ */
+enum SPU_OPERATIONS {
+	SPU_OP_nop,
+
+	TOTAL_SPU_OPS,
+};
+
+struct kspu_job {
+	enum SPU_OPERATIONS operation __attribute__((aligned(16)));
+	unsigned long long in __attribute__((aligned(16)));
+	unsigned int in_size __attribute__((aligned(16)));
+	/*
+	 * This union is reserved for the parameter block of the offloaded
+	 * function.
+	 */
+	union {
+	} __attribute__((aligned(16)));
+};
+
+typedef void (*spu_operation_t)(struct kspu_job *kjob, void *buffer,
+		unsigned int buf_num);
+
+struct kspu_ring_data {
+	volatile unsigned int consumed __attribute__((aligned(16)));
+	volatile unsigned int outstanding __attribute__((aligned(16)));
+};
+
+struct kernel_spu_data {
+	struct kspu_ring_data kspu_ring_data __attribute__((aligned(16)));
+	struct kspu_job work_item[RB_SLOTS] __attribute__((aligned(16)));
+};
+
+#define KERNEL_SPU_DATA_OFFSET (KSPU_LS_SIZE - sizeof(struct kernel_spu_data))
+
+#endif

-- 

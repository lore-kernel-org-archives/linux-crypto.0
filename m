From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: [patch 03/10] spufs: kspu documentation
Date: Thu, 16 Aug 2007 22:01:08 +0200
Message-ID: <20070816200135.452834000@ml.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc>
Cc: <herbert@gondor.apana.org.au>, <arnd@arndb.de>, <jk@ozlabs.org>,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60612 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223AbXHPUFz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 16:05:55 -0400
Content-Disposition: inline; filename=spufs-kspu_doc.diff
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Documentation how to use kspu from the PPU & SPU side

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
--- /dev/null
+++ b/Documentation/powerpc/kspu.txt
@@ -0,0 +1,243 @@
+                  KSPU: Utilization of SPUs for kernel tasks
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+0. KSPU design
+==============
+
+The idea is to offload single time consuming tasks to the SPU. Those tasks are
+fed with data that they have to process.
+Once the function on the SPU side is invoked, the input data is already
+available. After the job is done, the offloaded function must kick off a DMA
+transfer, that transfers the result back to the main memory.
+On the PPU, the KSPU user queues the job temporary in a linked list and receives
+later a callback to put queue the job directly in SPU's ring buffer. The transit
+stop is required for two reasons:
+- It must be possible to queue work items from softirq context
+- All requests must be accepted, even if the ring buffer is full. Waiting (until
+	a slot becomes available) is not an option.
+
+The callback (for the enqueue process on the SPU) happens in a kthread context,
+so a mutex may be hold. However, there is only one kthread for this job, so
+every delay will have global impact.
+The user should enqueue only one job item on every enqueue request. The user
+may enqueue more than one job item if _really_ necessary. If there are not
+enough free slots than the enqueue function will be called as the first enqueue
+function once free slots are available again.
+After the offloaded function completed the job, the kthread calls the
+completion callback (it is the same kthread that is used for enqueue).
+Double/multi buffering is performed by KSPU.
+
+0.5 SPU usage
+=============
+Currently only one SPU is used and allocated. Allocation occurs during KSPU
+module initialization via the spufs interface. Therefore the physical SPU is
+considered in the scheduling process (and "shared" with user space). Right
+now, it is not "easy" to find out
+- how many SPUs may be taken (i.e. not used by user space)
+- how many SPUs are useful to be taken (depending of the workload)
+The later is (theoretically) an easy accounting approach if there are no
+dependencies in processing (and two jobs of the same kind may be processed on
+two SPUs in parallel).
+A second SPU (context) may be required if the local store memory is used up.
+This can be prevented if "overlays" are used. The advantage over several SPU
+context:
+- less complexity (since there is only one kind of SPU code)
+- no tracking which function is in which context. Plus overlay code switches
+	the binary probably faster than the scheduler does.
+
+1. Overview of memory layout
+=============================
+
+            ------------------ 256 KiB
+            |    RB ENTRY    |
+            ------------------ Ring buffer entries
+            |   .........    |
+            ------------------
+            |    RB ENTRY    |
+            ------------------
+            |    RB state    | (consumed + outstanding)
+            ------------------
+            |      STACK     | Stack growing downwards
+            |       ||       |
+            |       \/       |
+            ------------------
+            |     .......    |  unused / reserved :)
+            ------------------
+            |      Data      |
+            | DMA Buffers,   |
+            | functions'     |
+            | private data   |
+            ------------------
+            |      Code      |
+            | offloaded SPU  |
+            | functions      |
+            ------------------
+            |   multiplexor  | spu_main.c
+            ------------------ 0
+
+Type of Ring buffer entry is struct kspu_job.
+Number of ring buffer entries is determined by RB_SLOTS.
+Number of of DMA buffers is determined by DMA_BUFFERS.
+The stack grows uncontrolled. There is no (cheap) way to notice a stack
+overflow. After adding a new SPU program, the developer is encourage to check
+the stack usage and make sure the stack will never hit the data segment. This
+task is not required if recursive functions are used (I hope the suicide part
+has been understood).
+
+1.1 Ring buffer
+===============
+The ring buffer has been chosen because the data structure allows exchange of
+data (PPU <-> SPU) without any locking. The ring buffer entry consists of two
+parts
+- Data known by the KSPU (public data).
+- Private data is only known by the user (hidden from KSPU)
+Public data contains the function parameters of the offloaded SPU program.
+Private data is meaningless to the KSPU and may consider algorithm specific
+information (like where to put the result).
+The number of ring buffer entries (RB_SLOTS) has two constrains (except
+LS_SIZE :D):
+- it must be power of 2.
+- it must be at least DMA_BUFFERS*2
+
+1.2 DMA Buffers
+===============
+Every DMA buffer is DMA_MAX_TRANS_SIZE bytes in size. The size reflects the
+maximum transfer size that may be request by the SPU. Therefore the same
+requirements apply here like to the MFC DMA size: it must be a multiple of 16
+and may not by larger than 16KiB.
+The only limit for the number of available DMA buffers (DMA_BUFFERS) (besides
+the available space) is that "DMA_BUFFERS*2 <= RB_SLOTS" must be true. The
+reason for this constraint is that the "multiplexor", once started, requests
+DMA_BUFFERS buffers and starts processing. While processing the first batch,
+the next DMA_BUFFERS are requested (to get into streaming mode). After
+processing DMA_BUFFERS*2 requests, the first point is reached, where the SPU
+starts to notify the PPU about done requests and may stop. Therefore the
+shortest run is DMA_BUFFERS*2 requests. If there are not enough requests
+available, KSPU fills the ring buffer with NOPs to fit. A NOP is a DMA
+transfer with the size zero (nop for the MFC) and just a return statement as
+the job function.
+
+2. Offloading a task to SPU
+===========================
+Three steps are required to offload a task to SPU:
+- PPU code
+- SPU code
+- Update header files & Makefile
+
+The example code shows an example how to offload an 'add operation' via spu_add
+on the SPU. The complete implementation is in skeleton files.
+
+2.1 PPU code
+============
+1. Init
+- Prepare a struct with 'struct kspu_work_item' embedded in it.
+  struct my_spu_req {
+		struct kspu_work_item kspu_work;
+		void *data;
+	};
+
+- get global kspu ctx.
+    struct kspu_context *kctx = kspu_get_kctx();
+
+2. Enqueue a specific request. (struct my_spu_req spe_req)
+- Setup enqueue callback.
+  spe_req.kspu_work.enqueue = my_enqueue_func;
+
+- Enqueue it in kspu.
+  kspu_enqueue_work_item(kctx, &spe_req.kspu_work);
+
+3. Wait for the callback, enqueue it than on the SPU
+- Get an empty slot
+  struct kspu_job *work_item = kspu_get_rb_slot(kctx);
+
+- fill it
+  work_item->operation = MY_ADD;
+	work_item->in = spe_req.data;
+	work_item->in_size = 16;
+
+- mark it as ready
+  kspu_mark_rb_slot_ready(kctx, &spe_req.kspu_work);
+
+- set the finish callback
+  spe_req.kspu_work.notify = my_notify_func;
+
+4. Wait for the "finish" callback.
+- job finished.
+
+2.2 SPU code
+============
+- prepare a function that matches the following params:
+ void spu_my_add(struct kspu_job *kjob, void *buffer, unsigned int buf_num)
+
+	Use init_put_data() to write data back to main memory. It is just a wrapper
+	around mfc_putf(). Use the supplied buf_num as the tag.
+  init_put_data(buffer, out, length,	buf_num);
+
+2.3 Update files
+================
+- define your private data structures which are visible from your PPU program
+	and from your SPU program. They become later part of struct kspu_job if you
+	need them for parameters. Keep them as small as possible.
+
+- attach the function to SPU_OPS in
+	include/asm-powerpc/kspu/merged_code.h before TOTAL_SPU_OPS
+
+- attach the function to spu_funcs[] in arch/powerpc/platforms/cell/spufs/spu_main.c
+
+2.4 Skeleton files
+=================
+PPU code in Documentation/powerpc/kspu_ppu_skeleton.c
+SPU code in Documentation/powerpc/kspu_spu_skeleton.[ch]
+
+Merge both into kspu:
+--- a/arch/powerpc/platforms/cell/spufs/Makefile
++++ b/arch/powerpc/platforms/cell/spufs/Makefile
+@@ -24,6 +24,7 @@ kspu-y += kspu_helper.o kspu_code.o
+ $(obj)/kspu_code.o: $(obj)/spu_kspu_dump.h
+
+ spu_kspu_code_obj-y += $(obj)/spu_main.o $(obj)/spu_runtime.o
++spu_kspu_code_obj-y += $(obj)/spu_kspu_ppu_skeleton.o
+ spu_kspu_code_obj-y += $(spu_kspu_code_obj-m)
+
+ $(obj)/spu_kspu: $(spu_kspu_code_obj-y)
+
+--- a/arch/powerpc/platforms/cell/spufs/spu_main.c
++++ b/arch/powerpc/platforms/cell/spufs/spu_main.c
+@@ -13,6 +13,7 @@
+
+ static spu_operation_t spu_ops[TOTAL_SPU_FUNCS] __attribute__((aligned(16))) = {
+        [SPU_OP_nop] = spu_nop,
++       [SPU_OP_my_add] = spu_my_add
+ };
+
+ static unsigned char kspu_buff[DMA_BUFFERS][DMA_MAX_TRANS_SIZE];
+
+--- a/arch/powerpc/platforms/cell/spufs/spu_runtime.h
++++ b/arch/powerpc/platforms/cell/spufs/spu_runtime.h
+@@ -25,5 +25,6 @@ void memcpy_aligned(void *dest, const vo
+ /* exported offloaded functions */
+ void spu_nop(struct kspu_job *kjob, void *buffer,
+                unsigned int buf_num);
+
++void spu_my_add(struct kspu_job *kjob, void *buffer,
++               unsigned int buf_num);
+
+ #endif
+
+--- a/include/asm-powerpc/kspu/merged_code.h
++++ b/include/asm-powerpc/kspu/merged_code.h
+@@ -14,6 +14,7 @@
+
+ enum SPU_OPERATIONS {
+        SPU_OP_nop,
++       SPU_OP_my_add,
+
+        TOTAL_OP_FUNCS,
+ };
+@@ -23,6 +24,7 @@ struct kspu_job {
+        unsigned long long in __attribute__((aligned(16)));
+        unsigned int in_size __attribute__((aligned(16)));
+        union {
++               struct my_sum my_sum;
+        } __attribute__((aligned(16)));
+ };
+

-- 

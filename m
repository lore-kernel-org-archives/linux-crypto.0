From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: [patch 07/10] spufs: add kernel support for spu task
Date: Thu, 16 Aug 2007 22:01:12 +0200
Message-ID: <20070816200137.051342000@ml.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc>
Cc: <herbert@gondor.apana.org.au>, <arnd@arndb.de>, <jk@ozlabs.org>,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60619 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025AbXHPUF6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 16:05:58 -0400
Content-Disposition: inline; filename=spufs-add_kspu_ppu_side.diff
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Utilization of SPUs by the kernel, main implementation. 
Functions that are offloaded to the SPU must be spitted into two parts:
- SPU part (executing)
- PPU part (prepare/glue)

The SPU part expects a buffer and maybe some other parameters and performs
the work on the buffer. After the work/job is done, it requests the
transfer back into main memory.
The PPU part needs to split the information into this kind of job. Every
job consists of one buffer (16 KiB max) and a few parameters. Once
everything is prepared, the request is added to a list. There is soft
limit for the number of requests that fit into this list. Once the limit
is reached, all request are dropped (unless a flag is passed in order not
to). The limit makes sure the user is not trying to process faster than
the SPU is capable of. The "queue anyway" flag is necessary because under
some circumstances the user may not be able to drop the request or try
again later.
A separate thread dequeues the request(s) from the list and calls a user
supplied function in order to enqueue this request in a ring buffer which is
located on the SPU. This transit stop enables
- enqueuing items if the ring buffer is full (not the list)
- enqueuing items from non-blocking context
After the callback function returns, the SPU starts "immediately" the
work. Once the SPU performed the work, KSPU invokes another callback to inform
the user, that his request is complete. 
The PPU code is responsible for proper alignment & transfer size.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
--- a/arch/powerpc/platforms/cell/Kconfig
+++ b/arch/powerpc/platforms/cell/Kconfig
@@ -54,6 +54,13 @@ config SPU_BASE
 	bool
 	default n
 
+config KSPU
+	bool "Support for utilisation of SPU by the kernel"
+	depends on SPU_FS && EXPERIMENTAL
+	help
+	  With this option enabled, the kernel is able to utilize the SPUs for its
+	  own tasks.
+
 config CBE_RAS
 	bool "RAS features for bare metal Cell BE"
 	depends on PPC_CELL_NATIVE
--- a/arch/powerpc/platforms/cell/spufs/Makefile
+++ b/arch/powerpc/platforms/cell/spufs/Makefile
@@ -3,6 +3,7 @@ obj-y += switch.o fault.o lscsa_alloc.o
 obj-$(CONFIG_SPU_FS) += spufs.o
 spufs-y += inode.o file.o context.o syscalls.o coredump.o
 spufs-y += sched.o backing_ops.o hw_ops.o run.o gang.o
+spufs-$(CONFIG_KSPU) += kspu.o
 
 # Rules to build switch.o with the help of SPU tool chain
 SPU_CROSS	:= spu-
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -791,10 +791,17 @@ static int __init spufs_init(void)
 	if (ret)
 		goto out_syscalls;
 
+	ret = kspu_init();
+	if (ret)
+		goto out_archcoredump;
+
 	spufs_init_isolated_loader();
 
 	return 0;
 
+out_archcoredump:
+	printk("kspu_init() failed\n");
+	unregister_arch_coredump_calls(&spufs_coredump_calls);
 out_syscalls:
 	unregister_spu_syscalls(&spufs_calls);
 out_fs:
@@ -804,12 +811,14 @@ out_sched:
 out_cache:
 	kmem_cache_destroy(spufs_inode_cache);
 out:
+	printk("spufs init not performed\n");
 	return ret;
 }
 module_init(spufs_init);
 
 static void __exit spufs_exit(void)
 {
+	kspu_exit();
 	spu_sched_exit();
 	spufs_exit_isolated_loader();
 	unregister_arch_coredump_calls(&spufs_coredump_calls);
--- /dev/null
+++ b/arch/powerpc/platforms/cell/spufs/kspu.c
@@ -0,0 +1,645 @@
+/*
+ * Interface for accessing SPUs from the kernel.
+ *
+ * Author: Sebastian Siewior <sebastian@breakpoint.cc>
+ * License: GPLv2
+ *
+ * Utilization of SPUs by the kernel, main implementation.
+ * Functions that are offloaded to the SPU must be spitted into two parts:
+ * - SPU part (executing)
+ * - PPU part (prepare/glue)
+ *
+ * The SPU part expects a buffer and maybe some other parameters and performs
+ * the work on the buffer. After the work/job is done, it requests the
+ * transfer back into main memory.
+ * The PPU part needs to split the information into this kind of job. Every
+ * job consists of one buffer (16 KiB max) and a few parameters. Once
+ * everything is prepared, the request is added to a list. There is soft
+ * limit for the number of requests that fit into this list. Once the limit
+ * is reached, all request are dropped (unless a flag is passed in order not
+ * to). The limit makes sure the user is not trying to process faster than
+ * the SPU is capable of. The "queue anyway" flag is necessary because under
+ * some circumstances the user may not be able to drop the request or try
+ * again later.
+ * A separate thread dequeues the request(s) from the list and calls a user
+ * supplied function in order to enqueue this request in a ring buffer which is
+ * located on the SPU. This transit stop enables
+ * - enqueuing items if the ring buffer is full (not the list)
+ * - enqueuing items from non-blocking context
+ * After the callback function returns, the SPU starts "immediately" the
+ * work. Once the SPU performed the work, KSPU invokes another callback to
+ * inform the user, that his request is complete.
+ * The PPU code is responsible for proper alignment & transfer size.
+ */
+
+#include <asm/spu_priv1.h>
+#include <asm/kspu/kspu.h>
+#include <asm/kspu/merged_code.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/init_task.h>
+#include <linux/hardirq.h>
+#include <linux/kernel.h>
+
+#include "spufs.h"
+#include "kspu_util.h"
+#include "spu_kspu_dump.h"
+
+static struct kspu_code single_spu_code = {
+	.code = spu_kspu_code,
+	.code_len = sizeof(spu_kspu_code),
+	.kspu_data_offset = KERNEL_SPU_DATA_OFFSET,
+	.queue_mask = RB_SLOTS-1,
+	.queue_entr_size = sizeof(struct kspu_job),
+};
+
+static void free_kspu_context(struct kspu_context *kctx)
+{
+	struct spu_context *spu_ctx = kctx->spu_ctx;
+	int ret;
+
+	if (spu_ctx->owner)
+		spu_forget(spu_ctx);
+	ret = put_spu_context(spu_ctx);
+	WARN_ON(!ret);
+	kfree(kctx->notify_cb_info);
+	kfree(kctx);
+}
+
+static void setup_stack(struct kspu_context *kctx)
+{
+	struct spu_context *ctx = kctx->spu_ctx;
+	u8 *ls;
+	u32 *u32p;
+
+	spu_acquire_saved(ctx);
+	ls = ctx->ops->get_ls(ctx);
+
+#define BACKCHAIN (kctx->spu_code->kspu_data_offset - 16)
+#define STACK_GAP 176
+#define INITIAL_STACK (BACKCHAIN - STACK_GAP)
+
+	BUG_ON(INITIAL_STACK > KSPU_LS_SIZE);
+
+	u32p = (u32 *) &ls[BACKCHAIN];
+	u32p[0] = 0;
+	u32p[1] = 0;
+	u32p[2] = 0;
+	u32p[3] = 0;
+
+	u32p = (u32 *) &ls[INITIAL_STACK];
+	u32p[0] = BACKCHAIN;
+	u32p[1] = 0;
+	u32p[2] = 0;
+	u32p[3] = 0;
+
+	ctx->csa.lscsa->gprs[1].slot[0] = INITIAL_STACK;
+	spu_release(ctx);
+	pr_debug("SPU's stack ready 0x%04x\n", INITIAL_STACK);
+}
+
+static struct kspu_context *__init kcreate_spu_context(int flags,
+		struct kspu_code *spu_code)
+{
+	struct kspu_context *kctx;
+	struct spu_context *ctx;
+	unsigned int ret;
+	u8 *ls;
+
+	flags |= SPU_CREATE_EVENTS_ENABLED;
+	ret = -EINVAL;
+
+	if (flags & (~SPU_CREATE_FLAG_ALL))
+		goto err;
+	/*
+	 * it must be a multiple of 16 because this value is used to calculate
+	 * the initial stack frame which must be 16byte aligned
+	 */
+	if (spu_code->kspu_data_offset & 15)
+		goto err;
+
+	pr_debug("SPU's queue: %d elemets, %d bytes each (%d bytes total)\n",
+			spu_code->queue_mask+1, spu_code->queue_entr_size,
+			(spu_code->queue_mask+1) * spu_code->queue_entr_size);
+
+	ret = -EFBIG;
+	if (spu_code->code_len > KSPU_LS_SIZE)
+		goto err;
+
+	ret = -ENOMEM;
+	kctx = kzalloc(sizeof *kctx, GFP_KERNEL);
+	if (!kctx)
+		goto err;
+
+	kctx->qlen = 0;
+	kctx->spu_code = spu_code;
+	init_waitqueue_head(&kctx->newitem_wq);
+	spin_lock_init(&kctx->queue_lock);
+	INIT_LIST_HEAD(&kctx->work_queue);
+	kctx->notify_cb_info = kzalloc(sizeof(*kctx->notify_cb_info) *
+			(kctx->spu_code->queue_mask + 1), GFP_KERNEL);
+	if (!kctx->notify_cb_info)
+		goto err_notify;
+
+	ctx = kspu_alloc_context();
+	if (!ctx)
+		goto err_spu_ctx;
+
+	kctx->spu_ctx = ctx;
+	ctx->flags = flags;
+
+	spu_acquire(ctx);
+	ls = ctx->ops->get_ls(ctx);
+	memcpy(ls, spu_code->code, spu_code->code_len);
+	spu_release(ctx);
+	setup_stack(kctx);
+
+	return kctx;
+err_spu_ctx:
+	kfree(kctx->notify_cb_info);
+
+err_notify:
+	kfree(kctx);
+err:
+	return ERR_PTR(ret);
+}
+
+/**
+ * kspu_get_rb_slot - get a free slot to queue a work request on the SPU.
+ * @kctx:	kspu context, where the free slot is required
+ *
+ * Returns a free slot where a request may be queued on. Repeated calls will
+ * return the same slot until it is marked as taken (by
+ * kspu_mark_rb_slot_ready()).
+ */
+struct kspu_job *kspu_get_rb_slot(struct kspu_context *kctx)
+{
+	struct kspu_ring_data *ring_data;
+	unsigned char *ls;
+	unsigned int outstanding;
+	unsigned int queue_mask;
+	unsigned int notified;
+
+	ls = kctx->spu_ctx->ops->get_ls(kctx->spu_ctx);
+	ls += kctx->spu_code->kspu_data_offset;
+	ring_data = (struct kspu_ring_data *) ls;
+
+	queue_mask = kctx->spu_code->queue_mask;
+	outstanding = ring_data->outstanding;
+	notified = kctx->last_notified;
+
+	/* without the & an overflow won't be detected */
+	if (((outstanding + 1) & queue_mask) == (notified & queue_mask)) {
+		return NULL;
+	}
+
+	ls += sizeof(struct kspu_ring_data);
+	/* ls points now to the first queue slot */
+	ls += kctx->spu_code->queue_entr_size * (outstanding & queue_mask);
+
+	pr_debug("Return slot %d, at %p\n", (outstanding & queue_mask), ls);
+	return (struct kspu_job *) ls;
+}
+EXPORT_SYMBOL_GPL(kspu_get_rb_slot);
+
+/*
+ * kspu_mark_rb_slot_ready - mark a request valid.
+ * @kctx:	kspu context that the request belongs to
+ * @work:	work item that is used for notification. May be NULL.
+ *
+ * The slot will be marked as valid not returned kspu_get_rb_slot() until
+ * the request is processed. If @work is not NULL, work->notify will be
+ * called to notify the user, that his request is done.
+ */
+void kspu_mark_rb_slot_ready(struct kspu_context *kctx,
+		struct kspu_work_item *work)
+{
+	struct kspu_ring_data *ring_data;
+	unsigned char *ls;
+	unsigned int outstanding;
+	unsigned int queue_mask;
+
+	ls = kctx->spu_ctx->ops->get_ls(kctx->spu_ctx);
+	ls += kctx->spu_code->kspu_data_offset;
+	ring_data = (struct kspu_ring_data *) ls;
+
+	queue_mask = kctx->spu_code->queue_mask;
+	outstanding = ring_data->outstanding;
+	kctx->notify_cb_info[outstanding & queue_mask] = work;
+	pr_debug("item ready: outs %d, notification data %p\n",
+			outstanding & queue_mask, work);
+	outstanding++;
+	BUG_ON((outstanding & queue_mask) == (kctx->last_notified & queue_mask));
+	ring_data->outstanding = outstanding;
+}
+EXPORT_SYMBOL_GPL(kspu_mark_rb_slot_ready);
+
+static int notify_done_reqs(struct kspu_context *kctx)
+{
+	struct kspu_ring_data *ring_data;
+	struct kspu_work_item *kspu_work;
+	unsigned char *kjob;
+	unsigned char *ls;
+	unsigned int current_notify;
+	unsigned int queue_mask;
+	unsigned ret = 0;
+
+	ls = kctx->spu_ctx->ops->get_ls(kctx->spu_ctx);
+	ls += kctx->spu_code->kspu_data_offset;
+	ring_data = (struct kspu_ring_data *) ls;
+	ls += sizeof(struct kspu_ring_data);
+
+	current_notify = kctx->last_notified;
+	queue_mask = kctx->spu_code->queue_mask;
+	pr_debug("notify| %d | %d (%d | %d)\n", current_notify & queue_mask,
+			ring_data->consumed & queue_mask,
+			current_notify, ring_data->consumed);
+
+	while (ring_data->consumed != current_notify) {
+
+		pr_debug("do notify %d. (consumed = %d)\n", current_notify, ring_data->consumed);
+
+		kspu_work = kctx->notify_cb_info[current_notify & queue_mask];
+		if (likely(kspu_work)) {
+			kjob = (unsigned char *) ls +
+				kctx->spu_code->queue_entr_size *
+				(current_notify & queue_mask);
+			kspu_work->notify(kspu_work, (struct kspu_job *) kjob);
+		}
+
+		current_notify++;
+		ret = 1;
+	}
+
+	kctx->last_notified = current_notify;
+	pr_debug("notify done\n");
+	return ret;
+}
+
+static int queue_requests(struct kspu_context *kctx)
+{
+	int ret;
+	int empty;
+	int queued = 0;
+	struct kspu_work_item *work;
+
+	WARN_ON(in_irq());
+	while(1) {
+		if (!kspu_get_rb_slot(kctx))
+			break;
+
+		spin_lock_bh(&kctx->queue_lock);
+		empty = list_empty(&kctx->work_queue);
+		if (unlikely(empty)) {
+			work = NULL;
+		} else {
+			work = list_first_entry(&kctx->work_queue,
+					struct kspu_work_item, list);
+			list_del(&work->list);
+			kctx->qlen--;
+		}
+		spin_unlock_bh(&kctx->queue_lock);
+
+		if (!work)
+			break;
+
+		pr_debug("Adding item %p to queue\n", work);
+		ret = work->enqueue(work);
+		if (unlikely(ret == 0)) {
+			pr_debug("Adding item %p again to list.\n", work);
+			spin_lock_bh(&kctx->queue_lock);
+			list_add(&work->list, &kctx->work_queue);
+			kctx->qlen++;
+			spin_unlock_bh(&kctx->queue_lock);
+			break;
+		}
+
+		queued = 1;
+	}
+	pr_debug("Queue requests done. => %d\n", queued);
+	return queued;
+}
+
+/**
+ * kspu_enqueue_work_item - Enqueue a request that supposed to be queued on the
+ * SPU.
+ * @kctx:	kspu context that should be used.
+ * @work:	Work item that should be placed on the SPU
+ *
+ * The functions puts the work item in a list belonging to the kctx. If the
+ * queue is full (KSPU_MAX_QUEUE_LENGTH limit) the request will be discarded
+ * unless the KSPU_MUST_BACKLOG flag has been specified. The flag should be
+ * specified if the user can't drop the requeuest or try again later (softirq).
+ * Once a SPU slot is available, the user supplied enqueue function
+ * (work->enqueue) will be called from a kthread context. The user may then
+ * enqueue the request on the SPU. This function may be called from softirq.
+ *
+ * Returns: -EINPROGRESS if the work item is enqueued,
+ * -EBUSY if the queue is full and the user should slowdown. Packet is
+ *  discarded unless KSPU_MUST_BACKLOG has been passed.
+ */
+int kspu_enqueue_work_item(struct kspu_context *kctx,
+		struct kspu_work_item *work, unsigned int flags)
+{
+	int ret = -EINPROGRESS;
+
+	spin_lock_bh(&kctx->queue_lock);
+	if (unlikely(kctx->qlen > KSPU_MAX_QUEUE_LENGTH)) {
+
+		ret = -EBUSY;
+		if (flags != KSPU_MUST_BACKLOG) {
+			spin_unlock_bh(&kctx->queue_lock);
+			return ret;
+		}
+	}
+
+	kctx->qlen++;
+	list_add_tail(&work->list, &kctx->work_queue);
+
+	spin_unlock_bh(&kctx->queue_lock);
+	wake_up_all(&kctx->newitem_wq);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kspu_enqueue_work_item);
+
+static int pending_spu_work(struct kspu_context *kctx)
+{
+	struct kspu_ring_data *ring_data;
+	unsigned char *ls;
+
+	ls = kctx->spu_ctx->ops->get_ls(kctx->spu_ctx);
+	ls += kctx->spu_code->kspu_data_offset;
+	ring_data = (struct kspu_ring_data *) ls;
+
+	pr_debug("pending spu work status: %u == %u ?\n",
+			ring_data->consumed,
+			ring_data->outstanding);
+	if (ring_data->consumed == ring_data->outstanding )
+		return 0;
+
+	return 1;
+}
+
+/*
+ * Fill dummy requests in the ring buffer. Dummy requests are required
+ * to let MFC "transfer" data if there are not enough real requests.
+ * Transfers with a size of 0 bytes are nops for the MFC
+ */
+static void kspu_fill_dummy_reqs(struct kspu_context *kctx)
+{
+
+	struct kspu_ring_data *ring_data;
+	unsigned char *ls;
+	unsigned int requests;
+	unsigned int queue_mask;
+	unsigned int outstanding;
+	unsigned int consumed;
+	struct kspu_job *kjob;
+	int i;
+
+	ls = kctx->spu_ctx->ops->get_ls(kctx->spu_ctx);
+	ls += kctx->spu_code->kspu_data_offset;
+	ring_data = (struct kspu_ring_data *) ls;
+	queue_mask = kctx->spu_code->queue_mask;
+
+	outstanding = ring_data->outstanding;
+	consumed = ring_data->consumed;
+
+	requests = outstanding - consumed;
+
+	if (requests >= DMA_BUFFERS *  2)
+		return;
+
+	for (i = requests; i < (DMA_BUFFERS * 2); i++) {
+		kjob = kspu_get_rb_slot(kctx);
+		kjob->operation = SPU_OP_nop;
+		kjob->in_size = 0;
+		kspu_mark_rb_slot_ready(kctx, NULL);
+	}
+}
+
+static void print_kctx_debug(struct kspu_context *kctx)
+{
+	struct kspu_job *kjob;
+	struct kspu_ring_data *ring_data;
+	unsigned char *ls, *new_queue;
+	unsigned int requests, consumed, outstanding;
+	unsigned int queue_mask;
+	unsigned int i;
+
+	ls = kctx->spu_ctx->ops->get_ls(kctx->spu_ctx);
+	ls += kctx->spu_code->kspu_data_offset;
+	ring_data = (struct kspu_ring_data *) ls;
+	ls += sizeof(struct kspu_ring_data);
+
+	consumed = ring_data->consumed;
+	outstanding = ring_data->outstanding;
+
+	if (likely(outstanding > consumed))
+		requests = outstanding - consumed;
+	else
+		requests = UINT_MAX - consumed + outstanding +1;
+
+	queue_mask = kctx->spu_code->queue_mask;
+	/* show the last two processed as well */
+	requests +=2;
+	consumed -=2;
+
+	printk(KERN_ERR "Consumed: %d Outstanding: %d (%d)\n", consumed, outstanding, requests);
+	if (requests > 10)
+		requests = 10;
+
+	for (i = 0; i < requests; i++) {
+		new_queue = ls + kctx->spu_code->queue_entr_size * (consumed & queue_mask);
+		kjob = (struct kspu_job *) new_queue;
+
+		printk(KERN_ERR "Request: %d function: %d src addr: %08llx, length: %d\n",
+				consumed & queue_mask, kjob->operation, kjob->in, kjob->in_size);
+		consumed++;
+	}
+}
+
+/*
+ * based on run.c spufs_run_spu
+ */
+static int spufs_run_kernel_spu(void *priv)
+{
+	struct kspu_context *kctx = (struct kspu_context *) priv;
+	struct spu_context *ctx = kctx->spu_ctx;
+	int ret;
+	u32 status;
+	unsigned int npc = 0;
+	int fastpath;
+	DEFINE_WAIT(wait_for_stop);
+	DEFINE_WAIT(wait_for_ibox);
+	DEFINE_WAIT(wait_for_newitem);
+
+	spu_enable_spu(ctx);
+	ctx->event_return = 0;
+	spu_acquire(ctx);
+	if (ctx->state == SPU_STATE_SAVED) {
+		__spu_update_sched_info(ctx);
+
+		ret = spu_activate(ctx, 0);
+		if (ret) {
+			spu_release(ctx);
+			printk(KERN_ERR "could not obtain runnable spu: %d\n",
+					ret);
+			BUG();
+		}
+	} else {
+		/*
+		 * We have to update the scheduling priority under active_mutex
+		 * to protect against find_victim().
+		 */
+		spu_update_sched_info(ctx);
+	}
+
+	spu_run_init(ctx, &npc);
+	do {
+		fastpath = 0;
+		prepare_to_wait(&ctx->stop_wq, &wait_for_stop,
+				TASK_INTERRUPTIBLE);
+		prepare_to_wait(&ctx->ibox_wq, &wait_for_ibox,
+				TASK_INTERRUPTIBLE);
+		prepare_to_wait(&kctx->newitem_wq, &wait_for_newitem,
+				TASK_INTERRUPTIBLE);
+
+		if (unlikely(test_and_clear_bit(SPU_SCHED_NOTIFY_ACTIVE,
+						&ctx->sched_flags))) {
+
+			if (!(status & SPU_STATUS_STOPPED_BY_STOP)) {
+				spu_switch_notify(ctx->spu, ctx);
+			}
+		}
+
+		spuctx_switch_state(ctx, SPU_UTIL_SYSTEM);
+
+		pr_debug("going to handle class1\n");
+		ret = spufs_handle_class1(ctx);
+		if (unlikely(ret)) {
+			/*
+			 * SPE_EVENT_SPE_DATA_STORAGE => refernce invalid memory
+			 */
+			printk(KERN_ERR "Invalid memory dereferenced by the"
+					"spu: %d\n", ret);
+			BUG();
+		}
+
+		/* FIXME BUG: We need a physical SPU to discover
+		 * ctx->spu->class_0_pending. It is not saved on context
+		 * switch. We may lose this on context switch.
+		 */
+		status = ctx->ops->status_read(ctx);
+		if (unlikely((ctx->spu && ctx->spu->class_0_pending) ||
+					status & SPU_STATUS_INVALID_INSTR)) {
+			printk(KERN_ERR "kspu error, status_register: 0x%08x\n",
+					status);
+			printk(KERN_ERR "event return: 0x%08lx, spu's npc: "
+					"0x%08x\n", kctx->spu_ctx->event_return,
+					kctx->spu_ctx->ops->npc_read(
+						kctx->spu_ctx));
+			printk(KERN_ERR "class_0_pending: 0x%lx\n", ctx->spu->class_0_pending);
+			print_kctx_debug(kctx);
+			BUG();
+		}
+
+		if (notify_done_reqs(kctx))
+			fastpath = 1;
+
+		if (queue_requests(kctx))
+			fastpath = 1;
+
+		if (!(status & SPU_STATUS_RUNNING)) {
+			/* spu is currently not running */
+			pr_debug("SPU not running, last stop code was: %08x\n",
+					status >> SPU_STOP_STATUS_SHIFT);
+			if (pending_spu_work(kctx)) {
+				/* spu should run again */
+				pr_debug("Activate SPU\n");
+				kspu_fill_dummy_reqs(kctx);
+
+				spu_run_fini(ctx, &npc, &status);
+				spu_acquire_runnable(ctx, 0);
+				spu_run_init(ctx, &npc);
+			} else {
+				/* spu finished work */
+				pr_debug("SPU will remain in stop state\n");
+				spu_run_fini(ctx, &npc, &status);
+				spu_yield(ctx);
+				spu_acquire(ctx);
+			}
+		} else {
+			pr_debug("SPU is running, switch state to util user\n");
+			spuctx_switch_state(ctx, SPU_UTIL_USER);
+		}
+
+		if (fastpath)
+			continue;
+
+		spu_release(ctx);
+		schedule();
+		spu_acquire(ctx);
+
+	} while (!kthread_should_stop() || !list_empty(&kctx->work_queue));
+
+	finish_wait(&ctx->stop_wq, &wait_for_stop);
+	finish_wait(&ctx->ibox_wq, &wait_for_ibox);
+	finish_wait(&kctx->newitem_wq, &wait_for_newitem);
+
+	spu_release(ctx);
+	spu_disable_spu(ctx);
+	return 0;
+}
+
+static struct kspu_context *kspu_ctx;
+
+/**
+ * kspu_get_kctx - return a kspu contexte.
+ *
+ * Returns a kspu_context that identifies the SPU context used by the kernel.
+ * Right now only one static context exist which may be used by multiple users.
+ */
+struct kspu_context *kspu_get_kctx(void)
+{
+	return kspu_ctx;
+}
+EXPORT_SYMBOL_GPL(kspu_get_kctx);
+
+int __init kspu_init(void)
+{
+	int ret;
+
+	pr_debug("code @%p, len %d, offet 0x%08x, elemets: %d,"
+			"element size: %d\n", single_spu_code.code,
+			single_spu_code.code_len,
+			single_spu_code.kspu_data_offset,
+			single_spu_code.queue_mask,
+			single_spu_code.queue_entr_size);
+	kspu_ctx = kcreate_spu_context(0, &single_spu_code);
+	if (IS_ERR(kspu_ctx)) {
+		ret = PTR_ERR(kspu_ctx);
+		goto out;
+	}
+
+	/* kthread_run */
+	kspu_ctx->thread = kthread_create(spufs_run_kernel_spu, kspu_ctx,
+			"spucode");
+	if (IS_ERR(kspu_ctx->thread)) {
+		ret = PTR_ERR(kspu_ctx->thread);
+		goto err_kspu_ctx;
+	}
+	wake_up_process(kspu_ctx->thread);
+
+	return 0;
+err_kspu_ctx:
+	free_kspu_context(kspu_ctx);
+out:
+	return ret;
+}
+
+void __exit kspu_exit(void)
+{
+	kthread_stop(kspu_ctx->thread);
+	free_kspu_context(kspu_ctx);
+}
--- /dev/null
+++ b/arch/powerpc/platforms/cell/spufs/kspu_util.h
@@ -0,0 +1,30 @@
+#ifndef KSPU_UTIL_H
+#define KSPU_UTIL_H
+#include <linux/wait.h>
+
+struct kspu_code {
+	const unsigned int *code;
+	unsigned int code_len;
+	unsigned int kspu_data_offset;
+	unsigned int queue_mask;
+	unsigned int queue_entr_size;
+};
+
+struct notify_cb_info {
+	void *notify;
+};
+
+struct kspu_context {
+	struct spu_context *spu_ctx;
+	wait_queue_head_t newitem_wq;
+	void **notify_cb_info;
+	unsigned int last_notified;
+	struct kspu_code *spu_code;
+	struct task_struct *thread;
+	/* spinlock protects qlen + work_queue */
+	spinlock_t queue_lock;
+	unsigned int qlen;
+	struct list_head work_queue;
+};
+
+#endif
--- a/arch/powerpc/platforms/cell/spufs/spufs.h
+++ b/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -344,4 +344,18 @@ static inline void spuctx_switch_state(s
 	}
 }
 
+#ifdef CONFIG_KSPU
+int __init kspu_init(void);
+void __exit kspu_exit(void);
+#else
+static inline int kspu_init(void)
+{
+	return 0;
+}
+
+static inline void kspu_exit(void)
+{
+}
+#endif
+
 #endif
--- /dev/null
+++ b/include/asm-powerpc/kspu/kspu.h
@@ -0,0 +1,35 @@
+#ifndef KSPU_KSPU_H
+#define KSPU_KSPU_H
+#include <linux/list.h>
+#include <asm/kspu/merged_code.h>
+
+/*
+ * If the queue is full, the request must be accepted (it can't be droped).
+ * The user that uses this flag should make sure that further requests arrive
+ * more slowly
+ */
+#define KSPU_MUST_BACKLOG	0x1
+
+/*
+ * Max number of requests that may be in the queue. All following items are
+ * discared if the KSPU_MUST_BACKLOG is not specified (it seems that the SPE
+ * is not working fast enough).
+ */
+#define KSPU_MAX_QUEUE_LENGTH	400
+
+struct kspu_work_item {
+	struct list_head list;
+	int (*enqueue)(struct kspu_work_item *);
+	void (*notify)(struct kspu_work_item *, struct kspu_job *);
+};
+
+struct kspu_context;
+
+struct kspu_job *kspu_get_rb_slot(struct kspu_context *kspu);
+void kspu_mark_rb_slot_ready(struct kspu_context *kspu,
+		struct kspu_work_item *work);
+int kspu_enqueue_work_item(struct kspu_context *kctx,
+		struct kspu_work_item *work, unsigned int flags);
+struct kspu_context *kspu_get_kctx(void);
+
+#endif

-- 

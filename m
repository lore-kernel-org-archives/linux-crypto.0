From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC 2/2] add kernel support for spu task
Date: Wed, 27 Jun 2007 01:00:49 +0200
Message-ID: <20070626230049.GA4615@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36774 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755969AbXFZXAv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jun 2007 19:00:51 -0400
Content-Disposition: inline; filename="spufs-add_kernel_spu_support.diff"
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Utilisation of SPUs by the kernel, main implementation. 
The idea behind this implementation is that there are single jobs that are
executed asynchronous on the SPU. The user queues jobs with
enqueue_for_spu() and gets a callback once the job is completed. The
function itself does not block. The job will be queued in a linked list 
(protected by a spinlock, calls from softirq context are possible) and the 
kthread that handles the SPU will be woken up.
The SPU thread takes the first element from the list, and calls the
enqueue function supplied by the user. The user has now the chance to fill
the ring buffer entry and set a callback for notification which will be
called once the SPU code accomplished the task. The queue function has
to ensure alignment & valid transfer size.

Signed-off-by: Sebastian Siewior <bigeasy@breakpoint.cc>
--- /dev/null
+++ b/arch/powerpc/platforms/cell/spufs/kspu_helper.c
@@ -0,0 +1,518 @@
+/*
+ * Interface for accessing SPUs from the kernel.
+ *
+ * Author: Sebastian Siewior <bigeasy@breakpoint.cc>
+ * License: GPLv2
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
+#include "spufs.h"
+#include "kspu_util.h"
+
+static int free_kspu_context(struct kspu_context *kctx)
+{
+	struct spu_context *spu_ctx = kctx->spu_ctx;
+	int ret;
+
+	if (spu_ctx->owner)
+		spu_forget(spu_ctx);
+	
+	put_spu_context(spu_ctx);
+
+
+	kfree(kctx->notify_cb_info);
+	kfree(kctx);
+
+	return ret;
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
+static struct kspu_context *kcreate_spu_context(int flags,
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
+	kctx->spu_code = spu_code;
+	init_waitqueue_head(&kctx->newitem_wq);
+	spin_lock_init(&kctx->queue_lock);
+	INIT_LIST_HEAD(&kctx->work_queue);
+	kctx->notify_cb_info = kzalloc(sizeof(*kctx->notify_cb_info) *
+			(kctx->spu_code->queue_mask+1), GFP_KERNEL);
+	if (!kctx->notify_cb_info)
+		goto err_notify;
+
+	ctx = kalloc_spu_context();
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
+
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
+	int consumed, outstanding, queue_mask;
+
+	ls = kctx->spu_ctx->ops->get_ls(kctx->spu_ctx);
+	ls += kctx->spu_code->kspu_data_offset;
+	ring_data = (struct kspu_ring_data *) ls;
+
+	queue_mask = kctx->spu_code->queue_mask;
+	consumed = ring_data->consumed;
+	outstanding = ring_data->outstanding;
+
+	outstanding++;
+
+	if ((outstanding & queue_mask) ==
+			(consumed & queue_mask))
+		return NULL;
+
+	outstanding = ring_data->outstanding;
+
+	ls += sizeof (struct kspu_ring_data);
+	/* ls points now to the first queue slot */
+	ls += kctx->spu_code->queue_entr_size * (outstanding & queue_mask);
+
+	pr_debug("Return slot %d, at %p\n", (outstanding&queue_mask), ls);
+	return (struct kspu_job *) ls;
+
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
+	int outstanding, queue_mask;
+
+	ls = kctx->spu_ctx->ops->get_ls(kctx->spu_ctx);
+	ls += kctx->spu_code->kspu_data_offset;
+	ring_data = (struct kspu_ring_data *) ls;
+
+	queue_mask = kctx->spu_code->queue_mask;
+	outstanding = ring_data->outstanding;
+	kctx->notify_cb_info[outstanding & queue_mask] = work;
+	pr_debug("item ready: outs %d, notification data %p\n",
+			outstanding &queue_mask, work);
+	outstanding++;
+	BUG_ON(outstanding == ring_data->consumed);
+	ring_data->outstanding = outstanding;
+}
+EXPORT_SYMBOL_GPL(kspu_mark_rb_slot_ready);
+
+static int notify_done_reqs(struct kspu_context *kctx)
+{
+	struct kspu_ring_data *ring_data;
+	struct kspu_work_item *kspu_work;
+	unsigned char *ls;
+	unsigned int current_notify, queue_mask;
+	unsigned ret = 0;
+
+	ls = kctx->spu_ctx->ops->get_ls(kctx->spu_ctx);
+	ls += kctx->spu_code->kspu_data_offset;
+	ring_data = (struct kspu_ring_data *) ls;
+	ls += sizeof (struct kspu_ring_data);
+
+	current_notify = kctx->last_notified;
+	queue_mask = kctx->spu_code->queue_mask;
+	pr_debug("notify| %d | %d\n", current_notify & queue_mask,
+			ring_data->consumed & queue_mask);
+
+	while (ring_data->consumed != current_notify) {
+
+		pr_debug("do notify %d\n", current_notify);
+
+		kspu_work = kctx->notify_cb_info[current_notify & queue_mask];
+		if (likely(kspu_work))
+			kspu_work->notify(kspu_work);
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
+
+	do {
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
+			spin_unlock_bh(&kctx->queue_lock);
+			break;
+		}
+
+		queued = 1;
+	} while (1);
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
+ * The functions puts the work item in a list. Once a SPU slot is available,
+ * work->enqueue will be called from a kthread context. User's enqueue
+ * function may than queue the request on the SPU.
+ * kspu_enqueue_work_item() may be called from softirq.
+ */
+void kspu_enqueue_work_item(struct kspu_context *kctx,
+		struct kspu_work_item *work)
+{
+	spin_lock_bh(&kctx->queue_lock);
+	list_add_tail(&work->list, &kctx->work_queue);
+	spin_unlock_bh(&kctx->queue_lock);
+	wake_up_all(&kctx->newitem_wq);
+}
+EXPORT_SYMBOL_GPL(kspu_enqueue_work_item);
+
+static int pending_spu_work(struct kspu_context *kctx)
+{
+	struct kspu_ring_data *ring_data;
+	unsigned char *ls;
+	int queue_mask;
+
+	ls = kctx->spu_ctx->ops->get_ls(kctx->spu_ctx);
+	ls += kctx->spu_code->kspu_data_offset;
+	ring_data = (struct kspu_ring_data *) ls;
+
+	queue_mask = kctx->spu_code->queue_mask;
+	pr_debug("pending spu work status: %u == %u ?\n",
+			ring_data->consumed & queue_mask,
+			ring_data->outstanding & queue_mask);
+	if (ring_data->consumed == ring_data->outstanding)
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
+	unsigned int queue_mask;
+	unsigned int requests;
+	struct kspu_job *kjob;
+	int i;
+
+	ls = kctx->spu_ctx->ops->get_ls(kctx->spu_ctx);
+	ls += kctx->spu_code->kspu_data_offset;
+	ring_data = (struct kspu_ring_data *) ls;
+
+	queue_mask = kctx->spu_code->queue_mask;
+
+	/* check for overflow */
+	requests = ring_data->outstanding - ring_data->consumed;
+
+	if (requests >= DMA_BUFFERS *2)
+		return;
+
+	for (i = requests; i < (DMA_BUFFERS*2); i++) {
+		kjob = kspu_get_rb_slot(kctx);
+		kjob->in_size = 0;
+		kspu_mark_rb_slot_ready(kctx, NULL);
+	}
+}
+
+static int spufs_run_kernel_spu(void *priv)
+{
+	struct kspu_context *kctx = (struct kspu_context *) priv;
+	struct spu_context *ctx = kctx->spu_ctx;
+	int ret;
+	u32 status;
+	int npc = 0;
+	int fastpath;
+	DEFINE_WAIT(wait_for_stop);
+	DEFINE_WAIT(wait_for_ibox);
+	DEFINE_WAIT(wait_for_newitem);
+
+	spu_enable_spu(ctx);
+	ctx->event_return = 0;
+
+	ret = spu_acquire_runnable(ctx, 0);
+	if (ret) {
+		mutex_unlock(&ctx->run_mutex);
+		printk(KERN_ERR "could not obtain runable spu: %d\n", ret);
+		BUG();
+	}
+
+	spu_run_init(ctx, &npc);
+
+	do {
+		fastpath = 0;
+		prepare_to_wait(&ctx->stop_wq, &wait_for_stop,
+				TASK_INTERRUPTIBLE);
+		prepare_to_wait(&ctx->ibox_wq, &wait_for_ibox,
+				TASK_INTERRUPTIBLE);
+		prepare_to_wait(&kctx->newitem_wq, &wait_for_newitem,
+				TASK_INTERRUPTIBLE);
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
+		pr_debug("going to process kspu_events\n");
+		/* FIXME BUG: We need a physical SPU to discover
+		 * ctx->spu->class_0_pending. It is not saved on context
+		 * switch. We may lose this on context switch.
+		 */
+		status = ctx->ops->status_read(ctx);
+		if ((ctx->spu && ctx->spu->class_0_pending) ||
+				status & SPU_STATUS_INVALID_INSTR) {
+			printk(KERN_ERR "kspu error, status_register: 0x%08x\n",
+					status);
+			printk(KERN_ERR "event return: 0x%08lx, spu's npc: \
+					0x%08x\n", kctx->spu_ctx->event_return,
+					kctx->spu_ctx->ops->npc_read(
+						kctx->spu_ctx));
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
+				spu_release(ctx);
+				ret = spu_acquire_runnable(ctx, 0);
+				BUG_ON(ret);
+				ret = spu_run_init(ctx, &npc);
+				BUG_ON(ret);
+			} else {
+
+				/* spu probably finished working,  */
+				pr_debug("SPU will remain in stop state\n");
+				ret = spu_run_fini(ctx, &npc, &status);
+				BUG_ON(ret);
+				spu_yield(ctx);
+				spu_acquire(ctx);
+			}
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
+extern struct kspu_code single_spu_code;
+
+/**
+ * kspu_get_kctx - return a kspu context.
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
+static int __init kspu_init(void)
+{
+	int ret = 0;
+
+	pr_debug("code @%p, len %d, offset 0x%08x, elemets: %d,"
+			"element size: %d\n", single_spu_code.code,
+			single_spu_code.code_len,
+			single_spu_code.kspu_data_offset,
+			single_spu_code.queue_mask,
+			single_spu_code.queue_entr_size);
+	kspu_ctx = kcreate_spu_context(0, &single_spu_code);
+	if (IS_ERR(kspu_ctx))
+		return PTR_ERR(kspu_ctx);
+
+	/* kthread_run */
+	kspu_ctx->thread = kthread_create(spufs_run_kernel_spu, kspu_ctx,
+			"spucode");
+	if (IS_ERR(kspu_ctx->thread)) {
+		ret = PTR_ERR(kspu_ctx->thread);
+		free_kspu_context(kspu_ctx);
+	}
+	wake_up_process(kspu_ctx->thread);
+	return ret;
+}
+
+static void __exit kspu_exit(void)
+{
+	kthread_stop(kspu_ctx->thread);
+	free_kspu_context(kspu_ctx);
+}
+
+module_init(kspu_init);
+module_exit(kspu_exit);
+
+MODULE_DESCRIPTION("KSPU interface module");
+MODULE_AUTHOR("Sebastian Siewior <bigeasy@breakpoint.cc>");
+MODULE_LICENSE("GPL");
--- /dev/null
+++ b/arch/powerpc/platforms/cell/spufs/kspu_util.h
@@ -0,0 +1,29 @@
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
+	struct list_head work_queue;
+	/* access to the work_queue element. May be used from softirq */
+	spinlock_t queue_lock;
+};
+
+#endif
--- /dev/null
+++ b/arch/powerpc/platforms/cell/spufs/spu_main.c
@@ -0,0 +1,100 @@
+/*
+ * This code can be considered as crt0.S
+ * Compile with -O[123S] and make sure that here is only one function
+ * that starts at 0x0
+ * Author: Sebastian Siewior <bigeasy@breakpoint.cc>
+ * License: GPLv2
+ */
+#include <asm/kspu/merged_code.h>
+#include <spu_mfcio.h>
+#include "spu_runtime.h"
+
+#define barrier() __asm__ __volatile__("": : :"memory")
+
+spu_operation spu_funcs[TOTAL_SPU_FUNCS] __attribute__((aligned(16))) = {
+	[SPU_FUNC_nop] = spu_nop,
+};
+
+struct kspu_buffers kspu_buff[DMA_BUFFERS];
+
+void _start(void) __attribute__((noreturn));
+void _start(void)
+{
+	struct kernel_spu_data *spu_data;
+
+	spu_data = (struct kernel_spu_data*) KERNEL_SPU_DATA_OFFSET;
+
+	while (37) {
+		unsigned int consumed, outstanding, cur_req, cur_item, cur_buf;
+		unsigned int i;
+
+		spu_stop(1);
+		/*
+		 * Once started, it is guaranteed that at least DMA_BUFFERS *2 requests are in ring buffer.
+		 * The work order is:
+		 * 1. request DMA_BUFFERS transfers, every in a separate buffer with its own tag.
+		 * 2. process those buffers and request new ones.
+		 * 3. if more than (DMA_BUFFERS *2) are available, than the main loop begins:
+		 *   - wait for tag to finish transfers
+		 *   - notify done work
+		 *   - process request
+		 *   - write back
+		 * 4. if no more request are available, process the last DMA_BUFFERS request that are left,
+		 *    write them back and wait until that transfers completes and spu_stop()
+		 */
+
+		consumed = spu_data->kspu_ring_data.consumed;
+		cur_req = consumed;
+		cur_item = consumed;
+
+		/* 1 */
+		for (cur_buf = 0; cur_buf < DMA_BUFFERS; cur_buf++) {
+			init_get_data(&kspu_buff[cur_buf & DMA_BUFF_MASK].space[0],
+					&spu_data->work_item[cur_req & RB_MASK], cur_buf & DMA_BUFF_MASK);
+			cur_req++;
+		}
+
+		/* 2 */
+		for (cur_buf = 0; cur_buf < DMA_BUFFERS; cur_buf++) {
+			wait_for_buffer(1<< (cur_buf & DMA_BUFF_MASK));
+			spu_funcs[spu_data->work_item[cur_item & RB_MASK].operation]
+				(cur_item & RB_MASK, cur_buf & DMA_BUFF_MASK);
+
+			init_get_data(&kspu_buff[cur_buf & DMA_BUFF_MASK].space[0],
+					&spu_data->work_item[cur_req & RB_MASK], cur_buf & DMA_BUFF_MASK);
+			cur_item++;
+			cur_req++;
+		}
+
+		outstanding = spu_data->kspu_ring_data.outstanding;
+		/* 3 */
+		while (cur_req  != outstanding) {
+			wait_for_buffer(1<< (cur_buf & DMA_BUFF_MASK));
+			spu_data->kspu_ring_data.consumed++;
+			if (spu_stat_out_mbox())
+				spu_write_out_mbox(0x0);
+
+			spu_funcs[spu_data->work_item[cur_item & RB_MASK].operation]
+				(cur_item & RB_MASK, cur_buf & DMA_BUFF_MASK);
+
+			init_get_data(&kspu_buff[cur_buf & DMA_BUFF_MASK].space[0],
+					&spu_data->work_item[cur_req & RB_MASK], cur_buf & DMA_BUFF_MASK);
+			cur_item++;
+			cur_req++;
+			cur_buf++;
+			outstanding = spu_data->kspu_ring_data.outstanding;
+		}
+
+		/* 4 */
+		for (i = 0; i < DMA_BUFFERS; i++) {
+			wait_for_buffer(1<< (cur_buf & DMA_BUFF_MASK));
+			spu_funcs[spu_data->work_item[cur_item & RB_MASK].operation]
+				(cur_item & RB_MASK, cur_buf & DMA_BUFF_MASK);
+			cur_buf++;
+			cur_item++;
+		}
+
+		wait_for_buffer(ALL_DMA_BUFFS);
+		spu_data->kspu_ring_data.consumed = cur_item;
+	}
+}
--- /dev/null
+++ b/include/asm-powerpc/kspu/kspu.h
@@ -0,0 +1,23 @@
+#ifndef KSPU_KSPU_H
+#define KSPU_KSPU_H
+#ifdef __KERNEL__
+#include <linux/list.h>
+
+#define MAX_DMA_TRANSFER (16 * 1024)
+
+struct kspu_work_item {
+	struct list_head list;
+	int (*enqueue)(struct kspu_work_item *);
+	void (*notify)(struct kspu_work_item *);
+};
+
+struct kspu_context;
+
+struct kspu_job *kspu_get_rb_slot(struct kspu_context *kspu);
+void kspu_mark_rb_slot_ready(struct kspu_context *kspu,
+		struct kspu_work_item *work);
+void kspu_enqueue_work_item(struct kspu_context *kctx,
+		struct kspu_work_item *work);
+struct kspu_context *kspu_get_kctx(void);
+#endif
+#endif
--- /dev/null
+++ b/include/asm-powerpc/kspu/merged_code.h
@@ -0,0 +1,40 @@
+#ifndef KSPU_MERGED_CODE_H
+#define KSPU_MERGED_CODE_H
+#include <linux/autoconf.h>
+
+#define KSPU_LS_SIZE 0x40000
+
+#define RB_SLOTS 256
+
+#define DMA_BUFFERS   2
+#define DMA_BUFF_MASK (DMA_BUFFERS-1)
+#define ALL_DMA_BUFFS ((1 << DMA_BUFFERS)-1)
+
+typedef int (*spu_operation)(unsigned int cur);
+
+enum SPU_FUNCTIONS {
+
+	TOTAL_SPU_FUNCS,
+};
+
+struct kspu_job {
+	enum SPU_FUNCTIONS operation __attribute__((aligned(16)));
+	unsigned long long in __attribute__((aligned(16)));
+	unsigned int in_size __attribute__((aligned(16)));
+	union {
+	} __attribute__((aligned(16)));
+};
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

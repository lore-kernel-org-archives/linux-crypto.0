From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: [patch 04/10] spufs: kspu doc skeleton
Date: Thu, 16 Aug 2007 22:01:09 +0200
Message-ID: <20070816200135.855942000@ml.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc>
Cc: <herbert@gondor.apana.org.au>, <arnd@arndb.de>, <jk@ozlabs.org>,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60600 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbXHPUFx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 16:05:53 -0400
Content-Disposition: inline; filename=spufs-kspu_doc_skeleton.diff
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Skeleton for PPU & SPU code that the documentation refers to.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
--- /dev/null
+++ b/Documentation/powerpc/kspu_ppu_skeleton.c
@@ -0,0 +1,98 @@
+/*
+ *  KSPU skeleton - PPU part
+ *
+ */
+
+#include <asm/kspu/kspu.h>
+#include <asm/kspu/merged_code.h>
+
+struct spu_async_req {
+	struct kspu_context *kctx;
+	struct kspu_work_item kspu_work;
+	struct completion mcompletion;
+	void *n1p;
+	unsigned char n2;
+};
+
+static void my_add_finish_callback(struct kspu_work_item *kspu_work)
+{
+	struct spu_async_req *req = container_of(kspu_work,
+			struct spu_async_req, kspu_work);
+
+
+	complete(&req->mcompletion);
+	return;
+}
+
+static int enqueue_on_spu(struct kspu_work_item *kspu_work)
+{
+	struct spu_async_req *req = container_of(kspu_work,
+			struct spu_async_req, kspu_work);
+	struct kspu_job *work_item;
+	struct my_sum *msum;
+	unsigned int i;
+
+	work_item = kspu_get_rb_slot(req->kctx);
+
+	my_sum = &work_item->my_sum;
+	work_item->operation = SPU_OP_my_add;
+
+	work_item->in = (unsigned long int) req->n1p;
+	my_sum->out = (unsigned long int) req->n1p;
+
+	for (i=0; i<16; i++)
+		my_sum->num[i] = req->n2;
+
+	kspu_work->notify = my_add_finish_callback;
+	kspu_mark_rb_slot_ready(req->kctx, kspu_work);
+	return 1;
+}
+
+static void enqueue_request(struct spu_async_req *req)
+{
+	struct kspu_work_item *work = &asy_d_ctx->kspu_work;
+
+	work->enqueue = enqueue_on_spu;
+
+	kspu_enqueue_work_item(ctx->spe_ctx->ctx, &req->kspu_work);
+}
+
+static unsigned char n1[16] __attribute__((aligned(16)));
+
+static int __init skeleton_init(void)
+{
+	struct async_d_request req;
+	unsigned int i;
+
+	req.kctx = kspu_get_kctx();
+
+	for (i=0; i<sizeof(n1); i++)
+		n1[i] = i*i;
+
+	req.n1p = n1;
+	req.n2 = 20;
+
+	init_completion(&req.mcompletion);
+	enqueue_request(req);
+
+	wait_for_completion_interruptible(&req.mcompletion);
+
+	for (i=0; i<sizeof(n1); i++)
+		printk("0x%02x ", n1[i]);
+
+	printk("\n");
+
+	/* don't load me plz */
+	return -ENOMEM;
+}
+
+static void __exit skeleton_finit(void)
+{
+}
+
+module_init(skeleton_init);
+module_exit(skeleton_finit);
+
+MODULE_DESCRIPTION("KSPU Skeleton for the PPU part");
+MODULE_AUTHOR("John Doe <john@the-doe-family.cc>");
+MODULE_LICENSE("GPL");
--- /dev/null
+++ b/Documentation/powerpc/kspu_spu_skeleton.c
@@ -0,0 +1,19 @@
+/*
+ * KSPU skeleton - SPU part
+ *
+ */
+
+#include <spu_intrinsics.h>
+#include <asm/kspu/spu_skeleton.h>
+#include <asm/kspu/merged_code.h>
+
+void spu_my_add(struct kspu_job *kjob, void *buffer, unsigned int buf_num)
+{
+	vector unsigned char sum1 = (*((vector unsigned char *)(buffer)));
+	struct my_sum *my_sum = &kjob->my_sum;
+	vector unsigned char sum2 = (*((vector unsigned char *)(my_sum->num)));
+	vector unsigned char sum;
+
+	sum = spu_add(sum1, sum2);
+	init_put_data(&sum, my_sum->out, 16, buf_num);
+}
--- /dev/null
+++ b/Documentation/powerpc/kspu_spu_skeleton.h
@@ -0,0 +1,9 @@
+#ifndef asm_kspu_spu_skeleton_h
+#define asm_kspu_spu_skeleton_h
+
+struct my_sum {
+	unsigned char num[16] __attribute__((aligned(16)));
+	unsigned long long out __attribute__((aligned(16)));
+};
+
+#endif

-- 

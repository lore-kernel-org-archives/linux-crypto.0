From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: [patch 06/10] spufs: add kspu_alloc_context()
Date: Thu, 16 Aug 2007 22:01:11 +0200
Message-ID: <20070816200136.639095000@ml.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc>
Cc: <herbert@gondor.apana.org.au>, <arnd@arndb.de>, <jk@ozlabs.org>,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60615 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbXHPUF7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 16:05:59 -0400
Content-Disposition: inline; filename=spufs-add_kspu_alloc_context.diff
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Function behaves like alloc_spu_context() but instead of current-> init
task's informations are used and the problem state bit is removed.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
--- a/arch/powerpc/platforms/cell/spufs/context.c
+++ b/arch/powerpc/platforms/cell/spufs/context.c
@@ -32,7 +32,8 @@
 
 atomic_t nr_spu_contexts = ATOMIC_INIT(0);
 
-struct spu_context *alloc_spu_context(struct spu_gang *gang)
+static struct spu_context *__alloc_spu_context(struct spu_gang *gang,
+		struct mm_struct *mm)
 {
 	struct spu_context *ctx;
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
@@ -54,7 +55,7 @@ struct spu_context *alloc_spu_context(st
 	init_waitqueue_head(&ctx->mfc_wq);
 	ctx->state = SPU_STATE_SAVED;
 	ctx->ops = &spu_backing_ops;
-	ctx->owner = get_task_mm(current);
+	ctx->owner = mm;
 	INIT_LIST_HEAD(&ctx->rq);
 	INIT_LIST_HEAD(&ctx->aff_list);
 	if (gang)
@@ -73,6 +74,37 @@ out:
 	return ctx;
 }
 
+struct spu_context *alloc_spu_context(struct spu_gang *gang)
+{
+	struct mm_struct *mm;
+	struct spu_context *ctx;
+
+	mm = get_task_mm(current);
+	ctx = __alloc_spu_context(gang, mm);
+	if (!ctx)
+		mmput(mm);
+	return ctx;
+}
+
+struct spu_context *kspu_alloc_context(void)
+{
+	struct spu_context *ctx;
+
+	/* for priviliged spu context, we borrow all the task specific
+	 * informations from init_task.
+	 */
+	atomic_inc(&init_mm.mm_users);
+	ctx = __alloc_spu_context(NULL, &init_mm);
+	if (!ctx) {
+		mmput(&init_mm);
+		return ctx;
+	}
+
+	/* remove problem state bit in order to access kernel memory */
+	ctx->csa.priv1.mfc_sr1_RW &= ~MFC_STATE1_PROBLEM_STATE_MASK;
+	return ctx;
+}
+
 void destroy_spu_context(struct kref *kref)
 {
 	struct spu_context *ctx;
--- a/arch/powerpc/platforms/cell/spufs/spufs.h
+++ b/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -232,6 +232,7 @@ static inline void spu_release(struct sp
 }
 
 struct spu_context * alloc_spu_context(struct spu_gang *gang);
+struct spu_context *kspu_alloc_context(void);
 void destroy_spu_context(struct kref *kref);
 struct spu_context * get_spu_context(struct spu_context *ctx);
 int put_spu_context(struct spu_context *ctx);

-- 

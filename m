From: Sebastian Siewior <cbe-oss-dev@ml.breakpoint.cc>
Subject: [patch 05/10] spufs: kspu add required declarations
Date: Thu, 16 Aug 2007 22:01:10 +0200
Message-ID: <20070816200136.260259000@ml.breakpoint.cc>
References: <20070816200105.735608000@ml.breakpoint.cc>
Cc: <herbert@gondor.apana.org.au>, <arnd@arndb.de>, <jk@ozlabs.org>,
	linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: cbe-oss-dev@ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60606 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbXHPUFy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Aug 2007 16:05:54 -0400
Content-Disposition: inline; filename=spufs-export_symbols2.diff
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

spu_run_init() and spu_run_fini() need to be used outside of spufs/run.c
but within spufs.ko.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
--- a/arch/powerpc/platforms/cell/spufs/run.c
+++ b/arch/powerpc/platforms/cell/spufs/run.c
@@ -126,7 +126,7 @@ out:
 	return ret;
 }
 
-static int spu_run_init(struct spu_context *ctx, u32 *npc)
+int spu_run_init(struct spu_context *ctx, u32 *npc)
 {
 	spuctx_switch_state(ctx, SPU_UTIL_SYSTEM);
 
@@ -160,8 +160,7 @@ static int spu_run_init(struct spu_conte
 	return 0;
 }
 
-static int spu_run_fini(struct spu_context *ctx, u32 *npc,
-			       u32 *status)
+int spu_run_fini(struct spu_context *ctx, u32 *npc, u32 *status)
 {
 	int ret = 0;
 
--- a/arch/powerpc/platforms/cell/spufs/spufs.h
+++ b/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -254,6 +254,10 @@ void spu_sched_exit(void);
 
 extern char *isolated_loader;
 
+/* sched */
+int spu_run_init(struct spu_context *ctx, u32 *npc);
+int spu_run_fini(struct spu_context *ctx, u32 *npc, u32 *status);
+
 /*
  * spufs_wait
  *	Same as wait_event_interruptible(), except that here

-- 

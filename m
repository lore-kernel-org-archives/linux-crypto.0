From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH v3 6/6] crypto: SHA1 multibuffer - flush the jobs before
 going into idle
Date: Wed, 11 Jun 2014 14:04:10 -0700
Message-ID: <1402520650.2970.542.camel@schen9-DESK>
References: <cover.1402491749.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaFKVEO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jun 2014 17:04:14 -0400
In-Reply-To: <cover.1402491749.git.tim.c.chen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a notifier to the SHA1 multi-buffer algorithm
when CPU is giong idle, so it can take advantage of the available
CPU power to flush out any partially completed jobs.  This
will eliminate possible extended latency in the multi-buffer
algorithm.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha-mb/sha1_mb.c | 67 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 61 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
index 0674727..3469250 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha-mb/sha1_mb.c
@@ -70,6 +70,7 @@
 #include <asm/xsave.h>
 #include <linux/hardirq.h>
 #include <asm/fpu-internal.h>
+#include <asm/idle.h>
 #include "sha_mb_ctx.h"
 
 #define FLUSH_INTERVAL 1000 /* in usec */
@@ -437,9 +438,13 @@ static int sha_complete_job(struct mcryptd_hash_request_ctx *rctx,
 	list_del(&rctx->waiter);
 	spin_unlock(&cstate->work_lock);
 
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
+	if (irqs_disabled())
+		rctx->complete(&req->base, err);
+	else {
+		local_bh_disable();
+		rctx->complete(&req->base, err);
+		local_bh_enable();
+	}
 
 	/* check to see if there are other jobs that are done */
 	sha_ctx = sha1_ctx_mgr_get_comp_ctx(cstate->mgr);
@@ -452,9 +457,13 @@ static int sha_complete_job(struct mcryptd_hash_request_ctx *rctx,
 			spin_unlock(&cstate->work_lock);
 
 			req = cast_mcryptd_ctx_to_req(req_ctx);
-			local_bh_disable();
-			rctx->complete(&req->base, ret);
-			local_bh_enable();
+			if (irqs_disabled())
+				rctx->complete(&req->base, ret);
+			else {
+				local_bh_disable();
+				rctx->complete(&req->base, ret);
+				local_bh_enable();
+			}
 		}
 		sha_ctx = sha1_ctx_mgr_get_comp_ctx(cstate->mgr);
 	}
@@ -812,6 +821,47 @@ static struct ahash_alg sha1_mb_async_alg = {
 	},
 };
 
+void sha1_mb_force_flush(struct mcryptd_alg_cstate *cstate)
+{
+	struct mcryptd_hash_request_ctx *rctx;
+	struct sha1_hash_ctx *sha_ctx;
+
+	/* force flush uncompleted jobs in all data lanes before cpu becomes idle */
+	while (!list_empty(&cstate->work_list)) {
+		/* turn off flusher as we are flushing here */
+		if (cstate->flusher_engaged)
+			cstate->flusher_engaged = false;
+
+		kernel_fpu_begin();
+		sha_ctx = (struct sha1_hash_ctx *) sha1_ctx_mgr_flush(cstate->mgr);
+		kernel_fpu_end();
+		if (!sha_ctx) {
+			pr_err("sha1_mb error: nothing got flushed for non-empty list\n");
+			break;
+		}
+		rctx = cast_hash_to_mcryptd_ctx(sha_ctx);
+		sha_finish_walk(&rctx, cstate, true);
+		sha_complete_job(rctx, cstate, 0);
+	}
+
+	return;
+}
+
+static int sha1_mb_idle_notifier(struct notifier_block *nb, unsigned long val,
+                                void *data)
+{
+	struct mcryptd_alg_cstate *cstate =
+				this_cpu_ptr(sha1_mb_alg_state.alg_cstate);
+
+        if (val == IDLE_START) {
+		sha1_mb_force_flush(cstate);
+	}
+}
+
+static struct notifier_block sha1_mb_idle_nb = {
+	.notifier_call = sha1_mb_idle_notifier,
+};
+
 unsigned long sha1_mb_flusher(struct mcryptd_alg_cstate *cstate)
 {
 	struct mcryptd_hash_request_ctx *rctx;
@@ -822,6 +872,9 @@ unsigned long sha1_mb_flusher(struct mcryptd_alg_cstate *cstate)
 
 	cur_time = jiffies;
 
+	if (!cstate->flusher_engaged)
+		return 0;
+
 	while (!list_empty(&cstate->work_list)) {
 		rctx = list_entry(cstate->work_list.next,
 				struct mcryptd_hash_request_ctx, waiter);
@@ -899,6 +952,7 @@ static int __init sha1_mb_mod_init(void)
 	if (err)
 		goto err1;
 
+	idle_notifier_register(&sha1_mb_idle_nb);
 
 	return 0;
 err1:
@@ -917,6 +971,7 @@ static void __exit sha1_mb_mod_fini(void)
 	int cpu;
 	struct mcryptd_alg_cstate *cpu_state;
 
+	idle_notifier_unregister(&sha1_mb_idle_nb);
 	crypto_unregister_ahash(&sha1_mb_async_alg);
 	crypto_unregister_shash(&sha1_mb_shash_alg);
 	for_each_possible_cpu(cpu) {
-- 
1.7.11.7

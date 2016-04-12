From: Xiaodong Liu <xiaodong.liu@intel.com>
Subject: [PATCH] crypto: sha1-mb - use corrcet pointer while completing jobs
Date: Tue, 12 Apr 2016 09:45:51 +0000
Message-ID: <1460454351-43534-1-git-send-email-xiaodong.liu@intel.com>
Cc: <linux-crypto@vger.kernel.org>, <megha.dey@linux.intel.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>
To: <herbert@gondor.apana.org.au>, <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:19528 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107AbcDLJte (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Apr 2016 05:49:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In sha_complete_job, incorrect mcryptd_hash_request_ctx pointer is used
when check and complete other jobs. If the memory of first completed req
is freed, while still completing other jobs in the func, kernel will
crash since NULL pointer is assigned to RIP.

Signed-off-by: Xiaodong Liu <xiaodong.liu@intel.com>
---
 arch/x86/crypto/sha-mb/sha1_mb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
index a8a0224..081255c 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha-mb/sha1_mb.c
@@ -453,10 +453,10 @@ static int sha_complete_job(struct mcryptd_hash_request_ctx *rctx,
 
 			req = cast_mcryptd_ctx_to_req(req_ctx);
 			if (irqs_disabled())
-				rctx->complete(&req->base, ret);
+				req_ctx->complete(&req->base, ret);
 			else {
 				local_bh_disable();
-				rctx->complete(&req->base, ret);
+				req_ctx->complete(&req->base, ret);
 				local_bh_enable();
 			}
 		}
-- 
2.1.4

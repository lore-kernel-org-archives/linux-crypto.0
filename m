From: Xiaodong Liu <xiaodong.liu@intel.com>
Subject: [PATCH] crypto: fix ctx pointer in sha512-mb
Date: Fri, 12 Aug 2016 06:28:31 -0400
Message-ID: <1470997711-118507-1-git-send-email-xiaodong.liu@intel.com>
Cc: linux-crypto@vger.kernel.org, tim.c.chen@linux.intel.com,
	megha.dey@intel.com, linux-kernel@vger.kernel.org,
	Xiaodong Liu <xiaodong.liu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:52163 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbcHLJjX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Aug 2016 05:39:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Xiaodong Liu <xiaodong.liu@intel.com>
---
 arch/x86/crypto/sha512-mb/sha512_mb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha512-mb/sha512_mb.c b/arch/x86/crypto/sha512-mb/sha512_mb.c
index f4cf5b7..d210174 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb.c
+++ b/arch/x86/crypto/sha512-mb/sha512_mb.c
@@ -497,10 +497,10 @@ static int sha_complete_job(struct mcryptd_hash_request_ctx *rctx,
 
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
1.9.1

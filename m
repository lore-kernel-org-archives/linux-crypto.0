From: Ameen Ali <ameenali023@gmail.com>
Subject: [PATCH 12/12] crypto/sha-mb/sha1_mb.c : Syntax error
Date: Fri, 13 Mar 2015 23:13:24 +0200
Message-ID: <1426281204-10219-1-git-send-email-ameenali023@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Ameen Ali <ameenali023@gmail.com>
To: tim.c.chen@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
	hpa@zytor.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38867 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbCMVNl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Mar 2015 17:13:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

fixing a syntax-error .

Signed-off-by : Ameen Ali <AmeenAli023@gmail.com>
---
 arch/x86/crypto/sha-mb/sha1_mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
index fd9f6b0..ec0b989 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha-mb/sha1_mb.c
@@ -828,7 +828,7 @@ static unsigned long sha1_mb_flusher(struct mcryptd_alg_cstate *cstate)
 	while (!list_empty(&cstate->work_list)) {
 		rctx = list_entry(cstate->work_list.next,
 				struct mcryptd_hash_request_ctx, waiter);
-		if time_before(cur_time, rctx->tag.expire)
+		if(time_before(cur_time, rctx->tag.expire))
 			break;
 		kernel_fpu_begin();
 		sha_ctx = (struct sha1_hash_ctx *) sha1_ctx_mgr_flush(cstate->mgr);
-- 
2.1.0

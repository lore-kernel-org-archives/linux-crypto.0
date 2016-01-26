From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH] crypto : sha1-mb : Add missing args_digest offset
Date: Mon, 25 Jan 2016 16:46:09 -0800
Message-ID: <1453769169-27479-1-git-send-email-megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux=kernel@vger.kernel.org,
	megha.dey@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41724 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687AbcAZAn0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 19:43:26 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Megha Dey <megha.dey@linux.intel.com>

The _args_digest is defined as _args+_digest, both of which are the first
members of 2 separate structures, effectively yielding _args_digest to have
a value of zero. Thus, no errors have spawned yet due to this. To ensure
sanity, adding the missing _args_digest offset to the sha1_mb_mgr_submit.S.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
---
 arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S b/arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S
index 2ab9560..c420d89 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S
+++ b/arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S
@@ -197,7 +197,7 @@ len_is_0:
 	vpinsrd  $1, _args_digest+1*32(state , idx, 4), %xmm0, %xmm0
 	vpinsrd  $2, _args_digest+2*32(state , idx, 4), %xmm0, %xmm0
 	vpinsrd  $3, _args_digest+3*32(state , idx, 4), %xmm0, %xmm0
-	movl    4*32(state, idx, 4), DWORD_tmp
+	movl     _args_digest+4*32(state, idx, 4), DWORD_tmp
 
 	vmovdqu  %xmm0, _result_digest(job_rax)
 	movl    DWORD_tmp, _result_digest+1*16(job_rax)
-- 
1.9.1

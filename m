From: Xiaodong Liu <xiaodong.liu@intel.com>
Subject: Re: [PATCH 4/7] crypto: sha256-mb - submit/flush routines for AVX2
Date: Mon, 11 Apr 2016 06:13:59 +0000
Message-ID: <1460355239-41687-1-git-send-email-xiaodong.liu@intel.com>
References: <1458851163-3448-5-git-send-email-megha.dey@linux.intel.com>
Cc: Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, tim.c.chen@linux.intel.com
To: megha.dey@linux.intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:11326 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbcDKGT0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Apr 2016 02:19:26 -0400
In-reply-to: <1458851163-3448-5-git-send-email-megha.dey@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Xiaodong Liu <xiaodong.liu@intel.com>
---
 sha256_mb_mgr_flush_avx2.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sha256_mb_mgr_flush_avx2.S b/sha256_mb_mgr_flush_avx2.S
index 93eda35..0bd791b 100644
--- a/sha256_mb_mgr_flush_avx2.S
+++ b/sha256_mb_mgr_flush_avx2.S
@@ -285,13 +285,13 @@ ENTRY(sha256_mb_mgr_get_comp_job_avx2)
 	vpinsrd	$1, _args_digest+1*32(state, idx, 4), %xmm0, %xmm0
 	vpinsrd	$2, _args_digest+2*32(state, idx, 4), %xmm0, %xmm0
 	vpinsrd	$3, _args_digest+3*32(state, idx, 4), %xmm0, %xmm0
-	movl	_args_digest+4*32(state, idx, 4), tmp2_w
+	movd	_args_digest+4*32(state, idx, 4), %xmm1
 	vpinsrd	$1, _args_digest+5*32(state, idx, 4), %xmm1, %xmm1
 	vpinsrd	$2, _args_digest+6*32(state, idx, 4), %xmm1, %xmm1
 	vpinsrd	$3, _args_digest+7*32(state, idx, 4), %xmm1, %xmm1
 
 	vmovdqu	%xmm0, _result_digest(job_rax)
-	movl	tmp2_w, _result_digest+1*16(job_rax)
+	vmovdqu	%xmm1, _result_digest+1*16(job_rax)
 
 	pop	%rbx
 
-- 
2.1.4

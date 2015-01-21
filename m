From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] crypto: ccp: terminate ccp_support array with empty element
Date: Wed, 21 Jan 2015 18:06:31 +0300
Message-ID: <1421852791-29679-1-git-send-email-a.ryabinin@samsung.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC...)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37895 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbbAUPGn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Jan 2015 10:06:43 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

x86_match_cpu() expects array of x86_cpu_ids terminated
with empty element.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 drivers/crypto/ccp/ccp-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index c6e6171..ca29c12 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -583,6 +583,7 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
 #ifdef CONFIG_X86
 static const struct x86_cpu_id ccp_support[] = {
 	{ X86_VENDOR_AMD, 22, },
+	{ },
 };
 #endif
 
-- 
2.2.1

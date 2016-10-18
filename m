From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - remove unneeded code
Date: Tue, 18 Oct 2016 17:28:49 -0500
Message-ID: <147682972966.8169.12625496646634682202.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0076.outbound.protection.outlook.com ([104.47.33.76]:25728
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933007AbcJRW3C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 18:29:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Clean up patch for an unneeded structure member.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 0d996fe..b96d788 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -515,7 +515,6 @@ struct ccp_op {
 		struct ccp_passthru_op passthru;
 		struct ccp_ecc_op ecc;
 	} u;
-	struct ccp_mem key;
 };
 
 static inline u32 ccp_addr_lo(struct ccp_dma_info *info)

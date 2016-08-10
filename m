From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: CCP - build error: label 'e_hwrng' undefined
Date: Wed, 10 Aug 2016 12:45:02 -0500
Message-ID: <20160810174502.14375.82321.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <gary.hook@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:20668
	"EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934580AbcHJTSl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2016 15:18:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix goto target for when registration fails

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 4086714..114675e 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -835,7 +835,7 @@ static int ccp5_init(struct ccp_device *ccp)
 	/* Register the DMA engine support */
 	ret = ccp_dmaengine_register(ccp);
 	if (ret)
-		goto e_hwrng;
+		goto e_kthread;
 
 	return 0;
 

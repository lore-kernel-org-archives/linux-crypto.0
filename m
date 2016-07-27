From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 09/10] crypto: ccp - Enable DMA service on a v5 CCP
Date: Tue, 26 Jul 2016 19:10:40 -0500
Message-ID: <20160727001040.24944.93400.stgit@taos>
References: <20160727000652.24944.44919.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0041.outbound.protection.outlook.com ([104.47.38.41]:3461
	"EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757678AbcG0AZR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jul 2016 20:25:17 -0400
In-Reply-To: <20160727000652.24944.44919.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Every CCP is capable of providing general DMA services.
Register the device as a provider.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index ddce220..4086714 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -832,6 +832,11 @@ static int ccp5_init(struct ccp_device *ccp)
 	if (ret)
 		goto e_kthread;
 
+	/* Register the DMA engine support */
+	ret = ccp_dmaengine_register(ccp);
+	if (ret)
+		goto e_hwrng;
+
 	return 0;
 
 e_kthread:
@@ -856,6 +861,9 @@ static void ccp5_destroy(struct ccp_device *ccp)
 	struct ccp_cmd *cmd;
 	unsigned int i;
 
+	/* Unregister the DMA engine */
+	ccp_dmaengine_unregister(ccp);
+
 	/* Unregister the RNG */
 	ccp_unregister_rng(ccp);
 

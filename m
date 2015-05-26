From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 2/3] crypto: ccp - Remove unused structure field
Date: Tue, 26 May 2015 13:06:30 -0500
Message-ID: <20150526180630.6527.80504.stgit@tlendack-t1.amdoffice.net>
References: <20150526180612.6527.53332.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0106.outbound.protection.outlook.com ([207.46.100.106]:59024
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750845AbbEZSWT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 14:22:19 -0400
In-Reply-To: <20150526180612.6527.53332.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the length field from the ccp_sg_workarea since it is unused.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-ops.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 71f2e3c..542453c 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -53,7 +53,6 @@ struct ccp_dm_workarea {
 struct ccp_sg_workarea {
 	struct scatterlist *sg;
 	unsigned int nents;
-	unsigned int length;
 
 	struct scatterlist *dma_sg;
 	struct device *dma_dev;
@@ -497,7 +496,6 @@ static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
 		return 0;
 
 	wa->nents = sg_nents(sg);
-	wa->length = sg->length;
 	wa->bytes_left = len;
 	wa->sg_used = 0;
 

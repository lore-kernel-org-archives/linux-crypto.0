From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: CCP - change type of struct member lsb to signed
Date: Wed, 12 Oct 2016 08:47:03 -0500
Message-ID: <20161012134703.15296.24795.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0041.outbound.protection.outlook.com ([104.47.34.41]:44448
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754043AbcJLPW3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Oct 2016 11:22:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The lsb field uses a value of -1 to indicate that it
is unassigned. Therefore type must be a signed int.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index da5f4a6..5afaa53 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -278,7 +278,7 @@ struct ccp_cmd_queue {
 	/* Private LSB that is assigned to this queue, or -1 if none.
 	 * Bitmap for my private LSB, unused otherwise
 	 */
-	unsigned int lsb;
+	int lsb;
 	DECLARE_BITMAP(lsbmap, PLSB_MAP_SIZE);
 
 	/* Queue processing thread */

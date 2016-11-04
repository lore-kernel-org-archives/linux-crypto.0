From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V2 1/9] crypto: ccp - Fix handling of RSA exponent on a v5
 device
Date: Fri, 4 Nov 2016 11:03:34 -0500
Message-ID: <20161104160334.18155.32509.stgit@taos>
References: <20161104160140.18155.75618.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0079.outbound.protection.outlook.com ([104.47.34.79]:58880
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935059AbcKDQDm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Nov 2016 12:03:42 -0400
In-Reply-To: <20161104160140.18155.75618.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The exponent size in the ccp_op structure is in bits. A v5
CCP requires the exponent size to be in bytes, so convert
the size from bits to bytes when populating the descriptor.

The current code references the exponent in memory, but
these fields have not been set since the exponent is
actually store in the LSB. Populate the descriptor with
the LSB location (address).

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index ff7816a..e2ce819 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -403,7 +403,7 @@ static int ccp5_perform_rsa(struct ccp_op *op)
 	CCP5_CMD_PROT(&desc) = 0;
 
 	function.raw = 0;
-	CCP_RSA_SIZE(&function) = op->u.rsa.mod_size;
+	CCP_RSA_SIZE(&function) = op->u.rsa.mod_size >> 3;
 	CCP5_CMD_FUNCTION(&desc) = function.raw;
 
 	CCP5_CMD_LEN(&desc) = op->u.rsa.input_len;
@@ -418,10 +418,10 @@ static int ccp5_perform_rsa(struct ccp_op *op)
 	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
 	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
 
-	/* Key (Exponent) is in external memory */
-	CCP5_CMD_KEY_LO(&desc) = ccp_addr_lo(&op->exp.u.dma);
-	CCP5_CMD_KEY_HI(&desc) = ccp_addr_hi(&op->exp.u.dma);
-	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+	/* Exponent is in LSB memory */
+	CCP5_CMD_KEY_LO(&desc) = op->sb_key * LSB_ITEM_SIZE;
+	CCP5_CMD_KEY_HI(&desc) = 0;
+	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SB;
 
 	return ccp5_do_cmd(&desc, op->cmd_q);
 }

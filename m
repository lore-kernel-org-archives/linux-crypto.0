From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Remove redundant cpu-to-le32 macros
Date: Tue, 28 Mar 2017 08:58:28 -0500
Message-ID: <20170328135828.13086.97535.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <gary.hook@amd.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0079.outbound.protection.outlook.com ([104.47.36.79]:20016
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752303AbdC1N7E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 09:59:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Endianness is dealt with when the command descriptor is
copied into the command queue. Remove any occurrences of
cpu_to_le32() found elsewhere.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 5e08654..e03d06a 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -419,22 +419,22 @@ static int ccp5_perform_des3(struct ccp_op *op)
 	CCP_DES3_ENCRYPT(&function) = op->u.des3.action;
 	CCP_DES3_MODE(&function) = op->u.des3.mode;
 	CCP_DES3_TYPE(&function) = op->u.des3.type;
-	CCP5_CMD_FUNCTION(&desc) = cpu_to_le32(function.raw);
+	CCP5_CMD_FUNCTION(&desc) = function.raw;
 
-	CCP5_CMD_LEN(&desc) = cpu_to_le32(op->src.u.dma.length);
+	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
 
-	CCP5_CMD_SRC_LO(&desc) = cpu_to_le32(ccp_addr_lo(&op->src.u.dma));
-	CCP5_CMD_SRC_HI(&desc) = cpu_to_le32(ccp_addr_hi(&op->src.u.dma));
-	CCP5_CMD_SRC_MEM(&desc) = cpu_to_le32(CCP_MEMTYPE_SYSTEM);
+	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
+	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
+	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
 
-	CCP5_CMD_DST_LO(&desc) = cpu_to_le32(ccp_addr_lo(&op->dst.u.dma));
-	CCP5_CMD_DST_HI(&desc) = cpu_to_le32(ccp_addr_hi(&op->dst.u.dma));
-	CCP5_CMD_DST_MEM(&desc) = cpu_to_le32(CCP_MEMTYPE_SYSTEM);
+	CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
+	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
+	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
 
-	CCP5_CMD_KEY_LO(&desc) = cpu_to_le32(lower_32_bits(key_addr));
+	CCP5_CMD_KEY_LO(&desc) = lower_32_bits(key_addr);
 	CCP5_CMD_KEY_HI(&desc) = 0;
-	CCP5_CMD_KEY_MEM(&desc) = cpu_to_le32(CCP_MEMTYPE_SB);
-	CCP5_CMD_LSB_ID(&desc) = cpu_to_le32(op->sb_ctx);
+	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SB;
+	CCP5_CMD_LSB_ID(&desc) = op->sb_ctx;
 
 	return ccp5_do_cmd(&desc, op->cmd_q);
 }

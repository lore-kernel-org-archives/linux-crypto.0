From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Set the AES size field for all modes
Date: Wed, 8 Feb 2017 13:07:06 -0600
Message-ID: <20170208190706.7984.97805.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0070.outbound.protection.outlook.com ([104.47.33.70]:13120
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751014AbdBHTI7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2017 14:08:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ensure that the size field is correctly populated for
all AES modes.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |    3 +--
 drivers/crypto/ccp/ccp-dev.h    |    1 +
 drivers/crypto/ccp/ccp-ops.c    |    8 ++++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 612898b..9c6ff8b8 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -284,8 +284,7 @@ static int ccp5_perform_aes(struct ccp_op *op)
 	CCP_AES_ENCRYPT(&function) = op->u.aes.action;
 	CCP_AES_MODE(&function) = op->u.aes.mode;
 	CCP_AES_TYPE(&function) = op->u.aes.type;
-	if (op->u.aes.mode == CCP_AES_MODE_CFB)
-		CCP_AES_SIZE(&function) = 0x7f;
+	CCP_AES_SIZE(&function) = op->u.aes.size;
 
 	CCP5_CMD_FUNCTION(&desc) = function.raw;
 
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 649e561..2b5c01f 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -467,6 +467,7 @@ struct ccp_aes_op {
 	enum ccp_aes_type type;
 	enum ccp_aes_mode mode;
 	enum ccp_aes_action action;
+	unsigned int size;
 };
 
 struct ccp_xts_aes_op {
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 50fae44..6878160 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -692,6 +692,14 @@ static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			goto e_ctx;
 		}
 	}
+	switch (aes->mode) {
+	case CCP_AES_MODE_CFB: /* CFB128 only */
+	case CCP_AES_MODE_CTR:
+		op.u.aes.size = AES_BLOCK_SIZE * BITS_PER_BYTE - 1;
+		break;
+	default:
+		op.u.aes.size = 0;
+	}
 
 	/* Prepare the input and output data workareas. For in-place
 	 * operations we need to set the dma direction to BIDIRECTIONAL

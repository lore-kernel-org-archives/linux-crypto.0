From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 2/4] crypto: ccp - Set the start-of-command bit
Date: Mon, 30 Jan 2017 08:28:34 -0600
Message-ID: <20170130142834.8459.15278.stgit@taos>
References: <20170130142414.8459.71539.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0075.outbound.protection.outlook.com ([104.47.41.75]:33706
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753536AbdA3O2s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2017 09:28:48 -0500
In-Reply-To: <20170130142414.8459.71539.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The start-of-command bit should be set for every sha
operation.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-ops.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 50fae44..1a27af3 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1077,6 +1077,7 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		case CCP_SHA_TYPE_1:
 		case CCP_SHA_TYPE_224:
 		case CCP_SHA_TYPE_256:
+			op.soc = 1;
 			memcpy(ctx.address + ioffset, init, ctx_size);
 			break;
 		default:

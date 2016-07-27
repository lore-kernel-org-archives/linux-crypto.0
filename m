From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 02/10] crypto: ccp - Shorten the fields of the action
 structure
Date: Tue, 26 Jul 2016 19:09:31 -0500
Message-ID: <20160727000931.24944.8322.stgit@taos>
References: <20160727000652.24944.44919.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0057.outbound.protection.outlook.com ([104.47.32.57]:58553
	"EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756926AbcG0AYH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jul 2016 20:24:07 -0400
In-Reply-To: <20160727000652.24944.44919.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use more concise field names; "perform_" is too verbose.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v3.c |   12 ++++++------
 drivers/crypto/ccp/ccp-dev.h    |   12 ++++++------
 drivers/crypto/ccp/ccp-ops.c    |   21 +++++++++++----------
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 2f7f3c5..1a94d2e 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -528,12 +528,12 @@ static irqreturn_t ccp_irq_handler(int irq, void *data)
 }
 
 static const struct ccp_actions ccp3_actions = {
-	.perform_aes = ccp_perform_aes,
-	.perform_xts_aes = ccp_perform_xts_aes,
-	.perform_sha = ccp_perform_sha,
-	.perform_rsa = ccp_perform_rsa,
-	.perform_passthru = ccp_perform_passthru,
-	.perform_ecc = ccp_perform_ecc,
+	.aes = ccp_perform_aes,
+	.xts_aes = ccp_perform_xts_aes,
+	.sha = ccp_perform_sha,
+	.rsa = ccp_perform_rsa,
+	.passthru = ccp_perform_passthru,
+	.ecc = ccp_perform_ecc,
 	.init = ccp_init,
 	.destroy = ccp_destroy,
 	.irqhandler = ccp_irq_handler,
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 8824e41..46d3ef3 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -149,12 +149,12 @@ struct ccp_op;
 
 /* Structure for computation functions that are device-specific */
 struct ccp_actions {
-	int (*perform_aes)(struct ccp_op *);
-	int (*perform_xts_aes)(struct ccp_op *);
-	int (*perform_sha)(struct ccp_op *);
-	int (*perform_rsa)(struct ccp_op *);
-	int (*perform_passthru)(struct ccp_op *);
-	int (*perform_ecc)(struct ccp_op *);
+	int (*aes)(struct ccp_op *);
+	int (*xts_aes)(struct ccp_op *);
+	int (*sha)(struct ccp_op *);
+	int (*rsa)(struct ccp_op *);
+	int (*passthru)(struct ccp_op *);
+	int (*ecc)(struct ccp_op *);
 	int (*init)(struct ccp_device *);
 	void (*destroy)(struct ccp_device *);
 	irqreturn_t (*irqhandler)(int, void *);
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index ffa2891..d102477 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ * Author: Gary R Hook <gary.hook@amd.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -478,7 +479,7 @@ static int ccp_copy_to_from_ksb(struct ccp_cmd_queue *cmd_q,
 
 	op.u.passthru.byte_swap = byte_swap;
 
-	return cmd_q->ccp->vdata->perform->perform_passthru(&op);
+	return cmd_q->ccp->vdata->perform->passthru(&op);
 }
 
 static int ccp_copy_to_ksb(struct ccp_cmd_queue *cmd_q,
@@ -610,7 +611,7 @@ static int ccp_run_aes_cmac_cmd(struct ccp_cmd_queue *cmd_q,
 			}
 		}
 
-		ret = cmd_q->ccp->vdata->perform->perform_aes(&op);
+		ret = cmd_q->ccp->vdata->perform->aes(&op);
 		if (ret) {
 			cmd->engine_error = cmd_q->cmd_error;
 			goto e_src;
@@ -772,7 +773,7 @@ static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 				op.soc = 1;
 		}
 
-		ret = cmd_q->ccp->vdata->perform->perform_aes(&op);
+		ret = cmd_q->ccp->vdata->perform->aes(&op);
 		if (ret) {
 			cmd->engine_error = cmd_q->cmd_error;
 			goto e_dst;
@@ -937,7 +938,7 @@ static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
 		if (!src.sg_wa.bytes_left)
 			op.eom = 1;
 
-		ret = cmd_q->ccp->vdata->perform->perform_xts_aes(&op);
+		ret = cmd_q->ccp->vdata->perform->xts_aes(&op);
 		if (ret) {
 			cmd->engine_error = cmd_q->cmd_error;
 			goto e_dst;
@@ -1094,7 +1095,7 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		if (sha->final && !src.sg_wa.bytes_left)
 			op.eom = 1;
 
-		ret = cmd_q->ccp->vdata->perform->perform_sha(&op);
+		ret = cmd_q->ccp->vdata->perform->sha(&op);
 		if (ret) {
 			cmd->engine_error = cmd_q->cmd_error;
 			goto e_data;
@@ -1274,7 +1275,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	op.u.rsa.mod_size = rsa->key_size;
 	op.u.rsa.input_len = i_len;
 
-	ret = cmd_q->ccp->vdata->perform->perform_rsa(&op);
+	ret = cmd_q->ccp->vdata->perform->rsa(&op);
 	if (ret) {
 		cmd->engine_error = cmd_q->cmd_error;
 		goto e_dst;
@@ -1399,7 +1400,7 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
 		op.dst.u.dma.offset = dst.sg_wa.sg_used;
 		op.dst.u.dma.length = op.src.u.dma.length;
 
-		ret = cmd_q->ccp->vdata->perform->perform_passthru(&op);
+		ret = cmd_q->ccp->vdata->perform->passthru(&op);
 		if (ret) {
 			cmd->engine_error = cmd_q->cmd_error;
 			goto e_dst;
@@ -1484,7 +1485,7 @@ static int ccp_run_passthru_nomap_cmd(struct ccp_cmd_queue *cmd_q,
 	op.dst.u.dma.offset = 0;
 	op.dst.u.dma.length = pt->src_len;
 
-	ret = cmd_q->ccp->vdata->perform->perform_passthru(&op);
+	ret = cmd_q->ccp->vdata->perform->passthru(&op);
 	if (ret)
 		cmd->engine_error = cmd_q->cmd_error;
 
@@ -1575,7 +1576,7 @@ static int ccp_run_ecc_mm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	op.u.ecc.function = cmd->u.ecc.function;
 
-	ret = cmd_q->ccp->vdata->perform->perform_ecc(&op);
+	ret = cmd_q->ccp->vdata->perform->ecc(&op);
 	if (ret) {
 		cmd->engine_error = cmd_q->cmd_error;
 		goto e_dst;
@@ -1739,7 +1740,7 @@ static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 
 	op.u.ecc.function = cmd->u.ecc.function;
 
-	ret = cmd_q->ccp->vdata->perform->perform_ecc(&op);
+	ret = cmd_q->ccp->vdata->perform->ecc(&op);
 	if (ret) {
 		cmd->engine_error = cmd_q->cmd_error;
 		goto e_dst;

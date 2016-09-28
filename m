From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v2 2/2] crypto: ccp - Make syslog errors human-readable
Date: Wed, 28 Sep 2016 11:53:56 -0500
Message-ID: <20160928165356.23263.84073.stgit@taos>
References: <20160928165204.23263.77515.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0074.outbound.protection.outlook.com ([104.47.34.74]:40181
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932856AbcI1RJU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 13:09:20 -0400
In-Reply-To: <20160928165204.23263.77515.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add human-readable strings to log messages about CCP errors

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v3.c |    3 ++
 drivers/crypto/ccp/ccp-dev-v5.c |    3 ++
 drivers/crypto/ccp/ccp-dev.c    |   53 +++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.h    |    2 +
 4 files changed, 61 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index b6615b1..8d2dbac 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -124,6 +124,9 @@ static int ccp_do_cmd(struct ccp_op *op, u32 *cr, unsigned int cr_count)
 			/* On error delete all related jobs from the queue */
 			cmd = (cmd_q->id << DEL_Q_ID_SHIFT)
 			      | op->jobid;
+			if (cmd_q->cmd_error)
+				ccp_log_error(cmd_q->ccp,
+					      cmd_q->cmd_error);
 
 			iowrite32(cmd, ccp->io_regs + DEL_CMD_Q_JOB);
 
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index a90ca9e..faf3cb3 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -243,6 +243,9 @@ static int ccp5_do_cmd(struct ccp5_desc *desc,
 		ret = wait_event_interruptible(cmd_q->int_queue,
 					       cmd_q->int_rcvd);
 		if (ret || cmd_q->cmd_error) {
+			if (cmd_q->cmd_error)
+				ccp_log_error(cmd_q->ccp,
+					      cmd_q->cmd_error);
 			/* A version 5 device doesn't use Job IDs... */
 			if (!ret)
 				ret = -EIO;
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 5d36eef..cafa633 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -40,6 +40,59 @@ struct ccp_tasklet_data {
 	struct ccp_cmd *cmd;
 };
 
+/* Human-readable error strings */
+char *ccp_error_codes[] = {
+	"",
+	"ERR 01: ILLEGAL_ENGINE",
+	"ERR 02: ILLEGAL_KEY_ID",
+	"ERR 03: ILLEGAL_FUNCTION_TYPE",
+	"ERR 04: ILLEGAL_FUNCTION_MODE",
+	"ERR 05: ILLEGAL_FUNCTION_ENCRYPT",
+	"ERR 06: ILLEGAL_FUNCTION_SIZE",
+	"ERR 07: Zlib_MISSING_INIT_EOM",
+	"ERR 08: ILLEGAL_FUNCTION_RSVD",
+	"ERR 09: ILLEGAL_BUFFER_LENGTH",
+	"ERR 10: VLSB_FAULT",
+	"ERR 11: ILLEGAL_MEM_ADDR",
+	"ERR 12: ILLEGAL_MEM_SEL",
+	"ERR 13: ILLEGAL_CONTEXT_ID",
+	"ERR 14: ILLEGAL_KEY_ADDR",
+	"ERR 15: 0xF Reserved",
+	"ERR 16: Zlib_ILLEGAL_MULTI_QUEUE",
+	"ERR 17: Zlib_ILLEGAL_JOBID_CHANGE",
+	"ERR 18: CMD_TIMEOUT",
+	"ERR 19: IDMA0_AXI_SLVERR",
+	"ERR 20: IDMA0_AXI_DECERR",
+	"ERR 21: 0x15 Reserved",
+	"ERR 22: IDMA1_AXI_SLAVE_FAULT",
+	"ERR 23: IDMA1_AIXI_DECERR",
+	"ERR 24: 0x18 Reserved",
+	"ERR 25: ZLIBVHB_AXI_SLVERR",
+	"ERR 26: ZLIBVHB_AXI_DECERR",
+	"ERR 27: 0x1B Reserved",
+	"ERR 27: ZLIB_UNEXPECTED_EOM",
+	"ERR 27: ZLIB_EXTRA_DATA",
+	"ERR 30: ZLIB_BTYPE",
+	"ERR 31: ZLIB_UNDEFINED_SYMBOL",
+	"ERR 32: ZLIB_UNDEFINED_DISTANCE_S",
+	"ERR 33: ZLIB_CODE_LENGTH_SYMBOL",
+	"ERR 34: ZLIB _VHB_ILLEGAL_FETCH",
+	"ERR 35: ZLIB_UNCOMPRESSED_LEN",
+	"ERR 36: ZLIB_LIMIT_REACHED",
+	"ERR 37: ZLIB_CHECKSUM_MISMATCH0",
+	"ERR 38: ODMA0_AXI_SLVERR",
+	"ERR 39: ODMA0_AXI_DECERR",
+	"ERR 40: 0x28 Reserved",
+	"ERR 41: ODMA1_AXI_SLVERR",
+	"ERR 42: ODMA1_AXI_DECERR",
+	"ERR 43: LSB_PARITY_ERR",
+};
+
+void ccp_log_error(struct ccp_device *d, int e)
+{
+	dev_err(d->dev, "CCP error: %s (0x%x)\n", ccp_error_codes[e], e);
+}
+
 /* List of CCPs, CCP count, read-write access lock, and access functions
  *
  * Lock structure: get ccp_unit_lock for reading whenever we need to
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 08f58b0..da5f4a6 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -601,6 +601,8 @@ void ccp_platform_exit(void);
 void ccp_add_device(struct ccp_device *ccp);
 void ccp_del_device(struct ccp_device *ccp);
 
+extern void ccp_log_error(struct ccp_device *, int);
+
 struct ccp_device *ccp_alloc_struct(struct device *dev);
 bool ccp_queues_suspended(struct ccp_device *ccp);
 int ccp_cmd_queue_thread(void *data);

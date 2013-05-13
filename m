From: Andrei Varvara <andrei.varvara@freescale.com>
Subject: [PATCH 1/8] crypto: caam - fix SEQ IN PTR command when RTO or PRE bit is set
Date: Mon, 13 May 2013 17:37:57 +0300
Message-ID: <1368455877-1759-1-git-send-email-andrei.varvara@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <Kim.Phillips@freescale.com>, <AFLEMING@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:12130
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554Ab3EMOxK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 May 2013 10:53:10 -0400
Received: from mail107-db8 (localhost [127.0.0.1])	by
 mail107-db8-R.bigfish.com (Postfix) with ESMTP id 70872200AB0	for
 <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:38:05 +0000 (UTC)
Received: from DB8EHSMHS025.bigfish.com (unknown [10.174.8.235])	by
 mail107-db8.bigfish.com (Postfix) with ESMTP id 52F30180055	for
 <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:38:03 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SEQ IN PTR command does not require pointer if RTO or PRE bit is set
Updated desc_constr.h accordingly.

Signed-off-by: Andrei Varvara <andrei.varvara@freescale.com>
Reviewed-by: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>
Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
---
 drivers/crypto/caam/desc.h        |    4 ++--
 drivers/crypto/caam/desc_constr.h |    8 ++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index f7f833b..89fa3d0 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -1290,18 +1290,18 @@ struct sec4_sg_entry {
  * SEQ_OUT_PTR Command Constructs
  */
 
 /* Sequence pointer is a scatter-gather table */
 #define SQOUT_SGF	0x01000000
 
 /* Appends to a previous pointer */
-#define SQOUT_PRE	0x00800000
+#define SQOUT_PRE	SQIN_PRE
 
 /* Restore sequence with pointer/length */
-#define SQOUT_RTO	0x00200000
+#define SQOUT_RTO	 SQIN_RTO
 
 /* Use extended length following pointer */
 #define SQOUT_EXT	0x00400000
 
 #define SQOUT_LEN_SHIFT		0
 #define SQOUT_LEN_MASK		(0xffff << SQOUT_LEN_SHIFT)
 
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index c85c1f0..19501b5 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -118,15 +118,16 @@ static inline void append_cmd_ptr(u32 *desc, dma_addr_t ptr, int len,
 }
 
 /* Write length after pointer, rather than inside command */
 static inline void append_cmd_ptr_extlen(u32 *desc, dma_addr_t ptr,
 					 unsigned int len, u32 command)
 {
 	append_cmd(desc, command);
-	append_ptr(desc, ptr);
+	if (!(command & (SQIN_RTO | SQIN_PRE)))
+		append_ptr(desc, ptr);
 	append_cmd(desc, len);
 }
 
 static inline void append_cmd_data(u32 *desc, void *data, int len,
 				   u32 command)
 {
 	append_cmd(desc, command | IMMEDIATE | len);
@@ -182,15 +183,18 @@ APPEND_CMD_PTR(fifo_store, FIFO_STORE)
 
 #define APPEND_SEQ_PTR_INTLEN(cmd, op) \
 static inline void append_seq_##cmd##_ptr_intlen(u32 *desc, dma_addr_t ptr, \
 						 unsigned int len, \
 						 u32 options) \
 { \
 	PRINT_POS; \
-	append_cmd_ptr(desc, ptr, len, CMD_SEQ_##op##_PTR | options); \
+	if (options & (SQIN_RTO | SQIN_PRE)) \
+		append_cmd(desc, CMD_SEQ_##op##_PTR | len | options); \
+	else \
+		append_cmd_ptr(desc, ptr, len, CMD_SEQ_##op##_PTR | options); \
 }
 APPEND_SEQ_PTR_INTLEN(in, IN)
 APPEND_SEQ_PTR_INTLEN(out, OUT)
 
 #define APPEND_CMD_PTR_TO_IMM(cmd, op) \
 static inline void append_##cmd##_as_imm(u32 *desc, void *data, \
 					 unsigned int len, u32 options) \
-- 
1.7.3.4

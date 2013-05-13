From: Andrei Varvara <andrei.varvara@freescale.com>
Subject: [PATCH 2/8] crypto: caam - Fix STORE command to support overwriting Shared Descriptor's memory
Date: Mon, 13 May 2013 17:50:51 +0300
Message-ID: <1368456651-1798-1-git-send-email-andrei.varvara@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <Kim.Phillips@freescale.com>, <AFLEMING@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:31741
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754449Ab3EMOvB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 May 2013 10:51:01 -0400
Received: from mail47-db8 (localhost [127.0.0.1])	by mail47-db8-R.bigfish.com
 (Postfix) with ESMTP id EC8E8C20246	for <linux-crypto@vger.kernel.org>; Mon,
 13 May 2013 14:50:59 +0000 (UTC)
Received: from DB8EHSMHS021.bigfish.com (unknown [10.174.8.249])	by
 mail47-db8.bigfish.com (Postfix) with ESMTP id 33D5E580066	for
 <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:50:57 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In case Store command is used with overwrite Shared Descriptor
feature there is no need for pointer, it is using the
address from which the Shared Descriptor was fetched.

Signed-off-by: Andrei Varvara <andrei.varvara@freescale.com>
Reviewed-by: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>
Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
---
 drivers/crypto/caam/desc_constr.h |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 19501b5..fc4470a 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -173,18 +173,34 @@ static inline void append_##cmd(u32 *desc, dma_addr_t ptr, unsigned int len, \
 				u32 options) \
 { \
 	PRINT_POS; \
 	append_cmd_ptr(desc, ptr, len, CMD_##op | options); \
 }
 APPEND_CMD_PTR(key, KEY)
 APPEND_CMD_PTR(load, LOAD)
-APPEND_CMD_PTR(store, STORE)
 APPEND_CMD_PTR(fifo_load, FIFO_LOAD)
 APPEND_CMD_PTR(fifo_store, FIFO_STORE)
 
+static inline void append_store(u32 *desc, dma_addr_t ptr, unsigned int len,
+				u32 options)
+{
+	u32 cmd_src;
+
+	cmd_src = options & LDST_SRCDST_MASK;
+
+	append_cmd(desc, CMD_STORE | options | len);
+
+	/* The following options do not require pointer */
+	if (!(cmd_src == LDST_SRCDST_WORD_DESCBUF_SHARED ||
+	      cmd_src == LDST_SRCDST_WORD_DESCBUF_JOB    ||
+	      cmd_src == LDST_SRCDST_WORD_DESCBUF_JOB_WE ||
+	      cmd_src == LDST_SRCDST_WORD_DESCBUF_SHARED_WE))
+		append_ptr(desc, ptr);
+}
+
 #define APPEND_SEQ_PTR_INTLEN(cmd, op) \
 static inline void append_seq_##cmd##_ptr_intlen(u32 *desc, dma_addr_t ptr, \
 						 unsigned int len, \
 						 u32 options) \
 { \
 	PRINT_POS; \
 	if (options & (SQIN_RTO | SQIN_PRE)) \
-- 
1.7.3.4

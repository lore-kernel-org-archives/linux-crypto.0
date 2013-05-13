From: Andrei Varvara <andrei.varvara@freescale.com>
Subject: [PATCH 6/8] crypto: caam - Add defines for CAAM commands
Date: Mon, 13 May 2013 17:52:51 +0300
Message-ID: <1368456771-2033-1-git-send-email-andrei.varvara@freescale.com>
References: <n>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <Kim.Phillips@freescale.com>, <AFLEMING@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:15540
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554Ab3EMOxC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 May 2013 10:53:02 -0400
Received: from mail122-va3 (localhost [127.0.0.1])	by
 mail122-va3-R.bigfish.com (Postfix) with ESMTP id F3C714402C8	for
 <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:53:01 +0000 (UTC)
Received: from VA3EHSMHS011.bigfish.com (unknown [10.7.14.254])	by
 mail122-va3.bigfish.com (Postfix) with ESMTP id 84BE4480054	for
 <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:52:59 +0000 (UTC)
In-Reply-To: <n>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

add defines for:
    append load immediate command
    setting SEQ LIODN equal to the Non-SEQ LIODN for the job
    replace job descriptor command

Signed-off-by: Andrei Varvara <andrei.varvara@freescale.com>
Reviewed-by: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>
Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
---
 drivers/crypto/caam/desc.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 972ad14..8214dc1 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -1604,8 +1604,17 @@ struct sec4_sg_entry {
 
 #define NFIFOENTRY_DLEN_SHIFT	0
 #define NFIFOENTRY_DLEN_MASK	(0xFFF << NFIFOENTRY_DLEN_SHIFT)
 
 #define NFIFOENTRY_PLEN_SHIFT	0
 #define NFIFOENTRY_PLEN_MASK	(0xFF << NFIFOENTRY_PLEN_SHIFT)
 
+/* Append Load Immediate Command */
+#define FD_CMD_APPEND_LOAD_IMMEDIATE			0x80000000
+
+/* Set SEQ LIODN equal to the Non-SEQ LIODN for the job */
+#define FD_CMD_SET_SEQ_LIODN_EQUAL_NONSEQ_LIODN		0x40000000
+
+/* Frame Descriptor Command for Replacement Job Descriptor */
+#define FD_CMD_REPLACE_JOB_DESC				0x20000000
+
 #endif /* DESC_H */
-- 
1.7.3.4

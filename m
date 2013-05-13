From: Andrei Varvara <andrei.varvara@freescale.com>
Subject: [PATCH 5/8] crypto: caam - Add defines for overwriting Descriptor's memory
Date: Mon, 13 May 2013 17:52:41 +0300
Message-ID: <1368456761-1986-1-git-send-email-andrei.varvara@freescale.com>
References: <n>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <Kim.Phillips@freescale.com>, <AFLEMING@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:30427
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab3EMOwy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 May 2013 10:52:54 -0400
Received: from mail29-ch1 (localhost [127.0.0.1])	by mail29-ch1-R.bigfish.com
 (Postfix) with ESMTP id 12F5760295	for <linux-crypto@vger.kernel.org>; Mon,
 13 May 2013 14:52:54 +0000 (UTC)
Received: from CH1EHSMHS017.bigfish.com (snatpool2.int.messaging.microsoft.com
 [10.43.68.230])	by mail29-ch1.bigfish.com (Postfix) with ESMTP id E82061C00E6
	for <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:52:47 +0000 (UTC)
In-Reply-To: <n>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Store command has options to overwrite the Job Desc, Shared Desc or
the entire Descriptor in memory, using the address from
which the Descriptor was fetched.

Signed-off-by: Andrei Varvara <andrei.varvara@freescale.com>
Reviewed-by: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>
Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
---
 drivers/crypto/caam/desc.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 7d8b147..972ad14 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -228,14 +228,18 @@ struct sec4_sg_entry {
 #define LDST_SRCDST_WORD_CLASS1_ICV_SZ	(0x0c << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_ALTDS_CLASS1	(0x0f << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_A_SZ	(0x10 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_B_SZ	(0x11 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_N_SZ	(0x12 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_E_SZ	(0x13 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DESCBUF	(0x40 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DESCBUF_JOB	(0x41 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DESCBUF_SHARED	(0x42 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DESCBUF_JOB_WE	(0x45 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_DESCBUF_SHARED_WE (0x46 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_INFO_FIFO	(0x7a << LDST_SRCDST_SHIFT)
 
 /* Offset in source/destination */
 #define LDST_OFFSET_SHIFT	8
 #define LDST_OFFSET_MASK	(0xff << LDST_OFFSET_SHIFT)
 
 /* LDOFF definitions used when DST = LDST_SRCDST_WORD_DECOCTRL */
-- 
1.7.3.4

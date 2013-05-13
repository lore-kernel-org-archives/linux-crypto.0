From: Andrei Varvara <andrei.varvara@freescale.com>
Subject: [PATCH 8/8] crypto: caam - add missing flag for the LOAD/STORE commands
Date: Mon, 13 May 2013 17:53:16 +0300
Message-ID: <1368456796-2119-1-git-send-email-andrei.varvara@freescale.com>
References: <n>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <Kim.Phillips@freescale.com>, <AFLEMING@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:10947
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554Ab3EMOxX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 May 2013 10:53:23 -0400
Received: from mail158-co9 (localhost [127.0.0.1])	by
 mail158-co9-R.bigfish.com (Postfix) with ESMTP id D233B2C01D8	for
 <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:53:22 +0000 (UTC)
Received: from CO9EHSMHS027.bigfish.com (unknown [10.236.132.248])	by
 mail158-co9.bigfish.com (Postfix) with ESMTP id E0F86340285	for
 <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:53:20 +0000 (UTC)
In-Reply-To: <n>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Class Context SRC / DEST flags for the LOAD & STORE commands

Signed-off-by: Andrei Varvara <andrei.varvara@freescale.com>
Reviewed-by: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>
Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
---
 drivers/crypto/caam/desc.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 8214dc1..53b296f 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -227,14 +227,15 @@ struct sec4_sg_entry {
 #define LDST_SRCDST_WORD_DECO_MATH3	(0x0b << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_CLASS1_ICV_SZ	(0x0c << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_ALTDS_CLASS1	(0x0f << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_A_SZ	(0x10 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_B_SZ	(0x11 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_N_SZ	(0x12 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_PKHA_E_SZ	(0x13 << LDST_SRCDST_SHIFT)
+#define LDST_SRCDST_WORD_CLASS_CTX	(0x20 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DESCBUF	(0x40 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DESCBUF_JOB	(0x41 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DESCBUF_SHARED	(0x42 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DESCBUF_JOB_WE	(0x45 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_DESCBUF_SHARED_WE (0x46 << LDST_SRCDST_SHIFT)
 #define LDST_SRCDST_WORD_INFO_FIFO	(0x7a << LDST_SRCDST_SHIFT)
 
-- 
1.7.3.4

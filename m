From: Andrei Varvara <andrei.varvara@freescale.com>
Subject: [PATCH 3/8] crypto: caam - Add MATH command to support shld function
Date: Mon, 13 May 2013 17:52:07 +0300
Message-ID: <1368456727-1830-1-git-send-email-andrei.varvara@freescale.com>
References: <n>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <Kim.Phillips@freescale.com>, <AFLEMING@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:17637
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314Ab3EMOwN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 May 2013 10:52:13 -0400
Received: from mail137-ch1 (localhost [127.0.0.1])	by
 mail137-ch1-R.bigfish.com (Postfix) with ESMTP id CE981400523	for
 <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:52:11 +0000 (UTC)
Received: from CH1EHSMHS031.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.241])	by mail137-ch1.bigfish.com (Postfix) with ESMTP id
 8DC404A004B	for <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:52:10
 +0000 (UTC)
In-Reply-To: <n>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Perform 32-bit left shift of DEST and concatenate with
left 32 bits of SRC1. {DEST[31:0],SRC1[63:32]}

Signed-off-by: Andrei Varvara <andrei.varvara@freescale.com>
Acked-by: Mihai Serb <mihai.serb@freescale.com>
Reviewed-by: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>
Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
---
 drivers/crypto/caam/desc_constr.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index fc4470a..08c95a1 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -295,14 +295,16 @@ append_cmd(desc, CMD_MATH | MATH_FUN_##op | MATH_DEST_##dest | \
 	APPEND_MATH(OR, desc, dest, src0, src1, len)
 #define append_math_xor(desc, dest, src0, src1, len) \
 	APPEND_MATH(XOR, desc, dest, src0, src1, len)
 #define append_math_lshift(desc, dest, src0, src1, len) \
 	APPEND_MATH(LSHIFT, desc, dest, src0, src1, len)
 #define append_math_rshift(desc, dest, src0, src1, len) \
 	APPEND_MATH(RSHIFT, desc, dest, src0, src1, len)
+#define append_math_ldshift(desc, dest, src0, src1, len) \
+	APPEND_MATH(SHLD, desc, dest, src0, src1, len)
 
 /* Exactly one source is IMM. Data is passed in as u32 value */
 #define APPEND_MATH_IMM_u32(op, desc, dest, src_0, src_1, data) \
 do { \
 	APPEND_MATH(op, desc, dest, src_0, src_1, CAAM_CMD_SZ); \
 	append_cmd(desc, data); \
 } while (0);
-- 
1.7.3.4

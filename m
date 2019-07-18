Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4E1C76195
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87A832184E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390857AbfGROqD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 10:46:03 -0400
Received: from inva020.nxp.com ([92.121.34.13]:49492 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390668AbfGROpm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 10:45:42 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C2BCD1A0359;
        Thu, 18 Jul 2019 16:45:39 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B58381A034D;
        Thu, 18 Jul 2019 16:45:39 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 61EBE205C7;
        Thu, 18 Jul 2019 16:45:39 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 08/14] crypto: caam - update rfc4106 sh desc to support zero length input
Date:   Thu, 18 Jul 2019 17:45:18 +0300
Message-Id: <1563461124-24641-9-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1563461124-24641-1-git-send-email-iuliana.prodan@nxp.com>
References: <1563461124-24641-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update share descriptor for rfc4106 to skip instructions in case
cryptlen is zero. If no instructions are jumped the DECO hangs and a
timeout error is thrown.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg_desc.c | 46 +++++++++++++++++++++++++-------------
 drivers/crypto/caam/caamalg_desc.h |  2 +-
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 7253183..99f419a 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -843,13 +843,16 @@ EXPORT_SYMBOL(cnstr_shdsc_gcm_decap);
  * @ivsize: initialization vector size
  * @icvsize: integrity check value (ICV) size (truncated or full)
  * @is_qi: true when called from caam/qi
+ *
+ * Input sequence: AAD | PTXT
+ * Output sequence: AAD | CTXT | ICV
+ * AAD length (assoclen), which includes the IV length, is available in Math3.
  */
 void cnstr_shdsc_rfc4106_encap(u32 * const desc, struct alginfo *cdata,
 			       unsigned int ivsize, unsigned int icvsize,
 			       const bool is_qi)
 {
-	u32 *key_jump_cmd;
-
+	u32 *key_jump_cmd, *zero_cryptlen_jump_cmd, *skip_instructions;
 	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
 	/* Skip key loading if it is loaded due to sharing */
@@ -890,26 +893,25 @@ void cnstr_shdsc_rfc4106_encap(u32 * const desc, struct alginfo *cdata,
 	}
 
 	append_math_sub_imm_u32(desc, VARSEQINLEN, REG3, IMM, ivsize);
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQOUTLEN, REG0, REG3, CAAM_CMD_SZ);
 
-	/* Read assoc data */
+	/* Skip AAD */
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
+
+	/* Read cryptlen and set this value into VARSEQOUTLEN */
+	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG3, CAAM_CMD_SZ);
+
+	/* If cryptlen is ZERO jump to AAD command */
+	zero_cryptlen_jump_cmd = append_jump(desc, JUMP_TEST_ALL |
+					    JUMP_COND_MATH_Z);
+
+	/* Read AAD data */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
 
 	/* Skip IV */
 	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_SKIP);
-
-	/* Will read cryptlen bytes */
-	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
-
-	/* Workaround for erratum A-005473 (simultaneous SEQ FIFO skips) */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_MSG);
-
-	/* Skip assoc data */
-	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
-
-	/* cryptlen = seqoutlen - assoclen */
-	append_math_sub(desc, VARSEQOUTLEN, VARSEQINLEN, REG0, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQINLEN, VARSEQOUTLEN, REG0, CAAM_CMD_SZ);
 
 	/* Write encrypted data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF);
@@ -918,6 +920,18 @@ void cnstr_shdsc_rfc4106_encap(u32 * const desc, struct alginfo *cdata,
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
 			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
 
+	/* Jump instructions to avoid double reading of AAD */
+	skip_instructions = append_jump(desc, JUMP_TEST_ALL);
+
+	/* There is no input data, cryptlen = 0 */
+	set_jump_tgt_here(desc, zero_cryptlen_jump_cmd);
+
+	/* Read AAD */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
+			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_LAST1);
+
+	set_jump_tgt_here(desc, skip_instructions);
+
 	/* Write ICV */
 	append_seq_store(desc, icvsize, LDST_CLASS_1_CCB |
 			 LDST_SRCDST_BYTE_CONTEXT);
diff --git a/drivers/crypto/caam/caamalg_desc.h b/drivers/crypto/caam/caamalg_desc.h
index da4a4ee..a49fb53 100644
--- a/drivers/crypto/caam/caamalg_desc.h
+++ b/drivers/crypto/caam/caamalg_desc.h
@@ -31,7 +31,7 @@
 #define DESC_QI_GCM_DEC_LEN		(DESC_GCM_DEC_LEN + 3 * CAAM_CMD_SZ)
 
 #define DESC_RFC4106_BASE		(3 * CAAM_CMD_SZ)
-#define DESC_RFC4106_ENC_LEN		(DESC_RFC4106_BASE + 13 * CAAM_CMD_SZ)
+#define DESC_RFC4106_ENC_LEN		(DESC_RFC4106_BASE + 15 * CAAM_CMD_SZ)
 #define DESC_RFC4106_DEC_LEN		(DESC_RFC4106_BASE + 13 * CAAM_CMD_SZ)
 #define DESC_QI_RFC4106_ENC_LEN		(DESC_RFC4106_ENC_LEN + 5 * CAAM_CMD_SZ)
 #define DESC_QI_RFC4106_DEC_LEN		(DESC_RFC4106_DEC_LEN + 5 * CAAM_CMD_SZ)
-- 
2.1.0


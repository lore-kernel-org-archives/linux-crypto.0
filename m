Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957A7C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 05:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C44B206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 05:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfG3FtM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 01:49:12 -0400
Received: from inva020.nxp.com ([92.121.34.13]:39036 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfG3FtL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 01:49:11 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 493D81A0593;
        Tue, 30 Jul 2019 07:49:09 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3C6BA1A014D;
        Tue, 30 Jul 2019 07:49:09 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D4135204D6;
        Tue, 30 Jul 2019 07:49:08 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam - fix concurrency issue in givencrypt descriptor
Date:   Tue, 30 Jul 2019 08:48:33 +0300
Message-Id: <20190730054833.24192-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

IV transfer from ofifo to class2 (set up at [29][30]) is not guaranteed
to be scheduled before the data transfer from ofifo to external memory
(set up at [38]:

[29] 10FA0004           ld: ind-nfifo (len=4) imm
[30] 81F00010               <nfifo_entry: ofifo->class2 type=msg len=16>
[31] 14820004           ld: ccb2-datasz len=4 offs=0 imm
[32] 00000010               data:0x00000010
[33] 8210010D    operation: cls1-op aes cbc init-final enc
[34] A8080B04         math: (seqin + math0)->vseqout len=4
[35] 28000010    seqfifold: skip len=16
[36] A8080A04         math: (seqin + math0)->vseqin len=4
[37] 2F1E0000    seqfifold: both msg1->2-last2-last1 len=vseqinsz
[38] 69300000   seqfifostr: msg len=vseqoutsz
[39] 5C20000C      seqstr: ccb2 ctx len=12 offs=0

If ofifo -> external memory transfer happens first, DECO will hang
(issuing a Watchdog Timeout error, if WDOG is enabled) waiting for
data availability in ofifo for the ofifo -> c2 ififo transfer.

Make sure IV transfer happens first by waiting for all CAAM internal
transfers to end before starting payload transfer.

New descriptor with jump command inserted at [37]:

[..]
[36] A8080A04         math: (seqin + math0)->vseqin len=4
[37] A1000401         jump: jsl1 all-match[!nfifopend] offset=[01] local->[38]
[38] 2F1E0000    seqfifold: both msg1->2-last2-last1 len=vseqinsz
[39] 69300000   seqfifostr: msg len=vseqoutsz
[40] 5C20000C      seqstr: ccb2 ctx len=12 offs=0

[Note: the issue is present in the descriptor from the very beginning
(cf. Fixes tag). However I've marked it v4.19+ since it's the oldest
maintained kernel that the patch applies clean against.]

Cc: <stable@vger.kernel.org> # v4.19+
Fixes: 1acebad3d8db8 ("crypto: caam - faster aead implementation")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_desc.c | 9 +++++++++
 drivers/crypto/caam/caamalg_desc.h | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 72531837571e..28ecef7a481c 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -503,6 +503,7 @@ void cnstr_shdsc_aead_givencap(u32 * const desc, struct alginfo *cdata,
 			       const bool is_qi, int era)
 {
 	u32 geniv, moveiv;
+	u32 *wait_cmd;
 
 	/* Note: Context registers are saved. */
 	init_sh_desc_key_aead(desc, cdata, adata, is_rfc3686, nonce, era);
@@ -598,6 +599,14 @@ void cnstr_shdsc_aead_givencap(u32 * const desc, struct alginfo *cdata,
 
 	/* Will read cryptlen */
 	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+
+	/*
+	 * Wait for IV transfer (ofifo -> class2) to finish before starting
+	 * ciphertext transfer (ofifo -> external memory).
+	 */
+	wait_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL | JUMP_COND_NIFP);
+	set_jump_tgt_here(desc, wait_cmd);
+
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_BOTH | KEY_VLF |
 			     FIFOLD_TYPE_MSG1OUT2 | FIFOLD_TYPE_LASTBOTH);
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF);
diff --git a/drivers/crypto/caam/caamalg_desc.h b/drivers/crypto/caam/caamalg_desc.h
index da4a4ee60c80..706007624d82 100644
--- a/drivers/crypto/caam/caamalg_desc.h
+++ b/drivers/crypto/caam/caamalg_desc.h
@@ -12,7 +12,7 @@
 #define DESC_AEAD_BASE			(4 * CAAM_CMD_SZ)
 #define DESC_AEAD_ENC_LEN		(DESC_AEAD_BASE + 11 * CAAM_CMD_SZ)
 #define DESC_AEAD_DEC_LEN		(DESC_AEAD_BASE + 15 * CAAM_CMD_SZ)
-#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 7 * CAAM_CMD_SZ)
+#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 8 * CAAM_CMD_SZ)
 #define DESC_QI_AEAD_ENC_LEN		(DESC_AEAD_ENC_LEN + 3 * CAAM_CMD_SZ)
 #define DESC_QI_AEAD_DEC_LEN		(DESC_AEAD_DEC_LEN + 3 * CAAM_CMD_SZ)
 #define DESC_QI_AEAD_GIVENC_LEN		(DESC_AEAD_GIVENC_LEN + 3 * CAAM_CMD_SZ)
-- 
2.17.1


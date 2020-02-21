Return-Path: <SRS0=BixN=4J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00BFC35640
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 08:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1398206DB
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 08:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgBUHwU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 02:52:20 -0500
Received: from inva020.nxp.com ([92.121.34.13]:51524 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729892AbgBUHwS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 02:52:18 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C36801A6F35;
        Fri, 21 Feb 2020 08:52:17 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B70431A6F4B;
        Fri, 21 Feb 2020 08:52:17 +0100 (CET)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 70998202D2;
        Fri, 21 Feb 2020 08:52:17 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam/qi2 - fix chacha20 data size error
Date:   Fri, 21 Feb 2020 09:52:01 +0200
Message-Id: <20200221075201.5725-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

HW generates a Data Size error for chacha20 requests that are not
a multiple of 64B, since algorithm state (AS) does not have
the FINAL bit set.

Since updating req->iv (for chaining) is not required,
modify skcipher descriptors to set the FINAL bit for chacha20.

[Note that for skcipher decryption we know that ctx1_iv_off is 0,
which allows for an optimization by not checking algorithm type,
since append_dec_op1() sets FINAL bit for all algorithms except AES.]

Also drop the descriptor operations that save the IV.
However, in order to keep code logic simple, things like
S/G tables generation etc. are not touched.

Cc: <stable@vger.kernel.org> # v5.3+
Fixes: 334d37c9e263 ("crypto: caam - update IV using HW support")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_desc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index aa9ccca67045..372d3d4ed6c5 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1379,6 +1379,8 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
 				const u32 ctx1_iv_off)
 {
 	u32 *key_jump_cmd;
+	bool is_chacha20 = ((cdata->algtype & OP_ALG_ALGSEL_MASK) ==
+			    OP_ALG_ALGSEL_CHACHA20);
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
 	/* Skip if already shared */
@@ -1417,14 +1419,15 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
 				      LDST_OFFSET_SHIFT));
 
 	/* Load operation */
-	append_operation(desc, cdata->algtype | OP_ALG_AS_INIT |
-			 OP_ALG_ENCRYPT);
+	if (is_chacha20)
+		options |= OP_ALG_AS_FINALIZE;
+	append_operation(desc, options);
 
 	/* Perform operation */
 	skcipher_append_src_dst(desc);
 
 	/* Store IV */
-	if (ivsize)
+	if (!is_chacha20 && ivsize)
 		append_seq_store(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
 				 LDST_CLASS_1_CCB | (ctx1_iv_off <<
 				 LDST_OFFSET_SHIFT));
@@ -1451,6 +1454,9 @@ void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
 				const u32 ctx1_iv_off)
 {
 	u32 *key_jump_cmd;
+	u32 options = cdata->algtype | OP_ALG_AS_INIT | OP_ALG_ENCRYPT;
+	bool is_chacha20 = ((cdata->algtype & OP_ALG_ALGSEL_MASK) ==
+			    OP_ALG_ALGSEL_CHACHA20);
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
 	/* Skip if already shared */
@@ -1499,7 +1505,7 @@ void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
 	skcipher_append_src_dst(desc);
 
 	/* Store IV */
-	if (ivsize)
+	if (!is_chacha20 && ivsize)
 		append_seq_store(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
 				 LDST_CLASS_1_CCB | (ctx1_iv_off <<
 				 LDST_OFFSET_SHIFT));
-- 
2.17.1


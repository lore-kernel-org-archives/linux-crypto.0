Return-Path: <SRS0=uro5=SS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27064C10F13
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 16:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E5220821
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 16:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbfDPQ10 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:27:26 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41030 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfDPQ10 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Apr 2019 12:27:26 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1B8F91A009A;
        Tue, 16 Apr 2019 18:27:24 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0E6DD1A005B;
        Tue, 16 Apr 2019 18:27:24 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id BE47E205F3;
        Tue, 16 Apr 2019 18:27:23 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam/jr - update gcm detection logic
Date:   Tue, 16 Apr 2019 19:27:12 +0300
Message-Id: <20190416162712.31106-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

GCM detection logic has to change for two reasons:
-some CAAM instantiations with Era < 10, even though they have AES LP,
they now support GCM mode
-Era 10 upwards, there is a dedicated bit in AESA_VERSION[AESA_MISC]
field for GCM support

For Era 9 and earlier, all AES accelerator versions support GCM,
except for AES LP (CHAVID_LS[AESVID]=3) with revision CRNR[AESRN] < 8.

For Era 10 and later, bit 9 of the AESA_VERSION register should be used
to detect GCM support in AES accelerator.

Note: caam/qi and caam/qi2 are drivers for QI (Queue Interface), which
is used in DPAA-based SoCs; for now, we rely on CAAM having an AES HP
and this AES accelerator having support for GCM.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 18 +++++++++++-------
 drivers/crypto/caam/regs.h    |  3 +++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 579578498deb..72e978146061 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3460,7 +3460,7 @@ static int __init caam_algapi_init(void)
 	u32 aes_vid, aes_inst, des_inst, md_vid, md_inst, ccha_inst, ptha_inst;
 	u32 arc4_inst;
 	unsigned int md_limit = SHA512_DIGEST_SIZE;
-	bool registered = false;
+	bool registered = false, gcm_support;
 
 	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
 	if (!dev_node) {
@@ -3493,7 +3493,7 @@ static int __init caam_algapi_init(void)
 	 * First, detect presence and attributes of DES, AES, and MD blocks.
 	 */
 	if (priv->era < 10) {
-		u32 cha_vid, cha_inst;
+		u32 cha_vid, cha_inst, aes_rn;
 
 		cha_vid = rd_reg32(&priv->ctrl->perfmon.cha_id_ls);
 		aes_vid = cha_vid & CHA_ID_LS_AES_MASK;
@@ -3508,6 +3508,10 @@ static int __init caam_algapi_init(void)
 			    CHA_ID_LS_ARC4_SHIFT;
 		ccha_inst = 0;
 		ptha_inst = 0;
+
+		aes_rn = rd_reg32(&priv->ctrl->perfmon.cha_rev_ls) &
+			 CHA_ID_LS_AES_MASK;
+		gcm_support = !(aes_vid == CHA_VER_VID_AES_LP && aes_rn < 8);
 	} else {
 		u32 aesa, mdha;
 
@@ -3523,6 +3527,8 @@ static int __init caam_algapi_init(void)
 		ccha_inst = rd_reg32(&priv->ctrl->vreg.ccha) & CHA_VER_NUM_MASK;
 		ptha_inst = rd_reg32(&priv->ctrl->vreg.ptha) & CHA_VER_NUM_MASK;
 		arc4_inst = rd_reg32(&priv->ctrl->vreg.afha) & CHA_VER_NUM_MASK;
+
+		gcm_support = aesa & CHA_VER_MISC_AES_GCM;
 	}
 
 	/* If MD is present, limit digest size based on LP256 */
@@ -3595,11 +3601,9 @@ static int __init caam_algapi_init(void)
 		if (c2_alg_sel == OP_ALG_ALGSEL_POLY1305 && !ptha_inst)
 			continue;
 
-		/*
-		 * Check support for AES algorithms not available
-		 * on LP devices.
-		 */
-		if (aes_vid  == CHA_VER_VID_AES_LP && alg_aai == OP_ALG_AAI_GCM)
+		/* Skip GCM algorithms if not supported by device */
+		if (c1_alg_sel == OP_ALG_ALGSEL_AES &&
+		    alg_aai == OP_ALG_AAI_GCM && !gcm_support)
 			continue;
 
 		/*
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 3cd0822ea819..8591914d5c51 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -253,6 +253,9 @@ struct version_regs {
 #define CHA_VER_VID_SHIFT	24
 #define CHA_VER_VID_MASK	(0xffull << CHA_VER_VID_SHIFT)
 
+/* CHA Miscellaneous Information - AESA_MISC specific */
+#define CHA_VER_MISC_AES_GCM	BIT(1 + CHA_VER_MISC_SHIFT)
+
 /*
  * caam_perfmon - Performance Monitor/Secure Memory Status/
  *                CAAM Global Status/Component Version IDs
-- 
2.17.1


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B58C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Sep 2021 22:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D71061165
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Sep 2021 22:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhIOWEl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Sep 2021 18:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhIOWEl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Sep 2021 18:04:41 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1026CC061574;
        Wed, 15 Sep 2021 15:03:18 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id DF2C9221E6;
        Thu, 16 Sep 2021 00:03:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1631743395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=az8ndf9MuAUOd7G3bxNNPg7S0H1T8m0GdpfKSF24zG0=;
        b=pU+t95OFg9TKtLKsgqlIndLPplLY04i72BEsJQF3dliY5F5qSAEdQe89xRcVPYf2mFkgBS
        9ayA8vFolAflqrfZClenOG95fhxeE74x1WxKSEiMQpKRPZv3Y2BB/689jI9TjrMO/19vXp
        4AtVRA1Ej1hxVvjAdTi48UpOkxp3MOU=
From:   Michael Walle <michael@walle.cc>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH] crypto: caam: disable pkc for non-E SoCs
Date:   Thu, 16 Sep 2021 00:03:07 +0200
Message-Id: <20210915220307.3079917-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On newer CAAM versions, not all accelerators are disabled if the SoC is
a non-E variant. While the driver checks most of the modules for
availability, there is one - PKHA - which sticks out. On non-E variants
it is still reported as available, that is the number of instances is
non-zero, but it has limited functionality. In particular it doesn't
support encryption and decryption, but just signing and verifying. This
is indicated by a bit in the PKHA_MISC field. Take this bit into account
if we are checking for availablitly.

This will the following error:
[    8.167817] caam_jr 8020000.jr: 20000b0f: CCB: desc idx 11: : Invalid CHA selected.

Tested on an NXP LS1028A (non-E) SoC.

Fixes: d239b10d4ceb ("crypto: caam - add register map changes cf. Era 10")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/crypto/caam/caampkc.c | 19 +++++++++++++++----
 drivers/crypto/caam/regs.h    |  3 +++
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index e313233ec6de..bf6275ffc4aa 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -1153,16 +1153,27 @@ static struct caam_akcipher_alg caam_rsa = {
 int caam_pkc_init(struct device *ctrldev)
 {
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
-	u32 pk_inst;
+	u32 pk_inst, pkha;
 	int err;
 	init_done = false;
 
 	/* Determine public key hardware accelerator presence. */
-	if (priv->era < 10)
+	if (priv->era < 10) {
 		pk_inst = (rd_reg32(&priv->ctrl->perfmon.cha_num_ls) &
 			   CHA_ID_LS_PK_MASK) >> CHA_ID_LS_PK_SHIFT;
-	else
-		pk_inst = rd_reg32(&priv->ctrl->vreg.pkha) & CHA_VER_NUM_MASK;
+	} else {
+		pkha = rd_reg32(&priv->ctrl->vreg.pkha);
+		pk_inst = pkha & CHA_VER_NUM_MASK;
+
+		/*
+		 * Newer CAAMs support partially disabled functionality. If this is the
+		 * case, the number is non-zero, but this bit is set to indicate that
+		 * no encryption or decryption is supported. Only signing and verifying
+		 * is supported.
+		 */
+		if (pkha & CHA_VER_MISC_PKHA_NO_CRYPT)
+			pk_inst = 0;
+	}
 
 	/* Do not register algorithms if PKHA is not present. */
 	if (!pk_inst)
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index af61f3a2c0d4..3738625c0250 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -322,6 +322,9 @@ struct version_regs {
 /* CHA Miscellaneous Information - AESA_MISC specific */
 #define CHA_VER_MISC_AES_GCM	BIT(1 + CHA_VER_MISC_SHIFT)
 
+/* CHA Miscellaneous Information - PKHA_MISC specific */
+#define CHA_VER_MISC_PKHA_NO_CRYPT	BIT(7 + CHA_VER_MISC_SHIFT)
+
 /*
  * caam_perfmon - Performance Monitor/Secure Memory Status/
  *                CAAM Global Status/Component Version IDs
-- 
2.30.2


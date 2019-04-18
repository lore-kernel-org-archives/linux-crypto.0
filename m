Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9943EC10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AB4B20674
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389146AbfDRNmZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:42:25 -0400
Received: from foss.arm.com ([217.140.101.70]:33778 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389270AbfDRNmY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:42:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6E5380D;
        Thu, 18 Apr 2019 06:42:23 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B2363F5AF;
        Thu, 18 Apr 2019 06:42:22 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 32/35] crypto: ccree: remove cc7x3 obsoleted AXIM configs
Date:   Thu, 18 Apr 2019 16:39:07 +0300
Message-Id: <20190418133913.9122-33-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ofir Drang <ofir.drang@arm.com>

AXIM configuration register modified in cc7x3 and no longer
includes AXI interrupt masking fields.

Signed-off-by: Ofir Drang <ofir.drang@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_driver.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index a28548192211..902f196d4be1 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -193,11 +193,14 @@ int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe)
 	unsigned int val, cache_params;
 	struct device *dev = drvdata_to_dev(drvdata);
 
-	/* Unmask all AXI interrupt sources AXI_CFG1 register */
-	val = cc_ioread(drvdata, CC_REG(AXIM_CFG));
-	cc_iowrite(drvdata, CC_REG(AXIM_CFG), val & ~CC_AXI_IRQ_MASK);
-	dev_dbg(dev, "AXIM_CFG=0x%08X\n",
-		cc_ioread(drvdata, CC_REG(AXIM_CFG)));
+	/* Unmask all AXI interrupt sources AXI_CFG1 register   */
+	/* AXI interrupt config are obsoleted startign at cc7x3 */
+	if (drvdata->hw_rev <= CC_HW_REV_712) {
+		val = cc_ioread(drvdata, CC_REG(AXIM_CFG));
+		cc_iowrite(drvdata, CC_REG(AXIM_CFG), val & ~CC_AXI_IRQ_MASK);
+		dev_dbg(dev, "AXIM_CFG=0x%08X\n",
+			cc_ioread(drvdata, CC_REG(AXIM_CFG)));
+	}
 
 	/* Clear all pending interrupts */
 	val = cc_ioread(drvdata, CC_REG(HOST_IRR));
-- 
2.21.0


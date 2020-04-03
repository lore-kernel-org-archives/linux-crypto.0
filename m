Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B20C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 11:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36E932082F
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 11:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgDCLN0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 07:13:26 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:3380 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbgDCLN0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 07:13:26 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.11]) by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee25e871a3c10c-7828c; Fri, 03 Apr 2020 19:13:01 +0800 (CST)
X-RM-TRANSID: 2ee25e871a3c10c-7828c
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.3.208.73])
        by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee65e871a3afd0-e407c;
        Fri, 03 Apr 2020 19:13:01 +0800 (CST)
X-RM-TRANSID: 2ee65e871a3afd0-e407c
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     narmstrong@baylibre.com, clabbe@baylibre.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH v5]crypto: amlogic - Delete duplicate dev_err in meson_crypto_probe()
Date:   Fri,  3 Apr 2020 19:14:29 +0800
Message-Id: <20200403111429.11876-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When something goes wrong, platform_get_irq() will print an error message,
so in order to avoid the situation of repeat output，we should remove
dev_err here.

Changes from v4:
 - rewrite the code, because the code in v4 is wrong, sorry.

Changes form v3:
 - fix the theme writing error.

Changes from v2:
 - modify the theme format and content description.
 - reformat the patch, it's the wrong way to resubmit a new patch that
   should be modified on top of the original. The original piece is:
   https://lore.kernel.org/patchwork/patch/1219611/

Changes from v1:
 - the title has changed, because the description is not very detailed.
 - the code has been modified, because it needs to match the theme.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 9d4ead2f7..411857fad 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -253,10 +253,8 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	mc->irqs = devm_kcalloc(mc->dev, MAXFLOW, sizeof(int), GFP_KERNEL);
 	for (i = 0; i < MAXFLOW; i++) {
 		mc->irqs[i] = platform_get_irq(pdev, i);
-		if (mc->irqs[i] < 0) {
-			dev_err(mc->dev, "Cannot get IRQ for flow %d\n", i);
+		if (mc->irqs[i] < 0)
 			return mc->irqs[i];
-		}
 
 		err = devm_request_irq(&pdev->dev, mc->irqs[i], meson_irq_handler, 0,
 				       "gxl-crypto", mc);
-- 
2.20.1.windows.1




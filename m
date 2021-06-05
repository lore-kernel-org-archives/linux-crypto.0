Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FE1C47082
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 12:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2D2A613AA
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 12:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhFEM5w (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Jun 2021 08:57:52 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:56233 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhFEM5w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Jun 2021 08:57:52 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d78 with ME
        id DQvx2500221Fzsu03QvxbN; Sat, 05 Jun 2021 14:56:02 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 05 Jun 2021 14:56:02 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        gregkh@linuxfoundation.org, acostag.ubuntu@gmail.com,
        lee.jones@linaro.org, Jampala.Srikanth@cavium.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: cavium/nitrox - Fix an erro rhandling path in 'nitrox_probe()'
Date:   Sat,  5 Jun 2021 14:55:56 +0200
Message-Id: <26f71d3925541924bfda1dca9114a48db5ffafe4.1622897629.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If an error occurs after a successful 'ioremap()' call, it must be undone
by a corresponding 'iounmap()' call, as already done in the remove
function.
Ass a 'pf_sw_fail' label in the error handling path and add the missing
'iounmap()'.

While at it, also add a 'flr_fail' label in the error handling path and use
it to avoid some code duplication.

Fixes: 14fa93cdcd9b ("crypto: cavium - Add support for CNN55XX adapters.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/cavium/nitrox/nitrox_main.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index 144d554bd44d..96bc7b5c6532 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -424,8 +424,7 @@ static int nitrox_probe(struct pci_dev *pdev,
 	err = nitrox_device_flr(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "FLR failed\n");
-		pci_disable_device(pdev);
-		return err;
+		goto flr_fail;
 	}
 
 	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
@@ -434,16 +433,13 @@ static int nitrox_probe(struct pci_dev *pdev,
 		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "DMA configuration failed\n");
-			pci_disable_device(pdev);
-			return err;
+			goto flr_fail;
 		}
 	}
 
 	err = pci_request_mem_regions(pdev, nitrox_driver_name);
-	if (err) {
-		pci_disable_device(pdev);
-		return err;
-	}
+	if (err)
+		goto flr_fail;
 	pci_set_master(pdev);
 
 	ndev = kzalloc(sizeof(*ndev), GFP_KERNEL);
@@ -479,7 +475,7 @@ static int nitrox_probe(struct pci_dev *pdev,
 
 	err = nitrox_pf_sw_init(ndev);
 	if (err)
-		goto ioremap_err;
+		goto pf_sw_fail;
 
 	err = nitrox_pf_hw_init(ndev);
 	if (err)
@@ -509,12 +505,15 @@ static int nitrox_probe(struct pci_dev *pdev,
 	smp_mb__after_atomic();
 pf_hw_fail:
 	nitrox_pf_sw_cleanup(ndev);
+pf_sw_fail:
+	iounmap(ndev->bar_addr);
 ioremap_err:
 	nitrox_remove_from_devlist(ndev);
 	kfree(ndev);
 	pci_set_drvdata(pdev, NULL);
 ndev_fail:
 	pci_release_mem_regions(pdev);
+flr_fail:
 	pci_disable_device(pdev);
 	return err;
 }
-- 
2.30.2


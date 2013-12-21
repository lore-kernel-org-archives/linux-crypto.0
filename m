From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 2/3] crypto: ccp-pci: Remove redundant dev_set_drvdata
Date: Sat, 21 Dec 2013 12:52:29 +0530
Message-ID: <1387610550-13493-2-git-send-email-sachin.kamat@linaro.org>
References: <1387610550-13493-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, thomas.lendacky@amd.com,
	sachin.kamat@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45039 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3LUHZu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 21 Dec 2013 02:25:50 -0500
Received: by mail-pa0-f49.google.com with SMTP id kx10so3510206pab.8
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2013 23:25:50 -0800 (PST)
In-Reply-To: <1387610550-13493-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Driver core sets it to NULL upon probe failure or release.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/crypto/ccp/ccp-pci.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index 1fbeaf1856a8..f08c16d370cd 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -247,7 +247,6 @@ e_bar0:
 
 e_device:
 	pci_disable_device(pdev);
-	dev_set_drvdata(dev, NULL);
 
 e_regions:
 	pci_release_regions(pdev);
@@ -273,7 +272,6 @@ static void ccp_pci_remove(struct pci_dev *pdev)
 	pci_iounmap(pdev, ccp->io_map);
 
 	pci_disable_device(pdev);
-	dev_set_drvdata(dev, NULL);
 
 	pci_release_regions(pdev);
 
-- 
1.7.9.5

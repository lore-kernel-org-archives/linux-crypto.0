From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: qat: fix spelling mistake: "runing" -> "running"
Date: Mon, 26 Jun 2017 20:41:03 +0100
Message-ID: <20170626194103.5755-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Conor McLoughlin <conor.mcloughlin@intel.com>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45766 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbdFZTlM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2017 15:41:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in dev_info message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/qat/qat_common/adf_aer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index d3e25c37dc33..da8a2d3b5e9a 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -208,7 +208,7 @@ static pci_ers_result_t adf_slot_reset(struct pci_dev *pdev)
 static void adf_resume(struct pci_dev *pdev)
 {
 	dev_info(&pdev->dev, "Acceleration driver reset completed\n");
-	dev_info(&pdev->dev, "Device is up and runnig\n");
+	dev_info(&pdev->dev, "Device is up and running\n");
 }
 
 static const struct pci_error_handlers adf_err_handler = {
-- 
2.11.0

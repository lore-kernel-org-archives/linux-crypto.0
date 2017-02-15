From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH] crypto: cavium/cpt: Fix couple of static checker errors
Date: Wed, 15 Feb 2017 12:42:19 +0000
Message-ID: <1487162539-29269-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        George Cherian <george.cherian@cavium.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        dan.carpenter@oracle.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0061.outbound.protection.outlook.com ([104.47.32.61]:35457
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751478AbdBOMmn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 07:42:43 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix the following smatch errors
cptvf_reqmanager.c:333 do_post_process() warn: variable dereferenced
before check 'cptvf'
cptvf_main.c:825 cptvf_remove() error: we previously assumed 'cptvf'
could be null

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: George Cherian <george.cherian@cavium.com>
---
 drivers/crypto/cavium/cpt/cptvf_main.c       | 4 +++-
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index aac2966..e50872e 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -815,8 +815,10 @@ static void cptvf_remove(struct pci_dev *pdev)
 {
 	struct cpt_vf *cptvf = pci_get_drvdata(pdev);
 
-	if (!cptvf)
+	if (!cptvf) {
 		dev_err(&pdev->dev, "Invalid CPT-VF device\n");
+		return;
+	}
 
 	/* Convey DOWN to PF */
 	if (cptvf_send_vf_down(cptvf)) {
diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
index 7f57f30..169e662 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -330,8 +330,8 @@ void do_post_process(struct cpt_vf *cptvf, struct cpt_info_buffer *info)
 {
 	struct pci_dev *pdev = cptvf->pdev;
 
-	if (!info || !cptvf) {
-		dev_err(&pdev->dev, "Input params are incorrect for post processing\n");
+	if (!info) {
+		dev_err(&pdev->dev, "incorrect cpt_info_buffer for post processing\n");
 		return;
 	}
 
-- 
2.1.4

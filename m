From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH cryptodev-2.6 2/4] crypto: cavium/nitrox - use pcie_flr instead of duplicating it
Date: Sat, 29 Sep 2018 13:49:08 +0530
Message-ID: <20180929081910.17652-2-Jampala.Srikanth@cavium.com>
References: <20180929081910.17652-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgadam@cavium.com, Jampala.Srikanth@cavium.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180929081910.17652-1-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

check the flr capability using pcie_has_flr() and do the flr.

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Reviewed-by: Gadam Sreerama <sgadam@cavium.com>
---
 drivers/crypto/cavium/nitrox/nitrox_main.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index 5bd97cff1405..13436ca98cb5 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -217,7 +217,7 @@ void nitrox_put_device(struct nitrox_device *ndev)
 	smp_mb__after_atomic();
 }
 
-static int nitrox_reset_device(struct pci_dev *pdev)
+static int nitrox_device_flr(struct pci_dev *pdev)
 {
 	int pos = 0;
 
@@ -227,15 +227,10 @@ static int nitrox_reset_device(struct pci_dev *pdev)
 		return -ENOMEM;
 	}
 
-	pos = pci_pcie_cap(pdev);
-	if (!pos)
-		return -ENOTTY;
+	/* check flr support */
+	if (pcie_has_flr(pdev))
+		pcie_flr(pdev);
 
-	if (!pci_wait_for_pending_transaction(pdev))
-		dev_err(&pdev->dev, "waiting for pending transaction\n");
-
-	pcie_capability_set_word(pdev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
-	msleep(100);
 	pci_restore_state(pdev);
 
 	return 0;
@@ -345,7 +340,7 @@ static int nitrox_probe(struct pci_dev *pdev,
 		return err;
 
 	/* do FLR */
-	err = nitrox_reset_device(pdev);
+	err = nitrox_device_flr(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "FLR failed\n");
 		pci_disable_device(pdev);
-- 
2.17.1

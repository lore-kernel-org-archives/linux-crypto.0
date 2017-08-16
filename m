From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: cavium/nitrox - Fix an error handling path in 'nitrox_probe()'
Date: Wed, 16 Aug 2017 07:16:06 +0200
Message-ID: <20170816051606.14950-1-christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        Jampala.Srikanth@cavium.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

'err' is known to be 0 at this point.
If 'kzalloc()' fails, returns -ENOMEM instead of 0 which means success.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/cavium/nitrox/nitrox_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index 9ccefb9b7232..fee7cb2ce747 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -513,8 +513,10 @@ static int nitrox_probe(struct pci_dev *pdev,
 	pci_set_master(pdev);
 
 	ndev = kzalloc(sizeof(*ndev), GFP_KERNEL);
-	if (!ndev)
+	if (!ndev) {
+		err = -ENOMEM;
 		goto ndev_fail;
+	}
 
 	pci_set_drvdata(pdev, ndev);
 	ndev->pdev = pdev;
-- 
2.11.0

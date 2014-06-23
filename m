From: Joe Perches <joe@perches.com>
Subject: [PATCH 04/22] crypto: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:32 -0700
Message-ID: <774846b64fca6521637a4a4dec7161daa3df19fe.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/crypto/hifn_795x.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 12fea3e..8d2a772 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2617,14 +2617,13 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	}
 
-	dev->desc_virt = pci_alloc_consistent(pdev, sizeof(struct hifn_dma),
-			&dev->desc_dma);
+	dev->desc_virt = pci_zalloc_consistent(pdev, sizeof(struct hifn_dma),
+					       &dev->desc_dma);
 	if (!dev->desc_virt) {
 		dprintk("Failed to allocate descriptor rings.\n");
 		err = -ENOMEM;
 		goto err_out_unmap_bars;
 	}
-	memset(dev->desc_virt, 0, sizeof(struct hifn_dma));
 
 	dev->pdev = pdev;
 	dev->irq = pdev->irq;
-- 
1.8.1.2.459.gbcd45b4.dirty

From: Peter Huewe <PeterHuewe@gmx.de>
Subject: [PATCH 16/25] crypto: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 21:00:41 +0200
Message-ID: <201007152100.42276.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Roel Kluin <roel.kluin@gmail.com>,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	Chihau Chau <chihau@gmail.com>,
	linux-geode@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:28644 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934314Ab0GOTAu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jul 2010 15:00:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Peter Huewe <peterhuewe@gmx.de>

This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
.subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
PCI_VDEVICE macro, and thus improves readability.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/crypto/geode-aes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 09389dd..219d09c 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -573,7 +573,7 @@ geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 }
 
 static struct pci_device_id geode_aes_tbl[] = {
-	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LX_AES, PCI_ANY_ID, PCI_ANY_ID} ,
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_LX_AES), } ,
 	{ 0, }
 };
 
-- 
1.7.1

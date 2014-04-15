From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH] crypto/ccp: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Tue, 15 Apr 2014 09:54:31 +0200
Message-ID: <1397548471-24441-1-git-send-email-agordeev@redhat.com>
Cc: Alexander Gordeev <agordeev@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/crypto/ccp/ccp-pci.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index 93319f9..0d74623 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -48,12 +48,11 @@ static int ccp_get_msix_irqs(struct ccp_device *ccp)
 	for (v = 0; v < ARRAY_SIZE(msix_entry); v++)
 		msix_entry[v].entry = v;
 
-	while ((ret = pci_enable_msix(pdev, msix_entry, v)) > 0)
-		v = ret;
-	if (ret)
+	ret = pci_enable_msix_range(pdev, msix_entry, 1, v);
+	if (ret < 0)
 		return ret;
 
-	ccp_pci->msix_count = v;
+	ccp_pci->msix_count = ret;
 	for (v = 0; v < ccp_pci->msix_count; v++) {
 		/* Set the interrupt names and request the irqs */
 		snprintf(ccp_pci->msix[v].name, name_len, "ccp-%u", v);
-- 
1.7.7.6

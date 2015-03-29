From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 14/86] crypto/ccp: use uapi/linux/pci_ids.h directly
Date: Sun, 29 Mar 2015 15:38:44 +0200
Message-ID: <1427635734-24786-15-git-send-email-mst@redhat.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbbC2Niy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Mar 2015 09:38:54 -0400
Content-Disposition: inline
In-Reply-To: <1427635734-24786-1-git-send-email-mst@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Header moved from linux/pci_ids.h to uapi/linux/pci_ids.h,
use the new header directly so we can drop
the wrapper in include/linux/pci_ids.h.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/crypto/ccp/ccp-ops.c | 2 +-
 drivers/crypto/ccp/ccp-pci.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 8729364..fd5491d 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/pci_ids.h>
+#include <uapi/linux/pci_ids.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index 7f89c94..c09d0eb 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -14,7 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/pci.h>
-#include <linux/pci_ids.h>
+#include <uapi/linux/pci_ids.h>
 #include <linux/dma-mapping.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
-- 
MST

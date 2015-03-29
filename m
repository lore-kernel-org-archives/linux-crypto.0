From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 15/86] crypto/geode: use uapi/linux/pci_ids.h directly
Date: Sun, 29 Mar 2015 15:38:48 +0200
Message-ID: <1427635734-24786-16-git-send-email-mst@redhat.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-geode@lists.infradead.org, linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427635734-24786-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Header moved from linux/pci_ids.h to uapi/linux/pci_ids.h,
use the new header directly so we can drop
the wrapper in include/linux/pci_ids.h.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/crypto/geode-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index fe538e5..5775d1a 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -9,7 +9,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/pci_ids.h>
+#include <uapi/linux/pci_ids.h>
 #include <linux/crypto.h>
 #include <linux/spinlock.h>
 #include <crypto/algapi.h>
-- 
MST

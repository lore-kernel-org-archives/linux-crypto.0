From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 1/6] crypto/ccp: drop linux/pci dependencies
Date: Mon, 30 Mar 2015 12:59:23 +0200
Message-ID: <1427712964-16155-2-git-send-email-mst@redhat.com>
References: <1427712964-16155-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427712964-16155-1-git-send-email-mst@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

pci code is in ccp-pci.c, don't include pci
headers from ccp/ccp-ops.c.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/crypto/ccp/ccp-ops.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 8729364..3da1140 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -12,8 +12,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/pci_ids.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-- 
MST

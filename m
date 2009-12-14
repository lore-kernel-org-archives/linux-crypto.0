From: Vishnu Suresh <Vishnu@freescale.com>
Subject: [PATCH v0] Crypto: Talitos: re-initialize async_tx descriptors
Date: Mon, 14 Dec 2009 19:03:22 +0530
Message-ID: <1260797602-7476-1-git-send-email-Vishnu@freescale.com>
Cc: B04825@freescale.com, R58472@freescale.com,
	Vishnu Suresh <Vishnu@freescale.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, dan.j.williams@intel.com,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The async_tx descriptors contains dangling pointers.
Hence, re-initialize them to NULL before use.

Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
---
o. Rebased to linux-next as of 20091214

 drivers/crypto/talitos.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 87f06be..9e261c6 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -952,6 +952,9 @@ static struct dma_async_tx_descriptor * talitos_prep_dma_xor(
 		return NULL;
 	}
 	dma_async_tx_descriptor_init(&new->async_tx, &xor_chan->common);
+	new->async_tx.parent = NULL;
+	new->async_tx.next = NULL;
+
 
 	desc = &new->hwdesc;
 	/* Set destination: Last pointer pair */
-- 
1.6.4.2


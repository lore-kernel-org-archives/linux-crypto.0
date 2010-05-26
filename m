From: David Miller <davem@davemloft.net>
Subject: [PATCH 2/7] n2_crypto: Fix MAU kmem_cache name.
Date: Tue, 25 May 2010 17:43:34 -0700 (PDT)
Message-ID: <20100525.174334.48502566.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37719
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155Ab0EZAnX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 20:43:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Both the CWQ and MAU caches unintentionally had that same name.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/crypto/n2_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 1a5b1e7..5613b8a 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1449,7 +1449,7 @@ static int queue_cache_init(void)
 {
 	if (!queue_cache[HV_NCS_QTYPE_MAU - 1])
 		queue_cache[HV_NCS_QTYPE_MAU - 1] =
-			kmem_cache_create("cwq_queue",
+			kmem_cache_create("mau_queue",
 					  (MAU_NUM_ENTRIES *
 					   MAU_ENTRY_SIZE),
 					  MAU_ENTRY_SIZE, 0, NULL);
-- 
1.7.0.4

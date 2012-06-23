From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 03/20] crypto: caam - fix start index for Protocol shared descriptors
Date: Fri, 22 Jun 2012 19:42:37 -0500
Message-ID: <1340412174-1784-4-git-send-email-kim.phillips@freescale.com>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Yashpal Dutta <yashpal.dutta@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:29954
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756689Ab2FWApF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:45:05 -0400
In-Reply-To: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Yashpal Dutta <yashpal.dutta@freescale.com>

In case of protocol acceleration descriptors, Shared descriptor header must
carry size of header length + PDB length in words which will be skipped by
DECO while processing descriptor to provide first command word offset

Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/desc_constr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 348b882..0d31e27 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -1,7 +1,7 @@
 /*
  * caam descriptor construction helper functions
  *
- * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ * Copyright 2008-2012 Freescale Semiconductor, Inc.
  */
 
 #include "desc.h"
@@ -64,7 +64,7 @@ static inline void init_sh_desc_pdb(u32 *desc, u32 options, size_t pdb_bytes)
 {
 	u32 pdb_len = pdb_bytes / CAAM_CMD_SZ + 1;
 
-	init_sh_desc(desc, ((pdb_len << HDR_START_IDX_SHIFT) + pdb_len) |
+	init_sh_desc(desc, (((pdb_len + 1) << HDR_START_IDX_SHIFT) + pdb_len) |
 		     options);
 }
 
-- 
1.7.11.1

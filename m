From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 04/20] crypto: caam - fix descriptor length adjustments for protocol descriptors
Date: Fri, 22 Jun 2012 19:42:38 -0500
Message-ID: <1340412174-1784-5-git-send-email-kim.phillips@freescale.com>
References: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>,
	Yashpal Dutta <yashpal.dutta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:44714
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756735Ab2FWApG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2012 20:45:06 -0400
In-Reply-To: <1340412174-1784-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

init_desc, by always ORing with 1 for the descriptor header inclusion
into the descriptor length, and init_sh_desc_pdb, by always specifying
the descriptor length modification for the PDB via options, would not
allow for odd length PDBs to be embedded in the constructed descriptor
length.  Fix this by simply changing the OR to an addition.

also round-up pdb_bytes to the next SEC command unit size, to
allow for, e.g., optional packet header bytes that aren't a
multiple of CAAM_CMD_SZ.

Reported-by: Radu-Andrei BULIE <radu.bulie@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Cc: Yashpal Dutta <yashpal.dutta@freescale.com>
---
 drivers/crypto/caam/desc_constr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 0d31e27..8e1056f 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -51,7 +51,7 @@ static inline void *sh_desc_pdb(u32 *desc)
 
 static inline void init_desc(u32 *desc, u32 options)
 {
-	*desc = options | HDR_ONE | 1;
+	*desc = (options | HDR_ONE) + 1;
 }
 
 static inline void init_sh_desc(u32 *desc, u32 options)
@@ -62,7 +62,7 @@ static inline void init_sh_desc(u32 *desc, u32 options)
 
 static inline void init_sh_desc_pdb(u32 *desc, u32 options, size_t pdb_bytes)
 {
-	u32 pdb_len = pdb_bytes / CAAM_CMD_SZ + 1;
+	u32 pdb_len = (pdb_bytes + CAAM_CMD_SZ - 1) / CAAM_CMD_SZ;
 
 	init_sh_desc(desc, (((pdb_len + 1) << HDR_START_IDX_SHIFT) + pdb_len) |
 		     options);
-- 
1.7.11.1

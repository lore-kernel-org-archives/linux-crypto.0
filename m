From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v3 01/10] crypto/chcr:Fix memory corruption
Date: Tue, 29 Nov 2016 19:00:34 +0530
Message-ID: <272b95acbd25c0c4bb6d70f88d650b88d5815d4a.1480413079.git.harsh@chelsio.com>
References: <cover.1480413079.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>, Jitendra Lulla <JLULLA@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        hariprasad@chelsio.com, jlulla@chelsio.com, atul.gupta@chelsio.com,
        yeshaswi@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:43926 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933265AbcK2NbP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 08:31:15 -0500
In-Reply-To: <cover.1480413079.git.harsh@chelsio.com>
In-Reply-To: <cover.1480413079.git.harsh@chelsio.com>
References: <cover.1480413079.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix memory corruption done by  *((u32 *)dec_key + k)
 operation.

Signed-off-by: Jitendra Lulla <JLULLA@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.h b/drivers/crypto/chelsio/chcr_algo.h
index ec64fbc..199b0bb 100644
--- a/drivers/crypto/chelsio/chcr_algo.h
+++ b/drivers/crypto/chelsio/chcr_algo.h
@@ -422,7 +422,7 @@ static inline void get_aes_decrypt_key(unsigned char *dec_key,
 {
 	u32 temp;
 	u32 w_ring[MAX_NK];
-	int i, j, k = 0;
+	int i, j, k;
 	u8  nr, nk;
 
 	switch (keylength) {
@@ -460,6 +460,7 @@ static inline void get_aes_decrypt_key(unsigned char *dec_key,
 		temp = w_ring[i % nk];
 		i++;
 	}
+	i--;
 	for (k = 0, j = i % nk; k < nk; k++) {
 		*((u32 *)dec_key + k) = htonl(w_ring[j]);
 		j--;
-- 
1.8.2.3

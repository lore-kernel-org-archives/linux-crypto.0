From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [crypto] chcr: fix a type cast error
Date: Tue,  5 Dec 2017 15:59:22 +0530
Message-ID: <1512469762-3757-1-git-send-email-atul.gupta@chelsio.com>
Cc: dan.carpenter@oracle.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:1280 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753253AbdLEK3m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 05:29:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

fix a type cast error for queue descriptor

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ipsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index f90f991..a413156 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -428,7 +428,7 @@ inline void *copy_key_cpltx_pktxt(struct sk_buff *skb,
 			memcpy(pos, sa_entry->key, left);
 			memcpy(q->q.desc, sa_entry->key + left,
 			       key_len - left);
-			pos = q->q.desc + (key_len - left);
+			pos = (u8 *)q->q.desc + (key_len - left);
 		}
 	}
 	/* Copy CPL TX PKT XT */
-- 
1.8.3.1

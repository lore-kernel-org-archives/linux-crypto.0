From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [PATCH v2 5/5] crypto: chtls: free beyond end rspq_skb_cache
Date: Sun, 27 May 2018 21:15:22 +0530
Message-ID: <1527435922-6727-6-git-send-email-atul.gupta@chelsio.com>
References: <1527435922-6727-1-git-send-email-atul.gupta@chelsio.com>
Cc: gustavo@embeddedor.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, davem@davemloft.net, atul.gupta@chelsio.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1527435922-6727-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 273afd3..9b07f91 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -250,7 +250,7 @@ static void *chtls_uld_add(const struct cxgb4_lld_info *info)
 
 	return cdev;
 out_rspq_skb:
-	for (j = 0; j <= i; j++)
+	for (j = 0; j < i; j++)
 		kfree_skb(cdev->rspq_skb_cache[j]);
 	kfree_skb(cdev->askb);
 out_skb:
-- 
1.8.3.1

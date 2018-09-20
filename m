From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH] crypto : chtls: remove redundant null pointer check before kfree_skb
Date: Thu, 20 Sep 2018 17:57:16 +0800
Message-ID: <1537437436-43088-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <harsh@chelsio.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

kfree_skb has taken the null pointer into account. hence it is safe
to remove the redundant null pointer check before kfree_skb.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c   | 3 +--
 drivers/crypto/chelsio/chtls/chtls_main.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 0997e16..fd2ae1e 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -234,8 +234,7 @@ static void chtls_send_reset(struct sock *sk, int mode, struct sk_buff *skb)
 
 	return;
 out:
-	if (skb)
-		kfree_skb(skb);
+	kfree_skb(skb);
 }
 
 static void release_tcp_port(struct sock *sk)
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index f59b044..f472c51 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -272,8 +272,7 @@ static void chtls_free_uld(struct chtls_dev *cdev)
 	for (i = 0; i < (1 << RSPQ_HASH_BITS); i++)
 		kfree_skb(cdev->rspq_skb_cache[i]);
 	kfree(cdev->lldi);
-	if (cdev->askb)
-		kfree_skb(cdev->askb);
+	kfree_skb(cdev->askb);
 	kfree(cdev);
 }
 
-- 
1.7.12.4

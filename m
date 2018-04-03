From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto : chtls_cm - Fix potential NULL pointer dereferences
Date: Tue, 3 Apr 2018 15:09:12 -0500
Message-ID: <20180403200912.GA25976@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Atul Gupta <atul.gupta@chelsio.com>,
        Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add null checks on lookup_tid() return value in order to prevent
null pointer dereferences.

Addresses-Coverity-ID: 1467422 ("Dereference null return value")
Addresses-Coverity-ID: 1467443 ("Dereference null return value")
Addresses-Coverity-ID: 1467445 ("Dereference null return value")
Addresses-Coverity-ID: 1467449 ("Dereference null return value")
Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 82a473a..23c43b8 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1537,6 +1537,10 @@ static int chtls_rx_data(struct chtls_dev *cdev, struct sk_buff *skb)
 	struct sock *sk;
 
 	sk = lookup_tid(cdev->tids, hwtid);
+	if (unlikely(!sk)) {
+		pr_err("can't find conn. for hwtid %u.\n", hwtid);
+		return -EINVAL;
+	}
 	skb_dst_set(skb, NULL);
 	process_cpl_msg(chtls_recv_data, sk, skb);
 	return 0;
@@ -1585,6 +1589,10 @@ static int chtls_rx_pdu(struct chtls_dev *cdev, struct sk_buff *skb)
 	struct sock *sk;
 
 	sk = lookup_tid(cdev->tids, hwtid);
+	if (unlikely(!sk)) {
+		pr_err("can't find conn. for hwtid %u.\n", hwtid);
+		return -EINVAL;
+	}
 	skb_dst_set(skb, NULL);
 	process_cpl_msg(chtls_recv_pdu, sk, skb);
 	return 0;
@@ -1646,6 +1654,10 @@ static int chtls_rx_cmp(struct chtls_dev *cdev, struct sk_buff *skb)
 	struct sock *sk;
 
 	sk = lookup_tid(cdev->tids, hwtid);
+	if (unlikely(!sk)) {
+		pr_err("can't find conn. for hwtid %u.\n", hwtid);
+		return -EINVAL;
+	}
 	skb_dst_set(skb, NULL);
 	process_cpl_msg(chtls_rx_hdr, sk, skb);
 
@@ -2105,6 +2117,10 @@ static int chtls_wr_ack(struct chtls_dev *cdev, struct sk_buff *skb)
 	struct sock *sk;
 
 	sk = lookup_tid(cdev->tids, hwtid);
+	if (unlikely(!sk)) {
+		pr_err("can't find conn. for hwtid %u.\n", hwtid);
+		return -EINVAL;
+	}
 	process_cpl_msg(chtls_rx_ack, sk, skb);
 
 	return 0;
-- 
2.7.4

From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [PATCH v2 3/5] crypto: chtls: dereference null variable
Date: Sun, 27 May 2018 21:15:20 +0530
Message-ID: <1527435922-6727-4-git-send-email-atul.gupta@chelsio.com>
References: <1527435922-6727-1-git-send-email-atul.gupta@chelsio.com>
Cc: gustavo@embeddedor.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, davem@davemloft.net, atul.gupta@chelsio.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1527435922-6727-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

skb dereferenced before check in sendpage

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 7aa5d90..8cfc27b 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1230,9 +1230,8 @@ int chtls_sendpage(struct sock *sk, struct page *page,
 		struct sk_buff *skb = skb_peek_tail(&csk->txq);
 		int copy, i;
 
-		copy = mss - skb->len;
 		if (!skb || (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND) ||
-		    copy <= 0) {
+		    (copy = mss - skb->len) <= 0) {
 new_buf:
 			if (!csk_mem_free(cdev, sk))
 				goto wait_for_sndbuf;
-- 
1.8.3.1

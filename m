From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [PATCH v2 4/5] crypto: chtls: kbuild warnings
Date: Sun, 27 May 2018 21:15:21 +0530
Message-ID: <1527435922-6727-5-git-send-email-atul.gupta@chelsio.com>
References: <1527435922-6727-1-git-send-email-atul.gupta@chelsio.com>
Cc: gustavo@embeddedor.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, davem@davemloft.net, atul.gupta@chelsio.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1527435922-6727-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

- unindented continue
- check for null page
- signed return

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_io.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 8cfc27b..51fc682 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -907,11 +907,11 @@ static int chtls_skb_copy_to_page_nocache(struct sock *sk,
 }
 
 /* Read TLS header to find content type and data length */
-static u16 tls_header_read(struct tls_hdr *thdr, struct iov_iter *from)
+static int tls_header_read(struct tls_hdr *thdr, struct iov_iter *from)
 {
 	if (copy_from_iter(thdr, sizeof(*thdr), from) != sizeof(*thdr))
 		return -EFAULT;
-	return (__force u16)cpu_to_be16(thdr->length);
+	return (__force int)cpu_to_be16(thdr->length);
 }
 
 static int csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
@@ -1083,9 +1083,10 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			int off = TCP_OFF(sk);
 			bool merge;
 
-			if (page)
-				pg_size <<= compound_order(page);
+			if (!page)
+				goto wait_for_memory;
 
+			pg_size <<= compound_order(page);
 			if (off < pg_size &&
 			    skb_can_coalesce(skb, i, page, off)) {
 				merge = 1;
@@ -1492,7 +1493,7 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			break;
 		chtls_cleanup_rbuf(sk, copied);
 		sk_wait_data(sk, &timeo, NULL);
-			continue;
+		continue;
 found_ok_skb:
 		if (!skb->len) {
 			skb_dst_set(skb, NULL);
-- 
1.8.3.1

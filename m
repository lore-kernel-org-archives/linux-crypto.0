Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:1341 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbeLKKU7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 05:20:59 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Cc: dt@chelsio.com, atul.gupta@chelsio.com
Subject: [tls 4/5] crypto/chelsio/chtls: macro correction in tx path
Date: Tue, 11 Dec 2018 02:20:40 -0800
Message-Id: <20181211102040.3665-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

corrected macro used in tx path. removed redundant hdrlen
and check for !page in chtls_sendmsg

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_io.c     | 20 ++++++++------------
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |  3 +++
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index afebbd8..18f553f 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -397,7 +397,7 @@ static void tls_tx_data_wr(struct sock *sk, struct sk_buff *skb,
 
 	req_wr->lsodisable_to_flags =
 			htonl(TX_ULP_MODE_V(ULP_MODE_TLS) |
-			      FW_OFLD_TX_DATA_WR_URGENT_V(skb_urgent(skb)) |
+			      TX_URG_V(skb_urgent(skb)) |
 			      T6_TX_FORCE_F | wr_ulp_mode_force |
 			      TX_SHOVE_V((!csk_flag(sk, CSK_TX_MORE_DATA)) &&
 					 skb_queue_empty(&csk->txq)));
@@ -534,10 +534,9 @@ static void make_tx_data_wr(struct sock *sk, struct sk_buff *skb,
 				FW_OFLD_TX_DATA_WR_SHOVE_F);
 
 	req->tunnel_to_proxy = htonl(wr_ulp_mode_force |
-			FW_OFLD_TX_DATA_WR_URGENT_V(skb_urgent(skb)) |
-			FW_OFLD_TX_DATA_WR_SHOVE_V((!csk_flag
-					(sk, CSK_TX_MORE_DATA)) &&
-					 skb_queue_empty(&csk->txq)));
+			TX_URG_V(skb_urgent(skb)) |
+			TX_SHOVE_V((!csk_flag(sk, CSK_TX_MORE_DATA)) &&
+				   skb_queue_empty(&csk->txq)));
 	req->plen = htonl(len);
 }
 
@@ -995,7 +994,6 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	int mss, flags, err;
 	int recordsz = 0;
 	int copied = 0;
-	int hdrlen = 0;
 	long timeo;
 
 	lock_sock(sk);
@@ -1032,7 +1030,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 
 			recordsz = tls_header_read(&hdr, &msg->msg_iter);
 			size -= TLS_HEADER_LENGTH;
-			hdrlen += TLS_HEADER_LENGTH;
+			copied += TLS_HEADER_LENGTH;
 			csk->tlshws.txleft = recordsz;
 			csk->tlshws.type = hdr.type;
 			if (skb)
@@ -1083,10 +1081,8 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			int off = TCP_OFF(sk);
 			bool merge;
 
-			if (!page)
-				goto wait_for_memory;
-
-			pg_size <<= compound_order(page);
+			if (page)
+				pg_size <<= compound_order(page);
 			if (off < pg_size &&
 			    skb_can_coalesce(skb, i, page, off)) {
 				merge = 1;
@@ -1187,7 +1183,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		chtls_tcp_push(sk, flags);
 done:
 	release_sock(sk);
-	return copied + hdrlen;
+	return copied;
 do_fault:
 	if (!skb->len) {
 		__skb_unlink(skb, &csk->txq);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index f152da1..c62a0c8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -1453,6 +1453,9 @@ struct cpl_tx_data {
 #define T6_TX_FORCE_V(x)	((x) << T6_TX_FORCE_S)
 #define T6_TX_FORCE_F		T6_TX_FORCE_V(1U)
 
+#define TX_URG_S    16
+#define TX_URG_V(x) ((x) << TX_URG_S)
+
 #define TX_SHOVE_S    14
 #define TX_SHOVE_V(x) ((x) << TX_SHOVE_S)
 
-- 
1.8.3.1

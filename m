From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/7] [SCSI] iscsi: Use crypto_hash interface instead of crypto_digest
Date: Sat, 02 Sep 2006 21:06:39 +1000
Message-ID: <E1GJTKh-0001Fa-00@gondolin.me.apana.org.au>
References: <20060902110520.GA4690@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40976 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1751050AbWIBLGg
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Sep 2006 07:06:36 -0400
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Michal Ludvig <michal@logix.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[SCSI] iscsi: Use crypto_hash interface instead of crypto_digest

This patch converts ISCSI to use the new crypto_hash interface instead
of crypto_digest.  It's a fairly straightforward substitution.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/scsi/iscsi_tcp.c |  134 +++++++++++++++++++++++++----------------------
 drivers/scsi/iscsi_tcp.h |    9 +--
 2 files changed, 78 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -26,6 +26,7 @@
  *	Zhenyu Wang
  */
 
+#include <linux/err.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/inet.h>
@@ -110,8 +111,11 @@ iscsi_hdr_digest(struct iscsi_conn *conn
 		 u8* crc)
 {
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct hash_desc desc;
 
-	crypto_digest_digest(tcp_conn->tx_tfm, &buf->sg, 1, crc);
+	desc.tfm = tcp_conn->tx_tfm;
+	desc.flags = 0;
+	crypto_hash_digest(&desc, &buf->sg, buf->sg.length, crc);
 	buf->sg.length += sizeof(uint32_t);
 }
 
@@ -446,11 +450,14 @@ iscsi_tcp_hdr_recv(struct iscsi_conn *co
 	}
 
 	if (conn->hdrdgst_en) {
+		struct hash_desc desc;
 		struct scatterlist sg;
 
 		sg_init_one(&sg, (u8 *)hdr,
 			    sizeof(struct iscsi_hdr) + ahslen);
-		crypto_digest_digest(tcp_conn->rx_tfm, &sg, 1, (u8 *)&cdgst);
+		desc.tfm = tcp_conn->rx_tfm;
+		desc.flags = 0;
+		crypto_hash_digest(&desc, &sg, sg.length, (u8 *)&cdgst);
 		rdgst = *(uint32_t*)((char*)hdr + sizeof(struct iscsi_hdr) +
 				     ahslen);
 		if (cdgst != rdgst) {
@@ -650,7 +657,7 @@ partial_sg_digest_update(struct iscsi_tc
 	memcpy(&temp, sg, sizeof(struct scatterlist));
 	temp.offset = offset;
 	temp.length = length;
-	crypto_digest_update(tcp_conn->data_rx_tfm, &temp, 1);
+	crypto_hash_update(&tcp_conn->data_rx_hash, &temp, length);
 }
 
 static void
@@ -659,7 +666,7 @@ iscsi_recv_digest_update(struct iscsi_tc
 	struct scatterlist tmp;
 
 	sg_init_one(&tmp, buf, len);
-	crypto_digest_update(tcp_conn->data_rx_tfm, &tmp, 1);
+	crypto_hash_update(&tcp_conn->data_rx_hash, &tmp, len);
 }
 
 static int iscsi_scsi_data_in(struct iscsi_conn *conn)
@@ -713,9 +720,9 @@ static int iscsi_scsi_data_in(struct isc
 		if (!rc) {
 			if (conn->datadgst_en) {
 				if (!offset)
-					crypto_digest_update(
-							tcp_conn->data_rx_tfm,
-							&sg[i], 1);
+					crypto_hash_update(
+							&tcp_conn->data_rx_hash,
+							&sg[i], sg[i].length);
 				else
 					partial_sg_digest_update(tcp_conn,
 							&sg[i],
@@ -854,8 +861,7 @@ more:
 		rc = iscsi_tcp_hdr_recv(conn);
 		if (!rc && tcp_conn->in.datalen) {
 			if (conn->datadgst_en) {
-				BUG_ON(!tcp_conn->data_rx_tfm);
-				crypto_digest_init(tcp_conn->data_rx_tfm);
+				crypto_hash_init(&tcp_conn->data_rx_hash);
 			}
 			tcp_conn->in_progress = IN_PROGRESS_DATA_RECV;
 		} else if (rc) {
@@ -908,11 +914,11 @@ more:
 					  tcp_conn->in.padding);
 				memset(pad, 0, tcp_conn->in.padding);
 				sg_init_one(&sg, pad, tcp_conn->in.padding);
-				crypto_digest_update(tcp_conn->data_rx_tfm,
-						     &sg, 1);
+				crypto_hash_update(&tcp_conn->data_rx_hash,
+						   &sg, sg.length);
 			}
-			crypto_digest_final(tcp_conn->data_rx_tfm,
-					    (u8 *) & tcp_conn->in.datadgst);
+			crypto_hash_final(&tcp_conn->data_rx_hash,
+					  (u8 *)&tcp_conn->in.datadgst);
 			debug_tcp("rx digest 0x%x\n", tcp_conn->in.datadgst);
 			tcp_conn->in_progress = IN_PROGRESS_DDIGEST_RECV;
 		} else
@@ -1159,8 +1165,7 @@ iscsi_data_digest_init(struct iscsi_tcp_
 {
 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
 
-	BUG_ON(!tcp_conn->data_tx_tfm);
-	crypto_digest_init(tcp_conn->data_tx_tfm);
+	crypto_hash_init(&tcp_conn->data_tx_hash);
 	tcp_ctask->digest_count = 4;
 }
 
@@ -1174,7 +1179,7 @@ iscsi_digest_final_send(struct iscsi_con
 	int sent = 0;
 
 	if (final)
-		crypto_digest_final(tcp_conn->data_tx_tfm, (u8*)digest);
+		crypto_hash_final(&tcp_conn->data_tx_hash, (u8 *)digest);
 
 	iscsi_buf_init_iov(buf, (char*)digest, 4);
 	rc = iscsi_sendpage(conn, buf, &tcp_ctask->digest_count, &sent);
@@ -1469,16 +1474,17 @@ handle_xmstate_imm_data(struct iscsi_con
 		if (rc) {
 			tcp_ctask->xmstate |= XMSTATE_IMM_DATA;
 			if (conn->datadgst_en) {
-				crypto_digest_final(tcp_conn->data_tx_tfm,
-						(u8*)&tcp_ctask->immdigest);
+				crypto_hash_final(&tcp_conn->data_tx_hash,
+						  (u8 *)&tcp_ctask->immdigest);
 				debug_tcp("tx imm sendpage fail 0x%x\n",
 					  tcp_ctask->datadigest);
 			}
 			return rc;
 		}
 		if (conn->datadgst_en)
-			crypto_digest_update(tcp_conn->data_tx_tfm,
-					     &tcp_ctask->sendbuf.sg, 1);
+			crypto_hash_update(&tcp_conn->data_tx_hash,
+					   &tcp_ctask->sendbuf.sg,
+					   tcp_ctask->sendbuf.sg.length);
 
 		if (!ctask->imm_count)
 			break;
@@ -1555,8 +1561,8 @@ handle_xmstate_uns_data(struct iscsi_con
 			tcp_ctask->xmstate |= XMSTATE_UNS_DATA;
 			/* will continue with this ctask later.. */
 			if (conn->datadgst_en) {
-				crypto_digest_final(tcp_conn->data_tx_tfm,
-						(u8 *)&dtask->digest);
+				crypto_hash_final(&tcp_conn->data_tx_hash,
+						  (u8 *)&dtask->digest);
 				debug_tcp("tx uns data fail 0x%x\n",
 					  dtask->digest);
 			}
@@ -1571,8 +1577,9 @@ handle_xmstate_uns_data(struct iscsi_con
 		 * so pass it
 		 */
 		if (conn->datadgst_en && tcp_ctask->sent - start > 0)
-			crypto_digest_update(tcp_conn->data_tx_tfm,
-					     &tcp_ctask->sendbuf.sg, 1);
+			crypto_hash_update(&tcp_conn->data_tx_hash,
+					   &tcp_ctask->sendbuf.sg,
+					   tcp_ctask->sendbuf.sg.length);
 
 		if (!ctask->data_count)
 			break;
@@ -1646,7 +1653,7 @@ solicit_again:
 		tcp_ctask->xmstate |= XMSTATE_SOL_DATA;
 		/* will continue with this ctask later.. */
 		if (conn->datadgst_en) {
-			crypto_digest_final(tcp_conn->data_tx_tfm,
+			crypto_hash_final(&tcp_conn->data_tx_hash,
 					  (u8 *)&dtask->digest);
 			debug_tcp("r2t data send fail 0x%x\n", dtask->digest);
 		}
@@ -1655,8 +1662,8 @@ solicit_again:
 
 	BUG_ON(r2t->data_count < 0);
 	if (conn->datadgst_en)
-		crypto_digest_update(tcp_conn->data_tx_tfm, &r2t->sendbuf.sg,
-				     1);
+		crypto_hash_update(&tcp_conn->data_tx_hash, &r2t->sendbuf.sg,
+				   r2t->sendbuf.sg.length);
 
 	if (r2t->data_count) {
 		BUG_ON(ctask->sc->use_sg == 0);
@@ -1744,8 +1751,9 @@ handle_xmstate_w_pad(struct iscsi_conn *
 	}
 
 	if (conn->datadgst_en) {
-		crypto_digest_update(tcp_conn->data_tx_tfm,
-				     &tcp_ctask->sendbuf.sg, 1);
+		crypto_hash_update(&tcp_conn->data_tx_hash,
+				   &tcp_ctask->sendbuf.sg,
+				   tcp_ctask->sendbuf.sg.length);
 		/* imm data? */
 		if (!dtask) {
 			rc = iscsi_digest_final_send(conn, ctask,
@@ -1935,13 +1943,13 @@ iscsi_tcp_conn_destroy(struct iscsi_cls_
 	/* now free tcp_conn */
 	if (digest) {
 		if (tcp_conn->tx_tfm)
-			crypto_free_tfm(tcp_conn->tx_tfm);
+			crypto_free_hash(tcp_conn->tx_tfm);
 		if (tcp_conn->rx_tfm)
-			crypto_free_tfm(tcp_conn->rx_tfm);
-		if (tcp_conn->data_tx_tfm)
-			crypto_free_tfm(tcp_conn->data_tx_tfm);
-		if (tcp_conn->data_rx_tfm)
-			crypto_free_tfm(tcp_conn->data_rx_tfm);
+			crypto_free_hash(tcp_conn->rx_tfm);
+		if (tcp_conn->data_tx_hash.tfm)
+			crypto_free_hash(tcp_conn->data_tx_hash.tfm);
+		if (tcp_conn->data_rx_hash.tfm)
+			crypto_free_hash(tcp_conn->data_rx_hash.tfm);
 	}
 
 	/* free conn->data, size = MaxRecvDataSegmentLength */
@@ -2177,44 +2185,48 @@ iscsi_conn_set_param(struct iscsi_cls_co
 		if (conn->hdrdgst_en) {
 			tcp_conn->hdr_size += sizeof(__u32);
 			if (!tcp_conn->tx_tfm)
-				tcp_conn->tx_tfm = crypto_alloc_tfm("crc32c",
-								    0);
-			if (!tcp_conn->tx_tfm)
-				return -ENOMEM;
+				tcp_conn->tx_tfm =
+					crypto_alloc_hash("crc32c", 0,
+							  CRYPTO_ALG_ASYNC);
+			if (IS_ERR(tcp_conn->tx_tfm))
+				return PTR_ERR(tcp_conn->tx_tfm);
 			if (!tcp_conn->rx_tfm)
-				tcp_conn->rx_tfm = crypto_alloc_tfm("crc32c",
-								    0);
-			if (!tcp_conn->rx_tfm) {
-				crypto_free_tfm(tcp_conn->tx_tfm);
-				return -ENOMEM;
+				tcp_conn->rx_tfm =
+					crypto_alloc_hash("crc32c", 0,
+							  CRYPTO_ALG_ASYNC);
+			if (IS_ERR(tcp_conn->rx_tfm)) {
+				crypto_free_hash(tcp_conn->tx_tfm);
+				return PTR_ERR(tcp_conn->rx_tfm);
 			}
 		} else {
 			if (tcp_conn->tx_tfm)
-				crypto_free_tfm(tcp_conn->tx_tfm);
+				crypto_free_hash(tcp_conn->tx_tfm);
 			if (tcp_conn->rx_tfm)
-				crypto_free_tfm(tcp_conn->rx_tfm);
+				crypto_free_hash(tcp_conn->rx_tfm);
 		}
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
 		if (conn->datadgst_en) {
-			if (!tcp_conn->data_tx_tfm)
-				tcp_conn->data_tx_tfm =
-				    crypto_alloc_tfm("crc32c", 0);
-			if (!tcp_conn->data_tx_tfm)
-				return -ENOMEM;
-			if (!tcp_conn->data_rx_tfm)
-				tcp_conn->data_rx_tfm =
-				    crypto_alloc_tfm("crc32c", 0);
-			if (!tcp_conn->data_rx_tfm) {
-				crypto_free_tfm(tcp_conn->data_tx_tfm);
-				return -ENOMEM;
+			if (!tcp_conn->data_tx_hash.tfm)
+				tcp_conn->data_tx_hash.tfm =
+				    crypto_alloc_hash("crc32c", 0,
+						      CRYPTO_ALG_ASYNC);
+			if (IS_ERR(tcp_conn->data_tx_hash.tfm))
+				return PTR_ERR(tcp_conn->data_tx_hash.tfm);
+			if (!tcp_conn->data_rx_hash.tfm)
+				tcp_conn->data_rx_hash.tfm =
+				    crypto_alloc_hash("crc32c", 0,
+						      CRYPTO_ALG_ASYNC);
+			if (IS_ERR(tcp_conn->data_rx_hash.tfm)) {
+				crypto_free_hash(tcp_conn->data_tx_hash.tfm);
+				return PTR_ERR(tcp_conn->data_rx_hash.tfm);
 			}
 		} else {
-			if (tcp_conn->data_tx_tfm)
-				crypto_free_tfm(tcp_conn->data_tx_tfm);
-			if (tcp_conn->data_rx_tfm)
-				crypto_free_tfm(tcp_conn->data_rx_tfm);
+			if (tcp_conn->data_tx_hash.tfm)
+				crypto_free_hash(tcp_conn->data_tx_hash.tfm);
+			if (tcp_conn->data_rx_hash.tfm)
+				crypto_free_hash(tcp_conn->data_rx_hash.tfm);
 		}
 		tcp_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_conn->sock->ops->sendpage;
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -51,6 +51,7 @@
 #define ISCSI_SG_TABLESIZE		SG_ALL
 #define ISCSI_TCP_MAX_CMD_LEN		16
 
+struct crypto_hash;
 struct socket;
 
 /* Socket connection recieve helper */
@@ -86,8 +87,8 @@ struct iscsi_tcp_conn {
 	/* iSCSI connection-wide sequencing */
 	int			hdr_size;	/* PDU header size */
 
-	struct crypto_tfm	*rx_tfm;	/* CRC32C (Rx) */
-	struct crypto_tfm	*data_rx_tfm;	/* CRC32C (Rx) for data */
+	struct crypto_hash	*rx_tfm;	/* CRC32C (Rx) */
+	struct hash_desc	data_rx_hash;	/* CRC32C (Rx) for data */
 
 	/* control data */
 	struct iscsi_tcp_recv	in;		/* TCP receive context */
@@ -99,8 +100,8 @@ struct iscsi_tcp_conn {
 	void			(*old_write_space)(struct sock *);
 
 	/* xmit */
-	struct crypto_tfm	*tx_tfm;	/* CRC32C (Tx) */
-	struct crypto_tfm	*data_tx_tfm;	/* CRC32C (Tx) for data */
+	struct crypto_hash	*tx_tfm;	/* CRC32C (Tx) */
+	struct hash_desc	data_tx_hash;	/* CRC32C (Tx) for data */
 
 	/* MIB custom statistics */
 	uint32_t		sendpage_failures_cnt;

-- 
VGER BF report: H 0.0915141

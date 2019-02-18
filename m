Return-Path: <SRS0=tWXW=QZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F80C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Feb 2019 10:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69E212146F
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Feb 2019 10:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfBRKEw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:04:52 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:35924 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbfBRKEw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Feb 2019 05:04:52 -0500
Received: from beagle7.asicdesigners.com (beagle7.asicdesigners.com [10.192.192.157])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x1IA4iUT004118;
        Mon, 18 Feb 2019 02:04:45 -0800
From:   Atul Gupta <atul.gupta@chelsio.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        dt@chelsio.com
Cc:     atul.gupta@chelsio.com
Subject: [PATCH] crypto/chelsio/chcr: Fixed Traffic Stall
Date:   Mon, 18 Feb 2019 02:04:37 -0800
Message-Id: <20190218100437.13077-1-atul.gupta@chelsio.com>
X-Mailer: git-send-email 2.20.0.rc2.7.g965798d
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixed Traffic Stall caused by
- Subcommands except last should have more bit set
- For esn case subcommand is required for linear skb only
- Also Optimized is_eth_imm usage

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ipsec.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 0c826d0..2f60049 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -336,7 +336,8 @@ static inline int is_eth_imm(const struct sk_buff *skb,
 }
 
 static inline unsigned int calc_tx_sec_flits(const struct sk_buff *skb,
-					     struct ipsec_sa_entry *sa_entry)
+					     struct ipsec_sa_entry *sa_entry,
+					     bool *immediate)
 {
 	unsigned int kctx_len;
 	unsigned int flits;
@@ -354,8 +355,10 @@ static inline unsigned int calc_tx_sec_flits(const struct sk_buff *skb,
 	 * TX Packet header plus the skb data in the Work Request.
 	 */
 
-	if (hdrlen)
+	if (hdrlen) {
+		*immediate = true;
 		return DIV_ROUND_UP(skb->len + hdrlen, sizeof(__be64));
+	}
 
 	flits = sgl_len(skb_shinfo(skb)->nr_frags + 1);
 
@@ -418,7 +421,7 @@ inline void *copy_esn_pktxt(struct sk_buff *skb,
 	iv = skb_transport_header(skb) + sizeof(struct ip_esp_hdr);
 	memcpy(aadiv->iv, iv, 8);
 
-	if (is_eth_imm(skb, sa_entry)) {
+	if (is_eth_imm(skb, sa_entry) && !skb_is_nonlinear(skb)) {
 		sc_imm = (struct ulptx_idata *)(pos +
 			  (DIV_ROUND_UP(sizeof(struct chcr_ipsec_aadiv),
 					sizeof(__be64)) << 3));
@@ -531,15 +534,18 @@ inline void *chcr_crypto_wreq(struct sk_buff *skb,
 	struct adapter *adap = pi->adapter;
 	unsigned int ivsize = GCM_ESP_IV_SIZE;
 	struct chcr_ipsec_wr *wr;
+	bool immediate = false;
 	u16 immdatalen = 0;
 	unsigned int flits;
 	u32 ivinoffset;
 	u32 aadstart;
 	u32 aadstop;
 	u32 ciphstart;
+	u16 sc_more = 0;
 	u32 ivdrop = 0;
 	u32 esnlen = 0;
 	u32 wr_mid;
+	u16 ndesc;
 	int qidx = skb_get_queue_mapping(skb);
 	struct sge_eth_txq *q = &adap->sge.ethtxq[qidx + pi->first_qset];
 	unsigned int kctx_len = sa_entry->kctx_len;
@@ -547,20 +553,24 @@ inline void *chcr_crypto_wreq(struct sk_buff *skb,
 
 	atomic_inc(&adap->chcr_stats.ipsec_cnt);
 
-	flits = calc_tx_sec_flits(skb, sa_entry);
+	flits = calc_tx_sec_flits(skb, sa_entry, &immediate);
+	ndesc = DIV_ROUND_UP(flits, 2);
 	if (sa_entry->esn)
 		ivdrop = 1;
 
-	if (is_eth_imm(skb, sa_entry))
+	if (immediate)
 		immdatalen = skb->len;
 
-	if (sa_entry->esn)
+	if (sa_entry->esn) {
 		esnlen = sizeof(struct chcr_ipsec_aadiv);
+		if (!skb_is_nonlinear(skb))
+			sc_more  = 1;
+	}
 
 	/* WR Header */
 	wr = (struct chcr_ipsec_wr *)pos;
 	wr->wreq.op_to_compl = htonl(FW_WR_OP_V(FW_ULPTX_WR));
-	wr_mid = FW_CRYPTO_LOOKASIDE_WR_LEN16_V(DIV_ROUND_UP(flits, 2));
+	wr_mid = FW_CRYPTO_LOOKASIDE_WR_LEN16_V(ndesc);
 
 	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
 		netif_tx_stop_queue(q->txq);
@@ -572,10 +582,10 @@ inline void *chcr_crypto_wreq(struct sk_buff *skb,
 
 	/* ULPTX */
 	wr->req.ulptx.cmd_dest = FILL_ULPTX_CMD_DEST(pi->port_id, qid);
-	wr->req.ulptx.len = htonl(DIV_ROUND_UP(flits, 2)  - 1);
+	wr->req.ulptx.len = htonl(ndesc - 1);
 
 	/* Sub-command */
-	wr->req.sc_imm.cmd_more = FILL_CMD_MORE(!immdatalen);
+	wr->req.sc_imm.cmd_more = FILL_CMD_MORE(!immdatalen || sc_more);
 	wr->req.sc_imm.len = cpu_to_be32(sizeof(struct cpl_tx_sec_pdu) +
 					 sizeof(wr->req.key_ctx) +
 					 kctx_len +
@@ -698,7 +708,7 @@ int chcr_ipsec_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	cxgb4_reclaim_completed_tx(adap, &q->q, true);
 
-	flits = calc_tx_sec_flits(skb, sa_entry);
+	flits = calc_tx_sec_flits(skb, sa_entry, &immediate);
 	ndesc = flits_to_desc(flits);
 	credits = txq_avail(&q->q) - ndesc;
 
@@ -711,9 +721,6 @@ int chcr_ipsec_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 	}
 
-	if (is_eth_imm(skb, sa_entry))
-		immediate = true;
-
 	if (!immediate &&
 	    unlikely(cxgb4_map_skb(adap->pdev_dev, skb, addr) < 0)) {
 		q->mapping_err++;
-- 
1.8.3.1


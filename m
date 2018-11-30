Return-Path: <SRS0=r27M=OJ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:47014 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbeK3UKt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Nov 2018 15:10:49 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [crypto chcr 1/2] small packet Tx stalls the queue
Date: Fri, 30 Nov 2018 14:31:48 +0530
Message-Id: <1543568508-23639-1-git-send-email-atul.gupta@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Immediate packets sent to hardware should include the work
request length in calculating the flits. WR occupy one flit and
if not accounted result in invalid request which stalls the HW
queue.

Cc: stable@vger.kernel.org
Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ipsec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 461b97e..1ff8738 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -303,7 +303,10 @@ static bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 
 static inline int is_eth_imm(const struct sk_buff *skb, unsigned int kctx_len)
 {
-	int hdrlen = sizeof(struct chcr_ipsec_req) + kctx_len;
+	int hdrlen;
+
+	hdrlen = sizeof(struct fw_ulptx_wr) +
+		 sizeof(struct chcr_ipsec_req) + kctx_len;
 
 	hdrlen += sizeof(struct cpl_tx_pkt);
 	if (skb->len <= MAX_IMM_TX_PKT_LEN - hdrlen)
-- 
1.8.3.1

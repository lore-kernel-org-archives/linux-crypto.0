Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:38973 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfAQRXh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 12:23:37 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        dt@chelsio.com
Cc: atul.gupta@chelsio.com
Subject: [PATCH 1/2] crypto/chelsio: avoid using sa_entry imm
Date: Thu, 17 Jan 2019 09:18:35 -0800
Message-Id: <20190117171835.6029-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

use is_eth_imm to determine immediate data than use sa_entry
field which is common for tunnel and not per skb.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.h  |  2 +-
 drivers/crypto/chelsio/chcr_ipsec.c | 10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index 1159dee..ad874d5 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -183,7 +183,7 @@ struct chcr_ipsec_aadiv {
 struct ipsec_sa_entry {
 	int hmac_ctrl;
 	u16 esn;
-	u16 imm;
+	u16 resv;
 	unsigned int enckey_len;
 	unsigned int kctx_len;
 	unsigned int authsize;
diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 2fb48cc..4f24646 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -415,12 +415,12 @@ inline void *copy_esn_pktxt(struct sk_buff *skb,
 	iv = skb_transport_header(skb) + sizeof(struct ip_esp_hdr);
 	memcpy(aadiv->iv, iv, 8);
 
-	if (sa_entry->imm) {
+	if (is_eth_imm(skb, sa_entry)) {
 		sc_imm = (struct ulptx_idata *)(pos +
 			  (DIV_ROUND_UP(sizeof(struct chcr_ipsec_aadiv),
 					sizeof(__be64)) << 3));
-		sc_imm->cmd_more = FILL_CMD_MORE(!sa_entry->imm);
-		sc_imm->len = cpu_to_be32(sa_entry->imm);
+		sc_imm->cmd_more = FILL_CMD_MORE(0);
+		sc_imm->len = cpu_to_be32(skb->len);
 	}
 	pos += len;
 	return pos;
@@ -548,10 +548,8 @@ inline void *chcr_crypto_wreq(struct sk_buff *skb,
 	if (sa_entry->esn)
 		ivdrop = 1;
 
-	if (is_eth_imm(skb, sa_entry)) {
+	if (is_eth_imm(skb, sa_entry))
 		immdatalen = skb->len;
-		sa_entry->imm = immdatalen;
-	}
 
 	if (sa_entry->esn)
 		esnlen = sizeof(struct chcr_ipsec_aadiv);
-- 
1.8.3.1

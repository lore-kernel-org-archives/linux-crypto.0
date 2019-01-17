Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:37044 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfAQRUt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 12:20:49 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        dt@chelsio.com
Cc: atul.gupta@chelsio.com
Subject: [PATCH 2/2] crypto/chelsio: Inline single pdu only
Date: Thu, 17 Jan 2019 09:19:19 -0800
Message-Id: <20190117171919.6080-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Inline single pdu else take co-pro path

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ipsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 4f24646..0c826d0 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -303,6 +303,9 @@ static bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 		if (ipv6_ext_hdr(ipv6_hdr(skb)->nexthdr))
 			return false;
 	}
+	/* Inline single pdu */
+	if (skb_shinfo(skb)->gso_size)
+		return false;
 	return true;
 }
 
-- 
1.8.3.1

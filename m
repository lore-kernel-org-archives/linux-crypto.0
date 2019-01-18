Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:12044 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfARE4q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 23:56:46 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com
Cc: atul.gupta@chelsio.com
Subject: [net-next 3/3] cxgb4: TLS record offload enable
Date: Thu, 17 Jan 2019 20:56:39 -0800
Message-Id: <20190118045639.2877-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable Inline TLS record by default

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 6ba9099..73fc247 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5653,7 +5653,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 						   NETIF_F_GSO_UDP_TUNNEL |
 						   NETIF_F_TSO | NETIF_F_TSO6;
 
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
+					       NETIF_F_HW_TLS_RECORD;
 		}
 
 		if (highdma)
-- 
1.8.3.1

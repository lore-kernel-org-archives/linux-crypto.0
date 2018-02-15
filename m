From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [Crypto v5 02/12] ethtool: feature for Inline TLS in HW
Date: Thu, 15 Feb 2018 12:24:44 +0530
Message-ID: <1518677694-28448-3-git-send-email-atul.gupta@chelsio.com>
References: <1518677694-28448-1-git-send-email-atul.gupta@chelsio.com>
Cc: sd@queasysnail.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, ganeshgr@chelsio.com
To: davejwatson@fb.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:65512 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754783AbeBOGzc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 01:55:32 -0500
In-Reply-To: <1518677694-28448-1-git-send-email-atul.gupta@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 include/linux/netdev_features.h | 2 ++
 net/core/ethtool.c              | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index b1b0ca7..e1a33b7 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -77,6 +77,7 @@ enum {
 	NETIF_F_HW_ESP_BIT,		/* Hardware ESP transformation offload */
 	NETIF_F_HW_ESP_TX_CSUM_BIT,	/* ESP with TX checksum offload */
 	NETIF_F_RX_UDP_TUNNEL_PORT_BIT, /* Offload of RX port for UDP tunnels */
+	NETIF_F_HW_TLS_INLINE_BIT,      /* Offload TLS record */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -142,6 +143,7 @@ enum {
 #define NETIF_F_HW_ESP		__NETIF_F(HW_ESP)
 #define NETIF_F_HW_ESP_TX_CSUM	__NETIF_F(HW_ESP_TX_CSUM)
 #define	NETIF_F_RX_UDP_TUNNEL_PORT  __NETIF_F(RX_UDP_TUNNEL_PORT)
+#define NETIF_F_HW_TLS_INLINE   __NETIF_F(HW_TLS_INLINE)
 
 #define for_each_netdev_feature(mask_addr, bit)	\
 	for_each_set_bit(bit, (unsigned long *)mask_addr, NETDEV_FEATURE_COUNT)
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index f8fcf45..cac1c77 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -106,6 +106,7 @@ int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	[NETIF_F_HW_ESP_BIT] =		 "esp-hw-offload",
 	[NETIF_F_HW_ESP_TX_CSUM_BIT] =	 "esp-tx-csum-hw-offload",
 	[NETIF_F_RX_UDP_TUNNEL_PORT_BIT] =	 "rx-udp_tunnel-port-offload",
+	[NETIF_F_HW_TLS_INLINE_BIT] =    "tls-inline",
 };
 
 static const char
-- 
1.8.3.1
